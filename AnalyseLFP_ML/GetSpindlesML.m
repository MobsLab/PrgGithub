%GetSpindlesML.m

function [SpiTot,SpiHigh,SpiLow,SpiULow,channel]=GetSpindlesML(nameStructure,Epoch,SWSEpoch)

% define SD on SWSEpoch only, then detect spindles on whole Epoch
% output:
% SpiTot in s. start/pick/end of spindles
% SpiHigh in s. start/pick/end of spindles
% SpiLow in s. start/pick/end of spindles
% SpiULow in s. start/pick/end of spindles
%
% input:
% nameStructure = 'PFCx_sup'

% see also
% GetRipplesML.m
% GetDeltaML.m

% %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%% inputs and definition
newname=['AllSpindles',nameStructure];
newname(strfind(newname,'_')+1)=upper(newname(strfind(newname,'_')+1));
newname(strfind(newname,'_'))=[];
Spi1=[];
SpiTot=[];
SpiHigh=[];
SpiLow=[];
SpiULow=[];
channel=[];
LFP=[];


disp(['GetSpindlesML for ',nameStructure,'...'])
% %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%% load if exists
try
    if ~exist('Epoch','var') && ~exist('SWSEpoch','var')
        Spi1=load(newname,'SpiHigh','SpiLow','SpiULow','SpiTot');
    else
        Spi1=load(newname,'SpiHigh','SpiLow','SpiULow','SpiTot','Epoch','SWSEpoch');
        if floor(sum(Stop(Epoch,'s')-Start(Epoch,'s')))~=floor(sum(Stop(Spi1.Epoch,'s')-Start(Spi1.Epoch,'s'))), error('Epochs have changed');end
        if floor(sum(Stop(SWSEpoch,'s')-Start(SWSEpoch,'s')))~=floor(sum(Stop(Spi1.SWSEpoch,'s')-Start(Spi1.SWSEpoch,'s'))), error('Epochs have changed');end
    end  
    SpiTot= Spi1.SpiTot;
    SpiHigh= Spi1.SpiHigh;
    SpiLow= Spi1.SpiLow;
    SpiULow= Spi1.SpiULow;
    
catch
    if ~exist('SWSEpoch','var') || ~exist('Epoch','var')
        error('Define Epoch for SD calculation, and Epoch for detection !! ')
    end
    try
        eval(['load(''ChannelsToAnalyse/',nameStructure,'.mat'',''channel'');']);
        if ~isempty(channel),disp('         Calculating !!');end
        
        eval(['load(''LFPData/LFP',num2str(channel),'.mat'',''LFP'');'])
        [SpiTot,SWATot,~,TotEpoch]=FindSpindles(LFP,[2 20],Epoch,SWSEpoch);
        [SpiHigh,SWAHigh,~,HiEpoch]=FindSpindles(LFP,[12 15],Epoch,SWSEpoch);
        [SpiLow,SWALow,~,LowEpoch]=FindSpindles(LFP,[9 12],Epoch,SWSEpoch);
        [SpiULow,SWAULow,~,UlowEpoch]=FindSpindles(LFP,[6 8],Epoch,SWSEpoch);
        
        %-------------------------------------------------
        % saving
        save(newname,'SpiTot','SpiHigh','SpiLow','SpiULow',...
            'SWATot','SWAHigh','SWALow','SWAULow',...
            'TotEpoch','HiEpoch','LowEpoch','UlowEpoch','channel','Epoch','SWSEpoch')
        
    catch
        disp(['  -> No spindles ',nameStructure])
    end
end


%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%% %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

    function [Spi,SWA,stdev,usedEpoch]=FindSpindles(LFP,fre,Epoch,SWS)
        % each row in Spi corresponds to a detected spindles:
        % Spi(i,1:3)=[tStartSpindles, tPeakSpindles, tEndSpindles]
        
        %-------------------------------------------------
        % inputs
        LFP=ResampleTSD(LFP,1250);
        if fre==[2 20]
            thfreq=[1.5 4];
        else
            thfreq=[3 5];
        end
        smo=2;
        stdev=[];
        
        %-------------------------------------------------
        % calculate SD on sws only
        Epoch2=SWS;
        if sum(End(SWS,'s')-Start(SWS,'s'))>12000
            Epoch2=subset(SWS,1:floor(length(Start(SWS))/3));
        end
        signal = Data(Restrict(FilterLFP(LFP,fre,512),Epoch2));
        frequency=round(1/median(diff(Range(LFP,'s'))));
        windowLength = round(frequency/1250*11);
        squaredSignal = signal.^2;
        window = ones(windowLength,1)/windowLength;
        [normalizedSquaredSignal,SDsws] = unity(Filter0(window,sum(squaredSignal,2)),[],[]);
        
        vari=SDsws*2/3;
        
        %-------------------------------------------------
        % compute with filter parameter 512
        Spi=[];SWA=[];
        usedEpoch=Epoch;
        for i=1:length(Start(Epoch))
            try
                Filsp=FilterLFP(Restrict(LFP,subset(Epoch,i)),fre,512);
                rgFilsp=Range(Filsp,'s');
                filtered=[rgFilsp-rgFilsp(1) Data(Filsp)];
                disp(' ');disp(['Epoch ',num2str(i)])
                [ripples,swa,stdev,noise] = FindspindlesMarie(filtered,'durations',[100 350 200000],'stdev',vari,'thresholds',thfreq,'show','off');
                ripples(:,1:3)=ripples(:,1:3)+rgFilsp(1);
                Spi=[Spi;ripples];
                swa=swa+rgFilsp(1);
                SWA=[SWA;swa];
            catch
                usedEpoch=usedEpoch-subset(Epoch,i);
                usedEpoch=CleanUpEpoch(usedEpoch);
            end
        end

        %-------------------------------------------------
        % if bad, recompute with filter parameter 1024
        if length(Spi)<10
            clear Spi ripples
            Spi=[];SWA=[];
            usedEpoch=Epoch;
            for i=1:length(Start(Epoch))
                try
                    Filsp=FilterLFP(Restrict(LFP,subset(Epoch,i)),fre,1024);
                    rgFilsp=Range(Filsp,'s');
                    filtered=[rgFilsp-rgFilsp(1) Data(Filsp)];
                    [ripples,swa, stdev,noise] = FindspindlesMarie(filtered,'durations',[100 350 200000],'thresholds',thfreq,'show','off');
                    ripples(:,1:3)=ripples(:,1:3)+rgFilsp(1);
                    Spi=[Spi;ripples];
                    swa=swa+rgFilsp(1);
                    SWA=[SWA;swa];
                catch
                    usedEpoch=usedEpoch-subset(Epoch,i);
                    usedEpoch=CleanUpEpoch(usedEpoch);
                end
            end
        end
        
        %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
        %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
        function y = Filter0(b,x)
            
            if size(x,1) == 1
                x = x(:);
            end
            
            if mod(length(b),2)~=1
                error('filter order should be odd');
            end
            
            shift = (length(b)-1)/2;
            
            [y0 z] = filter(b,1,x);
            
            y = [y0(shift+1:end,:) ; z(1:shift,:)];
        end
        
        %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
        %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
        function [U,stdA] = unity(A,sd,restrict)
            
            if ~isempty(restrict),
                meanA = mean(A(restrict));
                stdA = std(A(restrict));
            else
                meanA = mean(A);
                stdA = std(A);
            end
            if ~isempty(sd),
                stdA = sd;
            end
            
            U = (A - meanA)/stdA;
        end
        
    end
end
