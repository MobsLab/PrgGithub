clear all
Dir = PathForExperimentsMtzlProject('BaselineSleep');
for mouse = 16%length(Dir.path)
    for day = 1:length(Dir.path{mouse})
        close all
        cd(Dir.path{mouse}{day})
        disp(Dir.path{mouse}{day})
        
        VideoFiles = dir('*.avi');
        
        if exist('behavResources.mat')>0 & length(VideoFiles)>0
            
            try
                RecalcTemperatureFromVideo_SB('CalibrationOct2017IRCamera');
                disp('success!')
            catch
                disp('tried and failed')
            end
        else
            disp('not the right files')
        end
    end
end
