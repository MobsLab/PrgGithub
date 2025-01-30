%PlotLocalGlobal_AvsB
smo=1;
load([res,'/LFPData/InfoLFP']);
close all
load LFPLocalGlobal
lim=5500;
pval=0.05;


for i=1:length(InfoLFP.structure); 
    %---------------------------------------------------------------------------
    %<><><><><><><><><><><><><><> Local Effect <><><><><><><><><><><><><><><
    %---------------------------------------------------------------------------
    tempA=Data(MLstdGstd_A(i))';
    MsA=[tempA(:,1:size(tempA,2)-1)];
    MsA(MsA>lim)=nan;
    MsA(MsA<-lim)=nan;
    
    tempB=Data(MLdevGstd_B(i))';
    MsB=[tempB(:,1:size(tempB,2)-1)];
    MsB(MsB>lim)=nan;
    MsB(MsB<-lim)=nan;
    
    [Ma,S1,Ea]=MeanDifNan(RemoveNan(MsA));
    [Mb,S2,Eb]=MeanDifNan(RemoveNan(MsB));

    [h,p]=ttest2(RemoveNan(MsA),RemoveNan(MsB));
    
    rg=Range(MLstdGstd_A(i),'ms');
    pr=rescale(p,-600, -700);
    tps=Range(MLstdGstd_A(i),'ms');
    
    figure, subplot(4,2,1)
    hold on, plot(tps(1:end-1),SmoothDec((Ma),smo),'k','linewidth',2), 
    hold on, plot(tps(1:end-1),SmoothDec((Ma+Ea),smo),'k') 
    hold on, plot(tps(1:end-1),SmoothDec((Ma-Ea),smo),'k') 
    hold on, plot(tps(1:end-1),SmoothDec((Mb),smo),'r','linewidth',2), 
    hold on, plot(tps(1:end-1),SmoothDec((Mb+Eb),smo),'r') 
    hold on, plot(tps(1:end-1),SmoothDec((Mb-Eb),smo),'r') 
    hold on, plot(rg(p<pval),pr(p<pval),'kx')
    hold on, axis([-100 1200 -800 800])
    title(['Local effect - last tone A',InfoLFP.structure(i)])
    for a=0:150:600
        hold on, plot(a,min(axis):max(axis),'b','linewidth',1);
    end
    
    %---------------------------------------------------------------------------
    %<><><><><><><><><><><><><><> Global Effect <><><><><><><><><><><><><><><
    %---------------------------------------------------------------------------
    tempA=Data(MLstdGstd_A(i))';
    MsA=[tempA(:,1:size(tempA,2)-1)];
    MsA(MsA>lim)=nan;
    MsA(MsA<-lim)=nan;
    
    tempB=Data(MLstdGdev_A(i))';
    MsB=[tempB(:,1:size(tempB,2)-1)];
    MsB(MsB>lim)=nan;
    MsB(MsB<-lim)=nan;
    
    [Ma,S1,Ea]=MeanDifNan(RemoveNan(MsA));
    [Mb,S2,Eb]=MeanDifNan(RemoveNan(MsB));

    [h,p]=ttest2(RemoveNan(MsA),RemoveNan(MsB));
    
    rg=Range(MLstdGstd_A(i),'ms');
    pr=rescale(p,-600, -700);
    tps=Range(MLstdGstd_A(i),'ms');
    
    hold on, subplot(4,2,3)
    hold on, plot(tps(1:end-1),SmoothDec((Ma),smo),'k','linewidth',2), 
    hold on, plot(tps(1:end-1),SmoothDec((Ma+Ea),smo),'k') 
    hold on, plot(tps(1:end-1),SmoothDec((Ma-Ea),smo),'k') 
    hold on, plot(tps(1:end-1),SmoothDec((Mb),smo),'r','linewidth',2), 
    hold on, plot(tps(1:end-1),SmoothDec((Mb+Eb),smo),'r') 
    hold on, plot(tps(1:end-1),SmoothDec((Mb-Eb),smo),'r') 
    hold on, plot(rg(p<pval),pr(p<pval),'kx')
    hold on, axis([-100 1200 -800 800])
    title(['Global effect 1 - last tone A',InfoLFP.structure(i)])
    for a=0:150:600
        hold on, plot(a,min(axis):max(axis),'b','linewidth',1);
    end
    
    %----------------------------
    tempA=Data(MLdevGstd_B(i))';
    MsA=[tempA(:,1:size(tempA,2)-1)];
    MsA(MsA>lim)=nan;
    MsA(MsA<-lim)=nan;
    
    tempB=Data(MLdvtGdev_B(i))';
    MsB=[tempB(:,1:size(tempB,2)-1)];
    MsB(MsB>lim)=nan;
    MsB(MsB<-lim)=nan;
    
    [Ma,S1,Ea]=MeanDifNan(RemoveNan(MsA));
    [Mb,S2,Eb]=MeanDifNan(RemoveNan(MsB));

    [h,p]=ttest2(RemoveNan(MsA),RemoveNan(MsB));
    
    rg=Range(MLdevGstd_B(i),'ms');
    pr=rescale(p,-600, -700);
    tps=Range(MLdevGstd_B(i),'ms');
    
    hold on, subplot(4,2,5)
    hold on, plot(tps(1:end-1),SmoothDec((Ma),smo),'k','linewidth',2), 
    hold on, plot(tps(1:end-1),SmoothDec((Ma+Ea),smo),'k') 
    hold on, plot(tps(1:end-1),SmoothDec((Ma-Ea),smo),'k') 
    hold on, plot(tps(1:end-1),SmoothDec((Mb),smo),'r','linewidth',2), 
    hold on, plot(tps(1:end-1),SmoothDec((Mb+Eb),smo),'r') 
    hold on, plot(tps(1:end-1),SmoothDec((Mb-Eb),smo),'r') 
    hold on, plot(rg(p<pval),pr(p<pval),'kx')
    hold on, axis([-100 1200 -800 800])
    title(['Global effect 2 - last tone A',InfoLFP.structure(i)])
    for a=0:150:600
        hold on, plot(a,min(axis):max(axis),'b','linewidth',1);
    end
    
    %---------------------------------------------------------------------------
    %<><><><><><><><><><><><><><> Omission Effect <><><><><><><><><><><><><><><
    %---------------------------------------------------------------------------
    tempA=Data(OmiFreq_A(i))';
    MsA=[tempA(:,1:size(tempA,2)-1)];
    MsA(MsA>lim)=nan;
    MsA(MsA<-lim)=nan;
    
    tempB=Data(OmiRare_A(i))';
    MsB=[tempB(:,1:size(tempB,2)-1)];
    MsB(MsB>lim)=nan;
    MsB(MsB<-lim)=nan;
    
    [Ma,S1,Ea]=MeanDifNan(RemoveNan(MsA));
    [Mb,S2,Eb]=MeanDifNan(RemoveNan(MsB));

    [h,p]=ttest2(RemoveNan(MsA),RemoveNan(MsB));
    
    rg=Range(OmiFreq_A(i),'ms');
    pr=rescale(p,-600, -700);
    tps=Range(OmiFreq_A(i),'ms');
    
    hold on, subplot(4,2,7)
    hold on, plot(tps(1:end-1),SmoothDec((Ma),smo),'k','linewidth',2), 
    hold on, plot(tps(1:end-1),SmoothDec((Ma+Ea),smo),'k') 
    hold on, plot(tps(1:end-1),SmoothDec((Ma-Ea),smo),'k') 
    hold on, plot(tps(1:end-1),SmoothDec((Mb),smo),'r','linewidth',2), 
    hold on, plot(tps(1:end-1),SmoothDec((Mb+Eb),smo),'r') 
    hold on, plot(tps(1:end-1),SmoothDec((Mb-Eb),smo),'r') 
    hold on, plot(rg(p<pval),pr(p<pval),'kx')
    hold on, axis([-100 1200 -800 800])
    title(['Omission effect - last tone A',InfoLFP.structure(i)])
    for a=0:150:600
        hold on, plot(a,min(axis):max(axis),'b','linewidth',1);
    end
    
    
    
    %---------------------------------------------------------------------------
    %<><><><><><><><><><><><><><> Local Effect <><><><><><><><><><><><><><><
    %---------------------------------------------------------------------------
    tempA=Data(MLstdGstd_B(i))';
    MsA=[tempA(:,1:size(tempA,2)-1)];
    MsA(MsA>lim)=nan;
    MsA(MsA<-lim)=nan;
    
    tempB=Data(MLdevGstd_A(i))';
    MsB=[tempB(:,1:size(tempB,2)-1)];
    MsB(MsB>lim)=nan;
    MsB(MsB<-lim)=nan;
    
    [Ma,S1,Ea]=MeanDifNan(RemoveNan(MsA));
    [Mb,S2,Eb]=MeanDifNan(RemoveNan(MsB));

    [h,p]=ttest2(RemoveNan(MsA),RemoveNan(MsB));
    
    rg=Range(MLstdGstd_B(i),'ms');
    pr=rescale(p,-600, -700);
    tps=Range(MLstdGstd_B(i),'ms');
    
    hold on, subplot(4,2,2)
    hold on, plot(tps(1:end-1),SmoothDec((Ma),smo),'k','linewidth',2), 
    hold on, plot(tps(1:end-1),SmoothDec((Ma+Ea),smo),'k') 
    hold on, plot(tps(1:end-1),SmoothDec((Ma-Ea),smo),'k') 
    hold on, plot(tps(1:end-1),SmoothDec((Mb),smo),'r','linewidth',2), 
    hold on, plot(tps(1:end-1),SmoothDec((Mb+Eb),smo),'r') 
    hold on, plot(tps(1:end-1),SmoothDec((Mb-Eb),smo),'r') 
    hold on, plot(rg(p<pval),pr(p<pval),'kx')
    hold on, axis([-100 1200 -800 800])
    title(['Local effect - last tone B',InfoLFP.structure(i)])
    for a=0:150:600
        hold on, plot(a,min(axis):max(axis),'b','linewidth',1);
    end
    
    %---------------------------------------------------------------------------
    %<><><><><><><><><><><><><><> Global Effect <><><><><><><><><><><><><><><
    %---------------------------------------------------------------------------
    tempA=Data(MLstdGstd_B(i))';
    MsA=[tempA(:,1:size(tempA,2)-1)];
    MsA(MsA>lim)=nan;
    MsA(MsA<-lim)=nan;
    
    tempB=Data(MLstdGdev_B(i))';
    MsB=[tempB(:,1:size(tempB,2)-1)];
    MsB(MsB>lim)=nan;
    MsB(MsB<-lim)=nan;
    
    [Ma,S1,Ea]=MeanDifNan(RemoveNan(MsA));
    [Mb,S2,Eb]=MeanDifNan(RemoveNan(MsB));

    [h,p]=ttest2(RemoveNan(MsA),RemoveNan(MsB));
    
    rg=Range(MLstdGstd_B(i),'ms');
    pr=rescale(p,-600, -700);
    tps=Range(MLstdGstd_B(i),'ms');
    
    hold on, subplot(4,2,4)
    hold on, plot(tps(1:end-1),SmoothDec((Ma),smo),'k','linewidth',2), 
    hold on, plot(tps(1:end-1),SmoothDec((Ma+Ea),smo),'k') 
    hold on, plot(tps(1:end-1),SmoothDec((Ma-Ea),smo),'k') 
    hold on, plot(tps(1:end-1),SmoothDec((Mb),smo),'r','linewidth',2), 
    hold on, plot(tps(1:end-1),SmoothDec((Mb+Eb),smo),'r') 
    hold on, plot(tps(1:end-1),SmoothDec((Mb-Eb),smo),'r') 
    hold on, plot(rg(p<pval),pr(p<pval),'kx')
    hold on, axis([-100 1200 -800 800])
    title(['Global effect 1 - last tone B',InfoLFP.structure(i)])
    for a=0:150:600
        hold on, plot(a,min(axis):max(axis),'b','linewidth',1);
    end
    
    %--------------------------
    tempA=Data(MLdevGstd_A(i))';
    MsA=[tempA(:,1:size(tempA,2)-1)];
    MsA(MsA>lim)=nan;
    MsA(MsA<-lim)=nan;
    
    tempB=Data(MLdvtGdev_A(i))';
    MsB=[tempB(:,1:size(tempB,2)-1)];
    MsB(MsB>lim)=nan;
    MsB(MsB<-lim)=nan;
    
    [Ma,S1,Ea]=MeanDifNan(RemoveNan(MsA));
    [Mb,S2,Eb]=MeanDifNan(RemoveNan(MsB));

    [h,p]=ttest2(RemoveNan(MsA),RemoveNan(MsB));
    
    rg=Range(MLdevGstd_A(i),'ms');
    pr=rescale(p,-600, -700);
    tps=Range(MLdevGstd_A(i),'ms');
    
    hold on, subplot(4,2,6)
    hold on, plot(tps(1:end-1),SmoothDec((Ma),smo),'k','linewidth',2), 
    hold on, plot(tps(1:end-1),SmoothDec((Ma+Ea),smo),'k') 
    hold on, plot(tps(1:end-1),SmoothDec((Ma-Ea),smo),'k') 
    hold on, plot(tps(1:end-1),SmoothDec((Mb),smo),'r','linewidth',2), 
    hold on, plot(tps(1:end-1),SmoothDec((Mb+Eb),smo),'r') 
    hold on, plot(tps(1:end-1),SmoothDec((Mb-Eb),smo),'r') 
    hold on, plot(rg(p<pval),pr(p<pval),'kx')
    hold on, axis([-100 1200 -800 800])
    title(['Global effect 2 - last tone B',InfoLFP.structure(i)])
    for a=0:150:600
        hold on, plot(a,min(axis):max(axis),'b','linewidth',1);
    end
    
    %---------------------------------------------------------------------------
    %<><><><><><><><><><><><><><> Omission Effect <><><><><><><><><><><><><><><
    %---------------------------------------------------------------------------
    tempA=Data(OmiFreq_B(i))';
    MsA=[tempA(:,1:size(tempA,2)-1)];
    MsA(MsA>lim)=nan;
    MsA(MsA<-lim)=nan;
    
    tempB=Data(OmiRare_B(i))';
    MsB=[tempB(:,1:size(tempB,2)-1)];
    MsB(MsB>lim)=nan;
    MsB(MsB<-lim)=nan;
    
    [Ma,S1,Ea]=MeanDifNan(RemoveNan(MsA));
    [Mb,S2,Eb]=MeanDifNan(RemoveNan(MsB));

    [h,p]=ttest2(RemoveNan(MsA),RemoveNan(MsB));
    
    rg=Range(OmiFreq_A(i),'ms');
    pr=rescale(p,-600, -700);
    tps=Range(OmiFreq_A(i),'ms');
    
    hold on, subplot(4,2,8)
    hold on, plot(tps(1:end-1),SmoothDec((Ma),smo),'k','linewidth',2), 
    hold on, plot(tps(1:end-1),SmoothDec((Ma+Ea),smo),'k') 
    hold on, plot(tps(1:end-1),SmoothDec((Ma-Ea),smo),'k') 
    hold on, plot(tps(1:end-1),SmoothDec((Mb),smo),'r','linewidth',2), 
    hold on, plot(tps(1:end-1),SmoothDec((Mb+Eb),smo),'r') 
    hold on, plot(tps(1:end-1),SmoothDec((Mb-Eb),smo),'r') 
    hold on, plot(rg(p<pval),pr(p<pval),'kx')
    hold on, axis([-100 1200 -800 800])
    title(['Omission effect - last tone B',InfoLFP.structure(i)])
    for a=0:150:600
        hold on, plot(a,min(axis):max(axis),'b','linewidth',1);
    end
end

%%-----------------------------------------------------------------------------------------------------------