%ParcoursProcessingBasal_5
% 06.12.2017 KJ
%
% processing for dataset
%
% ParcoursProcessingBasal_3 ParcoursProcessingBasal_6
%


a=0;
% ------------ 243 ------------
a=a+1; Dir.path{a}='/media/DataMOBsRAID/ProjetBreathDeltaFeedback/Mice243-244/20150329/Breath-Mouse-243-244-29032015/Mouse243'; 
a=a+1; Dir.path{a}='/media/DataMOBsRAID/ProjetBreathDeltaFeedback/Mice243-244/20150331/Breath-Mouse-243-244-31032015/Mouse243'; 
a=a+1; Dir.path{a}='/media/DataMOBsRAID/ProjetBreathDeltaFeedback/Mice243-244/20150401/Breath-Mouse-243-244-01042015/Mouse243';
a=a+1; Dir.path{a}='/media/DataMOBsRAID/ProjetBreathDeltaFeedback/Mice243-244/20150409/Breath-Mouse-243-244-09042015/Mouse243';


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
    
        ParcoursProcessingBasal_f
    
end