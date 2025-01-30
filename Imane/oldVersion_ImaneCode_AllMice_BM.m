

%% Imane's codes
clear all

% load spectrograms range 
cd('/media/nas4/ProjetEmbReact/Mouse688/20180209/ProjectEmbReact_M688_20180209_TestPre_PreDrug/TestPre2')
load('H_Low_Spectrum.mat'); RangeLow=Spectro{3};
load('B_Middle_Spectrum.mat'); RangeMiddle=Spectro{3};
load('B_High_Spectrum.mat'); RangeHigh=Spectro{3};
load('H_VHigh_Spectrum.mat'); RangeVHigh=Spectro{3};
Drug_Group={'SalineSB','ChronicFlx','AcuteFlx','Midazolam','SalineBM_Short','Diazepam_Short','SalineBM_Long','Diazepam_Long','Saline1','Saline2','DZP1','DZP2','RipInhib','ChronicBUS'};

% Load all necessary sessions for mice
cd('/media/nas6/ProjetEmbReact/transfer')
load('Sess.mat')
GetEmbReactMiceFolderList_BM
Session_type={'Fear','Cond','Ext','CondPre','CondPost','TestPre','TestPost'};
Session_type2={'sleep_pre','sleep_post'};

%% generate all behaviour variables
for mouse=1:length(Mouse)
    Mouse_names{mouse}=['M' num2str(Mouse(mouse))];
    for sess=1:length(Session_type)
        try
            if convertCharsToStrings(Session_type{sess})=='Fear'
                FolderList=FearSess;
            elseif convertCharsToStrings(Session_type{sess})=='Cond'
                FolderList=CondSess;
            elseif convertCharsToStrings(Session_type{sess})=='Ext'
                FolderList=ExtSess;
            elseif convertCharsToStrings(Session_type{sess})=='CondPre'
                FolderList=CondPreSess;
            elseif convertCharsToStrings(Session_type{sess})=='CondPost'
                FolderList=CondPostSess;
            elseif convertCharsToStrings(Session_type{sess})=='TestPre'
                FolderList=TestPreSess;
            elseif convertCharsToStrings(Session_type{sess})=='TestPost'
                FolderList=TestPostSess;
            end
            BlockedEpoch.(Session_type{sess}).(Mouse_names{mouse}) = ConcatenateDataFromFolders_SB(FolderList.(Mouse_names{mouse}),'Epoch','epochname','blockedepoch');
        end
    end
    disp(Mouse_names{mouse})
end

% little temporary correction for OE mice
for sess=1:length(Session_type)
    for mouse=1:length(Mouse)
        try
            if length(Start(Epoch1.(Session_type{sess}){mouse,2}))==0
                Epoch1.(Session_type{sess}){mouse,2} = intervalSet(0,0);
            end
        end
    end
end

for sess=1:length(Session_type)
    for mouse=1:length(Mouse)
        Mouse_names{mouse}=['M' num2str(Mouse(mouse))];
        for cond=1:8
            try
                Epoch_Blocked.(Session_type{sess}){mouse,cond} = and(Epoch1.(Session_type{sess}){mouse,cond} , BlockedEpoch.(Session_type{sess}).(Mouse_names{mouse}));
                Epoch_Unblocked.(Session_type{sess}){mouse,cond} = Epoch1.(Session_type{sess}){mouse,cond} - Epoch_Blocked.(Session_type{sess}){mouse,cond};
            end
        end
    end
end

clear ExtraStim FreezingProp ZoneOccupancy StimNumb ShockZoneEntries Total_Time Latency_SZ OccupancyMeanTime;
for mouse=1:length(Mouse)
    for sess=1:length(Session_type)
        try
            % Freezing proportion
            FreezingProp.All.(Session_type{sess}).(Mouse_names{mouse}) = sum(Stop(Epoch1.(Session_type{sess}){mouse,3})-Start(Epoch1.(Session_type{sess}){mouse,3}))/sum(Stop(Epoch1.(Session_type{sess}){mouse,1})-Start(Epoch1.(Session_type{sess}){mouse,1}));
            % Freezing shock/safe proportion
            FreezingProp.Shock.(Session_type{sess}).(Mouse_names{mouse}) = sum(Stop(Epoch1.(Session_type{sess}){mouse,5})-Start(Epoch1.(Session_type{sess}){mouse,5}))/sum(Stop(Epoch1.(Session_type{sess}){mouse,3})-Start(Epoch1.(Session_type{sess}){mouse,3}));
            % Shock and safe proportion
            FreezingPercentage.Shock.(Session_type{sess}).(Mouse_names{mouse}) = sum(Stop(Epoch1.(Session_type{sess}){mouse,5})-Start(Epoch1.(Session_type{sess}){mouse,5}))/(sum(Stop(Epoch1.(Session_type{sess}){mouse,5})-Start(Epoch1.(Session_type{sess}){mouse,5})) +sum(Stop(Epoch1.(Session_type{sess}){mouse,7})-Start(Epoch1.(Session_type{sess}){mouse,7})));
            FreezingPercentage.Safe.(Session_type{sess}).(Mouse_names{mouse}) = sum(Stop(Epoch1.(Session_type{sess}){mouse,6})-Start(Epoch1.(Session_type{sess}){mouse,6}))/(sum(Stop(Epoch1.(Session_type{sess}){mouse,6})-Start(Epoch1.(Session_type{sess}){mouse,6})) +sum(Stop(Epoch1.(Session_type{sess}){mouse,8})-Start(Epoch1.(Session_type{sess}){mouse,8})));
            % Exploration
            ZoneOccupancy.Shock.(Session_type{sess}).(Mouse_names{mouse}) = (sum(Stop(Epoch_Unblocked.(Session_type{sess}){mouse,5})-Start(Epoch_Unblocked.(Session_type{sess}){mouse,5})) + sum(Stop(Epoch_Unblocked.(Session_type{sess}){mouse,7})-Start(Epoch_Unblocked.(Session_type{sess}){mouse,7})))/sum(Stop(Epoch_Unblocked.(Session_type{sess}){mouse,1})-Start(Epoch_Unblocked.(Session_type{sess}){mouse,1}));
            ZoneOccupancy.Safe.(Session_type{sess}).(Mouse_names{mouse}) = (sum(Stop(Epoch_Unblocked.(Session_type{sess}){mouse,6})-Start(Epoch_Unblocked.(Session_type{sess}){mouse,6})) + sum(Stop(Epoch_Unblocked.(Session_type{sess}){mouse,8})-Start(Epoch_Unblocked.(Session_type{sess}){mouse,8})))/sum(Stop(Epoch_Unblocked.(Session_type{sess}){mouse,1})-Start(Epoch_Unblocked.(Session_type{sess}){mouse,1}));
            % mean time in shock zone
            OccupancyMeanTime.Shock.(Session_type{sess}).(Mouse_names{mouse}) = (sum(Stop(Epoch_Unblocked.(Session_type{sess}){mouse,5})-Start(Epoch_Unblocked.(Session_type{sess}){mouse,5})) + sum(Stop(Epoch_Unblocked.(Session_type{sess}){mouse,7})-Start(Epoch_Unblocked.(Session_type{sess}){mouse,7})))/(length(Start(Epoch_Unblocked.(Session_type{sess}){mouse,7}))*1e4);
            OccupancyMeanTime.Safe.(Session_type{sess}).(Mouse_names{mouse}) = (sum(Stop(Epoch_Unblocked.(Session_type{sess}){mouse,6})-Start(Epoch_Unblocked.(Session_type{sess}){mouse,6})) + sum(Stop(Epoch_Unblocked.(Session_type{sess}){mouse,8})-Start(Epoch_Unblocked.(Session_type{sess}){mouse,8})))/(length(Start(Epoch_Unblocked.(Session_type{sess}){mouse,8}))*1e4);
            % Stim number / min
            StimNumb.(Session_type{sess}).(Mouse_names{mouse}) = length(Start(Epoch1.(Session_type{sess}){mouse,2}));
            StimNumb_Blocked.(Session_type{sess}).(Mouse_names{mouse}) = length(Start(and(Epoch1.(Session_type{sess}){mouse,2} , BlockedEpoch.(Session_type{sess}).(Mouse_names{mouse}))));
            ExtraStim.(Session_type{sess}).(Mouse_names{mouse}) = (StimNumb.(Session_type{sess}).(Mouse_names{mouse}) - StimNumb_Blocked.(Session_type{sess}).(Mouse_names{mouse}))/(sum(Stop(Epoch_Unblocked.(Session_type{sess}){mouse, 1},'s')-Start(Epoch_Unblocked.(Session_type{sess}){mouse, 1},'s'))/60);
            % Shock zone entries / min
            clear SZ_Entries; SZ_Entries = Start(Epoch_Unblocked.(Session_type{sess}){mouse,7});
            ShockZoneEntries.(Session_type{sess}).(Mouse_names{mouse}) = length(SZ_Entries(SZ_Entries>2e4))/(sum(Stop(Epoch_Unblocked.(Session_type{sess}){mouse, 1},'s')-Start(Epoch_Unblocked.(Session_type{sess}){mouse, 1},'s'))/60) ; % consider SZ entries only if sup to 2s
            % Total time
            Total_Time.(Session_type{sess}).(Mouse_names{mouse}) = sum(Stop(Epoch1.(Session_type{sess}){mouse,1})-Start(Epoch1.(Session_type{sess}){mouse,1}));
            % Shock zone entries latency
            Latency_SZ.(Session_type{sess}).(Mouse_names{mouse})=Get_Latency_BM(Epoch1.(Session_type{sess}){mouse,7})/1e4;
            % Freezing time
            FreezingTime.Shock.(Session_type{sess}).(Mouse_names{mouse}) = sum(Stop(Epoch1.(Session_type{sess}){mouse,5})-Start(Epoch1.(Session_type{sess}){mouse,5}))/6e5;
            FreezingTime.Safe.(Session_type{sess}).(Mouse_names{mouse}) = sum(Stop(Epoch1.(Session_type{sess}){mouse,6})-Start(Epoch1.(Session_type{sess}){mouse,6}))/6e5;
        end
    end
    Mouse_names{mouse}
end

for group=1:length(Drug_Group)
   
    Drugs_Groups_UMaze_BM
    
    for sess=1:length(Session_type) % generate all data required for analyses
        for mouse=1:length(Mouse)
            Mouse_names{mouse}=['M' num2str(Mouse(mouse))];
            
            try
                FreezingProp.All.(Drug_Group{group}).(Session_type{sess})(mouse,:) = FreezingProp.All.(Session_type{sess}).(Mouse_names{mouse});
                FreezingProp.Shock.(Drug_Group{group}).(Session_type{sess})(mouse,:) = FreezingProp.Shock.(Session_type{sess}).(Mouse_names{mouse});
                FreezingPercentage.Shock.(Drug_Group{group}).(Session_type{sess})(mouse,:) = FreezingPercentage.Shock.(Session_type{sess}).(Mouse_names{mouse});
                FreezingPercentage.Safe.(Drug_Group{group}).(Session_type{sess})(mouse,:) = FreezingPercentage.Safe.(Session_type{sess}).(Mouse_names{mouse});
                ZoneOccupancy.Shock.(Drug_Group{group}).(Session_type{sess})(mouse,:) = ZoneOccupancy.Shock.(Session_type{sess}).(Mouse_names{mouse});
                ZoneOccupancy.Safe.(Drug_Group{group}).(Session_type{sess})(mouse,:) = ZoneOccupancy.Safe.(Session_type{sess}).(Mouse_names{mouse});
                % mean time in shock zone
                OccupancyMeanTime.Shock.(Drug_Group{group}).(Session_type{sess})(mouse,:) = OccupancyMeanTime.Shock.(Session_type{sess}).(Mouse_names{mouse});
                OccupancyMeanTime.Safe.(Drug_Group{group}).(Session_type{sess})(mouse,:) = OccupancyMeanTime.Safe.(Session_type{sess}).(Mouse_names{mouse});
                % Stim number
                StimNumb.(Drug_Group{group}).(Session_type{sess})(mouse,:) = StimNumb.(Session_type{sess}).(Mouse_names{mouse});
                StimNumb_Blocked.(Drug_Group{group}).(Session_type{sess})(mouse,:) = StimNumb_Blocked.(Session_type{sess}).(Mouse_names{mouse});
                ExtraStim.(Drug_Group{group}).(Session_type{sess})(mouse,:) = ExtraStim.(Session_type{sess}).(Mouse_names{mouse});
                % Shock zone entries
                ShockZoneEntries.(Drug_Group{group}).(Session_type{sess})(mouse,:) = ShockZoneEntries.(Session_type{sess}).(Mouse_names{mouse});
                % Total time
                Total_Time.(Drug_Group{group}).(Session_type{sess})(mouse,:) = Total_Time.(Session_type{sess}).(Mouse_names{mouse});
                % Shock zone entries latency
                Latency_SZ.(Drug_Group{group}).(Session_type{sess})(mouse,:) = Latency_SZ.(Session_type{sess}).(Mouse_names{mouse});
                % Freezing time
                FreezingTime.Shock.(Drug_Group{group}).(Session_type{sess})(mouse,:) = FreezingTime.Shock.(Session_type{sess}).(Mouse_names{mouse});
                FreezingTime.Safe.(Drug_Group{group}).(Session_type{sess})(mouse,:) = FreezingTime.Safe.(Session_type{sess}).(Mouse_names{mouse}) ;
            end
        end
    end
end


%% generate data and epoch
GetEmbReactMiceFolderList_BM
for sess=1:length(Session_type2) 
    [OutPutData.(Session_type2{sess}) , Epoch1.(Session_type2{sess}) , NameEpoch] = MeanValuesPhysiologicalParameters_BM(Mouse,lower(Session_type2{sess}),'respi_freq_bm');
end

% Generate RA tsd
for sess=1:length(Session_type) % generate all data required for analyses
    for mouse=1:length(Mouse)
        if convertCharsToStrings(Session_type{sess})=='Fear'
            FolderList=FearSess;
        elseif convertCharsToStrings(Session_type{sess})=='Cond'
            FolderList=CondSess;
        elseif convertCharsToStrings(Session_type{sess})=='Ext'
            FolderList=ExtSess;
        elseif convertCharsToStrings(Session_type{sess})=='CondPre'
            FolderList=CondPreSess;
        elseif convertCharsToStrings(Session_type{sess})=='CondPost'
            FolderList=CondPostSess;
        elseif convertCharsToStrings(Session_type{sess})=='TestPre'
            FolderList=TestPreSess;
        elseif convertCharsToStrings(Session_type{sess})=='TestPost'
            FolderList=TestPostSess;
        end
        RA.(Session_type{sess}).(Mouse_names{mouse}) = ConcatenateDataFromFolders_SB(FolderList.(Mouse_names{mouse}),'risk_assessment') ;
    end
end

% Transforming some variables
for mouse=1:length(Mouse)
    Mouse_names{mouse}=['M' num2str(Mouse(mouse))];
    % Sleep data
    for sess=1:length(Session_type2)
        
        REM_prop.(Session_type2{sess}).(Mouse_names{mouse}) = sum(Stop(Epoch1.(Session_type2{sess}){mouse,5})-Start(Epoch1.(Session_type2{sess}){mouse,5}))/sum(Stop(Epoch1.(Session_type2{sess}){mouse,3})-Start(Epoch1.(Session_type2{sess}){mouse,3}));
        
    end
    % Experiment data
    for sess=1:length(Session_type)
        
        Freezing_prop.All.(Session_type{sess}).(Mouse_names{mouse}) = sum(Stop(Epoch1.(Session_type{sess}){mouse,3})-Start(Epoch1.(Session_type{sess}){mouse,3}))/sum(Stop(Epoch1.(Session_type{sess}){mouse,1})-Start(Epoch1.(Session_type{sess}){mouse,1}));
        Freezing_prop.Shock.(Session_type{sess}).(Mouse_names{mouse}) = sum(Stop(Epoch1.(Session_type{sess}){mouse,5})-Start(Epoch1.(Session_type{sess}){mouse,5}))/sum(Stop(Epoch1.(Session_type{sess}){mouse,1})-Start(Epoch1.(Session_type{sess}){mouse,1}));
        Freezing_prop.Safe.(Session_type{sess}).(Mouse_names{mouse}) = sum(Stop(Epoch1.(Session_type{sess}){mouse,6})-Start(Epoch1.(Session_type{sess}){mouse,6}))/sum(Stop(Epoch1.(Session_type{sess}){mouse,1})-Start(Epoch1.(Session_type{sess}){mouse,1}));
        
        Respi_Data.All.(Session_type{sess}).(Mouse_names{mouse}) = Data(OutPutData.(Session_type{sess}).respi_freq_bm.tsd{mouse,3});
        Respi_Data.Shock.(Session_type{sess}).(Mouse_names{mouse}) = Data(OutPutData.(Session_type{sess}).respi_freq_bm.tsd{mouse,5});
        Respi_Data.Safe.(Session_type{sess}).(Mouse_names{mouse}) = Data(OutPutData.(Session_type{sess}).respi_freq_bm.tsd{mouse,6});
        
        Respi_Freq_Above_4.All.(Session_type{sess}).(Mouse_names{mouse}) = sum(Respi_Data.All.(Session_type{sess}).(Mouse_names{mouse})>4)/length(Respi_Data.All.(Session_type{sess}).(Mouse_names{mouse}));
        Respi_Freq_Above_4.Shock.(Session_type{sess}).(Mouse_names{mouse}) = sum(Respi_Data.Shock.(Session_type{sess}).(Mouse_names{mouse})>4)/length(Respi_Data.Shock.(Session_type{sess}).(Mouse_names{mouse}));
        Respi_Freq_Above_4.Safe.(Session_type{sess}).(Mouse_names{mouse}) = sum(Respi_Data.Safe.(Session_type{sess}).(Mouse_names{mouse})>4)/length(Respi_Data.Safe.(Session_type{sess}).(Mouse_names{mouse}));
    end
end

%% Gathering data
for group=1:length(Drug_Group)
    
    Drugs_Groups_UMaze_BM
    
    for sess=1:length(Session_type2)
        for mouse=1:length(Mouse)
            Mouse_names{mouse}=['M' num2str(Mouse(mouse))];
            
            REM_prop.(Drug_Group{group}).(Session_type2{sess})(mouse) = REM_prop.(Session_type2{sess}).(Mouse_names{mouse});
            
        end
    end
    for sess=1:length(Session_type)
        for mouse=1:length(Mouse)
            Mouse_names{mouse}=['M' num2str(Mouse(mouse))];
            
            Freezing_prop.All.(Drug_Group{group}).(Session_type{sess})(mouse) = Freezing_prop.All.(Session_type{sess}).(Mouse_names{mouse});
            Freezing_prop.Shock.(Drug_Group{group}).(Session_type{sess})(mouse) = Freezing_prop.Shock.(Session_type{sess}).(Mouse_names{mouse});
            Freezing_prop.Safe.(Drug_Group{group}).(Session_type{sess})(mouse) = Freezing_prop.Safe.(Session_type{sess}).(Mouse_names{mouse});
            
            Respi_Freq_Above_4.All.(Drug_Group{group}).(Session_type{sess})(mouse)=Respi_Freq_Above_4.All.(Session_type{sess}).(Mouse_names{mouse});
            Respi_Freq_Above_4.Shock.(Drug_Group{group}).(Session_type{sess})(mouse)=Respi_Freq_Above_4.Shock.(Session_type{sess}).(Mouse_names{mouse});
            Respi_Freq_Above_4.Safe.(Drug_Group{group}).(Session_type{sess})(mouse)=Respi_Freq_Above_4.Safe.(Session_type{sess}).(Mouse_names{mouse});
            
            ExtraStim.(Drug_Group{group}).(Session_type{sess})(mouse) = ExtraStim.(Session_type{sess}).(Mouse_names{mouse});
            %         Freezing_prop.All.SalineSB.(Session_type{sess})(Freezing_prop.All.SalineSB.(Session_type{sess})>.3)=NaN;
            %         Freezing_prop.Shock.SalineSB.(Session_type{sess})(Freezing_prop.Shock.SalineSB.(Session_type{sess})>.3)=NaN;
            %         Freezing_prop.Safe.SalineSB.(Session_type{sess})(Freezing_prop.Safe.SalineSB.(Session_type{sess})>.3)=NaN;
            %         ExtraStim.SalineSB.(Session_type{sess})(ExtraStim.SalineSB.(Session_type{sess})>1)=NaN;
            
            AllZoneOccupancy.Shock.(Drug_Group{group}).(Session_type{sess})(mouse) = ZoneOccupancy.Shock.(Session_type{sess}).(Mouse_names{mouse});
            AllShockZoneZoneEntries.(Drug_Group{group}).(Session_type{sess})(mouse) = ShockZoneEntries.(Session_type{sess}).(Mouse_names{mouse});
            AllLatencySZ.(Drug_Group{group}).(Session_type{sess})(mouse) = Latency_SZ.(Session_type{sess}).(Mouse_names{mouse});
            RA.(Drug_Group{group}).(Session_type{sess})(mouse) = length(Start(RA.(Session_type{sess}).(Mouse_names{mouse})));
        end
    end
end

% cleaning some data 
% REM_prop.SalineSB.sleep_pre(or(REM_prop.SalineSB.sleep_pre>.2 , REM_prop.SalineSB.sleep_pre<.06))=NaN;
% REM_prop.SalineSB.sleep_post(or(REM_prop.SalineSB.sleep_post>.2 , REM_prop.SalineSB.sleep_post<.06))=NaN;
% RA.SalineSB.Cond(or(RA.SalineSB.Cond==0 , RA.SalineSB.Cond>35))=NaN;
% Stim_By_SZ_entries.SalineSB.Cond = AllShockZoneZoneEntries.SalineSB.Cond./ExtraStim.SalineSB.Cond';
% Stim_By_SZ_entries.SalineSB.Cond(Stim_By_SZ_entries.SalineSB.Cond>60)=NaN;

for sess=1:length(Session_type)
    for group=1:length(Drug_Group)
        try
            %RA.(Drug_Group{group}).(Session_type{sess})(RA.(Drug_Group{group}).(Session_type{sess})==0) = NaN;
            RA_density.(Drug_Group{group}).(Session_type{sess}) = RA.(Drug_Group{group}).(Session_type{sess})./Total_Time.(Drug_Group{group}).(Session_type{sess});
        end
    end
end


% Gather for all saline
for sess=1:length(Session_type2)
    REM_prop.Saline_All.(Session_type2{sess})=[];
    for group=[1 5 7]
        REM_prop.Saline_All.(Session_type2{sess}) = [REM_prop.Saline_All.(Session_type2{sess}) REM_prop.(Drug_Group{group}).(Session_type2{sess})];
    end
end
for sess=1:length(Session_type)
    try
        FreezingProp.All.Saline_All.(Session_type{sess})=[]; FreezingProp.Shock.Saline_All.(Session_type{sess})=[]; ZoneOccupancy.Shock.Saline_All.(Session_type{sess})=[];  RA.Saline_All.(Session_type{sess})=[];
        OccupancyMeanTime.Shock.Saline_All.(Session_type{sess})=[];
        for group=[1 5 7]
            ZoneOccupancy.Shock.Saline_All.(Session_type{sess}) = [ZoneOccupancy.Shock.Saline_All.(Session_type{sess}) ZoneOccupancy.Shock.(Drug_Group{group}).(Session_type{sess})'];
            FreezingProp.All.Saline_All.(Session_type{sess}) = [FreezingProp.All.Saline_All.(Session_type{sess}) FreezingProp.All.(Drug_Group{group}).(Session_type{sess})'];
            FreezingProp.Shock.Saline_All.(Session_type{sess}) = [FreezingProp.Shock.Saline_All.(Session_type{sess}) FreezingProp.Shock.(Drug_Group{group}).(Session_type{sess})'];
            RA.Saline_All.(Session_type{sess}) = [RA.Saline_All.(Session_type{sess}) RA.(Drug_Group{group}).(Session_type{sess})];
            OccupancyMeanTime.Shock.Saline_All.(Session_type{sess}) = [OccupancyMeanTime.Shock.Saline_All.(Session_type{sess}) OccupancyMeanTime.Shock.(Drug_Group{group}).(Session_type{sess})'];
        end
    end
end
REM_prop.Saline_All.sleep_pre([8:10 13 14 20 21])=NaN; REM_prop.Saline_All.sleep_post([8:10 13 14 20 21])=NaN;



%% Plot section
figure
subplot(121)
PlotCorrelations_BM(REM_prop.SalineSB.sleep_pre , Freezing_prop.All.SalineSB.Fear)
makepretty; xlabel('REM proportion'); ylabel('Frezzing proportion'); xlim([0 .15])
title('Sleep Pre')
subplot(122)
PlotCorrelations_BM(REM_prop.SalineSB.sleep_post , Freezing_prop.All.SalineSB.Fear)
makepretty; xlabel('REM proportion'); xlim([0 .15])
title('Sleep Post')

figure
subplot(121)
PlotCorrelations_BM(REM_prop.SalineSB.sleep_pre , Freezing_prop.Shock.SalineSB.Fear)
makepretty; xlabel('REM proportion'); ylabel('Shock freezing proportion'); xlim([0 .15])
title('Sleep Pre')
subplot(122)
PlotCorrelations_BM(REM_prop.SalineSB.sleep_post , Freezing_prop.Shock.SalineSB.Fear)
makepretty; xlabel('REM proportion'); xlim([0 .15])
title('Sleep Post')

figure
subplot(121)
PlotCorrelations_BM(REM_prop.SalineSB.sleep_pre , Freezing_prop.Safe.SalineSB.Fear)
makepretty; xlabel('REM proportion'); ylabel('Safe freezing proportion'); xlim([0 .15])
title('Sleep Pre')
subplot(122)
PlotCorrelations_BM(REM_prop.SalineSB.sleep_post , Freezing_prop.Safe.SalineSB.Fear)
makepretty; xlabel('REM proportion'); xlim([0 .15])
title('Sleep Post')


% Respi freq above 4
figure
subplot(121)
PlotCorrelations_BM(REM_prop.SalineSB.sleep_pre , Respi_Freq_Above_4.All.SalineSB.Fear)
makepretty; xlabel('REM proportion'); ylabel('Freezing proportion > 4Hz'); xlim([0 .15])
title('Sleep Pre')
subplot(122)
PlotCorrelations_BM(REM_prop.SalineSB.sleep_post , Respi_Freq_Above_4.All.SalineSB.Fear)
makepretty; xlabel('REM proportion'); xlim([0 .15])
title('Sleep Post')

figure
subplot(121)
PlotCorrelations_BM(REM_prop.SalineSB.sleep_pre , Respi_Freq_Above_4.Shock.SalineSB.Fear)
makepretty; xlabel('REM proportion'); ylabel('Shock freezing proportion > 4Hz'); xlim([0 .15])
title('Sleep Pre')
subplot(122)
PlotCorrelations_BM(REM_prop.SalineSB.sleep_post , Respi_Freq_Above_4.Shock.SalineSB.Fear)
makepretty; xlabel('REM proportion'); xlim([0 .15])
title('Sleep Post')

figure
subplot(121)
PlotCorrelations_BM(REM_prop.SalineSB.sleep_pre , Respi_Freq_Above_4.Safe.SalineSB.Fear)
makepretty; xlabel('REM proportion'); ylabel('Safe freezing proportion > 4Hz'); xlim([0 .15])
title('Sleep Pre')
subplot(122)
PlotCorrelations_BM(REM_prop.SalineSB.sleep_post , Respi_Freq_Above_4.Safe.SalineSB.Fear)
makepretty; xlabel('REM proportion'); xlim([0 .15])
title('Sleep Post')

%% Looking at differences Cond/Ext
figure
subplot(221)
PlotCorrelations_BM(REM_prop.SalineSB.sleep_pre , Freezing_prop.All.SalineSB.Cond)
title('Sleep Pre'); ylabel('% Fz Cond')
subplot(222)
PlotCorrelations_BM(REM_prop.SalineSB.sleep_post , Freezing_prop.All.SalineSB.Cond)
title('Sleep Post')
subplot(223)
PlotCorrelations_BM(REM_prop.SalineSB.sleep_pre , Freezing_prop.All.SalineSB.Ext)
ylabel('% Fz Ext')
subplot(224)
PlotCorrelations_BM(REM_prop.SalineSB.sleep_post , Freezing_prop.All.SalineSB.Ext)

figure
subplot(221)
PlotCorrelations_BM(REM_prop.SalineSB.sleep_pre , Freezing_prop.Shock.SalineSB.Cond)
title('Sleep Pre')
subplot(222)
PlotCorrelations_BM(REM_prop.SalineSB.sleep_post , Freezing_prop.Shock.SalineSB.Cond)
title('Sleep Post')
subplot(223)
PlotCorrelations_BM(REM_prop.SalineSB.sleep_pre , Freezing_prop.Shock.SalineSB.Ext)
subplot(224)
PlotCorrelations_BM(REM_prop.SalineSB.sleep_post , Freezing_prop.Shock.SalineSB.Ext)

figure
subplot(221)
PlotCorrelations_BM(REM_prop.SalineSB.sleep_pre , Freezing_prop.Safe.SalineSB.Cond)
subplot(222)
PlotCorrelations_BM(REM_prop.SalineSB.sleep_post , Freezing_prop.Safe.SalineSB.Cond)
subplot(223)
PlotCorrelations_BM(REM_prop.SalineSB.sleep_pre , Freezing_prop.Safe.SalineSB.Ext)
subplot(224)
PlotCorrelations_BM(REM_prop.SalineSB.sleep_post , Freezing_prop.Safe.SalineSB.Ext)


% Respi freq above 4
figure
subplot(221)
PlotCorrelations_BM(REM_prop.SalineSB.sleep_pre , Respi_Freq_Above_4.All.SalineSB.Cond)
subplot(222)
PlotCorrelations_BM(REM_prop.SalineSB.sleep_post , Respi_Freq_Above_4.All.SalineSB.Cond)
subplot(223)
PlotCorrelations_BM(REM_prop.SalineSB.sleep_pre , Respi_Freq_Above_4.All.SalineSB.Ext)
subplot(224)
PlotCorrelations_BM(REM_prop.SalineSB.sleep_post , Respi_Freq_Above_4.All.SalineSB.Ext)

figure
subplot(221)
PlotCorrelations_BM(REM_prop.SalineSB.sleep_pre , Respi_Freq_Above_4.Shock.SalineSB.Cond)
subplot(222)
PlotCorrelations_BM(REM_prop.SalineSB.sleep_post , Respi_Freq_Above_4.Shock.SalineSB.Cond)
subplot(223)
PlotCorrelations_BM(REM_prop.SalineSB.sleep_pre , Respi_Freq_Above_4.Shock.SalineSB.Ext)
subplot(224)
PlotCorrelations_BM(REM_prop.SalineSB.sleep_post , Respi_Freq_Above_4.Shock.SalineSB.Ext)

figure
subplot(221)
PlotCorrelations_BM(REM_prop.SalineSB.sleep_pre , Respi_Freq_Above_4.Safe.SalineSB.Cond)
subplot(222)
PlotCorrelations_BM(REM_prop.SalineSB.sleep_post , Respi_Freq_Above_4.Safe.SalineSB.Cond)
subplot(223)
PlotCorrelations_BM(REM_prop.SalineSB.sleep_pre , Respi_Freq_Above_4.Safe.SalineSB.Ext)
subplot(224)
PlotCorrelations_BM(REM_prop.SalineSB.sleep_post , Respi_Freq_Above_4.Safe.SalineSB.Ext)


%% Behaviour TestPost 
figure
subplot(121)
PlotCorrelations_BM(REM_prop.SalineSB.sleep_pre , AllZoneOccupancy.Shock.SalineSB.TestPost)
makepretty; xlabel('REM proportion'); ylabel('Shock zone occupancy'); xlim([0 .15])
subplot(122)
PlotCorrelations_BM(REM_prop.SalineSB.sleep_post , AllZoneOccupancy.Shock.SalineSB.TestPost)
makepretty; xlabel('REM proportion'); xlim([0 .15])

figure
subplot(121)
PlotCorrelations_BM(REM_prop.SalineSB.sleep_pre , AllShockZoneZoneEntries.SalineSB.TestPost)
makepretty; xlabel('REM proportion'); ylabel('Shock zone occupancy'); xlim([0 .15])
subplot(122)
PlotCorrelations_BM(REM_prop.SalineSB.sleep_post , AllShockZoneZoneEntries.SalineSB.TestPost)
makepretty; xlabel('REM proportion'); xlim([0 .15])

figure
subplot(121)
PlotCorrelations_BM(REM_prop.SalineSB.sleep_pre , AllLatencySZ.SalineSB.TestPost)
makepretty; xlabel('REM proportion'); ylabel('Shock zone occupancy'); xlim([0 .15])
subplot(122)
PlotCorrelations_BM(REM_prop.SalineSB.sleep_post , AllLatencySZ.SalineSB.TestPost)
makepretty; xlabel('REM proportion'); xlim([0 .15])


%% Behaviour Cond 
figure
subplot(121)
PlotCorrelations_BM(REM_prop.SalineSB.sleep_pre , AllZoneOccupancy.Shock.SalineSB.Cond)
makepretty; xlabel('REM proportion'); ylabel('Shock zone occupancy'); xlim([0 .15])
subplot(122)
PlotCorrelations_BM(REM_prop.SalineSB.sleep_post , AllZoneOccupancy.Shock.SalineSB.Cond)
makepretty; xlabel('REM proportion'); xlim([0 .15])

figure
subplot(121)
PlotCorrelations_BM(REM_prop.SalineSB.sleep_pre , AllShockZoneZoneEntries.SalineSB.Cond)
makepretty; xlabel('REM proportion'); ylabel('Shock zone occupancy'); xlim([0 .15])
subplot(122)
PlotCorrelations_BM(REM_prop.SalineSB.sleep_post , AllShockZoneZoneEntries.SalineSB.Cond)
makepretty; xlabel('REM proportion'); xlim([0 .15])

figure
subplot(121)
PlotCorrelations_BM(REM_prop.SalineSB.sleep_pre , AllLatencySZ.SalineSB.Cond)
makepretty; xlabel('REM proportion'); ylabel('Shock zone occupancy'); xlim([0 .15])
subplot(122)
PlotCorrelations_BM(REM_prop.SalineSB.sleep_post , AllLatencySZ.SalineSB.Cond)
makepretty; xlabel('REM proportion'); xlim([0 .15])

figure
subplot(121)
PlotCorrelations_BM(REM_prop.SalineSB.sleep_pre , ExtraStim.SalineSB.Cond')
makepretty; xlabel('REM proportion'); ylabel('Shock zone occupancy'); xlim([0 .15])
subplot(122)
PlotCorrelations_BM(REM_prop.SalineSB.sleep_post , ExtraStim.SalineSB.Cond')
makepretty; xlabel('REM proportion'); xlim([0 .15])

figure
subplot(121)
PlotCorrelations_BM(REM_prop.SalineSB.sleep_pre , Stim_By_SZ_entries.SalineSB.Cond)
makepretty; xlabel('REM proportion'); ylabel('Shock zone occupancy'); xlim([0 .15])
subplot(122)
PlotCorrelations_BM(REM_prop.SalineSB.sleep_post , Stim_By_SZ_entries.SalineSB.Cond)
makepretty; xlabel('REM proportion'); xlim([0 .15])

figure
subplot(121)
PlotCorrelations_BM(REM_prop.SalineSB.sleep_pre , RA.SalineSB.Cond)
makepretty; xlabel('REM proportion'); ylabel('RA number (#)'); xlim([0 .15])
subplot(122)
PlotCorrelations_BM(REM_prop.SalineSB.sleep_post , RA.SalineSB.Cond)
makepretty; xlabel('REM proportion'); xlim([0 .15])



%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%% Dividing by drug group
Cols = {[0 0 1],[0 1 0],[1 0 0]};
Legends ={'SalineSB' 'Acute Flx' 'Chronic Flx'};
NoLegends ={'', '', ''};
X = [1:3];

Cols2 = {[0 0 1],[1 0 0]};
Legends2 ={'SalineSB' 'Chronic Flx'};
NoLegends2 ={'', ''};
X2 = [1:2];

Cols3 = {[0 0 1],[0 1 0]};
Legends3 ={'SalineSB' 'Acute Flx' };

% REM proportion
figure
subplot(121)
MakeSpreadAndBoxPlot2_SB({REM_prop.SalineSB.sleep_pre*100 REM_prop.AcuteFlx.sleep_pre*100 REM_prop.ChronicFlx.sleep_pre*100},Cols,X,Legends,'showpoints',1,'paired',0); 
ylabel('%')
title('Sleep Pre')
subplot(122)
MakeSpreadAndBoxPlot2_SB({REM_prop.SalineSB.sleep_post*100 REM_prop.AcuteFlx.sleep_post*100 REM_prop.ChronicFlx.sleep_post*100},Cols,X,Legends,'showpoints',1,'paired',0); 
title('Sleep Post')
a=suptitle('REM percentage of sleep, UMaze'); a.FontSize=20;


% Freezing percentage
figure; n=1;
for sess=[2 3]
    
    subplot(2,2,n)
    MakeSpreadAndBoxPlot2_SB({FreezingPercentage.Shock.SalineSB.(Session_type{sess})  FreezingPercentage.Shock.ChronicFlx.(Session_type{sess})},Cols2,X2,NoLegends2,'showpoints',1,'paired',0);
    if n==1; ylabel('% time in shock zone'); end
    title(Session_type{sess})
    
    subplot(2,2,n+2)
    MakeSpreadAndBoxPlot2_SB({FreezingPercentage.Safe.SalineSB.(Session_type{sess})  FreezingPercentage.Safe.ChronicFlx.(Session_type{sess})},Cols2,X2,Legends2,'showpoints',1,'paired',0);
    if n==1; ylabel('% time in safe zone'); end
    
    n=n+1;
end
a=suptitle('Freezing percentage in UMaze zones'); a.FontSize=20;

figure; n=1;
for sess=[4 5 3]
    
    subplot(2,3,n)
    MakeSpreadAndBoxPlot2_SB({FreezingPercentage.Shock.SalineSB.(Session_type{sess})  FreezingPercentage.Shock.AcuteFlx.(Session_type{sess})},Cols3,X2,NoLegends2,'showpoints',1,'paired',0);
    if n==1; ylabel('% time in shock zone'); end
    title(Session_type{sess})
    
    subplot(2,3,n+3)
    MakeSpreadAndBoxPlot2_SB({FreezingPercentage.Safe.SalineSB.(Session_type{sess})  FreezingPercentage.Safe.AcuteFlx.(Session_type{sess})},Cols3,X2,Legends3,'showpoints',1,'paired',0);
    if n==1; ylabel('% time in safe zone'); end
    
    n=n+1;
end
a=suptitle('Freezing percentage in UMaze zones'); a.FontSize=20;


% Mean occupancy
figure; n=1;
for sess=[2 3]
    
    subplot(2,2,n)
    MakeSpreadAndBoxPlot2_SB({OccupancyMeanTime.Shock.SalineSB.(Session_type{sess})  OccupancyMeanTime.Shock.ChronicFlx.(Session_type{sess})},Cols2,X2,NoLegends2,'showpoints',1,'paired',0);
    if n==1; ylabel('time in shock zone (s)'); end
    title(Session_type{sess})
    
    subplot(2,2,n+2)
    MakeSpreadAndBoxPlot2_SB({OccupancyMeanTime.Safe.SalineSB.(Session_type{sess})  OccupancyMeanTime.Safe.ChronicFlx.(Session_type{sess})},Cols2,X2,Legends2,'showpoints',1,'paired',0);
    if n==1; ylabel('time in safe zone (s)'); end
    
    n=n+1;
end

title('Shock')
ylim([0 120])
subplot(122)
MakeSpreadAndBoxPlot2_SB({OccupancyMeanTime.Safe.SalineSB.Cond OccupancyMeanTime.Safe.AcuteFlx.Cond OccupancyMeanTime.Safe.ChronicFlx.Cond},Cols,X,Legends,'showpoints',1,'paired',0); 
title('Safe')
a=suptitle('Mean time in zones, conditionning sessions'); a.FontSize=20;


figure; sess=4;
subplot(221)
MakeSpreadAndBoxPlot2_SB({OccupancyMeanTime.Shock.SalineSB.CondPre OccupancyMeanTime.Shock.AcuteFlx.CondPre OccupancyMeanTime.Shock.ChronicFlx.CondPre},Cols,X,NoLegends,'showpoints',1,'paired',0); 
ylabel('shock zone time (s)')
title('CondPre')
ylim([0 10])
subplot(222)
MakeSpreadAndBoxPlot2_SB({OccupancyMeanTime.Shock.SalineSB.CondPost OccupancyMeanTime.Shock.AcuteFlx.CondPost OccupancyMeanTime.Shock.ChronicFlx.CondPost},Cols,X,NoLegends,'showpoints',1,'paired',0); 
sess=5;
title('CondPost')
ylim([0 200])
subplot(223)
MakeSpreadAndBoxPlot2_SB({OccupancyMeanTime.Safe.SalineSB.CondPre OccupancyMeanTime.Safe.AcuteFlx.CondPre OccupancyMeanTime.Safe.ChronicFlx.CondPre},Cols,X,Legends,'showpoints',1,'paired',0); 
ylabel('safe zone time (s)')
subplot(224)
MakeSpreadAndBoxPlot2_SB({OccupancyMeanTime.Safe.SalineSB.CondPost OccupancyMeanTime.Safe.AcuteFlx.CondPost OccupancyMeanTime.Safe.ChronicFlx.CondPost},Cols,X,Legends,'showpoints',1,'paired',0); 

a=suptitle('Mean time in zones, conditionning sessions, UMaze'); a.FontSize=20;


% RA
figure
MakeSpreadAndBoxPlot2_SB({RA.SalineSB.Cond RA.AcuteFlx.Cond},Cols2,X2,Legends2,'showpoints',1,'paired',0); 
ylim([0 50])
title('RA, conditionning sessions')
ylabel('#')


figure
subplot(121)
MakeSpreadAndBoxPlot2_SB({RA.SalineSB.CondPre RA.AcuteFlx.CondPre},Cols3,X2,Legends3,'showpoints',1,'paired',0); 
ylim([0 25])
title('CondPre')
ylabel('#')
subplot(122)
MakeSpreadAndBoxPlot2_SB({RA.SalineSB.CondPost RA.AcuteFlx.CondPost},Cols3,X2,Legends3,'showpoints',1,'paired',0); 
ylabel('proportion')
title('CondPost')
ylim([0 25])

a=suptitle('Risk assessment analysis, conditionning sessions'); a.FontSize=20;


%% Correlations
% REM & Shock zone occupancy
figure
subplot(121)
plot(REM_prop.Saline_All.sleep_pre , ZoneOccupancy.Shock.Saline_All.Fear , '.b' , 'MarkerSize' , 30)
hold on
plot(REM_prop.ChronicFlx.sleep_pre , ZoneOccupancy.Shock.ChronicFlx.Fear , '.r' , 'MarkerSize' , 30)
plot(REM_prop.AcuteFlx.sleep_pre , ZoneOccupancy.Shock.AcuteFlx.Fear , '.g' , 'MarkerSize' , 30)
makepretty; xlabel('REM proportion'); ylabel('Shock zone occupancy'); xlim([0 .15]); ylim([0 .2])
axis square
legend('Saline','Chronic Flx','Acute Flx')
title('Sleep Pre')

[R,P] = corrcoef_BM( REM_prop.Saline_All.sleep_pre , ZoneOccupancy.Shock.Saline_All.Fear )
u=text(0.01,.18,['R = ' num2str(R(1,2)) ', P = ' num2str(P(1,2))],'Color','b');
[R,P] = corrcoef_BM( REM_prop.ChronicFlx.sleep_pre , ZoneOccupancy.Shock.ChronicFlx.Fear' )
u=text(0.01,.17,['R = ' num2str(R(1,2)) ', P = ' num2str(P(1,2))],'Color','r');
[R,P] = corrcoef_BM( REM_prop.AcuteFlx.sleep_pre , ZoneOccupancy.Shock.AcuteFlx.Fear' )
u=text(0.01,.16,['R = ' num2str(R(1,2)) ', P = ' num2str(P(1,2))],'Color','g');


subplot(122)
plot(REM_prop.Saline_All.sleep_post , ZoneOccupancy.Shock.Saline_All.Fear , '.b' , 'MarkerSize' , 30)
hold on
plot(REM_prop.ChronicFlx.sleep_post , ZoneOccupancy.Shock.ChronicFlx.Fear , '.r' , 'MarkerSize' , 30)
plot(REM_prop.AcuteFlx.sleep_post , ZoneOccupancy.Shock.AcuteFlx.Fear , '.g' , 'MarkerSize' , 30)
makepretty; xlabel('REM proportion'); xlim([0 .15]); ylim([0 .2])
axis square
title('Sleep Post')

[R,P] = corrcoef_BM( REM_prop.Saline_All.sleep_post , ZoneOccupancy.Shock.Saline_All.Fear )
u=text(0.01,.18,['R = ' num2str(R(1,2)) ', P = ' num2str(P(1,2))],'Color','b');
[R,P] = corrcoef_BM( REM_prop.ChronicFlx.sleep_post , ZoneOccupancy.Shock.ChronicFlx.Fear' )
u=text(0.01,.17,['R = ' num2str(R(1,2)) ', P = ' num2str(P(1,2))],'Color','r');
[R,P] = corrcoef_BM( REM_prop.AcuteFlx.sleep_post , ZoneOccupancy.Shock.AcuteFlx.Fear' )
u=text(0.01,.16,['R = ' num2str(R(1,2)) ', P = ' num2str(P(1,2))],'Color','g');



%% REM & Freezing proportion
figure
subplot(121)
plot(REM_prop.Saline_All.sleep_pre , FreezingProp.All.Saline_All.Fear , '.b' , 'MarkerSize' , 30)
hold on
plot(REM_prop.ChronicFlx.sleep_pre , FreezingProp.All.ChronicFlx.Fear , '.r' , 'MarkerSize' , 30)
plot(REM_prop.AcuteFlx.sleep_pre , FreezingProp.All.AcuteFlx.Fear , '.g' , 'MarkerSize' , 30)
makepretty; xlabel('REM proportion'); ylabel('Freezing proportion'); xlim([0 .15]); ylim([0 .25])
axis square
legend('Saline','Chronic Flx','Acute Flx')
title('Sleep Pre')

[R,P] = corrcoef_BM( REM_prop.Saline_All.sleep_pre , FreezingProp.All.Saline_All.Fear )
u=text(0.01,.24,['R = ' num2str(R(1,2)) ', P = ' num2str(P(1,2))],'Color','b');
[R,P] = corrcoef_BM( REM_prop.ChronicFlx.sleep_pre , FreezingProp.All.ChronicFlx.Fear' )
u=text(0.01,.23,['R = ' num2str(R(1,2)) ', P = ' num2str(P(1,2))],'Color','r');
[R,P] = corrcoef_BM( REM_prop.AcuteFlx.sleep_pre , FreezingProp.All.AcuteFlx.Fear' )
u=text(0.01,.22,['R = ' num2str(R(1,2)) ', P = ' num2str(P(1,2))],'Color','g');


subplot(122)
plot(REM_prop.Saline_All.sleep_post , FreezingProp.All.Saline_All.Fear , '.b' , 'MarkerSize' , 30)
hold on
plot(REM_prop.ChronicFlx.sleep_post , FreezingProp.All.ChronicFlx.Fear , '.r' , 'MarkerSize' , 30)
plot(REM_prop.AcuteFlx.sleep_post , FreezingProp.All.AcuteFlx.Fear , '.g' , 'MarkerSize' , 30)
makepretty; xlabel('REM proportion'); xlim([0 .15]); ylim([0 .25])
axis square
title('Sleep Post')

[R,P] = corrcoef_BM( REM_prop.Saline_All.sleep_post , FreezingProp.All.Saline_All.Fear )
u=text(0.01,.24,['R = ' num2str(R(1,2)) ', P = ' num2str(P(1,2))],'Color','b');
[R,P] = corrcoef_BM( REM_prop.ChronicFlx.sleep_post , FreezingProp.All.ChronicFlx.Fear' )
u=text(0.01,.23,['R = ' num2str(R(1,2)) ', P = ' num2str(P(1,2))],'Color','r');
[R,P] = corrcoef_BM( REM_prop.AcuteFlx.sleep_post , FreezingProp.All.AcuteFlx.Fear' )
u=text(0.01,.22,['R = ' num2str(R(1,2)) ', P = ' num2str(P(1,2))],'Color','g');


%% REM & RA
figure
subplot(121)
plot(REM_prop.Saline_All.sleep_pre , RA.Saline_All.Fear , '.b' , 'MarkerSize' , 30)
hold on
plot(REM_prop.ChronicFlx.sleep_pre , RA.ChronicFlx.Fear , '.r' , 'MarkerSize' , 30)
plot(REM_prop.AcuteFlx.sleep_pre , RA.AcuteFlx.Fear , '.g' , 'MarkerSize' , 30)
makepretty; xlabel('REM proportion'); ylabel('RA #'); xlim([0 .15]); ylim([0 40])
axis square
legend('Saline','Chronic Flx','Acute Flx')
title('Sleep Pre')

[R,P] = corrcoef_BM( REM_prop.Saline_All.sleep_pre , RA.Saline_All.Fear )
u=text(0.01,38,['R = ' num2str(R(1,2)) ', P = ' num2str(P(1,2))],'Color','b');
[R,P] = corrcoef_BM( REM_prop.ChronicFlx.sleep_pre , RA.ChronicFlx.Fear )
u=text(0.01,36,['R = ' num2str(R(1,2)) ', P = ' num2str(P(1,2))],'Color','r');
[R,P] = corrcoef_BM( REM_prop.AcuteFlx.sleep_pre , RA.AcuteFlx.Fear )
u=text(0.01,34,['R = ' num2str(R(1,2)) ', P = ' num2str(P(1,2))],'Color','g');


subplot(122)
plot(REM_prop.Saline_All.sleep_post , RA.Saline_All.Fear , '.b' , 'MarkerSize' , 30)
hold on
plot(REM_prop.ChronicFlx.sleep_post , RA.ChronicFlx.Fear , '.r' , 'MarkerSize' , 30)
plot(REM_prop.AcuteFlx.sleep_post , RA.AcuteFlx.Fear , '.g' , 'MarkerSize' , 30)
makepretty; xlabel('REM proportion'); xlim([0 .15]); ylim([0 40])
axis square
title('Sleep Post')

[R,P] = corrcoef_BM( REM_prop.Saline_All.sleep_post , RA.Saline_All.Fear )
u=text(0.01,38,['R = ' num2str(R(1,2)) ', P = ' num2str(P(1,2))],'Color','b');
[R,P] = corrcoef_BM( REM_prop.ChronicFlx.sleep_post , RA.ChronicFlx.Fear )
u=text(0.01,36,['R = ' num2str(R(1,2)) ', P = ' num2str(P(1,2))],'Color','r');
[R,P] = corrcoef_BM( REM_prop.AcuteFlx.sleep_post , RA.AcuteFlx.Fear )
u=text(0.01,34,['R = ' num2str(R(1,2)) ', P = ' num2str(P(1,2))],'Color','g');


%% REM & Occupancy mean time
figure
subplot(121)
plot(REM_prop.Saline_All.sleep_pre , OccupancyMeanTime.Shock.Saline_All.Fear , '.b' , 'MarkerSize' , 30)
hold on
plot(REM_prop.ChronicFlx.sleep_pre , OccupancyMeanTime.Shock.ChronicFlx.Fear , '.r' , 'MarkerSize' , 30)
plot(REM_prop.AcuteFlx.sleep_pre , OccupancyMeanTime.Shock.AcuteFlx.Fear , '.g' , 'MarkerSize' , 30)
makepretty; xlabel('REM proportion'); ylabel('Mean time shock zone (s)'); xlim([0 .15]); ylim([0 12])
axis square
legend('Saline','Chronic Flx','Acute Flx')
title('Sleep Pre')

[R,P] = corrcoef_BM( REM_prop.Saline_All.sleep_pre , OccupancyMeanTime.Shock.Saline_All.Fear )
u=text(0.01,11.5,['R = ' num2str(R(1,2)) ', P = ' num2str(P(1,2))],'Color','b');
[R,P] = corrcoef_BM( REM_prop.ChronicFlx.sleep_pre , OccupancyMeanTime.Shock.ChronicFlx.Fear' )
u=text(0.01,11,['R = ' num2str(R(1,2)) ', P = ' num2str(P(1,2))],'Color','r');
[R,P] = corrcoef_BM( REM_prop.AcuteFlx.sleep_pre , OccupancyMeanTime.Shock.AcuteFlx.Fear' )
u=text(0.01,10.5,['R = ' num2str(R(1,2)) ', P = ' num2str(P(1,2))],'Color','g');


subplot(122)
plot(REM_prop.Saline_All.sleep_post , OccupancyMeanTime.Shock.Saline_All.Fear , '.b' , 'MarkerSize' , 30)
hold on
plot(REM_prop.ChronicFlx.sleep_post , OccupancyMeanTime.Shock.ChronicFlx.Fear , '.r' , 'MarkerSize' , 30)
plot(REM_prop.AcuteFlx.sleep_post , OccupancyMeanTime.Shock.AcuteFlx.Fear , '.g' , 'MarkerSize' , 30)
makepretty; xlabel('REM proportion'); xlim([0 .15]); ylim([0 .2])
axis square
title('Sleep Post')

[R,P] = corrcoef_BM( REM_prop.Saline_All.sleep_post , OccupancyMeanTime.Shock.Saline_All.Fear )
u=text(0.01,.18,['R = ' num2str(R(1,2)) ', P = ' num2str(P(1,2))],'Color','b');
[R,P] = corrcoef_BM( REM_prop.ChronicFlx.sleep_post , OccupancyMeanTime.Shock.ChronicFlx.Fear' )
u=text(0.01,.17,['R = ' num2str(R(1,2)) ', P = ' num2str(P(1,2))],'Color','r');
[R,P] = corrcoef_BM( REM_prop.AcuteFlx.sleep_post , OccupancyMeanTime.Shock.AcuteFlx.Fear' )
u=text(0.01,.16,['R = ' num2str(R(1,2)) ', P = ' num2str(P(1,2))],'Color','g');


%% Freezing proportion & RA
figure
plot(FreezingProp.All.Saline_All.Fear , RA.Saline_All.Fear , '.b' , 'MarkerSize' , 30)
hold on
plot(FreezingProp.All.ChronicFlx.Fear , RA.ChronicFlx.Fear , '.r' , 'MarkerSize' , 30)
plot(FreezingProp.All.AcuteFlx.Fear , RA.AcuteFlx.Fear , '.g' , 'MarkerSize' , 30)
makepretty; ylabel('RA #'); xlabel('Freezing proportion'); xlim([0 .2]); ylim([0 40])
axis square
legend('Saline','Chronic Flx','Acute Flx')

[R,P] = corrcoef_BM( FreezingProp.All.Saline_All.Fear , RA.Saline_All.Fear )
u=text(0.01,38,['R = ' num2str(R(1,2)) ', P = ' num2str(P(1,2))],'Color','b');
[R,P] = corrcoef_BM( FreezingProp.All.ChronicFlx.Fear' , RA.ChronicFlx.Fear )
u=text(0.01,36,['R = ' num2str(R(1,2)) ', P = ' num2str(P(1,2))],'Color','r');
[R,P] = corrcoef_BM( FreezingProp.All.AcuteFlx.Fear' , RA.AcuteFlx.Fear )
u=text(0.01,34,['R = ' num2str(R(1,2)) ', P = ' num2str(P(1,2))],'Color','g');











