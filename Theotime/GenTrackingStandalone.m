function GenTrackingStandalone(aviFile, behavResources_Offline, varargin)
    % GenTrackingStandalone redoes the tracking for a given .avi file with fixed parameters - no GUI needed!
    % It uses the parameters given in the input behavResources_Offline argument - either a pathname or a struct
    % It saves the results in a .mat file
    % Inputs:
    %   aviFile: the name of the .avi file to track, or a dir struct
    %       containing the .avi file to track
    %       if it is a struct, it should contain the field 'name' with the name of the .avi file
    %       and the field 'folder' with the path to the .avi file
    %       if it is a string, it should be the name of the .avi file
    %   behavResources_Offline: the name of the template .mat file containing the parameters, or the struct file itself
    %   varargin: arguments for the tracking function
    %       'duration': the duration of the video in seconds /!\ This one is REQUIRED.
    %       'saveBehav': if set to true, the function will save the results in a new behavResources.mat file
    % Outputs:
    %   None
    % Author: Almost Théotime


    % Load necessary resources and parameters
    % Load the offline data which will overwrite the previous one
    % Load the data - handle if it is a pathname or a struct object
    if ischar(behavResources_Offline)
        load(behavResources_Offline, 'ref', 'mask', 'Ratio_IMAonREAL', 'BW_threshold', 'smaller_object_size', 'sm_fact', 'strsz', 'SrdZone', 'shape_ratio');
    elseif isstruct(behavResources_Offline)
        ref = behavResources_Offline.ref;
        mask = behavResources_Offline.mask;
        Ratio_IMAonREAL = behavResources_Offline.Ratio_IMAonREAL;
        BW_threshold = behavResources_Offline.BW_threshold;
        smaller_object_size = behavResources_Offline.smaller_object_size;
        sm_fact = behavResources_Offline.sm_fact;
        strsz = behavResources_Offline.strsz;
        SrdZone = behavResources_Offline.SrdZone;
        shape_ratio = behavResources_Offline.shape_ratio;
    else    
        error('Invalid input for behavResources_Offline. It should be a filename or a struct.');
    end

    % Check if the aviFile is a struct or a string
    if isstruct(aviFile)
        % If it is a struct, get the name and folder fields
        aviFile = fullfile(aviFile.folder, aviFile.name);
    elseif ischar(aviFile)
        % If it is a string, check if it is a valid file
        if ~exist(aviFile, 'file')
            error('The specified avi file does not exist.');
        end
    else
        error('Invalid input for aviFile. It should be a filename or a struct.');
    end
    
    % Check if the aviFile is a valid .avi file
    [~, ~, ext] = fileparts(aviFile);
    if ~strcmp(ext, '.avi')
        error('The specified file is not a .avi file.');
    end

    % Check the varargin arguments
    % Check if the saveBehav argument is set to true
    p = inputParser;
    addParameter(p, 'saveBehav', false, @(x) islogical(x));
    addParameter(p, 'duration', [], @(x) isnumeric(x) && ~isempty(x));
    parse(p, varargin{:});
    if isempty(p.Results.duration)
        error('The ''duration'' parameter is required and must be specified.');
    end
    saveBehav = p.Results.saveBehav;
    duration = p.Results.duration;

    % Initialize video reader
    OBJ = VideoReader(aviFile);
    try
        totframe = get(OBJ, 'numberOfFrames');
    catch
        totframe = OBJ.NumFrames;
    end
    fcy = duration/totframe;
    
    fr = 1;
    % Read the first frame to initialize
    % the video reader and get the frame rate
    % and the duration
    vidFrames = read(OBJ,fr);
    IM=(double(vidFrames(:,:,3,1)))/256;
    chrono=fr*fcy;


    % Initialize matrices for tracking data
    PosMat = [];
    im_diff = [];
    OldIm = mask;
    OldZone = mask;
    
    n=1;
    waittracking=waitbar(0,'Offline Tracking');

    for fr = 1:totframe
        % Read the current frame
        vidFrames = read(OBJ, fr);
        IM = (double(vidFrames(:, :, 3, 1))) / 256;
        chrono = fr * fcy;

        waitbar(fr/totframe,waittracking);

        % Call the tracking function
        se = strel('disk', strsz);
        % Call the tracking function
        [Pos, ImDiff, PixelsUsed, NewIm, FzZone] = Track_ImDiff(double(IM), double(mask), double(ref), BW_threshold, smaller_object_size, sm_fact, se, SrdZone, ...
            Ratio_IMAonREAL, OldIm, OldZone, 'IRCamera');

        diffshow=double(NewIm);
        diffshow(FzZone==1)=0.4;
        diffshow(OldZone==1)=0.4;
        diffshow(NewIm==1)=0.8;

        % Store tracking results
        if sum(isnan(Pos)) == 0
            PosMat(fr, 1) = chrono;
            PosMat(fr, 2) = Pos(1);
            PosMat(fr, 3) = Pos(2);
            PosMat(fr,4)=0;
            im_diff(fr, 1) = chrono;
            im_diff(fr, 2) = ImDiff;
            im_diff(fr, 3) = PixelsUsed;
        else
            PosMat(fr,:)=[chrono;NaN;NaN;NaN];
            im_diff(fr,1:3)=[chrono;NaN;NaN];
        end
        OldIm = NewIm;
        OldZone = FzZone;
    end
    close(waittracking)

    [PosMat,PosMatInit,im_diff,im_diffInit,Vtsd,Xtsd,Ytsd,Imdifftsd]=CommonInterpPosMatImDiff(im_diff,chrono,PosMat);

    
    % Save results to a .mat file
    % save in the same directory as the avi file
    [pathstr, name, ext] = fileparts(aviFile); 
    savePath = fullfile(pathstr, 'behavResources_Offline.mat');

    cd(pathstr);
    % Save the results  
    save(savePath,'PosMat','PosMatInit','im_diff','im_diffInit','Vtsd','Xtsd','Ytsd','Imdifftsd',...
        'ref','mask','Ratio_IMAonREAL','BW_threshold','smaller_object_size','sm_fact','strsz','SrdZone','shape_ratio');

    % Save the results in a new file if saveBehav is true
    if saveBehav
        % Save the results in a new file
        saveName = fullfile(pathstr, 'behavResources.mat');
        % Load the data
        behavResources = load(saveName);

        % make a copy of behavResources.mat under old_behavResources.mat
        date = datestr(now, 'dd-mm-yyyy');
        save(['old_behavResources_' date '.mat'], 'behavResources')

        % Get rid of any field containing 'Clean' in its name
        % This is to avoid overwriting the previous data
        % Get the field names
        fieldNames = fieldnames(behavResources);
        % Loop through the field names
        for j = 1:length(fieldNames)
            % Check if the field name contains 'Clean'
            if contains(fieldNames{j}, 'Clean') || contains(fieldNames{j}, 'Aligned')
                % If it does, remove it from the struct
                behavResources = rmfield(behavResources, fieldNames{j});
            end
        end
        % Sace the new data
        save(saveName, '-struct', 'behavResources');

        % Save the new data 
        save(saveName, 'PosMat', 'im_diff', 'Vtsd', 'Xtsd', 'Ytsd', 'Imdifftsd', 'ref', 'mask', 'Ratio_IMAonREAL', ...
            'BW_threshold', 'strsz', 'smaller_object_size', 'shape_ratio', ...
            'sm_fact', 'SrdZone', '-append')
    end
end