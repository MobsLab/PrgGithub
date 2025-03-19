function GenerateSpindlesGL(res)

% inputs:
% res (optional) = path

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%% INITIALIZATION
erasePreviousAnalysis=0;
keyboardIfProblem=0;


if ~exist('res','var')
    res=pwd;
end


disp(' ')
disp([res,'/StateEpoch.mat'])
try
    tempLoad=load([res,'/StateEpoch.mat'],'SWSEpoch','NoiseEpoch','GndNoiseEpoch','WeirdNoiseEpoch');
catch
    tempLoad=load([res,'/StateEpochSB.mat'],'SWSEpoch','NoiseEpoch','GndNoiseEpoch','WeirdNoiseEpoch');
end
Epoch=tempLoad.SWSEpoch-tempLoad.GndNoiseEpoch;
Epoch=Epoch-tempLoad.NoiseEpoch;
if exist('tempLoad.WeirdNoiseEpoch','var'),Epoch=Epoch-tempLoad.WeirdNoiseEpoch;end

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


%% FIND SPINDLES
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



% ------------------ Prefrontal Cortex Deep -------------------------------
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


%% FIND SPINDLES
% ------------------ Motor Cortex Deep ---------------------------------
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
        cd(res)
        clear tempLoad
        tempch=load([res,'/ChannelsToAnalyse/MoCx_deep.mat'],'channel');
        eval(['tempLoad=load([res,''/LFPData/LFP',num2str(tempch.channel),'.mat''],''LFP'');'])

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


% ------------------ Motor Cortex Sup ----------------------------------
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


%% FIND SPINDLES
% ------------------ Olfactory Bulb Ecog ----------------------------------
try
    clear tempLoad
    tempLoad=load([res,'/SpindlesBulbSup.mat'],'SpiTot');
    tempLoad.SpiTot;
    
    clear tempLoad
    if erasePreviousAnalysis
        error;
    else
        disp('SpindlesBulbSup.mat already exists... skipping...')
    end
catch
    
    disp('detecting SpindlesBulbSup...')
    try
        clear tempLoad
        tempch=load([res,'/ChannelsToAnalyse/Bulb_sup.mat'],'channel');
        eval(['tempLoad=load([res,''/LFPData/LFP',num2str(tempch.channel),'.mat''],''LFP'');'])
        
        cd(res)
        [SpiTot,SWATot,~,TotEpoch]=FindSpindlesKarimNewSB(tempLoad.LFP,[2 20],Epoch,'off');
        [SpiHigh,SWAHigh,~,HiEpoch]=FindSpindlesKarimNewSB(tempLoad.LFP,[12 15],Epoch,'off');
        [SpiLow,SWALow,~,LowEpoch]=FindSpindlesKarimNewSB(tempLoad.LFP,[9 12],Epoch,'off');
        [SpiULow,SWAULow,~,UlowEpoch]=FindSpindlesKarimNewSB(tempLoad.LFP,[6 8],Epoch,'off');
        save([res,'/SpindlesBulbSup.mat'],'SpiTot','SWATot','SpiHigh','SWAHigh','SpiLow','SWALow','SpiULow','SWAULow',...
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