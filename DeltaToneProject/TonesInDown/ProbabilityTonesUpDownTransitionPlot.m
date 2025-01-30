%%ProbabilityTonesUpDownTransitionPlot
% 24.05.2018 KJ
%
% Assess the probability for a tones/sham to create a transition up>down or down>up
%   -> Plot
%
% see
%   ProbabilityTonesUpDownTransition
%

%load
clear

load(fullfile(FolderDeltaDataKJ,'ProbabilityTonesUpDownTransition.mat'))

data_down = cell(0);
data_up = cell(0);

for p=1:2%length(transit_res.path)
    
    %In down
    data_down{1}(p) = transit_res.tones.inside.nb_intv1{p} / transit_res.tones.inside.nb{p};
    data_down{2}(p) = transit_res.sham.inside.nb_intv1{p} / transit_res.sham.inside.nb{p};
    data_down{3}(p) = transit_res.tones.inside.nb_intv2{p} / transit_res.tones.inside.nb{p};
    data_down{4}(p) = transit_res.sham.inside.nb_intv2{p} / transit_res.sham.inside.nb{p};
    
    %In up
    data_up{1}(p) = transit_res.tones.outside.nb_intv1{p} / transit_res.tones.outside.nb{p};
    data_up{2}(p) = transit_res.sham.outside.nb_intv1{p} / transit_res.sham.outside.nb{p};
    data_up{3}(p) = transit_res.tones.outside.nb_intv2{p} / transit_res.tones.outside.nb{p};
    data_up{4}(p) = transit_res.sham.outside.nb_intv2{p} / transit_res.sham.outside.nb{p};
    
end


%% Plot
figure, hold on

subplot(1,2,1), hold on
PlotErrorBarN_KJ(data_down, 'newfig',0, 'paired', 0,  'barcolors',{'k',[0.6 0.6 0.6],'k',[0.6 0.6 0.6]}, 'ShowSigstar','sig');
set(gca,'xtick',1:4,'XtickLabel',{'tones 1','sham 1', 'tones 2', 'sham 2'}),
title('Tones in down')

subplot(1,2,2), hold on
PlotErrorBarN_KJ(data_up, 'newfig',0, 'paired', 0,  'barcolors',{'k',[0.6 0.6 0.6],'k',[0.6 0.6 0.6]}, 'ShowSigstar','sig');
set(gca,'xtick',1:4,'XtickLabel',{'tones 1','sham 1', 'tones 2', 'sham 2'}),
title('Tones in Up')





