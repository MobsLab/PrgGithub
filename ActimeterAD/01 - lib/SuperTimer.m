classdef SuperTimer
    %SUPERTIMER Redef of timer to handle edition in callback
    %   This is a timer that accepts to be edited during the execution of
    %   its callback function. In fact, it is based in a pair of timers.
    %
    % developed for the ProjetSLEEPcontrol-Antoine project
    % by antoine.delhomme@espci.fr
    %
    
    properties
        % Timers
        timers = {};
        nbOfTimers = 2;
        currentTimer = 1;
        
        % Properties
        StartDelay;
        TimerFcn;
    end
    
    properties (Constant)
        ExecutionMode = 'singleShot';
    end
    
    methods
        function obj = SuperTimer()
            for timerID = 1:obj.nbOfTimers
                obj.timers{timerID} = timer;
            end
        end
        
        function delete(obj)
            for timerID = 1:obj.nbOfTimers
                stop(obj.timers{timerID});
                delete(obj.timers{timerID});
            end
        end
        
        function start(obj)
            if strcmp(obj.timers{obj.currentTimer}.Running, 'on')
                selectedTimer = mod(obj.currentTimer, 2) + 1;
                
                if strcmp(obj.timers{selectedTimer}.Running, 'on')
                    error('All timers are running.');
                else
                    obj.currentTimer = selectedTimer;
                end
            end
            
            obj.timers{obj.currentTimer}.ExecutionMode = obj.ExecutionMode;
            obj.timers{obj.currentTimer}.StartDelay = obj.StartDelay;
            obj.timers{obj.currentTimer}.TimerFcn = obj.TimerFcn;
            
            start(obj.timers{obj.currentTimer});
            
        end
        
        function stop(obj)
            stop(obj.timers{obj.currentTimer})
        end
    end
    
end

