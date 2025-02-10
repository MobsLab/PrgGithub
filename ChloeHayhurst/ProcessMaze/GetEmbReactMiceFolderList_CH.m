
SessNames={'TestPost_PostDrug'};

Dir=PathForExperimentsEmbReact_CH(SessNames{1});

for d=1:length(Dir.path)
    Mouse_names{d}= ['M' num2str(Dir.ExpeInfo{1, d}{1, 1}.nmouse)];
    Mouse(d)=Dir.ExpeInfo{1, d}{1, 1}.nmouse;
end


load('/media/nas6/ProjetEmbReact/transfer/Sess.mat')

for mouse = 1:length(Mouse)
    try
        HabSess24.(Mouse_names{mouse}) = Sess.(Mouse_names{mouse})(find(not(cellfun(@isempty,strfind(Sess.(Mouse_names{mouse}) ,'Habituation2')))));
        HabSessPre.(Mouse_names{mouse}) = Sess.(Mouse_names{mouse})(find(not(cellfun(@isempty,strfind(Sess.(Mouse_names{mouse}) ,'Habituation_')))));
        HabSess.(Mouse_names{mouse}) =  [HabSess24.(Mouse_names{mouse}) HabSessPre.(Mouse_names{mouse})];
        TestPreSess.(Mouse_names{mouse}) = Sess.(Mouse_names{mouse})(find(not(cellfun(@isempty,strfind(Sess.(Mouse_names{mouse}) ,'TestPre')))));
        TestPostPreSess.(Mouse_names{mouse}) = Sess.(Mouse_names{mouse})(find(not(cellfun(@isempty,strfind(Sess.(Mouse_names{mouse}) ,'TestPost_Pre')))));
        TestPostPostSess.(Mouse_names{mouse}) = Sess.(Mouse_names{mouse})(find(not(cellfun(@isempty,strfind(Sess.(Mouse_names{mouse}) ,'TestPost_Post')))));
        TestPostSess.(Mouse_names{mouse}) = Sess.(Mouse_names{mouse})(find(not(cellfun(@isempty,strfind(Sess.(Mouse_names{mouse}) ,'TestPost')))));
        TestSess.(Mouse_names{mouse}) = Sess.(Mouse_names{mouse})(find(not(cellfun(@isempty,strfind(Sess.(Mouse_names{mouse}) ,'Test')))));
        SleepSess.(Mouse_names{mouse}) = Sess.(Mouse_names{mouse})(find(not(cellfun(@isempty,strfind(Sess.(Mouse_names{mouse}) ,'Sleep')))));
        CondSess.(Mouse_names{mouse}) = Sess.(Mouse_names{mouse})(find(not(cellfun(@isempty,strfind(Sess.(Mouse_names{mouse}) ,'Cond')))));
        LastCondPreSess.(Mouse_names{mouse}) = Sess.(Mouse_names{mouse})(find(not(cellfun(@isempty,strfind(Sess.(Mouse_names{mouse}) ,'PreDrug/Cond3')))));
        ExtSess.(Mouse_names{mouse}) = Sess.(Mouse_names{mouse})(find(not(cellfun(@isempty,strfind(Sess.(Mouse_names{mouse}) ,'Ext')))));
        CondSessCorrections_CH
        FearSess.(Mouse_names{mouse}) =  [CondSess.(Mouse_names{mouse}) ExtSess.(Mouse_names{mouse})];
        CondExploSess.(Mouse_names{mouse}) = Sess.(Mouse_names{mouse})(find(not(cellfun(@isempty,strfind(Sess.(Mouse_names{mouse}) ,'CondExplo')))));
        FirstExtSess.(Mouse_names{mouse}) = [ExtSess.(Mouse_names{mouse})(1) ExtSess.(Mouse_names{mouse})(ceil(length(ExtSess.(Mouse_names{mouse}))/2)+1)];
        SleepPreSess.(Mouse_names{mouse}) = Sess.(Mouse_names{mouse})(find(not(cellfun(@isempty,strfind(Sess.(Mouse_names{mouse}) ,'SleepPre')))));
        SleepPostPreSess.(Mouse_names{mouse}) = Sess.(Mouse_names{mouse})(find(not(cellfun(@isempty,strfind(Sess.(Mouse_names{mouse}) ,'SleepPost_Pre')))));
        SleepPostPostSess.(Mouse_names{mouse}) = Sess.(Mouse_names{mouse})(find(not(cellfun(@isempty,strfind(Sess.(Mouse_names{mouse}) ,'SleepPost_Post')))));
        SleepPostSess.(Mouse_names{mouse}) = Sess.(Mouse_names{mouse})(find(not(cellfun(@isempty,strfind(Sess.(Mouse_names{mouse}) ,'SleepPost')))));

        % Protocole très long! 
        
        CondPreSess.(Mouse_names{mouse}) = CondSess.(Mouse_names{mouse})(1:6);
        CondPostSess.(Mouse_names{mouse}) = CondSess.(Mouse_names{mouse})(7:end);

    end
end
clear i j m mouse n SessNames 
