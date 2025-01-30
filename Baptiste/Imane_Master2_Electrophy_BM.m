
GetEmbReactMiceFolderList_BM
Mouse=[688,739,777,779,849,893,1096];
Session_type={'Cond','sleep_pre','sleep_post'};
Session_type1={'sleep_pre','sleep_post'};
Session_type2={'Cond'};
Drug_Group={'Saline'};

load('/media/nas6/ProjetEmbReact/DataEmbReact/Imane_code_Data.mat') % physio/neuro data

%% generate data and epoch
% run only if you didn't load data
for sess=1:length(Session_type) 
    [OutPutData.(Session_type{sess}) , Epoch1.(Session_type{sess}) , NameEpoch] = MeanValuesPhysiologicalParameters_BM(Mouse,lower(Session_type{sess}),'ob_low','hpc_low','pfc_low');
end

for mouse=1:length(Mouse)
    Mouse_names{mouse}=['M' num2str(Mouse(mouse))];
    UMazeSleepSess.(Mouse_names{mouse}) = Sess.(Mouse_names{mouse})(find(not(cellfun(@isempty,strfind(Sess.(Mouse_names{mouse}) ,'Sleep')))));
    SleepPreSess.(Mouse_names{mouse}) = UMazeSleepSess.(Mouse_names{mouse})(1);
    SleepPostSess.(Mouse_names{mouse}) = UMazeSleepSess.(Mouse_names{mouse})(3);
end

for mouse=1:length(Mouse)
    Mouse_names{mouse}=['M' num2str(Mouse(mouse))];
    % Sleep data
    for sess=1:length(Session_type1)
        
        if sess==1
            FolderList=SleepPreSess;
        else
            FolderList=SleepPostSess;
        end
        
        HPC_Spec.(Session_type1{sess}).(Mouse_names{mouse}) = ConcatenateDataFromFolders_SB(FolderList.(Mouse_names{mouse}) , 'spectrum','prefix','H_Low');
        OB_Spec.(Session_type1{sess}).(Mouse_names{mouse}) = ConcatenateDataFromFolders_SB(FolderList.(Mouse_names{mouse}) , 'spectrum','prefix','B_Low');
        PFC_Spec.(Session_type1{sess}).(Mouse_names{mouse}) = ConcatenateDataFromFolders_SB(FolderList.(Mouse_names{mouse}) , 'spectrum','prefix','PFCx_Low');
        
        REM_MeanDur.(Session_type1{sess}).(Mouse_names{mouse}) = (Stop(Epoch1.(Session_type1{sess}){mouse,5})-Start(Epoch1.(Session_type1{sess}){mouse,5}))/1e4;
        REM_TotalDur.(Session_type1{sess}).(Mouse_names{mouse}) = sum(Stop(Epoch1.(Session_type1{sess}){mouse,5})-Start(Epoch1.(Session_type1{sess}){mouse,5}))/1e4;
        Sleep_TotalDur.(Session_type1{sess}).(Mouse_names{mouse}) = sum(Stop(Epoch1.(Session_type1{sess}){mouse,3})-Start(Epoch1.(Session_type1{sess}){mouse,3}))/1e4;
        REM_prop.(Session_type1{sess}).(Mouse_names{mouse}) = sum(Stop(Epoch1.(Session_type1{sess}){mouse,5})-Start(Epoch1.(Session_type1{sess}){mouse,5}))/sum(Stop(Epoch1.(Session_type1{sess}){mouse,3})-Start(Epoch1.(Session_type1{sess}){mouse,3}));
        LongREM_MeanDur.(Session_type1{sess}).(Mouse_names{mouse}) = REM_MeanDur.(Session_type1{sess}).(Mouse_names{mouse})(REM_MeanDur.(Session_type1{sess}).(Mouse_names{mouse})>15);        
        [aft_cell.(Session_type1{sess}).(Mouse_names{mouse}) , bef_cell.(Session_type1{sess}).(Mouse_names{mouse})] = transEpoch(or(Epoch1.(Session_type1{sess}){mouse,4} , Epoch1.(Session_type1{sess}){mouse,2}) , Epoch1.(Session_type1{sess}){mouse,5});
        
        ind_to_use = ((Stop(aft_cell.(Session_type1{sess}).(Mouse_names{mouse}){1,2}) - Start(aft_cell.(Session_type1{sess}).(Mouse_names{mouse}){1,2}))/60e4)<2.5; % less than 3 minutes between REM episodes
        clear REM_Start_After_Other REM_Stop_After_Other
        REM_Start_After_Other = Start(bef_cell.(Session_type1{sess}).(Mouse_names{mouse}){2,1});
        REM_Stop_After_Other = Stop(bef_cell.(Session_type1{sess}).(Mouse_names{mouse}){2,1});

        Sequential_REM_Epoch.(Session_type1{sess}).(Mouse_names{mouse}) = intervalSet(REM_Start_After_Other(ind_to_use) , REM_Stop_After_Other(ind_to_use));
        Single_REM_Epoch.(Session_type1{sess}).(Mouse_names{mouse}) = intervalSet(REM_Start_After_Other(~ind_to_use) , REM_Stop_After_Other(~ind_to_use));

    end
    disp(Mouse_names{mouse})
end


for mouse = 1:length(Mouse) % generate all sessions of interest
    Mouse_names{mouse}=['M' num2str(Mouse(mouse))];
    for sess=1:length(Session_type1)
        %try
        HPC_Spec_REM.(Session_type1{sess}).(Mouse_names{mouse}) = OutPutData.(Session_type1{sess}).hpc_low.mean(mouse,5,:);
        OB_Spec_REM.(Session_type1{sess}).(Mouse_names{mouse}) = OutPutData.(Session_type1{sess}).ob_low.mean(mouse,5,:);
        PFC_Spec_REM.(Session_type1{sess}).(Mouse_names{mouse}) = OutPutData.(Session_type1{sess}).pfc_low.mean(mouse,5,:);
        
        HPC_Max_REM.(Session_type1{sess}).(Mouse_names{mouse}) = OutPutData.(Session_type1{sess}).hpc_low.power(mouse,5);
        OB_Max_REM.(Session_type1{sess}).(Mouse_names{mouse}) = OutPutData.(Session_type1{sess}).ob_low.power(mouse,5);
        PFC_Max_REM.(Session_type1{sess}).(Mouse_names{mouse}) = OutPutData.(Session_type1{sess}).pfc_low.power(mouse,5);
        
        HPC_Freq_REM.(Session_type1{sess}).(Mouse_names{mouse}) = OutPutData.(Session_type1{sess}).hpc_low.max_freq(mouse,5);
        OB_Freq_REM.(Session_type1{sess}).(Mouse_names{mouse}) = OutPutData.(Session_type1{sess}).ob_low.max_freq(mouse,5);
        PFC_Freq_REM.(Session_type1{sess}).(Mouse_names{mouse}) = OutPutData.(Session_type1{sess}).pfc_low.max_freq(mouse,5);
        %end
        HPC_Spec_SequentialREM.(Session_type1{sess}).(Mouse_names{mouse}) = nanmean(Data(Restrict(HPC_Spec.(Session_type1{sess}).(Mouse_names{mouse}) , Sequential_REM_Epoch.(Session_type1{sess}).(Mouse_names{mouse}))));
        OB_Spec_SequentialREM.(Session_type1{sess}).(Mouse_names{mouse}) = nanmean(Data(Restrict(OB_Spec.(Session_type1{sess}).(Mouse_names{mouse}) , Sequential_REM_Epoch.(Session_type1{sess}).(Mouse_names{mouse}))));
        PFC_Spec_SequentialREM.(Session_type1{sess}).(Mouse_names{mouse}) = nanmean(Data(Restrict(PFC_Spec.(Session_type1{sess}).(Mouse_names{mouse}) , Sequential_REM_Epoch.(Session_type1{sess}).(Mouse_names{mouse}))));
        
        HPC_Spec_SingleREM.(Session_type1{sess}).(Mouse_names{mouse}) = nanmean(Data(Restrict(HPC_Spec.(Session_type1{sess}).(Mouse_names{mouse}) , Single_REM_Epoch.(Session_type1{sess}).(Mouse_names{mouse}))));
        OB_Spec_SingleREM.(Session_type1{sess}).(Mouse_names{mouse}) = nanmean(Data(Restrict(OB_Spec.(Session_type1{sess}).(Mouse_names{mouse}) , Single_REM_Epoch.(Session_type1{sess}).(Mouse_names{mouse}))));
        PFC_Spec_SingleREM.(Session_type1{sess}).(Mouse_names{mouse}) = nanmean(Data(Restrict(PFC_Spec.(Session_type1{sess}).(Mouse_names{mouse}) , Single_REM_Epoch.(Session_type1{sess}).(Mouse_names{mouse}))));
        
    end
end
    for sess=1:length(Session_type2)
        try
        HPC_Spec_Fz.(Session_type2{sess}).(Mouse_names{mouse}) = OutPutData.(Session_type2{sess}).hpc_low.mean(mouse,3,:);
        OB_Spec_Fz.(Session_type2{sess}).(Mouse_names{mouse}) = OutPutData.(Session_type2{sess}).ob_low.mean(mouse,3,:);
        PFC_Spec_Fz.(Session_type2{sess}).(Mouse_names{mouse}) = OutPutData.(Session_type2{sess}).pfc_low.mean(mouse,3,:);
       
        HPC_Max_Fz.(Session_type2{sess}).(Mouse_names{mouse}) = OutPutData.(Session_type2{sess}).hpc_low.power(mouse,3);
        OB_Max_Fz.(Session_type2{sess}).(Mouse_names{mouse}) = OutPutData.(Session_type2{sess}).ob_low.power(mouse,3);
        PFC_Max_Fz.(Session_type2{sess}).(Mouse_names{mouse}) = OutPutData.(Session_type2{sess}).pfc_low.power(mouse,3);
       
        HPC_Freq_Fz.(Session_type2{sess}).(Mouse_names{mouse}) = OutPutData.(Session_type2{sess}).hpc_low.max_freq(mouse,3);
        OB_Freq_Fz.(Session_type2{sess}).(Mouse_names{mouse}) = OutPutData.(Session_type2{sess}).ob_low.max_freq(mouse,3);
        PFC_Freq_Fz.(Session_type2{sess}).(Mouse_names{mouse}) = OutPutData.(Session_type2{sess}).pfc_low.max_freq(mouse,3);
        end
    end
end

for group=1%:length(Drug_Group)
    
    Drugs_Groups_UMaze_BM
    
    for mouse=1:length(Mouse)
        Mouse_names{mouse}=['M' num2str(Mouse(mouse))];
        for sess=1:length(Session_type1)
            %try
            HPC_Spec_REM.(Drug_Group{group}).(Session_type1{sess})(mouse,:) = HPC_Spec_REM.(Session_type1{sess}).(Mouse_names{mouse});
            OB_Spec_REM.(Drug_Group{group}).(Session_type1{sess})(mouse,:) = OB_Spec_REM.(Session_type1{sess}).(Mouse_names{mouse});
            PFC_Spec_REM.(Drug_Group{group}).(Session_type1{sess})(mouse,:) = PFC_Spec_REM.(Session_type1{sess}).(Mouse_names{mouse});
            
            HPC_Max_REM.(Drug_Group{group}).(Session_type1{sess})(mouse) = HPC_Max_REM.(Session_type1{sess}).(Mouse_names{mouse});
            OB_Max_REM.(Drug_Group{group}).(Session_type1{sess})(mouse) = OB_Max_REM.(Session_type1{sess}).(Mouse_names{mouse});
            PFC_Max_REM.(Drug_Group{group}).(Session_type1{sess})(mouse) = PFC_Max_REM.(Session_type1{sess}).(Mouse_names{mouse});
            
            HPC_Freq_REM.(Drug_Group{group}).(Session_type1{sess})(mouse) = HPC_Freq_REM.(Session_type1{sess}).(Mouse_names{mouse});
            OB_Freq_REM.(Drug_Group{group}).(Session_type1{sess})(mouse) = OB_Freq_REM.(Session_type1{sess}).(Mouse_names{mouse});
            PFC_Freq_REM.(Drug_Group{group}).(Session_type1{sess})(mouse) = PFC_Freq_REM.(Session_type1{sess}).(Mouse_names{mouse});
            %end
            HPC_Spec_SequentialREM.(Drug_Group{group}).(Session_type1{sess})(mouse,:) = HPC_Spec_SequentialREM.(Session_type1{sess}).(Mouse_names{mouse});
            OB_Spec_SequentialREM.(Drug_Group{group}).(Session_type1{sess})(mouse,:) = OB_Spec_SequentialREM.(Session_type1{sess}).(Mouse_names{mouse});
            PFC_Spec_SequentialREM.(Drug_Group{group}).(Session_type1{sess})(mouse,:) = PFC_Spec_SequentialREM.(Session_type1{sess}).(Mouse_names{mouse});
            
            HPC_Spec_SingleREM.(Drug_Group{group}).(Session_type1{sess})(mouse,:) = HPC_Spec_SingleREM.(Session_type1{sess}).(Mouse_names{mouse});
            OB_Spec_SingleREM.(Drug_Group{group}).(Session_type1{sess})(mouse,:) = OB_Spec_SingleREM.(Session_type1{sess}).(Mouse_names{mouse});
            PFC_Spec_SingleREM.(Drug_Group{group}).(Session_type1{sess})(mouse,:) = PFC_Spec_SingleREM.(Session_type1{sess}).(Mouse_names{mouse});
        end
end
        for sess=1:length(Session_type2)
            try
                HPC_Spec_Fz.(Drug_Group{group}).(Session_type2{sess})(mouse,:) = HPC_Spec_Fz.(Session_type2{sess}).(Mouse_names{mouse});
                OB_Spec_Fz.(Drug_Group{group}).(Session_type2{sess})(mouse,:) = OB_Spec_Fz.(Session_type2{sess}).(Mouse_names{mouse});
                PFC_Spec_Fz.(Drug_Group{group}).(Session_type2{sess})(mouse,:) = PFC_Spec_Fz.(Session_type2{sess}).(Mouse_names{mouse});
                
                HPC_Max_Fz.(Drug_Group{group}).(Session_type2{sess})(mouse,:) = HPC_Max_Fz.(Session_type2{sess}).(Mouse_names{mouse});
                OB_Max_Fz.(Drug_Group{group}).(Session_type2{sess})(mouse,:) = OB_Max_Fz.(Session_type2{sess}).(Mouse_names{mouse});
                PFC_Max_Fz.(Drug_Group{group}).(Session_type2{sess})(mouse,:) = PFC_Max_Fz.(Session_type2{sess}).(Mouse_names{mouse});
                
                HPC_Freq_Fz.(Drug_Group{group}).(Session_type2{sess})(mouse,:) = HPC_Freq_Fz.(Session_type2{sess}).(Mouse_names{mouse});
                OB_Freq_Fz.(Drug_Group{group}).(Session_type2{sess})(mouse,:) = OB_Freq_Fz.(Session_type2{sess}).(Mouse_names{mouse});
                PFC_Freq_Fz.(Drug_Group{group}).(Session_type2{sess})(mouse,:) = PFC_Freq_Fz.(Session_type2{sess}).(Mouse_names{mouse});
            end
        end
    end
end

%% Figures
% Basic 
figure
subplot(131)
clear DATA; DATA = HPC_Spec_REM.(Drug_Group{group}).sleep_pre./HPC_Max_REM.Saline.sleep_pre';
Conf_Inter=nanstd(DATA)/sqrt(size(DATA,1));
clear Mean_All_Sp; Mean_All_Sp=nanmean(DATA);
shadedErrorBar(Spectro{3} , Mean_All_Sp , Conf_Inter,'-b',1); hold on;
    
clear DATA; DATA = HPC_Spec_Fz.(Drug_Group{group}).Cond./HPC_Max_REM.Saline.sleep_pre';
Conf_Inter=nanstd(DATA)/sqrt(size(DATA,1));
clear Mean_All_Sp; Mean_All_Sp=nanmean(DATA);
shadedErrorBar(Spectro{3} , Mean_All_Sp , Conf_Inter,'-k',1); hold on;
   
clear DATA; DATA = HPC_Spec_REM.(Drug_Group{group}).sleep_post./HPC_Max_REM.Saline.sleep_pre';
Conf_Inter=nanstd(DATA)/sqrt(size(DATA,1));
clear Mean_All_Sp; Mean_All_Sp=nanmean(DATA);
shadedErrorBar(Spectro{3} , Mean_All_Sp , Conf_Inter,'-r',1); hold on;
   
title('HPC'); xlim([0 12]); makepretty
f=get(gca,'Children'); a=legend([f(9),f(5),f(1)],'Sleep Pre','Freezing','Sleep Post');
xlabel('Frequency (Hz)'); ylabel('Power (a.u.)')


subplot(132)
clear DATA; DATA = OB_Spec_REM.(Drug_Group{group}).sleep_pre./OB_Max_REM.Saline.sleep_pre';
Conf_Inter=nanstd(DATA)/sqrt(size(DATA,1));
clear Mean_All_Sp; Mean_All_Sp=nanmean(DATA);
shadedErrorBar(Spectro{3} , Mean_All_Sp , Conf_Inter,'-b',1); hold on;
    
clear DATA; DATA = OB_Spec_Fz.(Drug_Group{group}).Cond./OB_Max_REM.Saline.sleep_pre';
Conf_Inter=nanstd(DATA)/sqrt(size(DATA,1));
clear Mean_All_Sp; Mean_All_Sp=nanmean(DATA);
shadedErrorBar(Spectro{3} , Mean_All_Sp , Conf_Inter,'-k',1); hold on;
   
clear DATA; DATA = OB_Spec_REM.(Drug_Group{group}).sleep_post./OB_Max_REM.Saline.sleep_pre';
Conf_Inter=nanstd(DATA)/sqrt(size(DATA,1));
clear Mean_All_Sp; Mean_All_Sp=nanmean(DATA);
shadedErrorBar(Spectro{3} , Mean_All_Sp , Conf_Inter,'-r',1); hold on;
   
title('OB'); xlim([0 12]); ylim([0 1.5]); makepretty
xlabel('Frequency (Hz)');


subplot(133)
[a,b] = max(PFC_Spec_REM.(Drug_Group{group}).sleep_pre(:,70:118)');
clear DATA; DATA = PFC_Spec_REM.(Drug_Group{group}).sleep_pre./a';
Conf_Inter=nanstd(DATA)/sqrt(size(DATA,1));
clear Mean_All_Sp; Mean_All_Sp=nanmean(DATA);
shadedErrorBar(Spectro{3} , Mean_All_Sp , Conf_Inter,'-b',1); hold on;
    
clear DATA; DATA = PFC_Spec_Fz.(Drug_Group{group}).Cond./a';
Conf_Inter=nanstd(DATA)/sqrt(size(DATA,1));
clear Mean_All_Sp; Mean_All_Sp=nanmean(DATA);
shadedErrorBar(Spectro{3} , Mean_All_Sp , Conf_Inter,'-k',1); hold on;
   
clear DATA; DATA = PFC_Spec_REM.(Drug_Group{group}).sleep_post./a';
Conf_Inter=nanstd(DATA)/sqrt(size(DATA,1));
clear Mean_All_Sp; Mean_All_Sp=nanmean(DATA);
shadedErrorBar(Spectro{3} , Mean_All_Sp , Conf_Inter,'-r',1); hold on;
   
title('PFC'); xlim([0 12]); ylim([0 3.5]); makepretty
xlabel('Frequency (Hz)');

a=suptitle('Mean spectrum analysis, REM Total and Freezing, Saline, n=7'); a.FontSize=20;



Cols = {[1 0 0],[0 1 0]};
X = [1:2];
Legends ={'Sleep Pre','Sleep Post'};
NoLegends ={'' '' ''};

figure
subplot(131)
MakeSpreadAndBoxPlot2_SB({HPC_Max_REM.Saline.sleep_pre HPC_Max_REM.Saline.sleep_post},Cols,X,Legends,'showpoints',0);
title('HPC'); ylabel('Power (a.u.)')
subplot(132)
MakeSpreadAndBoxPlot2_SB({OB_Max_REM.Saline.sleep_pre OB_Max_REM.Saline.sleep_post},Cols,X,Legends,'showpoints',0);
title('OB')
subplot(133)
MakeSpreadAndBoxPlot2_SB({PFC_Max_REM.Saline.sleep_pre PFC_Max_REM.Saline.sleep_post},Cols,X,Legends,'showpoints',0);
title('PFC')

OB_Freq_REM.Saline.sleep_post([4 6 7]) = [NaN 1.45 2.899];
OB_Freq_REM.Saline.sleep_pre([4]) = [NaN];
figure
subplot(131)
MakeSpreadAndBoxPlot2_SB({HPC_Freq_REM.Saline.sleep_pre(HPC_Freq_REM.Saline.sleep_pre>6) HPC_Freq_REM.Saline.sleep_post(HPC_Freq_REM.Saline.sleep_pre>6)},Cols,X,Legends,'showpoints',0);
title('HPC'); ylabel('Frequency (Hz)')
subplot(132)
MakeSpreadAndBoxPlot2_SB({OB_Freq_REM.Saline.sleep_pre OB_Freq_REM.Saline.sleep_post},Cols,X,Legends,'showpoints',0);
title('OB')
subplot(133)
MakeSpreadAndBoxPlot2_SB({PFC_Freq_REM.Saline.sleep_pre PFC_Freq_REM.Saline.sleep_post},Cols,X,Legends,'showpoints',0);
title('PFC')





% Mean spectrum sequential/single REM
figure
subplot(231)
[a,b] = max(HPC_Spec_REM.(Drug_Group{group}).sleep_pre(:,70:118)');

clear DATA; DATA = HPC_Spec_SequentialREM.(Drug_Group{group}).sleep_pre./a';
Conf_Inter=nanstd(DATA)/sqrt(size(DATA,1));
clear Mean_All_Sp; Mean_All_Sp=nanmean(DATA);
shadedErrorBar(Spectro{3} , Mean_All_Sp , Conf_Inter,'-r',1); hold on;

clear DATA; DATA = HPC_Spec_SingleREM.(Drug_Group{group}).sleep_pre./a';
Conf_Inter=nanstd(DATA)/sqrt(size(DATA,1));
clear Mean_All_Sp; Mean_All_Sp=nanmean(DATA);
shadedErrorBar(Spectro{3} , Mean_All_Sp , Conf_Inter,'-g',1); hold on;

title('HPC'); xlim([0 12]); makepretty
f=get(gca,'Children'); a=legend([f(5),f(1)],'Sequential','Single');
ylabel('Puissance (a.u.)')


subplot(234)
[a,b] = max(HPC_Spec_REM.(Drug_Group{group}).sleep_post(:,70:118)');

clear DATA; DATA = HPC_Spec_SequentialREM.(Drug_Group{group}).sleep_post./a';
Conf_Inter=nanstd(DATA)/sqrt(size(DATA,1));
clear Mean_All_Sp; Mean_All_Sp=nanmean(DATA);
shadedErrorBar(Spectro{3} , Mean_All_Sp , Conf_Inter,'-r',1); hold on;

clear DATA; DATA = HPC_Spec_SingleREM.(Drug_Group{group}).sleep_post./a';
Conf_Inter=nanstd(DATA)/sqrt(size(DATA,1));
clear Mean_All_Sp; Mean_All_Sp=nanmean(DATA);
shadedErrorBar(Spectro{3} , Mean_All_Sp , Conf_Inter,'-g',1); hold on;

title('HPC'); xlim([0 12]); makepretty
ylabel('Puissance (a.u.)')
xlabel('Fréquence (Hz)'); 

% OB
subplot(232)
[a,b] = max(OB_Spec_REM.(Drug_Group{group}).sleep_pre(:,13:91)');

clear DATA; DATA = OB_Spec_SequentialREM.(Drug_Group{group}).sleep_pre./a';
Conf_Inter=nanstd(DATA)/sqrt(size(DATA,1));
clear Mean_All_Sp; Mean_All_Sp=nanmean(DATA);
shadedErrorBar(Spectro{3} , Mean_All_Sp , Conf_Inter,'-r',1); hold on;

clear DATA; DATA = OB_Spec_SingleREM.(Drug_Group{group}).sleep_pre./a';
Conf_Inter=nanstd(DATA)/sqrt(size(DATA,1));
clear Mean_All_Sp; Mean_All_Sp=nanmean(DATA);
shadedErrorBar(Spectro{3} , Mean_All_Sp , Conf_Inter,'-g',1); hold on;

title('OB'); xlim([0 12]); makepretty


subplot(235)
[a,b] = max(OB_Spec_REM.(Drug_Group{group}).sleep_post(:,13:91)');

clear DATA; DATA = OB_Spec_SequentialREM.(Drug_Group{group}).sleep_post./a';
Conf_Inter=nanstd(DATA)/sqrt(size(DATA,1));
clear Mean_All_Sp; Mean_All_Sp=nanmean(DATA);
shadedErrorBar(Spectro{3} , Mean_All_Sp , Conf_Inter,'-r',1); hold on;

clear DATA; DATA = OB_Spec_SingleREM.(Drug_Group{group}).sleep_post./a';
Conf_Inter=nanstd(DATA)/sqrt(size(DATA,1));
clear Mean_All_Sp; Mean_All_Sp=nanmean(DATA);
shadedErrorBar(Spectro{3} , Mean_All_Sp , Conf_Inter,'-g',1); hold on;
title('OB'); xlim([0 12]); makepretty
xlim([0 12]); makepretty
xlabel('Fréquence (Hz)'); 

% PFC
subplot(233)
[a,b] = max(PFC_Spec_REM.(Drug_Group{group}).sleep_pre(:,70:118)');

clear DATA; DATA = PFC_Spec_SequentialREM.(Drug_Group{group}).sleep_pre./a';
Conf_Inter=nanstd(DATA)/sqrt(size(DATA,1));
clear Mean_All_Sp; Mean_All_Sp=nanmean(DATA);
shadedErrorBar(Spectro{3} , Mean_All_Sp , Conf_Inter,'-r',1); hold on;

clear DATA; DATA = PFC_Spec_SingleREM.(Drug_Group{group}).sleep_pre./a';
Conf_Inter=nanstd(DATA)/sqrt(size(DATA,1));
clear Mean_All_Sp; Mean_All_Sp=nanmean(DATA);
shadedErrorBar(Spectro{3} , Mean_All_Sp , Conf_Inter,'-g',1); hold on;

title('PFC'); xlim([0 12]); makepretty


subplot(236)
[a,b] = max(PFC_Spec_REM.(Drug_Group{group}).sleep_post(:,70:118)');

clear DATA; DATA = PFC_Spec_SequentialREM.(Drug_Group{group}).sleep_post./a';
Conf_Inter=nanstd(DATA)/sqrt(size(DATA,1));
clear Mean_All_Sp; Mean_All_Sp=nanmean(DATA);
shadedErrorBar(Spectro{3} , Mean_All_Sp , Conf_Inter,'-r',1); hold on;

clear DATA; DATA = PFC_Spec_SingleREM.(Drug_Group{group}).sleep_post./a';
Conf_Inter=nanstd(DATA)/sqrt(size(DATA,1));
clear Mean_All_Sp; Mean_All_Sp=nanmean(DATA);
shadedErrorBar(Spectro{3} , Mean_All_Sp , Conf_Inter,'-g',1); hold on;

title('PFC'); xlim([0 12]); makepretty
xlabel('Fréquence (Hz)'); 

% Significative graph
[a,b] = max(OB_Spec_REM.(Drug_Group{group}).sleep_pre(:,13:91)');
Data1 = OB_Spec_SequentialREM.(Drug_Group{group}).sleep_pre./a';
Data2 = OB_Spec_SingleREM.(Drug_Group{group}).sleep_pre./a';
[a,b] = max(PFC_Spec_REM.(Drug_Group{group}).sleep_post(:,70:118)');
Data3 = PFC_Spec_SequentialREM.(Drug_Group{group}).sleep_post./a';
Data4 = PFC_Spec_SingleREM.(Drug_Group{group}).sleep_post./a';

[a,b] = max(PFC_Spec_REM.(Drug_Group{group}).sleep_pre(:,70:118)');
Data5 = PFC_Spec_SequentialREM.(Drug_Group{group}).sleep_pre./a';
Data6 = PFC_Spec_SingleREM.(Drug_Group{group}).sleep_pre./a';


[h,p3]=ttest(Data1,Data2);
figure, subplot(3,1,1:2), hold on, plot(Spectro{3},mean(Data1),'r'), plot(Spectro{3},mean(Data2),'g'),subplot(3,1,3), plot(Spectro{3},p3,'k.-')
hline(0.05,'--r')
[h,p3]=ttest(Data3,Data4);
figure, subplot(3,1,1:2), hold on, plot(Spectro{3},mean(Data3),'r'), plot(Spectro{3},mean(Data4),'g'),subplot(3,1,3), plot(Spectro{3},p3,'k.-')
hline(0.05,'--r')
[h,p3]=ttest(Data5,Data6);
figure, subplot(3,1,1:2), hold on, plot(Spectro{3},mean(Data5),'r'), plot(Spectro{3},mean(Data6),'g'),subplot(3,1,3), plot(Spectro{3},p3,'k.-')
hline(0.05,'--r')



% Stats on single/sequential REM
HPC_Spec_REM.Saline.sleep_pre(4,:)=NaN;
HPC_Spec_REM.Saline.sleep_post(4,:)=NaN;

[HPC_Max_REM.Saline.sleep_pre , HPC_Freq_REM.Saline.sleep_pre] = max(HPC_Spec_REM.Saline.sleep_pre(:,70:118)');
[OB_Max_REM.Saline.sleep_pre , OB_Freq_REM.Saline.sleep_pre] = max(OB_Spec_REM.Saline.sleep_pre(:,13:91)');
[PFC_Max_REM.Saline.sleep_pre , PFC_Freq_REM.Saline.sleep_pre] = max(PFC_Spec_REM.Saline.sleep_pre(:,70:118)');

[HPC_Max_REM.Saline.sleep_post , HPC_Freq_REM.Saline.sleep_post] = max(HPC_Spec_REM.Saline.sleep_post(:,70:118)');
[OB_Max_REM.Saline.sleep_post , OB_Freq_REM.Saline.sleep_post] = max(OB_Spec_REM.Saline.sleep_post(:,13:91)');
[PFC_Max_REM.Saline.sleep_post , PFC_Freq_REM.Saline.sleep_post] = max(PFC_Spec_REM.Saline.sleep_post(:,70:118)');


figure
subplot(131)
MakeSpreadAndBoxPlot2_SB({HPC_Max_REM.Saline.sleep_pre HPC_Max_REM.Saline.sleep_post},Cols,X,Legends,'showpoints',0);
title('HPC'); ylabel('Power (a.u.)')
subplot(132)
MakeSpreadAndBoxPlot2_SB({OB_Max_REM.Saline.sleep_pre OB_Max_REM.Saline.sleep_post},Cols,X,Legends,'showpoints',0);
title('OB')
subplot(133)
MakeSpreadAndBoxPlot2_SB({PFC_Max_REM.Saline.sleep_pre PFC_Max_REM.Saline.sleep_post},Cols,X,Legends,'showpoints',0);
title('PFC')

OB_Freq_REM.Saline.sleep_post([4 6 7]) = [NaN 1.45 2.899];
OB_Freq_REM.Saline.sleep_pre([4]) = [NaN];
figure
subplot(131)
MakeSpreadAndBoxPlot2_SB({HPC_Freq_REM.Saline.sleep_pre(HPC_Freq_REM.Saline.sleep_pre>6) HPC_Freq_REM.Saline.sleep_post(HPC_Freq_REM.Saline.sleep_pre>6)},Cols,X,Legends,'showpoints',0);
title('HPC'); ylabel('Frequency (Hz)')
subplot(132)
MakeSpreadAndBoxPlot2_SB({OB_Freq_REM.Saline.sleep_pre OB_Freq_REM.Saline.sleep_post},Cols,X,Legends,'showpoints',0);
title('OB')
subplot(133)
MakeSpreadAndBoxPlot2_SB({PFC_Freq_REM.Saline.sleep_pre PFC_Freq_REM.Saline.sleep_post},Cols,X,Legends,'showpoints',0);
title('PFC')





HPC_Spec_SequentialREM.Saline.sleep_pre(4,:)=NaN;
HPC_Spec_SequentialREM.Saline.sleep_post(4,:)=NaN;


[HPC_Max_SequentialREM.Saline.sleep_pre , HPC_Freq_SequentialREM.Saline.sleep_pre] = max(HPC_Spec_SequentialREM.Saline.sleep_pre(:,70:118)');
[OB_Max_SequentialREM.Saline.sleep_pre , OB_Freq_SequentialREM.Saline.sleep_pre] = max(OB_Spec_SequentialREM.Saline.sleep_pre(:,13:91)');
[PFC_Max_SequentialREM.Saline.sleep_pre , PFC_Freq_SequentialREM.Saline.sleep_pre] = max(PFC_Spec_SequentialREM.Saline.sleep_pre(:,70:118)');

[HPC_Max_SequentialREM.Saline.sleep_post , HPC_Freq_SequentialREM.Saline.sleep_post] = max(HPC_Spec_SequentialREM.Saline.sleep_post(:,70:118)');
[OB_Max_SequentialREM.Saline.sleep_post , OB_Freq_SequentialREM.Saline.sleep_post] = max(OB_Spec_SequentialREM.Saline.sleep_post(:,13:91)');
[PFC_Max_SequentialREM.Saline.sleep_post , PFC_Freq_SequentialREM.Saline.sleep_post] = max(PFC_Spec_SequentialREM.Saline.sleep_post(:,70:118)');



figure
subplot(131)
MakeSpreadAndBoxPlot2_SB({HPC_Max_SequentialREM.Saline.sleep_pre HPC_Max_SequentialREM.Saline.sleep_post},Cols,X,Legends,'showpoints',0);
title('HPC'); ylabel('Power (a.u.)')
subplot(132)
MakeSpreadAndBoxPlot2_SB({OB_Max_SequentialREM.Saline.sleep_pre OB_Max_SequentialREM.Saline.sleep_post},Cols,X,Legends,'showpoints',0);
title('OB')
subplot(133)
MakeSpreadAndBoxPlot2_SB({PFC_Max_SequentialREM.Saline.sleep_pre PFC_Max_SequentialREM.Saline.sleep_post},Cols,X,Legends,'showpoints',0);
title('PFC')

OB_Freq_SequentialREM.Saline.sleep_post([4 6 7]) = [NaN 1.45 2.899];
OB_Freq_SequentialREM.Saline.sleep_pre([4]) = [NaN];
figure
subplot(131)
MakeSpreadAndBoxPlot2_SB({HPC_Freq_SequentialREM.Saline.sleep_pre(HPC_Freq_SequentialREM.Saline.sleep_pre>6) HPC_Freq_SequentialREM.Saline.sleep_post(HPC_Freq_SequentialREM.Saline.sleep_pre>6)},Cols,X,Legends,'showpoints',0);
title('HPC'); ylabel('Frequency (Hz)')
subplot(132)
MakeSpreadAndBoxPlot2_SB({OB_Freq_SequentialREM.Saline.sleep_pre OB_Freq_SequentialREM.Saline.sleep_post},Cols,X,Legends,'showpoints',0);
title('OB')
subplot(133)
MakeSpreadAndBoxPlot2_SB({PFC_Freq_SequentialREM.Saline.sleep_pre PFC_Freq_SequentialREM.Saline.sleep_post},Cols,X,Legends,'showpoints',0);
title('PFC')



HPC_Spec_SingleREM.Saline.sleep_pre(4,:)=NaN;
HPC_Spec_SingleREM.Saline.sleep_post(4,:)=NaN;


[HPC_Max_SingleREM.Saline.sleep_pre , HPC_Freq_SingleREM.Saline.sleep_pre] = max(HPC_Spec_SingleREM.Saline.sleep_pre(:,70:118)');
[OB_Max_SingleREM.Saline.sleep_pre , OB_Freq_SingleREM.Saline.sleep_pre] = max(OB_Spec_SingleREM.Saline.sleep_pre(:,13:91)');
[PFC_Max_SingleREM.Saline.sleep_pre , PFC_Freq_SingleREM.Saline.sleep_pre] = max(PFC_Spec_SingleREM.Saline.sleep_pre(:,70:118)');

[HPC_Max_SingleREM.Saline.sleep_post , HPC_Freq_SingleREM.Saline.sleep_post] = max(HPC_Spec_SingleREM.Saline.sleep_post(:,70:118)');
[OB_Max_SingleREM.Saline.sleep_post , OB_Freq_SingleREM.Saline.sleep_post] = max(OB_Spec_SingleREM.Saline.sleep_post(:,13:91)');
[PFC_Max_SingleREM.Saline.sleep_post , PFC_Freq_SingleREM.Saline.sleep_post] = max(PFC_Spec_SingleREM.Saline.sleep_post(:,70:118)');



figure
subplot(231)
MakeSpreadAndBoxPlot2_SB({HPC_Max_SingleREM.Saline.sleep_pre HPC_Max_SingleREM.Saline.sleep_post},Cols,X,Legends,'showpoints',0);
title('HPC'); ylabel('Power (a.u.)')
subplot(132)
MakeSpreadAndBoxPlot2_SB({OB_Max_SingleREM.Saline.sleep_pre OB_Max_SingleREM.Saline.sleep_post},Cols,X,Legends,'showpoints',0);
title('OB')
subplot(133)
MakeSpreadAndBoxPlot2_SB({PFC_Max_SingleREM.Saline.sleep_pre PFC_Max_SingleREM.Saline.sleep_post},Cols,X,Legends,'showpoints',0);
title('PFC')

OB_Freq_SingleREM.Saline.sleep_post([4 6 7]) = [NaN 1.45 2.899];
OB_Freq_SingleREM.Saline.sleep_pre([4]) = [NaN];
figure
subplot(131)
MakeSpreadAndBoxPlot2_SB({HPC_Freq_SingleREM.Saline.sleep_pre(HPC_Freq_SingleREM.Saline.sleep_pre>6) HPC_Freq_SingleREM.Saline.sleep_post(HPC_Freq_SingleREM.Saline.sleep_pre>6)},Cols,X,Legends,'showpoints',0);
title('HPC'); ylabel('Frequency (Hz)')
subplot(132)
MakeSpreadAndBoxPlot2_SB({OB_Freq_SingleREM.Saline.sleep_pre OB_Freq_SingleREM.Saline.sleep_post},Cols,X,Legends,'showpoints',0);
title('OB')
subplot(133)
MakeSpreadAndBoxPlot2_SB({PFC_Freq_SingleREM.Saline.sleep_pre PFC_Freq_SingleREM.Saline.sleep_post},Cols,X,Legends,'showpoints',0);
title('PFC')



u=text(-5,3,'Sleep Pre'); set(u,'FontSize',15,'FontWeight','bold','Rotation',90)


