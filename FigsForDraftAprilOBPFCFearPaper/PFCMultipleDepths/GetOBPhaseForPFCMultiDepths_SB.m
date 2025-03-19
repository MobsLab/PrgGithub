clear allDataLocationPFCMultipleDepths

OptionsMiniMaxi.Fs=1250; % sampling rate of LFP
OptionsMiniMaxi.FilBand=[1 20];
OptionsMiniMaxi.std=[0.5 0.2];
OptionsMiniMaxi.TimeLim=0.07;

%% Spectra and coherence

for m=2:mm
    
    for ff=1:length(Filename{m})
        cd(Filename{m}{ff})
        mkdir('MiniMaxiLFP')
        disp(Filename{m}{ff})
        clear channel
        load('ChannelsToAnalyse/Bulb_deep.mat')
        load(['LFPData/LFP',num2str(channel),'.mat'])
        
        AllPeaks=FindPeaksForFrequency(LFP,OptionsMiniMaxi,0);
        AllPeaks(:,3)=[0:pi:pi*(length(AllPeaks)-1)];
        Y=interp1(AllPeaks(:,1),AllPeaks(:,3),Range(LFP,'s'));
        if AllPeaks(1,2)==1
            PhaseInterpol=tsd(Range(LFP),mod(Y,2*pi));
        else
            PhaseInterpol=tsd(Range(LFP),mod(Y+pi,2*pi));
        end
        save(['MiniMaxiLFP/MiniMaxiLFP_BulbDeep.mat'],'channel','AllPeaks','OptionsMiniMaxi','PhaseInterpol','-v7.3')
        clear AllPeaks PhaseInterpol

        
        
        
    end
    
    cd(SleepSession{m})
    disp(SleepSession{m})
    mkdir('MiniMaxiLFP')
    
    load(['LFPData/LFP',num2str(channel),'.mat'])
    
    AllPeaks=FindPeaksForFrequency(LFP,OptionsMiniMaxi,0);
    AllPeaks(:,3)=[0:pi:pi*(length(AllPeaks)-1)];
    Y=interp1(AllPeaks(:,1),AllPeaks(:,3),Range(LFP,'s'));
    if AllPeaks(1,2)==1
        PhaseInterpol=tsd(Range(LFP),mod(Y,2*pi));
    else
        PhaseInterpol=tsd(Range(LFP),mod(Y+pi,2*pi));
    end
    save(['MiniMaxiLFP/MiniMaxiLFP_BulbDeep.mat'],'channel','AllPeaks','OptionsMiniMaxi','PhaseInterpol','-v7.3')
    clear AllPeaks PhaseInterpol
    
end

% M510 correction
clear allDataLocationPFCMultipleDepths

OptionsMiniMaxi.Fs=1250; % sampling rate of LFP
OptionsMiniMaxi.FilBand=[1 20];
OptionsMiniMaxi.std=[0.5 0.2];
OptionsMiniMaxi.TimeLim=0.07;

%% Spectra and coherence

for m=7
    
    for ff=1:length(Filename{m})
        cd(Filename{m}{ff})
        mkdir('MiniMaxiLFP')
        disp(Filename{m}{ff})
        clear channel
        channel = 1;
        load(['LFPData/LFP',num2str(channel),'.mat'])
        
        AllPeaks=FindPeaksForFrequency(LFP,OptionsMiniMaxi,0);
        AllPeaks(:,3)=[0:pi:pi*(length(AllPeaks)-1)];
        Y=interp1(AllPeaks(:,1),AllPeaks(:,3),Range(LFP,'s'));
        if AllPeaks(1,2)==1
            PhaseInterpol=tsd(Range(LFP),mod(Y,2*pi));
        else
            PhaseInterpol=tsd(Range(LFP),mod(Y+pi,2*pi));
        end
        save(['MiniMaxiLFP/MiniMaxiLFP_BulbDeep.mat'],'channel','AllPeaks','OptionsMiniMaxi','PhaseInterpol','-v7.3')
        clear AllPeaks PhaseInterpol

        
        
        
    end
    
    cd(SleepSession{m})
    disp(SleepSession{m})
    mkdir('MiniMaxiLFP')
    
    load(['LFPData/LFP',num2str(channel),'.mat'])
    
    AllPeaks=FindPeaksForFrequency(LFP,OptionsMiniMaxi,0);
    AllPeaks(:,3)=[0:pi:pi*(length(AllPeaks)-1)];
    Y=interp1(AllPeaks(:,1),AllPeaks(:,3),Range(LFP,'s'));
    if AllPeaks(1,2)==1
        PhaseInterpol=tsd(Range(LFP),mod(Y,2*pi));
    else
        PhaseInterpol=tsd(Range(LFP),mod(Y+pi,2*pi));
    end
    save(['MiniMaxiLFP/MiniMaxiLFP_BulbDeep.mat'],'channel','AllPeaks','OptionsMiniMaxi','PhaseInterpol','-v7.3')
    clear AllPeaks PhaseInterpol
    
end








