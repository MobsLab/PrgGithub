


clear all
GetAllSalineSessions_BM
Session_type={'TestPre','Cond'};
% Session_type={'TestPre','TestPost'};

Group=[22];
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
            
            if isempty(max(Range(Speed.(Session_type{sess}).(Mouse_names{mouse}))))
                TotalEpoch.(Session_type{sess}).(Mouse_names{mouse}) = intervalSet([],[]);
            else
                TotalEpoch.(Session_type{sess}).(Mouse_names{mouse}) = intervalSet(0 , max(Range(Speed.(Session_type{sess}).(Mouse_names{mouse}))));
            end
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


for sess=1:length(Session_type)
    for mouse=1:length(Mouse)
        Mouse_names{mouse}=['M' num2str(Mouse(mouse))];
        for param=1:length(Param)
            
            try
                Corr_Speed_Physio_all.(Param{param}).(Session_type{sess})(mouse,:,:) = Corr_Speed_Physio.(Param{param}).(Session_type{sess}).(Mouse_names{mouse});
                HistData_Physio_all.(Param{param}).(Session_type{sess})(mouse,:) = runmean(HistData_Physio.(Param{param}).(Session_type{sess}).(Mouse_names{mouse})/nansum(HistData_Physio.(Param{param}).(Session_type{sess}).(Mouse_names{mouse})),3);
                
                D = Data(Speed.(Session_type{sess}).(Mouse_names{mouse})); D(D==0) = NaN;
                Speed_mean{sess}(mouse) = nanmean(log10(D));
                Respi_mean{sess}(mouse) = nanmean(Data(Respi.(Session_type{sess}).(Mouse_names{mouse})));
                HR_mean{sess}(mouse) = nanmean(Data(HeartRate.(Session_type{sess}).(Mouse_names{mouse})));
                HRVar_mean{sess}(mouse) = nanmean(Data(HeartRateVar.(Session_type{sess}).(Mouse_names{mouse})));
            end
            
            try
                Freeze_Prop{sess}(mouse) = sum(DurationEpoch(FreezeEpoch.(Session_type{sess}).(Mouse_names{mouse})))./max(Range(Speed.(Session_type{sess}).(Mouse_names{mouse})));
            end
        end
        Corr_Speed_Physio_all_mean.(Param{param}).(Session_type{sess}) = nanmean(Corr_Speed_Physio_all.(Param{param}).(Session_type{sess}));
        Corr_Speed_Physio_all_squeeze.(Param{param}).(Session_type{sess}) = squeeze(Corr_Speed_Physio_all_mean.(Param{param}).(Session_type{sess}));
        
        clear A B min_to_use
        A=runmean_BM(runmean_BM(Corr_Speed_Physio_all_squeeze.(Param{param}).(Session_type{sess})',3)',3);
        B=A;
        B(B==0)=NaN;
        min_to_use = min(min(B));
        A=A*(1/min_to_use);
        Corr_Speed_Physio_all_corrected.(Param{param}).(Session_type{sess})=log10(A);
    end
end


for param=1:length(Param)
    for sess=1:length(Session_type)
        for i=1:size(HistData_Physio_all.(Param{param}).(Session_type{sess}))
            if  mean(double(HistData_Physio_all.(Param{param}).(Session_type{sess})(i,:)==zeros(1,144)))==1
                HistData_Physio_all.(Param{param}).(Session_type{sess})(i,:)=NaN;
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
    for mouse=1:length(Mouse)
        Mouse_names{mouse}=['M' num2str(Mouse(mouse))];
        for sess=1:length(Session_type)
            try
                H.(Param{param}).(Session_type{sess})(mouse,:) = ...
                    sum(Corr_Speed_Physio.(Param{param}).(Session_type{sess}).(Mouse_names{mouse})./...
                    nansum(Corr_Speed_Physio.(Param{param}).(Session_type{sess}).(Mouse_names{mouse})).*(linspace(thr_physio1,thr_physio2,100)'));
            end
        end
    end
end

for param=1:length(Param)
    for sess=1:length(Session_type)
        H.(Param{param}).(Session_type{sess})(H.(Param{param}).(Session_type{sess})==0) = NaN;
    end
end


%% figures
Cols = {[.3, .745, .93],[.85, .325, .098]};

figure
subplot(131)
MakeSpreadAndBoxPlot3_SB(Respi_mean,Cols,[1,2],{'Habituation','Conditioning'},'showpoints',1,'paired',0)
ylabel('Breathing (Hz)')
makepretty_BM2

subplot(132)
MakeSpreadAndBoxPlot3_SB(HR_mean,Cols,[1,2],{'Habituation','Conditioning'},'showpoints',1,'paired',0)
ylabel('Heart rate (Hz)')
makepretty_BM2

subplot(133)
MakeSpreadAndBoxPlot3_SB(HRVar_mean,Cols,[1,2],{'Habituation','Conditioning'},'showpoints',1,'paired',0)
ylabel('Heart rate variability (a.u.)')
makepretty_BM2


figure
subplot(131), param=1;
Data_to_use = H.(Param{param}).(Session_type{1}); Data_to_use(Data_to_use==0)=NaN; Data_to_use=Data_to_use(:,2:66);
Conf_Inter=nanstd(Data_to_use)/sqrt(size(Data_to_use,1));
h=shadedErrorBar(linspace(0,10,65) , runmean(nanmean(Data_to_use),3) , runmean(Conf_Inter,3) ,'-k',1);
xlabel('Speed (cm/s)'), ylabel('Breathing (Hz)')
makepretty_BM2

subplot(132), param=2;
Data_to_use = H.(Param{param}).(Session_type{1}); Data_to_use(Data_to_use==0)=NaN; Data_to_use=Data_to_use(:,2:66);
Conf_Inter=nanstd(Data_to_use)/sqrt(size(Data_to_use,1));
h=shadedErrorBar(linspace(0,10,65) , runmean(nanmean(Data_to_use),3) , runmean(Conf_Inter,3) ,'-k',1);
xlabel('Speed (cm/s)'), ylabel('Heart rate (Hz)')
makepretty_BM2

subplot(133), param=3;
Data_to_use = H.(Param{param}).(Session_type{1}); Data_to_use(Data_to_use==0)=NaN; Data_to_use=Data_to_use(:,2:66);
Conf_Inter=nanstd(Data_to_use)/sqrt(size(Data_to_use,1));
h=shadedErrorBar(linspace(0,10,65) , runmean(nanmean(Data_to_use),3) , runmean(Conf_Inter,3) ,'-k',1);
xlabel('Speed (cm/s)'), ylabel('Heart rate variability (a.u.)')
makepretty_BM2


figure
subplot(121)
MakeSpreadAndBoxPlot3_SB(Speed_mean,Cols,[1,2],{'Habituation','Conditioning'},'showpoints',1,'paired',0)
ylabel('Motion (log scale)')
makepretty_BM2

subplot(122)
MakeSpreadAndBoxPlot3_SB(Freeze_Prop,Cols,[1,2],{'Habituation','Conditioning'},'showpoints',1,'paired',0)
ylabel('Freezing proportion')
makepretty_BM2


l=linspace(0,10,65);
figure
for param=1:3
    
    subplot(1,3,param)
    
    Data_to_use = H.(Param{param}).(Session_type{1}); Data_to_use(Data_to_use==0)=NaN; Data_to_use=Data_to_use(:,2:66);
    Conf_Inter=nanstd(Data_to_use)/sqrt(size(Data_to_use,1));
    h=shadedErrorBar(linspace(0,10,65) , runmean(nanmean(Data_to_use),3) , runmean(Conf_Inter,3) ,'-k',1);
    col = Cols{1}; h.mainLine.Color=col; h.patch.FaceColor=col; h.edge(1).Color=col; h.edge(2).Color=col;
    hold on;
    Data_to_use = H.(Param{param}).(Session_type{2}); Data_to_use(Data_to_use==0)=NaN; Data_to_use=Data_to_use(:,2:66);
    Conf_Inter=nanstd(Data_to_use)/sqrt(size(Data_to_use,1));
    h=shadedErrorBar(linspace(0,10,65) , runmean(nanmean(Data_to_use),3) , runmean(Conf_Inter,3) ,'-k',1);
    col = Cols{2}; h.mainLine.Color=col; h.patch.FaceColor=col; h.edge(1).Color=col; h.edge(2).Color=col;
    
    for i=1:length(H.(Param{param}).(Session_type{1}))
        p{param}(i) = ttest(H.(Param{param}).(Session_type{1})(:,i) , H.(Param{param}).(Session_type{2})(:,i));
    end
    p{param}(isnan(p{param}))=0;
    y=ylim;
    plot(l(logical(p{param}(1:65))) , y(2) , '*k')
    
    makepretty_BM2
    if param==1; ylabel('Breathing (Hz)')
    elseif param==2;  ylabel('Heart rate (Hz)')
    elseif param==3;  ylabel('Heart rate variability (a.u.)')
    end
    xlabel('Speed (cm/s)')
    if param==1; f=get(gca,'Children'); legend([f(8),f(4)],'Habituation','Conditioning'); end
end


figure
plot(H.(Param{1}).(Session_type{2})')




