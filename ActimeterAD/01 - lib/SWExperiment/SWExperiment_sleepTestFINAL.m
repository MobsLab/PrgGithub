classdef SWExperiment_sleepTestFINAL < handle & SWExperiment
    %SWExperiment_sleepTest SWExperiment class to perform sleep
    %                       conditionning test. (probe test)
    %   Set an SWEperiment class to conduct sleep conditoning test. (ie a
    %   probe test)
    %
    % developed for the ProjetSLEEPcontrol-Antoine project
    % by antoine.delhomme@espci.fr
    %
    
    properties
        % Properties of the experiment
        
        % Volume of the stimulations
        volume = 190;
        
        % mean occurance frequency
        SoundWindow = 180; % one every 3 minute
        
        % Duration of the event sound (in s)
        duration_sound = 10;
        
    end
    
    methods
        function obj = SWExperiment_sleepTestFINAL(channels, port)
            %SWExperiment_soundCalibration Constructor
            %   Prepare the experiment, init a SleepWake instance and
            %   register the events listener.
            %
            
            % Set ar guments to their default value is necessary.
            if (nargin < 2)
                port = 'COM4';
            end
            
            fprintf('[SWExperiment] SWExperiment - sleep conditioning testFINAL\n');
            fprintf('               ProjetSLEEPcontrol-Antoine project\n');
            fprintf('               \n');
            fprintf('               This experiment permits to test the\n');
            fprintf('               LAST sleep conditioning.\n');
            fprintf('               \n');
            fprintf('               Initialization...\n');
            
            obj = obj@SWExperiment(channels, port);
            
            fprintf('[SWExperiment] Is inited.\n');
        end
        
        function riseEvent(obj, event, channel, ~)
            if (obj.isRunning)
               % Log the event
                %obj.s.logEvent(event, channel);
                
                if (event == obj.SWc.EVT_NOTHING)
                    if mod(obj.s.currentTimeStamp,obj.SoundWindow)==0
                        % Set the timer
                        % Take a delay
                        delay = randi([10,obj.SoundWindow-10]);
                        
                        %trigger an event
                        obj.timers{channel}.StartDelay = delay;
                        obj.timers{channel}.TimerFcn = {@obj.act_playSound, channel};
                        start(obj.timers{channel});
                        
                    end
                end
            end
        end
        
        %% Actions
        function act_playSound(obj, ~, ~, channel)
            %act_wakeToSleep Action to perform when a wake to sleep
            %                transition is trigger.
            obj.playStim(channel, obj.volume);
        end
        
        %% Sound aliases
        function playStim(obj, channel, volume)
            %setChannel Play the stimulation on a given channel
            %
            obj.s.logEvent(obj.SWc.EVT_SOUND_STIM, channel, volume);
            obj.c.setChannel(channel, obj.c.SOUND_NOISE, volume, obj.c.MODE_TRAIN);
            fprintf('#%d s -> Sound to Mouse in cage #%d.\n', [obj.s.currentTimeStamp,channel]);
        end
        
        %% Commands
        function start(obj)
            %start Start the experiment
            %
            
            obj.s.monitor();
            obj.s.activity();
            obj.s.record();
            
            obj.isRunning = true;
        end
    end
    
end

