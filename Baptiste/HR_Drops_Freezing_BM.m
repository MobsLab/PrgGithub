
%% HR drops
load('/media/nas7/ProjetEmbReact/DataEmbReact/HR_Temporal_Evol.mat')

Mouse=Drugs_Groups_UMaze_BM(19);
Session_type={'CondPre','CondPost','Ext'};
for sess=3:length(Session_type)
    [OutPutData.(Session_type{sess}) , Epoch1.(Session_type{sess}) , NameEpoch] = MeanValuesPhysiologicalParameters_BM('all_saline',Mouse,lower(Session_type{sess}),...
        'heartrate');
end

for sess=1:length(Session_type)
    for mouse=1:length(Mouse)
        for bin=1:10
            try
                clear St, St = Start(Epoch1.(Session_type{sess}){mouse,5});
                for ep=1:length(St)
                    try
                        SmallEp = and(subset(Epoch1.(Session_type{sess}){mouse,5},ep) , intervalSet(St(ep) , St(ep)+bin*1e4));
                        if DurationEpoch(SmallEp)==bin*1e4
                            clear D, D = Data(Restrict(OutPutData.(Session_type{sess}).heartrate.tsd{mouse,1} , SmallEp));
                            HR_Shock.(Session_type{sess}){mouse}{bin}(ep,:) = interp1(linspace(0,1,length(D)) , D' , linspace(0,1,10*bin));
                        end
                    end
                end
                HR_Shock.(Session_type{sess}){mouse}{bin}(HR_Shock.(Session_type{sess}){mouse}{bin}==0)=NaN;
                clear D, D = nanmean(HR_Shock.(Session_type{sess}){mouse}{bin});
                HR_Shock_all.(Session_type{sess}){bin}(mouse,1:length(D)) = D;
            end
            
            try
                clear St, St = Start(Epoch1.(Session_type{sess}){mouse,6});
                for ep=1:length(St)
                    try
                        SmallEp = and(subset(Epoch1.(Session_type{sess}){mouse,6},ep) , intervalSet(St(ep) , St(ep)+bin*1e4));
                        if DurationEpoch(SmallEp)==bin*1e4
                            clear D, D = Data(Restrict(OutPutData.(Session_type{sess}).heartrate.tsd{mouse,1} , SmallEp));
                            HR_Safe.(Session_type{sess}){mouse}{bin}(ep,1:length(D)) = interp1(linspace(0,1,10*bin) , D , linspace(0,1,length(D)));
                        end
                    end
                end
                HR_Safe.(Session_type{sess}){mouse}{bin}(HR_Safe.(Session_type{sess}){mouse}{bin}==0)=NaN;
                clear D, D = nanmean(HR_Safe.(Session_type{sess}){mouse}{bin});
                HR_Safe_all.(Session_type{sess}){bin}(mouse,1:length(D)) = D;
            end
        end
        disp(mouse)
    end
    for bin=1:10
        try, HR_Shock_all.(Session_type{sess}){bin}(HR_Shock_all.(Session_type{sess}){bin}==0)=NaN; end
        try, HR_Safe_all.(Session_type{sess}){bin}(HR_Safe_all.(Session_type{sess}){bin}==0)=NaN; end
    end
end



figure
for sess=1:3
    subplot(1,3,sess)
    Data_to_use = HR_Shock_all.(Session_type{sess});
    Conf_Inter=nanstd(Data_to_use)/sqrt(size(Data_to_use,1));
    Mean_All_Sp=nanmean(Data_to_use);
    h=shadedErrorBar(linspace(0,10,size(HR_Shock_all.(Session_type{sess}),2)) , runmean(Mean_All_Sp,10) , runmean(Conf_Inter,10) ,'-k',1); hold on;
    color= [1 .5 .5]; h.mainLine.Color=color; h.patch.FaceColor=[1 .3 .3]; h.edge(1).Color=color; h.edge(2).Color=color;
    Data_to_use = HR_Safe_all.(Session_type{sess});
    Conf_Inter=nanstd(Data_to_use)/sqrt(size(Data_to_use,1));
    Mean_All_Sp=nanmean(Data_to_use);
    h=shadedErrorBar(linspace(0,10,size(HR_Safe_all.(Session_type{sess}),2)) , runmean(Mean_All_Sp,10) , runmean(Conf_Inter,10) ,'-k',1); hold on;
    color= [.5 .5 1]; h.mainLine.Color=color; h.patch.FaceColor=[.3 .3 1]; h.edge(1).Color=color; h.edge(2).Color=color;
end

figure
for sess=1:3
    subplot(1,3,sess)
    Data_to_use = HR_Shock_all.(Session_type{sess})-nanmean(HR_Shock_all.(Session_type{sess})')';
    Conf_Inter=nanstd(Data_to_use)/sqrt(size(Data_to_use,1));
    Mean_All_Sp=nanmean(Data_to_use);
    h=shadedErrorBar(linspace(0,10,size(HR_Shock_all.(Session_type{sess}),2)) , runmean(Mean_All_Sp,10) , runmean(Conf_Inter,10) ,'-k',1); hold on;
    color= [1 .5 .5]; h.mainLine.Color=color; h.patch.FaceColor=[1 .3 .3]; h.edge(1).Color=color; h.edge(2).Color=color;
    Data_to_use = HR_Safe_all.(Session_type{sess})-nanmean(HR_Safe_all.(Session_type{sess})')';
    Conf_Inter=nanstd(Data_to_use)/sqrt(size(Data_to_use,1));
    Mean_All_Sp=nanmean(Data_to_use);
    h=shadedErrorBar(linspace(0,10,size(HR_Safe_all.(Session_type{sess}),2)) , runmean(Mean_All_Sp,10) , runmean(Conf_Inter,10) ,'-k',1); hold on;
    color= [.5 .5 1]; h.mainLine.Color=color; h.patch.FaceColor=[.3 .3 1]; h.edge(1).Color=color; h.edge(2).Color=color;
end


figure
for sess=1:3
    subplot(2,3,sess)
    for bin=1:10
        plot(runmean(nanmean(HR_Shock_all.(Session_type{sess}){bin}-nanmean(HR_Shock_all.(Session_type{sess}){bin}(:,1:3)')') , 2*bin) , 'Color' , [1 .5 .5]), hold on
    end
    ylim([-2.5 .2])
    
    subplot(2,3,sess+3)
    for bin=1:10
        plot(runmean(nanmean(HR_Safe_all.(Session_type{sess}){bin}-nanmean(HR_Safe_all.(Session_type{sess}){bin}(:,1:3)')') , 2*bin) , 'Color' , [.5 .5 1]), hold on
    end
    ylim([-2.5 .2])
end
