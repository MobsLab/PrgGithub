% QuantifStimImpactSuccessSwDensityPlot
% 14.05.2017 KJ
%
% tones success rate and slow waves density
%   -> plot
%
%   see 
%       QuantifStimImpactSuccessSwDensity 
%

%load
clear
load(fullfile(FolderStimImpactData, 'QuantifStimImpactSuccessSwDensity.mat'))

densityBins1 = [0:1:14 30];
xdata1 = 0:1:14;
for p=1:length(density_res.filename)
    for b=1:length(densityBins1)-1
        idx = density_res.tones.around{p}>=densityBins1(b) & density_res.tones.around{p}<densityBins1(b+1);
        density_success.tones(p,b) = mean(density_res.tones.success{p}(idx)>0)*100;
        
        idx = density_res.sham.around{p}>=densityBins1(b) & density_res.sham.around{p}<densityBins1(b+1);
        density_success.sham(p,b) = mean(density_res.sham.success{p}(idx)>0)*100;
    end
end

densityBins2 = [0:1:8 15];
xdata2 = 0:1:8;
for p=1:length(density_res.filename)
    for b=1:length(densityBins2)-1
        idx = density_res.tones.before{p}>=densityBins2(b) & density_res.tones.before{p}<densityBins2(b+1);
        before_success.tones(p,b) = mean(density_res.tones.success{p}(idx)>0)*100;
        
        idx = density_res.sham.before{p}>=densityBins2(b) & density_res.sham.before{p}<densityBins2(b+1);
        before_success.sham(p,b) = mean(density_res.sham.success{p}(idx)>0)*100;
    end
end


%% PLOT

%Line
figure, hold on

%around
subplot(2,1,1), hold on
[~,h(1)]=PlotErrorLineN_KJ(density_success.tones,'x_data',xdata1,'newfig',0,'linecolor','k','ShowSigstar','none','errorbars',1,'linespec','-.');
[~,h(2)]=PlotErrorLineN_KJ(density_success.sham,'x_data',xdata1,'newfig',0,'linecolor',[0.75 0.75 0.75],'ShowSigstar','none','linespec','-om','linewidth',3,'errorbars',1);
legend(h,'Tones','Sham')
title('Success rate and density of slow waves','fontsize',16)
ylabel('% of tones/sham followed by a slow waves'), xlabel('density of slow waves around tones/sham')

%before
subplot(2,1,2), hold on
[~,h(1)]=PlotErrorLineN_KJ(before_success.tones,'x_data',xdata2,'newfig',0,'linecolor','k','ShowSigstar','none','errorbars',1,'linespec','-.');
[~,h(2)]=PlotErrorLineN_KJ(before_success.sham,'x_data',xdata2,'newfig',0,'linecolor',[0.75 0.75 0.75],'ShowSigstar','none','linespec','-om','linewidth',3,'errorbars',1);
legend(h,'Tones','Sham')
title('Success rate and density of slow waves','fontsize',16)
ylabel('% of tones/sham followed by a slow waves'), xlabel('density of slow waves before tones/sham')





