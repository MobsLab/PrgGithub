function RetrackAndLinearizeAllSessions(dirin, sessions, redo)
% This lovely function will try to do the video tracking again.
% It will also linearize the data and save it in the behavResources.mat files
% in the current directory and subdirectories.

% It's as much automatic as possible, and will only ask you to redo the tracking for the ones you're not happy with.
try
    sessions;
catch
    sessions = {'Hab', 'PreTests', 'Cond', 'PostTests', 'Ext'}
end
try
    redo;
catch
    redo = 0;
end

old_dir = pwd;
cd(dirin);
for i = 1:length(sessions)
    skip_tracking = false;
    cd(sessions{i});
    disp('Loading session:');
    disp(sessions{i});
    % Load the data
    % regex this: find all the *avi files in the current directory and subdirectories

    whereToSearch = pwd;
    regexSearch = [whereToSearch, '/**/*.avi'];
    amplifierregex = [whereToSearch, '/**/amplifier.dat'];
    xmlregex = [whereToSearch, '/**/amplifier.xml'];

    % Sort the files by name
    aviFiles = dir(regexSearch);
    amplifierFiles = dir(amplifierregex);
    xmlFiles = dir(xmlregex);

    [~, ind] = sort({amplifierFiles.folder});
    amplifierSorted = amplifierFiles(ind);
    [~, ind] = sort({aviFiles.folder});
    aviFiles = aviFiles(ind);
    [~, ind] = sort({xmlFiles.folder});
    xmlFiles = xmlFiles(ind);

    %% First, track and linearize the first, "template" session
    try
        % Get the amplifier and xml files
        folder = amplifierSorted(1).folder;
        amplifier_name = amplifierSorted(1).name;
        amplifier_file = fullfile(folder, amplifier_name);
        xml_file = fullfile(xmlFiles(1).folder, xmlFiles(1).name);
        warning('off')
        xml = LoadXml(xml_file);
        warning('on')
        sampling_rate = xml.SampleRate;
        nChannels = xml.nChannels;
        % Finally, get the duration of the amplifier file in seconds.
        % as it's Int16, one element is 2 bytes - hence there are 2*nChannels bytes per sample point
        amplifier = dir(amplifier_file);
        size_bytes = amplifier.bytes;
        % the duration is the closest lower integer dividable by 10 (all Exp are ).
        durationTemplate = floor((size_bytes / (nChannels * 2 * sampling_rate))/10)*10;
        fprintf('Duration of the amplifier file for the %s session:\n', sessions{i});
        disp(durationTemplate/60);
    
        nb_sessions = length(aviFiles);
        nb_amplifier = length(amplifierSorted);
        if nb_sessions ~= nb_amplifier
            disp('Number of avi files and amplifier files do not match');
            disp('Exiting...');
            return
        end
    catch e
        if contains(lower(sessions{i}), 'sleep')
            disp('Processing sleep session - no amplifier found so will skip the tracking.')
            skip_tracking = true;
        else
            fprintf(1,'There was an error! The message was:\n%s',e.message);
        end
    end

    done = false;
    % Take the first folder (by name) as the template one
    folder = aviFiles(1).folder;
    aviFile = aviFiles(1).name;
    aviFile = fullfile(folder, aviFile);
    sess_number = 1;
    
    % Cd to the folder containing the avi file
    cd(folder);

    % Start a lovely new tracking session  with the GUI
    % OfflineTrackingFinal_CompNewTracking for now has another name.
    if done == false
        % Call the GUI
        % This will create a new behavResources_Offline.mat file
        % and save it in the current directory
        % The function will ask for the avi file to track
        % and the parameters to use
        % It will also ask for the output directory
        % and the name of the output file
        % The function will then call GenTrackingStandalone to do the tracking
        % and save the results in a .mat file

        % If the behavResources.mat file was created today, skip bonjour GUI
        % and load the data from the behavResources.mat file
        % Check if the behavResources.mat file was created today
        % Get the date of the last modification behavResources.mat file

        if isFileModifiedToday('behavResources.mat') && ~redo
            % If it is, skip the GUI
            disp('behavResources.mat was created today, skipping GUI');
            done = true;
        elseif ~skip_tracking
            % If it is not, call the GUI
            % This will create a new behavResources_Offline.mat file
            FastOfflineTrackingFinal_CompNewTracking('aviFile', aviFile, 'duration', durationTemplate)
            % Wait for the GUI to be closed
            a = input('Type `ready` to continue...', 's');
            if ~strcmp(a, 'ready')
                disp('You did not type `ready`');
                disp('Exiting...');
                keyboard
            end

            done = true;
        end
    end

    % Load the freshly created data
    clearvars -except dirin sessions aviFiles amplifierSorted xmlFiles i old_dir sess_number done redo durationTemplate

    % Load the data
    behavResources = load('behavResources.mat');

    % make a copy of behavResources.mat under old_behavResources.mat
    date = datestr(now, 'dd-mm-yyyy');
    save(['old_behavResources_' date '.mat'], 'behavResources')

    % Get rid of any field containing 'Clean' in its name
    % This is to avoid overwriting the previous data
    % Get the field names
    fieldNames = fieldnames(behavResources);
    % Loop through the field names
    for j = 1:length(fieldNames)
        % Check if the field name contains 'Clean' or 'Aligned'
        if contains(fieldNames{j}, 'Clean') || contains(fieldNames{j}, 'Aligned')
            % If it does, remove it from the struct
            behavResources = rmfield(behavResources, fieldNames{j});
        end
    end
    % Save the new data
    save('behavResources.mat', '-struct', 'behavResources');

    % Load the offline data which will overwrite the previous one
    data = load('behavResources_Offline.mat');
    % Load the proper variables contained in the data struct
    PosMat = data.PosMat;
    im_diff = data.im_diff;
    Vtsd = data.Vtsd;
    Xtsd = data.Xtsd;
    Ytsd = data.Ytsd;
    Imdifftsd = data.Imdifftsd;
    ref = data.ref;
    mask = data.mask;
    Ratio_IMAonREAL = data.Ratio_IMAonREAL;
    BW_threshold = data.BW_threshold;
    strsz = data.strsz;
    smaller_object_size = data.smaller_object_size;
    shape_ratio = data.shape_ratio;
    sm_fact = data.sm_fact;
    SrdZone = data.SrdZone;
    try
        Ratio_IMAonREAL = data.Ratio_IMAonREAL;
    catch
        Ratio_IMAonREAL = 1./data.pixratio;
    end
    Xtsd = data.Xtsd;
    Ytsd = data.Ytsd;
    load('behavResources.mat', 'Zone');
    data.Zone = Zone;
    % Save the Zone var in behav_resources Offline
    save('behavResources_Offline.mat', 'Zone', '-append');
    ref = data.ref;

    if isFileModifiedToday('behavResources.mat') && ~redo
        disp('');
    else
        if contains(lower(sessions{i}), 'sleep')
            ZoneEpochAligned = [];
            XYOutput = [];
            curvexy = [];
            LinearDist = [];
            curvexy = [];
            [AlignedXtsd, AlignedYtsd] = HCTracking(Xtsd, Ytsd, Ratio_IMAonREAL, 'plot', true);
        else
            % Do the same with MorphLinearize and AlignMaze
            [AlignedXtsd,AlignedYtsd,ZoneEpochAligned,XYOutput] = MorphMazeToSingleShape_EmbReact_DB...
                (Xtsd,Ytsd, Zone{1}, ref, Ratio_IMAonREAL);
            [LinearDist, curvexy] = LinearizeMaze(data, 1);
        end
        % Save the new data
        save('behavResources.mat', 'PosMat', 'im_diff', 'Vtsd', 'Xtsd', 'Ytsd', 'Imdifftsd', 'ref', 'mask', 'Ratio_IMAonREAL', ...
            'BW_threshold', 'strsz', 'smaller_object_size', 'shape_ratio', ...
            'sm_fact', 'SrdZone', 'AlignedXtsd', 'AlignedYtsd', 'ZoneEpochAligned', 'XYOutput', 'LinearDist', '-append')
    end

    clearvars -except dirin sessions aviFiles amplifierSorted xmlFiles i old_dir sess_number done XYOutput Ratio_IMAonREAL curvexy redo durationTemplate


    %% Now, we need to track the other sessions with the template session's settings
    % Make a Call to GenTrackingStandalone for other recordings of the same session
    % Get the behavResources_Offline.mat path
    offline_BehavPath = GetFullPath('behavResources_Offline.mat');

    % Get the avi file path
    for w = sess_number+1:length(aviFiles)
        skipProcessing = false;
        happy = 0;
        gui = 0;

        % Check if the file should be skipped early
        cd(aviFiles(w).folder);
        behavResources = fullfile(aviFiles(w).folder, 'behavResources.mat');
        if isFileModifiedToday(behavResources) && ~redo && ~gui
            disp('behavResources.mat was created today (even for subfolders), skipping GUI');
            skipProcessing = true;
        end

        % Skip the current file if necessary
        if skipProcessing
            continue;
        end

        % Process the file (no need to check skipProcessing again)
        try
            amplifier = amplifierSorted(w);
            amplifier_file = fullfile(amplifier.folder, amplifier.name);
            xml_file = fullfile(xmlFiles(w).folder, xmlFiles(w).name);
            warning('off');
            xml = LoadXml(xml_file);
            warning('on');
            sampling_rate = xml.SampleRate;
            nChannels = xml.nChannels;

            % Calculate duration
            amplifier = dir(amplifier_file);
            size_bytes = amplifier.bytes;
            durationNew = floor((size_bytes / (nChannels * 2 * sampling_rate))/10)*10;
            % Check duration difference
            if abs(durationNew - durationTemplate) > 0.1* durationTemplate
                if amplifier.folder ~= xmlFiles(w).folder
                    warning('xml and dat files dont come from the same folder!')
                end
                disp(['Duration of the amplifier file (' amplifier.folder ', xml ' xmlFiles(w).folder '):']);
                disp(durationNew/60);
                disp('Duration of the template session:');
                disp(durationTemplate/60);
                duration = inputdlg('Duration of the amplifier file (in seconds)', '/!\Duration differs from template!', 1, {num2str(durationNew)});
                duration = eval(duration{1});
            else
                duration = durationNew;
            end
        catch
            if contains(lower(sessions{i}), 'sleep')
                disp('Processing sleep session - no amplifier found so will skip the tracking.')
                duration = [];
            else
                fprintf(1,'There was an error! The message was:\n%s',e.message);
            end
        end

        while ~happy
            % Call tracking functions
            if ~gui
                GenTrackingStandalone(aviFiles(w), offline_BehavPath, 'saveBehav', true, 'duration', duration);
            else
                FastOfflineTrackingFinal_CompNewTracking('aviFile', aviFiles(w), 'duration', duration);

                a = input('Type `ready` to continue...', 's');
                if ~strcmp(a, 'ready')
                    disp('You did not type `ready`');
                    disp('Exiting...');
                    keyboard
                end
            end

            % Morph and linearize data
            data = load('behavResources_Offline.mat');

            if gui
                XYOutput = [];
                curvexy = [];
            end
            PosMat = data.PosMat;
            im_diff = data.im_diff;
            Vtsd = data.Vtsd;
            Xtsd = data.Xtsd;
            Ytsd = data.Ytsd;
            Imdifftsd = data.Imdifftsd;
            ref = data.ref;
            mask = data.mask;
            Ratio_IMAonREAL = data.Ratio_IMAonREAL;
            BW_threshold = data.BW_threshold;
            strsz = data.strsz;
            smaller_object_size = data.smaller_object_size;
            shape_ratio = data.shape_ratio;
            sm_fact = data.sm_fact;
            SrdZone = data.SrdZone;
            try
                Ratio_IMAonREAL = data.Ratio_IMAonREAL;
            catch
                Ratio_IMAonREAL = 1./data.pixratio;
            end
            Xtsd = data.Xtsd;
            Ytsd = data.Ytsd;
            load('behavResources.mat', 'Zone');
            data.Zone = Zone;
            save('behavResources_Offline.mat', 'Zone', '-append');
            ref = data.ref;

            if contains(lower(sessions{i}), 'sleep')
                ZoneEpochAligned = [];
                XYOutput = [];
                curvexy = [];
                LinearDist = [];
                curvexy = [];
                [AlignedXtsd, AlignedYtsd] = AlignHCBehaviour(Xtsd, Ytsd, Ratio_IMAonREAL, 'plot', true);
            else
                [AlignedXtsd, AlignedYtsd, ZoneEpochAligned, XYOutput] = MorphMazeToSingleShape_EmbReact_DB(Xtsd, Ytsd, Zone{1}, ref, Ratio_IMAonREAL, XYOutput);
                [LinearDist, curvexy] = LinearizeMaze(data, 1, 'curvexy', curvexy);
            end
            % Save the new data
            happy = inputdlg('Happy with the tracking and linearization? (0/1)', 'redo with GUI');
            try
                happy = eval(happy{1});
            catch
                keyboard
            end

            if ~happy
                disp('Redoing the tracking and linearization with GUI');
                gui = 1;
            end
        end

        save('behavResources.mat', 'PosMat', 'im_diff', 'Vtsd', 'Xtsd', 'Ytsd', 'Imdifftsd', 'ref', 'mask', 'Ratio_IMAonREAL', ...
            'BW_threshold', 'strsz', 'smaller_object_size', 'shape_ratio', ...
            'sm_fact', 'SrdZone', 'AlignedXtsd', 'AlignedYtsd', 'ZoneEpochAligned', 'XYOutput', 'LinearDist', '-append')

        clearvars -except dirin sessions aviFiles offline_BehavPath amplifierSorted xmlFiles i old_dir sess_number done XYOutput Ratio_IMAonREAL curvexy redo durationTemplate
    end
    cd(dirin);
end
cd(old_dir)
end

function isToday = isFileModifiedToday(filePath)
if exist(filePath, 'file')
    fileInfo = dir(filePath);
    [Y, M, D] = datevec(fileInfo.datenum);
    today = datetime('now');
    isToday = (Y == year(today)) && (M == month(today)) && (D == day(today));
else
    isToday = false;
end
end

function [AlignedXtsd, AlignedYtsd] = HCTracking(Xtsd, Ytsd, Ratio_IMAonREAL, varargin)

p = inputParser;
addParameter(p, 'plot', false, @(x) islogical(x));
parse(p, varargin{:});
plotting = p.Results.plot;
satisfied = 0;

while satisfied ==0
    % Behaviour
    polygon = GetCageEdgesWithVideo(Data(Ytsd).*Ratio_IMAonREAL,Data(Xtsd).*Ratio_IMAonREAL);
    x = polygon.Position(:,2);
    y = polygon.Position(:,1);
    if abs(x(1)-x(2))>abs(x(3)-x(2))
        Coord1 = [x(1)-x(2),y(1)-y(2)];
        Coord2 = [x(3)-x(2),y(3)-y(2)];
    else
        Coord2 = [x(1)-x(2),y(1)-y(2)];
        Coord1 = [x(3)-x(2),y(3)-y(2)];
    end
    TranssMat = [Coord1',Coord2'];
    XInit = Data(Xtsd).*Ratio_IMAonREAL-x(2);
    YInit = Data(Ytsd).*Ratio_IMAonREAL-y(2);

    % The Xtsd and Ytsd in new coordinates
    A = ((pinv(TranssMat)*[XInit,YInit]')');
    AlignedXtsd = tsd(Range(Xtsd),40*A(:,1));
    AlignedYtsd = tsd(Range(Ytsd),20*A(:,2));
    clf
    if plotting
        plot(Data(AlignedXtsd),Data(AlignedYtsd))
        xlim([0 40])
        ylim([0 20])
    end

    satisfied = input('happy?')

end
end
