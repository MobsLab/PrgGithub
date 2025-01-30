
for group=Group
    Mouse=Drugs_Groups_UMaze_BM(group);
    for sess=1:length(Session_type)
        for mouse=1:length(Mouse)
            Mouse_names{mouse}=['M' num2str(Mouse(mouse))];
            
            Sessions_List_ForLoop_BM
            
%                 StimEpoch.(Session_type{sess}).(Mouse_names{mouse}) = ConcatenateDataFromFolders_SB(FolderList.(Mouse_names{mouse}),'epoch','epochname','stimepoch');
            for i=1:100
                SmallEp = intervalSet((i-1)*60e4 , i*60e4);
                
%                 STIM_Number(mouse,i) = length(Start(and(StimEpoch.(Session_type{sess}).(Mouse_names{mouse}) , and(SmallEp , Active_Unblocked.(Mouse_names{mouse})))));
%                 RESPI_Safe(mouse,i) = nanmean(Data(Restrict(OutPutData.Cond.respi_freq_bm.tsd{mouse,6} , SmallEp)));
                HR_Safe(mouse,i) = nanmean(Data(Restrict(OutPutData.Cond.heartrate.tsd{mouse,6} , SmallEp)));
            end
            disp(Mouse_names{mouse})
        end
    end
end
RESPI_Safe(:,[26:29 34:37 42:45]) = NaN;
RESPI_Safe(RESPI_Safe<1.5)=NaN;
HR_Safe(:,[26:29 34:37 42:45]) = NaN;
HR_Safe(51,35) = NaN;
HR_Safe(HR_Safe<7)=NaN;

figure
Data_to_use = STIM_Number;
Conf_Inter=nanstd(Data_to_use)/sqrt(size(Data_to_use,1));
Mean_All_Sp=nanmean(Data_to_use);
yyaxis left
shadedErrorBar([1:100] , movmean(Mean_All_Sp,4,'omitnan') , movmean(Conf_Inter,4,'omitnan') ,'-b',1); hold on;
xlabel('time (min)'), ylabel('shocks (#/min)')
xlim([0 71]), box off, ylim([0 1.4])

Data_to_use = RESPI_Safe;
Conf_Inter=nanstd(Data_to_use)/sqrt(size(Data_to_use,1));
Mean_All_Sp=nanmean(Data_to_use);
yyaxis right
shadedErrorBar([1:100] , movmean(Mean_All_Sp,4,'omitnan') , movmean(Conf_Inter,4,'omitnan') ,'-r',1); hold on;
xlabel('time (min)'), ylabel('Breathing (Hz)')
ylim([2.8 4.7])



figure
Data_to_use = STIM_Number;
Conf_Inter=nanstd(Data_to_use)/sqrt(size(Data_to_use,1));
Mean_All_Sp=nanmean(Data_to_use);
yyaxis left
shadedErrorBar([1:100] , movmean(Mean_All_Sp,4,'omitnan') , movmean(Conf_Inter,4,'omitnan') ,'-b',1); hold on;
xlabel('time (min)'), ylabel('shocks (#/min)')
xlim([0 71]), box off, ylim([0 1.4])

Data_to_use = HR_Safe;
Conf_Inter=nanstd(Data_to_use)/sqrt(size(Data_to_use,1));
Mean_All_Sp=nanmean(Data_to_use);
yyaxis right
shadedErrorBar([1:100] , movmean(Mean_All_Sp,4,'omitnan') , movmean(Conf_Inter,4,'omitnan') ,'-r',1); hold on;
xlabel('time (min)'), ylabel('Heart rate (Hz)')
ylim([10 13])



figure
imagesc(RESPI_Safe)
xlabel('time (min)')
ylabel('mice #')
colorbar
colormap viridis




imagesc(HR_Safe)
caxis([10 13])






