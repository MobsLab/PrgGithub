% StimImpactSlowWavesThresholdAnalysis2
% 01.04.2018 KJ
%
% Infos
%    
%
% SEE 
%    
%


clear
load(fullfile(FolderStimImpactData,'StimImpactSlowWavesThresholdAnalysis.mat'));

%params plot
ylabel_substage = {'N3','N2','N1','REM','WAKE'};
ytick_substage = [1 1.5 2 3 4]; %ordinate in graph
colori = {[0.5 0.3 1], [1 0.5 1], [0.8 0 0.7], [0.1 0.7 0], [0.5 0.2 0.1]}; %substage color

gap = [0.02 0.02];

for p=1:length(thres_res.filereference)
    
    figure, hold on
    for t=1:9%length(thD_list)
        
        
        %% NEW HYPNO
        StageEpochs = thres_res.newhypno{p}{t};
        
        N1=StageEpochs{1}; 
        N2=StageEpochs{2}; 
        N3=StageEpochs{3}; 
        REM=StageEpochs{4}; 
        WAKE=StageEpochs{5}; 

        %Sleep Stages
        Rec=or(or(or(N1,or(N2,N3)),REM),WAKE);
        Epochs={N1,N2,N3,REM,WAKE};
        num_substage=[2 1.5 1 3 4]; %ordinate in graph
        indtime=min(Start(Rec)):1E4:max(Stop(Rec));
        timeTsd=tsd(indtime,zeros(length(indtime),1));
        SleepStages=zeros(1,length(Range(timeTsd)))+4.5;
        rg=Range(timeTsd);
        sample_size = median(diff(rg))/10; %in ms

        time_stages = zeros(1,5);
        meanDuration_sleepstages = zeros(1,5);
        for ep=1:length(Epochs)
            idx=find(ismember(rg,Range(Restrict(timeTsd,Epochs{ep})))==1);
            SleepStages(idx)=num_substage(ep);
            time_stages(ep) = length(idx) * sample_size;
            meanDuration_sleepstages(ep) = mean(diff([0;find(diff(idx)~=1);length(idx)])) * sample_size;
        end

        SleepStages=tsd(rg,SleepStages');

        percentvalues_NREM = zeros(1,3);
        for ep=1:3
            percentvalues_NREM(ep) = time_stages(ep)/sum(time_stages(1:3));
        end
        percentvalues_NREM = round(percentvalues_NREM*100,2);


        
        %% PLOT
        subtightplot(9,4,(1:2)+4*(t-1), gap), hold on
        plot(Range(SleepStages,'s')/3600,Data(SleepStages),'k'), hold on,
        for ep=1:length(Epochs)
            plot(Range(Restrict(SleepStages,Epochs{ep}),'s')/3600 ,Data(Restrict(SleepStages,Epochs{ep})),'.','Color',colori{ep}), hold on,
        end
        xlim([0 max(Range(SleepStages,'s')/3600)]), ylim([0.5 5]), set(gca,'Ytick',ytick_substage,'YTickLabel',ylabel_substage), hold on,
        if t==1
            maintitle = [thres_res.subject{p} ' - ' num2str(thres_res.filereference{p}) ' (' thres_res.condition{p} ') - ' thres_res.date{p} ];
            title(maintitle);
        end
        if t==8
            xlabel('Time (h)')
        else
            set(gca, 'XTickLabel', {}, 'XTick',[]), hold on
        end
        

        subtightplot(9,4,3+4*(t-1), gap), hold on
        for ep=1:length(time_stages)
            h = bar(ep, time_stages(ep)/3600E3); hold on
            set(h,'FaceColor', colori{ep}), hold on
            if any(1:3==ep)
                text(ep - 0.3, (time_stages(ep)/1000 + 1000)/3600, [num2str(percentvalues_NREM(ep)) '%'], 'VerticalAlignment', 'top', 'FontSize', 8)
            end
        end
        ylim([0, max(time_stages/3600E3) * 1.2]);
        if t==1
            title('Total duration'); ylabel('duration (h)')
        end
        if t==8
            set(gca, 'XTickLabel', {'N1','N2','N3','REM','WAKE'}, 'XTick',1:5), hold on
        else
            set(gca, 'XTickLabel', {}, 'XTick',[]), hold on
        end
        

        subtightplot(9,4,4+4*(t-1), gap), hold on
        for ep=1:length(meanDuration_sleepstages)
            h = bar(ep, meanDuration_sleepstages(ep)/60E3); hold on
            set(h,'FaceColor', colori{ep}), hold on
        end
        if t==1
            title('Episode mean duration'); ylabel('duration (min)')
        end
        if t==8
            set(gca, 'XTickLabel',{'N1','N2','N3','REM','WAKE'}, 'XTick',1:5), hold on
        else
            set(gca, 'XTickLabel', {}, 'XTick',[]), hold on
        end


    end


end


