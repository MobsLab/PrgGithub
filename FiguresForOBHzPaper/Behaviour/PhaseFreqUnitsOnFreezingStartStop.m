clear all,% close all
%% INITIATION
FreqRange=[3,6];
[params,movingwin,suffix]=SpectrumParametersML('low');
tps=[0.05:0.05:1];
timeatTransition=4;
timebefprop=0.3;
timebefxpos=timebefprop./(1+timebefprop*2);

%% DATA LOCALISATION
[Dir,KeepFirstSessionOnly]=GetRightSessionsFor4HzPaper('CtrlAllDataSpikes');
SaveFolder='/media/DataMOBsRAIDN/ProjetAversion/AnalysisStartStopFreezing_LinkWith4Hz/';
StrucNames= {'HPCVars','OBVars'};


for m=1:length(KeepFirstSessionOnly)
    
    %% Go to file location
    mm=KeepFirstSessionOnly(m);
    disp(Dir.path{mm})
    cd(Dir.path{mm})
    clear Spec FreqBand NewMat TotalNoiseEpoch NoFreezeEpoch FreezeEpoch FreezeAccEpoch FreqBand
    clear Movtsd MovAcctsd
    
    %% load data
    % Epochs
    load('behavResources.mat')
    load('StateEpochSB.mat')
    if exist('FreezeAccEpoch')
        FreezeEpoch=FreezeAccEpoch;
    end
    TotEpoch=intervalSet(0,max(Range(Movtsd)));
    FreezeEpoch=and(FreezeEpoch,TotEpoch);
    NoFreezeEpoch = TotEpoch-FreezeEpoch;
    NoFreezeEpoch = NoFreezeEpoch-TotalNoiseEpoch;
    
    FreezeEpoch=dropShortIntervals(FreezeEpoch,4*1e4);
    FreezeEpochBis=FreezeEpoch;
    for fr_ep=1:length(Start(FreezeEpoch))
        LitEp=subset(FreezeEpoch,fr_ep);
        NotLitEp=FreezeEpoch-LitEp;
        StopEp=intervalSet(Stop(LitEp)-4*1e4,Stop(LitEp)+4*1e4);
        if not(isempty(Data(Restrict(Movtsd,and(NotLitEp,StopEp)))))
            FreezeEpochBis=FreezeEpochBis-LitEp;
        end
    end
    FreezeEpoch=CleanUpEpoch(FreezeEpochBis);
    
    % OB and HPC Spectra
    load(['B_Low_Spectrum.mat'])
    Sptsd_B=tsd(Spectro{2}*1e4,Spectro{1});
    load(['H_Low_Spectrum.mat'])
    Sptsd_H=tsd(Spectro{2}*1e4,Spectro{1});
    
    % Spikes
    load('SpikeData.mat')
    load LFPData/InfoLFP.mat
    chans=InfoLFP.channel(strcmp(InfoLFP.structure,'PFCx'));
    numtt=[]; % nb tetrodes ou montrodes du PFCx

    for cc=1:length(chans)
        for tt=1:length(tetrodeChannels) % tetrodeChannels= tetrodes ou montrodes (toutes)
            if ~isempty(find(tetrodeChannels{tt}==chans(cc)))
                numtt=[numtt,tt];
            end
        end
    end
    
    numNeurons=[]; % neurones du PFCx
    for i=1:length(S);
        if ismember(TT{i}(1),numtt)
            numNeurons=[numNeurons,i];
        end
    end
    
    numMUA=[];
    for k=1:length(numNeurons)
        j=numNeurons(k);
        if TT{j}(2)==1
            numMUA=[numMUA, k];
        end
    end
    numNeurons(numMUA)=[];
    
    load('MeanWaveform.mat')
    
    % Spike modulation by LFP
    SpikeMod.HPCVars=load('NeuronLFPCoupling/FzNeuronModFreqSpecificBandCorrected_HPC1.mat');
    SpikeMod.OBVars=load('NeuronLFPCoupling/FzNeuronModFreqSpecificBandCorrected_OB1.mat');
    
    for sp=1:length(numNeurons)
        SpikeInfo.WF{m}(sp,:)=W{sp}(BestElec{sp},:);
        SpikeInfo.FR{m}(sp,:)=Params{sp}(1);
        Dur_Fz=sum(Stop(FreezeEpoch,'s')-Start(FreezeEpoch,'s'));
        FR_Fz = length(Range(Restrict(S{numNeurons(sp)},FreezeEpoch)))/Dur_Fz;
        Dur_NoFz=sum(Stop(NoFreezeEpoch,'s')-Start(NoFreezeEpoch,'s'));
        FR_NoFz = length(Range(Restrict(S{numNeurons(sp)},NoFreezeEpoch)))/Dur_NoFz;
        
        Weight_Fz_NoFz{m}(sp) = FR_Fz-FR_NoFz;

        for s=1:length(StrucNames)
            SpikeInfo.(StrucNames{s}).pval{m}(sp)=SpikeMod.(StrucNames{s}).pval{sp}.Transf;
            SpikeInfo.(StrucNames{s}).Kappa{m}(sp)=SpikeMod.(StrucNames{s}).Kappa{sp}.Transf;
            SpikeInfo.(StrucNames{s}).PhaseMu{m}(sp,:)=SpikeMod.(StrucNames{s}).mu{sp}.Transf;
            [Y,X]=hist(mod(SpikeMod.(StrucNames{s}).PhasesSpikes{sp}.Transf,2*pi),30);
            SpikeInfo.(StrucNames{s}).Mod{m}(sp,:)=Y;
            SpikeInfo.(StrucNames{s}).Params{m}(sp,:)=Params{numNeurons(sp)};
            [mutest, ~, ~, Rmean, ~, ~,~,~] = CircularMean((SpikeMod.(StrucNames{s}).PhasesSpikes{sp}.Transf));
            SpikeInfo.(StrucNames{s}).Z{m}(sp)=length((SpikeMod.(StrucNames{s}).PhasesSpikes{sp}.Transf)) * Rmean^2; % R^2/N
        end
    end
    
    
    for ep=1:length(Start(FreezeEpoch))-1
        ActualEpoch=subset(FreezeEpoch,ep);
        Dur{m}(ep)=Stop(ActualEpoch,'s')-Start(ActualEpoch,'s');
        
        for sp=1:length(numNeurons)
            OverallFR{m}(ep,sp) = length(Range(Restrict(S{numNeurons(sp)},ActualEpoch)))/ Dur{m}(ep);
        end

        %% Look at Normalized periods
        % define epoch
        timebef=Dur{m}(ep)*timebefprop; % period before and after is 30% acutal period
        LittleEpoch=intervalSet(Start(ActualEpoch)-timebef*1e4,Stop(ActualEpoch)+timebef*1e4);
        
        % spectra + power
        % OB
        Spec=Data(Restrict(Sptsd_B,(LittleEpoch)));
        FreqBand=nanmean(Spec(:,find(Spectro{3}<FreqRange(1),1,'last'):find(Spectro{3}<FreqRange(2),1,'last'))');
        % interpolate
        FreqBandPower_AllMice_normPer_B{m}(ep,:)=interp1([1/length(FreqBand):1/length(FreqBand):1],FreqBand,tps); hold on
        for sp=1:length(Spectro{3})
            Spectro_AllMice_normPer_B{m}(ep,sp,:)=interp1([1/length(FreqBand):1/length(FreqBand):1],Spec(:,sp),tps); hold on
        end
        % HPC
        Spec=Data(Restrict(Sptsd_H,(LittleEpoch)));
        FreqBand=nanmean(Spec(:,find(Spectro{3}<FreqRange(1),1,'last'):find(Spectro{3}<FreqRange(2),1,'last'))');
        % interpolate
        FreqBandPower_AllMice_normPer_H{m}(ep,:)=interp1([1/length(FreqBand):1/length(FreqBand):1],FreqBand,tps); hold on
        for sp=1:length(Spectro{3})
            Spectro_AllMice_normPer_H{m}(ep,sp,:)=interp1([1/length(FreqBand):1/length(FreqBand):1],Spec(:,sp),tps); hold on
        end
        
        % Movement
        Mov=Data(Restrict(Movtsd,LittleEpoch));
        InstSpeed_AllMice_normPer{m}(ep,:)=interp1([1/length(Mov):1/length(Mov):1],Mov,tps); hold on
        if exist('MovAcctsd')
            MovAcc=Data(Restrict(MovAcctsd,(LittleEpoch)));
            InstAcc_AllMice_normPer{m}(ep,:)=interp1([1/length(MovAcc):1/length(MovAcc):1],MovAcc,tps); hold on
            MovAcc=Data(Restrict(MovAccSmotsd,(LittleEpoch)));
            InstAccSmoo_AllMice_normPer{m}(ep,:)=interp1([1/length(MovAcc):1/length(MovAcc):1],MovAcc,tps); hold on
        end
        
        % Neuron firing
        for sp=1:length(numNeurons)
            NeurFiring = hist(Range(S{numNeurons(sp)},'s'),[0.1:0.1:max(Range(Sptsd_H,'s'))])';
            S_temp = tsd([0.1:0.1:max(Range(Sptsd_H,'s'))]*1e4,NeurFiring);
            Sp_temp=Data(Restrict(S_temp,LittleEpoch));
            PFCFiring_AllMice_normPer{m}(ep,sp,:)=interp1([1/length(Sp_temp):1/length(Sp_temp):1],Sp_temp,tps); hold on
        end
        
        %% Look at onset periods
        % define epoch
        LittleEpoch=intervalSet(Start(ActualEpoch)-timeatTransition*1e4,Start(ActualEpoch)+timeatTransition*1e4);
        
        % spectra + power
        Spec=Data(Restrict(Sptsd_B,LittleEpoch));
        FreqBand=nanmean(Spec(:,find(Spectro{3}<FreqRange(1),1,'last'):find(Spectro{3}<FreqRange(2),1,'last'))');
        % interpolate
        FreqBandPower_AllMice_Onset_B{m}(ep,:)=interp1([1/length(FreqBand):1/length(FreqBand):1],FreqBand,tps); hold on
        for sp=1:length(Spectro{3})
            Spectro_AllMice_Onset_B{m}(ep,sp,:)=interp1([1/length(FreqBand):1/length(FreqBand):1],Spec(:,sp),tps); hold on
        end
        Spec=Data(Restrict(Sptsd_H,LittleEpoch));
        FreqBand=nanmean(Spec(:,find(Spectro{3}<FreqRange(1),1,'last'):find(Spectro{3}<FreqRange(2),1,'last'))');
        % interpolate
        FreqBandPower_AllMice_Onset_H{m}(ep,:)=interp1([1/length(FreqBand):1/length(FreqBand):1],FreqBand,tps); hold on
        for sp=1:length(Spectro{3})
            Spectro_AllMice_Onset_H{m}(ep,sp,:)=interp1([1/length(FreqBand):1/length(FreqBand):1],Spec(:,sp),tps); hold on
        end
        
        % Movement
        Mov=Data(Restrict(Movtsd,(LittleEpoch)));
        InstSpeed_AllMice_Onset{m}(ep,:)=interp1([1/length(Mov):1/length(Mov):1],Mov,tps); hold on
        if exist('MovAcctsd')
            MovAcc=Data(Restrict(MovAcctsd,(LittleEpoch)));
            InstAcc_AllMice_Onset{m}(ep,:)=interp1([1/length(MovAcc):1/length(MovAcc):1],MovAcc,tps); hold on
            MovAcc=Data(Restrict(MovAccSmotsd,(LittleEpoch)));
            InstAccSmoo_AllMice_Onset{m}(ep,:)=interp1([1/length(MovAcc):1/length(MovAcc):1],MovAcc,tps); hold on
            
        end
                      

        % Neuron firing
        for sp=1:length(numNeurons)
            NeurFiring = hist(Range(S{numNeurons(sp)},'s'),[0.1:0.1:max(Range(Sptsd_H,'s'))])';
            S_temp = tsd([0.1:0.1:max(Range(Sptsd_H,'s'))]*1e4,NeurFiring);
            Sp_temp=Data(Restrict(S_temp,LittleEpoch));
            PFCFiring_AllMice_Onset{m}(ep,sp,:)=interp1([1/length(Sp_temp):1/length(Sp_temp):1],Sp_temp,tps); hold on
        end

        %% Look at offset periods
        % define epoch
        LittleEpoch=intervalSet(Stop(ActualEpoch)-timeatTransition*1e4,Stop(ActualEpoch)+timeatTransition*1e4);
        % spectra + power
        Spec=Data(Restrict(Sptsd_B,(LittleEpoch)));
        FreqBand=nanmean(Spec(:,find(Spectro{3}<FreqRange(1),1,'last'):find(Spectro{3}<FreqRange(2),1,'last'))');
        % interpolate
        FreqBandPower_AllMice_Offset_B{m}(ep,:)=interp1([1/length(FreqBand):1/length(FreqBand):1],FreqBand,tps); hold on
        for sp=1:length(Spectro{3})
            Spectro_AllMice_Offset_B{m}(ep,sp,:)=interp1([1/length(FreqBand):1/length(FreqBand):1],Spec(:,sp),tps); hold on
        end
        Spec=Data(Restrict(Sptsd_H,(LittleEpoch)));
        FreqBand=nanmean(Spec(:,find(Spectro{3}<FreqRange(1),1,'last'):find(Spectro{3}<FreqRange(2),1,'last'))');
        % interpolate
        FreqBandPower_AllMice_Offset_H{m}(ep,:)=interp1([1/length(FreqBand):1/length(FreqBand):1],FreqBand,tps); hold on
        for sp=1:length(Spectro{3})
            Spectro_AllMice_Offset_H{m}(ep,sp,:)=interp1([1/length(FreqBand):1/length(FreqBand):1],Spec(:,sp),tps); hold on
        end
        
        % Movement
        Mov=Data(Restrict(Movtsd,(LittleEpoch)));
        InstSpeed_AllMice_Offset{m}(ep,:)=interp1([1/length(Mov):1/length(Mov):1],Mov,tps); hold on
        if exist('MovAcctsd')
            MovAcc=Data(Restrict(MovAcctsd,(LittleEpoch)));
            InstAcc_AllMice_Offset{m}(ep,:)=interp1([1/length(MovAcc):1/length(MovAcc):1],MovAcc,tps); hold on
            MovAcc=Data(Restrict(MovAccSmotsd,(LittleEpoch)));
            InstAccSmoo_AllMice_Offset{m}(ep,:)=interp1([1/length(MovAcc):1/length(MovAcc):1],MovAcc,tps); hold on
        end
        
        % Neuron firing
        for sp=1:length(numNeurons)
            NeurFiring = hist(Range(S{numNeurons(sp)},'s'),[0.1:0.1:max(Range(Sptsd_H,'s'))])';
            S_temp = tsd([0.1:0.1:max(Range(Sptsd_H,'s'))]*1e4,NeurFiring);
            Sp_temp=Data(Restrict(S_temp,LittleEpoch));
            PFCFiring_AllMice_Offset{m}(ep,sp,:)=interp1([1/length(Sp_temp):1/length(Sp_temp):1],Sp_temp,tps); hold on
        end
        
    end
end
cd /media/DataMOBsRAIDN/ProjetAversion/AnalysisStartStopFreezing_LinkWith4Hz
 save('OnsetOffSetGeneral.mat','SpikeInfo','PFCFiring_AllMice_Onset','InstAccSmoo_AllMice_Onset','InstAcc_AllMice_Onset','Spectro_AllMice_Onset_H','FreqBandPower_AllMice_Onset_H',...
    'Spectro_AllMice_Onset_B', 'FreqBandPower_AllMice_Onset_B', 'PFCFiring_AllMice_Onset',...
'PFCFiring_AllMice_Offset','InstAccSmoo_AllMice_Offset','InstAcc_AllMice_Offset','Spectro_AllMice_Offset_H','FreqBandPower_AllMice_Offset_H',...
    'Spectro_AllMice_Offset_B', 'FreqBandPower_AllMice_Offset_B', 'PFCFiring_AllMice_Onset',...
'OverallFR','Dur','FreqBandPower_AllMice_normPer_B','Spectro_AllMice_normPer_B','FreqBandPower_AllMice_normPer_H','Spectro_AllMice_normPer_H',...
    'InstAccSmoo_AllMice_normPer','PFCFiring_AllMice_normPer','Weight_Fz_NoFz');

%% Spectrogram figures
figure
AllSpec=zeros(263,20);
clear AllPow
for m=1:length(KeepFirstSessionOnly)
    dattemp=squeeze(nanmean(Spectro_AllMice_normPer_B{m},1));
    dattemp=dattemp./norm(dattemp(:));
    AllSpec=AllSpec+dattemp;
    AllPow(m,:)=nanmean(FreqBandPower_AllMice_normPer_B{m});
end
tpsrealigned=tps*(1+(timebefprop*2))-timebefprop;
subplot(3,1,1:2)
imagesc(tpsrealigned,Spectro{3},(AllSpec)), axis xy
line([0 0],ylim,'color','k','linewidth',3)
line([1 1],ylim,'color','k','linewidth',3)
subplot(3,1,3)
plot(tpsrealigned,zscore(AllPow'),'color','k'), hold on
plot(tpsrealigned,mean(zscore(AllPow')'),'color','k','linewidth',3)
line([0 0],ylim,'color','k','linewidth',3)
line([1 1],ylim,'color','k','linewidth',3)
xlim([min(tpsrealigned) max(tpsrealigned)])
ylim([-3 3])
box off

%%
figure
AllSpec=zeros(263,20);
clear AllPow
for m=1:length(KeepFirstSessionOnly)
    dattemp=squeeze(nanmean(Spectro_AllMice_normPer_H{m},1));
    dattemp=dattemp./norm(dattemp(:));
    AllSpec=AllSpec+dattemp;
    AllPow(m,:)=nanmean(FreqBandPower_AllMice_normPer_H{m});
end
tpsrealigned=tps*(1+(timebefprop*2))-timebefprop;
subplot(3,1,1:2)
imagesc(tpsrealigned,Spectro{3},(AllSpec)), axis xy
line([0 0],ylim,'color','k','linewidth',3)
line([1 1],ylim,'color','k','linewidth',3)
clim([0.02 0.29])
subplot(3,1,3)
plot(tpsrealigned,zscore(AllPow'),'color','k'), hold on
plot(tpsrealigned,mean(zscore(AllPow')'),'color','k','linewidth',3)
line([0 0],ylim,'color','k','linewidth',3)
line([1 1],ylim,'color','k','linewidth',3)
xlim([min(tpsrealigned) max(tpsrealigned)])
ylim([-3 3])
box off




%% Single unit firing
AllOff=[];AllOn=[];
for mm=1:length(Weight_Fz_NoFz)
    for sp = 1:size(PFCFiring_AllMice_Offset{mm},2)
        temp = squeeze(mean(PFCFiring_AllMice_Offset{mm}(:,sp,:),1));
        Weight_temp = (nanmean(temp(1:9))-nanmean(temp(11:20)))./(nanmean(temp(11:20))+nanmean(temp(1:9)));
        AllOff = [AllOff,squeeze(mean(PFCFiring_AllMice_normPer{mm}(Dur{mm}<10,sp,:),1)).*Weight_Fz_NoFz{mm}(sp)];
        
        temp = squeeze(mean(PFCFiring_AllMice_Onset{mm}(:,sp,:),1));
        Weight_temp = (nanmean(temp(11:20))-nanmean(temp(1:9)))./(nanmean(temp(11:20))+nanmean(temp(1:9)));
        AllOn = [AllOn,squeeze(mean(PFCFiring_AllMice_normPer{mm}(Dur{mm}>10,sp,:),1)).*Weight_Fz_NoFz{mm}(sp)];
    end
end


figure
plot(tpsrealigned,(nanmean(AllOn')),':','color','k','linewidth',4), hold on
plot(tpsrealigned,(nanmean(fliplr(AllOff'))),'color',[0.9 0.4 0.4],'linewidth',4), hold on
line([0 0],ylim)
box off


figure
Dat=[];
for mm=1:length(PFCFiring_AllMice_Offset)
    Dat = [Dat;[nanmean(OverallFR{mm}')'-nanmean(SpikeInfo.FR{mm}),Dur{mm}(:)]];
    Dat = [nanmean(OverallFR{mm}')'-nanmean(SpikeInfo.FR{mm}),Dur{mm}(:)];
    plot(Dat(:,2),Dat(:,1),'*')
    [R,P] = corrcoef(Dat(:,2),Dat(:,1));
    Rall(mm)=R(1,2);
    Pall(mm)=P(1,2);
    hold on
end

figure
subplot(121)
Dat=[];
for mm=1:length(PFCFiring_AllMice_Offset)
    X = nanmean(nanmean(PFCFiring_AllMice_Onset{mm}(:,:,1:9),3)')'-nanmean(nanmean(PFCFiring_AllMice_Onset{mm}(:,:,11:end),3)')';
    Y = nanmean(nanmean(PFCFiring_AllMice_Onset{mm}(:,:,1:9),3)')'+nanmean(nanmean(PFCFiring_AllMice_Onset{mm}(:,:,11:end),3)')';
    Dat = [Dat;[X./Y,Dur{mm}(:)]];
    %     Rall(mm)=R(1,2);
    %     Pall(mm)=P(1,2);
end
Dat(Dat(:,2)>25,:) =[];
plot(Dat(:,2),Dat(:,1),'*')
[R,P] = corrcoef(Dat(:,2),Dat(:,1));
title(num2str(R(1,2)))
ylim([-1 1])
subplot(122)
Dat=[];
for mm=1:length(PFCFiring_AllMice_Offset)
    X = -(nanmean(nanmean(PFCFiring_AllMice_Offset{mm}(:,:,1:9),3)')'-nanmean(nanmean(PFCFiring_AllMice_Offset{mm}(:,:,11:end),3)')');
    Y = nanmean(nanmean(PFCFiring_AllMice_Offset{mm}(:,:,1:9),3)')'+nanmean(nanmean(PFCFiring_AllMice_Offset{mm}(:,:,11:end),3)')';
    Dat = [Dat;[X./Y,Dur{mm}(:)]];
    %     Rall(mm)=R(1,2);
    %     Pall(mm)=P(1,2);
end
Dat(Dat(:,2)>25,:) =[];
plot(Dat(:,2),Dat(:,1),'*')
[R,P] = corrcoef(Dat(:,2),Dat(:,1));
title(num2str(R(1,2)))
ylim([-1 1])

figure
Step = 5;
StepsToTake1 = [0:Step:20];
StepsToTake2 = [Step:Step:25];
cols = summer(length(StepsToTake1));
clear OnsetAv OffSetAv
for Lim = 1:length(StepsToTake1)
    
AllNeurResp_Offset=[];
AllNeurResp_Onset=[];
AllNeurResp_Norm=[];
AllKappa = [];
AllP = [];
for mm=1:length(PFCFiring_AllMice_Offset)
    for sp = 1:size(PFCFiring_AllMice_Offset{mm},2)
        AllNeurResp_Offset=[AllNeurResp_Offset,squeeze(nanmean(PFCFiring_AllMice_Offset{mm}(Dur{mm}>StepsToTake1(Lim) & Dur{mm}<StepsToTake2(Lim),sp,:),1))];
        AllNeurResp_Onset=[AllNeurResp_Onset,squeeze(nanmean(PFCFiring_AllMice_Onset{mm}(Dur{mm}>StepsToTake1(Lim) & Dur{mm}<StepsToTake2(Lim),sp,:),1))];
        AllNeurResp_Norm=[AllNeurResp_Norm,squeeze(nanmean(PFCFiring_AllMice_normPer{mm}(Dur{mm}>StepsToTake1(Lim) & Dur{mm}<StepsToTake2(Lim),sp,:),1))];
        
    end
    
    AllKappa = [AllKappa,SpikeInfo.OBVars.Kappa{mm}];
    AllP = [AllP,SpikeInfo.OBVars.pval{mm}];
    
end
subplot(131)
plot(nanmean((AllNeurResp_Offset(:,AllP<0.05))')','linewidth',3,'color',cols(Lim,:)), hold on,ylim([0.4 1.4])
OffSetAv(Lim,1) = nanmean(nanmean((AllNeurResp_Offset(1:9,AllP<0.05))')');
OffSetAv(Lim,2) = nanmean(nanmean((AllNeurResp_Offset(11:end,AllP<0.05))')');
subplot(132)
plot(nanmean((AllNeurResp_Onset(:,AllP<0.05))')','linewidth',3,'color',cols(Lim,:)), hold on,ylim([0.4 1.4])
OnsetAv(Lim,1) = nanmean(nanmean((AllNeurResp_Onset(1:9,AllP<0.05))')');
OnsetAv(Lim,2) = nanmean(nanmean((AllNeurResp_Onset(11:end,AllP<0.05))')');
subplot(133)
plot(nanmean((AllNeurResp_Norm(:,AllP<0.05))')','linewidth',3,'color',cols(Lim,:)), hold on, ylim([0.4 1.4])
end

figure
subplot(211)
plot(StepsToTake1, OnsetAv)
subplot(212)
plot(StepsToTake1, OffSetAv)

figure
AllNeurResp_Offset=[];
AllNeurResp_Onset=[];
AllNeurResp_Norm=[];
AllKappa = [];
AllP = [];
for mm=1:length(PFCFiring_AllMice_Offset)
    for sp = 1:size(PFCFiring_AllMice_Offset{mm},2)
        AllNeurResp_Offset=[AllNeurResp_Offset,squeeze(nanmean(PFCFiring_AllMice_Offset{mm}(:,sp,:),1))];
        AllNeurResp_Onset=[AllNeurResp_Onset,squeeze(nanmean(PFCFiring_AllMice_Onset{mm}(:,sp,:),1))];
        AllNeurResp_Norm=[AllNeurResp_Norm,squeeze(nanmean(PFCFiring_AllMice_normPer{mm}(:,sp,:),1))];
        
    
    AllKappa = [AllKappa,SpikeInfo.OBVars.Kappa{mm}];
    AllP = [AllP,SpikeInfo.OBVars.pval{mm}];
    end
end

subplot(131)
plot(nanmean((AllNeurResp_Offset)')','linewidth',3,'color',cols(Lim,:)), hold on,ylim([0.4 1.2])
subplot(132)
plot(nanmean((AllNeurResp_Onset)')','linewidth',3,'color',cols(Lim,:)), hold on,ylim([0.4 1.2])
subplot(133)
plot(nanmean((AllNeurResp_Norm)')','linewidth',3,'color',cols(Lim,:)), hold on, ylim([0.4 1.2])

figure
subplot(131)
tpsrealigned=tps*(1+(timebefprop*2))-timebefprop;
shadedErrorBar(tpsrealigned,nanmean(zscore(AllNeurResp_Norm)'),[stdError(zscore(AllNeurResp_Norm)');stdError(zscore(AllNeurResp_Norm)')])
hold on
shadedErrorBar(tpsrealigned,nanmean(zscore(AllNeurResp_Norm(:,AllP<0.05))'),[stdError(zscore(AllNeurResp_Norm(:,AllP<0.05))');stdError(zscore(AllNeurResp_Norm(:,AllP<0.05))')],'r')
xlim([-0.2 1.2])
box off, ylim([-0.6 0.6])
line([0 0],ylim,'color','k','linewidth',3)
line([1 1],ylim,'color','k','linewidth',3)
title('Normalized')

subplot(132)
tpsrealigned=tps*8-4-0.2;
shadedErrorBar(tpsrealigned,nanmean(zscore(AllNeurResp_Onset)'),[stdError(zscore(AllNeurResp_Onset)');stdError(zscore(AllNeurResp_Onset)')])
hold on
shadedErrorBar(tpsrealigned,nanmean(zscore(AllNeurResp_Onset(:,AllP<0.05))'),[stdError(zscore(AllNeurResp_Onset(:,AllP<0.05))');stdError(zscore(AllNeurResp_Onset(:,AllP<0.05))')],'r')
box off, ylim([-0.6 0.6])
line([0 0],ylim,'color','k','linewidth',3)
title('Onset')

dattemp=((nanmean(zscore(AllNeurResp_Offset(:,AllP<0.05))')));
dattemp=(runmean(dattemp,2));
dattemp=dattemp-min(dattemp);dattemp=dattemp/max(dattemp);
[fitresult, gof] = createFit_Sigmoid_Freezing(tps, dattemp,1);

        
subplot(133)
tpsrealigned=tps*8-4-0.2;
shadedErrorBar(tpsrealigned,nanmean(zscore(AllNeurResp_Offset)'),[stdError(zscore(AllNeurResp_Offset)');stdError(zscore(AllNeurResp_Offset)')])
hold on
shadedErrorBar(tpsrealigned,nanmean(zscore(AllNeurResp_Offset(:,AllP<0.05))'),[stdError(zscore(AllNeurResp_Offset(:,AllP<0.05))');stdError(zscore(AllNeurResp_Offset(:,AllP<0.05))')],'r')
box off, ylim([-0.6 0.6])
line([0 0],ylim,'color','k','linewidth',3)
title('Offset')


%%%
%% No error bars

figure
Step = 5;
StepsToTake1 = [0:Step:20];
StepsToTake2 = [Step:Step:25];
cols = summer(length(StepsToTake1));
clear OnsetAv OffSetAv
for Lim = 1:length(StepsToTake1)
    
    AllNeurResp_Offset=[];
    AllNeurResp_Onset=[];
    AllNeurResp_Norm=[];
    AllKappa = [];
    AllP = [];
    for mm=1:length(PFCFiring_AllMice_Offset)
        for sp = 1:size(PFCFiring_AllMice_Offset{mm},2)
            AllNeurResp_Offset=[AllNeurResp_Offset,squeeze(nanmean(PFCFiring_AllMice_Offset{mm}(Dur{mm}>StepsToTake1(Lim) & Dur{mm}<StepsToTake2(Lim),sp,:),1))];
            AllNeurResp_Onset=[AllNeurResp_Onset,squeeze(nanmean(PFCFiring_AllMice_Onset{mm}(Dur{mm}>StepsToTake1(Lim) & Dur{mm}<StepsToTake2(Lim),sp,:),1))];
            AllNeurResp_Norm=[AllNeurResp_Norm,squeeze(nanmean(PFCFiring_AllMice_normPer{mm}(Dur{mm}>StepsToTake1(Lim) & Dur{mm}<StepsToTake2(Lim),sp,:),1))];
        end
        
        AllKappa = [AllKappa,SpikeInfo.OBVars.Kappa{mm}];
        AllP = [AllP,SpikeInfo.OBVars.pval{mm}];
        
    end
    subplot(131)
    plot(nanmean((AllNeurResp_Offset(:,AllP>0))')','linewidth',3,'color',cols(Lim,:)), hold on,ylim([0.2 1.8])
    OffSetAv(Lim,1) = nanmean(nanmean((AllNeurResp_Offset(1:9,AllP>0))')');
    OffSetAv(Lim,2) = nanmean(nanmean((AllNeurResp_Offset(11:end,AllP>0))')');
    subplot(132)
    plot(nanmean((AllNeurResp_Onset(:,AllP>0))')','linewidth',3,'color',cols(Lim,:)), hold on,ylim([0.2 1.8])
    OnsetAv(Lim,1) = nanmean(nanmean((AllNeurResp_Onset(1:9,AllP>0))')');
    OnsetAv(Lim,2) = nanmean(nanmean((AllNeurResp_Onset(11:end,AllP>0))')');
    subplot(133)
    plot(nanmean((AllNeurResp_Norm(:,AllP>0))')','linewidth',3,'color',cols(Lim,:)), hold on, ylim([0.2 1.8])
end

figure
subplot(211)
plot(StepsToTake1, OnsetAv)
subplot(212)
plot(StepsToTake1, OffSetAv)



%histogram of episode durations
figure
nhist([Dur{:}],'binfactor',10,'noerror')
hold on
line([25 25],ylim,'color','k','linewidth',3)
xlabel('Fur of events')
ylabel('counts')

 % correlate change in firing rate at transitions with duration of event
figure
subplot(121)
Dat=[];
for mm=1:length(PFCFiring_AllMice_Offset)
    X = -(nanmean(nanmean(PFCFiring_AllMice_Onset{mm}(:,SpikeInfo.OBVars.pval{mm}>0.05,1:9),3),2)'-nanmean(nanmean(PFCFiring_AllMice_Onset{mm}(:,SpikeInfo.OBVars.pval{mm}>0.05,11:end),3),2)');
    Y = nanmean(nanmean(PFCFiring_AllMice_Onset{mm}(:,SpikeInfo.OBVars.pval{mm}>0.05,1:9),3),2)'+nanmean(nanmean(PFCFiring_AllMice_Onset{mm}(:,SpikeInfo.OBVars.pval{mm}>0.05,11:end),3),2)';
    Dat = [Dat,[X./Y;Dur{mm}]];
end
Dat(:,Dat(2,:)>25) =[];
Dat(:,isnan(Dat(1,:))) = [];
plot(Dat(2,:),Dat(1,:),'.k')
model=fitlm(Dat(2,:),Dat(1,:));
hold on
plot(Dat(2,:),Dat(2,:)*model.Coefficients.Estimate(2)+model.Coefficients.Estimate(1))
[R,P] = corrcoef(Dat(2,:),Dat(1,:));
title(['R=',num2str(round(R(1,2)*10)/10),'  P=',num2str(round(P(1,2)*1000)/1000)])
xlabel('Dur Fz episode')
ylabel('FiringRate MI nofz-fz')
ylim([-1 1])
line(xlim,[0 0],'color','k')
box off
set(gca,'FontSize',15)
subplot(122)
Dat=[];
for mm=1:length(PFCFiring_AllMice_Offset)
    X = (nanmean(nanmean(PFCFiring_AllMice_Offset{mm}(:,SpikeInfo.OBVars.pval{mm}>0.05,1:9),3),2)'-nanmean(nanmean(PFCFiring_AllMice_Offset{mm}(:,SpikeInfo.OBVars.pval{mm}>0.05,11:end),3),2)');
    Y = nanmean(nanmean(PFCFiring_AllMice_Offset{mm}(:,SpikeInfo.OBVars.pval{mm}>0.05,1:9),3),2)'+nanmean(nanmean(PFCFiring_AllMice_Offset{mm}(:,SpikeInfo.OBVars.pval{mm}>0.05,11:end),3),2)';
    Dat = [Dat,[X./Y;Dur{mm}]];
end
Dat(:,Dat(2,:)>25) =[];
Dat(:,isnan(Dat(1,:))) = [];
plot(Dat(2,:),Dat(1,:),'.k')
[R,P] = corrcoef(Dat(2,:),Dat(1,:));
model=fitlm(Dat(2,:),Dat(1,:));
hold on
plot(Dat(2,:),Dat(2,:)*model.Coefficients.Estimate(2)+model.Coefficients.Estimate(1))
title(['R=',num2str(round(R(1,2)*10)/10),'  P=',num2str(round(P(1,2)*1000)/1000)])
ylim([-1 1])
line(xlim,[0 0],'color','k')
xlabel('Dur Fz episode')
ylabel('FiringRate MI nofz-fz')
box off
set(gca,'FontSize',15)





%% All freezing episodes - zscored
tpsrealigned=tps*(1+(timebefprop*2))-timebefprop;
tpsrealignedbis=tps*8-4-0.2;

figure
for condnum = 1:3
    
    clear AllNeurResp_Offset_Tot AllNeurResp_Onset_Tot AllNeurResp_Norm_Tot
    for mm=1:length(PFCFiring_AllMice_Offset)
        AllNeurResp_Offset=[];
        AllNeurResp_Onset=[];
        AllNeurResp_Norm=[];
        AllKappa = [];
        AllP = [];
        
        for sp = 1:size(PFCFiring_AllMice_Offset{mm},2)
            if eval(['SpikeInfo.OBVars.pval{mm}(sp)',Cond{condnum}])
                AllNeurResp_Offset=[AllNeurResp_Offset,squeeze(nanmean(PFCFiring_AllMice_Offset{mm}(:,sp,:),1))];
                AllNeurResp_Onset=[AllNeurResp_Onset,squeeze(nanmean(PFCFiring_AllMice_Onset{mm}(:,sp,:),1))];
                AllNeurResp_Norm=[AllNeurResp_Norm,squeeze(nanmean(PFCFiring_AllMice_normPer{mm}(:,sp,:),1))];
            end
        end
        AllNeurResp_Offset_Tot(mm,:) = nanmean(zscore(AllNeurResp_Offset)');
        AllNeurResp_Onset_Tot(mm,:) = nanmean(zscore(AllNeurResp_Onset)');
        AllNeurResp_Norm_Tot(mm,:) = nanmean(zscore(AllNeurResp_Norm)');
        
    end
    
    subplot(3,3,1+(condnum-1)*3)
    errorbar(tpsrealignedbis,squeeze(nanmean(AllNeurResp_Onset_Tot(:,:),1)),stdError(squeeze(AllNeurResp_Onset_Tot(:,:)))','linewidth',3,'color','k'), hold on,%ylim([0.2 1.8])
    xlim([-4.1 4.1]), ylim([-1 1])
    line([0 0],ylim,'color','r','linewidth',2)
    xlabel('time (s)')
    ylabel('FR (zscr)')
    if condnum==1
        title('onset')
    end
    subplot(3,3,2+(condnum-1)*3)
    errorbar(tpsrealignedbis,squeeze(nanmean(AllNeurResp_Offset_Tot(:,:),1)),stdError(squeeze(AllNeurResp_Offset_Tot(:,:)))','linewidth',3,'color','k'), hold on,%ylim([0.2 1.8])
    xlim([-4.1 4.1]), ylim([-1 1])
    line([0 0],ylim,'color','b','linewidth',2)
    xlabel('time (s)')
    if condnum==1
        title('offset')
    end
    subplot(3,3,3+(condnum-1)*3)
    errorbar(tpsrealigned,squeeze(nanmean(AllNeurResp_Norm_Tot(:,:),1)),stdError(squeeze(AllNeurResp_Norm_Tot(:,:)))','linewidth',3,'color','k'), hold on,%ylim([0.2 1.8])
    xlim([-0.4 1.4]), ylim([-1 1])
    line([0 0],ylim,'color','r','linewidth',2)
    line([1 1],ylim,'color','b','linewidth',2)
    xlabel('time (norm)')
    if condnum==1
        title('norm ep')
    end
    
end

%% All freezing episodes - FR
tpsrealigned=tps*(1+(timebefprop*2))-timebefprop;
tpsrealignedbis=tps*8-4-0.2;

figure
for condnum = 1:3
    
    clear AllNeurResp_Offset_Tot AllNeurResp_Onset_Tot AllNeurResp_Norm_Tot
    for mm=1:length(PFCFiring_AllMice_Offset)
        AllNeurResp_Offset=[];
        AllNeurResp_Onset=[];
        AllNeurResp_Norm=[];
        AllKappa = [];
        AllP = [];
        
        for sp = 1:size(PFCFiring_AllMice_Offset{mm},2)
            if eval(['SpikeInfo.OBVars.pval{mm}(sp)',Cond{condnum}])
                AllNeurResp_Offset=[AllNeurResp_Offset,squeeze(nanmean(PFCFiring_AllMice_Offset{mm}(:,sp,:),1))];
                AllNeurResp_Onset=[AllNeurResp_Onset,squeeze(nanmean(PFCFiring_AllMice_Onset{mm}(:,sp,:),1))];
                AllNeurResp_Norm=[AllNeurResp_Norm,squeeze(nanmean(PFCFiring_AllMice_normPer{mm}(:,sp,:),1))];
            end
        end
        AllNeurResp_Offset_Tot(mm,:) = nanmean((AllNeurResp_Offset)');
        AllNeurResp_Onset_Tot(mm,:) = nanmean((AllNeurResp_Onset)');
        AllNeurResp_Norm_Tot(mm,:) = nanmean((AllNeurResp_Norm)');
        
    end
    
    subplot(3,3,1+(condnum-1)*3)
    errorbar(tpsrealignedbis,squeeze(nanmean(AllNeurResp_Onset_Tot(:,:),1)),stdError(squeeze(AllNeurResp_Onset_Tot(:,:)))','linewidth',3,'color','k'), hold on,%ylim([0.2 1.8])
    xlim([-4.1 4.1]), ylim([0.4 1.5])
    line([0 0],ylim,'color','r','linewidth',2)
    xlabel('time (s)')
    ylabel('FR (zscr)')
    if condnum==1
        title('onset')
    end
    subplot(3,3,2+(condnum-1)*3)
    errorbar(tpsrealignedbis,squeeze(nanmean(AllNeurResp_Offset_Tot(:,:),1)),stdError(squeeze(AllNeurResp_Offset_Tot(:,:)))','linewidth',3,'color','k'), hold on,%ylim([0.2 1.8])
    xlim([-4.1 4.1]), ylim([0.4 1.5])
    line([0 0],ylim,'color','b','linewidth',2)
    xlabel('time (s)')
    if condnum==1
        title('offset')
    end
    subplot(3,3,3+(condnum-1)*3)
    errorbar(tpsrealigned,squeeze(nanmean(AllNeurResp_Norm_Tot(:,:),1)),stdError(squeeze(AllNeurResp_Norm_Tot(:,:)))','linewidth',3,'color','k'), hold on,%ylim([0.2 1.8])
    xlim([-0.4 1.4]), ylim([0.4 1.5])
    line([0 0],ylim,'color','r','linewidth',2)
    line([1 1],ylim,'color','b','linewidth',2)
    xlabel('time (norm)')
    if condnum==1
        title('norm ep')
    end
    
end


%% muse by mouse
Cond={'>0','>0.05','<0.05'};
for condnum = 1:3
    figure(99)
    Step = 5;
    StepsToTake1 = [0:Step:20];
    StepsToTake2 = [Step:Step:25];
    cols = [0 0 0;0.8 0.8 0.8;0 0 0;0.2 0.2 0.2];
    clear OnsetAv OffSetAv
    clear AllNeurResp_Offset_Tot AllNeurResp_Onset_Tot AllNeurResp_Norm_Tot
    for Lim = 1:length(StepsToTake1)
        
        for mm=1:length(PFCFiring_AllMice_Offset)
            AllNeurResp_Offset=[];
            AllNeurResp_Onset=[];
            AllNeurResp_Norm=[];
            AllKappa = [];
            AllP = [];
            
            for sp = 1:size(PFCFiring_AllMice_Offset{mm},2)
                if eval(['SpikeInfo.OBVars.pval{mm}(sp)',Cond{condnum}])
                    AllNeurResp_Offset=[AllNeurResp_Offset,squeeze(nanmean(PFCFiring_AllMice_Offset{mm}(Dur{mm}>StepsToTake1(Lim) & Dur{mm}<StepsToTake2(Lim),sp,:),1))];
                    AllNeurResp_Onset=[AllNeurResp_Onset,squeeze(nanmean(PFCFiring_AllMice_Onset{mm}(Dur{mm}>StepsToTake1(Lim) & Dur{mm}<StepsToTake2(Lim),sp,:),1))];
                    AllNeurResp_Norm=[AllNeurResp_Norm,squeeze(nanmean(PFCFiring_AllMice_normPer{mm}(Dur{mm}>StepsToTake1(Lim) & Dur{mm}<StepsToTake2(Lim),sp,:),1))];
                end
            end
            
            AllKappa = [AllKappa,SpikeInfo.OBVars.Kappa{mm}];
            AllP = [AllP,SpikeInfo.OBVars.pval{mm}];
            AllNeurResp_Offset_Tot(mm,Lim,:) = nanmean(AllNeurResp_Offset');
            AllNeurResp_Onset_Tot(mm,Lim,:) = nanmean(AllNeurResp_Onset');
            AllNeurResp_Norm_Tot(mm,Lim,:) = nanmean(AllNeurResp_Norm');
            OffSetAv(mm,Lim,1) = nanmean(nanmean((AllNeurResp_Offset_Tot(mm,Lim,1:9)),2),3);
            OffSetAv(mm,Lim,2) = nanmean(nanmean((AllNeurResp_Offset_Tot(mm,Lim,11:end)),2),3);
            OnsetAv(mm,Lim,1) = nanmean(nanmean((AllNeurResp_Onset_Tot(mm,Lim,1:9)),2),3);
            OnsetAv(mm,Lim,2) = nanmean(nanmean((AllNeurResp_Onset_Tot(mm,Lim,11:end)),2),3);
            NormAv(mm,Lim,1) = nanmean(nanmean((AllNeurResp_Norm_Tot(mm,Lim,6:12)),2),3);
            NormAv(mm,Lim,2) = nanmean(nanmean((AllNeurResp_Norm_Tot(mm,Lim,1:4)),2),3);
            NormAv(mm,Lim,3) = nanmean(nanmean((AllNeurResp_Norm_Tot(mm,Lim,end-3:end)),2),3);
            
        end
        if Lim ==2 | Lim ==4
            
            subplot(3,3,1+(condnum-1)*3)
            errorbar(tpsrealignedbis,squeeze(nanmean(AllNeurResp_Onset_Tot(:,Lim,:),1)),stdError(squeeze(AllNeurResp_Onset_Tot(:,Lim,:)))','linewidth',3,'color',cols(Lim,:)), hold on,%ylim([0.2 1.8])
            xlim([-4.1 4.1]),
            line([0 0],ylim,'color','r','linewidth',2)
            xlabel('time (s)')
            ylabel('FR (zscr)')
            if condnum==1
                title('onset')
            end
            subplot(3,3,2+(condnum-1)*3)
            errorbar(tpsrealignedbis,squeeze(nanmean(AllNeurResp_Offset_Tot(:,Lim,:),1)),stdError(squeeze(AllNeurResp_Offset_Tot(:,Lim,:)))','linewidth',3,'color',cols(Lim,:)), hold on,%ylim([0.2 1.8])
            xlim([-4.1 4.1]),
            line([0 0],ylim,'color','b','linewidth',2)
            xlabel('time (s)')
            if condnum==1
                title('offset')
            end
            subplot(3,3,3+(condnum-1)*3)
            errorbar(tpsrealigned,squeeze(nanmean(AllNeurResp_Norm_Tot(:,Lim,:),1)),stdError(squeeze(AllNeurResp_Norm_Tot(:,Lim,:)))','linewidth',3,'color',cols(Lim,:)), hold on,%ylim([0.2 1.8])
            xlim([-0.4 1.4]),
            line([0 0],ylim,'color','r','linewidth',2)
            line([1 1],ylim,'color','b','linewidth',2)
            xlabel('time (norm)')
            if condnum==1
                title('norm ep')
            end
        end
        
    end
    
    
    figure(100)
    subplot(3,3,1+(condnum-1)*3)
    errorbar(StepsToTake1, nanmean(squeeze(OnsetAv(:,:,1)),1),stdError(squeeze(OnsetAv(:,:,1))),'linewidth',3,'color','r')
    hold on
    errorbar(StepsToTake1, nanmean(squeeze(OnsetAv(:,:,2)),1),stdError(squeeze(OnsetAv(:,:,2))),'linewidth',3,'color','b')
    xlabel('Duration of ep'), ylabel('FR')
    set(gca,'XTick',StepsToTake1)
    if condnum==1
        title('onset')
        legend('NoFz','Fz')

    end
    subplot(3,3,2+(condnum-1)*3)
    errorbar(StepsToTake1, nanmean(squeeze(OffSetAv(:,:,1)),1),stdError(squeeze(OffSetAv(:,:,1))),'linewidth',3,'color','b')
    hold on
    errorbar(StepsToTake1, nanmean(squeeze(OffSetAv(:,:,2)),1),stdError(squeeze(OffSetAv(:,:,2))),'linewidth',3,'color','r')
    xlabel('Duration of ep')
    if condnum==1
        title('offset')
    end
    set(gca,'XTick',StepsToTake1)
    subplot(3,3,3+(condnum-1)*3)
    errorbar(StepsToTake1, nanmean(squeeze(NormAv(:,:,1)),1),stdError(squeeze(NormAv(:,:,1))),'linewidth',3,'color','k'),hold on
    errorbar(StepsToTake1, nanmean(squeeze(NormAv(:,:,2)),1),stdError(squeeze(NormAv(:,:,2))),'linewidth',3,'color','r')
    errorbar(StepsToTake1, nanmean(squeeze(NormAv(:,:,3)),1),stdError(squeeze(NormAv(:,:,3))),'linewidth',3,'color','b')
    xlabel('Duration of ep')
    set(gca,'XTick',StepsToTake1)
    if condnum==1
        title('norm ep')
    end
    
    
end

tpsrealigned_norm=tps*(1+(timebefprop*2))-timebefprop;
tpsrealigned=tps*8-4-0.2;


%% PFC units 
% Onset - offset - norm
%% Single unit firing and projected values
AllOff=[];AllOn=[];AllNorm=[];
for mm=1:length(Weight_Fz_NoFz)
    for sp = 1:size(PFCFiring_AllMice_Offset{mm},2)
        AllOff = [AllOff,squeeze(mean(PFCFiring_AllMice_Offset{mm}(:,sp,:),1))];
        
        AllOn = [AllOn,squeeze(mean(PFCFiring_AllMice_Onset{mm}(:,sp,:),1))];
        
        AllNorm = [AllNorm,squeeze(mean(PFCFiring_AllMice_normPer{mm}(:,sp,:),1))];

    end
end

figure
subplot(231)
plot(tpsrealigned,(nanmean(AllOn')),'color','k','linewidth',4), hold on
line([0 0],ylim)
box off
ylim([0.7 1])
title('Onset')
subplot(232)
plot(tpsrealigned_norm,(nanmean(AllNorm')),'color','k','linewidth',4), hold on
line([0 0],ylim)
line([1 1],ylim)
box off
title('norm')
ylim([0.7 1])
subplot(233)
plot(tpsrealigned,(nanmean(AllOff')),'color','k','linewidth',4), hold on
line([0 0],ylim)
box off
title('offset')
ylim([0.7 1])

AllOff=[];AllOn=[];AllNorm=[];
for mm=1:length(Weight_Fz_NoFz)
    for sp = 1:size(PFCFiring_AllMice_Offset{mm},2)
        AllOff = [AllOff,squeeze(mean(PFCFiring_AllMice_Offset{mm}(:,sp,:),1)).*Weight_Fz_NoFz{mm}(sp)];
        
        AllOn = [AllOn,squeeze(mean(PFCFiring_AllMice_Onset{mm}(:,sp,:),1)).*Weight_Fz_NoFz{mm}(sp)];
        
        AllNorm = [AllNorm,squeeze(mean(PFCFiring_AllMice_normPer{mm}(:,sp,:),1)).*Weight_Fz_NoFz{mm}(sp)];

    end
end
subplot(234)
plot(tpsrealigned,(nanmean(AllOn')),'color','k','linewidth',4), hold on
line([0 0],ylim)
box off
title('Onset')
ylim([-4.5 -1])
subplot(235)
plot(tpsrealigned_norm,(nanmean(AllNorm')),'color','k','linewidth',4), hold on
line([0 0],ylim)
line([1 1],ylim)
box off
title('norm')
ylim([-4.5 -1])
subplot(236)
plot(tpsrealigned,(nanmean(AllOff')),'color','k','linewidth',4), hold on
line([0 0],ylim)
box off
title('offset')
ylim([-4.5 -1])


%% Single unit firing and projected values for different durations
step = 3;
figure
cols = winter(3);
LowDur =[3:6:18];
HighDur = [6:6:21];
for dur=1:length(LowDur)
    
    AllOff=[];AllOn=[];AllNorm=[];
    for mm=1:length(Weight_Fz_NoFz)
        for sp = 1:size(PFCFiring_AllMice_Offset{mm},2)
            if SpikeInfo.OBVars.pval{mm}(sp)<0.05
                AllOff = [AllOff,squeeze(mean(PFCFiring_AllMice_Offset{mm}(Dur{mm}<HighDur(dur) & Dur{mm}>LowDur(dur),sp,:),1))];
                
                AllOn = [AllOn,squeeze(mean(PFCFiring_AllMice_Onset{mm}(Dur{mm}<HighDur(dur) & Dur{mm}>LowDur(dur),sp,:),1))];
                
                AllNorm = [AllNorm,squeeze(mean(PFCFiring_AllMice_normPer{mm}(Dur{mm}<HighDur(dur) & Dur{mm}>LowDur(dur),sp,:),1))];
            end
        end
    end
    
    
    subplot(231)
    plot(tpsrealigned,(nanmean(AllOn')),'color',cols(dur,:),'linewidth',4), hold on
    line([0 0],ylim)
    box off
    title('Onset')
    subplot(232)
    plot(tpsrealigned_norm,(nanmean(AllNorm')),'color',cols(dur,:),'linewidth',4), hold on
    line([0 0],ylim)
    line([1 1],ylim)
    box off
    title('norm')
    subplot(233)
    plot(tpsrealigned,(nanmean(AllOff')),'color',cols(dur,:),'linewidth',4), hold on
    line([0 0],ylim)
    box off
    title('offset')
    
    AllOff=[];AllOn=[];AllNorm=[];
    for mm=1:length(Weight_Fz_NoFz)
        for sp = 1:size(PFCFiring_AllMice_Offset{mm},2)
            if SpikeInfo.OBVars.pval{mm}(sp)<0.05
                AllOff = [AllOff,squeeze(mean(PFCFiring_AllMice_Offset{mm}(Dur{mm}<HighDur(dur) & Dur{mm}>LowDur(dur),sp,:),1)).*Weight_Fz_NoFz{mm}(sp)];
                
                AllOn = [AllOn,squeeze(mean(PFCFiring_AllMice_Onset{mm}(Dur{mm}<HighDur(dur) & Dur{mm}>LowDur(dur),sp,:),1)).*Weight_Fz_NoFz{mm}(sp)];
                
                AllNorm = [AllNorm,squeeze(mean(PFCFiring_AllMice_normPer{mm}(Dur{mm}<HighDur(dur) & Dur{mm}>LowDur(dur),sp,:),1)).*Weight_Fz_NoFz{mm}(sp)];
            end
        end
    end
    subplot(234)
    plot(tpsrealigned,(nanmean(AllOn')),'color',cols(dur,:),'linewidth',4), hold on
    line([0 0],ylim)
    box off
    title('Onset')
    subplot(235)
    plot(tpsrealigned_norm,(nanmean(AllNorm')),'color',cols(dur,:),'linewidth',4), hold on
    line([0 0],ylim)
    line([1 1],ylim)
    box off
    title('norm')
    subplot(236)
    plot(tpsrealigned,(nanmean(AllOff')),'color',cols(dur,:),'linewidth',4), hold on
    line([0 0],ylim)
    box off
    title('offst')
    
    
end




%histogram of episode durations
figure
nhist([Dur{:}],'binfactor',10,'noerror')
hold on
line([25 25],ylim,'color','k','linewidth',3)
xlabel('Fur of events')
ylabel('counts')

 % correlate change in firing rate at transitions with duration of event
figure
subplot(121)
Dat=[];
for mm=1:length(PFCFiring_AllMice_Onset)
    X = -(nanmean(nanmean(PFCFiring_AllMice_Onset{mm}(:,:,1:9),3),2)'-nanmean(nanmean(PFCFiring_AllMice_Onset{mm}(:,:,11:end),3),2)');
    Y = nanmean(nanmean(PFCFiring_AllMice_Onset{mm}(:,:,1:9),3),2)'+nanmean(nanmean(PFCFiring_AllMice_Onset{mm}(:,:,11:end),3),2)';
    Dat = [Dat,[X./Y;Dur{mm}]];
end
Dat(:,Dat(2,:)>25) =[];
Dat(:,isnan(Dat(1,:))) = [];
plot(Dat(2,:),Dat(1,:),'.k')
model=fitlm(Dat(2,:),Dat(1,:));
hold on
plot(Dat(2,:),Dat(2,:)*model.Coefficients.Estimate(2)+model.Coefficients.Estimate(1))
[R,P] = corrcoef(Dat(2,:),Dat(1,:));
title(['R=',num2str(round(R(1,2)*10)/10),'  P=',num2str(round(P(1,2)*1000)/1000)])
xlabel('Dur Fz episode')
ylabel('FiringRate MI nofz-fz')
ylim([-1 1])
line(xlim,[0 0],'color','k')
box off
set(gca,'FontSize',15)
subplot(122)
Dat=[];
for mm=1:length(PFCFiring_AllMice_Offset)
    X = (nanmean(nanmean(PFCFiring_AllMice_Offset{mm}(:,:,1:9),3),2)'-nanmean(nanmean(PFCFiring_AllMice_Offset{mm}(:,:,11:end),3),2)');
    Y = nanmean(nanmean(PFCFiring_AllMice_Offset{mm}(:,:,1:9),3),2)'+nanmean(nanmean(PFCFiring_AllMice_Offset{mm}(:,:,11:end),3),2)';
    Dat = [Dat,[X./Y;Dur{mm}]];
end
Dat(:,Dat(2,:)>25) =[];
Dat(:,isnan(Dat(1,:))) = [];
plot(Dat(2,:),Dat(1,:),'.k')
[R,P] = corrcoef(Dat(2,:),Dat(1,:));
model=fitlm(Dat(2,:),Dat(1,:));
hold on
plot(Dat(2,:),Dat(2,:)*model.Coefficients.Estimate(2)+model.Coefficients.Estimate(1))
title(['R=',num2str(round(R(1,2)*10)/10),'  P=',num2str(round(P(1,2)*1000)/1000)])
ylim([-1 1])
line(xlim,[0 0],'color','k')
xlabel('Dur Fz episode')
ylabel('FiringRate MI nofz-fz')
box off
set(gca,'FontSize',15)
