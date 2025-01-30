clear all,
Dir=PathForExperimentFEAR('FearCBNov15');
Dir=RestrictPathForExperiment(Dir,'Session','EXT-24h-envC');
% Dir=RestrictPathForExperiment(Dir,'nMice',[,280:285:290,]);

%%  to check the influence of 2mice already hyperactive on day 'post' (272 and 274)
if 0 %
Dir.path([4 6])=[];Dir.group([4 6])=[];Dir.name([4 6])=[];Dir.manipe([4 6])=[];Dir.Session([4 6])=[];Dir.Treatment([4 6])=[];%CorrecAmpli([4 6])=[];
end

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

%% figure where CS+1, 2, 3 are averaged
if 0
    X1=[0.8:1.2:(3-0.2)];
X2=[1.2:1.2:3+0.2];
    fig_av123=figure; 
    FzPerc_av=nan(size(FzPerc,1),1);
    FzPerc_av(:,1)=FzPerc(:,1);
    FzPerc_av(:,2)=nanmean(FzPerc(:,2:4),2);
    b=bar(X1,nanmean(FzPerc_av(CTRL==1,:)),'FaceColor',[0 0 0], 'BarWidth', 0.3), hold on
    b=bar(X2,nanmean(FzPerc_av(CTRL==0,:)),'FaceColor',[0.5 0.5 0.5], 'BarWidth', 0.3)
    errorbar(X1,nanmean(FzPerc_av(CTRL==1,:)),stdError(FzPerc_av(CTRL==1,:)),'k.')
    errorbar(X2,nanmean(FzPerc_av(CTRL==0,:)),stdError(FzPerc_av(CTRL==0,:)),'k.')
    xlim([0.5 3.1])
    set(gca,'XTick',[1,2.2],'XTickLabel',{'CS-','Cs+'},'FontSize',14,'YTick',[0:10:40])
    ylabel('Freezing (%)')

     MouseNum=[CTRL;CTRL]';
    SessNum=[[1:2]'*ones(1,length(CTRL))]';
    [p_an,table_an,stats_an] = anovan(FzPerc_av(:),{MouseNum(:),SessNum(:)},'model' ,'interaction');
    [Pkw_g,table_kw_g]= kruskalwallis(FzPerc_av(:), MouseNum(:));
    for i=1:2
        [p(i),h(i)]=ranksum(FzPerc_av(CTRL,i),FzPerc_av(CTRL==0,i));
    end
    figure(fig_av123)
    title(['ANOVA p CS+/-' sprintf('%0.3f',p_an(1)) ' p sham/obx ' sprintf('%0.3f',p_an(2)) ' p int ' sprintf('%0.3f',p_an(3))])
    xlabel([' ranksum ' sprintf('%0.3f',p(1))  '   '  sprintf('%0.3f',p(2))  ])
    
    cd /home/mobs/Dropbox/SophiesOB4HzManusciptFolder/Fig5
    save data_CSplus_123_averaged  FzPerc_av p_an table_an stats_an Pkw_g table_kw_g
    saveas(fig_av123,'fig_CSplus_123_averaged.fig')
    res=pwd;
    saveFigure(fig_av123,'figCSplus_123_averaged',res)
    
    
    fig_av123_=figure; 
    
    PlotErrorSpreadN_KJ([FzPerc_av(CTRL==1,1) FzPerc_av(CTRL==0,1) FzPerc_av(CTRL==1,2) FzPerc_av(CTRL==0,2) ],'plotcolors',{[0.7 0.7 0.7],[0 0 0 ], [0.7 0.7 0.7],[0 0 0 ]},'newfig',0,'markersize',15);hold on
    set(gca,'XTick',[1.5 3.5],'XTickLabel',{'CS-','Cs+'},'FontSize',14)
    ylabel('Freezing (%)')
    title(['ANOVA p CS+/-' sprintf('%0.3f',p_an(1)) ' p sham/obx ' sprintf('%0.3f',p_an(2)) ' p int ' sprintf('%0.3f',p_an(3))])
    xlabel([' ranksum ' sprintf('%0.3f',p(1))  '   '  sprintf('%0.3f',p(2))  ])
    
    cd /home/mobs/Dropbox/SophiesOB4HzManusciptFolder/Fig5
    saveas(fig_av123,'fig_CSplus_123_averaged_spread.fig')
    res=pwd;
    saveFigure(fig_av123,'figCSplus_123_averaged_spread',res)
end



%% figure without 2_obx_mice_already_hyperactive at 'post-fear'
if 0
    cd /home/mobs/Dropbox/SophiesOB4HzManusciptFolder/Fig5
    saveas(gcf,'fig without 2 obx mice already hyperactive.fig')
    res=pwd;
    saveFigure(gcf,'fig_without_2_obx_mice_already_hyperactive',res)
    for k=1:4
        p_rk{k}=ranksum(FzPerc(CTRL==1,k), FzPerc(CTRL==0,k));
    end
    title('fig without 2 obx mice already hyperactive on day post (272 and 274)')
    xlabel(['p= ' sprintf('%0.3f',p_rk{1}) ' ' sprintf('%0.3f',p_rk{2}) ' ' sprintf('%0.3f',p_rk{3}) ' ' sprintf('%0.3f',p_rk{4})])
    save data_without_2_obx_mice_already_hyperactive
    
end

%% Fig HAB
clear all,
Dir=PathForExperimentFEAR('FearCBNov15');
Dir=RestrictPathForExperiment(Dir,'Session','HAB-NaN');
cd(Dir.path{1})
load Behavior StimInfo

int=intervalSet(StimInfo(1:end-1,1),StimInfo(2:end,1));
int2=dropShortIntervals(int,2);
CSEpoch{2}=subset(int2,[1 3 5 7]);
CSEpoch{1}=subset(int2,[2 4 6 8]);
for mm=1:length(Dir.path)
    mm
    cd(Dir.path{mm})
    try, load('behavResources.mat');catch,load('Behavior.mat'); end
    for ep=1:2
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