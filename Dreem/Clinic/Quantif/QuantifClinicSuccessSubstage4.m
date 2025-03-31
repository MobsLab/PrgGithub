% QuantifClinicSuccessSubstage4
% 24.01.2017 KJ
%
% Plot of the ratio of tones evoking slow waves
%   - Sleep stages = N3
%   - 1st success only, 2nd success only, 2-click sucess both
%
%
%   see QuantifClinicSuccessSubstage QuantifClinicSuccessSubstage2 QuantifClinicSuccessSubstage3
%


%load
clear
eval(['load ' FolderPrecomputeDreem 'QuantifClinicSuccessSubstage.mat'])
conditionsWithTones = {'UpPhase','Random'};


%% Concatenate
%params
ranks = 0:3;
n3_stage = 3;

%loop
for cond=1:length(conditionsWithTones)
    for r=1:length(ranks)        
        tones_success = [];
        nb_tones = [];
        
        for p=1:length(success_res.filename)
            if strcmpi(success_res.condition{p},conditionsWithTones{cond})     
                
                if ranks(r)>0 
                    tones_success = [tones_success 0];
                    nb_tones = [nb_tones 0];
                    
                    for i=1:length(success_res.rank_tones{p})-1
                       
                       % N3 tones + 2-click + induced or not
                       if success_res.sleepstage_tone{p}(i)==n3_stage && success_res.rank_tones{p}(i)==1 && success_res.rank_tones{p}(i+1)==2; %succession of first and second
                            nb_tones(end) = nb_tones(end) + 1;
                            induce_first = success_res.induce_slow_wave{p}(i);
                            induce_second = success_res.induce_slow_wave{p}(i+1);

                            if ranks(r)==1 && induce_first && ~induce_second %first only induced slow waves
                                tones_success(end) = tones_success(end) + 1;
                            elseif ranks(r)==2 && ~induce_first && induce_second %second only induced slow waves
                                tones_success(end) = tones_success(end) + 1;
                            elseif ranks(r)==3 && induce_first && induce_second %both induced slow waves
                                tones_success(end) = tones_success(end) + 1;
                            end
                       end
                       
                    end
                else
                    n3_tones = (success_res.sleepstage_tone{p}==n3_stage)'; % N3 tones
                    induce_tones = success_res.induce_slow_wave{p}; % induced or not a slow wave
                    rank_tones = success_res.rank_tones{p} == ranks(r); %first, second or isolated

                    tones_success = [tones_success sum(induce_tones .* n3_tones .* rank_tones)];
                    nb_tones = [nb_tones sum(n3_tones .* rank_tones)];
                end
            end
        end      

        epoch_nb_tones{cond,r} = nb_tones;
        percentage_success{cond,r} = (tones_success ./ nb_tones) * 100;
        
    end
end


%% Plot

labels={'Alone','1st only','2nd only','Both click'};
barcolors = {'k','b','r','g'}; %substage color


figure, hold on
for cond=1:length(conditionsWithTones)
    %Percentage of successful
    subplot(2,2,cond),hold on
    data = percentage_success(cond,:);       
    [~,eb] = PlotErrorBarN_KJ(data,'newfig',0,'barcolors',barcolors,'showPoints',0);
    set(eb,'Linewidth',2); %bold error bar
    title(conditionsWithTones{cond}),
    ylabel('Percentage of tone evoking Slow wave'),
    set(gca, 'XTickLabel',labels, 'XTick',1:numel(labels),'YTick',0:20:70,'YLim',[0 40],'FontName','Times','fontsize',12), hold on,
    
    %Number of tones
    subplot(2,2,cond+2),hold on
    data = epoch_nb_tones(cond,:);             
    [~,eb] = PlotErrorBarN_KJ(data,'newfig',0,'barcolors',barcolors,'showPoints',0);
    set(eb,'Linewidth',2); %bold error bar
    ylabel('Number of tones per night'),
    set(gca, 'XTickLabel',labels, 'XTick',1:numel(labels),'FontName','Times','fontsize',12), hold on,
end

suplabel('Success percentage for each sound','t');








