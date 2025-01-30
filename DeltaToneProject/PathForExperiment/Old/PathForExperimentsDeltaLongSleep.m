function Dir=PathForExperimentsDeltaLongSleep(experiment)

%
% see PathForExperimentsDeltaWavesTone PathForExperimentsDeltaSleepSpikes
%

%% Basal condition
a=0;
if strcmpi(experiment,'BASAL')
    %GL
    a=a+1; Dir.path{a}='/media/DataMOBsRAID/ProjetBreathDeltaFeedback/Mice243-244/20150329/Breath-Mouse-243-244-29032015/Mouse244'; % Mouse 244 - Day 2
    a=a+1; Dir.path{a}='/media/DataMOBsRAID/ProjetBreathDeltaFeedback/Mice243-244/20150331/Breath-Mouse-243-244-31032015/Mouse243'; % Mouse 243 - Day 3
    a=a+1; Dir.path{a}='/media/DataMOBsRAID/ProjetBreathDeltaFeedback/Mice243-244/20150331/Breath-Mouse-243-244-31032015/Mouse244'; % Mouse 244 - Day 3
    a=a+1; Dir.path{a}='/media/DataMOBsRAID/ProjetBreathDeltaFeedback/Mice243-244/20150409/Breath-Mouse-243-244-09042015/Mouse243'; % Mouse 243 - Day 5
    a=a+1; Dir.path{a}='/media/DataMOBsRAID/ProjetBreathDeltaFeedback/Mice243-244/20150409/Breath-Mouse-243-244-09042015/Mouse244'; % Mouse 244 - Day 5
    
    a=a+1; Dir.path{a}='/media/DataMOBsRAID/ProjetBreathDeltaFeedback/Mice251-252/20150518/Breath-Mouse-251-252-18052015/Mouse251'; % Mouse 251 - Day 1
    a=a+1; Dir.path{a}='/media/DataMOBsRAID/ProjetBreathDeltaFeedback/Mice251-252/20150518/Breath-Mouse-251-252-18052015/Mouse252'; % Mouse 252 - Day 1
    a=a+1; Dir.path{a}='/media/DataMOBsRAID/ProjetBreathDeltaFeedback/Mice251-252/20150519/Breath-Mouse-251-252-19052015/Mouse251'; % Mouse 251 - Day 2
    a=a+1; Dir.path{a}='/media/DataMOBsRAID/ProjetBreathDeltaFeedback/Mice251-252/20150519/Breath-Mouse-251-252-19052015/Mouse252'; % Mouse 252 - Day 2
    a=a+1; Dir.path{a}='/media/DataMOBsRAID/ProjetBreathDeltaFeedback/Mice251-252/20150520/Breath-Mouse-251-252-20052015/Mouse251'; % Mouse 251 - Day 3
    a=a+1; Dir.path{a}='/media/DataMOBsRAID/ProjetBreathDeltaFeedback/Mice251-252/20150520/Breath-Mouse-251-252-20052015/Mouse252'; % Mouse 252 - Day 3
    a=a+1; Dir.path{a}='/media/DataMOBsRAID/ProjetBreathDeltaFeedback/Mice251-252/20150521/Breath-Mouse-251-252-21052015/Mouse251'; % Mouse 251 - Day 4
    a=a+1; Dir.path{a}='/media/DataMOBsRAID/ProjetBreathDeltaFeedback/Mice251-252/20150521/Breath-Mouse-251-252-21052015/Mouse252'; % Mouse 252 - Day 4
    a=a+1; Dir.path{a}='/media/DataMOBsRAID/ProjetBreathDeltaFeedback/Mice251-252/20150522/Breath-Mouse-251-252-22052015/Mouse251'; % Mouse 251 - Day 5
    a=a+1; Dir.path{a}='/media/DataMOBsRAID/ProjetBreathDeltaFeedback/Mice251-252/20150522/Breath-Mouse-251-252-22052015/Mouse252'; % Mouse 252 - Day 5
    
    a=a+1; Dir.path{a}='/media/DataMOBsRAID/ProjetBreathDeltaFeedback/Mice293-294-296/20151207/Mouse293/Breath-Mouse-293-07122015'; % Mouse 293 - Day 1
    a=a+1; Dir.path{a}='/media/DataMOBsRAID/ProjetBreathDeltaFeedback/Mice293-294-296/20151207/Mouse294/Breath-Mouse-294-07122015'; % Mouse 294 - Day 1
    a=a+1; Dir.path{a}='/media/DataMOBsRAID/ProjetBreathDeltaFeedback/Mice293-294-296/20151207/Mouse296/Breath-Mouse-296-07122015'; % Mouse 296 - Day 1
    a=a+1; Dir.path{a}='/media/DataMOBsRAID/ProjetBreathDeltaFeedback/Mice293-294-296/20151209/Mouse293/Breath-Mouse-293-09122015'; % Mouse 293 - Day 3
    a=a+1; Dir.path{a}='/media/DataMOBsRAID/ProjetBreathDeltaFeedback/Mice293-294-296/20151209/Mouse296/Breath-Mouse-296-09122015'; % Mouse 296 - Day 3
    a=a+1; Dir.path{a}='/media/DataMOBsRAID/ProjetBreathDeltaFeedback/Mice293-294-296/20151211/Mouse293/Breath-Mouse-293-11122015'; % Mouse 293 - Day 4
    a=a+1; Dir.path{a}='/media/DataMOBsRAID/ProjetBreathDeltaFeedback/Mice293-294-296/20151211/Mouse294/Breath-Mouse-294-11122015'; % Mouse 294 - Day 3
    
    a=a+1; Dir.path{a}='/media/DataMOBsRAID/ProjetBreathDeltaFeedback/Mice328-330/20160322/Breath-Mouse-328-22032016'; % Mouse 328 - Day 1
    a=a+1; Dir.path{a}='/media/DataMOBsRAID/ProjetBreathDeltaFeedback/Mice328-330/20160325/Breath-Mouse-328-25032016'; % Mouse 328 - Day 2
    a=a+1; Dir.path{a}='/media/DataMOBsRAID/ProjetBreathDeltaFeedback/Mice328-330/20160401/Mouse328/Breath-Mouse-328-01042016'; % Mouse 328 - Day 4
    a=a+1; Dir.path{a}='/media/DataMOBsRAID/ProjetBreathDeltaFeedback/Mice328-330/20160401/Mouse330/Breath-Mouse-330-01042016'; % Mouse 330 - Day 2
    a=a+1; Dir.path{a}='/media/DataMOBsRAID/ProjetBreathDeltaFeedback/Mice328-330/20160404/Mouse328/Breath-Mouse-328-04042016'; % Mouse 328 - Day 5
    a=a+1; Dir.path{a}='/media/DataMOBsRAID/ProjetBreathDeltaFeedback/Mice328-330/20160404/Mouse330/Breath-Mouse-330-04042016'; % Mouse 330 - Day 3
    a=a+1; Dir.path{a}='/media/DataMOBsRAID/ProjetBreathDeltaFeedback/Mice328-330/20160408/Mouse330/Breath-Mouse-330-08042016'; % Mouse 330 - Day 4
    
end


%% Random condition
a=0;
if strcmpi(experiment,'RdmTone')
    a=a+1; Dir.path{a}='/media/DataMOBsRAID/ProjetBreathDeltaFeedback/Mice243-244/20150417/Breath-Mouse-243-244-17042015/Mouse244'; % 17-04-2015 > random tone effect  - Mouse 244 (delay 200ms!! of M243 detection)
    Dir.delay{a}=0.2;
    
    a=a+1; Dir.path{a}='/media/DataMOBsRAID/ProjetBreathDeltaFeedback/Mice251-252/20150602/Breath-Mouse-251-252-02062015/Mouse252'; % 02-06-2015 > random tone effect  - Mouse 252 (delay 140ms!! of M251 detection)
    Dir.delay{a}=0.14;
    
    a=a+1; Dir.path{a}='/media/DataMOBsRAID/ProjetBreathDeltaFeedback/Mice293-294-296/20151227/Mouse296/Breath-Mouse-296-27122015'; % 27-12-2015 > random tone effect  - Mouse 296 (delay 140ms!! of M294 detection)
    Dir.delay{a}=0.14;
    a=a+1; Dir.path{a}='/media/DataMOBsRAID/ProjetBreathDeltaFeedback/Mice293-294-296/20151228/Mouse293/Breath-Mouse-293-28122015'; % 28-12-2015 > random tone effect  - Mouse 293 (delay 140ms!! of M296 detection)
    Dir.delay{a}=0.14;
    a=a+1; Dir.path{a}='/media/DataMOBsRAID/ProjetBreathDeltaFeedback/Mice293-294-296/20151228/Mouse294/Breath-Mouse-294-28122015'; % 28-12-2015 > random tone effect  - Mouse 294 (delay 140ms!! of M296 detection)
    Dir.delay{a}=0.14;
    a=a+1; Dir.path{a}='/media/DataMOBsRAID/ProjetBreathDeltaFeedback/Mice293-294-296/20160104/Mouse294/Breath-Mouse-294-04012016'; % 04-01-2016 > random tone effect  - Mouse 294 (delay 140ms!! of M293 detection)
    Dir.delay{a}=0.14;
    a=a+1; Dir.path{a}='/media/DataMOBsRAID/ProjetBreathDeltaFeedback/Mice293-294-296/20160104/Mouse296/Breath-Mouse-296-04012016'; % 04-01-2016 > random tone effect  - Mouse 296 (delay 140ms!! of M293 detection)
    Dir.delay{a}=0.14;
    a=a+1; Dir.path{a}='/media/DataMOBsRAID/ProjetBreathDeltaFeedback/Mice293-294-296/20160215/Mouse293/Breath-Mouse-293-15022016';  % 15-02-2016 > random tone effect - Mouse 293 (delay 140ms!! of M294 detection)
    Dir.delay{a}=0.14;
    a=a+1; Dir.path{a}='/media/DataMOBsRAID/ProjetBreathDeltaFeedback/Mice293-294-296/20160216/Mouse294/Breath-Mouse-294-16022016';  % 16-02-2016 > random tone effect - Mouse 294 (delay 140ms!! of M293 detection)
    Dir.delay{a}=0.14;
    a=a+1; Dir.path{a}='/media/DataMOBsRAID/ProjetBreathDeltaFeedback/Mice293-294-296/20160217/Mouse293/Breath-Mouse-293-17022016';  % 17-02-2016 > random tone effect - Mouse 293 (delay 320ms!! of M294 detection)
    Dir.delay{a}=0.32;
    a=a+1; Dir.path{a}='/media/DataMOBsRAID/ProjetBreathDeltaFeedback/Mice293-294-296/20160223/Mouse294/Breath-Mouse-294-23022016';  % 23-02-2016 > random tone effect - Mouse 294 (delay 320ms!! of M293 detection)
    Dir.delay{a}=0.32;
    a=a+1; Dir.path{a}='/media/DataMOBsRAID/ProjetBreathDeltaFeedback/Mice293-294-296/20160224/Mouse293/Breath-Mouse-293-24022016';  % 24-02-2016 > random tone effect - Mouse 293 (delay 490ms!! of M294 detection)
    Dir.delay{a}=0.49;
    
    
    a=a+1; Dir.path{a}='/media/DataMOBsRAID/ProjetBreathDeltaFeedback/Mice328-330/20160421/Mouse330/Breath-Mouse-330-21042016'; % 21-04-2016 > random tone effect  - Mouse 330 (delay 0ms!! of M328 detection)
    Dir.delay{a}=0;
    a=a+1; Dir.path{a}='/media/DataMOBsRAID/ProjetBreathDeltaFeedback/Mice328-330/20160502/Mouse328/Breath-Mouse-328-02052016'; % 02-05-2016 > random tone effect  - Mouse 328 (delay 0ms!! of M330 detection)
    Dir.delay{a}=0;
    a=a+1; Dir.path{a}='/media/DataMOBsRAID/ProjetBreathDeltaFeedback/Mice328-330/20160518/Mouse328/Breath-Mouse-328-18052016'; % 18-05-2016 > random tone effect  - Mouse 328 (delay 0ms!! of M330 detection)
    Dir.delay{a}=0; 
    a=a+1; Dir.path{a}='/media/DataMOBsRAID/ProjetBreathDeltaFeedback/Mice328-330/20160523/Mouse330/Breath-Mouse-330-23052016'; % 23-05-2016 > random tone effect  - Mouse 330 (delay 0ms!! of M328 detection)
    Dir.delay{a}=0;
    a=a+1; Dir.path{a}='/media/DataMOBsRAID/ProjetBreathDeltaFeedback/Mice328-330/20160614/Mouse328/Breath-Mouse-328-14062016'; % 14-06-2016 > random tone effect  - Mouse 328 (delay 0ms!! of M330 detection)
    Dir.delay{a}=0;
    
end  


%% DeltaTone condition

a=0;
if strcmpi(experiment,'DeltaT0')
    
    a=a+1; Dir.path{a}='/media/DataMOBsRAID/ProjetBreathDeltaFeedback/Mice328-330/20160421/Mouse328/Breath-Mouse-328-21042016'; % 21-04-2016 > delay 0ms - Mouse 328
    Dir.delay{a}=0;
    a=a+1; Dir.path{a}='/media/DataMOBsRAID/ProjetBreathDeltaFeedback/Mice328-330/20160502/Mouse330/Breath-Mouse-330-02052016'; % 02-05-2016 > delay 0ms - Mouse 330
    Dir.delay{a}=0;
    a=a+1; Dir.path{a}='/media/DataMOBsRAID/ProjetBreathDeltaFeedback/Mice328-330/20160517/Mouse328/Breath-Mouse-328-17052016'; % 17-05-2016 > delay 0ms - Mouse 328
    Dir.delay{a}=0;
    a=a+1; Dir.path{a}='/media/DataMOBsRAID/ProjetBreathDeltaFeedback/Mice328-330/20160518/Mouse330/Breath-Mouse-330-18052016'; % 18-05-2016 > delay 0ms - Mouse 330
    Dir.delay{a}=0;
    a=a+1; Dir.path{a}='/media/DataMOBsRAID/ProjetBreathDeltaFeedback/Mice328-330/20160523/Mouse328/Breath-Mouse-328-23052016'; % 23-05-2016 > delay 0ms - Mouse 328
    Dir.delay{a}=0;
    a=a+1; Dir.path{a}='/media/DataMOBsRAID/ProjetBreathDeltaFeedback/Mice328-330/20160614/Mouse330/Breath-Mouse-330-14062016'; % 14-06-2016 > delay 0ms - Mouse 330
    Dir.delay{a}=0;
end

a=0;
if strcmpi(experiment,'DeltaT140')
    a=a+1; Dir.path{a}='/media/DataMOBsRAID/ProjetBreathDeltaFeedback/Mice243-244/20150421/Breath-Mouse-243-21042015';               % 21-04-2015 > delay 140ms - Mouse 243
    Dir.delay{a}=0.14;
    a=a+1; Dir.path{a}='/media/DataMOBsRAID/ProjetBreathDeltaFeedback/Mice243-244/20150422/Breath-Mouse-244-22042015';               % 22-04-2015 > delay 140ms - Mouse 244
    Dir.delay{a}=0.14;
    a=a+1; Dir.path{a}='/media/DataMOBsRAID/ProjetBreathDeltaFeedback/Mice251-252/20150614/Breath-Mouse-251-14062015';               % 14-06-2015 > delay 140ms - Mouse 251
    Dir.delay{a}=0.14;
    a=a+1; Dir.path{a}='/media/DataMOBsRAID/ProjetBreathDeltaFeedback/Mice293-294-296/20160215/Mouse294/Breath-Mouse-294-15022016'; % 15-02-2016 > delay 140ms - Mouse 294
    Dir.delay{a}=0.14;
    a=a+1; Dir.path{a}='/media/DataMOBsRAID/ProjetBreathDeltaFeedback/Mice293-294-296/20160216/Mouse293/Breath-Mouse-293-16022016'; % 16-02-2016 > > delay 140ms - Mouse 293
    Dir.delay{a}=0.14;
    
end

a=0;
if strcmpi(experiment,'DeltaT200')
    a=a+1; Dir.path{a}='/media/DataMOBsRAID/ProjetBreathDeltaFeedback/Mice243-244/20150417/Breath-Mouse-243-244-17042015/Mouse243';  % 17-04-2015 > delay 200ms - Mouse 243
    Dir.delay{a}=0.2;
end

a=0;
if strcmpi(experiment,'DeltaT320') 
    a=a+1; Dir.path{a}='/media/DataMOBsRAID/ProjetBreathDeltaFeedback/Mice243-244/20150424/Breath-Mouse-244-24042015';               % 24-04-2015 > delay 320ms - Mouse 244
    Dir.delay{a}=0.32;
    a=a+1; Dir.path{a}='/media/DataMOBsRAID/ProjetBreathDeltaFeedback/Mice251-252/20150617/Breath-Mouse-251-17062015';               % 17-06-2015 > delay 320ms - Mouse 251
    Dir.delay{a}=0.32;
    a=a+1; Dir.path{a}='/media/DataMOBsRAID/ProjetBreathDeltaFeedback/Mice293-294-296/20160217/Mouse294/Breath-Mouse-294-17022016'; % 17-02-2016 > delay 320ms  - Mouse 294 
    Dir.delay{a}=0.32;
    a=a+1; Dir.path{a}='/media/DataMOBsRAID/ProjetBreathDeltaFeedback/Mice293-294-296/20160223/Mouse293/Breath-Mouse-293-23022016'; % 23-02-2016 > delay 320ms  - Mouse 293
    Dir.delay{a}=0.32;
    
end

a=0;
if strcmpi(experiment,'DeltaT490')
    a=a+1; Dir.path{a}='/media/DataMOBsRAID/ProjetBreathDeltaFeedback/Mice243-244/20150425/Breath-Mouse-243-25042015';               % 25-04-2015 > delay 490ms - Mouse 243
    Dir.delay{a}=0.49;
    a=a+1; Dir.path{a}='/media/DataMOBsRAID/ProjetBreathDeltaFeedback/Mice243-244/20150426/Breath-Mouse-244-26042015';               % 26-04-2015 > delay 490ms - Mouse 244
    Dir.delay{a}=0.49;
    a=a+1; Dir.path{a}='/media/DataMOBsRAID/ProjetBreathDeltaFeedback/Mice251-252/20150619/Breath-Mouse-251-19062015';               % 19-06-2015 > delay 490ms - Mouse 251
    Dir.delay{a}=0.49;
    a=a+1; Dir.path{a}='/media/DataMOBsRAID/ProjetBreathDeltaFeedback/Mice293-294-296/20160224/Mouse294/Breath-Mouse-294-24022016'; % 24-02-2016 > delay 490ms  - Mouse 294
    Dir.delay{a}=0.49;
    
end


%% If ALL experiments
if strcmpi(experiment,'all')
    Dir1 = PathForExperimentsDeltaLongSleep('Basal');
    for p=1:length(Dir1.path)
        Dir1.delay{p}=-1;
    end
    Dir2=PathForExperimentsDeltaLongSleep('RdmTone');
    Dir3=PathForExperimentsDeltaLongSleep('DeltaToneAll');
    Dir = MergePathForExperiment(Dir2,Dir3);
    Dir = MergePathForExperiment(Dir1,Dir);
    
elseif strcmpi(experiment,'DeltaToneAll')
    Dir1 = PathForExperimentsDeltaLongSleep('DeltaT0');
    Dir2 = PathForExperimentsDeltaLongSleep('DeltaT140');
    Dir3 = PathForExperimentsDeltaLongSleep('DeltaT200');
    Dir4 = PathForExperimentsDeltaLongSleep('DeltaT320');
    Dir5 = PathForExperimentsDeltaLongSleep('DeltaT490');
    
    Dir = MergePathForExperiment(Dir1,Dir2);
    %Dir = MergePathForExperiment(Dir,Dir3);
    Dir = MergePathForExperiment(Dir,Dir4);
    Dir = MergePathForExperiment(Dir,Dir5);
    
    for i=1:length(Dir.path)
       Dir.manipe{i}='DeltaToneAll'; 
    end
    
else
    %% names
    for i=1:length(Dir.path)
        Dir.manipe{i}=experiment;
        if Dir.path{i}(end-8)=='/'
        Dir.name{i}=Dir.path{i}(end-7:end);
        else
        Dir.name{i}=Dir.path{i}(strfind(Dir.path{i},'Mouse'):strfind(Dir.path{i},'Mouse')+8);
        Dir.name{i}(Dir.name{i}=='-')=[];
        Dir.name{i}(Dir.name{i}=='/')=[];
        end

    end

    %% Strain
    for i=1:length(Dir.path)
        Dir.group{i}=nan;
    end

    %% Date
    for i=1:length(Dir.path)
        ind=strfind(Dir.path{i},'2015');
        if isempty(ind)
            ind=strfind(Dir.path{i},'2016');
        end
        if isempty(ind)
            ind=strfind(Dir.path{i},'2017');
        end
        Dir.date{i} = Dir.path{i}(ind(end)-4:ind(end)+3);
    end

end

end

