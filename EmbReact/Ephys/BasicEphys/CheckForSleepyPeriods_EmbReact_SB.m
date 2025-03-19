%% This codes checks for sleepy Epochs by applying the gamma_thresh from sleep periods
smootime=3;
mindur=3; %abs cut off for events;
clear Dir
% Get numbers of mice
MiceNumber = [];
AllDates = {};
ss=1;
dd=1; % add by BM on 17/11/2020
Dir{ss}=PathForExperimentsEmbReact(SessNames{ss});

for d=1:length(Dir{ss}.path)
    if (Dir{ss}.ExpeInfo{d}{dd}.nmouse==MouseToDo)
        
        date=num2str(Dir{ss}.ExpeInfo{d}{1}.date);
        if length(date)==7
            date = ['0' date];
        end
    end
end


SleepFilesNames= FindSleepFile_EmbReact_BM(MouseToDo,date); % change on 25/02/2023, before FindSleepFile_EmbReact_SB
go = 0;
if not(isempty(SleepFilesNames))
    cd(SleepFilesNames)
    go = 1;
else
    cd(SleepFilesNames.Base)
    go = 1;
end
if go ==1
    load('StateEpochSB.mat','gamma_thresh')
    GammaThreshold.(['M',num2str(MouseToDo)])=gamma_thresh;
    clear gamma_thresh
end





for ss=1:length(SessNames)
    Dir{ss}=PathForExperimentsEmbReact(SessNames{ss});

    if isempty(strfind(lower(SessNames{ss}),'sleep'))
        for d=1:length(Dir{ss}.path)
            for dd=1:length(Dir{ss}.path{d})
                if (Dir{ss}.ExpeInfo{d}{dd}.nmouse==MouseToDo)
                    
                    if Dir{ss}.ExpeInfo{d}{dd}.SleepSession == 0
                        cd(Dir{ss}.path{d}{dd})
                        disp(Dir{ss}.path{d}{dd})
                        
                        clear SleepyEpoch
                        load('StateEpochSB.mat','SleepyEpoch')
                        if not(exist('SleepyEpoch'))
                            disp('SleepyEpoch calculation')
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
                            gamma_thresh= GammaThreshold.(['M',num2str(Dir{ss}.ExpeInfo{d}{dd}.nmouse)]);
                            SleepyEpoch=thresholdIntervals(smooth_ghi,gamma_thresh,'Direction','Below');
                            SleepyEpoch=mergeCloseIntervals(SleepyEpoch,mindur*1e4);
                            SleepyEpoch=dropShortIntervals(SleepyEpoch,mindur*1e4);
%                                                     clf
%                                                     plot(Range(smooth_ghi,'s'),Data(smooth_ghi)), hold on
%                                                     plot(Range(Restrict(smooth_ghi,SleepyEpoch),'s'),Data(Restrict(smooth_ghi,SleepyEpoch)),'c')
%                                                     line(xlim,[gamma_thresh gamma_thresh],'color','k')
%                                                     keyboard
                            save('StateEpochSB','SleepyEpoch','gamma_thresh','mindur','smooth_ghi','-v7.3','-append');
                            clear gamma_thresh SleepyEpoch smooth_ghi
                        end
                    end
                end
            end
        end
    end
end
