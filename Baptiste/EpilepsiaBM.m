


GetEmbReactMiceFolderList_BM


for group=[16 13]%1:length(Drug_Group)
    Mouse=Drugs_Groups_UMaze_BM(group);
    for mouse=1:length(Mouse)
        Mouse_names{mouse}=['M' num2str(Mouse(mouse))];
        
        try
            chan = Get_chan_numb_BM(CondSess.(Mouse_names{mouse}){1},'rip');
        catch
            try
                chan = Get_chan_numb_BM(CondSess.(Mouse_names{mouse}){1},'hpc_deep');
            catch
                chan = Get_chan_numb_BM(CondSess.(Mouse_names{mouse}){1},'bulb_deep');
            end
        end
        LFP_rip.(Mouse_names{mouse}) = ConcatenateDataFromFolders_SB(CondSess.(Mouse_names{mouse}),'lfp','channumber',chan);
        try
            HPC_Sptsd.(Mouse_names{mouse}) = ConcatenateDataFromFolders_SB(CondSess.(Mouse_names{mouse}),'spectrum','prefix','H_Low');
        catch
            HPC_Sptsd.(Mouse_names{mouse}) = ConcatenateDataFromFolders_SB(CondSess.(Mouse_names{mouse}),'spectrum','prefix','B_Low');
        end
        EyelidEpoch.(Mouse_names{mouse}) = ConcatenateDataFromFolders_SB(CondSess.(Mouse_names{mouse}),'epoch','epochname','stimepoch');
        try; VHCStimEpoch.(Mouse_names{mouse}) = ConcatenateDataFromFolders_SB(CondSess.(Mouse_names{mouse}),'epoch','epochname','vhc_stim'); end
        Ripples.(Mouse_names{mouse}) = ConcatenateDataFromFolders_SB(CondSess.(Mouse_names{mouse}),'ripples');
        
        disp(Mouse_names{mouse})
    end
end


% Mouse = [1266,1268,1267,1269,1304,1305,1350,1351,1352 ,1349 , 1377,...
%     41266,41268,41269,41305,41349,41350,41351,41352,1376,1385,1386,...
%     1144,1146,1147,1170,1171,9184,1189,9205,1251,1253,1254,1391,1392,1393,1394,...
%     11147,11184,11189,11200,11204,11205,11206,11207,11251,11252,11253,11254];

Mouse = [1266,1268,1267,1269,1304,1305,1350,1351,1352 ,1349 , 1377,...
    41266,41268,41269,41305,41349,41350,41351,41352,1376,1385,1386];

for mouse=1:length(Mouse)
    Mouse_names{mouse}=['M' num2str(Mouse(mouse))];
    
    AroundEyelid.(Mouse_names{mouse}) = intervalSet(Start(EyelidEpoch.(Mouse_names{mouse})) , Stop(EyelidEpoch.(Mouse_names{mouse}))+1e3);
    try
        AroundVHC.(Mouse_names{mouse}) = intervalSet(Start(VHCStimEpoch.(Mouse_names{mouse})) , Stop(VHCStimEpoch.(Mouse_names{mouse}))+1e3);
        NoiseEpoch.(Mouse_names{mouse}) = or(AroundEyelid.(Mouse_names{mouse}) , AroundVHC.(Mouse_names{mouse}));
    catch
        NoiseEpoch.(Mouse_names{mouse}) = AroundEyelid.(Mouse_names{mouse});
    end
    LFP_rip_nonoise.(Mouse_names{mouse}) = Restrict(LFP_rip.(Mouse_names{mouse})  , intervalSet(0 , max(Range(LFP_rip.(Mouse_names{mouse}))))  -  NoiseEpoch.(Mouse_names{mouse}));
    Low_Passed_LFP.(Mouse_names{mouse}) = real(LowPassFilter(Data(LFP_rip_nonoise.(Mouse_names{mouse})) , 2 , 1250)) ;
    Low_Passed_LFP_TSD.(Mouse_names{mouse}) = tsd(Range(LFP_rip_nonoise.(Mouse_names{mouse})) , Low_Passed_LFP.(Mouse_names{mouse}));
    Enveloppe.(Mouse_names{mouse}) = envelope(Data(Low_Passed_LFP_TSD.(Mouse_names{mouse})) , 1e3 , 'rms');
    [HighPassed_LFP_rip, ~ ] = HighPassFilter_BM(Data(LFP_rip_nonoise.(Mouse_names{mouse})) , 8, 1250 );
    HighPassed_LFP_rip = tsd(Range(LFP_rip_nonoise.(Mouse_names{mouse})) , HighPassed_LFP_rip);
    DetectStim_tsd.(Mouse_names{mouse}) = tsd(Range(LFP_rip_nonoise.(Mouse_names{mouse})) , abs(Data(HighPassed_LFP_rip)));
    %        DetectStim2_tsd.(Mouse_names{mouse}) = real(LowPassFilter(Data(DetectStim_tsd.(Mouse_names{mouse})) , 1 , 1250)) ;
    Theta.(Mouse_names{mouse}) = real(LowPassFilter(Data(LFP_rip_nonoise.(Mouse_names{mouse})) ,12 , 1250)) ;
    Theta2.(Mouse_names{mouse}) = real(HighPassFilter_BM(Data(LFP_rip_nonoise.(Mouse_names{mouse})) ,5 , 1250)) ;
    EnveloppeTheta.(Mouse_names{mouse}) = envelope(Theta2.(Mouse_names{mouse}) , 250 , 'rms');
    EnveloppeTheta_tsd.(Mouse_names{mouse}) = tsd(Range(LFP_rip_nonoise) , EnveloppeTheta.(Mouse_names{mouse}));
    
    disp(Mouse_names{mouse})
end



figure
for mouse=1:length(Mouse)
    
    subplot(311)
    plot(Range(DetectStim_tsd.(Mouse_names{mouse}))  , runmean(Data(DetectStim_tsd.(Mouse_names{mouse})),100))
    hold on
    line([Start(EyelidEpoch.(Mouse_names{mouse})) Start(EyelidEpoch.(Mouse_names{mouse}))],[0 1e3], 'LineWidth' , 1 , 'Color' , 'r');
    ylim([0 1e3]), xlim([0 max(Range(DetectStim_tsd.(Mouse_names{mouse})))])
    title('High passed LFP, absolute value')
    
    subplot(312)
    imagesc(Data(HPC_Sptsd.(Mouse_names{mouse}))'); axis xy; caxis([0 4e4]), colormap jet
    title('H Low spectrum')
    
    subplot(313)
    plot(Range(EnveloppeTheta_tsd.(Mouse_names{mouse})) , runmean(Data(EnveloppeTheta_tsd.(Mouse_names{mouse})),100))
    line([Start(EyelidEpoch.(Mouse_names{mouse})) Start(EyelidEpoch.(Mouse_names{mouse}))],[0 1e3], 'LineWidth' , 1 , 'Color' , 'r');
    ylim([0 1e3]),  xlim([0 max(Range(EnveloppeTheta_tsd.(Mouse_names{mouse})))])
    title('Theta enveloppe')
    
    sgtitle(Mouse_names{mouse})
    keyboard
    clf
    
end

figure
plot(Range(LFP_rip_nonoise.(Mouse_names{mouse})) , abs(runmean(Data(LFP_rip_nonoise.(Mouse_names{mouse})),1000)))
ylim([0 2e3])
