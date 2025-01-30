%%DownstateNbNeuronsNeed1
%
% 14.03.2018 KJ
%
% see
%   DownstatesSubpopulationAnalysisFiringRate DownstatesSubpopulationAnalysis_bis
%


% load
clear
load(fullfile(FolderDeltaDataKJ,'DownstatesSubpopulationAnalysisFiringRate.mat'))
load(fullfile(FolderDeltaDataKJ,'DownstatesSubpopulationAnalysis_bis.mat'))


range_nbneurons = range_nbneurons(1:18);
x_neurons = unique(range_nbneurons);

Mat_mua=[];
k=0;

for p=1:length(subfr_res.path)
    for i=1:length(range_nbneurons)
        if ~isempty(subfr_res.sws.fr{p,i})
            k=k+1;
            nb_neurons(k) = range_nbneurons(i);
            sws_fr(k) = subfr_res.sws.fr{p,i};
            
            mean_mua{k} = subfr_res.meansub{p,i}(:,2);
            Mat_mua = [Mat_mua;mean_mua{k}'];
            x_mua{k} = subfr_res.meansub{p,i}(:,1);
            
            precision(k) = suball_res.detect.sub_alone{p,i};
            sub_firing(k) = (subfr_res.firingDown{p,i} / subfr_res.subdown_dur{p,i});
            
        end
    end
    
end

%% precision

%sort by number of neurons
for i=1:length(x_neurons)
    idx = nb_neurons==x_neurons(i);
    y_precision_neur{i} = precision(idx);
    y_firing_neur{i} = sub_firing(idx);
end

%sort by firing rate
[~, idx] = sort(sws_fr);
range_fr = 0:10:120;
x_firing = (range_fr(2:end)+range_fr(1:end-1))/2;

for i=1:length(range_fr)-1
    idx = sws_fr>=range_fr(i) & sws_fr<range_fr(i+1);
    y_precision_fr{i} = precision(idx);
    y_firing_fr{i} = sub_firing(idx);
end

figure, hold on
subplot(2,2,1), hold on
PlotErrorLineN_KJ(y_firing_neur, 'newfig',0, 'x_data', x_neurons, 'errorbars', 1);
subplot(2,2,2), hold on
PlotErrorLineN_KJ(y_firing_fr, 'newfig',0, 'x_data', x_firing, 'errorbars', 1);
subplot(2,2,3), hold on
PlotErrorLineN_KJ(y_precision_neur, 'newfig',0, 'x_data', x_neurons, 'errorbars', 1);
subplot(2,2,4), hold on
PlotErrorLineN_KJ(y_precision_fr, 'newfig',0, 'x_data', x_firing, 'errorbars', 1);


% %% raster mean firing rate
% [~, idx] = sort(sws_fr);
% sorted_mua = Mat_mua(idx,:);
% 
% 
% figure, hold on
% imagesc(x_mua{1}/1E3, 1:size(sorted_mua,2), sorted_mua), hold on
% ylabel('# tone'), hold on
% line([0 0], ylim,'Linewidth',2,'color','k'), hold on
% line(xlim, [0 size(sorted_mua,2)],'color','k'), hold on
% set(gca,'YLim', [0 size(sorted_mua,2)], 'xlim', [-400 400]/1000,'FontName','Times','fontsize',12);
% hb = colorbar('location','eastoutside'); hold on
% 
% % yyaxis right
% % y_mua = mean(Mat_mua(sws_fr>=0 & sws_fr<30,:),1);
% % hold on, plot(x_mua{1}/1E3, y_mua)
% 






