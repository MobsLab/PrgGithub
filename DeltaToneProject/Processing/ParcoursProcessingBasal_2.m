%ParcoursProcessingBasal_2
% 06.12.2017 KJ
%
% processing for dataset
%
% see ParcoursProcessingBasal_1 ParcoursProcessingBasal_3

a=0;
% ------------ 294 ------------
a=a+1; Dir.path{a}='/media/DataMOBsRAID/ProjetBreathDeltaFeedback/Mice293-294-296/20151207/Mouse294/Breath-Mouse-294-07122015'; % Mouse 294 - Day 1
a=a+1; Dir.path{a}='/media/DataMOBsRAID/ProjetBreathDeltaFeedback/Mice293-294-296/20151208/Mouse294/Breath-Mouse-294-08122015'; % Mouse 294 - Day 2
a=a+1; Dir.path{a}='/media/DataMOBsRAID/ProjetBreathDeltaFeedback/Mice293-294-296/20151211/Mouse294/Breath-Mouse-294-11122015'; % Mouse 294 - Day 3
a=a+1; Dir.path{a}='/media/DataMOBsRAID/ProjetBreathDeltaFeedback/Mice293-294-296/20151218/Mouse294/Breath-Mouse-294-18122015'; % Mouse 294 - Day 4

% ------------ 328 ------------
a=a+1; Dir.path{a}='/media/DataMOBsRAID/ProjetBreathDeltaFeedback/Mice328-330/20160322/Breath-Mouse-328-22032016'; % Mouse 328 - Day 1
a=a+1; Dir.path{a}='/media/DataMOBsRAID/ProjetBreathDeltaFeedback/Mice328-330/20160325/Breath-Mouse-328-25032016'; % Mouse 328 - Day 2
a=a+1; Dir.path{a}='/media/DataMOBsRAID/ProjetBreathDeltaFeedback/Mice328-330/20160401/Mouse328/Breath-Mouse-328-01042016'; % Mouse 328 - Day 4
a=a+1; Dir.path{a}='/media/DataMOBsRAID/ProjetBreathDeltaFeedback/Mice328-330/20160404/Mouse328/Breath-Mouse-328-04042016'; % Mouse 328 - Day 5  



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