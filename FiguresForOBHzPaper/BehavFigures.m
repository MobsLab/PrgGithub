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
CSEpoch{1}=intervalSet(CSMOINS*1e4,CSMOINS*1e4+60*1e4);
CSEpoch{2}=intervalSet(CSPLUS(1:4)*1e4,CSPLUS(1:4)*1e4+60*1e4);
CSEpoch{3}=intervalSet(CSPLUS(5:8)*1e4,CSPLUS(5:8)*1e4+60*1e4);
CSEpoch{4}=intervalSet(CSPLUS(9:12)*1e4,CSPLUS(9:12)*1e4+60*1e4);
SaveToName='/home/vador/Dropbox/MOBS_workingON/OB4Hz-manuscrit/Fig1/';
KeepFirstSessionOnly=[1,3,4,6,8:length(Dir.path)];
num=1;
for mm=KeepFirstSessionOnly
    mm
    cd(Dir.path{mm})
    clear chH chB chP
    %©load('StateEpoch.mat')
    load('behavResources.mat')
    for ep=1:4
        FzPerc(num,ep)=100*length(Range(Restrict(Movtsd,and(FreezeEpoch,CSEpoch{ep}))))./length(Range(Restrict(Movtsd,CSEpoch{ep})));
    end
    num=num+1;
end

fig=figure;
b=bar(1,mean(FzPerc(:,1)));set(b,'FaceColor',[0.4 0.4 0.4]*2), hold on
errorbar(1,mean(FzPerc(:,1)),stdError(FzPerc(:,1)),'k')
b=bar([2:4],nanmean(FzPerc(:,2:4)));set(b,'FaceColor',[0.8 0.8 0.8]/2), hold on
errorbar([2:4],nanmean(FzPerc(:,2:4)),stdError(FzPerc(:,2:4)),'.k')
ylim([0 85])
box off
set(gca,'XTick',[1,3],'XTickLabel',{'CS-','Cs+'},'FontSize',14,'YTick',[0:20:80])
ylabel('Freezing (%)')
[h,p1,ci,stats1]=ttest(FzPerc(:,1),FzPerc(:,2));
[h,p2,ci,stats2]=ttest(FzPerc(:,2),FzPerc(:,3));
% sigstar({[1.1,1.9],[2.1,2.9]},[p1,p2])
saveas(fig,[SaveToName,'Behav.fig'])
saveas(fig,[SaveToName,'Behav.eps'])

%% Stats
%Overall effect - anova
[p,anovatab,stats] = anova1(FzPerc,[],0);

