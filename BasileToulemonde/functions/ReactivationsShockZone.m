function [N,N2,Idx,ReactShock,ReactSafe,Behav] = ReactivationsShockZone(dirAnalysis, dur,val1,val2,val3,imEp)


% [N1, N2, idx, rtShock, rtSafe] = ReactivationsShockZone(DirAnalyse{i},200,0.3,0.2,0.2);
% if imEp=1 do the analysis on immobility


try
    imEp;
catch
    imEp=1;
end
    

    eval(['cd ',dirAnalysis]);

    load('DataDoAnalysisFor1mouse.mat');
    eval(['load DataPred',num2str(dur)]);
    eval(['load Epochs',num2str(dur)]);
    if imEp
        try 
            ImmobEpoch;
        catch
            ImmobEpoch=thresholdIntervals(V,1,'Direction','Below');
        end
            else
        ImmobEpoch=thresholdIntervals(V,7,'Direction','Above');
    end
    
try 
    val1;
    val2;
    val3;
catch
    val1=0.3;
    val2=0.3;
    val3=0.2;
end

    LinearPredTsd = eval(['LinearPredTsd',num2str(dur),'tot']);
    LinearTrueTsd = eval(['LinearTrueTsd',num2str(dur)]);
    EpochOK = eval(['EpochOK',num2str(dur)]);
    GoodEpoch = eval(['GoodEpoch',num2str(dur)]);
    
    tPreSleep = Range(Restrict(LinearPredTsd, preSleep));
    dPredPreSleep = Data(Restrict(Restrict(LinearPredTsd, GoodEpoch), preSleep));
    dTruePreSleep = Data(Restrict(Restrict(LinearTrueTsd, GoodEpoch), preSleep));
    
    tHab = Range(Restrict(Restrict(LinearPredTsd,ImmobEpoch), hab));
    dPredHab = Data(Restrict(Restrict(Restrict(LinearPredTsd,ImmobEpoch), EpochOK), hab));
    dTrueHab = Data(Restrict(Restrict(Restrict(LinearTrueTsd,ImmobEpoch), EpochOK), hab));
    
    tCond = Range(Restrict(Restrict(LinearPredTsd,ImmobEpoch), condi));
    dPredCond = Data(Restrict(Restrict(Restrict(LinearPredTsd,ImmobEpoch), EpochOK), condi));
    dTrueCond = Data(Restrict(Restrict(Restrict(LinearTrueTsd,ImmobEpoch), EpochOK), condi));
    
    tTestPre = Range(Restrict(Restrict(LinearPredTsd,ImmobEpoch), testPre));
    dPredTestPre = Data(Restrict(Restrict(Restrict(LinearPredTsd,ImmobEpoch), EpochOK), testPre));
    dTrueTestPre = Data(Restrict(Restrict(Restrict(LinearTrueTsd,ImmobEpoch), EpochOK), testPre));
    
    tPostSleep = Range(Restrict(LinearPredTsd, postSleep));
    dPredPostSleep = Data(Restrict(Restrict(LinearPredTsd, GoodEpoch), postSleep));
    dTruePostSleep = Data(Restrict(Restrict(LinearTrueTsd, GoodEpoch), postSleep));
    
    tTestPost = Range(Restrict(Restrict(LinearPredTsd,ImmobEpoch), testPost));
    dPredTestPost = Data(Restrict(Restrict(Restrict(LinearPredTsd,ImmobEpoch), EpochOK), testPost));
    dTrueTestPost = Data(Restrict(Restrict(Restrict(LinearTrueTsd,ImmobEpoch),EpochOK), testPost));
    
    t = {tPreSleep,tHab,tTestPre, tCond,tPostSleep,tTestPost};
    dPred = {dPredPreSleep,dPredHab,dPredTestPre,dPredCond,dPredPostSleep,dPredTestPost};
    dTrue = {dTruePreSleep,dTrueHab,dTrueTestPre,dTrueCond,dTruePostSleep,dTrueTestPost};
    tRip = Range(tRipples);
    N = [0 0 0 0 0 0];
    N2 = [0 0 0 0 0 0];
    for i = 1:length(dPred)
        dpred = dPred{i};
        dtrue = dTrue{i};
        tps = t{i};
        for k = 1:(length(dpred)-1)
%             low = tps(k) - 150;
%             high = tps(k) + 50;
            if i == 1 || i == 5
                if dpred(k)<val1
%                     if any(tRip >= low & tRip <= high) == 1
                        N(i) = N(i) + 1;
%                     end
                end
                 if dpred(k)>val2
%                     if any(tRip >= low & tRip <= high) == 1
                        N2(i) = N2(i) + 1;
%                     end
                end
            else
                if (dpred(k)<val1 && dtrue(k)>val2)
%                     if any(tRip >= low & tRip <= high) == 1
                        N(i) = N(i) + 1;
%                     end
                end
               
                if (dpred(k)>val2 && dtrue(k)<val1)
%                     if any(tRip >= low & tRip <= high) == 1
                        N2(i) = N2(i) + 1;
%                     end
                end
                
            end
        end
    end
  
    
% figure, 
for k=1:6
    if k == 2  | k==3  | k==4  | k==6
        try
        Behav(k,1)=length(find(dTrue{k}>0.3));
        Behav(k,2)=length(find(dTrue{k}<0.3));
        Behav(k,3)=length(find(dPred{k}>0.3));
        Behav(k,4)=length(find(dPred{k}<0.3));
        Idx(k,1)=length(find(dTrue{k}>0.45 & dPred{k}>0.45 & abs(dTrue{k}-dPred{k})<=val3));
        Idx(k,2)=length(find(dTrue{k}>val2 & dPred{k}<val1 & abs(dTrue{k}-dPred{k})>=val3));
        Idx(k,3)=length(find(dTrue{k}<0.45 & dPred{k}<0.45 & abs(dTrue{k}-dPred{k})<=val3));
        Idx(k,4)=length(find(dTrue{k}<val1 & dPred{k}>val2 & abs(dTrue{k}-dPred{k})>=val3));
        catch
        Behav(k,1)=0;
        Behav(k,2)=0;
        Behav(k,3)=length(find(dPred{k}>0.3));
        Behav(k,4)=length(find(dPred{k}<0.3));
        Idx(k,1)=1;
        Idx(k,2)=length(find(dPred{k}<val1));
        Idx(k,3)=1;
        Idx(k,4)=length(find(dPred{k}>1-val1));     
        end
    end
    if k == 1  | k==5  
        Behav(k,1)=0;
        Behav(k,2)=0;
        Behav(k,3)=length(find(dPred{k}>0.3));
        Behav(k,4)=length(find(dPred{k}<0.3));
        Idx(k,1)=1;
        Idx(k,2)=length(find(dPred{k}<val1));
        Idx(k,3)=1;
        Idx(k,4)=length(find(dPred{k}>1-val1));     
    end
        ReactShock(k) = Idx(k,2)/Idx(k,1);
        ReactSafe(k) = Idx(k,4)/Idx(k,3);
        subplot(1,6,k), 
        try
            hold on,
            plot(dTrue{k},dPred{k},'k.')
            id=find(dTrue{k}>val2&dPred{k}<val1&abs(dTrue{k}-dPred{k})>=val3);
            id2=find(dTrue{k}<val1&dPred{k}>val2&abs(dTrue{k}-dPred{k})>=val3);
            id3=find(dTrue{k}<0.45&dPred{k}<0.45&abs(dTrue{k}-dPred{k})<val3);
            id4=find(dTrue{k}>0.45&dPred{k}>0.45&abs(dTrue{k}-dPred{k})<=val3);
            plot(dTrue{k}(id),dPred{k}(id),'r.')
            plot(dTrue{k}(id2),dPred{k}(id2),'b.')
            plot(dTrue{k}(id3),dPred{k}(id3),'g.')
            plot(dTrue{k}(id4),dPred{k}(id4),'y.')
            reactShock = length(id)/length(id4);
            reactSafe = length(id2)/length(id3);
        catch
            [h,b]=hist(dPred{k},[0.025:0.05:0.975]);
            plot(b,h,'ko-')
        end
    end
%     for k=1:6
%         try
%         Idx(k,1)=length(find(dTrue{k}>val2&dPred{k}>val2));
%         Idx(k,2)=length(find(dTrue{k}>val2&dPred{k}<val1));
%         Idx(k,3)=length(find(dTrue{k}<val1&dPred{k}<val1));
%         Idx(k,4)=length(find(dTrue{k}<val1&dPred{k}>val2));
%         catch
% 
%         Idx(k,1)=length(find(dPred{k}>val2));
%         Idx(k,2)=length(find(dPred{k}>val2));
%         Idx(k,3)=length(find(dPred{k}<val1));
%         Idx(k,4)=length(find(dPred{k}<val1));     
%         end
% 
%         subplot(1,6,k), 
%         try
%             hold on,
%             plot(dTrue{k},dPred{k},'k.')
%             id=find(dTrue{k}>val2&dPred{k}<val1);
%             id2=find(dTrue{k}<val1&dPred{k}>val2);
%             plot(dTrue{k}(id),dPred{k}(id),'r.')
%             plot(dTrue{k}(id2),dPred{k}(id2),'b.')
%         catch
%             [h,b]=hist(dPred{k},[0.025:0.05:0.975]);
%             plot(b,h,'ko-')
%         end
%     end
