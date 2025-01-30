clear all, close all
cd /media/DataMOBsRAIDN/ProjetSlSc/FiguresReview
load('Gamma_HR_Corr_Response_RangeOfTimeBins.mat','T','Time','GammaThresh','MeannGamSleep','MeannGamWake')
TimeWindow.Mov = [find(Time.Mov<0.1,1,'last'):find(Time.Mov<0.3,1,'last')];


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

figure
nhist(log(AllReac),'binfactor',5,'noerror')
hold on
xlabel('Reaction to stim')
ylabel('counts')
ylim([0 40])
line([17 17],ylim,'color','k','linewidth',4)
set(gca,'LineWidth',2,'FontSize',15)

Thresh = 17;
for  k = 1 :4
    
    Reac_ThisMouse = log(AllReac(AllMice==k));
    OBGamma_ThisMouse = log(AllGamma_OB(AllMice==k));
    EKG_ThisMouse = (AllHB(AllMice==k));
    
    % Do the ROC analysis - OB Gamma
    alpha=[];
    beta=[];
    minval=min([OBGamma_ThisMouse]);
    maxval=max([OBGamma_ThisMouse]);
    
    delval=(maxval-minval)/20;
    ValsToTest=[min(OBGamma_ThisMouse)-delval:delval:max(OBGamma_ThisMouse)+delval];
    
    OBGamma_ThisMouse_Wake = OBGamma_ThisMouse(Reac_ThisMouse>Thresh);
    OBGamma_ThisMouse_Anesth = OBGamma_ThisMouse(Reac_ThisMouse<=Thresh);
    
    for z=ValsToTest
        alpha=[alpha,sum(OBGamma_ThisMouse_Anesth>z)/length(OBGamma_ThisMouse_Anesth)];
        beta=[beta,sum(OBGamma_ThisMouse_Wake>z)/length(OBGamma_ThisMouse_Wake)];
    end
    
    RocVal_Start_OB(k)=sum(beta-alpha)/length(beta)+0.5;
    ROCAlpha_Start_OB{k}=alpha;
    ROCBeta_Start_OB{k}=beta;
    
    % Do the ROC analysis - EKG
    alpha=[];
    beta=[];
    minval=min([EKG_ThisMouse]);
    maxval=max([EKG_ThisMouse]);
    
    delval=(maxval-minval)/20;
    ValsToTest=[min(EKG_ThisMouse)-delval:delval:max(EKG_ThisMouse)+delval];
    
    EKG_ThisMouse_Wake = EKG_ThisMouse(Reac_ThisMouse>Thresh);
    EKG_ThisMouse_Anesth = EKG_ThisMouse(Reac_ThisMouse<=Thresh);
    
    for z=ValsToTest
        alpha=[alpha,sum(EKG_ThisMouse_Anesth>z)/length(EKG_ThisMouse_Anesth)];
        beta=[beta,sum(EKG_ThisMouse_Wake>z)/length(EKG_ThisMouse_Wake)];
    end
    
    RocVal_Start_EKG(k)=sum(beta-alpha)/length(beta)+0.5;
    ROCAlpha_Start_EKG{k}=alpha;
    ROCBeta_Start_EKG{k}=beta;
    
end

figure
for  k = 1:4
    plot( ROCAlpha_Start_OB{k}, ROCBeta_Start_OB{k},'k')
    hold on
    plot( ROCAlpha_Start_EKG{k}, ROCBeta_Start_EKG{k},'r')
end


NewAlpha=[0:0.01:1];
for  k = 1:4
    OldAlpha=ROCAlpha_Start_OB{k};
    OldBeta=ROCBeta_Start_OB{k};
    
    while sum(OldAlpha==1)>1
        OldBeta(find(OldAlpha==1,1,'last'))=[];
        OldAlpha(find(OldAlpha==1,1,'last'))=[];
    end
    while sum(OldAlpha==0)>1
        OldBeta(find(OldAlpha==0,1,'first'))=[];
        OldAlpha(find(OldAlpha==0,1,'first'))=[];
    end
    
    [C,IA,IC] = unique(OldAlpha);
    OldBeta=OldBeta(IA);
    OldAlpha=OldAlpha(IA);
    NewBeta_OB(k,:)=interp1(OldAlpha,OldBeta,NewAlpha);
    
       OldAlpha=ROCAlpha_Start_EKG{k};
    OldBeta=ROCBeta_Start_EKG{k};
    
    while sum(OldAlpha==1)>1
        OldBeta(find(OldAlpha==1,1,'last'))=[];
        OldAlpha(find(OldAlpha==1,1,'last'))=[];
    end
    while sum(OldAlpha==0)>1
        OldBeta(find(OldAlpha==0,1,'first'))=[];
        OldAlpha(find(OldAlpha==0,1,'first'))=[];
    end
    
    [C,IA,IC] = unique(OldAlpha);
    OldBeta=OldBeta(IA);
    OldAlpha=OldAlpha(IA);
    NewBeta_EKG(k,:)=interp1(OldAlpha,OldBeta,NewAlpha);
end




figure
[hl,hp]=boundedline(NewAlpha,nanmean(NewBeta_OB),[stdError(NewBeta_OB);stdError(NewBeta_OB)]','k');
set(hl,'Color',[1 0.8 0.8]*0.5,'linewidth',2,'linestyle',':')
set(hp,'FaceColor',[1 0.8 0.8])
[hl,hp]=boundedline(NewAlpha,nanmean(NewBeta_EKG),[stdError(NewBeta_EKG);stdError(NewBeta_EKG)]','k');
set(hl,'Color',[0.4 0.4 0.4],'linewidth',2)
line([0 1],[0 1],'color','k','linestyle',':','linewidth',2)
xlim([0 1]),ylim([0 1]),box off
set(gca,'LineWidth',2,'FontSize',15)
xlabel('False Positive rate'),ylabel('True Positive rate')


figure
Vals = {RocVal_Start_OB';RocVal_Start_EKG'};
XPos = [1.1,1.9];

Cols = [1,0.9,0.9;0.9,0.9,0.9];
for k = 1:2
    X = Vals{k};
    a=iosr.statistics.boxPlot(XPos(k),X,'boxColor',Cols(k,:),'lineColor',Cols(k,:),'medianColor','k','boxWidth',0.5,'showOutliers',false);
    a.handles.upperWhiskers.Visible='off';a.handles.upperWhiskerTips.Visible='off';
    a.handles.lowerWhiskers.Visible='off';a.handles.lowerWhiskerTips.Visible='off';
    a.handles.medianLines.LineWidth = 5;
    
    handlesplot=plotSpread(X,'distributionColors',[0 0 0],'xValues',XPos(k),'spreadWidth',0.4), hold on;
    set(handlesplot{1},'MarkerSize',30)
    handlesplot=plotSpread(X,'distributionColors',Cols(k,:)*0.8,'xValues',XPos(k),'spreadWidth',0.4), hold on;
    set(handlesplot{1},'MarkerSize',20)
    
end

xlim([0.5 2.4])
ylim([0.6 1.1])
set(gca,'FontSize',18,'XTick',XPos,'XTickLabel',{'Onset','Offset'},'linewidth',1.5,'YTick',[0.5:0.1:1])
ylabel('ROC value')
box off

randperm(1:8)
AllCombi = combnk(1:8,4);
AllVals = [RocVal_Start_OB,RocVal_Start_EKG];

for ac = 1:length(AllCombi)
    MN(1,ac) = nanmean(AllVals(AllCombi(ac,:)));
    Temp = [1:8];
    Temp(AllCombi(ac,:)) = [];
    MN(2,ac) = nanmean(AllVals(Temp));
end