%%PlotTonePethNeuronOrderedRipples
% 13.09.2018 KJ
%
%
%
% see
%   GenerateTonePethNeuron PlotTonePethNeuron GenerateRipplesPethNeuron
%


clear

Dir1=PathForExperimentsDeltaSleepSpikes('RdmTone');
% Dir2=PathForExperimentsDeltaSleepSpikes('DeltaT0');
% Dir = MergePathForExperiment(Dir1,Dir2);
Dir = CheckPathForExperiment_KJ(Dir1);

AllPethRip = [];
AllPethTone = [];

%get data for each record
for p=1:length(Dir.path)

    eval(['cd(Dir.path{',num2str(p),'}'')'])
%     disp(' ')
%     disp('****************************************************************')
%     disp(pwd)
    
    clearvars -except Dir p AllPethRip AllPethTone
    
    %ripples correlogram    
    load('RipplesPeth.mat', 'MatCorr', 't_corr')
    AllPethRip = [AllPethRip ; MatCorr];
    
    %tones correlogram  
    load('TonePeth.mat','MatCorr')
    AllPethTone = [AllPethTone ; MatCorr];
    
end


%% zscore
ZpethRip = zscore(AllPethRip,[],2);
ZpethTone = zscore(AllPethTone,[],2);

%ordered by time response
[~,idmax] = max(ZpethRip,[],2);
[~,id2] = sort(idmax);
Ord_pethTone = ZpethTone(id2,:);

y_mua = mean(Ord_pethTone,1);

%% plot

%ordered
figure, hold on
subplot(4,1,1), hold on
plot(-500:5:500, y_mua),
xlim([-500 500]), ylim([-1.1 1.1])
line([0 0], get(gca,'ylim'), 'linewidth',2),

subplot(4,1,2:4), hold on
imagesc(-500:5:500, 1:size(Ord_pethTone,1), Ord_pethTone);
xlim([-500 500]), ylim([1 size(Ord_pethTone,1)])
line([0 0], get(gca,'ylim'), 'linewidth',2),
caxis([-3.3 9.4]),
title('Neurons on tones - ordered by delay of response on ripples')





