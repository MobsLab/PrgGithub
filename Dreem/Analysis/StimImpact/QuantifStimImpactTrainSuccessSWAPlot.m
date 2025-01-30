% QuantifStimImpactTrainSuccessSWAPlot
% 16.05.2017 KJ
%
% tones success rate and slow waves density
%   -> plot
%
%   see 
%       QuantifStimImpactTrainSuccessSWA QuantifStimImpactTrainSuccessSwDensityPlot
%

%load
clear
load(fullfile(FolderStimImpactData, 'QuantifStimImpactTrainSuccessSWA.mat'))


densityBins = 0:0.2:2.6;
xdata = 0:0.2:2.4;
for p=1:length(swa_res.filename)
    for b=1:length(densityBins)-1
        
        tonesSWA = swa_res.tones.swabefore{p} / swa_res.average.night{p};
        shamSWA = swa_res.sham.swabefore{p} / swa_res.average.night{p};
        
        idx = tonesSWA>=densityBins(b) & tonesSWA<densityBins(b+1);
        before_success.tones(p,b) = mean(swa_res.tones.success{p}(idx)./ swa_res.tones.nb{p}(idx))*100;
        
        idx = shamSWA>=densityBins(b) & shamSWA<densityBins(b+1);
        before_success.sham(p,b) = mean(swa_res.sham.success{p}(idx)./ swa_res.sham.nb{p}(idx))*100;
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





