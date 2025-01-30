% QuantifClinicSuccessSubstage2
% 15.01.2017 KJ
%
% Plot of the ratio of tones evoking slow waves
%   - Sleep stages = N1, N2, N3, REM, WAKE
%
%
%   see QuantifClinicSuccessSubstage
%


%load
clear
eval(['load ' FolderPrecomputeDreem 'QuantifClinicSuccessSubstage.mat'])
conditionsWithTones = {'UpPhase','Random'};


%% Concatenate
%params


%loop
for cond=1:length(conditionsWithTones)
    for sstage=sleepstage_ind
        tones_success = [];
        nb_tones = [];
        
        for p=1:length(success_res.filename)
            if strcmpi(success_res.condition{p},conditionsWithTones{cond})                
                tones_success = [tones_success sum(success_res.induce_slow_wave{p}' .* (success_res.sleepstage_tone{p}==sstage))];
                nb_tones = [nb_tones sum(success_res.sleepstage_tone{p}==sstage)];
            end
        end      

        epoch_nb_tones{cond,sstage} = nb_tones;
        percentage_success{cond,sstage} = (tones_success ./ nb_tones) * 100;
        
    end
end


%% Plot

labels={'N1','N2','N3','REM','WAKE'};
barcolors = {[0.5 0.3 1], [1 0.5 1], [0.8 0 0.7], [0.1 0.7 0], [0.5 0.2 0.1]}; %substage color
columntest=[1 2;2 3];

figure, hold on
for cond=1:length(conditionsWithTones)
    %Percentage of successful
    subplot(2,2,cond),hold on
    data = percentage_success(cond,:);            
    [~,eb] = PlotErrorBarN_KJ(data,'newfig',0,'ColumnTest',columntest,'barcolors',barcolors,'showPoints',0);
    set(eb,'Linewidth',2); %bold error bar
    title(conditionsWithTones{cond}),
    ylabel('Percentage of tone evoking Slow wave'),
    set(gca, 'XTickLabel',labels, 'XTick',1:numel(labels),'YTick',0:20:70,'FontName','Times','fontsize',12), hold on,
    
    %Number of tones
    subplot(2,2,cond+2),hold on
    data = epoch_nb_tones(cond,:);             
    [~,eb] = PlotErrorBarN_KJ(data,'newfig',0,'ColumnTest',columntest,'barcolors',barcolors,'showPoints',0);
    set(eb,'Linewidth',2); %bold error bar
    ylabel('Number of tones per night'),
    set(gca, 'XTickLabel',labels, 'XTick',1:numel(labels),'FontName','Times','fontsize',12), hold on,
end






