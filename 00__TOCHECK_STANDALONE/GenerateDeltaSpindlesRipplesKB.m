function GenerateDeltaSpindlesRipplesKB(Epoch)

% inputs:
% res (optional) = path

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%% INITIALIZATION
erasePreviousAnalysis=0;
keyboardIfProblem=0;

    res=pwd;



disp(' ')
disp([res,'/StateEpochSB.mat'])

try
    Epoch;
catch
tempLoad=load([res,'/StateEpochSB.mat'],'SWSEpoch');
Epoch=tempLoad.SWSEpoch;
end


%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%% FIND DELTA WAVES
disp(' ')
disp('   ________ FIND DELTA WAVES ________ ')

% ------------------ Parietal Cortex --------------------------------------
try
    clear tempLoad
    tempLoad=load([res,'/DeltaPaCx.mat'],'tDeltaT2','DeltaEpoch');
    tempLoad.tDeltaT2;
    tempLoad.DeltaEpoch;
    clear tempLoad
    if erasePreviousAnalysis
        error;
    else
        disp('DeltaPaCx.mat already exists... skipping...')
    end
catch

    disp('detecting DeltaPaCx...')
    try
        cd(res)
        [tDeltaT2,tDeltaP2,DeltaEpoch]=FindDeltaWavesChan('PaCx',Epoch);

        save([res,'/DeltaPaCx.mat'],'tDeltaT2','tDeltaP2','DeltaEpoch')
        clear tDeltaT2 tDeltaP2 DeltaEpoch
        disp('   -> Done')
    catch
        disp('   -> problem'); if keyboardIfProblem, keyboard;end
    end
end

% ------------------ Prefrontal Cortex ------------------------------------
try
    clear tempLoad
    tempLoad=load([res,'/DeltaPFCx.mat'],'tDeltaT2','DeltaEpoch');
    tempLoad.tDeltaT2;
    tempLoad.DeltaEpoch;

    clear tempLoad
    if erasePreviousAnalysis
        error;
    else
        disp('DeltaPFCx.mat already exists... skipping...')
    end
catch

    disp('detecting DeltaPFCx...')
    try
        cd(res)
        [tDeltaT2,tDeltaP2,DeltaEpoch]=FindDeltaWavesChan('PFCx',Epoch);

        save([res,'/DeltaPFCx.mat'],'tDeltaT2','tDeltaP2','DeltaEpoch')
        clear tDeltaT2 tDeltaP2 DeltaEpoch
        disp('   -> Done')
    catch
        disp('   -> problem');if keyboardIfProblem, keyboard;end
    end
end



% ------------------ Motor Cortex ------------------------------------
try
    clear tempLoad
    tempLoad=load([res,'/DeltaMoCx.mat'],'tDeltaT2','DeltaEpoch');
    tempLoad.tDeltaT2;
    tempLoad.DeltaEpoch;

    clear tempLoad
    if erasePreviousAnalysis
        error;
    else
        disp('DeltaMoCx.mat already exists... skipping...')
    end
catch

    disp('detecting DeltaMoCx...')
    try
        cd(res)
        [tDeltaT2,tDeltaP2,DeltaEpoch]=FindDeltaWavesChan('MoCx',Epoch);

        save([res,'/DeltaMoCx.mat'],'tDeltaT2','tDeltaP2','DeltaEpoch')
        clear tDeltaT2 tDeltaP2 DeltaEpoch
        disp('   -> Done')
    catch
        disp('   -> problem');if keyboardIfProblem, keyboard;end
    end
end



%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%% FIND RIPPLES
disp(' ')
disp('   ________ FIND RIPPLES ________ ')

try
    clear tempLoad
    tempLoad=load([res,'/RipplesdHPC25.mat'],'dHPCrip');
    tempLoad.dHPCrip;

    clear tempLoad
    if erasePreviousAnalysis
        error;
    else
        disp('RipplesdHPC.mat already exists... skipping...')
    end
catch

    disp('detecting RipplesdHPC...')
    try
        cd(res)
        tempchHPC=load([res,'/ChannelsToAnalyse/dHPC_deep.mat'],'channel');
        chHPC=tempchHPC.channel;
        if isempty(chHPC)
            disp('No dHPC channel!!! skipping...')
        else
            eval(['tempLoad=load([res,''/LFPData/LFP',num2str(chHPC),'.mat''],''LFP'');'])
            eegRip=tempLoad.LFP;

            [dHPCrip,EpochRip]=FindRipplesKarimSB(eegRip,Epoch,[2 5]);

            save([res,'/RipplesdHPC25.mat'],'dHPCrip','EpochRip','chHPC');
            clear dHPCrip EpochRip chHPC
            disp('   -> Done')
        end
    catch
        disp('   -> problem'); if keyboardIfProblem, keyboard;end
    end
end

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%% FIND SPINDLES
disp(' ')
disp('   ________ FIND SPINDLES ________ ')

% ------------------ Parietal Cortex Deep ---------------------------------
try
    clear tempLoad
    tempLoad=load([res,'/SpindlesPaCxDeep.mat'],'SpiTot');
    tempLoad.SpiTot;
    
    clear tempLoad
    if erasePreviousAnalysis
        error;
    else
        disp('SpindlesPaCxDeep.mat already exists... skipping...')
    end
catch
    
    disp('detecting SpindlesPaCxDeep...')
    try
        cd(res)
        clear tempLoad
        tempch=load([res,'/ChannelsToAnalyse/PaCx_deep.mat'],'channel');
        eval(['tempLoad=load([res,''/LFPData/LFP',num2str(tempch.channel),'.mat''],''LFP'');'])
        
        [SpiTot,SWATot,~,TotEpoch]=FindSpindlesKarimNewSB(tempLoad.LFP,[2 20],Epoch,'off');
        [SpiHigh,SWAHigh,~,HiEpoch]=FindSpindlesKarimNewSB(tempLoad.LFP,[12 15],Epoch,'off');
        [SpiLow,SWALow,~,LowEpoch]=FindSpindlesKarimNewSB(tempLoad.LFP,[9 12],Epoch,'off');
        [SpiULow,SWAULow,~,UlowEpoch]=FindSpindlesKarimNewSB(tempLoad.LFP,[6 8],Epoch,'off');
        save([res,'/SpindlesPaCxDeep.mat'],'SpiTot','SWATot','SpiHigh','SWAHigh','SpiLow','SWALow','SpiULow','SWAULow',...
            'TotEpoch','HiEpoch','LowEpoch','UlowEpoch');

        clear SpiTot SWATot
        clear SpiHigh SWAHigh
        clear SpiLow SWALow
        clear SpiULow SWAULow
        clear TotEpoch HiEpoch LowEpoch UlowEpoch
        disp('   -> Done')
    catch
        disp('   -> problem'); if keyboardIfProblem, keyboard;end
    end
end


% ------------------ Parietal Cortex Sup ----------------------------------
try
    clear tempLoad
    tempLoad=load([res,'/SpindlesPaCxSup.mat'],'SpiTot');
    tempLoad.SpiTot;
    
    clear tempLoad
    if erasePreviousAnalysis
        error;
    else
        disp('SpindlesPaCxSup.mat already exists... skipping...')
    end
catch
    
    disp('detecting SpindlesPaCxSup...')
    try
        clear tempLoad
        tempch=load([res,'/ChannelsToAnalyse/PaCx_sup.mat'],'channel');
        eval(['tempLoad=load([res,''/LFPData/LFP',num2str(tempch.channel),'.mat''],''LFP'');'])
        
        cd(res)
        [SpiTot,SWATot,~,TotEpoch]=FindSpindlesKarimNewSB(tempLoad.LFP,[2 20],Epoch,'off');
        [SpiHigh,SWAHigh,~,HiEpoch]=FindSpindlesKarimNewSB(tempLoad.LFP,[12 15],Epoch,'off');
        [SpiLow,SWALow,~,LowEpoch]=FindSpindlesKarimNewSB(tempLoad.LFP,[9 12],Epoch,'off');
        [SpiULow,SWAULow,~,UlowEpoch]=FindSpindlesKarimNewSB(tempLoad.LFP,[6 8],Epoch,'off');
        save([res,'/SpindlesPaCxSup.mat'],'SpiTot','SWATot','SpiHigh','SWAHigh','SpiLow','SWALow','SpiULow','SWAULow',...
            'TotEpoch','HiEpoch','LowEpoch','UlowEpoch');

        clear SpiTot SWATot
        clear SpiHigh SWAHigh
        clear SpiLow SWALow
        clear SpiULow SWAULow
        clear TotEpoch HiEpoch LowEpoch UlowEpoch
        disp('   -> Done')
    catch
        disp('   -> problem'); if keyboardIfProblem, keyboard;end
    end
end



% ------------------ Prefrontal Cortex Deep -------------------------------
try
    
    clear tempLoad
    tempLoad=load([res,'/SpindlesPFCxDeep.mat'],'SpiTot');
    tempLoad.SpiTot;
    clear tempLoad
    if erasePreviousAnalysis
        error;
    else
        disp('SpindlesPFCxDeep.mat already exists... skipping...')
    end
catch
    
    disp('detecting SpindlesPFCxDeep...')
    try
        clear tempLoad
        tempch=load([res,'/ChannelsToAnalyse/PFCx_deep.mat'],'channel');
        eval(['tempLoad=load([res,''/LFPData/LFP',num2str(tempch.channel),'.mat''],''LFP'');'])
        
        cd(res)
        [SpiTot,SWATot,~,TotEpoch]=FindSpindlesKarimNewSB(tempLoad.LFP,[2 20],Epoch,'off');
        [SpiHigh,SWAHigh,~,HiEpoch]=FindSpindlesKarimNewSB(tempLoad.LFP,[12 15],Epoch,'off');
        [SpiLow,SWALow,~,LowEpoch]=FindSpindlesKarimNewSB(tempLoad.LFP,[9 12],Epoch,'off');
        [SpiULow,SWAULow,~,UlowEpoch]=FindSpindlesKarimNewSB(tempLoad.LFP,[6 8],Epoch,'off');
        save([res,'/SpindlesPFCxDeep.mat'],'SpiTot','SWATot','SpiHigh','SWAHigh','SpiLow','SWALow','SpiULow','SWAULow',...
            'TotEpoch','HiEpoch','LowEpoch','UlowEpoch');

        clear SpiTot SWATot
        clear SpiHigh SWAHigh
        clear SpiLow SWALow
        clear SpiULow SWAULow
        clear TotEpoch HiEpoch LowEpoch UlowEpoch
        disp('   -> Done')
    catch
        disp('   -> problem'); if keyboardIfProblem, keyboard;end
    end
end



% ------------------ Prefrontal Cortex Sup -------------------------------
try
    
    clear tempLoad
    tempLoad=load([res,'/SpindlesPFCxSup.mat'],'SpiTot');
    tempLoad.SpiTot;
    
    clear tempLoad
    if erasePreviousAnalysis
        error;
    else
        disp('SpindlesPFCxSup.mat already exists... skipping...')
    end
catch
    
    disp('detecting SpindlesPFCxSup...')
    try
        clear tempLoad
        tempch=load([res,'/ChannelsToAnalyse/PFCx_sup.mat'],'channel');
        eval(['tempLoad=load([res,''/LFPData/LFP',num2str(tempch.channel),'.mat''],''LFP'');'])
        
        cd(res)
        [SpiTot,SWATot,~,TotEpoch]=FindSpindlesKarimNewSB(tempLoad.LFP,[2 20],Epoch,'off');
        [SpiHigh,SWAHigh,~,HiEpoch]=FindSpindlesKarimNewSB(tempLoad.LFP,[12 15],Epoch,'off');
        [SpiLow,SWALow,~,LowEpoch]=FindSpindlesKarimNewSB(tempLoad.LFP,[9 12],Epoch,'off');
        [SpiULow,SWAULow,~,UlowEpoch]=FindSpindlesKarimNewSB(tempLoad.LFP,[6 8],Epoch,'off');
        save([res,'/SpindlesPFCxSup.mat'],'SpiTot','SWATot','SpiHigh','SWAHigh','SpiLow','SWALow','SpiULow','SWAULow',...
            'TotEpoch','HiEpoch','LowEpoch','UlowEpoch');

        clear SpiTot SWATot
        clear SpiHigh SWAHigh
        clear SpiLow SWALow
        clear SpiULow SWAULow
        clear TotEpoch HiEpoch LowEpoch UlowEpoch
        
        disp('   -> Done')
    catch
        disp('   -> problem'); if keyboardIfProblem, keyboard;end
    end
end




% ------------------ Prefrontal Cortex Motor Sup -------------------------------
try
    
    clear tempLoad
    tempLoad=load([res,'/SpindlesMoCxSup.mat'],'SpiTot');
    tempLoad.SpiTot;
    
    clear tempLoad
    if erasePreviousAnalysis
        error;
    else
        disp('SpindlesMoCxSup.mat already exists... skipping...')
    end
catch
    
    disp('detecting SpindlesMoCxSup...')
    try
        clear tempLoad
        tempch=load([res,'/ChannelsToAnalyse/MoCx_sup.mat'],'channel');
        eval(['tempLoad=load([res,''/LFPData/LFP',num2str(tempch.channel),'.mat''],''LFP'');'])
        
        cd(res)
        [SpiTot,SWATot,~,TotEpoch]=FindSpindlesKarimNewSB(tempLoad.LFP,[2 20],Epoch,'off');
        [SpiHigh,SWAHigh,~,HiEpoch]=FindSpindlesKarimNewSB(tempLoad.LFP,[12 15],Epoch,'off');
        [SpiLow,SWALow,~,LowEpoch]=FindSpindlesKarimNewSB(tempLoad.LFP,[9 12],Epoch,'off');
        [SpiULow,SWAULow,~,UlowEpoch]=FindSpindlesKarimNewSB(tempLoad.LFP,[6 8],Epoch,'off');
        save([res,'/SpindlesMoCxSup.mat'],'SpiTot','SWATot','SpiHigh','SWAHigh','SpiLow','SWALow','SpiULow','SWAULow',...
            'TotEpoch','HiEpoch','LowEpoch','UlowEpoch');

        clear SpiTot SWATot
        clear SpiHigh SWAHigh
        clear SpiLow SWALow
        clear SpiULow SWAULow
        clear TotEpoch HiEpoch LowEpoch UlowEpoch
        
        disp('   -> Done')
    catch
        disp('   -> problem'); if keyboardIfProblem, keyboard;end
    end
end


% ------------------ Prefrontal Cortex Motor Deep -------------------------------
try
    
    clear tempLoad
    tempLoad=load([res,'/SpindlesMoCxDeep.mat'],'SpiTot');
    tempLoad.SpiTot;
    
    clear tempLoad
    if erasePreviousAnalysis
        error;
    else
        disp('SpindlesMoCxDeep.mat already exists... skipping...')
    end
catch
    
    disp('detecting SpindlesMoCxDeep...')
    try
        clear tempLoad
        tempch=load([res,'/ChannelsToAnalyse/MoCx_deep.mat'],'channel');
        eval(['tempLoad=load([res,''/LFPData/LFP',num2str(tempch.channel),'.mat''],''LFP'');'])
        
        cd(res)
        [SpiTot,SWATot,~,TotEpoch]=FindSpindlesKarimNewSB(tempLoad.LFP,[2 20],Epoch,'off');
        [SpiHigh,SWAHigh,~,HiEpoch]=FindSpindlesKarimNewSB(tempLoad.LFP,[12 15],Epoch,'off');
        [SpiLow,SWALow,~,LowEpoch]=FindSpindlesKarimNewSB(tempLoad.LFP,[9 12],Epoch,'off');
        [SpiULow,SWAULow,~,UlowEpoch]=FindSpindlesKarimNewSB(tempLoad.LFP,[6 8],Epoch,'off');
        save([res,'/SpindlesMoCxDeep.mat'],'SpiTot','SWATot','SpiHigh','SWAHigh','SpiLow','SWALow','SpiULow','SWAULow',...
            'TotEpoch','HiEpoch','LowEpoch','UlowEpoch');

        clear SpiTot SWATot
        clear SpiHigh SWAHigh
        clear SpiLow SWALow
        clear SpiULow SWAULow
        clear TotEpoch HiEpoch LowEpoch UlowEpoch
        
        disp('   -> Done')
    catch
        disp('   -> problem'); if keyboardIfProblem, keyboard;end
    end
end

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%% FIND SLEEP STAGES
disp(' ')
disp('   ________ FIND SLEEP STAGES ________ ')

% ------------------ Parietal Cortex Deep ---------------------------------
try
    clear tempLoad
    tempLoad=load([res,'/SleepStagesPaCxDeep.mat'],'S12');
    tempLoad.S12;
    
    clear tempLoad
    if erasePreviousAnalysis
        error;
    else
        disp('SleepStagesPaCxDeep.mat already exists... skipping...')
    end
catch
    
    disp('detecting SleepStagesPaCxDeep...')
    try
        clear tempLoad
        tempch=load([res,'/ChannelsToAnalyse/PaCx_deep.mat'],'channel');
        eval(['tempLoad=load([res,''/LFPData/LFP',num2str(tempch.channel),'.mat''],''LFP'');'])
        
        cd(res)
        [S12,S34,S5,REMEpoch, WakeEpoch,SWAEpoch,SleepStages]=FindSleepStage(tempLoad.LFP);
        save([res,'/SleepStagesPaCxDeep.mat'],'S12','S34','S5','REMEpoch','WakeEpoch','SWAEpoch','SleepStages');
        
        clear S12
        clear S34
        clear S5
        clear REMEpoch
        clear WakeEpoch
        clear SWAEpoch
        clear SleepStages
        clear tempLoad
        clear LFP
        close all
        disp('   -> Done')
    catch
        disp('   -> problem'); if keyboardIfProblem, keyboard;end
    end
end


% ------------------ Parietal Cortex Sup ----------------------------------

try
    clear tempLoad
    tempLoad=load([res,'/SleepStagesPaCxSup.mat'],'S12');
    tempLoad.S12;
    
    clear tempLoad
    if erasePreviousAnalysis
        error;
    else
        disp('SleepStagesPaCxSup.mat already exists... skipping...')
    end
catch
    
    disp('detecting SleepStagesPaCxSup...')
    try
        clear tempLoad;
        tempch=load([res,'/ChannelsToAnalyse/PaCx_sup.mat'],'channel');
        eval(['tempLoad=load([res,''/LFPData/LFP',num2str(tempch.channel),'.mat''],''LFP'');'])
        
        cd(res)
        [S12,S34,S5,REMEpoch, WakeEpoch,SWAEpoch,SleepStages]=FindSleepStage(tempLoad.LFP);
        save([res,'/SleepStagesPaCxSup.mat'],'S12','S34','S5','REMEpoch','WakeEpoch','SWAEpoch','SleepStages');
        clear S12
        clear S34
        clear S5
        clear REMEpoch
        clear WakeEpoch
        clear SWAEpoch
        clear SleepStages
        clear tempLoad
        clear LFP
        close all
        disp('   -> Done')
    catch
        disp('   -> problem'); if keyboardIfProblem, keyboard;end
    end
end




% ------------------ Prefrontal Cortex Sup --------------------------------
try
    clear tempLoad
    tempLoad=load([res,'/SleepStagesPFCxSup.mat'],'S12');
    tempLoad.S12;
    
    clear tempLoad
    if erasePreviousAnalysis
        error;
    else
        disp('SleepStagesPFCxSup.mat already exists... skipping...')
    end
catch
    
    disp('detecting SleepStagesPFCxSup...')
    try
        clear tempLoad
        tempch=load([res,'/ChannelsToAnalyse/PFCx_sup.mat'],'channel');
        eval(['tempLoad=load([res,''/LFPData/LFP',num2str(tempch.channel),'.mat''],''LFP'');'])
        
        cd(res)
        [S12,S34,S5,REMEpoch, WakeEpoch,SWAEpoch,SleepStages]=FindSleepStage(tempLoad.LFP);
        save([res,'/SleepStagesPFCxSup.mat'],'S12','S34','S5','REMEpoch','WakeEpoch','SWAEpoch','SleepStages');
        
        clear S12
        clear S34
        clear S5
        clear REMEpoch
        clear WakeEpoch
        clear SWAEpoch
        clear SleepStages
        clear tempLoad
        clear LFP
        close all
        disp('   -> Done')
    catch
        disp('   -> problem'); if keyboardIfProblem, keyboard;end
    end
end

% ------------------ Prefrontal Cortex Deep -------------------------------
try
    clear tempLoad
    tempLoad=load([res,'/SleepStagesPFCxDeep.mat'],'S12');
    tempLoad.S12;
    
    clear tempLoad
    if erasePreviousAnalysis
        error;
    else
        disp('SleepStagesPFCxDeep.mat already exists... skipping...')
    end
catch
    
    disp('detecting SleepStagesPFCxDeep...')
    try
        clear tempLoad
        tempch=load([res,'/ChannelsToAnalyse/PFCx_deep.mat'],'channel');
        eval(['tempLoad=load([res,''/LFPData/LFP',num2str(tempch.channel),'.mat''],''LFP'');'])
        
        cd(res)
        [S12,S34,S5,REMEpoch, WakeEpoch,SWAEpoch,SleepStages]=FindSleepStage(tempLoad.LFP);
        save([res,'/SleepStagesPFCxDeep.mat'],'S12','S34','S5','REMEpoch','WakeEpoch','SWAEpoch','SleepStages');
        
        clear S12
        clear S34
        clear S5
        clear REMEpoch
        clear WakeEpoch
        clear SWAEpoch
        clear SleepStages
        clear tempLoad
        clear LFP
        close all
        disp('   -> Done')
    catch
        disp('   -> problem'); if keyboardIfProblem, keyboard;end
    end
end

