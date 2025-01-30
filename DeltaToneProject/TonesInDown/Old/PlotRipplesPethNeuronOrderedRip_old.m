%%PlotRipplesPethNeuronOrderedRip
% 13.09.2018 KJ
%
%
%
% see
%   GenerateTonePethNeuron PlotTonePethNeuron GenerateRipplesPethNeuron
%


clear

Dir = PathForExperimentsSleepRipplesSpikes('all');
% Dir = PathForExperimentsSleepRipplesSpikes('tone');
Dir = CheckPathForExperiment_KJ(Dir);

AllPethRip = [];
AllPethCorrected = [];

%get data for each record
for p=1:length(Dir.path)

    eval(['cd(Dir.path{',num2str(p),'}'')'])
%     disp(' ')
%     disp('****************************************************************')
%     disp(pwd)
    
    clearvars -except Dir p AllPethRip AllPethCorrected
    
    %ripples correlogram    
    load('RipplesPeth.mat', 'MatCorr', 't_corr')
    AllPethRip = [AllPethRip ; MatCorr];
    
    %tones correlogram  
    load('RipplesCorrectedPeth.mat', 'MatCorr', 't_corr')
    AllPethCorrected = [AllPethCorrected ; MatCorr];
    
end


%% zscore
ZpethRip = zscore(AllPethRip,[],2);
ZpethCorrected = zscore(AllPethCorrected,[],2);

%order corrected
[~,idmax] = max(ZpethCorrected,[],2);
[~,idcorr] = sort(idmax);
%order ripples
[~,idmax] = max(ZpethRip,[],2);
[~,idrip] = sort(idmax);


%order rip-rip
Zpeth.rip.rip = ZpethRip(idrip,:);
y_mua.rip.rip = mean(Zpeth.rip.rip,1);
%order rip-corrected
Zpeth.rip.corr = ZpethRip(idcorr,:);
y_mua.rip.corr = mean(Zpeth.rip.corr,1);
%order corrected-corrected
Zpeth.corr.corr = ZpethCorrected(idcorr,:);
y_mua.corr.corr = mean(Zpeth.corr.corr,1);
%order corrected-rip
Zpeth.corr.rip = ZpethCorrected(idrip,:);
y_mua.corr.rip = mean(Zpeth.corr.rip,1);


%to plot
Opeth{1} = Zpeth.rip.rip;   y_peth{1} = y_mua.rip.rip; titlefig{1} = 'All ripples';
Opeth{2} = Zpeth.corr.rip;  y_peth{2} = y_mua.corr.rip; titlefig{2} = 'All ripples with no down before - neurons ordered as in left';
Opeth{3} = Zpeth.rip.corr;  y_peth{3} = y_mua.rip.corr; titlefig{3} = 'All ripples - neurons ordered as in right';
Opeth{4} = Zpeth.corr.corr; y_peth{4} = y_mua.corr.corr; titlefig{4} = 'All ripples with no down before';


%% plot

gap = [0.1 0.06];

%ordered
figure, hold on
for i=1:4
    subtightplot(2,2,i,gap), hold on
    
    imagesc(-500:5:500, 1:size(Opeth{i},1), Opeth{i});
    line([0 0], get(gca,'ylim'), 'linewidth',2),
    caxis([-2 6]),
    
    yyaxis right
    if i==1 || i==4
        hold on, plot(-500:5:500, y_peth{i}, '-k', 'linewidth', 2);
        set(gca,'YLim', [-0.5 1]);
    end
    
    yyaxis left
    set(gca,'YLim', [0 size(Opeth{i},1)], 'XLim',[-500 500]);
    xlabel('time relative to ripples (ms)'), ylabel('#neurons'),
    
    title(titlefig{i});

end



