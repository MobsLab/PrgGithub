%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%Calcul multi-mouse%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

%Proportion SWS_Wake_REM
    %Homecage1
PercWake_Total_Homecage1 = [PercWake_Total_923_Homecage1 PercWake_Total_926_Homecage1 PercWake_Total_927_Homecage1 PercWake_Total_928_Homecage1 PercWake_Total_953_Homecage1 PercWake_Total_954_Homecage1]; 
PercSWS_Total_Homecage1 = [PercSWS_Total_923_Homecage1 PercSWS_Total_926_Homecage1 PercSWS_Total_927_Homecage1 PercSWS_Total_928_Homecage1 PercSWS_Total_953_Homecage1 PercSWS_Total_954_Homecage1]; 
PercREM_Total_Homecage1 = [PercREM_Total_923_Homecage1 PercREM_Total_926_Homecage1 PercREM_Total_927_Homecage1 PercREM_Total_928_Homecage1 PercREM_Total_953_Homecage1 PercREM_Total_954_Homecage1]; 

    %CNO
PercWake_Total_CNO = [PercWake_Total_923_CNO PercWake_Total_926_CNO PercWake_Total_927_CNO PercWake_Total_928_CNO PercWake_Total_953_CNO PercWake_Total_954_CNO]; 
PercSWS_Total_CNO = [PercSWS_Total_923_CNO PercSWS_Total_926_CNO PercSWS_Total_927_CNO PercSWS_Total_928_CNO PercSWS_Total_953_CNO PercSWS_Total_954_CNO]; 
PercREM_Total_CNO = [PercREM_Total_923_CNO PercREM_Total_926_CNO PercREM_Total_927_CNO PercREM_Total_928_CNO PercREM_Total_953_CNO PercREM_Total_954_CNO]; 

    %CNO in day 3 923/926
PercWake_Total_CNO_day3 = [PercWake_Total_923_CNO PercWake_Total_926_CNO PercWake_Total_953_CNO PercWake_Total_954_CNO]; 
PercSWS_Total_CNO_day3 = [PercSWS_Total_923_CNO PercSWS_Total_926_CNO PercSWS_Total_953_CNO PercSWS_Total_954_CNO]; 
PercREM_Total_CNO_day3 = [PercREM_Total_923_CNO PercREM_Total_926_CNO PercREM_Total_953_CNO PercREM_Total_954_CNO]; 

    %CNO in day 5
PercWake_Total_CNO_day5 = [PercWake_Total_927_CNO PercWake_Total_928_CNO]; 
PercSWS_Total_CNO_day5 = [PercSWS_Total_927_CNO PercSWS_Total_928_CNO]; 
PercREM_Total_CNO_day5 = [PercREM_Total_927_CNO PercREM_Total_928_CNO]; 
    
    %Homecage2
PercWake_Total_Homecage2 = [PercWake_Total_923_Homecage2 PercWake_Total_926_Homecage2 PercWake_Total_927_Homecage2 PercWake_Total_928_Homecage2 PercWake_Total_953_Homecage2 PercWake_Total_954_Homecage2]; 
PercSWS_Total_Homecage2 = [PercSWS_Total_923_Homecage2 PercSWS_Total_926_Homecage2 PercSWS_Total_927_Homecage2 PercSWS_Total_928_Homecage2 PercSWS_Total_953_Homecage2 PercSWS_Total_954_Homecage2]; 
PercREM_Total_Homecage2 = [PercREM_Total_923_Homecage2 PercREM_Total_926_Homecage2 PercREM_Total_927_Homecage2 PercREM_Total_928_Homecage2 PercREM_Total_953_Homecage2 PercREM_Total_954_Homecage2]; 

    %Saline
PercWake_Total_Saline = [PercWake_Total_923_Saline PercWake_Total_926_Saline PercWake_Total_927_Saline PercWake_Total_928_Saline PercWake_Total_953_Saline PercWake_Total_954_Saline]; 
PercSWS_Total_Saline = [PercSWS_Total_923_Saline PercSWS_Total_926_Saline PercSWS_Total_927_Saline PercSWS_Total_928_Saline PercSWS_Total_953_Saline PercSWS_Total_954_Saline]; 
PercREM_Total_Saline = [PercREM_Total_923_Saline PercREM_Total_926_Saline PercREM_Total_927_Saline PercREM_Total_928_Saline PercREM_Total_953_Saline PercREM_Total_954_Saline]; 

    %Saline in day 3
PercWake_Total_Saline_day3 = [PercWake_Total_927_Saline PercWake_Total_928_Saline]; 
PercSWS_Total_Saline_day3 = [PercSWS_Total_927_Saline PercSWS_Total_928_Saline]; 
PercREM_Total_Saline_day3 = [PercREM_Total_927_Saline PercREM_Total_928_Saline]; 

    %Saline in day 5
PercWake_Total_Saline_day5 = [PercWake_Total_923_Saline PercWake_Total_926_Saline PercWake_Total_953_Saline PercWake_Total_954_Saline]; 
PercSWS_Total_Saline_day5 = [PercSWS_Total_923_Saline PercSWS_Total_926_Saline PercSWS_Total_953_Saline PercSWS_Total_954_Saline]; 
PercREM_Total_Saline_day5 = [PercREM_Total_923_Saline PercREM_Total_926_Saline PercREM_Total_953_Saline PercREM_Total_954_Saline]; 

    
% SWS
PlotErrorBarN_KJ({PercSWS_Total_Homecage1 PercSWS_Total_CNO PercSWS_Total_Homecage2 PercSWS_Total_Saline})
ylabel('Proportion (%)')
xlabel('Conditions')
title('SWS proportion')
xticklabels({'','Homecage1','Exchange CNO','Homecage2', 'Exchange saline'})

% Wake
PlotErrorBarN_KJ({PercWake_Total_Homecage1 PercWake_Total_CNO PercWake_Total_Homecage2 PercWake_Total_Saline})
ylabel('Proportion (%)')
xlabel('Conditions')
title('Wake proportion')
xticklabels({'','Homecage1','Exchange CNO','Homecage2', 'Exchange saline'})

% REM
PlotErrorBarN_KJ({PercREM_Total_Homecage1 PercREM_Total_CNO PercREM_Total_Homecage2 PercREM_Total_Saline})
ylabel('Proportion (%)')
xlabel('Conditions')
title('REM proportion')
xticklabels({'','Homecage1','Exchange CNO','Homecage2', 'Exchange saline'})

% REM for order CNO->Saline 
PlotErrorBarN_KJ({PercREM_Total_Saline_day3 PercREM_Total_CNO_day5 PercREM_Total_Saline_day5 PercREM_Total_CNO_day3})
ylabel('Proportion (%REM)')
xlabel('Conditions')
title('REM proportion (order Saline->CNO vs CNO->Saline)')
xticklabels({'Saline_day3','CNO_day5','Saline_day5','CNO_day3'})

%Number of bouts in homecage1 condition
Nb_SWSEpoch_Homecage1=[Nb_SWSEpoch923Homecage1 Nb_SWSEpoch926Homecage1 Nb_SWSEpoch927Homecage1 Nb_SWSEpoch928Homecage1 Nb_SWSEpoch953Homecage1 Nb_SWSEpoch954Homecage1]
Nb_WakeEpoch_Homecage1=[Nb_WakeEpoch923Homecage1 Nb_WakeEpoch926Homecage1 Nb_WakeEpoch927Homecage1 Nb_WakeEpoch928Homecage1 Nb_WakeEpoch953Homecage1 Nb_WakeEpoch954Homecage1]
Nb_REMEpoch_Homecage1=[Nb_REMEpoch923Homecage1 Nb_REMEpoch926Homecage1 Nb_REMEpoch927Homecage1 Nb_REMEpoch928Homecage1 Nb_REMEpoch953Homecage1 Nb_REMEpoch954Homecage1]

%Number of bouts in CNO condition
Nb_SWSEpoch_CNO=[Nb_SWSEpoch923CNO Nb_SWSEpoch926CNO Nb_SWSEpoch927CNO Nb_SWSEpoch928CNO Nb_SWSEpoch953CNO Nb_SWSEpoch954CNO]
Nb_WakeEpoch_CNO=[Nb_WakeEpoch923CNO Nb_WakeEpoch926CNO Nb_WakeEpoch927CNO Nb_WakeEpoch928CNO Nb_WakeEpoch953CNO Nb_WakeEpoch954CNO]
Nb_REMEpoch_CNO=[Nb_REMEpoch923CNO Nb_REMEpoch926CNO Nb_REMEpoch927CNO Nb_REMEpoch928CNO Nb_REMEpoch953CNO Nb_REMEpoch954CNO]

%Number of bouts in homecage2 condition
Nb_SWSEpoch_Homecage2=[Nb_SWSEpoch923Homecage2 Nb_SWSEpoch926Homecage2 Nb_SWSEpoch927Homecage2 Nb_SWSEpoch928Homecage2 Nb_SWSEpoch953Homecage2 Nb_SWSEpoch954Homecage2]
Nb_WakeEpoch_Homecage2=[Nb_WakeEpoch923Homecage2 Nb_WakeEpoch926Homecage2 Nb_WakeEpoch927Homecage2 Nb_WakeEpoch928Homecage2 Nb_WakeEpoch953Homecage2 Nb_WakeEpoch954Homecage2]
Nb_REMEpoch_Homecage2=[Nb_REMEpoch923Homecage2 Nb_REMEpoch926Homecage2 Nb_REMEpoch927Homecage2 Nb_REMEpoch928Homecage2 Nb_REMEpoch953Homecage2 Nb_REMEpoch954Homecage2]

%Number of bouts in Saline condition
Nb_SWSEpoch_Saline=[Nb_SWSEpoch923Saline Nb_SWSEpoch926Saline Nb_SWSEpoch927Saline Nb_SWSEpoch928Saline Nb_SWSEpoch953Saline Nb_SWSEpoch954Saline]
Nb_WakeEpoch_Saline=[Nb_WakeEpoch923Saline Nb_WakeEpoch926Saline Nb_WakeEpoch927Saline Nb_WakeEpoch928Saline Nb_WakeEpoch953Saline Nb_WakeEpoch954Saline]
Nb_REMEpoch_Saline=[Nb_REMEpoch923Saline Nb_REMEpoch926Saline Nb_REMEpoch927Saline Nb_REMEpoch928Saline Nb_REMEpoch953Saline Nb_REMEpoch954Saline]

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
xticklabels({'','Homecage1','Exchange CNO','Homecage2', 'Exchange saline'})

PlotErrorBarN_KJ({Nb_WakeEpoch_Homecage1 Nb_WakeEpoch_CNO Nb_WakeEpoch_Homecage2 Nb_WakeEpoch_Saline})
ylabel('Number of events')
xlabel('Conditions')
title('Number of Wake events')
xticklabels({'','Homecage1','Exchange CNO','Homecage2', 'Exchange saline'})

PlotErrorBarN_KJ({Nb_REMEpoch_Homecage1 Nb_REMEpoch_CNO Nb_REMEpoch_Homecage2 Nb_REMEpoch_Saline})
ylabel('Number of events')
xlabel('Conditions')
title('Number of REM events')
xticklabels({'','Homecage1','Exchange CNO','Homecage2', 'Exchange saline'})


%Calcul ratio SWS vs Total Sleep Mouse 923-926-927-928-953-954
ra_Homecage1_SWSTotal=[ra923_Homecage1_SWSTotal ra926_Homecage1_SWSTotal ra927_Homecage1_SWSTotal ra928_Homecage1_SWSTotal ra953_Homecage1_SWSTotal ra954_Homecage1_SWSTotal]
ra_CNO_SWSTotal=[ra923_CNO_SWSTotal ra926_CNO_SWSTotal ra927_CNO_SWSTotal ra928_CNO_SWSTotal ra953_CNO_SWSTotal ra954_CNO_SWSTotal]
ra_Homecage2_SWSTotal=[ra923_Homecage2_SWSTotal ra926_Homecage2_SWSTotal ra927_Homecage2_SWSTotal ra928_Homecage2_SWSTotal ra953_Homecage2_SWSTotal ra954_Homecage2_SWSTotal]
ra_Saline_SWSTotal=[ra923_Saline_SWSTotal ra926_Saline_SWSTotal ra927_Saline_SWSTotal ra928_Saline_SWSTotal ra953_Saline_SWSTotal ra954_Saline_SWSTotal]

PlotErrorBarN_KJ({ra_Homecage1_SWSTotal,ra_CNO_SWSTotal,ra_Homecage2_SWSTotal,ra_Saline_SWSTotal})
ylabel('ratio SWS/TotalSleep')
xlabel('Conditions')
title('Ratio SWS/Total (homecage1, Exchange Cage CNO, homecage2, Saline)')
xticklabels({'','Homecage1','Exchange CNO','Homecage2','Exchange Saline'})

%Calcul ratio REM vs Total Sleep Mouse 923-926-927-928-953-954
ra_Homecage1_REMTotal=[ra923_Homecage1_REMTotal ra926_Homecage1_REMTotal ra927_Homecage1_REMTotal ra928_Homecage1_REMTotal ra953_Homecage1_REMTotal ra954_Homecage1_REMTotal]
ra_CNO_REMTotal=[ra923_CNO_REMTotal ra926_CNO_REMTotal ra927_CNO_REMTotal ra928_CNO_REMTotal ra953_CNO_REMTotal ra954_CNO_REMTotal]
ra_Homecage2_REMTotal=[ra923_Homecage2_REMTotal ra926_Homecage2_REMTotal ra927_Homecage2_REMTotal ra928_Homecage2_REMTotal ra953_Homecage2_REMTotal ra954_Homecage2_REMTotal]
ra_Saline_REMTotal=[ra923_Saline_REMTotal ra926_Saline_REMTotal ra927_Saline_REMTotal ra928_Saline_REMTotal ra953_Saline_REMTotal ra954_Saline_REMTotal]

PlotErrorBarN_KJ({ra_Homecage1_REMTotal,ra_CNO_REMTotal,ra_Homecage2_REMTotal,ra_Saline_REMTotal})
ylabel('ratio REM/TotalSleep')
xlabel('Conditions')
title('Ratio REM/Total (homecage1, Exchange Cage CNO, homecage2, Saline)')
xticklabels({'','Homecage1','Exchange CNO','Homecage2','Exchange Saline'})
   

%Calcul ratio REM vs Total Sleep Mouse 923-926-953-954 (ordre CNO->Saline)
ra_Homecage1_REMTotal_order_CNO_Saline=[ra923_Homecage1_REMTotal ra926_Homecage1_REMTotal ra953_Homecage1_REMTotal ra954_Homecage1_REMTotal]
ra_CNO_REMTotal_order_CNO_Saline=[ra923_CNO_REMTotal ra926_CNO_REMTotal ra953_CNO_REMTotal ra954_CNO_REMTotal]
ra_Homecage2_REMTotal_order_CNO_Saline=[ra923_Homecage2_REMTotal ra926_Homecage2_REMTotal ra953_Homecage2_REMTotal ra954_Homecage2_REMTotal]
ra_Saline_REMTotal_order_CNO_Saline=[ra923_Saline_REMTotal ra926_Saline_REMTotal ra953_Saline_REMTotal ra954_Saline_REMTotal]

PlotErrorBarN_KJ({ra_Homecage1_REMTotal_order_CNO_Saline ,ra_CNO_REMTotal_order_CNO_Saline,ra_Homecage2_REMTotal_order_CNO_Saline,ra_Saline_REMTotal_order_CNO_Saline})
ylabel('ratio REM/TotalSleep')
xlabel('Conditions')
title('Ratio REM/Total (order: homecage1 -> Exchange Cage CNO -> homecage2 -> Saline)')
xticklabels({'','Homecage1','Exchange CNO','Homecage2','Exchange Saline'})

%Calcul ratio REM vs Total Sleep Mouse 923-926-953-954 (ordre Saline->CNO)
ra_Homecage1_REMTotal_order_Saline_CNO=[ra927_Homecage1_REMTotal ra928_Homecage1_REMTotal]
ra_CNO_REMTotal_order_Saline_CNO=[ra927_CNO_REMTotal ra928_CNO_REMTotal]
ra_Homecage2_REMTotal_order_Saline_CNO=[ra927_Homecage2_REMTotal ra928_Homecage2_REMTotal]
ra_Saline_REMTotal_order_Saline_CNO=[ra927_Saline_REMTotal ra928_Saline_REMTotal]

PlotErrorBarN_KJ({ra_Homecage1_REMTotal_order_Saline_CNO ,ra_Saline_REMTotal_order_Saline_CNO, ra_Homecage2_REMTotal_order_Saline_CNO, ra_CNO_REMTotal_order_Saline_CNO,})
ylabel('ratio REM/TotalSleep')
xlabel('Conditions')
title('Ratio REM/Total (order: homecage1 -> Saline -> homecage2 -> Exchange Cage CNO)')
xticklabels({'','Homecage1','Exchange Saline','Homecage2','Exchange CNO'})


%Calcul durée total recordings Mouse 923-926-927-928-953-954
%923
timeRecord923Homecage1=(Wake923Homecage1DurationTot+SWS923Homecage1DurationTot+REM923Homecage1DurationTot)
timeRecord923CNO=(Wake923CNODurationTot+SWS923CNODurationTot+REM923CNODurationTot)
timeRecord923Homecage2=(Wake923Homecage2DurationTot+SWS923Homecage2DurationTot+REM923Homecage2DurationTot)
timeRecord923Saline=(Wake923SalineDurationTot+SWS923SalineDurationTot+REM923SalineDurationTot)
PlotErrorBarN_KJ({timeRecord923Homecage1, timeRecord923CNO,timeRecord923Homecage2, timeRecord923Saline})
%926
timeRecord926Homecage1=(Wake926Homecage1DurationTot+SWS926Homecage1DurationTot+REM926Homecage1DurationTot)
timeRecord926CNO=(Wake926CNODurationTot+SWS926CNODurationTot+REM926CNODurationTot)
timeRecord926Homecage2=(Wake926Homecage2DurationTot+SWS926Homecage2DurationTot+REM926Homecage2DurationTot)
timeRecord926Saline=(Wake926SalineDurationTot+SWS926SalineDurationTot+REM926SalineDurationTot)
PlotErrorBarN_KJ({timeRecord926Homecage1, timeRecord926CNO,timeRecord926Homecage2, timeRecord926Saline})
%927
timeRecord927Homecage1=(Wake927Homecage1DurationTot+SWS927Homecage1DurationTot+REM927Homecage1DurationTot)
timeRecord927CNO=(Wake927CNODurationTot+SWS927CNODurationTot+REM927CNODurationTot)
timeRecord927Homecage2=(Wake927Homecage2DurationTot+SWS927Homecage2DurationTot+REM927Homecage2DurationTot)
timeRecord927Saline=(Wake927SalineDurationTot+SWS927SalineDurationTot+REM927SalineDurationTot)
PlotErrorBarN_KJ({timeRecord927Homecage1, timeRecord927CNO,timeRecord927Homecage2, timeRecord927Saline})
%928
timeRecord928Homecage1=(Wake928Homecage1DurationTot+SWS928Homecage1DurationTot+REM928Homecage1DurationTot)
timeRecord928CNO=(Wake928CNODurationTot+SWS928CNODurationTot+REM928CNODurationTot)
timeRecord928Homecage2=(Wake928Homecage2DurationTot+SWS928Homecage2DurationTot+REM928Homecage2DurationTot)
timeRecord928Saline=(Wake928SalineDurationTot+SWS928SalineDurationTot+REM928SalineDurationTot)
PlotErrorBarN_KJ({timeRecord928Homecage1, timeRecord928CNO,timeRecord928Homecage2, timeRecord928Saline})

%953
timeRecord953Homecage1=(Wake953Homecage1DurationTot+SWS953Homecage1DurationTot+REM953Homecage1DurationTot)
timeRecord953CNO=(Wake953CNODurationTot+SWS953CNODurationTot+REM953CNODurationTot)
timeRecord953Homecage2=(Wake953Homecage2DurationTot+SWS953Homecage2DurationTot+REM953Homecage2DurationTot)
timeRecord953Saline=(Wake953SalineDurationTot+SWS953SalineDurationTot+REM953SalineDurationTot)
PlotErrorBarN_KJ({timeRecord953Homecage1, timeRecord953CNO,timeRecord953Homecage2, timeRecord953Saline})

%954
timeRecord954Homecage1=(Wake954Homecage1DurationTot+SWS954Homecage1DurationTot+REM954Homecage1DurationTot)
timeRecord954CNO=(Wake954CNODurationTot+SWS954CNODurationTot+REM954CNODurationTot)
timeRecord954Homecage2=(Wake954Homecage2DurationTot+SWS954Homecage2DurationTot+REM954Homecage2DurationTot)
timeRecord954Saline=(Wake954SalineDurationTot+SWS954SalineDurationTot+REM954SalineDurationTot)
PlotErrorBarN_KJ({timeRecord954Homecage1, timeRecord954CNO,timeRecord954Homecage2, timeRecord954Saline})

timeRecord_Homecage1=[timeRecord923Homecage1 timeRecord926Homecage1 timeRecord927Homecage1 timeRecord928Homecage1 timeRecord953Homecage1 timeRecord954Homecage1]; 
timeRecord_CNO=[timeRecord923CNO timeRecord926CNO timeRecord927CNO timeRecord928CNO timeRecord953CNO timeRecord954CNO]; 
timeRecord_Homecage2=[timeRecord923Homecage2 timeRecord926Homecage2 timeRecord927Homecage2 timeRecord928Homecage2 timeRecord953Homecage2 timeRecord954Homecage2]; 
timeRecord_Saline=[timeRecord923Saline timeRecord926Saline timeRecord927Saline timeRecord928Saline timeRecord953Saline timeRecord954Saline]; 

PlotErrorBarN_KJ({timeRecord_Homecage1, timeRecord_CNO,timeRecord_Homecage2, timeRecord_Saline})
ylabel('Duration')
xlabel('Conditions')
title('Recording Durations')
xticklabels({'','Homecage1','CNO','Homecage2', 'saline'})

%% Pourcentage first_second_third

% Poucentage REM Homecage1
PercFirstHalfHomecage1 = [PercFirstHalfHomecage1_923 PercFirstHalfHomecage1_926 PercFirstHalfHomecage1_927 PercFirstHalfHomecage1_928 PercFirstHalfHomecage1_953 PercFirstHalfHomecage1_954]
PercSecHalfHomecage1 = [PercSecHalfHomecage1_923 PercSecHalfHomecage1_926 PercSecHalfHomecage1_927 PercSecHalfHomecage1_928 PercSecHalfHomecage1_953 PercSecHalfHomecage1_954]
PercFirstThirdHomecage1 = [PercFirstThirdHomecage1_923 PercFirstThirdHomecage1_926 PercFirstThirdHomecage1_927 PercFirstThirdHomecage1_928 PercFirstThirdHomecage1_953 PercFirstThirdHomecage1_954]
PercSecThirdHomecage1 = [PercSecThirdHomecage1_923 PercSecThirdHomecage1_926 PercSecThirdHomecage1_927 PercSecThirdHomecage1_928 PercSecThirdHomecage1_953 PercSecThirdHomecage1_954]
PercLastThirdHomecage1 = [PercLastThirdHomecage1_923 PercLastThirdHomecage1_926 PercLastThirdHomecage1_927 PercLastThirdHomecage1_928 PercLastThirdHomecage1_953 PercLastThirdHomecage1_954]

%Graphe mean_%REM_Homecage1
PlotErrorBarN_KJ({PercFirstHalfHomecage1 PercSecHalfHomecage1 PercFirstThirdHomecage1 PercSecThirdHomecage1 PercLastThirdHomecage1})
ylabel('%REM')
xlabel('Periods')
title('Percentage REM in different periods Homecage1')
xticklabels({'FirstHalf','SecondHalf','FirstThird','SecondThird', 'LastThird'})

%Pourcentage REM CNO Exchange 
PercFirstHalfCNO = [PercFirstHalfCNO_923 PercFirstHalfCNO_926 PercFirstHalfCNO_927 PercFirstHalfCNO_928 PercFirstHalfCNO_953 PercFirstHalfCNO_954]
PercSecHalfCNO = [PercSecHalfCNO_923 PercSecHalfCNO_926 PercSecHalfCNO_927 PercSecHalfCNO_928 PercSecHalfCNO_953 PercSecHalfCNO_954]
PercFirstThirdCNO = [PercFirstThirdCNO_923 PercFirstThirdCNO_926 PercFirstThirdCNO_927 PercFirstThirdCNO_928 PercFirstThirdCNO_953 PercFirstThirdCNO_954]
PercSecThirdCNO = [PercSecThirdCNO_923 PercSecThirdCNO_926 PercSecThirdCNO_927 PercSecThirdCNO_928 PercSecThirdCNO_953 PercSecThirdCNO_954]
PercLastThirdCNO = [PercLastThirdCNO_923 PercLastThirdCNO_926 PercLastThirdCNO_927 PercLastThirdCNO_928 PercLastThirdCNO_953 PercLastThirdCNO_954]

%Graphe mean_%REM_CNO
PlotErrorBarN_KJ({PercFirstHalfCNO PercSecHalfCNO PercFirstThirdCNO PercSecThirdCNO PercLastThirdCNO})
ylabel('%REM')
xlabel('Periods')
title('Percentage REM in different periods CNO')
xticklabels({'FirstHalf','SecondHalf','FirstThird','SecondThird', 'LastThird'})

%Pourcentage REMHomecage2
PercFirstHalfHomecage2 = [PercFirstHalfHomecage2_923 PercFirstHalfHomecage2_926 PercFirstHalfHomecage2_927 PercFirstHalfHomecage2_928 PercFirstHalfHomecage2_953 PercFirstHalfHomecage2_954]
PercSecHalfHomecage2 = [PercSecHalfHomecage2_923 PercSecHalfHomecage2_926 PercSecHalfHomecage2_927 PercSecHalfHomecage2_928 PercSecHalfHomecage2_953 PercSecHalfHomecage2_954]
PercFirstThirdHomecage2 = [PercFirstThirdHomecage2_923 PercFirstThirdHomecage2_926 PercFirstThirdHomecage2_927 PercFirstThirdHomecage2_928 PercFirstThirdHomecage2_953 PercFirstThirdHomecage2_954]
PercSecThirdHomecage2 = [PercSecThirdHomecage2_923 PercSecThirdHomecage2_926 PercSecThirdHomecage2_927 PercSecThirdHomecage2_928 PercSecThirdHomecage2_953 PercSecThirdHomecage2_954]
PercLastThirdHomecage2 = [PercLastThirdHomecage2_923 PercLastThirdHomecage2_926 PercLastThirdHomecage2_927 PercLastThirdHomecage2_928 PercLastThirdHomecage2_953 PercLastThirdHomecage2_954]

%Graphe mean_%REM_Homecage2
PlotErrorBarN_KJ({PercFirstHalfHomecage2 PercSecHalfHomecage2 PercFirstThirdHomecage2 PercSecThirdHomecage2 PercLastThirdHomecage2})
ylabel('%REM')
xlabel('Periods')
title('Percentage REM in different periods Homecage2')
xticklabels({'FirstHalf','SecondHalf','FirstThird','SecondThird', 'LastThird'})

%Saline
PercFirstHalfSaline = [PercFirstHalfSaline_923 PercFirstHalfSaline_926 PercFirstHalfSaline_927 PercFirstHalfSaline_928 PercFirstHalfSaline_953 PercFirstHalfSaline_954]
PercSecHalfSaline = [PercSecHalfSaline_923 PercSecHalfSaline_926 PercSecHalfSaline_927 PercSecHalfSaline_928 PercSecHalfSaline_953 PercSecHalfSaline_954]
PercFirstThirdSaline = [PercFirstThirdSaline_923 PercFirstThirdSaline_926 PercFirstThirdSaline_927 PercFirstThirdSaline_928 PercFirstThirdSaline_953 PercFirstThirdSaline_954]
PercSecThirdSaline = [PercSecThirdSaline_923 PercSecThirdSaline_926 PercSecThirdSaline_927 PercSecThirdSaline_928 PercSecThirdSaline_953 PercSecThirdSaline_954]
PercLastThirdSaline = [PercLastThirdSaline_923 PercLastThirdSaline_926 PercLastThirdSaline_927 PercLastThirdSaline_928 PercLastThirdSaline_953 PercLastThirdSaline_954]

%Graphe mean_%REM_Saline
PlotErrorBarN_KJ({PercFirstHalfSaline PercSecHalfSaline PercFirstThirdSaline PercSecThirdSaline PercLastThirdSaline})
ylabel('%REM')
xlabel('Periods')
title('Percentage REM in different periods Saline')
xticklabels({'FirstHalf','SecondHalf','FirstThird','SecondThird', 'LastThird'})

%Graphe mean_%REM_for First_Third period
PlotErrorBarN_KJ({PercFirstThirdHomecage1 PercFirstThirdCNO PercFirstThirdHomecage2 PercFirstThirdSaline})
ylabel('%REM')
xlabel('Conditions')
title('Percentage REM in First Third of recording')
xticklabels({'HomeCage1','CNO','Homecage2','Saline'})

%Graphe mean_%REM_for Second_Third period
PlotErrorBarN_KJ({PercSecThirdHomecage1 PercSecThirdCNO PercSecThirdHomecage2 PercSecThirdSaline})
ylabel('%REM')
xlabel('Conditions')
title('Percentage REM in Sec Third of recording')
xticklabels({'HomeCage1','CNO','Homecage2','Saline'})

%Graphe mean_%REM_for Last_Third period
PlotErrorBarN_KJ({PercLastThirdHomecage1 PercLastThirdCNO PercLastThirdHomecage2 PercLastThirdSaline})
ylabel('%REM')
xlabel('Conditions')
title('Percentage REM in Last Third of recording')
xticklabels({'HomeCage1','CNO','Homecage2','Saline'})

%Graphe mean_%REM_for First_Half period
PlotErrorBarN_KJ({PercFirstHalfHomecage1 PercFirstHalfCNO PercFirstHalfHomecage2 PercFirstHalfSaline})
ylabel('%REM')
xlabel('Conditions')
title('Percentage REM in First Half of recording')
xticklabels({'HomeCage1','CNO','Homecage2','Saline'})

%Graphe mean_%REM_for Second_Half period
PlotErrorBarN_KJ({PercSecHalfHomecage1 PercSecHalfCNO PercSecHalfHomecage2 PercSecHalfSaline})
ylabel('%REM')
xlabel('Conditions')
title('Percentage REM in Second Half of recording')
xticklabels({'HomeCage1','CNO','Homecage2','Saline'})