function Dir=PathForExperimentsBULB(experiment)

% input:
% name of the experiment.
% possible choices: 
% 'SLEEPBasal' 'SLEEPocclu' 'SLEEPpostFear' 
% 'PLETHYSMO_spikes' PLETHYSMO_LFP
% 'FEAR-EXT-24h' 'FEAR-EXT-48h'
% output
% Dir = structure containing paths / names / strains / name of the
% experiment (manipe) / correction for amplification (default=1000)
%
%
% example:
% Dir=PathForExperimentsML('BASAL');
%
% 	merge two Dir:
% Dir=MergePathForExperiment(Dir1,Dir2);
%
%   restrict Dir to mice or group:
% Dir=RestrictPathForExperiment(Dir,'nMice',[245 246])
% Dir=RestrictPathForExperiment(Dir,'Group',{'OBX','hemiOBX'})
% Dir=RestrictPathForExperiment(Dir,'Group','OBX')
%
% similar functions:
% PathForExperimentFEAR.m
% PathForExperimentsDeltaSleep.m
% PathForExperimentsKB.m PathForExperimentsKBnew.m 
% PathForExperimentsML.m 

%% strains inputs

MICEgroups={'OBX','hemiOBX','CTRL','Thy1'};

% bulbectomy
OBX={'Mouse230' 'Mouse247'};

% hemibulbectomy
hemiOBX={'Mouse245' 'Mouse246'};

CTRL={'Mouse062' 'Mouse063' 'Mouse160' 'Mouse231' 'Mouse241' 'Mouse242' 'Mouse243'  'Mouse244' 'Mouse248' 'Mouse251' 'Mouse252' 'Mouse253' 'Mouse254'};

Thy1={'Mouse105' 'Mouse106'};

%% Path
a=0;
I_CA=[];
if strcmp(experiment,'SLEEPBasal')
    % mouse 245 - hemiOBX
    %a=a+1; Dir.path{a}='/media/DataMOBsRAID/ProjetAstro/Mouse245/20150319/BULB-Mouse-245-246-19032015';% finir spike sorting
    %a=a+1; Dir.path{a}='/media/DataMOBsRAID/ProjetAstro/Mouse245/20150320/BULB-Mouse-245-246-20032015';% finir spike sorting
    a=a+1; Dir.path{a}='/media/DataMOBsRAID/ProjetAstro/Mouse245/20150323/BULB-Mouse-245-246-23032015';
    a=a+1; Dir.path{a}='/media/DataMOBsRAID/ProjetAstro/Mouse245/20150325/BULB-Mouse-245-246-25032015';
    a=a+1; Dir.path{a}='/media/DataMOBsRAID/ProjetAstro/Mouse245/20150326/BULB-Mouse-245-246-26032015';
    a=a+1; Dir.path{a}='/media/DataMOBsRAID/ProjetAstro/Mouse245/20150327/BULB-Mouse-245-246-27032015';
    % mouse 246 - hemiOBX
    %a=a+1; Dir.path{a}='/media/DataMOBsRAID/ProjetAstro/Mouse246/20150319/BULB-Mouse-245-246-19032015';% finir spike sorting
    %a=a+1; Dir.path{a}='/media/DataMOBsRAID/ProjetAstro/Mouse246/20150320/BULB-Mouse-245-246-20032015';% finir spike sorting
    a=a+1; Dir.path{a}='/media/DataMOBsRAID/ProjetAstro/Mouse246/20150323/BULB-Mouse-245-246-23032015';
    a=a+1; Dir.path{a}='/media/DataMOBsRAID/ProjetAstro/Mouse246/20150325/BULB-Mouse-245-246-25032015';
    a=a+1; Dir.path{a}='/media/DataMOBsRAID/ProjetAstro/Mouse246/20150326/BULB-Mouse-245-246-26032015';
    a=a+1; Dir.path{a}='/media/DataMOBsRAID/ProjetAstro/Mouse246/20150327/BULB-Mouse-245-246-27032015';
    
     % mouse 160 - groupe CTRL manipe dko
    a=a+1; Dir.path{a}='/media/DataMOBsRAID/ProjetAstro/Mouse160/20141219/BULB-Mouse-160-19122014';
    a=a+1; Dir.path{a}='/media/DataMOBsRAID/ProjetAstro/Mouse160/20141222/BULB-Mouse-160-22122014';
    a=a+1; Dir.path{a}='/media/DataMOBsRAID/ProjetAstro/Mouse160/20141223/BULB-Mouse-160-23122014';
    
    
    a=a+1; Dir.path{a}='/media/DataMOBsRAID/ProjetBreathDeltaFeedback/Mice251-252/20150518/Breath-Mouse-251-252-18052015/Mouse251'; % Mouse 251 - Day 1
    a=a+1; Dir.path{a}='/media/DataMOBsRAID/ProjetBreathDeltaFeedback/Mice251-252/20150518/Breath-Mouse-251-252-18052015/Mouse252'; % Mouse 252 - Day 1
    
    a=a+1; Dir.path{a}='/media/DataMOBsRAID/ProjetBreathDeltaFeedback/Mice243-244/20150329/Electrophy/Breath-Mouse-243-244-29032015/Mouse243'; % Mouse 243 - Day 2
    a=a+1; Dir.path{a}='/media/DataMOBsRAID/ProjetBreathDeltaFeedback/Mice243-244/20150329/Electrophy/Breath-Mouse-243-244-29032015/Mouse244'; % Mouse 244 - Day 2
    a=a+1; Dir.path{a}='/media/DataMOBsRAID/ProjetBreathDeltaFeedback/Mice251-252/20150519/Breath-Mouse-251-252-19052015/Mouse251';            % Mouse 251 - Day 2
    a=a+1; Dir.path{a}='/media/DataMOBsRAID/ProjetBreathDeltaFeedback/Mice251-252/20150519/Breath-Mouse-251-252-19052015/Mouse252';            % Mouse 252 - Day 2
    
    a=a+1; Dir.path{a}='/media/DataMOBsRAID/ProjetBreathDeltaFeedback/Mice243-244/20150331/Electrophy/Breath-Mouse-243-244-31032015/Mouse243'; % Mouse 243 - Day 3
    a=a+1; Dir.path{a}='/media/DataMOBsRAID/ProjetBreathDeltaFeedback/Mice243-244/20150331/Electrophy/Breath-Mouse-243-244-31032015/Mouse244'; % Mouse 244 - Day 3
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
    
    % mice injected with DREADD, sleep preFEAR
    
    a=a+1; Dir.path{a}='/media/DataMOBsRAID/ProjetAversion/DATA-Fear/Mouse253/20150629-SLEEPbasal'; 
    a=a+1; Dir.path{a}='/media/DataMOBsRAID/ProjetAversion/DATA-Fear/Mouse253/20150630-SLEEPbasal'; 
    a=a+1; Dir.path{a}='/media/DataMOBsRAID/ProjetAversion/DATA-Fear/Mouse254/20150629-SLEEPbasal'; 
    a=a+1; Dir.path{a}='/media/DataMOBsRAID/ProjetAversion/DATA-Fear/Mouse254/20150630-SLEEPbasal'; 
    
elseif strcmp(experiment,'SLEEPocclu')
    a=a+1; Dir.path{a}='/media/DataMOBsRAID/ProjetAstro/Mouse245/20150409/BULB-Mouse-245-246-09042015';
    a=a+1; Dir.path{a}='/media/DataMOBsRAID/ProjetAstro/Mouse245/20150410/SLEEP/BULB-Mouse-245-246-10042015';
    
    a=a+1; Dir.path{a}='/media/DataMOBsRAID/ProjetAstro/Mouse246/20150409/BULB-Mouse-245-246-09042015';
    a=a+1; Dir.path{a}='/media/DataMOBsRAID/ProjetAstro/Mouse246/20150410/SLEEP/BULB-Mouse-245-246-10042015';
    
    
 elseif strcmp(experiment,'SLEEPpostFear')
    a=a+1; Dir.path{a}='/media/DataMOBsRAID/ProjetAversion/DATA-Fear/Mouse253/20150728-SLEEP-basal';
    a=a+1; Dir.path{a}='/media/DataMOBsRAID/ProjetAversion/DATA-Fear/Mouse254/20150728-SLEEP-basal';
    
elseif strcmp(experiment,'SLEEPpostFear-cno')
    a=a+1; Dir.path{a}='/media/DataMOBsRAID/ProjetAversion/DATA-Fear/Mouse253/20150729-SLEEP-cno';
    a=a+1; Dir.path{a}='/media/DataMOBsRAID/ProjetAversion/DATA-Fear/Mouse254/20150729-SLEEP-cno';
    
elseif strcmp(experiment,'PLETHYSMO_spikes')
    
    a=a+1; Dir.path{a}='/media/DataMOBsRAID/ProjetAstro-DataPlethysmo/Mouse241-newwifi/20150228/RESPI-Mouse-241-28022015';
    a=a+1; Dir.path{a}='/media/DataMOBsRAID/ProjetAstro-DataPlethysmo/Mouse242-newwifi/20150228/RESPI-Mouse-242-28022015';
    
    
elseif strcmp(experiment,'PLETHYSMO_LFP')
    
    % thy1
    a=a+1; Dir.path{a}='/media/DataMOBsRAID5/ProjetOPTO/DATAopto/Mouse106-Thy1/20131206-plethy';
    a=a+1; Dir.path{a}='/media/DataMOBsRAID5/ProjetOPTO/DATAopto/Mouse106-Thy1/20131213-plethy';
    a=a+1; Dir.path{a}='/media/DataMOBsRAID5/ProjetOPTO/DATAopto/Mouse106-Thy1/20131230-plethy';
    a=a+1; Dir.path{a}='/media/DataMOBsRAID5/ProjetOPTO/DATAopto/Mouse106-Thy1/20131231-plethy-occlusion';
    a=a+1; Dir.path{a}='/media/DataMOBsRAID5/ProjetOPTO/DATAopto/Mouse105-Thy1/20131204-plethy';
    a=a+1; Dir.path{a}='/media/DataMOBsRAID5/ProjetOPTO/DATAopto/Mouse105-Thy1/20131205-plethy';
    a=a+1; Dir.path{a}='/media/DataMOBsRAID5/ProjetOPTO/DATAopto/Mouse105-Thy1/20131213-plethy';
    a=a+1; Dir.path{a}='/media/DataMOBsRAID5/ProjetOPTO/DATAopto/Mouse105-Thy1/20131231-plethy-occlusion';

    a=a+1; Dir.path{a}='/media/DataMOBsRAID/ProjetAstro-DataPlethysmo/Mouse160/20141221';
    a=a+1; Dir.path{a}='/media/DataMOBsRAID/ProjetAstro-DataPlethysmo/Mouse160/20141224';
    a=a+1; Dir.path{a}='/media/DataMOBsRAID/ProjetAstro-DataPlethysmo/Mouse160/20141228';
    
elseif strcmp(experiment,'FEAR-EXT-24h')
    
    a=a+1; Dir.path{a}='/media/DataMOBsRAID/ProjetAversion/DATA-Fear/Mouse230/20150212-EXT-24h-envC/'; % ref intan soustraite
    a=a+1; Dir.path{a}='/media/DataMOBsRAID/ProjetAversion/DATA-Fear/Mouse231/20150212-EXT-24h-envC/'; % ref intan soustraite
    a=a+1; Dir.path{a}='/media/DataMOBsRAID/ProjetAversion/DATA-Fear/Mouse247/20150326-EXT-24h-envC/'; % pas de ref à sourstraire - analyser que pendant freezing
    a=a+1; Dir.path{a}='/media/DataMOBsRAID/ProjetAversion/DATA-Fear/Mouse248/20150326-EXT-24h-envC/'; % pas de ref à sourstraire - analyser que pendant freezing

elseif strcmp(experiment,'FEAR-EXT-48h')
    a=a+1; Dir.path{a}='/media/DataMOBsRAID/ProjetAversion/DATA-Fear/Mouse248/20150327-EXT-48h-envB/'; % pas de ref à sourstraire - analyser que pendant freezing
    
    
else
    error('Invalid name of experiment')
end


%% names

for i=1:length(Dir.path)
    Dir.manipe{i}=experiment;
    ind=strfind(Dir.path{i},'Mouse');
    for d=1:length(ind); %disp(Dir.path{i}(ind(d):ind(d)+7))
        if ~strcmp(Dir.path{i}(ind(d)+5),'-')
            Dir.name{i}=Dir.path{i}(ind(d):ind(d)+7);
        end
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

%% Correction if gain 1000 was not applied for signal aquisition

for i=1:length(Dir.path)
    Dir.CorrecAmpli(i)=1;
end

for i=I_CA
    Dir.CorrecAmpli(i)=1/2;
end
