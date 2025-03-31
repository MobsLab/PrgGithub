

%% PC score and freezing episodes

for s=1:3
    for mouse=1:length(Mouse)
        try
            %             for ep=1:length(Start(Epoch1.Cond{mouse,side(s)}))
            %
            %                 clear Freezing
            %                 Freezing = subset(Epoch1.Cond{mouse,side(s)} , ep);
            %                 clear D, D = Data(Restrict(PCA_score_tsd{mouse} , Freezing));
            %                 if ~isempty(D)
            %                     GlobalScoreFreezing{s}{mouse}(ep,1:size(D,1)) = D(:,1);
            %                     GlobalScoreFreezing_lin{s}{mouse}(ep,:) = interp1(linspace(0,1,size(D,1)) , D(:,1)' , linspace(0,1,100));
            %                 end
            %             end
            
            GlobalScoreFreezing{s}{mouse}(GlobalScoreFreezing{s}{mouse}==0)=NaN;
            GlobalScoreFreezing_lin{s}{mouse}(GlobalScoreFreezing_lin{s}{mouse}==0)=NaN;
            
            if ~isnan(nanmean(GlobalScoreFreezing{s}{mouse}))
                GlobalScoreFreezing_lin_all{s}(mouse,:) = nanmean(GlobalScoreFreezing_lin{s}{mouse});
%                 GlobalScoreFreezing_all{s}(mouse,:) = nanmean(GlobalScoreFreezing{s}{mouse});
            end
            
            disp(Mouse_names{mouse})
        end
    end
    GlobalScoreFreezing_lin_all{s}(GlobalScoreFreezing_lin_all{s}==0)=NaN;
end



figure
Data_to_use = zscore(GlobalScoreFreezing_lin_all{2}')';
Data_to_use([24 49],:)=NaN;
Conf_Inter=nanstd(Data_to_use)/sqrt(size(Data_to_use,1));
Mean_All_Sp=nanmean(Data_to_use);
h=shadedErrorBar(linspace(0,1,100) , runmean(Mean_All_Sp,5) , runmean(Conf_Inter,5) ,'-k',1); hold on;
color=[1 .5 .5]; h.mainLine.Color=color; h.patch.FaceColor=[1 .3 .3]; h.FaceAlpha=.5; h.edge(1).Color=color; h.edge(2).Color=color;

Data_to_use = zscore(GlobalScoreFreezing_lin_all{3}')';
Data_to_use(39,:)=NaN;
Conf_Inter=nanstd(Data_to_use)/sqrt(size(Data_to_use,1));
Mean_All_Sp=nanmean(Data_to_use);
h=shadedErrorBar(linspace(0,1,100) , runmean(Mean_All_Sp,5) , runmean(Conf_Inter,5) ,'-k',1); hold on;
color=[.5 .5 1]; h.mainLine.Color=color; h.patch.FaceColor=[.3 .3 1]; h.FaceAlpha=.5; h.edge(1).Color=color; h.edge(2).Color=color;

ylim([-.8 1]), xlabel('time (a.u.)'), ylabel('PC1 score (zscore)')
title('PC score evolution along freezing episodes')
box off
makepretty_BM
f=get(gca,'Children'); legend([f([1 5])],'Freezing shock','Freezing safe');





figure
subplot(121)
Data_to_use = GlobalScoreFreezing_lin_all{2};
Data_to_use([24 49],:)=NaN;
Conf_Inter=nanstd(Data_to_use)/sqrt(size(Data_to_use,1));
Mean_All_Sp=nanmean(Data_to_use);
h=shadedErrorBar(linspace(0,1,100) , runmean(Mean_All_Sp,5) , runmean(Conf_Inter,5) ,'-k',1); hold on;
color=[1 .5 .5]; h.mainLine.Color=color; h.patch.FaceColor=[1 .3 .3]; h.FaceAlpha=.5; h.edge(1).Color=color; h.edge(2).Color=color;

subplot(122)
Data_to_use = GlobalScoreFreezing_lin_all{3};
Data_to_use(39,:)=NaN;
Conf_Inter=nanstd(Data_to_use)/sqrt(size(Data_to_use,1));
Mean_All_Sp=nanmean(Data_to_use);
h=shadedErrorBar(linspace(0,1,100) , runmean(Mean_All_Sp,5) , runmean(Conf_Inter,5) ,'-k',1); hold on;
color=[.5 .5 1]; h.mainLine.Color=color; h.patch.FaceColor=[.3 .3 1]; h.FaceAlpha=.5; h.edge(1).Color=color; h.edge(2).Color=color;

ylim([-.8 1]), xlabel('time (a.u.)'), ylabel('PC1 score (a.u.)')
title('PC score evolution along freezing episodes')
box off
makepretty_BM
f=get(gca,'Children'); legend([f([1 5])],'Freezing shock','Freezing safe');




for s=1:3
    for mouse=1:length(Mouse)
        PC_values_beg_Fz{s}(mouse) = nanmedian(GlobalScoreFreezing_lin_all{s}(mouse,1:10));
        PC_values_end_Fz{s}(mouse) = nanmedian(GlobalScoreFreezing_lin_all{s}(mouse,90:end));
    end
end


Cols = {[1 .5 .5],[.5 .5 1]};
X = 1:2;
Legends = {'Shock','Safe'};

figure
makepretty_BM
MakeSpreadAndBoxPlot3_SB({PC_values_end_Fz{2}-PC_values_beg_Fz{2} PC_values_end_Fz{3}-PC_values_beg_Fz{3}},Cols,X,Legends,'showpoints',1,'paired',0);
ylabel('PC1 score evolution (a.u.)')

[h,p1]=ttest(PC_values_beg_Fz{2}-PC_values_end_Fz{2},zeros(1,length(PC_values_beg_Fz{2}-PC_values_end_Fz{2})));
[h,p2]=ttest(PC_values_beg_Fz{3}-PC_values_end_Fz{3},zeros(1,length(PC_values_beg_Fz{3}-PC_values_end_Fz{3})));


text([2],[1.5],'**','HorizontalAlignment','Center','BackGroundColor','none','Tag','sigstar_stars','FontSize',15);








%% PC score and ripples occurence
for sess=1:length(Session_type)
    for mouse=1:length(Mouse)
        Mouse_names{mouse}=['M' num2str(Mouse(mouse))];
        i=1;
        clear ep ind_to_use
        
        for ep=1:length(Start(Epoch1.(Session_type{sess}){mouse, 3}))
            
            % for full 1s bin
            for bin=1:ceil(((DurationEpoch(subset(Epoch1.(Session_type{sess}){mouse, 3},ep)))/(bin_size*1e4)))-1 % bin of 2s or less
                
                TIME.(Session_type{sess}).(Mouse_names{mouse})(i) = Start(subset(Epoch1.(Session_type{sess}){mouse, 3},ep))+5e3;
                i=i+1;
                
            end
        end
        disp(Mouse_names{mouse})
    end
end

for mouse=1:length(Mouse)
    clear DATA3
    DATA3 = ((DATA.(Session_type{sess}).(Mouse_names{mouse})(1:8,:)-mu')./sigma')';
    for pc=1:size(eigen_vector,2)
        for i=1:size(DATA3,1)
            ind = ~isnan(DATA3(i,:));
            PC_values{mouse}(pc,i) = eigen_vector(ind,pc)'*DATA3(i,ind)';
        end
    end
end

for mouse=1:length(Mouse)
    PCA_score_tsd{mouse} = tsd(TIME.(Session_type{sess}).(Mouse_names{mouse})' , PC_values{mouse}');
end

load('/media/nas7/ProjetEmbReact/DataEmbReact/Ripples_On_Breathing_Phase.mat', 'OutPutData2')
side=[3 5 6];
window_time=2;

for s=1:3
    for mouse=1:length(Mouse)
        try
            %             R = Range(OutPutData2.Cond.ripples.ts{mouse,side(s)});
            %             for rip=1:length(R)
            %                 SmallEp = intervalSet(R(rip)-window_time*1e4 , R(rip)+window_time*1e4);
            %                 if (sum(DurationEpoch(and(SmallEp , Epoch1.Cond{mouse,3})))/1e4)==2*window_time
            %                     clear D, D = Data(Restrict(PCA_score_tsd{mouse} , SmallEp));
            %                     if ~isempty(D)
            %                         GlobalScoreAroundRipples{s}{mouse}(rip,:) = interp1(linspace(0,1,size(D,1)) , D(:,1)' , linspace(0,1,20));
            %                     end
            %                 end
            %             end
            %             try, GlobalScoreAroundRipples{s}{mouse}(GlobalScoreAroundRipples{s}{mouse}==0)=NaN; end
            if ~isnan(nanmean(GlobalScoreAroundRipples{s}{mouse}))
                GlobalScoreAroundRipples_All{s}(mouse,:) = nanmean(GlobalScoreAroundRipples{s}{mouse});
            end
            disp(Mouse_names{mouse})
        end
    end
    GlobalScoreAroundRipples_All{s}(GlobalScoreAroundRipples_All{s}==0)=NaN;
end

figure
subplot(121)
GlobalScoreAroundRipples_All{2}([12 43],:)=NaN;
Data_to_use = GlobalScoreAroundRipples_All{2};
Conf_Inter=nanstd(Data_to_use)/sqrt(size(Data_to_use,1));
Mean_All_Sp=nanmean(Data_to_use);
h=shadedErrorBar(linspace(-window_time,window_time,20) , runmean(Mean_All_Sp,3) , runmean(Conf_Inter,3) ,'-k',1); hold on;
color=[1 .5 .5]; h.mainLine.Color=color; h.patch.FaceColor=[1 .3 .3]; h.FaceAlpha=.5; h.edge(1).Color=color; h.edge(2).Color=color;
h=vline(0,'--r'); set(h,'LineWidth',2)
makepretty_BM
xlabel('time (s)'), ylabel('PC1 score (a.u.)'), ylim([-.1 .7])

subplot(122)
Data_to_use = GlobalScoreAroundRipples_All{3};
Conf_Inter=nanstd(Data_to_use)/sqrt(size(Data_to_use,1));
Mean_All_Sp=nanmean(Data_to_use);
h=shadedErrorBar(linspace(-window_time,window_time,20) , runmean(Mean_All_Sp,3) , runmean(Conf_Inter,3) ,'-k',1); hold on;
color=[.5 .5 1]; h.mainLine.Color=color; h.patch.FaceColor=[.3 .3 1]; h.FaceAlpha=.5; h.edge(1).Color=color; h.edge(2).Color=color;
h=vline(0,'--r'); set(h,'LineWidth',2)
xlabel('time (s)'), ylim([-1.6 -.8])




figure
subplot(121)
GlobalScoreAroundRipples_All{2}([12 43],:)=NaN;
Data_to_use = zscore(GlobalScoreAroundRipples_All{2}')';
Conf_Inter=nanstd(Data_to_use)/sqrt(size(Data_to_use,1));
Mean_All_Sp=nanmean(Data_to_use);
h=shadedErrorBar(linspace(-window_time,window_time,20) , runmean(Mean_All_Sp,3) , runmean(Conf_Inter,3) ,'-k',1); hold on;
color=[1 .5 .5]; h.mainLine.Color=color; h.patch.FaceColor=[1 .3 .3]; h.FaceAlpha=.5; h.edge(1).Color=color; h.edge(2).Color=color;
h=vline(0,'--r'); set(h,'LineWidth',2)
makepretty_BM
xlabel('time (s)'), ylabel('PC1 score (zscore)'), %ylim([-.1 .7])

subplot(122)
Data_to_use = zscore(GlobalScoreAroundRipples_All{3}')';
Conf_Inter=nanstd(Data_to_use)/sqrt(size(Data_to_use,1));
Mean_All_Sp=nanmean(Data_to_use);
h=shadedErrorBar(linspace(-window_time,window_time,20) , runmean(Mean_All_Sp,3) , runmean(Conf_Inter,3) ,'-k',1); hold on;
color=[.5 .5 1]; h.mainLine.Color=color; h.patch.FaceColor=[.3 .3 1]; h.FaceAlpha=.5; h.edge(1).Color=color; h.edge(2).Color=color;
h=vline(0,'--r'); set(h,'LineWidth',2)
xlabel('time (s)'), %ylim([-1.6 -.8])
makepretty_BM








