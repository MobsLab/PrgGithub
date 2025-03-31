%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%Calcul multi-mouse%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

%Proportion SWS_Wake_REM
    %Homecage1
PercWake_Total_Homecage1 = [PercWake_Total_929_Homecage1 PercWake_Total_930_Homecage1]; 
PercSWS_Total_Homecage1 = [PercSWS_Total_929_Homecage1 PercSWS_Total_930_Homecage1]; 
PercREM_Total_Homecage1 = [PercREM_Total_929_Homecage1 PercREM_Total_930_Homecage1]; 

    %CNO
PercWake_Total_CNO = [PercWake_Total_929_CNO PercWake_Total_930_CNO]; 
PercSWS_Total_CNO = [PercSWS_Total_929_CNO PercSWS_Total_930_CNO]; 
PercREM_Total_CNO = [PercREM_Total_929_CNO PercREM_Total_930_CNO]; 
 
    %Homecage2
PercWake_Total_Homecage2 = [PercWake_Total_929_Homecage2 PercWake_Total_930_Homecage2]; 
PercSWS_Total_Homecage2 = [PercSWS_Total_929_Homecage2 PercSWS_Total_930_Homecage2]; 
PercREM_Total_Homecage2 = [PercREM_Total_929_Homecage2 PercREM_Total_930_Homecage2]; 

    %Saline
PercWake_Total_Saline = [PercWake_Total_929_Saline PercWake_Total_930_Saline]; 
PercSWS_Total_Saline = [PercSWS_Total_929_Saline PercSWS_Total_930_Saline]; 
PercREM_Total_Saline = [PercREM_Total_929_Saline PercREM_Total_930_Saline]; 

% SWS
PlotErrorBarN_KJ({PercSWS_Total_Homecage1 PercSWS_Total_CNO PercSWS_Total_Homecage2 PercSWS_Total_Saline})
ylabel('Proportion (%)')
xlabel('Conditions')
title('SWS proportion')
xticklabels({'','SWS Homecage1','SWS CNO','SWS Homecage2', 'SWS saline'})

% Wake
PlotErrorBarN_KJ({PercWake_Total_Homecage1 PercWake_Total_CNO PercWake_Total_Homecage2 PercWake_Total_Saline})
ylabel('Proportion (%)')
xlabel('Conditions')
title('Wake proportion')
xticklabels({'','Wake Homecage1','Wake CNO','Wake Homecage2', 'Wake saline'})

% REM
PlotErrorBarN_KJ({PercREM_Total_Homecage1 PercREM_Total_CNO PercREM_Total_Homecage2 PercREM_Total_Saline})
ylabel('Proportion (%)')
xlabel('Conditions')
title('REM proportion')
xticklabels({'','REM Homecage1','REM CNO','REM Homecage2', 'REM saline'})


%Number of bouts in homecage1 condition
Nb_SWSEpoch_Homecage1=[Nb_SWSEpoch929Homecage1 Nb_SWSEpoch930Homecage1]
Nb_WakeEpoch_Homecage1=[Nb_WakeEpoch929Homecage1 Nb_WakeEpoch930Homecage1]
Nb_REMEpoch_Homecage1=[Nb_REMEpoch929Homecage1 Nb_REMEpoch930Homecage1]

%Number of bouts in CNO condition
Nb_SWSEpoch_CNO=[Nb_SWSEpoch929CNO Nb_SWSEpoch930CNO]
Nb_WakeEpoch_CNO=[Nb_WakeEpoch929CNO Nb_WakeEpoch930CNO]
Nb_REMEpoch_CNO=[Nb_REMEpoch929CNO Nb_REMEpoch930CNO]

%Number of bouts in homecage2 condition
Nb_SWSEpoch_Homecage2=[Nb_SWSEpoch929Homecage2 Nb_SWSEpoch930Homecage2]
Nb_WakeEpoch_Homecage2=[Nb_WakeEpoch929Homecage2 Nb_WakeEpoch930Homecage2]
Nb_REMEpoch_Homecage2=[Nb_REMEpoch929Homecage2 Nb_REMEpoch930Homecage2]

%Number of bouts in Saline condition
Nb_SWSEpoch_Saline=[Nb_SWSEpoch929Saline Nb_SWSEpoch930Saline]
Nb_WakeEpoch_Saline=[Nb_WakeEpoch929Saline Nb_WakeEpoch930Saline]
Nb_REMEpoch_Saline=[Nb_REMEpoch929Saline Nb_REMEpoch930Saline]

%Figures Number of events in states

PlotErrorBarN_KJ({Nb_SWSEpoch_Homecage1 Nb_WakeEpoch_Homecage1 Nb_REMEpoch_Homecage1})
ylabel('Number of events')
xlabel('Conditions')
title('Number of sate events (Homecage1)')
xticklabels({'','','SWS', '','Wake','', 'REM'})

PlotErrorBarN_KJ({Nb_SWSEpoch_CNO Nb_WakeEpoch_CNO Nb_REMEpoch_CNO})
ylabel('Number of events')
xlabel('Conditions')
title('Number of sate events (CNO)')
xticklabels({'','','SWS Exchange', '','Wake Exchange','', 'REM Exchange'})

PlotErrorBarN_KJ({Nb_SWSEpoch_Homecage2 Nb_WakeEpoch_Homecage2 Nb_REMEpoch_Homecage2})
ylabel('Number of events')
xlabel('Conditions')
title('Number of sate events (Homecage2)')
xticklabels({'','','SWS', '','Wake','', 'REM'})

PlotErrorBarN_KJ({Nb_SWSEpoch_Saline Nb_WakeEpoch_Saline Nb_REMEpoch_Saline})
ylabel('Number of events')
xlabel('Conditions')
title('Number of sate events (Saline)')
xticklabels({'','','SWS Exchange', '','Wake Exchange','', 'REM Exchange'})

%Figures Number of events in conditions

PlotErrorBarN_KJ({Nb_SWSEpoch_Homecage1 Nb_SWSEpoch_CNO Nb_SWSEpoch_Homecage2 Nb_SWSEpoch_Saline})
ylabel('Number of events')
xlabel('Conditions')
title('Number of SWS events')
xticklabels({'','Homecage1','CNO','Homecage2', 'saline'})

PlotErrorBarN_KJ({Nb_WakeEpoch_Homecage1 Nb_WakeEpoch_CNO Nb_WakeEpoch_Homecage2 Nb_WakeEpoch_Saline})
ylabel('Number of events')
xlabel('Conditions')
title('Number of Wake events')
xticklabels({'','Homecage1','CNO','Homecage2', 'saline'})

PlotErrorBarN_KJ({Nb_REMEpoch_Homecage1 Nb_REMEpoch_CNO Nb_REMEpoch_Homecage2 Nb_REMEpoch_Saline})
ylabel('Number of events')
xlabel('Conditions')
title('Number of REM events')
xticklabels({'','Homecage1','CNO','Homecage2', 'saline'})


%Calcul ratio SWS vs Total Sleep Mouse 929-930
ra_Homecage1_SWSTotal=[ra929_Homecage1_SWSTotal ra930_Homecage1_SWSTotal]
ra_CNO_SWSTotal=[ra929_CNO_SWSTotal ra930_CNO_SWSTotal]
ra_Homecage2_SWSTotal=[ra929_Homecage2_SWSTotal ra930_Homecage2_SWSTotal]
ra_Saline_SWSTotal=[ra929_Saline_SWSTotal ra930_Saline_SWSTotal]

PlotErrorBarN_KJ({ra_Homecage1_SWSTotal,ra_CNO_SWSTotal,ra_Homecage2_SWSTotal,ra_Saline_SWSTotal})
ylabel('ratio SWS/TotalSleep')
xlabel('Conditions')
title('Ratio SWS/Total (homecage1, Exchange Cage CNO, homecage2, Saline)')
xticklabels({'','Homecage1','Exchange CNO','Homecage2','Exchange Saline'})

%Calcul ratio REM vs Total Sleep Mouse 929-930
ra_Homecage_REMTotal=[ra929_Homecage1_REMTotal ra930_Homecage1_REMTotal]
ra_CNO_REMTotal=[ra929_CNO_REMTotal ra930_CNO_REMTotal]
ra_Homecage2_REMTotal=[ra929_Homecage2_REMTotal ra930_Homecage2_REMTotal]
ra_Saline_REMTotal=[ra929_Saline_REMTotal ra930_Saline_REMTotal]

PlotErrorBarN_KJ({ra_Homecage_REMTotal,ra_CNO_REMTotal,ra_Homecage2_REMTotal,ra_Saline_REMTotal})
ylabel('ratio REM/TotalSleep')
xlabel('Conditions')
title('Ratio REM/Total (homecage1, Exchange Cage CNO, homecage2, Saline)')
xticklabels({'','Homecage1','Exchange CNO','Homecage2','Exchange Saline'})
   
%Calcul durée total recordings Mouse 929-930
%929
timeRecord929Homecage1=(Wake929Homecage1DurationTot+SWS929Homecage1DurationTot+REM929Homecage1DurationTot)
timeRecord929CNO=(Wake929CNODurationTot+SWS929CNODurationTot+REM929CNODurationTot)
timeRecord929Homecage2=(Wake929Homecage2DurationTot+SWS929Homecage2DurationTot+REM929Homecage2DurationTot)
timeRecord929Saline=(Wake929SalineDurationTot+SWS929SalineDurationTot+REM929SalineDurationTot)
PlotErrorBarN_KJ({timeRecord929Homecage1, timeRecord929CNO,timeRecord929Homecage2, timeRecord929Saline})
%930
timeRecord930Homecage1=(Wake930Homecage1DurationTot+SWS930Homecage1DurationTot+REM930Homecage1DurationTot)
timeRecord930CNO=(Wake930CNODurationTot+SWS930CNODurationTot+REM930CNODurationTot)
timeRecord930Homecage2=(Wake930Homecage2DurationTot+SWS930Homecage2DurationTot+REM930Homecage2DurationTot)
timeRecord930Saline=(Wake930SalineDurationTot+SWS930SalineDurationTot+REM930SalineDurationTot)
PlotErrorBarN_KJ({timeRecord930Homecage1, timeRecord930CNO,timeRecord930Homecage2, timeRecord930Saline})

timeRecord_Homecage1=[timeRecord929Homecage1 timeRecord930Homecage1]; 
timeRecord_CNO=[timeRecord929CNO timeRecord930CNO]; 
timeRecord_Homecage2=[timeRecord929Homecage2 timeRecord930Homecage2]; 
timeRecord_Saline=[timeRecord929Saline timeRecord930Saline]; 

PlotErrorBarN_KJ({timeRecord_Homecage1, timeRecord_CNO,timeRecord_Homecage2, timeRecord_Saline})
ylabel('Duration')
xlabel('Conditions')
title('Recording Durations')
xticklabels({'','Homecage1','CNO','Homecage2', 'saline'})

%% Pourcentage first_second_third

% Poucentage REM Homecage1
PercFirstHalfHomecage1 = [PercFirstHalfHomecage1_929 PercFirstHalfHomecage1_930]
PercSecHalfHomecage1 = [PercSecHalfHomecage1_929 PercSecHalfHomecage1_930]
PercFirstThirdHomecage1 = [PercFirstThirdHomecage1_929 PercFirstThirdHomecage1_930]
PercSecThirdHomecage1 = [PercSecThirdHomecage1_929 PercSecThirdHomecage1_930]
PercLastThirdHomecage1 = [PercLastThirdHomecage1_929 PercLastThirdHomecage1_930]

%Graphe mean_%REM_Homecage1
PlotErrorBarN_KJ({PercFirstHalfHomecage1 PercSecHalfHomecage1 PercFirstThirdHomecage1 PercSecThirdHomecage1 PercLastThirdHomecage1})
ylabel('%REM')
xlabel('Periods')
title('Percentage REM in different periods Homecage1')
xticklabels({'FirstHalf','SecondHalf','FirstThird','SecondThird','LastThird'})
set(gca,'FontSize',14)
xticks([1 2 3 4 5])

%Pourcentage REM CNO Exchange 
PercFirstHalfCNO = [PercFirstHalfCNO_929 PercFirstHalfCNO_930]
PercSecHalfCNO = [PercSecHalfCNO_929 PercSecHalfCNO_930]
PercFirstThirdCNO = [PercFirstThirdCNO_929 PercFirstThirdCNO_930]
PercSecThirdCNO = [PercSecThirdCNO_929 PercSecThirdCNO_930]
PercLastThirdCNO = [PercLastThirdCNO_929 PercLastThirdCNO_930]

%Graphe mean_%REM_CNO
PlotErrorBarN_KJ({PercFirstHalfCNO PercSecHalfCNO PercFirstThirdCNO PercSecThirdCNO PercLastThirdCNO})
ylabel('%REM')
xlabel('Periods')
title('Percentage REM in different periods CNO')
xticklabels({'FirstHalf','SecondHalf','FirstThird','SecondThird', 'LastThird'})
set(gca,'FontSize',14)
xticks([1 2 3 4 5])

%Pourcentage REMHomecage2
PercFirstHalfHomecage2 = [PercFirstHalfHomecage2_929 PercFirstHalfHomecage2_930]
PercSecHalfHomecage2 = [PercSecHalfHomecage2_929 PercSecHalfHomecage2_930]
PercFirstThirdHomecage2 = [PercFirstThirdHomecage2_929 PercFirstThirdHomecage2_930]
PercSecThirdHomecage2 = [PercSecThirdHomecage2_929 PercSecThirdHomecage2_930]
PercLastThirdHomecage2 = [PercLastThirdHomecage2_929 PercLastThirdHomecage2_930]
set(gca,'FontSize',14)
xticks([1 2 3 4 5])

%Graphe mean_%REM_Homecage2
PlotErrorBarN_KJ({PercFirstHalfHomecage2 PercSecHalfHomecage2 PercFirstThirdHomecage2 PercSecThirdHomecage2 PercLastThirdHomecage2})
ylabel('%REM')
xlabel('Periods')
title('Percentage REM in different periods Homecage2')
xticklabels({'FirstHalf','SecondHalf','FirstThird','SecondThird', 'LastThird'})
set(gca,'FontSize',14)
xticks([1 2 3 4 5])

%Saline
PercFirstHalfSaline = [PercFirstHalfSaline_929 PercFirstHalfSaline_930]
PercSecHalfSaline = [PercSecHalfSaline_929 PercSecHalfSaline_930]
PercFirstThirdSaline = [PercFirstThirdSaline_929 PercFirstThirdSaline_930]
PercSecThirdSaline = [PercSecThirdSaline_929 PercSecThirdSaline_930]
PercLastThirdSaline = [PercLastThirdSaline_929 PercLastThirdSaline_930]
set(gca,'FontSize',14)
xticks([1 2 3 4 5])

%Graphe mean_%REM_Saline
PlotErrorBarN_KJ({PercFirstHalfSaline PercSecHalfSaline PercFirstThirdSaline PercSecThirdSaline PercLastThirdSaline})
ylabel('%REM')
xlabel('Periods')
title('Percentage REM in different periods Saline')
xticklabels({'FirstHalf','SecondHalf','FirstThird','SecondThird', 'LastThird'})
set(gca,'FontSize',14)
xticks([1 2 3 4 5])

%Graphe mean_%REM_for First_Third period
PlotErrorBarN_KJ({PercFirstThirdHomecage1 PercFirstThirdCNO PercFirstThirdHomecage2 PercFirstThirdSaline})
ylabel('%REM')
xlabel('Conditions')
title('Percentage REM in First Third of recording')
xticklabels({'HomeCage1','CNO','Homecage2','Saline'})
set(gca,'FontSize',14)
xticks([1 2 3 4 5])

%Graphe mean_%REM_for Second_Third period
PlotErrorBarN_KJ({PercSecThirdHomecage1 PercSecThirdCNO PercSecThirdHomecage2 PercSecThirdSaline})
ylabel('%REM')
xlabel('Conditions')
title('Percentage REM in Sec Third of recording')
xticklabels({'HomeCage1','CNO','Homecage2','Saline'})
set(gca,'FontSize',14)
xticks([1 2 3 4 5])

%Graphe mean_%REM_for Last_Third period
PlotErrorBarN_KJ({PercLastThirdHomecage1 PercLastThirdCNO PercLastThirdHomecage2 PercLastThirdSaline})
ylabel('%REM')
xlabel('Conditions')
title('Percentage REM in Last Third of recording')
xticklabels({'HomeCage1','CNO','Homecage2','Saline'})
set(gca,'FontSize',14)
xticks([1 2 3 4 5])

%Graphe mean_%REM_for First_Half period
PlotErrorBarN_KJ({PercFirstHalfHomecage1 PercFirstHalfCNO PercFirstHalfHomecage2 PercFirstHalfSaline})
ylabel('%REM')
xlabel('Conditions')
title('Percentage REM in First Half of recording')
xticklabels({'HomeCage1','CNO','Homecage2','Saline'})
set(gca,'FontSize',14)
xticks([1 2 3 4 5])

%Graphe mean_%REM_for Second_Half period
PlotErrorBarN_KJ({PercSecHalfHomecage1 PercSecHalfCNO PercSecHalfHomecage2 PercSecHalfSaline})
ylabel('%REM')
xlabel('Conditions')
title('Percentage REM in Second Half of recording')
xticklabels({'HomeCage1','CNO','Homecage2','Saline'})
set(gca,'FontSize',14)
xticks([1 2 3 4 5])
