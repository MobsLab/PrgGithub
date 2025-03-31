% FiguresGaetan01072015.m

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%% %%%%%%%%%%%%%% Detect evol slow all mice %%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
if 0
    Parcours_EvolutionSlow
end



%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%% %%%%%%%%%%%%%% Detect evol delta all mice %%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
if 0
    AnalyseEvolutionDeltaML
end



%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%% %%%%%%%%%%%%%% Detect evol delta all mice %%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

% Get days with double sleep scoring (ML + SB)
Dir1=PathForExperimentsDeltaSleepNew('BASAL');
Dir1=RestrictPathForExperiment(Dir1,'nMice',[251 252]);
Dir2=PathForExperimentsML('BASAL');
Dir2=RestrictPathForExperiment(Dir2,'Group','WT');
Dir=MergePathForExperiment(Dir1,Dir2);

DbleSleepScor=[];
for man=1:length(Dir.path)
    cd(Dir.path{man})
    if exist('StateEpoch.mat','file') && exist('StateEpochSB.mat','file') && exist('B_High_Spectrum.mat','file')
        disp([num2str(length(DbleSleepScor)+1),'- ',Dir.path{man}]); DbleSleepScor=[DbleSleepScor,man];
    end
end
a=0;

%% generate figure interface a=a+1;
% pourris= 11:14,17,20
a=2;
disp(' '), disp(Dir.path{DbleSleepScor(a)})
ActimetrySleepScorCompar(Dir.path{DbleSleepScor(a)},0)





