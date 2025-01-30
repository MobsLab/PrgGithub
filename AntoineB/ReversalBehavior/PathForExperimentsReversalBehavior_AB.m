function Dir=PathForExperimentsReversalBehavior_AB(experiment)

% input:
% name of the experiment.
% possible choices:

% 'Hab', 'Ext' , 'TestPre', 'TestPostPAG', 'TestPostMFB'
% 'CondPAG', 'CondWallShockPAG', 'CondWallSafePAG'
% 'CondMFB', 'CondWallShockMFB', 'CondWallSafeMFB'

% output
% Dir = structure containing paths / names / strains / name of the
% experiment (manipe) / correction for amplification (default=1000)
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



%% Path
a=0;
%seed = '/media/nas6/ProjetReversalBehavior';
seed_test = '/media/nas6/ProjetReversalBehavior/ReversalTest';
seed_sham = '/media/nas6/ProjetReversalBehavior/ReversalSham';
seed_import = '/media/nas6/ProjetReversalBehavior/SleepImport';

metadata_test = {'M913','20190529';...
    'M934','20190612';...
    'M1139','20210106';...
    'M1141','20201229';...
    'M1142','20210326';...
    'M1143','20201230'};
metadata_sham = {'M913','20190702';...
    'M934','20190708';...
    'M935','20190613';...
    'M938','20190618';...
    'M1138','20201216';...
    'M1139','20210317';...
    'M1140','20201217';...
    'M1142','20201218'};
metadata_import = {'M863','20190520';...
    'M913','20190521';...
    'M932','20190704';...
    'M934','20190531';...
    'M935','20190603';...
    'M938','20190606'};

switch experiment

    case {'Hab','FirstExplo'}
        
        % test_mice
        for i=1:size(metadata_test,1)
            cur_mouse = char(metadata_test{i,1});
            cur_date = char(metadata_test{i,2});
            a=a+1;Dir.path{a}{1}= fullfile(seed_test,cur_mouse,cur_date,'behavior_sorted/FirstExplo');
        end
        % sham mice
        for i=1:size(metadata_sham,1)
            cur_mouse = char(metadata_sham{i,1});
            cur_date = char(metadata_sham{i,2});
            a=a+1;Dir.path{a}{1}= fullfile(seed_sham,cur_mouse,cur_date,'behavior_sorted/FirstExplo');
        end
        % import mice
        for i=1:size(metadata_import,1)
            cur_mouse = char(metadata_import{i,1});
            cur_date = char(metadata_import{i,2});
            a=a+1;Dir.path{a}{1}= fullfile(seed_import,cur_mouse,cur_date,'behavior_sorted/FirstExplo');
        end
        
    case {'Ext','Extinction'}
        
        % test_mice
        for i=1:size(metadata_test,1)
            cur_mouse = char(metadata_test{i,1});
            cur_date = char(metadata_test{i,2});
            a=a+1;Dir.path{a}{1}= fullfile(seed_test,cur_mouse,cur_date,'behavior_sorted/Extinction');
        end
        % sham mice
        for i=1:size(metadata_sham,1)
            cur_mouse = char(metadata_sham{i,1});
            cur_date = char(metadata_sham{i,2});
            a=a+1;Dir.path{a}{1}= fullfile(seed_sham,cur_mouse,cur_date,'behavior_sorted/Extinction');
        end
        
    case {'TestPre'}
        
        % test_mice
        for i=1:size(metadata_test,1)
            cur_mouse = char(metadata_test{i,1});
            cur_date = char(metadata_test{i,2});
            a=a+1;
            ss=1;
            for s=1:4
                Dir.path{a}{ss}=fullfile(seed_test,cur_mouse,cur_date,'behavior_sorted',experiment,strcat(experiment,num2str(s)));
                ss=ss+1;
            end  
        end
        % sham mice
        for i=1:size(metadata_sham,1)
            cur_mouse = char(metadata_sham{i,1});
            cur_date = char(metadata_sham{i,2});
            a=a+1;
            ss=1;
            for s=1:4
                Dir.path{a}{ss}=fullfile(seed_sham,cur_mouse,cur_date,'behavior_sorted',experiment,strcat(experiment,num2str(s)));
                ss=ss+1;
            end
        end        
        % import mice
        for i=1:size(metadata_import,1)
            cur_mouse = char(metadata_import{i,1});
            cur_date = char(metadata_import{i,2});
            a=a+1;
            ss=1;
            for s=1:4
                Dir.path{a}{ss}=fullfile(seed_import,cur_mouse,cur_date,'behavior_sorted',experiment,strcat(experiment,num2str(s)));
                ss=ss+1;
            end
        end
        
        case{'TestPostPAG','TestPostMFB'}
            
            % test_mice
            for i=1:size(metadata_test,1)
                cur_mouse = char(metadata_test{i,1});
                cur_date = char(metadata_test{i,2});
                a=a+1;
                ss=1;
                for s=1:4
                    Dir.path{a}{ss}=fullfile(seed_test,cur_mouse,cur_date,'behavior_sorted','TestPost',experiment,strcat(experiment,num2str(s)));
                    ss=ss+1;
                end
                
            end
            % sham mice
            for i=1:size(metadata_sham,1)
                cur_mouse = char(metadata_sham{i,1});
                cur_date = char(metadata_sham{i,2});
                a=a+1;
                ss=1;
                for s=1:4
                    Dir.path{a}{ss}=fullfile(seed_sham,cur_mouse,cur_date,'behavior_sorted','TestPost',experiment,strcat(experiment,num2str(s)));
                    ss=ss+1;
                end
            end
            if strcmp(experiment,'TestPostPAG')
                % import mice
                for i=1:size(metadata_import,1)
                    cur_mouse = char(metadata_import{i,1});
                    cur_date = char(metadata_import{i,2});
                    a=a+1;
                    ss=1;
                    for s=1:4
                        Dir.path{a}{ss}=fullfile(seed_import,cur_mouse,cur_date,'behavior_sorted','TestPost',strcat(experiment,num2str(s)));
                        ss=ss+1;
                    end
                end
            end
            
    case {'TestProbe'}
        
        % import mice
        for i=1:size(metadata_import,1)
            cur_mouse = char(metadata_import{i,1});
            cur_date = char(metadata_import{i,2});
            a=a+1;
            Dir.path{a}{1}=fullfile(seed_import,cur_mouse,cur_date,'behavior_sorted/TestProbe');    
        end
            
    case{'CondPAG','CondMFB'}
        
        % test_mice
        for i=1:size(metadata_test,1)
            cur_mouse = char(metadata_test{i,1});
            cur_date = char(metadata_test{i,2});
            a=a+1;
            ss=1;
            for s=1:3
                Dir.path{a}{ss}=fullfile(seed_test,cur_mouse,cur_date,'behavior_sorted','Cond',experiment,strcat(experiment,num2str(s)));
                ss=ss+1;
            end
            
        end
        % sham mice
        for i=1:size(metadata_sham,1)
            cur_mouse = char(metadata_sham{i,1});
            cur_date = char(metadata_sham{i,2});
            a=a+1;
            ss=1;
            for s=1:3
                Dir.path{a}{ss}=fullfile(seed_sham,cur_mouse,cur_date,'behavior_sorted','Cond',experiment,strcat(experiment,num2str(s)));
                ss=ss+1;
            end
        end
        
        if strcmp(experiment,'CondPAG')
            % import mice
            for i=1:size(metadata_import,1)
                cur_mouse = char(metadata_import{i,1});
                cur_date = char(metadata_import{i,2});
                a=a+1;
                ss=1;
                for s=1:4
                    Dir.path{a}{ss}=fullfile(seed_import,cur_mouse,cur_date,'behavior_sorted','Cond',strcat(experiment,num2str(s)));
                    ss=ss+1;
                end
            end
        end
        
    case{'CondWallShockPAG','CondWallShockMFB'}
        
        % test_mice
        for i=1:size(metadata_test,1)
            cur_mouse = char(metadata_test{i,1});
            cur_date = char(metadata_test{i,2});
            a=a+1;
            ss=1;
            for s=1:3
                Dir.path{a}{ss}=fullfile(seed_test,cur_mouse,cur_date,'behavior_sorted','CondWallShock',experiment,strcat(experiment,num2str(s)));
                ss=ss+1;
            end
            
        end
        % sham mice
        for i=1:size(metadata_sham,1)
            cur_mouse = char(metadata_sham{i,1});
            cur_date = char(metadata_sham{i,2});
            a=a+1;
            ss=1;
            for s=1:3
                Dir.path{a}{ss}=fullfile(seed_sham,cur_mouse,cur_date,'behavior_sorted','CondWallShock',experiment,strcat(experiment,num2str(s)));
                ss=ss+1;
            end
        end
        
    case{'CondWallSafePAG','CondWallSafeMFB'}
        
        % test_mice
        for i=1:size(metadata_test,1)
            cur_mouse = char(metadata_test{i,1});
            cur_date = char(metadata_test{i,2});
            a=a+1;
            ss=1;
            for s=1:3
                Dir.path{a}{ss}=fullfile(seed_test,cur_mouse,cur_date,'behavior_sorted','CondWallSafe',experiment,strcat(experiment,num2str(s)));
                ss=ss+1;
            end
            
        end
        % sham mice
        for i=1:size(metadata_sham,1)
            cur_mouse = char(metadata_sham{i,1});
            cur_date = char(metadata_sham{i,2});
            a=a+1;
            ss=1;
            for s=1:3
                Dir.path{a}{ss}=fullfile(seed_sham,cur_mouse,cur_date,'behavior_sorted','CondWallSafe',experiment,strcat(experiment,num2str(s)));
                ss=ss+1;
            end
        end
        
    otherwise
        % invalid experiment
        error('Unknown Experiment Name: %s.',experiment);
end
    

%% Mice names
for i=1:length(Dir.path)
    Dir.manipe{i}=experiment;
    temp=strfind(Dir.path{i}{1},'M');
    if isempty(temp)
        Dir.name{i}=Dir.path{i}{1}(strfind(Dir.path{i}{1},'Mouse'):strfind(Dir.path{i}{1},'Mouse')+7);
    else
        Dir.name{i}=['Mouse',Dir.path{i}{1}(temp+1:temp+4)];
        if sum(isstrprop(Dir.path{i}{1}(temp+1:temp+4),'alphanum'))<4
            Dir.name{i}=['Mouse',Dir.path{i}{1}(temp+1:temp+3)];
        end
    end
end

%% Groups
Exp = 1:size(metadata_test,1);
Sham = length(Exp)+(1:size(metadata_sham,1));
SleepImport = length(Exp)+length(Sham)+(1:size(metadata_import,1));

for i=1:length(Dir.path)
    Dir.manipe{i}=experiment;
    
    Dir.group{1} = cell(length(Dir.path),1);
    Dir.group{2} = cell(length(Dir.path),1);
    Dir.group{3} = cell(length(Dir.path),1);
%     if strcmp(Dir.manipe{i},'Hab') ||...
%             strcmp(Dir.manipe{i},'TestPre') ||...
%             strcmp(Dir.manipe{i},'TestPostPAG') ||...
%             strcmp(Dir.manipe{i},'TestPostMFB') ||...
%             strcmp(Dir.manipe{i},'CondPAG') ||...
%             strcmp(Dir.manipe{i},'CondMFB')
        
        for j=1:length(Sham)
            Dir.group{1}{Sham(j)} = 'ReversalSham';
        end
        for j=1:length(Exp)
            Dir.group{2}{Exp(j)} = 'ReversalTest';
        end
        for j=1:length(SleepImport)
            Dir.group{3}{SleepImport(j)} = 'SleepImport';
        end
%     end
end

% sanity check
counter = 0;
flag_not_dir = false;
not_dir = [];
for i =1:length(Dir.path)
    for j=1:length(Dir.path{i})
        if ~isdir(Dir.path{i}{j})
            fprintf('*** Not a dir: %s.\n',Dir.path{i}{j});
            flag_not_dir = true;
            not_dir = [not_dir;{Dir.path{i}{j}}];
        else
            %fprintf('good dir: %s.\n',Dir.path{i}{j});
            counter = counter+1;
        end
    end
end

if ~flag_not_dir
    fprintf('Sanity Check OK : [%s] %d files correctly imported.\n',experiment,counter);
else
    for i=1:length(not_dir)
        fprintf('*** Not a dir: %s.\n',char(not_dir(i)));
    end
end

