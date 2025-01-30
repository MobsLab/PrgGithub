%TrucKarimSpikesRipplesJitter

%DataTrucKarimSpikesRipplesJitter200

plo=0;

 Dir=PathForExperimentsMLnew('Spikes');MethMouK=1;
% Dir=PathForExperimentsSleepRipplesSpikes('all');MethMouK=0;

nbperm=250;
jit=400;
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

for p=1:5

    try
    disp(' ')
    disp('****************************************************************')
    eval(['cd(Dir.path{',num2str(p),'}'')'])
    disp(pwd)
    
    
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
  
     a=1;
%     CCparam1=10;
%     CCparam2=100;
    for i=1:length(S)
        [C(a,:),B]=JitterCrossCorr(rip,S{i},nbperm,jit,CCparam1,CCparam2);   
        [CN1(a,:),B]=JitterCrossCorr(Restrict(rip,N1),S{i},nbperm,jit,CCparam1,CCparam2);   
        [CN2(a,:),B]=JitterCrossCorr(Restrict(rip,N2),S{i},nbperm,jit,CCparam1,CCparam2);   
        [CN3(a,:),B]=JitterCrossCorr(Restrict(rip,N3),S{i},nbperm,jit,CCparam1,CCparam2);   
        [CWA(a,:),B]=JitterCrossCorr(Restrict(rip,Wake),S{i},nbperm,jit,CCparam1,CCparam2);   
        listlocal(b)=p;
        a=a+1;
        b=b+1; 
    end
    Ct=[Ct;C];
    CtN1=[CtN1;CN1];
    CtN2=[CtN2;CN2];
    CtN3=[CtN3;CN3];
    CtWA=[CtWA;CWA];
    
    end
    
end


[BE,idt]=sort(mean(Ct(:,floor(size(Ct,2)/2):floor(size(Ct,2)/2)+5),2));
    
figure, 
subplot(2,6,1), imagesc(B/1E3,1:size(Ct,1),Ct(idt,:))
subplot(2,6,2), imagesc(B/1E3,1:size(Ct,1),CtN1(idt,:))
subplot(2,6,3), imagesc(B/1E3,1:size(Ct,1),CtN2(idt,:))
subplot(2,6,4), imagesc(B/1E3,1:size(Ct,1),CtN3(idt,:))
subplot(2,6,5), imagesc(B/1E3,1:size(Ct,1),CtWA(idt,:))
subplot(2,6,7), plot(B/1E3,runmean(nanmean(Ct),2),'k'), line([0 0],[-0.5 2],'color',[0.7 0.7 0.7]), ylim([-0.5 2]), title('Total')
subplot(2,6,8), plot(B/1E3,runmean(nanmean(CtN1),2),'k'), line([0 0],[-0.5 2],'color',[0.7 0.7 0.7]), ylim([-0.5 2]), title('N1')
subplot(2,6,9), plot(B/1E3,runmean(nanmean(CtN2),2),'k'), line([0 0],[-0.5 2],'color',[0.7 0.7 0.7]), ylim([-0.5 2]), title('N2')
subplot(2,6,10), plot(B/1E3,runmean(nanmean(CtN3),2),'k'), line([0 0],[-0.5 2],'color',[0.7 0.7 0.7]), ylim([-0.5 2]), title('N3')
subplot(2,6,11), plot(B/1E3,runmean(nanmean(CtWA),2),'k'), line([0 0],[-0.5 2],'color',[0.7 0.7 0.7]), ylim([-0.5 2]), title('Wake')
    
    
subplot(2,6,[6,12]),hold on
plot(B/1E3,runmean(nanmean(Ct),2),'k'), 
plot(B/1E3,runmean(nanmean(CtN1),2),'b')
plot(B/1E3,runmean(nanmean(CtN2),2),'m')
plot(B/1E3,runmean(nanmean(CtN3),2),'r')
plot(B/1E3,runmean(nanmean(CtWA),2),'g')
line([0 0],[-0.5 2],'color',[0.7 0.7 0.7]), ylim([-0.5 2])


