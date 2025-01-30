
res=pwd;
smo=2;
load([res,'/LFPData/InfoLFP']);

J1=-2000;
J2=+13000;

for num=0:28;
    clear LFP
    clear i;
    load([res,'/LFPData/LFP',num2str(num)]);
    LFP2=ResampleTSD(LFP,500);
    i=num+1;
    
    load LocalGlobalAssignment1
    if 1
        figure, [fh, rasterAx, histAx, MLstd1(i)]=ImagePETH(LFP2, ts(sort([LocalStdGlobStdA;LocalStdGlobStdB])), J1, J2,'BinSize',800);close
        figure, [fh, rasterAx, histAx, MLdev1(i)]=ImagePETH(LFP2, ts(sort([LocalDvtGlobStdA;LocalDvtGlobStdB])), J1, J2,'BinSize',800);close
        figure, [fh, rasterAx, histAx, MGdev1(i)]=ImagePETH(LFP2, ts(sort([LocalStdGlobDvtA;LocalStdGlobDvtB])), J1, J2,'BinSize',800);close
        figure, [fh, rasterAx, histAx, OmiFreq1(i)] = ImagePETH(LFP2, ts(sort([OmiAAAA;OmiBBBB])), J1, J2,'BinSize',800);close
        figure, [fh, rasterAx, histAx, OmiRare1(i)] = ImagePETH(LFP2, ts(sort([OmissionRareA;OmissionRareB])), J1, J2,'BinSize',800);close
        MGstd1(i)=MLstd1(i);
    end
   load LocalGlobalAssignment2
    if 1
        figure, [fh, rasterAx, histAx, MLstd2(i)]=ImagePETH(LFP2, ts(sort([LocalStdGlobStdA;LocalStdGlobStdB])), J1, J2,'BinSize',800);close
        figure, [fh, rasterAx, histAx, MLdev2(i)]=ImagePETH(LFP2, ts(sort([LocalDvtGlobStdA;LocalDvtGlobStdB])), J1, J2,'BinSize',800);close
        figure, [fh, rasterAx, histAx, MGdev2(i)]=ImagePETH(LFP2, ts(sort([LocalStdGlobDvtA;LocalStdGlobDvtB])), J1, J2,'BinSize',800);close
        figure, [fh, rasterAx, histAx, OmiFreq2(i)] = ImagePETH(LFP2, ts(sort([OmiAAAA;OmiBBBB])), J1, J2,'BinSize',800);close
        figure, [fh, rasterAx, histAx, OmiRare2(i)] = ImagePETH(LFP2, ts(sort([OmissionRareA;OmissionRareB])), J1, J2,'BinSize',800);close
        MGstd2(i)=MLstd2(i);
    end
   
    
  
    
   
%---------------------------------------------------------------------------
%<><><><><><><><><><><><><><> Local Effect <><><><><><><><><><><><><><><
%---------------------------------------------------------------------------
    lim=5500;
    pval=0.05;

    temp1a=Data(MLstd1(i))';
    temp1b=Data(MLstd2(i))';
    Msa=[temp1a(:,1:size(temp1a,2)-1);temp1b(:,1:size(temp1a,2)-1)];
    Msa(Msa>lim)=nan;
    Msa(Msa<-lim)=nan;
    
    temp2a=Data(MLdev1(i))';
    temp2b=Data(MLdev2(i))';
    Msb=[temp2a(:,1:size(temp1a,2)-1);temp2b(:,1:size(temp1a,2)-1)];
    Msb(Msb>lim)=nan;
    Msb(Msb<-lim)=nan;
    
    [Ma,Sa,Ea]=MeanDifNan(RemoveNan(Msa));
    [Mb,Sb,Eb]=MeanDifNan(RemoveNan(Msb));

    [h,p]=ttest2(RemoveNan(Msa),RemoveNan(Msb));
    rg=Range(MLdev1(i),'ms');
    pr=rescale(p,450, 490);
        
    tps=Range(MLstd1(i),'ms');

    figure, plot(tps(1:end-1),SmoothDec((Ma),smo),'k','linewidth',2), 
    hold on, plot(tps(1:end-1),SmoothDec((Ma+Ea),smo),'k') 
    hold on, plot(tps(1:end-1),SmoothDec((Ma-Ea),smo),'k') 
    hold on, plot(tps(1:end-1),SmoothDec((Mb),smo),'r','linewidth',2) 
    hold on, plot(tps(1:end-1),SmoothDec((Mb+Eb),smo),'r') 
    hold on, plot(tps(1:end-1),SmoothDec((Mb-Eb),smo),'r') 
    hold on, plot(rg(p<pval),pr(p<pval),'gx')
    title(['local effect, channel',num2str(num),InfoLFP.structure(i)])
    hold on, axis([-200 1300 -600 600])
    for a=0:150:600
        hold on, plot(a,min(axis):max(axis),'b','linewidth',1);
    end

%---------------------------------------------------------------------------
%<><><><><><><><><><><><><><> Global Effect <><><><><><><><><><><><><><><
%---------------------------------------------------------------------------
    temp1a=Data(MGstd1(i))';
    temp1b=Data(MGstd2(i))';
    Msa=[temp1a(:,1:size(temp1a,2)-1);temp1b(:,1:size(temp1a,2)-1)];
    Msa(Msa>lim)=nan;
    Msa(Msa<-lim)=nan;
    
    temp2a=Data(MGdev1(i))';
    temp2b=Data(MGdev2(i))';
    Msb=[temp2a(:,1:size(temp1a,2)-1);temp2b(:,1:size(temp1a,2)-1)];
    Msb(Msb>lim)=nan;
    Msb(Msb<-lim)=nan;

    [Ma,Sa,Ea]=MeanDifNan(RemoveNan(Msa));
    [Mb,Sb,Eb]=MeanDifNan(RemoveNan(Msb));

    [h,p]=ttest2(RemoveNan(Msa),RemoveNan(Msb));
    rg=Range(MGdev1(i),'ms');
    pr=rescale(p,450, 490);
    
    tps=Range(MGstd1(i),'ms');

    figure, plot(tps(1:end-1),SmoothDec((Ma),smo),'k','linewidth',2), 
    hold on, plot(tps(1:end-1),SmoothDec((Ma+Ea),smo),'k') 
    hold on, plot(tps(1:end-1),SmoothDec((Ma-Ea),smo),'k') 
    hold on, plot(tps(1:end-1),SmoothDec((Mb),smo),'r','linewidth',2) 
    hold on, plot(tps(1:end-1),SmoothDec((Mb+Eb),smo),'r') 
    hold on, plot(tps(1:end-1),SmoothDec((Mb-Eb),smo),'r') 
    hold on, plot(rg(p<pval),pr(p<pval),'gx')
    title(['Global effect, channel',num2str(num),InfoLFP.structure(i)])
    hold on, axis([-200 1300 -600 600])
    for a=0:150:600
        hold on, plot(a,min(axis):max(axis),'b','linewidth',1);
    end
 
%---------------------------------------------------------------------------
%<><><><><><><><><><><><><> Global Omission Effect <><><><><><><><><><><><><
%---------------------------------------------------------------------------
    lim=5500;
    pval=0.05;

    temp1a=Data(OmiFreq1(i))';
    temp1b=Data(OmiFreq2(i))';
    Msa=[temp1a(:,1:size(temp1a,2)-1);temp1b(:,1:size(temp1a,2)-1)];
    Msa(Msa>lim)=nan;
    Msa(Msa<-lim)=nan;
    
    temp2a=Data(OmiRare1(i))';
    temp2b=Data(OmiRare2(i))';
    Msb=[temp2a(:,1:size(temp1a,2)-1);temp2b(:,1:size(temp1a,2)-1)];
    Msb(Msb>lim)=nan;
    Msb(Msb<-lim)=nan;
    
    [Ma,Sa,Ea]=MeanDifNan(RemoveNan(Msa));
    [Mb,Sb,Eb]=MeanDifNan(RemoveNan(Msb));

    [h,p]=ttest2(RemoveNan(Msa),RemoveNan(Msb));
    rg=Range(OmiFreq1(i),'ms');
    pr=rescale(p,450, 490);
        
    tps=Range(MLstd1(i),'ms');

    figure, plot(tps(1:end-1),SmoothDec((Ma),smo),'k','linewidth',2), 
    hold on, plot(tps(1:end-1),SmoothDec((Ma+Ea),smo),'k') 
    hold on, plot(tps(1:end-1),SmoothDec((Ma-Ea),smo),'k') 
    hold on, plot(tps(1:end-1),SmoothDec((Mb),smo),'r','linewidth',2) 
    hold on, plot(tps(1:end-1),SmoothDec((Mb+Eb),smo),'r') 
    hold on, plot(tps(1:end-1),SmoothDec((Mb-Eb),smo),'r') 
    hold on, plot(rg(p<pval),pr(p<pval),'gx')
    title(['Global Omission effect, channel',num2str(num),InfoLFP.structure(i)])
    hold on, axis([-200 1300 -600 600])
    for a=0:150:600
        hold on, plot(a,min(axis):max(axis),'b','linewidth',1);
    end
    
%---------------------------------------------------------------------------
%<><><><><><><><><><><><><> Local Omission Effect <><><><><><><><><><><><><
%---------------------------------------------------------------------------
%     lim=5500;
%     pval=0.05;
% 
%     temp1a=Data(MLstd1(i))';
%     temp1b=Data(MLstd2(i))';
%     Msa=[temp1a(:,1:size(temp1a,2)-1);temp1b(:,1:size(temp1a,2)-1)];
%     Msa(Msa>lim)=nan;
%     Msa(Msa<-lim)=nan;
%     
%     temp2a=Data(OmiRare1(i))';
%     temp2b=Data(OmiRare2(i))';
%     Msb=[temp2a(:,1:size(temp1a,2)-1);temp2b(:,1:size(temp1a,2)-1)];
%     Msb(Msb>lim)=nan;
%     Msb(Msb<-lim)=nan;
%     
%     [Ma,Sa,Ea]=MeanDifNan(RemoveNan(Msa));
%     [Mb,Sb,Eb]=MeanDifNan(RemoveNan(Msb));
% 
%     [h,p]=ttest2(RemoveNan(Msa),RemoveNan(Msb));
%     rg=Range(MLdev1(i),'ms');
%     pr=rescale(p,450, 490);
%         
%     tps=Range(MLstd1(i),'ms');
% 
%     figure, plot(tps(1:end-1),SmoothDec((Ma),smo),'k','linewidth',2), 
%     hold on, plot(tps(1:end-1),SmoothDec((Ma+Ea),smo),'k') 
%     hold on, plot(tps(1:end-1),SmoothDec((Ma-Ea),smo),'k') 
%     hold on, plot(tps(1:end-1),SmoothDec((Mb),smo),'r','linewidth',2) 
%     hold on, plot(tps(1:end-1),SmoothDec((Mb+Eb),smo),'r') 
%     hold on, plot(tps(1:end-1),SmoothDec((Mb-Eb),smo),'r') 
%     hold on, plot(rg(p<pval),pr(p<pval),'gx')
%     title(['Local Omission effect, channel',num2str(num),InfoLFP.structure(i)])
%     hold on, axis([-200 1100 -600 600])
%     for a=0:150:600
%         hold on, plot(a,min(axis):max(axis),'b','linewidth',1);
%     end

end

save MMNanalysisLFP MGdev1 MGdev2 MGstd1 MGstd2 MLdev1 MLdev2 MLstd1 MLstd2 OmiFreq1 OmiFreq2 OmiRare1 OmiRare2


