

%% Gamma & DZP

Cols = {[1 0.5 0.5],[0.5 0.5 1]};
X = [1,2];
Legends = {'Shock','Safe'};

cd('/media/nas4/ProjetEmbReact/Mouse688/20180209/ProjectEmbReact_M688_20180209_TestPre_PreDrug/TestPre2')
load('H_Low_Spectrum.mat'); RangeLow=Spectro{3};
load('B_Middle_Spectrum.mat'); RangeMiddle=Spectro{3};
load('B_High_Spectrum.mat'); RangeHigh=Spectro{3};
load('H_VHigh_Spectrum.mat'); RangeVHigh=Spectro{3};
Session_type={'Cond','TestPre'};
Drug_Group = {'Saline','Diazepam'};

Mouse=[1170,1189,1251,1253,1254 , 11207,11251,11252,11253,11254];
Mouse=[1254 , 11254];
for sess=1:length(Session_type) % generate all data required for analyses
    [OutPutData.(Session_type{sess}) , Epoch.(Session_type{sess}) , NameEpoch] = MeanValuesPhysiologicalParameters_BM(Mouse,lower(Session_type{sess}),'hpc_vhigh_on_theta_phase_pref');
end
State=NameEpoch;

for sess=1:length(Session_type) % generate all data required for analyses
    for group=1:2
        if group==1
            ind=[1:5];
        else
            ind=[6:10];
        end
        for mouse=ind
            for state=1:length(State)
                try
                    PhasePref.(Session_type{sess}).(Drug_Group{group})(mouse,state,:,:) = OutPutData.(Session_type{sess}).hpc_vhigh_on_theta_phase_pref.PhasePref{mouse, state};
                end
            end
        end
    end
end

for group=1:2
    for state=1:length(State)
        PhasePref_Averaged.(Session_type{sess}).(Drug_Group{group})(state,:,:) = squeeze(nanmean(PhasePref.(Session_type{sess}).(Drug_Group{group})(:,state,:,:),1));
    end
end


for state=1:length(State)
    try
        figure
        subplot(121)
        A = interp2_BM(squeeze(PhasePref_Averaged.Saline(state,:,:)));
        imagesc([1:620] , linspace(20,250,940) , SmoothDec([linspace(20,250,940)'.*A' linspace(20,250,940)'.*A'],1.5)); axis xy; colormap jet
        xticks([0 310 620]); xticklabels({'0','2pi','4pi'}); ylabel('Frequency (Hz)'); caxis([2e3 4e4])
        subplot(122)
        B = interp2_BM(squeeze(PhasePref_Averaged.Diazepam(state,:,:)));
        imagesc([1:620] , linspace(20,250,940) , SmoothDec([linspace(20,250,940)'.*B' linspace(20,250,940)'.*B'],.7)); axis xy; colormap jet
        xticks([0 310 620]); xticklabels({'0','2pi','4pi'}); caxis([2e3 4e4])
    end
end



caxis([2e3 6e4])






%% 1254/11254

load('H_VHigh_Spectrum.mat')
range_VHigh = Spectro{3};

LFP = ConcatenateDataFromFolders_SB({'/media/nas6/ProjetEmbReact/Mouse1227/20210730'},'lfp','channumber',23);
Spectrogram_to_use = ConcatenateDataFromFolders_SB({'/media/nas6/ProjetEmbReact/Mouse1227/20210730'},'spectrum','prefix','H_Vhigh');

SleepInfo.Injection_time = 1.741e8;

DZP_Epoch{1} = intervalSet(0 , SleepInfo.Injection_time-80e4);
DZP_Epoch{2} = intervalSet(SleepInfo.Injection_time , SleepInfo.Injection_time+5400*1e4);
DZP_Epoch{3} = intervalSet(SleepInfo.Injection_time+5400*1e4 , max(Range(MovAcctsd)));

States1={'BeforeInj','OneHourAft','AfterInj'};
States2={'Wake','NREM','REM'};

for states1=1:3
    for states2=1:3
        if states2==1
            Epoch_to_use = Wake;
        elseif states2==2
            Epoch_to_use = SWSEpoch;
        else
            Epoch_to_use = REMEpoch;
        end
        
        LFP2.(States1{states1}).(States2{states2}) = Restrict(LFP , and(Epoch_to_use , DZP_Epoch{states1}));
        Spectrogram_to_use2.(States1{states1}).(States2{states2}) = Restrict(Spectrogram_to_use , and(Epoch_to_use , DZP_Epoch{states1}));
        
    end
end

for states1=1:3
    for states2=1:3
        
        [P.(States1{states1}).(States2{states2}),f,VBinnedPhase] = PrefPhaseSpectrum(LFP2.(States1{states1}).(States2{states2}) , Data(Spectrogram_to_use2.(States1{states1}).(States2{states2})) , Range(Spectrogram_to_use2.(States1{states1}).(States2{states2}),'s') , range_VHigh , [3 10] , 30); close
        
    end
end


figure
for states1=1:3
    for states2=1:3
        
        subplot(3,3,(states2-1)*3+states1)
        imagesc([VBinnedPhase VBinnedPhase] , f , [(f.*P.(States1{states1}).(States2{states2}))'  (f.*P.(States1{states1}).(States2{states2}))']); axis xy
        caxis([2e3 8e4])
        if states2==1; title(States1{states1}); end
        if states1==1; ylabel('Frequency (Hz)'); u=text(-80,100,States2{states2}); set(u,'FontSize',20,'FontWeight','bold','Rotation',90); end 
        xticks([0 178 356]); xticklabels({'0','2π','4π'})
        if states2==3; xlabel('Phase (rad)'); end 
        if or(states2==1 , states2==3); hline(51,'-k'); end
        if states2==2; hline(149,'-k'); end
        
    end
end
colormap jet




