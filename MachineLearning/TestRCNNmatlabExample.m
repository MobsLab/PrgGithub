%TestRCNNmatlabExample
%
% SEE on mathworks.fr : Object Detection Using Faster R-CNN Deep Learning
%

clear

% Load vehicle data set
data = load('fasterRCNNVehicleTrainingData.mat');
vehicleDataset = data.vehicleTrainingData;

% Add fullpath to the local vehicle data folder.
dataDir = fullfile(toolboxdir('vision'),'visiondata');
vehicleDataset.imageFilename = fullfile(dataDir, vehicleDataset.imageFilename);

% Read one of the images.
I = imread(vehicleDataset.imageFilename{10});

% Insert the ROI labels.
I = insertShape(I, 'Rectangle', vehicleDataset.vehicle{10});

% Resize and display image.
I = imresize(I, 3);
figure
imshow(I)


% Split data into a training and test set.
idx = floor(0.6 * height(vehicleDataset));
trainingData = vehicleDataset(1:idx,:);
testData = vehicleDataset(idx:end,:);

%% Layer

% Create image input layer.
inputLayer = imageInputLayer([32 32 3]);

% Define the convolutional layer parameters.
filterSize = [3 3];
numFilters = 32;

% Create the middle layers.
middleLayers = [convolution2dLayer(filterSize, numFilters, 'Padding', 1), reluLayer(), ...
    convolution2dLayer(filterSize, numFilters, 'Padding', 1), reluLayer(), maxPooling2dLayer(3, 'Stride',2)];

% Create the final layer:
% - Add a fully connected layer with 64 output neurons. The output size
%   of this layer will be an array with a length of 64.
% - Add a ReLU non-linearity.
% - Add the last fully connected layer. At this point, the network must
%   produce outputs that can be used to measure whether the input image
%   belongs to one of the object classes or background. This measurement
%   is made using the subsequent loss layers.
% - Add the softmax loss layer and classification layer.
finalLayers = [fullyConnectedLayer(64), reluLayer(), fullyConnectedLayer(width(vehicleDataset)), softmaxLayer(), classificationLayer()];

layers = [inputLayer, middleLayers, finalLayers]';
  

%% Configure training options

% Options for step 1.
optionsStage1 = trainingOptions('sgdm', ...
    'MaxEpochs', 10, ...
    'InitialLearnRate', 1e-5, ...
    'CheckpointPath', tempdir);

% Options for step 2.
optionsStage2 = trainingOptions('sgdm', ...
    'MaxEpochs', 10, ...
    'InitialLearnRate', 1e-5, ...
    'CheckpointPath', tempdir);

% Options for step 3.
optionsStage3 = trainingOptions('sgdm', ...
    'MaxEpochs', 10, ...
    'InitialLearnRate', 1e-6, ...
    'CheckpointPath', tempdir);

% Options for step 4.
optionsStage4 = trainingOptions('sgdm', ...
    'MaxEpochs', 10, ...
    'InitialLearnRate', 1e-6, ...
    'CheckpointPath', tempdir);

options = [optionsStage1, optionsStage2, optionsStage3, optionsStage4];


%% Train Faster R-CNN

% A trained network is loaded from disk to save time when running the
% example. Set this flag to true to train the network.
doTrainingAndEval = true;

if doTrainingAndEval
    % Set random seed to ensure example training reproducibility.
    rng(0);

    % Train Faster R-CNN detector. Select a BoxPyramidScale of 1.2 to allow
    % for finer resolution for multiscale object detection.
    detector = trainFasterRCNNObjectDetector(trainingData, layers, options, ...
        'NegativeOverlapRange', [0 0.3], ...
        'PositiveOverlapRange', [0.6 1], ...
        'BoxPyramidScale', 1.2);
else
    % Load pretrained detector for the example.
    detector = data.detector;
end


%% TEST 
% Read a test image.
I = imread('highway.png');

% Run the detector.
[bboxes, scores] = detect(detector, I);

% Annotate detections in the image.
I = insertObjectAnnotation(I, 'rectangle', bboxes, scores);
figure
imshow(I)

    
    