function stimKindPosthoc
global FIGURE_DIR 

sign_thresh = 0.05;

hm = getenv('HOME');
A = Analysis([hm filesep 'Data/amyphys']);
FIGURE_DIR = [hm filesep 'Data/amyphys/figuresPaper'];


datasets = List2Cell('datasets_2way.list');


[A, ato] = getResource(A, 'AnovasStimKind4Total', datasets);
A = getResource(A, 'RateObject', datasets);
A = getResource(A, 'RateMonkey', datasets);
A = getResource(A, 'RateHuman', datasets);
A = getResource(A, 'RatioObjectFamiliar', datasets);
A = getResource(A, 'RateObjectUnfamiliar', datasets);

A = getResource(A, 'PostHocPvalMonkey', datasets);
A = getResource(A, 'PostHocPvalHuman', datasets);
A = getResource(A, 'PostHocPvalObject', datasets);
A = getResource(A, 'PostHocPvalObjectFamiliar', datasets);
A = getResource(A, 'PostHocPvaObjectUnfamliar', datasets);


for i = 1:length(ato)
    L = ato{i};
    atop(i) = L{'StimKind'};
end
atop = atop';

sign_cells = find(atop < 0.05);

amyphys_cells = find(isnan(rateObject) & atop < 0.05);
phys12_cells = find(~isnan(rateObject) & atop < 0.05);



%1 = amyphys 2 = phys12

monkeyp1 = sum(postHocPvalMonkey(amyphys_cells) > 0 & ...
    postHocPvalMonkey(amyphys_cells) < sign_thresh/4);
monkeyn1 = sum(postHocPvalMonkey(amyphys_cells) < 0 & ...
    abs(postHocPvalMonkey(amyphys_cells)) < sign_thresh/4);
humanp1 = sum(postHocPvalHuman(amyphys_cells) > 0 & ...
    postHocPvalHuman(amyphys_cells) < sign_thresh/4);
humann1 = sum(postHocPvalHuman(amyphys_cells) < 0 & ...
    abs(postHocPvalHuman(amyphys_cells)) < sign_thresh/4);

familiarp1 = sum(postHocPvalObjectFamiliar(amyphys_cells) > 0 & ...
    postHocPvalObjectFamiliar(amyphys_cells) < sign_thresh/4);
familiarn1 = sum(postHocPvalObjectFamiliar(amyphys_cells) < 0 & ...
    abs(postHocPvalObjectFamiliar(amyphys_cells)) < sign_thresh/4);

unfamiliarp1 = sum(postHocPvalObjectUnfamiliar(amyphys_cells) > 0 & ...
    postHocPvalObjectUnfamiliar(amyphys_cells) < sign_thresh/4);
unfamiliarn1 = sum(postHocPvalObjectUnfamiliar(amyphys_cells) < 0 & ...
    abs(postHocPvalObjectUnfamiliar(amyphys_cells)) < sign_thresh/4);



monkeyp2 = sum(postHocPvalMonkey(phys12_cells) > 0 & ...
    postHocPvalMonkey(phys12_cells) < sign_thresh/3);
monkeyn2 = sum(postHocPvalMonkey(phys12_cells) < 0 & ...
    abs(postHocPvalMonkey(phys12_cells)) < sign_thresh/3);
humanp2 = sum(postHocPvalHuman(phys12_cells) > 0 & ...
    postHocPvalHuman(phys12_cells) < sign_thresh/3);
humann2 = sum(postHocPvalHuman(phys12_cells) < 0 & ...
    abs(postHocPvalHuman(phys12_cells)) < sign_thresh/3);

objectp2 = sum(postHocPvalObject(phys12_cells) > 0 & ...
    postHocPvalObject(phys12_cells) < sign_thresh/3);
objectn2 = sum(postHocPvalObjectFamiliar(phys12_cells) < 0 & ...
    abs(postHocPvalObject(phys12_cells)) < sign_thresh/3);

MRateMonkey1 = mean(rateMonkey(amyphys_cells));
MRateHuman1 = mean(rateHuman(amyphys_cells));
MRateObjectFamiliar1 = mean(rateObjectFamiliar(amyphys_cells));
MRateObjectUnfamiliar1 = mean(rateObjectUnfamiliar(amyphys_cells));

SRateMonkey1 = std(rateMonkey(amyphys_cells));
SRateHuman1 = std(rateHuman(amyphys_cells));
SRateObjectFamiliar1 = std(rateObjectFamiliar(amyphys_cells));
SRateObjectUnfamiliar1 = std(rateObjectUnfamiliar(amyphys_cells));

MRateMonkey2 = mean(rateMonkey(phys12_cells));
MRateHuman2 = mean(rateHuman(phys12_cells));
MRateObject2= mean(rateObject(phys12_cells));

SRateMonkey2 = std(rateMonkey(phys12_cells));
SRateHuman2 = std(rateHuman(phys12_cells));
SRateObject2 = std(rateObject(phys12_cells));



keyboard

atop(atop==0) = 1e-16;
[hi, x] = hist(-log10(atop), linspace(0, 20, 60));
fig.x = x;
fig.n = hi';
fig.figureType = 'hist';
fig.figureName = 'stimKindHist';
fig.xLim = [0 20];
fig.xLabel = 'Category selectivity p-value';
fig.xTick = [0 4 8 12 16 20];
fig.xTickLabel = {'1', '10^{-4}', '10^{-8}', '10^{-12}', '10^{-16}', '10^{-20}'}
fig.yLabel = 'Cell Count';
makeFigure({fig});
plot([q q], [0 35], 'k--', 'linewidth', 2)












