function [op,NamesOp,Dpfc,Epoch,noise]=FindNREMepochsML

% [op,NamesOp,Dpfc]=FindNREMepochsML(Dirman,SlowEpochType)
%
% inputs:
% SlowEpochType (optional) = option in FindSlowOscBulb.m (default = 11)


%% INITIATION
disp('Running FindNREMepochsML.m')

NamesOp = {'PFsupOsci','PFdeepOsci','BurstDelta','REM','WAKE','SWS','SIEpoch','PFswa','OBswa'};

% <<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<
%% <<<<<<<<<<<<<<<< Find sleepStages from PFCx <<<<<<<<<<<<<<<<
try
    %temp=load('newDeltaPFCx.mat','tDelta'); temp.tDelta;
    % <<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<
    % sleepStages from PFCxDeep
    [dSWS,dREM,dWAKE,dOsciEpoch,noise,SIEpoch,Immob]=FindSleepStageML('PFCx_deep');
    %Epoch=dSWS;
    Epoch=Immob-noise;
    % <<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<
    % sleepStages from PFCxSup
    try
        [sSWS,sREM,sWAKE,sOsciEpoch]=FindSleepStageML('PFCx_sup');
    catch
        [sSWS,sREM,sWAKE,sOsciEpoch]=FindSleepStageML('PFCx_deltasup');
    end
catch
    disp('no delta, run FindDeltaWavesChanGL')
end
% <<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<
%% <<<<<<<<<<< load delta PFCx and find BurstDeltaEpoch <<<<<<<<<<<

disp('... loading AllDeltaPFCx PFCxDeep channel')
if exist('Epoch','var')
    
    [tDelta,DeltaEpoch]=GetDeltaML('PFCx',Epoch,dSWS);
    % tDelta in 1E-4ms, middle of period above 2SD.
    Dpfc=ts(tDelta); 
    if ~isempty(tDelta) 
        disp('           run FindDeltaBurst2.m')
        BurstDeltaEpoch=FindDeltaBurst2(Restrict(Dpfc,Epoch),0.7,0);
    end
end

% <<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<
%% <<<<<<<<<<<< Find strong delta activity in PFCx <<<<<<<<<<<<

if exist('Dpfc','var') && exist('tDelta','var') && ~isempty(tDelta) 
    try
        temp=load('ChannelsToAnalyse/PFCx_deep.mat');
        disp(['... loading PFCx_deep SpectrumDataL/Spectrum',num2str(temp.channel),'.mat'])
        eval(['temp=load(''SpectrumDataL/Spectrum',num2str(temp.channel),'.mat'');'])
        disp('... FindSlowOscBulb.m on PFCxDeep channel')
        
        %[EpochSlowPF,val,val2]=FindSlowOscBulb(Sp,t,f,Epoch,1,[5 6]); % PFCx slow oscill
        %EpochSlowPF=EpochSlowPF{SlowEpochType};
        EpochSlowPF=FindSlowOscML(temp.Sp,temp.t,temp.f); % !!! not restricted to SWS !!!
        disp('Done.');close
    catch
        EpochSlowPF=intervalSet(NaN,NaN);
    end
end


% <<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<
%% <<<<<<<<<<<<<<< Find strong oscillation in OB <<<<<<<<<<<<<<

if exist('Dpfc','var') && ~isempty(tDelta) 
    
    clear channel Sp t f
    try
        temp=load('ChannelsToAnalyse/Bulb_deep.mat');
        disp(['... loading Bulb_deep SpectrumDataL/Spectrum',num2str(temp.channel),'.mat'])
        eval(['temp=load(''SpectrumDataL/Spectrum',num2str(temp.channel),'.mat'');'])
        disp('... FindSlowOscBulb.m on Bulb_deep channel')
        %         [EpochSlowOB,val,val2]=FindSlowOscBulb(Sp,t,f,Epoch,1,[5 6]); % Bulb slow oscill
        %         EpochSlowOB=EpochSlowOB{SlowEpochType};
        EpochSlowOB=FindSlowOscML(temp.Sp,temp.t,temp.f); % !!! not restricted to SWS !!!
        disp('Done.')
    catch
        EpochSlowOB=intervalSet(NaN,NaN);
    end
end



%% TERMINATION

if exist('Dpfc','var') && ~isempty(tDelta) && exist('Epoch','var')
    % <<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<
    try
    % raw epochs
    op{1}=sOsciEpoch; %S34
    op{2}=dOsciEpoch; %S34;
    op{3}=BurstDeltaEpoch; %N3
    op{4}=dREM;
    op{5}=dWAKE;
    op{6}=dSWS;
    op{7}=SIEpoch;% short immobility
    op{8}=EpochSlowPF; %PFCx
    op{9}=EpochSlowOB; %OB
    catch
        keyboard
    end
else
    op={};
end

if ~exist('Epoch','var')
    Epoch=intervalSet([],[]);
end
if ~exist('noise','var')
    noise=intervalSet([],[]);
end
%% FUNCTION FindSlowOscML

    function EpochSlow=FindSlowOscML(Sp,t,f)
        
        % parameters
        plo=1;
        lim1=[2 4]; % band of interest
        lim2=[0.5 1.5]; % lower band
        lim3=[4.5 6]; % upper band
        th=2;
        
        % spectrograms value corresponding to those bands 
        V1=mean(Sp(:,find(f>lim1(1)&f<lim1(2))),2);
        V2=mean(Sp(:,find(f>lim2(1)&f<lim2(2))),2);
        V3=mean(Sp(:,find(f>lim3(1)&f<lim3(2))),2);
        
        % find slow osc epoch
        Vts1=tsd(t*1E4,(V1./V2));
        EpochSlow1=thresholdIntervals(Vts1,1.1,'Direction','Above');
        Vts2=tsd(t*1E4,(V1./V3));
        EpochSlow2=thresholdIntervals(Vts2,th,'Direction','Above');
        
        EpochSlow=and(EpochSlow1,EpochSlow2);
        EpochSlow=mergeCloseIntervals(EpochSlow,1E4);
        EpochSlow=dropShortIntervals(EpochSlow,1E4);
        
        I=intervalSet(t(1)*1E4,t(end)*1E4);
        val=100*sum(Stop(EpochSlow)-Start(EpochSlow))/sum(Stop(I)-Start(I));
        
        % display
        if plo
            Stsd=tsd(t*1E4,Sp);
            figure('Color',[1 1 1]), hold on, 
            subplot(2,1,1), imagesc(t,f,10*log10(Sp)');axis xy, caxis([15 60])
            title(pwd); ylim([0 20]); xlim([min(t),max(t)])
            line([Start(EpochSlow,'s'),Stop(EpochSlow,'s')]',10*ones(2,length(Stop(EpochSlow))),'Color','k')
            subplot(2,1,2), imagesc(t(1:length(Data(Restrict(Stsd,EpochSlow)))),f,10*log10(Data(Restrict(Stsd,EpochSlow)))')
            axis xy, caxis([15 60]); ylim([0 20]); xlim([min(t),max(t)])
            title(sprintf('FindSlowOscML: %1.1f percent of epoch',val))
        end
        disp(sprintf('FindSlowOscML: %1.1f percent of epoch',val))
    end
end

