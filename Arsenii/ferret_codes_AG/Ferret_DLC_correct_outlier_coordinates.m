function Ferret_DLC_correct_outlier_coordinates(Session_params, datapath)
% Parameters
cd([datapath '/DLC']);
video_file = dir('*fixed.avi');
videoFilePath = [datapath '/DLC/' video_file.name];       % Path to your video file VIDEO MUST BE WITH LABELS ALREADY

% coordinates_file = dir('*filtered.csv');
% coordinatesFilePath = [datapath '/DLC/' coordinates_file.name]; % Path to your tracking data (.csv or .h5)
fps = Session_params.fps;                                      % Frame rate of the video (frames per second)

% Load Tracking Data
file=dir('*_filtered.csv'); % smoothed by DLC

filename=file.name; disp(['DLC data: ' filename]) %don't forget to specify the csv if you have many
trackingData = csvread(fullfile(pwd,filename),3); %loads the csv from line 3 to the end (to skip the Header)

% Load the Video
video = VideoReader(videoFilePath);

% Input the Approximate Time Range (in seconds)
startTime = input('Enter start time in seconds: ');
endTime = input('Enter end time in seconds: ');

% Convert Times to Frame Numbers
startFrame = round(startTime * fps);
endFrame = round(endTime * fps);

% Ensure Frame Numbers are within Video Range
numFrames = video.NumFrames;
if startFrame < 1
    startFrame = 1;
end
if endFrame > numFrames
    endFrame = numFrames;
end

% Loop through each Frame in the Specified Range
for frameNumber = startFrame:endFrame
    % Set the video to the current frame
    video.CurrentTime = (frameNumber - 1) / fps;
    
    % Read the current frame
    frame = readFrame(video);
    
    % Extract Current Coordinates for Each Body Part from Tracking Data
    % Assuming columns named like 'bodypart_x' and 'bodypart_y'

    pupil_x = trackingData(:, 2:3:23);
    pupil_y = trackingData(:, 3:3:24);

    % Display Frame with Overlaid Coordinates
    figure(1); clf;
    imshow(frame); hold on;
    plot(pupil_x(frameNumber, :), pupil_y(frameNumber, :), 'ro', 'MarkerSize', 3, 'LineWidth', 2); % Mark the keypoint
    title(['Frame: ', num2str(frameNumber)]);
    hold off;
    
    % Ask User for Verification
    prompt = 'Is the coordinate correct? (y/n): ';
    answer = input(prompt, 's');
    
    if strcmp(answer, 'n') || strcmp(answer, 'N')
        % Manually Adjust Coordinates
        disp('Click the correct location on the image');
        [newX, newY] = ginput(1);
        
        % Update Coordinates in Tracking Data
        trackingData{frameNumber, 'bodypart_x'} = newX;
        trackingData{frameNumber, 'bodypart_y'} = newY;
    end
    
    % Optionally, add an option to exit the loop early
    prompt = 'Do you want to continue to the next frame? (y/n): ';
    continueAnswer = input(prompt, 's');
    if strcmp(continueAnswer, 'n') || strcmp(continueAnswer, 'N')
        break;
    end
end

% Save the Corrected Data
writetable(trackingData, 'path/to/your/corrected_outputfile.csv');

end