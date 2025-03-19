clear all,
Dir=PathForExperimentFEAR('FearCBNov15');
Dir=RestrictPathForExperiment(Dir,'Session','EXT-24h-envC');
% Dir=RestrictPathForExperiment(Dir,'nMice',[,280:285:290,]);

% Dir=PathForExperimentFEAR('ManipFeb15Bulbectomie');
% Dir=RestrictPathForExperiment(Dir,'Session','EXT-24h-envC');

CSMOINS=[122 192 257 347];
CSPLUS=[408 478 628 689 789 862 927 1007 1117 1178 1256 1320];
% CSEpoch{1}=intervalSet(CSMOINS*1e4,CSMOINS*1e4+30*1e4);
% CSEpoch{2}=intervalSet(CSPLUS(1:4)*1e4,CSPLUS(1:4)*1e4+30*1e4);
% CSEpoch{3}=intervalSet(CSPLUS(5:8)*1e4,CSPLUS(5:8)*1e4+30*1e4);
% CSEpoch{4}=intervalSet(CSPLUS(9:12)*1e4,CSPLUS(9:12)*1e4+30*1e4);
CSEpoch{1}=intervalSet(122*1e4,408*1e4); % the block of four CS-
CSEpoch{2}=intervalSet(408*1e4,789*1e4); % 1st block of four CS+
CSEpoch{3}=intervalSet(789*1e4,1117*1e4); % 2nd block of four CS+
CSEpoch{4}=intervalSet(1117*1e4,1400*1e4); % 3rd block of four CS+

% CSEpoch{1}=intervalSet(CSMOINS(1)*1e4,CSMOINS(4)*1e4+30*1e4);
% CSEpoch{2}=intervalSet(CSPLUS(1)*1e4,CSPLUS(4)*1e4+30*1e4);
% CSEpoch{3}=intervalSet(CSPLUS(5)*1e4,CSPLUS(8)*1e4+30*1e4);
% CSEpoch{4}=intervalSet(CSPLUS(9)*1e4,CSPLUS(12)*1e4+30*1e4);

for mm=1:length(Dir.path)
    mm
    cd(Dir.path{mm})
    clear chH chB chP
    try, load('behavResources.mat');catch,load('Behavior.mat'); end
    for ep=1:4
        FzPerc(mm,ep)=100*length(Range(Restrict(Movtsd,and(FreezeEpoch,CSEpoch{ep}))))./length(Range(Restrict(Movtsd,CSEpoch{ep})));
    end
    
end
a=strfind(Dir.group,'OBX');
CTRL=cellfun('isempty',a);
%  PlotErrorBarN(FzPerc(CTRL==0,:))
figure
X1=[0.8:1.2:(5-0.2)];
X2=[1.2:1.2:5+0.2];
clf
hold on
b=bar(X1,nanmean(FzPerc(CTRL==1,:)),'FaceColor',[0 0 0], 'BarWidth', 0.3), hold on
b=bar(X2,nanmean(FzPerc(CTRL==0,:)),'FaceColor',[0.5 0.5 0.5], 'BarWidth', 0.3)
errorbar(X1,nanmean(FzPerc(CTRL==1,:)),stdError(FzPerc(CTRL==1,:)),'k.')
errorbar(X2,nanmean(FzPerc(CTRL==0,:)),stdError(FzPerc(CTRL==0,:)),'k.')
xlim([0.5 5.1])
set(gca,'XTick',[1,3.4],'XTickLabel',{'CS-','Cs+'},'FontSize',14,'YTick',[0:20:80])
ylabel('Freezing (%)')

%stats
if 1
    MouseNum=[CTRL;CTRL;CTRL;CTRL]';
    SessNum=[[1:4]'*ones(1,length(CTRL))]';
    [p_an,table_an,stats_an] = anovan(FzPerc(:),{MouseNum(:),SessNum(:)},'model' ,'interaction');
    [Pkw_g,table_kw_g]= kruskalwallis(FzPerc(:), MouseNum(:));
    for i=1:4
        [p(i),h(i)]=ranksum(FzPerc(CTRL,i),FzPerc(CTRL==0,i));
    end
end