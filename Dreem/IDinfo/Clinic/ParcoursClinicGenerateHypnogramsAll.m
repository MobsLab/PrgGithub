% ParcoursClinicGenerateHypnogramsAll
% 18.07.2017 KJ
%
% Infos
%   Loop over all record: generate and plot hypnograms
%
% SEE 
%   PlotIDClinicalRecord GenerateIDClinicalRecordVC
%


Dir = ListOfClinicalTrialDreemAnalyse('all');

for p=1:length(Dir.filename)
    try
        clearvars -except Dir p

        disp(' ')
        disp('****************************************************************')
        disp(Dir.filename{p})
        
        %% load
        [Hypnograms, scorer, ref_score] = GetHypnogramClinic(Dir.filereference{p});
        [~, ~, StageEpochs, ~, ~, ~] = GetRecordClinic(Dir.filename{p});

        Hypnograms{end+1} = StageEpochs;
        scorer{end+1} = 'dreem';
        ref_score{end+1} = 'dreem';
        
        
        %% get data and plot
        figure, hold on
        for i=1:length(Hypnograms)
            StageEpochs = Hypnograms{i};
            N1=StageEpochs{1}; N2=StageEpochs{2}; N3=StageEpochs{3}; REM=StageEpochs{4}; WAKE=StageEpochs{5};

            %% Sleep Stages
            Rec=or(or(or(N1,or(N2,N3)),REM),WAKE);
            Epochs={N1,N2,N3,REM,WAKE};
            num_substage=[2 1.5 1 3 4]; %ordinate in graph
            indtime=min(Start(Rec)):1E4:max(Stop(Rec));
            timeTsd=tsd(indtime,zeros(length(indtime),1));
            SleepStages=zeros(1,length(Range(timeTsd)))+4.5;
            rg=Range(timeTsd);
            sample_size = median(diff(rg))/10; %in ms
            for ep=1:length(Epochs)
                idx=find(ismember(rg,Range(Restrict(timeTsd,Epochs{ep})))==1);
                SleepStages(idx)=num_substage(ep);
            end
            SleepStages=tsd(rg,SleepStages');

            %% Plot
            subplot(2,3,i), hold on
            ylabel_substage = {'N3','N2','N1','REM','WAKE'};
            ytick_substage = [1 1.5 2 3 4]; %ordinate in graph
            colori = {[0.5 0.3 1], [1 0.5 1], [0.8 0 0.7], [0.1 0.7 0], [0.5 0.2 0.1]}; %substage color
            plot(Range(SleepStages,'s')/3600,Data(SleepStages),'k'), hold on,
            for ep=1:length(Epochs)
                plot(Range(Restrict(SleepStages,Epochs{ep}),'s')/3600 ,Data(Restrict(SleepStages,Epochs{ep})),'.','Color',colori{ep}), hold on,
            end
            xlim([0 max(Range(SleepStages,'s')/3600)]), ylim([0.5 5]), set(gca,'Ytick',ytick_substage,'YTickLabel',ylabel_substage), hold on,
            xlabel('Time (h)');

            title(['Scored by ' scorer{i} ' (ref: ' ref_score{i} ')']); 

        end
        suplabel(['Sujet ' num2str(Dir.subject{p}) ' - night ' num2str(Dir.night{p}) ' - ' Dir.condition{p} ' - ' Dir.date{p}],'t');
        
        
        
        %% save figure
        cd([FolderClinicFigures '/IDfigures/Hypnograms'])

        %title
        filename_png = ['Hypnograms_' num2str(Dir.filereference{p})  '.png'];
        %save figure
        set(gcf,'units','normalized','outerposition',[0 0 1 1])
        saveas(gcf,filename_png,'png')
        close all
        
    catch
        disp('error for this record')
    end
    
end







