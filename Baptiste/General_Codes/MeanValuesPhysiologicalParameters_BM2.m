
function [OutPutData , Epoch , NameEpoch , OutPutTSD] = MeanValuesPhysiologicalParameters_BM2(Sleep_Type,group,varargin)

% Same as MeanValuesPhysiologicalParameters_BM2 but for sleep, Epoch here
% NameEpoch{1}='Total';
% NameEpoch{2}='Wake';
% NameEpoch{3}='Sleep';
% NameEpoch{4}='NREM';
% NameEpoch{5}='REM';
% NameEpoch{6}='N1';
% NameEpoch{7}='N2';
% NameEpoch{8}='N3';


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
% - lfp ('lfp',num_chan)
% - linearposition
% - masktemperature
% - tailtemperature
% - emg
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
%  - added by Sb :'respi_freq_BM_sametps','heartrate_sametps','heartratevar_sametps','ob_high_sametps','ripples_density_sametps','ob_high_freq_sametps


if convertCharsToStrings(Sleep_Type) == 'baseline_sleep'
    GetSleepSessions_Drugs_BM
    FolderList = SleepInfo.path{group};
    study_time = 60; % time in minutes that define Epoch
elseif convertCharsToStrings(Sleep_Type) == 'maze_sleep'
    GetAllSalineSessions_BM
end



cd('/media/nas4/ProjetEmbReact/Mouse688/20180209/ProjectEmbReact_M688_20180209_TestPre_PreDrug/TestPre3')
load('H_Low_Spectrum.mat'); range_Low=Spectro{3};
load('B_Middle_Spectrum.mat'); range_Middle=Spectro{3};
load('B_High_Spectrum.mat'); range_High=Spectro{3};
load('H_VHigh_Spectrum.mat'); range_VHigh=Spectro{3};

NameEpoch_inj{1}='Pre';
NameEpoch_inj{2}='Post Inj';
NameEpoch_inj{3}='Post';

NameEpoch_state{1}='Total';
NameEpoch_state{2}='Wake';
NameEpoch_state{3}='Sleep';
NameEpoch_state{4}='NREM';
NameEpoch_state{5}='REM';
NameEpoch_state{6}='N1';
NameEpoch_state{7}='N2';
NameEpoch_state{8}='N3';


% calculating the differents epochs that you will use

for mouse=1:length(FolderList)
    
    cd(FolderList{mouse})
    
    clear Epoch_Drugs Epoch_pre Epoch_pre2
    load('SleepScoring_OBGamma.mat', 'Epoch_Drugs')
    Epoch_inj{1} = Epoch_Drugs{1};
    Epoch_inj{2} = intervalSet(Start(Epoch_Drugs{2}) , Start(Epoch_Drugs{2}) + study_time*60e4);
    Epoch_inj{3} = intervalSet(Stop(Epoch_inj{2}) , Stop(Epoch_Drugs{3}));
    
    NoisyEpoch = ConcatenateDataFromFolders_SB(FolderList(mouse),'Epoch','epochname','noiseepoch');
    Epoch_pre{mouse,1}= intervalSet(0,max( Range( ConcatenateDataFromFolders_SB(FolderList(mouse),'accelero')))) -NoisyEpoch;
    Epoch_pre(mouse,[2 4 5])=ConcatenateDataFromFolders_SB(FolderList(mouse),'epoch','epochname','sleepstates');
    Epoch_pre{mouse,3}=or(Epoch_pre{mouse,4},Epoch_pre{mouse,5});
    try
        Epoch_pre2=ConcatenateDataFromFolders_SB(FolderList(mouse),'epoch','epochname','NREMsubstages');
    catch
        Epoch_pre2{1} = intervalSet(0,0); Epoch_pre2{2} = intervalSet(0,0); Epoch_pre2{3} = intervalSet(0,0);
    end
    Epoch_pre(mouse,6:8)=Epoch_pre2(1:3);
    
    
    for ep=1:3
        for epo=1:8
            try
                Epoch{mouse,ep,epo} = and(Epoch_inj{ep} , Epoch_pre{epo});
            catch
                Epoch{mouse,ep,epo} = intervalSet([],[]);
            end
                NameEpoch{ep,epo} = [NameEpoch_inj{ep} ' ' NameEpoch_state{epo}];
        end
    end
    
    % calculating the differents variables that you will use
    for i = 1:length(varargin)
        if ~ischar(varargin{i})
        else
            switch(lower(varargin{i}))
                case 'accelero'
                    try
                        OutPutVar=ConcatenateDataFromFolders_SB(FolderList(mouse),'accelero');
                    catch
                        OutPutVar=ConcatenateDataFromFolders_BM(FolderList(mouse),'accelero_on_behav');
                    end
                    
                case 'speed'
                    OutPutVar=ConcatenateDataFromFolders_SB(FolderList(mouse),'speed');
                    
                case 'lfp'
                    chan_numb=varargin{i+1};
                    OutPutVar=ConcatenateDataFromFolders_SB(FolderList(mouse),'lfp','channumber',chan_numb);
                    
                case 'linearposition'
                    OutPutVar=ConcatenateDataFromFolders_SB(FolderList(mouse),'linearposition');
                    
                case 'masktemperature'
                    OutPutVar=ConcatenateDataFromFolders_SB(FolderList(mouse),'masktemperature');
                    
                case 'tailtemperature'
                    OutPutVar=ConcatenateDataFromFolders_SB(FolderList(mouse),'tailtemperature');
                    
                case 'heartrate'
                    try
                        OutPutVar=ConcatenateDataFromFolders_SB(FolderList(mouse),'heartrate');
                    end
                    
                case 'heartratevar'
                    try
                        OutPutVar=ConcatenateDataFromFolders_SB(FolderList(mouse),'heartratevar');
                    end
                    
                case 'emg'
                    try
                        OutPutVar=ConcatenateDataFromFolders_SB(FolderList(mouse),'emg');
                    end
                    
                case 'instfreq'
                    OutPutVar=ConcatenateDataFromFolders_SB(FolderList(mouse),'instfreq','suffix_instfreq','B');
                    
                case 'instphase'
                    OutPutVar=ConcatenateDataFromFolders_SB(FolderList(mouse),'instphase','suffix_instphase','B');
                    
                case 'respi_freq_bm'
                    OutPutVar=ConcatenateDataFromFolders_SB(FolderList(mouse),'respi_freq_BM');
                    
                case 'ob_gamma_freq'
                    for mouse=1:length(Mouse_names)
                        OutPutVar=ConcatenateDataFromFolders_SB(FolderList(mouse),'ob_gamma_freq');
                    end
                    
                case 'ob_gamma_power'
                    OutPutVar=ConcatenateDataFromFolders_SB(FolderList(mouse),'ob_gamma_power');
                    
                case 'respivar'
                    OutPutVar=ConcatenateDataFromFolders_SB(FolderList(mouse),'respivar');
                    
                case 'ripples'
                    try
                        OutPutVar=ConcatenateDataFromFolders_SB(FolderList(mouse),'ripples');
                    catch
                        keyboard
                    end
                    
                case 'ripples_all'
                    try
                        OutPutVar=ConcatenateDataFromFolders_SB(FolderList(mouse),'ripples_all');
                    catch
                        keyboard
                    end
                    
                case 'ripples_epoch'
                    OutPutVar=ConcatenateDataFromFolders_SB(FolderList(mouse),'ripples_epoch');
                    
                case 'stimepoch2'
                    OutPutVar=ConcatenateDataFromFolders_SB(FolderList(mouse),'epoch','epochname','stimepoch2');
                    
                case 'ripples_meanwaveform'
                    try
                        chan_numb = Get_chan_numb_BM(FolderList(mouse) , 'rip');
                        LFP_rip = ConcatenateDataFromFolders_SB(FolderList(mouse),'lfp','channumber',chan_numb);
                        OutPutVar = ConcatenateDataFromFolders_SB(FolderList(mouse),'ripples');
                        is_there_rip_chan = 1;
                    catch
                        is_there_rip_chan = 0;
                        OutPutVar=NaN;
                    end
                    
                case 'respi_meanwaveform'
                    chan_numb = Get_chan_numb_BM(FolderList(mouse) , 'bulb_deep');
                    LFP_BulbDeep = ConcatenateDataFromFolders_SB(FolderList(mouse),'lfp','channumber',chan_numb);
                    OutPutVar = ConcatenateDataFromFolders_SB(FolderList(mouse),'respi_peak');
                    
                case 'hpc_around_ripples'
                    try
                        Sptsd_dHPC = ConcatenateDataFromFolders_SB(FolderList(mouse),'spectrum','prefix','H_Low');
                        RipplesTimes = ConcatenateDataFromFolders_SB(FolderList(mouse),'ripples');
                        AroundRipples = intervalSet(Range(RipplesTimes)-1e4 , Range(RipplesTimes)+1e4);
                        OutPutVar= Restrict(Sptsd_dHPC , and(Epoch{mouse,1} , AroundRipples));
                        is_there_rip_chan = 1;
                    catch
                        is_there_rip_chan = 0;
                        OutPutVar=NaN;
                    end
                    
                    noise_thr=21;
                    Sp_type=1;
                    
                case 'spindles'
                    OutPutVar=ConcatenateDataFromFolders_SB(FolderList(mouse),'spindles');
                    
                case 'delta'
                    OutPutVar=ConcatenateDataFromFolders_SB(FolderList(mouse),'deltawaves');
                    
                case 'ob_low'
                    OutPutVar=ConcatenateDataFromFolders_SB(FolderList(mouse),'spectrum','prefix','B_Low');
                    
                    noise_thr=12;
                    Sp_type=1;
                    
                case 'ob_middle'
                    OutPutVar=ConcatenateDataFromFolders_SB(FolderList(mouse),'spectrum','prefix','B_Middle');
                    
                    noise_thr=21;
                    Sp_type=4;
                    
                case 'ob_high'
                    OutPutVar=ConcatenateDataFromFolders_SB(FolderList(mouse),'spectrum','prefix','B_High');
                    
                    noise_thr=9;
                    Sp_type=2;
                    
                case 'hpc_low'
                    try
                        OutPutVar=ConcatenateDataFromFolders_SB(FolderList(mouse),'spectrum','prefix','H_Low');
                    catch
                        OutPutVar=NaN;
                    end
                    
                    noise_thr=21;
                    Sp_type=1;
                    
                case 'pfc_low'
                    try
                        OutPutVar=ConcatenateDataFromFolders_SB(FolderList(mouse),'spectrum','prefix','PFCx_Low');
                    catch
                        OutPutVar=NaN;
                    end
                    
                    noise_thr=12; %noise_thr=5; must set threshold if active or sleep, manually for the moment
                    Sp_type=1;
                    
                case 'h_vhigh'
                    try
                        %                         OutPutVar=Restrict(ConcatenateDataFromFolders_SB(FolderList(mouse),'spectrum','prefix','H_VHigh') , ConcatenateDataFromFolders_SB(FolderList(mouse),'ripples_epoch'));
                        OutPutVar=ConcatenateDataFromFolders_SB(FolderList(mouse),'spectrum','prefix','H_VHigh');
                    catch
                        OutPutVar=tsd([],[]);
                    end
                    
                    noise_thr=33;
                    Sp_type=3;
                    
                case 'h_vhigh_extended'
                    try
                        OutPutVar=Restrict(ConcatenateDataFromFolders_SB(FolderList(mouse),'spectrum','prefix','H_VHigh') , ConcatenateDataFromFolders_SB(FolderList(mouse),'ripples_epoch_extended'));
                        %OutPutVar=ConcatenateDataFromFolders_SB(FolderList(mouse),'spectrum','prefix','H_VHigh');
                    catch
                        OutPutVar=tsd([],[]);
                    end
                    
                    noise_thr=33;
                    Sp_type=3;
                    
                case 'ob_high_on_respi_phase_pref'
                    chan_numb = Get_chan_numb_BM(FolderList(mouse) , 'bulb_deep');
                    LFP = ConcatenateDataFromFolders_SB(FolderList(mouse),'lfp','channumber',chan_numb);
                    Spectrogram_to_use = ConcatenateDataFromFolders_SB(FolderList(mouse),'spectrum','prefix','B_Middle');
                    
                case 'hpc_vhigh_on_respi_phase_pref'
                    chan_numb = Get_chan_numb_BM(FolderList(mouse) , 'bulb_deep');
                    LFP = ConcatenateDataFromFolders_SB(FolderList(mouse),'lfp','channumber',chan_numb);
                    try
                        Spectrogram_to_use = ConcatenateDataFromFolders_SB(FolderList(mouse),'spectrum','prefix','H_Vhigh');
                    catch
                        Spectrogram_to_use = tsd([],[]);
                    end
                    
                    
                case 'hpc_vhigh_on_theta_phase_pref'
                    chan_numb = Get_chan_numb_BM(FolderList(mouse) , 'hpc_deep');
                    LFP = ConcatenateDataFromFolders_SB(FolderList(mouse),'lfp','channumber',chan_numb);
                    try
                        Spectrogram_to_use = ConcatenateDataFromFolders_SB(FolderList(mouse),'spectrum','prefix','H_Vhigh');
                    catch
                        Spectrogram_to_use = tsd([],[]);
                    end
                    
                case 'ob_pfc_coherence'
                    try
                        chan_numb1 = Get_chan_numb_BM(FolderList(mouse) , 'bulb_deep');
                        chan_numb2 = Get_chan_numb_BM(FolderList(mouse) , 'pfc_deep');
                        LFP_bulb = ConcatenateDataFromFolders_SB(FolderList(mouse),'lfp','channumber',chan_numb1);
                        LFP_pfc = ConcatenateDataFromFolders_SB(FolderList(mouse),'lfp','channumber',chan_numb2);
                        params.Fs=1/median(diff(Range(LFP_bulb,'s'))); params.tapers=[3 5]; params.fpass=[0.1 20]; params.err=[2,0.05]; params.pad=0; movingwin=[3 0.2];
                        OutPutVar = LFP_bulb;
                    catch
                        OutPutVar = NaN;
                    end
                    
                case 'hpc_pfc_coherence'
                    try
                        chan_numb1 = Get_chan_numb_BM(FolderList(mouse) , 'hpc_deep');
                        chan_numb2 = Get_chan_numb_BM(FolderList(mouse) , 'pfc_deep');
                        LFP_hpc = ConcatenateDataFromFolders_SB(FolderList(mouse),'lfp','channumber',chan_numb1);
                        LFP_pfc = ConcatenateDataFromFolders_SB(FolderList(mouse),'lfp','channumber',chan_numb2);
                        params.Fs=1/median(diff(Range(LFP_hpc,'s'))); params.tapers=[3 5]; params.fpass=[0.1 20]; params.err=[2,0.05]; params.pad=0; movingwin=[3 0.2];
                        OutPutVar = LFP_hpc;
                    catch
                        OutPutVar = NaN;
                    end
                    
                    %% added by SB
                    
                    
                case 'respi_freq_bm_sametps'
                    OutPutVar=ConcatenateDataFromFolders_SB(FolderList(mouse),'respi_freq_BM_sametps');
                    
                case 'heartrate_sametps'
                    OutPutVar=ConcatenateDataFromFolders_SB(FolderList(mouse),'heartrate_sametps');
                    
                case 'heartratevar_sametps'
                    OutPutVar=ConcatenateDataFromFolders_SB(FolderList(mouse),'heartratevar_sametps');
                    
                case 'ob_high_sametps'
                    OutPutVar=ConcatenateDataFromFolders_SB(FolderList(mouse),'ob_high_sametps');
                    
                case 'ripples_density'
                    OutPutVar=ConcatenateDataFromFolders_SB(FolderList(mouse),'ripples_density');
                    
                case 'ob_high_freq_sametps'
                    OutPutVar=ConcatenateDataFromFolders_SB(FolderList(mouse),'ob_high_freq_sametps');
                    
                case 'accelero_sametps'
                    OutPutVar=ConcatenateDataFromFolders_SB(FolderList(mouse),'accelero_sametps');
                    
                case 'hpc_lowtheta_samteps'
                    OutPutVar=ConcatenateDataFromFolders_SB(FolderList(mouse),'hpc_lowtheta_samteps');
                    
                case 'linpos_sampetps'
                    OutPutVar=ConcatenateDataFromFolders_SB(FolderList(mouse),'linpos_sampetps');
                    
            end
            
            
            % gathering data
            for ep =1:3
                for epo =1:8
                    
                    if convertCharsToStrings(varargin{i}) == 'ripples_meanwaveform'                                     % exception for mean riplles waveform
                        if is_there_rip_chan == 0
                            OutPutData.(varargin{i})(mouse,ep,epo,:)=NaN(1,1,1001);
                        else
                            Ripples_times_OnEpoch = Restrict(OutPutVar , Epoch{mouse,ep,epo});
                            ripples_time = Range(Ripples_times_OnEpoch,'s');
                            [~,T_pre] = PlotRipRaw(LFP_rip, ripples_time, 400, 0, 0);
                            if isnan(nanmean(T_pre))
                                OutPutData.(varargin{i})(mouse,ep,epo,:)=NaN(1,1001);
                            else
                                try
                                    OutPutData.(varargin{i})(mouse,ep,epo,:) = nanmean(T_pre);
                                catch
                                    OutPutData.(varargin{i})(mouse,ep,epo,:) = [nanmean(T_pre) NaN];
                                end
                            end
                        end
                        
                        
                    elseif convertCharsToStrings(varargin{i}) == 'respi_meanwaveform'                                     % exception for mean riplles waveform
                        
                        Peaks_times_OnEpoch = Restrict(OutPutVar , Epoch{mouse,ep,epo});
                        Peaks_time = Range(Peaks_times_OnEpoch,'s');
                        [M_pre,T_pre] = PlotRipRaw(LFP_BulbDeep, Peaks_time, 300, 0, 0);
                        if isnan(nanmean(T_pre));
                            OutPutData.(varargin{i})(mouse,ep,epo,:)=NaN(1,751);
                        else
                            OutPutData.(varargin{i})(mouse,ep,epo,:) = nanmean(T_pre);
                        end
                        
                        
                    elseif or(or(convertCharsToStrings(varargin{i}) == 'ob_high_on_respi_phase_pref' , convertCharsToStrings(varargin{i}) == 'hpc_vhigh_on_respi_phase_pref'),convertCharsToStrings(varargin{i}) == 'hpc_vhigh_on_theta_phase_pref')   % exception for phase preference
                        LFP_to_use = Restrict(LFP , Epoch{mouse,ep,epo});
                        Spectro_to_use = Restrict(Spectrogram_to_use , Epoch{mouse,ep,epo});
                        if length(Spectro_to_use)>0
                            try
                                if convertCharsToStrings(varargin{i}) == 'ob_high_on_respi_phase_pref'
                                    [P,f,VBinnedPhase] = PrefPhaseSpectrum(LFP_to_use , Data(Spectro_to_use) , Range(Spectro_to_use,'s') , range_Middle , [1 7] , 30); close
                                elseif convertCharsToStrings(varargin{i}) == 'hpc_vhigh_on_respi_phase_pref'
                                    try
                                        [P,f,VBinnedPhase] = PrefPhaseSpectrum(LFP_to_use , Data(Spectro_to_use) , Range(Spectro_to_use,'s') , range_VHigh , [1 7] , 30); close
                                    catch
                                        P=NaN; f=NaN; VBinnedPhase=NaN;
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
                        OutPutData.(varargin{i}).PhasePref{mouse,ep,epo} = P;
                        OutPutData.(varargin{i}).Frequency = f;
                        OutPutData.(varargin{i}).BinnedPhase = VBinnedPhase;
                        OutPutVar = LFP_to_use;
                        
                    elseif convertCharsToStrings(varargin{i}) == 'ob_pfc_coherence'
                        try
                            [Ctemp,phi,S12,S1temp,S2temp,t,f,confC,phitemp,Cerr]=cohgramc( Data(Restrict(LFP_bulb , Epoch{mouse,ep,epo})) , Data(Restrict(LFP_pfc , Epoch{mouse,ep,epo})) , movingwin , params);
                            OutPutData.(varargin{i}).mean(mouse,ep,epo,:) = nanmean(Ctemp);
                        end
                        
                    elseif convertCharsToStrings(varargin{i}) == 'hpc_pfc_coherence'
                        try
                            [Ctemp,phi,S12,S1temp,S2temp,t,f,confC,phitemp,Cerr]=cohgramc( Data(Restrict(LFP_hpc , Epoch{mouse,ep,epo})) , Data(Restrict(LFP_pfc , Epoch{mouse,ep,epo})) , movingwin , params);
                            OutPutData.(varargin{i}).mean(mouse,ep,epo,:) = nanmean(Ctemp);
                        end
                        
                    elseif convertCharsToStrings(varargin{i}) == 'ripples_all'
                        try
                            OutPutData.(varargin{i}).tsd{mouse,ep,epo}=Restrict(OutPutVar , Epoch{mouse,ep,epo});
                        end
                        
                    else
                        dimensions=size(OutPutVar);
                        if dimensions(2)==1 % Spectro or not
                            % not spectro
                            b=convertCharsToStrings(class(OutPutVar));
                            if b=='ts'
                                OutPutData.(varargin{i}).mean(mouse,ep,epo)=length(Restrict(OutPutVar , Epoch{mouse,ep,epo})) / (sum(Stop(Epoch{mouse,ep,epo}) - Start(Epoch{mouse,ep,epo}))/1e4);
                                OutPutData.(varargin{i}).ts{mouse,ep,epo}=Restrict(OutPutVar , Epoch{mouse,ep,epo}) ;
                            elseif b=='intervalSet'
                                OutPutData.(varargin{i}).proportion(mouse,ep,epo)=  (sum(Stop(and(OutPutVar , Epoch{mouse,ep,epo})) - Start(and(OutPutVar , Epoch{mouse,ep,epo})))/1e4) / (sum(Stop(Epoch{mouse,ep,epo}) - Start(Epoch{mouse,ep,epo}))/1e4);
                                OutPutData.(varargin{i}).density(mouse,ep,epo)= length(Start(and(OutPutVar , Epoch{mouse,ep,epo}))) / (sum(Stop(Epoch{mouse,ep,epo}) - Start(Epoch{mouse,ep,epo}))/1e4);
                                OutPutData.(varargin{i}).epoch(mouse,ep,epo)= and(OutPutVar , Epoch{mouse,ep,epo});
                            else % tsd data
                                try
                                    OutPutData.(varargin{i}).mean(mouse,ep,epo)=nanmean(Data(Restrict(OutPutVar , Epoch{mouse,ep,epo})));
                                    OutPutData.(varargin{i}).tsd{mouse,ep,epo}=Restrict(OutPutVar , Epoch{mouse,ep,epo});
                                end
                            end
                            
                            % spectro
                        elseif dimensions(2)>1
                            % little correction for old low spectrums
                            if size(Data(OutPutVar),2)==263
                                R=Range(OutPutVar);
                                D=Data(OutPutVar);
                                OutPutVar = tsd(R , D(:,3:end));
                            end
                            
                            MeanSpectrum = nanmean(Data(Restrict(OutPutVar , Epoch{mouse,ep,epo})));
                            try
                                [ OutPutData.(varargin{i}).power(mouse,ep,epo) , OutPutData.(varargin{i}).max_freq(mouse,ep,epo) ] = max( MeanSpectrum(noise_thr:end ) );
                                %                             if OutPutData.(varargin{i}).max_freq(mouse,ep,epo)==noise_thr
                                %                             OutPutData.(varargin{i}).max_freq(mouse,ep,epo)=NaN
                                %                             end
                                
                                if Sp_type==1 % Low spectrum
                                    
                                    OutPutData.(varargin{i}).max_freq(mouse,ep,epo) = range_Low(OutPutData.(varargin{i}).max_freq(mouse,ep,epo) + noise_thr-1);
                                    OutPutData.(varargin{i}).mean(mouse,ep,epo,:) = nanmean(Data(Restrict(OutPutVar , Epoch{mouse,ep,epo})));
                                    %                                 OutPutData.(varargin{i}).spectrogram{mouse,ep,epo}=Restrict(OutPutVar , Epoch{mouse,ep,epo});
                                elseif Sp_type==2 % High spectrum
                                    OutPutData.(varargin{i}).mean(mouse,ep,epo,:) = nanmean(Data(Restrict(OutPutVar , Epoch{mouse,ep,epo})));
                                    OutPutData.(varargin{i}).max_freq(mouse,ep,epo) = range_High(OutPutData.(varargin{i}).max_freq(mouse,ep,epo) + noise_thr-1);
                                elseif Sp_type==3 % VHigh spectrum
                                    OutPutData.(varargin{i}).max_freq(mouse,ep,epo) = range_VHigh(OutPutData.(varargin{i}).max_freq(mouse,ep,epo) + noise_thr-1);
                                    OutPutData.(varargin{i}).mean(mouse,ep,epo,:) = nanmean(Data(Restrict(OutPutVar , Epoch{mouse,ep,epo})));
                                    %                                 OutPutData.(varargin{i}).spectrogram{mouse,ep,epo}=Restrict(OutPutVar , Epoch{mouse,ep,epo});
                                elseif Sp_type==4 % Middle spectrum
                                    OutPutData.(varargin{i}).max_freq(mouse,ep,epo) = range_Middle(OutPutData.(varargin{i}).max_freq(mouse,ep,epo) + noise_thr-1);
                                    OutPutData.(varargin{i}).mean(mouse,ep,epo,:) = nanmean(Data(Restrict(OutPutVar , Epoch{mouse,ep,epo})));
                                end
                                %OutPutData.(varargin{i}).norm(mouse,ep,epo,:) = nanmean(zscore_nan_BM(Data(Restrict(OutPutVar , Epoch{mouse,ep,epo}))')');
                                %OutPutData.(varargin{i}).tsd{mouse,states,:} = Restrict(OutPutVar , Epoch{mouse,ep,epo});
                                
                            catch
                                try
                                    OutPutData.(varargin{i}).power(mouse,ep,epo) = NaN;
                                    OutPutData.(varargin{i}).mean(mouse,ep,epo,:) = NaN(1,length(range_VHigh));
                                    OutPutData.(varargin{i}).max_freq(mouse,ep,epo) = NaN;
                                catch
                                    keyboard
                                end
                            end
                        end
                    end
                    OutPutTSD.(varargin{i}){mouse} = OutPutVar; % SB chnaged from  OutPutTSD.(varargin{i}){i,mouse} = OutPutVar;
                    disp(mouse)
                end
            end
        end
        
    end
end






