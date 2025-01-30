% QuantifStimImpactTrainSuccessSwDensityPlot
% 16.05.2017 KJ
%
% tones success rate and slow waves density
%   -> plot
%
%   see 
%       QuantifStimImpactTrainSuccessSwDensity QuantifStimImpactSuccessSwDensityPlot
%

%load
clear
load(fullfile(FolderStimImpactData, 'QuantifStimImpactTrainSuccessSwDensity.mat'))


densityBins = [0:1:6 20];
xdata = 0:1:6;
for p=1:length(dens_res.filename)
    for b=1:length(densityBins)-1
        idx = dens_res.tones.before{p}>=densityBins(b) & dens_res.tones.before{p}<densityBins(b+1);
        before_success.tones(p,b) = mean(dens_res.tones.success{p}(idx)./ dens_res.tones.nb{p}(idx))*100;
        
        idx = dens_res.sham.before{p}>=densityBins(b) & dens_res.sham.before{p}<densityBins(b+1);
        before_success.sham(p,b) = mean(dens_res.sham.success{p}(idx)./ dens_res.sham.nb{p}(idx))*100;
    end
end

%% PLOT

%Line
figure, hold on

%before
[~,h(1)]=PlotErrorLineN_KJ(before_success.tones,'x_data',xdata,'newfig',0,'linecolor','k','ShowSigstar','none','errorbars',1,'linespec','-.');
[~,h(2)]=PlotErrorLineN_KJ(before_success.sham,'x_data',xdata,'newfig',0,'linecolor',[0.75 0.75 0.75],'ShowSigstar','none','linespec','-om','linewidth',3,'errorbars',1);
legend(h,'Tones','Sham')
title('Success rate and density of slow waves','fontsize',16)
ylabel('% of tones/sham followed by a slow waves'), xlabel('density of slow waves before tones/sham')





