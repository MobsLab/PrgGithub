% ParcoursGenerateIDClinicalHypnogramVC
% 14.07.2017 KJ
%
% Infos
%   Loop over all record: generate and save data, plot and save figures
%   ONLY REGENERATE HYPNOGRAM
%
% SEE 
%   PlotIDClinicalRecordVC GenerateIDClinicalRecordVC
%

Dir = ListOfClinicalTrialDreemAnalyse('all');

for p=1:length(Dir.filename)
    try
        clearvars -except Dir p

        disp(' ')
        disp('****************************************************************')
        disp(Dir.filename{p})

        %% Hypnogram
        [Hypnograms, ~, ~] = GetHypnogramClinic(Dir.filereference{p});
        nb_hypnogram = length(Hypnograms);
        if ~isempty(Hypnograms)
            StageEpochs = Hypnograms{4};
            infos.hypno_pascal=1;
        else
            [~, ~, StageEpochs, ~, ~, ~] = GetRecordClinic(Dir.filename{p});
            infos.hypno_pascal=0;
        end
        
        N1=StageEpochs{1}; N2=StageEpochs{2}; N3=StageEpochs{3}; REM=StageEpochs{4}; WAKE=StageEpochs{5};
        
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
        
        %%save
        cd(FolderProcessDreem)
        savefile = ['IDfigures_' num2str(Dir.filereference{p})];
        save(savefile,'-append','SleepStages','Epochs','time_stages','percentvalues_NREM','meanDuration_sleepstages','nb_hypnogram')
        
        
        %% Plot
        PlotIDClinicalRecordVC(Dir.filereference{p});

        cd([FolderClinicFigures '/IDfigures/ID_VC'])

        %title
        filename_png = ['IDfigures_' num2str(Dir.filereference{p})  '.png'];
        %save figure
        set(gcf,'units','normalized','outerposition',[0 0 1 1])
        saveas(gcf,filename_png,'png')
        close all
    catch
        disp('error for this record');
    end

end


