
% ------------ 394 ------------
Dir{3,1}='/media/DataMOBsRAIDN/ProjetNREM/Mouse394/20160906';
Dir{3,2}='/media/DataMOBsRAIDN/ProjetNREM/Mouse394/20160906-night';

% ------------ 400 ------------
Dir{5,1}='/media/DataMOBsRAIDN/ProjetNREM/Mouse400/20160913';
Dir{5,2}='/media/DataMOBsRAIDN/ProjetNREM/Mouse400/20160913-night';

% ------------ 403 ------------
Dir{6,1}='/media/DataMOBsRAIDN/ProjetNREM/Mouse403/20160913';
Dir{6,2}='/media/DataMOBsRAIDN/ProjetNREM/Mouse403/20160913-night';

% ------------ 450 ------------
Dir{7,1}='/media/DataMOBsRAIDN/ProjetNREM/Mouse450/20160913';
Dir{7,2}='/media/DataMOBsRAIDN/ProjetNREM/Mouse450/20160913-night';

% ------------ 451 ------------
Dir{8,1}='/media/DataMOBsRAIDN/ProjetNREM/Mouse451/20160913';
Dir{8,2}='/media/DataMOBsRAIDN/ProjetNREM/Mouse451/20160913-night';

for mm=[3,5,6,7,8]


    
end


%% Get the spectra
for mm=3:8
    for d=1:2
        cd(Dir{2,1})
        try
            load('ChannelsToAnalyse/dHPC_deep.mat')
            chH=channel;
        catch
            try
                load('ChannelsToAnalyse/dHPC_rip.mat')
                chH=channel;
            catch
                chH=input('please give hippocampus channel for theta ');
            end
        end
        
        try
            load('ChannelsToAnalyse/Bulb_deep.mat')
            chB=channel;
        catch
            chB=input('please give olfactory bulb channel ');
        end
        
        
        HighSpectrum([cd, filesep],chB,'B');
        disp('Bulb Spectrum done')
        LowSpectrumSB([cd, filesep],chH,'H');
        disp('Hpc spectrum done')
        
    end
end

mindur=3; %abs cut off for events;
ThetaI=[3 3]; %merge and drop
mw_dur=5; %max length of microarousal
sl_dur=15; %min duration of sleep around microarousal
ms_dur=10; % max length of microsleep
wa_dur=20; %min duration of wake around microsleep


%% Step 2 - Theta and Gamma Epochs from Spectra
for mm=3:8
    for d=1:2
        try
        clear Epoch TotalNoiseEpoch TotalEpoch
        cd(Dir{mm,d})
        load('ChannelsToAnalyse/Bulb_deep.mat')
        chB=channel;
        filename=cd;
        if filename(end)~='/'
            filename(end+1)='/';
        end
        res=pwd;
        
        load StateEpoch
        load([res,'/LFPData/LFP',num2str(channel)]);
        
        r=Range(LFP);
        TotalEpoch=intervalSet(0*1e4,r(end));
        Epoch=TotalEpoch-TotalNoiseEpoch;
        save('StateEpochSB.mat','NoiseEpoch','GndNoiseEpoch','TotalNoiseEpoch','Epoch')
        ThreshEpoch=TotalEpoch;
        
        TotalEpoch=and(TotalEpoch,Epoch);
        TotalEpoch=CleanUpEpoch(TotalEpoch);
        ThreshEpoch=and(ThreshEpoch,Epoch);
        ThreshEpoch=CleanUpEpoch(ThreshEpoch);
        
        smootime=3;
        load(strcat('LFPData/LFP',num2str(chB),'.mat'));
        
        % find gamma epochs
        disp(' ');
        disp('... Creating Gamma Epochs ');
        FilGamma=FilterLFP(LFP,[50 70],1024);
        HilGamma=hilbert(Data(FilGamma));
        H=abs(HilGamma);
        tot_ghi=Restrict(tsd(Range(LFP),H),Epoch);
        smooth_ghi=tsd(Range(tot_ghi),runmean(Data(tot_ghi),ceil(smootime/median(diff(Range(tot_ghi,'s'))))));
        save('StateEpochSB.mat','smooth_ghi','-append')
        catch
          mm
          d
        end
    end
end

close all
for mm=7:8
    clear Gamma TotEpoch gamma_threshAll
    try
        for d=1:2
            clear Epoch TotalNoiseEpoch TotalEpoch smooth_ghi
            cd(Dir{mm,d})
            load('StateEpochSB.mat')
            sm_ghi=Data(smooth_ghi);
            gamma_threshAll{d}=GetGammaThresh(sm_ghi);
            gamma_threshAll{d}=exp(gamma_threshAll{d});
            Gamma{d}=smooth_ghi;
            TotEpoch{d}=and(intervalSet(0,max(Range(smooth_ghi))),Epoch);
            gamma_thresh=gamma_threshAll{d};
            save('StateEpochSB.mat','smooth_ghi','gamma_thresh','-append')
        end
        
        for d=1:2
            for dd=1:2
                sleepper{d,dd}=thresholdIntervals(Gamma{d},gamma_threshAll{dd},'Direction','Below');
                sleepper{d,dd}=mergeCloseIntervals(sleepper{d,dd},mindur*1e4);
                sleepper{d,dd}=dropShortIntervals(sleepper{d,dd},mindur*1e4);
                sleepper{d,dd}=and(TotEpoch{d},sleepper{d,dd});
                wakeper{d,dd}=TotEpoch{d}-sleepper{d,dd};
            end
        end
        
        fig=figure;
        nhist({log(Data(Gamma{1})),log(Data(Gamma{2}))})
        AgreePer=or(and(wakeper{1,2},wakeper{1,1}),and(sleepper{1,2},sleepper{1,1}));
        TotPer=or(wakeper{1,1},sleepper{1,1});
        CorrVal(mm,1)=length(Data(Restrict(smooth_ghi,AgreePer)))./length(Data(Restrict(smooth_ghi,TotPer)));
        AgreePer=or(and(wakeper{2,1},wakeper{2,2}),and(sleepper{2,1},sleepper{2,2}));
        TotPer=or(wakeper{2,2},sleepper{2,2});
        CorrVal(mm,2)=length(Data(Restrict(smooth_ghi,AgreePer)))./length(Data(Restrict(smooth_ghi,TotPer)));
        title(num2str(CorrVal(mm,:)))
        saveas(fig,['/media/DataMOBSSlSc/SleepScoringMice/NightVsDay/MouseDayNightComp',num2str(mm),'.png'])
        saveas(fig,['/media/DataMOBSSlSc/SleepScoringMice/NightVsDay/MouseDayNightComp',num2str(mm),'.fig'])
    end
end