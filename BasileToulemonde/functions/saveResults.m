function saveResults(dirAnalysis1, dirAnalysis2)
    try
        [TimeStepsPred36,LinearTrue36,LinearPred36,TimeStepsPredPreSleep36,TimeStepsPredPostSleep36,LinearPredPreSleep36,LinearPredPostSleep36,LossPred36, LossPredPreSleep36,LossPredPostSleep36,LossPredTsd36, LossPredPreSleepTsd36,LossPredPostSleepTsd36,LinearTrueTsd36, LinearPredTsd36,LinearPredPreSleepTsd36,LinearPredPostSleepTsd36,XpredTsd36,YpredTsd36] = importResultsf(dirAnalysis1, dirAnalysis2, 36);
        tps36=[TimeStepsPredPreSleep36;TimeStepsPred36;TimeStepsPredPostSleep36]*1E4;
        linearPred36tot=[LinearPredPreSleep36;LinearPred36;LinearPredPostSleep36];
        lossPredtot36=[LossPredPreSleep36;LossPred36;LossPredPostSleep36];
        [tps36,id36]=sort(tps36);
        linearPred36tot=linearPred36tot(id36);
        lossPredtot36=lossPredtot36(id36);
        LinearPredTsd36tot=tsd(tps36,linearPred36tot);
        LossPredTsd36tot=tsd(tps36,lossPredtot36);
        save(strcat(dirAnalysis1,'/DataPred36'), 'TimeStepsPred36', 'LinearTrue36', 'LinearPred36', 'TimeStepsPredPreSleep36', 'TimeStepsPredPostSleep36', 'LinearPredPreSleep36', 'LinearPredPostSleep36', 'LossPred36', 'LossPredPreSleep36', 'LossPredPostSleep36', 'LossPredTsd36', 'LossPredPreSleepTsd36', 'LossPredPostSleepTsd36', 'LinearTrueTsd36', 'LinearPredTsd36', 'LinearPredPreSleepTsd36', 'LinearPredPostSleepTsd36', 'LinearPredTsd36tot','LossPredTsd36tot', 'XpredTsd36', 'YpredTsd36')

        [TimeStepsPred200,LinearTrue200,LinearPred200,TimeStepsPredPreSleep200,TimeStepsPredPostSleep200,LinearPredPreSleep200,LinearPredPostSleep200,LossPred200, LossPredPreSleep200,LossPredPostSleep200,LossPredTsd200, LossPredPreSleepTsd200,LossPredPostSleepTsd200,LinearTrueTsd200, LinearPredTsd200,LinearPredPreSleepTsd200,LinearPredPostSleepTsd200,XpredTsd200,YpredTsd200] = importResultsf(dirAnalysis1, dirAnalysis2, 200);
        tps200=[TimeStepsPredPreSleep200;TimeStepsPred200;TimeStepsPredPostSleep200]*1E4;
        linearPred200tot=[LinearPredPreSleep200;LinearPred200;LinearPredPostSleep200];
        lossPredtot200=[LossPredPreSleep200;LossPred200;LossPredPostSleep200];
        [tps200,id200]=sort(tps200);
        linearPred200tot=linearPred200tot(id200);
        lossPredtot200=lossPredtot200(id200);
        LinearPredTsd200tot=tsd(tps200,linearPred200tot);
        LossPredTsd200tot=tsd(tps200,lossPredtot200);
        save(strcat(dirAnalysis1,'/DataPred200'), 'TimeStepsPred200', 'LinearTrue200', 'LinearPred200', 'TimeStepsPredPreSleep200', 'TimeStepsPredPostSleep200', 'LinearPredPreSleep200', 'LinearPredPostSleep200', 'LossPred200', 'LossPredPreSleep200', 'LossPredPostSleep200', 'LossPredTsd200', 'LossPredPreSleepTsd200', 'LossPredPostSleepTsd200', 'LinearTrueTsd200', 'LinearPredTsd200', 'LinearPredPreSleepTsd200', 'LinearPredPostSleepTsd200','LinearPredTsd200tot','LossPredTsd200tot', 'XpredTsd200', 'YpredTsd200')        
        dist2Wall = distanceToTheWall(dirAnalysis1);
        dist2WallTsd = tsd(TimeStepsPred200*1E4,dist2Wall);
        save(strcat(dirAnalysis1,'/DataPred200'), 'TimeStepsPred200', 'LinearTrue200', 'LinearPred200', 'TimeStepsPredPreSleep200', 'TimeStepsPredPostSleep200', 'LinearPredPreSleep200', 'LinearPredPostSleep200', 'LossPred200', 'LossPredPreSleep200', 'LossPredPostSleep200', 'LossPredTsd200', 'LossPredPreSleepTsd200', 'LossPredPostSleepTsd200', 'LinearTrueTsd200', 'LinearPredTsd200', 'LinearPredPreSleepTsd200', 'LinearPredPostSleepTsd200','LinearPredTsd200tot','LossPredTsd200tot', 'XpredTsd200', 'YpredTsd200', 'dist2WallTsd') 
        
        [TimeStepsPred504,LinearTrue504,LinearPred504,TimeStepsPredPreSleep504,TimeStepsPredPostSleep504,LinearPredPreSleep504,LinearPredPostSleep504,LossPred504, LossPredPreSleep504,LossPredPostSleep504,LossPredTsd504, LossPredPreSleepTsd504,LossPredPostSleepTsd504,LinearTrueTsd504, LinearPredTsd504,LinearPredPreSleepTsd504,LinearPredPostSleepTsd504,XpredTsd504,YpredTsd504] = importResultsf(dirAnalysis1, dirAnalysis2, 504);
        tps504=[TimeStepsPredPreSleep504;TimeStepsPred504;TimeStepsPredPostSleep504]*1E4;
        linearPred504tot=[LinearPredPreSleep504;LinearPred504;LinearPredPostSleep504];
        lossPredtot504=[LossPredPreSleep504;LossPred504;LossPredPostSleep504];
        [tps504,id504]=sort(tps504);
        linearPred504tot=linearPred504tot(id504);
        lossPredtot504=lossPredtot504(id504);
        LinearPredTsd504tot=tsd(tps504,linearPred504tot);
        LossPredTsd504tot=tsd(tps504,lossPredtot504);
        save(strcat(dirAnalysis1,'/DataPred504'), 'TimeStepsPred504', 'LinearTrue504', 'LinearPred504', 'TimeStepsPredPreSleep504', 'TimeStepsPredPostSleep504', 'LinearPredPreSleep504', 'LinearPredPostSleep504', 'LossPred504', 'LossPredPreSleep504', 'LossPredPostSleep504', 'LossPredTsd504', 'LossPredPreSleepTsd504', 'LossPredPostSleepTsd504', 'LinearTrueTsd504', 'LinearPredTsd504', 'LinearPredPreSleepTsd504', 'LinearPredPostSleepTsd504','LinearPredTsd504tot','LossPredTsd504tot', 'XpredTsd504', 'YpredTsd504')

        [X,Y,V,preSleep,hab,testPre,condi,postSleep,testPost,exploFinal,sleep,wake,tot,Stsd, tRipples] = loadData(dirAnalysis1);
        save(strcat(dirAnalysis1,'/DataDoAnalysisFor1mouse'), 'X', 'Y', 'V', 'preSleep', 'hab', 'testPre', 'condi', 'postSleep', 'testPost', 'exploFinal', 'sleep', 'wake', 'tot', 'Stsd', 'tRipples');
        [BadEpoch36,GoodEpoch36,EpochOK36] = good_bad_Single(LossPredTsd36tot,X,Y);
        save(strcat(dirAnalysis1,'/Epochs36'), 'BadEpoch36','GoodEpoch36','EpochOK36');
        [BadEpoch200,GoodEpoch200,EpochOK200] = good_bad_Single(LossPredTsd200tot,X,Y);
        save(strcat(dirAnalysis1,'/Epochs200'), 'BadEpoch200','GoodEpoch200','EpochOK200');
        [BadEpoch504,GoodEpoch504,EpochOK504] = good_bad_Single(LossPredTsd504tot,X,Y);
        save(strcat(dirAnalysis1,'/Epochs504'), 'BadEpoch504','GoodEpoch504','EpochOK504');
    catch
        [TimeStepsPred200,LinearTrue200,LinearPred200,TimeStepsPredPreSleep200,TimeStepsPredPostSleep200,LinearPredPreSleep200,LinearPredPostSleep200,LossPred200, LossPredPreSleep200,LossPredPostSleep200,LossPredTsd200, LossPredPreSleepTsd200,LossPredPostSleepTsd200,LinearTrueTsd200, LinearPredTsd200,LinearPredPreSleepTsd200,LinearPredPostSleepTsd200, XpredTsd200, YpredTsd200] = importResultsf(dirAnalysis1, dirAnalysis2, 200);
        tps200=[TimeStepsPredPreSleep200;TimeStepsPred200;TimeStepsPredPostSleep200]*1E4;
        linearPred200tot=[LinearPredPreSleep200;LinearPred200;LinearPredPostSleep200];
        lossPredtot200=[LossPredPreSleep200;LossPred200;LossPredPostSleep200];
        [tps200,id200]=sort(tps200);
        linearPred200tot=linearPred200tot(id200);
        lossPredtot200=lossPredtot200(id200);
        LinearPredTsd200tot=tsd(tps200,linearPred200tot);
        LossPredTsd200tot=tsd(tps200,lossPredtot200);
        save(strcat(dirAnalysis1,'/DataPred200'), 'TimeStepsPred200', 'LinearTrue200', 'LinearPred200', 'TimeStepsPredPreSleep200', 'TimeStepsPredPostSleep200', 'LinearPredPreSleep200', 'LinearPredPostSleep200', 'LossPred200', 'LossPredPreSleep200', 'LossPredPostSleep200', 'LossPredTsd200', 'LossPredPreSleepTsd200', 'LossPredPostSleepTsd200', 'LinearTrueTsd200', 'LinearPredTsd200', 'LinearPredPreSleepTsd200', 'LinearPredPostSleepTsd200','LinearPredTsd200tot','LossPredTsd200tot', 'XpredTsd200', 'YpredTsd200')        
        dist2Wall = distanceToTheWall(dirAnalysis1);
        dist2WallTsd = tsd(TimeStepsPred200*1E4,dist2Wall);
        save(strcat(dirAnalysis1,'/DataPred200'), 'TimeStepsPred200', 'LinearTrue200', 'LinearPred200', 'TimeStepsPredPreSleep200', 'TimeStepsPredPostSleep200', 'LinearPredPreSleep200', 'LinearPredPostSleep200', 'LossPred200', 'LossPredPreSleep200', 'LossPredPostSleep200', 'LossPredTsd200', 'LossPredPreSleepTsd200', 'LossPredPostSleepTsd200', 'LinearTrueTsd200', 'LinearPredTsd200', 'LinearPredPreSleepTsd200', 'LinearPredPostSleepTsd200','LinearPredTsd200tot','LossPredTsd200tot', 'XpredTsd200', 'YpredTsd200', 'dist2WallTsd')        
        [X,Y,V,preSleep,hab,testPre,condi,postSleep,testPost,exploFinal,sleep,wake,tot,Stsd, tRipples] = loadData(dirAnalysis1);
        save(strcat(dirAnalysis1,'/DataDoAnalysisFor1mouse'), 'X', 'Y', 'V', 'preSleep', 'hab', 'testPre', 'condi', 'postSleep', 'testPost', 'exploFinal', 'sleep', 'wake', 'tot', 'Stsd', 'tRipples');
        [BadEpoch200,GoodEpoch200,EpochOK200] = good_bad_Single(LossPredTsd200tot,X,Y);
        save(strcat(dirAnalysis1,'/Epochs200'), 'BadEpoch200','GoodEpoch200','EpochOK200');
    end
end