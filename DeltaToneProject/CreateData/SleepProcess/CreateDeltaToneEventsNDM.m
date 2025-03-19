% CreateDeltaToneEventsNDM
% 13.02.2017 KJ
%
% Convert events in .evt file, to be used with neuroscope:
%   - Delta waves
%   - Down states
%   - Tones
%   - Ripples
%   - Spindles
%   


Dir=PathForExperimentsDeltaWavesTone('all');

for p=1
    try
        disp(' ')
        disp('****************************************************************')
        eval(['cd(Dir.path{',num2str(p),'}'')'])
        disp(pwd)
        
        clearvars -except Dir p
        
        %% basename
        event_files = dir('*.evt.do');
        if length(event_files)==1
            basename = event_files(1).name;
            basename = basename(1:end-8);
            disp(basename);
        else
            basename=input('give basename for evt. saving (i.e. xml name)     ');
        end
        
        %% remove existing evt
        files_to_remove=dir([basename '.evt.*']);
        for i=1:length(files_to_remove)
            delete(files_to_remove(i).name);
        end
          
        %% data
        
        %SWS
        load StateEpochSB SWSEpoch
        
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
        start_down = Range(Restrict(ts(start_down),SWSEpoch));
        
        %evt
        evt.time=start_down/1E4;
        for i=1:length(evt.time)
            evt.description{i}='down_states';
        end
        CreateEvent(evt,basename,'dow')
        
        
        %% Delta
        try
            load DeltaPFCx DeltaOffline
            center_deltas = (Start(DeltaOffline)+End(DeltaOffline))/2; 
        catch
            try
                load newDeltaPFCx DeltaEpoch
            catch
                load AllDeltaPFCx DeltaEpoch
            end
            center_deltas = (Start(DeltaEpoch)+End(DeltaEpoch))/2; 
        end
        center_deltas = Range(Restrict(ts(center_deltas),SWSEpoch));
        
        %evt
        evt.time=center_deltas/1E4;
        for i=1:length(evt.time)
            evt.description{i}='delta_waves';
        end
        CreateEvent(evt,basename,'dPF')
        
        %% Tones
        if ~strcmpi(Dir.manipe{p},'basal')
            load('DeltaSleepEvent.mat', 'TONEtime1')
            load('DeltaSleepEvent.mat', 'TONEtime2')
            
            %evt
            evt.time=TONEtime1_SWS/1E4;
            for i=1:length(evt.time)
                evt.description{i}='detection';
            end
            CreateEvent(evt,basename,'det')
            
            evt.time=TONEtime1_SWS/1E4 + Dir.delay{p};
            for i=1:length(evt.time)
                evt.description{i}='tones1_sws';
            end
            CreateEvent(evt,basename,'tn1')
            
            if exist('TONEtime2_SWS','var')
                evt.time=TONEtime2_SWS/1E4 + Dir.delay{p};
                for i=1:length(evt.time)
                    evt.description{i}='tones2_sws';
                end
                CreateEvent(evt,basename,'tn2')
            end
            
        end
        
        %% Tones
        load('behavResources.mat', 'ToneEvent')
        evt.time = Range(ToneEvent)/1E4;
        for i=1:length(evt.time)
            evt.description{i}='tones';
        end
        CreateEvent(evt,'tones','ton')
            
        
    catch
        disp('error for this record')
    end
end



