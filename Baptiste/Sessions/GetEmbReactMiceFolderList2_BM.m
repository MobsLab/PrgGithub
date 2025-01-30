

SessNames={'Habituation24HPre_PreDrug_TempProt'};

Dir1=PathForExperimentsEmbReact(SessNames{1});

SessNames={'TestPre_PreDrug'};

Dir2=PathForExperimentsEmbReact(SessNames{1});

Dir=MergePathForExperiment(Dir1,Dir2);

for d=1:length(Dir.path)
    Mouse_names{d}= ['M' num2str(Dir.ExpeInfo{1, d}{1, 1}.nmouse)];
    Mouse(d)=Dir.ExpeInfo{1, d}{1, 1}.nmouse;
end

cd('/media/nas6/ProjetEmbReact/transfer')
load('Sess.mat')

for mouse =1:length(Mouse_names)
    %Sess.(Mouse_names{mouse}) = GetAllMouseTaskSessions(Mouse(mouse));
    TestPostSess.(Mouse_names{mouse}) = Sess.(Mouse_names{mouse})(find(not(cellfun(@isempty,strfind(Sess.(Mouse_names{mouse}) ,'TestPost')))));
    TestSess.(Mouse_names{mouse}) = Sess.(Mouse_names{mouse})(find(not(cellfun(@isempty,strfind(Sess.(Mouse_names{mouse}) ,'Test')))));
    CondSess.(Mouse_names{mouse}) = Sess.(Mouse_names{mouse})(find(not(cellfun(@isempty,strfind(Sess.(Mouse_names{mouse}) ,'Cond')))));
    CondPreSess.(Mouse_names{mouse}) = CondSess.(Mouse_names{mouse})(1:6);
    CondPostSess.(Mouse_names{mouse}) = CondSess.(Mouse_names{mouse})(6:end);
    ExtSess.(Mouse_names{mouse}) = Sess.(Mouse_names{mouse})(find(not(cellfun(@isempty,strfind(Sess.(Mouse_names{mouse}) ,'Ext')))));
    %CondSessCorrections
    FearSess.(Mouse_names{mouse}) =  [CondSess.(Mouse_names{mouse}) ExtSess.(Mouse_names{mouse})];
    TestPreSess.(Mouse_names{mouse}) = Sess.(Mouse_names{mouse})(find(not(cellfun(@isempty,strfind(Sess.(Mouse_names{mouse}) ,'TestPre')))));
    CondExploSess.(Mouse_names{mouse}) = Sess.(Mouse_names{mouse})(find(not(cellfun(@isempty,strfind(Sess.(Mouse_names{mouse}) ,'CondExplo')))));
    FirstExtSess.(Mouse_names{mouse}) = [ExtSess.(Mouse_names{mouse})(1) ExtSess.(Mouse_names{mouse})(ceil(length(ExtSess.(Mouse_names{mouse}))/2)+1)];
end
