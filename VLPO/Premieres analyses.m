load('SleepScoring_OBGamma.mat')

% Nombre d'épisodes REM
REM1=length(Start(REMEpoch,'s'))
% durée totae des épisode
REM2=sum(Stop(REMEpoch,'s')-Start(REMEpoch,'s'))
% pourcentage de rem sur tout sommeil
REM3=sum(Stop(REMEpoch,'s')-Start(REMEpoch,'s'))./sum(Stop(Sleep,'s')-Start(Sleep,'s'))

% Nombre d'épisodes SWSEpoch
SWS1=length(Start(SWSEpoch,'s'))
% durée totale des épisodes
SWS2=sum(Stop(SWSEpoch,'s')-Start(SWSEpoch,'s'))
% pourcentage de SWS sur tout sommeil
SWS3=sum(Stop(SWSEpoch,'s')-Start(SWSEpoch,'s'))./sum(Stop(Sleep,'s')-Start(Sleep,'s'))

% Nombre d'épisodes Wake
W1=length(Start(Wake,'s'))
% durée totale des épisodes
W2=sum(Stop(Wake,'s')-Start(Wake,'s'))
% Ratio Wake/sleep
W3=sum(Stop(Wake,'s')-Start(Wake,'s'))/sum(Stop(Sleep,'s')-Start(Sleep,'s'))

%Ratio Wake/temps total
W4=sum(Stop(Wake,'s')-Start(Wake,'s'))/(sum(Stop(Sleep,'s')-Start(Sleep,'s'))+sum(Stop(Wake,'s')-Start(Wake,'s')))

%%Matrice avec les valeurs précédentes (dans le même ordre)
M=[REM1 REM2 REM3 SWS1 SWS2 SWS3 W1 W2 W3 W4]
