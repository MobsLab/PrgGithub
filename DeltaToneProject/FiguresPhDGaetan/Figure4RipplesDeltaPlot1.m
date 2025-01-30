% Figure4RipplesDeltaPlot1
% 10.12.2016 KJ
%
% Plot the figures from the Figure4.pdf of Gaetan PhD
% 
% 
%   see Figure4RipplesDelta Figure4RipplesDeltaPlot2
%


clear
load([FolderProjetDelta 'Data/Figure4RipplesDelta.mat']) 

conditions = unique(figure4_res.manipe);
labels_sessions = {'S1','S2','S3','S4','S5'};
basal_colors = {'k'};
deltatone_colors = {'k','b','k','b','k'};
rdmtone_colors = {'k','g','k','g','k'};
condition_colors = {basal_colors;deltatone_colors;rdmtone_colors};

figure, hold on
for cond=1:length(conditions)
    
    %delta density
    subplot(2,3,cond),hold on
    delta_density_cond = [];
    for p=1:length(figure4_res.path)
        if strcmpi(figure4_res.manipe{p}, conditions{cond})
            delta_density_cond = [delta_density_cond ; squeeze(figure4_res.delta.density(p,:))];
        end
    end
    delta_density_cond(delta_density_cond==0)=nan;
    delta_density_cond(delta_density_cond>2)=nan;
    
    PlotErrorBarN_KJ(delta_density_cond, 'newfig',0,'barcolors',condition_colors{cond},'y_lim',[0 3]);
    ylabel('Delta waves frequency'),
    set(gca, 'XTickLabel',labels_sessions, 'XTick',1:numel(labels_sessions)), hold on,
    title(conditions{cond})
   
    
    %SPW-Rs density
    subplot(2,3,cond+3),hold on
    ripples_density_cond = [];
    for p=1:length(figure4_res.path)
        if strcmpi(figure4_res.manipe{p}, conditions{cond})
            ripples_density_cond = [ripples_density_cond ; squeeze(figure4_res.ripples.density(p,:))];
        end
    end
    ripples_density_cond(ripples_density_cond>2)=nan;
    
    PlotErrorBarN_KJ(ripples_density_cond, 'newfig',0,'barcolors',condition_colors{cond},'y_lim',[0 0.1]);
    ylabel('SPW-Rs frequency'),
    set(gca, 'XTickLabel',labels_sessions, 'XTick',1:numel(labels_sessions)), hold on,
    title(conditions{cond})
    
end
suplabel('Delta and SPW-Rs frequency','t');


figure, hold on
for cond=1:length(conditions)
    
    %Coupled delta-SPWR number
    subplot(2,3,cond),hold on
    nb_deltaripped = [];
    for p=1:length(figure4_res.path)
        if strcmpi(figure4_res.manipe{p}, conditions{cond})
            nb_deltaripped = [nb_deltaripped ; squeeze(figure4_res.session.number.delta_ripped(p,:))];
        end
    end
    
    PlotErrorBarN_KJ(nb_deltaripped, 'newfig',0,'barcolors',condition_colors{cond},'y_lim',[0 150]);
    ylabel('Number of Delta Preceeded by a SPW-Rs'),
    set(gca, 'XTickLabel',labels_sessions, 'XTick',1:numel(labels_sessions)), hold on,
    title(conditions{cond})
   
    
    %Non Coupled delta - number
    subplot(2,3,cond+3),hold on
    nb_delta_alone = [];
    for p=1:length(figure4_res.path)
        if strcmpi(figure4_res.manipe{p}, conditions{cond})
            nb_delta_alone = [nb_delta_alone ; squeeze(figure4_res.session.number.delta_alone(p,:))];
        end
    end
    
    PlotErrorBarN_KJ(nb_delta_alone, 'newfig',0,'barcolors',condition_colors{cond},'y_lim',[0 12000]);
    ylabel('Number of Delta non preceeded by a SPW-Rs'),
    set(gca, 'XTickLabel',labels_sessions, 'XTick',1:numel(labels_sessions)), hold on,
    title(conditions{cond})
    
end
suplabel('Delta preceeded by SPW-Rs','t');




