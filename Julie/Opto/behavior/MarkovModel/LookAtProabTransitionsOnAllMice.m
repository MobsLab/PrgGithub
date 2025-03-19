% Make behaviour,spectra, coherence and granger pannels for fig1
clear all
% Get data

CtrlEphys=[242,248,244,243,253,254,258,259,299,394,395,402,403,450,451];

Dir=PathForExperimentFEAR('Fear-electrophy');
Dir=RestrictPathForExperiment(Dir,'nMice',CtrlEphys);
Dir=RestrictPathForExperiment(Dir,'Session','EXT-24h');
KeepFirstSessionOnly=[1,3,4,6,8:length(Dir.path)];
CSMOINS=[122 192 257 347];
CSPLUS=[408 478 628 689 789 862 927 1007 1117 1178 1256 1320];
% CSEpoch{1}=intervalSet(CSMOINS*1e4,CSMOINS*1e4+60*1e4);
% CSEpoch{2}=intervalSet(CSPLUS(1:4)*1e4,CSPLUS(1:4)*1e4+60*1e4);
% CSEpoch{3}=intervalSet(CSPLUS(5:8)*1e4,CSPLUS(5:8)*1e4+60*1e4);
% CSEpoch{4}=intervalSet(CSPLUS(9:12)*1e4,CSPLUS(9:12)*1e4+60*1e4);
SaveToName='/home/vador/Dropbox/MOBS_workingON/OB4Hz-manuscrit/Fig1/';
KeepFirstSessionOnly=[1,3,4,6,8:length(Dir.path)];
num=1;
stepsize = 2;
EndSessionTime = 1400;

% load('/media/DataMOBsRAIDN/ProjetAversion/OptoFear/Fear_Mar2-July-Oct2017/EXT-24_fullperiod_close2sound_acc_epochs','CsminPer','CspluPer0','CspluPer1','CspluPer2','CspluPer3')
% CSEpoch{1} = CsminPer;
% CSEpoch{2} = CspluPer0;
% CSEpoch{3} = CspluPer1;

CSEpoch{1}=intervalSet(0*1e4,120*1e4);
CSEpoch{2}=intervalSet(CSMOINS(1)*1e4,CSMOINS(4)*1e4+60*1e4);
CSEpoch{3}=intervalSet(CSPLUS(1)*1e4,CSPLUS(4)*1e4+60*1e4);
% CSEpoch{4}=intervalSet(CSPLUS(9:12)*1e4,CSPLUS(9:12)*1e4+60*1e4);


for mm=KeepFirstSessionOnly
    mm
    cd(Dir.path{mm})
    
    load('behavResources.mat')
    
    for k=1:3
        
        tps = [0:stepsize:EndSessionTime]*1e4;
        FakeData = tsd((tps),[1:length(tps)]');
        
        BinData_FZ_ind = Data(Restrict(FakeData,FreezeEpoch));
        BinData_FZ_val = zeros(1,length(tps));
        BinData_FZ_val(BinData_FZ_ind)=1;
        BinData_FZ_val_Change=diff(BinData_FZ_val);
        BinData_FZ_val(end)=[];
        
        BinData_FZ_val_Change = Data(Restrict(tsd(tps(1:end-1),BinData_FZ_val_Change'),CSEpoch{k}));
        BinData_FZ_val = Data(Restrict(tsd(tps(1:end-1),BinData_FZ_val'),CSEpoch{k}));
        
        StayAct_GFP(num,k) = sum(BinData_FZ_val==0 & BinData_FZ_val_Change==0)/sum(BinData_FZ_val==0);
        ChangeAct_GFP(num,k) = sum(BinData_FZ_val==0 & BinData_FZ_val_Change==1)/sum(BinData_FZ_val==0);
        StayFz_GFP(num,k)= sum(BinData_FZ_val==1 & BinData_FZ_val_Change==0)/sum(BinData_FZ_val==1);
        ChangeFz_GFP(num,k) = sum(BinData_FZ_val==1 & BinData_FZ_val_Change==-1)/sum(BinData_FZ_val==1);
        
        NumInit_GFP(num,k)=sum(BinData_FZ_val==0 & BinData_FZ_val_Change==1);
        TutDur_GFP(num,k)=sum(BinData_FZ_val==1);
        
        DurFzEp_GFP(num,k)=nanmean(Stop(and(CSEpoch{k},FreezeEpoch),'s')-Start(and(CSEpoch{k},FreezeEpoch),'s'));
        
        ActEpoch = and(CSEpoch{k},intervalSet(0,EndSessionTime*1e4)-FreezeEpoch);
        DurActEp_GFP(num,k)=nanmean(Stop(ActEpoch,'s')-Start(ActEpoch,'s'));
    end
    
    num=num+1;
end


%% Figures with duration
figure
subplot(211)
hold on
errorbar([1:3],nanmean(DurFzEp_GFP),stdError(DurFzEp_GFP),'color',[0 0 0],'linewidth',3)
xlim([0.5 3.5])
ylabel('Mean freezing episode duration')
subplot(212)
errorbar([1:3],nanmean(DurActEp_GFP),stdError(DurActEp_GFP),'color',[0 0 0],'linewidth',3)
xlim([0.5 3.5])
ylabel('Mean active episode duration')
box off

Xlabels={'Bef','CS-','CS+';};
%% correlate mean episode duration of two types of behaviour and start stop
fig = figure;fig.Position = [366 38 1019 751];
for k = 1:3
    subplot(3,3,k)
    plot(DurFzEp_GFP(:,k),DurActEp_GFP(:,k),'k.','MarkerSize',20), hold on
    [R,P] = corrcoef(DurFzEp_GFP(:,k),DurActEp_GFP(:,k),'Rows','complete');
    if P(1,2)<0.05
        text(max(xlim)*0.8,max(ylim)*0.8,num2str(round(P(1,2)*1000)/1000))
        text(max(xlim)*0.8,max(ylim)*0.6,num2str(round(R(1,2)*1000)/1000))
    end
    xlabel('Fz Ep dur')
    ylabel('Act Ep dur')
    title(Xlabels{k})
    
    subplot(3,3,3+k)
    plot(DurFzEp_GFP(:,k),NumInit_GFP(:,k),'k.','MarkerSize',20), hold on
    [R,P] = corrcoef(DurFzEp_GFP(:,k),NumInit_GFP(:,k),'Rows','complete');
    if P(1,2)<0.05
        text(max(xlim)*0.8,max(ylim)*0.8,num2str(round(P(1,2)*1000)/1000))
        text(max(xlim)*0.8,max(ylim)*0.6,num2str(round(R(1,2)*1000)/1000))
    end
    xlabel('Fz Ep dur')
    ylabel('Num of fz ep')
    
    
    subplot(3,3,6+k)
    plot(NumInit_GFP(:,k),DurActEp_GFP(:,k),'k.','MarkerSize',20), hold on
    [R,P] = corrcoef(NumInit_GFP(:,k),DurActEp_GFP(:,k),'Rows','complete');
    if P(1,2)<0.05
        text(max(xlim)*0.8,max(ylim)*0.8,num2str(round(P(1,2)*1000)/1000))
        text(max(xlim)*0.8,max(ylim)*0.6,num2str(round(R(1,2)*1000)/1000))

    end
    xlabel('Num of fz ep')
    ylabel('Act Ep dur')
end

save('DataFzingStatesAllMiceBroadEpochs.mat','DurActEp_GFP','DurFzEp_GFP','NumInit_GFP','TutDur_GFP','ChangeFz_GFP','StayFz_GFP','ChangeAct_GFP','StayAct_GFP')