%%PlotRipplesCorrectedPethNeuron2
% 11.09.2018 KJ
%
%
%
% see
%   GenerateTonePethNeuron PlotTonePethNeuron GenerateRipplesPethNeuron PlotRipplesPethNeuron
%


clear

Dir = PathForExperimentsSleepRipplesSpikes('all');
% Dir = PathForExperimentsSleepRipplesSpikes('tone');
Dir = CheckPathForExperiment_KJ(Dir);

AllPeth = [];

%get data for each record
for p=1:length(Dir.path)

    eval(['cd(Dir.path{',num2str(p),'}'')'])
%     disp(' ')
%     disp('****************************************************************')
%     disp(pwd)
    
    clearvars -except Dir p AllPeth
    
    %ripples correlogram   
    load(fullfile(FolderDeltaDataKJ, 'neuronResponseTones.mat'), 'responses')
    load('RipplesCorrectedPeth2.mat', 'MatCorr', 't_corr')
    AllPeth = [AllPeth ; MatCorr];

%         selected_neurons = find(responses.Big{p}==1);
%         selected_neurons = find((responses.N2{p}==1 | responses.N3{p}==1) & strcmpi(responses.area{p},'pfcx'));
%         selected_neurons = find((responses.N2{p}==-1 | responses.N3{p}==-1) & strcmpi(responses.area{p},'pfcx'));
%         AllPeth = [AllPeth ; MatCorr(selected_neurons,:)];
    
end


%% zscore
Zpeth = zscore(AllPeth,[],2);

%ordered by amplitude response
[mean_after] = mean(Zpeth(:,100:130),2);
[~,id2] = sort(mean_after);
Ord_peth = Zpeth(id2,:);

%ordered by time response
[~,idmax] = max(Zpeth,[],2);
[~,id2] = sort(idmax);
Ord_peth = Zpeth(id2,:);

y_mua = mean(Ord_peth,1);


%% plot

%ordered
figure, hold on
subplot(4,1,1), hold on
plot(-500:5:500, y_mua),
xlim([-500 500]), ylim([-0.5 0.6]),
line([0 0], get(gca,'ylim'), 'linewidth',2),

subplot(4,1,2:4), hold on
imagesc(-500:5:500, 1:size(Ord_peth,1), Ord_peth);
xlim([-500 500]), ylim([1 size(Ord_peth,1)])
line([0 0], get(gca,'ylim'), 'linewidth',2),
caxis([-3.3 9.4]),
title('Neurons on ripples / no down before & after (all records)')





