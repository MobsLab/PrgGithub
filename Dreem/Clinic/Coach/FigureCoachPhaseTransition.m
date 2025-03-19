% FigureCoachPhaseTransition
% 29.03.2017 KJ
%
% plot the transitions
%
%
% see 
%   FigureCoachPhaseDuration ClinicTransitionSleepStage ClinicTransitionSleepStagePlot
%  

figure, hold on

transitions = [3 5;2 5; 4 5; 2 4];

for i=1:size(transitions,1)
    subplot(2,2,i), hold on
    stage_before = transitions(i,1);
    stage_after = transitions(i,2);
    ClinicTransitionSleepStagePlot(stage_before, stage_after, 'ratio',0,'newfig',0);
end
suplabel('Sleep Stages Transitions','t');

