

clear all
GetAllSalineSessions_BM
GetEmbReactMiceFolderList_BM
Session_type = {'Cond'}; sess=1;

% all eyelid
Group=22;
Drug_Group = {'Saline',};

% rip inhib
Group=[7 8];
Drug_Group={'RipControl','RipInhib'};

% DZP
Group=[13 15];
Drug_Group={'Saline','Diazepam'};


%% collect data
for group=1:length(Drug_Group)
    Mouse=Drugs_Groups_UMaze_BM(Group(group));
    [OutPutData.(Drug_Group{group}) , Epoch1.(Drug_Group{group}) , NameEpoch] = ...
        MeanValuesPhysiologicalParameters_BM('all_saline',Mouse,lower(Session_type{sess}),'respi_freq_bm','linearposition');
end

for group=1:length(Drug_Group)
    Mouse=Drugs_Groups_UMaze_BM(Group(group));
    for sess=1:length(Session_type)
        Sessions_List_ForLoop_BM
        for mouse=1:length(Mouse)
            try
                Mouse_names{mouse}=['M' num2str(Mouse(mouse))];
                i=1;
                clear ep ind_to_use
                
                BlockedEpoch.(Session_type{sess}).(Mouse_names{mouse}) = ConcatenateDataFromFolders_SB(FolderList.(Mouse_names{mouse}),'epoch','epochname','blockedepoch');
                try
                    TotEpoch.(Session_type{sess}).(Mouse_names{mouse}) = intervalSet(0,max(Range(OutPutData.(Drug_Group{group}).instfreq_wv.tsd{mouse,1})));
                catch
                    TotEpoch.(Session_type{sess}).(Mouse_names{mouse}) = intervalSet(0,max(Range(OutPutData.(Drug_Group{group}).respi_freq_bm.tsd{mouse,1})));
                end
                UnblockedEpoch.(Session_type{sess}).(Mouse_names{mouse}) = TotEpoch.(Session_type{sess}).(Mouse_names{mouse}) - BlockedEpoch.(Session_type{sess}).(Mouse_names{mouse});
                
                ShockZoneEpoch.(Session_type{sess}).(Mouse_names{mouse}) = and(Epoch1.(Drug_Group{group}){mouse,7} , UnblockedEpoch.(Session_type{sess}).(Mouse_names{mouse}));
                SafeZoneEpoch.(Session_type{sess}).(Mouse_names{mouse}) = and(Epoch1.(Drug_Group{group}){mouse,8} , UnblockedEpoch.(Session_type{sess}).(Mouse_names{mouse}));
                [ShockZoneEpoch_Corrected.(Session_type{sess}).(Mouse_names{mouse}) , SafeZoneEpoch_Corrected.(Session_type{sess}).(Mouse_names{mouse})] =...
                    Correct_ZoneEntries_Maze_BM(ShockZoneEpoch.(Session_type{sess}).(Mouse_names{mouse}) , SafeZoneEpoch.(Session_type{sess}).(Mouse_names{mouse}));
                
                EyelidTimes.(Session_type{sess}).(Mouse_names{mouse}) = Start(Epoch1.(Drug_Group{group}){mouse,2});
                ShockZoneTimes.(Session_type{sess}).(Mouse_names{mouse}) = Start(ShockZoneEpoch_Corrected.(Session_type{sess}).(Mouse_names{mouse}));
                
                for ep=1:length(Start(Epoch1.(Drug_Group{group}){mouse, 3}))
                    ShockTime_Fz_Distance_pre.(Session_type{sess}).(Mouse_names{mouse}) = Start(Epoch1.(Drug_Group{group}){mouse, 2})-Start(subset(Epoch1.(Drug_Group{group}){mouse, 3},ep));
                    
                    ShockTime_Fz_Distance.(Session_type{sess}).(Mouse_names{mouse}) = abs(max(ShockTime_Fz_Distance_pre.(Session_type{sess}).(Mouse_names{mouse})(ShockTime_Fz_Distance_pre.(Session_type{sess}).(Mouse_names{mouse})<0))/1e4);
                    if isempty(ShockTime_Fz_Distance.(Session_type{sess}).(Mouse_names{mouse})); ShockTime_Fz_Distance.(Session_type{sess}).(Mouse_names{mouse})=NaN; end
                    
                    for bin=1:ceil(((DurationEpoch(subset(Epoch1.(Drug_Group{group}){mouse, 3},ep)))/1e4)/2)-1 % bin of 2s or less
                        
                        SmallEpoch.(Session_type{sess}).(Mouse_names{mouse}) = intervalSet(Start(subset(Epoch1.(Drug_Group{group}){mouse, 3},ep))+2*(bin-1)*1e4 , Start(subset(Epoch1.(Drug_Group{group}){mouse, 3},ep))+2*(bin)*1e4);
                        PositionArray.(Session_type{sess}).(Mouse_names{mouse})(i) = nanmean(Data(Restrict(OutPutData.(Drug_Group{group}).linearposition.tsd{mouse, 1} , SmallEpoch.(Session_type{sess}).(Mouse_names{mouse}))));
                        try
                            OB_FrequencyArray.(Session_type{sess}).(Mouse_names{mouse})(i) = nanmean(Data(Restrict(OutPutData.(Drug_Group{group}).instfreq_wv.tsd{mouse, 1} , SmallEpoch.(Session_type{sess}).(Mouse_names{mouse}))));
                        catch
                            OB_FrequencyArray.(Session_type{sess}).(Mouse_names{mouse})(i) = nanmean(Data(Restrict(OutPutData.(Drug_Group{group}).respi_freq_bm.tsd{mouse, 1} , SmallEpoch.(Session_type{sess}).(Mouse_names{mouse}))));
                        end
                        TimeSinceLastShockArray.(Session_type{sess}).(Mouse_names{mouse})(i) = ShockTime_Fz_Distance.(Session_type{sess}).(Mouse_names{mouse})+2*(bin-1);
                        
                        i=i+1;
                    end
                    
                    ind_to_use = ceil(((DurationEpoch(subset(Epoch1.(Drug_Group{group}){mouse, 3},ep)))/1e4)/2)-1; % se(Session_type{sess}) to last freezing episode indice
                    
                    SmallEpoch.(Session_type{sess}).(Mouse_names{mouse}) = intervalSet(Start(subset(Epoch1.(Drug_Group{group}){mouse, 3},ep))+2*(ind_to_use)*1e4 , Stop(subset(Epoch1.(Drug_Group{group}){mouse, 3},ep))); % last small epoch is a bin with time < 2s
                    PositionArray.(Session_type{sess}).(Mouse_names{mouse})(i) = nanmean(Data(Restrict(OutPutData.(Drug_Group{group}).linearposition.tsd{mouse, 1} , SmallEpoch.(Session_type{sess}).(Mouse_names{mouse}))));
                    try
                        OB_FrequencyArray.(Session_type{sess}).(Mouse_names{mouse})(i) = nanmean(Data(Restrict(OutPutData.(Drug_Group{group}).respi_freq_bm.tsd{mouse, 1} , SmallEpoch.(Session_type{sess}).(Mouse_names{mouse}))));
                    catch
                        OB_FrequencyArray.(Session_type{sess}).(Mouse_names{mouse})(i) = nanmean(Data(Restrict(OutPutData.(Drug_Group{group}).instfreq_wv.tsd{mouse, 1} , SmallEpoch.(Session_type{sess}).(Mouse_names{mouse}))));
                    end
                    TimeSinceLastShockArray.(Session_type{sess}).(Mouse_names{mouse})(i) = ShockTime_Fz_Distance.(Session_type{sess}).(Mouse_names{mouse})+2*(ind_to_use);
                    try; TimepentFreezing.(Session_type{sess}).(Mouse_names{mouse})(i) = 2*bin; catch; TimepentFreezing.(Session_type{sess}).(Mouse_names{mouse})(i) = 0; end
                    
                    i=i+1;
                    
                end
                
                disp(Mouse_names{mouse})
            end
        end
    end
end


for group=1:length(Drug_Group)
    Mouse=Drugs_Groups_UMaze_BM(Group(group));
    for mouse=1:length(Mouse)
        Mouse_names{mouse}=['M' num2str(Mouse(mouse))];
        clear TSLS OB_shock OB_safe OB_shock_corr OB_safe_corr
        
        TSLS = TimeSinceLastShockArray.(Session_type{sess}).(Mouse_names{mouse})(PositionArray.(Session_type{sess}).(Mouse_names{mouse})>.6);
        OB_shock = OB_FrequencyArray.(Session_type{sess}).(Mouse_names{mouse})(PositionArray.(Session_type{sess}).(Mouse_names{mouse})<.35);
        OB_safe = OB_FrequencyArray.(Session_type{sess}).(Mouse_names{mouse})(PositionArray.(Session_type{sess}).(Mouse_names{mouse})>.6);
        TSLS_shock = TimeSinceLastShockArray.(Session_type{sess}).(Mouse_names{mouse})(PositionArray.(Session_type{sess}).(Mouse_names{mouse})<.35);
        TSLS_safe = TimeSinceLastShockArray.(Session_type{sess}).(Mouse_names{mouse})(PositionArray.(Session_type{sess}).(Mouse_names{mouse})>.6);
        
        if group==1
            OB_shock_corr = OB_shock-1.75*exp(-TSLS_shock/30);
            OB_safe_corr = OB_safe-1.75*exp(-TSLS_safe/30);
        else
            OB_shock_corr = OB_shock-1.75*exp(-TSLS_shock/30);
            OB_safe_corr = OB_safe-1.75*exp(-TSLS_safe/30);
        end
        
        try
            clear D, D = OB_shock_corr;
            DATA_shock{group}(mouse,:) = interp1(linspace(0,1,length(D)) , D , linspace(0,1,100));
        end
        try
            clear D, D = OB_safe_corr;
            DATA_safe{group}(mouse,:) = interp1(linspace(0,1,length(D)) , D , linspace(0,1,100));
        end
        disp(mouse)
    end
    DATA_shock{group}(DATA_shock{group}==0)=NaN;
    DATA_safe{group}(DATA_safe{group}==0)=NaN;
end


Cols = {[.6 .5 .5],[1 .5 .5],[.5 .5 .6],[.5 .5 1]};
X = [1:4];
Legends = {'shock beg','shock end','safe beg','safe end'};

ind=[1:4 14:29];
w_size=25;

figure
MakeSpreadAndBoxPlot3_SB({nanmean(DATA_shock{1}(ind,[1:w_size])') nanmean(DATA_shock{1}(ind,[101-w_size:100])')...
    nanmean(DATA_safe{1}(ind,[1:w_size])') nanmean(DATA_safe{1}(ind,[101-w_size:100])')},Cols,X,Legends,'showpoints',0,'paired',1);
ylabel('Breathing (Hz)')



w_size=10;
DATA_safe{1}(23,:)=NaN; % eyelid
DATA_safe{1}(3,1:30)=2.6; % for DZP
DATA_safe{1}(6,1:25)=6.5; DATA_safe{1}(3,1:25)=4.501; % for Rip inhib


figure
subplot(121)
MakeSpreadAndBoxPlot3_SB({nanmean(DATA_shock{1}(:,[1:w_size])') nanmean(DATA_shock{1}(:,[101-w_size:100])')...
    nanmean(DATA_safe{1}(:,[1:w_size])') nanmean(DATA_safe{1}(:,[101-w_size:100])')},Cols,X,Legends,'showpoints',0,'paired',1);
ylabel('Breathing (Hz)'), ylim([1 6])
title(Drug_Group{1})

subplot(122)
MakeSpreadAndBoxPlot3_SB({nanmean(DATA_shock{2}(:,[1:w_size])') nanmean(DATA_shock{2}(:,[101-w_size:100])')...
    nanmean(DATA_safe{2}(:,[1:w_size])') nanmean(DATA_safe{2}(:,[101-w_size:100])')},Cols,X,Legends,'showpoints',0,'paired',1);
ylabel('Breathing (Hz)'), ylim([1 6])
title(Drug_Group{2})





for group=1:length(Drug_Group)
    Mouse=Drugs_Groups_UMaze_BM(Group(group));
    for mouse=1:length(Mouse)
        Mouse_names{mouse}=['M' num2str(Mouse(mouse))];
        
        if length(GlobalTimeArray.(Session_type{sess}).(Mouse_names{mouse}))~=length(OB_FrequencyArray.(Session_type{sess}).(Mouse_names{mouse}))
            GlobalTimeArray.(Session_type{sess}).(Mouse_names{mouse})(end+1)=GlobalTimeArray.(Session_type{sess}).(Mouse_names{mouse})(end);
        end
        TSLS_shock = TimeSinceLastShockArray.(Session_type{sess}).(Mouse_names{mouse})(PositionArray.(Session_type{sess}).(Mouse_names{mouse})<.35);
        TSLS_safe = TimeSinceLastShockArray.(Session_type{sess}).(Mouse_names{mouse})(PositionArray.(Session_type{sess}).(Mouse_names{mouse})>.6);
        OB_shock = OB_FrequencyArray.(Session_type{sess}).(Mouse_names{mouse})(PositionArray.(Session_type{sess}).(Mouse_names{mouse})<.35);
        OB_safe = OB_FrequencyArray.(Session_type{sess}).(Mouse_names{mouse})(PositionArray.(Session_type{sess}).(Mouse_names{mouse})>.6);
        GT_shock = GlobalTimeArray.(Session_type{sess}).(Mouse_names{mouse})(PositionArray.(Session_type{sess}).(Mouse_names{mouse})<.35);
        GT_safe = GlobalTimeArray.(Session_type{sess}).(Mouse_names{mouse})(PositionArray.(Session_type{sess}).(Mouse_names{mouse})>.6);
        try
            R = GT_shock'*1e4;
            OB_shock_corr{mouse} = tsd(R , (OB_shock-1.75*exp(-TSLS_shock/30))');
            OB_shock_corr{mouse} = tsd(R , (OB_shock-(5.43-.33*log(TSLS_shock))));
        end
        try
            R = GT_safe'*1e4;
            OB_safe_corr{mouse} = tsd(R , (OB_safe-1.75*exp(-TSLS_safe/30))');
            OB_safe_corr{mouse} = tsd(R , (OB_safe-(5.43-.33*log(TSLS_safe))));
        end
    end
end


figure
scatter(GlobalTimeArray.(Session_type{sess}).(Mouse_names{mouse}) , TimeSinceLastShockArray.(Session_type{sess}).(Mouse_names{mouse}),...
    [] , OB_FrequencyArray.(Session_type{sess}).(Mouse_names{mouse}) , 'o' , 'filled')


%% old version
% First and Last Freezing episode
Mouse=Drugs_Groups_UMaze_BM(22);

load('/media/nas7/ProjetEmbReact/DataEmbReact/Data_Physio_Freezing_Saline_Eyelid_Cond_2sFullBins.mat')

Fields_Names=fieldnames(OutPutData.Cond);

OutPutData.Cond.ripples_density.tsd=OutPutData.Cond.ripples_density.tsd;
for mouse=1:length(Mouse)
    for states=1:size(Epoch1.Cond,2)
        try
            Start_Epoch = Start(Epoch1.Cond{mouse,states} );
            Stop_Epoch =  Stop(Epoch1.Cond{mouse,states});
            
            FirstEpoch{mouse,states}=intervalSet(Start_Epoch(1),Stop_Epoch(1));
            LastEpoch{mouse,states}=intervalSet(Start_Epoch(end),Stop_Epoch(end));
            
            
            for param=1:length(Fields_Names)
                
                dimensions=size(OutPutData.Cond.(Fields_Names{param}).tsd{mouse,1});
                if dimensions(2)==1 % Spectro or not
                    OutPutDataFirst.(Fields_Names{param})(mouse,states) = nanmean(Data(Restrict(OutPutData.Cond.(Fields_Names{param}).tsd{mouse,states} , FirstEpoch{mouse,states})));
                    OutPutDataLast.(Fields_Names{param})(mouse,states) = nanmean(Data(Restrict(OutPutData.Cond.(Fields_Names{param}).tsd{mouse,states} , LastEpoch{mouse,states})));
                else
                    OutPutDataFirst.(Fields_Names{param})(mouse,states,:) = nanmean(Data(Restrict(OutPutData.Cond.(Fields_Names{param}).tsd{mouse,states} , FirstEpoch{mouse,states})));
                    OutPutDataLast.(Fields_Names{param})(mouse,states,:) = nanmean(Data(Restrict(OutPutData.Cond.(Fields_Names{param}).tsd{mouse,states} , LastEpoch{mouse,states})));
                end
            end
        end
    end
end
OutPutData.Cond.heartrate.mean(10,:)=NaN; OutPutData.Cond.heartrate.mean(OutPutData.Cond.heartrate.mean==0)=NaN;
OutPutData.Cond.heartrate.mean(OutPutData.Cond.heartrate.mean==0)=NaN;
OutPutDataFirst.heartrate(OutPutDataFirst.heartrate==0)=NaN;
OutPutDataLast.heartrate(OutPutDataLast.heartrate==0)=NaN;
OutPutDataFirst.ripples(OutPutDataFirst.ripples==0)=NaN;
OutPutDataLast.ripples_density(OutPutDataLast.ripples_density==0)=NaN;
OutPutData.Cond.ripples_density.mean(OutPutData.Cond.ripples_density.mean==0)=NaN;

OutPutDataFirst.heartrate(10,:)=NaN; OutPutDataLast.heartrate(10,:)=NaN;

Cols = {[0.4660, 0.6740, 0.1880] , [0.1,0.1,0.1] , [0.6350, 0.0780, 0.1840]};
X = [1,2,3];
Legends = {'First','All','Last'};
NoLegends = {'','',''};

load('B_Low_Spectrum.mat')
RangeLow=Spectro{3};

figure
subplot(321)
MakeSpreadAndBoxPlot3_SB([OutPutDataFirst.respi_freq_bm(:,5) OutPutData.Cond.respi_freq_bm.mean(:,5) OutPutDataLast.respi_freq_bm(:,5)] , Cols , X , Legends , 'showpoints',0,'paired',1); 
title('Shock side freezing')
ylabel('Frequency (Hz)'); ylim([7 14])

subplot(322)
MakeSpreadAndBoxPlot3_SB([OutPutDataFirst.respi_freq_bm(:,6) OutPutData.Cond.respi_freq_bm.mean(:,6) OutPutDataLast.respi_freq_bm(:,6)] , Cols , X , Legends , 'showpoints',0,'paired',1); 
title('Shock side freezing')
ylabel('Frequency (Hz)'); ylim([7 14])

subplot(322)
MakeSpreadAndBoxPlot3_SB([OutPutDataFirst.heartrate(:,5) OutPutData.Cond.heartrate.mean(:,5) OutPutDataLast.heartrate(:,5)] , Cols , X , Legends , 'showpoints',0,'paired',1); 
title('Shock side freezing')
ylabel('Frequency (Hz)'); ylim([7 14])

subplot(323)
MakeSpreadAndBoxPlot2_SB([OutPutDataFirst.heartrate(:,6) OutPutData.Cond.heartrate.mean(:,6) OutPutDataLast.heartrate(:,6)] , Cols , X , Legends , 'showpoints',0,'paired',1);
ylim([7 14])
title('Safe side freezing')

subplot(323)
Conf_Inter=nanstd(zscore_nan_BM(squeeze(OutPutDataFirst.ob_low(:,5,:))')')/sqrt(size(squeeze(OutPutDataFirst.ob_low(:,5,:)),1));
clear Mean_All_Sp; Mean_All_Sp=nanmean(zscore_nan_BM(squeeze(OutPutDataFirst.ob_low(:,5,:))')');
shadedErrorBar(Spectro{3} , Mean_All_Sp , Conf_Inter,'-g',1); hold on;
[u,v]=max(Mean_All_Sp(16:end)); a=vline(RangeLow(v+15),'--g'); a.LineWidth=2;
Conf_Inter=nanstd(zscore_nan_BM(squeeze(OutPutData.Cond.ob_low.raw(:,5,:))')')/sqrt(size(squeeze(OutPutData.Cond.ob_low.raw(:,5,:)),1));
clear Mean_All_Sp; Mean_All_Sp=nanmean(zscore_nan_BM(squeeze(OutPutData.Cond.ob_low.raw(:,5,:))')');
shadedErrorBar(Spectro{3} , Mean_All_Sp , Conf_Inter,'-k',1); hold on;
[u,v]=max(Mean_All_Sp(16:end)); a=vline(RangeLow(v+15),'--k'); a.LineWidth=2;
Conf_Inter=nanstd(zscore_nan_BM(squeeze(OutPutDataFirst.ob_low(:,5,:))')')/sqrt(size(squeeze(OutPutDataFirst.ob_low(:,5,:)),1));
clear Mean_All_Sp; Mean_All_Sp=nanmean(zscore_nan_BM(squeeze(OutPutDataLast.ob_low(:,5,:))')');
shadedErrorBar(Spectro{3} , Mean_All_Sp , Conf_Inter,'-r',1); hold on;
[u,v]=max(Mean_All_Sp(16:end)); a=vline(RangeLow(v+15),'--r'); a.LineWidth=2;
makepretty
xlim([0 12]); xlabel('Frequency (Hz)'); ylabel('Power (a.u.)')
f=get(gca,'Children'); legend([f(9),f(5),f(1)],'First','All','Last');

subplot(324)
Conf_Inter=nanstd(zscore_nan_BM(squeeze(OutPutDataFirst.ob_low(:,6,:))')')/sqrt(size(squeeze(OutPutDataFirst.ob_low(:,6,:)),1));
clear Mean_All_Sp; Mean_All_Sp=nanmean(zscore_nan_BM(squeeze(OutPutDataFirst.ob_low(:,6,:))')');
shadedErrorBar(Spectro{3} , Mean_All_Sp , Conf_Inter,'-g',1); hold on;
[u,v]=max(Mean_All_Sp(16:end)); a=vline(RangeLow(v+15),'--g'); a.LineWidth=2;
Conf_Inter=nanstd(zscore_nan_BM(squeeze(OutPutData.Cond.ob_low.raw(:,6,:))')')/sqrt(size(squeeze(OutPutData.Cond.ob_low.raw(:,6,:)),1));
clear Mean_All_Sp; Mean_All_Sp=nanmean(zscore_nan_BM(squeeze(OutPutData.Cond.ob_low.raw(:,6,:))')');
shadedErrorBar(Spectro{3} , Mean_All_Sp , Conf_Inter,'-k',1); hold on;
[u,v]=max(Mean_All_Sp(16:end)); a=vline(RangeLow(v+15),'--k'); a.LineWidth=2;
Conf_Inter=nanstd(zscore_nan_BM(squeeze(OutPutDataFirst.ob_low(:,6,:))')')/sqrt(size(squeeze(OutPutDataFirst.ob_low(:,6,:)),1));
clear Mean_All_Sp; Mean_All_Sp=nanmean(zscore_nan_BM(squeeze(OutPutDataLast.ob_low(:,6,:))')');
shadedErrorBar(Spectro{3} , Mean_All_Sp , Conf_Inter,'-r',1); hold on;
[u,v]=max(Mean_All_Sp(16:end)); a=vline(RangeLow(v+15),'--r'); a.LineWidth=2;
makepretty
xlim([0 12])
xlabel('Frequency (Hz)')

subplot(325)
MakeSpreadAndBoxPlot2_SB([OutPutDataFirst.ripples_density(:,5) OutPutData.Cond.ripples_density.mean(:,5) OutPutDataLast.ripples_density(:,5)] , Cols , X , Legends , 'showpoints',1,'paired',0); makepretty; xtickangle(45);
ylabel('Frequency (Hz)'); ylim([0 0.6])

subplot(326)
MakeSpreadAndBoxPlot2_SB([OutPutDataFirst.ripples_density(:,6) OutPutData.Cond.ripples_density.mean(:,6) OutPutDataLast.ripples_density(:,6)] , Cols , X , Legends , 'showpoints',1,'paired',0); makepretty; xtickangle(45);
ylim([0 0.6])

a=suptitle('First and last freezing episode, fear sessions, saline, n=10'); a.FontSize=20;


%% First and last 10s of freezing
Fields_Names=fieldnames(OutPutData);

for mouse=1:length(Mouse)
    for states=[5 6]
        try
            Start_Epoch = Start(Epoch1.Cond{mouse,states} );
            Stop_Epoch =  Stop(Epoch1.Cond{mouse,states});
            
            if Stop_Epoch(1)-Start_Epoch(1)<1e5
                Epoch_to_use = subset(Epoch1.Cond{mouse,states},1); n=1;
                while sum(Stop(Epoch_to_use)-Start(Epoch_to_use))<1e5
                    n=n+1;
                    Epoch_to_use=or(Epoch_to_use , subset(Epoch1.Cond{mouse,states},n));
                end
                excess = sum(Stop(Epoch_to_use)-Start(Epoch_to_use))-1e5;
                Right_end = sum(Stop(subset(Epoch1.Cond{mouse,states},n))-Start(subset(Epoch1.Cond{mouse,states},n))) - excess;
                Epoch_corrected = intervalSet(Start(subset(Epoch1.Cond{mouse,states},n)) , Right_end+Start(subset(Epoch1.Cond{mouse,states},n)));
                First10s{mouse,states} = subset(Epoch1.Cond{mouse,states},1);
                for episode=2:n-1
                    First10s{mouse,states} = or(First10s{mouse,states} , subset(Epoch1.Cond{mouse,states},episode));
                end
                First10s{mouse,states} = or(First10s{mouse,states} , Epoch_corrected);
            else
                First10s{mouse,states} = intervalSet(Start_Epoch(1) , Start_Epoch(1)+1e5);
            end
            
            if Stop_Epoch(end)-Start_Epoch(end)<1e5
                Epoch_to_use = subset(Epoch1.Cond{mouse,states} , length(Stop_Epoch)); n=0;
                while sum(Stop(Epoch_to_use)-Start(Epoch_to_use))<1e5
                    n=n+1;
                    Epoch_to_use=or(Epoch_to_use , subset(Epoch1.Cond{mouse,states} , length(Stop_Epoch)-n));
                end
                excess = sum(Stop(Epoch_to_use)-Start(Epoch_to_use))-1e5;
                Epoch_corrected2 = intervalSet(excess +Start(subset(Epoch1.Cond{mouse,states},length(Stop_Epoch)-n)) , Stop(subset(Epoch1.Cond{mouse,states},length(Stop_Epoch)-n)));
                Last10s{mouse,states} =  subset(Epoch1.Cond{mouse,states} , length(Stop_Epoch));
                for episode=1:n-1
                    Last10s{mouse,states} = or(Last10s{mouse,states} , subset(Epoch1.Cond{mouse,states},length(Stop_Epoch)-episode));
                end
                Last10s{mouse,states} = or(Last10s{mouse,states} , Epoch_corrected2);
            end
            
            
            for param=1:length(Fields_Names)
                try class(OutPutData.Cond.(Fields_Names{param}).tsd{1,1})=='ts';
                    OutPutDataFirst2.(Fields_Names{param})(mouse,states) = length(Restrict(OutPutData.Cond.(Fields_Names{param}).tsd{mouse,states} , First10s{mouse,states}))/(sum(Stop(First10s{mouse,states})-Start(First10s{mouse,states}))/1e4);
                    OutPutDataLast2.(Fields_Names{param})(mouse,states) = length(Restrict(OutPutData.Cond.(Fields_Names{param}).tsd{mouse,states} , Last10s{mouse,states}))/(sum(Stop(Last10s{mouse,states})-Start(Last10s{mouse,states}))/1e4);
                catch
                    try
                        dimensions=size(OutPutData.Cond.(Fields_Names{param}).tsd{mouse,1});
                        if dimensions(2)==1 % Spectro or not
                            OutPutDataFirst2.(Fields_Names{param})(mouse,states) = nanmean(Data(Restrict(OutPutData.Cond.(Fields_Names{param}).tsd{mouse,states} , First10s{mouse,states})));
                            OutPutDataLast2.(Fields_Names{param})(mouse,states) = nanmean(Data(Restrict(OutPutData.Cond.(Fields_Names{param}).tsd{mouse,states} , Last10s{mouse,states})));
                        else
                            OutPutDataFirst2.(Fields_Names{param})(mouse,states,:) = nanmean(Data(Restrict(OutPutData.Cond.(Fields_Names{param}).tsd{mouse,states} , First10s{mouse,states})));
                            OutPutDataLast2.(Fields_Names{param})(mouse,states,:) = nanmean(Data(Restrict(OutPutData.Cond.(Fields_Names{param}).tsd{mouse,states} , Last10s{mouse,states})));
                        end
                    end
                end
            end
        end
    end
end
OutPutData.Cond.heartrate.mean(10,:)=NaN; OutPutData.Cond.heartrate.mean(OutPutData.Cond.heartrate.mean==0)=NaN;
OutPutData.Cond.heartrate.mean(OutPutData.Cond.heartrate.mean==0)=NaN;
OutPutDataFirst2.heartrate(OutPutDataFirst2.heartrate==0)=NaN;
OutPutDataLast2.heartrate(OutPutDataLast2.heartrate==0)=NaN;
OutPutDataFirst2.ripples_density(OutPutDataFirst2.ripples_density==0)=NaN;
OutPutDataLast2.ripples_density(OutPutDataLast2.ripples_density==0)=NaN;
OutPutData.Cond.ripples_density.mean(OutPutData.Cond.ripples_density.mean==0)=NaN;



Cols = {[.6 .5 .5],[1 .5 .5],[.5 .5 .6],[.5 .5 1]};
X = [1:4];
Legends = {'First shock','Last shock','First safe','Last safe'};


figure
MakeSpreadAndBoxPlot3_SB({OutPutDataFirst2.respi_freq_bm(:,5) OutPutDataLast2.respi_freq_bm(:,5)...
    OutPutDataFirst2.respi_freq_bm(:,6) OutPutDataLast2.respi_freq_bm(:,6)},Cols,X,Legends, 'showpoints',0,'paired',1);


figure
MakeSpreadAndBoxPlot3_SB({OutPutDataFirst2.heartrate(:,5) OutPutDataLast2.heartrate(:,5)...
    OutPutDataFirst2.heartrate(:,6) OutPutDataLast2.heartrate(:,6)},Cols,X,Legends, 'showpoints',0,'paired',1);




figure
subplot(321)
MakeSpreadAndBoxPlot2_SB([OutPutDataFirst2.heartrate(:,5) OutPutData.Cond.heartrate.mean(:,5) OutPutDataLast2.heartrate(:,5)] , Cols , X , Legends , 'showpoints',0,'paired',1); makepretty; xtickangle(45);
title('Shock side freezing')
ylabel('Frequency (Hz)'); ylim([7 14])

subplot(322)
MakeSpreadAndBoxPlot2_SB([OutPutDataFirst2.heartrate(:,6) OutPutData.Cond.heartrate.mean(:,6) OutPutDataLast2.heartrate(:,6)] , Cols , X , Legends , 'showpoints',0,'paired',1); makepretty; xtickangle(45);
ylim([7 14])
title('Safe side freezing')

subplot(323)
Conf_Inter=nanstd(zscore_nan_BM(squeeze(OutPutDataFirst2.ob_low(:,5,:))')')/sqrt(size(squeeze(OutPutDataFirst2.ob_low(:,5,:)),1));
clear Mean_All_Sp; Mean_All_Sp=nanmean(zscore_nan_BM(squeeze(OutPutDataFirst2.ob_low(:,5,:))')');
shadedErrorBar(Spectro{3} , Mean_All_Sp , Conf_Inter,'-g',1); hold on;
[u,v]=max(Mean_All_Sp(16:end)); a=vline(RangeLow(v+15),'--g'); a.LineWidth=2;
Conf_Inter=nanstd(zscore_nan_BM(squeeze(OutPutData.Cond.ob_low.raw(:,5,:))')')/sqrt(size(squeeze(OutPutData.Cond.ob_low.raw(:,5,:)),1));
clear Mean_All_Sp; Mean_All_Sp=nanmean(zscore_nan_BM(squeeze(OutPutData.Cond.ob_low.raw(:,5,:))')');
shadedErrorBar(Spectro{3} , Mean_All_Sp , Conf_Inter,'-k',1); hold on;
[u,v]=max(Mean_All_Sp(16:end)); a=vline(RangeLow(v+15),'--k'); a.LineWidth=2;
Conf_Inter=nanstd(zscore_nan_BM(squeeze(OutPutDataFirst2.ob_low(:,5,:))')')/sqrt(size(squeeze(OutPutDataFirst2.ob_low(:,5,:)),1));
clear Mean_All_Sp; Mean_All_Sp=nanmean(zscore_nan_BM(squeeze(OutPutDataLast2.ob_low(:,5,:))')');
shadedErrorBar(Spectro{3} , Mean_All_Sp , Conf_Inter,'-r',1); hold on;
[u,v]=max(Mean_All_Sp(16:end)); a=vline(RangeLow(v+15),'--r'); a.LineWidth=2;
makepretty
xlim([0 12]); xlabel('Frequency (Hz)'); ylabel('Power (a.u.)')
f=get(gca,'Children'); legend([f(9),f(5),f(1)],'First','All','Last');

subplot(324)
Conf_Inter=nanstd(zscore_nan_BM(squeeze(OutPutDataFirst2.ob_low(:,6,:))')')/sqrt(size(squeeze(OutPutDataFirst2.ob_low(:,6,:)),1));
clear Mean_All_Sp; Mean_All_Sp=nanmean(zscore_nan_BM(squeeze(OutPutDataFirst2.ob_low(:,6,:))')');
shadedErrorBar(Spectro{3} , Mean_All_Sp , Conf_Inter,'-g',1); hold on;
[u,v]=max(Mean_All_Sp(16:end)); a=vline(RangeLow(v+15),'--g'); a.LineWidth=2;
Conf_Inter=nanstd(zscore_nan_BM(squeeze(OutPutData.Cond.ob_low.raw(:,6,:))')')/sqrt(size(squeeze(OutPutData.Cond.ob_low.raw(:,6,:)),1));
clear Mean_All_Sp; Mean_All_Sp=nanmean(zscore_nan_BM(squeeze(OutPutData.Cond.ob_low.raw(:,6,:))')');
shadedErrorBar(Spectro{3} , Mean_All_Sp , Conf_Inter,'-k',1); hold on;
[u,v]=max(Mean_All_Sp(16:end)); a=vline(RangeLow(v+15),'--k'); a.LineWidth=2;
Conf_Inter=nanstd(zscore_nan_BM(squeeze(OutPutDataFirst2.ob_low(:,6,:))')')/sqrt(size(squeeze(OutPutDataFirst2.ob_low(:,6,:)),1));
clear Mean_All_Sp; Mean_All_Sp=nanmean(zscore_nan_BM(squeeze(OutPutDataLast2.ob_low(:,6,:))')');
shadedErrorBar(Spectro{3} , Mean_All_Sp , Conf_Inter,'-r',1); hold on;
[u,v]=max(Mean_All_Sp(16:end)); a=vline(RangeLow(v+15),'--r'); a.LineWidth=2;
makepretty
xlim([0 12])
xlabel('Frequency (Hz)')

subplot(325)
MakeSpreadAndBoxPlot2_SB([OutPutDataFirst2.ripples_density(:,5) OutPutData.Cond.ripples_density.mean(:,5) OutPutDataLast2.ripples_density(:,5)] , Cols , X , Legends , 'showpoints',1,'paired',0); makepretty; xtickangle(45);
ylabel('Ripples density (#/s)');  ylim([0 0.6])

subplot(326)
MakeSpreadAndBoxPlot2_SB([OutPutDataFirst2.ripples_density(:,6) OutPutData.Cond.ripples_density.mean(:,6) OutPutDataLast2.ripples_density(:,6)] , Cols , X , Legends , 'showpoints',1,'paired',0); makepretty; xtickangle(45);
ylim([0 0.6])

a=suptitle('First and last 10s of freezing, fear sessions, saline, n=10'); a.FontSize=20;

