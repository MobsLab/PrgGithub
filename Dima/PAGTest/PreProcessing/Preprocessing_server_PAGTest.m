%Preprocessing_server_DB
% 11.04.2018 DB

function Preprocessing_PAGTest(dirin)

try
   dirin;
catch
   dirin={
       '/media/mobsrick/DataMOBS87/Mouse-783/09092018/BaselineSleep/';
       '/media/mobsrick/DataMOBS87/Mouse-783/09092018/ContextANeutral/';
       '/media/mobsrick/DataMOBS87/Mouse-783/09092018/CalibrationB/Calib-0.5V/';
       '/media/mobsrick/DataMOBS87/Mouse-783/09092018/CalibrationB/Calib-0V/';
       '/media/mobsrick/DataMOBS87/Mouse-783/09092018/CalibrationB/Calib-1.5V/';
       '/media/mobsrick/DataMOBS87/Mouse-783/09092018/CalibrationB/Calib-1V/';
       '/media/mobsrick/DataMOBS87/Mouse-783/09092018/CalibrationB/Calib-2.5V/';
       '/media/mobsrick/DataMOBS87/Mouse-783/09092018/CalibrationB/Calib-2V/';
       '/media/mobsrick/DataMOBS87/Mouse-783/09092018/CalibrationB/Calib-3V/';
       '/media/mobsrick/DataMOBS87/Mouse-783/09092018/CalibrationB/Calib-4V/';
       '/media/mobsrick/DataMOBS87/Mouse-783/09092018/CalibrationB/Calib-5V/';
       '/media/mobsrick/DataMOBS87/Mouse-783/09092018/CalibrationB/Calib-6V/';
       '/media/mobsrick/DataMOBS87/Mouse-783/09092018/CalibrationC/Calib-0.5V/';
       '/media/mobsrick/DataMOBS87/Mouse-783/09092018/CalibrationC/Calib-0V/';
       '/media/mobsrick/DataMOBS87/Mouse-783/09092018/CalibrationC/Calib-1.5V/';
       '/media/mobsrick/DataMOBS87/Mouse-783/09092018/CalibrationC/Calib-1V/';
       '/media/mobsrick/DataMOBS87/Mouse-783/09092018/CalibrationC/Calib-2.5V/';
       '/media/mobsrick/DataMOBS87/Mouse-783/09092018/CalibrationC/Calib-2V/';
       '/media/mobsrick/DataMOBS87/Mouse-783/09092018/CalibrationC/Calib-3V/';
       '/media/mobsrick/DataMOBS87/Mouse-783/09092018/CalibrationC/Calib-4V/';
       '/media/mobsrick/DataMOBS87/Mouse-783/09092018/CalibrationC/Calib-5V/';
       '/media/mobsrick/DataMOBS87/Mouse-783/09092018/CalibrationC/Calib-6V/';
       '/media/mobsrick/DataMOBS87/Mouse-783/11092018/ContextATest/';
       '/media/mobsrick/DataMOBS87/Mouse-783/11092018/ContextBTest/';
       '/media/mobsrick/DataMOBS87/Mouse-783/11092018/ContextCTest/';
       '/media/mobsrick/DataMOBS87/Mouse-783/11092018/Hab/';
       '/media/mobsrick/DataMOBS87/Mouse-783/11092018/TestPre/';
       '/media/mobsrick/DataMOBS87/Mouse-783/11092018/Cond/';
       '/media/mobsrick/DataMOBS87/Mouse-783/11092018/TestPost/TestPost0/';
       '/media/mobsrick/DataMOBS87/Mouse-783/11092018/TestPost/';
       '/media/mobsrick/DataMOBS87/Mouse-785/09092018/BaselineSleep/';
       '/media/mobsrick/DataMOBS87/Mouse-785/09092018/ContextANeutral/';
       '/media/mobsrick/DataMOBS87/Mouse-785/09092018/CalibrationB/Calib-0.5V/';
       '/media/mobsrick/DataMOBS87/Mouse-785/09092018/CalibrationB/Calib-0V/';
       '/media/mobsrick/DataMOBS87/Mouse-785/09092018/CalibrationB/Calib-1.5V/';
       '/media/mobsrick/DataMOBS87/Mouse-785/09092018/CalibrationB/Calib-1V/';
       '/media/mobsrick/DataMOBS87/Mouse-785/09092018/CalibrationB/Calib-2.5V/';
       '/media/mobsrick/DataMOBS87/Mouse-785/09092018/CalibrationB/Calib-2V/';
       '/media/mobsrick/DataMOBS87/Mouse-785/09092018/CalibrationB/Calib-3V/';
       '/media/mobsrick/DataMOBS87/Mouse-785/09092018/CalibrationC/Calib-0.5V/';
       '/media/mobsrick/DataMOBS87/Mouse-785/09092018/CalibrationC/Calib-0V/';
       '/media/mobsrick/DataMOBS87/Mouse-785/09092018/CalibrationC/Calib-1.5V/';
       '/media/mobsrick/DataMOBS87/Mouse-785/09092018/CalibrationC/Calib-1V/';
       '/media/mobsrick/DataMOBS87/Mouse-785/09092018/CalibrationC/Calib-2.5V/';
       '/media/mobsrick/DataMOBS87/Mouse-785/09092018/CalibrationC/Calib-2V/';
       '/media/mobsrick/DataMOBS87/Mouse-785/09092018/CalibrationC/Calib-3.5V/';
       '/media/mobsrick/DataMOBS87/Mouse-785/09092018/CalibrationC/Calib-3V/';
       '/media/mobsrick/DataMOBS87/Mouse-785/09092018/CalibrationC/Calib-4.5V/';
       '/media/mobsrick/DataMOBS87/Mouse-785/09092018/CalibrationC/Calib-4V/';
       '/media/mobsrick/DataMOBS87/Mouse-785/09092018/CalibrationC/Calib-5V/';
       '/media/mobsrick/DataMOBS87/Mouse-785/09092018/CalibrationC/Calib-6V/';
       '/media/mobsrick/DataMOBS87/Mouse-785/11092018/ContextATest/';
       '/media/mobsrick/DataMOBS87/Mouse-785/11092018/ContextBTest/';
       '/media/mobsrick/DataMOBS87/Mouse-785/11092018/ContextCTest/';
       '/media/mobsrick/DataMOBS87/Mouse-785/11092018/Hab/';
       '/media/mobsrick/DataMOBS87/Mouse-785/11092018/TestPre/';
       '/media/mobsrick/DataMOBS87/Mouse-785/11092018/Cond/';
       '/media/mobsrick/DataMOBS87/Mouse-785/11092018/TestPost/TestPost0/';
       '/media/mobsrick/DataMOBS87/Mouse-785/11092018/TestPost/';
       '/media/mobsrick/DataMOBS87/Mouse-785/12092018/Hab/';
       '/media/mobsrick/DataMOBS87/Mouse-785/12092018/TestPre/';
       '/media/mobsrick/DataMOBS87/Mouse-785/12092018/Cond/';
       '/media/mobsrick/DataMOBS87/Mouse-785/12092018/TestPost/TestPost0/';
       '/media/mobsrick/DataMOBS87/Mouse-785/12092018/TestPost/';
       '/media/mobsrick/DataMOBS87/Mouse-785/13092018/TestPost/';
       '/media/mobsrick/DataMOBS87/Mouse-786/09092018/BaselineSleep/';
       '/media/mobsrick/DataMOBS87/Mouse-786/09092018/ContextANeutral/';
       '/media/mobsrick/DataMOBS87/Mouse-786/09092018/CalibrationB/Calib-0.5V/';
       '/media/mobsrick/DataMOBS87/Mouse-786/09092018/CalibrationB/Calib-0V/';
       '/media/mobsrick/DataMOBS87/Mouse-786/09092018/CalibrationB/Calib-1.5V/';
       '/media/mobsrick/DataMOBS87/Mouse-786/09092018/CalibrationB/Calib-1V/';
       '/media/mobsrick/DataMOBS87/Mouse-786/09092018/CalibrationB/Calib-2.5V/';
       '/media/mobsrick/DataMOBS87/Mouse-786/09092018/CalibrationB/Calib-2V/';
       '/media/mobsrick/DataMOBS87/Mouse-786/09092018/CalibrationB/Calib-3.5V/';
       '/media/mobsrick/DataMOBS87/Mouse-786/09092018/CalibrationB/Calib-3V/';
       '/media/mobsrick/DataMOBS87/Mouse-786/09092018/CalibrationC/Calib-0.5V/';
       '/media/mobsrick/DataMOBS87/Mouse-786/09092018/CalibrationC/Calib-0V/';
       '/media/mobsrick/DataMOBS87/Mouse-786/09092018/CalibrationC/Calib-1.5V/';
       '/media/mobsrick/DataMOBS87/Mouse-786/09092018/CalibrationC/Calib-1V/';
       '/media/mobsrick/DataMOBS87/Mouse-786/09092018/CalibrationC/Calib-2.5V/';
       '/media/mobsrick/DataMOBS87/Mouse-786/09092018/CalibrationC/Calib-2V/';
       '/media/mobsrick/DataMOBS87/Mouse-786/09092018/CalibrationC/Calib-3.5V/';
       '/media/mobsrick/DataMOBS87/Mouse-786/09092018/CalibrationC/Calib-3V/';
       '/media/mobsrick/DataMOBS87/Mouse-786/09092018/CalibrationC/Calib-4.5V/';
       '/media/mobsrick/DataMOBS87/Mouse-786/09092018/CalibrationC/Calib-4V/';
       '/media/mobsrick/DataMOBS87/Mouse-786/09092018/CalibrationC/Calib-5V/';
       '/media/mobsrick/DataMOBS87/Mouse-786/10092018/ContextATest/';
       '/media/mobsrick/DataMOBS87/Mouse-786/10092018/ContextBTest/';
       '/media/mobsrick/DataMOBS87/Mouse-786/10092018/ContextCTest/';
       '/media/mobsrick/DataMOBS87/Mouse-786/10092018/Hab/';
       '/media/mobsrick/DataMOBS87/Mouse-786/10092018/TestPre/';
       '/media/mobsrick/DataMOBS87/Mouse-786/10092018/Cond/';
       '/media/mobsrick/DataMOBS87/Mouse-786/10092018/TestPost/TestPost0/';
       '/media/mobsrick/DataMOBS87/Mouse-786/10092018/TestPost/';
       '/media/mobsrick/DataMOBS87/Mouse-786/11092018/TestPost/';
       '/media/mobsrick/DataMOBS87/Mouse-786/12092018/Hab/';
       '/media/mobsrick/DataMOBS87/Mouse-786/12092018/TestPre/';
       '/media/mobsrick/DataMOBS87/Mouse-786/12092018/Cond/';
       '/media/mobsrick/DataMOBS87/Mouse-786/12092018/TestPost/TestPost0/';
       '/media/mobsrick/DataMOBS87/Mouse-786/12092018/TestPost/';
       '/media/mobsrick/DataMOBS87/Mouse-787/09092018/BaselineSleep/';
       '/media/mobsrick/DataMOBS87/Mouse-787/09092018/ContextANeutral/';
       '/media/mobsrick/DataMOBS87/Mouse-787/09092018/CalibrationB/Calib-0.5V/';
       '/media/mobsrick/DataMOBS87/Mouse-787/09092018/CalibrationB/Calib-0V/';
       '/media/mobsrick/DataMOBS87/Mouse-787/09092018/CalibrationB/Calib-1.5V/';
       '/media/mobsrick/DataMOBS87/Mouse-787/09092018/CalibrationB/Calib-1V/';
       '/media/mobsrick/DataMOBS87/Mouse-787/09092018/CalibrationB/Calib-2V/';
       '/media/mobsrick/DataMOBS87/Mouse-787/09092018/CalibrationC/Calib-0.5V/';
       '/media/mobsrick/DataMOBS87/Mouse-787/09092018/CalibrationC/Calib-0V/';
       '/media/mobsrick/DataMOBS87/Mouse-787/09092018/CalibrationC/Calib-1.5V/';
       '/media/mobsrick/DataMOBS87/Mouse-787/09092018/CalibrationC/Calib-1V/';
       '/media/mobsrick/DataMOBS87/Mouse-787/09092018/CalibrationC/Calib-2.5V/';
       '/media/mobsrick/DataMOBS87/Mouse-787/09092018/CalibrationC/Calib-2V/';
       '/media/mobsrick/DataMOBS87/Mouse-787/09092018/CalibrationC/Calib-3V/';
       '/media/mobsrick/DataMOBS87/Mouse-787/09092018/CalibrationC/Calib-4V/';
       '/media/mobsrick/DataMOBS87/Mouse-787/09092018/CalibrationC/Calib-5V/';
       '/media/mobsrick/DataMOBS87/Mouse-787/09092018/CalibrationC/Calib-6V/';
       '/media/mobsrick/DataMOBS87/Mouse-787/11092018/ContextATest/';
       '/media/mobsrick/DataMOBS87/Mouse-787/11092018/ContextBTest/';
       '/media/mobsrick/DataMOBS87/Mouse-787/11092018/ContextCTest/';
       '/media/mobsrick/DataMOBS87/Mouse-787/11092018/Hab/';
       '/media/mobsrick/DataMOBS87/Mouse-787/11092018/TestPre/';
       '/media/mobsrick/DataMOBS87/Mouse-787/11092018/Cond/';
       '/media/mobsrick/DataMOBS87/Mouse-787/11092018/TestPost/';
       '/media/mobsrick/DataMOBS87/Mouse-787/12092018/Day4/TestPost/';
       '/media/mobsrick/DataMOBS87/Mouse-787/12092018/Hab/';
       '/media/mobsrick/DataMOBS87/Mouse-787/12092018/TestPre/';
       '/media/mobsrick/DataMOBS87/Mouse-787/12092018/Cond/';
       '/media/mobsrick/DataMOBS87/Mouse-787/12092018/TestPost/TestPost0/';
       '/media/mobsrick/DataMOBS87/Mouse-787/12092018/TestPost/';
       '/media/mobsrick/DataMOBS87/Mouse-788/09092018/BaselineSleep/';
       '/media/mobsrick/DataMOBS87/Mouse-788/09092018/CalibrationB/Calib-0.5V/';
       '/media/mobsrick/DataMOBS87/Mouse-788/09092018/CalibrationB/Calib-0V/';
       '/media/mobsrick/DataMOBS87/Mouse-788/09092018/CalibrationB/Calib-1.5V/';
       '/media/mobsrick/DataMOBS87/Mouse-788/09092018/CalibrationB/Calib-1V/';
       '/media/mobsrick/DataMOBS87/Mouse-788/09092018/CalibrationB/Calib-2.5V/';
       '/media/mobsrick/DataMOBS87/Mouse-788/09092018/CalibrationB/Calib-2V/';
       '/media/mobsrick/DataMOBS87/Mouse-788/09092018/CalibrationC/Calib-0.5V/';
       '/media/mobsrick/DataMOBS87/Mouse-788/09092018/CalibrationC/Calib-0V/';
       '/media/mobsrick/DataMOBS87/Mouse-788/09092018/CalibrationC/Calib-1.5V/';
       '/media/mobsrick/DataMOBS87/Mouse-788/09092018/CalibrationC/Calib-1V/';
       '/media/mobsrick/DataMOBS87/Mouse-788/09092018/CalibrationC/Calib-2.5V/';
       '/media/mobsrick/DataMOBS87/Mouse-788/09092018/CalibrationC/Calib-2V/';
       '/media/mobsrick/DataMOBS87/Mouse-788/09092018/CalibrationC/Calib-3V/';
       '/media/mobsrick/DataMOBS87/Mouse-788/09092018/CalibrationC/Calib-4V/';
       '/media/mobsrick/DataMOBS87/Mouse-788/09092018/CalibrationC/Calib-5V/';
       '/media/mobsrick/DataMOBS87/Mouse-788/09092018/CalibrationC/Calib-6V/';
       '/media/mobsrick/DataMOBS87/Mouse-788/09092018/CalibrationC/Calib-8V/';
       '/media/mobsrick/DataMOBS87/Mouse-788/10092018/ContextATest/';
       '/media/mobsrick/DataMOBS87/Mouse-788/10092018/ContextBTest/';
       '/media/mobsrick/DataMOBS87/Mouse-788/10092018/ContextCTest/';
       '/media/mobsrick/DataMOBS87/Mouse-788/10092018/Hab/';
       '/media/mobsrick/DataMOBS87/Mouse-788/10092018/TestPre/';
       '/media/mobsrick/DataMOBS87/Mouse-788/10092018/Cond/';
       '/media/mobsrick/DataMOBS87/Mouse-788/10092018/TestPost/TestPost0/';
       '/media/mobsrick/DataMOBS87/Mouse-788/10092018/TestPost/';
       '/media/mobsrick/DataMOBS87/Mouse-788/11092018/TestPost/';
       };
end


for i=1:length(dirin)
    Dir=dirin{i};
    
    cd(Dir);
    prefix = 'PAG-';  % Experiment prefix
    load('ExpeInfo.mat');
    load('makedataBulbeInputs.mat');
    flnme = [prefix 'Mouse-' num2str(ExpeInfo.nmouse) '-' num2str(ExpeInfo.date) '-' ExpeInfo.phase];
    dir_rip = '';

    %% Make data

    %Set Session
    SetCurrentSession([flnme '.xml']);
    
    % make LFP
    MakeData_LFP
    
    % Make accelerometer Movtsd
    MakeData_Accelero(Dir);
    
    % Digital inputs
    if dodigitalin == 1
        MakeData_Digin
    end
    
    % Get Stimulations if you have any
    if dodigitalin == 1
        GetStims_DB
    end
   
    
end
end

%% After - get freezing, noise and heart