function [testPre, hab, cond, testPost, sleep, tot] = GetEpochsFromSessionEpoch(SessionEpoch)
%GETEPOCHSFROMSESSIONEPOCH This function takes a SessionEpoch object and returns several epochs of interest.
%   The function takes a SessionEpoch object and returns the following epochs:
%   testPre, hab, cond, testPost, sleep, tot.
%   The function is able to handle both the old and new style of data.
sleep = 0;
try
    preSleep=SessionEpoch.PreSleep;
    try
        hab = or(SessionEpoch.Hab1,SessionEpoch.Hab2);
    catch error
        hab = SessionEpoch.Hab;
    end

    try
        testPre=or(or(SessionEpoch.Hab1,SessionEpoch.Hab2),or(or(SessionEpoch.TestPre1,SessionEpoch.TestPre2),or(SessionEpoch.TestPre3,SessionEpoch.TestPre4)));
    catch
        testPre=or(SessionEpoch.Hab,or(or(SessionEpoch.TestPre1,SessionEpoch.TestPre2),or(SessionEpoch.TestPre3,SessionEpoch.TestPre4)));
    end

    cond=or(or(SessionEpoch.Cond1,SessionEpoch.Cond2),or(SessionEpoch.Cond3,SessionEpoch.Cond4));
    postSleep=SessionEpoch.PostSleep;
    testPost=or(or(SessionEpoch.TestPost1,SessionEpoch.TestPost2),or(SessionEpoch.TestPost3,SessionEpoch.TestPost4));
    try
        extinct = SessionEpoch.Extinct;
        sleep = or(preSleep,postSleep);
        tot=or(or(hab,or(testPre,or(testPost,or(cond,extinct)))),sleep);
    catch
        disp('no extinct session')
        sleep = or(preSleep,postSleep);
        tot=or(or(hab,or(testPre,or(testPost, cond))),sleep);
    end

catch
    % Dima's style of data
    % clear Stsd
    % for i=1:length(S.C)
    %     test=S.C{1,i};
    %     Stsd{i}=ts(test.data);
    % end
    % Stsd=tsdArray(Stsd);
    hab1 = intervalSet(SessionEpoch.Hab1.start,SessionEpoch.Hab1.stop);
    hab2 = intervalSet(SessionEpoch.Hab2.start,SessionEpoch.Hab2.stop);
    hab = or(hab1, hab2)
    testPre1=intervalSet(SessionEpoch.TestPre1.start,SessionEpoch.TestPre1.stop);
    testPre2=intervalSet(SessionEpoch.TestPre1.start,SessionEpoch.TestPre2.stop);
    testPre3=intervalSet(SessionEpoch.TestPre1.start,SessionEpoch.TestPre3.stop);
    testPre4=intervalSet(SessionEpoch.TestPre1.start,SessionEpoch.TestPre4.stop);
    testPre=or(or(hab1,hab2),or(or(testPre1,testPre2),or(testPre3,testPre4)));
    cond1 = intervalSet(SessionEpoch.Cond1.start,SessionEpoch.Cond1.stop);
    cond2 = intervalSet(SessionEpoch.Cond2.start,SessionEpoch.Cond2.stop);
    cond3 = intervalSet(SessionEpoch.Cond3.start,SessionEpoch.Cond3.stop);
    cond4 = intervalSet(SessionEpoch.Cond4.start,SessionEpoch.Cond4.stop);
    cond = or(or(cond1,cond2),or(cond3,cond4));
    postSleep = intervalSet(SessionEpoch.PostSleep.start,SessionEpoch.PostSleep.stop);
    preSleep = intervalSet(SessionEpoch.PreSleep.start,SessionEpoch.PreSleep.stop);
    sleep = or(preSleep,postSleep);
    tot=or(or(hab,or(testPre,or(testPost, cond))),sleep);
end
end

