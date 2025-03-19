clear all, close all
cd /media/DataMOBsRAIDN/ProjetSlSc/FiguresReview
load('Gamma_HR_Corr_Response_RangeOfTimeBins.mat','T','Time','GammaThresh','MeannGamSleep','MeannGamWake')

% Put data together for correlations
AllGamma_OB = [];AllGamma_OBSpec=[];
AllHB = []; AllReac = [];
Allexp = []; AllMice = [];

TimeWindow.Mov = [find(Time.Mov<0.1,1,'last'):find(Time.Mov<0.3,1,'last')];

cols = lines(4);
for j = 1:19
    for exp = 1
        if exp == 1
            Stim = 2;
        else
            Stim = 3;
        end
        
        for  k = 1:4
            AllGamma_OB = [AllGamma_OB,T.GammaOB{exp,k,Stim}(j,:)./(GammaThresh(k))];
            AllGamma_OBSpec = [AllGamma_OBSpec,T.GammaOB_Spec{exp,k,Stim}(j,:)];
            AllHB = [AllHB,T.EKG{exp,k,Stim}(j,:)];
            AllReac = [AllReac,nanmean(T.Mov{exp,k,Stim}(:,TimeWindow.Mov)')];
            AllMice = [AllMice, k*ones(1,size(nanmean(T.Mov{exp,k,Stim}(:,TimeWindow.Mov)'),2))];
            Allexp = [Allexp, exp*ones(1,size(nanmean(T.Mov{exp,k,Stim}(:,TimeWindow.Mov)'),2))];
            
        end
    end
    
    AllGamma_OBSpec(isnan(AllGamma_OB))=[];
    AllHB(isnan(AllGamma_OB))=[];
    AllReac(isnan(AllGamma_OB))=[];
    AllMice(isnan(AllGamma_OB))=[];
    Allexp(isnan(AllGamma_OB))=[];
    AllGamma_OB(isnan(AllGamma_OB))=[];
    
    
    for  k = 1:4
        LamVals = [-2:0.05:2];
        for l = 1:length(LamVals)
            lam = LamVals(l);
            if lam ==0
                X = log(AllGamma_OB(AllMice==k));
            else
                X = ((AllGamma_OB(AllMice==k).^lam)-1)/lam;
            end
            Y=log(AllReac(AllMice==k));
            Y(isinf(X))=[];
            X(isinf(X))=[];
            
            [R,P]=corrcoef(X,Y);
            RVal_Gam(l) = R(1,2);
        end
        
        for l = 1:length(LamVals)
            lam = LamVals(l);
            if lam ==0
                X = log(AllHB(AllMice==k));
            else
                X = ((AllHB(AllMice==k).^lam)-1)/lam;
            end
            Y=log(AllReac(AllMice==k));
            Y(isinf(X))=[];
            X(isinf(X))=[];
            
            [R,P]=corrcoef(X,Y);
            RVal_HB(l) = R(1,2);
        end
        
        RemRVal_HB(j,k,:) =RVal_HB;
        RemRVal_Gam(j,k,:) =RVal_Gam;
        
    end
end

figure
cols = jet(17);
for j =1:17
    subplot(121)
    plot(LamVals,squeeze(nanmean(RemRVal_HB(j,:,:),2))','color',cols(j,:)), hold on
    subplot(122)
    plot(LamVals,squeeze(nanmean(RemRVal_Gam(j,:,:),2))','color',cols(j,:)), hold on
end
subplot(121)
box off
set(gca,'FontSize',15,'LineWidth',1.5)
xlabel('lambda'), ylabel('R')
title('HB')
subplot(122)
box off
set(gca,'FontSize',15,'LineWidth',1.5)
xlabel('lambda'), ylabel('R')
title('Gamma OB')

% General Plot comparing OBGamma and EKG
figure
subplot(2,3,[1,4])
errorbar(LamVals,nanmean(RemRVal_Gam),stdError(RemRVal_Gam),'r','linewidth',2), hold on
errorbar(LamVals,nanmean(RemRVal_HB),stdError(RemRVal_HB),'k','linewidth',2)
[val,ind_Gam]=max(nanmean(RemRVal_Gam));
[val,ind_HB]=max(nanmean(RemRVal_HB));
xlabel('lambda')
ylabel('R')
legend('OB Gamma','HB','Location','northwest')
box off
set(gca,'FontSize',15,'LineWidth',1.5)

subplot(232)
lam_Gam = LamVals(ind_Gam);
for k=1:4
    if lam_Gam ==0
        X = log(AllGamma_OB(AllMice==k));
    else
        X = ((AllGamma_OB(AllMice==k).^lam_Gam)-1)/lam_Gam;
    end
    plot(X,log(AllReac(AllMice==k)),'r.','MarkerSize',10), hold on
end
if lam_Gam ==0
    X = [AllGamma_OB];
else
    X = ([AllGamma_OB].^lam_Gam-1)/lam_Gam;
end
[cf_,good_]=LinearFit(X,log([AllReac]));
CF=coeffvalues(cf_);
plot(X,CF(1)*X+CF(2),'color','b','linewidth',2)
xlim([-10 150])
ylim([13 21])
xlabel('Gamma Power - transformed')
ylabel('reaction to stimulus')
box off
set(gca,'FontSize',15,'LineWidth',1.5)
box off

subplot(233)
qqplot(log([AllReac])-(CF(1)*X+CF(2)))
set(gca,'FontSize',15,'LineWidth',1.5)
title('')

subplot(235)
lam_HB = LamVals(ind_HB);
for k=1:4
    if lam_HB ==0
        X = log(AllHB(AllMice==k));
    else
        X = ((AllHB(AllMice==k).^lam_HB)-1)/lam_HB;
    end
    plot(X,log(AllReac(AllMice==k)),'k.','MarkerSize',10), hold on
end
if lam_HB ==0
    X = log(AllHB);
else
    X = ((AllHB.^lam_HB)-1)/lam_HB;
end
[cf_,good_]=LinearFit(X,log([AllReac]));
CF=coeffvalues(cf_);
plot(X,CF(1)*X+CF(2),'color','b','linewidth',2)
ylim([13 21])
xlim([0 11])
xlabel('Heart Rate - transformed')
ylabel('reaction to stimulus')
box off
set(gca,'FontSize',15,'LineWidth',1.5)
box off
subplot(236)
qqplot(log([AllReac])-(CF(1)*X+CF(2)))
set(gca,'FontSize',15,'LineWidth',1.5)
title('')
