%% This codes checks for sleepy Epochs by applying the gamma_thresh from sleep periods
smootime=3;
mindur=3;
clear Dir
MiceNumber = [];
AllDates = {};
ss=1;
dd=1; % add by BM on 17/11/2020


load('/media/nas6/ProjetEmbReact/transfer/Sess.mat')
SleepSess = Sess.(Mouse_names{1})(find(not(cellfun(@isempty,strfind(Sess.(Mouse_names{1}) ,'Sleep')))));

if not(isempty(SleepSess))
    go = 1;
else
    go = 0;
    disp('No Sleep Sessions?')
end

if go ==1
    cd(SleepSess{1})
    load('StateEpochSB.mat','gamma_thresh')
    GammaThreshold.(['M',num2str(MouseToDo)])=gamma_thresh;
    clear gamma_thresh
end

for sess = 1:length(Sess.(Mouse_names{1}))
    cd(Sess.(Mouse_names{1}){sess})
    disp(Sess.(Mouse_names{1}){sess})
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
        gamma_thresh= GammaThreshold.(Mouse_names{1});
        SleepyEpoch=thresholdIntervals(smooth_ghi,gamma_thresh,'Direction','Below');
        SleepyEpoch=mergeCloseIntervals(SleepyEpoch,mindur*1e4);
        SleepyEpoch=dropShortIntervals(SleepyEpoch,mindur*1e4);
        save('StateEpochSB','SleepyEpoch','gamma_thresh','mindur','smooth_ghi','-v7.3','-append');
        clear gamma_thresh SleepyEpoch smooth_ghi
    end
end