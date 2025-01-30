
clear all

GetEmbReactMiceFolderList_BM
load('/media/nas6/ProjetEmbReact/DataEmbReact/Create_Behav_Drugs_BM.mat','Epoch1')
Session_type={'Fear','Cond','Ext','CondPre','CondPost','TestPre','TestPost'};
Side={'All','Shock','Safe'};
Side_ind=[3,5,6];
Drug_Group={'SalineSB','ChronicFlx','AcuteFlx','Midazolam','SalineBM_Short','Diazepam_Short','SalineBM_Long','Diazepam_Long','Saline1','Saline2','DZP1','DZP2','RipInhib','ChronicBUS','AcuteBUS','RipControl','RipInhib1','RipControl1','RipInhibPaired','RipControlPaired'};
Group=[9 11 18 17];

Cols = {'m','c'};
Cols2={'k','r','b'};


for sess=1:length(Session_type)
    for mouse=1:length(Mouse)
        for side=1:length(Side)
            FreezingTime.(Session_type{sess}).(Side{side}).(Mouse_names{mouse}) = (Stop(Epoch1.(Session_type{sess}){mouse , Side_ind(side)}) - Start(Epoch1.(Session_type{sess}){mouse , Side_ind(side)}))/1e4;
        end
    end
end

for sess=1:length(Session_type)
    n=1;
    for group=Group
        Drugs_Groups_UMaze_BM
        for mouse=1:length(Mouse)
            Mouse_names{mouse}=['M' num2str(Mouse(mouse))];
            for side=1:length(Side)
                
                FreezingTimeAll.(Session_type{sess}).(Side{side}){n}{mouse} = FreezingTime.(Session_type{sess}).(Side{side}).(Mouse_names{mouse});
                h = histogram(FreezingTimeAll.(Session_type{sess}).(Side{side}){n}{mouse} , 'BinLimits',[0 20],'NumBins',30);
                Freezing_Distrib.(Session_type{sess}).(Side{side}){n}(mouse,:) = h.Values;
                
            end
        end
        n=n+1;
    end
end




for sess=[4 5 3]
    figure; n=1;
    for group=Group
        subplot(2,2,n)
        for side=2:3
            
            Conf_Inter=nanstd(Freezing_Distrib.(Session_type{sess}).(Side{side}){n})/sqrt(size(Freezing_Distrib.(Session_type{sess}).(Side{side}){n},1));
            shadedErrorBar([1:30] , nanmean(Freezing_Distrib.(Session_type{sess}).(Side{side}){n}),Conf_Inter,Cols2{side},1); hold on;
            hold on
            
        end
        makepretty
        if sess==1
            ylim([0 20])
        else
            ylim([0 10])
        end
        xticks([0:7.5:30]); xticklabels({'0','5','10','15','20'})
        title(Drug_Group{group})
        if n>4; xlabel('time (s)'); end
        if or(n==1,n==3); ylabel('episodes number (#)'); end
        n=n+1;
    end
    a=suptitle(['Freezing times distribution, ' Session_type{sess}]); a.FontSize=20;
end


for sess=[4 5 3]
    figure;
    for side=1:3; n=1;
        subplot(2,3,side)
        for group=[9 11]
            
            Conf_Inter=nanstd(Freezing_Distrib.(Session_type{sess}).(Side{side}){n})/sqrt(size(Freezing_Distrib.(Session_type{sess}).(Side{side}){n},1));
            shadedErrorBar([1:30] , nanmean(Freezing_Distrib.(Session_type{sess}).(Side{side}){n}) , Conf_Inter,Cols{n},1); hold on;
            hold on
            
            n=n+1;
        end
        makepretty
        xticks([0:7.5:30]); xticklabels({'0','5','10','15','20'}); %ylim([0 ~])
        title((Side{side}))
        if side==1; f=get(gca,'Children'); a=legend([f(5),f(1)],'Saline','DZP'); end
%         [h,p]=ttest(Freezing_Distrib.(Session_type{sess}).(Side{side}){1},Freezing_Distrib.(Session_type{sess}).(Side{side}){2});

        
        subplot(2,3,side+3)
        for group=[18 17]
            
            Conf_Inter=nanstd(Freezing_Distrib.(Session_type{sess}).(Side{side}){n})/sqrt(size(Freezing_Distrib.(Session_type{sess}).(Side{side}){n},1));
            shadedErrorBar([1:30] , nanmean(Freezing_Distrib.(Session_type{sess}).(Side{side}){n}),Conf_Inter,Cols{n-2},1); hold on;
            hold on
            
            n=n+1;
        end
        makepretty
        xticks([0:7.5:30]); xticklabels({'0','5','10','15','20'})
        if side==1; f=get(gca,'Children'); a=legend([f(5),f(1)],'RipControl','RipInhib'); end
    end
    a=suptitle(['Distribution time freezing, ' Session_type{sess}]); a.FontSize=20;
end


I=1:30;
for sess=[4 5 3]
    figure;
    for side=1:3; n=1;
        subplot(2,3,side)
        for group=[9 11]
            
            Data_to_use = [1:30].*Freezing_Distrib.(Session_type{sess}).(Side{side}){n};
            Conf_Inter=nanstd(Data_to_use)/sqrt(size(Data_to_use,1));
            clear Mean_All_Sp; Mean_All_Sp=nanmean(Data_to_use);
            shadedErrorBar([1:30] , Mean_All_Sp ,Conf_Inter,Cols{n},1); hold on;
            
            n=n+1;
        end
        makepretty
        xticks([0:7.5:30]); xticklabels({'0','5','10','15','20'}); ylim([0 inf])
        title((Side{side}))
        if side==1; f=get(gca,'Children'); a=legend([f(5),f(1)],'Saline','DZP'); ylabel('episodes # x time'); end
    [h,p]=ttest2(Freezing_Distrib.(Session_type{sess}).(Side{side}){1} , Freezing_Distrib.(Session_type{sess}).(Side{side}){2});
        plot(I(p<.05) , )
        
        subplot(2,3,side+3)
        for group=[18 17]
            
            Data_to_use = [1:30].*Freezing_Distrib.(Session_type{sess}).(Side{side}){n};
            Conf_Inter=nanstd(Data_to_use)/sqrt(size(Data_to_use,1));
            clear Mean_All_Sp; Mean_All_Sp=nanmean(Data_to_use);
            shadedErrorBar([1:30] , Mean_All_Sp ,Conf_Inter,Cols{n-2},1); hold on;
            
            n=n+1;
        end
        makepretty
        xticks([0:7.5:30]); xticklabels({'0','5','10','15','20'}); ylim([0 inf])
        xlabel('time (s)')
        if side==1; f=get(gca,'Children'); a=legend([f(5),f(1)],'RipControl','RipInhib'); ylabel('episodes # x time'); end
    [h,p]=ttest2(Freezing_Distrib.(Session_type{sess}).(Side{side}){3} , Freezing_Distrib.(Session_type{sess}).(Side{side}){4});
    end
    a=suptitle(['Distribution time freezing, ' Session_type{sess}]); a.FontSize=20;
end



for i=1:30
    [h(i),p(i)]=ttest2(Freezing_Distrib.(Session_type{sess}).(Side{side}){1}(:,i) , Freezing_Distrib.(Session_type{sess}).(Side{side}){2}(:,i));
end
    [h,p]=ttest2(Freezing_Distrib.(Session_type{sess}).(Side{side}){1} , Freezing_Distrib.(Session_type{sess}).(Side{side}){2});



%% Other binning system
figure
for sess=1:length(Session_type)
    n=1;
    for group=Group
        Drugs_Groups_UMaze_BM
        for mouse=1:length(Mouse)
            Mouse_names{mouse}=['M' num2str(Mouse(mouse))];
            for side=1:length(Side)
                
                FreezingTimeAll.(Session_type{sess}).(Side{side}){n}{mouse} = FreezingTime.(Session_type{sess}).(Side{side}).(Mouse_names{mouse});
                h = histogram(FreezingTimeAll.(Session_type{sess}).(Side{side}){n}{mouse} , 'BinLimits',[0 100],'NumBins',100);
                Freezing_Distrib2.(Session_type{sess}).(Side{side}){n}(mouse,:) = h.Values;
                
            end
        end
        n=n+1;
    end
end



for sess=[4 5 3]
    figure;
    for side=1:3; n=1;
        subplot(2,3,side)
        for group=[9 11]
            
            Data_to_use = [1:100].*Freezing_Distrib2.(Session_type{sess}).(Side{side}){n};
            Conf_Inter=nanstd(Data_to_use)/sqrt(size(Data_to_use,1));
            clear Mean_All_Sp; Mean_All_Sp=nanmean(Data_to_use);
            shadedErrorBar([1:100] , Mean_All_Sp ,Conf_Inter,Cols{n},1); hold on;
            
            n=n+1;
        end
        makepretty
        xticks([0:25:100]); xticklabels({'0','25','50','75','100'}); ylim([0 inf])
        title((Side{side}))
        if side==1; f=get(gca,'Children'); a=legend([f(5),f(1)],'Saline','DZP'); ylabel('episodes # x time'); end
        %         [h,p]=ttest(Freezing_Distrib2.(Session_type{sess}).(Side{side}){1},Freezing_Distrib2.(Session_type{sess}).(Side{side}){2});
        
        
        subplot(2,3,side+3)
        for group=[18 17]
            
            Data_to_use = [1:100].*Freezing_Distrib2.(Session_type{sess}).(Side{side}){n};
            Conf_Inter=nanstd(Data_to_use)/sqrt(size(Data_to_use,1));
            clear Mean_All_Sp; Mean_All_Sp=nanmean(Data_to_use);
            shadedErrorBar([1:100] , Mean_All_Sp ,Conf_Inter,Cols{n-2},1); hold on;
            
            n=n+1;
        end
        makepretty
        xticks([0:25:100]); xticklabels({'0','25','50','75','100'}); ylim([0 inf])
        xlabel('time (s)')
        if side==1; f=get(gca,'Children'); a=legend([f(5),f(1)],'RipControl','RipInhib'); ylabel('episodes # x time'); end
    end
    a=suptitle(['Distribution time freezing, ' Session_type{sess}]); a.FontSize=20;
end











