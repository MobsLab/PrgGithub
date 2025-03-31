cd /media/mobs/DataMOBS92/Processed_DATA/M782_processed/M782_SleepBaseline_day_06112018
load('SleepScoring_OBGamma.mat', 'Wake','REMEpoch','SWSEpoch')
sws782Before=sum(End(SWSEpoch,'s')-Start(SWSEpoch,'s'))
rem782Before=sum(End(REMEpoch,'s')-Start(REMEpoch,'s'))
Wake782Before=sum(End(Wake,'s')-Start(Wake,'s'))
Wake782BeforeStart = Start(Wake)./(1e4);
Wake782BeforeEnd = End(Wake)./(1e4); 
Nb_WakeEpoch782Before = length(Wake782BeforeStart); 

cd /media/mobs/MOBs96/M782_Sleep_cage_changed_day_07112018
load('SleepScoring_OBGamma.mat', 'Wake','REMEpoch','SWSEpoch')
sws782After=sum(End(SWSEpoch,'s')-Start(SWSEpoch,'s'))
rem782After=sum(End(REMEpoch,'s')-Start(REMEpoch,'s'))
Wake782After=sum(End(Wake,'s')-Start(Wake,'s'))
Wake782AfterStart = Start(Wake)./(1e4);
Wake782AfterEnd = End(Wake)./(1e4); 
Nb_WakeEpoch782After = length(Wake782AfterStart); 

totalSleep782Before=(rem782Before+sws782Before)
totalSleep782After=(rem782After+sws782After)
raAfter1=rem782After/sws782After
raBefore1=rem782Before/sws782Before
raBefore1wake=Wake782Before/totalSleep782Before
raAfter1wake=Wake782After/totalSleep782After

cd /media/mobs/DataMOBS92/Processed_DATA/M781_processed/M781_SleepBaseline_day_06112018
load('SleepScoring_OBGamma.mat', 'WakeEpoch','REMEpoch','SWSEpoch')
sws781Before=sum(End(SWSEpoch,'s')-Start(SWSEpoch,'s'))
rem781Before=sum(End(REMEpoch,'s')-Start(REMEpoch,'s'))
Wake781Before=sum(End(Wake,'s')-Start(Wake,'s'))

cd /media/mobs/MOBs96/M781_Sleep_cage_changed_day_07112018
load('SleepScoring_OBGamma.mat', 'WakeEpoch','REMEpoch','SWSEpoch')
sws781After=sum(End(SWSEpoch,'s')-Start(SWSEpoch,'s'))
rem781After=sum(End(REMEpoch,'s')-Start(REMEpoch,'s'))
Wake781After=sum(End(Wake,'s')-Start(Wake,'s'))


totalSleep781Before=(rem781Before+sws781Before)
totalSleep781After=(rem781After+sws781After)
raAfter2=rem781After/sws781After;
raBefore2=rem781Before/sws781Before;
raBefore2wake=Wake781Before/totalSleep781Before
raAfter2wake=Wake781After/totalSleep781After


PlotErrorBarN_KJ({Wake781Before,Wake781After})
PlotErrorBarN_KJ({Wake782Before,Wake782After})

timeRecord781Before=(Wake781Before+sws781Before+rem781Before)
timeRecord781After=(Wake781After+sws781After+rem781After)
timeRecord782Before=(Wake782Before+sws782Before+rem782Before)
timeRecord782After=(Wake782After+sws782After+rem782After)

PlotErrorBarN_KJ({timeRecord781Before, timeRecord781After,timeRecord782Before, timeRecord782After})
hold on
PlotErrorBarN_KJ({sws781Before,sws781After,sws782Before,sws782After})

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

cd /media/mobs/DataMOBS92/Processed_DATA/M782_processed/M782_SleepBaseline_day_06112018
load('SleepScoring_OBGamma.mat')

cd /media/mobs/DataMOBS92/Processed_DATA/M781_processed/M781_SleepBaseline_day_06112018
load('SleepScoring_OBGamma.mat', 'WakeEpoch','REMEpoch','SWSEpoch')

cd /media/mobs/MOBs96/M782_Sleep_cage_changed_day_07112018
load('SleepScoring_OBGamma.mat', 'WakeEpoch','REMEpoch','SWSEpoch')

cd /media/mobs/MOBs96/M782_Sleep_cage_changed_day_07112018
load('SleepScoring_OBGamma.mat')

REM781bStart = Start(REMEpoch)./(1e4);
REM781bEnd = End(REMEpoch)./(1e4); 
Nb_REMEpoch781b = length(REM781bStart); 

REM781bduration=REM781bEnd-REM781bStart

histogram((REM781bduration),20)
title('781')

hold on

clear all
DataLocation{2}='/media/mobs/DataMOBS92/Processed_DATA/M781_processed/M781_SleepBaseline_day_06112018';
cd(DataLocation{2})
load('SleepScoring_OBGamma.mat')

REM781cStart = Start(REMEpoch)./(1e4);
REM781cEnd = End(REMEpoch)./(1e4); 
Nb_REMEpoch781c = length(REM781cStart); 

REM781cduration=REM781cEnd-REM781cStart

histogram((REM781cduration),20)

clear all
DataLocation{3}='/media/mobs/MOBs96/M782_Sleep_cage_changed_day_07112018';
cd(DataLocation{3})
load('SleepScoring_OBGamma.mat')

REM782cStart = Start(REMEpoch)./(1e4);
REM782cEnd = End(REMEpoch)./(1e4); 
Nb_REMEpoch782c = length(REM782cStart); 

REM782cduration=REM782cEnd-REM782cStart

figure
histogram((REM782cduration),20)
title('782')

hold on

clear all
DataLocation{4}='/media/mobs/DataMOBS92/Processed_DATA/M782_processed/M782_SleepBaseline_day_06112018';
cd(DataLocation{4})
load('SleepScoring_OBGamma.mat')

REM782bStart = Start(REMEpoch)./(1e4);
REM782bEnd = End(REMEpoch)./(1e4); 
Nb_REMEpoch782b = length(REM782bStart); 

REM782bduration=REM782bEnd-REM782bStart

histogram((REM782bduration),20)












histogram(Stop(REMEpoch,'s')-Start(REMEpoch,'s'),100)
sum(Stop(REMEpoch,'s')-Start(REMEpoch,'s'))./sum(Stop(Sleep,'s')-Start(Sleep,'s'))
DataLocation{1}='/media/mobs/DataMOBS92/Processed_DATA/M781_processed/M781_SleepBaseline_day_06112018';
cd(DataLocation{1})
load('SleepScoring_OBGamma.mat')
REMEPoch
Start(REMEpoch,'s')
Stop(REMEpoch,'s')
length(Start(REMEpoch,'s'))
Stop(REMEpoch,'s')-Start(REMEpoch,'s')
histogram(Stop(REMEpoch,'s')-Start(REMEpoch,'s')
histogram(Stop(REMEpoch,'s')-Start(REMEpoch,'s')))
histogram(Stop(REMEpoch,'s')-Start(REMEpoch,'s'))
histogram(Stop(REMEpoch,'s')-Start(REMEpoch,'s'),1000)
histogram(Stop(REMEpoch,'s')-Start(REMEpoch,'s'),100)
sum(Stop(REMEpoch,'s')-Start(REMEpoch,'s'))./sum(Stop(Sleep,'s')-Start(Sleep,'s'))