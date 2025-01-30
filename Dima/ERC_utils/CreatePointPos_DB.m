

try
   dirin;
catch
   dirin={
       '/media/mobsrick/DataMOBS87/Mouse-797/10112018/NeutralContextDay1/';
       '/media/mobsrick/DataMOBS87/Mouse-797/11112018/AversiveContextDay2/'; 
       '/media/mobsrick/DataMOBS87/Mouse-797/11112018/Cond/'; 
       '/media/mobsrick/DataMOBS87/Mouse-797/11112018/Hab/'; 
       '/media/mobsrick/DataMOBS87/Mouse-797/11112018/NeutralContextDay2/';
%        '/media/mobsrick/DataMOBS87/Mouse-797/11112018/PostSleep/'; 
%        '/media/mobsrick/DataMOBS87/Mouse-797/11112018/PreSleep/'; 
       '/media/mobsrick/DataMOBS87/Mouse-797/11112018/TestPost/'; 
       '/media/mobsrick/DataMOBS87/Mouse-797/11112018/TestPre/';
       '/media/mobsrick/DataMOBS87/Mouse-797/12112018/TestPost/';
%        '/media/mobsrick/DataMOBS87/Mouse-797/10112018/PreSleep/';
%        '/media/mobsrick/DataMOBS87/Mouse-797/10112018/PostSleep/';
%        '/media/mobsrick/DataMOBS87/Mouse-797/10112018/Calib/Calib-0.0V/';
%        '/media/mobsrick/DataMOBS87/Mouse-797/10112018/Calib/Calib-0.5V/';
%        '/media/mobsrick/DataMOBS87/Mouse-797/10112018/Calib/Calib-1.0V/';
%        '/media/mobsrick/DataMOBS87/Mouse-797/10112018/Calib/Calib-1.5V/';
%        '/media/mobsrick/DataMOBS87/Mouse-797/10112018/Calib/Calib-2.0V/';
%        '/media/mobsrick/DataMOBS87/Mouse-797/10112018/Calib/Calib-2.5V/';
%        '/media/mobsrick/DataMOBS87/Mouse-797/10112018/Calib/Calib-3.0V/';
%        
       '/media/mobsrick/DataMOBS87/Mouse-798/10112018/NeutralContextDay1/';
       '/media/mobsrick/DataMOBS87/Mouse-798/11112018/AversiveContextDay2/';
       '/media/mobsrick/DataMOBS87/Mouse-798/11112018/NeutralContextDay2/';
       '/media/mobsrick/DataMOBS87/Mouse-798/12112018/Cond/';
       '/media/mobsrick/DataMOBS87/Mouse-798/12112018/Hab/';
%        '/media/mobsrick/DataMOBS87/Mouse-798/12112018/PostSleep/'; 
%        '/media/mobsrick/DataMOBS87/Mouse-798/12112018/PreSleep/';
       '/media/mobsrick/DataMOBS87/Mouse-798/12112018/TestPost/';
       '/media/mobsrick/DataMOBS87/Mouse-798/12112018/TestPre/';
       '/media/mobsrick/DataMOBS87/Mouse-798/13112018/TestPost/';
%        '/media/mobsrick/DataMOBS87/Mouse-798/10112018/PreSleep/'; 
%        '/media/mobsrick/DataMOBS87/Mouse-798/10112018/PostSleep/';
%        '/media/mobsrick/DataMOBS87/Mouse-798/10112018/Calib/Calib-0.0V/';
%        '/media/mobsrick/DataMOBS87/Mouse-798/10112018/Calib/Calib-0.5V/';
%        '/media/mobsrick/DataMOBS87/Mouse-798/10112018/Calib/Calib-1.0V/';
%        '/media/mobsrick/DataMOBS87/Mouse-798/10112018/Calib/Calib-1.5V/';
%        '/media/mobsrick/DataMOBS87/Mouse-798/10112018/Calib/Calib-2.0V/';
%        '/media/mobsrick/DataMOBS87/Mouse-798/10112018/Calib/Calib-2.5V/';
%        '/media/mobsrick/DataMOBS87/Mouse-798/10112018/Calib/Calib-3.0V/';
%        '/media/mobsrick/DataMOBS87/Mouse-798/10112018/Calib/Calib-3.5V/';
%        '/media/mobsrick/DataMOBS87/Mouse-798/10112018/Calib/Calib-4.0V/';
%        '/media/mobsrick/DataMOBS87/Mouse-798/10112018/Calib/Calib-4.5V/';
       };
end


for i=1:length(dirin)
    Dir=dirin{i};
    
    cd(Dir);
    prefix = 'ERC-';  % Experiment prefix
    load('ExpeInfo.mat');
    load('makedataBulbeInputs.mat');
    load('behavResources.mat', 'PosMat');
    flnme = [prefix 'Mouse-' num2str(ExpeInfo.nmouse) '-' num2str(ExpeInfo.date) '-' ExpeInfo.phase];
    dir_rip = '/media/mobsrick/DataMOBS87/Mouse-798/12112018/PreSleep/';

file1 = fopen([flnme '.pos'],'w');

for pp = 1:length(PosMat)
    fprintf(file1,'%f\t',PosMat(pp,2)); fprintf(file1,'%f\n',PosMat(pp,3));
    
end
fclose(file1);
clear PosMat
end
