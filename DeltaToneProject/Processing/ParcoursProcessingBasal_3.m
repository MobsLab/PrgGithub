%ParcoursProcessingBasal_3
% 06.12.2017 KJ
%
% processing for dataset
%
% see ParcoursProcessingBasal_2 ParcoursProcessingBasal_4


a=0;
%------------ 451 ------------
a=a+1; Dir.path{a}='/media/DataMOBsRAID/ProjetBreathDeltaFeedback/Mice403-451/20161205/Mouse451/Breath-Mouse-451-05122016/';
a=a+1; Dir.path{a}='/media/DataMOBsRAID/ProjetBreathDeltaFeedback/Mice403-451/20161209/Mouse451/Breath-Mouse-451-09122016/';
a=a+1; Dir.path{a}='/media/DataMOBsRAID/ProjetBreathDeltaFeedback/Mice403-451/20161212/Mouse451/Breath-Mouse-451-12122016/';
a=a+1; Dir.path{a}='/media/DataMOBsRAID/ProjetBreathDeltaFeedback/Mice403-451/20161217/Mouse451/Breath-Mouse-451-17122016/';


%% SB
% ------------ 490 ------------
a=a+1; Dir.path{a}='/media/nas4/ProjetDeltaToneFeedback/Mouse490/20161124/'; % Mouse 490 - Basal 1 
% a=a+1; Dir.path{a}='/media/nas4/ProjetDeltaToneFeedback/Mouse490/20161129/'; % Mouse 490 - Basal 2 

% ------------ 507 ------------
a=a+1; Dir.path{a}='/media/nas4/ProjetDeltaToneFeedback/Mouse507/20170126/'; % Mouse 507 - Basal 1 
a=a+1; Dir.path{a}='/media/nas4/ProjetDeltaToneFeedback/Mouse507/20170127/'; % Mouse 507 - Basal 2 



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

scoring = 'ob';

for p=1:length(Dir.path)
    disp(' ')
    disp('****************************************************************')
    eval(['cd(Dir.path{',num2str(p),'}'')'])
    disp(pwd)
    
    clearvars -except Dir p scoring
    
    try
        ParcoursProcessingBasal_f
    catch
       disp('error') 
    end
    
end