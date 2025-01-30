%GetRipplesML.m

function [dHPCrip,EpochRip,chHPC]=GetRipplesML(Epoch,SWSEpoch,nameChannelNoise)

% define SD on SWSEpoch only, then detect ripples on whole Epoch
% output:
% dHPCrip in s. start/pick/end of ripples

% see also
% GetSpindlesML.m
% GetDeltaML.m

% %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%% inputs
par=[5,7]; % dafault [2 5] , exigent [5,7]
duration=[30 30 100];
ripFreq=[120 200];
channel=[];
LFP=[];
dHPCrip=[];
EpochRip=[];
temp=[];
temp2=[];
disp('GetRipplesML...')
%
if ~exist('nameChannelNoise','var')
    nameChannelNoise='PFCx_deep';
end


% %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%% load if exists
%-------------------------------------------------
% clean epoch
% for episod shorter than 2s, filterLFP cannot proceed
if ~exist('SWSEpoch','var') && ~exist('Epoch','var')
    try
        load('AllRipplesdHPC25.mat','dHPCrip','EpochRip','chHPC');
    catch
        error('Missing inputs Epoch and SWSEpoch')
    end
else
    SWSEpoch=mergeCloseIntervals(SWSEpoch,10);
    SWSEpoch=dropShortIntervals(SWSEpoch,2*1E4);
    
    Epoch=mergeCloseIntervals(Epoch,10);
    Epoch=dropShortIntervals(Epoch,2*1E4);
    
    try
        temp=load('AllRipplesdHPC25.mat','dHPCrip','EpochRip','chHPC','chNoise','SWSEpoch','Epoch');
        dHPCrip=temp.dHPCrip;
        chNoise=temp.chNoise;
        
        if floor(sum(Stop(Epoch,'s')-Start(Epoch,'s')))~=floor(sum(Stop(temp.Epoch,'s')-Start(temp.Epoch,'s'))), error('Epochs have changed');end
        if floor(sum(Stop(SWSEpoch,'s')-Start(SWSEpoch,'s')))~=floor(sum(Stop(temp.SWSEpoch,'s')-Start(temp.SWSEpoch,'s'))), error('Epochs have changed');end
        
    catch
        
        %-------------------------------------------------
        dHPCrip=[];
        disp('Computing AllRipplesdHPC25.mat');
        %-------------------------------------------------
        % load LFP dHPC ripples
        try
            load('ChannelsToAnalyse/dHPC_rip.mat');
            chHPC=channel;
        catch
            try
                load('RipplesdHPC25.mat','chHPC');
                chHPC;
            catch
                disp('!! make sure this is the good ripples channel and put it in ChannelsToAnalyse/dHPC_rip !')
                load('ChannelsToAnalyse/dHPC_deep.mat');
                chHPC=channel;
            end
        end
        if ~isempty(chHPC)
            eval(['load(''LFPData/LFP',num2str(chHPC),'.mat'',''LFP'');'])
            %-------------------------------------------------
            % load LFP PFCdeep to control noise
            try
                temp=load(['ChannelsToAnalyse/',nameChannelNoise,'.mat']);
                eval(['temp2=load(''LFPData/LFP',num2str(temp.channel),'.mat'',''LFP'');'])
                noiseLFP=temp2.LFP;
                chNoise=temp.channel;
            catch
                noiseLFP=tsd([],[]);
                chNoise=[];
            end
            
            %-------------------------------------------------
            % Determine SD on sws signal
            Epoch2=SWSEpoch;
            if sum(End(SWSEpoch,'s')-Start(SWSEpoch,'s'))>12000
                Epoch2=subset(SWSEpoch,1:floor(length(Start(SWSEpoch))/3));
            end
            signal=Data(Restrict(FilterLFP(LFP,ripFreq,1024),Epoch2));
            frequency=round(1/median(diff(Range(LFP,'s'))));
            windowLength = round(frequency/1250*11);
            squaredSignal = signal.^2;
            window = ones(windowLength,1)/windowLength;
            [normalizedSquaredSignal,SDsws] = unity(Filter0(window,sum(squaredSignal,2)),[],[]);
            
            %-------------------------------------------------
            % FindRipplesKarimSB
            EpochRip=Epoch;
            for i=1:length(Start(Epoch))
                try
                    Filsp=FilterLFP(Restrict(LFP,subset(Epoch,i)),ripFreq,1024);
                    rgFilsp=Range(Filsp,'s');
                    filtered=[rgFilsp-rgFilsp(1) Data(Filsp)];
                    %noise
                    Filnoise=FilterLFP(Restrict(noiseLFP,subset(Epoch,i)),ripFreq,1024);
                    FilNOISE=[rgFilsp-rgFilsp(1) Data(Filnoise)];
                    [ripples,stdev,noise] = FindRipples(filtered,'thresholds',par,'durations',duration,'stdev',SDsws*2/3,'noise',FilNOISE);
                    ripples(:,1:3)=ripples(:,1:3)+rgFilsp(1);
                    dHPCrip=[dHPCrip;ripples];
                catch
                    EpochRip=EpochRip-subset(Epoch,i);
                    EpochRip=CleanUpEpoch(EpochRip);
                end
            end
            
            %-------------------------------------------------
            % saving
            disp('Saving in AllRipplesdHPC25.mat')
            save('AllRipplesdHPC25.mat','dHPCrip','EpochRip','chHPC','SDsws','SWSEpoch','Epoch','chNoise');
        end
        disp('Done.')
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
