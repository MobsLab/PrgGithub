clear all
m=0;
m=m+1;File{m} = '/media/DataMOBsRAID/ProjetAversion/DATA-Fear/Mouse230/20150212-EXT-24h-envC';
m=m+1;File{m} = '/media/DataMOBsRAID/ProjetAversion/DATA-Fear/Mouse250/20150506-EXT-24h-envC';
m=m+1;File{m} = '/media/DataMOBsRAID/ProjetAversion/DATA-Fear/Mouse249/20150506-EXT-24h-envC';
m=m+1;File{m} = '/media/DataMOBsRAID/ProjetAversion/DATA-Fear/Mouse297/20151217-EXT-24h-envC';
m=m+1;File{m} = '/media/DataMOBsRAID/ProjetAversion/DATA-Fear/Mouse298/20151217-EXT-24h-envC';
m=m+1;File{m} = '/media/DataMOBsRAID/ProjetAversion/DATA-Fear/Mouse291/20151204-EXT-24h-envC';

for mm = 1:m
    clear Spectro FreezeEpoch FreezeAccEpoch
    
    cd(File{mm})
    load('behavResources.mat')
    load('PFCx_Low_Spectrum.mat')
%     if exist('FreezeAccEpoch')>0
%         FreezeEpoch = FreezeAccEpoch;
%     end
    
    fS = Spectro{3};
    Sptsd = tsd(Spectro{2}*1e4,log(Spectro{1}));
    Spec.Fz.PFC(mm,:) = nanmean(Data(Restrict(Sptsd,FreezeEpoch)));
    
    BandLimsS = [find(fS<3,1,'last'):find(fS<6,1,'last')];
    OtherFreq = [1:length(fS)];OtherFreq(ismember(OtherFreq,BandLimsS))=[];
    
end

ValBBX = nanmean(Spec.Fz.PFC(:,BandLimsS)')./nanmean(Spec.Fz.PFC(:,OtherFreq)');


[Dir,KeepFirstSessionOnly,CtrlEphys]=GetRightSessionsFor4HzPaper('CtrlAllData');
for mm=KeepFirstSessionOnly
    cd(Dir.path{mm})
    clear Spectro FreezeEpoch FreezeAccEpoch
    load('behavResources.mat')
    load('PFCx_Low_Spectrum.mat')
    fS = Spectro{3};
%     if exist('FreezeAccEpoch')>0
%         FreezeEpoch = FreezeAccEpoch;
%     end
    Sptsd = tsd(Spectro{2}*1e4,log(Spectro{1}));
    SpecCtrl.Fz.PFC(mm,:) = nanmean(Data(Restrict(Sptsd,FreezeEpoch)));
    
    BandLimsS = [find(fS<3,1,'last'):find(fS<6,1,'last')];
    OtherFreq = [1:length(fS)];OtherFreq(ismember(OtherFreq,BandLimsS))=[];
end
SpecCtrl.Fz.PFC(5:6,:) = [];

ValCTRL = nanmean(SpecCtrl.Fz.PFC(:,BandLimsS)')./nanmean(SpecCtrl.Fz.PFC(:,OtherFreq)');

Cols = {[0.8 0.8 0.8],[1 0.4 0.4],[0.8 0.6 0.6]};
figure
A = {ValCTRL,ValBBX};
Legends = {'Ctrl','BBX'};
X = 1:2
MakeSpreadAndBoxPlot_SB(A,Cols,X,Legends)
ylabel('3-6SNR')
ylim([1 1.4])
[p,h,ci]=ranksum(ValCTRL,ValBBX);

figure
plot(Spectro{3},nanmean(SpecCtrl.Fz.PFC),'color',Cols{1},'linewidth',3)
hold on
plot(Spectro{3},nanmean(Spec.Fz.PFC(:,:)),'color',Cols{2},'linewidth',3)
patch([3 3 6 6],[0,20,20,0],[1 1 1]*0.95,'EdgeColor',[1 1 1]*0.95),hold on
[hl,hp]=boundedline(fS,nanmean(SpecCtrl.Fz.PFC),[stdError(SpecCtrl.Fz.PFC);stdError(SpecCtrl.Fz.PFC)]','alpha'),hold on
set(hl,'Color',Cols{1}*0.7,'linewidth',2)
set(hp,'FaceColor',Cols{1})
hold on
[hl,hp]=boundedline(fS,nanmean(Spec.Fz.PFC(:,:)),[stdError(Spec.Fz.PFC(:,:));stdError(Spec.Fz.PFC(:,:))]','alpha'),hold on
set(hl,'Color',Cols{2}*0.7,'linewidth',2)
set(hp,'FaceColor',Cols{2})
set(gca,'Layer','top')
ylim([5 12])
set(gca,'Layer','top')
legend('Ctrl','BBX')
set(gca,'FontSize',15,'linewidth',1.5)
xlabel('Frequency (Hz)')
ylabel('Power - log scale')
box off
set(gca,'FontSize',15,'linewidth',1.5)
xlabel('Frequency (Hz)')
ylabel('Power - log scale')
box off

figure
A = {ValCTRL,ValBBX(2:3),ValBBX(([1,4,5,6]))};
Legends = {'CtrlDataSet','Small BBX','Big BBX'};
X = 1:3
MakeSpreadAndBoxPlot_SB(A,Cols,X,Legends)
ylabel('3-6SNR')
ylim([1 1.4])

figure
plot(Spectro{3},nanmean(SpecCtrl.Fz.PFC),'color',Cols{1},'linewidth',3)
hold on
plot(Spectro{3},nanmean(Spec.Fz.PFC(1:3,:)),'color',Cols{2},'linewidth',3)
plot(Spectro{3},nanmean(Spec.Fz.PFC(4:end,:)),'color',Cols{3},'linewidth',3)
patch([3 3 6 6],[0,20,20,0],[1 1 1]*0.95,'EdgeColor',[1 1 1]*0.95),hold on
[hl,hp]=boundedline(fS,nanmean(SpecCtrl.Fz.PFC),[stdError(SpecCtrl.Fz.PFC);stdError(SpecCtrl.Fz.PFC)]','alpha'),hold on
set(hl,'Color',Cols{1}*0.7,'linewidth',2)
set(hp,'FaceColor',Cols{1})
hold on
[hl,hp]=boundedline(fS,nanmean(Spec.Fz.PFC(1:3,:)),[stdError(Spec.Fz.PFC(1:3,:));stdError(Spec.Fz.PFC(1:3,:))]','alpha'),hold on
set(hl,'Color',Cols{2}*0.7,'linewidth',2)
set(hp,'FaceColor',Cols{2})
[hl,hp]=boundedline(fS,nanmean(Spec.Fz.PFC(4:end,:)),[stdError(Spec.Fz.PFC(4:end,:));stdError(Spec.Fz.PFC(4:end,:))]','alpha'),hold on
set(hl,'Color',Cols{3}*0.7,'linewidth',2)
set(hp,'FaceColor',Cols{3})
set(gca,'Layer','top')
ylim([5 12])
legend('Ctrl','Small BBX','Big BBX')
set(gca,'FontSize',15,'linewidth',1.5)
xlabel('Frequency (Hz)')
ylabel('Power - log scale')
box off
