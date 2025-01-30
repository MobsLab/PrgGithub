%ModulatioDeltaRespi

clear 
tic

NameDir={'PLETHYSMO'};

dropSh=1; limdrop=2E4;
a=1;
b=1;

for i=1:length(NameDir)
Dir=PathForExperimentsML(NameDir{i});
for man=1:length(Dir.path)
disp('  ')
disp(Dir.path{man})
disp(Dir.group{man})
disp(' ')
cd(Dir.path{man})
try
    
    clear Sp
    clear t
    clear f
    res=pwd;
    tempchBulb=load([res,'/ChannelsToAnalyse/Bulb_deep.mat'],'channel');
    chBulb=tempchBulb.channel;
    eval(['load(''',res,'','/SpectrumDataL/Spectrum',num2str(chBulb),'.mat'');'])
    disp('*****************  Bulb *********************')
    Sp;
    clear Fil
    clear RespiTSD
    clear SWSEpoch
    try
    clear NoiseEpoch
    clear GndNoiseEpoch
    clear WeirdNoiseEpoch
    end
    clear EpochSlow
    clear tDeltaT2
    clear Dpfcx
    clear Dpacx
    
    load LFPData RespiTSD
    Fil=FilterLFP(RespiTSD,[2 4],4096);
    load StateEpoch SWSEpoch NoiseEpoch GndNoiseEpoch WeirdNoiseEpoch
    
    try
        SWSEpoch=SWSEpoch-NoiseEpoch-GndNoiseEpoch-WeirdNoiseEpoch;
    catch
        try
          SWSEpoch=SWSEpoch-NoiseEpoch-GndNoiseEpoch;  
        catch
          SWSEpoch=SWSEpoch-NoiseEpoch;
        end
    end
    
    
    [EpochSlow,val,val2]=FindSlowOscBulb(Sp,t,f,SWSEpoch,1,[5.5 6.5]);close
    id=find(val(1:9)>30);
    disp(val)
    disp(id)
    try
        id=id(end);
    catch
        id=1;
    end
    %id=10;
    id=5;
    
    disp(' ')
    Epoch=EpochSlow{id};
    if dropSh, Epoch=dropShortIntervals(Epoch,limdrop); end
%     Epoch=SWSEpoch;
 %     Epoch=SWSEpoch-EpochSlow{1};
    clear rg
    clear xmax
    clear tDeltaT2
    clear Dpfcx
    clear Dpacx
 if Dir.group{man}(1)=='W'
        load DeltaPFCx
        Dpfcx=tDeltaT2;
        clear tDeltaT2        
        load DeltaPaCx
        Dpacx=tDeltaT2;        
        [phWTpfc,muWTpfc(a), KappaWTpfc(a), pvalWTpfc(a),BWTpfc,CWTpfc(a,:)]=ModulationTheta(Dpfcx,Fil,Epoch,25,1);close
        [phWTpac,muWTpac(a), KappaWTpac(a), pvalWTpac(a),BWTpac,CWTpac(a,:)]=ModulationTheta(Dpacx,Fil,Epoch,25,1);close
        zr = hilbert(Data(Fil));
        phzr = atan2(imag(zr), real(zr));
        phzr(phzr < 0) = phzr(phzr < 0) + 2 * pi;
        phaseTsd = tsd(Range(Fil), phzr);
        [H(a,:),B]=hist(Data(phaseTsd),[2*pi/50:2*pi/25:2*pi-2*pi/50]);
        [muH(a), KappaH(a), pvalH(a)] = CircularMean(Data(phaseTsd));
        nameWT{a}=pwd;
        DurSlow(a,1)=val(id);
        DurSlow(a,2)=id;   
        DurSlow(a,3)=t(end)-t(1);    
        DurSlow(a,4)=sum(End(SWSEpoch,'s')-Start(SWSEpoch,'s'));
        DurSlow(a,5)=sum(End(Epoch,'s')-Start(Epoch,'s'));
        DurSlow(a,6)=sum(End(SWSEpoch-Epoch,'s')-Start(SWSEpoch-Epoch,'s'));
        
        DurSlow(a,7)=length(Range(Restrict(Dpfcx,SWSEpoch)));
        DurSlow(a,8)=length(Range(Restrict(Dpacx,SWSEpoch)));
        DurSlow(a,9)=length(Range(Restrict(Dpfcx,Epoch)));
        DurSlow(a,10)=length(Range(Restrict(Dpacx,Epoch)));
        DurSlow(a,11)=length(Range(Restrict(Dpfcx,SWSEpoch-Epoch)));
        DurSlow(a,12)=length(Range(Restrict(Dpacx,SWSEpoch-Epoch)));
        
        [Cr(a,:),Br]=CrossCorr(Range(Restrict(Dpfcx,Epoch)),Range(Restrict(Dpacx,Epoch)),20,200);
        [Cr2(a,:),Br]=CrossCorr(Range(Restrict(Dpfcx,SWSEpoch-Epoch)),Range(Restrict(Dpacx,SWSEpoch-Epoch)),20,200);   
        rg=Range(RespiTSD);
        Fil=FilterLFP(RespiTSD,[2 4],4096);
        xmax=findpeaks(Data(Fil));
        tref=ts(rg(xmax.loc));
        [Cr3(a,:),Br]=CrossCorr(Range(Restrict(tref,Epoch)),Range(Restrict(Dpfcx,Epoch)),20,200);
        [Cr4(a,:),Br]=CrossCorr(Range(Restrict(tref,SWSEpoch-Epoch)),Range(Restrict(Dpfcx,SWSEpoch-Epoch)),20,200);
        [Cr5(a,:),Br]=CrossCorr(Range(Restrict(tref,SWSEpoch)),Range(Restrict(Dpfcx,SWSEpoch)),20,200);
        [Cr6(a,:),Br]=CrossCorr(Range(Restrict(tref,Epoch)),Range(Restrict(Dpacx,Epoch)),20,200);
        [Cr7(a,:),Br]=CrossCorr(Range(Restrict(tref,SWSEpoch-Epoch)),Range(Restrict(Dpacx,SWSEpoch-Epoch)),20,200);        
        [Cr8(a,:),Br]=CrossCorr(Range(Restrict(tref,SWSEpoch)),Range(Restrict(Dpacx,SWSEpoch)),20,200);        
        a=a+1;
 else
        load DeltaPFCx
        Dpfcx=tDeltaT2;
        clear tDeltaT2
        load DeltaPaCx
        Dpacx=tDeltaT2;  
        [phKOpac,muKOpfc(b), KappaKOpfc(b), pvalKOpfc(b),BKOpfc,CKOpfc(b,:)]=ModulationTheta(Dpfcx,Fil,Epoch,25,1);close
        [phKOpac,muKOpac(b), KappaKOpac(b), pvalKOpac(b),BKOpac,CKOpac(b,:)]=ModulationTheta(Dpacx,Fil,Epoch,25,1);close
        zr = hilbert(Data(Fil));
        phzr = atan2(imag(zr), real(zr));
        phzr(phzr < 0) = phzr(phzr < 0) + 2 * pi;
        phaseTsd = tsd(Range(Fil), phzr);
        [HKO(b,:),B]=hist(Data(phaseTsd),[2*pi/50:2*pi/25:2*pi-2*pi/50]);
        [muHKO(b), KappaHKO(b), pvalHKO(b)] = CircularMean(Data(phaseTsd));
        nameKO{b}=pwd;
        DurSlowKO(b,1)=val(id);  
        DurSlowKO(b,2)=id;   
        DurSlowKO(b,3)=t(end)-t(1);      
        DurSlowKO(b,4)=sum(End(SWSEpoch,'s')-Start(SWSEpoch,'s'));
        DurSlowKO(b,5)=sum(End(Epoch,'s')-Start(Epoch,'s'));
        DurSlowKO(b,6)=sum(End(SWSEpoch-Epoch,'s')-Start(SWSEpoch-Epoch,'s'));
        
        DurSlowKO(b,7)=length(Range(Restrict(Dpfcx,SWSEpoch)));
        DurSlowKO(b,8)=length(Range(Restrict(Dpacx,SWSEpoch)));
        DurSlowKO(b,9)=length(Range(Restrict(Dpfcx,Epoch)));
        DurSlowKO(b,10)=length(Range(Restrict(Dpacx,Epoch)));
        DurSlowKO(b,11)=length(Range(Restrict(Dpfcx,SWSEpoch-Epoch)));
        DurSlowKO(b,12)=length(Range(Restrict(Dpacx,SWSEpoch-Epoch)));
        

        
        [CrKO(b,:),BrKO]=CrossCorr(Range(Restrict(Dpfcx,Epoch)),Range(Restrict(Dpacx,Epoch)),20,200);
        [CrKO2(b,:),BrKO]=CrossCorr(Range(Restrict(Dpfcx,SWSEpoch-Epoch)),Range(Restrict(Dpacx,SWSEpoch-Epoch)),20,200);
         rg=Range(RespiTSD);
        Fil=FilterLFP(RespiTSD,[2 4],4096);
        xmax=findpeaks(Data(Fil));
        tref=ts(rg(xmax.loc));
        [CrKO3(b,:),BrKO]=CrossCorr(Range(Restrict(tref,Epoch)),Range(Restrict(Dpfcx,Epoch)),20,200);
        [CrKO4(b,:),BrKO]=CrossCorr(Range(Restrict(tref,SWSEpoch-Epoch)),Range(Restrict(Dpfcx,SWSEpoch-Epoch)),20,200);  
        [CrKO5(b,:),BrKO]=CrossCorr(Range(Restrict(tref,SWSEpoch)),Range(Restrict(Dpfcx,SWSEpoch)),20,200); 
        [CrKO6(b,:),BrKO]=CrossCorr(Range(Restrict(tref,Epoch)),Range(Restrict(Dpacx,Epoch)),20,200); 
        [CrKO7(b,:),BrKO]=CrossCorr(Range(Restrict(tref,SWSEpoch-Epoch)),Range(Restrict(Dpacx,SWSEpoch-Epoch)),20,200);         
        [CrKO8(b,:),BrKO]=CrossCorr(Range(Restrict(tref,SWSEpoch)),Range(Restrict(Dpacx,SWSEpoch)),20,200);         
        b=b+1;
end
end
end
end


%--------------------------------------------------------------------
%--------------------------------------------------------------------
%--------------------------------------------------------------------



for i=1:size(H,1)
    ma1(i)=max(H(i,:));
end
for i=1:size(HKO,1)
    ma2(i)=max(HKO(i,:));
end



phc=[2*pi/50:2*pi/25:2*pi-2*pi/50];
th=0.05;

figure('color',[1 1 1]),
subplot(1,3,1), hold on, 
plot(muWTpfc,KappaWTpfc,'ko'), plot(muKOpfc,KappaKOpfc,'ro')
plot(muWTpfc(pvalWTpfc<th),KappaWTpfc(pvalWTpfc<th),'ko','markerfacecolor','k'), plot(muKOpfc(pvalKOpfc<th),KappaKOpfc(pvalKOpfc<th),'ro','markerfacecolor','r')
xlim([0 2*pi]),yl=ylim; ylim([0 yl(2)])
subplot(1,3,2), hold on, 
plot(muWTpac,KappaWTpac,'ko'), plot(muKOpac,KappaKOpac,'ro')
plot(muWTpac(pvalWTpac<th),KappaWTpac(pvalWTpac<th),'ko','markerfacecolor','k'), plot(muKOpac(pvalKOpac<th),KappaKOpac(pvalKOpac<th),'ro','markerfacecolor','r')
xlim([0 2*pi]),yl=ylim; ylim([0 yl(2)])
subplot(1,3,3), hold on, 
plot(phc,mean(HKO./(ma2'*ones(1,size(HKO,2)))),'m')
plot(phc,mean(H./(ma1'*ones(1,size(H,2)))),'b')
xlim([0 2*pi])
ylim([0 1])

% 
% [BE,idWT]=sort(muWTpfc);
% [BE,idKO]=sort(muWTpfcKO);
% [BE,idWT2]=sort(muWTpac);
% [BE,idKO2]=sort(muWTpacKO);
% 
% figure('color',[1 1 1]), 
% subplot(2,2,1), imagesc(CWTpfc(idWT,:)), title('PFC WT')
% subplot(2,2,3), imagesc(CWTpfcKO(idKO,:)), title('PFC KO')
% subplot(2,2,2), imagesc(CWTpac(idWT2,:)), title('Par WT')
% subplot(2,2,4), imagesc(CWTpacKO(idKO2,:)), title('Par KO')



figure('color',[1 1 1]),
subplot(2,4,1), imagesc(CWTpfc), title('PFC WT')
subplot(2,4,5), imagesc(CKOpfc), title('PFC KO')
subplot(2,4,2), imagesc(CWTpac), title('Par WT')
subplot(2,4,6), imagesc(CKOpac), title('Par KO')

subplot(2,4,3), imagesc(H./(ma1'*ones(1,size(H,2)))), title('WT')
subplot(2,4,7), imagesc(HKO./(ma2'*ones(1,size(HKO,2)))), title('KO')
subplot(2,4,4), imagesc(zscore(H')'), title('WT (zscore)')
subplot(2,4,8), imagesc(zscore(HKO')'), title('KO (zscore)')


phas=0:2*pi/24:2*pi;

figure('color',[1 1 1]),
subplot(2,5,1), plot(phas,CWTpfc','k'), ylabel('PF Cx'),xlim([0 2*pi])
subplot(2,5,2), plot(phas,CKOpfc','r'),xlim([0 2*pi])
subplot(2,5,3), hold on, 
plot(phas,mean(CWTpfc),'k','linewidth',2), 
plot(phas,mean(CKOpfc),'r','linewidth',2),xlim([0 2*pi])
yl=ylim; ylim([0 yl(2)])
subplot(2,5,6), plot(phas,CWTpac','k'), ylabel('Par Cx'),xlim([0 2*pi])
subplot(2,5,7), plot(phas,CKOpac','r'),xlim([0 2*pi])
subplot(2,5,8), hold on, 
plot(phas,mean(CWTpac),'k','linewidth',2), 
plot(phas,mean(CKOpac),'r','linewidth',2),xlim([0 2*pi])
yl=ylim; ylim([0 yl(2)])
subplot(2,5,4), imagesc(SmoothDec(zscore(CWTpfc')',[0.001 1])), title('PFC WT')
subplot(2,5,5), imagesc(SmoothDec(zscore(CKOpfc')',[0.001 1])), title('PFC KO')
subplot(2,5,9), imagesc(SmoothDec(zscore(CWTpac')',[0.001 1])), title('Par WT')
subplot(2,5,10), imagesc(SmoothDec(zscore(CKOpac')',[0.001 1])), title('Par KO')



titCr{1}='Delta Pfc Par, Slow';
titCr{2}='Delta Pfc Par, no Slow';
titCr{3}='Respi Delta Pfc, Slow';
titCr{4}='Respi Delta Pfc, no Slow';
titCr{5}='Respi Delta Par, Slow';
titCr{6}='Respi Delta Par, no Slow';

smo=5;

figure('color',[1 1 1])
subplot(3,2,1), hold on, 
plot(Br,smooth(mean(Cr),smo),'k','linewidth',2)
plot(Br,smooth(mean(CrKO),smo),'r','linewidth',2), 
yl=ylim; line([0 0],yl,'color',[0.7 0.7 0.7])
ylim([0 yl(2)])
title(titCr{1})
subplot(3,2,2), hold on, 
plot(Br,smooth(mean(Cr2),smo),'k','linewidth',2)
plot(Br,smooth(mean(CrKO2),smo),'r','linewidth',2), 
yl=ylim; line([0 0],yl,'color',[0.7 0.7 0.7])
title(titCr{2})
ylim([0 yl(2)])
subplot(3,2,3), hold on, 
plot(Br,smooth(mean(Cr3),smo),'k','linewidth',2)
plot(Br,smooth(mean(CrKO3),smo),'r','linewidth',2), 
yl=ylim; line([0 0],yl,'color',[0.7 0.7 0.7])
title(titCr{3})
ylim([0 yl(2)])
subplot(3,2,4), hold on, 
plot(Br,smooth(mean(Cr4),smo),'k','linewidth',2)
plot(Br,smooth(mean(CrKO4),smo),'r','linewidth',2), 
yl=ylim; line([0 0],yl,'color',[0.7 0.7 0.7])
title(titCr{4})
ylim([0 yl(2)])
subplot(3,2,5), hold on, 
plot(Br,smooth(mean(Cr6),smo),'k','linewidth',2)
plot(Br,smooth(mean(CrKO6),smo),'r','linewidth',2), 
yl=ylim; line([0 0],yl,'color',[0.7 0.7 0.7])
title(titCr{5})
ylim([0 yl(2)])
subplot(3,2,6), hold on, 
plot(Br,smooth(mean(Cr7),smo),'k','linewidth',2)
plot(Br,smooth(mean(CrKO7),smo),'r','linewidth',2), 
yl=ylim; line([0 0],yl,'color',[0.7 0.7 0.7])
title(titCr{6})
ylim([0 yl(2)])



figure('color',[1 1 1])
subplot(1,2,1), hold on, 
plot(Br,smooth(mean(Cr5),smo),'k','linewidth',2)
plot(Br,smooth(mean(CrKO5),smo),'r','linewidth',2), 
yl=ylim; line([0 0],yl,'color',[0.7 0.7 0.7])
ylim([0 yl(2)])
[h,p]=ttest2(Cr5,CrKO5);
for i=1:size(Cr5,1)
[p(i),h]=ranksum(Cr5(i,:),CrKO5(i,:));
end
plot(Br(find(p<0.05)),zeros(length(find(p<0.05)),1),'bo','markerfacecolor','b')
title('Respi Delta PFC')
subplot(1,2,2), hold on, 
plot(Br,smooth(mean(Cr8),smo),'k','linewidth',2)
plot(Br,smooth(mean(CrKO8),smo),'r','linewidth',2), 
yl=ylim; line([0 0],yl,'color',[0.7 0.7 0.7])
title('Respi Delta Par')
ylim([0 yl(2)])
[h,p8]=ttest2(Cr8,CrKO8);
for i=1:size(Cr8,1)
[p8(i),h]=ranksum(Cr8(i,:),CrKO8(i,:));
end
plot(Br(find(p8<0.05)),zeros(length(find(p8<0.05)),1),'bo','markerfacecolor','b')

 
tiDur{1}='percentage Slow';
tiDur{2}='id;';

tiDur{3}='Duration recording'; 
tiDur{4}='Duration SWSEpoch,';
tiDur{5}='Duration Slow,';
tiDur{6}='Duration No Slow,';

tiDur{7}='Nb Delta pfcx SWSEpoch';
tiDur{8}='Nb Delta pacx SWSEpoch';
tiDur{9}='Nb Delta pfcx Slow Epoch';
tiDur{10}='Nb Delta pacx Slow Epoch';
tiDur{11}='Nb Delta pfcx No Slow Epoch';
tiDur{12}='Nb Delta pacx No Slow Epoch';

tiDur{13}='Freq Delta pfcx SWSEpoch';
tiDur{14}='Freq Delta pacx SWSEpoch';
tiDur{15}='Freq Delta pfcx Slow Epoch';
tiDur{16}='Freq Delta pacx Slow Epoch';
tiDur{17}='Freq Delta pfcx No Slow Epoch';
tiDur{18}='Freq Delta pacx No Slow Epoch';

DurSlow(:,13)=DurSlow(:,7)./DurSlow(:,4);
DurSlow(:,14)=DurSlow(:,8)./DurSlow(:,4);
DurSlow(:,15)=DurSlow(:,9)./DurSlow(:,5);
DurSlow(:,16)=DurSlow(:,10)./DurSlow(:,5);
DurSlow(:,17)=DurSlow(:,9)./DurSlow(:,6);
DurSlow(:,18)=DurSlow(:,10)./DurSlow(:,6);

DurSlowKO(:,13)=DurSlowKO(:,7)./DurSlowKO(:,4);
DurSlowKO(:,14)=DurSlowKO(:,8)./DurSlowKO(:,4);
DurSlowKO(:,15)=DurSlowKO(:,9)./DurSlowKO(:,5);
DurSlowKO(:,16)=DurSlowKO(:,10)./DurSlowKO(:,5);
DurSlowKO(:,17)=DurSlowKO(:,9)./DurSlowKO(:,6);
DurSlowKO(:,18)=DurSlowKO(:,10)./DurSlowKO(:,6);


 figure('color',[1 1 1])
 for i=1:18
     subplot(3,6,i), PlotErrorBar2(DurSlow(:,i),DurSlowKO(:,i),0,1), title(tiDur{i})
 end
 
 
 
toc


