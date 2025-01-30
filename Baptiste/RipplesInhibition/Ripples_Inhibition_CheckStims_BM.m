
function Ripples_Inhibition_CheckStims_BM(FolderList,manual)

for sess=1:length(FolderList)
    cd(FolderList{sess})
    
    try; chan_numb = Get_chan_numb_BM(FolderList{sess} , 'rip'); end
    load(['LFPData/LFP' num2str(chan_numb) '.mat'])
    tpsmax = max(Range(LFP)); % use LFP to get precise end time
    TotalEpoch = intervalSet(0,max(Range(LFP)));
    try
        load('behavResources_SB.mat','TTLInfo')
        TotalEpochWithoutStim = TotalEpoch-TTLInfo.StimEpoch;
    catch
        TotalEpochWithoutStim = TotalEpoch;
    end
    
    % Detecting stims on high passed LFP without eyelid stims
    [HighPassed_LFP_rip, ~ ] = HighPassFilter_BM(Data(LFP) , 8, 1250 );
    HighPassed_LFP_rip = tsd(Range(LFP) , HighPassed_LFP_rip);
    DetectStim_tsd = tsd(Range(Restrict(LFP , TotalEpochWithoutStim)) , abs(Data(Restrict(HighPassed_LFP_rip , TotalEpochWithoutStim))));
    
    % Defining an epoch depend on how stims were influencing sinal amplitude
    thr = max(abs(Data(Restrict(HighPassed_LFP_rip , TotalEpochWithoutStim))))/4;
    VHC_StimEpoch = thresholdIntervals(DetectStim_tsd , thr);
    VHC_StimEpoch = mergeCloseIntervals(VHC_StimEpoch,.3e4); % avoid analysis of repeated stims
    
    if manual==1
        thr
        clf;
        plot(Range(DetectStim_tsd,'s') , Data(DetectStim_tsd))
        hold on
        plot(Start(VHC_StimEpoch)/1e4 , 1.2e4 , '*r')
        
        disp('threshold is good ?')
        in=input('happy? 1/0 ');
        while in~=1
            New_thr=input('select your threshold ');
            VHC_StimEpoch = thresholdIntervals(DetectStim_tsd , New_thr);
            VHC_StimEpoch = mergeCloseIntervals(VHC_StimEpoch,.15e4); % avoid analysis of repeated stims
            
            clf;
            plot(Range(DetectStim_tsd,'s') , Data(DetectStim_tsd))
            hold on
            plot(Start(VHC_StimEpoch)/1e4 , 1.2e4 , '*r')
            
            disp('threshold is good ?')
            in=input('happy? 1/0 ');
        end
    end
    
    % correct epoch to find not start put right time of stim 
    for i=1:length(Start(VHC_StimEpoch))
        [~,ind] = max(Data(Restrict(DetectStim_tsd , subset(VHC_StimEpoch,i))));
        Rg = Range(Restrict(DetectStim_tsd , subset(VHC_StimEpoch,i)));
        Right_Time_Start(i) = Rg(ind)-2; % -.2ms before stim
        Right_Time_Stop(i) = Rg(ind)+2; % +.2ms after stim
    end
    
        
    TTLInfo.VHC_Stim_Epoch = intervalSet(Right_Time_Start , Right_Time_Stop);
    try
        save('behavResources_SB.mat','TTLInfo','-append')
    catch
        save('behavResources_SB.mat','TTLInfo')
    end
end
end






