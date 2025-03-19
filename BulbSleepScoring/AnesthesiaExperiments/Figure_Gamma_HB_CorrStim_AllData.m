clear all, close all
cd /media/DataMOBsRAIDN/ProjetSlSc/FiguresReview
load('Gamma_HR_Corr_Response_RangeOfTimeBins.mat','T','Time','GammaThresh','MeannGamSleep','MeannGamWake')
TimeWindow.Mov = [find(Time.Mov<0.1,1,'last'):find(Time.Mov<0.3,1,'last')];


% Put data together for correlations
AllGamma_OB = [];AllGamma_OBSpec=[];
AllHB = []; AllReac = [];
Allexp = []; AllMice = [];

j = 2
for exp = 1
    if exp == 1
        Stim = 1;
    else
        Stim = 2;
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
    
    RemRVal_HB(k,:) =RVal_HB;
    RemRVal_Gam(k,:) =RVal_Gam;
    
end
[val,ind_Gam]=max(nanmean(RemRVal_Gam));
[val,ind_HB]=max(nanmean(RemRVal_HB));


% Put data together for correlations
AllGamma_OB = [];AllGamma_OBSpec=[];
AllHB = []; AllReac = [];
Allexp = []; AllMice = [];

j = 2
for exp = 1:6
    if exp == 1
        Stim = 1;
    else
        Stim = 2;
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


% General Plot comparing OBGamma and EKG

figure
subplot(3,3,[2,3,5,6])
cols = plasma(5);
lam_Gam = LamVals(ind_Gam);
for k=1:4
    if lam_Gam ==0
        X = log(AllGamma_OB(AllMice==k));
    else
        X = ((AllGamma_OB(AllMice==k).^lam_Gam)-1)/lam_Gam;
    end
    plot(X,log(AllReac(AllMice==k)),'.','color',cols(k,:),'MarkerSize',20), hold on
end
if lam_Gam ==0
    X = log([AllGamma_OB]);
else
    X = ([AllGamma_OB].^lam_Gam-1)/lam_Gam;
end
[cf_,good_]=LinearFit(X,log([AllReac]));
CF=coeffvalues(cf_);
plot(X,CF(1)*X+CF(2),'color',[0.6 0.6 0.6],'linewidth',4)
xlim([-5 3])
ylim([13 21])
set(gca,'FontSize',15,'LineWidth',1.5)
box off

subplot(3,3,[1,4])
[Y,X]=hist(log(AllReac),[13:0.1:21]);
stairs(runmean(Y,2),X,'linewidth',3,'color','k')
ylim([13 21])
line(xlim,[17 17],'linewidth',2,'color','k')
ylabel('reaction to stimulus')
set(gca,'FontSize',15,'LineWidth',1.5)
box off

subplot(3,3,[8,9])
[Y,X]=hist(log(AllGamma_OB),[-5:0.15:3]);
stairs(X,runmean(Y,2),'linewidth',3,'color','k')
xlim([-5 3])
line([0 0],ylim,'linewidth',2,'color','k')
xlabel('Gamma power - transformed')
set(gca,'FontSize',15,'LineWidth',1.5)
box off

subplot(3,3,[2,3,5,6])
line([0 0],ylim,'linestyle',':','linewidth',1,'color','k')
line(xlim,[17 17],'linestyle',':','linewidth',1,'color','k')

figure
subplot(3,3,[2,3,5,6])
cols = plasma(5);
lam_HB = LamVals(ind_HB);
for k=1:4
    if lam_HB ==0
        X = log(AllHB(AllMice==k));
    else
        X = ((AllHB(AllMice==k).^lam_HB)-1)/lam_HB;
    end
        plot(X,log(AllReac(AllMice==k)),'.','color',cols(k,:),'MarkerSize',20), hold on

end
if lam_HB ==0
    X = log(AllHB);
else
    X = ((AllHB.^lam_HB)-1)/lam_HB;
end
[cf_,good_]=LinearFit(X,log([AllReac]));
CF=coeffvalues(cf_);
plot(X,CF(1)*X+CF(2),'color',[0.6 0.6 0.6],'linewidth',4)
ylim([13 21])
xlim([-1 8])
box off
set(gca,'FontSize',15,'LineWidth',1.5)
box off

subplot(3,3,[1,4])
[Y,X]=hist(log(AllReac),[13:0.2:21]);
stairs(runmean(Y,2),X,'linewidth',3,'color','k')
ylim([13 21])
line(xlim,[17 17],'linewidth',2,'color','k')
ylabel('reaction to stimulus')
set(gca,'FontSize',15,'LineWidth',1.5)
box off

subplot(3,3,[8,9])
[Y,X]=hist(((AllHB.^lam_HB)-1)/lam_HB,[-1:0.15:8]);
stairs(X,runmean(Y,2),'linewidth',3,'color','k')
xlim([-1 8])
line([5 5],ylim,'linewidth',2,'color','k')
xlabel('HB - transformed')
set(gca,'FontSize',15,'LineWidth',1.5)
box off

subplot(3,3,[2,3,5,6])
line([5 5 ],ylim,'linestyle',':','linewidth',1,'color','k')
line(xlim,[17 17],'linestyle',':','linewidth',1,'color','k')
