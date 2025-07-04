
for num=2:6; 

cd /media/KARIMBACKUP/DataMMN/Mouse64/20130515/MMN-Mouse-64-15052013

load LFPData
load LocalGlobalAssignment  

if 1
figure, [fh, rasterAx, histAx, MLstd1]=ImagePETH(LFP{num}, ts(sort([LocalStdGlobStdA;LocalStdGlobStdB])), -2000, +11000,'BinSize',800);title(['Block Local std - Global Standard   A']);close
figure, [fh, rasterAx, histAx, MLdev1]=ImagePETH(LFP{num}, ts(sort([LocalDvtGlobStdA;LocalDvtGlobStdB])), -2000, +11000,'BinSize',800);title(['Block Local std - Global Standard   A']);close


figure, [fh, rasterAx, histAx, MGstd1]=ImagePETH(LFP{num}, ts(sort([LocalStdGlobStdA;LocalStdGlobStdB])), -3000, +11000,'BinSize',800);title(['Block Local std - Global Standard   A']);close
figure, [fh, rasterAx, histAx, MGdev1]=ImagePETH(LFP{num}, ts(sort([LocalStdGlobDvtA;LocalStdGlobDvtB])), -3000, +11000,'BinSize',800);title(['Block Local std - Global Standard   A']);close

else
    
figure, [fh, rasterAx, histAx, MLstdT1]=ImagePETH(LFP{num}, ts(sort([LocalStdGlobStdA;LocalStdGlobStdB;LocalStdGlobDvtA;LocalStdGlobDvtB])), -3000, +11000,'BinSize',800);title(['Block Local std - Global Standard   A']);close
figure, [fh, rasterAx, histAx, MLdevT1]=ImagePETH(LFP{num}, ts(sort([LocalDvtGlobStdA;LocalDvtGlobStdB;LocalDvtGlobDvtA;LocalDvtGlobDvtB])), -3000, +11000,'BinSize',800);title(['Block Local std - Global Standard   A']);close
 
figure, [fh, rasterAx, histAx, MGstdT1]=ImagePETH(LFP{num}, ts(sort([LocalStdGlobStdA;LocalStdGlobStdB;LocalDvtGlobStdA;LocalDvtGlobStdB])), -3000, +11000,'BinSize',800);title(['Block Local std - Global Standard   A']);close
figure, [fh, rasterAx, histAx, MGdevT1]=ImagePETH(LFP{num}, ts(sort([LocalStdGlobDvtA;LocalStdGlobDvtB;LocalDvtGlobDvtA;LocalDvtGlobDvtB])), -3000, +11000,'BinSize',800);title(['Block Local std - Global Standard   A']);close
 
end


cd /media/KARIMBACKUP/DataMMN/Mouse64/20130516/MMN-Mouse-64-16052013

load LFPData
load LocalGlobalAssignment

if 1
    
figure, [fh, rasterAx, histAx, MLstd2]=ImagePETH(LFP{num}, ts(sort([LocalStdGlobStdA;LocalStdGlobStdB])), -2000, +11000,'BinSize',800);title(['Block Local std - Global Standard   A']);close
figure, [fh, rasterAx, histAx, MLdev2]=ImagePETH(LFP{num}, ts(sort([LocalDvtGlobStdA;LocalDvtGlobStdB])), -2000, +11000,'BinSize',800);title(['Block Local std - Global Standard   A']);close


figure, [fh, rasterAx, histAx, MGstd2]=ImagePETH(LFP{num}, ts(sort([LocalStdGlobStdA;LocalStdGlobStdB])), -3000, +11000,'BinSize',800);title(['Block Local std - Global Standard   A']);close
figure, [fh, rasterAx, histAx, MGdev2]=ImagePETH(LFP{num}, ts(sort([LocalStdGlobDvtA;LocalStdGlobDvtB])), -3000, +11000,'BinSize',800);title(['Block Local std - Global Standard   A']);close

else
    
figure, [fh, rasterAx, histAx, MLstdT2]=ImagePETH(LFP{num}, ts(sort([LocalStdGlobStdA;LocalStdGlobStdB;LocalStdGlobDvtA;LocalStdGlobDvtB])), -3000, +11000,'BinSize',800);title(['Block Local std - Global Standard   A']);close
figure, [fh, rasterAx, histAx, MLdevT2]=ImagePETH(LFP{num}, ts(sort([LocalDvtGlobStdA;LocalDvtGlobStdB;LocalDvtGlobDvtA;LocalDvtGlobDvtB])), -3000, +11000,'BinSize',800);title(['Block Local std - Global Standard   A']);close
 
figure, [fh, rasterAx, histAx, MGstdT2]=ImagePETH(LFP{num}, ts(sort([LocalStdGlobStdA;LocalStdGlobStdB;LocalDvtGlobStdA;LocalDvtGlobStdB])), -3000, +11000,'BinSize',800);title(['Block Local std - Global Standard   A']);close
figure, [fh, rasterAx, histAx, MGdevT2]=ImagePETH(LFP{num}, ts(sort([LocalStdGlobDvtA;LocalStdGlobDvtB;LocalDvtGlobDvtA;LocalDvtGlobDvtB])), -3000, +11000,'BinSize',800);title(['Block Local std - Global Standard   A']);close
 
end


%---------------------------------------------------------------------------
%---------------------------------------------------------------------------
%---------------------------------------------------------------------------


lim=5500;
pval=0.05;

tempa=Data(MLstd1)';
tempb=Data(MLstd2)';
Msa=[tempa(:,1:size(tempa,2)-1);tempb(:,1:size(tempa,2)-1) ];
    Msa(Msa>lim)=nan;
    Msa(Msa<-lim)=nan;
    
temp2a=Data(MLdev1)';
temp2b=Data(MLdev2)';
    Msb=[temp2a(:,1:size(tempa,2)-1);temp2b(:,1:size(tempa,2)-1)];
    Msb(Msb>lim)=nan;
    Msb(Msb<-lim)=nan;
    
%     
% Msa=[Data(MLstd1)';Data(MLstd2)'];
% 
%     Msa(Msa>lim)=nan;
%     Msa(Msa<-lim)=nan;
% 
% Msb=[Data(Restrict(MLdev1,MLstd1))';Data(Restrict(MLdev2,MLstd2))'];
%     Msb(Msb>lim)=nan;
%     Msb(Msb<-lim)=nan;

%  [Ma,Sa,Ea]=MeanDifNan(Msa);
% [Mb,Sb,Eb]=MeanDifNan(Msb);

[Ma,Sa,Ea]=MeanDifNan(RemoveNan(Msa));
[Mb,Sb,Eb]=MeanDifNan(RemoveNan(Msb));

    [h,p]=ttest2(RemoveNan(Msa),RemoveNan(Msb));
    rg=Range(MLdev1,'ms');
    pr=rescale(p,500, 550);
    
%    figure, plot(Range(Mstd,'ms'),nanmean(Msa),'k'), hold on, plot(Range(Mstd,'ms'),nanmean(Msb),'r') 
%     pval=0.05;
% hold on, plot(rg(p<pval),pr(p<pval),'bx')

tps=Range(MLstd1,'ms');

figure, plot(tps(1:end-1),Ma,'k','linewidth',2), 
hold on, plot(tps(1:end-1),Ma+Ea,'k') 
hold on, plot(tps(1:end-1),Ma-Ea,'k') 
hold on, plot(tps(1:end-1),Mb,'r','linewidth',2) 
hold on, plot(tps(1:end-1),Mb+Eb,'r') 
hold on, plot(tps(1:end-1),Mb-Eb,'r') 
hold on, plot(rg(p<pval),pr(p<pval),'bx')
hold on, plot(rg(p<0.01),pr(p<0.01),'gx')
title(['local effect, channel ',num2str(num)])
hold on, axis([-100 1100 -1500 1200])
    for a=0:150:600
        hold on, plot(a,min(axis):max(axis),'b','linewidth',1);
    end

%---------------------------------------------------------------------------

tempa=Data(MGstd1)';
tempb=Data(MGstd2)';
Msa=[tempa(:,1:size(tempa,2)-1);tempb(:,1:size(tempa,2)-1) ];
    Msa(Msa>lim)=nan;
    Msa(Msa<-lim)=nan;
    
temp2a=Data(MGdev1)';
temp2b=Data(MGdev2)';
    Msb=[temp2a(:,1:size(tempa,2)-1);temp2b(:,1:size(tempa,2)-1)];
    Msb(Msb>lim)=nan;
    Msb(Msb<-lim)=nan;

 

% [Ma,Sa,Ea]=MeanDifNan(Msa);
% [Mb,Sb,Eb]=MeanDifNan(Msb);


[Ma,Sa,Ea]=MeanDifNan(RemoveNan(Msa));
[Mb,Sb,Eb]=MeanDifNan(RemoveNan(Msb));


    [h,p]=ttest2(RemoveNan(Msa),RemoveNan(Msb));
    rg=Range(MGdev1,'ms');
    pr=rescale(p,500, 550);
    
%    figure, plot(Range(Mstd,'ms'),nanmean(Msa),'k'), hold on, plot(Range(Mstd,'ms'),nanmean(Msb),'r') 
%     pval=0.05;
% hold on, plot(rg(p<pval),pr(p<pval),'bx')

tps=Range(MGstd1,'ms');

figure, plot(tps(1:end-1),Ma,'k','linewidth',2), 
hold on, plot(tps(1:end-1),Ma+Ea,'k') 
hold on, plot(tps(1:end-1),Ma-Ea,'k') 
hold on, plot(tps(1:end-1),Mb,'r','linewidth',2) 
hold on, plot(tps(1:end-1),Mb+Eb,'r') 
hold on, plot(tps(1:end-1),Mb-Eb,'r') 
hold on, plot(rg(p<pval),pr(p<pval),'bx')
hold on, plot(rg(p<0.01),pr(p<0.01),'gx')
title(['global effect, channel ',num2str(num)])

hold on, axis([-100 1100 -1500 1200])
    for a=0:150:600
        hold on, plot(a,min(axis):max(axis),'b','linewidth',1);
    end

end


