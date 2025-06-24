classdef SWExperiment_sleepWakeConditioning < handle & SWExperiment
    %SWExperiment_sleepConditioning SWExperiment class to perform sleep and
    %                               wake conditioning
    %   Set an SWEperiment class to conduct sleep/wake conditoning.
    %
    % developed for the ProjetSLEEPcontrol-Antoine project
    % by antoine.delhomme@espci.fr
    %
    
    properties
        % Properties of the experiment
        
        % Define the two groups
        % Mouses in group_sleepConditioning will get stimulated at the
        % beginnig of their sleep epochs
        group_sleepConditioning = [3, 4, 7, 8, 11, 12];
        % Mouses in group_wakeContioning will get stimulated at the
        % beginning of their moving epochs
        group_wakeConditioning = [1, 2, 5, 6, 9, 10];
        
        % Volume of the stimulations
        volume = 190;
        
        % Delay before event for transition sleep > wake (in s)
        delay_sleepToWake = 20;
        % Delay before event for transition wake > sleep (in s)
        delay_wakeToSleep = 20;

        % Duration of the sleep to wake event sound (in s)
        duration_sleepToWake = 10;
        % DUration of the wake to sleep event sound (in s)
        duration_wakeToSleep = 10;

        % Before trigerring a sleepToWake event, the actimetry is monitor on a
        % smaller window to prevent the event if the mouse just falls asleep.
        % (in s)
        checkWindow_sleepToWake = 5;
        % Before trigerring a wakeToSleep event, the actimetry is monitor on a
        % smaller window to prevent the event if the mouse just wakes up.
        checkWindow_wakeToSleep = 5;
    end
    
    methods
        function obj = SWExperiment_sleepWakeConditioning(channels, port)
            %SWExperiment_soundCalibration Constructor
            %   Prepare the experiment, init a SleepWake instance and
            %   register the events listener.
            %
            
            % Set ar guments to their default value is necessary.
            if (nargin < 2)
                port = 'COM4';
            end
            
            fprintf('[SWExperiment] SWExperiment - sleep conditioning\n');
            fprintf('               ProjetSLEEPcontrol-Antoine project\n');
            fprintf('               \n');
            fprintf('               This experiment permits to perform\n');
            fprintf('               sleep conditioning.\n');
            fprintf('               \n');
            fprintf('               Initialization...\n');
            
            obj = obj@SWExperiment(channels, port);
            
            fprintf('[SWExperiment] Is inited.\n');
        end
        
        function riseEvent(obj, event, channel, lastActivities)
            %riseEvent Function called by SleepWake when an event occurs.
            %
            
            if (obj.isRunning)
                % Log the event
                obj.s.logEvent(event, channel);
                
                if (event == obj.SWc.EVT_IS_SLEEPING)
                    % Immediatly trigger the fallAsleepInhibitor();
                    obj.act_fallAsleepInhibitor(channel);
                    
                elseif (event == obj.SWc.EVT_IS_AWAKE)
                    % Immediatly trigger the wakeUpInhibitor();
                    obj.act_wakeUpInhibitor(channel);
            
                elseif (event == obj.SWc.EVT_FALL_ASLEEP)
                    % Immediatly trigger the fallAsleepInhibitor();
                    obj.act_fallAsleepInhibitor(channel);
                    
                    if any(obj.group_sleepConditioning == channel)
                        fprintf('[SWExperiment] Mouse in cage #%d falls asleep and is in the sleepConditioning group.\n', channel);
%                         % Find the beginning of the event (in the ref of last
%                         % activities)
%                         t_1 = find(lastActivities == obj.SWc.IS_SLEEPING, 1, 'last');
%                         if isempty(t_1)
%                             evt_beginning = 1;
%                         else
%                             t_2 = find(lastActivities(1:t_1) == obj.SWc.IS_AWAKE, 1, 'last');
%                             if isempty(t_2)
%                                 evt_beginning = 1;
%                             else
%                                 evt_beginning = t_2 + 1;
%                             end
%                         end

                        % Find the beginning of the event (in the ref of last
                        % activities)
                        evt_beginning = SWBeginningOfSleep(lastActivities, obj.SWc);

                        % Log the true beginning of the event
                        obj.s.logEvent(obj.SWc.EVT_FALL_ASLEEP_CORR, channel, - length(lastActivities) + evt_beginning);
                        
                        % Set the timer
                        % Compute the delay of the timer
                        delay = obj.delay_wakeToSleep - length(lastActivities) + evt_beginning;

                        % If the dalay is < 0, it is too late to trigger an event
                        if delay > 0
                            obj.timers{channel}.StartDelay = delay;
                            obj.timers{channel}.TimerFcn = {@obj.act_playWakeToSleepSound, channel};
                            start(obj.timers{channel});
                        end
                    else
                        fprintf('[SWExperiment] Mouse in cage #%d falls asleep but is not in the right group.\n', channel);
                    end
                    
                elseif (event == obj.SWc.EVT_WAKE_UP)
                    % Immediatly trigger the wakeUpInhibitor();
                    obj.act_wakeUpInhibitor(channel);
                    
                    if any(obj.group_wakeConditioning == channel)
                        fprintf('[SWExperiment] Mouse in cage #%d wakes up and is in the wakeConditioning group.\n', channel);
%                         % Find the beginning of the event (in the ref of last
%                         % activities)
%                         t_1 = find(lastActivities == obj.SWc.IS_AWAKE, 1, 'last');
%                         if isempty(t_1)
%                             evt_beginning = 1;
%                         else
%                             t_2 = find(lastActivities(1:t_1) == obj.SWc.IS_SLEEPING, 1, 'last');
%                             if isempty(t_2)
%                                 evt_beginning = 1;
%                             else
%                                 evt_beginning = t_2 + 1;
%                             end
%                         end

                        % Find the beginning of the event (in the ref of last
                        % activities)
                        evt_beginning = SWBeginningOfWakefulness(lastActivities, obj.SWc);

                        % Log the true beginning of the event
                        obj.s.logEvent(obj.SWc.EVT_WAKE_UP_CORR, channel, - length(lastActivities) + evt_beginning);

                        % Set the timer
                        % Compute the delay of the timer
                        delay = obj.delay_sleepToWake - length(lastActivities) + evt_beginning;

                        % If the dalay is < 0, it is too late to trigger an event
                        if delay > 0
                            obj.timers{channel}.StartDelay = delay;
                            obj.timers{channel}.TimerFcn = {@obj.act_playSleepToWakeSound, channel};
                            start(obj.timers{channel});
                        end
                    else
                        fprintf('[SWExperiment] Mouse in cage #%d wakes up but is not in the right group.\n', channel);
                    end
                end
            end
        end
           
        %% Actions
        function act_playWakeToSleepSound(obj, ~, ~, channel)
            %act_wakeToSleep Action to perform when a wake to sleep
            %                transition is trigger.
            %
            
            % Last check before triggering the action
            lastActivities = obj.s.activityBuffer(end - obj.checkWindow_wakeToSleep + 1:end, channel);
            fprintf('[SWExperiment] act_playWakeToSleepSound for cage #%d.', channel);
            
            if isempty(find(lastActivities == obj.SWc.IS_AWAKE, 1))
                obj.playStim(channel, obj.volume);
                fprintf('\tconfirmé\n');
            else
                fprintf('\tras\n');
            end
        end
        
        function act_playSleepToWakeSound(obj, ~, ~, channel)
            %act_wakeToSleep Action to perform when a sleep to wake
            %                transition is trigger.
            %
            
            % Last check before triggering the action
            lastActivities = obj.s.activityBuffer(end - obj.checkWindow_wakeToSleep + 1:end, channel);
            fprintf('[SWExperiment] act_playSleepToWakeSound for cage #%d.', channel);
            
            if isempty(find(lastActivities == obj.SWc.IS_SLEEPING, 1))
                obj.playStim(channel, obj.volume);
                fprintf('\tconfirmé\n');
            else
                fprintf('\tras\n');
            end
        end
        
        function act_wakeUpInhibitor(obj, channel)
            %act_wakeUpInhibitor Actions to perform in case of a wake up
            %   If some wakeToSleep actions are performed and the mouse
            %   sudenly wakes up, stop them.
            %
            
            fprintf('[SWExperiment] act_wakeUpInhibitor for cage #%d.\n', channel);
            
            %%% Stop the sound
            obj.stopSound(channel);
            %%%%%%%%%%%%
            
            % If a timer is running, stop it
            if (strcmp(obj.timers{channel}.Running, 'on'))
                stop(obj.timers{channel});
                fprintf('[SWExperiment] Cage #%d: test is stopped because the mouse wakes up.\n', channel);
            end
        end
        
        function act_fallAsleepInhibitor(obj, channel)
            %act_fallAsleepInhibitor Actions to perform in case of a mouse
            %                        falls asleep.
            %   If some sleepToWake actions are performed and the mouse
            %   sudenly falls asleep, stop them.
            %
            
            fprintf('[SWExperiment] act_fallAsleepInhibitor for cage #%d.\n', channel);
            
            % Stop sound
            obj.stopSound(channel);
            %%%%%%%%%%%%%%%
            
            % If a timer is running, stop it
            if (strcmp(obj.timers{channel}.Running, 'on'))
                stop(obj.timers{channel});
                fprintf('[SWExperiment] Cage #%d: test is stopped because the mouse falls asleep.\n', channel);
            end
        end
        
        %% Sound aliases
        function playStim(obj, channel, volume)
            %setChannel Play the stimulation on a given channel
            %
            
            obj.s.logEvent(obj.SWc.EVT_SOUND_STIM, channel, volume);
            obj.c.setChannel(channel, obj.c.SOUND_NOISE, volume, obj.c.MODE_TRAIN);
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

