
cd('/media/nas6/ProjetEmbReact/transfer/')
load('Sess.mat','Sess')
Cols = {[1 0 0],[0 0 1]};
X = [1,2];
Legends = {'Saline','Chronic Flx'};
Session_type={'Hab','TestPre','Cond','TestPost'};

%% Mean OB Spectrum
GetEmbReactMiceFolderList_BM
cd('/media/nas4/ProjetEmbReact/Mouse688/20180209/ProjectEmbReact_M688_20180209_HabituationBlockedSafe_PreDrug')
load('B_Low_Spectrum.mat')


for mouse=1:length(Mouse)
    %     a=figure; a.Position=[1e3 1e3 3e3 2e3];
    Mouse_names{mouse}=['M' num2str(Mouse(mouse))];
    for sess=1:length(Session_type)
        
        if sess==1
            FolderList=HabSess;
        elseif sess==2
            FolderList=TestPreSess;
        elseif sess==3
            FolderList=CondSess;
        elseif sess==4
            FolderList=TestPostSess;
        end
        try
            Speed.(Mouse_names{mouse})=ConcatenateDataFromFolders_SB(FolderList.(Mouse_names{mouse}),'speed');
            NewSpeed_tsd=tsd(Range(Speed.(Mouse_names{mouse})) , runmean(Data(Speed.(Mouse_names{mouse})) , 7));
            MovingEpoch=thresholdIntervals(NewSpeed_tsd,3,'Direction','Above');
            MovingEpoch=thresholdIntervals(NewSpeed_tsd,25,'Direction','Below');
            MovingEpoch=mergeCloseIntervals(MovingEpoch,0.3*1e4);
            MovingEpoch=dropShortIntervals(MovingEpoch,1e4);
            
            Speed_Smoothed_Moving = Restrict(NewSpeed_tsd , MovingEpoch);
            Speed_Smoothed_Moving_Data = Data(Speed_Smoothed_Moving);
            
            HPC_Sp.(Mouse_names{mouse})=ConcatenateDataFromFolders_SB(FolderList.(Mouse_names{mouse}),'spectrum','prefix','H_Low');
            HPC_Sp_Moving = Restrict(HPC_Sp.(Mouse_names{mouse}) , MovingEpoch);
            HPC_Sp_Moving_Data = Data(HPC_Sp_Moving);
            
            [a,Theta_Frequency_Pre] = max((Spectro{3}(65:157).*HPC_Sp_Moving_Data(:,65:157))');
            Theta_Frequency = runmean(Spectro{3}(Theta_Frequency_Pre+64),3);
            Theta_Frequency_tsd = tsd(Range(HPC_Sp_Moving) , Theta_Frequency');
            
            Speed_Interpolated_Moving = Restrict(Speed_Smoothed_Moving , ts(Range(HPC_Sp_Moving)));
            Speed_Interpolated_Moving_Data = Data(Speed_Interpolated_Moving);
            
            [R,P,a,b, X.(Session_type{sess}).(Mouse_names{mouse}) , Y.(Session_type{sess}).(Mouse_names{mouse})] = PlotCorrelations_BM(Data(Speed_Interpolated_Moving)' , Theta_Frequency , 5 , 1);
            
        end
        %         subplot(1,4,sess)
        %         [R,P]=PlotCorrelations_BM(Data(Speed_Interpolated_Moving)' , Theta_Frequency , 5 , 1);
        %         xlim([0 20]); ylim([6 10]); xlabel('speed (cm/s)')
        %         if sess==1; ylabel('theta frequency (Hz)')
        %             title(Session_type{sess})
        %         end
        %         a=suptitle(['Theta/speed correlations ' Mouse_names{mouse}]); a.FontSize=20;
        disp(Session_type{sess})
    end
    disp(Mouse_names{mouse})
end



for sess=1:length(Session_type)
    subplot(1,4,sess)
    for mouse=1:length(Mouse)
        try
            All_X.(Session_type{sess})(mouse,:) = X.(Session_type{sess}).(Mouse_names{mouse});
            All_Y.(Session_type{sess})(mouse,:) = Y.(Session_type{sess}).(Mouse_names{mouse});
            plot(X.(Session_type{sess}).(Mouse_names{mouse}) , Y.(Session_type{sess}).(Mouse_names{mouse}) ,'k','Linewidth',2)
            hold on
            xlabel('Speed (cm/s)')
            if sess==1; ylabel('Theta frequency (Hz)'); end
            ylim([7 10.5]); xlim([0 25])
            makepretty
            title(Session_type{sess})
        end
    end
end
a=suptitle(['Theta/speed correlations, all mice, n=75']); a.FontSize=20;


figure
for sess=1:length(Session_type)
    
    All_X.(Session_type{sess})(All_X.(Session_type{sess})==0)=NaN;
    All_Y.(Session_type{sess})(All_Y.(Session_type{sess})==0)=NaN;
    
    subplot(1,4,sess)
    plot(nanmean(All_X.(Session_type{sess})) , nanmean(All_Y.(Session_type{sess})) ,'r','Linewidth',4)

end


Drug_Group={'SalineSB','ChronicFlx','AcuteFlx','Midazolam','SalineBM_Short','Diazepam_Short','SalineBM_Long','Diazepam_Long'};
for group=1:length(Drug_Group)
    
    Drugs_Groups_UMaze_BM
    
    for sess=1:length(Session_type)
        for mouse=1:length(Mouse)
            Mouse_names{mouse}=['M' num2str(Mouse(mouse))];
            try
                Speed.(Drug_Group{group}).(Session_type{sess})(mouse,:) = X.(Session_type{sess}).(Mouse_names{mouse});
                Theta_Frequency.(Drug_Group{group}).(Session_type{sess})(mouse,:) = Y.(Session_type{sess}).(Mouse_names{mouse});
                
                Speed.(Drug_Group{group}).(Session_type{sess})(Speed.(Drug_Group{group}).(Session_type{sess})==0)=NaN;
                Theta_Frequency.(Drug_Group{group}).(Session_type{sess})(Theta_Frequency.(Drug_Group{group}).(Session_type{sess})==0)=NaN;
            end
        end
    end
end


Col_Drugs={[0, 0, 1],[1, 0, 0],[1, 0.5, 0.5],[0, 0.5, 0],[0.3, 0.745, 0.93],[0.85, 0.325, 0.098],[0.2, 0.645, 0.83],[0.75, 0.225, 0]};
figure
for sess=1:length(Session_type)
    subplot(1,4,sess)
    for group=1:length(Drug_Group)
        
        plot(nanmean(Speed.(Drug_Group{group}).(Session_type{sess})) , nanmean(Theta_Frequency.(Drug_Group{group}).(Session_type{sess})),'Color' , Col_Drugs{group},'Linewidth',2)
        hold on
        xlabel('Speed (cm/s)')
        if sess==1; ylabel('Theta frequency (Hz)'); legend('SalineSB' ,'Chronic Flx', 'Acute Flx', 'Midazolam','Saline_Short','DZP_Short','Saline_Long','DZP_Long'); end
        ylim([7.5 10]); xlim([0 25])
        makepretty
        title(Session_type{sess})
        
    end
end
a=suptitle(['Theta/speed correlations, drugs groups']); a.FontSize=20;




