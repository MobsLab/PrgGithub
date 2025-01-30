function R=DoAnalysisFor1mouse(DirAnalyse,DirAnalyse2,dur,removemissingPoint,movEp)


try
    removemissingPoint;
catch
    removemissingPoint=0;
end

try
    movEp;
catch
    movEp=0;    
end

[X1,Y1,V1,preSleep1,hab1,testPre1,cond1,postSleep1,testPost1,exploFinal1,sleep1,wake1,tot1,Stsd1] = loadData(DirAnalyse);

[TimeStepsPred36_1,LinearTrue36_1,LinearPred36_1,TimeStepsPredPreSleep36_1,TimeStepsPredPostSleep36_1,LinearPredPreSleep36_1,LinearPredPostSleep36_1,LossPred36_1, LossPredPreSleep36_1,LossPredPostSleep36_1,LossPredTsd36_1, LossPredPreSleepTsd36_1,LossPredPostSleepTsd36_1,LinearTrueTsd36_1, LinearPredTsd36_1,LinearPredPreSleepTsd36_1,LinearPredPostSleepTsd36_1] = importResultsf(DirAnalyse, DirAnalyse2, dur);

LinearTrueTsd = LinearTrueTsd36_1;
LinearPredTsd = LinearPredTsd36_1;
LossPredTsd=LossPredTsd36_1;

if movEp
    MovEpoch=thresholdIntervals(V1,7,'Direction','Above');
    LinearTrueTsd = Restrict(LinearTrueTsd36_1,MovEpoch);
    LinearPredTsd = Restrict(LinearPredTsd36_1,MovEpoch);
    LossPredTsd=Restrict(LossPredTsd36_1,MovEpoch);
end

%%
if removemissingPoint

    t = Range(LinearTrueTsd);
    d = Data(LinearTrueTsd);
    tPred = TimeStepsPred36_1;
    dPred = LinearPred36_1;
    tPredTsd = Range(LinearPredTsd);
    dPredTsd = Data(LinearPredTsd);
    for i = 1:(length(t)-1)
        if t(i+1)-t(i)>1
            for k = 1:length(tPredTsd)
                if tPredTsd(k) == t(i)
                    t1 = tPredTsd(k);
                end
                if tPredTsd(k) == t(i+1)
                    t2 = tPredTsd(k);
                end
            end
            for p = 1:length(tPredTsd)
                if tPredTsd(p) > t1 & tPredTsd(p) < t2
                    dPredTsd(p) = NaN;
                end
            end
            for j = 1:length(tPred)
                if tPred(j)>t1 & tPred(j) < t2
                    dPred(j) = NaN;
                end
            end
        end
    end

end

%%

[BadEpoch36_1,GoodEpoch36_1,EpochOK36_1] = good_bad_Single(LossPredTsd,X1,Y1);

[mean_errhabgood,mean_errtestPregood,mean_errcondgood,mean_errtestPostgood,mean_errhabbad,mean_errtestPrebad,mean_errcondbad,mean_errtestPostbad] = errorByEpoch(hab1,testPre1,cond1,testPost1,LinearPredTsd,LinearTrueTsd,EpochOK36_1,BadEpoch36_1);

R(1)=mean_errhabgood;
R(2)=mean_errhabbad;
R(3)=mean_errtestPregood;
R(4)=mean_errtestPrebad;
R(5)=mean_errcondgood;
R(6)=mean_errcondbad;
R(7)=mean_errtestPostgood;
R(8)=mean_errtestPostbad;

