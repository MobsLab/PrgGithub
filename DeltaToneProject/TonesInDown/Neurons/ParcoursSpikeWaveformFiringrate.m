%%ParcoursSpikeWaveformFiringrate
% 17.01.2019 KJ
%
% Spike waveforms and features correlations
%
% see
%
%

clear
Dir=PathForExperimentsDeltaSleepSpikes('all');
Dir = CheckPathForExperiment_KJ(Dir);


neuron_class = [];
neuron_fr = [];
neuron_ismua = [];
AllWF = [];

for p=1:length(Dir.path)
    
    %goto
    disp(' ')
    disp('****************************************************************')
    eval(['cd(Dir.path{',num2str(p),'}'')'])
    disp(pwd)
        
    % Parameters
    resample_factor = 300;
    
    
    %% load
    
    %waveform
    load MeanWaveform W
    % Get waveforms from electrods with max amplitude
    for ww=1:length(W)
        clear Peak
        for elec=1:4
        try
            Peak{ww}(elec) = min(W{ww}(elec,:));
        end
        end
        [~,BestElec{ww}] = min(Peak{ww});
        AllWF = [AllWF W{ww}(BestElec{ww},:)'];
    end
    
    %info
    load('InfoNeuronsAll.mat')
    neuron_class = [neuron_class ; InfoNeurons.putative];
    neuron_fr = [neuron_fr ; InfoNeurons.firingrate];
    neuron_ismua = [neuron_ismua ; InfoNeurons.ismua];
    
    
end


%% waveform features

for k = 1:size(AllWF,2)
    % resample to higher frequency
    WaveToUseResample(k,:) = resample(AllWF(:,k),resample_factor,1);

    % normalize amplitude
    WaveToUseResample(k,:) = WaveToUseResample(k,:)./(max(WaveToUseResample(k,:))-min(WaveToUseResample(k,:)));

    % Trough To Peak
    [valMin,indMin] = min(WaveToUseResample(k,:)); % find trough
    [~,indPeak] = max(WaveToUseResample(k,indMin:end)); % find next peak
    WFInfo.TroughToPeakTime(k) = indPeak*5e-5/resample_factor;

    % Half amplitude duration
    HalfAmp = valMin/2;
    TimeAtHlafAmp(1) = find(WaveToUseResample(k,:)<HalfAmp,1,'first');
    TimeAtHlafAmp(2) = find(WaveToUseResample(k,:)<HalfAmp,1,'last');
    WFInfo.HalfAmpDur(k) = (TimeAtHlafAmp(2)-TimeAtHlafAmp(1))*5e-5/resample_factor;

    % Half width
    DD = diff(WaveToUseResample(k,:));
    diffpeak = find(DD(indMin:end) == max(DD(indMin:end)))+indMin;
    DD = DD(diffpeak:end);
    IndMax = find(DD<max(abs(diff(WaveToUseResample(k,:))))*0.01,1,'first')+diffpeak;
    if isempty(IndMax)
        IndMax = find(DD<max(abs(diff(WaveToUseResample(k,:))))*0.05,1,'first')+diffpeak;
    end
    if WaveToUseResample(k,IndMax)<0
        if not(isempty(find(WaveToUseResample(k,IndMax:end)>0,1,'first')+IndMax))
            IndMax = find(WaveToUseResample(k,IndMax:end)>0,1,'first')+IndMax ;
        end
    end
    WFInfo.HalfWidth(k) = ((IndMax-indMin)*5e-5)/resample_factor;

    % Area under curve
    WaveToUseResampleTemp = WaveToUseResample(k,indMin:end);
    valzero = find(WaveToUseResampleTemp>0,1,'first');
    WaveToCalc = WaveToUseResampleTemp(valzero:end);
    WFInfo.AreaUnderCurve(k) = sum(abs(WaveToCalc));
    if ~isempty(valzero)
        WFInfo.AreaUnderCurveNorm(k) = sum(abs(WaveToCalc))./(length(WaveToUseResample(k,:))-valzero);
    else
        WFInfo.AreaUnderCurveNorm(k) = 0;
    end

    % Assymetry
    MaxBef = max(WaveToUseResample(k,1:indMin));
    MaxAft = max(WaveToUseResample(k,indMin:end));
    WFInfo.Assymetry(k) = (MaxAft-MaxBef)./(MaxAft+MaxBef);
end


%% remove mua
idx = neuron_ismua==0;

neuron_class = neuron_class(idx);
neuron_fr = neuron_fr(idx);
fields = fieldnames(WFInfo);
for i = 1:numel(fields)
    x = WFInfo.(fields{i});
    WFInfo.(fields{i}) = x(idx);
end



%% Plot
figure, hold on
sz = 20;
fontsize = 13;
neuron_color = neuron_class;

%
subplot(2,2,1), hold on
scatter(neuron_fr, WFInfo.HalfWidth, sz, neuron_color, 'filled'),
set(gca, 'fontsize',fontsize),
xlabel('firing rate'), ylabel('half width'),
title('half width'),

%
subplot(2,2,2), hold on
scatter(neuron_fr, WFInfo.AreaUnderCurveNorm, sz, neuron_color, 'filled'),
set(gca, 'fontsize',fontsize),
xlabel('firing rate'), ylabel('AUC norm'),
title('AUC normalized'),

%
subplot(2,2,3), hold on
scatter(neuron_fr, WFInfo.TroughToPeakTime, sz, neuron_color, 'filled'),
set(gca, 'fontsize',fontsize),
xlabel('firing rate'), ylabel('trough-to-peak time'),
title('trough-to-peak time'),

%
subplot(2,2,4), hold on
scatter(neuron_fr, WFInfo.HalfAmpDur, sz, neuron_color, 'filled'),
set(gca, 'fontsize',fontsize),
xlabel('firing rate'), ylabel('half amplitude duration'),
title('half amplitude duration'),

suplabel('all neurons' ,'t');




