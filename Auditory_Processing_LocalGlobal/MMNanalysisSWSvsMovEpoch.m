load LocalGlobalTotalAssignment
load StateEpoch
res=pwd;
smo=0;
load([res,'/LFPData/InfoLFP']);
J1=-2000;
J2=+13000;

try load LFPmovEpoch
catch
    for num=0:28;
        clear LFP
        clear i;
        load([res,'/LFPData/LFP',num2str(num)]);
        LFP2=ResampleTSD(LFP,500);
        i=num+1;
        
        Epoch=MovEpoch;
        figure, [fh, rasterAx, histAx, MLstdMov(i)]=ImagePETH(LFP2, Restrict(ts(sort([LocalStdGlobStdA;LocalStdGlobStdB])),Epoch), J1, J2,'BinSize',800);close
        figure, [fh, rasterAx, histAx, MLdevMov(i)]=ImagePETH(LFP2, Restrict(ts(sort([LocalDvtGlobStdA;LocalDvtGlobStdB])),Epoch), J1, J2,'BinSize',800);close
        figure, [fh, rasterAx, histAx, MGdevMov(i)]=ImagePETH(LFP2, Restrict(ts(sort([LocalStdGlobDvtA;LocalStdGlobDvtB])),Epoch), J1, J2,'BinSize',800);close
        figure, [fh, rasterAx, histAx, OmiFreqMov(i)] = ImagePETH(LFP2, Restrict(ts(sort([OmiAAAA;OmiBBBB])),Epoch), J1, J2,'BinSize',800);close
        figure, [fh, rasterAx, histAx, OmiRareMov(i)] = ImagePETH(LFP2, Restrict(ts(sort([OmissionRareA;OmissionRareB])),Epoch), J1, J2,'BinSize',800);close
        MGstdMov(i)=MLstdMov(i);
    end
    save LFPmovEpoch MLstdMov MLdevMov MGstdMov MGdevMov OmiFreqMov OmiRareMov
end

try load LFPSWSEpoch
catch
    for num=0:28;
        clear LFP
        clear i;
        load([res,'/LFPData/LFP',num2str(num)]);
        LFP2=ResampleTSD(LFP,500);
        i=num+1;
        
        Epoch=SWSEpoch;
        figure, [fh, rasterAx, histAx, MLstdSWS(i)]=ImagePETH(LFP2, Restrict(ts(sort([LocalStdGlobStdA;LocalStdGlobStdB])),Epoch), J1, J2,'BinSize',800);close
        figure, [fh, rasterAx, histAx, MLdevSWS(i)]=ImagePETH(LFP2, Restrict(ts(sort([LocalDvtGlobStdA;LocalDvtGlobStdB])),Epoch), J1, J2,'BinSize',800);close
        figure, [fh, rasterAx, histAx, MGdevSWS(i)]=ImagePETH(LFP2, Restrict(ts(sort([LocalStdGlobDvtA;LocalStdGlobDvtB])),Epoch), J1, J2,'BinSize',800);close
        figure, [fh, rasterAx, histAx, OmiFreqSWS(i)] = ImagePETH(LFP2, Restrict(ts(sort([OmiAAAA;OmiBBBB])),Epoch), J1, J2,'BinSize',800);close
        figure, [fh, rasterAx, histAx, OmiRareSWS(i)] = ImagePETH(LFP2, Restrict(ts(sort([OmissionRareA;OmissionRareB])),Epoch), J1, J2,'BinSize',800);close
        MGstdSWS(i)=MLstdSWS(i);
    end
    save LFPSWSEpoch MLstdSWS MLdevSWS MGstdSWS MGdevSWS OmiFreqSWS OmiRareSWS
end


for i=1:27; 
    a=i-1;
    %---------------------------------------------------------------------------
    %<><><><><><><><><><><><><><> Local Effect <><><><><><><><><><><><><><><
    %---------------------------------------------------------------------------
    lim=5500;
    pval=0.05;

    tempASWS=Data(MLstdSWS(i))';
    MsaSWS=[tempASWS(:,1:size(tempASWS,2)-1)];
    MsaSWS(MsaSWS>lim)=nan;
    MsaSWS(MsaSWS<-lim)=nan;
    TempBSWS=Data(MLdevSWS(i))';
    MsbSWS=[TempBSWS(:,1:size(TempBSWS,2)-1)];
    MsbSWS(MsbSWS>lim)=nan;
    MsbSWS(MsbSWS<-lim)=nan;
    [MaSWS,Sa,EaSWS]=MeanDifNan(RemoveNan(MsaSWS));
    [MbSWS,Sb,EbSWS]=MeanDifNan(RemoveNan(MsbSWS));
    [hSWS,pSWS]=ttest2(RemoveNan(MsaSWS),RemoveNan(MsbSWS));
    rgSWS=Range(MLdevSWS(i),'ms');
    pr=rescale(pSWS,1000, 1100);
    tpsSWS=Range(MLstdSWS(i),'ms');
    
    tempAMov=Data(MLstdMov(i))';
    MsaMov=[tempAMov(:,1:size(tempAMov,2)-1)];
    MsaMov(MsaMov>lim)=nan;
    MsaMov(MsaMov<-lim)=nan;
    TempBMov=Data(MLdevMov(i))';
    MsbMov=[TempBMov(:,1:size(TempBMov,2)-1)];
    MsbMov(MsbMov>lim)=nan;
    MsbMov(MsbMov<-lim)=nan;
    [MaMov,Sa,EaMov]=MeanDifNan(RemoveNan(MsaMov));
    [MbMov,Sb,EbMov]=MeanDifNan(RemoveNan(MsbMov));
    [hMov,pMov]=ttest2(RemoveNan(MsaMov),RemoveNan(MsbMov));
    rgMov=Range(MLdevMov(i),'ms');
    prMov=rescale(pMov,1100, 1200);
    tpsMov=Range(MLstdMov(i),'ms');
    
    figure, subplot(3,1,1)
    hold on, plot(tpsSWS(1:end-1),SmoothDec((MaSWS),smo),'r','linewidth',2), 
    hold on, plot(tpsSWS(1:end-1),SmoothDec((MaSWS+EaSWS),smo),'r') 
    hold on, plot(tpsSWS(1:end-1),SmoothDec((MaSWS-EaSWS),smo),'r') 
    hold on, plot(tpsSWS(1:end-1),SmoothDec((MbSWS),smo),'color',[1 0.2 0.6],'linewidth',2) 
    hold on, plot(tpsSWS(1:end-1),SmoothDec((MbSWS+EbSWS),smo),'color',[1 0.2 0.6]) 
    hold on, plot(tpsSWS(1:end-1),SmoothDec((MbSWS-EbSWS),smo),'color',[1 0.2 0.6]) 
    hold on, plot(rgSWS(pSWS<pval),pr(pSWS<pval),'rx')
    hold on, plot(tpsMov(1:end-1),SmoothDec((MaMov),smo),'b','linewidth',2), 
    hold on, plot(tpsMov(1:end-1),SmoothDec((MaMov+EaMov),smo),'b') 
    hold on, plot(tpsMov(1:end-1),SmoothDec((MaMov-EaMov),smo),'b') 
    hold on, plot(tpsMov(1:end-1),SmoothDec((MbMov),smo),'color',[0 0.5 1],'linewidth',2) 
    hold on, plot(tpsMov(1:end-1),SmoothDec((MbMov+EbMov),smo),'color',[0 0.5 1]) 
    hold on, plot(tpsMov(1:end-1),SmoothDec((MbMov-EbMov),smo),'color',[0 0.5 1]) 
    hold on, plot(rgMov(pMov<pval),prMov(pMov<pval),'bx')
    title(['local effect - Wake vs SWS, n°',num2str(a),InfoLFP.structure(i)])
    hold on, axis([-200 1300 -1200 1200])
    for a=0:150:600
        hold on, plot(a,min(axis):max(axis),'b','linewidth',1);
    end

    %---------------------------------------------------------------------------
    %<><><><><><><><><><><><><><> Global Effect <><><><><><><><><><><><><><><
    %---------------------------------------------------------------------------
    TempASWS=Data(MGstdSWS(i))';
    MsaSWS=[TempASWS(:,1:size(TempASWS,2)-1)];
    MsaSWS(MsaSWS>lim)=nan;
    MsaSWS(MsaSWS<-lim)=nan;
    TempBSWS=Data(MGdevSWS(i))';
    MsbSWS=[TempBSWS(:,1:size(TempBSWS,2)-1)];
    MsbSWS(MsbSWS>lim)=nan;
    MsbSWS(MsbSWS<-lim)=nan;
    [MaSWS,Sa,EaSWS]=MeanDifNan(RemoveNan(MsaSWS));
    [MbSWS,Sb,EbSWS]=MeanDifNan(RemoveNan(MsbSWS));
    [hSWS,pSWS]=ttest2(RemoveNan(MsaSWS),RemoveNan(MsbSWS));
    rgSWS=Range(MGdevSWS(i),'ms');
    pr=rescale(pSWS,1000, 1100);
    tpsSWS=Range(MGstdSWS(i),'ms');

    TempAMov=Data(MGstdMov(i))';
    MsaMov=[tempAMov(:,1:size(tempAMov,2)-1)];
    MsaMov(MsaMov>lim)=nan;
    MsaMov(MsaMov<-lim)=nan;
    TempBMov=Data(MGdevMov(i))';
    MsbMov=[TempBMov(:,1:size(TempBMov,2)-1)];
    MsbMov(MsbMov>lim)=nan;
    MsbMov(MsbMov<-lim)=nan;
    [MaMov,Sa,EaMov]=MeanDifNan(RemoveNan(MsaMov));
    [MbMov,Sb,EbMov]=MeanDifNan(RemoveNan(MsbMov));
    [hMov,pMov]=ttest2(RemoveNan(MsaMov),RemoveNan(MsbMov));
    rgMov=Range(MGdevMov(i),'ms');
    prMov=rescale(pMov,1100, 1200);
    tpsMov=Range(MGstdMov(i),'ms');
    
    hold on, subplot(3,1,2)
    hold on, plot(tpsSWS(1:end-1),SmoothDec((MaSWS),smo),'r','linewidth',2), 
    hold on, plot(tpsSWS(1:end-1),SmoothDec((MaSWS+EaSWS),smo),'r') 
    hold on, plot(tpsSWS(1:end-1),SmoothDec((MaSWS-EaSWS),smo),'r') 
    hold on, plot(tpsSWS(1:end-1),SmoothDec((MbSWS),smo),'color',[1 0.2 0.6],'linewidth',2) 
    hold on, plot(tpsSWS(1:end-1),SmoothDec((MbSWS+EbSWS),smo),'color',[1 0.2 0.6]) 
    hold on, plot(tpsSWS(1:end-1),SmoothDec((MbSWS-EbSWS),smo),'color',[1 0.2 0.6]) 
    hold on, plot(rgSWS(pSWS<pval),pr(pSWS<pval),'rx')
    hold on, plot(tpsMov(1:end-1),SmoothDec((MaMov),smo),'b','linewidth',2), 
    hold on, plot(tpsMov(1:end-1),SmoothDec((MaMov+EaMov),smo),'b') 
    hold on, plot(tpsMov(1:end-1),SmoothDec((MaMov-EaMov),smo),'b') 
    hold on, plot(tpsMov(1:end-1),SmoothDec((MbMov),smo),'color',[0 0.5 1],'linewidth',2) 
    hold on, plot(tpsMov(1:end-1),SmoothDec((MbMov+EbMov),smo),'color',[0 0.5 1]) 
    hold on, plot(tpsMov(1:end-1),SmoothDec((MbMov-EbMov),smo),'color',[0 0.5 1]) 
    hold on, plot(rgMov(pMov<pval),prMov(pMov<pval),'bx')
    title(['Global effect - Wake vs SWS, n°',num2str(a),InfoLFP.structure(i)])
    hold on, axis([-200 1300 -1200 1200])
    for a=0:150:600
        hold on, plot(a,min(axis):max(axis),'b','linewidth',1);
    end
 
    %---------------------------------------------------------------------------
    %<><><><><><><><><><><><><><><> Omission Effect <><><><><><><><><><><><><><>
    %---------------------------------------------------------------------------
    lim=5500;
    pval=0.05;

    TempASWS=Data(OmiFreqSWS(i))';
    MsaSWS=[TempASWS(:,1:size(TempASWS,2)-1)];
    MsaSWS(MsaSWS>lim)=nan;
    MsaSWS(MsaSWS<-lim)=nan;
    TempBSWS=Data(OmiRareSWS(i))';
    MsbSWS=[TempBSWS(:,1:size(TempBSWS,2)-1)];
    MsbSWS(MsbSWS>lim)=nan;
    MsbSWS(MsbSWS<-lim)=nan;
    [MaSWS,Sa,EaSWS]=MeanDifNan(RemoveNan(MsaSWS));
    [MbSWS,Sb,EbSWS]=MeanDifNan(RemoveNan(MsbSWS));
    [hSWS,pSWS]=ttest2(RemoveNan(MsaSWS),RemoveNan(MsbSWS));
    rgSWS=Range(OmiFreqSWS(i),'ms');
    pr=rescale(pSWS,1000, 1100);
    tpsSWS=Range(MLstdSWS(i),'ms');

    TempAMov=Data(OmiFreqMov(i))';
    MsaMov=[tempAMov(:,1:size(tempAMov,2)-1)];
    MsaMov(MsaMov>lim)=nan;
    MsaMov(MsaMov<-lim)=nan;
    TempBMov=Data(OmiRareMov(i))';
    MsbMov=[TempBMov(:,1:size(TempBMov,2)-1)];
    MsbMov(MsbMov>lim)=nan;
    MsbMov(MsbMov<-lim)=nan;
    [MaMov,Sa,EaMov]=MeanDifNan(RemoveNan(MsaMov));
    [MbMov,Sb,EbMov]=MeanDifNan(RemoveNan(MsbMov));
    [hMov,pMov]=ttest2(RemoveNan(MsaMov),RemoveNan(MsbMov));
    rgMov=Range(OmiFreqMov(i),'ms');
    prMov=rescale(pMov,1100, 1200);
    tpsMov=Range(MLstdMov(i),'ms');
    
    hold on, subplot (3,1,3)
    hold on, plot(tpsSWS(1:end-1),SmoothDec((MaSWS),smo),'r','linewidth',2), 
    hold on, plot(tpsSWS(1:end-1),SmoothDec((MaSWS+EaSWS),smo),'r') 
    hold on, plot(tpsSWS(1:end-1),SmoothDec((MaSWS-EaSWS),smo),'r') 
    hold on, plot(tpsSWS(1:end-1),SmoothDec((MbSWS),smo),'color',[1 0.2 0.6],'linewidth',2) 
    hold on, plot(tpsSWS(1:end-1),SmoothDec((MbSWS+EbSWS),smo),'color',[1 0.2 0.6]) 
    hold on, plot(tpsSWS(1:end-1),SmoothDec((MbSWS-EbSWS),smo),'color',[1 0.2 0.6]) 
    hold on, plot(rgSWS(pSWS<pval),pr(pSWS<pval),'rx')
    hold on, plot(tpsMov(1:end-1),SmoothDec((MaMov),smo),'b','linewidth',2), 
    hold on, plot(tpsMov(1:end-1),SmoothDec((MaMov+EaMov),smo),'b') 
    hold on, plot(tpsMov(1:end-1),SmoothDec((MaMov-EaMov),smo),'b') 
    hold on, plot(tpsMov(1:end-1),SmoothDec((MbMov),smo),'color',[0 0.5 1],'linewidth',2) 
    hold on, plot(tpsMov(1:end-1),SmoothDec((MbMov+EbMov),smo),'color',[0 0.5 1]) 
    hold on, plot(tpsMov(1:end-1),SmoothDec((MbMov-EbMov),smo),'color',[0 0.5 1]) 
    hold on, plot(rgMov(pMov<pval),prMov(pMov<pval),'bx')
    title(['Omission effect - Wake vs SWS, n°',num2str(a),InfoLFP.structure(i)])
    hold on, axis([-200 1300 -1200 1200])
    for a=0:150:600
        hold on, plot(a,min(axis):max(axis),'b','linewidth',1);
    end

end