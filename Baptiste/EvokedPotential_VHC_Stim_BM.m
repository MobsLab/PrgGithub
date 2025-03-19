
clear all

GetEmbReactMiceFolderList_BM
Session_type={'Cond'};

Mouse=[1266,1267,1268,1269,1304,1305,1350,1351,1352 ,1349 , 41266,41268,41269,41305,41349,41350,41351,41352];

for mouse=1:length(Mouse)
    Mouse_names{mouse}=['M' num2str(Mouse(mouse))];
    for sess=1
        
        Sessions_List_ForLoop_BM
        
        chan_rip = Get_chan_numb_BM(CondSess.(Mouse_names{mouse}){1} , 'rip');
        Freeze_Epoch.(Mouse_names{mouse}) = ConcatenateDataFromFolders_SB(CondSess.(Mouse_names{mouse}),'epoch','epochname','freezeepoch');
        LFP_rip.(Mouse_names{mouse}) = ConcatenateDataFromFolders_SB(CondSess.(Mouse_names{mouse}),'lfp','channumber',chan_rip);
        VHC_Stim_Epoch.(Mouse_names{mouse}) = ConcatenateDataFromFolders_SB(CondSess.(Mouse_names{mouse}),'epoch','epochname','vhc_stim');
        
        VHC_Stim_Freezing.(Mouse_names{mouse}) = and(Freeze_Epoch.(Mouse_names{mouse}) , VHC_Stim_Epoch.(Mouse_names{mouse}));
        
    end
end

for mouse=1:length(Mouse)
    Mouse_names{mouse}=['M' num2str(Mouse(mouse))];
    [M.(Mouse_names{mouse}),T.(Mouse_names{mouse})] = PlotRipRaw(LFP_rip.(Mouse_names{mouse}) , Start(VHC_Stim_Freezing.(Mouse_names{mouse}))/1e4, 50, 0, 0, 0);
end

for mouse=1:length(Mouse)
    M_all(mouse,:) = M.(Mouse_names{mouse})(:,2);
end

bin_size = 625;
bin_size = 125;

figure
for mouse=1:10
    subplot(2,5,mouse)
    
    Data_To_Use = T.(Mouse_names{mouse}); %if size(Data_To_Use,1)==1; Data_To_Use=[Data_To_Use;Data_To_Use]; end
    Conf_Inter=nanstd(Data_To_Use)/sqrt(size(Data_To_Use,1));
    clear Mean_All_Sp; Mean_All_Sp=nanmean(Data_To_Use);
    shadedErrorBar([1:bin_size],Mean_All_Sp,Conf_Inter,'-k',1); hold on;
    xticks([0 bin_size/2 bin_size]); xticklabels({'-50 ms','0','+ 50 ms'})
    xlim([0 bin_size])
    if or(mouse==1 , mouse==6); ylabel('amplitude (a.u.)'); end
    vline(bin_size/2,'--r')
    
    title([Mouse_names{mouse} ', ' num2str(size(T.(Mouse_names{mouse}),1)) ' events'])
end
sgtitle('Mean LFP around VHC stims, ripples inhibition mice')

figure
for mouse=11:18
    subplot(2,5,mouse-10)
    
    Data_To_Use = T.(Mouse_names{mouse}); %if size(Data_To_Use,1)==1; Data_To_Use=[Data_To_Use;Data_To_Use]; end
    Conf_Inter=nanstd(Data_To_Use)/sqrt(size(Data_To_Use,1));
    clear Mean_All_Sp; Mean_All_Sp=nanmean(Data_To_Use);
    shadedErrorBar([1:bin_size],Mean_All_Sp,Conf_Inter,'-k',1); hold on;
    xticks([0 bin_size/2 bin_size]); xticklabels({'-50 ms','0','+ 50 ms'})
    xlim([0 bin_size])
    if or(mouse==1 , mouse==6); ylabel('amplitude (a.u.)'); end
    vline(bin_size/2,'--r')
    
    title([Mouse_names{mouse} ', ' num2str(size(T.(Mouse_names{mouse}),1)) ' events'])
end
sgtitle('Mean LFP around VHC stims, ripples control mice')







