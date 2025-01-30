function Dir=PathForExperimentsDeltaSleepNew(experiment)

% input:
% name of the experiment.
% BASAL, RdmTone, DeltaT140, DeltaT200, DeltaT320, DeltaT480, DeltaT3delays
% 
% possible choices: 'DPCPX' 'LPS' 'BASAL' 'CANAB' 'PLETHYSMO'
% 'PLETHYSMO_thy1' 'SELECT_SB'
%
% output
% Dir = structure containing paths / names / strains / name of the
% experiment (manipe) / correction for amplification (default=1000)
%
% example:
% Dir=PathForExperimentsML('BASAL');
%
% merge two Dir:
% Dir=MergePathForExperiment(Dir1,Dir2);
%
%   restrict Dir to mice or group:
% Dir=RestrictPathForExperiment(Dir,'nMice',[245 246])
% Dir=RestrictPathForExperiment(Dir,'Group',{'OBX','hemiOBX'})
% Dir=RestrictPathForExperiment(Dir,'Group','OBX')
%
% similar functions:
% PathForExperimentFEAR.m
% PathForExperimentsBULB.m
% PathForExperimentsKB.m PathForExperimentsKBnew.m 
% PathForExperimentsML.m 

%% strains inputs
MICEgroups={'CTRL'};
CTRL={'Mouse243' 'Mouse244' 'Mouse251' 'Mouse252'};

%% Path
a=0;
I_CA=[];
if strcmpi(experiment,'BASAL')
    % attention behavResources a refaire
    a=a+1; Dir.path{a}='/media/DataMOBsRAID/ProjetBreathDeltaFeedback/Mice243-244/20150222/Breath-Mouse-243-244-22022015/Mouse243'; % Mouse 243 - Day 1
    a=a+1; Dir.path{a}='/media/DataMOBsRAID/ProjetBreathDeltaFeedback/Mice243-244/20150222/Breath-Mouse-243-244-22022015/Mouse244'; % Mouse 244 - Day 1
    
    a=a+1; Dir.path{a}='/media/DataMOBsRAID/ProjetBreathDeltaFeedback/Mice251-252/20150518/Breath-Mouse-251-252-18052015/Mouse251'; % Mouse 251 - Day 1
    a=a+1; Dir.path{a}='/media/DataMOBsRAID/ProjetBreathDeltaFeedback/Mice251-252/20150518/Breath-Mouse-251-252-18052015/Mouse252'; % Mouse 252 - Day 1
    
    a=a+1; Dir.path{a}='/media/DataMOBsRAID/ProjetBreathDeltaFeedback/Mice243-244/20150329/Breath-Mouse-243-244-29032015/Mouse243'; % Mouse 243 - Day 2
    a=a+1; Dir.path{a}='/media/DataMOBsRAID/ProjetBreathDeltaFeedback/Mice243-244/20150329/Breath-Mouse-243-244-29032015/Mouse244'; % Mouse 244 - Day 2
    a=a+1; Dir.path{a}='/media/DataMOBsRAID/ProjetBreathDeltaFeedback/Mice251-252/20150519/Breath-Mouse-251-252-19052015/Mouse251';            % Mouse 251 - Day 2
    a=a+1; Dir.path{a}='/media/DataMOBsRAID/ProjetBreathDeltaFeedback/Mice251-252/20150519/Breath-Mouse-251-252-19052015/Mouse252';            % Mouse 252 - Day 2
    
    a=a+1; Dir.path{a}='/media/DataMOBsRAID/ProjetBreathDeltaFeedback/Mice243-244/20150331/Breath-Mouse-243-244-31032015/Mouse243'; % Mouse 243 - Day 3
    a=a+1; Dir.path{a}='/media/DataMOBsRAID/ProjetBreathDeltaFeedback/Mice243-244/20150331/Breath-Mouse-243-244-31032015/Mouse244'; % Mouse 244 - Day 3
    a=a+1; Dir.path{a}='/media/DataMOBsRAID/ProjetBreathDeltaFeedback/Mice251-252/20150520/Breath-Mouse-251-252-20052015/Mouse251';            % Mouse 251 - Day 3
    a=a+1; Dir.path{a}='/media/DataMOBsRAID/ProjetBreathDeltaFeedback/Mice251-252/20150520/Breath-Mouse-251-252-20052015/Mouse252';            % Mouse 252 - Day 3
    
    
    a=a+1; Dir.path{a}='/media/DataMOBsRAID/ProjetBreathDeltaFeedback/Mice243-244/20150401/Breath-Mouse-243-244-01042015/Mouse243'; % Mouse 243 - Day 4
    a=a+1; Dir.path{a}='/media/DataMOBsRAID/ProjetBreathDeltaFeedback/Mice243-244/20150401/Breath-Mouse-243-244-01042015/Mouse244'; % Mouse 244 - Day 4
    a=a+1; Dir.path{a}='/media/DataMOBsRAID/ProjetBreathDeltaFeedback/Mice251-252/20150521/Breath-Mouse-251-252-21052015/Mouse251'; % Mouse 251 - Day 4
    a=a+1; Dir.path{a}='/media/DataMOBsRAID/ProjetBreathDeltaFeedback/Mice251-252/20150521/Breath-Mouse-251-252-21052015/Mouse252'; % Mouse 252 - Day 4
    
    a=a+1; Dir.path{a}='/media/DataMOBsRAID/ProjetBreathDeltaFeedback/Mice243-244/20150409/Breath-Mouse-243-244-09042015/Mouse243'; % Mouse 243 - Day 5
    a=a+1; Dir.path{a}='/media/DataMOBsRAID/ProjetBreathDeltaFeedback/Mice243-244/20150409/Breath-Mouse-243-244-09042015/Mouse244'; % Mouse 244 - Day 5
    a=a+1; Dir.path{a}='/media/DataMOBsRAID/ProjetBreathDeltaFeedback/Mice251-252/20150522/Breath-Mouse-251-252-22052015/Mouse251'; % Mouse 251 - Day 5
    a=a+1; Dir.path{a}='/media/DataMOBsRAID/ProjetBreathDeltaFeedback/Mice251-252/20150522/Breath-Mouse-251-252-22052015/Mouse252'; % Mouse 252 - Day 5
    
    a=a+1; Dir.path{a}='/media/DataMOBsRAID/ProjetBreathDeltaFeedback/Mice293-294-296/20151207/Mouse293/Breath-Mouse-293-07122015'; % Mouse 293 - Day 1
    a=a+1; Dir.path{a}='/media/DataMOBsRAID/ProjetBreathDeltaFeedback/Mice293-294-296/20151207/Mouse294/Breath-Mouse-294-07122015'; % Mouse 294 - Day 1
    a=a+1; Dir.path{a}='/media/DataMOBsRAID/ProjetBreathDeltaFeedback/Mice293-294-296/20151207/Mouse296/Breath-Mouse-296-07122015'; % Mouse 296 - Day 1
    
    a=a+1; Dir.path{a}='/media/DataMOBsRAID/ProjetBreathDeltaFeedback/Mice293-294-296/20151208/Mouse293/Breath-Mouse-293-08122015'; % Mouse 293 - Day 2
    a=a+1; Dir.path{a}='/media/DataMOBsRAID/ProjetBreathDeltaFeedback/Mice293-294-296/20151208/Mouse294/Breath-Mouse-294-08122015'; % Mouse 294 - Day 2
    a=a+1; Dir.path{a}='/media/DataMOBsRAID/ProjetBreathDeltaFeedback/Mice293-294-296/20151208/Mouse296/Breath-Mouse-296-08122015'; % Mouse 296 - Day 2
    
    a=a+1; Dir.path{a}='/media/DataMOBsRAID/ProjetBreathDeltaFeedback/Mice293-294-296/20151209/Mouse293/Breath-Mouse-293-09122015'; % Mouse 293 - Day 3
    a=a+1; Dir.path{a}='/media/DataMOBsRAID/ProjetBreathDeltaFeedback/Mice293-294-296/20151209/Mouse296/Breath-Mouse-296-09122015'; % Mouse 296 - Day 3
    
    a=a+1; Dir.path{a}='/media/DataMOBsRAID/ProjetBreathDeltaFeedback/Mice293-294-296/20151211/Mouse293/Breath-Mouse-293-11122015'; % Mouse 293 - Day 4
    a=a+1; Dir.path{a}='/media/DataMOBsRAID/ProjetBreathDeltaFeedback/Mice293-294-296/20151211/Mouse294/Breath-Mouse-294-11122015'; % Mouse 294 - Day 3
    a=a+1; Dir.path{a}='/media/DataMOBsRAID/ProjetBreathDeltaFeedback/Mice293-294-296/20151211/Mouse296/Breath-Mouse-296-11122015'; % Mouse 296 - Day 4
    
    a=a+1; Dir.path{a}='/media/DataMOBsRAID/ProjetBreathDeltaFeedback/Mice293-294-296/20151218/Mouse293/Breath-Mouse-293-18122015'; % Mouse 293 - Day 5
    a=a+1; Dir.path{a}='/media/DataMOBsRAID/ProjetBreathDeltaFeedback/Mice293-294-296/20151218/Mouse294/Breath-Mouse-294-18122015'; % Mouse 294 - Day 4
    a=a+1; Dir.path{a}='/media/DataMOBsRAID/ProjetBreathDeltaFeedback/Mice293-294-296/20151218/Mouse296/Breath-Mouse-296-18122015'; % Mouse 296 - Day 5
    
    
    
end

a=0;
I_CA=[];
if strcmpi(experiment,'RdmTone')
    
   a=a+1; Dir.path{a}='/media/DataMOBsRAID/ProjetBreathDeltaFeedback/Mice243-244/20150416/Breath-Mouse-243-244-16042015/Mouse243';  % 16-04-2015 > random tone effect  - Mouse 243 (delay 200ms!! of M244 detection)
   Dir.delay{a}=0.2;
    a=a+1; Dir.path{a}='/media/DataMOBsRAID/ProjetBreathDeltaFeedback/Mice243-244/20150417/Breath-Mouse-243-244-17042015/Mouse244';  % 17-04-2015 > random tone effect  - Mouse 244 (delay 200ms!! of M243 detection)
    Dir.delay{a}=0.2;
    a=a+1; Dir.path{a}='/media/DataMOBsRAID/ProjetBreathDeltaFeedback/Mice251-252/20150603/Breath-Mouse-252-251-03062015/Mouse251';  % 03-06-2015 > random tone effect  - Mouse 251 (delay 140ms!! of M252 detection)
    Dir.delay{a}=0.14;
    a=a+1; Dir.path{a}='/media/DataMOBsRAID/ProjetBreathDeltaFeedback/Mice251-252/20150602/Breath-Mouse-251-252-02062015/Mouse252';  % 02-06-2015 > random tone effect  - Mouse 252 (delay 140ms!! of M251 detection)
    Dir.delay{a}=0.14;
    
     a=a+1; Dir.path{a}='/media/DataMOBsRAID/ProjetBreathDeltaFeedback/Mice243-244/20150416/Breath-Mouse-243-244-16042015/Mouse243';         % 16-04-2015 > random tone effect (sound after 200ms !!!!!!) 
    Dir.delay{a}=0.14;
     a=a+1; Dir.path{a}='/media/DataMOBsRAID/ProjetBreathDeltaFeedback/Mice243-244/20150417/Breath-Mouse-243-244-17042015/Mouse244';  % 17-04-2015 > random tone effect (sound after 200ms !!!!!!) 
    Dir.delay{a}=0.2;

    a=a+1; Dir.path{a}='/media/DataMOBsRAID/ProjetBreathDeltaFeedback/Mice293-294-296/20151222/Mouse293/Breath-Mouse-293-22122015'; % Mouse 293 - Day Rdm Tone
    Dir.delay{a}=0.14;
    a=a+1; Dir.path{a}='/media/DataMOBsRAID/ProjetBreathDeltaFeedback/Mice293-294-296/20151227/Mouse296/Breath-Mouse-296-27122015'; % Mouse 296 - Day Rdm Tone
    Dir.delay{a}=0.14;
    a=a+1; Dir.path{a}='/media/DataMOBsRAID/ProjetBreathDeltaFeedback/Mice293-294-296/20151228/Mouse293/Breath-Mouse-293-28122015'; % Mouse 293 - Day Rdm Tone
    Dir.delay{a}=0.14;
    a=a+1; Dir.path{a}='/media/DataMOBsRAID/ProjetBreathDeltaFeedback/Mice293-294-296/20151228/Mouse294/Breath-Mouse-294-28122015'; % Mouse 294 - Day Rdm Tone
    Dir.delay{a}=0.14;
    a=a+1; Dir.path{a}='/media/DataMOBsRAID/ProjetBreathDeltaFeedback/Mice293-294-296/20160104/Mouse294/Breath-Mouse-294-04012016'; % Mouse 294 - Day Rdm Tone
    Dir.delay{a}=0.14;
    a=a+1; Dir.path{a}='/media/DataMOBsRAID/ProjetBreathDeltaFeedback/Mice293-294-296/20160104/Mouse296/Breath-Mouse-296-04012016'; % Mouse 296 - Day Rdm Tone
    Dir.delay{a}=0.14;

end

a=0;
I_CA=[];
if strcmpi(experiment,'DeltaTone')
    
    a=a+1; Dir.path{a}='/media/DataMOBsRAID/ProjetBreathDeltaFeedback/Mice243-244/20150421/Breath-Mouse-243-21042015';               % 21-04-2015 > delay 140ms - Mouse 243
    Dir.delay{a}=0.14;
    a=a+1; Dir.path{a}='/media/DataMOBsRAID/ProjetBreathDeltaFeedback/Mice243-244/20150422/Breath-Mouse-244-22042015';               % 22-04-2015 > delay 140ms - Mouse 244
    Dir.delay{a}=0.14;
    a=a+1; Dir.path{a}='/media/DataMOBsRAID/ProjetBreathDeltaFeedback/Mice251-252/20150614/Breath-Mouse-251-14062015';               % 14-06-2015 > delay 140ms - Mouse 251
    Dir.delay{a}=0.14;
    a=a+1; Dir.path{a}='/media/DataMOBsRAID/ProjetBreathDeltaFeedback/Mice251-252/20150603/Breath-Mouse-252-251-03062015/Mouse252';  % 03-06-2015 > delay 140ms - Mouse 252
    Dir.delay{a}=0.14;
    
    a=a+1; Dir.path{a}='/media/DataMOBsRAID/ProjetBreathDeltaFeedback/Mice243-244/20150417/Breath-Mouse-243-244-17042015/Mouse243';  % 17-04-2015 > delay 200ms - Mouse 243
    Dir.delay{a}=0.2;
    a=a+1; Dir.path{a}='/media/DataMOBsRAID/ProjetBreathDeltaFeedback/Mice243-244/20150416/Breath-Mouse-243-244-16042015/Mouse244';  % 16-04-2015 > delay 200ms
    Dir.delay{a}=0.2;
    
    a=a+1; Dir.path{a}='/media/DataMOBsRAID/ProjetBreathDeltaFeedback/Mice243-244/20150423/Breath-Mouse-243-23042015';               % 23-04-2015 > delay 320ms - Mouse 243
    Dir.delay{a}=0.32;
    a=a+1; Dir.path{a}='/media/DataMOBsRAID/ProjetBreathDeltaFeedback/Mice243-244/20150424/Breath-Mouse-244-24042015';               % 24-04-2015 > delay 320ms - Mouse 244
    Dir.delay{a}=0.32;
    a=a+1; Dir.path{a}='/media/DataMOBsRAID/ProjetBreathDeltaFeedback/Mice251-252/20150617/Breath-Mouse-251-17062015';               % 17-06-2015 > delay 320ms - Mouse 251
    Dir.delay{a}=0.32;
  a=a+1; Dir.path{a}='/media/DataMOBsRAID/ProjetBreathDeltaFeedback/Mice251-252/20150605/Breath-Mouse-252-05062015';               % 05-06-2015 > delay 320ms - Mouse 252
  Dir.delay{a}=0.32;
    
    a=a+1; Dir.path{a}='/media/DataMOBsRAID/ProjetBreathDeltaFeedback/Mice243-244/20150425/Breath-Mouse-243-25042015';               % 25-04-2015 > delay 480ms - Mouse 243
    Dir.delay{a}=0.48;
    a=a+1; Dir.path{a}='/media/DataMOBsRAID/ProjetBreathDeltaFeedback/Mice243-244/20150426/Breath-Mouse-244-26042015';               % 26-04-2015 > delay 480ms - Mouse 244
    Dir.delay{a}=0.48;
    a=a+1; Dir.path{a}='/media/DataMOBsRAID/ProjetBreathDeltaFeedback/Mice251-252/20150619/Breath-Mouse-251-19062015';               % 09-06-2015 > delay 480ms - Mouse 251
    Dir.delay{a}=0.48;
    a=a+1; Dir.path{a}='/media/DataMOBsRAID/ProjetBreathDeltaFeedback/Mice251-252/20150608/Breath-Mouse-252-08062015';               % 08-06-2015 > delay 480ms - Mouse 252
    Dir.delay{a}=0.48;
    
    a=a+1; Dir.path{a}='/media/DataMOBsRAID/ProjetBreathDeltaFeedback/Mice243-244/20150429/Breath-Mouse-243-29042015';               % 29-04-2015 > delay 3*140ms - Mouse 243
    Dir.delay{a}=0.14;
    a=a+1; Dir.path{a}='/media/DataMOBsRAID/ProjetBreathDeltaFeedback/Mice243-244/20150430/Breath-Mouse-244-30042015';               % 25-04-2015 > delay 3*140ms - Mouse 244
    Dir.delay{a}=0.14;
    a=a+1; Dir.path{a}='/media/DataMOBsRAID/ProjetBreathDeltaFeedback/Mice251-252/20150621/Breath-Mouse-251-21062015';               % 09-06-2015 > delay 3*140ms - Mouse 251
    Dir.delay{a}=0.14;
    a=a+1; Dir.path{a}='/media/DataMOBsRAID/ProjetBreathDeltaFeedback/Mice251-252/20150610/Breath-Mouse-252-10062015';               % 08-06-2015 > delay 3*140ms - Mouse 252
    Dir.delay{a}=0.14;
end



a=0;
I_CA=[];
if strcmpi(experiment,'DeltaT140')
    
    a=a+1; Dir.path{a}='/media/DataMOBsRAID/ProjetBreathDeltaFeedback/Mice243-244/20150421/Breath-Mouse-243-21042015';               % 21-04-2015 > delay 140ms - Mouse 243
    Dir.delay{a}=0.14;
    a=a+1; Dir.path{a}='/media/DataMOBsRAID/ProjetBreathDeltaFeedback/Mice243-244/20150422/Breath-Mouse-244-22042015';               % 22-04-2015 > delay 140ms - Mouse 244
    Dir.delay{a}=0.14;
    a=a+1; Dir.path{a}='/media/DataMOBsRAID/ProjetBreathDeltaFeedback/Mice251-252/20150614/Breath-Mouse-251-14062015';               % 14-06-2015 > delay 140ms - Mouse 251
    Dir.delay{a}=0.14;
    a=a+1; Dir.path{a}='/media/DataMOBsRAID/ProjetBreathDeltaFeedback/Mice251-252/20150603/Breath-Mouse-252-251-03062015/Mouse252';  % 03-06-2015 > delay 140ms - Mouse 252
    Dir.delay{a}=0.14;
end

a=0;
I_CA=[];
if strcmpi(experiment,'DeltaT200')
    
    a=a+1; Dir.path{a}='/media/DataMOBsRAID/ProjetBreathDeltaFeedback/Mice243-244/20150417/Breath-Mouse-243-244-17042015/Mouse243';  % 17-04-2015 > delay 200ms - Mouse 243
    Dir.delay{a}=0.2;
    a=a+1; Dir.path{a}='/media/DataMOBsRAID/ProjetBreathDeltaFeedback/Mice243-244/20150416/Breath-Mouse-243-244-16042015/Mouse244';  % 16-04-2015 > delay 200ms - Mouse 244
    Dir.delay{a}=0.2;
    
end

a=0;
I_CA=[];
if strcmpi(experiment,'DeltaT320')
    
    a=a+1; Dir.path{a}='/media/DataMOBsRAID/ProjetBreathDeltaFeedback/Mice243-244/20150423/Breath-Mouse-243-23042015';               % 23-04-2015 > delay 320ms - Mouse 243
    Dir.delay{a}=0.32;
    a=a+1; Dir.path{a}='/media/DataMOBsRAID/ProjetBreathDeltaFeedback/Mice243-244/20150424/Breath-Mouse-244-24042015';               % 24-04-2015 > delay 320ms - Mouse 244
    Dir.delay{a}=0.32;
    a=a+1; Dir.path{a}='/media/DataMOBsRAID/ProjetBreathDeltaFeedback/Mice251-252/20150617/Breath-Mouse-251-17062015';               % 17-06-2015 > delay 320ms - Mouse 251
    Dir.delay{a}=0.32;
    a=a+1; Dir.path{a}='/media/DataMOBsRAID/ProjetBreathDeltaFeedback/Mice251-252/20150605/Breath-Mouse-252-05062015';               % 05-06-2015 > delay 320ms - Mouse 252
    Dir.delay{a}=0.32;
end

a=0;
I_CA=[];
if strcmpi(experiment,'DeltaT480')

    a=a+1; Dir.path{a}='/media/DataMOBsRAID/ProjetBreathDeltaFeedback/Mice243-244/20150425/Breath-Mouse-243-25042015';               % 25-04-2015 > delay 480ms - Mouse 243
    Dir.delay{a}=0.48;
    a=a+1; Dir.path{a}='/media/DataMOBsRAID/ProjetBreathDeltaFeedback/Mice243-244/20150426/Breath-Mouse-244-26042015';               % 26-04-2015 > delay 480ms - Mouse 244
    Dir.delay{a}=0.48;
    a=a+1; Dir.path{a}='/media/DataMOBsRAID/ProjetBreathDeltaFeedback/Mice251-252/20150619/Breath-Mouse-251-19062015';               % 09-06-2015 > delay 480ms - Mouse 251
    Dir.delay{a}=0.48;
    a=a+1; Dir.path{a}='/media/DataMOBsRAID/ProjetBreathDeltaFeedback/Mice251-252/20150608/Breath-Mouse-252-08062015';               % 08-06-2015 > delay 480ms - Mouse 252
    Dir.delay{a}=0.48;
end

a=0;
I_CA=[];
if strcmpi(experiment,'DeltaT3delays')
    a=a+1; Dir.path{a}='/media/DataMOBsRAID/ProjetBreathDeltaFeedback/Mice243-244/20150429/Breath-Mouse-243-29042015';               % 29-04-2015 > delay 3*140ms - Mouse 243
    Dir.delay{a}=0;
    a=a+1; Dir.path{a}='/media/DataMOBsRAID/ProjetBreathDeltaFeedback/Mice243-244/20150430/Breath-Mouse-244-30042015';               % 25-04-2015 > delay 3*140ms - Mouse 244
    Dir.delay{a}=0;
    a=a+1; Dir.path{a}='/media/DataMOBsRAID/ProjetBreathDeltaFeedback/Mice251-252/20150621/Breath-Mouse-251-21062015';               % 09-06-2015 > delay 3*140ms - Mouse 251
    Dir.delay{a}=0;
    a=a+1; Dir.path{a}='/media/DataMOBsRAID/ProjetBreathDeltaFeedback/Mice251-252/20150610/Breath-Mouse-252-10062015';               % 08-06-2015 > delay 3*140ms - Mouse 252
end


%% names

for i=1:length(Dir.path)
    Dir.manipe{i}=experiment;
    if Dir.path{i}(end-8)=='/'
    Dir.name{i}=Dir.path{i}(end-7:end);
    else
    Dir.name{i}=Dir.path{i}(strfind(Dir.path{i},'Mouse'):strfind(Dir.path{i},'Mouse')+8);
    Dir.name{i}(Dir.name{i}=='-')=[];
    end
    
end

%% Strain

for i=1:length(Dir.path)
    for mi=1:length(MICEgroups)
        eval(['temp(mi)=sum(strcmp(Dir.name{i},',MICEgroups{mi},'));']);
    end
   
    if sum(temp)==0
        Dir.group{i}=nan;
    else
        Dir.group{i}=MICEgroups{temp==1};
    end
    %disp([Dir.name{i},' -> ',Dir.group{i}])
end

% 
% %% Correction if gain 1000 was not applied for signal aquisition
% 
% for i=1:length(Dir.path)
%     Dir.CorrecAmpli(i)=1;
% end
% 
% for i=I_CA
%     Dir.CorrecAmpli(i)=1/2;
% end
