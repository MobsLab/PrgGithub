

try
   dirin;
catch
   dirin={
% %        '/media/mobsrick/DataMOBS87/Mouse-797/10112018/NeutralContextDay1/';
% %        '/media/mobsrick/DataMOBS87/Mouse-797/11112018/AversiveContextDay2/'; 
%        '/media/mobsrick/DataMOBS87/Mouse-797/11112018/Cond/'; 
%        '/media/mobsrick/DataMOBS87/Mouse-797/11112018/Hab/'; 
% %        '/media/mobsrick/DataMOBS87/Mouse-797/11112018/NeutralContextDay2/';
% %        '/media/mobsrick/DataMOBS87/Mouse-797/11112018/PostSleep/'; 
% %        '/media/mobsrick/DataMOBS87/Mouse-797/11112018/PreSleep/'; 
%        '/media/mobsrick/DataMOBS87/Mouse-797/11112018/TestPost/'; 
%        '/media/mobsrick/DataMOBS87/Mouse-797/11112018/TestPre/';
%        '/media/mobsrick/DataMOBS87/Mouse-797/12112018/TestPost/';
% %        '/media/mobsrick/DataMOBS87/Mouse-797/10112018/PreSleep/';
% %        '/media/mobsrick/DataMOBS87/Mouse-797/10112018/PostSleep/';
%        '/media/mobsrick/DataMOBS87/Mouse-797/10112018/Calib/Calib-0.0V/';
%        '/media/mobsrick/DataMOBS87/Mouse-797/10112018/Calib/Calib-0.5V/';
%        '/media/mobsrick/DataMOBS87/Mouse-797/10112018/Calib/Calib-1.0V/';
%        '/media/mobsrick/DataMOBS87/Mouse-797/10112018/Calib/Calib-1.5V/';
%        '/media/mobsrick/DataMOBS87/Mouse-797/10112018/Calib/Calib-2.0V/';
%        '/media/mobsrick/DataMOBS87/Mouse-797/10112018/Calib/Calib-2.5V/';
%        '/media/mobsrick/DataMOBS87/Mouse-797/10112018/Calib/Calib-3.0V/';
%        
% %        '/media/mobsrick/DataMOBS87/Mouse-798/10112018/NeutralContextDay1/';
% %        '/media/mobsrick/DataMOBS87/Mouse-798/11112018/AversiveContextDay2/';
% %        '/media/mobsrick/DataMOBS87/Mouse-798/11112018/NeutralContextDay2/';
%        '/media/mobsrick/DataMOBS87/Mouse-798/12112018/Cond/';
%        '/media/mobsrick/DataMOBS87/Mouse-798/12112018/Hab/';
% %        '/media/mobsrick/DataMOBS87/Mouse-798/12112018/PostSleep/'; 
% %        '/media/mobsrick/DataMOBS87/Mouse-798/12112018/PreSleep/';
%        '/media/mobsrick/DataMOBS87/Mouse-798/12112018/TestPost/';
%        '/media/mobsrick/DataMOBS87/Mouse-798/12112018/TestPre/';
%        '/media/mobsrick/DataMOBS87/Mouse-798/13112018/TestPost/';
% %        '/media/mobsrick/DataMOBS87/Mouse-798/10112018/PreSleep/'; 
% %        '/media/mobsrick/DataMOBS87/Mouse-798/10112018/PostSleep/';
%        '/media/mobsrick/DataMOBS87/Mouse-798/10112018/Calib/Calib-0.0V/';
%        '/media/mobsrick/DataMOBS87/Mouse-798/10112018/Calib/Calib-0.5V/';
%        '/media/mobsrick/DataMOBS87/Mouse-798/10112018/Calib/Calib-1.0V/';
%        '/media/mobsrick/DataMOBS87/Mouse-798/10112018/Calib/Calib-1.5V/';
%        '/media/mobsrick/DataMOBS87/Mouse-798/10112018/Calib/Calib-2.0V/';
%        '/media/mobsrick/DataMOBS87/Mouse-798/10112018/Calib/Calib-2.5V/';
       '/media/mobsrick/DataMOBS87/Mouse-798/10112018/Calib/Calib-3.0V/';
       '/media/mobsrick/DataMOBS87/Mouse-798/10112018/Calib/Calib-3.5V/';
       '/media/mobsrick/DataMOBS87/Mouse-798/10112018/Calib/Calib-4.0V/';
       '/media/mobsrick/DataMOBS87/Mouse-798/10112018/Calib/Calib-4.5V/';
       };
end

load('/media/mobsrick/DataMOBS87/CalibrationIR_August2018.mat');
TempOutput(isnan(ValuesInput))=[];
ValuesInput(isnan(ValuesInput))=[];



for i=1:length(dirin)
    Dir=dirin{i};
    
    cd(Dir);
    prefix = 'ERC-';  % Experiment prefix
    load('ExpeInfo.mat');
    load('makedataBulbeInputs.mat');
    load('behavResources.mat', 'MouseTemp', 'frame_limits');
    flnme = [prefix 'Mouse-' num2str(ExpeInfo.nmouse) '-' num2str(ExpeInfo.date) '-' ExpeInfo.phase];

    MouseTemp1 = (MouseTemp*(frame_limits(2)-frame_limits(1)))+frame_limits(1);
    MouseTemp_InDegrees = interp1(ValuesInput,TempOutput, MouseTemp1(:,2));
    
    save ('behavResources.mat', 'MouseTemp_InDegrees', '-append');
    clear MouseTemp MouseTemp_InDegrees MouseTemp1 frame_limits
end

