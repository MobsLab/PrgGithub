% TestTimingTone
% 30.01.2017 KJ
%
% for each night, look at the timing of tones and if it is coherent with
% ohter data
%
% see
%   TestTimingTone2 TestTimingToneLFP TestTimingToneLFP2



Dir1=PathForExperimentsDeltaWavesTone('RdmTone');
Dir2=PathForExperimentsDeltaWavesTone('DeltaToneAll');
Dir = MergePathForExperiment(Dir1,Dir2);


% Dir1 = PathForExperimentsDeltaKJHD('RdmTone');
% Dir2 =PathForExperimentsDeltaKJHD('DeltaToneAll');
% Dir = MergePathForExperiment(Dir1,Dir2);

for p=1:length(Dir.path)
    if strcmpi(Dir.manipe{p},'RdmTone')
        Dir.condition{p} = 'RdmTone';
    elseif strcmpi(Dir.manipe{p},'DeltaToneAll')
        Dir.condition{p} = ['Tone ' num2str(Dir.delay{p}*1000) 'ms'];
    end
end

%params
binsize = 100; %10ms
nbins = 200;


for p=1:length(Dir.path)
    try
        disp(' ')
        disp('****************************************************************')
        eval(['cd(Dir.path{',num2str(p),'}'')'])
        disp(pwd)
        clearvars -except Dir p binsize nbins
        

        %Delta waves
        try
            load DeltaPFCx DeltaOffline
        catch
            load newDeltaPFCx DeltaEpoch
            DeltaOffline =  DeltaEpoch; 
            clear DeltaEpoch
        end
        tdeltas = (Start(DeltaOffline)+End(DeltaOffline))/2;

        %Tones/Shams
        load('DeltaSleepEvent.mat', 'TONEtime1')
        delay = Dir.delay{p}*1E4; %in 1E-4s
        tEvents = ts(TONEtime1 + delay);
        nb_events = length(tEvents);
        
        %delta
        Cc_delta = CrossCorr(tEvents, ts(tdeltas), binsize, nbins);
        x_delta = Range(Cc_delta);
        y_delta = Data(Cc_delta);
        
        %maximum
        y = y_delta;
        y(x_delta<0)=0;
        [~,idx] = max(y);
        x_max_pos = x_delta(idx);
        
        y = y_delta;
        y(x_delta>0)=0;
        [~,idx] = max(y);
        x_max_neg = x_delta(idx);
        
        
        %% PLOT AND SAVE FIG
        figure, hold on
        plot(x_delta/10,y_delta,'k'), hold on
        line([0 0],get(gca,'YLim')), hold on
        line([x_max_pos/10 x_max_pos/10],get(gca,'YLim'),'linestyle','--'), hold on
        line([x_max_neg/10 x_max_neg/10],get(gca,'YLim'),'linestyle','--'), hold on
        set(gca, 'XTick',sort([-1000:200:1000 x_max_neg/10 x_max_pos/10]));
        
        % save fig
        title(['CorrelogramToneDelta ' Dir.name{p}  ' - ' Dir.condition{p} ' - ' Dir.date{p}]);
        %name_fig
        filename_fig = ['CorrelogramToneDelta_' Dir.name{p}  '_' Dir.date{p}];
        filename_png = [filename_fig  '.png'];
        %save figure
        cd([FolderFigureDelta 'IDfigures/CorrelogramToneDelta/'])
        saveas(gcf,filename_png,'png')
        close
        
        
        
    catch
        disp('error for this record')
    end
end











