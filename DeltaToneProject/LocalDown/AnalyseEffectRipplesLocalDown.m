%%AnalyseEffectRipplesLocalDown
% 09.09.2019 KJ
%
% Infos
%   check the effect of ripples on local down and check where is the
%   electrode
%
% see
%     ScriptOccurenceRipplesFakeDeltaDeep
%    


% load
clear

%% Reload layer electrode 2D-space

load(fullfile(FolderDeltaDataKJ,'LayerElectrodeDetectionMetrics.mat'))
% unique animals & electrodes
[animals, electrodes, all_electrodes, ecogs] = Get_uniqueElectrodes_KJ(layer_res);

%% Features in 2D-space
% meancurves
meancurves = layer_res.down.meandown;
    
%features extraction
X = nan(size(electrodes));
for i=1:size(electrodes,1)
    m = electrodes(i,1);
    elec = electrodes(i,2);
    
    feat1     = [];
    feat2     = [];
    %look for electrode data
    for p=1:length(layer_res.path)
        if strcmpi(animals{m},layer_res.name{p})
            channels = layer_res.channels{p};
            for ch=1:length(channels)
                if channels(ch)==elec
                    
                    x = meancurves{p}{ch}(:,1);
                    y = meancurves{p}{ch}(:,2);
                    %postive deflection
                    if sum(y(x>0 & x<=150))>0
                        x1 = x>0 & x<=200;
                        x2 = x>150 & x<=350;
                        feat1 = [feat1 max(y(x1))];
                        feat2 = [feat2 min(y(x2))];
                    %negative deflection
                    else
                        x1 = x>0 & x<=250;
                        x2 = x>200 & x<=350;
                        feat1 = [feat1 min(y(x1))];
                        feat2 = [feat2 max(y(x2))];
                    end
                end
            end
        end
    end
    
    %mean and save
    X(i,:) = [mean(feat1) mean(feat2)];

end


%just keep features
clearvars -except X
xp = X(:,1); %first amplitude
yp = X(:,2); %second amplitude


%% Tetrodes
load(fullfile(FolderDeltaDataKJ,'ScriptOccurenceRipplesFakeDeltaDeep.mat'))

animals = unique(crosscorr_res.name);

all_animals = [];
all_electrodes = [];
for p=1:length(crosscorr_res.path)
    for tt=1:length(crosscorr_res.tetrodes{p})
        all_electrodes = [all_electrodes ; [p,tt]];
        all_animals = [all_animals find(strcmpi(animals,crosscorr_res.name{p}))];
    end
end


%% Ripples response
rip_responses = [];

for p=1:length(crosscorr_res.path)
    for tt=1:length(crosscorr_res.tetrodes{p})
        x_cc = crosscorr_res.down.local{p,tt}(:,1);
        y_cc = crosscorr_res.down.local{p,tt}(:,2);

        %find tetrode with down after ripples
        Cc_norm = zscore(y_cc); 
        Cc_norm = y_cc/mean(y_cc(x_cc<-800));
        rip_responses = [rip_responses max(Cc_norm(x_cc>0&x_cc<100))];
    end
end


%% meancurves

feat1 = [];
feat2 = [];

for p=1:length(crosscorr_res.path)
    for tt=1:length(crosscorr_res.tetrodes{p})

        x = crosscorr_res.meandown{p,tt}(:,1);
        y = crosscorr_res.meandown{p,tt}(:,2);
        
        %postive deflection
        if sum(y(x>0 & x<=150))>0
            x1 = x>0 & x<=200;
            x2 = x>150 & x<=350;
            feat1 = [feat1 max(y(x1))];
            feat2 = [feat2 min(y(x2))];
        %negative deflection
        else
            x1 = x>0 & x<=250;
            x2 = x>200 & x<=350;
            feat1 = [feat1 min(y(x1))];
            feat2 = [feat2 max(y(x2))];
        end
        
    end
end


%% high and low values
low_values = [];
high_values = [];

for m=1:length(animals)
    [~, idx] = sort(feat1(all_animals==m));
    y_values = rip_responses(all_animals==m);
    y_values = y_values(idx);
    
    databar(m,1) = mean(y_values(1:3));
    databar(m,2) = mean(y_values(end-2:end));
    
end


%% PLOT

figure, hold on
PlotErrorBarN_KJ(databar, 'newfig',0, 'paired',1, 'optiontest','ttest', 'showPoints',1,'ShowSigstar','sig');
set(gca,'XTick',1:2 ,'XTickLabel',{'lowest LFP response on down','highest'})
ylabel('Occurence of local down after ripples')
title('Ripples generates more local down on deep layers')

figure, hold on
PlotErrorBarN_KJ(databar, 'newfig',0, 'paired',1, 'optiontest','ranksum', 'showPoints',1,'ShowSigstar','sig');
set(gca,'XTick',1:2 ,'XTickLabel',{'lowest LFP response on down','highest'})
ylabel('Occurence of local down after ripples')
title('Ripples generates more local down on deep layers')











