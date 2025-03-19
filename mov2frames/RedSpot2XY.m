function [centroid,regionProps]=RedSpot2XY(image)

%[centroid,regionProps]=RedSpot2XY(image)


% Read the input image
%image = imread('path_to_your_image.jpg');

% Display the original image
% figure;
% imshow(image);
% title('Original Image');

% Convert the image to the HSV color space
hsvImage = rgb2hsv(image);

% Define thresholds for the red color in HSV space
% These thresholds might need adjustment based on your specific image
hueThresholdLow = 0.0;
hueThresholdHigh = 0.1;
saturationThresholdLow = 0.4;
valueThresholdLow = 0.2;

% Create a binary mask for the red color
redMask = (hsvImage(:,:,1) >= hueThresholdLow | hsvImage(:,:,1) <= hueThresholdHigh) & ...
          (hsvImage(:,:,2) >= saturationThresholdLow) & ...
          (hsvImage(:,:,3) >= valueThresholdLow);

% Display the red mask
% figure;
% imshow(redMask);
% title('Red Mask');

% Label connected components in the binary image
labeledImage = bwlabel(redMask);

% Measure properties of image regions
regionProps = regionprops(labeledImage, 'Centroid',"Area");

% Extract the coordinates of the centroid of the largest red spot
if ~isempty(regionProps)
    % Find the largest red spot by area
    allAreas = [regionProps.Area];
    [~, largestIdx] = max(allAreas);
    
    % Get the centroid of the largest red spot
    centroid = regionProps(largestIdx).Centroid;
    
    % Display the coordinates
%     fprintf('Coordinates of the red spot: (%.2f, %.2f)\n', centroid(1), centroid(2));
    
    % Plot the centroid on the original image
%     hold on;
%     plot(centroid(1), centroid(2), 'b*', 'MarkerSize', 10, 'LineWidth', 2);
%     hold off;
else
    disp('No red spot found in the image.');
    centroid(1)=nan;
    centroid(2)=nan;
end