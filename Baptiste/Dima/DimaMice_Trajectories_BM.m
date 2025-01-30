

clear all

Dir=PathForExperimentsERC_Dima('UMazePAG');

for d=1:length(Dir.path)
    Mouse_names{d}= ['M' num2str(Dir.ExpeInfo{1, d}.nmouse)];
    Mouse(d)=Dir.ExpeInfo{1, d}.nmouse;
end


Session_type={'TestPre','Cond','TestPost'};

for mouse=1:length(Mouse)
    
    cd(Dir.path{mouse}{1})
    load('behavResources.mat','SessionEpoch', 'AlignedXtsd', 'AlignedYtsd')
    
    CondEpoch.(Mouse_names{mouse}) =  or(SessionEpoch.Cond1,or(SessionEpoch.Cond2,or(SessionEpoch.Cond3,SessionEpoch.Cond4)));    
    try
        TestPreEpoch.(Mouse_names{mouse}) =  or(or(SessionEpoch.TestPre1,SessionEpoch.TestPre2) , or(SessionEpoch.TestPre3,SessionEpoch.TestPre4));
    catch
        try
            TestPreEpoch.(Mouse_names{mouse}) =  or(or(SessionEpoch.TestPre1,SessionEpoch.TestPre2) , SessionEpoch.TestPre4);
        catch
            TestPreEpoch.(Mouse_names{mouse}) =  intervalSet([],[]);
        end
    end
    TestPostEpoch.(Mouse_names{mouse}) =  or(or(SessionEpoch.TestPost1,SessionEpoch.TestPost2) , or(SessionEpoch.TestPost3,SessionEpoch.TestPost4));
    
    for sess=1:3
        
        if sess==1
            Epoch_to_use=TestPreEpoch.(Mouse_names{mouse});
        elseif sess==2
            Epoch_to_use=CondEpoch.(Mouse_names{mouse});
        elseif sess==3
            Epoch_to_use=TestPostEpoch.(Mouse_names{mouse});
        end
        
        Position.(Session_type{sess}).(Mouse_names{mouse}) = [Data(Restrict(AlignedXtsd,Epoch_to_use)) Data(Restrict(AlignedYtsd,Epoch_to_use))];
        
        load('behavResources.mat', 'TTLInfo')
        StimEpoch.(Mouse_names{mouse})=and(TTLInfo.StimEpoch,CondEpoch.(Mouse_names{mouse}));

        Position_Stim.(Session_type{sess}).(Mouse_names{mouse}) = [Data(Restrict(AlignedXtsd , ts(Start(StimEpoch.(Mouse_names{mouse}))))) Data(Restrict(AlignedYtsd , ts(Start(StimEpoch.(Mouse_names{mouse})))))];
        
    end
    disp(Mouse_names{mouse})
end



figure
plot(Position.Cond.M711(:,1) , Position.Cond.M711(:,2) , '.')
hold on
plot(Position_Stim.Cond.M711(:,1) , Position_Stim.Cond.M711(:,2) , '*r')


