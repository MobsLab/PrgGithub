
clear all
GetEmbReactMiceFolderList_BM
for mouse =1:length(Mouse) % generate all sessions of interest
    AllSleepSess.(Mouse_names{mouse}) = Sess.(Mouse_names{mouse})(find(not(cellfun(@isempty,strfind(Sess.(Mouse_names{mouse}) ,'Sleep')))));
end

SleepSess={'SleepPre','SleepPost_Pre','SleepPost_Post'};
for mouse = 1:length(Mouse) % generate all sessions of interest
    for sleep_sess=1:length(AllSleepSess.(Mouse_names{mouse}))
        
        SleepEpoch.(Mouse_names{mouse})=ConcatenateDataFromFolders_SB(AllSleepSess.(Mouse_names{mouse})(sleep_sess),'epoch','epochname','sleepstates');
        NREM_and_REM.(Mouse_names{mouse})=or(SleepEpoch.(Mouse_names{mouse}){2},SleepEpoch.(Mouse_names{mouse}){3});
        All_Epoch.(Mouse_names{mouse})=or(or(SleepEpoch.(Mouse_names{mouse}){2},SleepEpoch.(Mouse_names{mouse}){3}),SleepEpoch.(Mouse_names{mouse}){1});
        REM_prop.(Mouse_names{mouse})(sleep_sess) = sum(Stop(SleepEpoch.(Mouse_names{mouse}){3})-Start(SleepEpoch.(Mouse_names{mouse}){3}))./(sum(Stop(NREM_and_REM.(Mouse_names{mouse}))-Start(NREM_and_REM.(Mouse_names{mouse}))))*100;
        Sleep_prop.(Mouse_names{mouse})(sleep_sess) = sum(Stop(NREM_and_REM.(Mouse_names{mouse}))-Start(NREM_and_REM.(Mouse_names{mouse})))./(sum(Stop(All_Epoch.(Mouse_names{mouse}))-Start(All_Epoch.(Mouse_names{mouse})))); Sleep_prop.(Mouse_names{mouse})(sleep_sess) = Sleep_prop.(Mouse_names{mouse})(sleep_sess)*100;
        
        % Ripples
        try
            Ripples_tsd.(Mouse_names{mouse}){sleep_sess} = ConcatenateDataFromFolders_BM(AllSleepSess.(Mouse_names{mouse})(sleep_sess),'ripples');
        catch
            Ripples_tsd.(Mouse_names{mouse}){sleep_sess} = [];
        end
        if isempty(Ripples_tsd.(Mouse_names{mouse}){sleep_sess})
            RipplesDensity.(Mouse_names{mouse})(sleep_sess) = NaN;
        else
            RipplesDensity.(Mouse_names{mouse})(sleep_sess) = length(Restrict(Ripples_tsd.(Mouse_names{mouse}){sleep_sess} , SleepEpoch.(Mouse_names{mouse}){2}))/(sum(Stop(SleepEpoch.(Mouse_names{mouse}){2})-Start(SleepEpoch.(Mouse_names{mouse}){2}))/1e4); % ripples density on SWS
        end
        try
            %             chan_numb = Get_chan_numb_BM(AllSleepSess.(Mouse_names{mouse}){1} , 'rip');
            %              LFP_rip.(Mouse_names{mouse}){sleep_sess} = ConcatenateDataFromFolders_BM(AllSleepSess.(Mouse_names{mouse})(sleep_sess),'lfp','channumber',chan_numb);
            %             Ripples_times_OnEpoch{sleep_sess} = Restrict(Ripples_tsd.(Mouse_names{mouse}){sleep_sess} , SleepEpoch.(Mouse_names{mouse}){2});
            %             ripples_time{sleep_sess} = Range(Ripples_times_OnEpoch{sleep_sess},'s');
            %             %             [M_pre,T_pre{sleep_sess}] = PlotRipRaw(LFP_rip.(Mouse_names{mouse}){sleep_sess}, ripples_time{sleep_sess}, 400, 0, 0);
            %             %             if isnan(nanmean(T_pre{sleep_sess}));
            %                 Mean_Ripples.(Mouse_names{mouse})(:,sleep_sess)=NaN(1,1001);
            %             else
            %                 Mean_Ripples.(Mouse_names{mouse})(:,sleep_sess) = nanmean(T_pre{sleep_sess});
            %             end
        end
        
        try
            NREM_Substages.(Mouse_names{mouse})=ConcatenateDataFromFolders_SB(AllSleepSess.(Mouse_names{mouse})(sleep_sess),'epoch','epochname','NREMsubstages');
            N1_prop.(Mouse_names{mouse})(sleep_sess) =sum(Stop(NREM_Substages.(Mouse_names{mouse}){1})-Start(NREM_Substages.(Mouse_names{mouse}){1}))./(sum(Stop(NREM_and_REM.(Mouse_names{mouse}))-Start(NREM_and_REM.(Mouse_names{mouse}))))*100;
            N2_prop.(Mouse_names{mouse})(sleep_sess) =sum(Stop(NREM_Substages.(Mouse_names{mouse}){2})-Start(NREM_Substages.(Mouse_names{mouse}){2}))./(sum(Stop(NREM_and_REM.(Mouse_names{mouse}))-Start(NREM_and_REM.(Mouse_names{mouse}))))*100;
            N3_prop.(Mouse_names{mouse})(sleep_sess) =sum(Stop(NREM_Substages.(Mouse_names{mouse}){3})-Start(NREM_Substages.(Mouse_names{mouse}){3}))./(sum(Stop(NREM_and_REM.(Mouse_names{mouse}))-Start(NREM_and_REM.(Mouse_names{mouse}))))*100;
        catch
            N1_prop.(Mouse_names{mouse})(sleep_sess) =NaN; N2_prop.(Mouse_names{mouse})(sleep_sess) = NaN; N3_prop.(Mouse_names{mouse})(sleep_sess) = NaN;
        end
        
%         Temperature.(Mouse_names{mouse})=ConcatenateDataFromFolders_SB(AllSleepSess.(Mouse_names{mouse})(sleep_sess),'masktemperature');
%         
%         SleepMeanTemp.(Mouse_names{mouse})(sleep_sess,1)=nanmean(Data(Restrict(Temperature.(Mouse_names{mouse}),SleepEpoch.(Mouse_names{mouse}){1})));
%         SleepMeanTemp.(Mouse_names{mouse})(sleep_sess,2)=nanmean(Data(Restrict(Temperature.(Mouse_names{mouse}),SleepEpoch.(Mouse_names{mouse}){2})));
%         SleepMeanTemp.(Mouse_names{mouse})(sleep_sess,3)=nanmean(Data(Restrict(Temperature.(Mouse_names{mouse}),SleepEpoch.(Mouse_names{mouse}){3})));
%         SleepMeanTemp.(Mouse_names{mouse})(sleep_sess,4)=nanmean(Data(Temperature.(Mouse_names{mouse})));
%         SleepMeanTemp.(Mouse_names{mouse})(sleep_sess,1:3)=SleepMeanTemp.(Mouse_names{mouse})(sleep_sess,1:3)-SleepMeanTemp.(Mouse_names{mouse})(sleep_sess,4);
%         
%         EKG.(Mouse_names{mouse})=ConcatenateDataFromFolders_SB(AllSleepSess.(Mouse_names{mouse})(sleep_sess),'heartrate');
%         
%         SleepMeanHR.(Mouse_names{mouse})(sleep_sess,1)=nanmean(Data(Restrict(EKG.(Mouse_names{mouse}),SleepEpoch.(Mouse_names{mouse}){1})));
%         SleepMeanHR.(Mouse_names{mouse})(sleep_sess,2)=nanmean(Data(Restrict(EKG.(Mouse_names{mouse}),SleepEpoch.(Mouse_names{mouse}){2})));
%         SleepMeanHR.(Mouse_names{mouse})(sleep_sess,3)=nanmean(Data(Restrict(EKG.(Mouse_names{mouse}),SleepEpoch.(Mouse_names{mouse}){3})));
%         SleepMeanHR.(Mouse_names{mouse})(sleep_sess,4)=nanmean(Data(EKG.(Mouse_names{mouse})));
%         
    end
    disp(Mouse_names{mouse})
end

% Gathering data
Drug_Group={'SalineSB','ChronicFlx','AcuteFlx','Midazolam','SalineBM_Short','Diazepam_Short','SalineBM_Long','Diazepam_Long','Saline1','Saline2','DZP1','DZP2','RipInhib','ChronicBUS','AcuteBUS','RipControl','RipInhib1','RipControl1','RipInhibPaired','RipControlPaired'};

for group=1:length(Drug_Group)
    
    Mouse=Drugs_Groups_UMaze_BM(group);
    
    for mouse=1:length(Mouse)
        Mouse_names{mouse}=['M' num2str(Mouse(mouse))];
        for sleep_sess=1:length(AllSleepSess.(Mouse_names{mouse}))
            REM_prop.(Drug_Group{group})(mouse,sleep_sess)=REM_prop.(Mouse_names{mouse})(sleep_sess);
            Sleep_prop.(Drug_Group{group})(mouse,sleep_sess)=Sleep_prop.(Mouse_names{mouse})(sleep_sess);
            RipplesDensity.(Drug_Group{group})(mouse,sleep_sess)=RipplesDensity.(Mouse_names{mouse})(sleep_sess);
            RipplesDensity.(Drug_Group{group})(RipplesDensity.(Drug_Group{group})==0)=NaN;
            
            N1_prop.(Drug_Group{group})(mouse,sleep_sess)=N1_prop.(Mouse_names{mouse})(sleep_sess);
            N2_prop.(Drug_Group{group})(mouse,sleep_sess)=N2_prop.(Mouse_names{mouse})(sleep_sess);
            N3_prop.(Drug_Group{group})(mouse,sleep_sess)=N3_prop.(Mouse_names{mouse})(sleep_sess);
            
%             Temperature_Wake.(Drug_Group{group})(mouse,sleep_sess)=SleepMeanTemp.(Mouse_names{mouse})(sleep_sess,1);
%             Temperature_NREM.(Drug_Group{group})(mouse,sleep_sess)=SleepMeanTemp.(Mouse_names{mouse})(sleep_sess,2);
%             Temperature_REM.(Drug_Group{group})(mouse,sleep_sess)=SleepMeanTemp.(Mouse_names{mouse})(sleep_sess,3);
%             AbsoluteTemperature.(Drug_Group{group})(mouse,sleep_sess)=SleepMeanTemp.(Mouse_names{mouse})(sleep_sess,4);
%             
%             EKG_Wake.(Drug_Group{group})(mouse,sleep_sess)=SleepMeanHR.(Mouse_names{mouse})(sleep_sess,1);
%             EKG_NREM.(Drug_Group{group})(mouse,sleep_sess)=SleepMeanHR.(Mouse_names{mouse})(sleep_sess,2);
%             EKG_REM.(Drug_Group{group})(mouse,sleep_sess)=SleepMeanHR.(Mouse_names{mouse})(sleep_sess,3);
%             MeanEKG.(Drug_Group{group})(mouse,sleep_sess)=SleepMeanHR.(Mouse_names{mouse})(sleep_sess,4);
%             
%             try
%                 Mean_Ripples.(Drug_Group{group})(mouse,:,sleep_sess) = Mean_Ripples.(Mouse_names{mouse})(:,sleep_sess);
%             catch
%                 Mean_Ripples.(Drug_Group{group})(mouse,:,sleep_sess) = NaN(1,1001);
%             end
%             Mean_Ripples.(Drug_Group{group})(Mean_Ripples.(Drug_Group{group})==0)=NaN;
        end
    end
end
% SleepMeanHR.M876=NaN(3,4); SleepMeanHR.M893=NaN(3,4); 
% REM_prop.SalineBM_Short([1 3],1)=NaN;  
% RipplesDensity.Classic(4,2)=NaN; RipplesDensity.M877(1)=NaN;
% Sleep_prop.Saline([1 2],3)=NaN; Sleep_prop.Classic(4,2)=NaN;
% EKG_Wake.Saline([1 2],3)=NaN; EKG_NREM.Saline([1 2],3)=NaN; EKG_REM.Saline([1 2],3)=NaN; MeanEKG.Saline([1 2],3)=NaN;
% Temperature_Wake.Saline([1 2],3)=NaN; Temperature_NREM.Saline([1 2],3)=NaN; Temperature_REM.Saline([1 2],3)=NaN; AbsoluteTemperature.Saline([1 2],3)=NaN;

% Mice without HPC
Sleep_prop.SalineBM_Short([1 3 11],1)=NaN;
REM_prop.SalineBM_Short([1 2 3 6 11],:)=NaN;

Sleep_prop.Saline1([1 3],1)=NaN;
REM_prop.Saline1([1 2 3 6],:)=NaN;
REM_prop.SalineBM_Long(1,:)=NaN; REM_prop.SalineBM_Long(2,1)=NaN;

REM_prop.DiazepamBM_Short([1 2],:)=NaN;

REM_prop.DZP1([1 2],:)=NaN;

N3_prop.ChronicFlx(6,:)=NaN;


Cols0 = {[0.66 0.66 1],[0 0 1],[0 0 0.33]};
X0 = [1:3];
Legends0 ={'SleepPre' 'SleepPost_Pre' 'SleepPost_Post'};
NoLegends0 ={'' '' ''};

Cols1 = {[0.66 0.66 1],[0 0 0.33]};
X1 = [1:2];
Legends1 ={'SleepPre' 'SleepPost'};
NoLegends1 ={'' ''};

X2 = [1:8];
Cols2 = {[0, 0, 1],[1, 0, 0],[1, 0.5, 0.5],[0, 0.5, 0],[0.3, 0.745, 0.93],[0.85, 0.325, 0.098],[0.2, 0.645, 0.83],[0.75, 0.225, 0]};
Legends_Drugs ={'SalineSB' 'Chronic Flx' 'Acute Flx' 'Midazolam','Saline_Short','DZP_Short','Saline_Long','DZP_Long'};
NoLegends_Drugs ={'', '', '', '','','','',''};

Cols3 = {'g','r','b'};

Group=1:4;
Group=[9 11 18 17 14];
Group=[7 8];

% Sleep
a=figure; a.Position=[1e3 1e3 1e3 1e3]; n=1;
for group=Group
    if size(REM_prop.(Drug_Group{group}),2)==3
        X = X0; Cols=Cols0; Legends=Legends0; NoLegends=NoLegends0;
    else
        X = X1; Cols=Cols1; Legends=Legends1; NoLegends=NoLegends1;
    end
    
    subplot(3,length(Group),n)
    MakeSpreadAndBoxPlot2_SB(REM_prop.(Drug_Group{group}),Cols,X,NoLegends,'showpoints',0);
    ylim([0 17])
    title(Drug_Group{group})
    if n==1; ylabel('REM proportion (%)'); end
    
    subplot(3,length(Group),n+length(Group))
    MakeSpreadAndBoxPlot2_SB(Sleep_prop.(Drug_Group{group}),Cols,X,NoLegends,'showpoints',0);
    ylim([0 100])
    if n==1; ylabel('Sleep proportion (%)'); end
    
    subplot(3,length(Group),n+length(Group)*2)
    MakeSpreadAndBoxPlot2_SB(RipplesDensity.(Drug_Group{group}),Cols,X,Legends,'showpoints',0);
    ylim([0 1])
    if n==1; ylabel('Ripples density'); end
    
    n=n+1;
end
a=sgtitle('Sleep characteristics, drugs experiments'); a.FontSize=20;


% Substages
a=figure; a.Position=[1e3 1e3 1.5e3 1e3]; n=1;
for group=Group
    if size(REM_prop.(Drug_Group{group}),2)==3
        X = X0; Cols=Cols0; Legends=Legends0; NoLegends=NoLegends0;
    else
        X = X1; Cols=Cols1; Legends=Legends1; NoLegends=NoLegends1;
    end
    
    subplot(3,4,n)
    MakeSpreadAndBoxPlot2_SB(N1_prop.(Drug_Group{group}),Cols,X,NoLegends,'showpoints',0);
    ylim([0 20])
    title(Drug_Group{group})
    if n==1; ylabel('N1 proportion (%)'); end
    
    subplot(3,4,n+4)
    MakeSpreadAndBoxPlot2_SB(N2_prop.(Drug_Group{group}),Cols,X,NoLegends,'showpoints',0);
    ylim([0 100])
    if n==1; ylabel('N2 proportion (%)'); end
    
    subplot(3,4,n+8)
    MakeSpreadAndBoxPlot2_SB(N3_prop.(Drug_Group{group}),Cols,X,Legends,'showpoints',0);
    ylim([0 100])
    if n==1; ylabel('N3 proportion (%)'); end
    
    n=n+1;
end
a=suptitle('NREM characteristics, UMaze drugs experiments'); a.FontSize=20;


% TEMPERATURE
figure
for group=[1 2 4]%1:length(Drug_Group)
    subplot(4,5,group)
    MakeSpreadAndBoxPlot2_SB(AbsoluteTemperature.(Drug_Group{group}),Cols,X,NoLegends,0,1);
    %ylim([-0.2 0.9])
    title(Drug_Group{group})
    if group==1; ylabel('Absolute Temperature'); end
    subplot(4,5,group+5)
    MakeSpreadAndBoxPlot2_SB(Temperature_Wake.(Drug_Group{group}),Cols,X,NoLegends,0,1);
    ylim([-0.2 0.9])
    title(Drug_Group{group})
    if group==1; ylabel('Temperature Wake'); end
    subplot(4,5,group+10)
    MakeSpreadAndBoxPlot2_SB(Temperature_NREM.(Drug_Group{group}),Cols,X,NoLegends,0,1);
    ylim([-0.7 0.1])
    if group==1; ylabel('Temperature NREM'); end
    xticks([ 1 2 3]); xticklabels({'','',''});
    subplot(4,5,group+15)
    MakeSpreadAndBoxPlot2_SB(Temperature_REM.(Drug_Group{group}),Cols,X,Legends,0,1);
    ylim([-0.8 0.3])
    if group==1; ylabel('Temperature REM'); end
end
a=suptitle('Temperature characteristics, drugs experiments'); a.FontSize=20;


% EKG
figure
for group=1:length(Drug_Group)-1
    subplot(4,5,group)
    MakeSpreadAndBoxPlot2_SB(MeanEKG.(Drug_Group{group}),Cols,X,NoLegends,'showpoints',0);
    ylim([7 12.5])
    title(Drug_Group{group})
    if group==1; ylabel('Mean Heart rate'); end
    subplot(4,5,group+5)
    MakeSpreadAndBoxPlot2_SB(EKG_Wake.(Drug_Group{group}),Cols,X,NoLegends,'showpoints',0);
    ylim([8 13.5])
    if group==1; ylabel('Heart rate Wake'); end
    xticks([ 1 2 3]); xticklabels({'','',''});
    subplot(4,5,group+10)
    MakeSpreadAndBoxPlot2_SB(EKG_NREM.(Drug_Group{group}),Cols,X,NoLegends,'showpoints',0);
    if group==1; ylabel('Heart rate NREM'); end
    subplot(4,5,group+15)
    MakeSpreadAndBoxPlot2_SB(EKG_REM.(Drug_Group{group}),Cols,X,Legends,'showpoints',0);
       ylim([8 13.5])
 if group==1; ylabel('Heart rate REM'); end
end
a=suptitle('Heart rate characteristics, drugs experiments'); a.FontSize=20;


%% Mean spectrum
Mouse=[666 668 688 739 777 779 849 893 1096 875 876 877 1001 1002 1095 1130 740 750 775 778 794 829 851 856 857 858 859 1005 1006 561 567 568 569];

for mouse = 1:length(Mouse) % generate all sessions of interest
    Mouse_names{mouse}=['M' num2str(Mouse(mouse))];
end

for mouse = 1:length(Mouse) % generate all sessions of interest
    for sleep_sess=1:length(AllSleepSess.(Mouse_names{mouse}))
        
        SleepEpoch.(Mouse_names{mouse})=ConcatenateDataFromFolders_SB(AllSleepSess.(Mouse_names{mouse})(sleep_sess),'epoch','epochname','sleepstates');
        NREM_and_REM.(Mouse_names{mouse})=or(SleepEpoch.(Mouse_names{mouse}){2},SleepEpoch.(Mouse_names{mouse}){3});
        
        try
            HPCSpec.(Mouse_names{mouse})=ConcatenateDataFromFolders_SB(AllSleepSess.(Mouse_names{mouse})(sleep_sess),'spectrum','prefix','H_Low');
            HPCSpec_REM.(Mouse_names{mouse})(sleep_sess,:) = nanmean(Data(Restrict(HPCSpec.(Mouse_names{mouse}) , SleepEpoch.(Mouse_names{mouse}){3} )));
            HPCSpec_Wake.(Mouse_names{mouse})(sleep_sess,:) = nanmean(Data(Restrict(HPCSpec.(Mouse_names{mouse}) , SleepEpoch.(Mouse_names{mouse}){1} )));
        end
        try
            PFCSpec.(Mouse_names{mouse})=ConcatenateDataFromFolders_SB(AllSleepSess.(Mouse_names{mouse})(sleep_sess),'spectrum','prefix','PFCx_Low');
            PFCSpec_NREM.(Mouse_names{mouse})(sleep_sess,:) = nanmean(Data(Restrict(PFCSpec.(Mouse_names{mouse}) , SleepEpoch.(Mouse_names{mouse}){2} )));
        end
        try
            OBSpec.(Mouse_names{mouse})=ConcatenateDataFromFolders_SB(AllSleepSess.(Mouse_names{mouse})(sleep_sess),'spectrum','prefix','B_Low');
            OBSpec_Wake.(Mouse_names{mouse})(sleep_sess,:) = nanmean(Data(Restrict(OBSpec.(Mouse_names{mouse}) , SleepEpoch.(Mouse_names{mouse}){1}  )));
            OBSpec_NREM.(Mouse_names{mouse})(sleep_sess,:) = nanmean(Data(Restrict(OBSpec.(Mouse_names{mouse}) , SleepEpoch.(Mouse_names{mouse}){2} )));
            OBSpec_REM.(Mouse_names{mouse})(sleep_sess,:) = nanmean(Data(Restrict(OBSpec.(Mouse_names{mouse}) , SleepEpoch.(Mouse_names{mouse}){3} )));
        end
        try
            HighOBSpec.(Mouse_names{mouse})=ConcatenateDataFromFolders_SB(AllSleepSess.(Mouse_names{mouse})(sleep_sess),'spectrum','prefix','B_High');
            HighOBSpec_Wake.(Mouse_names{mouse})(sleep_sess,:) = nanmean(Data(Restrict(HighOBSpec.(Mouse_names{mouse}) , SleepEpoch.(Mouse_names{mouse}){1} )));
            HighOBSpec_NREM.(Mouse_names{mouse})(sleep_sess,:) = nanmean(Data(Restrict(HighOBSpec.(Mouse_names{mouse}) , SleepEpoch.(Mouse_names{mouse}){2} )));
            HighOBSpec_REM.(Mouse_names{mouse})(sleep_sess,:) = nanmean(Data(Restrict(HighOBSpec.(Mouse_names{mouse}) , SleepEpoch.(Mouse_names{mouse}){3} )));
        end
    end
    disp(Mouse_names{mouse})
end
HPCSpec_REM.M1130 = NaN(3,261); HPCSpec_Wake.M1130 = NaN(3,261);
PFCSpec_NREM.M875(:,1:18) = NaN; PFCSpec_NREM.M876(:,1:18) = NaN; PFCSpec_NREM.M877(3,1:18) = NaN; PFCSpec_NREM.M778(3,1:18) = NaN; PFCSpec_NREM.M893(2,1:18) = NaN;

% Gathering data
Drug_Group={'Saline','ChronicFlx','AcuteFlx','Midazolam','Classic'};
for group=1:length(Drug_Group)
    
    if group==1 % saline mice
        Mouse_names={'M666','M668','M688','M739','M777','M779','M849','M893','M1096'};
        Mouse=[666 668 688 739 777 779 849 893 1096];
    elseif group==2 % chronic flx mice
        Mouse_names={'M875','M876','M877','M1001','M1002','M1095','M1130'};
        Mouse=[875 876 877 1001 1002 1095 1130 ];
    elseif group==3 % Acute Flx
        Mouse_names={'M740','M750','M775','M778','M794'};
        Mouse=[740 750 775 778 794];
    elseif group==4 % midazolam mice
        Mouse_names={'M829','M851','M857','M858','M859','M1005','M1006'};
        Mouse=[829 851 857 858 859 1005 1006];
    elseif group==5 % classic mice
        Mouse_names={'M561','M567','M568','M569'};
        Mouse=[561 566 567 568 569];
    end
    
    for mouse=1:length(Mouse_names)
        for sleep_sess=1:length(AllSleepSess.(Mouse_names{mouse}))
            try
                %REM
                [Power_max_Spc_HPC_REM.(Mouse_names{mouse}) , Freq_max_Spc_HPC_REM.(Mouse_names{mouse})] = max(HPCSpec_REM.(Mouse_names{mouse})(1,:));
                HPCSpec_REM.(Drug_Group{group}).(SleepSess{sleep_sess})(mouse,:)=HPCSpec_REM.(Mouse_names{mouse})(sleep_sess,:)./Power_max_Spc_HPC_REM.(Mouse_names{mouse}) ;
                Powermax_HPCSpec_REM.(Drug_Group{group})(mouse)=Power_max_Spc_HPC_REM.(Mouse_names{mouse});
                HPCSpec_REM.(Drug_Group{group}).(SleepSess{sleep_sess})(HPCSpec_REM.(Drug_Group{group}).(SleepSess{sleep_sess})==0)=NaN;
                %Wake
                [Power_max_Spc_HPC_Wake.(Mouse_names{mouse}) , Freq_max_Spc_HPC_Wake.(Mouse_names{mouse})] = max(HPCSpec_Wake.(Mouse_names{mouse})(1,52:157));
                HPCSpec_Wake.(Drug_Group{group}).(SleepSess{sleep_sess})(mouse,:)=HPCSpec_Wake.(Mouse_names{mouse})(sleep_sess,:)./Power_max_Spc_HPC_Wake.(Mouse_names{mouse}) ;
                Powermax_HPCSpec_Wake.(Drug_Group{group})(mouse)=Power_max_Spc_HPC_Wake.(Mouse_names{mouse});
                HPCSpec_Wake.(Drug_Group{group}).(SleepSess{sleep_sess})(HPCSpec_Wake.(Drug_Group{group}).(SleepSess{sleep_sess})==0)=NaN;
            end
            try
                % PFC NREM
                [Power_max_Spc_PFC_NREM.(Mouse_names{mouse}) , Freq_max_Spc_PFC_NREM.(Mouse_names{mouse})] = max(PFCSpec_NREM.(Mouse_names{mouse})(1,19:52));
                PFCSpec_NREM.(Drug_Group{group}).(SleepSess{sleep_sess})(mouse,:)=PFCSpec_NREM.(Mouse_names{mouse})(sleep_sess,:)./Power_max_Spc_PFC_NREM.(Mouse_names{mouse}) ;
                Powermax_PFCSpec_NREM.(Drug_Group{group})(mouse)=Power_max_Spc_PFC_NREM.(Mouse_names{mouse});
                PFCSpec_NREM.(Drug_Group{group}).(SleepSess{sleep_sess})(PFCSpec_NREM.(Drug_Group{group}).(SleepSess{sleep_sess})==0)=NaN;
            end
            try
                %REM
                [Power_max_Spc_OB_REM.(Mouse_names{mouse}) , Freq_max_Spc_OB_REM.(Mouse_names{mouse})] = max(OBSpec_REM.(Mouse_names{mouse})(1,19:end));
                OBSpec_REM.(Drug_Group{group}).(SleepSess{sleep_sess})(mouse,:)=OBSpec_REM.(Mouse_names{mouse})(sleep_sess,:)./Power_max_Spc_OB_REM.(Mouse_names{mouse}) ;
                Powermax_OBSpec_REM.(Drug_Group{group})(mouse)=Power_max_Spc_OB_REM.(Mouse_names{mouse});
                OBSpec_REM.(Drug_Group{group}).(SleepSess{sleep_sess})(OBSpec_REM.(Drug_Group{group}).(SleepSess{sleep_sess})==0)=NaN;
                %Wake
                [Power_max_Spc_OB_Wake.(Mouse_names{mouse}) , Freq_max_Spc_OB_Wake.(Mouse_names{mouse})] = max(OBSpec_Wake.(Mouse_names{mouse})(1,19:end));
                OBSpec_Wake.(Drug_Group{group}).(SleepSess{sleep_sess})(mouse,:)=OBSpec_Wake.(Mouse_names{mouse})(sleep_sess,:)./Power_max_Spc_OB_Wake.(Mouse_names{mouse}) ;
                Powermax_OBSpec_Wake.(Drug_Group{group})(mouse)=Power_max_Spc_OB_Wake.(Mouse_names{mouse});
                OBSpec_Wake.(Drug_Group{group}).(SleepSess{sleep_sess})(OBSpec_Wake.(Drug_Group{group}).(SleepSess{sleep_sess})==0)=NaN;
                %NREM
                [Power_max_Spc_OB_NREM.(Mouse_names{mouse}) , Freq_max_Spc_OB_NREM.(Mouse_names{mouse})] = max(OBSpec_NREM.(Mouse_names{mouse})(1,19:end));
                OBSpec_NREM.(Drug_Group{group}).(SleepSess{sleep_sess})(mouse,:)=OBSpec_NREM.(Mouse_names{mouse})(sleep_sess,:)./Power_max_Spc_OB_NREM.(Mouse_names{mouse}) ;
                Powermax_OBSpec_NREM.(Drug_Group{group})(mouse)=Power_max_Spc_OB_NREM.(Mouse_names{mouse});
                OBSpec_NREM.(Drug_Group{group}).(SleepSess{sleep_sess})(OBSpec_NREM.(Drug_Group{group}).(SleepSess{sleep_sess})==0)=NaN;
            end
            try
                %REM
                [Power_max_Spc_HighOB_REM.(Mouse_names{mouse}) , Freq_max_Spc_HighOB_REM.(Mouse_names{mouse})] = max(HighOBSpec_REM.(Mouse_names{mouse})(1,9:end));
                HighOBSpec_REM.(Drug_Group{group}).(SleepSess{sleep_sess})(mouse,:)=HighOBSpec_REM.(Mouse_names{mouse})(sleep_sess,:)./Power_max_Spc_HighOB_REM.(Mouse_names{mouse}) ;
                Powermax_HighOBSpec_REM.(Drug_Group{group})(mouse)=Power_max_Spc_HighOB_REM.(Mouse_names{mouse});
                HighOBSpec_REM.(Drug_Group{group}).(SleepSess{sleep_sess})(HighOBSpec_REM.(Drug_Group{group}).(SleepSess{sleep_sess})==0)=NaN;
                %Wake
                [Power_max_Spc_HighOB_Wake.(Mouse_names{mouse}) , Freq_max_Spc_HighOB_Wake.(Mouse_names{mouse})] = max(HighOBSpec_Wake.(Mouse_names{mouse})(1,9:end));
                HighOBSpec_Wake.(Drug_Group{group}).(SleepSess{sleep_sess})(mouse,:)=HighOBSpec_Wake.(Mouse_names{mouse})(sleep_sess,:)./Power_max_Spc_HighOB_Wake.(Mouse_names{mouse}) ;
                Powermax_HighOBSpec_Wake.(Drug_Group{group})(mouse)=Power_max_Spc_HighOB_Wake.(Mouse_names{mouse});
                HighOBSpec_Wake.(Drug_Group{group}).(SleepSess{sleep_sess})(HighOBSpec_Wake.(Drug_Group{group}).(SleepSess{sleep_sess})==0)=NaN;
                %NREM
                [Power_max_Spc_HighOB_NREM.(Mouse_names{mouse}) , Freq_max_Spc_HighOB_NREM.(Mouse_names{mouse})] = max(HighOBSpec_NREM.(Mouse_names{mouse})(1,9:end));
                HighOBSpec_NREM.(Drug_Group{group}).(SleepSess{sleep_sess})(mouse,:)=HighOBSpec_NREM.(Mouse_names{mouse})(sleep_sess,:)./Power_max_Spc_HighOB_NREM.(Mouse_names{mouse}) ;
                Powermax_HighOBSpec_NREM.(Drug_Group{group})(mouse)=Power_max_Spc_HighOB_NREM.(Mouse_names{mouse});
                HighOBSpec_NREM.(Drug_Group{group}).(SleepSess{sleep_sess})(HighOBSpec_NREM.(Drug_Group{group}).(SleepSess{sleep_sess})==0)=NaN;
            end
        end
    end
end

%% HPC
Cols3 = {{'g'},{'-r'},{'-b'}};
load('H_Low_Spectrum.mat')
figure
for group=1:length(Drug_Group)
    
    if group==1 % saline mice
        Mouse_names={'M666','M668','M688','M739','M777','M779','M849','M893','M1096'};
        Mouse=[666 668 688 739 777 779 849 893 1096];
    elseif group==2 % chronic flx mice
        Mouse_names={'M875','M876','M877','M1001','M1002','M1095','M1130'};
        Mouse=[875 876 877 1001 1002 1095 1130 ];
    elseif group==3 % Acute Flx
        Mouse_names={'M740','M750','M775','M778','M794'};
        Mouse=[740 750 775 778 794];
    elseif group==4 % midazolam mice
        Mouse_names={'M829','M851','M857','M858','M859','M1005','M1006'};
        Mouse=[829 851 857 858 859 1005 1006];
    elseif group==5 % classic mice
        Mouse_names={'M561','M567','M568','M569'};
        Mouse=[561 567 568 569];
    end
    
    subplot(2,5,group)
    for sleep_sess=1:length(AllSleepSess.(Mouse_names{3}))
        Conf_Inter=nanstd(HPCSpec_REM.(Drug_Group{group}).(SleepSess{sleep_sess}))/sqrt(length(Mouse_names))';
        shadedErrorBar(Spectro{3} , nanmean(HPCSpec_REM.(Drug_Group{group}).(SleepSess{sleep_sess})) , Conf_Inter,Cols3{sleep_sess},1); hold on;
    end
    makepretty
    xlim([4 12]); ylim([0 1.2])
    title(Drug_Group{group})
    if group==1; ylabel('Theta HPC REM');
        f=get(gca,'Children'); legend([f(12),f(8),f(4)],'Sleep Pre','Sleep Post Pre','Sleep Post Post'); end
    
    
    subplot(2,5,group+5)
    for sleep_sess=1:length(AllSleepSess.(Mouse_names{3}))
        Conf_Inter=nanstd(HPCSpec_Wake.(Drug_Group{group}).(SleepSess{sleep_sess}))/sqrt(length(Mouse_names))';
        shadedErrorBar(Spectro{3} , nanmean(HPCSpec_Wake.(Drug_Group{group}).(SleepSess{sleep_sess})) , Conf_Inter,Cols3{sleep_sess},1); hold on;
    end
    makepretty
    xlim([4 12]); ylim([0 1.2])
    if group==1; ylabel('Theta HPC Wake'); end
    xlabel('Frequency (Hz)')
    
end
a=suptitle('Mean HPC Spectrum during REM & Wake, UMaze drugs experiments'); a.FontSize=20;

% Power
figure
subplot(121)
MakeSpreadAndBoxPlot2_SB({Powermax_HPCSpec_REM.Saline Powermax_HPCSpec_REM.ChronicFlx Powermax_HPCSpec_REM.AcuteFlx Powermax_HPCSpec_REM.Midazolam Powermax_HPCSpec_REM.Classic},Cols2,X2,Legends_Drugs,'showpoints',1,'paired',0);
ylabel('Power maximum')
title('REM'); ylim([0 3e5])
subplot(122)
MakeSpreadAndBoxPlot2_SB([{Powermax_HPCSpec_Wake.Saline}, {Powermax_HPCSpec_Wake.ChronicFlx}, {Powermax_HPCSpec_Wake.AcuteFlx}, {Powermax_HPCSpec_Wake.Midazolam}, {Powermax_HPCSpec_Wake.Classic}],Cols2,X2,Legends_Drugs,'showpoints',1,'paired',0);
title('Wake'); ylim([0 3.5e5])
a=suptitle('Power maximums of HPC spectrums in Sleep Pre'); a.FontSize=20;


%% PFC
figure
for group=1:length(Drug_Group)
    
    if group==1 % saline mice
        Mouse_names={'M666','M668','M688','M739','M777','M779','M849','M893','M1096'};
        Mouse=[666 668 688 739 777 779 849 893 1096];
    elseif group==2 % chronic flx mice
        Mouse_names={'M875','M876','M877','M1001','M1002','M1095','M1130'};
        Mouse=[875 876 877 1001 1002 1095 1130 ];
    elseif group==3 % Acute Flx
        Mouse_names={'M740','M750','M775','M778','M794'};
        Mouse=[740 750 775 778 794];
    elseif group==4 % midazolam mice
        Mouse_names={'M829','M851','M857','M858','M859','M1005','M1006'};
        Mouse=[829 851 857 858 859 1005 1006];
    elseif group==5 % classic mice
        Mouse_names={'M561','M567','M568','M569'};
        Mouse=[561 566 567 568 569];
    end
    
    subplot(1,5,group)
    for sleep_sess=1:length(AllSleepSess.(Mouse_names{3}))
        Conf_Inter=nanstd(PFCSpec_NREM.(Drug_Group{group}).(SleepSess{sleep_sess}))/sqrt(length(Mouse_names))';
        shadedErrorBar(Spectro{3} , nanmean(PFCSpec_NREM.(Drug_Group{group}).(SleepSess{sleep_sess})) , Conf_Inter,Cols3{sleep_sess},1); hold on;
    end
    makepretty
    xlim([0 5]); ylim([0 1.6])
    title(Drug_Group{group})
    if group==1; ylabel('PFC NREM');
        f=get(gca,'Children'); legend([f(12),f(8),f(4)],'Sleep Pre','Sleep Post Pre','Sleep Post Post'); end
    xlabel('Frequency (Hz)')
    
end
a=suptitle('Mean PFC Spectrum during NREM, UMaze drugs experiments'); a.FontSize=20;

% Power
figure
MakeSpreadAndBoxPlot2_SB([{Powermax_PFCSpec_NREM.Saline}, {Powermax_PFCSpec_NREM.ChronicFlx}, {Powermax_PFCSpec_NREM.AcuteFlx}, {Powermax_PFCSpec_NREM.Midazolam}, {Powermax_PFCSpec_NREM.Classic}],Cols2,X2,Legends_Drugs,'showpoints',1,'paired',0);
ylabel('Power maximum')
a=suptitle('Power maximums of PFC spectrums in Sleep Pre'); a.FontSize=20;

%% Low OB
figure
for group=1:length(Drug_Group)
    
    if group==1 % saline mice
        Mouse_names={'M666','M668','M688','M739','M777','M779','M849','M893','M1096'};
        Mouse=[666 668 688 739 777 779 849 893 1096];
    elseif group==2 % chronic flx mice
        Mouse_names={'M875','M876','M877','M1001','M1002','M1095','M1130'};
        Mouse=[875 876 877 1001 1002 1095 1130 ];
    elseif group==3 % Acute Flx
        Mouse_names={'M740','M750','M775','M778','M794'};
        Mouse=[740 750 775 778 794];
    elseif group==4 % midazolam mice
        Mouse_names={'M829','M851','M857','M858','M859','M1005','M1006'};
        Mouse=[829 851 857 858 859 1005 1006];
    elseif group==5 % classic mice
        Mouse_names={'M561','M567','M568','M569'};
        Mouse=[561 567 568 569];
    end
    
    subplot(3,5,group)
    for sleep_sess=1:3
        Conf_Inter=nanstd(OBSpec_Wake.(Drug_Group{group}).(SleepSess{sleep_sess}))/sqrt(length(Mouse_names))';
        shadedErrorBar(Spectro{3} , nanmean(OBSpec_Wake.(Drug_Group{group}).(SleepSess{sleep_sess})) , Conf_Inter,Cols3{sleep_sess},1); hold on;
    end
    makepretty
    xlim([0 10]); ylim([0 1.4])
    title(Drug_Group{group})
    if group==1; ylabel('OB Wake');
        f=get(gca,'Children'); legend([f(12),f(8),f(4)],'Sleep Pre','Sleep Post Pre','Sleep Post Post'); end
    
    subplot(3,5,group+5)
    for sleep_sess=1:3
        Conf_Inter=nanstd(OBSpec_NREM.(Drug_Group{group}).(SleepSess{sleep_sess}))/sqrt(length(Mouse_names))';
        shadedErrorBar(Spectro{3} , nanmean(OBSpec_NREM.(Drug_Group{group}).(SleepSess{sleep_sess})) , Conf_Inter,Cols3{sleep_sess},1); hold on;
    end
    makepretty
    xlim([0 7]); ylim([0 1.5])
    if group==1; ylabel('OB NREM'); end
    
    subplot(3,5,group+10)
    for sleep_sess=1:3
        Conf_Inter=nanstd(OBSpec_REM.(Drug_Group{group}).(SleepSess{sleep_sess}))/sqrt(length(Mouse_names))';
        shadedErrorBar(Spectro{3} , nanmean(OBSpec_REM.(Drug_Group{group}).(SleepSess{sleep_sess})) , Conf_Inter,Cols3{sleep_sess},1); hold on;
    end
    makepretty
    xlim([0 7]); ylim([0 2])
    if group==1; ylabel('OB REM'); end
    xlabel('Frequency (Hz)')
    
end
a=suptitle('Mean OB Spectrum during Wake & NREM & REM, UMaze drugs experiments'); a.FontSize=20;

% Power
figure
subplot(131)
MakeSpreadAndBoxPlot2_SB([{Powermax_OBSpec_Wake.Saline}, {Powermax_OBSpec_Wake.ChronicFlx}, {Powermax_OBSpec_Wake.AcuteFlx}, {Powermax_OBSpec_Wake.Midazolam}, {Powermax_OBSpec_Wake.Classic}],Cols2,X2,Legends_Drugs,'showpoints',1,'paired',0);
ylabel('Power maximum')
title('Wake')
ylim([0 12e5])
subplot(132)
MakeSpreadAndBoxPlot2_SB([{Powermax_OBSpec_NREM.Saline}, {Powermax_OBSpec_NREM.ChronicFlx}, {Powermax_OBSpec_NREM.AcuteFlx}, {Powermax_OBSpec_NREM.Midazolam}, {Powermax_OBSpec_NREM.Classic}],Cols2,X2,Legends_Drugs,'showpoints',1,'paired',0);
title('NREM')
ylim([0 12e5])
subplot(133)
MakeSpreadAndBoxPlot2_SB([{Powermax_OBSpec_REM.Saline}, {Powermax_OBSpec_REM.ChronicFlx}, {Powermax_OBSpec_REM.AcuteFlx}, {Powermax_OBSpec_REM.Midazolam}, {Powermax_OBSpec_REM.Classic}],Cols2,X2,Legends_Drugs,'showpoints',1,'paired',0);
title('REM')
ylim([0 12e5])
a=suptitle('Power maximums of Low OB spectrums in Sleep Pre'); a.FontSize=20;



%% HighOB
load('B_High_Spectrum.mat')
figure
for group=1:length(Drug_Group)
    
    if group==1 % saline mice
        Mouse_names={'M666','M668','M688','M739','M777','M779','M849','M893','M1096'};
        Mouse=[666 668 688 739 777 779 849 893 1096];
    elseif group==2 % chronic flx mice
        Mouse_names={'M875','M876','M877','M1001','M1002','M1095','M1130'};
        Mouse=[875 876 877 1001 1002 1095 1130 ];
    elseif group==3 % Acute Flx
        Mouse_names={'M740','M750','M775','M778','M794'};
        Mouse=[740 750 775 778 794];
    elseif group==4 % midazolam mice
        Mouse_names={'M829','M851','M857','M858','M859','M1005','M1006'};
        Mouse=[829 851 857 858 859 1005 1006];
    elseif group==5 % classic mice
        Mouse_names={'M561','M567','M568','M569'};
        Mouse=[561 567 568 569];
    end
    
    subplot(3,5,group)
    for sleep_sess=1:3
        Conf_Inter=nanstd(HighOBSpec_Wake.(Drug_Group{group}).(SleepSess{sleep_sess}))/sqrt(length(Mouse_names))';
        shadedErrorBar(Spectro{3} , nanmean(HighOBSpec_Wake.(Drug_Group{group}).(SleepSess{sleep_sess})) , Conf_Inter,Cols3{sleep_sess},1); hold on;
    end
    makepretty
    ylim([0 1.5]); xlim([20 100])
    title(Drug_Group{group})
    if group==1; ylabel('HighOB Wake');
        f=get(gca,'Children'); legend([f(12),f(8),f(4)],'Sleep Pre','Sleep Post Pre','Sleep Post Post'); end
    
    subplot(3,5,group+5)
    for sleep_sess=1:3
        Conf_Inter=nanstd(HighOBSpec_NREM.(Drug_Group{group}).(SleepSess{sleep_sess}))/sqrt(length(Mouse_names))';
        shadedErrorBar(Spectro{3} , nanmean(HighOBSpec_NREM.(Drug_Group{group}).(SleepSess{sleep_sess})) , Conf_Inter,Cols3{sleep_sess},1); hold on;
    end
    makepretty
    ylim([0 2.5]); xlim([20 100])
    if group==1; ylabel('HighOB NREM'); end
    
    subplot(3,5,group+10)
    for sleep_sess=1:3
        Conf_Inter=nanstd(HighOBSpec_REM.(Drug_Group{group}).(SleepSess{sleep_sess}))/sqrt(length(Mouse_names))';
        shadedErrorBar(Spectro{3} , nanmean(HighOBSpec_REM.(Drug_Group{group}).(SleepSess{sleep_sess})) , Conf_Inter,Cols3{sleep_sess},1); hold on;
    end
    makepretty
    ylim([0 2.5]); xlim([20 100])
    if group==1; ylabel('HighOB REM'); end
    xlabel('Frequency (Hz)')
    
end
a=suptitle('Mean HighOB Spectrum during Wake & NREM & REM, UMaze drugs experiments'); a.FontSize=20;

% Power
figure
subplot(131)
MakeSpreadAndBoxPlot2_SB([{Powermax_HighOBSpec_Wake.Saline}, {Powermax_HighOBSpec_Wake.ChronicFlx}, {Powermax_HighOBSpec_Wake.AcuteFlx}, {Powermax_HighOBSpec_Wake.Midazolam}, {Powermax_HighOBSpec_Wake.Classic}],Cols2,X2,Legends_Drugs,'showpoints',1,'paired',0);
ylabel('Power maximum')
title('Wake')
ylim([0 2e4])
subplot(132)
MakeSpreadAndBoxPlot2_SB([{Powermax_HighOBSpec_NREM.Saline}, {Powermax_HighOBSpec_NREM.ChronicFlx}, {Powermax_HighOBSpec_NREM.AcuteFlx}, {Powermax_HighOBSpec_NREM.Midazolam}, {Powermax_HighOBSpec_NREM.Classic}],Cols2,X2,Legends_Drugs,'showpoints',1,'paired',0);
title('NREM')
ylim([0 2e4])
subplot(133)
MakeSpreadAndBoxPlot2_SB([{Powermax_HighOBSpec_REM.Saline}, {Powermax_HighOBSpec_REM.ChronicFlx}, {Powermax_HighOBSpec_REM.AcuteFlx}, {Powermax_HighOBSpec_REM.Midazolam}, {Powermax_HighOBSpec_REM.Classic}],Cols2,X2,Legends_Drugs,'showpoints',1,'paired',0);
title('REM')
ylim([0 2e4])
a=suptitle('Power maximums of High OB spectrums in Sleep Pre'); a.FontSize=20;


% Ripples mean waveform
figure
for group=1:length(Drug_Group)-1
    
    subplot(2,2,group)
    Conf_Inter=nanstd(squeeze(Mean_Ripples.(Drug_Group{group})(:,:,1)))/sqrt(size(squeeze(Mean_Ripples.(Drug_Group{group})(:,:,1)),1));
    clear Mean_All_Sp; Mean_All_Sp=squeeze(nanmean(Mean_Ripples.(Drug_Group{group})(:,:,1)));
    shadedErrorBar([1:1001] , Mean_All_Sp , Conf_Inter,'-k',1); hold on;
    Conf_Inter=nanstd(squeeze(Mean_Ripples.(Drug_Group{group})(:,:,2)))/sqrt(size(squeeze(Mean_Ripples.(Drug_Group{group})(:,:,2)),1));
    clear Mean_All_Sp; Mean_All_Sp=squeeze(nanmean(Mean_Ripples.(Drug_Group{group})(:,:,2)));
    shadedErrorBar([1:1001] , Mean_All_Sp+1000 , Conf_Inter,'-b',1); hold on;
    Conf_Inter=nanstd(squeeze(Mean_Ripples.(Drug_Group{group})(:,:,3)))/sqrt(size(squeeze(Mean_Ripples.(Drug_Group{group})(:,:,3)),1));
    clear Mean_All_Sp; Mean_All_Sp=squeeze(nanmean(Mean_Ripples.(Drug_Group{group})(:,:,3)));
    shadedErrorBar([1:1001] , Mean_All_Sp+2000 , Conf_Inter,'-r',1); hold on;
    makepretty; xlabel('time (a.u.)'); ylabel('time (V)'); xlim([300 750])
    if group==1; f=get(gca,'Children'); legend([f(9),f(5),f(1)],'Sleep Pre','Sleep Post C','Sleep Post C Post D'); end
    title(Drug_Group{group})
end
a=suptitle('Ripples waveform during NREM'); a.FontSize=20;


%%





a=figure; a.Position=[1e3 1e3 1.5e3 1e3]; n=1;
for group=Group
    if size(REM_prop.(Drug_Group{group}),2)==3
        X = X0; Cols=Cols0; Legends=Legends0; NoLegends=NoLegends0;
    else
        X = X1; Cols=Cols1; Legends=Legends1; NoLegends=NoLegends1;
    end
    
    subplot(3,length(Group),n)
    try
        MakeSpreadAndBoxPlot2_SB(N1_prop.(Drug_Group{group}),Cols,X,NoLegends,'showpoints',0);
        ylim([0 20])
        title(Drug_Group{group})
        if n==1; ylabel('N1 proportion (%)'); end
    end
    try
        subplot(3,length(Group),n+length(Group))
        MakeSpreadAndBoxPlot2_SB(N2_prop.(Drug_Group{group}),Cols,X,NoLegends,'showpoints',0);
        ylim([0 100])
        if n==1; ylabel('N2 proportion (%)'); end
    end
    try
        subplot(3,length(Group),n+2*length(Group))
        MakeSpreadAndBoxPlot2_SB(N3_prop.(Drug_Group{group}),Cols,X,Legends,'showpoints',0);
        ylim([0 100])
        if n==1; ylabel('N3 proportion (%)'); end
    end
    n=n+1;
end



%%


for mouse=1:length(Mouse)
    Mouse_names{mouse}=['M' num2str(Mouse(mouse))];
    for sleep_sess=1:length(AllSleepSess.(Mouse_names{mouse}))
        
        SleepEpoch.(Mouse_names{mouse})=ConcatenateDataFromFolders_SB(AllSleepSess.(Mouse_names{mouse})(sleep_sess),'epoch','epochname','sleepstates');
        NREM_and_REM.(Mouse_names{mouse})=or(SleepEpoch.(Mouse_names{mouse}){2},SleepEpoch.(Mouse_names{mouse}){3});
        All_Epoch.(Mouse_names{mouse})=or(or(SleepEpoch.(Mouse_names{mouse}){2},SleepEpoch.(Mouse_names{mouse}){3}),SleepEpoch.(Mouse_names{mouse}){1});
        
        REM_prop.(Mouse_names{mouse})(sleep_sess) = sum(Stop(SleepEpoch.(Mouse_names{mouse}){3})-Start(SleepEpoch.(Mouse_names{mouse}){3}))./(sum(Stop(NREM_and_REM.(Mouse_names{mouse}))-Start(NREM_and_REM.(Mouse_names{mouse}))))*100;
        REM_MeanDur.(Mouse_names{mouse})(sleep_sess) = nanmean(Stop(SleepEpoch.(Mouse_names{mouse}){3})-Start(SleepEpoch.(Mouse_names{mouse}){3}))/1e4;
        REM_EpNumb.(Mouse_names{mouse})(sleep_sess) = length(Stop(SleepEpoch.(Mouse_names{mouse}){3}));
        
        REM_prop_all(mouse,sleep_sess) = REM_prop.(Mouse_names{mouse})(sleep_sess);
        REM_MeanDur_all(mouse,sleep_sess) = REM_MeanDur.(Mouse_names{mouse})(sleep_sess);
        REM_EpNumb_all(mouse,sleep_sess) = REM_EpNumb.(Mouse_names{mouse})(sleep_sess);
        
    end
end

    
Cols0 = {[0.66 0.66 1],[0 0 1],[0 0 0.33]};
X0 = [1:3];
Legends0 ={'SleepPre' 'SleepPost_Pre' 'SleepPost_Post'};
NoLegends0 ={'' '' ''};


figure
subplot(131)
MakeSpreadAndBoxPlot2_SB(REM_prop_all,Cols0,X0,Legends0,'showpoints',0);
ylim([0 17])
title('REM proportion'), ylabel('proportion')

subplot(132)
MakeSpreadAndBoxPlot2_SB(REM_MeanDur_all,Cols0,X0,Legends0,'showpoints',0);
ylim([0 65])
title('REM episodes number'), ylabel('#')

subplot(133)
MakeSpreadAndBoxPlot2_SB(REM_EpNumb_all,Cols0,X0,Legends0,'showpoints',0);
ylim([0 35])
title('REM mean duration'), ylabel('time (s)')

 sgtitle('REM features, UMaze, Saline long protocol')











