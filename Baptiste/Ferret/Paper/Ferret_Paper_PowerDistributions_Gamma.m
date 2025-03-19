
%% beautiful example
figure
D = log10(Data(Smooth_Gamma{3}{5}));
h=histogram(D,'BinLimits',[1.9 2.9],'NumBins',200); hold on
h.FaceColor=[.3 .3 .3];
xlabel('OB gamma power (log)'), ylabel('PDF'), xlim([1.9 2.9]), ylim([0 1e6])
yticks([0:3e5:9e5]), yticklabels({'0','.02','.04','.06'})
v=vline(gamma_thresh{3}(5),'-r'); v.LineWidth=5;
text(2,9e5,'Sleep','FontSize',15), text(2.7,9e5,'Wake','FontSize',15)
makepretty


%% intra-variability
clear all
Dir{1} = PathForExperimentsOB({'Shropshire'}, 'freely-moving', 'none');
drug=1;

n=1;
while n<11
    for sess=1:20
        clear SmoothGamma
        load([Dir{drug}.path{sess} filesep 'SleepScoring_OBGamma.mat'], 'Epoch','TotalNoiseEpoch')
        tot_dur = sum(DurationEpoch(or(Epoch , TotalNoiseEpoch)))./3600e4;
        if tot_dur>4
            load([Dir{drug}.path{sess} filesep 'SleepScoring_OBGamma.mat'], 'SmoothGamma', 'Info')
            Smooth_Gamma{n} = SmoothGamma;
%             Gamma_Tresh(n) = Info.gamma_thresh;
            n=n+1;
            disp(n)
        end
    end
end

figure
for i=1:10
    D = log10(Data(Smooth_Gamma{i}));
    h=histogram(D,'BinLimits',[1.8 3.1],'NumBins',200); hold on
    HistData(i,:) = h.Values./sum(h.Values);
end
close

figure
for i=1:10
    clf
    D = log10(Data(Smooth_Gamma{i}));
    gamma_thresh(i) = GetGaussianThresh_BM(D, 0, 1);
end


figure
plot(linspace(1.8,3.1,200) , HistData' , 'k')
xlabel('OB gamma power (log)'), ylabel('PDF'), xlim([1.8 3.1])
hold on
plot(gamma_thresh(1:10),linspace(.01,.05,10), '*r')
makepretty


%% inter-variability
clear all

% sessions
Dir1 = PathForExperimentsOB({'Labneh'}, 'freely-moving','saline');
Dir2 = PathForExperimentsOB({'Labneh'}, 'freely-moving','none');
Dir{1} = MergePathForExperiment(Dir1,Dir2);

Dir1 = PathForExperimentsOB({'Brynza'}, 'freely-moving','saline');
Dir2 = PathForExperimentsOB({'Brynza'}, 'freely-moving','none');
Dir{2} = MergePathForExperiment(Dir1,Dir2);

Dir1 = PathForExperimentsOB({'Shropshire'}, 'freely-moving','saline');
Dir2 = PathForExperimentsOB({'Shropshire'}, 'freely-moving','none');
Dir{3} = MergePathForExperiment(Dir1,Dir2);

% data
for ferret=1:3
    n=1;
    while n<11
        for sess=1:length(Dir{ferret}.path)
            clear SmoothGamma
            load([Dir{ferret}.path{sess} filesep 'SleepScoring_OBGamma.mat'], 'Epoch','TotalNoiseEpoch')
            tot_dur = sum(DurationEpoch(or(Epoch , TotalNoiseEpoch)))./3600e4;
            if tot_dur>2
                load([Dir{ferret}.path{sess} filesep 'SleepScoring_OBGamma.mat'], 'SmoothGamma', 'Info')
                Smooth_Gamma{ferret}{n} = SmoothGamma;
                n=n+1;
                disp(n)
            end
        end
    end
end


figure
for ferret=1:3
    for i=1:length(Smooth_Gamma{ferret})
        clf
        D = log10(Data(Smooth_Gamma{ferret}{i}));
        [gamma_thresh{ferret}(i),~,~,~,~,AshD{ferret}(i)] = GetGaussianThresh_BM(D, 0, 1);
    end
end
AshD{2}([1 2 5 6]) = NaN;
    
% figures
Cols = {[.2 .5 .8],[.8 .5 .2],[.5 .2 .8]};
X = 1:3;
Legends = {'F1','F2','F3'};


PlotErrorBarN_KJ(AshD,...
    'barcolors',Cols,'x_data',X,'showPoints',0,'newfig',1);
ylabel('Ash D')
set(gca,'XTick',X,'XtickLabel',Legends)
makepretty












