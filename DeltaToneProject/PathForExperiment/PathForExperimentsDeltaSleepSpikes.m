function Dir=PathForExperimentsDeltaSleepSpikes(experiment)

%
% see PathForExperimentsDeltaLongSleep PathForExperimentsDeltaWavesTone
%

% input:
% name of the experiment.
% BASAL, RdmTone, DeltaT140, DeltaT200, DeltaT320, DeltaT480, DeltaToneAll
% 
% possible choices: 'Basal', 
%
% output
% Dir = structure containing paths / names / strains / name of the
% experiment (manipe) / correction for amplification (default=1000)
%
% example:
% Dir=PathForExperimentsDeltaSleepSpikes('Basal');
% Dir=PathForExperimentsDeltaSleepSpikes('DeltaT140');
% Dir=PathForExperimentsDeltaSleepSpikes('DeltaToneAll');
%
% merge two Dir:
% Dir=MergePathForExperiment(Dir1,Dir2);
%
%   restrict Dir to mice or group:
% Dir=RestrictPathForExperiment(Dir,'nMice',[245 246])
% Dir=RestrictPathForExperiment(Dir,'Group',{'OBX','hemiOBX'})
% Dir=RestrictPathForExperiment(Dir,'Group','OBX')



%% strains inputs
MICEgroups = {'CTRL'};
CTRL = {'Mouse243' 'Mouse244' 'Mouse403' 'Mouse451'};

a=0;
if strcmpi(experiment,'Prelim')
    a=a+1; Dir.path{a}='/media/DataMOBsRAID/ProjetBreathDeltaFeedback/Mice243-244/20150220/Breath-Mouse-244-20022015'; % Mouse 243 - Day 0
    
    a=a+1; Dir.path{a}='/media/DataMOBsRAID/ProjetBreathDeltaFeedback/Mice243-244/20150222/Breath-Mouse-243-244-22022015/Mouse243'; % Mouse 243 - Day 1 - Noise on the ref at the beginning
    a=a+1; Dir.path{a}='/media/DataMOBsRAID/ProjetBreathDeltaFeedback/Mice243-244/20150222/Breath-Mouse-243-244-22022015/Mouse244'; % Mouse 244 - Day 1
    a=a+1; Dir.path{a}='/media/DataMOBsRAID/ProjetBreathDeltaFeedback/Mice243-244/20150223/Breath-Mouse-243-244-23022015/Mouse243'; % Mouse 243 - ??
    a=a+1; Dir.path{a}='/media/DataMOBsRAID/ProjetBreathDeltaFeedback/Mice243-244/20150223/Breath-Mouse-243-244-23022015/Mouse244'; % Mouse 244 - ??
end


a=0;
if strcmpi(experiment,'Basal')
    % attention behavResources a refaire
    
    a=a+1; Dir.path{a}='/media/DataMOBsRAID/ProjetBreathDeltaFeedback/Mice243-244/20150329/Breath-Mouse-243-244-29032015/Mouse243'; % Mouse 243 - Day 2
    a=a+1; Dir.path{a}='/media/DataMOBsRAID/ProjetBreathDeltaFeedback/Mice243-244/20150329/Breath-Mouse-243-244-29032015/Mouse244'; % Mouse 244 - Day 2
    a=a+1; Dir.path{a}='/media/DataMOBsRAID/ProjetBreathDeltaFeedback/Mice243-244/20150331/Breath-Mouse-243-244-31032015/Mouse243'; % Mouse 243 - Day 3
    a=a+1; Dir.path{a}='/media/DataMOBsRAID/ProjetBreathDeltaFeedback/Mice243-244/20150331/Breath-Mouse-243-244-31032015/Mouse244'; % Mouse 244 - Day 3
    a=a+1; Dir.path{a}='/media/DataMOBsRAID/ProjetBreathDeltaFeedback/Mice243-244/20150401/Breath-Mouse-243-244-01042015/Mouse243'; % Mouse 243 - Day 4
    a=a+1; Dir.path{a}='/media/DataMOBsRAID/ProjetBreathDeltaFeedback/Mice243-244/20150401/Breath-Mouse-243-244-01042015/Mouse244'; % Mouse 244 - Day 4
    a=a+1; Dir.path{a}='/media/DataMOBsRAID/ProjetBreathDeltaFeedback/Mice243-244/20150409/Breath-Mouse-243-244-09042015/Mouse243'; % Mouse 243 - Day 5
    a=a+1; Dir.path{a}='/media/DataMOBsRAID/ProjetBreathDeltaFeedback/Mice243-244/20150409/Breath-Mouse-243-244-09042015/Mouse244'; % Mouse 244 - Day 5
    a=a+1; Dir.path{a}='/media/nas4/ProjetBreathDeltaFeedback/Mouse873/20190418/'; % Mouse 873 - Day 1
    
end


a=0;
if strcmpi(experiment,'RdmTone')
    a=a+1; Dir.path{a}='/media/DataMOBsRAID/ProjetBreathDeltaFeedback/Mice243-244/20150416/Breath-Mouse-243-244-16042015/Mouse243';  % 16-04-2015 > random tone effect  - Mouse 243 (delay 200ms!! of M244 detection)
    Dir.delay{a}=0.2;
    a=a+1; Dir.path{a}='/media/DataMOBsRAID/ProjetBreathDeltaFeedback/Mice243-244/20150417/Breath-Mouse-243-244-17042015/Mouse244';  % 17-04-2015 > random tone effect  - Mouse 244 (delay 200ms!! of M243 detection)
    Dir.delay{a}=0.2;
    
%     a=a+1; Dir.path{a}='/media/DataMOBsRAID/ProjetBreathDeltaFeedback/Mice403-451/20170130/Breath-Mouse-403-451-30012017/Mouse451';
%     Dir.delay{a}=0;
    a=a+1; Dir.path{a}='/media/DataMOBsRAID/ProjetBreathDeltaFeedback/Mice403-451/20170215/Breath-Mouse-403-451-15022017/Mouse403';
    Dir.delay{a}=0;
    a=a+1; Dir.path{a}='/media/DataMOBsRAID/ProjetBreathDeltaFeedback/Mice403-451/20170213/Breath-Mouse-403-451-13022017/Mouse451';
    Dir.delay{a}=0;
    
end    

a=0;
if strcmpi(experiment,'DeltaT0')
%     a=a+1; Dir.path{a}='/media/DataMOBsRAID/ProjetBreathDeltaFeedback/Mice403-451/20170130/Breath-Mouse-403-451-30012017/Mouse403'; % 30-01-2017 > delay 0 ms - Mouse 403
%     Dir.delay{a}=0; 
    a=a+1; Dir.path{a}='/media/DataMOBsRAID/ProjetBreathDeltaFeedback/Mice403-451/20170213/Breath-Mouse-403-451-13022017/Mouse403'; % 13-02-2017 > delay 0 ms - Mouse 403
    Dir.delay{a}=0;
    a=a+1; Dir.path{a}='/media/DataMOBsRAID/ProjetBreathDeltaFeedback/Mice403-451/20170215/Breath-Mouse-403-451-15022017/Mouse451'; % 15-02-2017 > delay 0 ms - Mouse 451
    Dir.delay{a}=0;
    
end

a=0;
if strcmpi(experiment,'DeltaT140')
    a=a+1; Dir.path{a}='/media/DataMOBsRAID/ProjetBreathDeltaFeedback/Mice243-244/20150421/Breath-Mouse-243-21042015';               % 21-04-2015 > delay 140ms - Mouse 243
    Dir.delay{a}=0.14;
    a=a+1; Dir.path{a}='/media/DataMOBsRAID/ProjetBreathDeltaFeedback/Mice243-244/20150422/Breath-Mouse-244-22042015';               % 22-04-2015 > delay 140ms - Mouse 244
    Dir.delay{a}=0.14;
end

a=0;
if strcmpi(experiment,'DeltaT200')
    a=a+1; Dir.path{a}='/media/DataMOBsRAID/ProjetBreathDeltaFeedback/Mice243-244/20150417/Breath-Mouse-243-244-17042015/Mouse243';  % 17-04-2015 > delay 200ms - Mouse 243
    Dir.delay{a}=0.2;
    a=a+1; Dir.path{a}='/media/DataMOBsRAID/ProjetBreathDeltaFeedback/Mice243-244/20150416/Breath-Mouse-243-244-16042015/Mouse244';  % 16-04-2015 > delay 200ms - Mouse 244
    Dir.delay{a}=0.2;
end

a=0;
if strcmpi(experiment,'DeltaT320') 
    a=a+1; Dir.path{a}='/media/DataMOBsRAID/ProjetBreathDeltaFeedback/Mice243-244/20150423/Breath-Mouse-243-23042015';               % 23-04-2015 > delay 320ms - Mouse 243
    Dir.delay{a}=0.32;
    a=a+1; Dir.path{a}='/media/DataMOBsRAID/ProjetBreathDeltaFeedback/Mice243-244/20150424/Breath-Mouse-244-24042015';               % 24-04-2015 > delay 320ms - Mouse 244
    Dir.delay{a}=0.32;
end

a=0;
if strcmpi(experiment,'DeltaT490')
    a=a+1; Dir.path{a}='/media/DataMOBsRAID/ProjetBreathDeltaFeedback/Mice243-244/20150425/Breath-Mouse-243-25042015';               % 25-04-2015 > delay 480ms - Mouse 243
    Dir.delay{a}=0.49;
    a=a+1; Dir.path{a}='/media/DataMOBsRAID/ProjetBreathDeltaFeedback/Mice243-244/20150426/Breath-Mouse-244-26042015';               % 26-04-2015 > delay 480ms - Mouse 244
    Dir.delay{a}=0.49;
end


%% If ALL experiments
if strcmpi(experiment,'all')
    Dir1 = PathForExperimentsDeltaSleepSpikes('Basal');
    for p=1:length(Dir1.path)
        Dir1.delay{p}=-1;
    end
    Dir2=PathForExperimentsDeltaSleepSpikes('RdmTone');
    Dir3=PathForExperimentsDeltaSleepSpikes('DeltaToneAll');
    Dir = MergePathForExperiment(Dir2,Dir3);
    Dir = MergePathForExperiment(Dir1,Dir);
    
elseif strcmpi(experiment,'DeltaToneAll')
    Dir1 = PathForExperimentsDeltaSleepSpikes('DeltaT140');
    Dir2 = PathForExperimentsDeltaSleepSpikes('DeltaT320');
    Dir3 = PathForExperimentsDeltaSleepSpikes('DeltaT490');
    
    Dir4 = PathForExperimentsDeltaSleepSpikes('DeltaT200');
    Dir5 = PathForExperimentsDeltaSleepSpikes('DeltaT0');
    
    Dir = MergePathForExperiment(Dir1,Dir2);
    Dir = MergePathForExperiment(Dir,Dir3);
    Dir = MergePathForExperiment(Dir,Dir4);
    Dir = MergePathForExperiment(Dir,Dir5);
    
    for i=1:length(Dir.path)
       Dir.manipe{i}='DeltaToneAll'; 
    end
    
elseif strcmpi(experiment,'DeltaTone')
    Dir1 = PathForExperimentsDeltaSleepSpikes('DeltaT140');
    Dir2 = PathForExperimentsDeltaSleepSpikes('DeltaT320');
    Dir3 = PathForExperimentsDeltaSleepSpikes('DeltaT490');
    
    Dir4 = PathForExperimentsDeltaSleepSpikes('DeltaT200');
    Dir5 = PathForExperimentsDeltaSleepSpikes('DeltaT0');
    
    Dir = MergePathForExperiment(Dir1,Dir2);
    Dir = MergePathForExperiment(Dir,Dir3);
    Dir = MergePathForExperiment(Dir,Dir4);
    Dir = MergePathForExperiment(Dir,Dir5);
    
    for i=1:length(Dir.path)
       Dir.manipe{i}='DeltaTone'; 
    end
    
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





