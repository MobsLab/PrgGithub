function Dir=PathForExperimentsMtzlProject(experiment)
% input:
% name of the experiment.
% possible choices:
% 'EPM'

% 'SoundHab' 'SoundCond' 'SoundTest' 'SoundTestPlethysmo'

% 'SleepPreDrug'
% 'SleepDrugDay1' 'SleepDrugDay2' 'SleepDrugDay3' 'SleepDrugDay4'

% 'OpenFieldBehav_Post' 'OpenFieldBehav_Pre'

% output
% Dir = structure containing paths / names / strains / name of the
% experiment (manipe) / correction for amplification (default=1000)
%
%
% example:
% Dir=PathForExperimentsML('EPM');
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

% Mice injected with methimazole : 692, 693, 750, 775, 776
% Mice injected with saline : 740, 751, 777, 778, 779

%% Path
a=0;
I_CA=[];

if strcmp(experiment,'EPM')
    %Mouse692
    a=a+1;Dir.path{a}{1}='/media/nas4/ProjetMTZL/Mouse692/13102018/EPM/';
    load([Dir.path{a}{1},'ExpeInfo.mat']),Dir.ExpeInfo{a}{1}=ExpeInfo;
    %Mouse693
    a=a+1;Dir.path{a}{1}='/media/nas4/ProjetMTZL/Mouse693/13102018/EPM/';
    load([Dir.path{a}{1},'ExpeInfo.mat']),Dir.ExpeInfo{a}{1}=ExpeInfo;
    %Mouse 750
    a=a+1;Dir.path{a}{1}='/media/nas4/ProjetMTZL/Mouse750/13102018/EPM/';
    load([Dir.path{a}{1},'ExpeInfo.mat']),Dir.ExpeInfo{a}{1}=ExpeInfo;
    %Mouse 775
    a=a+1;Dir.path{a}{1}='/media/nas4/ProjetMTZL/Mouse775/13102018/EPM/';
    load([Dir.path{a}{1},'ExpeInfo.mat']),Dir.ExpeInfo{a}{1}=ExpeInfo;
    %Mouse 776
    a=a+1;Dir.path{a}{1}='/media/nas4/ProjetMTZL/Mouse776/13102018/EPM/';
    load([Dir.path{a}{1},'ExpeInfo.mat']),Dir.ExpeInfo{a}{1}=ExpeInfo;
    
    
    %Mouse740
    a=a+1;Dir.path{a}{1}='/media/nas4/ProjetMTZL/Mouse740/13102018/EPM/';
    load([Dir.path{a}{1},'ExpeInfo.mat']),Dir.ExpeInfo{a}{1}=ExpeInfo;
    %Mouse751
    a=a+1;Dir.path{a}{1}='/media/nas4/ProjetMTZL/Mouse751/13102018/EPM/';
    load([Dir.path{a}{1},'ExpeInfo.mat']),Dir.ExpeInfo{a}{1}=ExpeInfo;
    %Mouse777
    a=a+1;Dir.path{a}{1}='/media/nas4/ProjetMTZL/Mouse777/13102018/EPM/';
    load([Dir.path{a}{1},'ExpeInfo.mat']),Dir.ExpeInfo{a}{1}=ExpeInfo;
    %Mouse778
    a=a+1;Dir.path{a}{1}='/media/nas4/ProjetMTZL/Mouse778/13102018/EPM/';
    load([Dir.path{a}{1},'ExpeInfo.mat']),Dir.ExpeInfo{a}{1}=ExpeInfo;
    %Mouse779
    a=a+1;Dir.path{a}{1}='/media/nas4/ProjetMTZL/Mouse779/13102018/EPM/';
    load([Dir.path{a}{1},'ExpeInfo.mat']),Dir.ExpeInfo{a}{1}=ExpeInfo;
    
elseif strcmp(experiment,'SoundHab')
    %Mouse692
    a=a+1;Dir.path{a}{1}='/media/nas4/ProjetMTZL/Mouse692/13102018/HabSound/';
    load([Dir.path{a}{1},'ExpeInfo.mat']),Dir.ExpeInfo{a}{1}=ExpeInfo;
    %Mouse693
    a=a+1;Dir.path{a}{1}='/media/nas4/ProjetMTZL/Mouse693/13102018/HabSound/';
    load([Dir.path{a}{1},'ExpeInfo.mat']),Dir.ExpeInfo{a}{1}=ExpeInfo;
    %Mouse 750
    a=a+1;Dir.path{a}{1}='/media/nas4/ProjetMTZL/Mouse750/13102018/HabSound/';
    load([Dir.path{a}{1},'ExpeInfo.mat']),Dir.ExpeInfo{a}{1}=ExpeInfo;
    %Mouse 775
    a=a+1;Dir.path{a}{1}='/media/nas4/ProjetMTZL/Mouse775/13102018/HabSound/';
    load([Dir.path{a}{1},'ExpeInfo.mat']),Dir.ExpeInfo{a}{1}=ExpeInfo;
    %Mouse 776
    a=a+1;Dir.path{a}{1}='/media/nas4/ProjetMTZL/Mouse776/13102018/HabSound/';
    load([Dir.path{a}{1},'ExpeInfo.mat']),Dir.ExpeInfo{a}{1}=ExpeInfo;
    
    
    %Mouse740
    a=a+1;Dir.path{a}{1}='/media/nas4/ProjetMTZL/Mouse740/13102018/HabSound/';
    load([Dir.path{a}{1},'ExpeInfo.mat']),Dir.ExpeInfo{a}{1}=ExpeInfo;
    %Mouse751
    a=a+1;Dir.path{a}{1}='/media/nas4/ProjetMTZL/Mouse779/13102018/HabSound/';
    load([Dir.path{a}{1},'ExpeInfo.mat']),Dir.ExpeInfo{a}{1}=ExpeInfo;
    %Mouse777
    a=a+1;Dir.path{a}{1}='/media/nas4/ProjetMTZL/Mouse777/13102018/HabSound/';
    load([Dir.path{a}{1},'ExpeInfo.mat']),Dir.ExpeInfo{a}{1}=ExpeInfo;
    %Mouse778
    a=a+1;Dir.path{a}{1}='/media/nas4/ProjetMTZL/Mouse778/13102018/HabSound/';
    load([Dir.path{a}{1},'ExpeInfo.mat']),Dir.ExpeInfo{a}{1}=ExpeInfo;
    %Mouse779
    a=a+1;Dir.path{a}{1}='/media/nas4/ProjetMTZL/Mouse779/13102018/HabSound/';
    load([Dir.path{a}{1},'ExpeInfo.mat']),Dir.ExpeInfo{a}{1}=ExpeInfo;
    
elseif strcmp(experiment,'SoundCond')
    %Mouse692
    a=a+1;Dir.path{a}{1}='/media/nas4/ProjetMTZL/Mouse692/13102018/CondSound/';
    load([Dir.path{a}{1},'ExpeInfo.mat']),Dir.ExpeInfo{a}{1}=ExpeInfo;
    %Mouse693
    a=a+1;Dir.path{a}{1}='/media/nas4/ProjetMTZL/Mouse693/13102018/CondSound/';
    load([Dir.path{a}{1},'ExpeInfo.mat']),Dir.ExpeInfo{a}{1}=ExpeInfo;
    %Mouse 750
    a=a+1;Dir.path{a}{1}='/media/nas4/ProjetMTZL/Mouse750/13102018/CondSound/';
    load([Dir.path{a}{1},'ExpeInfo.mat']),Dir.ExpeInfo{a}{1}=ExpeInfo;
    %Mouse 775
    a=a+1;Dir.path{a}{1}='/media/nas4/ProjetMTZL/Mouse775/13102018/CondSound/';
    load([Dir.path{a}{1},'ExpeInfo.mat']),Dir.ExpeInfo{a}{1}=ExpeInfo;
    %Mouse 776
    a=a+1;Dir.path{a}{1}='/media/nas4/ProjetMTZL/Mouse776/13102018/CondSound/';
    load([Dir.path{a}{1},'ExpeInfo.mat']),Dir.ExpeInfo{a}{1}=ExpeInfo;
    
    
    %Mouse740
    a=a+1;Dir.path{a}{1}='/media/nas4/ProjetMTZL/Mouse740/13102018/CondSound/';
    load([Dir.path{a}{1},'ExpeInfo.mat']),Dir.ExpeInfo{a}{1}=ExpeInfo;
    %Mouse751
    a=a+1;Dir.path{a}{1}='/media/nas4/ProjetMTZL/Mouse751/13102018/CondSound/';
    load([Dir.path{a}{1},'ExpeInfo.mat']),Dir.ExpeInfo{a}{1}=ExpeInfo;
    %Mouse777
    a=a+1;Dir.path{a}{1}='/media/nas4/ProjetMTZL/Mouse777/13102018/CondSound/';
    load([Dir.path{a}{1},'ExpeInfo.mat']),Dir.ExpeInfo{a}{1}=ExpeInfo;
    %Mouse778
    a=a+1;Dir.path{a}{1}='/media/nas4/ProjetMTZL/Mouse778/13102018/CondSound/';
    load([Dir.path{a}{1},'ExpeInfo.mat']),Dir.ExpeInfo{a}{1}=ExpeInfo;
    %Mouse779
    a=a+1;Dir.path{a}{1}='/media/nas4/ProjetMTZL/Mouse779/13102018/HabSound/';
    load([Dir.path{a}{1},'ExpeInfo.mat']),Dir.ExpeInfo{a}{1}=ExpeInfo;
    
elseif strcmp(experiment,'SoundTest')
    %Mouse692
    a=a+1;Dir.path{a}{1}='/media/nas4/ProjetMTZL/Mouse692/14102018/';
    load([Dir.path{a}{1},'ExpeInfo.mat']),Dir.ExpeInfo{a}{1}=ExpeInfo;
    %Mouse693
    a=a+1;Dir.path{a}{1}='/media/nas4/ProjetMTZL/Mouse693/14102018/';
    load([Dir.path{a}{1},'ExpeInfo.mat']),Dir.ExpeInfo{a}{1}=ExpeInfo;
    %Mouse 750
    a=a+1;Dir.path{a}{1}='/media/nas4/ProjetMTZL/Mouse750/14102018/';
    load([Dir.path{a}{1},'ExpeInfo.mat']),Dir.ExpeInfo{a}{1}=ExpeInfo;
    %Mouse 775
    a=a+1;Dir.path{a}{1}='/media/nas4/ProjetMTZL/Mouse775/14102018/';
    load([Dir.path{a}{1},'ExpeInfo.mat']),Dir.ExpeInfo{a}{1}=ExpeInfo;
    %Mouse 776
    a=a+1;Dir.path{a}{1}='/media/nas4/ProjetMTZL/Mouse776/14102018/';
    load([Dir.path{a}{1},'ExpeInfo.mat']),Dir.ExpeInfo{a}{1}=ExpeInfo;
    
    
    %Mouse740s
    a=a+1;Dir.path{a}{1}='/media/nas4/ProjetMTZL/Mouse740/14102018/';
    load([Dir.path{a}{1},'ExpeInfo.mat']),Dir.ExpeInfo{a}{1}=ExpeInfo;
    %Mouse751
    a=a+1;Dir.path{a}{1}='/media/nas4/ProjetMTZL/Mouse751/14102018/';
    load([Dir.path{a}{1},'ExpeInfo.mat']),Dir.ExpeInfo{a}{1}=ExpeInfo;
    %Mouse777
    a=a+1;Dir.path{a}{1}='/media/nas4/ProjetMTZL/Mouse777/14102018/';
    load([Dir.path{a}{1},'ExpeInfo.mat']),Dir.ExpeInfo{a}{1}=ExpeInfo;
    %Mouse778
    a=a+1;Dir.path{a}{1}='/media/nas4/ProjetMTZL/Mouse778/14102018/';
    load([Dir.path{a}{1},'ExpeInfo.mat']),Dir.ExpeInfo{a}{1}=ExpeInfo;
    %Mouse779
    a=a+1;Dir.path{a}{1}='/media/nas4/ProjetMTZL/Mouse779/14102018/';
    load([Dir.path{a}{1},'ExpeInfo.mat']),Dir.ExpeInfo{a}{1}=ExpeInfo;
    
elseif strcmp(experiment,'SoundTestPlethysmo')
    %Mouse692
    a=a+1;Dir.path{a}{1}='/media/nas4/ProjetMTZL/Mouse692/15102018/';
    load([Dir.path{a}{1},'ExpeInfo.mat']),Dir.ExpeInfo{a}{1}=ExpeInfo;
    %Mouse693
    a=a+1;Dir.path{a}{1}='/media/nas4/ProjetMTZL/Mouse693/15102018/';
    load([Dir.path{a}{1},'ExpeInfo.mat']),Dir.ExpeInfo{a}{1}=ExpeInfo;
    %Mouse 750
    a=a+1;Dir.path{a}{1}='/media/nas4/ProjetMTZL/Mouse750/15102018/';
    load([Dir.path{a}{1},'ExpeInfo.mat']),Dir.ExpeInfo{a}{1}=ExpeInfo;
    %Mouse 775
    a=a+1;Dir.path{a}{1}='/media/nas4/ProjetMTZL/Mouse775/15102018/';
    load([Dir.path{a}{1},'ExpeInfo.mat']),Dir.ExpeInfo{a}{1}=ExpeInfo;
    %Mouse 776
    a=a+1;Dir.path{a}{1}='/media/nas4/ProjetMTZL/Mouse776/15102018/';
    load([Dir.path{a}{1},'ExpeInfo.mat']),Dir.ExpeInfo{a}{1}=ExpeInfo;
    
    
    %Mouse740
    a=a+1;Dir.path{a}{1}='/media/nas4/ProjetMTZL/Mouse740/15102018/';
    load([Dir.path{a}{1},'ExpeInfo.mat']),Dir.ExpeInfo{a}{1}=ExpeInfo;
    %Mouse751
    a=a+1;Dir.path{a}{1}='/media/nas4/ProjetMTZL/Mouse751/15102018/';
    load([Dir.path{a}{1},'ExpeInfo.mat']),Dir.ExpeInfo{a}{1}=ExpeInfo;
    %Mouse777
    a=a+1;Dir.path{a}{1}='/media/nas4/ProjetMTZL/Mouse777/15102018/';
    load([Dir.path{a}{1},'ExpeInfo.mat']),Dir.ExpeInfo{a}{1}=ExpeInfo;
    %Mouse778
    a=a+1;Dir.path{a}{1}='/media/nas4/ProjetMTZL/Mouse778/15102018/';
    load([Dir.path{a}{1},'ExpeInfo.mat']),Dir.ExpeInfo{a}{1}=ExpeInfo;
    %Mouse779
    a=a+1;Dir.path{a}{1}='/media/nas4/ProjetMTZL/Mouse779/15102018/';
    load([Dir.path{a}{1},'ExpeInfo.mat']),Dir.ExpeInfo{a}{1}=ExpeInfo;
    
elseif strcmp(experiment,'SoundHab_Plethysmo_PreMTZL')
    
    AllMiceNumbers = {'751','795','849','850','851','858','859','861'};
    for k = 1 :length(AllMiceNumbers)
    a=a+1;Dir.path{a}{1}=['/media/nas4/ProjetMTZL/Mouse',AllMiceNumbers{k},'/01042019-Hab/'];
    load([Dir.path{a}{1},'ExpeInfo.mat']),Dir.ExpeInfo{a}{1}=ExpeInfo;
    Dir.ExpeInfo{a}{1}.DrugInjected = 'NTHG';
    end
    
elseif strcmp(experiment,'SoundHab_Plethysmo_PostMTZL')
    
    AllMiceNumbers = {'751','795','849','850','851','858','859','861'};
    for k = 1 :length(AllMiceNumbers)
        a=a+1;Dir.path{a}{1}=['/media/nas4/ProjetMTZL/Mouse',AllMiceNumbers{k},'/08042019-HabPostMTZL/'];
        load([Dir.path{a}{1},'ExpeInfo.mat']),Dir.ExpeInfo{a}{1}=ExpeInfo;
        Dir.ExpeInfo{a}{1}.DrugInjected = 'METHIMAZOLE';
    end
    
    
elseif strcmp(experiment,'SoundTest_Plethysmo_PreMTZL')
    
    AllMiceNumbers = {'751','849','850','851','859','861'};
    for k = 1 :length(AllMiceNumbers)
        a=a+1;Dir.path{a}{1}=['/media/nas4/ProjetMTZL/Mouse',AllMiceNumbers{k},'/03042019-Ext/'];
        load([Dir.path{a}{1},'ExpeInfo.mat']),Dir.ExpeInfo{a}{1}=ExpeInfo;
        Dir.ExpeInfo{a}{1}.DrugInjected = 'NTHG';

    end
    
elseif strcmp(experiment,'SoundTest_Plethysmo_PostMTZL')
    
    AllMiceNumbers = {'751','849','850','851','859','861'};
    for k = 1 :length(AllMiceNumbers)
        a=a+1;Dir.path{a}{1}=['/media/nas4/ProjetMTZL/Mouse',AllMiceNumbers{k},'/10042019-ExtPostMTZL/'];
        load([Dir.path{a}{1},'ExpeInfo.mat']),Dir.ExpeInfo{a}{1}=ExpeInfo;
        Dir.ExpeInfo{a}{1}.DrugInjected = 'METHIMAZOLE';

    end
    
elseif strcmp(experiment,'SoundTest_Plethysmo_NoInjection')
    
    FolderPath='/media/DataMOBsRAIDN/ProjetAversion/DATA-Fear';
    a=a+1; Dir.path{a}{1}=[FolderPath,'/Mouse493/FEAR-Mouse-493-Ext-24-Plethysmo-20161227/'];
    load([Dir.path{a}{1},'ExpeInfo.mat']),Dir.ExpeInfo{a}{1}=ExpeInfo;
    Dir.ExpeInfo{a}{1}.DrugInjected = 'NTHG';
    a=a+1; Dir.path{a}{1}=[FolderPath,'/Mouse471/FEAR-Mouse-471-Ext-24-Plethysmo-20161227/'];
    load([Dir.path{a}{1},'ExpeInfo.mat']),Dir.ExpeInfo{a}{1}=ExpeInfo;
    Dir.ExpeInfo{a}{1}.DrugInjected = 'NTHG';
    a=a+1; Dir.path{a}{1}=[FolderPath,'/Mouse470/FEAR-Mouse-470-Ext-24-Plethysmo-20161227/'];
    load([Dir.path{a}{1},'ExpeInfo.mat']),Dir.ExpeInfo{a}{1}=ExpeInfo;
    Dir.ExpeInfo{a}{1}.DrugInjected = 'NTHG';
    a=a+1; Dir.path{a}{1}=[FolderPath,'/Mouse402/FEAR-Mouse-402-EXT-24-Plethysmo-20161228/'];
    load([Dir.path{a}{1},'ExpeInfo.mat']),Dir.ExpeInfo{a}{1}=ExpeInfo;
    Dir.ExpeInfo{a}{1}.DrugInjected = 'NTHG';
    a=a+1; Dir.path{a}{1}=[FolderPath,'/Mouse450/FEAR-Mouse-450-Ext-24-Plethysmo-20161228/'];
    load([Dir.path{a}{1},'ExpeInfo.mat']),Dir.ExpeInfo{a}{1}=ExpeInfo;
    Dir.ExpeInfo{a}{1}.DrugInjected = 'NTHG';
    a=a+1; Dir.path{a}{1}=[FolderPath,'/Mouse395/FEAR-Mouse-395-Ext-24-Plethysmo-20161228/'];
    load([Dir.path{a}{1},'ExpeInfo.mat']),Dir.ExpeInfo{a}{1}=ExpeInfo;
    Dir.ExpeInfo{a}{1}.DrugInjected = 'NTHG';
    
    
elseif strcmp(experiment,'BaselineSleep')
    
    FilePath{1} = '/media/DataMOBsRAIDN/ProjetAversion/DATA-Fear/MTZL-Exp/Mouse666/';
    FilePath{2} = '/media/DataMOBsRAIDN/ProjetAversion/DATA-Fear/MTZL-Exp/Mouse689/';
    % Mice were recorded for 5 consecutive days and injected with MTZL or
    % saline on the second day
    clear Dates
    Dates{1} = '10052018';
    Dates{2} = '14052018'; % injection day
    Dates{3} = '15052018';
    Dates{4} = '16052018';
    Dates{5} = '17052018';
    Dates{6} = '18052018';
    
    %Mouse666
    a=a+1;
    for d = 1 : length(Dates)
        Dir.path{a}{d}=['/media/DataMOBsRAIDN/ProjetAversion/DATA-Fear/MTZL-Exp/Mouse666/' Dates{d} '/'];
        load([Dir.path{a}{d},'ExpeInfo.mat']),Dir.ExpeInfo{a}{d}=ExpeInfo;
        Dir.ExpeInfo{a}{d}.DrugInjected = 'METHIMAZOLE';
    end
    %Mouse689
    a=a+1;
    for d = 1 : length(Dates)
        Dir.path{a}{d}=['/media/DataMOBsRAIDN/ProjetAversion/DATA-Fear/MTZL-Exp/Mouse689/' Dates{d} '/'];
        load([Dir.path{a}{d},'ExpeInfo.mat']),Dir.ExpeInfo{a}{d}=ExpeInfo;
        Dir.ExpeInfo{a}{d}.DrugInjected = 'METHIMAZOLE';
    end

    % Mice were recorded for 5 consecutive days and injected with MTZL or
    % saline on the second day
    clear Dates
    Dates{1} = '08102018';
    Dates{2} = '09102018'; % injection day
    Dates{3} = '10102018';
    Dates{4} = '11102018';
    Dates{5} = '12102018';
    
    %Mouse692
    a=a+1;
    for d = 1 : length(Dates)
        Dir.path{a}{d}=['/media/nas4/ProjetMTZL/Mouse692/' Dates{d} '/'];
        load([Dir.path{a}{d},'ExpeInfo.mat']),Dir.ExpeInfo{a}{d}=ExpeInfo;
    end
    %Mouse693
    a=a+1;
    for d = 1 : length(Dates)
        Dir.path{a}{d}=['/media/nas4/ProjetMTZL/Mouse693/' Dates{d} '/'];
        load([Dir.path{a}{d},'ExpeInfo.mat']),Dir.ExpeInfo{a}{d}=ExpeInfo;
    end
    %Mouse 750
    a=a+1;
    for d = 1 : length(Dates)
        Dir.path{a}{d}=['/media/nas4/ProjetMTZL/Mouse750/' Dates{d} '/'];
        load([Dir.path{a}{d},'ExpeInfo.mat']),Dir.ExpeInfo{a}{d}=ExpeInfo;
    end
    %Mouse 775
    a=a+1;
    for d = 1 : length(Dates)
        Dir.path{a}{d}=['/media/nas4/ProjetMTZL/Mouse775/' Dates{d} '/'];
        load([Dir.path{a}{d},'ExpeInfo.mat']),Dir.ExpeInfo{a}{d}=ExpeInfo;
    end
    %Mouse 776
    a=a+1;
    for d = 1 : length(Dates)
        Dir.path{a}{d}=['/media/nas4/ProjetMTZL/Mouse776/' Dates{d} '/'];
        load([Dir.path{a}{d},'ExpeInfo.mat']),Dir.ExpeInfo{a}{d}=ExpeInfo;
    end
    
    %Mouse740
    a=a+1;
    for d = 1 : length(Dates)
        Dir.path{a}{d}=['/media/nas4/ProjetMTZL/Mouse740/' Dates{d} '/'];
        try
            load([Dir.path{a}{d},'ExpeInfo.mat']),Dir.ExpeInfo{a}{d}=ExpeInfo;
        catch
            Dir.ExpeInfo{a}{d} = {};
        end
    end
    %Mouse751
    a=a+1;
    for d = 1 : length(Dates)
        Dir.path{a}{d}=['/media/nas4/ProjetMTZL/Mouse751/' Dates{d} '/'];
        try
            load([Dir.path{a}{d},'ExpeInfo.mat']),Dir.ExpeInfo{a}{d}=ExpeInfo;
        catch
            Dir.ExpeInfo{a}{d} = {};
        end
    end
    %Mouse777
    a=a+1;
    for d = 1 : length(Dates)
        Dir.path{a}{d}=['/media/nas4/ProjetMTZL/Mouse777/' Dates{d} '/'];
        try
            load([Dir.path{a}{d},'ExpeInfo.mat']),Dir.ExpeInfo{a}{d}=ExpeInfo;
        catch
            Dir.ExpeInfo{a}{d} = {};
        end
    end
    %Mouse778
    a=a+1;
    for d = 1 : length(Dates)
        Dir.path{a}{d}=['/media/nas4/ProjetMTZL/Mouse778/' Dates{d} '/'];
        try
            load([Dir.path{a}{d},'ExpeInfo.mat']),Dir.ExpeInfo{a}{d}=ExpeInfo;
        catch
            Dir.ExpeInfo{a}{d} = {};
        end
    end
    %Mouse779
    a=a+1;
    for d = 1 : length(Dates)
        Dir.path{a}{d}=['/media/nas4/ProjetMTZL/Mouse779/' Dates{d} '/'];
        try
            load([Dir.path{a}{d},'ExpeInfo.mat']),Dir.ExpeInfo{a}{d}=ExpeInfo;
        catch
            Dir.ExpeInfo{a}{d} = {};
        end
    end
    
    % A separate saline group (identical protocol was done to have a
    % big enough n for he saline)
    clear Dates
    Dates{1} = '20190107';
    Dates{2} = '20190109';% injection day
    Dates{3} = '20190110';
    Dates{4} = '20190111';
    
    % M829
    a=a+1;
    for d = 1 : length(Dates)
        Dir.path{a}{d}=['/media/nas4/ProjetEmbReact/Mouse829/' Dates{d} '/'];
        load([Dir.path{a}{d},'ExpeInfo.mat']),Dir.ExpeInfo{a}{d}=ExpeInfo;
        Dir.ExpeInfo{a}{d}.DrugInjected = 'SALINE';
    end
    % M849
    a=a+1;
    for d = 1 : length(Dates)
        Dir.path{a}{d}=['/media/nas4/ProjetEmbReact/Mouse849/' Dates{d} '/'];
        load([Dir.path{a}{d},'ExpeInfo.mat']),Dir.ExpeInfo{a}{d}=ExpeInfo;
        Dir.ExpeInfo{a}{d}.DrugInjected = 'SALINE';
    end
    % M850
    a=a+1;
    for d = 1 : length(Dates)
        Dir.path{a}{d}=['/media/nas4/ProjetEmbReact/Mouse850/' Dates{d} '/'];
        load([Dir.path{a}{d},'ExpeInfo.mat']),Dir.ExpeInfo{a}{d}=ExpeInfo;
        Dir.ExpeInfo{a}{d}.DrugInjected = 'SALINE';
    end
    % M851
    a=a+1;
    for d = 1 : length(Dates)
        Dir.path{a}{d}=['/media/nas4/ProjetEmbReact/Mouse851/' Dates{d} '/'];
        load([Dir.path{a}{d},'ExpeInfo.mat']),Dir.ExpeInfo{a}{d}=ExpeInfo;
        Dir.ExpeInfo{a}{d}.DrugInjected = 'SALINE';
    end
    
elseif strcmp(experiment,'SleepPlethysmograph')

    
    % M794
    a=a+1;Dir.path{a}{1}='/media/nas4/ProjetMTZL/Mouse794/20181121/M794_SleepAfternoonPleythsmo_181121_143653/';
    load([Dir.path{a}{1},'ExpeInfo.mat']),Dir.ExpeInfo{a}{1}=ExpeInfo;
    Dir.ExpeInfo{a}{1}.DrugInjected = 'NONE';
    Dir.path{a}{2}='/media/nas4/ProjetMTZL/Mouse794/20181123/M794_SleepPlethysmo_181123_090246/';
    load([Dir.path{a}{2},'ExpeInfo.mat']),Dir.ExpeInfo{a}{2}=ExpeInfo;
    Dir.ExpeInfo{a}{2}.DrugInjected = 'NONE';
    Dir.path{a}{3}='/media/nas4/ProjetMTZL/Mouse794/20181126/M794_SLeepPlethysmo_181126_091803/';
    load([Dir.path{a}{3},'ExpeInfo.mat']),Dir.ExpeInfo{a}{3}=ExpeInfo;
    Dir.ExpeInfo{a}{3}.DrugInjected = 'METHIMAZOLE';
    
    % M751
    a=a+1;Dir.path{a}{1}='/media/nas4/ProjetMTZL/Mouse751/22102018/M751_SleepPlethysmo_181022_090703/';
    load([Dir.path{a}{1},'ExpeInfo.mat']),Dir.ExpeInfo{a}{1}=ExpeInfo;
    Dir.ExpeInfo{a}{1}.DrugInjected = 'SALINE';

    % M775
    a=a+1;Dir.path{a}{1}='/media/nas4/ProjetMTZL/Mouse775/17102018/M775_SleepPlethysmo_181017_103647/';
    load([Dir.path{a}{1},'ExpeInfo.mat']),Dir.ExpeInfo{a}{1}=ExpeInfo;
    Dir.ExpeInfo{a}{1}.DrugInjected = 'METHIMAZOLE';

%     % M776
%     a=a+1;Dir.path{a}{1}='/media/nas4/ProjetMTZL/Mouse776/23102018/';
%     load([Dir.path{a}{1},'ExpeInfo.mat']),Dir.ExpeInfo{a}{1}=ExpeInfo;
%     Dir.ExpeInfo{a}{1}.DrugInjected = 'METHIMAZOLE';

    % M778
    a=a+1;Dir.path{a}{1}='/media/nas4/ProjetMTZL/Mouse778/24102018/';
    load([Dir.path{a}{1},'ExpeInfo.mat']),Dir.ExpeInfo{a}{1}=ExpeInfo;
    Dir.ExpeInfo{a}{1}.DrugInjected = 'SALINE';
    Dir.path{a}{2}='/media/nas4/ProjetMTZL/Mouse778/20181213/';
    load([Dir.path{a}{2},'ExpeInfo.mat']),Dir.ExpeInfo{a}{2}=ExpeInfo;
    Dir.ExpeInfo{a}{2}.DrugInjected = 'SALINE';
    Dir.path{a}{3}='/media/nas4/ProjetMTZL/Mouse778/20181218/';
    load([Dir.path{a}{3},'ExpeInfo.mat']),Dir.ExpeInfo{a}{3}=ExpeInfo;
    Dir.ExpeInfo{a}{3}.DrugInjected = 'METHIMAZOLE';
    
    % M859
    a=a+1;Dir.path{a}{1}='/media/nas4/ProjetMTZL/Mouse859/20190410/';
    load([Dir.path{a}{1},'ExpeInfo.mat']),Dir.ExpeInfo{a}{1}=ExpeInfo;
    Dir.ExpeInfo{a}{1}.DrugInjected = 'METHIMAZOLE';
    
    % M851
    a=a+1;Dir.path{a}{1}='/media/nas4/ProjetMTZL/Mouse851/20190411/';
    load([Dir.path{a}{1},'ExpeInfo.mat']),Dir.ExpeInfo{a}{1}=ExpeInfo;
    Dir.ExpeInfo{a}{1}.DrugInjected = 'METHIMAZOLE';
    
elseif strcmp(experiment,'OpenFieldBehav_Pre')
    
    Mice = [756 758 761 763 765];
    for mm = 1 :length(Mice)
        a=a+1;Dir.path{a}{1}=['/media/DataMOBsRAIDN/ProjetAversion/DATA-Fear/MethimazoleBehaviourExperiment/BeforeInjection/FEAR-Mouse-',num2str(Mice(mm)),'-12062018-Hab_00/'];
        load([Dir.path{a}{1},'ExpeInfo.mat']),Dir.ExpeInfo{a}{1}=ExpeInfo;
        Dir.ExpeInfo{a}{1}.DrugInjected = 'SALINE';
    end
    
    Mice = [757 759 760 762 764];
    for mm = 1 :length(Mice)
        a=a+1;Dir.path{a}{1}=['/media/DataMOBsRAIDN/ProjetAversion/DATA-Fear/MethimazoleBehaviourExperiment/BeforeInjection/FEAR-Mouse-',num2str(Mice(mm)),'-12062018-Hab_00/'];
        load([Dir.path{a}{1},'ExpeInfo.mat']),Dir.ExpeInfo{a}{1}=ExpeInfo;
        Dir.ExpeInfo{a}{1}.DrugInjected = 'METHIMAZOLE';
    end
    
elseif strcmp(experiment,'OpenFieldBehav_Post')
    
    Mice = [756 758 761 763 765];
    for mm = 1 :length(Mice)
        a=a+1;Dir.path{a}{1}=['/media/DataMOBsRAIDN/ProjetAversion/DATA-Fear/MethimazoleBehaviourExperiment/4DqysPost/FEAR-Mouse-',num2str(Mice(mm)),'-16062018-Hab_00/'];
        load([Dir.path{a}{1},'ExpeInfo.mat']),Dir.ExpeInfo{a}{1}=ExpeInfo;
        Dir.ExpeInfo{a}{1}.DrugInjected = 'SALINE';
    end
    
    Mice = [757 759 760 762 764];
    for mm = 1 :length(Mice)
        a=a+1;Dir.path{a}{1}=['/media/DataMOBsRAIDN/ProjetAversion/DATA-Fear/MethimazoleBehaviourExperiment/4DqysPost/FEAR-Mouse-',num2str(Mice(mm)),'-16062018-Hab_00/'];
        load([Dir.path{a}{1},'ExpeInfo.mat']),Dir.ExpeInfo{a}{1}=ExpeInfo;
        Dir.ExpeInfo{a}{1}.DrugInjected = 'METHIMAZOLE';
    end


else
    error('Invalid name of experiment')
end

end
