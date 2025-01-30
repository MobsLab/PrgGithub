function Dir=PathForExperimentsDeltaSleep873_874(experiment)


%% Basal condition
a=0;
if strcmpi(experiment,'basal')
    %KJ 873
    a=a+1; Dir.path{a}='/media/nas4/ProjetDeltaToneFeedback/Mouse873/20190418/'; % Mouse 873 18-04-2019
    a=a+1; Dir.path{a}='/media/nas4/ProjetDeltaToneFeedback/Mouse873/20190423/'; % Mouse 873 23-04-2019
    
    %KJ 874
    a=a+1; Dir.path{a}='/media/nas4/ProjetDeltaToneFeedback/Mouse874/20190418/'; % Mouse 874 18-04-2019
    
end


%% Random condition
a=0;
if strcmpi(experiment,'RdmTone')
    %KJ 873
    a=a+1; Dir.path{a}='/media/nas4/ProjetDeltaToneFeedback/Mouse873/20190425/'; % Mouse 873 25-04-2019
    Dir.delay{a}=0;
    a=a+1; Dir.path{a}='/media/nas4/ProjetDeltaToneFeedback/Mouse873/20190502/'; % Mouse 873 02-05-2019
    Dir.delay{a}=0;
    a=a+1; Dir.path{a}='/media/nas4/ProjetDeltaToneFeedback/Mouse873/20190503/'; % Mouse 873 03-05-2019
    Dir.delay{a}=0;
    a=a+1; Dir.path{a}='/media/nas4/ProjetDeltaToneFeedback/Mouse873/20190529/'; % Mouse 873 29-05-2019
    Dir.delay{a}=0;
    a=a+1; Dir.path{a}='/media/nas4/ProjetDeltaToneFeedback/Mouse873/20190611/'; % Mouse 873 11-06-2019
    Dir.delay{a}=0;
    a=a+1; Dir.path{a}='/media/nas4/ProjetDeltaToneFeedback/Mouse873/20190619/'; % Mouse 873 19-06-2019
    Dir.delay{a}=0;
    a=a+1; Dir.path{a}='/media/nas4/ProjetDeltaToneFeedback/Mouse873/20190621/'; % Mouse 873 21-06-2019
    Dir.delay{a}=0;
    
    %KJ 874
    a=a+1; Dir.path{a}='/media/nas4/ProjetDeltaToneFeedback/Mouse874/20190425/'; % Mouse 874 25-04-2019
    Dir.delay{a}=0;
    a=a+1; Dir.path{a}='/media/nas4/ProjetDeltaToneFeedback/Mouse874/20190502/'; % Mouse 874 02-05-2019
    Dir.delay{a}=0;
    a=a+1; Dir.path{a}='/media/nas4/ProjetDeltaToneFeedback/Mouse874/20190503/'; % Mouse 874 03-05-2019
    Dir.delay{a}=0;
    a=a+1; Dir.path{a}='/media/nas4/ProjetDeltaToneFeedback/Mouse874/20190517/'; % Mouse 874 17-05-2019
    Dir.delay{a}=0;
    a=a+1; Dir.path{a}='/media/nas4/ProjetDeltaToneFeedback/Mouse874/20190604/'; % Mouse 874 04-06-2019
    Dir.delay{a}=0;
    a=a+1; Dir.path{a}='/media/nas4/ProjetDeltaToneFeedback/Mouse874/20190618/'; % Mouse 874 18-06-2019
    Dir.delay{a}=0;
    a=a+1; Dir.path{a}='/media/nas4/ProjetDeltaToneFeedback/Mouse874/20190619/'; % Mouse 874 19-06-2019
    Dir.delay{a}=0;
    a=a+1; Dir.path{a}='/media/nas4/ProjetDeltaToneFeedback/Mouse874/20190621/'; % Mouse 874 21-06-2019
    Dir.delay{a}=0;
end


%% DeltaTone condition 0ms - Delta restriction

a=0;
if strcmpi(experiment,'DeltaT0')
    
    %KJ 873
    a=a+1; Dir.path{a}='/media/nas4/ProjetDeltaToneFeedback/Mouse873/20190509/'; % Mouse 873 09-05-2019
    Dir.delay{a}=0;
    a=a+1; Dir.path{a}='/media/nas4/ProjetDeltaToneFeedback/Mouse873/20190514/'; % Mouse 873 14-05-2019
    Dir.delay{a}=0;
    a=a+1; Dir.path{a}='/media/nas4/ProjetDeltaToneFeedback/Mouse873/20190517/'; % Mouse 873 17-05-2019
    Dir.delay{a}=0;

    
    %KJ 874
    a=a+1; Dir.path{a}='/media/nas4/ProjetDeltaToneFeedback/Mouse874/20190510/'; % Mouse 874 10-05-2019
    Dir.delay{a}=0;
    a=a+1; Dir.path{a}='/media/nas4/ProjetDeltaToneFeedback/Mouse874/20190513/'; % Mouse 874 13-05-2019
    Dir.delay{a}=0;
    a=a+1; Dir.path{a}='/media/nas4/ProjetDeltaToneFeedback/Mouse874/20190529/'; % Mouse 874 29-05-2019
    Dir.delay{a}=0;
    
    
end


%% DeltaTone condition 100
a=0;
if strcmpi(experiment,'DeltaT100')
    %KJ 873
    a=a+1; Dir.path{a}='/media/nas4/ProjetDeltaToneFeedback/Mouse873/20190604/'; % Mouse 873 04-06-2019
    Dir.delay{a}=0;
    a=a+1; Dir.path{a}='/media/nas4/ProjetDeltaToneFeedback/Mouse873/20190618/'; % Mouse 873 18-06-2019
    Dir.delay{a}=0;
    
    %KJ 874
    a=a+1; Dir.path{a}='/media/nas4/ProjetDeltaToneFeedback/Mouse874/20190611/'; % Mouse 874 11-06-2019
    Dir.delay{a}=0;
end



%% If ALL experiments
if strcmpi(experiment,'all')
    Dir1 = PathForExperimentsDeltaSleep873_874('Basal');
    for p=1:length(Dir1.path)
        Dir1.delay{p}=-1;
    end
    Dir2 = PathForExperimentsDeltaSleep873_874('RdmTone');
    Dir3 = PathForExperimentsDeltaSleep873_874('DeltaT0');
    Dir4 = PathForExperimentsDeltaSleep873_874('DeltaT100');
    Dir1 = MergePathForExperiment(Dir1,Dir2);
    Dir2 = MergePathForExperiment(Dir3,Dir4);
    Dir = MergePathForExperiment(Dir1,Dir2);
    
elseif strcmpi(experiment,'tone')
    Dir1 = PathForExperimentsDeltaSleep873_874('RdmTone');
    Dir2 = PathForExperimentsDeltaSleep873_874('DeltaT0');
    Dir3 = PathForExperimentsDeltaSleep873_874('DeltaT100');
    Dir = MergePathForExperiment(Dir2,Dir3);
    Dir = MergePathForExperiment(Dir1,Dir);
    
else

    %% name, manipe, group, date 
    for i=1:length(Dir.path)
        Dir.manipe{i}=experiment;
        Dir.group{i}='WT';

        %mouse name
        Dir.name{i}=Dir.path{i}(strfind(Dir.path{i},'/Mouse'):strfind(Dir.path{i},'/Mouse')+8);
        Dir.name{i}(Dir.name{i}=='-')=[];
        Dir.name{i}(Dir.name{i}=='/')=[];
        
        if isempty(Dir.name{i})
            idx = strfind(Dir.path{i},'-Mouse-');
            Dir.name{i}=Dir.path{i}(idx+1:idx+9);
            Dir.name{i}(Dir.name{i}=='-')=[];
            Dir.name{i}(Dir.name{i}=='/')=[];
        end
        

        %date
        ind = strfind(Dir.path{i},'/201');
        Dir.date{i} = Dir.path{i}(ind + [7 8 5 6 1:4]);

    end

end


end




