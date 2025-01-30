%%PlotDeltaTonePethNeuron
% 13.09.2018 KJ
%
%
%
% see
%   GenerateTonePethNeuron PlotTonePethNeuron GenerateRipplesPethNeuron
%


clear

Dir = PathForExperimentsDeltaSleepSpikes('DeltaTone');
Dir = CheckPathForExperiment_KJ(Dir);

%list_delays
list_delays = unique(cell2mat(Dir.delay));



%get data for each record
for d=1:length(list_delays)
    AllPethRip{d}  = [];
    AllPethTone{d} = [];

    for p=1:length(Dir.path)
        
        if Dir.delay{p}==list_delays(d)
            eval(['cd(Dir.path{',num2str(p),'}'')'])
%             disp(' ')
%             disp('****************************************************************')
%             disp(pwd)
% 
%             %ripples correlogram    
%             load('RipplesPeth.mat', 'MatCorr', 't_corr')
%             AllPethRip{d} = [AllPethRip{d} ; MatCorr];

            %tones correlogram  
            load('TonePeth.mat','MatCorr')
            AllPethTone{d} = [AllPethTone{d} ; MatCorr];
        end
    end
end

%% zscore
for d=1:length(list_delays)
%     ZpethRip{d} = zscore(AllPethRip{d},[],2);
    ZpethTone{d} = zscore(AllPethTone{d},[],2);

    %ordered by time response
    [~,idmax] = max(ZpethTone{d},[],2);
    [~,id2] = sort(idmax);
    Ord_pethTone{d} = ZpethTone{d}(id2,:);
    
    y_mua{d} = mean(Ord_pethTone{d},1);

end


%% plot

for d=1:length(list_delays)

    %ordered
    figure, hold on
    subplot(4,1,1), hold on
    plot(-500:5:500, y_mua{d}),
    line([0 0], get(gca,'ylim'), 'linewidth',2),
    
    subplot(4,1,2:4), hold on
    imagesc(-500:5:500, 1:size(Ord_pethTone{d},1), Ord_pethTone{d});
    xlim([-500 500]), ylim([1 size(Ord_pethTone{d},1)])
    line([0 0], get(gca,'ylim'), 'linewidth',2),
    caxis([-3.3 9.4]),
    title(['Neurons on tones - delay ' num2str(list_delays(d)*1000) 'ms'])

end



