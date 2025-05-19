classdef SleepWake < handle
    %SLEEPWAKE Object to monitor a SleepWake experiment
    %   This object is design as an helper to perform a sleep-wake
    %   experiment with mouses, tracking their activity. It offers some
    %   inline analysis on raw signals as:
    %       - a sleep scoring based on actimetry
    %       - a breath frequency measure during sleep
    %
    %   Remark. Please use the Activity class to perform offline analyzes
    %
    % developed for the ProjetSLEEPcontrol-Antoine project
    % by antoine.delhomme@espci.fr
    %
    
    properties
        % Data parameters
        
        % Name of the dir in which data are saved
        dataDir = 'C:\Users\MobsHP\Documents\Antoine\04 - Data\';
        
        % Acquisition parameters
        %	channels:           channels to listen to
        %   fCut:               cut frequency of the low pass
        %   sampleRate:         number of samples by second
        %   performRate:        every performRate, data are prformed (in s)
        %   nbOfBlocks:         nb of blocks used when the signal is performed
        channels;
        sampleRate = 100;
        fCut = 10;
        performRate = 1;
        nbOfBlocks = 10;
        
        % Aliases
        % Those parameters are often used in functions so they are set only
        % once in the constructor
        %   nbOfChannels:       number of channels
        %   blockLength:        number of sample in a block
        nbOfChannels;
        blockLength;
        
        % DAQ parameters
        %   s:                  daq session object
        %   lh:                 handler to the listener of s.DataAvailable
        %   e:                  events
        s;
        lh;
        SWc = SWConsts.getInstance;
        
        % Others
        %   dataActions:        list of action to perform on new data
        %   hPlots_signal:      handlers of signal plots
        %   hAxis_signal:       handles of signal axis
        %   hPlots_breath:      handlers of breath plots
        %   hPlots_activity:    handlers of activity plots (sleep or wake)
        %   recordFiles_sign:   files in which raw signals are stored
        %   recordFiles_block:  files in which extracted data for each
        %                       block are stored
        %   recordFiles_evt:	files in which events are stored.
        %   hEvents:            function handlers of events
        dataActions = containers.Map;
        hPlots_signal = [];
        hAxis_signal = [];
        hPlots_breath = [];
        hPlots_activity = [];
        hPlots_spectre = [];
        recordFiles_sign = [];
        recordFiles_block = [];
        recordFiles_evt = [];
        recordFiles_time = 0;
        hEvents;
        
        % Buffers
        
        % Buffer of the last data
        dataBuffer = [];
        % Buffer of the last activities
        activityBuffer = [];
%         % Buffer of the last spectra
%         spectreBuffer = [];
%         % Buffer of the last breath freq
%         breathBuffer = [];
        % Current timestamp (use in logging purposes)
        currentTimeStamp = 0;
        
        % Tell the size of the activity buffer (in number of blocks)
        activityBufferSize = 20;
        % Store the last activity state validated on the whole activity
        % buffer and triggered to the event listener.
        stateTriggered = [];
        % Store the last activity state triggered to the event listener.
        % Activity states are triggered to the event  listener only when a
        % transition from one state to the other is detected.
        activityTriggered = [];
        
        % Offests to apply on timestamps so recording start at t = 0.
        timeStampsOffsets = [];
        
%         % Count the number consecutive blocks rated as awke epoch but
%         % reevaluated as sleepong one.
%         nbOfConsecutiveReclassifications;
%         % Tell the maximum number of reevaluations.
%         nbOfConsecutiveReclassificationsLim = 1;
        
    end
    
    methods
        function obj = SleepWake(channels)
            %SleepWake Constructor of the class
            %   The constructor set up the object.
            %       channels:       channels to listen to
            %
            
            fprintf('[SleepWake]\tA new SleepWake object is created.\n');
            
            % Save parameters brought in arguments
            obj.channels = channels;
            fprintf('           \tChannels : %s\n', mat2str(obj.channels));
            
            % Set aliases
            obj.nbOfChannels = length(obj.channels);
            obj.blockLength = obj.sampleRate*obj.performRate;
            
            % Init the actions dictionnary
            obj.dataActions('plotSignal') = {@obj.plotSignal, 0};
%             obj.dataActions('plotBreath') = {@obj.plotBreath, 0};
            obj.dataActions('plotActivity') = {@obj.plotActivity, 0};
            obj.dataActions('plotSpectrum') = {@obj.plotSpectrum, 0};
            obj.dataActions('recData') = {@obj.recData, 0};
            
            % Init the session for the National Instrument device
            obj.s = daq.createSession('ni');
            
            % Add inputs
            addAnalogInputChannel(obj.s, 'Dev1', obj.channels-1, 'Voltage');
            for channelID=obj.channels
                obj.s.Channels(channelID).InputType = 'SingleEnded';
            end
            
            % Set the session rate and duration of acquisition
            obj.s.Rate = obj.sampleRate;
            obj.s.IsContinuous = true;

            % Set the notify rate
            obj.s.NotifyWhenDataAvailableExceeds = obj.blockLength;
            
            % Add a listener to the DataAvailable event to plot the data
            obj.lh = addlistener(obj.s, 'DataAvailable', ...
                @(src, event) obj.performData(src, event));
        end
        
        function monitor(obj)
            %Monitor Monitor the raw signal
            %   Call monitor() to display raw signals.
            %   This function prepares the figure in which raw signals will
            %   be displayed. It then start the acquisition.
            %
            
            % Init the figure and the matrix in which handles of each plot
            % will be stored.
            figure(1);
            obj.hPlots_signal = zeros(1, obj.nbOfChannels);
            
            % In function of the number of channels, choose the right
            % parameters for subplot to dispose plots in a convenient way.
            nbOfFig_y = 2;
            if obj.nbOfChannels <= 4
                nbOfFig_x = 2;
                figOrder = [1, 2, 3, 4];
            elseif obj.nbOfChannels <= 8
                nbOfFig_x = 4;
                figOrder = [1, 2, 5, 6, 3, 4, 7, 8];
            else
                nbOfFig_x = 6;
                figOrder = [1, 2, 7, 8, 3, 4, 9, 10, 5, 6, 11, 12];
            end
            
            % Set each plots, handles are stored in dedicated matrix.
            for figureID = 1:obj.nbOfChannels
                obj.hAxis_signal(figureID) = subplot(nbOfFig_y, nbOfFig_x, figOrder(figureID));
                obj.hPlots_signal(figureID) = plot(NaN);
                
                title(sprintf('Channel #%d', obj.channels(figureID)));
                xlabel('time (s)');
                ylabel('signal (ua)');
                ylim([-2.5, 0]);
            end
            
            fprintf('[SleepWake]\tActivity monitoring is turned on.\n');
            
            % Add the display function in the dataActions list
            action = obj.dataActions('plotSignal');
            obj.dataActions('plotSignal') = {action{1}, 1};
            
            % Launch the acquisition if necessary
            obj.start();
        end
        
% %%%%%%%%%%%%%
% [Optimisation] 29 juin 2015 - breath monitoring disabled
        function breath(obj)
%             %Breath Monitor the breath frequency
%             %   Breath create a figure and display the breath frequency in
%             %   real time.
%             %
%             
%             % Init the plot figure
%             figure(2); clf;
%             obj.hPlots_breath = [];
%             
%             nbOfFig_y = 2;
%             if obj.nbOfChannels <= 4
%                 nbOfFig_x = 2;
%                 figOrder = [1, 2, 3, 4];
%             elseif obj.nbOfChannels <= 8
%                 nbOfFig_x = 4;
%                 figOrder = [1, 2, 5, 6, 3, 4, 7, 8];
%             else
%                 nbOfFig_x = 6;
%                 figOrder = [1, 2, 7, 8, 3, 4, 9, 10, 5, 6, 11, 12];
%             end
%                 
%             for figureID = 1:obj.nbOfChannels
%                 subplot(nbOfFig_y, nbOfFig_x, figOrder(figureID));
%                 obj.hPlots_breath = [obj.hPlots_breath, animatedline];
%                 title(sprintf('Channel #%d', obj.channels(figureID)));
%                 xlabel('time (s)');
%                 ylabel('breath frequency (Hz)');
%                 ylim([0, 5]);
%             end
%             
%             fprintf('[SleepWake]\tBreath monitoring is turned on.\n');
%             
%             action = obj.dataActions('plotBreath');
%             % Add the display function in the dataActions list if necessary
%             obj.dataActions('plotBreath') = {action{1}, 1};
%             
%             % Launch the acquisition if necessary
%             obj.start();
        end
% %%%%%%%%%%%%%

        function activity(obj)
            %Activity Interpret raw signals into a sleep/wake status
            %   Interpret raw signals to tell if a mouse is awake or
            %   sleeping.
            %
            
            % Init the plot figure
            %   col 1: activityBuffer
            %   col 2: sum(activityBuffer)
            obj.hPlots_activity = zeros(2, obj.nbOfChannels);
            
            nbOfFig_y = 2;
            if obj.nbOfChannels <= 4
                nbOfFig_x = 2;
                figOrder = [1, 2, 3, 4];
            elseif obj.nbOfChannels <= 8
                nbOfFig_x = 4;
                figOrder = [1, 2, 5, 6, 3, 4, 7, 8];
            else
                nbOfFig_x = 6;
                figOrder = [1, 2, 7, 8, 3, 4, 9, 10, 5, 6, 11, 12];
            end
            
            figure(3); clf;
            for figureID = 1:obj.nbOfChannels
                subplot(nbOfFig_y, nbOfFig_x, figOrder(figureID));
                hold on;
                    obj.hPlots_activity(1, figureID) = plot(NaN);
                    obj.hPlots_activity(2, figureID) = plot(NaN);
                hold off;
                
                title(sprintf('Channel #%d', obj.channels(figureID)));
                xlabel('time (s)');
                ylabel('Sleeping - Awake');
                ylim([-1.5, 1.5]);
            end
            
            fprintf('[SleepWake]\tActivity monitoring is turned on.\n');
            
            action = obj.dataActions('plotActivity');
            % Add the display function in the dataActions list if necessary
            obj.dataActions('plotActivity') = {action{1}, 1};
            
            % Launch the acquisition if necessary
            obj.start();
        end
        
        function spectre(obj)
            %Spectre Monitor the sprectrum of the signal
            %   Spectre create a figure and display the spectrum of the
            %   raw signal.
            %
            
            % Init the plot figure
            figure(4); clf;
            obj.hPlots_spectre = zeros(1, obj.nbOfChannels);
            
            nbOfFig_y = 2;
            if obj.nbOfChannels <= 4
                nbOfFig_x = 2;
                figOrder = [1, 2, 3, 4];
            elseif obj.nbOfChannels <= 8
                nbOfFig_x = 4;
                figOrder = [1, 2, 5, 6, 3, 4, 7, 8];
            else
                nbOfFig_x = 6;
                figOrder = [1, 2, 7, 8, 3, 4, 9, 10, 5, 6, 11, 12];
            end
                
            for figureID = 1:obj.nbOfChannels
                subplot(nbOfFig_y, nbOfFig_x, figOrder(figureID));
                
                obj.hPlots_spectre(figureID) = plot(NaN);
                
                title(sprintf('Channel #%d', obj.channels(figureID)));
                xlabel('freq (Hz)');
                ylabel('amplitude (ua)');
            end
            
            fprintf('[SleepWake]\tSpectrum monitoring is turned on.\n');
            
            action = obj.dataActions('plotSpectrum');
            % Add the display function in the dataActions list if necessary
            obj.dataActions('plotSpectrum') = {action{1}, 1};
            
            % Launch the acquisition if necessary
            obj.start();
        end
        
        function record(obj)
            %Record Record data into a file
            %   Call record() to save raw signals and the inline analysis
            %   into files. For each new acquisition, a dedicated directory
            %   is created. Metadata are written in a .yaml file and files
            %   to store data are prepared. Each mouse has its own pair of
            %   file: one for the raw signal and one for block informations
            %   (sleep-scoring, breath freq, flag if an event is
            %   triggered).
            %
            
            % Raise an error if a record file is already open.
            if ~isempty(obj.recordFiles_sign)
                error('SleepWake:IOError', 'At least one record file is already open.');
            end
            
            % Get the new record id
            d = dir(strcat(obj.dataDir, 'SLEEPActi-*'));
            if isempty(d)
                recordID = 0;
            else
                recordID = str2double(d(end).name(end-3:end)) + 1;
            end
            
            % Make a directory to store the new record
            c = fix(clock);
            recordDirName = sprintf('SLEEPActi-%02d%02d%02d-%04d', [c(1), c(2), c(3), recordID]);
            mkdir(obj.dataDir, recordDirName);
            
            % Save metadata
            obj.saveMetaData(recordID, recordDirName);
            
            % Create a file to store timestamps
            timeFileName = sprintf('%04d-time.dat', recordID);
            obj.recordFiles_time = fopen(strcat(obj.dataDir, recordDirName, '\', timeFileName), 'wt');
            % Check that nothing bad appened
            if obj.recordFiles_time < -1
                fclose(obj.recordFiles_time);
                error('SleepWake:IOError', 'Cannot open the file for timestamps. (%s)', timeFileName);
            end
            
            % Create directories and prepare files to save new data
            obj.recordFiles_sign = zeros(1, obj.nbOfChannels);
            obj.recordFiles_block = zeros(1, obj.nbOfChannels);
            obj.recordFiles_evt = zeros(1, obj.nbOfChannels);
            for channel = obj.channels
                [obj.recordFiles_sign(channel), obj.recordFiles_block(channel), obj.recordFiles_evt(channel)] = ...
                    obj.prepareRecordFiles(recordID, recordDirName, channel);
            end
            
            fprintf('[SleepWake]\tRecording is turned on.\n');
            fprintf('           \t(%s)\n', recordDirName);
            
            % Add the record function in the dataActions list if necessary
            action = obj.dataActions('recData');
            obj.dataActions('recData') = {action{1}, 1};
            
            % Launch the acquisition if necessary
            obj.start();
            
        end
        
        function saveMetaData(obj, recordID, recordDirName)
            %SaveMetaData Save metadata into a distinct file
            %
            
            % Open the file
            MDFileName = sprintf('%04d-info.yaml', recordID);
            MDFile = strcat(obj.dataDir, recordDirName, '\', MDFileName);
            MDFileID = fopen(MDFile, 'wt');
            
            % Check that nothing bad appened
            if MDFileID < -1
                fclose(MDFileID);
                error('SleepWake:IOError', 'Cannot open the file for metadata.');
            end
            
            % Write metadata
            c = fix(clock);
            fprintf(MDFileID, '%-20s %d\n', 'record ID :', recordID);
            fprintf(MDFileID, '%-20s %d-%d-%d\n', 'date :', [c(1), c(2), c(3)]);
            fprintf(MDFileID, '%-20s %d:%d:%d\n', 'hour :', [c(4), c(5), c(6)]);
            fprintf(MDFileID, '\n');
            fprintf(MDFileID, '%-20s %s\n', 'channels :', mat2str(obj.channels));
            fprintf(MDFileID, '%-20s %d\n', 'sample rate :', obj.sampleRate);
            fprintf(MDFileID, '%-20s %d\n', 'cut frequency :', obj.fCut);
            fprintf(MDFileID, '%-20s %d\n', 'perform rate :', obj.performRate);
            fprintf(MDFileID, '%-20s %d\n', 'number of blocks :', obj.nbOfBlocks);
            
            % Close the file
            fclose(MDFileID);
        end
        
        function [file_sign, file_block, file_evt] = prepareRecordFiles(obj, recordID, recordDirName, channel)
            %prepareRecordFiles Create the directory and files to save data
            %                   of a specific channel.
            %
            
            % Create the directory
            recordDir = strcat(obj.dataDir, recordDirName, '\');
            channelDirName = sprintf('%04d-cage%02d', [recordID, channel]);
            channelDir = strcat(recordDir, channelDirName, '\');
            mkdir(recordDir, channelDirName);
            
            % Build files name
            fileName_sign = sprintf('%04d-cage%02d-signal.dat', [recordID, channel]);
            fileName_block = sprintf('%04d-cage%02d-scoring.dat', [recordID, channel]);
            fileName_evt = sprintf('%04d-cage%02d-evt.dat', [recordID, channel]);
            
            % Open files
            file_sign = fopen(strcat(channelDir, fileName_sign), 'wt');
            file_block = fopen(strcat(channelDir, fileName_block), 'wt');
            file_evt = fopen(strcat(channelDir, fileName_evt), 'wt');
            
            if file_sign < 0 || file_block < 0 || file_evt < 0
                % One of the file cannot be open properly.
                % Close previously opened files ...
                fclose(file_sign);
                fclose(file_block);
                fclose(file_evt);
                obj.closeAllFiles();
                
                % ... and raise an error.
                error('simple_acquisition:IOError', 'One of the output files cannot be opened. (%s or %s or %s)', [fileName_sign, fileName_block, fileName_evt]);
            end
        end
        
        %% Actions
        
        function performData(obj, src, event)
            %PerformData Function called each time data are available.
            %   Each time date are available, functions in the dataActions
            %   list are called.
            %
            
            % Update the current timestamp
            obj.currentTimeStamp = event.TimeStamps(1);
            
            % First of all, push incoming data into the buffer
            obj.updateSignal(src, event);
            
% %%%%%%%%%%%%%
% [Optimisation] 29 juin 2015 - spectra monitoring disabled
%             % Then update spectra
%             obj.updateSpectrum(src, event);
% %%%%%%%%%%%%%

            % Then update the activity state
            obj.updateActivity(src, event);
            
            % Apply each action on incoming data
            for action = values(obj.dataActions)
                if action{1}{2}
                    action{1}{1}(src, event);
                end
            end
        end
        
        % Perform the signal
        function updateSignal(obj, ~, event)
            %updateSignal Push incoming data into the buffer.
            %
            
            % Init the dataBuffer if necessary
            if isempty(obj.dataBuffer)
                obj.dataBuffer = zeros(obj.nbOfBlocks * obj.blockLength, obj.nbOfChannels);
            end
            
            for figureID = 1:obj.nbOfChannels
                % Update the dataBuffer
                %d = LowPassFilter(event.Data(:, figureID), obj.fCut, obj.sampleRate);
                d = event.Data(:, figureID);
                obj.dataBuffer(1:(end - obj.blockLength), figureID) = obj.dataBuffer((obj.blockLength + 1):end, figureID);
                obj.dataBuffer((end - obj.blockLength + 1):end, figureID) = d;
            end
        end
        
        function plotSignal(obj, ~, event)
            %PlotSignal Plot raw signals
            %
            
            for figureID = 1:obj.nbOfChannels
                % Plot data
                m = mean(obj.dataBuffer(:, figureID));
                set(obj.hPlots_signal(figureID), 'XData', (-(obj.nbOfBlocks-1)*obj.blockLength:obj.blockLength-1)/obj.sampleRate + event.TimeStamps(1));
                set(obj.hPlots_signal(figureID), 'YData', obj.dataBuffer(:, figureID));
                set(obj.hAxis_signal(figureID), 'YLim', [m-1, m+1]);
                %set(hPlots_signal(figureID), 'Title', sprintf('%f Hz', f));
                drawnow;
            end
        end
        
        % Perform the spectrum
        function updateSpectrum(obj, ~, event)
            %updateSpectrum Compute the spectrum of the raw signal.
            
            % Init the dataBuffer if necessary
            if isempty(obj.spectreBuffer)
                obj.spectreBuffer = zeros(ceil(obj.sampleRate/2), obj.nbOfChannels);
            end
            
            for figureID = 1:obj.nbOfChannels
                % Update the spectreBuffer
                d = abs(fft(event.Data(:, figureID)));
                obj.spectreBuffer(:, figureID) = d(2:(ceil(obj.sampleRate)/2 + 1));
            end
        end
        
        function plotSpectrum(obj, ~, ~)
            %plotSpectrum Plot spectra
            %
            
            for figureID = 1:obj.nbOfChannels
                % Plot data
                set(obj.hPlots_spectre(figureID), 'XData', 1:floor(obj.sampleRate/2));
                set(obj.hPlots_spectre(figureID), 'YData', obj.spectreBuffer(:, figureID));
                drawnow;
            end
        end
        
        % Perform the activity
        function updateActivity(obj, ~, event)
            %updateActivity Update the activity state (sleep/awake)
            %
            
            % Init the activityBuffer if necessary
%             if isempty(obj.activityBuffer)
%                 obj.activityBuffer = zeros(obj.activityBufferSize, obj.nbOfChannels);
%             end
            
            if event.TimeStamps(1) > (obj.nbOfBlocks-1)*obj.performRate
                for figureID = 1:obj.nbOfChannels
                    % Prepare the activity buffer
                    obj.activityBuffer(1:(obj.activityBufferSize - 1), figureID) = obj.activityBuffer(2:end, figureID);
                    
                    % Get the activity state
                    %   IS_SLEEPING = -1;
                    %   IS_UNKNOWN = 0;
                    %   IS_AWAKE = 1;
                    state = GetActivity2(obj.dataBuffer(:, figureID), obj.sampleRate, obj.activityBuffer(end-1, figureID));
                    
                    % Set the new status
% %%%%%%%%%%%%%
% [Optimisation] 29 juin 2015 - reclassification is disabled
%                     if state == obj.SWc.IS_SLEEPING
%                         obj.nbOfConsecutiveReclassifications(figureID) = 0;
%                         newState = obj.SWc.IS_SLEEPING;
%                     elseif obj.nbOfConsecutiveReclassifications(figureID) < obj.nbOfConsecutiveReclassificationsLim
%                         obj.nbOfConsecutiveReclassifications(figureID) = obj.nbOfConsecutiveReclassifications(figureID) +1;
%                         newState = obj.SWc.IS_SLEEPING;
%                     else
%                         newState = state;
%                     end
%                     newState = state;

                    
                    % Update the activityBuffer
                    obj.activityBuffer(end, figureID) = state;
                    
% [Optimisation] 29 juin 2015 - breath monitoring disabled
%                     % Update the breathBuffer
%                     obj.breathBuffer(figureID) = f;
% %%%%%%%%%%%%%                    
                    
                    % If an event handler is defined, trigger some events
                    % according to the activity.
                    if ~isempty(obj.hEvents)
                        % The mouse has been moving long enough, trigger a
                        % sleep to wake event.
                        if sum(obj.activityBuffer(:, figureID)) > 0 && obj.stateTriggered(figureID) <= 0
                            obj.stateTriggered(figureID) = obj.SWc.IS_AWAKE;
                            obj.hEvents(obj.SWc.EVT_WAKE_UP, figureID, obj.activityBuffer(:, figureID));
                        % The mouse has been sleeping long enough, trigger
                        % a wake to sleep event.
                        elseif sum(obj.activityBuffer(:, figureID)) < 0 && obj.stateTriggered(figureID) >= 0
                            obj.stateTriggered(figureID) = obj.SWc.IS_SLEEPING;
                            obj.hEvents(obj.SWc.EVT_FALL_ASLEEP, figureID, obj.activityBuffer(:, figureID));
                        end
                        
                        % The mouse activity changes from sleep to wake.
                        if obj.activityBuffer(end, figureID) > 0 && obj.activityTriggered(figureID) <= 0
                            obj.activityTriggered(figureID) = obj.SWc.IS_AWAKE;
                            obj.hEvents(obj.SWc.EVT_IS_AWAKE, figureID, obj.activityBuffer(:, figureID));
                        % The mouse activity changes from wake to sleep.
                        elseif obj.activityBuffer(end, figureID) < 0 && obj.activityTriggered(figureID) >= 0
                            obj.activityTriggered(figureID) = obj.SWc.IS_SLEEPING;
                            obj.hEvents(obj.SWc.EVT_IS_SLEEPING, figureID, obj.activityBuffer(:, figureID));
                        end
                        
                    end
                    
                end
            end
        end
        
        function plotActivity(obj, ~, event)
            %plotActivity Plot the activity state (sleep/awake)
            %
            
            % Define some aliases
            %   _nbOfFigures_	nb of figures that will be updated
            nbOfFigures = length(obj.hPlots_activity);
            
            if event.TimeStamps(1) > (obj.nbOfBlocks-1)*obj.performRate
                for figureID = 1:nbOfFigures
                    set(obj.hPlots_activity(1, figureID), 'XData', ((1-obj.activityBufferSize):0) + event.TimeStamps(1) + obj.performRate/2);
                    set(obj.hPlots_activity(2, figureID), 'XData', ((1-obj.activityBufferSize):0) + event.TimeStamps(1) + obj.performRate/2);
                    set(obj.hPlots_activity(1, figureID), 'YData', obj.activityBuffer(:, figureID) );
                    set(obj.hPlots_activity(2, figureID), 'YData', sum(obj.activityBuffer(:, figureID))/obj.activityBufferSize * ones(1, obj.activityBufferSize)  );
                    
                    drawnow;
                end
            end
        end
        
% %%%%%%%%%%%%%
% [Optimisation] 29 juin 2015 - breath monitoring disabled
        % Perform the breath
        function plotBreath(obj, src, event)
%             %PlotSignal Plot the breath frequency
%             %
%             
%             for figureID = 1:obj.nbOfChannels
%                 addpoints(obj.hPlots_breath(figureID), event.TimeStamps(1), obj.breathBuffer(figureID));
%                 drawnow;
%             end
        end
% %%%%%%%%%%%%%
        
        % Perform the record    
        function recData(obj, ~, event)
            %RecData Write data in their record file
            %
            
            % Define the format in which data will be written
            format_time = '%.2f\n';
            format_sign = '%.4f\n';
            format_block = '%d %d %.1f\n';
            
            % Set the timestamps offset if necessary
            if isempty(obj.timeStampsOffsets)
                obj.timeStampsOffsets = zeros(1, obj.nbOfChannels);
                for channelId = 1:obj.nbOfChannels
                    obj.timeStampsOffsets(channelId) = event.TimeStamps(1);
                end
            end
            
            % Write timestamps
            fprintf(obj.recordFiles_time, format_time, event.TimeStamps' - obj.timeStampsOffsets(1));
            
            for channelID = 1:obj.nbOfChannels
                % Write signal
                fprintf(obj.recordFiles_sign(channelID), format_sign, event.Data(:, channelID)');
                % Write scoring
                fprintf(obj.recordFiles_block(channelID), format_block, ...
                    obj.activityBuffer(end, channelID), ...
                    obj.stateTriggered(channelID), ...
                    0);
%                     obj.breathBuffer(channelID));
            end
        end
        
        function logEvent(obj, event, channelID, other)
            %logEvent Log an event in the event file
            %
            
            if (nargin < 4)
                other = 0;
            end
            
            if ~isempty(obj.recordFiles_evt) && obj.recordFiles_evt(channelID) > 0
                %fprintf('log: time: %d, cage #%d, event %d\n', obj.currentTimeStamp, channelID, event);
                fprintf(obj.recordFiles_evt(channelID), '%d %d %d\n', obj.currentTimeStamp, event, other);
            end
        end
        
        %% Other
        
        function start(obj)
            %Start Start the DAS session
            %
            if ~obj.s.IsLogging
                % Clear buffer
                obj.dataBuffer  = [];
%                 obj.spectreBuffer = [];
                
                % Init the activity buffer
                obj.activityBuffer = zeros(obj.activityBufferSize, obj.nbOfChannels);
%                 % Init the reclassification counter array
%                 obj.nbOfConsecutiveReclassifications = zeros(1, obj.nbOfChannels);
%                 % Init the breaths array
%                 obj.breathBuffer = zeros(1, obj.nbOfChannels);
                % Reset the last state triggered
                obj.stateTriggered = zeros(1, obj.nbOfChannels);
                % Reset the last activity triggered
                obj.activityTriggered = zeros(1, obj.nbOfChannels);
            
                % Clear breath plots
                for figureID = 1:length(obj.hPlots_breath)
                    obj.hPlots_breath(figureID).clearpoints();
                end
                
                % Start the acquisition
                startBackground(obj.s);
            end
        end
        
        function stop(obj)
            %Stop Stop the acquisition
            %
            
            % Stop the session
            stop(obj.s);
            
            % Stop the recording
            action = obj.dataActions('recData');
            % Remove the record function from the dataActions list
            obj.dataActions('recData') = {action{1}, 0};
            
            % Clear the timestamps offset array
            obj.timeStampsOffsets = [];
            
            % Close all files
            obj.closeAllFiles();
        end
        
        function closeAllFiles(obj)
            %closeAllFiles Close all files opened by the class
            %
            
            % Close record files (raw signal)
            for fileID = obj.recordFiles_sign
                if fileID > 0
                    fclose(fileID);
                end
            end
            obj.recordFiles_sign = [];
            
            % Close record files (block data)
            for fileID = obj.recordFiles_block
                if fileID > 0
                    fclose(fileID);
                end
            end
            obj.recordFiles_block = [];
            
            % Close record files (evt data)
            for fileID = obj.recordFiles_evt
                if fileID > 0
                    fclose(fileID);
                end
            end
            obj.recordFiles_evt = [];
            
            % Close the timestamps file
            if obj.recordFiles_time > 0
                fclose(obj.recordFiles_time);
            end
        end
        
        function delete(obj)
            %Delete Destructor of the class
            %   Delete carefuly the object.
            %
            fprintf('[SleepWake] Deleted\n');
            obj.stop();
        end
    end
    
end

