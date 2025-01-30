%%LFPSpectraN2SupDeep
% 30.08.2019 KJ
%
%
%   Spectra for sup and deep layer in N2
%   
%   
%
% see
%   LayerElectrodeDetectionMetrics PfcSpectrumSubstages LFPlayerAndSpectra
%



% load
clear
load(fullfile(FolderDeltaDataKJ,'LayerElectrodeDetectionMetrics.mat'))
load(fullfile(FolderDeltaDataKJ,'PfcSpectrumSubstages.mat'))


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
    
    elec_feat1     = [];
    elec_feat2     = [];
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
                        elec_feat1 = [elec_feat1 max(y(x1))];
                        elec_feat2 = [elec_feat2 min(y(x2))];
                    %negative deflection
                    else
                        x1 = x>0 & x<=250;
                        x2 = x>200 & x<=350;
                        elec_feat1 = [elec_feat1 min(y(x1))];
                        elec_feat2 = [elec_feat2 max(y(x2))];
                    end
                end
            end
        end
    end
    
    %mean and save
    X(i,:) = [mean(elec_feat1) mean(elec_feat2)];

end

%axes
xp = X(:,1); %first amplitude
yp = X(:,2); %second amplitude


%% electrodes to keep: ecog, sup, deepest


%ecog
ecog_electrodes = electrodes(ecogs==1,:);
ecog_electrodes(ismember(ecog_electrodes,[8 44],'rows'),:)=[]; %noisy

%sup 
sup_electrodes = electrodes((ecogs==0) & (xp<=-150),:);
%deep
deep_electrodes = [];
for m=1:length(animals)
    
    animal_deepest = max(xp(electrodes(:,1)==m));
    deep_electrodes = [deep_electrodes ; electrodes(electrodes(:,1)==m & xp==animal_deepest,:)];
    
end


%% Spectra
normalization = 'norm_f_sp';

%ECOG
for sub=1:5 %substages
    
    meanspectrum.ecog.y{sub} = [];
    
    for i=1:size(ecog_electrodes,1)
        m = ecog_electrodes(i,1);
        elec = ecog_electrodes(i,2);
        
        spectra_elec = [];
        
        for p=1:length(spectra_res.path)
            if strcmpi(animals{m},spectra_res.name{p})
                
                channels = spectra_res.channels{p};
                for ch=1:length(channels)
                    if channels(ch)==elec
                        freq_sub      = spectra_res.spectrum{p}{ch,sub}(:,1);
                        spectrum_sub  = spectra_res.spectrum{p}{ch,sub}(:,2);
                        
                        if strcmpi(normalization,'log_sp')
                            norm_spectrum = 10 * log10(spectrum_sub);
                        elseif strcmpi(normalization,'f_sp')
                            norm_spectrum = freq_sub .* spectrum_sub;
                        elseif strcmpi(normalization,'norm_f_sp')
                            norm_spectrum = freq_sub .* spectrum_sub;
                            norm_spectrum = norm_spectrum / max(norm_spectrum);
                        else
                            norm_spectrum = spectrum_sub;
                        end
                        spectra_elec = [spectra_elec norm_spectrum];

                    end
                end
            end
        end
        
        %electrode averaged
        spectra.ecog.x{i,sub} = freq_sub;
        spectra.ecog.y{i,sub} = mean(spectra_elec,2);    

        meanspectrum.ecog.x{sub} = freq_sub;
        meanspectrum.ecog.y{sub} = [meanspectrum.ecog.y{sub} spectra.ecog.y{i,sub}];
    end
    
    %AVERAGE
    meanspectrum.ecog.std{sub} = std(meanspectrum.ecog.y{sub},0,2)/sqrt(size(meanspectrum.ecog.y{sub},2));
    meanspectrum.ecog.y{sub} = mean(meanspectrum.ecog.y{sub},2);
end


%SUP
for sub=1:5 %substages
    
    meanspectrum.sup.y{sub} = [];
    
    for i=1:size(sup_electrodes,1)
        m = sup_electrodes(i,1);
        elec = sup_electrodes(i,2);
        
        spectra_elec = [];
        
        for p=1:length(spectra_res.path)
            if strcmpi(animals{m},spectra_res.name{p})
                
                channels = spectra_res.channels{p};
                for ch=1:length(channels)
                    if channels(ch)==elec
                        freq_sub      = spectra_res.spectrum{p}{ch,sub}(:,1);
                        spectrum_sub  = spectra_res.spectrum{p}{ch,sub}(:,2);
                        
                        if strcmpi(normalization,'log_sp')
                            norm_spectrum = 10 * log10(spectrum_sub);
                        elseif strcmpi(normalization,'f_sp')
                            norm_spectrum = freq_sub .* spectrum_sub;
                        elseif strcmpi(normalization,'norm_f_sp')
                            norm_spectrum = freq_sub .* spectrum_sub;
                            norm_spectrum = norm_spectrum / max(norm_spectrum);
                        else
                            norm_spectrum = spectrum_sub;
                        end
                        spectra_elec = [spectra_elec norm_spectrum];

                    end
                end
            end
        end
        
        %electrode averaged
        spectra.sup.x{i,sub} = freq_sub;
        spectra.sup.y{i,sub} = mean(spectra_elec,2);    

        meanspectrum.sup.x{sub} = freq_sub;
        meanspectrum.sup.y{sub} = [meanspectrum.sup.y{sub} spectra.sup.y{i,sub}];
    end
    
    %AVERAGE
    meanspectrum.sup.std{sub} = std(meanspectrum.sup.y{sub},0,2)/sqrt(size(meanspectrum.sup.y{sub},2));
    meanspectrum.sup.y{sub} = mean(meanspectrum.sup.y{sub},2);
end


%DEEP
for sub=1:5 %substages
    
    meanspectrum.deep.y{sub} = [];
    
    for i=1:size(deep_electrodes,1)
        m    = deep_electrodes(i,1);
        elec = deep_electrodes(i,2);
        
        spectra_elec = [];
        
        for p=1:length(spectra_res.path)
            if strcmpi(animals{m},spectra_res.name{p})
                
                channels = spectra_res.channels{p};
                for ch=1:length(channels)
                    if channels(ch)==elec
                        freq_sub      = spectra_res.spectrum{p}{ch,sub}(:,1);
                        spectrum_sub  = spectra_res.spectrum{p}{ch,sub}(:,2);
                        
                        if strcmpi(normalization,'log_sp')
                            norm_spectrum = 10 * log10(spectrum_sub);
                        elseif strcmpi(normalization,'f_sp')
                            norm_spectrum = freq_sub .* spectrum_sub;
                        elseif strcmpi(normalization,'norm_f_sp')
                            norm_spectrum = freq_sub .* spectrum_sub;
                            norm_spectrum = norm_spectrum / max(norm_spectrum);
                        end
                        spectra_elec = [spectra_elec norm_spectrum];

                    end
                end
            end
        end
        
        %electrode averaged
        spectra.deep.x{i,sub} = freq_sub;
        spectra.deep.y{i,sub} = mean(spectra_elec,2);    

        meanspectrum.deep.x{sub} = freq_sub;
        meanspectrum.deep.y{sub} = [meanspectrum.deep.y{sub} spectra.deep.y{i,sub}];
    end
    
    %AVERAGE
    meanspectrum.deep.std{sub} = std(meanspectrum.deep.y{sub},0,2)/sqrt(size(meanspectrum.deep.y{sub},2));
    meanspectrum.deep.y{sub}   = mean(meanspectrum.deep.y{sub},2);
    
end


%% PLOT 1
colori = {[0.5 0.3 1], [1 0.5 1], [0.8 0 0.7], [0.1 0.7 0], [0.5 0.2 0.1]}; %substage color
NameSubstages = {'N1','N2','N3','REM'};

figure, hold on

subplot(1,3,1), hold on
for sub=1:4
    Hs(sub) = shadedErrorBar(meanspectrum.ecog.x{sub}, meanspectrum.ecog.y{sub}, meanspectrum.ecog.std{sub},{'markerfacecolor',colori{sub}},0.5);
    h(sub)  = plot(meanspectrum.ecog.x{sub}, meanspectrum.ecog.y{sub},'color', colori{sub},'linewidth',2);
end
set(gca,'xlim',[1.3 25]), hold on
title('EcoG'),
legend(h,NameSubstages),
xlabel('Hz'), ylabel('f*P(f) - mV2')

subplot(1,3,2), hold on
for sub=1:4
    Hs(sub) = shadedErrorBar(meanspectrum.sup.x{sub}, meanspectrum.sup.y{sub}, meanspectrum.sup.std{sub},{'markerfacecolor',colori{sub}},0.5);
    h(sub)  = plot(meanspectrum.sup.x{sub}, meanspectrum.sup.y{sub},'color', colori{sub},'linewidth',2);
end
set(gca,'xlim',[1.3 25]), hold on
title('Sup layer'),
legend(h,NameSubstages),
xlabel('Hz'), ylabel('f*P(f) - mV2')

subplot(1,3,3), hold on
for sub=1:4
    Hs(sub) = shadedErrorBar(meanspectrum.deep.x{sub}, meanspectrum.deep.y{sub}, meanspectrum.deep.std{sub},{'markerfacecolor',colori{sub}},0.5);
    h(sub) = plot(meanspectrum.deep.x{sub}, meanspectrum.deep.y{sub},'color', colori{sub},'linewidth',2);
end
set(gca,'xlim',[1.3 25]), hold on
title('Deep layer'),
xlabel('Hz'), ylabel('f*P(f) - mV2')


%% Plot for each substage
color_ecog = 'k';
color_sup = 'b';
color_deep = 'r';
NameSubstages = {'N1','N2','N3','REM','Wake'};

figure, hold on

for sub=1:5
    clear h
    
    subplot(2,3,sub), hold on
    Hs(1) = shadedErrorBar(meanspectrum.ecog.x{sub}, meanspectrum.ecog.y{sub}, meanspectrum.ecog.std{sub},{'markerfacecolor',color_ecog},0.5);
    h(1)  = plot(meanspectrum.ecog.x{sub}, meanspectrum.ecog.y{sub},'color', color_ecog,'linewidth',2);
    Hs(2) = shadedErrorBar(meanspectrum.sup.x{sub}, meanspectrum.sup.y{sub}, meanspectrum.sup.std{sub},{'markerfacecolor',color_sup},0.5);
    h(2)  = plot(meanspectrum.sup.x{sub}, meanspectrum.sup.y{sub},'color', color_sup,'linewidth',2);
    Hs(3) = shadedErrorBar(meanspectrum.deep.x{sub}, meanspectrum.deep.y{sub}, meanspectrum.deep.std{sub},{'markerfacecolor',color_deep},0.5);
    h(3)  = plot(meanspectrum.deep.x{sub}, meanspectrum.deep.y{sub},'color', color_deep,'linewidth',2);
    
    set(gca,'xlim',[1.3 25]), hold on
    title(NameSubstages{sub}),
    xlabel('Hz'), ylabel('f*P(f) - mV2')
    legend(h,'ecog','sup','deep');

    
end





