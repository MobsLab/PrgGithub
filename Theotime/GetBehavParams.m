function [StructOutput] = GetBehavParams(Dir, varargin)
%GETBEHAVPARAMS Summary of this function goes here
%   Detailed explanation goes here
p = inputParser;
defaultParams = V;
defaultrestrictFlag = false;
addRequired(p,'params',defaultplotFlag);
addOptional(p, 'restrict', defaultrestrictFlag)

parse(p,varargin{:});
paramsFlag = p.Results.params;
restrict= p.Results.restrict;

for imouse = 1:length(Dir.path)
    cd(Dir.path{imouse}{1});
    load('behavResources.mat');
    load('SWR.mat');
    % load('SpikeData.mat');
    cd(Dir.results{imouse}{1});
    load('LinearPred.mat');
    load('TimeStepsPred.mat')
    load('LossPred.mat')
    load('LinearTrue.mat')


    try
        % old fashion data
        % Range(S{1});
        % Stsd=S;
        t=Range(AlignedXtsd);
        X=AlignedXtsd;

        Y=AlignedYtsd;
        V=Vtsd;
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
        t = AlignedXtsd.data;
        X = tsd(AlignedXtsd.t,AlignedXtsd.data);
        Y = tsd(AlignedYtsd.t,AlignedYtsd.data);
        V = tsd(Vtsd.t,Vtsd.data);
        hab1 = intervalSet(SessionEpoch.Hab1.start,SessionEpoch.Hab1.stop);
        hab2 = intervalSet(SessionEpoch.Hab2.start,SessionEpoch.Hab2.stop);
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
        tot = or(testPre,sleep);
    end

    smootime = 2; % in s
    Smooth_Speed = tsd(Range(V) , movmean(Data(V), ceil(smootime/median(diff(Range(V,'s'))))));
    Vraw = V;
    V = Smooth_Speed;
    Moving=thresholdIntervals(V,2,'Direction','Above');
    TotEpoch=intervalSet(0,max(Range(V)));
    NonMoving=TotEpoch-Moving;
    LossPredTsd=tsd(TimeStepsPred*1E4,LossPred);
    LinearTrueTsd=tsd(TimeStepsPred*1E4,LinearTrue);
    LinearPredTsd=tsd(TimeStepsPred*1E4,LinearPred);
    LossPredCorrected=LossPred;
    LossPredCorrected(LossPredCorrected<-15)=NaN;
    LossPredTsdCorrected=tsd(TimeStepsPred*1E4,LossPredCorrected);
    LossPredTsd = LossPredTsdCorrected;
    try
        LinearPredSleepTsd=tsd(TimeStepsPredSleep*1E4,LinearPredSleep);
    catch
    end

    BadEpoch=thresholdIntervals(LossPredTsd,quantile(Data(LossPredTsd), 0.75),'Direction','Above');
    GoodEpoch=thresholdIntervals(LossPredTsd,quantile(Data(LossPredTsd), 0.15),'Direction','Below');
    stim=ts(Start(StimEpoch));
    RipEp=intervalSet(Range(tRipples)-0.2*1E4,Range(tRipples)+0.2*1E4);RipEp=mergeCloseIntervals(RipEp,1);


    if restrict
        LossPredTsd = Restrict(Restrict(LossPredTsd, NonMoving), tot - sleep);
        V = Restrict(Restrict(V, NonMoving), tot - sleep);
    end

        LossPredTsd_list{imouse} = LossPredTsd;
        Vtsd_list{imouse} = V;

end

end

