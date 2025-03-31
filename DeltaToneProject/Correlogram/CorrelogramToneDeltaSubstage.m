% CorrelogramToneDeltaSubstage
% 27.11.2016 KJ
%
% compute correlograms, for the different substage
% 
% 
%   see CorrelogramToneDeltaSubstagePlot
%


%% Dir
Dir = PathForExperimentsDeltaWavesTone('all');
%Dir = PathForExperimentsDeltaKJHD('all');
Dir_long = PathForExperimentsDeltaLongSleep('all');

Dir = IntersectPathForExperiment(Dir,Dir_long);
clearvars -except Dir

%condition 
Dir.condition=Dir.manipe;
for p=1:length(Dir.path)
    if strcmpi(Dir.manipe{p},'DeltaToneAll')
        Dir.condition{p} = ['Tone ' num2str(Dir.delay{p}*1000) 'ms'];
    end
end

%params
binsize = 100; %10ms
nbins = 100;

animals = unique(Dir.name); %Mice
conditions = unique(Dir.condition); %Conditions

%loop
for cond = 1:length(conditions)
    for m=1:length(animals)
        y_delta=[]; 
        nb_total_events_delta=0;

        for p=1:length(Dir.path)
            if strcmpi(Dir.name{p},animals{m}) && strcmpi(Dir.condition{p},conditions{cond})
                disp(' ')
                disp('****************************************************************')
                eval(['cd(Dir.path{',num2str(p),'}'')'])
                disp(pwd)

                %% load
                %Substages and stages
                clear op NamesOp Dpfc Epoch noise
                load NREMepochsML.mat op NamesOp Dpfc Epoch noise
                disp('Loading epochs from NREMepochsML.m')
                [Substages,NamesSubstages]=DefineSubStages(op,noise);
                
                %Delta waves
                try
                    load DeltaPFCx DeltaOffline
                catch
                    load newDeltaPFCx DeltaEpoch
                    DeltaOffline =  DeltaEpoch; 
                    clear DeltaEpoch
                end
                tdeltas = (Start(DeltaOffline)+End(DeltaOffline))/2;
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
                tdowns = (Start(Down)+End(Down))/2;

                %Tones/Shams
                try
                    load('DeltaSleepEvent.mat', 'TONEtime1')
                    delay = Dir.delay{p}*1E4; %in 1E-4s
                    tEvents = ts(TONEtime1 + delay);
                    with_tone=1;
                catch
                    load('ShamSleepEvent.mat', 'SHAMtime')
                    delay = 1000;
                    tEvents = ts(Range(SHAMtime) + delay);
                    with_tone=0;
                end
                nb_events = length(tEvents);

                %% Correlograms
                
                %delta
                Cc_delta = CrossCorr(tEvents, ts(tdeltas), binsize, nbins);
                x_delta = Range(Cc_delta);
                if isempty(y_delta)
                    y_delta = nb_events * Data(Cc_delta);
                    nb_total_events_delta = nb_events;
                else
                    y_delta = y_delta + nb_events * Data(Cc_delta);
                    nb_total_events_delta = nb_total_events_delta + nb_events;
                end
                %down
                Cc_down = CrossCorr(tEvents, ts(tdowns), binsize, nbins);
                x_down = Range(Cc_down);
                if isempty(y_down)
                    y_down = nb_events * Data(Cc_down);
                    nb_total_events_down = nb_events;
                else
                    y_down = y_down + nb_events * Data(Cc_down);
                    nb_total_events_down = nb_total_events_down + nb_events;
                end

            end
        end

        mouseCrossCor.deltas.x{m, cond} = x_delta;
        mouseCrossCor.deltas.y{m, cond} = y_delta / nb_total_events_delta;
        mouseCrossCor.downs.x{m, cond} = x_down;
        mouseCrossCor.downs.y{m, cond} = y_down / nb_total_events_down;
    end
end


%saving data
cd([FolderProjetDelta 'Data/']) 
save CorrelogramToneDeltaSubstage.mat mouseCrossCor conditions animals


  