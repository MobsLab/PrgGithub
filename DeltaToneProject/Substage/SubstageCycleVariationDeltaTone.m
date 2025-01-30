% SubstageCycleVariationDeltaTone
% 29.11.2016 KJ
%
% analyse the intervals between identical substages
% - Inter Substages Intervals (epoch, start, center, end)
% - Correlogram (start, center, end)
%
%   see 
%


Dir1 = PathForExperimentsDeltaWavesTone('Basal');
for p=1:length(Dir1.path)
    Dir1.delay{p}=0;
end
Dir2=PathForExperimentsDeltaWavesTone('RdmTone');
Dir3=PathForExperimentsDeltaWavesTone('DeltaToneAll');
Dir = MergePathForExperiment(Dir2,Dir3);
Dir = MergePathForExperiment(Dir1,Dir);

% Dir1 = PathForExperimentsDeltaKJHD('Basal');
% for p=1:length(Dir1.path)
%     Dir1.delay{p}=0;
% end
% Dir2 = PathForExperimentsDeltaKJHD('RdmTone');
% Dir3 =PathForExperimentsDeltaKJHD('DeltaToneAll');
% Dir = MergePathForExperiment(Dir2,Dir3);
% Dir = MergePathForExperiment(Dir1,Dir);

%% params
binsize = 20E4;
nbins = 100;
substages_ind = 1:5; %N1, N2, N3, REM, WAKE

animals = unique(Dir.name); %Mice
conditions = unique(Dir.manipe); %Mice

for cond = 1:length(conditions)
    disp('****************************************************************')
    disp(conditions{cond})
    
    for m=1:length(animals)
        disp(' ')
        disp('****************************************************************')
        disp(animals{m})

        for sub=substages_ind
            mouse.isi.epoch{m,cond,sub} = [];
            mouse.isi.start{m,cond,sub} = [];
            mouse.isi.end{m,cond,sub} = [];
            mouse.isi.center{m,cond,sub} = [];
            
            mouse.autoCorr.start{m,cond,sub} = zeros(nbins+1,1);
            mouse.autoCorr.end{m,cond,sub} = zeros(nbins+1,1);
            mouse.autoCorr.center{m,cond,sub} = zeros(nbins+1,1);
            mouse.autoCorr.nb_epoch{m,cond,sub} = 0;
        end

        a=0;
        for p=1:length(Dir.path)
            if strcmpi(Dir.name{p},animals{m}) && strcmpi(Dir.manipe{p},conditions{cond})
                a=a+1;
                disp(' ')
                disp('****************************************************************')
                eval(['cd(Dir.path{',num2str(p),'}'')'])
                disp(pwd)

                %Substages
                clear op NamesOp Dpfc Epoch noise
                load NREMepochsML.mat op NamesOp Dpfc Epoch noise
                disp('Loading epochs from NREMepochsML.m')
                [Substages,NamesSubstages]=DefineSubStages(op,noise);

                for sub=substages_ind                
                    start_intv = Start(Substages{sub});
                    end_intv = End(Substages{sub});
                    center_intv = (Start(Substages{sub}) + End(Substages{sub})) / 2;
                    nb_epoch = length(start_intv);

                    isi_epoch = (start_intv(2:end) - end_intv(1:end-1))/1E4;
                    isi_start = diff(start_intv)/1E4;
                    isi_end = diff(end_intv)/1E4;
                    isi_center = diff(center_intv)/1E4;

                    Cc_start = CrossCorr(ts(start_intv), ts(start_intv), binsize, nbins);
                    Cc_end = CrossCorr(ts(end_intv), ts(end_intv), binsize, nbins);
                    Cc_center = CrossCorr(ts(end_intv), ts(end_intv), binsize, nbins);

                    mouse.isi.epoch{m,cond,sub} = [mouse.isi.epoch{m,cond,sub};isi_epoch];
                    mouse.isi.start{m,cond,sub} = [mouse.isi.start{m,cond,sub};isi_start];
                    mouse.isi.end{m,cond,sub} = [mouse.isi.end{m,cond,sub};isi_end];
                    mouse.isi.center{m,cond,sub} = [mouse.isi.center{m,cond,sub};isi_center];

                    mouse.autoCorr.start{m,cond,sub} = mouse.autoCorr.start{m,cond,sub} + nb_epoch * Data(Cc_start);
                    mouse.autoCorr.end{m,cond,sub} = mouse.autoCorr.end{m,cond,sub} + nb_epoch * Data(Cc_end);
                    mouse.autoCorr.center{m,cond,sub} = mouse.autoCorr.center{m,cond,sub} + nb_epoch * Data(Cc_center);
                    mouse.autoCorr.nb_epoch{m,cond,sub} = mouse.autoCorr.nb_epoch{m,cond,sub} + nb_epoch;
                    mouse.autoCorr.x{m,cond,sub} = Range(Cc_start);

                end

            end
        end
        
        for sub=substages_ind 
            mouse.autoCorr.start{m,cond,sub} = mouse.autoCorr.start{m,cond,sub} / mouse.autoCorr.nb_epoch{m,cond,sub};
            mouse.autoCorr.end{m,cond,sub} = mouse.autoCorr.end{m,cond,sub} / mouse.autoCorr.nb_epoch{m,cond,sub};
            mouse.autoCorr.center{m,cond,sub} = mouse.autoCorr.center{m,cond,sub} / mouse.autoCorr.nb_epoch{m,cond,sub};

            center_autocorr = mouse.autoCorr.x{m,cond,sub}==0;
            mouse.autoCorr.start{m,cond,sub}(center_autocorr) = 0;
            mouse.autoCorr.end{m,cond,sub}(center_autocorr) = 0;
            mouse.autoCorr.center{m,cond,sub}(center_autocorr) = 0;
        end
    end
end



%% plot
smoothing = 0;
for sub=substages_ind
    figure, hold on
    for cond=1:length(conditions)
        %Start
        h(1+(cond-1)*3) = subplot(3,3,1+(cond-1)*3); hold on
        leg = cell(0);
        for m=1:length(animals)
            try
                plot(mouse.autoCorr.x{m,cond,sub}/1E4, Smooth(mouse.autoCorr.start{m,cond,sub},smoothing)), hold on
                leg{end+1} = animals{m}; 
            end
        end
        legend(leg)
        title(['Start of substage - ' conditions(cond)])
        line([0 0],get(gca,'YLim')), hold on
        
        %Center
        h(2+(cond-1)*3) = subplot(3,3,2+(cond-1)*3); hold on
        leg = cell(0);
        for m=1:length(animals)
            try
                plot(mouse.autoCorr.x{m,cond,sub}/1E4, Smooth(mouse.autoCorr.center{m,cond,sub},smoothing)), hold on
                leg{end+1} = animals{m}; 
            end
        end
        legend(leg)
        title(['Center of substage - ' conditions(cond)])
        line([0 0],get(gca,'YLim')), hold on
        
        %End
        h(3+(cond-1)*3) = subplot(3,3,3+(cond-1)*3); hold on
        leg = cell(0);
        for m=1:length(animals)
            try
                plot(mouse.autoCorr.x{m,cond,sub}/1E4, Smooth(mouse.autoCorr.end{m,cond,sub},smoothing)), hold on
                leg{end+1} = animals{m}; 
            end
        end
        legend(leg)
        title(['End of substage - ' conditions(cond)])
        line([0 0],get(gca,'YLim')), hold on
        
    end
    
    suplabel(NamesSubstages{sub},'t');
end







% 
% %% gather global autocorrelogram
% for cond = 1:length(conditions)
%     for m=1:length(animals)
%         
%         try
%             nb_night = length(mouse.crossCor.start(m,cond,1,:));
% 
%             for sub=substages_ind
%                 nb_epoch = 0;
%                 mouse.autoCorr.start{m,cond,sub} = [];
%                 mouse.autoCorr.end{m,cond,sub} = [];
%                 mouse.autoCorr.center{m,cond,sub} = [];
%                 for a=1:nb_night
%                     if ~isempty(mouse.crossCor.nb_epoch{m,cond,sub,a})
%                         nb_epoch = nb_epoch + mouse.crossCor.nb_epoch{m,cond,sub,a};
%                         if isempty(mouse.autoCorr.start{m,cond,sub})
%                             mouse.autoCorr.start{m,cond,sub} = Data(mouse.crossCor.start{m,cond,sub,a}) * mouse.crossCor.nb_epoch{m,cond,sub,a};
%                             mouse.autoCorr.end{m,cond,sub} = Data(mouse.crossCor.end{m,cond,sub,a}) * mouse.crossCor.nb_epoch{m,cond,sub,a};
%                             mouse.autoCorr.center{m,cond,sub} = Data(mouse.crossCor.center{m,cond,sub,a}) * mouse.crossCor.nb_epoch{m,cond,sub,a};
%                         else
%                             mouse.autoCorr.start{m,cond,sub} = mouse.autoCorr.start{m,cond,sub} + Data(mouse.crossCor.start{m,cond,sub,a}) * mouse.crossCor.nb_epoch{m,cond,sub,a};
%                             mouse.autoCorr.end{m,cond,sub} = mouse.autoCorr.end{m,cond,sub} + Data(mouse.crossCor.end{m,cond,sub,a}) * mouse.crossCor.nb_epoch{m,cond,sub,a};
%                             mouse.autoCorr.center{m,cond,sub} = mouse.autoCorr.center{m,cond,sub} + Data(mouse.crossCor.center{m,cond,sub,a}) * mouse.crossCor.nb_epoch{m,cond,sub,a};
%                         end
%                     end
%                 end
% 
%                 mouse.autoCorr.start{m,cond,sub} = mouse.autoCorr.start{m,cond,sub} / nb_epoch;
%                 mouse.autoCorr.end{m,cond,sub} = mouse.autoCorr.end{m,cond,sub} / nb_epoch;
%                 mouse.autoCorr.center{m,cond,sub} = mouse.autoCorr.center{m,cond,sub} / nb_epoch;
%                 
%                 mouse.autoCorr.x{m,cond,sub} = Range(mouse.crossCor.center{m,cond,sub,a});
%             end
%             
%         catch
%             mouse.autoCorr.start{m,cond,sub} = [];
%             mouse.autoCorr.end{m,cond,sub} = [];
%             mouse.autoCorr.center{m,cond,sub} = [];
%             mouse.autoCorr.x{m,cond,sub} = [];
%         end
%     end
% end
% 










