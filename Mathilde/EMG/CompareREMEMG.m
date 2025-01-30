function [C,cm,CL,valConf,LowEpoch,LowEpoch2,LowEpochL,LowEpoch2L,Clow2]=CompareREMEMG(REMEpoch,LFP_emg,thlow)


%[C,cm,CL,valConf,LowEpoch,LowEpoch2,LowEpochL,LowEpoch2L,Clow2]=CompareREMEMG(REMEpoch,LFP_emg,thlow)
% thlow=65*1E3;  


b=[0:1000:2E9];
me=6E4;
do=3E4;

try
    thlow;
catch
    thlow=65*1E3;   
end

EMG=tsd(Range(LFP_emg), Data(LFP_emg).^2);
EMG = ResampleTSD(EMG,10);
EMG=tsd(Range(EMG),runmean(Data(EMG),4));

%EMG=LFP_emg;

rgEMG=Range(EMG);
[h1,b1]=hist(Data(Restrict(EMG,REMEpoch)),b); 
[h2,b2]=hist(Data(Restrict(EMG,intervalSet(rgEMG(1),rgEMG(end))-REMEpoch)),b); 
    
th=nanmean(Data(Restrict(EMG,REMEpoch)))+nanstd(Data(Restrict(EMG,REMEpoch)))/10;
th2=nanmedian(Data(Restrict(EMG,REMEpoch)));
        
M=nanmean(Data(Restrict(EMG,REMEpoch)));
Me=nanmedian(Data(Restrict(EMG,REMEpoch)));

val=length(find(Data(Restrict(EMG,REMEpoch))<th));
val2=length(find(Data(Restrict(EMG,REMEpoch))<th2));
valt=length(Data(Restrict(EMG,REMEpoch)));
   
Val=val/valt*100;
Val2=val2/valt*100;

    figure,
    subplot(121),hold on
    plot(b1,h1,'color',[1 0.8 0.8],'linewidth',2)
    plot(b2,h2,'color',[1 0.6 0.6],'linewidth',2)
   % xlim([1100 0.3E6])
    line([th th],ylim,'color',[0.6 0.6 1],'linestyle','--')
    line([th2 th2],ylim,'color',[0.3 0.8 0.3],'linestyle','--')
    line([thlow thlow],ylim,'color','k','linestyle','--')  
    
    subplot(122),hold on
    plot(b1,h1/max(h1(10:200)),'color',[1 0.8 0.8],'linewidth',2)
    plot(b2,h2/max(h2(10:200)),'color',[1 0.6 0.6],'linewidth',2)
   % xlim([0.5E4 0.3E6])
    line([th th],ylim,'color',[0.6 0.6 1],'linestyle','--')
    line([th2 th2],ylim,'color',[0.3 0.8 0.3],'linestyle','--')
    line([thlow thlow],ylim,'color','k','linestyle','--')   
    set(gca,'xscale','log'), ylim([0 1.5])


%%

LowEpoch=thresholdIntervals(EMG,thlow,'Direction','Below');
LowEpoch=dropShortIntervals(LowEpoch,do);
LowEpoch2=mergeCloseIntervals(LowEpoch,me);

figure, 
subplot(311),hold on,
plot(Range(EMG,'s'),Data(EMG),'.-','color',[0.3 0.3 0.3])
plot(Range(Restrict(EMG,REMEpoch),'s'),Data(Restrict(EMG,REMEpoch)),'.','color',[0.3 0.8 0.3],'markersize',10)
line(xlim,[thlow thlow],'color','r','linestyle','--'), ylabel('True REM')
ylim([0 3E5])
subplot(312),hold on
plot(Range(EMG,'s'),Data(EMG),'.-','color',[0.3 0.3 0.3])
plot(Range(Restrict(EMG,LowEpoch),'s'),Data(Restrict(EMG,LowEpoch)),'.','color',[0.8 0.3 0.3],'markersize',20)
line(xlim,[thlow thlow],'color','r','linestyle','--'), ylabel('REM LowEpoch')
ylim([0 3E5])
subplot(313),hold on
plot(Range(EMG,'s'),Data(EMG),'.-','color',[0.3 0.3 0.3])
plot(Range(Restrict(EMG,LowEpoch2),'s'),Data(Restrict(EMG,LowEpoch2)),'.','color',[0.3 0.3 0.8],'markersize',20)
line(xlim,[thlow thlow],'color','r','linestyle','--'), ylabel('REM LowEpoch 2')
ylim([0 3E5])

% a=14500;
% a=19150;
% a=25000;
% a=5000;
% a=a+150;subplot(311),xlim([a a+200]), ylim([0 5E5]),subplot(312),xlim([a a+200]), ylim([0 5E5]),subplot(313),xlim([a a+200]), ylim([0 5E5])
StREM=Start(REMEpoch,'s');
nu=0; 
 nu=nu+1; a=StREM(nu)-30;subplot(311),xlim([a a+200]), ylim([0 5E5]),subplot(312),xlim([a a+200]), ylim([0 5E5]),subplot(313),xlim([a a+200]), ylim([0 5E5])
%nu=nu+1; a=StREM(nu)-50;subplot(311),xlim([a a+200]), caxis([15 50]), subplot(312),xlim([a a+200]), caxis([10 45]), subplot(313),xlim([a a+200]),ylim([0 5E5])

% a=a+100; ;subplot(311),xlim([a a+200]), ylim([0 5E5]),subplot(312),xlim([a a+200]), ylim([0 5E5]),subplot(313),xlim([a a+200]), ylim([0 5E5])

%%

for l=1:200
LowEpochL{l}=thresholdIntervals(EMG,l*1000,'Direction','Below');
LowEpochL{l}=dropShortIntervals(LowEpochL{l},do);
LowEpoch2L{l}=mergeCloseIntervals(LowEpochL{l},me);
end

%%

cm=[];
CL=[];
%valConf=[];
rg=Range(EMG);
rgrem=Range(Restrict(EMG,REMEpoch));
rglow=Range(Restrict(EMG,LowEpoch));
rglow2=Range(Restrict(EMG,LowEpoch2));

grouprem=zeros(length(rg),1);
grouplow=zeros(length(rg),1);
grouplow2=zeros(length(rg),1);

grouprem(ismember(rg,rgrem))=1;
grouplow(ismember(rg,rglow))=1;
grouplow2(ismember(rg,rglow2))=1;

%%

C = confusionmat(grouprem,grouplow);
label={'no-rem','rem'};
sC1=sum(C,1);
C1(1,:)=C(1,:)./sC1*100;
C1(2,:)=C(2,:)./sC1*100;
sC2=sum(C,2);
C2(:,1)=C(:,1)./sC2*100;
C2(:,2)=C(:,2)./sC2*100;


Clow2 = confusionmat(grouprem,grouplow2);
label={'no-rem','rem'};
sC1low2=sum(Clow2,1);
C1low2(1,:)=Clow2(1,:)./sC1low2*100;
C1low2(2,:)=Clow2(2,:)./sC1low2*100;
sC2low2=sum(Clow2,2);
C2low2(:,1)=Clow2(:,1)./sC2low2*100;
C2low2(:,2)=Clow2(:,2)./sC2low2*100;

valConf(l,:)=[0,C1(1,1),C1(2,2),C2(1,1),C2(2,2),C1(1,2),C2(1,2),C1low2(1,1),C1low2(2,2),C1low2(1,1),C1low2(2,2),C1low2(1,2),C1low2(1,2)];

try
figure('color',[1 1 1]),
cm=confusionchart(C,label);
cm.RowSummary = 'row-normalized';
cm.ColumnSummary = 'column-normalized';

for l=1:200
LowEpochL{l}=thresholdIntervals(EMG,l*1000,'Direction','Below');
LowEpochL{l}=dropShortIntervals(LowEpochL{l},do);
LowEpoch2L{l}=mergeCloseIntervals(LowEpochL{l},me);
[CL{l},Cl1,Cl2,cm]=ConfusionMat2Epoch(LowEpoch2L{l},REMEpoch,label,[],0);
ConfM{l}=[Cl1,[nan nan]',Cl2];
valConf(l,:)=[l*1000,Cl1(1,1),Cl1(2,2),Cl2(1,1),Cl2(2,2),Cl1(1,2),Cl2(1,2)];
end

figure, 
subplot(1,3,1), plot(valConf(:,2:3)), legend({'% of the predicted norem actually true norem',' % of the predicted rem actually true rem'}),line([thlow thlow]/1E3,[0 100] ,'color','k','linestyle','--')
subplot(1,3,2), plot(valConf(:,4:5)), legend({'% of true norem well predicted',' % of true rem well predicted '}),line([thlow thlow]/1E3,[0 100] ,'color','k','linestyle','--')
subplot(1,3,3), plot(valConf(:,6:7)), legend({'% of the predicted rem actually norem',' % of true norem predicted as rem true rem'}),line([thlow thlow]/1E3,[0 100] ,'color','k','linestyle','--')

end
