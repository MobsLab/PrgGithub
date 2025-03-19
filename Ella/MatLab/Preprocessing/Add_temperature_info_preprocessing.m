% Add temperature information in preprocessing (Ella)

load('ExpeInfo.mat', 'ExpeInfo');
ExpeInfo.Temperature

ExpeInfo.Temperature = struct('Monitoring', 'NaN', 'ManipulationTool', 'NaN');

ExpeInfo.Temperature = struct('Monitoring', 'WebCam', 'ManipulationTool', 'HeatingPad');
ExpeInfo.Temperature = struct('Monitoring', 'WebCam', 'ManipulationTool', 'NaN');

ExpeInfo.Temperature = struct('Monitoring', 'TempSensor', 'ManipulationTool', 'HeatingLamp');
ExpeInfo.Temperature = struct('Monitoring', 'TempSensor', 'ManipulationTool', 'NaN');


save('ExpeInfo.mat', 'ExpeInfo', '-append');
