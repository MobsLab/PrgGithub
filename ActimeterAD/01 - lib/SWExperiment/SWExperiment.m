classdef SWExperiment < handle
    %SWEXPERIMENT Pattern of SWExperiment classes
    %   Define the structure of an Experiment class that interact with
    %   SleepWake.
    %
    % by antoine.delhomme@espci.fr
    %
    
    properties (Abstract)
        
    end
    
    properties
        % Objects

        % Instance of the SleepWake class
        s;
        % Instance of soundControl
        c;
        % Timers
        timers = {};
        
        % Constants about sleepWake
        SWc = SWConsts.getInstance;
        % Flag about the state of the experiment
        isRunning = false;
        
        % Aliases
        
        %   nbOfChannels:   number of channels
        nbOfChannels;
    end
    
    methods (Abstract)
        riseEvent(obj, event, lastActivities)
        start(obj)
    end
    
    methods
        function obj = SWExperiment(channels, port)
            %SWExperiment constructor
            %   Build essential part of a SWExperiment: get an instance of
            %   SleepWake and of soundControl.
            %
            
            % Save aliases
            obj.nbOfChannels = length(channels);
            
            % Get a SleepWake instance
            obj.s = SleepWake(channels);
            % Register the events listener
            obj.s.hEvents = @obj.riseEvent;
            
            % Get a SoundControl instance
            obj.c = soundControl.getInstance(port);
            
            % Init timers
            % Use here SuperTimer to easily reconfigure them in callback
            % functions. This is currently only suported with the
            % singleShot mode.
            for channelID = obj.s.channels
                obj.timers{channelID} = SuperTimer;
            end
        end
        
        %% Sound aliases
        function stopSound(obj, channel)
            %stopSound Stop sound on given channel
            %
            
            obj.s.logEvent(obj.SWc.EVT_SOUND_STOP, channel);
            obj.c.setChannel(channel, obj.c.SOUND_NOISE, 0);
        end
        
        
        %% Commands
        function stop(obj)
            %stop Stop the experiment
            %

            obj.isRunning = false;
            
            % Stop timers and sounds
            for channelID = obj.s.channels
                stop(obj.timers{channelID});
                obj.stopSound(channelID);
            end
            
            % Stop the acquisition
            obj.s.stop();
        end
        
        function delete(obj)
            %delete Clear thing properly stopping everything
            %
            
            obj.stop();
            delete(obj.c);
            delete(obj.s);
            
            % Delete timers
            for channelID = obj.s.channels
                delete(obj.timers{channelID});
            end
        end
    end
    
end

