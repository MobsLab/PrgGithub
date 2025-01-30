% This script aims at removing the predictions for which we don't have any
% data about linearTrue even though the mouse is awake and moving

% 1161
% folderResults = '/media/mobs/DimaERC2/DataERC2/M1161/TEST'
% nasResultsDecoding = '/media/nas5/ProjetERC2/Mouse-K161/20201224/_Concatenated/resultsDecoding'
%1199
% folderResults = '/media/mobs/DimaERC2/TEST1_Basile/TEST'
% nasResultsDecoding = '/media/nas6/ProjetERC2/Mouse-K199/20210408/_Concatenated/resultsDecoding'

% 905
% folderResults = '/media/mobs/DimaERC2/DataERC2/M905/TEST'
% nasResultsDecoding = '/media/nas5/ProjetERC2/Mouse-905/20190404/PAGExp/_Concatenated/resultsDecoding'

% 1336
% folderResults = '/media/mobs/DimaERC2/Known_M1336/TEST'
% nasResultsDecoding = '/media/nas7/ProjetERC1/Known/M1336/resultsDecoding'

[TimeStepsPred36,LinearTrue36,LinearPred36,TimeStepsPredPreSleep36,TimeStepsPredPostSleep36,LinearPredPreSleep36,LinearPredPostSleep36,LossPred36, LossPredPreSleep36,LossPredPostSleep36,LossPredTsd36, LossPredPreSleepTsd36,LossPredPostSleepTsd36,LinearTrueTsd36, LinearPredTsd36,LinearPredPreSleepTsd36,LinearPredPostSleepTsd36] = importResultsf(folderResults, nasResultsDecoding, 36);
[TimeStepsPred200,LinearTrue200,LinearPred200,TimeStepsPredPreSleep200,TimeStepsPredPostSleep200,LinearPredPreSleep200,LinearPredPostSleep200,LossPred200, LossPredPreSleep200,LossPredPostSleep200,LossPredTsd200, LossPredPreSleepTsd200,LossPredPostSleepTsd200,LinearTrueTsd200, LinearPredTsd200,LinearPredPreSleepTsd200,LinearPredPostSleepTsd200] = importResultsf(folderResults, nasResultsDecoding, 200);
[TimeStepsPred504,LinearTrue504,LinearPred504,TimeStepsPredPreSleep504,TimeStepsPredPostSleep504,LinearPredPreSleep504,LinearPredPostSleep504,LossPred504, LossPredPreSleep504,LossPredPostSleep504,LossPredTsd504, LossPredPreSleepTsd504,LossPredPostSleepTsd504,LinearTrueTsd504, LinearPredTsd504,LinearPredPreSleepTsd504,LinearPredPostSleepTsd504] = importResultsf(folderResults, nasResultsDecoding, 504);

LinearTrueTsd = LinearTrueTsd200;
LinearPredTsd = LinearPredTsd200;
t = Range(LinearTrueTsd);
d = Data(LinearTrueTsd);
tPred = TimeStepsPred200;
dPred = LinearPred200;
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
LinearTrueTsd = LinearTrueTsd36;
LinearPredTsd = LinearPredTsd36;
t = Range(LinearTrueTsd);
d = Data(LinearTrueTsd);
tPred = TimeStepsPred36;
dPred = LinearPred36;
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
LinearTrueTsd = LinearTrueTsd504;
LinearPredTsd = LinearPredTsd504;
t = Range(LinearTrueTsd);
d = Data(LinearTrueTsd);
tPred = TimeStepsPred504;
dPred = LinearPred504;
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
%                 LinearPredTsd(p,:) = [];
            end
        end
        for j = 1:length(tPred)
            if tPred(j)>t1 & tPred(j) < t2
                dPred(j) = NaN;
            end
        end
    end
end


GoodEpoch=GoodEpoch200;
LinearPredTsd=LinearPredTsd200;

id=find(isnan(Data(X)));
temp(1,:)=Range(X);
temp(2,:)=ones(length(Data(X)),1);
temp(2,id)=0;
EpochOK=thresholdIntervals(tsd(temp(1,:),temp(2,:)'),0.5,'Direction','Above')

figure,subplot(1,5,1),
hist(Data(Restrict(LinearTrueTsd200,hab)),50)
subplot(1,5,2:5),hold on,
% thab = Range(Restrict(LinearPredTsd,hab))
% tcond = Range(Restrict(LinearPredTsd,cond))
% ttestPre = Range(Restrict(LinearPredTsd,testPre))
% ttestPost = Range(Restrict(LinearPredTsd,testPost))
% fill([thab(1) thab(end)], [1 1], [0,0,0.7])
% fill([ttestPre(1) ttestPre(end)], [1 1], [0,0.7,0])
% fill([tcond(1) tcond(end)], [1 1], [0.7,0,0])
% fill([ttestPost(1) ttestPost(end)], [1 1], 'Color', [0,0.7,0.7])
plot(Range(Restrict(LinearTrueTsd200, tot),'s'), Data(Restrict(LinearTrueTsd200, tot)),'r','linewidth',2)
plot(Range(Restrict(LinearTrueTsd200, tot),'s'), Data(Restrict(LinearTrueTsd200, tot)),'r','markersize',15)
% plot(Range(Restrict(X, tot),'s'), Data(Restrict(X, tot)),'y','linewidth',1),plot(Range(Restrict(Y, tot),'s'), Data(Restrict(Y, tot)),'g','linewidth',1)
plot(Range(Restrict(LinearTrueTsd200, tot),'s'), Data(Restrict(LinearTrueTsd200, tot)),'ro','linewidth',2)
plot(Range(Restrict(LinearPredTsd200tot, tot),'s'), Data(Restrict(LinearPredTsd200tot, tot)),'.','color',[0.8 0.8 0.8],'markersize',5)
%plot(Range(Restrict(LinearPredTsd, BadEpoch),'s'), Data(Restrict(LinearPredTsd, BadEpoch)),'g.','markersize',15)
plot(Range(Restrict(LinearPredTsd200tot, and(GoodEpoch,EpochOK)),'s'), Data(Restrict(LinearPredTsd200tot, and(GoodEpoch,EpochOK))),'b.','markersize',15)
line([Range(tRipples,'s') Range(tRipples,'s')],ylim/2,'color','b')
a=7850
l=1000; a=a+l/2;  xlim([a a+l])