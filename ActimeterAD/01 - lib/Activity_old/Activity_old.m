classdef Activity_old < handle
    %ACTIVITY Represent the activity signal of a mouse.
    %   Activity represents the activity signal of a mouse.
    %
    
    properties
        % General properties
        %   dataDir     dir in which data files are stored
        %   dataFileName_sign    file name of the data file
        acqID;
        %dataDir = 'C:\Users\MobsHP\Documents\Antoine\04 - Data\';
        dataDir = 'C:\Users\MOBs\Documents\Antoine\04 - Data\';
        dataFileName_sign;
        dataFileName_block;
        dataFile_sign;
        dataFile_block;
        fdata_sign = -1;
        fdata_block = -1;
        
        % Particular properties
        areBlockDataKnown;
        timeStamps_sign;
        timeStamps_block;
        data;
        activity;
        breath;
        sleepScoring;
        
        % Acquisition parameters
        %   _n_                 number of samples
        %   _fCut_              cut frequency of the low pass
        %   _sampleRate_        number of samples by second
        %   _performRate_       every performRate, data are prformed (in s)
        %   _nbOfBlocks_        nb of blocks to display or size of a group
        %   _nbOfGroups_        number of groups in this acquisition
        %   _timeStampsOffset_  timestamps offset so the acquisition starts
        %                       at t = 0
        n;
        fCut = 10;
        sampleRate = 100;
        performRate = 1;
        nbOfBlocks = 4;
        nbOfGroups;
        timeStampsOffset;
        
        % Constants
        SWc = SWConsts.getInstance;
    end
    
    methods
        function obj = Activity_old(acqID, channelID)
            %Activity Constructor of the class
            %   Load the data file according to the acqID and to the
            %   channelID.
            %
            
            % Save the acquisition ID
            obj.acqID = acqID;
            
            % Get the dir of the experiment
            d = dir(strcat(obj.dataDir, sprintf('act_%04d*', acqID)));
            
            obj.dataFileName_sign = strcat(d(end).name, '\', sprintf('act_%04d#%d_sign.dat', [acqID, channelID]));
            obj.dataFile_sign = strcat(obj.dataDir, obj.dataFileName_sign);
            
            obj.dataFileName_block = strcat(d(end).name, '\', sprintf('act_%04d#%d_block.dat', [acqID, channelID]));
            obj.dataFile_block = strcat(obj.dataDir, obj.dataFileName_block);
            
            % Do some printing
            fprintf('[Activity]\tOpen %s.\n', obj.dataFileName_sign);
            
            % Test if the data file exists
            if exist(obj.dataFile_sign, 'file') == 2
                % The file exists so open it
                obj.fdata_sign = fopen(obj.dataFile_sign, 'rt');
                
                if obj.fdata_sign < 0
                    error('Activity:IOError', 'Cannot open %s.', obj.dataFileName_sign);
                end
            else
                error('Activity:IOError', 'The file %s doesnot exist.', obj.dataFileName_sign);
            end
            
            % Test if the block file exists
            if exist(obj.dataFile_block, 'file') == 2
                % The file exists so open it
                obj.fdata_block = fopen(obj.dataFile_block, 'rt');
                
                if obj.fdata_block < 0
                    error('Activity:IOError', 'Cannot open %s.', obj.dataFileName_block);
                end
                
                obj.areBlockDataKnown = true;
            else
                obj.areBlockDataKnown = false;
            end
            
            % Then load data from the file to the object
            obj = obj.loadData();
            
            % Update the aliases
            obj.n = length(obj.data);
            obj.nbOfGroups = obj.n/(obj.performRate*obj.sampleRate) - obj.nbOfBlocks + 1;
            obj.timeStampsOffset = obj.timeStamps_sign(1);
        end
        
        function delete(obj)
            %DELETE Destructor of the class
            %
            
            % Finaly close files
            if obj.fdata_sign > 0
                fclose(obj.fdata_sign);
            end
            if obj.fdata_block > 0
                fclose(obj.fdata_block);
            end
            
            fprintf('[Activity] is deleted.\n');
            
        end
        
        function obj = loadData(obj)
            %LoadData Load data from the file into the object
            %
            A = fscanf(obj.fdata_sign, '%f %f', [2, inf]);
            obj.timeStamps_sign = A(1, :)';
            obj.data = A(2, :)';
            
            if obj.areBlockDataKnown
                % The format of _block files changes from the acquisition
                % #37.
                if obj.acqID < 37
                    B = fscanf(obj.fdata_block, '%f %f %f', [3, inf]);
                    obj.timeStamps_block = B(1, :)';
                    obj.activity = B(2, :)';
                    obj.breath = B(3, :)';
                else
                    B = fscanf(obj.fdata_block, '%f %d %d %f', [4, inf]);
                    obj.timeStamps_block = B(1, :)';
                    obj.activity = B(2, :)';
                    obj.breath = B(4, :)';
                end
                
            end
        end
        
        function updateActivity(obj)
            %updateActivity Update the _block file with an offline activty
            %   scoring. A copy of the original _block file is made.
            %
            
            % Define the format in which data will be written
            format_block = '%.4f %.4f %.4f\n';
            
            if obj.areBlockDataKnown
                % Copy the original _block file
                copyfile(obj.dataFile_block, strcat(obj.dataFile_block, '.bak'));
                
                % Close the _block file
                if obj.fdata_block > 0
                    fclose(obj.fdata_block);
                end
            
                % Open the file and clear it
                obj.fdata_block = fopen(obj.dataFile_block, 'wt');
                
                if obj.fdata_block < 0
                    error('Activity:IOError', 'Cannot open %s.', obj.dataFileName_block);
                end
                
                % Get the new activity
                obj.activity = [0, 0, 0, obj.applyForEachGroup(@GetActivity2, 1)];
                
                % Write the file
                fprintf(obj.fdata_block, format_block, ...
                   [obj.timeStamps_block'; ...
                    obj.activity; ...
                    obj.breath']);
                
                % Close the file
                fclose(obj.fdata_block);
                
                % Re-open it
                obj.fdata_block = fopen(obj.dataFile_block, 'rt');
                
                if obj.fdata_block < 0
                    error('Activity:IOError', 'Cannot re-open %s.', obj.dataFileName_block);
                end
                
            end
        end
        
        function plot(obj,varargin)
            %Plot
            %
            %figure(5); clf;
            
            if obj.areBlockDataKnown
                subplot(3, 1, 1);
            end
                plot(obj.timeStamps_sign - obj.timeStampsOffset, obj.data ,varargin{:})
                ylim([mean(obj.data) - 1, mean(obj.data) + 1]);
                title('Raw signal');
                xlabel('time (s)');
            
            if obj.areBlockDataKnown
                subplot(3, 1, 2);
                plot(obj.timeStamps_block - obj.timeStampsOffset, obj.activity);
                xlim([obj.timeStamps_sign(1) - obj.timeStampsOffset, obj.timeStamps_sign(end) - obj.timeStampsOffset]);
                ylim([-1.5, 1.5]);
                title('Activity');
                xlabel('time (s)');
                ylabel('Sleep/Awake');
                
                subplot(3, 1, 3);
                plot(obj.timeStamps_block - obj.timeStampsOffset, obj.breath);
                xlim([obj.timeStamps_sign(1) - obj.timeStampsOffset, obj.timeStamps_sign(end) - obj.timeStampsOffset]);
                ylim([2.5, 3.5]);
                title('Breath');
                xlabel('time (s)');
                ylabel('Freq (Hz)');
            end
        end
        
        function plot_fft(obj, range)
            %Plot_fft Plot the fft of data(range)
            %
            
            % Compute the fft
            % (only positive freq are interesting)
            n = length(range);
            d = obj.data(range);
            D = fft(d - mean(d));
            D = abs(D(1:(floor(n/2)+1)));
            
            % Compute wave numbers
            freq = (0:floor(n/2)) * obj.sampleRate/n;
            
            % Plot the spectrogramm
            plot(freq, D);
            title(sprintf('Spectrogramm of %s', obj.dataFileName_sign));
            xlabel('Frequency (Hz)');
            ylabel('Amplitude (ua)');
        end
        
        % Set of functions to manipulate group of blocks
        function [block, t] = getBlock(obj, blockId)
            %getBlock Return a block given its id
            %
            if blockId * obj.sampleRate <= obj.n
                lower_index = (blockId-1)*obj.performRate*obj.sampleRate+1;
                upper_index = blockId*obj.performRate*obj.sampleRate;
                
                block = obj.data(lower_index:upper_index);
                t = obj.timeStamps_sign(lower_index:upper_index);
            else
                error('Activity:IDError', 'ID out of range, last block is #%d.', floor(length(obj.data)/(obj.performRate*obj.sampleRate)));
            end
        end
        
        function [group, t] = getGroup(obj, lastBlockID)
            %getGroup Return a group of blocks
            %   Return blocks blockID-3, blockID-2, blockID-1 and blockID.
            %
            % Prepare variables
            group = zeros(1, obj.nbOfBlocks*obj.performRate*obj.sampleRate);
            t = zeros(1, obj.nbOfBlocks*obj.performRate*obj.sampleRate);
            blockIDs = (lastBlockID:(lastBlockID + obj.nbOfBlocks - 1)) - 3;
            
            % Get blocks and plot limits
            for index = 1:obj.nbOfBlocks
                lower_index = (index-1)*obj.performRate*obj.sampleRate +1;
                upper_index = index*obj.performRate*obj.sampleRate;
                
                [b, t(lower_index:upper_index)] = obj.getBlock(blockIDs(index));
                group(lower_index:upper_index) = b;
            end
        end
        
        function bplot(obj, blockID, varargin)
            %bplot Plot a block
            %
            [block, t] = obj.getBlock(blockID);
            
            plot(t, block, varargin{:});
            title(sprintf('Block #%d', blockID));
            xlabel('time (s)');
        end
        
        function gplot(obj, blockID, varargin)
            %bplot Plot a group
            %   Plot blocks blockID-3, blockID-2, blockID-1 and blockID.
            %
            
            % Define some aliases
            blockIDs = (blockID:(blockID + obj.nbOfBlocks - 1)) - 3;
            
            % Get the group
            [group, t] = obj.getGroup(blockID);
            
            % Prepare the figure
            clf;
            hold on;

            % Plot limits
            for index = 1:obj.nbOfBlocks
                upper_index = index*obj.performRate*obj.sampleRate;
                plot([t(upper_index), t(upper_index)], [mean(group)-0.5, mean(group)+0.5], '-r');
            end
            
            % Plot the group
            plot(t, group, varargin{:});
            title(sprintf('Block #%s', mat2str(blockIDs)));
            xlabel('time (s)');
            
            hold off;
        end
        
        function [out, timeStamps] =  applyForEachGroup(obj, callBack, sleepCounterLim)
            %ApplyForEachGroup Apply a function on eack group.
            %   This function is typically used to test the efficiency of a
            %   getAvtivity function.
            %
            
            if nargin < 3
                sleepCounterLim = 0;
            end
            
            % Reset the sleep counter
            sleepCounter = 0;
            
            % Prepare output matrix
            %   _out_           output of the callback
            %   _timeStamps_    timeStamps to plot out in function of time
            out = zeros(1, obj.nbOfGroups);
            timeStamps = zeros(1, obj.nbOfGroups);
            
            % Clear persistent variables of possible callback
            clear SoundTrigger;
            
            % Apply callback on each group of the signal
            
            % Special treatment for the first item ...
            [group, t] = obj.getGroup(1 + obj.nbOfBlocks - 1);
            out(1) = callBack(group, obj.sampleRate, 0);
            timeStamps(1) = t((obj.nbOfBlocks-1)*obj.performRate*obj.sampleRate+1);
            
            % ... and then continue
            for groupId = 2:obj.nbOfGroups
                [group, t] = obj.getGroup(groupId + obj.nbOfBlocks - 1);
                % Get the new status
                state = callBack(group, obj.sampleRate, out(groupId - 1));
                
                % Do the reclassification
                if state == -1
                    newState = -1;
                    sleepCounter = 0;
                elseif sleepCounter < sleepCounterLim
                    sleepCounter = sleepCounter +1;
                    newState = -1;
                else
                    newState = state;
                end
                
                out(groupId) = newState;
                timeStamps(groupId) = t((obj.nbOfBlocks-1)*obj.performRate*obj.sampleRate+1);
            end
            
        end
        
        function plotForEachGroup(obj, callBack, sleepCounterLim)
            %plotForEachGroup For each group, plot callBack(block)
            %
            
            if nargin < 3
                sleepCounterLim = 0;
            end

            [out, t] = obj.applyForEachGroup(callBack, sleepCounterLim);
            
            % Define some aliases
            m = mean(obj.data);
            
            % Prepare the figure
            %clf;
            
            plot(obj.timeStamps_sign - obj.timeStampsOffset, obj.data);
            hold on;
                plot(t - obj.timeStampsOffset, m + 2*out.*sqrt(var(obj.data)), 'r');
                
                ylim([m - 2, m + 2]);
                xlim([0, max(obj.timeStamps_sign)]);
            hold off;
                
        end
        
        function [spec, midd] = spectrogramme(obj)
            %spectrogramme Plot the spectrogramme of the signal
            %
            
            % Define some aliases
            n_block = obj.performRate*obj.sampleRate;
            
            % Init the spectrogramme
            spec = zeros(obj.sampleRate/2, obj.nbOfGroups);
            % Init the middle array
            midd = zeros(1, obj.nbOfGroups);
            
            for blockID = obj.nbOfBlocks:obj.nbOfGroups
                b = obj.getBlock(blockID);
                b = b - mean(b);
                B = abs(fftshift(fft(b)));
                B = B((floor(n_block/2) + 1:end));
                
                spec(:, blockID) = B';
                
                %midd(blockID) = sum((0:49).*B') / sum(B);
                [~, midd(blockID)] = max(B);
            end
            
            figure(3); clf;
            hold on;
                imagesc(spec);
                plot(1:obj.nbOfGroups, midd, 'r+');
            hold off;
        end
        
        function [autocorr] = autocorrgramme(obj)
            %autocorrgramme Plot the autocorrgramme of the signal
            %
            
            % Define some aliases
            n_group = obj.performRate*obj.sampleRate*obj.nbOfBlocks;
            
            % Init the autocorrgramme
            autocorr = zeros(n_group, obj.nbOfGroups);
            
            for groupID = obj.nbOfBlocks:obj.nbOfGroups
                b = obj.getGroup(groupID);
                b = b - mean(b);
                B = xcorr(b);
                B = B(n_group:end);
                
                autocorr(:, groupID) = B'/max(B);
                
            end
            
            figure(3); clf;
            hold on;
                imagesc(autocorr);
            hold off;
        end
        
        function [sleepScoring, timeStamps] = computeSleepScoring(obj)
            % computeSleepScoring Compute the sleep scoring based on the
            %                     activity scoring.
            %
            
            % Reset the sleepScoring array
            obj.sleepScoring = zeros(1, length(obj.timeStamps_block));
            
            % Init a triggerState variable
            lastTriggeredState = obj.activity(1);
            lastTriggeredState_timeStamp = 1;
            
            % Set the window on which the activity is smoothed
            smoothingWindow = 20;
            
            % Build the sleep scoring
            for blockID = smoothingWindow:length(obj.activity)
                % Smooth the activity
                smoothedActivity = sum(obj.activity(blockID - smoothingWindow + 1:blockID));
                
                % The mouse has been moving long enough, trigger a
                % sleep to wake event.
                if smoothedActivity > 0 && lastTriggeredState <= 0
                    % Find the true beginning of the event.
                    evt_beginning = SWBeginningOfWakefulness(obj.activity(lastTriggeredState_timeStamp:blockID), obj.SWc);
                    evt_beginning = evt_beginning + lastTriggeredState_timeStamp - 1;
                    
                    % Update the sleep scoring
                    obj.sleepScoring(lastTriggeredState_timeStamp + 1:evt_beginning - 1) = obj.SWc.IS_SLEEPING;
                    obj.sleepScoring(evt_beginning:blockID) = obj.SWc.IS_AWAKE;
                    
                    % Save some variables for the next trigger
                    lastTriggeredState_timeStamp = blockID;
                    lastTriggeredState = obj.SWc.IS_AWAKE;
                    
                % The mouse has been sleeping long enough, trigger
                % a wake to sleep event.
                elseif smoothedActivity < 0 && lastTriggeredState >= 0
                    % Find the true beginning of the event.
                    evt_beginning = SWBeginningOfSleep(obj.activity(lastTriggeredState_timeStamp:blockID), obj.SWc);
                    evt_beginning = evt_beginning + lastTriggeredState_timeStamp - 1;
                    
                    % Update the sleep scoring
                    obj.sleepScoring(lastTriggeredState_timeStamp + 1:evt_beginning - 1) = obj.SWc.IS_AWAKE;
                    obj.sleepScoring(evt_beginning:blockID) = obj.SWc.IS_SLEEPING;
                    
                    % Save some variables for the next trigger
                    lastTriggeredState_timeStamp = blockID;
                    lastTriggeredState = obj.SWc.IS_SLEEPING;
                    
                end
                
            end
            
            obj.sleepScoring(lastTriggeredState_timeStamp + 1:end) = lastTriggeredState;
            
            % Return values
            sleepScoring = obj.sleepScoring;
            timeStamps = obj.timeStamps_block;
              
        end
        
    end
    
end

