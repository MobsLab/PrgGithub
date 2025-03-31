% QuantifSuccessDeltaToneSubstage2
% 14.11.2016 KJ
%
% quantification of the success of tone to induce delta, for different
% substages
%   - Substages = N1, N2, N3, REM, WAKE
%
%
%   see QuantifSuccessDeltaToneSubstage


%% load
cd([FolderProjetDelta 'Data/'])
clear
load QuantifSuccessDeltaToneSubstage.mat

%% Gather data
animals = unique(deltatone_res.name);

%add delay=-1 for Random conditions
delays = [delays -1];
for p=1:length(deltatone_res.path)
    if strcmpi(deltatone_res.manipe{p},'RdmTone')
        deltatone_res.delay{p} = -1;
    end
end

%data
for sub=substages_ind
    for d=1:length(delays)
        for m=1:length(animals) 
            
            nb_gooddelta = 0;
            nb_baddelta = 0;
            nb_gooddown = 0;
            nb_baddown = 0;
            epoch_duration = 0;
            
            for p=1:length(deltatone_res.path)
                if strcmpi(deltatone_res.name{p},animals(m)) && deltatone_res.delay{p}==delays(d)
                    nb_gooddelta = nb_gooddelta + deltatone_res.gooddelta_substage{p,sub};
                    nb_baddelta = nb_baddelta + deltatone_res.baddelta_substage{p,sub};
                    nb_gooddown = nb_gooddown + deltatone_res.gooddown_substage{p,sub};
                    nb_baddown = nb_baddown + deltatone_res.baddown_substage{p,sub};
                    epoch_duration = epoch_duration + deltatone_res.epoch_duration{p,sub};
                end
            end
                 
            deltas.success.nb(d,sub,m) = nb_gooddelta;
            deltas.success.density(d,sub,m) = nb_gooddelta / epoch_duration;
            deltas.fail.nb(d,sub,m) = nb_baddelta;
            deltas.fail.density(d,sub,m) = nb_baddelta / epoch_duration;
            
            downs.success.nb(d,sub,m) = nb_gooddown;
            downs.success.density(d,sub,m) = nb_gooddown / epoch_duration;
            downs.fail.nb(d,sub,m) = nb_baddown;
            downs.fail.density(d,sub,m) = nb_baddown / epoch_duration;
            
            epoch.tones.nb(d,sub,m) = nb_gooddelta + nb_baddelta;
            epoch.tones.density(d,sub,m) = (nb_gooddelta + nb_baddelta) / epoch_duration;
            epoch.duration(d,sub,m) = epoch_duration;
            
        end
        
    end
end

clear p sub i m nb_badddelta nb_gooddown nb_badddown nb_gooddelta nb_badddelta


%% Plot

labels={'N1','N2','N3','REM','WAKE'};
NameConditions = {'140ms','200ms','320ms','490ms','Random'};
nb_subplot = length(delays);

%Delta success
ratio_success = deltas.success.nb ./ epoch.tones.nb;

figure, hold on
for d=1:length(delays)
    subplot(2,ceil(nb_subplot/2),d),hold on
    data = squeeze(ratio_success(d,:,:))';            
    PlotErrorBarN_KJ(data,'newfig',0,'y_lim',[0 0.9]);
    title(NameConditions{d})
    set(gca, 'XTickLabel',labels, 'XTick',1:numel(labels)), hold on,
end
suplabel('Percentage of successful tones','t');

%Number of tones
figure, hold on
for d=1:length(delays)
    subplot(2,ceil(nb_subplot/2),d),hold on
    data = squeeze(epoch.tones.nb(d,:,:))';            
    PlotErrorBarN_KJ(data,'newfig',0);
    title(NameConditions{d})
    set(gca, 'XTickLabel',labels, 'XTick',1:numel(labels)), hold on,
end
suplabel('Number of tones','t');


%Tones density
figure, hold on
for d=1:length(delays)
    subplot(2,ceil(nb_subplot/2),d),hold on
    data = squeeze(epoch.tones.density(d,:,:))';            
    PlotErrorBarN_KJ(data,'newfig',0);
    title(NameConditions{d})
    set(gca, 'XTickLabel',labels, 'XTick',1:numel(labels)), hold on,
end
suplabel('Tones density','t');



