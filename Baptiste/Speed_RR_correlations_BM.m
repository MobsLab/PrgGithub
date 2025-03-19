
clear all
GetEmbReactMiceFolderList_BM
Session_type={'TestPre','Cond','TestPost','Ext'};
Drug_Group={'SalineSB','ChronicFlx','AcuteFlx','Midazolam','SalineBM_Short','Diazepam_Short','RipSham','RipInhib','PAG','All_eyelid','All_saline','Elisa','Saline_short','Saline2','DZP_short','DZP2','AcuteBUS','RipControl','RipInhib1','RipControl1','RipInhibPaired','RipControlPaired','Sal_Maze1_1stMaze','Sal_Maze4_1stMaze','DZP_Maze1_1stMaze','DZP_Maze4_1stMaze'};

X = 1:8;
Cols = {[0, 0, 1],[1, 0, 0],[1, 0.5, 0.5],[0, 0.5, 0],[0.3, 0.745, 0.93],[0.85, 0.325, 0.098],[0.2, 0.645, 0.83],[0.75, 0.225, 0]};
Legends ={'SalineSB' 'Chronic Flx' 'Acute Flx' 'Midazolam','Saline_Short','DZP_Short','Saline_Long','DZP_Long'};
NoLegends ={'', '', '', '','','','',''};

% Group=[1:4 13 15];
% Group=[1 2];
Group=[13,15];
Param={'Respi','HR','HRVar','Acc'};
size_map = 100;

for sess=1:length(Session_type)
    Sessions_List_ForLoop_BM
    for group=Group
        Mouse=Drugs_Groups_UMaze_BM(group);
        for mouse=1:length(Mouse)
            Mouse_names{mouse}=['M' num2str(Mouse(mouse))];
            
            Speed.(Session_type{sess}).(Mouse_names{mouse}) = ConcatenateDataFromFolders_SB(FolderList.(Mouse_names{mouse}),'speed');
%             Respi.(Session_type{sess}).(Mouse_names{mouse}) = ConcatenateDataFromFolders_SB(FolderList.(Mouse_names{mouse}),'respi_freq_bm');
            Respi.(Session_type{sess}).(Mouse_names{mouse}) = ConcatenateDataFromFolders_SB(FolderList.(Mouse_names{mouse}),'instfreq','suffix_instfreq','B','method','WV');
            HeartRate.(Session_type{sess}).(Mouse_names{mouse}) = ConcatenateDataFromFolders_SB(FolderList.(Mouse_names{mouse}),'heartrate');
            HeartRateVar.(Session_type{sess}).(Mouse_names{mouse}) = ConcatenateDataFromFolders_SB(FolderList.(Mouse_names{mouse}),'heartratevar');
            Accelero.(Session_type{sess}).(Mouse_names{mouse}) = ConcatenateDataFromFolders_SB(FolderList.(Mouse_names{mouse}),'accelero');
            
            TotalEpoch.(Session_type{sess}).(Mouse_names{mouse}) = intervalSet(0 , max(Range(Speed.(Session_type{sess}).(Mouse_names{mouse}))));
            BlockedEpoch.(Session_type{sess}).(Mouse_names{mouse}) = ConcatenateDataFromFolders_SB(FolderList.(Mouse_names{mouse}),'epoch','epochname','blockedepoch');
            EpochUnblocked.(Session_type{sess}).(Mouse_names{mouse}) = TotalEpoch.(Session_type{sess}).(Mouse_names{mouse})-BlockedEpoch.(Session_type{sess}).(Mouse_names{mouse});
            FreezeEpoch.(Session_type{sess}).(Mouse_names{mouse}) = ConcatenateDataFromFolders_SB(FolderList.(Mouse_names{mouse}),'epoch','epochname','fz_epoch_withsleep');
            ActiveEpoch.(Session_type{sess}).(Mouse_names{mouse}) = TotalEpoch.(Session_type{sess}).(Mouse_names{mouse})-FreezeEpoch.(Session_type{sess}).(Mouse_names{mouse});
            Active_Free.(Session_type{sess}).(Mouse_names{mouse}) = and(ActiveEpoch.(Session_type{sess}).(Mouse_names{mouse}) , EpochUnblocked.(Session_type{sess}).(Mouse_names{mouse}));
            
            for param=1:length(Param)
                if param==1
                    DATA = Respi.(Session_type{sess}).(Mouse_names{mouse});
                    thr_physio1 = 0; thr_physio2 = 15;
                elseif param==2
                    DATA = HeartRate.(Session_type{sess}).(Mouse_names{mouse});
                    thr_physio1 = 9; thr_physio2 = 14.5;
                elseif param==3
                    DATA = HeartRateVar.(Session_type{sess}).(Mouse_names{mouse});
                    thr_physio1 = 0; thr_physio2 = .35;
                elseif param==4
                    DATA = tsd(Range(Accelero.(Session_type{sess}).(Mouse_names{mouse})) , log10(Data(Accelero.(Session_type{sess}).(Mouse_names{mouse}))));
                    thr_physio1 = 5; thr_physio2 = 9;
                end
                clear DATA_Active_Free DATA_interp SPEED Data_speed Data_physio ind_speed ind_physio Data_speed_corr Data_physio_corr h
                try
                    SPEED = Restrict(Speed.(Session_type{sess}).(Mouse_names{mouse}) , Active_Free.(Session_type{sess}).(Mouse_names{mouse}));
                    thr_speed = 25;
                    DATA_Active_Free = Restrict(DATA , Active_Free.(Session_type{sess}).(Mouse_names{mouse}));
                    DATA_interp = Restrict(DATA_Active_Free , SPEED);
                    
                    % smooth respi and speed with window = 0.3s
                    Data_speed = runmean_BM(Data(SPEED) , ceil(.3/median(diff(Range(SPEED,'s')))));
                    Data_physio = runmean_BM(Data(DATA_interp) , ceil(.3/median(diff(Range(SPEED,'s')))));
                    
                    ind_speed = Data_speed<thr_speed;
                    ind_physio = (Data_physio>thr_physio1 & Data_physio<thr_physio2);
                    
                    Data_speed_corr = Data_speed(ind_speed & ind_physio);
                    Data_physio_corr = Data_physio(ind_speed & ind_physio);
                    
                    % hist2d step
                    Corr_Speed_Physio.(Param{param}).(Session_type{sess}).(Mouse_names{mouse}) = hist2d([Data_speed_corr ; 0; 0; thr_speed ; thr_speed] , [Data_physio_corr; thr_physio1 ; thr_physio2; thr_physio1 ; thr_physio2] , size_map , size_map);
                    Corr_Speed_Physio.(Param{param}).(Session_type{sess}).(Mouse_names{mouse}) = Corr_Speed_Physio.(Param{param}).(Session_type{sess}).(Mouse_names{mouse})/sum(Corr_Speed_Physio.(Param{param}).(Session_type{sess}).(Mouse_names{mouse})(:));
                    Corr_Speed_Physio.(Param{param}).(Session_type{sess}).(Mouse_names{mouse}) = Corr_Speed_Physio.(Param{param}).(Session_type{sess}).(Mouse_names{mouse})';
                    
                    Corr_Speed_Physio_log.(Param{param}).(Session_type{sess}).(Mouse_names{mouse}) = log(Corr_Speed_Physio.(Param{param}).(Session_type{sess}).(Mouse_names{mouse}));
                    Corr_Speed_Physio_log.(Param{param}).(Session_type{sess}).(Mouse_names{mouse})(Corr_Speed_Physio_log.(Param{param}).(Session_type{sess}).(Mouse_names{mouse})==-Inf) = -1e4;
                    
                    h=histogram(Data_physio_corr,'NumBins',144,'BinLimits',[thr_physio1 thr_physio2]);
                    HistData_Physio.(Param{param}).(Session_type{sess}).(Mouse_names{mouse}) = h.Values;
                    
                    h=histogram(Data_physio_corr,'NumBins',144,'BinLimits',[thr_physio1 thr_physio2]);
                    HistData_Physio.(Param{param}).(Session_type{sess}).(Mouse_names{mouse}) = h.Values;
                end
            end
            disp(Mouse_names{mouse})
        end
    end
end
try
Corr_Speed_Physio_log.HR.Cond = rmfield(Corr_Speed_Physio_log.HR.Cond,'M11207');
end

for group=Group
    Mouse=Drugs_Groups_UMaze_BM(group);
    for param=1:length(Param)
        for sess=1:length(Session_type)
            for mouse=1:length(Mouse)
                Mouse_names{mouse}=['M' num2str(Mouse(mouse))];
                
                try
                    Corr_Speed_Physio_all.(Drug_Group{group}).(Param{param}).(Session_type{sess})(mouse,:,:) = Corr_Speed_Physio.(Param{param}).(Session_type{sess}).(Mouse_names{mouse});
                    HistData_Physio.(Drug_Group{group}).(Param{param}).(Session_type{sess})(mouse,:) = runmean(HistData_Physio.(Param{param}).(Session_type{sess}).(Mouse_names{mouse})/nansum(HistData_Physio.(Param{param}).(Session_type{sess}).(Mouse_names{mouse})),3);
                end
            end
            Corr_Speed_Physio_all_mean.(Drug_Group{group}).(Param{param}).(Session_type{sess}) = nanmean(Corr_Speed_Physio_all.(Drug_Group{group}).(Param{param}).(Session_type{sess}));
            Corr_Speed_Physio_all_squeeze.(Drug_Group{group}).(Param{param}).(Session_type{sess}) = squeeze(Corr_Speed_Physio_all_mean.(Drug_Group{group}).(Param{param}).(Session_type{sess}));
            
            clear A B min_to_use
            A=runmean_BM(runmean_BM(Corr_Speed_Physio_all_squeeze.(Drug_Group{group}).(Param{param}).(Session_type{sess})',3)',3);
            B=A;
            B(B==0)=NaN;
            min_to_use = min(min(B));
            A=A*(1/min_to_use);
            Corr_Speed_Physio_all_corrected.(Drug_Group{group}).(Param{param}).(Session_type{sess})=log10(A);
        end
    end
end

for group=Group
    for param=1:length(Param)
        for sess=1:length(Session_type)
            for i=1:size(HistData_Physio.(Drug_Group{group}).(Param{param}).(Session_type{sess}))
                if  mean(double(HistData_Physio.(Drug_Group{group}).(Param{param}).(Session_type{sess})(i,:)==zeros(1,144)))==1
                    HistData_Physio.(Drug_Group{group}).(Param{param}).(Session_type{sess})(i,:)=NaN;
                end
            end
        end
    end
end


for param=1:length(Param)
    if param==1
        thr_physio1 = 0; thr_physio2 = 15;
    elseif param==2
        thr_physio1 = 9; thr_physio2 = 14.5;
    elseif param==3
        thr_physio1 = 0; thr_physio2 = .35;
    elseif param==4
        thr_physio1 = 5; thr_physio2 = 9;
    end
    for group=Group
        Mouse=Drugs_Groups_UMaze_BM(group);
        for mouse=1:length(Mouse)
            Mouse_names{mouse}=['M' num2str(Mouse(mouse))];
            for sess=1:length(Session_type)
                try
                    H.(Drug_Group{group}).(Param{param}).(Session_type{sess})(mouse,:) = ...
                        sum(Corr_Speed_Physio.(Param{param}).(Session_type{sess}).(Mouse_names{mouse})./...
                        nansum(Corr_Speed_Physio.(Param{param}).(Session_type{sess}).(Mouse_names{mouse})).*(linspace(thr_physio1,thr_physio2,100)'));
                end
            end
        end
    end
end


%% figures
figure
imagesc(Corr_Speed_Physio_log.(Param{1}).(Session_type{sess}).(Mouse_names{mouse}))
caxis([-8 -5])

% see all mice
figure, param=1; n=1;
for group=Group
    Mouse=Drugs_Groups_UMaze_BM(group);
    for mouse=1:length(Mouse)
        Mouse_names{mouse}=['M' num2str(Mouse(mouse))];
        
        if param==1
            thr_physio1 = 0; thr_physio2 = 15;
        elseif param==2
            thr_physio1 = 9; thr_physio2 = 14.5;
        elseif param==3
            thr_physio1 = 0; thr_physio2 = .35;
        elseif param==4
            thr_physio1 = 5; thr_physio2 = 9;
        end
        
        if n==1
            try
                subplot(2,13,mouse)
                imagesc(linspace(0,25,size_map) , linspace(thr_physio1,thr_physio2,size_map) , Corr_Speed_Physio_log.(Param{param}).(Session_type{sess}).(Mouse_names{mouse})); axis xy
                caxis([-12 -3])
            end
            
        elseif n==2
            try
                subplot(2,13,mouse+13)
                imagesc(linspace(0,25,size_map) , linspace(thr_physio1,thr_physio2,size_map) , Corr_Speed_Physio_log.(Param{param}).(Session_type{sess}).(Mouse_names{mouse})); axis xy
                caxis([-12 -3])
            end
        end
        
    end
    n=n+1;
end
colormap jet


% mean for drugs groups
for param=1:4
    n=1;
    figure
    if param==1
        thr_physio1 = 0; thr_physio2 = 15;
    elseif param==2
        thr_physio1 = 9; thr_physio2 = 14.5;
    elseif param==3
        thr_physio1 = 0; thr_physio2 = .35;
    elseif param==4
        thr_physio1 = 5; thr_physio2 = 9;
    end
    for group=Group
        subplot(1,6,n)
        imagesc(linspace(0,25,size_map) , linspace(thr_physio1,thr_physio2,size_map) , Corr_Speed_Physio_all_corrected.(Drug_Group{group}).(Param{param}).(Session_type{sess})); axis xy
        caxis([0 4])
        ylabel('Respiratory rate (Hz)'); xlabel('Speed (cm/s)')
        title('Saline, n=11')
        
        colormap jet
        a=suptitle([Param{param} '/Speed correlations, active, unblocked, cond sessions']); a.FontSize=20;
        n=n+1;
    end
end

% hist
Cols{13} = [.3, .745, .93];
Cols{15} = [.85, .325, .098];
Group=[13 15];

figure, sess=1;
for param=1:4
    if param==1
        thr_physio1 = 0; thr_physio2 = 15;
    elseif param==2
        thr_physio1 = 9; thr_physio2 = 14.5;
    elseif param==3
        thr_physio1 = 0; thr_physio2 = .35;
    elseif param==4
        thr_physio1 = 5; thr_physio2 = 9;
    end
    subplot(2,2,param)
    
    Data_to_use = HistData_Physio.(Drug_Group{Group(1)}).(Param{param}).(Session_type{sess});
    Conf_Inter=nanstd(Data_to_use)/sqrt(size(Data_to_use,1));
    h=shadedErrorBar(linspace(thr_physio1,thr_physio2,144) , nanmean(Data_to_use),Conf_Inter,'-b',1);
    col=Cols{Group(1)}; h.mainLine.Color=col; h.patch.FaceColor=col; h.edge(1).Color=col; h.edge(2).Color=col;
    hold on;
    Data_to_use = HistData_Physio.(Drug_Group{Group(2)}).(Param{param}).(Session_type{sess});
    Conf_Inter=nanstd(Data_to_use)/sqrt(size(Data_to_use,1));
    h=shadedErrorBar(linspace(thr_physio1,thr_physio2,144) , nanmean(Data_to_use),Conf_Inter,'-k',1); hold on;
    col=Cols{Group(2)}; h.mainLine.Color=col; h.patch.FaceColor=col; h.edge(1).Color=col; h.edge(2).Color=col;
    
    makepretty_BM
    if or(param==1,param==2); xlabel('Frequency (Hz)')
    elseif param==3;  xlabel('Variaibilty (a.u.)')
    elseif param==4;  xlabel('Motion (log scale)')
    end
    ylabel('#')
    if param==1; f=get(gca,'Children'); legend([f(5),f(1)],Drug_Group{Group(1)},Drug_Group{Group(2)}); end
    title(Param{param})
end
a=suptitle('Physiology while active'); a.FontSize=20;




figure, Group=[13 15]; sess=1;
for param=1:4
    
    subplot(2,2,param)
    
    Data_to_use = H.(Drug_Group{Group(1)}).(Param{param}).(Session_type{sess}); Data_to_use(Data_to_use==0)=NaN;
    Conf_Inter=nanstd(Data_to_use)/sqrt(size(Data_to_use,1));
    h=shadedErrorBar(linspace(0,15,100) , movmean(nanmean(Data_to_use),5,'omitnan') , movmean(Conf_Inter,5,'omitnan'),'b',1);
    col=Cols{Group(1)}; h.mainLine.Color=col; h.patch.FaceColor=col; h.edge(1).Color=col; h.edge(2).Color=col;
    hold on;
    Data_to_use = H.(Drug_Group{Group(2)}).(Param{param}).(Session_type{sess}); Data_to_use(Data_to_use==0)=NaN;
    Conf_Inter=nanstd(Data_to_use)/sqrt(size(Data_to_use,1));
    h=shadedErrorBar(linspace(0,15,100) , movmean(nanmean(Data_to_use),5,'omitnan') , movmean(Conf_Inter,5,'omitnan'),'b',1);
    h.mainLine.Color=Cols{Group(2)}; h.patch.FaceColor=Cols{Group(2)}; h.edge(1).Color=Cols{Group(2)}; h.edge(2).Color=Cols{Group(2)};
    
    makepretty
    if or(param==1,param==2); ylabel('Frequency (Hz)')
    elseif param==3;  ylabel('Variaibilty (a.u.)')
    elseif param==4;  ylabel('Motion (log scale)')
    end
    xlabel('Speed (cm/s)')
    if param==1; f=get(gca,'Children'); legend([f(5),f(1)],Drug_Group{Group(1)},Drug_Group{Group(2)}); end
    title(Param{param})
end
a=suptitle('Physiology while active'); a.FontSize=20;








%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%ù
%% DZP



Session_type={'TestPre'};

for sess=1:length(Session_type)
    Sessions_List_ForLoop_BM
    for group=Group
        Mouse=Drugs_Groups_UMaze_BM(group);
        for mouse=1:length(Mouse)
            Mouse_names{mouse}=['M' num2str(Mouse(mouse))];
            
            Speed.(Session_type{sess}).(Mouse_names{mouse}) = ConcatenateDataFromFolders_SB(FolderList.(Mouse_names{mouse}),'speed');
%             Respi.(Session_type{sess}).(Mouse_names{mouse}) = ConcatenateDataFromFolders_SB(FolderList.(Mouse_names{mouse}),'respi_freq_bm');
            Respi.(Session_type{sess}).(Mouse_names{mouse}) = ConcatenateDataFromFolders_SB(FolderList.(Mouse_names{mouse}),'instfreq','suffix_instfreq','B','method','WV');
            HeartRate.(Session_type{sess}).(Mouse_names{mouse}) = ConcatenateDataFromFolders_SB(FolderList.(Mouse_names{mouse}),'heartrate');
            HeartRateVar.(Session_type{sess}).(Mouse_names{mouse}) = ConcatenateDataFromFolders_SB(FolderList.(Mouse_names{mouse}),'heartratevar');
            Accelero.(Session_type{sess}).(Mouse_names{mouse}) = ConcatenateDataFromFolders_SB(FolderList.(Mouse_names{mouse}),'accelero');
            
            TotalEpoch.(Session_type{sess}).(Mouse_names{mouse}) = intervalSet(0 , max(Range(Speed.(Session_type{sess}).(Mouse_names{mouse}))));
            BlockedEpoch.(Session_type{sess}).(Mouse_names{mouse}) = ConcatenateDataFromFolders_SB(FolderList.(Mouse_names{mouse}),'epoch','epochname','blockedepoch');
            EpochUnblocked.(Session_type{sess}).(Mouse_names{mouse}) = TotalEpoch.(Session_type{sess}).(Mouse_names{mouse})-BlockedEpoch.(Session_type{sess}).(Mouse_names{mouse});
            FreezeEpoch.(Session_type{sess}).(Mouse_names{mouse}) = ConcatenateDataFromFolders_SB(FolderList.(Mouse_names{mouse}),'epoch','epochname','fz_epoch_withsleep');
            ActiveEpoch.(Session_type{sess}).(Mouse_names{mouse}) = TotalEpoch.(Session_type{sess}).(Mouse_names{mouse})-FreezeEpoch.(Session_type{sess}).(Mouse_names{mouse});
            Active_Free.(Session_type{sess}).(Mouse_names{mouse}) = and(ActiveEpoch.(Session_type{sess}).(Mouse_names{mouse}) , EpochUnblocked.(Session_type{sess}).(Mouse_names{mouse}));
            
            for param=1:length(Param)
                if param==1
                    DATA = Respi.(Session_type{sess}).(Mouse_names{mouse});
                    thr_physio1 = 0; thr_physio2 = 15;
                elseif param==2
                    DATA = HeartRate.(Session_type{sess}).(Mouse_names{mouse});
                    thr_physio1 = 9; thr_physio2 = 14.5;
                elseif param==3
                    DATA = HeartRateVar.(Session_type{sess}).(Mouse_names{mouse});
                    thr_physio1 = 0; thr_physio2 = .35;
                elseif param==4
                    DATA = tsd(Range(Accelero.(Session_type{sess}).(Mouse_names{mouse})) , log10(Data(Accelero.(Session_type{sess}).(Mouse_names{mouse}))));
                    thr_physio1 = 5; thr_physio2 = 9;
                end
                clear DATA_Active_Free DATA_interp SPEED Data_speed Data_physio ind_speed ind_physio Data_speed_corr Data_physio_corr h
                try
                    SPEED = Restrict(Speed.(Session_type{sess}).(Mouse_names{mouse}) , Active_Free.(Session_type{sess}).(Mouse_names{mouse}));
                    thr_speed = 25;
                    DATA_Active_Free = Restrict(DATA , Active_Free.(Session_type{sess}).(Mouse_names{mouse}));
                    DATA_interp = Restrict(DATA_Active_Free , SPEED);
                    
                    % smooth respi and speed with window = 0.3s
                    Data_speed = runmean_BM(Data(SPEED) , ceil(.3/median(diff(Range(SPEED,'s')))));
                    Data_physio = runmean_BM(Data(DATA_interp) , ceil(.3/median(diff(Range(SPEED,'s')))));
                    
                    ind_speed = Data_speed<thr_speed;
                    ind_physio = (Data_physio>thr_physio1 & Data_physio<thr_physio2);
                    
                    Data_speed_corr = Data_speed(ind_speed & ind_physio);
                    Data_physio_corr = Data_physio(ind_speed & ind_physio);
                    
                    % hist2d step
                    Corr_Speed_Physio.(Param{param}).(Session_type{sess}).(Mouse_names{mouse}) = hist2d([Data_speed_corr ; 0; 0; thr_speed ; thr_speed] , [Data_physio_corr; thr_physio1 ; thr_physio2; thr_physio1 ; thr_physio2] , size_map , size_map);
                    Corr_Speed_Physio.(Param{param}).(Session_type{sess}).(Mouse_names{mouse}) = Corr_Speed_Physio.(Param{param}).(Session_type{sess}).(Mouse_names{mouse})/sum(Corr_Speed_Physio.(Param{param}).(Session_type{sess}).(Mouse_names{mouse})(:));
                    Corr_Speed_Physio.(Param{param}).(Session_type{sess}).(Mouse_names{mouse}) = Corr_Speed_Physio.(Param{param}).(Session_type{sess}).(Mouse_names{mouse})';
                    
                    Corr_Speed_Physio_log.(Param{param}).(Session_type{sess}).(Mouse_names{mouse}) = log(Corr_Speed_Physio.(Param{param}).(Session_type{sess}).(Mouse_names{mouse}));
                    Corr_Speed_Physio_log.(Param{param}).(Session_type{sess}).(Mouse_names{mouse})(Corr_Speed_Physio_log.(Param{param}).(Session_type{sess}).(Mouse_names{mouse})==-Inf) = -1e4;
                    
                    h=histogram(Data_physio_corr,'NumBins',144,'BinLimits',[thr_physio1 thr_physio2]);
                    HistData_Physio.(Param{param}).(Session_type{sess}).(Mouse_names{mouse}) = h.Values;
                    
                    h=histogram(Data_physio_corr,'NumBins',144,'BinLimits',[thr_physio1 thr_physio2]);
                    HistData_Physio.(Param{param}).(Session_type{sess}).(Mouse_names{mouse}) = h.Values;
                end
            end
            disp(Mouse_names{mouse})
        end
    end
end


for group=Group
    Mouse=Drugs_Groups_UMaze_BM(group);
    for param=1:length(Param)
        for sess=1:length(Session_type)
            for mouse=1:length(Mouse)
                Mouse_names{mouse}=['M' num2str(Mouse(mouse))];
                
                try
                    Corr_Speed_Physio_all.(Drug_Group{group}).(Param{param}).(Session_type{sess})(mouse,:,:) = Corr_Speed_Physio.(Param{param}).(Session_type{sess}).(Mouse_names{mouse});
                    HistData_Physio.(Drug_Group{group}).(Param{param}).(Session_type{sess})(mouse,:) = runmean(HistData_Physio.(Param{param}).(Session_type{sess}).(Mouse_names{mouse})/nansum(HistData_Physio.(Param{param}).(Session_type{sess}).(Mouse_names{mouse})),3);
                end
            end
            Corr_Speed_Physio_all_mean.(Drug_Group{group}).(Param{param}).(Session_type{sess}) = nanmean(Corr_Speed_Physio_all.(Drug_Group{group}).(Param{param}).(Session_type{sess}));
            Corr_Speed_Physio_all_squeeze.(Drug_Group{group}).(Param{param}).(Session_type{sess}) = squeeze(Corr_Speed_Physio_all_mean.(Drug_Group{group}).(Param{param}).(Session_type{sess}));
            
            clear A B min_to_use
            A=runmean_BM(runmean_BM(Corr_Speed_Physio_all_squeeze.(Drug_Group{group}).(Param{param}).(Session_type{sess})',3)',3);
            B=A;
            B(B==0)=NaN;
            min_to_use = min(min(B));
            A=A*(1/min_to_use);
            Corr_Speed_Physio_all_corrected.(Drug_Group{group}).(Param{param}).(Session_type{sess})=log10(A);
        end
    end
end



for group=Group
    for param=1:length(Param)
        for sess=1:length(Session_type)
            for i=1:size(HistData_Physio.(Drug_Group{group}).(Param{param}).(Session_type{sess}))
                if  mean(double(HistData_Physio.(Drug_Group{group}).(Param{param}).(Session_type{sess})(i,:)==zeros(1,144)))==1
                    HistData_Physio.(Drug_Group{group}).(Param{param}).(Session_type{sess})(i,:)=NaN;
                end
            end
        end
    end
end
for param=1:length(Param)
    if param==1
        thr_physio1 = 0; thr_physio2 = 15;
    elseif param==2
        thr_physio1 = 9; thr_physio2 = 14.5;
    elseif param==3
        thr_physio1 = 0; thr_physio2 = .35;
    elseif param==4
        thr_physio1 = 5; thr_physio2 = 9;
    end
    for group=Group
        Mouse=Drugs_Groups_UMaze_BM(group);
        for mouse=1:length(Mouse)
            Mouse_names{mouse}=['M' num2str(Mouse(mouse))];
            for sess=1:length(Session_type)
                try
                    H.(Drug_Group{group}).(Param{param}).(Session_type{sess})(mouse,:) = ...
                        sum(Corr_Speed_Physio.(Param{param}).(Session_type{sess}).(Mouse_names{mouse})./...
                        nansum(Corr_Speed_Physio.(Param{param}).(Session_type{sess}).(Mouse_names{mouse})).*(linspace(thr_physio1,thr_physio2,100)'));
                end
            end
        end
    end
end



figure, Group=[13 15]; sess=2; param=2;
for param=1:4
    
    subplot(2,2,param)
    
    Data_to_use = H.(Drug_Group{Group(1)}).(Param{param}).(Session_type{sess}); Data_to_use(Data_to_use==0)=NaN;
    Conf_Inter=nanstd(Data_to_use)/sqrt(size(Data_to_use,1));
    h=shadedErrorBar(linspace(0,15,100) , movmean(nanmean(Data_to_use),5,'omitnan') , movmean(Conf_Inter,5,'omitnan'),'b',1);
    col=Cols{Group(1)}; h.mainLine.Color=col; h.patch.FaceColor=col; h.edge(1).Color=col; h.edge(2).Color=col;
    hold on;
    Data_to_use = H.(Drug_Group{Group(2)}).(Param{param}).(Session_type{sess}); Data_to_use(Data_to_use==0)=NaN;
    Conf_Inter=nanstd(Data_to_use)/sqrt(size(Data_to_use,1));
    h=shadedErrorBar(linspace(0,15,100) , movmean(nanmean(Data_to_use),5,'omitnan') , movmean(Conf_Inter,5,'omitnan'),'b',1);
    h.mainLine.Color=Cols{Group(2)}; h.patch.FaceColor=Cols{Group(2)}; h.edge(1).Color=Cols{Group(2)}; h.edge(2).Color=Cols{Group(2)};
    
    makepretty
    if or(param==1,param==2); ylabel('Breathing (Hz)')
    elseif param==2;  ylabel('Heart rate (Hz)')
    elseif param==3;  ylabel('Heart rate var (a.u.)')
    elseif param==4;  ylabel('Motion (log scale)')
    end
    xlabel('Speed (cm/s)')
    if param==1; f=get(gca,'Children'); legend([f(5),f(1)],Drug_Group{Group(1)},Drug_Group{Group(2)}); end
end



figure, param=2; sess=2;
subplot(121)
Data_to_use = H.(Drug_Group{Group(1)}).(Param{param}).(Session_type{sess}); Data_to_use(Data_to_use==0)=NaN;
plot(Data_to_use'), legend, ylim([10.5 14])
subplot(122)
Data_to_use = H.(Drug_Group{Group(2)}).(Param{param}).(Session_type{sess}); Data_to_use(Data_to_use==0)=NaN;
plot(Data_to_use'), legend, ylim([10.5 14])


Session_type={'TestPre','CondPost'};

for sess=1:2
    H.Saline_short.HR.(Session_type{sess})([7 9],:) = NaN;
    H.Saline_short.HRVar.(Session_type{sess})([7 9],:) = NaN;
    H.DZP_short.HR.(Session_type{sess})([3 5 6 8],:) = NaN;
    H.DZP_short.HRVar.(Session_type{sess})([3 5 6 8],:) = NaN;
end



figure, param=3; sess=2;
subplot(121)
Data_to_use = H.(Drug_Group{Group(1)}).(Param{param}).(Session_type{sess}); Data_to_use(Data_to_use==0)=NaN;
plot(Data_to_use'), legend, %ylim([10.5 14])
subplot(122)
Data_to_use = H.(Drug_Group{Group(2)}).(Param{param}).(Session_type{sess}); Data_to_use(Data_to_use==0)=NaN;
plot(Data_to_use'), legend, %ylim([10.5 14])




H.Saline_short.HR.(Session_type{2})(11,:)=NaN
H.Saline_short.HRVar.(Session_type{2})(11,:)=NaN





