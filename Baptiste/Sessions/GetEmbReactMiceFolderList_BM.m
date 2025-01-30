
SessNames={'TestPost_PostDrug'};

Dir=PathForExperimentsEmbReact(SessNames{1});

for d=1:length(Dir.path)
    Mouse_names{d}= ['M' num2str(Dir.ExpeInfo{1, d}{1, 1}.nmouse)];
    Mouse(d)=Dir.ExpeInfo{1, d}{1, 1}.nmouse;
    %     DrugType{d} = Dir.ExpeInfo{1,d}{1,1}.DrugInjected; % addition SB
end


load('/media/nas6/ProjetEmbReact/transfer/Sess.mat')

Sessions_PAG_Mice_ERC_DZP_BM

for mouse =[1:60 65:length(Mouse)]
    try
        %Sess.(Mouse_names{mouse}) = GetAllMouseTaskSessions(Mouse(mouse));
        HabSess24.(Mouse_names{mouse}) = Sess.(Mouse_names{mouse})(find(not(cellfun(@isempty,strfind(Sess.(Mouse_names{mouse}) ,'Habituation2')))));
        HabSessPre.(Mouse_names{mouse}) = Sess.(Mouse_names{mouse})(find(not(cellfun(@isempty,strfind(Sess.(Mouse_names{mouse}) ,'Habituation_')))));
        HabSess.(Mouse_names{mouse}) =  [HabSess24.(Mouse_names{mouse}) HabSessPre.(Mouse_names{mouse})];
        TestPreSess.(Mouse_names{mouse}) = Sess.(Mouse_names{mouse})(find(not(cellfun(@isempty,strfind(Sess.(Mouse_names{mouse}) ,'TestPre')))));
        TestPostSess.(Mouse_names{mouse}) = Sess.(Mouse_names{mouse})(find(not(cellfun(@isempty,strfind(Sess.(Mouse_names{mouse}) ,'TestPost')))));
        TestSess.(Mouse_names{mouse}) = Sess.(Mouse_names{mouse})(find(not(cellfun(@isempty,strfind(Sess.(Mouse_names{mouse}) ,'Test')))));
        SleepSess.(Mouse_names{mouse}) = Sess.(Mouse_names{mouse})(find(not(cellfun(@isempty,strfind(Sess.(Mouse_names{mouse}) ,'Sleep')))));
        CondSess.(Mouse_names{mouse}) = Sess.(Mouse_names{mouse})(find(not(cellfun(@isempty,strfind(Sess.(Mouse_names{mouse}) ,'Cond')))));
        ExtSess.(Mouse_names{mouse}) = Sess.(Mouse_names{mouse})(find(not(cellfun(@isempty,strfind(Sess.(Mouse_names{mouse}) ,'Ext')))));
        CondSessCorrections
        FearSess.(Mouse_names{mouse}) =  [CondSess.(Mouse_names{mouse}) ExtSess.(Mouse_names{mouse})];
        TestPreSess.(Mouse_names{mouse}) = Sess.(Mouse_names{mouse})(find(not(cellfun(@isempty,strfind(Sess.(Mouse_names{mouse}) ,'TestPre')))));
        CondExploSess.(Mouse_names{mouse}) = Sess.(Mouse_names{mouse})(find(not(cellfun(@isempty,strfind(Sess.(Mouse_names{mouse}) ,'CondExplo')))));
        FirstExtSess.(Mouse_names{mouse}) = [ExtSess.(Mouse_names{mouse})(1) ExtSess.(Mouse_names{mouse})(ceil(length(ExtSess.(Mouse_names{mouse}))/2)+1)];
        SleepPreSess.(Mouse_names{mouse}) = Sess.(Mouse_names{mouse})(find(not(cellfun(@isempty,strfind(Sess.(Mouse_names{mouse}) ,'SleepPre')))));
        SleepPostSess.(Mouse_names{mouse}) = Sess.(Mouse_names{mouse})(find(not(cellfun(@isempty,strfind(Sess.(Mouse_names{mouse}) ,'SleepPost')))));
        
        if sum(mouse==[30:39 41:48 50:54 65:71 73:length(Mouse)])==1 % Short protocol
            CondPreSess.(Mouse_names{mouse}) = CondSess.(Mouse_names{mouse})(1:6);
            CondPostSess.(Mouse_names{mouse}) = CondSess.(Mouse_names{mouse})(7:end);
            RealTimeSess1.(Mouse_names{mouse}) = CondPreSess.(Mouse_names{mouse})(1:3);
            RealTimeSess2.(Mouse_names{mouse}) = CondPreSess.(Mouse_names{mouse})(4:end);
            RealTimeSess3.(Mouse_names{mouse}) = CondPostSess.(Mouse_names{mouse})(1);
            RealTimeSess4.(Mouse_names{mouse}) = CondPostSess.(Mouse_names{mouse})(2:end);
            RealTimeSess5.(Mouse_names{mouse}) = TestPostSess.(Mouse_names{mouse});
            RealTimeSess6.(Mouse_names{mouse}) = FirstExtSess.(Mouse_names{mouse});
            RealTimeSess7.(Mouse_names{mouse}) = ExtSess.(Mouse_names{mouse})(3:end);
        elseif mouse==72
            CondPreSess.(Mouse_names{mouse}) = CondSess.(Mouse_names{mouse})(1:3);
            CondPostSess.(Mouse_names{mouse}) = CondSess.(Mouse_names{mouse})(4:end);
        else % Long protocol
            CondPreSess.(Mouse_names{mouse}) = CondSess.(Mouse_names{mouse})(1:6);
            CondPostSess.(Mouse_names{mouse}) = CondSess.(Mouse_names{mouse})(7:end);
            RealTimeSess1.(Mouse_names{mouse}) = CondPreSess.(Mouse_names{mouse})(1:3);
            RealTimeSess2.(Mouse_names{mouse}) = CondPreSess.(Mouse_names{mouse})(4:end);
            RealTimeSess3.(Mouse_names{mouse}) = CondPostSess.(Mouse_names{mouse})(1:3);
            RealTimeSess4.(Mouse_names{mouse}) = CondPostSess.(Mouse_names{mouse})(4:end);
            RealTimeSess5.(Mouse_names{mouse}) = TestPostSess.(Mouse_names{mouse});
            RealTimeSess6.(Mouse_names{mouse}) = FirstExtSess.(Mouse_names{mouse});
            RealTimeSess7.(Mouse_names{mouse}) = ExtSess.(Mouse_names{mouse})(3:end);
        end
    end
end


for mouse =[61:64]
    TestPostSess.(Mouse_names{mouse}) = Sess.(Mouse_names{mouse})(find(not(cellfun(@isempty,strfind(Sess.(Mouse_names{mouse}) ,'TestPost')))));
    TestPreSess.(Mouse_names{mouse}) = Sess.(Mouse_names{mouse})(find(not(cellfun(@isempty,strfind(Sess.(Mouse_names{mouse}) ,'TestPre')))));
    FirstExtSess.(Mouse_names{mouse}) = [ExtSess.(Mouse_names{mouse})(1) ExtSess.(Mouse_names{mouse})(ceil(length(ExtSess.(Mouse_names{mouse}))/2)+1)];
    RealTimeSess1.(Mouse_names{mouse}) = CondPreSess.(Mouse_names{mouse})(1:3);
    RealTimeSess2.(Mouse_names{mouse}) = CondPreSess.(Mouse_names{mouse})(4:end);
    RealTimeSess3.(Mouse_names{mouse}) = CondPostSess.(Mouse_names{mouse})(1:3);
    RealTimeSess4.(Mouse_names{mouse}) = CondPostSess.(Mouse_names{mouse})(4:end);
    RealTimeSess5.(Mouse_names{mouse}) = TestPostSess.(Mouse_names{mouse});
    RealTimeSess6.(Mouse_names{mouse}) = FirstExtSess.(Mouse_names{mouse});
    RealTimeSess7.(Mouse_names{mouse}) = ExtSess.(Mouse_names{mouse})(3:end);
end

for mouse = [144]
     HabSess24.(Mouse_names{mouse}) = Sess.(Mouse_names{mouse})(find(not(cellfun(@isempty,strfind(Sess.(Mouse_names{mouse}) ,'Habituation2')))));
        HabSessPre.(Mouse_names{mouse}) = Sess.(Mouse_names{mouse})(find(not(cellfun(@isempty,strfind(Sess.(Mouse_names{mouse}) ,'Habituation_')))));
        HabSess.(Mouse_names{mouse}) =  [HabSess24.(Mouse_names{mouse}) HabSessPre.(Mouse_names{mouse})];
        TestPreSess.(Mouse_names{mouse}) = Sess.(Mouse_names{mouse})(find(not(cellfun(@isempty,strfind(Sess.(Mouse_names{mouse}) ,'TestPre')))));
        TestPostSess.(Mouse_names{mouse}) = Sess.(Mouse_names{mouse})(find(not(cellfun(@isempty,strfind(Sess.(Mouse_names{mouse}) ,'TestPost')))));
        TestSess.(Mouse_names{mouse}) = Sess.(Mouse_names{mouse})(find(not(cellfun(@isempty,strfind(Sess.(Mouse_names{mouse}) ,'Test')))));
        SleepSess.(Mouse_names{mouse}) = Sess.(Mouse_names{mouse})(find(not(cellfun(@isempty,strfind(Sess.(Mouse_names{mouse}) ,'Sleep')))));
        CondSess.(Mouse_names{mouse}) = Sess.(Mouse_names{mouse})(find(not(cellfun(@isempty,strfind(Sess.(Mouse_names{mouse}) ,'Cond')))));
        CondSessCorrections_CH
        FearSess.(Mouse_names{mouse}) =  [CondSess.(Mouse_names{mouse})];
        TestPreSess.(Mouse_names{mouse}) = Sess.(Mouse_names{mouse})(find(not(cellfun(@isempty,strfind(Sess.(Mouse_names{mouse}) ,'TestPre')))));
        CondExploSess.(Mouse_names{mouse}) = Sess.(Mouse_names{mouse})(find(not(cellfun(@isempty,strfind(Sess.(Mouse_names{mouse}) ,'CondExplo')))));
        CondPreSess.(Mouse_names{mouse}) = CondSess.(Mouse_names{mouse})(1:6);
        CondPostSess.(Mouse_names{mouse}) = CondSess.(Mouse_names{mouse})(7:12);
end
clear i j m mouse n SessNames RealTimeSess1 RealTimeSess2 RealTimeSess3 RealTimeSess4 RealTimeSess5 RealTimeSess6 RealTimeSess7 d


for mouse =[146:length(Mouse)]
    try
        HabSess24.(Mouse_names{mouse}) = Sess.(Mouse_names{mouse})(find(not(cellfun(@isempty,strfind(Sess.(Mouse_names{mouse}) ,'Habituation2')))));
        HabSessPre.(Mouse_names{mouse}) = Sess.(Mouse_names{mouse})(find(not(cellfun(@isempty,strfind(Sess.(Mouse_names{mouse}) ,'Habituation_')))));
        HabSess.(Mouse_names{mouse}) =  [HabSess24.(Mouse_names{mouse}) HabSessPre.(Mouse_names{mouse})];
        TestPreSess.(Mouse_names{mouse}) = Sess.(Mouse_names{mouse})(find(not(cellfun(@isempty,strfind(Sess.(Mouse_names{mouse}) ,'TestPre')))));
        TestPostPreSess.(Mouse_names{mouse}) = Sess.(Mouse_names{mouse})(find(not(cellfun(@isempty,strfind(Sess.(Mouse_names{mouse}) ,'TestPost_Pre')))));
        TestPostPostSess.(Mouse_names{mouse}) = Sess.(Mouse_names{mouse})(find(not(cellfun(@isempty,strfind(Sess.(Mouse_names{mouse}) ,'TestPost_Post')))));
%         TestSess.(Mouse_names{mouse}) = Sess.(Mouse_names{mouse})(find(not(cellfun(@isempty,strfind(Sess.(Mouse_names{mouse}) ,'Test')))));
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
    end
end


% if SB_modif_GetEmbReactMiceFolderList_Bm==1
%     D = length(DrugType);
%
%     SessNames={'TestPost_PreDrug_TempProt'};
%
%     Dir=PathForExperimentsEmbReact(SessNames{1});
%
%     for d=1:length(Dir.path)
%         Mouse_names{d+D}= ['M' num2str(Dir.ExpeInfo{1, d}{1, 1}.nmouse)];
%         Mouse(d+D)=Dir.ExpeInfo{1, d}{1, 1}.nmouse;
%         DrugType{d+D} = 'SALINE'; % addition SB
%     end
%
% end

%
% Mouse=[1252];
% try
%     for mouse = 1:length(Mouse)
%         Mouse_names{mouse}=['M' num2str(Mouse(mouse))];
%         BaselineSleepSess.(Mouse_names{mouse}) = GetBaselineSleepSessions_BM(Mouse(mouse));
%         BaselineSleepSess.(Mouse_names{mouse}) = [{BaselineSleepSess.(Mouse_names{mouse}){1}}];
%     end
% end

%
