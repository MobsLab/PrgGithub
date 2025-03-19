classdef daqSim < handle
    %DAQSIM This class emulate a daq device
    %   This is a false daq device. It is used to re-run a SWExperiment
    %   with old data.
    %
    % developed for the ProjetSLEEPcontrol-Antoine project
    % by antoine.delhomme@espci.fr
    %
    
    properties
        % Properties of the oject
        
        % Object that picture data
        a;
        
        % A callback function is called every
        % NotifyWhenDataAvailableExceeds samples
        NotifyWhenDataAvailableExceeds;
        
        % Callback function
        %   callback(src, event)
        callback;
        
        % Set to true when the emulation is launched
        IsLogging = false;
        
        src = 'dasSim';
        
        
    end
    
    methods
        function obj = daqSim(acqID, channelID)
            % daqSim Constructor of the class
            %
            
            % Load data
            obj.a = Activity(acqID, channelID);
        end
        
        function startBackground(obj)
            %startBackground Start the emulation
            %
            
            % if callback is not defined, it cannot start
            if isempty(obj.callback)
                error('Please define a callback function before starting the emulation.');
            end
            
            % if NotifyWhenDataAvailableExceeds is not defined, it cannot
            % start
            if isempty(obj.NotifyWhenDataAvailableExceeds) || obj.NotifyWhenDataAvailableExceeds <= 0
                error('Please define correctly NotifyWhenDataAvailableExceeds before starting the emulation.');
            end
            
            fprintf('[daqSim] Start the emulation.\n');
            obj.IsLogging = true;
            
            % Compte le nombre de block
            nbOfBlocks = floor(length(obj.a.data) / obj.NotifyWhenDataAvailableExceeds);
            
            % Main loop
            for blockID = 1:nbOfBlocks
                event.Data = obj.a.data( (blockID - 1)* obj.NotifyWhenDataAvailableExceeds +1 : blockID * obj.NotifyWhenDataAvailableExceeds);
                event.TimeStamps = obj.a.timeStamps_sign( (blockID - 1)* obj.NotifyWhenDataAvailableExceeds +1 : blockID * obj.NotifyWhenDataAvailableExceeds);
                
                obj.callback(obj.src, event);
            end
            
            obj.stop();
        end
        
        function stop(obj)
            %stop Sop
            %
            
            fprintf('[daqSim] Stop the emulation.\n');
            obj.IsLogging = false;
            
        end
    end
    
end

