% GetEvolutionAcrossZT.m
%
% list of related scripts in NREMstages_scripts.m
function [MatZT1,MatZT2,DurEpZT,NewtsdZT,timeZT]=GetEvolutionAcrossZT(Valtsd,Epochs,NewtsdZT,plo,timeZT,Windo)

%[MatZT1,MatZT2,DurEpZT,NewtsdZT,timeZT]=GetEvolutionAcrossZT(Valtsd,Epochs,NewtsdZT,plo,timeZT,Windo)
% Spikes :
% load('SpikeData.mat','S')
%[~,MatZT2,DurEpZT]=GetEvolutionAcrossZT(S,{WAKE,REM,N1,N2,N3},NewtsdZT,0,9:18,2); 
% Spectrum;
% load('Spectrum46.mat','t','f','Sp');
% Sptsd = tsd(t*1E4,10*log10(mean(Sp(:,find(f<4 & f>1.5)),2)));
%[MatZT1,~,DurEpZT]=GetEvolutionAcrossZT(Sptsd,{WAKE,REM,N1,N2,N3},NewtsdZT,1);

% inputs :
% Valtsd = tsd array, each cell must be a tsd tps-by-1 !!
% Epochs (optional) = array with all epochs, e.g {WAKE,REM,N1,N2,N3} 
% NewtsdZT (optional) = see GetZT_ML.m
% plo (optional) = 1 to plot evolution across ZT for each cell of Valtsd, default 0
% timeZT (optional) = steps of evolution across ZT in hours, default timeZT=[9:0.5:18];
% Windo (optional) = minimu time to be computed ex: %min 2sec episod
%
% outputs :
% MatZT = array of epochs x steps matrice of mean Valtsd
% DurEpZT = epochs x steps matrice of epoch duration
% NewtsdZT
% timeZT


% %%%%%%%%%%%%%%%%%%%%%% INPUTS %%%%%%%%%%%%%%%%%%%%%%%%%%%
if ~exist('NewtsdZT','var')
    disp('... loading rec time with GetZT_ML.m')
    NewtsdZT=GetZT_ML(pwd);
end

if ~exist('Epochs','var')
    Epochs{1}=intervalSet(min(Range(Valtsd),max(Range(Valtsd))));
end

if ~exist('plo','var')
    plo=0;
end

if ~exist('timeZT','var')
    timeZT=[9:0.5:18]; % hours  
end

if ~exist('Windo','var')
    Windo=2; %min 2sec episod
end

try
    Valtsd{1}; 
catch
    Valtsd=tsdArray(Valtsd);
end


% %%%%%%%%%%%%%%%%%%%%%% INITIATE %%%%%%%%%%%%%%%%%%%%%%%%%%%
DurEpZT=nan(length(Epochs),length(timeZT)-1);
rgZT=Range(NewtsdZT);
MatZT1={};
MatZT2={};
h=waitbar(0,'GetEvolutionAcrossZT... WAIT');

% %%%%%%%%%%%%%%%%%%%%%% COMPUTE %%%%%%%%%%%%%%%%%%%%%%%%%%%
% val over time
for mm=1:length(Valtsd)
    temp1=nan(length(Epochs),length(timeZT)-1);
    temp2=nan(length(Epochs),length(timeZT)-1);
    for n=1:length(Epochs)
        % -----------------------------------------------------
        % get epoch big enough
        clear epoch
        epoch=Epochs{n};
        
        % -----------------------------------------------------
        % get var on each steps of time
        for su=1:length(timeZT)-1
            st1=rgZT(min((find(Data(NewtsdZT)-timeZT(su)*3600*1E4>0))));
            st2=rgZT(min((find(Data(NewtsdZT)-timeZT(su+1)*3600*1E4>0))));
            if ~isempty(st1) && isempty(st2),st2=max(rgZT);end
            
            epochZT=and(epoch,intervalSet(st1,st2));
            dEZT=sum(Stop(epochZT,'s')-Start(epochZT,'s'));
            DurEpZT(n,su)=dEZT;
            
            if dEZT>Windo
                % var
                temp1(n,su)=mean(Data(Restrict(Valtsd{mm},epochZT)));
                temp2(n,su)=length(Range(Restrict(Valtsd{mm},epochZT)))/dEZT;
            end
        end
        waitbar((length(Epochs)*(mm-1)+n)/(length(Valtsd)*length(Epochs)));
    end
    MatZT1{mm}=temp1;
    MatZT2{mm}=temp2;
end
close(h)

%% %%%%%%%%%%%%%%%%%%%%%% DISPLAY %%%%%%%%%%%%%%%%%%%%%%%%%%%
if plo
    figure('Color',[1 1 1],'Unit','Normalized','Position',[0.1 0.1 min(1,0.15*length(Epochs)) 0.6])
    for n=1:length(Epochs)
        subplot(3,length(Epochs),n), hold on,
        for mm=1:min(length(Valtsd),10)
            plot(timeZT(2:end),DurEpZT(n,:)/60,'.-')
        end
        xlim([timeZT(1),timeZT(end)+0.5]);ylim([min(min(DurEpZT/60)),max(max(DurEpZT/60))])
        title(sprintf('Epoch #%d',n)); if n==1, ylabel('duration (min)');end
        
        subplot(3,length(Epochs),length(Epochs)+n), hold on,
        for mm=1:min(length(Valtsd),10)
            plot(timeZT(2:end),MatZT1{mm}(n,:),'.-')
        end
        xlim([timeZT(1),timeZT(end)+0.5]);ylim([min(min(MatZT1{mm})),max(max(MatZT1{mm}))])
        if n==1, ylabel('averaged value');end
        
        subplot(3,length(Epochs),2*length(Epochs)+n), hold on,
        for mm=1:length(Valtsd)
            plot(timeZT(2:end),MatZT2{mm}(n,:),'.-')
        end
        xlim([timeZT(1),timeZT(end)+0.5]);ylim([min(min(MatZT2{mm})),max(max(MatZT2{mm}))])
        xlabel('Time (h)'); if n==1, ylabel('Occurance/FR (Hz)');end
    end
end





