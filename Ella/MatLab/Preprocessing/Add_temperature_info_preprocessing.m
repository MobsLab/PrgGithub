% Add temperature information in preprocessing (Ella)

load('ExpeInfo.mat', 'ExpeInfo');
ExpeInfo.Temperature = struct('Monitoring', 'NaN', 'ManipulationTool', 'NaN');
save('ExpeInfo.mat', 'ExpeInfo', '-append');