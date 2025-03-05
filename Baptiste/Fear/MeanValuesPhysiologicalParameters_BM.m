
function [OutPutData , Epoch , NameEpoch , OutPutTSD] = MeanValuesPhysiologicalParameters_BM(List_Type,Mouse_List,Session_Type,varargin)

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
% - imdff
% - trackingnans
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
% - ripples_density
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
% - added by Sb :'respi_freq_BM_sametps','heartrate_sametps','heartratevar_sametps','ob_high_power_sametps','ripples_density_sametps','ob_high_freq_sametps
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
    GetEmbReactMiceFolderList_BM
elseif convertCharsToStrings(List_Type) == 'drugs'
    GetEmbReactMiceFolderList_BM
elseif convertCharsToStrings(List_Type) == 'sound_test'
    SoundCondSess = SoundCondSess2;
    %     SoundCondSess = SoundCondSess_Maze;
elseif convertCharsToStrings(List_Type) == 'sound_test_umze'
    SoundCondSess = SoundCondSess_Maze;
    
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
    case 'sound_test_umze'
        fear=1; sleep=0; FolderList=SoundCondSess;
        
    case 'fear_ctxt'
        fear=3; sleep=0; FolderList=FearContextSess;
end


cd('/media/nas4/ProjetEmbReact/Mouse688/20180209/ProjectEmbReact_M688_20180209_TestPre_PreDrug/TestPre3')
load('H_Low_Spectrum.mat'); range_Low=Spectro{3};
load('B_Middle_Spectrum.mat'); range_Middle=Spectro{3};
load('B_High_Spectrum.mat'); range_High=Spectro{3};
load('H_VHigh_Spectrum.mat'); range_VHigh=Spectro{3};


% calculating the differents epochs that you will use
if sleep==0
    if fear==0
        for mouse=1:length(Mouse)
            Mouse_names{mouse}=['M' num2str(Mouse(mouse))];
            
            Epoch{mouse,1}= intervalSet(0,max( Range( ConcatenateDataFromFolders_SB(FolderList.(Mouse_names{mouse}),'accelero'))));
            %             Epoch{mouse,2}=ConcatenateDataFromFolders_SB(FolderList.(Mouse_names{mouse}),'epoch','epochname','freezeepoch');
            %             Epoch{mouse,3}=Epoch{mouse,1} - Epoch{mouse,2};
            
            NameEpoch{1}='Total';
            %             NameEpoch{2}='Immobile';
            %             NameEpoch{3}='Moving';
        end
    elseif or(fear==2 , fear==3)
        for mouse=1:length(Mouse)
            Mouse_names{mouse}=['M' num2str(Mouse(mouse))];
            
            try
                Epoch{mouse,1}= intervalSet(0,max( Range( ConcatenateDataFromFolders_SB(FolderList.(Mouse_names{mouse}),'speed'))));
            catch
                Epoch{mouse,1}= intervalSet(0,max( Range( ConcatenateDataFromFolders_SB(FolderList.(Mouse_names{mouse}),'accelero'))));
            end
            try
                Epoch{mouse,2}=ConcatenateDataFromFolders_SB(FolderList.(Mouse_names{mouse}),'epoch','epochname','freezeepoch');
            catch
                Epoch{mouse,2}=ConcatenateDataFromFolders_SB(FolderList.(Mouse_names{mouse}),'epoch','epochname','freeze_epoch_camera');
            end
            Epoch{mouse,3}=Epoch{mouse,1} - Epoch{mouse,2};
            
            NameEpoch{1}='Total';
            NameEpoch{2}='Freezing';
            NameEpoch{3}='Active';
        end
    else
        for mouse=1:length(Mouse)
            if not(isempty(FolderList.(Mouse_names{mouse})))
                
                NoisyEpoch =ConcatenateDataFromFolders_SB(FolderList.(Mouse_names{mouse}),'Epoch','epochname','noiseepoch');
                try
                    Epoch{mouse,1}= intervalSet(0,max( Range( ConcatenateDataFromFolders_SB(FolderList.(Mouse_names{mouse}),'accelero')))) -NoisyEpoch;
                catch
                    try
                        Epoch{mouse,1}= ConcatenateDataFromFolders_SB(FolderList.(Mouse_names{mouse}),'epoch','epochname','tot_epoch') -NoisyEpoch;
                    catch
                        keyboard
                    end
                end
                Epoch{mouse,2}=ConcatenateDataFromFolders_SB(FolderList.(Mouse_names{mouse}),'epoch','epochname','afterstimepoch');
                try
                    Epoch{mouse,3}=ConcatenateDataFromFolders_SB(FolderList.(Mouse_names{mouse}),'epoch','epochname','freezeepoch');
                catch
                    Epoch{mouse,3} = ConcatenateDataFromFolders_SB(FolderList.(Mouse_names{mouse}) , 'epoch' , 'epochname' , 'all_fz_epoch');
                end
                %             Epoch{mouse,3}=ConcatenateDataFromFolders_SB(FolderList.(Mouse_names{mouse}),'epoch','epochname','freeze_epoch_camera');
                Epoch{mouse,4}=Epoch{mouse,1} - Epoch{mouse,3}; % Non freezing epochs
                ZoneEpoch.(Mouse_names{mouse}) = ConcatenateDataFromFolders_SB(FolderList.(Mouse_names{mouse}),'epoch','epochname','zoneepoch');
                
                %             % clean shock & safe epoch, put an option on it ? BM 24/09/2022
                ShockZoneEpoch.(Mouse_names{mouse})=ZoneEpoch.(Mouse_names{mouse}){1};
                SafeZoneEpoch.(Mouse_names{mouse})=or(ZoneEpoch.(Mouse_names{mouse}){2},ZoneEpoch.(Mouse_names{mouse}){5});
                %             SafeZoneEpoch.(Mouse_names{mouse})=or(ZoneEpoch.(Mouse_names{mouse}){2},or(ZoneEpoch.(Mouse_names{mouse}){5} , ZoneEpoch.(Mouse_names{mouse}){3}));
                
                Epoch{mouse,5}=and(Epoch{mouse,3} , ShockZoneEpoch.(Mouse_names{mouse}));
                Epoch{mouse,6}=and(Epoch{mouse,3} , SafeZoneEpoch.(Mouse_names{mouse}));
                Epoch{mouse,7}=and(Epoch{mouse,4} , ShockZoneEpoch.(Mouse_names{mouse}));
                Epoch{mouse,8}=and(Epoch{mouse,4} , SafeZoneEpoch.(Mouse_names{mouse}));
                disp(Mouse_names{mouse})
            end
        end
        NameEpoch{1}='Total';
        NameEpoch{2}='After_stim';
        NameEpoch{3}='Freezing';
        NameEpoch{4}='Active';
        NameEpoch{5}='Freezing_shock';
        NameEpoch{6}='Freezing_safe';
        NameEpoch{7}='Active_shock';
        NameEpoch{8}='Active_safe';
    end
    % elseif inj % sleep with drugs injection
    %     for mouse=1:length(Mouse)
    %         NoisyEpoch = ConcatenateDataFromFolders_SB(FolderList.(Mouse_names{mouse}),'Epoch','epochname','noiseepoch');
    %         Epoch{mouse,1}= intervalSet(0,max( Range( ConcatenateDataFromFolders_SB(FolderList.(Mouse_names{mouse}),'accelero')))) -NoisyEpoch;
    %         Epoch(mouse,[2 4 5])=ConcatenateDataFromFolders_SB(FolderList.(Mouse_names{mouse}),'epoch','epochname','sleepstates');
    %         Epoch{mouse,3}=or(Epoch{mouse,4},Epoch{mouse,5});
    %         try
    %             Epoch2=ConcatenateDataFromFolders_SB(FolderList.(Mouse_names{mouse}),'epoch','epochname','NREMsubstages');
    %         catch
    %             Epoch2{1} = intervalSet(0,0); Epoch2{2} = intervalSet(0,0); Epoch2{3} = intervalSet(0,0);
    %         end
    %         Epoch(mouse,6:8)=Epoch2(1:3);
    %     end
    %     NameEpoch{1}='Total';
    %     NameEpoch{2}='Wake';
    %     NameEpoch{3}='Sleep';
    %     NameEpoch{4}='NREM';
    %     NameEpoch{5}='REM';
    %     NameEpoch{6}='N1';
    %     NameEpoch{7}='N2';
    %     NameEpoch{8}='N3';
else
    for mouse=1:length(Mouse)
        try
            NoisyEpoch =ConcatenateDataFromFolders_SB(FolderList.(Mouse_names{mouse}),'Epoch','epochname','noiseepoch');
            Epoch{mouse,1}= intervalSet(0,ConcatenateDataFromFolders_SB(FolderList.(Mouse_names{mouse}) , 'timesessions')) -NoisyEpoch;
            Epoch(mouse,[2 4 5])=ConcatenateDataFromFolders_SB(FolderList.(Mouse_names{mouse}),'epoch','epochname','sleepstates'); % Temporary change from sleepstates to sleepstates_accelero
            Epoch{mouse,3}=or(Epoch{mouse,4},Epoch{mouse,5});
            try
                Epoch2=ConcatenateDataFromFolders_SB(FolderList.(Mouse_names{mouse}),'epoch','epochname','NREMsubstages');
            catch
                Epoch2{1} = intervalSet(0,0); Epoch2{2} = intervalSet(0,0); Epoch2{3} = intervalSet(0,0);
            end
            Epoch(mouse,6:8)=Epoch2(1:3);
        catch % no sleep pre sessions
            disp(['skipped mouse ' Mouse_names{mouse}])
            FolderList.(Mouse_names{mouse}) = [];
        end
    end
    NameEpoch{1}='Total';
    NameEpoch{2}='Wake';
    NameEpoch{3}='Sleep';
    NameEpoch{4}='NREM';
    NameEpoch{5}='REM';
    NameEpoch{6}='N1';
    NameEpoch{7}='N2';
    NameEpoch{8}='N3';
end


% calculating the differents variables that you will use
for i = 1:length(varargin)
    clear OutPutVar
    if ischar(varargin{i})
        switch(lower(varargin{i}))
            case 'accelero'
                for mouse=1:length(Mouse_names)
                    try
                        OutPutVar.(Mouse_names{mouse})=ConcatenateDataFromFolders_SB(FolderList.(Mouse_names{mouse}),'accelero');
                    catch
                        try
                            OutPutVar.(Mouse_names{mouse})=ConcatenateDataFromFolders_BM(FolderList.(Mouse_names{mouse}),'accelero_on_behav');
                        catch
                            OutPutVar.(Mouse_names{mouse})=tsd([],[]);
                        end
                    end
                end
                
            case 'speed'
                for mouse=1:length(Mouse_names)
                    try
                        OutPutVar.(Mouse_names{mouse})=ConcatenateDataFromFolders_SB(FolderList.(Mouse_names{mouse}),'speed');
                    catch
                        OutPutVar.(Mouse_names{mouse})=tsd([],[]);
                    end
                end
            case 'trackingnans'
                for mouse=1:length(Mouse_names)
                    try
                        OutPutVar.(Mouse_names{mouse})=ConcatenateDataFromFolders_SB(FolderList.(Mouse_names{mouse}),'trackingnans');
                    catch
                        OutPutVar.(Mouse_names{mouse})=tsd([],[]);
                    end
                end
                
                
            case 'imdiff'
                for mouse=1:length(Mouse_names)
                    try
                        OutPutVar.(Mouse_names{mouse})=ConcatenateDataFromFolders_SB(FolderList.(Mouse_names{mouse}),'imdiff');
                    catch
                        OutPutVar.(Mouse_names{mouse})=tsd([],[]);
                    end
                end
                
            case 'lfp'
                for mouse=1:length(Mouse_names)
                    chan_numb=varargin{i+1};
                    OutPutVar.(Mouse_names{mouse})=ConcatenateDataFromFolders_SB(FolderList.(Mouse_names{mouse}),'lfp','channumber',chan_numb);
                end
                
            case 'linearposition'
                for mouse=1:length(Mouse_names)
                    OutPutVar.(Mouse_names{mouse})=ConcatenateDataFromFolders_SB(FolderList.(Mouse_names{mouse}),'linearposition');
                end
                
            case 'masktemperature'
                for mouse=1:length(Mouse_names)
                    OutPutVar.(Mouse_names{mouse})=ConcatenateDataFromFolders_SB(FolderList.(Mouse_names{mouse}),'masktemperature');
                end
                
            case 'tailtemperature'
                for mouse=1:length(Mouse_names)
                    OutPutVar.(Mouse_names{mouse})=ConcatenateDataFromFolders_SB(FolderList.(Mouse_names{mouse}),'tailtemperature');
                end
                
            case 'heartrate'
                for mouse=1:length(Mouse_names)
                    try
                        OutPutVar.(Mouse_names{mouse})=ConcatenateDataFromFolders_SB(FolderList.(Mouse_names{mouse}),'heartrate');
                    end
                end
                
            case 'heartratevar'
                for mouse=1:length(Mouse_names)
                    try
                        OutPutVar.(Mouse_names{mouse})=ConcatenateDataFromFolders_SB(FolderList.(Mouse_names{mouse}),'heartratevar');
                    end
                end
                
            case 'heartbeat'
                for mouse=1:length(Mouse_names)
                    try
                        OutPutVar.(Mouse_names{mouse})=ConcatenateDataFromFolders_SB(FolderList.(Mouse_names{mouse}),'heartbeat');
                    end
                end
                
            case 'emg_pect'
                for mouse=1:length(Mouse_names)
                    try
                        OutPutVar.(Mouse_names{mouse})=ConcatenateDataFromFolders_SB(FolderList.(Mouse_names{mouse}),'emg_pect');
                    end
                end
                
            case 'alignedposition'
                for mouse=1:length(Mouse_names)
                    try
                        OutPutVar.(Mouse_names{mouse})=ConcatenateDataFromFolders_SB(FolderList.(Mouse_names{mouse}),'alignedposition');
                    end
                end
                
            case 'emg_neck'
                for mouse=1:length(Mouse_names)
                    try
                        OutPutVar.(Mouse_names{mouse})=ConcatenateDataFromFolders_SB(FolderList.(Mouse_names{mouse}),'emg_neck');
                    end
                end
                
            case 'emg_any'
                for mouse=1:length(Mouse_names)
                    try
                        OutPutVar.(Mouse_names{mouse})=ConcatenateDataFromFolders_SB(FolderList.(Mouse_names{mouse}),'emg_any');
                    end
                end
                
            case 'instfreq'
                for mouse=1:length(Mouse_names)
                    try
                        OutPutVar.(Mouse_names{mouse})=ConcatenateDataFromFolders_SB(FolderList.(Mouse_names{mouse}),'instfreq','suffix_instfreq','B');
                    end
                end
                
            case 'instphase'
                for mouse=1:length(Mouse_names)
                    try
                        OutPutVar.(Mouse_names{mouse})=ConcatenateDataFromFolders_SB(FolderList.(Mouse_names{mouse}),'instphase','suffix_instphase','B','method','WV');
                    end
                end
                
            case 'instfreq_wv'
                for mouse=1:length(Mouse_names)
                    OutPutVar.(Mouse_names{mouse})=ConcatenateDataFromFolders_SB(FolderList.(Mouse_names{mouse}),'instfreq','method','WV','suffix_instfreq','B');
                end
                
            case 'respi_freq_bm'
                for mouse=1:length(Mouse_names)
                    OutPutVar.(Mouse_names{mouse})=ConcatenateDataFromFolders_SB(FolderList.(Mouse_names{mouse}),'respi_freq_BM');
                end
                
            case 'ob_gamma_freq'
                for mouse=1:length(Mouse_names)
                    %                     try
                    OutPutVar.(Mouse_names{mouse})=ConcatenateDataFromFolders_SB(FolderList.(Mouse_names{mouse}),'ob_gamma_freq');
                    %                     end
                end
                
            case 'ob_gamma_power'
                for mouse=1:length(Mouse_names)
                    try
                        OutPutVar.(Mouse_names{mouse})=ConcatenateDataFromFolders_SB(FolderList.(Mouse_names{mouse}),'ob_gamma_power');
                    end
                end
                
            case 'ob_gamma_ratio'
                for mouse=1:length(Mouse_names)
                    try
                        OutPutVar.(Mouse_names{mouse})=ConcatenateDataFromFolders_SB(FolderList.(Mouse_names{mouse}),'ob_gamma_ratio');
                    end
                end
                
            case 'hpc_theta_freq'
                for mouse=1:length(Mouse_names)
                    try
                        OutPutVar.(Mouse_names{mouse})=ConcatenateDataFromFolders_SB(FolderList.(Mouse_names{mouse}),'hpc_theta_freq');
                    end
                end
                
            case 'hpc_theta_power'
                for mouse=1:length(Mouse_names)
                    try
                        OutPutVar.(Mouse_names{mouse})=ConcatenateDataFromFolders_SB(FolderList.(Mouse_names{mouse}),'hpc_theta_power');
                    end
                end
                
            case 'hpc_theta_delta'
                for mouse=1:length(Mouse_names)
                    try
                        OutPutVar.(Mouse_names{mouse})=ConcatenateDataFromFolders_SB(FolderList.(Mouse_names{mouse}),'hpc_theta_delta');
                    end
                end
                
            case 'pfc_delta_power'
                for mouse=1:length(Mouse_names)
                    try
                        OutPutVar.(Mouse_names{mouse})=ConcatenateDataFromFolders_SB(FolderList.(Mouse_names{mouse}),'pfc_delta_power');
                    end
                end
                
            case 'respivar'
                for mouse=1:length(Mouse_names)
                    OutPutVar.(Mouse_names{mouse})=ConcatenateDataFromFolders_SB(FolderList.(Mouse_names{mouse}),'respivar');
                end
                
            case 'ripples'
                for mouse=1:length(Mouse_names)
                    try
                        OutPutVar.(Mouse_names{mouse})=ConcatenateDataFromFolders_SB(FolderList.(Mouse_names{mouse}),'ripples');
                        %                     catch
                        %                         keyboard
                    end
                end
                
            case 'ripples_all'
                for mouse=1:length(Mouse_names)
                    try
                        OutPutVar.(Mouse_names{mouse})=ConcatenateDataFromFolders_SB(FolderList.(Mouse_names{mouse}),'ripples_all');
                    catch
                        keyboard
                    end
                end
                
            case 'ripples_epoch'
                for mouse=1:length(Mouse_names)
                    OutPutVar.(Mouse_names{mouse})=ConcatenateDataFromFolders_SB(FolderList.(Mouse_names{mouse}),'ripples_epoch');
                end
                
            case 'stimepoch2'
                for mouse=1:length(Mouse_names)
                    OutPutVar.(Mouse_names{mouse})=ConcatenateDataFromFolders_SB(FolderList.(Mouse_names{mouse}),'epoch','epochname','stimepoch2');
                end
                
            case 'ripples_meanwaveform'
                for mouse=1:length(Mouse_names)
                    try
                        chan_numb = Get_chan_numb_BM(FolderList.(Mouse_names{mouse}){1} , 'rip');
                        LFP_rip.(Mouse_names{mouse}) = ConcatenateDataFromFolders_SB(FolderList.(Mouse_names{mouse}),'lfp','channumber',chan_numb);
                        OutPutVar.(Mouse_names{mouse}) = ConcatenateDataFromFolders_SB(FolderList.(Mouse_names{mouse}),'ripples');
                        is_there_rip_chan.(Mouse_names{mouse}) = 1;
                    catch
                        is_there_rip_chan.(Mouse_names{mouse}) = 0;
                        OutPutVar.(Mouse_names{mouse})=NaN;
                    end
                end
                
            case 'respi_meanwaveform'
                for mouse=1:length(Mouse_names)
                    chan_numb = Get_chan_numb_BM(FolderList.(Mouse_names{mouse}){1} , 'bulb_deep');
                    LFP_BulbDeep.(Mouse_names{mouse}) = ConcatenateDataFromFolders_SB(FolderList.(Mouse_names{mouse}),'lfp','channumber',chan_numb);
                    OutPutVar.(Mouse_names{mouse}) = ConcatenateDataFromFolders_SB(FolderList.(Mouse_names{mouse}),'respi_peak');
                end
                
            case 'hpc_around_ripples'
                for mouse=1:length(Mouse_names)
                    try
                        Sptsd_dHPC.(Mouse_names{mouse}) = ConcatenateDataFromFolders_SB(FolderList.(Mouse_names{mouse}),'spectrum','prefix','H_Low');
                        RipplesTimes.(Mouse_names{mouse}) = ConcatenateDataFromFolders_SB(FolderList.(Mouse_names{mouse}),'ripples');
                        AroundRipples.(Mouse_names{mouse}) = intervalSet(Range(RipplesTimes.(Mouse_names{mouse}))-1e4 , Range(RipplesTimes.(Mouse_names{mouse}))+1e4);
                        OutPutVar.(Mouse_names{mouse})= Restrict(Sptsd_dHPC.(Mouse_names{mouse}) , and(Epoch{mouse,1} , AroundRipples.(Mouse_names{mouse})));
                        is_there_rip_chan.(Mouse_names{mouse}) = 1;
                    catch
                        is_there_rip_chan.(Mouse_names{mouse}) = 0;
                        OutPutVar.(Mouse_names{mouse})=NaN;
                    end
                end
                noise_thr=21;
                Sp_type=1;
                
            case 'spindles'
                for mouse=1:length(Mouse_names)
                    OutPutVar.(Mouse_names{mouse})=ConcatenateDataFromFolders_SB(FolderList.(Mouse_names{mouse}),'spindles');
                end
                
            case 'delta'
                for mouse=1:length(Mouse_names)
                    OutPutVar.(Mouse_names{mouse})=ConcatenateDataFromFolders_SB(FolderList.(Mouse_names{mouse}),'deltawaves');
                end
                
            case 'ob_low'
                for mouse=1:length(Mouse_names)
                    try
                        OutPutVar.(Mouse_names{mouse})=ConcatenateDataFromFolders_SB(FolderList.(Mouse_names{mouse}),'spectrum','prefix','B_Low');
                    end
                end
                noise_thr=12;
                Sp_type=1;
                
            case 'ob_middle'
                for mouse=1:length(Mouse_names)
                    OutPutVar.(Mouse_names{mouse})=ConcatenateDataFromFolders_SB(FolderList.(Mouse_names{mouse}),'spectrum','prefix','B_Middle');
                end
                noise_thr=21;
                Sp_type=4;
                
            case 'ob_high'
                try
                    for mouse=1:length(Mouse_names)
                        OutPutVar.(Mouse_names{mouse})=ConcatenateDataFromFolders_SB(FolderList.(Mouse_names{mouse}),'spectrum','prefix','B_High');
                    end
                    noise_thr=9;
                    Sp_type=2;
                end
                
            case 'hpc_low'
                for mouse=1:length(Mouse_names)
                    try
                        OutPutVar.(Mouse_names{mouse})=ConcatenateDataFromFolders_SB(FolderList.(Mouse_names{mouse}),'spectrum','prefix','H_Low');
                    catch
                        OutPutVar.(Mouse_names{mouse})=NaN;
                    end
                end
                noise_thr=21;
                Sp_type=1;
                
            case 'pfc_low'
                for mouse=1:length(Mouse_names)
                    try
                        OutPutVar.(Mouse_names{mouse})=ConcatenateDataFromFolders_SB(FolderList.(Mouse_names{mouse}),'spectrum','prefix','PFCx_Low');
                    catch
                        OutPutVar.(Mouse_names{mouse})=NaN;
                    end
                end
                noise_thr=12; %noise_thr=5; must set threshold if active or sleep, manually for the moment
                Sp_type=1;
                
            case 'hpc_vhigh'
                for mouse=1:length(Mouse_names)
                    try
                        %                         OutPutVar.(Mouse_names{mouse})=Restrict(ConcatenateDataFromFolders_SB(FolderList.(Mouse_names{mouse}),'spectrum','prefix','H_VHigh') , ConcatenateDataFromFolders_SB(FolderList.(Mouse_names{mouse}),'ripples_epoch'));
                        OutPutVar.(Mouse_names{mouse})=ConcatenateDataFromFolders_SB(FolderList.(Mouse_names{mouse}),'spectrum','prefix','H_VHigh');
                    catch
                        OutPutVar.(Mouse_names{mouse})=tsd([],[]);
                    end
                end
                noise_thr=33;
                Sp_type=3;
                
            case 'hpc_vhigh_extended'
                for mouse=1:length(Mouse_names)
                    try
                        OutPutVar.(Mouse_names{mouse})=Restrict(ConcatenateDataFromFolders_SB(FolderList.(Mouse_names{mouse}),'spectrum','prefix','H_VHigh') , ConcatenateDataFromFolders_SB(FolderList.(Mouse_names{mouse}),'ripples_epoch_extended'));
                        %OutPutVar.(Mouse_names{mouse})=ConcatenateDataFromFolders_SB(FolderList.(Mouse_names{mouse}),'spectrum','prefix','H_VHigh');
                    catch
                        OutPutVar.(Mouse_names{mouse})=tsd([],[]);
                    end
                end
                noise_thr=33;
                Sp_type=3;
                
            case 'ob_high_on_respi_phase_pref'
                for mouse=1:length(Mouse_names)
                    chan_numb = Get_chan_numb_BM(FolderList.(Mouse_names{mouse}){1} , 'bulb_deep');
                    LFP.(Mouse_names{mouse}) = ConcatenateDataFromFolders_SB(FolderList.(Mouse_names{mouse}),'lfp','channumber',chan_numb);
                    Spectrogram_to_use.(Mouse_names{mouse}) = ConcatenateDataFromFolders_SB(FolderList.(Mouse_names{mouse}),'spectrum','prefix','B_Middle');
                end
                
            case 'hpc_vhigh_on_respi_phase_pref'
                for mouse=1:length(Mouse_names)
                    chan_numb = Get_chan_numb_BM(FolderList.(Mouse_names{mouse}){1} , 'bulb_deep');
                    LFP.(Mouse_names{mouse}) = ConcatenateDataFromFolders_SB(FolderList.(Mouse_names{mouse}),'lfp','channumber',chan_numb);
                    try
                        Spectrogram_to_use.(Mouse_names{mouse}) = ConcatenateDataFromFolders_SB(FolderList.(Mouse_names{mouse}),'spectrum','prefix','H_Vhigh');
                    catch
                        Spectrogram_to_use.(Mouse_names{mouse}) = tsd([],[]);
                    end
                end
                
            case 'hpc_vhigh_on_theta_phase_pref'
                for mouse=1:length(Mouse_names)
                    chan_numb = Get_chan_numb_BM(FolderList.(Mouse_names{mouse}){1} , 'hpc_deep');
                    LFP.(Mouse_names{mouse}) = ConcatenateDataFromFolders_SB(FolderList.(Mouse_names{mouse}),'lfp','channumber',chan_numb);
                    try
                        Spectrogram_to_use.(Mouse_names{mouse}) = ConcatenateDataFromFolders_SB(FolderList.(Mouse_names{mouse}),'spectrum','prefix','H_Vhigh');
                    catch
                        Spectrogram_to_use.(Mouse_names{mouse}) = tsd([],[]);
                    end
                end
                
            case 'ob_pfc_coherence'
                for mouse=1:length(Mouse_names)
                    try
                        chan_numb1 = Get_chan_numb_BM(FolderList.(Mouse_names{mouse}){1} , 'bulb_deep');
                        chan_numb2 = Get_chan_numb_BM(FolderList.(Mouse_names{mouse}){1} , 'pfc_deep');
                        LFP_bulb.(Mouse_names{mouse}) = ConcatenateDataFromFolders_SB(FolderList.(Mouse_names{mouse}),'lfp','channumber',chan_numb1);
                        LFP_pfc.(Mouse_names{mouse}) = ConcatenateDataFromFolders_SB(FolderList.(Mouse_names{mouse}),'lfp','channumber',chan_numb2);
                        params.Fs=1/median(diff(Range(LFP_bulb.(Mouse_names{mouse}),'s'))); params.tapers=[3 5]; params.fpass=[0.1 20]; params.err=[2,0.05]; params.pad=0; movingwin=[3 0.2];
                        OutPutVar.(Mouse_names{mouse}) = LFP_bulb.(Mouse_names{mouse});
                    catch
                        OutPutVar.(Mouse_names{mouse}) = NaN;
                    end
                end
                
            case 'hpc_pfc_coherence'
                for mouse=1:length(Mouse_names)
                    try
                        chan_numb1 = Get_chan_numb_BM(FolderList.(Mouse_names{mouse}){1} , 'hpc_deep');
                        chan_numb2 = Get_chan_numb_BM(FolderList.(Mouse_names{mouse}){1} , 'pfc_deep');
                        LFP_hpc.(Mouse_names{mouse}) = ConcatenateDataFromFolders_SB(FolderList.(Mouse_names{mouse}),'lfp','channumber',chan_numb1);
                        LFP_pfc.(Mouse_names{mouse}) = ConcatenateDataFromFolders_SB(FolderList.(Mouse_names{mouse}),'lfp','channumber',chan_numb2);
                        params.Fs=1/median(diff(Range(LFP_hpc.(Mouse_names{mouse}),'s'))); params.tapers=[3 5]; params.fpass=[0.1 20]; params.err=[2,0.05]; params.pad=0; movingwin=[3 0.2];
                        OutPutVar.(Mouse_names{mouse}) = LFP_hpc.(Mouse_names{mouse});
                    catch
                        OutPutVar.(Mouse_names{mouse}) = NaN;
                    end
                end
                
                %% added by SB
                
                
            case 'respi_freq_bm_sametps'
                for mouse=1:length(Mouse_names)
                    OutPutVar.(Mouse_names{mouse})=ConcatenateDataFromFolders_SB(FolderList.(Mouse_names{mouse}),'respi_freq_BM_sametps');
                end
                
            case 'heartrate_sametps'
                for mouse=1:length(Mouse_names)
                    OutPutVar.(Mouse_names{mouse})=ConcatenateDataFromFolders_SB(FolderList.(Mouse_names{mouse}),'heartrate_sametps');
                end
                
            case 'heartratevar_sametps'
                for mouse=1:length(Mouse_names)
                    OutPutVar.(Mouse_names{mouse})=ConcatenateDataFromFolders_SB(FolderList.(Mouse_names{mouse}),'heartratevar_sametps');
                end
                
            case 'ob_high_power_sametps'
                for mouse=1:length(Mouse_names)
                    OutPutVar.(Mouse_names{mouse})=ConcatenateDataFromFolders_SB(FolderList.(Mouse_names{mouse}),'ob_high_power_sametps');
                end
                
            case 'ripples_density'
                try
                    for mouse=1:length(Mouse_names)
                        OutPutVar.(Mouse_names{mouse})=ConcatenateDataFromFolders_SB(FolderList.(Mouse_names{mouse}),'ripples_density');
                    end
                end
                
            case 'ob_high_freq_sametps'
                for mouse=1:length(Mouse_names)
                    OutPutVar.(Mouse_names{mouse})=ConcatenateDataFromFolders_SB(FolderList.(Mouse_names{mouse}),'ob_high_freq_sametps');
                end
                
            case 'accelero_sametps'
                for mouse=1:length(Mouse_names)
                    OutPutVar.(Mouse_names{mouse})=ConcatenateDataFromFolders_SB(FolderList.(Mouse_names{mouse}),'accelero_sametps');
                end
                
            case 'hpc_lowtheta_samteps'
                for mouse=1:length(Mouse_names)
                    OutPutVar.(Mouse_names{mouse})=ConcatenateDataFromFolders_SB(FolderList.(Mouse_names{mouse}),'hpc_lowtheta_samteps');
                end
                
            case 'linpos_sampetps'
                for mouse=1:length(Mouse_names)
                    OutPutVar.(Mouse_names{mouse})=ConcatenateDataFromFolders_SB(FolderList.(Mouse_names{mouse}),'linpos_sampetps');
                end
                
        end
        
        
        % gathering data
        for mouse=1:length(Mouse)
            Mouse_names{mouse} = ['M' num2str(Mouse(mouse))];
            
            if and(fear==1 , sleep==0)
                ind = [1:8];
            else
                ind = 1:size(Epoch,2);
            end
            for states=ind
                
                if convertCharsToStrings(varargin{i}) == 'ripples_meanwaveform'          % exception for mean riplles waveform
                    if is_there_rip_chan.(Mouse_names{mouse}) == 0
                        OutPutData.(varargin{1, i})(mouse,states,:)=NaN(1,1,1001);
                    else
                        Ripples_times_OnEpoch = Restrict(OutPutVar.(Mouse_names{mouse}) , Epoch{mouse,states});
                        ripples_time = Range(Ripples_times_OnEpoch,'s');
                        [~,T_pre] = PlotRipRaw(LFP_rip.(Mouse_names{mouse}), ripples_time, 400, 0, 0);
                        if isnan(nanmean(T_pre))
                            OutPutData.(varargin{1, i})(mouse,states,:)=NaN(1,1001);
                        else
                            try
                                OutPutData.(varargin{1, i})(mouse,states,:) = nanmean(T_pre);
                            catch
                                OutPutData.(varargin{1, i})(mouse,states,:) = [nanmean(T_pre) NaN];
                            end
                        end
                    end
                    
                    
                elseif convertCharsToStrings(varargin{i}) == 'respi_meanwaveform'                                     % exception for mean riplles waveform
                    
                    Peaks_times_OnEpoch = Restrict(OutPutVar.(Mouse_names{mouse}) , Epoch{mouse,states});
                    Peaks_time = Range(Peaks_times_OnEpoch,'s');
                    [M_pre,T_pre] = PlotRipRaw(LFP_BulbDeep.(Mouse_names{mouse}), Peaks_time, 300, 0, 0);
                    if isnan(nanmean(T_pre));
                        OutPutData.(varargin{1, i})(mouse,states,:)=NaN(1,751);
                    else
                        OutPutData.(varargin{1, i})(mouse,states,:) = nanmean(T_pre);
                    end
                    
                    
                elseif or(or(convertCharsToStrings(varargin{i}) == 'ob_high_on_respi_phase_pref' , convertCharsToStrings(varargin{i}) == 'hpc_vhigh_on_respi_phase_pref'),convertCharsToStrings(varargin{i}) == 'hpc_vhigh_on_theta_phase_pref')   % exception for phase preference
                    try
                        Spectro_to_use = Restrict(Spectrogram_to_use.(Mouse_names{mouse}) , Epoch{mouse,states});
                        LFP_to_use = Restrict(LFP.(Mouse_names{mouse}) , Epoch{mouse,states});
                    catch
                        Spectro_to_use = tsd([],[]);
                        LFP_to_use = tsd([],[]);
                    end
                    if length(Spectro_to_use)>0
                        try
                            if convertCharsToStrings(varargin{i}) == 'ob_high_on_respi_phase_pref'
                                [P,f,VBinnedPhase] = PrefPhaseSpectrum(LFP_to_use , Data(Spectro_to_use) , Range(Spectro_to_use,'s') , range_Middle , [1 7] , 30); close
                            elseif convertCharsToStrings(varargin{i}) == 'hpc_vhigh_on_respi_phase_pref'
                                try
                                    [P,f,VBinnedPhase,L] = PrefPhaseSpectrum_BM(LFP_to_use , Data(Spectro_to_use) , Range(Spectro_to_use,'s') , range_VHigh , [1 7] , 30); close
                                catch
                                    P=NaN; L=NaN; f=NaN; VBinnedPhase=NaN;
                                end
                            elseif convertCharsToStrings(varargin{i}) == 'hpc_vhigh_on_theta_phase_pref'
                                try
                                    [P,f,VBinnedPhase] = PrefPhaseSpectrum(LFP_to_use , Data(Spectro_to_use) , Range(Spectro_to_use,'s') , range_VHigh , [3 10] , 30); close
                                catch
                                    P=NaN; f=NaN; VBinnedPhase=NaN;
                                end
                            end
                        catch
                            keyboard
                        end
                    else
                        P=NaN; f=NaN; VBinnedPhase=NaN;
                    end
                    OutPutData.(varargin{1, i}).PhasePref{mouse,states} = P;
                    OutPutData.(varargin{1, i}).MeanLFP{mouse,states} = L;
                    OutPutData.(varargin{1, i}).Frequency = f;
                    OutPutData.(varargin{1, i}).BinnedPhase = VBinnedPhase;
                    OutPutVar.(Mouse_names{mouse}) = LFP_to_use;
                    
                elseif convertCharsToStrings(varargin{i}) == 'ob_pfc_coherence'
                    try
                        [Ctemp,phi,S12,S1temp,S2temp,t,f,confC,phitemp,Cerr]=cohgramc( Data(Restrict(LFP_bulb.(Mouse_names{mouse}) , Epoch{mouse,states})) , Data(Restrict(LFP_pfc.(Mouse_names{mouse}) , Epoch{mouse,states})) , movingwin , params);
                        OutPutData.(varargin{1, i}).mean(mouse,states,:) = nanmean(Ctemp);
                    end
                    
                elseif convertCharsToStrings(varargin{i}) == 'hpc_pfc_coherence'
                    try
                        [Ctemp,phi,S12,S1temp,S2temp,t,f,confC,phitemp,Cerr]=cohgramc( Data(Restrict(LFP_hpc.(Mouse_names{mouse}) , Epoch{mouse,states})) , Data(Restrict(LFP_pfc.(Mouse_names{mouse}) , Epoch{mouse,states})) , movingwin , params);
                        OutPutData.(varargin{1, i}).mean(mouse,states,:) = nanmean(Ctemp);
                    end
                    
                elseif convertCharsToStrings(varargin{i}) == 'ripples_all'
                    try
                        OutPutData.(varargin{1, i}).tsd{mouse,states}=Restrict(OutPutVar.(Mouse_names{mouse}) , Epoch{mouse,states});
                    end
                    
                else
                    % add by BM on 15/01/2024
                    try
                        OutPutVar.(Mouse_names{mouse});
                    catch
                        OutPutVar.(Mouse_names{mouse})=intervalSet([],[]);
                    end
                    
                    dimensions=size(OutPutVar.(Mouse_names{mouse}));
                    if dimensions(2)<3 % Spectro or not
                        % not spectro
                        b=convertCharsToStrings(class(OutPutVar.(Mouse_names{mouse})));
                        if b=='ts'
                            OutPutData.(varargin{1, i}).mean(mouse,states)=length(Restrict(OutPutVar.(Mouse_names{mouse}) , Epoch{mouse,states})) / (sum(Stop(Epoch{mouse,states}) - Start(Epoch{mouse,states}))/1e4);
                            OutPutData.(varargin{1, i}).ts{mouse,states}=Restrict(OutPutVar.(Mouse_names{mouse}) , Epoch{mouse,states}) ;
                        elseif b=='intervalSet'
                            OutPutData.(varargin{1, i}).proportion(mouse,states)=  (sum(Stop(and(OutPutVar.(Mouse_names{mouse}) , Epoch{mouse,states})) - Start(and(OutPutVar.(Mouse_names{mouse}) , Epoch{mouse,states})))/1e4) / (sum(Stop(Epoch{mouse,states}) - Start(Epoch{mouse,states}))/1e4);
                            OutPutData.(varargin{1, i}).density(mouse,states)= length(Start(and(OutPutVar.(Mouse_names{mouse}) , Epoch{mouse,states}))) / (sum(Stop(Epoch{mouse,states}) - Start(Epoch{mouse,states}))/1e4);
                            OutPutData.(varargin{1, i}).epoch(mouse,states)= and(OutPutVar.(Mouse_names{mouse}) , Epoch{mouse,states});
                        else % tsd data
                            if dimensions(2)==2
                                try
                                    OutPutData.(varargin{1, i}).mean(mouse,states,:)=nanmean(Data(Restrict(OutPutVar.(Mouse_names{mouse}) , Epoch{mouse,states})));
                                    OutPutData.(varargin{1, i}).tsd{mouse,states}=Restrict(OutPutVar.(Mouse_names{mouse}) , Epoch{mouse,states});
                                end
                            else
                                try
                                    OutPutData.(varargin{1, i}).mean(mouse,states)=nanmean(Data(Restrict(OutPutVar.(Mouse_names{mouse}) , Epoch{mouse,states})));
                                    OutPutData.(varargin{1, i}).tsd{mouse,states}=Restrict(OutPutVar.(Mouse_names{mouse}) , Epoch{mouse,states});
                                end
                            end
                        end
                        
                        % spectro
                    else
                        % little correction for old low spectrums
                        if size(Data(OutPutVar.(Mouse_names{mouse})),2)==263
                            R=Range(OutPutVar.(Mouse_names{mouse}));
                            D=Data(OutPutVar.(Mouse_names{mouse}));
                            OutPutVar.(Mouse_names{mouse}) = tsd(R , D(:,3:end));
                        end
                        
                        MeanSpectrum = nanmean(Data(Restrict(OutPutVar.(Mouse_names{mouse}) , Epoch{mouse,states})));
                        try
                            [ OutPutData.(varargin{1, i}).power(mouse,states) , OutPutData.(varargin{1, i}).max_freq(mouse,states) ] = max( MeanSpectrum(noise_thr:end ) );
                            %                             if OutPutData.(varargin{1, i}).max_freq(mouse,states)==noise_thr
                            %                             OutPutData.(varargin{1, i}).max_freq(mouse,states)=NaN
                            %                             end
                            
                            if Sp_type==1 % Low spectrum
                                RANGE=range_Low;
                            elseif Sp_type==2 % High spectrum
                                RANGE=range_High;
                            elseif Sp_type==3 % VHigh spectrum
                                RANGE=range_VHigh;
                            elseif Sp_type==4 % Middle spectrum
                                RANGE=range_Middle;
                            end
                            
                            OutPutData.(varargin{1, i}).max_freq(mouse,states) = RANGE(OutPutData.(varargin{1, i}).max_freq(mouse,states) + noise_thr-1);
                            OutPutData.(varargin{1, i}).mean(mouse,states,:) = nanmean(Data(Restrict(OutPutVar.(Mouse_names{mouse}) , Epoch{mouse,states})));
                            %      OutPutData.(varargin{1, i}).spectrogram{mouse,states} = Restrict(OutPutVar.(Mouse_names{mouse}) , Epoch{mouse,states});
                            
                            R = Range(OutPutVar.(Mouse_names{mouse})); D = Data(OutPutVar.(Mouse_names{mouse}));
                            OutPutData.(varargin{1, i}).spectrogram{mouse,states} = Restrict(tsd(R(1:10:end) , D(1:10:end,:)) , Epoch{mouse,states});
                            
                            
                        catch
                            try
                                OutPutData.(varargin{1, i}).power(mouse,states) = NaN;
                                OutPutData.(varargin{1, i}).mean(mouse,states,:) = NaN(1,length(RANGE));
                                OutPutData.(varargin{1, i}).max_freq(mouse,states) = NaN;
                            catch
                                %                                 keyboard
                            end
                        end
                    end
                end
                
                OutPutTSD.(varargin{1, i}){mouse} = OutPutVar.(Mouse_names{mouse}); % SB chnaged from  OutPutTSD.(varargin{1, i}){i,mouse} = OutPutVar.(Mouse_names{mouse});
                
            end
            disp(Mouse_names{mouse})
        end
    end
end






