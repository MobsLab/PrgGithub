% SolistChoristAnalysis1
% 05.05.2017 KJ
%
% Correlogram between soloist and chorist, before and after down states
% 
%   see SolistChoristDetection
%


%% Dir

%Dir = PathForExperimentsDeltaKJHD('all');
Dir = PathForExperimentsDeltaSleepSpikes('all');

clearvars -except Dir

%condition 
Dir.condition=Dir.manipe;
for p=1:length(Dir.path)
    if strcmpi(Dir.manipe{p},'DeltaToneAll')
        Dir.condition{p} = ['Tone ' num2str(Dir.delay{p}*1000) 'ms'];
    end
end


%% loop over records
for p=1:length(Dir.path)
    try
        disp(' ')
        disp('****************************************************************')
        eval(['cd(Dir.path{',num2str(p),'}'')'])
        disp(pwd)

        clearvars -except Dir p
        binsize_cc = 5;
        nbins_cc = 500;

        tbefore = 1E3; 
        tafter = 1E3;

        %% Load
        %Epoch and Spikes
        load StateEpochSB SWSEpoch Wake REMEpoch

        %MUA
        load SpikeData
        eval('load SpikesToAnalyse/PFCx_Neurons')
        NumNeurons=number;
        clear number

        %Down states
        try
            load newDownState Down
        catch
            try
                load DownSpk Down
            catch
                Down = intervalSet([],[]);
            end
        end
        start_down = Start(Down);
        end_down = End(Down);
        tdowns = (Start(Down)+End(Down)/2);


        %% Soloist vs Chorist

        Ssws=Restrict(S,SWSEpoch);
        nb_neuron = length(NumNeurons);

        for i=1:length(NumNeurons)
            num=1:length(NumNeurons);
            num(i)=[];
            [Cc(i,:), Bc] = CrossCorr(Range(Ssws{NumNeurons(i)}),Range(PoolNeurons(Ssws,NumNeurons(num))), binsize_cc, nbins_cc);
        end

        Cc_norm = Cc;
        Cc_norm(isnan(Cc_norm))=0;
        Cc_norm=zscore(Cc_norm')';
        Cc_norm=SmoothDec(Cc_norm,[0.001 3]);

        Chorist_idx = [];
        Soloist_idx = [];
        for i=1:length(NumNeurons)
            if mean(Cc_norm(i,240:260)) > mean(Cc_norm(i,1:200))
                Chorist_idx = [Chorist_idx i];
            else
                Soloist_idx = [Soloist_idx i];
            end
        end

        %MUA
        Qchor = Ssws{Chorist_idx};
        Qsol = Ssws{Soloist_idx};


        %% Restrict MUA to periods around down states
        BeforeDown = intervalSet(Start(Down)-tbefore, Start(Down));
        AfterDown = intervalSet(End(Down), End(Down)+tafter);

        %before
        Qchor_bef = Restrict(Qchor,BeforeDown);
        Qsol_bef = Restrict(Qsol,BeforeDown);
        [CcBefore, Bc1] = CrossCorr(Range(Qsol_bef), Range(Qchor_bef), binsize_cc, 100);
        [Cc_chor_Before, Bc3] = CrossCorr(Range(Qchor_bef), Range(Qchor_bef), binsize_cc, 100);

        %after
        Qchor_after = Restrict(Qchor,AfterDown);
        Qsol_after = Restrict(Qsol,AfterDown);
        [CcAfter, Bc2] = CrossCorr(Range(Qsol_after), Range(Qchor_after), binsize_cc, 100);
        [Cc_chor_After, Bc4] = CrossCorr(Range(Qchor_after), Range(Qchor_after), binsize_cc, 100);


        %nil on center
        % CcBefore(ceil(length(CcBefore)/2))=0;
        % Cc_chor_Before(ceil(length(Cc_chor_Before)/2))=0;
        % CcAfter(ceil(length(CcAfter)/2))=0;
        % Cc_chor_After(ceil(length(CcBefore)/2))=0;


        %% plot
        figure, hold on

        %soloist on chorist - BEFORE
        subplot(2,2,1),hold on
        y1 = zscore(CcBefore')';
        plot(Bc1, y1);
        line([0 0], get(gca,'ylim'));
        title('Before Down States - Soloist on Chorist')

        %soloist on chorist - AFTER
        subplot(2,2,2),hold on
        y2 = zscore(CcAfter')';
        plot(Bc2, y2);
        line([0 0], get(gca,'ylim'));
        title('After Down States - Soloist on Chorist')

        %chorist - BEFORE
        subplot(2,2,3),hold on
        y3 = zscore(Cc_chor_Before')';
        plot(Bc3, y3);
        line([0 0], get(gca,'ylim'));
        title('Before Down States - Chorist')

        %chorist - AFTER
        subplot(2,2,4),hold on
        y4 = zscore(Cc_chor_After')';
        plot(Bc3, y4);
        line([0 0], get(gca,'ylim'));
        title('After Down States - Chorist')
        
        
        %% save fig
        %title
        filename_fig = ['SolistChoristAnalysis1_' Dir.name{p}  '_' Dir.date{p}];
        filename_png = [filename_fig  '.png'];
        %save figure
        cd([FolderFigureDelta 'IDfigures/Soloist/'])
        saveas(gcf,filename_png,'png')
        close all
        
    catch
        disp('error for this record')
    end
end


