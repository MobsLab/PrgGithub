%ParcoursProcessingDelta_temp
% 26.03.2018 KJ
%
% processing for dataset
%
% see ParcoursProcessingBasalSleepSpike 


a=0;
% ----------- 403 ----------------------
a=a+1; Dir.path{a}='/media/DataMOBsRAID/ProjetBreathDeltaFeedback/Mice403-451/20170130/Breath-Mouse-403-451-30012017/Mouse403/';
a=a+1; Dir.path{a}='/media/DataMOBsRAID/ProjetBreathDeltaFeedback/Mice403-451/20170213/Breath-Mouse-403-451-13022017/Mouse403/';
a=a+1; Dir.path{a}='/media/DataMOBsRAID/ProjetBreathDeltaFeedback/Mice403-451/20170215/Breath-Mouse-403-451-15022017/Mouse403/';

% % ----------- 451 ----------------------
a=a+1; Dir.path{a}='/media/DataMOBsRAID/ProjetBreathDeltaFeedback/Mice403-451/20170130/Breath-Mouse-403-451-30012017/Mouse451/';
a=a+1; Dir.path{a}='/media/DataMOBsRAID/ProjetBreathDeltaFeedback/Mice403-451/20170213/Breath-Mouse-403-451-13022017/Mouse451/';
a=a+1; Dir.path{a}='/media/DataMOBsRAID/ProjetBreathDeltaFeedback/Mice403-451/20170215/Breath-Mouse-403-451-15022017/Mouse451/';


%% name, manipe, group, date 
for i=1:length(Dir.path)
    Dir.manipe{i}='Basal';
    Dir.group{i}='WT';

    %mouse name
    Dir.name{i}=Dir.path{i}(strfind(Dir.path{i},'/Mouse'):strfind(Dir.path{i},'/Mouse')+8);
    Dir.name{i}(Dir.name{i}=='-')=[];
    Dir.name{i}(Dir.name{i}=='/')=[];
    
    %date
    ind = strfind(Dir.path{i},'/201');
    Dir.date{i} = Dir.path{i}(ind + [7 8 5 6 1:4]);

end

scoring = 'accelero';


for p=1:length(Dir.path)
    disp(' ')
    disp('****************************************************************')
    eval(['cd(Dir.path{',num2str(p),'}'')'])
    disp(pwd)
    
    clearvars -except Dir p scoring
    
    %% params
    x = '*.xml';
    filelist = dir(x);
    for i=1:length(filelist)
        if contains(filelist(i).name, 'SpikeRef')
           xml_spike = filelist(i).name;
        elseif ~contains(filelist(i).name, 'SpikeRef') && ~contains(filelist(i).name, 'SubRef')
           xml_file = filelist(i).name; 
        end
    end
    %set current session
    clearvars -global DATA
    SetCurrentSession(xml_file)
    
    
    setCu=1;
    makeBehavRessourcesKJ;
    
        
    
        
    
end




