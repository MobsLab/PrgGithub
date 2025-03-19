%TrucKarimSpikesRipples


plo=0;

 Dir=PathForExperimentsMLnew('Spikes');MethMouK=1;
%Dir=PathForExperimentsSleepRipplesSpikes('all');MethMouK=0;

CCparam1=10;
CCparam2=200;

listMouse=[];
Ct=[];
CtN1=[];
CtN2=[];
CtN3=[];
CtWA=[];
b=1;
c=1;

for p=1:length(Dir.path)
    
    disp(' ')
    disp('****************************************************************')
    eval(['cd(Dir.path{',num2str(p),'}'')'])
    disp(pwd)
    
     try
    clear S
    clear Q
    clear QS
    clear N1

    load SpikeData
    try
        S=tsdArray(S);
    end
    
%     num=GetSpikesFromStructure('PFCx');
    numNeurons=GetSpikesFromStructure('PFCx');
    nN=numNeurons;
    for s=1:length(numNeurons)
        if TT{numNeurons(s)}(2)==1
            nN(nN==numNeurons(s))=[];
        end
    end
    S=S(nN);   

    if MethMouK==1
    dHPCrip=GetRipplesML;
    rip=ts(dHPCrip(:,2)*1E4);
    [Wake,REM,N1,N2,N3]=RunSubstages;close
    else    
    load('Ripples.mat', 'Ripples')
    rip=ts(Ripples(:,2)*10);
%     load('SleepSubstages.mat', 'Epoch')
%     N1 = Epoch{1}; N2 = Epoch{2}; N3 = Epoch{3}; REM = Epoch{4}; Wake = Epoch{5}; NREM = Epoch{7}; 
    [Wake,REM,N1,N2,N3]=RunSubstages;close
    end
    
    
   
    clear C
    clear CN1
    clear CN2
    clear CN3
    clear CWA    
    clear Cz
    clear CzN1
    clear CzN2
    clear CzN3
    clear CzWA    
     a=1;
%     CCparam1=10;
%     CCparam2=100;
    for i=1:length(S)
        [C(a,:),B]=CrossCorr(Range(rip),Range(S{i}),CCparam1,CCparam2);   
        [CN1(a,:),B]=CrossCorr(Range(Restrict(rip,N1)),Range(S{i}),CCparam1,CCparam2);   
        [CN2(a,:),B]=CrossCorr(Range(Restrict(rip,N2)),Range(S{i}),CCparam1,CCparam2);   
        [CN3(a,:),B]=CrossCorr(Range(Restrict(rip,N3)),Range(S{i}),CCparam1,CCparam2);   
        [CWA(a,:),B]=CrossCorr(Range(Restrict(rip,Wake)),Range(S{i}),CCparam1,CCparam2);   
        listlocal(b)=p;
        a=a+1;
        b=b+1; 
    end
    
    
    Q=MakeQfromS(S,400);
    QS=full(Data(Q));
    [m(c,:),sd(c,:),tps]=mETAverage(Range(rip),Range(Q),sum(zscore(QS),2),10,200);
    [mN1(c,:),sdN1(c,:),tps]=mETAverage(Range(Restrict(rip,N1)),Range(Q),sum(zscore(QS),2),10,200);
    [mN2(c,:),sdN2(c,:),tps]=mETAverage(Range(Restrict(rip,N2)),Range(Q),sum(zscore(QS),2),10,200);
    [mN3(c,:),sdN3(c,:),tps]=mETAverage(Range(Restrict(rip,N3)),Range(Q),sum(zscore(QS),2),10,200);
    [mWA(c,:),sdWA(c,:),tps]=mETAverage(Range(Restrict(rip,Wake)),Range(Q),sum(zscore(QS),2),10,200);
    mC(c,:)=nanmean(C);
    mCN1(c,:)=nanmean(CN1);
    mCN2(c,:)=nanmean(CN2);
    mCN3(c,:)=nanmean(CN3);
    mCWA(c,:)=nanmean(CWA);
    c=c+1;
    
    
    Cz=nanzscore(C')';
    CzN1=nanzscore(CN1')';
    CzN2=nanzscore(CN2')';
    CzN3=nanzscore(CN3')';
    CzWA=nanzscore(CWA')';
    
    [BE,id]=sort(mean(Cz(:,floor(size(C,2)/2):floor(size(C,2)/2)+5),2));
    
    if plo
    figure, 
    subplot(2,5,1), imagesc(B/1E3,1:size(C,1),Cz(id,:))
    subplot(2,5,2), imagesc(B/1E3,1:size(C,1),CzN1(id,:))
    subplot(2,5,3), imagesc(B/1E3,1:size(C,1),CzN2(id,:)), title(pwd)
    subplot(2,5,4), imagesc(B/1E3,1:size(C,1),CzN3(id,:))
    subplot(2,5,5), imagesc(B/1E3,1:size(C,1),CzWA(id,:))
    subplot(2,5,6), plot(B/1E3,runmean(nanmean(Cz),2),'k'), line([0 0],[-0.5 2],'color',[0.7 0.7 0.7]), ylim([-0.5 2]), title('Total')
    subplot(2,5,7), plot(B/1E3,runmean(nanmean(CzN1),2),'k'), line([0 0],[-0.5 2],'color',[0.7 0.7 0.7]), ylim([-0.5 2]), title('N1')
    subplot(2,5,8), plot(B/1E3,runmean(nanmean(CzN2),2),'k'), line([0 0],[-0.5 2],'color',[0.7 0.7 0.7]), ylim([-0.5 2]), title('N2')
    subplot(2,5,9), plot(B/1E3,runmean(nanmean(CzN3),2),'k'), line([0 0],[-0.5 2],'color',[0.7 0.7 0.7]), ylim([-0.5 2]), title('N3')
    subplot(2,5,10), plot(B/1E3,runmean(nanmean(CzWA),2),'k'), line([0 0],[-0.5 2],'color',[0.7 0.7 0.7]), ylim([-0.5 2]), title('Wake')
    end
    
    Ct=[Ct;C];
    CtN1=[CtN1;CN1];
    CtN2=[CtN2;CN2];
    CtN3=[CtN3;CN3];
    CtWA=[CtWA;CWA];
    
 end

end

Ctz=nanzscore(Ct')';
CtzN1=nanzscore(CtN1')';
CtzN2=nanzscore(CtN2')';
CtzN3=nanzscore(CtN3')';
CtzWA=nanzscore(CtWA')';

[BE,idt]=sort(mean(Ctz(:,floor(size(Ct,2)/2):floor(size(Ct,2)/2)+5),2));
    
figure, 
subplot(2,6,1), imagesc(B/1E3,1:size(Ct,1),Ctz(idt,:))
subplot(2,6,2), imagesc(B/1E3,1:size(Ct,1),CtzN1(idt,:))
subplot(2,6,3), imagesc(B/1E3,1:size(Ct,1),CtzN2(idt,:))
subplot(2,6,4), imagesc(B/1E3,1:size(Ct,1),CtzN3(idt,:))
subplot(2,6,5), imagesc(B/1E3,1:size(Ct,1),CtzWA(idt,:))
subplot(2,6,7), plot(B/1E3,runmean(nanmean(Ctz),2),'k'), line([0 0],[-0.5 2],'color',[0.7 0.7 0.7]), ylim([-0.5 2]), title('Total')
subplot(2,6,8), plot(B/1E3,runmean(nanmean(CtzN1),2),'k'), line([0 0],[-0.5 2],'color',[0.7 0.7 0.7]), ylim([-0.5 2]), title('N1')
subplot(2,6,9), plot(B/1E3,runmean(nanmean(CtzN2),2),'k'), line([0 0],[-0.5 2],'color',[0.7 0.7 0.7]), ylim([-0.5 2]), title('N2')
subplot(2,6,10), plot(B/1E3,runmean(nanmean(CtzN3),2),'k'), line([0 0],[-0.5 2],'color',[0.7 0.7 0.7]), ylim([-0.5 2]), title('N3')
subplot(2,6,11), plot(B/1E3,runmean(nanmean(CtzWA),2),'k'), line([0 0],[-0.5 2],'color',[0.7 0.7 0.7]), ylim([-0.5 2]), title('Wake')
    
    
subplot(2,6,[6,12]),hold on
plot(B/1E3,runmean(nanmean(Ctz),2),'k'), 
plot(B/1E3,runmean(nanmean(CtzN1),2),'b')
plot(B/1E3,runmean(nanmean(CtzN2),2),'m')
plot(B/1E3,runmean(nanmean(CtzN3),2),'r')
plot(B/1E3,runmean(nanmean(CtzWA),2),'g')
line([0 0],[-0.5 2],'color',[0.7 0.7 0.7]), ylim([-0.5 2])



figure, hold on, 
subplot(1,6,1), imagesc(tps,1:size(m,1),nanzscore(m')')
subplot(1,6,2), imagesc(tps,1:size(mN1,1),nanzscore(mN1')')
subplot(1,6,3), imagesc(tps,1:size(mN2,1),nanzscore(mN2')')
subplot(1,6,4), imagesc(tps,1:size(mN3,1),nanzscore(mN3')')
subplot(1,6,5), imagesc(tps,1:size(mWA,1),nanzscore(mWA')')
subplot(1,6,6), hold on
plot(tps,runmean(nanmean(nanzscore(m')'),2),'k')
plot(tps,runmean(nanmean(nanzscore(mN1')'),2),'b')
plot(tps,runmean(nanmean(nanzscore(mN2')'),2),'m')
plot(tps,runmean(nanmean(nanzscore(mN3')'),2),'r')
plot(tps,runmean(nanmean(nanzscore(mWA')'),2),'g')
line([0 0],[-5 5],'color',[0.7 0.7 0.7]), ylim([-5 5])


figure, hold on, 
subplot(1,3,1), hold on
plot(B/1E3,runmean(nanmean(Ctz),2),'k'), 
plot(B/1E3,runmean(nanmean(CtzN1),2),'b')
plot(B/1E3,runmean(nanmean(CtzN2),2),'m')
plot(B/1E3,runmean(nanmean(CtzN3),2),'r')
plot(B/1E3,runmean(nanmean(CtzWA),2),'g')
line([0 0],[-0.5 1.5],'color',[0.7 0.7 0.7]), ylim([-0.5 1.5])
subplot(1,3,2), hold on
plot(tps,runmean(nanmean(nanzscore(mC')'),2),'k')
plot(tps,runmean(nanmean(nanzscore(mCN1')'),2),'b')
plot(tps,runmean(nanmean(nanzscore(mCN2')'),2),'m')
plot(tps,runmean(nanmean(nanzscore(mCN3')'),2),'r')
plot(tps,runmean(nanmean(nanzscore(mCWA')'),2),'g')
line([0 0],[-2 5],'color',[0.7 0.7 0.7]), ylim([-2 5])
subplot(1,3,3), hold on
plot(tps,runmean(nanmean(nanzscore(m')'),2),'k')
plot(tps,runmean(nanmean(nanzscore(mN1')'),2),'b')
plot(tps,runmean(nanmean(nanzscore(mN2')'),2),'m')
plot(tps,runmean(nanmean(nanzscore(mN3')'),2),'r')
plot(tps,runmean(nanmean(nanzscore(mWA')'),2),'g')
line([0 0],[-2 5],'color',[0.7 0.7 0.7]), ylim([-2 5])




idx=find(B/1E3>-1&B/1E3<-0.5);
for j=1:size(Ct,1)
Ctzb(j,:)=Ct(j,:)/mean(Ct(j,idx));
CtzN1b(j,:)=CtN1(j,:)/mean(CtN1(j,idx));
CtzN2b(j,:)=CtN2(j,:)/mean(CtN2(j,idx));
CtzN3b(j,:)=CtN3(j,:)/mean(CtN3(j,idx));
CtzWAb(j,:)=CtWA(j,:)/mean(CtWA(j,idx));
end
[BE,idtb]=sort(mean(Ctzb(:,floor(size(Ctzb,2)/2):floor(size(Ctzb,2)/2)+5),2)); 

 
figure, 
subplot(2,6,1), imagesc(B/1E3,1:size(Ctzb,1),Ctzb(idtb,:))
subplot(2,6,2), imagesc(B/1E3,1:size(Ctzb,1),CtzN1b(idtb,:))
subplot(2,6,3), imagesc(B/1E3,1:size(Ctzb,1),CtzN2b(idtb,:))
subplot(2,6,4), imagesc(B/1E3,1:size(Ctzb,1),CtzN3b(idtb,:))
subplot(2,6,5), imagesc(B/1E3,1:size(Ctzb,1),CtzWAb(idtb,:))
subplot(2,6,7), plot(B/1E3,runmean(nanmean(Ctzb),2),'k'), line([0 0],[0.7 2],'color',[0.7 0.7 0.7]), ylim([0.7 1.5]), title('Total')
subplot(2,6,8), plot(B/1E3,runmean(nanmean(CtzN1b),2),'k'), line([0 0],[0.7 2],'color',[0.7 0.7 0.7]), ylim([0.7 1.5]), title('N1')
subplot(2,6,9), plot(B/1E3,runmean(nanmean(CtzN2b),2),'k'), line([0 0],[0.7 2],'color',[0.7 0.7 0.7]), ylim([0.7 1.5]), title('N2')
subplot(2,6,10), plot(B/1E3,runmean(nanmean(CtzN3b),2),'k'), line([0 0],[0.7 2],'color',[0.7 0.7 0.7]), ylim([0.7 1.5]), title('N3')
subplot(2,6,11), plot(B/1E3,runmean(nanmean(CtzWAb),2),'k'), line([0 0],[0.7 2],'color',[0.7 0.7 0.7]), ylim([0.7 1.5]), title('Wake')
    
    
subplot(2,6,[6,12]),hold on
plot(B/1E3,runmean(nanmean(Ctzb),2),'k'), 
plot(B/1E3,runmean(nanmean(CtzN1b),2),'b')
plot(B/1E3,runmean(nanmean(CtzN2b),2),'m')
plot(B/1E3,runmean(nanmean(CtzN3b),2),'r')
plot(B/1E3,runmean(nanmean(CtzWAb),2),'g')
line([0 0],[0.7 1.5],'color',[0.7 0.7 0.7]), ylim([0.7 1.5])

