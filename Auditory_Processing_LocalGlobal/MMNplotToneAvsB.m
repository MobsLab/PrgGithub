% MMNplotToneAvsB
% plot les PETH pour les Local/Global/Omission des sons A, B, selon les
% Epoch all, Mov, et SWS

res=pwd;
load([res,'/LFPData/InfoLFP']);
lim=5500;
pval=0.05;
smo=1;

load LFPallAvsB
load LFPmovEpoch
load LFPSWSEpoch


for i=1:2:22; 
    a=i-1;
    %---------------------------------------------------------------------------
    %<><><><><><><><><><><><><><> Local Effect <><><><><><><><><><><><><><><
    %---------------------------------------------------------------------------
    tempAMovA=Data(MLstdMovA(i))';
    MsaMovA=[tempAMovA(:,1:size(tempAMovA,2)-1)];
    MsaMovA(MsaMovA>lim)=nan;
    MsaMovA(MsaMovA<-lim)=nan;
    
    TempBMovA=Data(MLdevMovA(i))';
    MsbMovA=[TempBMovA(:,1:size(TempBMovA,2)-1)];
    MsbMovA(MsbMovA>lim)=nan;
    MsbMovA(MsbMovA<-lim)=nan;
    
    [MaMovA,Sa,EaMovA]=MeanDifNan(RemoveNan(MsaMovA));
    [MbMovA,Sb,EbMovA]=MeanDifNan(RemoveNan(MsbMovA));
    [hMov,pMovA]=ttest2(RemoveNan(MsaMovA),RemoveNan(MsbMovA));
    rgMovA=Range(MLstdMovA(i),'ms');
    prMovA=rescale(pMovA,-1000, -1200);
    tpsMovA=Range(MLstdMovA(i),'ms');
    
    tempAMovB=Data(MLstdMovB(i))';
    MsaMovB=[tempAMovB(:,1:size(tempAMovB,2)-1)];
    MsaMovB(MsaMovB>lim)=nan;
    MsaMovB(MsaMovB<-lim)=nan;
    TempBMovB=Data(MLdevMovB(i))';
    MsbMovB=[TempBMovB(:,1:size(TempBMovB,2)-1)];
    MsbMovB(MsbMovB>lim)=nan;
    MsbMovB(MsbMovB<-lim)=nan;
    [MaMovB,Sa,EaMovB]=MeanDifNan(RemoveNan(MsaMovB));
    [MbMovB,Sb,EbMovB]=MeanDifNan(RemoveNan(MsbMovB));
    [hMovB,pMovB]=ttest2(RemoveNan(MsaMovB),RemoveNan(MsbMovB));
    rgMovB=Range(MLstdMovB(i),'ms');
    prMovB=rescale(pMovB,1000, 1200);
    tpsMovB=Range(MLstdMovB(i),'ms');
    
    figure, subplot(3,3,1)
    hold on, plot(tpsMovA(1:end-1),SmoothDec((MaMovA),smo),'k','linewidth',2), 
    hold on, plot(tpsMovA(1:end-1),SmoothDec((MaMovA+EaMovA),smo),'k') 
    hold on, plot(tpsMovA(1:end-1),SmoothDec((MaMovA-EaMovA),smo),'k') 
    hold on, plot(tpsMovA(1:end-1),SmoothDec((MbMovA),smo),'color',[0.3 0.3 0.3],'linewidth',2) 
    hold on, plot(tpsMovA(1:end-1),SmoothDec((MbMovA+EbMovA),smo),'color',[0.3 0.3 0.3]) 
    hold on, plot(tpsMovA(1:end-1),SmoothDec((MbMovA-EbMovA),smo),'color',[0.3 0.3 0.3]) 
    hold on, plot(rgMovA(pMovA<pval),prMovA(pMovA<pval),'kx')
    
    hold on, plot(tpsMovB(1:end-1),SmoothDec((MaMovB),smo),'g','linewidth',2), 
    hold on, plot(tpsMovB(1:end-1),SmoothDec((MaMovB+EaMovB),smo),'g') 
    hold on, plot(tpsMovB(1:end-1),SmoothDec((MaMovB-EaMovB),smo),'g') 
    hold on, plot(tpsMovB(1:end-1),SmoothDec((MbMovB),smo),'color',[0.4 1 0.4],'linewidth',2) 
    hold on, plot(tpsMovB(1:end-1),SmoothDec((MbMovB+EbMovB),smo),'color',[0.4 1 0.4]) 
    hold on, plot(tpsMovB(1:end-1),SmoothDec((MbMovB-EbMovB),smo),'color',[0.4 1 0.4]) 
    hold on, plot(rgMovB(pMovB<pval),prMovB(pMovB<pval),'gx')
    title(['Mov - Local effect - A (black) vs B (green)',num2str(a),InfoLFP.structure(i)])
    hold on, axis([-200 1200 -1200 1200])
    for a=0:150:600
        hold on, plot(a,min(axis):max(axis),'b','linewidth',1);
    end

    %---------------------------------------------------------------------------
    %<><><><><><><><><><><><><><> Global Effect <><><><><><><><><><><><><><><
    %---------------------------------------------------------------------------
    a=i-1;
    tempAMovA=Data(MGstdMovA(i))';
    MsaMovA=[tempAMovA(:,1:size(tempAMovA,2)-1)];
    MsaMovA(MsaMovA>lim)=nan;
    MsaMovA(MsaMovA<-lim)=nan;
    TempBMovA=Data(MGdevMovA(i))';
    MsbMovA=[TempBMovA(:,1:size(TempBMovA,2)-1)];
    MsbMovA(MsbMovA>lim)=nan;
    MsbMovA(MsbMovA<-lim)=nan;
    [MaMovA,Sa,EaMovA]=MeanDifNan(RemoveNan(MsaMovA));
    [MbMovA,Sb,EbMovA]=MeanDifNan(RemoveNan(MsbMovA));
    [hMov,pMovA]=ttest2(RemoveNan(MsaMovA),RemoveNan(MsbMovA));
    rgMovA=Range(MGstdMovA(i),'ms');
    prMovA=rescale(pMovA,-1000, -1200);
    tpsMovA=Range(MGstdMovA(i),'ms');
    
    tempAMovB=Data(MGstdMovB(i))';
    MsaMovB=[tempAMovB(:,1:size(tempAMovB,2)-1)];
    MsaMovB(MsaMovB>lim)=nan;
    MsaMovB(MsaMovB<-lim)=nan;
    TempBMovB=Data(MGdevMovB(i))';
    MsbMovB=[TempBMovB(:,1:size(TempBMovB,2)-1)];
    MsbMovB(MsbMovB>lim)=nan;
    MsbMovB(MsbMovB<-lim)=nan;
    [MaMovB,Sa,EaMovB]=MeanDifNan(RemoveNan(MsaMovB));
    [MbMovB,Sb,EbMovB]=MeanDifNan(RemoveNan(MsbMovB));
    [hMovB,pMovB]=ttest2(RemoveNan(MsaMovB),RemoveNan(MsbMovB));
    rgMovB=Range(MGstdMovB(i),'ms');
    prMovB=rescale(pMovB,1000, 1200);
    tpsMovB=Range(MGstdMovB(i),'ms');
    
    hold on, subplot(3,3,4)
    hold on, plot(tpsMovA(1:end-1),SmoothDec((MaMovA),smo),'k','linewidth',2), 
    hold on, plot(tpsMovA(1:end-1),SmoothDec((MaMovA+EaMovA),smo),'k') 
    hold on, plot(tpsMovA(1:end-1),SmoothDec((MaMovA-EaMovA),smo),'k') 
    hold on, plot(tpsMovA(1:end-1),SmoothDec((MbMovA),smo),'color',[0.3 0.3 0.3],'linewidth',2) 
    hold on, plot(tpsMovA(1:end-1),SmoothDec((MbMovA+EbMovA),smo),'color',[0.3 0.3 0.3]) 
    hold on, plot(tpsMovA(1:end-1),SmoothDec((MbMovA-EbMovA),smo),'color',[0.3 0.3 0.3]) 
    hold on, plot(rgMovA(pMovA<pval),prMovA(pMovA<pval),'kx')
    
    hold on, plot(tpsMovB(1:end-1),SmoothDec((MaMovB),smo),'g','linewidth',2), 
    hold on, plot(tpsMovB(1:end-1),SmoothDec((MaMovB+EaMovB),smo),'g') 
    hold on, plot(tpsMovB(1:end-1),SmoothDec((MaMovB-EaMovB),smo),'g') 
    hold on, plot(tpsMovB(1:end-1),SmoothDec((MbMovB),smo),'color',[0.4 1 0.4],'linewidth',2) 
    hold on, plot(tpsMovB(1:end-1),SmoothDec((MbMovB+EbMovB),smo),'color',[0.4 1 0.4]) 
    hold on, plot(tpsMovB(1:end-1),SmoothDec((MbMovB-EbMovB),smo),'color',[0.4 1 0.4]) 
    hold on, plot(rgMovB(pMovB<pval),prMovB(pMovB<pval),'bx')
    title(['Mov - Global effect - A (black) vs B (green)',num2str(a),InfoLFP.structure(i)])
    hold on, axis([-200 1200 -1200 1200])
    for a=0:150:600
        hold on, plot(a,min(axis):max(axis),'b','linewidth',1);
    end
 
    %---------------------------------------------------------------------------
    %<><><><><><><><><><><><><><><> Omission Effect <><><><><><><><><><><><><><>
    %---------------------------------------------------------------------------
    a=i-1;    
    tempAMovA=Data(OmiFreqMovA(i))';
    MsaMovA=[tempAMovA(:,1:size(tempAMovA,2)-1)];
    MsaMovA(MsaMovA>lim)=nan;
    MsaMovA(MsaMovA<-lim)=nan;
    TempBMovA=Data(OmiRareMovA(i))';
    MsbMovA=[TempBMovA(:,1:size(TempBMovA,2)-1)];
    MsbMovA(MsbMovA>lim)=nan;
    MsbMovA(MsbMovA<-lim)=nan;
    [MaMovA,Sa,EaMovA]=MeanDifNan(RemoveNan(MsaMovA));
    [MbMovA,Sb,EbMovA]=MeanDifNan(RemoveNan(MsbMovA));
    [hMov,pMovA]=ttest2(RemoveNan(MsaMovA),RemoveNan(MsbMovA));
    rgMovA=Range(OmiFreqMovA(i),'ms');
    prAllA=rescale(pMovA,-1000, -1200);
    tpsMovA=Range(OmiFreqMovA(i),'ms');
    
    tempAMovB=Data(OmiFreqMovB(i))';
    MsaMovB=[tempAMovB(:,1:size(tempAMovB,2)-1)];
    MsaMovB(MsaMovB>lim)=nan;
    MsaMovB(MsaMovB<-lim)=nan;
    TempBMovB=Data(OmiRareMovB(i))';
    MsbMovB=[TempBMovB(:,1:size(TempBMovB,2)-1)];
    MsbMovB(MsbMovB>lim)=nan;
    MsbMovB(MsbMovB<-lim)=nan;
    [MaMovB,Sa,EaMovB]=MeanDifNan(RemoveNan(MsaMovB));
    [MbMovB,Sb,EbMovB]=MeanDifNan(RemoveNan(MsbMovB));
    [hMovB,pMovB]=ttest2(RemoveNan(MsaMovB),RemoveNan(MsbMovB));
    rgMovB=Range(OmiFreqMovB(i),'ms');
    prMovB=rescale(pMovB,1000, 1200);
    tpsMovB=Range(OmiFreqMovB(i),'ms');
    
    hold on, subplot (3,3,7)
    hold on, plot(tpsMovA(1:end-1),SmoothDec((MaMovA),smo),'k','linewidth',2), 
    hold on, plot(tpsMovA(1:end-1),SmoothDec((MaMovA+EaMovA),smo),'k') 
    hold on, plot(tpsMovA(1:end-1),SmoothDec((MaMovA-EaMovA),smo),'k') 
    hold on, plot(tpsMovA(1:end-1),SmoothDec((MbMovA),smo),'color',[0.3 0.3 0.3],'linewidth',2) 
    hold on, plot(tpsMovA(1:end-1),SmoothDec((MbMovA+EbMovA),smo),'color',[0.3 0.3 0.3]) 
    hold on, plot(tpsMovA(1:end-1),SmoothDec((MbMovA-EbMovA),smo),'color',[0.3 0.3 0.3]) 
    hold on, plot(rgMovA(pMovA<pval),prMovA(pMovA<pval),'kx')
    
    hold on, plot(tpsMovB(1:end-1),SmoothDec((MaMovB),smo),'g','linewidth',2), 
    hold on, plot(tpsMovB(1:end-1),SmoothDec((MaMovB+EaMovB),smo),'g') 
    hold on, plot(tpsMovB(1:end-1),SmoothDec((MaMovB-EaMovB),smo),'g') 
    hold on, plot(tpsMovB(1:end-1),SmoothDec((MbMovB),smo),'color',[0.4 1 0.4],'linewidth',2) 
    hold on, plot(tpsMovB(1:end-1),SmoothDec((MbMovB+EbMovB),smo),'color',[0.4 1 0.4]) 
    hold on, plot(tpsMovB(1:end-1),SmoothDec((MbMovB-EbMovB),smo),'color',[0.4 1 0.4]) 
    hold on, plot(rgMovB(pMovB<pval),prMovB(pMovB<pval),'bx')
    title(['Mov - Omission effect - A (black) vs B (green)',num2str(a),InfoLFP.structure(i)])
    hold on, axis([-200 1200 -1200 1200])
    for a=0:150:600
        hold on, plot(a,min(axis):max(axis),'b','linewidth',1);
    end

%------------------------------------------------------------------------------------
%<><><><><><><><><><><><><><> SWS comparison A vs B <><><><><><><><><><><><><><><
%------------------------------------------------------------------------------------

    %---------------------------------------------------------------------------
    %<><><><><><><><><><><><><><> Local Effect <><><><><><><><><><><><><><><
    %---------------------------------------------------------------------------
    a=i-1;
    tempASWSA=Data(MLstdSWSA(i))';
    MsaSWSA=[tempASWSA(:,1:size(tempASWSA,2)-1)];
    MsaSWSA(MsaSWSA>lim)=nan;
    MsaSWSA(MsaSWSA<-lim)=nan;
    tempBSWSA=Data(MLdevSWSA(i))';
    MsbSWSA=[tempBSWSA(:,1:size(tempBSWSA,2)-1)];
    MsbSWSA(MsbSWSA>lim)=nan;
    MsbSWSA(MsbSWSA<-lim)=nan;
    [MaSWSA,Sa,EaSWSA]=MeanDifNan(RemoveNan(MsaSWSA));
    [MbSWSA,Sb,EbSWSA]=MeanDifNan(RemoveNan(MsbSWSA));
    [hMov,pSWSA]=ttest2(RemoveNan(MsaSWSA),RemoveNan(MsbSWSA));
    rgSWSA=Range(MLstdSWSA(i),'ms');
    prSWSA=rescale(pSWSA,-1000, -1200);
    tpsSWSA=Range(MLstdSWSA(i),'ms');
    
    tempASWSB=Data(MLstdSWSB(i))';
    MsaSWSB=[tempASWSB(:,1:size(tempASWSB,2)-1)];
    MsaSWSB(MsaSWSB>lim)=nan;
    MsaSWSB(MsaSWSB<-lim)=nan;
    tempBSWSB=Data(MLdevSWSB(i))';
    MsbSWSB=[tempBSWSB(:,1:size(tempBSWSB,2)-1)];
    MsbSWSB(MsbSWSB>lim)=nan;
    MsbSWSB(MsbSWSB<-lim)=nan;
    [MaSWSB,Sa,EaSWSB]=MeanDifNan(RemoveNan(MsaSWSB));
    [MbSWSB,Sb,EbSWSB]=MeanDifNan(RemoveNan(MsbSWSB));
    [hMovB,pSWSB]=ttest2(RemoveNan(MsaSWSB),RemoveNan(MsbSWSB));
    rgSWSB=Range(MLstdSWSB(i),'ms');
    prSWSB=rescale(pSWSB,1000, 1200);
    tpsSWSB=Range(MLstdSWSB(i),'ms');
    
    hold on, subplot(3,3,2)
    hold on, plot(tpsSWSA(1:end-1),SmoothDec((MaSWSA),smo),'k','linewidth',2), 
    hold on, plot(tpsSWSA(1:end-1),SmoothDec((MaSWSA+EaSWSA),smo),'k') 
    hold on, plot(tpsSWSA(1:end-1),SmoothDec((MaSWSA-EaSWSA),smo),'k') 
    hold on, plot(tpsSWSA(1:end-1),SmoothDec((MbSWSA),smo),'color',[0.3 0.3 0.3],'linewidth',2) 
    hold on, plot(tpsSWSA(1:end-1),SmoothDec((MbSWSA+EbSWSA),smo),'color',[0.3 0.3 0.3]) 
    hold on, plot(tpsSWSA(1:end-1),SmoothDec((MbSWSA-EbSWSA),smo),'color',[0.3 0.3 0.3]) 
    hold on, plot(rgSWSA(pSWSA<pval),prSWSA(pSWSA<pval),'kx')
    
    hold on, plot(tpsSWSB(1:end-1),SmoothDec((MaSWSB),smo),'b','linewidth',2), 
    hold on, plot(tpsSWSB(1:end-1),SmoothDec((MaSWSB+EaSWSB),smo),'b') 
    hold on, plot(tpsSWSB(1:end-1),SmoothDec((MaSWSB-EaSWSB),smo),'b') 
    hold on, plot(tpsSWSB(1:end-1),SmoothDec((MbSWSB),smo),'color',[0 0.5 1],'linewidth',2) 
    hold on, plot(tpsSWSB(1:end-1),SmoothDec((MbSWSB+EbSWSB),smo),'color',[0 0.5 1]) 
    hold on, plot(tpsSWSB(1:end-1),SmoothDec((MbSWSB-EbSWSB),smo),'color',[0 0.5 1]) 
    hold on, plot(rgSWSB(pSWSB<pval),prSWSB(pSWSB<pval),'bx')
    title(['SWS - Local effect - A (black) vs B (blue)',num2str(a),InfoLFP.structure(i)])
    hold on, axis([-200 1200 -1200 1200])
    for a=0:150:600
        hold on, plot(a,min(axis):max(axis),'b','linewidth',1);
    end

    %---------------------------------------------------------------------------
    %<><><><><><><><><><><><><><> Global Effect <><><><><><><><><><><><><><><
    %---------------------------------------------------------------------------
    a=i-1;
    tempASWSA=Data(MGstdSWSA(i))';
    MsaSWSA=[tempASWSA(:,1:size(tempASWSA,2)-1)];
    MsaSWSA(MsaSWSA>lim)=nan;
    MsaSWSA(MsaSWSA<-lim)=nan;
    tempBSWSA=Data(MGdevSWSA(i))';
    MsbSWSA=[tempBSWSA(:,1:size(tempBSWSA,2)-1)];
    MsbSWSA(MsbSWSA>lim)=nan;
    MsbSWSA(MsbSWSA<-lim)=nan;
    [MaSWSA,Sa,EaSWSA]=MeanDifNan(RemoveNan(MsaSWSA));
    [MbSWSA,Sb,EbSWSA]=MeanDifNan(RemoveNan(MsbSWSA));
    [hMov,pSWSA]=ttest2(RemoveNan(MsaSWSA),RemoveNan(MsbSWSA));
    rgSWSA=Range(MGstdSWSA(i),'ms');
    prSWSA=rescale(pSWSA,-1000, -1200);
    tpsSWSA=Range(MGstdSWSA(i),'ms');
    
    tempASWSB=Data(MGstdSWSB(i))';
    MsaSWSB=[tempASWSB(:,1:size(tempASWSB,2)-1)];
    MsaSWSB(MsaSWSB>lim)=nan;
    MsaSWSB(MsaSWSB<-lim)=nan;
    tempBSWSB=Data(MGdevSWSB(i))';
    MsbSWSB=[tempBSWSB(:,1:size(tempBSWSB,2)-1)];
    MsbSWSB(MsbSWSB>lim)=nan;
    MsbSWSB(MsbSWSB<-lim)=nan;
    [MaSWSB,Sa,EaSWSB]=MeanDifNan(RemoveNan(MsaSWSB));
    [MbSWSB,Sb,EbSWSB]=MeanDifNan(RemoveNan(MsbSWSB));
    [hMovB,pSWSB]=ttest2(RemoveNan(MsaSWSB),RemoveNan(MsbSWSB));
    rgSWSB=Range(MGstdSWSB(i),'ms');
    prAllB=rescale(pSWSB,1000, 1200);
    tpsSWSB=Range(MGstdSWSB(i),'ms');
    
    hold on, subplot(3,3,5)
    hold on, plot(tpsSWSA(1:end-1),SmoothDec((MaSWSA),smo),'k','linewidth',2), 
    hold on, plot(tpsSWSA(1:end-1),SmoothDec((MaSWSA+EaSWSA),smo),'k') 
    hold on, plot(tpsSWSA(1:end-1),SmoothDec((MaSWSA-EaSWSA),smo),'k') 
    hold on, plot(tpsSWSA(1:end-1),SmoothDec((MbSWSA),smo),'color',[0.3 0.3 0.3],'linewidth',2) 
    hold on, plot(tpsSWSA(1:end-1),SmoothDec((MbSWSA+EbSWSA),smo),'color',[0.3 0.3 0.3]) 
    hold on, plot(tpsSWSA(1:end-1),SmoothDec((MbSWSA-EbSWSA),smo),'color',[0.3 0.3 0.3]) 
    hold on, plot(rgSWSA(pSWSA<pval),prSWSA(pSWSA<pval),'kx')
    
    hold on, plot(tpsSWSB(1:end-1),SmoothDec((MaSWSB),smo),'b','linewidth',2), 
    hold on, plot(tpsSWSB(1:end-1),SmoothDec((MaSWSB+EaSWSB),smo),'b') 
    hold on, plot(tpsSWSB(1:end-1),SmoothDec((MaSWSB-EaSWSB),smo),'b') 
    hold on, plot(tpsSWSB(1:end-1),SmoothDec((MbSWSB),smo),'color',[0 0.5 1],'linewidth',2) 
    hold on, plot(tpsSWSB(1:end-1),SmoothDec((MbSWSB+EbSWSB),smo),'color',[0 0.5 1]) 
    hold on, plot(tpsSWSB(1:end-1),SmoothDec((MbSWSB-EbSWSB),smo),'color',[0 0.5 1]) 
    hold on, plot(rgSWSB(pSWSB<pval),prSWSB(pSWSB<pval),'bx')
    title(['SWS - Global effect - A (black) vs B (blue)',num2str(a),InfoLFP.structure(i)])
    hold on, axis([-200 1200 -1200 1200])
    for a=0:150:600
        hold on, plot(a,min(axis):max(axis),'b','linewidth',1);
    end
 
    %---------------------------------------------------------------------------
    %<><><><><><><><><><><><><><><> Omission Effect <><><><><><><><><><><><><><>
    %---------------------------------------------------------------------------
    a=i-1;
    tempASWSA=Data(OmiFreqSWSA(i))';
    MsaSWSA=[tempASWSA(:,1:size(tempASWSA,2)-1)];
    MsaSWSA(MsaSWSA>lim)=nan;
    MsaSWSA(MsaSWSA<-lim)=nan;
    tempBSWSA=Data(OmiRareSWSA(i))';
    MsbSWSA=[tempBSWSA(:,1:size(tempBSWSA,2)-1)];
    MsbSWSA(MsbSWSA>lim)=nan;
    MsbSWSA(MsbSWSA<-lim)=nan;
    [MaSWSA,Sa,EaSWSA]=MeanDifNan(RemoveNan(MsaSWSA));
    [MbSWSA,Sb,EbSWSA]=MeanDifNan(RemoveNan(MsbSWSA));
    [hMov,pSWSA]=ttest2(RemoveNan(MsaSWSA),RemoveNan(MsbSWSA));
    rgSWSA=Range(OmiFreqSWSA(i),'ms');
    prSWSA=rescale(pSWSA,-1000, -1200);
    tpsSWSA=Range(OmiFreqSWSA(i),'ms');
    
    tempASWSB=Data(OmiFreqSWSB(i))';
    MsaSWSB=[tempASWSB(:,1:size(tempASWSB,2)-1)];
    MsaSWSB(MsaSWSB>lim)=nan;
    MsaSWSB(MsaSWSB<-lim)=nan;
    tempBSWSB=Data(OmiRareSWSB(i))';
    MsbSWSB=[tempBSWSB(:,1:size(tempBSWSB,2)-1)];
    MsbSWSB(MsbSWSB>lim)=nan;
    MsbSWSB(MsbSWSB<-lim)=nan;
    [MaSWSB,Sa,EaSWSB]=MeanDifNan(RemoveNan(MsaSWSB));
    [MbSWSB,Sb,EbSWSB]=MeanDifNan(RemoveNan(MsbSWSB));
    [hMovB,pSWSB]=ttest2(RemoveNan(MsaSWSB),RemoveNan(MsbSWSB));
    rgSWSB=Range(OmiFreqSWSB(i),'ms');
    prSWSB=rescale(pSWSB,1000, 1200);
    tpsSWSB=Range(OmiFreqSWSB(i),'ms');
    
    hold on, subplot (3,3,8)
    hold on, plot(tpsSWSA(1:end-1),SmoothDec((MaSWSA),smo),'k','linewidth',2), 
    hold on, plot(tpsSWSA(1:end-1),SmoothDec((MaSWSA+EaSWSA),smo),'k') 
    hold on, plot(tpsSWSA(1:end-1),SmoothDec((MaSWSA-EaSWSA),smo),'k') 
    hold on, plot(tpsSWSA(1:end-1),SmoothDec((MbSWSA),smo),'color',[0.3 0.3 0.3],'linewidth',2) 
    hold on, plot(tpsSWSA(1:end-1),SmoothDec((MbSWSA+EbSWSA),smo),'color',[0.3 0.3 0.3]) 
    hold on, plot(tpsSWSA(1:end-1),SmoothDec((MbSWSA-EbSWSA),smo),'color',[0.3 0.3 0.3]) 
    hold on, plot(rgSWSA(pSWSA<pval),prSWSA(pSWSA<pval),'kx')
    
    hold on, plot(tpsSWSB(1:end-1),SmoothDec((MaSWSB),smo),'b','linewidth',2), 
    hold on, plot(tpsSWSB(1:end-1),SmoothDec((MaSWSB+EaSWSB),smo),'b') 
    hold on, plot(tpsSWSB(1:end-1),SmoothDec((MaSWSB-EaSWSB),smo),'b') 
    hold on, plot(tpsSWSB(1:end-1),SmoothDec((MbSWSB),smo),'color',[0 0.5 1],'linewidth',2) 
    hold on, plot(tpsSWSB(1:end-1),SmoothDec((MbSWSB+EbSWSB),smo),'color',[0 0.5 1]) 
    hold on, plot(tpsSWSB(1:end-1),SmoothDec((MbSWSB-EbSWSB),smo),'color',[0 0.5 1]) 
    hold on, plot(rgSWSB(pSWSB<pval),prSWSB(pSWSB<pval),'bx')
    title(['SWS - Omission effect - A (black) vs B (blue)',num2str(a),InfoLFP.structure(i)])
    hold on, axis([-200 1200 -1200 1200])
    for a=0:150:600
        hold on, plot(a,min(axis):max(axis),'b','linewidth',1);
    end
    
%-----------------------------------------------------------------------------------
%<><><><><><><><><><><><><><> All comparison A vs B <><><><><><><><><><><><><><><><>
%-----------------------------------------------------------------------------------
    
    %--------------------------------------------------------------------------
    %<><><><><><><><><><><><><><> Local Effect <><><><><><><><><><><><><><><><>
    %--------------------------------------------------------------------------
    a=i-1;
    tempAallA=Data(MLstdA(i))';
    MsaallA=[tempAallA(:,1:size(tempAallA,2)-1)];
    MsaallA(MsaallA>lim)=nan;
    MsaallA(MsaallA<-lim)=nan;
    tempBallA=Data(MLdevA(i))';
    MsballA=[tempBallA(:,1:size(tempBallA,2)-1)];
    MsballA(MsballA>lim)=nan;
    MsballA(MsballA<-lim)=nan;
    [MaallA,Sa,EaAllA]=MeanDifNan(RemoveNan(MsaallA));
    [MballA,Sb,EbAllA]=MeanDifNan(RemoveNan(MsballA));
    [hMov,pAllA]=ttest2(RemoveNan(MsaallA),RemoveNan(MsballA));
    rgAllA=Range(MLdevA(i),'ms');
    prAllA=rescale(pAllA,-1000, -1200);
    tpsallA=Range(MLstdA(i),'ms');
    
    tempAallB=Data(MLstdB(i))';
    MsaallB=[tempAallB(:,1:size(tempAallB,2)-1)];
    MsaallB(MsaallB>lim)=nan;
    MsaallB(MsaallB<-lim)=nan;
    tempBallB=Data(MLdevB(i))';
    MsballB=[tempBallB(:,1:size(tempBallB,2)-1)];
    MsballB(MsballB>lim)=nan;
    MsballB(MsballB<-lim)=nan;
    [MaallB,Sa,EaAllB]=MeanDifNan(RemoveNan(MsaallB));
    [MballB,Sb,EbAllB]=MeanDifNan(RemoveNan(MsballB));
    [hMovB,pAllB]=ttest2(RemoveNan(MsaallB),RemoveNan(MsballB));
    rgAllB=Range(MLdevB(i),'ms');
    prAllB=rescale(pAllB,1000, 1200);
    tpsallB=Range(MLstdB(i),'ms');
    
    
    hold on, subplot(3,3,3)
    hold on, plot(tpsallA(1:end-1),SmoothDec((MaallA),smo),'k','linewidth',2), 
    hold on, plot(tpsallA(1:end-1),SmoothDec((MaallA+EaAllA),smo),'k') 
    hold on, plot(tpsallA(1:end-1),SmoothDec((MaallA-EaAllA),smo),'k') 
    hold on, plot(tpsallA(1:end-1),SmoothDec((MballA),smo),'color',[0.3 0.3 0.3],'linewidth',2) 
    hold on, plot(tpsallA(1:end-1),SmoothDec((MballA+EbAllA),smo),'color',[0.3 0.3 0.3]) 
    hold on, plot(tpsallA(1:end-1),SmoothDec((MballA-EbAllA),smo),'color',[0.3 0.3 0.3]) 
    hold on, plot(rgAllA(pAllA<pval),prAllA(pAllA<pval),'kx')
    
    hold on, plot(tpsallB(1:end-1),SmoothDec((MaallB),smo),'r','linewidth',2), 
    hold on, plot(tpsallB(1:end-1),SmoothDec((MaallB+EaAllB),smo),'r') 
    hold on, plot(tpsallB(1:end-1),SmoothDec((MaallB-EaAllB),smo),'r') 
    hold on, plot(tpsallB(1:end-1),SmoothDec((MballB),smo),'color',[1 0.2 0.6],'linewidth',2) 
    hold on, plot(tpsallB(1:end-1),SmoothDec((MballB+EbAllB),smo),'color',[1 0.2 0.6]) 
    hold on, plot(tpsallB(1:end-1),SmoothDec((MballB-EbAllB),smo),'color',[1 0.2 0.6]) 
    hold on, plot(rgAllB(pAllB<pval),prAllB(pAllB<pval),'rx')
    title(['local effect - A (black) vs B (red)',num2str(a),InfoLFP.structure(i)])
    hold on, axis([-200 1200 -1200 1200])
    for a=0:150:600
        hold on, plot(a,min(axis):max(axis),'b','linewidth',1);
    end

    %---------------------------------------------------------------------------
    %<><><><><><><><><><><><><><> Global Effect <><><><><><><><><><><><><><><><>
    %---------------------------------------------------------------------------
    a=i-1;
    tempAallA=Data(MGstdA(i))';
    MsaallA=[tempAallA(:,1:size(tempAallA,2)-1)];
    MsaallA(MsaallA>lim)=nan;
    MsaallA(MsaallA<-lim)=nan;
    tempBallA=Data(MGdevA(i))';
    MsballA=[tempBallA(:,1:size(tempBallA,2)-1)];
    MsballA(MsballA>lim)=nan;
    MsballA(MsballA<-lim)=nan;
    [MaallA,Sa,EaAllA]=MeanDifNan(RemoveNan(MsaallA));
    [MballA,Sb,EbAllA]=MeanDifNan(RemoveNan(MsballA));
    [hMov,pAllA]=ttest2(RemoveNan(MsaallA),RemoveNan(MsballA));
    rgAllA=Range(MGdevA(i),'ms');
    prAllA=rescale(pAllA,-1000, -1200);
    tpsallA=Range(MGstdA(i),'ms');
    
    tempAallB=Data(MGstdB(i))';
    MsaallB=[tempAallB(:,1:size(tempAallB,2)-1)];
    MsaallB(MsaallB>lim)=nan;
    MsaallB(MsaallB<-lim)=nan;
    tempBallB=Data(MGdevB(i))';
    MsballB=[tempBallB(:,1:size(tempBallB,2)-1)];
    MsballB(MsballB>lim)=nan;
    MsballB(MsballB<-lim)=nan;
    [MaallB,Sa,EaAllB]=MeanDifNan(RemoveNan(MsaallB));
    [MballB,Sb,EbAllB]=MeanDifNan(RemoveNan(MsballB));
    [hMovB,pAllB]=ttest2(RemoveNan(MsaallB),RemoveNan(MsballB));
    rgAllB=Range(MGdevB(i),'ms');
    prAllB=rescale(pAllB,1000, 1200);
    tpsallB=Range(MGstdB(i),'ms');
    
    hold on, subplot(3,3,6)
    hold on, plot(tpsallA(1:end-1),SmoothDec((MaallA),smo),'k','linewidth',2), 
    hold on, plot(tpsallA(1:end-1),SmoothDec((MaallA+EaAllA),smo),'k') 
    hold on, plot(tpsallA(1:end-1),SmoothDec((MaallA-EaAllA),smo),'k') 
    hold on, plot(tpsallA(1:end-1),SmoothDec((MballA),smo),'color',[0.3 0.3 0.3],'linewidth',2) 
    hold on, plot(tpsallA(1:end-1),SmoothDec((MballA+EbAllA),smo),'color',[0.3 0.3 0.3]) 
    hold on, plot(tpsallA(1:end-1),SmoothDec((MballA-EbAllA),smo),'color',[0.3 0.3 0.3]) 
    hold on, plot(rgAllA(pAllA<pval),prAllA(pAllA<pval),'kx')
    
    hold on, plot(tpsallB(1:end-1),SmoothDec((MaallB),smo),'r','linewidth',2), 
    hold on, plot(tpsallB(1:end-1),SmoothDec((MaallB+EaAllB),smo),'r') 
    hold on, plot(tpsallB(1:end-1),SmoothDec((MaallB-EaAllB),smo),'r') 
    hold on, plot(tpsallB(1:end-1),SmoothDec((MballB),smo),'color',[1 0.2 0.6],'linewidth',2) 
    hold on, plot(tpsallB(1:end-1),SmoothDec((MballB+EbAllB),smo),'color',[1 0.2 0.6]) 
    hold on, plot(tpsallB(1:end-1),SmoothDec((MballB-EbAllB),smo),'color',[1 0.2 0.6]) 
    hold on, plot(rgAllB(pAllB<pval),prAllB(pAllB<pval),'rx')
    title(['Global effect - A (black) vs B (red)',num2str(a),InfoLFP.structure(i)])
    hold on, axis([-200 1200 -1200 1200])
    for a=0:150:600
        hold on, plot(a,min(axis):max(axis),'b','linewidth',1);
    end
 
    %---------------------------------------------------------------------------
    %<><><><><><><><><><><><><><><> Omission Effect <><><><><><><><><><><><><><>
    %---------------------------------------------------------------------------
    a=i-1;
    tempAallA=Data(OmiFreqA(i))';
    MsaallA=[tempAallA(:,1:size(tempAallA,2)-1)];
    MsaallA(MsaallA>lim)=nan;
    MsaallA(MsaallA<-lim)=nan;
    tempBallA=Data(OmiRareA(i))';
    MsballA=[tempBallA(:,1:size(tempBallA,2)-1)];
    MsballA(MsballA>lim)=nan;
    MsballA(MsballA<-lim)=nan;
    [MaallA,Sa,EaAllA]=MeanDifNan(RemoveNan(MsaallA));
    [MballA,Sb,EbAllA]=MeanDifNan(RemoveNan(MsballA));
    [hMov,pAllA]=ttest2(RemoveNan(MsaallA),RemoveNan(MsballA));
    rgAllA=Range(OmiRareA(i),'ms');
    prAllA=rescale(pAllA,-1000, -1200);
    tpsallA=Range(OmiFreqA(i),'ms');
    
    tempAallB=Data(OmiFreqB(i))';
    MsaallB=[tempAallB(:,1:size(tempAallB,2)-1)];
    MsaallB(MsaallB>lim)=nan;
    MsaallB(MsaallB<-lim)=nan;
    tempBallB=Data(OmiRareB(i))';
    MsballB=[tempBallB(:,1:size(tempBallB,2)-1)];
    MsballB(MsballB>lim)=nan;
    MsballB(MsballB<-lim)=nan;
    [MaallB,Sa,EaAllB]=MeanDifNan(RemoveNan(MsaallB));
    [MballB,Sb,EbAllB]=MeanDifNan(RemoveNan(MsballB));
    [hMovB,pAllB]=ttest2(RemoveNan(MsaallB),RemoveNan(MsballB));
    rgAllB=Range(OmiRareB(i),'ms');
    prAllB=rescale(pAllB,1000, 1200);
    tpsallB=Range(OmiFreqB(i),'ms');
    
    hold on, subplot (3,3,9)
    hold on, plot(tpsallA(1:end-1),SmoothDec((MaallA),smo),'k','linewidth',2), 
    hold on, plot(tpsallA(1:end-1),SmoothDec((MaallA+EaAllA),smo),'k') 
    hold on, plot(tpsallA(1:end-1),SmoothDec((MaallA-EaAllA),smo),'k') 
    hold on, plot(tpsallA(1:end-1),SmoothDec((MballA),smo),'color',[0.3 0.3 0.3],'linewidth',2) 
    hold on, plot(tpsallA(1:end-1),SmoothDec((MballA+EbAllA),smo),'color',[0.3 0.3 0.3]) 
    hold on, plot(tpsallA(1:end-1),SmoothDec((MballA-EbAllA),smo),'color',[0.3 0.3 0.3]) 
    hold on, plot(rgAllA(pAllA<pval),prAllA(pAllA<pval),'kx')
    
    hold on, plot(tpsallB(1:end-1),SmoothDec((MaallB),smo),'r','linewidth',2), 
    hold on, plot(tpsallB(1:end-1),SmoothDec((MaallB+EaAllB),smo),'r') 
    hold on, plot(tpsallB(1:end-1),SmoothDec((MaallB-EaAllB),smo),'r') 
    hold on, plot(tpsallB(1:end-1),SmoothDec((MballB),smo),'color',[1 0.2 0.6],'linewidth',2) 
    hold on, plot(tpsallB(1:end-1),SmoothDec((MballB+EbAllB),smo),'color',[1 0.2 0.6]) 
    hold on, plot(tpsallB(1:end-1),SmoothDec((MballB-EbAllB),smo),'color',[1 0.2 0.6]) 
    hold on, plot(rgAllB(pAllB<pval),prAllB(pAllB<pval),'rx')
    title(['Omission effect - A (black) vs B (red)',num2str(a),InfoLFP.structure(i)])
    hold on, axis([-200 1200 -1200 1200])
    for a=0:150:600
        hold on, plot(a,min(axis):max(axis),'b','linewidth',1);
    end
end