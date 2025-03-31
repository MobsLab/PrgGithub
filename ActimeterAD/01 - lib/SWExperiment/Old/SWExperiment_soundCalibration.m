classdef SWExperiment_soundCalibration < handle & SWExperiment
    %SWEXPERIMENT_soundCalibration SWExperiment class to calibrate sounds
    %   Set an SWEperiment class to conduct a sound calibration in the
    %   context of ProjetSLEEPcontrol-Antoine.
    %
    % developed for the ProjetSLEEPcontrol-Antoine project
    % by antoine.delhomme@espci.fr
    %
    
    properties
        % Objects
        %   timers:         timers for each channel
        timers = {};
        
        % Aliases
        colors = [0.18, 0.42, 0.78; ...
                  0.51, 0.76, 0.18; ...
                  0.96, 0.56, 0.13];
        
        % Properties of the experiment
        
        % List of volumes to test
        volumesList = [140, 150, 160, 170, 180, 190, 200, 210, 220, 230, 240];
        nbOfVolumes;
        
        % Array of indexes of volume tested for each mouse
        mouse_currentVolume = [];
        % Historic of effective volumes
        mouse_volumesHistoric = [];
        % Counter of the number of successfull stimulations for each mouse
        mouse_nbOfSuccessStim = [];
        % Maximal number of stimulations
        nbMaxOfStim = 5;
        % Flag about the stage of the calibration for each mouse
        mouse_isCalibDone = [];
        
        % Timing
        % Delay before event for transition wake > sleep (in s)
        delay_wakeToSleep = 20;
        % Delay between stimulation and detection of its effect (in s)
        delay_beforeDetection = 5;
        % Delay between volume tests (in s)
        delay_interTests = 15;
        % Before trigerring a wakeToSleep event, the actimetry is monitor on a
        % smaller window to prevent the event if the mouse just wakes up.
        checkWindow_wakeToSleep = 5;
    end
    
    methods
        function obj = SWExperiment_soundCalibration(channels, port)
            %SWExperiment_soundCalibration Constructor
            %   Prepare the experiment.
            %
            
            % Set arguments to their default value is necessary.
            if (nargin < 2)
                port = 'COM4';
            end
            
            fprintf('[SWExperiment] SWExperiment - sound calibration\n');
            fprintf('               ProjetSLEEPcontrol-Antoine project\n');
            fprintf('               \n');
            fprintf('               This experiment permits to find the\n');
            fprintf('               good volume for each mouse.\n');
            fprintf('               \n');
            fprintf('               Initialization...\n');
            
            obj = obj@SWExperiment(channels, port);
            
            % Init timers
            % Use here SuperTimer to easily reconfigure them in callback
            % functions. This is currently only suported with the
            % singleShot mode.
            for channelID = obj.s.channels
                obj.timers{channelID} = SuperTimer;
            end
            
            % Init variables of the experiments
            obj.nbOfVolumes = length(obj.volumesList);
            
            fprintf('[SWExperiment] Is inited.\n');
        end
        
        function riseEvent(obj, event, channel, lastActivities)
            %riseEvent Function called by SleepWake when an event occurs.
            %   Here, riseEvent() is written to handle a sound calibration.
            %
            
            if (obj.isRunning)
                % Log the event
                obj.s.logEvent(event, channel);
            
                if (event == obj.SWc.EVT_FALL_ASLEEP)
                    fprintf('[SWExperiment] Mouse in cage #%d falls asleep.\n', channel);
                    if ~obj.mouse_isCalibDone(channel)
                        % Find the beginning of the event (in the ref of last
                        % activities)
                        t_1 = find(lastActivities == obj.SWc.IS_SLEEPING, 1, 'last');
                        if isempty(t_1)
                            evt_beginning = 1;
                        else
                            t_2 = find(lastActivities(1:t_1) == obj.SWc.IS_AWAKE, 1, 'last');
                            if isempty(t_2)
                                evt_beginning = 1;
                            else
                                evt_beginning = t_2 + 1;
                            end
                        end
                        
                        % Log the true beginning of the event
                        obj.s.logEvent(obj.SWc.EVT_FALL_ASLEEP_CORR, channel, - length(lastActivities) + evt_beginning);

                        % Set the timer
                        % Compute the delay of the timer
                        delay = obj.delay_wakeToSleep - length(lastActivities) + evt_beginning;

                        % If the delay is < 0, it is too late to trigger an event
                        if delay > 0
                            obj.timers{channel}.StartDelay = delay;
                            obj.timers{channel}.TimerFcn = {@obj.act_doStimulation, channel};
                            start(obj.timers{channel});
                        end
                    end

                elseif (event == obj.SWc.EVT_WAKE_UP)
                    fprintf('[SWExperiment] Mouse in cage #%d wakes up.\n', channel);

                    obj.act_wakeUpInhibitor(channel);
                end
            end
        end
        
        function plotStatus(obj)
            %plotStatus Plot the status of the calibration
            %
            
            figure(10); clf;
            subplot(2, 1, 1);
            hold on;
            for channelID = 1:obj.nbOfChannels
                color = obj.colors(obj.mouse_isCalibDone(channelID) + 1, :);
                bar(channelID, obj.volumesList(obj.mouse_currentVolume(channelID)), 'FaceColor', color, 'EdgeColor', color );
            end
            title('SWExperiment\_soundCalibration');
            xlabel('cage');
            ylabel('current volume (ua)');
            
            ylim([min(obj.volumesList) - 10, max(obj.volumesList) + 10]);
            
            subplot(2, 1, 2);
            title('Number of sample per mouse');
            bar(1:obj.nbOfChannels, obj.mouse_nbOfSuccessStim, 'FaceColor', obj.colors(1, :), 'EdgeColor', obj.colors(1, :));
            set(gca, 'ydir', 'reverse');
            
            ylim([0, obj.nbMaxOfStim + 1]);
            
        end
        
        %% Actions
        
        function act_doStimulation(obj, ~, ~, channel)
            %act_tryVolume Try a volume
            %   Play a stim sound at a definit volume and see if it has an
            %   effect on the mouse.
            %
            
            % Aliases
            volume = obj.volumesList(obj.mouse_currentVolume(channel));
            
            % Last activities
            lastActivities = obj.s.activityBuffer(end - obj.checkWindow_wakeToSleep + 1:end, channel);
            
            % Last test of the activity of the mouse before stimulating.
            if isempty(find(lastActivities == obj.SWc.IS_AWAKE, 1))
                % The mouse seems to be still sleeping so fire the
                % stimulation.
                fprintf('[SWExperiment] Cage #%d: try volume %d.\n', channel, volume);
                
                %%% Play the sound
                obj.playStim(channel, volume);
                %%%%%%%%%%%%

                % Set a new timer to see the result of the stimulation
                obj.timers{channel}.StartDelay = obj.delay_beforeDetection;
                obj.timers{channel}.TimerFcn = {@obj.act_resultOfStimulation, channel};
                start(obj.timers{channel});
                
                % Update the status graph
                obj.plotStatus();
            else
                % The mouse may be awaken so do not play the stimulation.
                fprintf('[SWExperiment] Cage #%d: try aborted as the mouse may be awaken.\n', channel);
            end
        end
        
        function act_resultOfStimulation(obj, ~, ~, channel)
            %act_resultOfStimulation Test the result of a stimulation
            %   If the mouse mouse after a stimulation, it means that it
            %   has been heard.
            %
            
            % Last activities
            lastActivities = obj.s.activityBuffer(end - obj.delay_beforeDetection + 1:end, channel);
            
            volume = obj.volumesList(obj.mouse_currentVolume(channel));
            
            if isempty(find(lastActivities == obj.SWc.IS_AWAKE, 1))
                % The stimulation was not heard so try another volume.
                if obj.mouse_currentVolume(channel) < length(obj.volumesList)
                    obj.mouse_currentVolume(channel) = obj.mouse_currentVolume(channel) + 1;

                    % Set a new timer to try another volume
                    obj.timers{channel}.StartDelay = obj.delay_interTests - obj.delay_beforeDetection;
                    obj.timers{channel}.TimerFcn = {@obj.act_doStimulation, channel};
                    start(obj.timers{channel});

                    fprintf('[SWExperiment] Cage #%d: volume %d is ineffective, try next.\n', channel, volume);
                else
                    % The last volume was tested, anyway, increment the
                    % counter of effective stimulation and save its volume.
                    obj.mouse_nbOfSuccessStim(channel) = obj.mouse_nbOfSuccessStim(channel) + 1;
                    obj.mouse_volumesHistoric(obj.mouse_nbOfSuccessStim(channel)) = volume;
                
                    % During a calibration session, the number of effective
                    % stimulation is limited. Check if the threshold is
                    % crossed.
                    if obj.mouse_nbOfSuccessStim(channel) >= obj.nbMaxOfStim
                        fprintf('[SWExperiment] Cage #%d: volume %d is ineffective and we cannot go further. End\n', channel, volume);
                        obj.mouse_isCalibDone(channel) = 2;
                    else
                        fprintf('[SWExperiment] Cage #%d: volume %d is ineffective and we cannot go further. Continue anyway.\n', channel, volume);
                        obj.mouse_currentVolume(channel) = obj.mouse_currentVolume(channel) - 2;
                        if obj.mouse_currentVolume(channel) <= 0
                            obj.mouse_currentVolume(channel) = 1;
                        end
                    end
                
                end
            else
                % The stimulation was heard
                % Increment the counter of effective stimulations and save
                % its volume.
                obj.mouse_nbOfSuccessStim(channel) = obj.mouse_nbOfSuccessStim(channel) + 1;
                obj.mouse_volumesHistoric(obj.mouse_nbOfSuccessStim(channel)) = volume;
                
                % During a calibration session, the number of effective
                % stimulation is limited. Check if the threshold is
                % crossed.
                if obj.mouse_nbOfSuccessStim(channel) >= obj.nbMaxOfStim
                    % The maximum nulber of effective stimulations is
                    % reached, so the calibration process stops for this
                    % mouse.
                    fprintf('[SWExperiment] Cage #%d: volume %d seems to be effictive. Stop.\n', channel, volume);
                    obj.mouse_isCalibDone(channel) = 1;
                else
                    % The current number of effective stimulations is below
                    % the maximal number, the calibration process
                    % continues from a lower volume level.
                    fprintf('[SWExperiment] Cage #%d: volume %d seems to be efficient. Continue.\n', channel, volume);
                    obj.mouse_currentVolume(channel) = obj.mouse_currentVolume(channel) - 2;
                    if obj.mouse_currentVolume(channel) <= 0
                        obj.mouse_currentVolume(channel) = 1;
                    end
                end
                
            end
            
            % Test if the calibration is completed.
            if isempty(find(obj.mouse_isCalibDone < 1, 1))
                fprintf('[SWExperiment] >>> The calibration is completed. <<<\n');
            end
            
            % Update the dashboard
            obj.plotStatus();
            
        end
        
        function act_wakeUpInhibitor(obj, channel)
            %act_wakeUpInhibitor Actions to conduct if the mouse wake up.
            %
            
            %%% Stop the sound
            obj.stopSound(channel);
            %%%%%%%%%%%%
            
            if (strcmp(obj.timers{channel}.Running, 'on'))
                % The timer was running
                fprintf('[SWExperiment] Cage #%d: test is stopped because the mouse wake up.\n', channel);
            end
            
            % Stop any timer
            stop(obj.timers{channel});
        end
        
        %% Sound aliases
        function playStim(obj, channel, volume)
            %setChannel Play the stimulation on a given channel
            %
            
            obj.s.logEvent(obj.SWc.EVT_SOUND_STIM, channel, volume);
            obj.c.setChannel(channel, obj.c.SOUND_NOISE, volume, obj.c.MODE_TRAIN);
        end
        
        function stopSound(obj, channel)
            %stopSound Stop sound on given channel
            %
            
            obj.s.logEvent(obj.SWc.EVT_SOUND_STOP, channel);
            obj.c.setChannel(channel, obj.c.SOUND_NOISE, 0);
        end
        
         %% Commands
        function start(obj, raz)
            %start Start the experiment
            %   Reset results of the calibration and start the experiment.
            %   Set raz to 'noReset' do disable the reset.
            %
            
            if nargin < 2 || ~strcmp(raz, 'noReset')
                obj.reset();
            end
            obj.s.monitor();
            obj.s.activity();
            obj.s.record();
            
            obj.isRunning = true;
        end
        
        function stop(obj)
            %stop Stop the experiment
            %
            
            obj.isRunning = false;
            
            % Stop timers and sounds
            for channelID = obj.s.channels
                stop(obj.timers{channelID});
                obj.stopSound(channelID);
            end
            
            % Call the stop function from the superclass
            stop@SWExperiment(obj);
            
        end
        
        function reset(obj)
            %reset Reset the results of the calibration
            %
            fprintf('[SWExperiment] The experiment is reset.\n');
            obj.mouse_currentVolume = ones(1, obj.nbOfChannels);
            obj.mouse_volumesHistoric = zeros(obj.nbMaxOfStim, obj.nbOfChannels);
            obj.mouse_isCalibDone = zeros(1, obj.nbOfChannels);
            obj.mouse_nbOfSuccessStim = zeros(1, obj.nbOfChannels);
            
        end
    end
    
end

