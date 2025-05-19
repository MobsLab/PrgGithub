

clear all
GetAllSalineSessions_BM
GetEmbReactMiceFolderList_BM
Session_type={'TestPre','Cond'};
Group=22;
Param={'HR'};
size_map = 100;
SpeedLim = 2;
smooth_time = 2;

for sess=1:length(Session_type)
    Sessions_List_ForLoop_BM
    for group=Group
        Mouse=Drugs_Groups_UMaze_BM(group);
        for mouse=1:length(Mouse)
            Mouse_names{mouse}=['M' num2str(Mouse(mouse))];
            Speed.(Session_type{sess}).(Mouse_names{mouse}) = ConcatenateDataFromFolders_SB(FolderList.(Mouse_names{mouse}),'speed');
            Speed.(Session_type{sess}).(Mouse_names{mouse}) = tsd(Range(Speed.(Session_type{sess}).(Mouse_names{mouse})) , runmean(Data(Speed.(Session_type{sess}).(Mouse_names{mouse})) , ceil(smooth_time/median(diff(Range(Speed.(Session_type{sess}).(Mouse_names{mouse}),'s'))))));
            %             Respi.(Session_type{sess}).(Mouse_names{mouse}) = ConcatenateDataFromFolders_SB(FolderList.(Mouse_names{mouse}),'respi_freq_bm');
            HeartRate.(Session_type{sess}).(Mouse_names{mouse}) = ConcatenateDataFromFolders_SB(FolderList.(Mouse_names{mouse}),'heartrate');
            if isempty(max(Range(Speed.(Session_type{sess}).(Mouse_names{mouse}))))
                TotalEpoch.(Session_type{sess}).(Mouse_names{mouse}) = intervalSet([],[]);
            else
                TotalEpoch.(Session_type{sess}).(Mouse_names{mouse}) = intervalSet(0 , max(Range(Speed.(Session_type{sess}).(Mouse_names{mouse}))));
            end
            BlockedEpoch.(Session_type{sess}).(Mouse_names{mouse}) = ConcatenateDataFromFolders_SB(FolderList.(Mouse_names{mouse}),'epoch','epochname','blockedepoch');
            EpochUnblocked.(Session_type{sess}).(Mouse_names{mouse}) = TotalEpoch.(Session_type{sess}).(Mouse_names{mouse})-BlockedEpoch.(Session_type{sess}).(Mouse_names{mouse});
            FreezeEpoch.(Session_type{sess}).(Mouse_names{mouse}) = ConcatenateDataFromFolders_SB(FolderList.(Mouse_names{mouse}),'epoch','epochname','fz_epoch_withsleep');
            ActiveEpoch.(Session_type{sess}).(Mouse_names{mouse}) = thresholdIntervals(Speed.(Session_type{sess}).(Mouse_names{mouse}) , SpeedLim ,'Direction', 'Above')-FreezeEpoch.(Session_type{sess}).(Mouse_names{mouse});
            Active_Free.(Session_type{sess}).(Mouse_names{mouse}) = and(ActiveEpoch.(Session_type{sess}).(Mouse_names{mouse}) , EpochUnblocked.(Session_type{sess}).(Mouse_names{mouse}));
            Active_Free.(Session_type{sess}).(Mouse_names{mouse}) = dropShortIntervals(Active_Free.(Session_type{sess}).(Mouse_names{mouse}) , 1e4);
            Active_Free.(Session_type{sess}).(Mouse_names{mouse}) = mergeCloseIntervals(Active_Free.(Session_type{sess}).(Mouse_names{mouse}) , 1e4);
            ZoneEpoch.(Session_type{sess}).(Mouse_names{mouse}) = ConcatenateDataFromFolders_SB(FolderList.(Mouse_names{mouse}),'epoch','epochname','zoneepoch');
            ShockEpoch.(Session_type{sess}).(Mouse_names{mouse}) = ZoneEpoch.(Session_type{sess}).(Mouse_names{mouse}){1};
            SafeEpoch.(Session_type{sess}).(Mouse_names{mouse}) = ZoneEpoch.(Session_type{sess}).(Mouse_names{mouse}){2};
            for param=1:length(Param)
                if param==1
                    DATA = HeartRate.(Session_type{sess}).(Mouse_names{mouse});
                    thr_physio1 = 9; thr_physio2 = 14.5;
                end
                clear DATA_Active_Free DATA_interp SPEED Data_speed Data_physio ind_speed ind_physio Data_speed_corr Data_physio_corr h
                try
                    SPEED = Restrict(Speed.(Session_type{sess}).(Mouse_names{mouse}) , Active_Free.(Session_type{sess}).(Mouse_names{mouse}));
                    SPEED_shock = Restrict(Speed.(Session_type{sess}).(Mouse_names{mouse}) , and(Active_Free.(Session_type{sess}).(Mouse_names{mouse}) , ShockEpoch.(Session_type{sess}).(Mouse_names{mouse})));
                    SPEED_safe = Restrict(Speed.(Session_type{sess}).(Mouse_names{mouse}) , and(Active_Free.(Session_type{sess}).(Mouse_names{mouse}) , SafeEpoch.(Session_type{sess}).(Mouse_names{mouse})));
                    thr_speed = 25;
                    DATA_Active_Free = Restrict(DATA , Active_Free.(Session_type{sess}).(Mouse_names{mouse}));
                    DATA_interp = Restrict(DATA_Active_Free , SPEED);
                    DATA_interp_shock = Restrict(DATA_Active_Free , SPEED_shock);
                    DATA_interp_safe = Restrict(DATA_Active_Free , SPEED_safe);
                    
                    % smooth respi and speed with window = 0.3s
                    Data_speed = runmean_BM(Data(SPEED) , ceil(.3/median(diff(Range(SPEED,'s')))));
                    Data_speed_shock = runmean_BM(Data(SPEED_shock) , ceil(.3/median(diff(Range(SPEED,'s')))));
                    Data_speed_safe = runmean_BM(Data(SPEED_safe) , ceil(.3/median(diff(Range(SPEED,'s')))));
                    
                    Data_physio = runmean_BM(Data(DATA_interp) , ceil(.3/median(diff(Range(SPEED,'s')))));
                    Data_physio_shock = runmean_BM(Data(DATA_interp_shock) , ceil(.3/median(diff(Range(SPEED,'s')))));
                    Data_physio_safe = runmean_BM(Data(DATA_interp_safe) , ceil(.3/median(diff(Range(SPEED,'s')))));
                    
                    ind_speed = Data_speed<thr_speed;
                    ind_speed_shock = Data_speed_shock<thr_speed;
                    ind_speed_safe = Data_speed_safe<thr_speed;
                    
                    ind_physio = (Data_physio>thr_physio1 & Data_physio<thr_physio2);
                    Data_speed_corr = Data_speed(ind_speed & ind_physio);
                    Data_physio_corr = Data_physio(ind_speed & ind_physio);
                    
                    ind_physio_shock = (Data_physio_shock>thr_physio1 & Data_physio_shock<thr_physio2);
                    Data_speed_corr_shock = Data_speed(ind_speed_shock & ind_physio_shock);
                    Data_physio_corr_shock = Data_physio(ind_speed_shock & ind_physio_shock);
                    
                    ind_physio_safe = (Data_physio_safe>thr_physio1 & Data_physio_safe<thr_physio2);
                    Data_speed_corr_safe = Data_speed(ind_speed_safe & ind_physio_safe);
                    Data_physio_corr_safe = Data_physio(ind_speed_safe & ind_physio_safe);
                    
                    % hist2d step
                    Corr_Speed_Physio.(Param{param}).(Session_type{sess}).(Mouse_names{mouse}) = hist2d([Data_speed_corr ; 0; 0; thr_speed ; thr_speed] , [Data_physio_corr; thr_physio1 ; thr_physio2; thr_physio1 ; thr_physio2] , size_map , size_map);
                    Corr_Speed_Physio.(Param{param}).(Session_type{sess}).(Mouse_names{mouse}) = Corr_Speed_Physio.(Param{param}).(Session_type{sess}).(Mouse_names{mouse})/sum(Corr_Speed_Physio.(Param{param}).(Session_type{sess}).(Mouse_names{mouse})(:));
                    Corr_Speed_Physio.(Param{param}).(Session_type{sess}).(Mouse_names{mouse}) = Corr_Speed_Physio.(Param{param}).(Session_type{sess}).(Mouse_names{mouse})';
                    Corr_Speed_Physio_shock.(Param{param}).(Session_type{sess}).(Mouse_names{mouse}) = hist2d([Data_speed_corr_shock ; 0; 0; thr_speed ; thr_speed] , [Data_physio_corr_shock; thr_physio1 ; thr_physio2; thr_physio1 ; thr_physio2] , size_map , size_map);
                    Corr_Speed_Physio_shock.(Param{param}).(Session_type{sess}).(Mouse_names{mouse}) = Corr_Speed_Physio_shock.(Param{param}).(Session_type{sess}).(Mouse_names{mouse})/sum(Corr_Speed_Physio_shock.(Param{param}).(Session_type{sess}).(Mouse_names{mouse})(:));
                    Corr_Speed_Physio_shock.(Param{param}).(Session_type{sess}).(Mouse_names{mouse}) = Corr_Speed_Physio_shock.(Param{param}).(Session_type{sess}).(Mouse_names{mouse})';
                    Corr_Speed_Physio_safe.(Param{param}).(Session_type{sess}).(Mouse_names{mouse}) = hist2d([Data_speed_corr_safe ; 0; 0; thr_speed ; thr_speed] , [Data_physio_corr_safe; thr_physio1 ; thr_physio2; thr_physio1 ; thr_physio2] , size_map , size_map);
                    Corr_Speed_Physio_safe.(Param{param}).(Session_type{sess}).(Mouse_names{mouse}) = Corr_Speed_Physio_safe.(Param{param}).(Session_type{sess}).(Mouse_names{mouse})/sum(Corr_Speed_Physio_safe.(Param{param}).(Session_type{sess}).(Mouse_names{mouse})(:));
                    Corr_Speed_Physio_safe.(Param{param}).(Session_type{sess}).(Mouse_names{mouse}) = Corr_Speed_Physio_safe.(Param{param}).(Session_type{sess}).(Mouse_names{mouse})';
                    
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


for param=1:length(Param)
    if param==1
        thr_physio1 = 9; thr_physio2 = 14.5;
    end
    for mouse=1:length(Mouse)
        Mouse_names{mouse}=['M' num2str(Mouse(mouse))];
        for sess=1:length(Session_type)
            try
                H.(Param{param}).(Session_type{sess})(mouse,:) = ...
                    sum(Corr_Speed_Physio.(Param{param}).(Session_type{sess}).(Mouse_names{mouse})./...
                    nansum(Corr_Speed_Physio.(Param{param}).(Session_type{sess}).(Mouse_names{mouse})).*(linspace(thr_physio1,thr_physio2,100)'));
                
                H_shock.(Param{param}).(Session_type{sess})(mouse,:) = ...
                    sum(Corr_Speed_Physio_shock.(Param{param}).(Session_type{sess}).(Mouse_names{mouse})./...
                    nansum(Corr_Speed_Physio_shock.(Param{param}).(Session_type{sess}).(Mouse_names{mouse})).*(linspace(thr_physio1,thr_physio2,100)'));
                
                H_safe.(Param{param}).(Session_type{sess})(mouse,:) = ...
                    sum(Corr_Speed_Physio_safe.(Param{param}).(Session_type{sess}).(Mouse_names{mouse})./...
                    nansum(Corr_Speed_Physio_safe.(Param{param}).(Session_type{sess}).(Mouse_names{mouse})).*(linspace(thr_physio1,thr_physio2,100)'));
            end
        end
    end
end

for param=1:length(Param)
    for sess=1:length(Session_type)
        H.(Param{param}).(Session_type{sess})(H.(Param{param}).(Session_type{sess})==0) = NaN;
        H_shock.(Param{param}).(Session_type{sess})(H_shock.(Param{param}).(Session_type{sess})==0) = NaN;
        H_safe.(Param{param}).(Session_type{sess})(H_safe.(Param{param}).(Session_type{sess})==0) = NaN;
    end
end

figure
subplot(131)
Data_to_use = movmean(H.(Param{param}).TestPre',3)';
Conf_Inter=nanstd(Data_to_use)/sqrt(size(Data_to_use,1));
h=shadedErrorBar(linspace(0,25,100) , nanmean(Data_to_use) , Conf_Inter ,'-k',1);
hold on
Data_to_use = movmean(H.(Param{param}).Cond',3)';
Conf_Inter=nanstd(Data_to_use)/sqrt(size(Data_to_use,1));
h=shadedErrorBar(linspace(0,25,100) , nanmean(Data_to_use) , Conf_Inter ,'-r',1);
xlabel('Speed (cm/s)'), ylabel('Heart rate (Hz)')
f=get(gca,'Children'); legend([f([8 4])],'TestPre','Cond');
xlim([2 15]), ylim([12.4 13.1])
makepretty_BM2

subplot(132)
Data_to_use = H_shock.(Param{param}).TestPre;
Conf_Inter=nanstd(Data_to_use)/sqrt(size(Data_to_use,1));
h=shadedErrorBar(linspace(0,25,100) , nanmean(Data_to_use) , Conf_Inter ,'-k',1);
hold on
Data_to_use = H_shock.(Param{param}).Cond;
Conf_Inter=nanstd(Data_to_use)/sqrt(size(Data_to_use,1));
h=shadedErrorBar(linspace(0,25,100) , nanmean(Data_to_use) , Conf_Inter ,'-r',1);
xlabel('Speed (cm/s)'), ylabel('Heart rate (Hz)')
f=get(gca,'Children'); legend([f([8 4])],'TestPre','Cond');
xlim([2 15]), ylim([12.4 13.3])

subplot(133)
Data_to_use = H_safe.(Param{param}).TestPre;
Conf_Inter=nanstd(Data_to_use)/sqrt(size(Data_to_use,1));
h=shadedErrorBar(linspace(0,25,100) , nanmean(Data_to_use) , Conf_Inter ,'-k',1);
hold on
Data_to_use = H_safe.(Param{param}).Cond;
Conf_Inter=nanstd(Data_to_use)/sqrt(size(Data_to_use,1));
h=shadedErrorBar(linspace(0,25,100) , nanmean(Data_to_use) , Conf_Inter ,'-r',1);
xlabel('Speed (cm/s)'), ylabel('Heart rate (Hz)')
f=get(gca,'Children'); legend([f([8 4])],'TestPre','Cond');
xlim([2 15]), ylim([12.4 13.3])



Session_type={'Cond'}; sess=1; Sessions_List_ForLoop_BM
% l=load('/media/nas7/ProjetEmbReact/DataEmbReact/Data_Physio_Freezing_Saline_all_Cond_2sFullBins.mat');
l=load('/media/nas7/ProjetEmbReact/DataEmbReact/Data_Physio_Freezing_Saline_Eyelid_Cond_2sFullBins.mat');
for mouse=1:length(Mouse)
    if ~isempty(Range(HeartRate.TestPre.(Mouse_names{mouse})))
        SPEED = Restrict(Speed.(Session_type{sess}).(Mouse_names{mouse}) , Active_Free.(Session_type{sess}).(Mouse_names{mouse}));
        Smooth_speed = tsd(Range(SPEED) , runmean_BM(Data(SPEED) , ceil(.3/median(diff(Range(SPEED,'s'))))));
        for bin=1:6e3
            SmallEp = intervalSet((bin-1)*1e4 , bin*1e4);
            SmallEp = and(SmallEp , Active_Free.(Session_type{sess}).(Mouse_names{mouse}));
            HeartRate_moving.(Mouse_names{mouse})(bin) = nanmean(Data(Restrict(l.OutPutData.Cond.heartrate.tsd{mouse,4} , SmallEp)));
            HeartRate_moving_shock.(Mouse_names{mouse})(bin) = nanmean(Data(Restrict(l.OutPutData.Cond.heartrate.tsd{mouse,1} ,...
                and(SmallEp , and(ActiveEpoch.(Session_type{sess}).(Mouse_names{mouse}) , ShockEpoch.(Session_type{sess}).(Mouse_names{mouse}))))));
            HeartRate_moving_safe.(Mouse_names{mouse})(bin) = nanmean(Data(Restrict(l.OutPutData.Cond.heartrate.tsd{mouse,1} ,...
                and(SmallEp , and(ActiveEpoch.(Session_type{sess}).(Mouse_names{mouse}) , SafeEpoch.(Session_type{sess}).(Mouse_names{mouse}))))));
            Speed_moving.(Mouse_names{mouse})(bin) = nanmean(Data(Restrict(Speed.(Session_type{sess}).(Mouse_names{mouse}) , SmallEp)));
            try
                ind = find(round(Speed_moving.(Mouse_names{mouse})(bin),1)<linspace(0,25,65),1,'first');
                Diff_HR{mouse}(bin) = H.HR.TestPre(mouse,ind)-HeartRate_moving.(Mouse_names{mouse})(bin);
                Diff_HR_shock{mouse}(bin) = H_shock.HR.TestPre(mouse,ind)-HeartRate_moving_shock.(Mouse_names{mouse})(bin);
                Diff_HR_safe{mouse}(bin) = H_safe.HR.TestPre(mouse,ind)-HeartRate_moving_safe.(Mouse_names{mouse})(bin);
            end
        end
        disp(mouse)
    end
    try, Diff_HR{mouse}(Diff_HR{mouse}==0) = NaN; end
    try, Diff_HR_shock{mouse}(Diff_HR_shock{mouse}==0) = NaN; end
    try, Diff_HR_safe{mouse}(Diff_HR_safe{mouse}==0) = NaN; end
end

for mouse=1:length(Mouse)
    try
        for i=1:10
            if i<10
                clear D, D = Diff_HR{mouse}([(i-1)*(ceil(length(Diff_HR{mouse})/10)-1)+1 : i*(ceil(length(Diff_HR{mouse})/10)-1)]);
                D(abs(D)>5) = NaN;
                Diff_HR_all(mouse,i) = nanmean(D);
                clear D, D = Diff_HR_shock{mouse}([(i-1)*(ceil(length(Diff_HR_shock{mouse})/10)-1)+1 : i*(ceil(length(Diff_HR_shock{mouse})/10)-1)]);
                D(abs(D)>5) = NaN;
                Diff_HR_shock_all(mouse,i) = nanmean(D);
                clear D, D = Diff_HR_safe{mouse}([(i-1)*(ceil(length(Diff_HR_safe{mouse})/10)-1)+1 : i*(ceil(length(Diff_HR_safe{mouse})/10)-1)]);
                D(abs(D)>5) = NaN;
                Diff_HR_safe_all(mouse,i) = nanmean(D);
            else
                clear D, D = Diff_HR{mouse}([(i-1)*(ceil(length(Diff_HR{mouse})/10)-1)+1 : end]);
                D(abs(D)>5) = NaN;
                Diff_HR_all(mouse,i) = nanmean(D);
                clear D, D = Diff_HR_shock{mouse}([(i-1)*(ceil(length(Diff_HR_shock{mouse})/10)-1)+1 : end]);
                D(abs(D)>5) = NaN;
                Diff_HR_shock_all(mouse,i) = nanmean(D);
                clear D, D = Diff_HR_safe{mouse}([(i-1)*(ceil(length(Diff_HR_safe{mouse})/10)-1)+1 : end]);
                D(abs(D)>5) = NaN;
                Diff_HR_safe_all(mouse,i) = nanmean(D);
            end
        end
    end
end
Diff_HR_all(Diff_HR_all==0)=NaN;
Diff_HR_shock_all(Diff_HR_shock_all==0)=NaN;
Diff_HR_safe_all(Diff_HR_safe_all==0)=NaN;
% Diff_HR_safe_all(8,50)=NaN; Diff_HR_shock_all(7,50)=NaN;
% Diff_HR_shock_all(50,7)=NaN; Diff_HR_safe_all(50,8)=NaN; 

figure
Data_to_use = -movmean(Diff_HR_shock_all',2,'omitnan')';
Conf_Inter=nanstd(Data_to_use)/sqrt(size(Data_to_use,1));
Mean_All_Sp=nanmean(Data_to_use);
h=shadedErrorBar(linspace(0,1,10) , Mean_All_Sp , Conf_Inter,'-r',1); hold on;
color= [1 .5 .5]; h.mainLine.Color=color; h.patch.FaceColor=color; h.edge(1).Color=color; h.edge(2).Color=color;
Data_to_use = -movmean(Diff_HR_safe_all',2,'omitnan')';
Conf_Inter=nanstd(Data_to_use)/sqrt(size(Data_to_use,1));
Mean_All_Sp=nanmean(Data_to_use);
h=shadedErrorBar(linspace(0,1,10) , Mean_All_Sp , Conf_Inter,'-b',1); hold on;
color= [.5 .5 1]; h.mainLine.Color=color; h.patch.FaceColor=color; h.edge(1).Color=color; h.edge(2).Color=color;
hline(0,'--r')
xlabel('time (a.u.)'), ylabel('Heart rate Cond-TestPre, moving')
box off
f=get(gca,'Children'); l=legend([f([8 4])],'Shock','Safe');




%% tools
figure
subplot(121)
plot(linspace(0,25,100) , H.HR.TestPre')
subplot(122)
plot(linspace(0,25,100) , H.HR.Cond')


figure
subplot(121)
plot(Diff_HR_shock_all')
ylim([-2 3]), hline(0,'--r')
subplot(122)
plot(Diff_HR_safe_all')
ylim([-2 3]), hline(0,'--r')


figure
Data_to_use = -Diff_HR_all;
Conf_Inter=nanstd(Data_to_use)/sqrt(size(Data_to_use,1));
Mean_All_Sp=nanmean(Data_to_use);
h=shadedErrorBar(linspace(0,1,10) , Mean_All_Sp , Conf_Inter,'-k',1); hold on;


%% other
bin_size = 6; % in minutes


for mouse=1:length(Mouse)
    Diff_HR_tsd{mouse} = tsd([.5e4:1e4:length(Diff_HR{mouse})*1e4-.5e4] , Diff_HR{mouse}');
    Diff_HR_shock_tsd{mouse} = tsd([.5e4:1e4:length(Diff_HR_shock{mouse})*1e4-.5e4] , Diff_HR_shock{mouse}');
    Diff_HR_safe_tsd{mouse} = tsd([.5e4:1e4:length(Diff_HR_safe{mouse})*1e4-.5e4] , Diff_HR_safe{mouse}');
end


for mouse=1:length(Mouse)
    for i=1:20
        SmallEp = intervalSet((i-1)*60e4*bin_size , i*60e4*bin_size);
        
        Diff_HR_SHOCK(mouse,i) = nanmean(Data(Restrict(Diff_HR_shock_tsd{mouse} , SmallEp)));
        Diff_HR_SAFE(mouse,i) = nanmean(Data(Restrict(Diff_HR_safe_tsd{mouse} , SmallEp)));
    end
end



figure
Data_to_use = movmean(Diff_HR_SHOCK',2,'omitnan')';
Conf_Inter=nanstd(Data_to_use)/sqrt(size(Data_to_use,1));
Mean_All_Sp=nanmean(Data_to_use);
shadedErrorBar([1:6:20*6] , Mean_All_Sp , Conf_Inter ,'-r',1); hold on;
Data_to_use = movmean(Diff_HR_SAFE',2,'omitnan')';
Conf_Inter=nanstd(Data_to_use)/sqrt(size(Data_to_use,1));
Mean_All_Sp=nanmean(Data_to_use);
shadedErrorBar([1:6:20*6] , Mean_All_Sp , Conf_Inter ,'-b',1); hold on;


box off, xlim([0 100]), ylim([0 3])
ylabel('shocks (#/min)')



figure
subplot(121)
Data_to_use = movmean(Diff_HR_SAFE',2,'omitnan')';
Conf_Inter=nanstd(Data_to_use)/sqrt(size(Data_to_use,1));
Mean_All_Sp=nanmean(Data_to_use);
yyaxis left
shadedErrorBar([1:6:20*6] , Mean_All_Sp , Conf_Inter ,'-b',1); hold on;
box off, xlim([0 100]), ylim([0 3])
ylabel('shocks (#/min)')







