% Make behaviour,spectra, coherence and granger pannels for fig1
clear all
% Get data
Dir=PathForExperimentFEARMac('Fear-electrophy');
CtrlEphys=[248,244,243,253,254,258,259,299,394,395,402,403,450,451];
%Dir=PathForExperimentFEAR('Fear-electrophy');
%CtrlEphys=[242,248,244,243,253,254,258,259,299,394,395,402,403,450,451];
Dir=RestrictPathForExperiment(Dir,'nMice',CtrlEphys);
Dir=RestrictPathForExperiment(Dir,'Session','EXT-24h');
KeepFirstSessionOnly=[1,2,4,6:length(Dir.path)];
%KeepFirstSessionOnly=[1,3,4,6,8:length(Dir.path)];

% Where to save
SaveFigFolder='/Users/sophiebagur/Dropbox/OB4Hz-manuscrit/FigTest/';
Date=date;
SaveFigFolder=[SaveFigFolder,Date,filesep];

% Get Parameters
CSMOINS=[122 192 257 347];
CSPLUS=[408 478 628 689 789 862 927 1007 1117 1178 1256 1320];
CSEpoch{1}=intervalSet(CSMOINS*1e4,CSMOINS*1e4+60*1e4);
CSEpoch{2}=intervalSet(CSPLUS(1:4)*1e4,CSPLUS(1:4)*1e4+60*1e4);
CSEpoch{3}=intervalSet(CSPLUS(5:8)*1e4,CSPLUS(5:8)*1e4+60*1e4);
CSEpoch{4}=intervalSet(CSPLUS(9:12)*1e4,CSPLUS(9:12)*1e4+60*1e4);
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
b=bar([2:4],mean(FzPerc(:,2:4)));set(b,'FaceColor',[0.8 0.8 0.8]/2), hold on
errorbar([2:4],mean(FzPerc(:,2:4)),stdError(FzPerc(:,2:4)),'.k')
ylim([0 85])
box off
set(gca,'XTick',[1,3],'XTickLabel',{'CS-','Cs+'},'FontSize',14,'YTick',[0:20:80])
ylabel('Freezing (%)')
for j=1:3
[hpost{j},p1post{j},cipost{j},statspost{j}]=ttest(FzPerc(:,1),FzPerc(:,j+1));
end
[panova,anovatab,statsanova] = anova1(FzPerc,[],0);
saveas(fig,[SaveFigFolder,'OverallBehav.fig'])
save([SaveFigFolder,'OverallBehav.mat'],'hpost','p1post','cipost','statspost',...
    'panova','anovatab','statsanova')
