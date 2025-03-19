
function [OutPutData , Epoch , NameEpoch , OutPutTSD] = GetRightSessions_temp(List_Type,Mouse_List,Session_Type,varargin)

% [OutPutData , Epoch , NameEpoch , OutPutTSD]=MeanValuesPhysiologicalParameters_BM(...
% List_Type , Mouse , Session_Type , varargin)

% INPUT VARIABLES:
% List_Type: what type of mice do you want to study ('all_saline','drugs','head_restraint')
% Mouse: vector with mice numbers (ex: Mouse=[688,777,779,893])
% SessionType : strain vector with session name ('fear','cond',...)
% variable : strain vector with wanted variable (below)

% OUTPUT VARIABLES:
% OutPutData: mean values for differents epoch
% Epoch1 : intervalsets defined for session
% NameEpoch : NameEpoch

% Variables that you can choose as an input:
% - accelero
% - speed
% - alignedposition
% - lfp ('lfp',num_chan)
% - linearposition
% - masktemperature
% - tailtemperature
% - emg_pect
% - emg_neck
% - emg_any
% - respi_freq_BM
% - heartrate
% - heartratevar
% - instfreq
% - sleep_ripples
% - wake_ripples
% - respi_meanwaveform
% - ripples_meanwaveform
% - h_vhigh_extended
% - ob_high_on_respi_phase_pref
% - hpc_vhigh_on_respi_phase_pref
% - hpc_vhigh_on_theta_phase_pref
% - spindles
% - delta
% - ob_low
% - ob_high
% - hpc_low
% - pfc_low
% - hpc vhigh
% - respivar
% - ob_pfc_coherence
% - hpc_pfc_coherence'
%  - added by Sb :'respi_freq_BM_sametps','heartrate_sametps','heartratevar_sametps','ob_high_power_sametps','ripples_density_sametps','ob_high_freq_sametps
% - hpc_theta_freq, hpc_theta_power
% - pfc_delta_power
% - ob_gamma_power
% - ob_gamma_freq

% Calculated on the following epoch:
% - For FEAR experiments :
% 1) Total Epoch
% 2) After stim epoch
% 3) Freezing
% 4) Active
% 5) Shock freezing
% 6) Safe freezing
% 7) Shock active
% 8) Safe active

% - For SLEEP experiments :
% NameEpoch{1}='Total';
% NameEpoch{2}='Wake';
% NameEpoch{3}='Sleep';
% NameEpoch{4}='NREM';
% NameEpoch{5}='REM';
% NameEpoch{6}='N1';
% NameEpoch{7}='N2';
% NameEpoch{8}='N3';


if convertCharsToStrings(List_Type) == 'head_restraint'
    HeadRestraintSess = HeadRestraintSess_BM2;
elseif convertCharsToStrings(List_Type) == 'all_saline'
    GetAllSalineSessions_BM
elseif convertCharsToStrings(List_Type) == 'drugs'
    GetEmbReactMiceFolderList_BM
elseif convertCharsToStrings(List_Type) == 'sound_test'
    SoundCondSess = SoundCondSess2;
%     SoundCondSess = SoundCondSess_Maze;
elseif convertCharsToStrings(List_Type) == 'fear_ctxt'
    FearContextSess = FearContextSess2;
end


Mouse = Mouse_List;

clear Mouse_names
for mouse=1:length(Mouse)
    Mouse_names{mouse}=['M' num2str(Mouse(mouse))];
    try % are you sure ?
        UMazeSleepSess.(Mouse_names{mouse}) = Sess.(Mouse_names{mouse})(find(not(cellfun(@isempty,strfind(Sess.(Mouse_names{mouse}) ,'Sleep')))));
        SleepPreSess.(Mouse_names{mouse}) = UMazeSleepSess.(Mouse_names{mouse})(1);
        if length(UMazeSleepSess.(Mouse_names{mouse}))==3
            SleepPreSess.(Mouse_names{mouse}) = UMazeSleepSess.(Mouse_names{mouse})(1);
            SleepPostPreSess.(Mouse_names{mouse}) = UMazeSleepSess.(Mouse_names{mouse})(2);
            SleepPostSess.(Mouse_names{mouse}) = UMazeSleepSess.(Mouse_names{mouse})(3);
        else
            try
                SleepPreSess.(Mouse_names{mouse}) = UMazeSleepSess.(Mouse_names{mouse})(1);
                SleepPostSess.(Mouse_names{mouse}) = UMazeSleepSess.(Mouse_names{mouse})(2);
            catch % for 11203... grrr
                SleepPreSess.(Mouse_names{mouse}) = UMazeSleepSess.(Mouse_names{mouse})(1);
                SleepPostSess.(Mouse_names{mouse}) = UMazeSleepSess.(Mouse_names{mouse})(1);
            end
        end
    end
end


% Generate folder lists
switch(lower(Session_Type))
    case 'fear' %|'slmz' | 'cond' | 'ext'
        fear=1; sleep=0; FolderList=FearSess;
    case 'cond'
        fear=1; sleep=0; FolderList=CondSess;
    case 'ext'
        fear=1; sleep=0; FolderList=ExtSess;
    case 'condpre'
        fear=1; sleep=0; FolderList=CondPreSess;
    case 'condpost'
        fear=1; sleep=0; FolderList=CondPostSess;
    case 'testpre'
        fear=1; sleep=0; FolderList=TestPreSess;
    case 'hab'
        fear=1; sleep=0; FolderList=HabSess;
    case 'testpost'
        fear=1; sleep=0; FolderList=TestPostSess;
    case 'firstextsess'
        fear=1; sleep=0; FolderList=FirstExtSess;
    case 'habituation'
        fear=1; sleep=0; FolderList=HabSess;
    case 'sleep_pre'
        fear=1; sleep=1; FolderList=SleepPreSess;
    case 'sleep_post'
        fear=1; sleep=1; FolderList=SleepPostSess;
    case 'slbs'
        fear=0; sleep=1; FolderList=BaselineSleepSess;
    case 'realtimesess1'
        fear=1; sleep=0; FolderList=RealTimeSess1;
    case 'realtimesess2'
        fear=1; sleep=0; FolderList=RealTimeSess2;
    case 'realtimesess3'
        fear=1; sleep=0; FolderList=RealTimeSess3;
    case 'realtimesess4'
        fear=1; sleep=0; FolderList=RealTimeSess4;
    case 'realtimesess5'
        fear=1; sleep=0; FolderList=RealTimeSess5;
    case 'realtimesess6'
        fear=1; sleep=0; FolderList=RealTimeSess6;
    case 'realtimesess7'
        fear=1; sleep=0; FolderList=RealTimeSess7;
    case 'head_restraint'
        fear=0; sleep=0; FolderList=HeadRestraintSess;
    case 'sound_test'
        fear=2; sleep=0; FolderList=SoundCondSess;
    case 'fear_ctxt'
        fear=3; sleep=0; FolderList=FearContextSess;
end


keyboard
mice = fieldnames(FolderList)
for ff = 1:length(mice)
    cd(FolderList.(mice{ff}){1})
    keyboard
end
clear TotalNoiseEpoch
load('SleepScoring_Accelero.mat', 'TotalNoiseEpoch')
save('StateEpochSB.mat','TotalNoiseEpoch')

end


%% RUN TO GET ALL THE GROUPS
%% Sleep analysis
% 
% clear all
% 
% % preliminary variables
% Drug_Group={'RipControl','RipInhib',};
% groupId = [7,8];
% Session_type={'sleep_pre','sleep_post'};
% States={'Sleep','Wake','NREM','REM'};
% MergeForLatencyCalculation = 1:20:200;
% 
% 
% 
% % generate data
% % Have to change inside the "MeanValuesPhysiologicalParameters_BM" code
% % sleepstate --> sleepstats_accelero
% for group=1:length(Drug_Group)
%     Mouse.(Drug_Group{group}) = Drugs_Groups_UMaze_BM(groupId(group));
%     for sess=1:length(Session_type)
%         disp((Drug_Group{group}))
%         disp(Session_type{sess})
%         [OutPutData.(Session_type{sess}).(Drug_Group{group}) , Epoch1.(Session_type{sess}).(Drug_Group{group}) , NameEpoch] =...
%             GetRightSessions_temp('all_saline', Mouse.(Drug_Group{group}) ,lower(Session_type{sess}),'ripples','heartrate','heartratevar','ob_low','hpc_low');
%     end
% end