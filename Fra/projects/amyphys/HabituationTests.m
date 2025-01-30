function HabituationTests

sign_thresh = 0.05;

hm = getenv('HOME');
A = Analysis([hm filesep 'Data/amyphys']);
FIGURE_DIR = [hm filesep 'Data/amyphys/figuresPaper'];

datasets = List2Cell('datasets_2way.list');


A = getResource(A, 'SplitVisualTTest', datasets);
A = getResource(A, 'SplitVisualRate', datasets);
[A, ato] = getResource(A, 'AnovasTotalSplit', datasets);




for i = 1:length(ato)
    L = ato{i};
    atop1(i) = L{'StimKind1'};
    atop2(i) = L{'StimKind2'};
    atow1(i,:) = (L{'2WayExprId1'})';
    atow2(i,:) = (L{'2WayExprId2'})';
end

keyboard
