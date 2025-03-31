

SessNames={'TestPre'};
Dir1=PathForExperimentsEmbReact(SessNames{1});

SessNames={'TestPreNight'};
Dir2=PathForExperimentsEmbReact(SessNames{1});

SessNames={'TestPre_EyeShockTempProt'};
Dir3=PathForExperimentsEmbReact(SessNames{1});

SessNames={'TestPre_EyeShock'};
Dir4=PathForExperimentsEmbReact(SessNames{1});

SessNames={'TestPre_PreDrug_TempProt'};
Dir5=PathForExperimentsEmbReact(SessNames{1});

SessNames={'TestPre_PreDrug'};
Dir6=PathForExperimentsEmbReact(SessNames{1});

Dir7=MergePathForExperiment(Dir1,Dir2);
Dir8=MergePathForExperiment(Dir3,Dir4);
Dir9=MergePathForExperiment(Dir5,Dir6);

Dir10=MergePathForExperiment(Dir7,Dir8);
Dir=MergePathForExperiment(Dir10,Dir9);


for d=1:length(Dir.path)
    Mouse_names{d}= ['M' num2str(Dir.ExpeInfo{1, d}{1, 1}.nmouse)];
    Mouse(d)=Dir.ExpeInfo{1, d}{1, 1}.nmouse;
end


load('/media/nas6/ProjetEmbReact/transfer/Sess.mat')

% Mouse=Drugs_Groups_UMaze_BM(11);
clear Mouse_names
for mouse =1:length(Mouse)
    Mouse_names{mouse}=['M' num2str(Mouse(mouse))];
    TestPreSess.(Mouse_names{mouse}) = Sess.(Mouse_names{mouse})(find(not(cellfun(@isempty,strfind(Sess.(Mouse_names{mouse}) ,'TestPre')))));
    TestPostSess.(Mouse_names{mouse}) = Sess.(Mouse_names{mouse})(find(not(cellfun(@isempty,strfind(Sess.(Mouse_names{mouse}) ,'TestPost')))));
    
    CondSess_Pre.(Mouse_names{mouse}) = Sess.(Mouse_names{mouse})(find(not(cellfun(@isempty,strfind(Sess.(Mouse_names{mouse}) ,'Cond')))));
    SoundCondSess.(Mouse_names{mouse}) = find(not(cellfun(@isempty,strfind(CondSess_Pre.(Mouse_names{mouse}) ,'Sound'))));
    if isempty(SoundCondSess.(Mouse_names{mouse}))
        CondSess.(Mouse_names{mouse}) = CondSess_Pre.(Mouse_names{mouse});
    else
        CondSess.(Mouse_names{mouse}) = CondSess_Pre.(Mouse_names{mouse})(1:SoundCondSess.(Mouse_names{mouse})(1)-1);
    end
    ind=round(length(CondSess.(Mouse_names{mouse}))/2);
    CondPreSess.(Mouse_names{mouse}) = CondSess.(Mouse_names{mouse})(1:ind);
    CondPostSess.(Mouse_names{mouse}) = CondSess.(Mouse_names{mouse})(ind+1:end);
    ExtSess.(Mouse_names{mouse}) = Sess.(Mouse_names{mouse})(find(not(cellfun(@isempty,strfind(Sess.(Mouse_names{mouse}) ,'Ext')))));
%     CondSessCorrections
    FearSess.(Mouse_names{mouse}) = [CondSess.(Mouse_names{mouse}) ExtSess.(Mouse_names{mouse})];
    
    HabSess.(Mouse_names{mouse}) = Sess.(Mouse_names{mouse})(find(not(cellfun(@isempty,strfind(Sess.(Mouse_names{mouse}) ,'Habituation')))));
    SleepSess.(Mouse_names{mouse}) = Sess.(Mouse_names{mouse})(find(not(cellfun(@isempty,strfind(Sess.(Mouse_names{mouse}) ,'Sleep')))));
end


CondSess.M431 = CondSess.M431(1:10);

HabSess.M1146 = HabSess.M1146([1:3 5:6]);
HabSess.M561 = HabSess.M561([1 3 5:6]);
HabSess.M688 = HabSess.M688([1:3 6]);
HabSess.M1225 = HabSess.M1225([1:4 6]);


clear Dir Dir1 Dir2 Dir3 Dir4 Dir5 Dir6 Dir7 Dir8 Dir9



