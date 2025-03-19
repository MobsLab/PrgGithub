%% This codes checks for sleepy Epochs by applying the gamma_thresh from sleep periods
clear all

close all
a=1;
smootime=3;
mindur=3; %abs cut off for events;

% Day time mice
MiceNumber=[404,425,431,436,437,438,439,490,507,508,509,510,512,514];
RefSess={'SleepPostUMaze'};
SessNames={'EPM'};
% Get the thresholds
Dir=PathForExperimentsEmbReactMontreal(RefSess);
for mm=1:length(MiceNumber)
    for d=1:length(Dir.path)
        if Dir.ExpeInfo{d}{1}.nmouse==MiceNumber(mm)
            cd(Dir.path{d}{1})
            load('StateEpochSB.mat','gamma_thresh')
            GammaThreshold(mm)=gamma_thresh;
        end
    end
end
clear gamma_thresh

for mm=1:length(MiceNumber)
    for ss=1:length(SessNames)
        Dir=PathForExperimentsEmbReactMontreal(SessNames{ss});
        disp(SessNames{ss})
        for d=1:length(Dir.path)
            for dd=1:length(Dir.path{d})
                if Dir.ExpeInfo{d}{dd}.nmouse==MiceNumber(mm)
                    cd(Dir.path{d}{dd})
                    load('ChannelsToAnalyse/Bulb_deep.mat')
                    load(strcat('LFPData/LFP',num2str(channel),'.mat'));
                    
                    
                    % find gamma epochs
                    disp(' ');
                    disp('... Creating Gamma Epochs ');
                    FilGamma=FilterLFP(LFP,[50 70],1024);
                    HilGamma=hilbert(Data(FilGamma));
                    H=abs(HilGamma);
                    tot_ghi=tsd(Range(LFP),H);
                    smooth_ghi=tsd(Range(tot_ghi),runmean(Data(tot_ghi),ceil(smootime/median(diff(Range(tot_ghi,'s'))))));
                    gamma_thresh= GammaThreshold(mm);
                    SleepyEpoch=thresholdIntervals(smooth_ghi,gamma_thresh,'Direction','Below');
                    SleepyEpoch=mergeCloseIntervals(SleepyEpoch,mindur*1e4);
                    SleepyEpoch=dropShortIntervals(SleepyEpoch,mindur*1e4);
                    %                     clf
                    %                     plot(Range(smooth_ghi,'s'),Data(smooth_ghi)), hold on
                    %                     plot(Range(Restrict(smooth_ghi,SleepyEpoch),'s'),Data(Restrict(smooth_ghi,SleepyEpoch)),'c')
                    %                     line(xlim,[gamma_thresh gamma_thresh],'color','k')
                    %                     keyboard
                    save('StateEpochSB','SleepyEpoch','gamma_thresh','mindur','smooth_ghi','-v7.3','-append');
                    clear gamma_thresh SleepyEpoch smooth_ghi
                    
                end
            end
        end
    end
end

% Night time mice
clear all
close all
a=1;
smootime=3;
mindur=3; %abs cut off for events;

MiceNumber=[469,470,471,483,484,485];
RefSess={'BaselineSleep'};

SessNames={'HabituationNight' 'TestPreNight' 'UMazeCondNight' 'TestPostNight' 'ExtinctionNight'};
% Get the thresholds
Dir=PathForExperimentsEmbReactMontreal(RefSess);
for mm=1:length(MiceNumber)
    for d=1:length(Dir.path)
        if Dir.ExpeInfo{d}{1}.nmouse==MiceNumber(mm)
            cd(Dir.path{d}{1})
            load('StateEpochSB.mat','gamma_thresh')
            GammaThreshold(mm)=gamma_thresh;
        end
    end
end
clear gamma_thresh

for mm=1%:length(MiceNumber)
    for ss=3%:length(SessNames)
        Dir=PathForExperimentsEmbReactMontreal(SessNames{ss});
        disp(SessNames{ss})
        for d=1:length(Dir.path)
            for dd=1:length(Dir.path{d})
                if Dir.ExpeInfo{d}{dd}.nmouse==MiceNumber(mm)
                    cd(Dir.path{d}{dd})
                    load('ChannelsToAnalyse/Bulb_deep.mat')
                    load(strcat('LFPData/LFP',num2str(channel),'.mat'));
                    
                    
                    % find gamma epochs
                    disp(' ');
                    disp('... Creating Gamma Epochs ');
                    FilGamma=FilterLFP(LFP,[50 70],1024);
                    HilGamma=hilbert(Data(FilGamma));
                    H=abs(HilGamma);
                    tot_ghi=tsd(Range(LFP),H);
                    smooth_ghi=tsd(Range(tot_ghi),runmean(Data(tot_ghi),ceil(smootime/median(diff(Range(tot_ghi,'s'))))));
                    gamma_thresh= GammaThreshold(mm);
                    SleepyEpoch=thresholdIntervals(smooth_ghi,gamma_thresh,'Direction','Below');
                    SleepyEpoch=mergeCloseIntervals(SleepyEpoch,mindur*1e4);
                    SleepyEpoch=dropShortIntervals(SleepyEpoch,mindur*1e4);
                    clf
                    plot(Range(smooth_ghi,'s'),Data(smooth_ghi)), hold on
                    plot(Range(Restrict(smooth_ghi,SleepyEpoch),'s'),Data(Restrict(smooth_ghi,SleepyEpoch)),'c')
                    line(xlim,[gamma_thresh gamma_thresh],'color','k')
                    keyboard
                    save('StateEpochSB','SleepyEpoch','gamma_thresh','mindur','smooth_ghi','-v7.3','-append');
                    clear gamma_thresh SleepyEpoch smooth_ghi
                end
            end
        end
    end
end