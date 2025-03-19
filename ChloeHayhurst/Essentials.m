

%% Essentials
% - explain what is : a tsd, a ts, an intervalSet
% - use basic lab function : Range, Data, Restrict, for epochs (and, or,
% Start, Stop, DurationEpoch), thresholdIntervals,
% mergeCloseIntervals, dropShortIntervals
% - transform some data in tsd or intervalSet (intervalSet, tsd, ts)
% - confirm by plot (plot, hist, imagesc, caxis)

%% Basics
% - To access data, you need to load it from the file you are in,
% for example the x position of a mouse :

load('HeartBeatInfo.mat', 'EKG')
Heart_Rate_tsd = EKG.HBRate;

% - This is a "tsd" for time stamped data : it is composed of an array of
% timestamps (ts) associated with an array of data. Range function acess to
% stamped times, Data function access to data stamped

% example:

R = Range(Heart_Rate_tsd,'s');
D = Data(Heart_Rate_tsd);

plot(R/60 , D)
xlabel('time (min)'), ylabel('Frequency (Hz)')
title('Heart rate evolution along baseline sleep session')
box off
% here time is in minutes

% - We can transform data into tsd by using the "tsd()" function, for
% example creating a variable of power in the bulb low spectrum depending
% on time :

SpectroBLow = load('B_Low_Spectrum.mat');

FreqBLow = SpectroBLow.Spectro{3}; % array with sampled frequencies from spectro

Sp_tsd_Blow = tsd(SpectroBLow.Spectro{2}*1e4 , SpectroBLow.Spectro{1});

% - Here, SpectroBLow.Spectro{2}*1e4 are the stamped times. We use *1e4
% because units of tsd are 0.0001s and Spectro{2} is in seconds

% - Then we can use the "imagesc()" function :

figure;
imagesc(SpectroBLow.Spectro{2}*1e4/60 , FreqBLow , log10(SpectroBLow.Spectro{1})'), axis xy
xlabel('time (hour)'), ylabel('Frequency (Hz)')
colorbar
title('Power spectrum of bulb low frequencies along baseline sleep session')
box off

% - Here we have a 3D data representation, the power (color) at each frequency (y
% axis) depending on time (x axis).

% The Spectro{3} is the frequency band, so for example the 52nd column
% corresponds to the frequency of 4Hz approximately

% axis xy is used to  inverse the x and y axis


% 1) Power of each frequency (1-261 bins from .15 to 20 Hz) for the first bin of time :

figure
plot(SpectroBLow.Spectro{1}(1,:))
xlabel('Frequency bin'), ylabel('Power')
title('Power of each frequency from .15 to 20 Hz for the first bin of time')
box off

% 2) Evolution of the 4 Hz frequency during time (The 52nd bin of frequency)

figure
plot(SpectroBLow.Spectro{1}(:,52))
xlabel('time (hour)'), ylabel('Frequency (Hz)')
colorbar
title('Power spectrum of bulb low frequencies along baseline sleep session')
box off

%% Display

% The plot fonction can be used to vizualise raw data such as the position
% of the mouse depending on time.

load('behavResources.mat', 'Xtsd', 'Ytsd');
figure;
plot (Data(Xtsd), Data(Ytsd))
% here we plot the position of the mouse in the homecage during baseline
% sleep session

% To define a period of time that you want to study, we use epochs. They are composed
% of time intervals delimited by starts and ends.
% How to define them ? --> intervalSet function

StartPoint = [1 5];
StopPoint = [2 6];
Study_Epoch = intervalSet(StartPoint , StopPoint);
% Here Study_Epoch is from 1 --> 2 and from 5 --> 6
% times in intervalSet have to be in 1e-4 s

% To visualize data during a specific epoch, we use Restrict:
% We can then use the Restrict function which allows us to visualize data
% between these Start and End time stamps.
% example: Heart Rate (HR) of the mouse during REM episodes

% load intervalSets
load('SleepScoring_OBGamma.mat', 'Wake', 'REMEpoch', 'Sleep', 'SWSEpoch')

% load tsd (variable)
load('HeartBeatInfo.mat', 'EKG')
Heart_Rate_tsd = EKG.HBRate;

HR.REM = Restrict(Heart_Rate_tsd , REMEpoch);

figure
plot(Range(HR.REM) , Data(HR.REM))


% define a structure for HR restricted on different epochs, for the first
% 100 minutes
Epoch.All = intervalSet(0,max(Range(Heart_Rate_tsd))); % define the epoch corresponding to the whole session
Epoch.Beginning = intervalSet(0,1e4*60*100); % epoch of the first 100 minutes of recording
HR.Beginning = Restrict(Heart_Rate_tsd, Epoch.Beginning); % Heart rate restricted on the first 100 minutes

HR.Wake = Restrict(HR.Beginning, Wake);
HR.SWS = Restrict(HR.Beginning, SWSEpoch);
HR.REM = Restrict(HR.Beginning, REMEpoch);

% Then plot it all on one figure

figure
plot(Range(HR.Wake,'s')/60, Data(HR.Wake) , '.b','MarkerSize', 5);hold on
plot(Range(HR.SWS,'s')/60, Data(HR.SWS) , '.r','MarkerSize', 5);hold on
plot(Range(HR.REM,'s')/60, Data(HR.REM) , '.g','MarkerSize', 4);hold on
ylabel('Frequency (Hz)'), xlabel('Time (minutes)')
legend('Wake','SWS','REM')
title('HR during the first 100 minutes')


% let's continue on epochs
% if you want to access to beggining of epoch, use Start
% example:
Sta = Start(REMEpoch)/60e4; % in Sta, vector with time in s of REM beginnings
REM_EpNumber = length(Start(REMEpoch)); % gives the number of REM episodes
% DurationEpoch give acces to duration of epochs
Dur = DurationEpoch(REMEpoch)/1e4; % vector of REM episodes in sec
REM_EpMeanDur = mean(DurationEpoch(REMEpoch))/1e4; % in minutes
REM_TotalDur = sum(DurationEpoch(REMEpoch))/60e4; % in minutes

% same for Stops
Sto = Stop(REMEpoch)/1e4; % in Sto, vector with time in s of REM ends

% to access to the i-th REM episode, use subset
i=20;
REM_Ep_i = subset(REMEpoch , i); % one epoch of time with one start and one end of 20th REM episode

for i=1:length(Sta) % for every REM episode
    REM_Ep = subset(REMEpoch , i); % extract HR for i-th episode
    if DurationEpoch(REM_Ep)>20e4
        HR_long_ep{i} = Restrict(Heart_Rate_tsd , REM_Ep);
        HR_long_interp(i,:) = interp1(linspace(0,1,length(Data(HR_long_ep{i}))) , Data(HR_long_ep{i}) , linspace(0,1,100)); % interpolate them to have the same size
    end
    HR_ep{i} = Restrict(Heart_Rate_tsd , REM_Ep);
    HR_interp(i,:) = interp1(linspace(0,1,length(Data(HR_ep{i}))) , Data(HR_ep{i}) , linspace(0,1,100)); % interpolate them to have the same size
end
HR_long_interp(HR_long_interp==0) = NaN;

figure
plot(nanmean(HR_interp))
hold on
plot(nanmean(HR_long_interp))

% to only study long episodes of REM, use dropShortIntervals
% example:
REM_long = dropShortIntervals(REMEpoch , 20e4); % only study REM episodes longer than 20s

% to merge episodes of REM that are close, use mergeCloseIntervals
% example:
REM_corr = mergeCloseIntervals(REMEpoch , 3e4); % will merge REM episodes espaced by less than 3s

% to define an epoch based on tsd values, use thresholdIntervals
Low_HR_Epoch = thresholdIntervals(Heart_Rate_tsd,7.5,'Direction','Below'); % epoch when HR is lower than 7.5Hz
Low_HR_Epoch = dropShortIntervals(Low_HR_Epoch , .5e4);
Low_HR_Epoch = mergeCloseIntervals(Low_HR_Epoch , 10e4);

Low_HR_Episodes_Number = length(Start(Low_HR_Epoch));

% to study intersection of epochs, use 'and'
% example:
SWS_and_LowHR = and(Low_HR_Epoch , SWSEpoch);
(sum(DurationEpoch(SWS_and_LowHR))/sum(DurationEpoch(Low_HR_Epoch)))*100
% proportion of low HR epoch that are happening during SWS

% to study both epochs, use 'or'
SWS_or_LowHR = or(Low_HR_Epoch , SWSEpoch);
(sum(DurationEpoch(SWS_or_LowHR))-sum(DurationEpoch(SWSEpoch)))/60e4



% intervalSet is used to define Epochs.


Epoch.All = intervalSet(0,max(Range(HR.All)))

Epoch.Beginning = intervalSet(0,1e4*60*100)

HR.Beginning = Restrict(HR.All, Epoch.Beginning);

figure
plot(Range(HR.Beginning,'s')/60,runmean(Data(HR.Beginning),200)+4)
h=histogram(Data(HR.Wake),30, 'FaceColor','b'), hold on
histogram(Data(HR.SWS),30, 'FaceColor','r'), hold on
histogram(Data(HR.REM),30, 'FaceColor','g')
legend('Wake','SWS','REM')
ylabel('AU'), xlabel('Frequency (Hz)')
title('HR Wake (blue), SWS (red), REM (green)')


tsd_HR = tsd(SpectroHLow.Spectro{2}*1e4 , SpectroHLow.Spectro{1});
Sp_tsd_BHigh = tsd(SpectroBHigh.Spectro{2}*1e4 , SpectroBHigh.Spectro{1});





figure
h=histogram(Data(HR.Wake),'BinLimits',[6 13],'NumBins',30, 'FaceColor','b');
hold on
h=histogram(Data(HR.SWS),'BinLimits',[6 13],'NumBins',30, 'FaceColor','r');
h=histogram(Data(HR.REM),'BinLimits',[6 13],'NumBins',30, 'FaceColor','g');


figure
[Y,X]=hist(Data(HR.Wake),30);
Y=Y/sum(Y);
plot(X,Y,'b','LineWidth',5)
hold on
[Y,X]=hist(Data(HR.SWS),30);
Y=Y/sum(Y);
plot(X,Y,'r','LineWidth',5)
[Y,X]=hist(Data(HR.REM),30);
Y=Y/nansum(Y);
plot(X,Y,'g','LineWidth',5)






%% Specific to SBM data
% example for Mouse #688 and Conditionning sessions
GetEmbReactMiceFolderList_BM

Speed = ConcatenateDataFromFolders_SB(CondSess.(Mouse_names{mouse}),'speed');
Respi = ConcatenateDataFromFolders_SB(CondSess.(Mouse_names{mouse}),'respi_freq_bm');
OB_Spec = ConcatenateDataFromFolders_SB(CondSess.(Mouse_names{mouse}),'Spectrum','prefix','B_Low');

FzEpoch = ConcatenateDataFromFolders_SB(CondSess.(Mouse_names{mouse}),'epoch','epochname','freezeepoch');
ZoneEpoch = ConcatenateDataFromFolders_SB(CondSess.(Mouse_names{mouse}),'epoch','epochname','zoneepoch');

ShockEpoch = ZoneEpoch{1};
SafeEpoch = or(ZoneEpoch{2} , ZoneEpoch{5});

FzShockEpoch = and(FzEpoch , ShockEpoch);
FzSafeEpoch = and(FzEpoch , SafeEpoch);

Respi_FzShock = Restrict(Respi , FzShockEpoch);
Respi_FzSafe = Restrict(Respi , FzSafeEpoch);

TimeFzShock = sum(DurationEpoch(FzShockEpoch))/1e4;
TimeFzSafe = sum(DurationEpoch(FzSafeEpoch))/1e4;

figure
plot(Range(Speed,'s') , Data(Speed))
plot(Range(Respi,'s') , Data(Respi))

% changing labels to have time spent freezing
figure
plot(linspace(0,TimeFzShock,length(Data(Respi_FzShock))) , runmean_BM(Data(Respi_FzShock),10),'r')
hold on
plot(linspace(0,TimeFzSafe,length(Data(Respi_FzSafe))) , runmean_BM(Data(Respi_FzSafe),10),'b')


% introducing interp1
D_Shock = runmean_BM(Data(Respi_FzShock),round(length(Data(Respi_FzShock))/20));% Data runmean for respi fz shock with a factor of 1/20th of data size (round is used to have this factor without decimal)
D_Safe = runmean_BM(Data(Respi_FzSafe),round(length(Data(Respi_FzSafe))/20));

Respi_FzShock_interp = interp1(linspace(0,1,length(Data(Respi_FzShock))) , D_Shock , linspace(0,1,100));
Respi_FzSafe_interp = interp1(linspace(0,1,length(Data(Respi_FzSafe))) , D_Safe , linspace(0,1,100));

figure
plot([1:100] , Respi_FzShock_interp,'r')
hold on
plot([1:100] , Respi_FzSafe_interp,'b')




% good, now let's check for a whole batch of mice
clear all
GetAllSalineSessions_BM

for mouse=1:length(Mouse)
    % generate the same data for all mice in different variables
    Respi.(Mouse_names{mouse}) = ConcatenateDataFromFolders_SB(CondSess.(Mouse_names{mouse}),'respi_freq_bm');
    
    FzEpoch.(Mouse_names{mouse}) = ConcatenateDataFromFolders_SB(CondSess.(Mouse_names{mouse}),'epoch','epochname','all_fz_epoch');
    ZoneEpoch.(Mouse_names{mouse}) = ConcatenateDataFromFolders_SB(CondSess.(Mouse_names{mouse}),'epoch','epochname','zoneepoch');
    
    ShockEpoch.(Mouse_names{mouse}) = ZoneEpoch.(Mouse_names{mouse}){1};
    SafeEpoch.(Mouse_names{mouse}) = or(ZoneEpoch.(Mouse_names{mouse}){2} , ZoneEpoch.(Mouse_names{mouse}){5});
    
    FzShockEpoch.(Mouse_names{mouse}) = and(FzEpoch.(Mouse_names{mouse}) , ShockEpoch.(Mouse_names{mouse}));
    FzSafeEpoch.(Mouse_names{mouse}) = and(FzEpoch.(Mouse_names{mouse}) , SafeEpoch.(Mouse_names{mouse}));
    
    Respi_FzShock.(Mouse_names{mouse}) = Restrict(Respi.(Mouse_names{mouse}) , FzShockEpoch.(Mouse_names{mouse}));
    Respi_FzSafe.(Mouse_names{mouse}) = Restrict(Respi.(Mouse_names{mouse}) , FzSafeEpoch.(Mouse_names{mouse}));
    
    clear D_Shock D_Safe
    D_Shock = runmean_BM(Data(Respi_FzShock.(Mouse_names{mouse})),round(length(Data(Respi_FzShock.(Mouse_names{mouse})))/20));% Data runmean for respi fz shock with a factor of 1/20th of data size (round is used to have this factor without decimal)
    D_Safe = runmean_BM(Data(Respi_FzSafe.(Mouse_names{mouse})),round(length(Data(Respi_FzSafe.(Mouse_names{mouse})))/20));
    
    try
        Respi_FzShock_interp.(Mouse_names{mouse}) = interp1(linspace(0,1,length(Data(Respi_FzShock.(Mouse_names{mouse})))) , D_Shock , linspace(0,1,100));
        Respi_FzSafe_interp.(Mouse_names{mouse}) = interp1(linspace(0,1,length(Data(Respi_FzSafe.(Mouse_names{mouse})))) , D_Safe , linspace(0,1,100));
    end
    
    % putting them together
    try
        Respi_FzShock_All(mouse,:) = Respi_FzShock_interp.(Mouse_names{mouse});
        Respi_FzSafe_All(mouse,:) = Respi_FzSafe_interp.(Mouse_names{mouse});
    end
    
    disp(Mouse_names{mouse})
end
Respi_FzShock_All(Respi_FzShock_All==0) = NaN;
Respi_FzSafe_All(Respi_FzSafe_All==0) = NaN;

% display data of all mice for respi safe, each color is a mouse
figure
plot(Respi_FzSafe_All')

% dislay of respi safe for each mouse
i=1;
plot(Respi_FzSafe_All(i,:)), i=i+1; ylim([1 6])

% disp
figure
subplot(121)
Data_to_use = Respi_FzShock_All;
Conf_Inter = nanstd(Data_to_use)/sqrt(size(Data_to_use,1));
Mean_All_Sp = nanmean(Data_to_use);
shadedErrorBar([1:100] , Mean_All_Sp , Conf_Inter,'-r',1); hold on;

Data_to_use = Respi_FzSafe_All;
Conf_Inter = nanstd(Data_to_use)/sqrt(size(Data_to_use,1));
Mean_All_Sp = nanmean(Data_to_use);
shadedErrorBar([1:100] , Mean_All_Sp , Conf_Inter,'-b',1); hold on;

subplot(122)
Data_to_use = Respi_FzShock_All-Respi_FzSafe_All;
Conf_Inter = nanstd(Data_to_use)/sqrt(size(Data_to_use,1));
Mean_All_Sp = nanmean(Data_to_use);
shadedErrorBar([1:100] , runmean(Mean_All_Sp,5) , runmean(Conf_Inter,5),'-k',1); hold on;


% all that can be done in one line
[OutPutData ,   , NameEpoch] = MeanValuesPhysiologicalParameters_BM('all_saline',Mouse,'Cond','respi_freq_bm');

% for 
Drug_Group={'SalineSB','ChronicFlx','AcuteFlx','Midazolam','SalineBM_Short','Diazepam_Short','SalineBM_Long','Diazepam_Long','Saline1','Saline2','DZP1','DZP2','RipInhib','ChronicBUS','AcuteBUS','RipControl','RipInhib1','RipControl1','RipInhibPaired','RipControlPaired'};
Session_type={'Cond','Ext'};

for group=[17] % differents experimental groups, here 5 is Saline short
    clear Mouse
    Mouse=Drugs_Groups_UMaze_BM(group); % attribute to Mouse vector the list of Saline short mice
    
    for sess=1:length(Session_type) % run for Cond and Ext session
        [OutPutData.(Drug_Group{group}).(Session_type{sess}) , Epoch1.(Drug_Group{group}).(Session_type{sess}) , NameEpoch] = MeanValuesPhysiologicalParameters_BM('drugs',Mouse,lower(Session_type{sess}),'h_vhigh');
    end
end






