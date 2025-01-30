%PlotDiffStructure

load LFPLocalGlobal
% lim(1:13)=3000;
% lim(1)=4000;
% lim(8)=4000;

pval=0.01;
smo=1;
decal=100;

%---------------------------------------------------------------------------
%<><><><><><><><><><><><><><> Local Effect <><><><><><><><><><><><><><><
%---------------------------------------------------------------------------


figure(1),clf
figure(2),clf
figure(3),clf
for i=1:14

    Lstd_Nfil=Data(LFP_LocalEffect_std(i))';
    Mfil_std=FilterLFP(LFP_LocalEffect_std(i),[45,55],128);
    Lstd_Fil=Data(Mfil_std)';
%   MsB(MsB>lim)=nan;
%   MsB(MsB<-lim)=nan;
    Lstd=Lstd_Nfil-Lstd_Fil;
    
    Ldvt_Nfil=Data(LFP_LocalEffect_dvt(i))';
    Mfil_dvt=FilterLFP(LFP_LocalEffect_dvt(i),[45,55],128);
    Ldvt_Fil=Data(Mfil_dvt)';
    Ldvt=Ldvt_Nfil-Ldvt_Fil;
    
    [Mstd,S1,Estd]=MeanDifNan(RemoveNan(Lstd));
    [Mdvt,S2,Edvt]=MeanDifNan(RemoveNan(Ldvt));
    Mdiff=(Mstd-Mdvt)';
    
    [h,p]=ttest2(RemoveNan(Lstd),RemoveNan(Ldvt));
    rg=Range(LFP_LocalEffect_std(i),'ms');
    pr=rescale(p,100, -120);
    tps=Range(LFP_LocalEffect_std(i),'ms');
    
    figure(1), plot(tps,i*decal+SmoothDec((Mdiff),smo),'k','linewidth',1),
    hold on, plot(rg(p<pval),i*decal+pr(p<pval),'rx')
    ylabel('Local effect')
    
    figure(2), plot(tps,i*decal+SmoothDec((abs(Mdiff)),smo),'b','linewidth',1),
    hold on, plot(rg(p<pval),i*decal+pr(p<pval),'rx')
    ylabel('Local effect')
    
    figure(3), plot(tps,i*(decal*2)+SmoothDec((Mstd),smo),'k','linewidth',1),
    hold on, plot(tps,i*(decal*2)+SmoothDec((Mdvt),smo),'r','linewidth',1),
    ylabel('Local effect')

end

figure(1)
for a=0:150:600
    hold on, plot(a,min(axis):max(axis),'b','linewidth',1);
end
figure(2)
for a=0:150:600
    hold on, plot(a,min(axis):max(axis),'b','linewidth',1);
end
figure(3)
for a=0:150:600
    hold on, plot(a,min(axis):max(axis),'b','linewidth',1);
end

%---------------------------------------------------------------------------
%<><><><><><><><><><><><><><> Global Effect <><><><><><><><><><><><><><><
%---------------------------------------------------------------------------

figure(4),clf
figure(5),clf
figure(6),clf
for i=1:14

    Lstd_Nfil=Data(LFP_GlobalEffectLstd_std(i))';
    Mfil_std=FilterLFP(LFP_GlobalEffectLstd_std(i),[45,55],128);
    Lstd_Fil=Data(Mfil_std)';
    Lstd=Lstd_Nfil-Lstd_Fil;
    
    Ldvt_Nfil=Data(LFP_GlobalEffectLstd_dvt(i))';
    Mfil_dvt=FilterLFP(LFP_GlobalEffectLstd_dvt(i),[45,55],128);
    Ldvt_Fil=Data(Mfil_dvt)';
    Ldvt=Ldvt_Nfil-Ldvt_Fil;
    
    [Mstd,S1,Estd]=MeanDifNan(RemoveNan(Lstd));
    [Mdvt,S2,Edvt]=MeanDifNan(RemoveNan(Ldvt));
    Mdiff=(Mstd-Mdvt)';
    
    [h,p]=ttest2(RemoveNan(Lstd),RemoveNan(Ldvt));
    rg=Range(LFP_GlobalEffectLstd_std(i),'ms');
    pr=rescale(p,100, -120);
    tps=Range(LFP_GlobalEffectLstd_std(i),'ms');
    
    figure(4), plot(tps,i*decal+SmoothDec((Mdiff),smo),'k','linewidth',1),
    hold on, plot(rg(p<pval),i*decal+pr(p<pval),'rx')
    ylabel('Global effect (local std)')
    
    figure(5), plot(tps,i*decal+SmoothDec((abs(Mdiff)),smo),'b','linewidth',1),
    hold on, plot(rg(p<pval),i*decal+pr(p<pval),'rx')
    ylabel('Global effect (local std)')
    
    figure(6), plot(tps,i*(decal*2)+SmoothDec((Mstd),smo),'k','linewidth',1),
    hold on, plot(tps,i*(decal*2)+SmoothDec((Mdvt),smo),'r','linewidth',1),
    ylabel('Global effect (local std)')

end

figure(4)
for a=0:150:600
    hold on, plot(a,min(axis):max(axis),'b','linewidth',1);
end
figure(5)
for a=0:150:600
    hold on, plot(a,min(axis):max(axis),'b','linewidth',1);
end
figure(6)
for a=0:150:600
    hold on, plot(a,min(axis):max(axis),'b','linewidth',1);
end

%---------------------------------------------------------------------------
%<><><><><><><><><><><><><><> Global Effect <><><><><><><><><><><><><><><
%---------------------------------------------------------------------------

figure(7),clf
figure(8),clf
figure(9),clf
for i=1:14

    Lstd_Nfil=Data(LFP_GlobalEffectLdvt_std(i))';
    Mfil_std=FilterLFP(LFP_GlobalEffectLdvt_std(i),[45,55],128);
    Lstd_Fil=Data(Mfil_std)';
    Lstd=Lstd_Nfil-Lstd_Fil;
    
    Ldvt_Nfil=Data(LFP_GlobalEffectLdvt_dvt(i))';
    Mfil_dvt=FilterLFP(LFP_GlobalEffectLdvt_dvt(i),[45,55],128);
    Ldvt_Fil=Data(Mfil_dvt)';
    Ldvt=Ldvt_Nfil-Ldvt_Fil;
    
    [Mstd,S1,Estd]=MeanDifNan(RemoveNan(Lstd));
    [Mdvt,S2,Edvt]=MeanDifNan(RemoveNan(Ldvt));
    Mdiff=(Mstd-Mdvt)';
    
    [h,p]=ttest2(RemoveNan(Lstd),RemoveNan(Ldvt));
    rg=Range(LFP_GlobalEffectLdvt_std(i),'ms');
    pr=rescale(p,100, -120);
    tps=Range(LFP_GlobalEffectLdvt_std(i),'ms');
    
    figure(7), plot(tps,i*decal+SmoothDec((Mdiff),smo),'k','linewidth',1),
    hold on, plot(rg(p<pval),i*decal+pr(p<pval),'rx')
    ylabel('Global effect (local dvt)')
    
    figure(8), plot(tps,i*decal+SmoothDec((abs(Mdiff)),smo),'b','linewidth',1),
    hold on, plot(rg(p<pval),i*decal+pr(p<pval),'rx')
    ylabel('Global effect (local dvt)')
    
    figure(9), plot(tps,i*(decal*2)+SmoothDec((Mstd),smo),'k','linewidth',1),
    hold on, plot(tps,i*(decal*2)+SmoothDec((Mdvt),smo),'r','linewidth',1),
    ylabel('Global effect (local dvt)')

end

figure(7)
for a=0:150:600
    hold on, plot(a,min(axis):max(axis),'b','linewidth',1);
end
figure(8)
for a=0:150:600
    hold on, plot(a,min(axis):max(axis),'b','linewidth',1);
end
figure(9)
for a=0:150:600
    hold on, plot(a,min(axis):max(axis),'b','linewidth',1);
end

%---------------------------------------------------------------------------
%<><><><><><><><><><><><><><> Global Effect <><><><><><><><><><><><><><><
%---------------------------------------------------------------------------

figure(10),clf
figure(11),clf
figure(12),clf
for i=1:14

    Lstd_Nfil=Data(LFP_OmissionEffect_std(i))';
    Mfil_std=FilterLFP(LFP_OmissionEffect_std(i),[45,55],128);
    Lstd_Fil=Data(Mfil_std)';
    Lstd=Lstd_Nfil-Lstd_Fil;
    
    Ldvt_Nfil=Data(LFP_OmissionEffect_dvt(i))';
    Mfil_dvt=FilterLFP(LFP_OmissionEffect_dvt(i),[45,55],128);
    Ldvt_Fil=Data(Mfil_dvt)';
    Ldvt=Ldvt_Nfil-Ldvt_Fil;
    
    [Mstd,S1,Estd]=MeanDifNan(RemoveNan(Lstd));
    [Mdvt,S2,Edvt]=MeanDifNan(RemoveNan(Ldvt));
    Mdiff=(Mstd-Mdvt)';
    
    [h,p]=ttest2(RemoveNan(Lstd),RemoveNan(Ldvt));
    rg=Range(LFP_OmissionEffect_std(i),'ms');
    pr=rescale(p,100, -120);
    tps=Range(LFP_OmissionEffect_std(i),'ms');
    
    figure(10), plot(tps,i*decal+SmoothDec((Mdiff),smo),'k','linewidth',1),
    hold on, plot(rg(p<pval),i*decal+pr(p<pval),'rx')
    ylabel('Omission Effect')
    
    figure(11), plot(tps,i*decal+SmoothDec((abs(Mdiff)),smo),'b','linewidth',1),
    hold on, plot(rg(p<pval),i*decal+pr(p<pval),'rx')
    ylabel('Omission Effect')
    
    figure(12), plot(tps,i*(decal*2)+SmoothDec((Mstd),smo),'k','linewidth',1),
    hold on, plot(tps,i*(decal*2)+SmoothDec((Mdvt),smo),'r','linewidth',1),
    ylabel('Omission Effect')

end

figure(10)
for a=0:150:600
    hold on, plot(a,min(axis):max(axis),'b','linewidth',1);
end
figure(11)
for a=0:150:600
    hold on, plot(a,min(axis):max(axis),'b','linewidth',1);
end
figure(12)
for a=0:150:600
    hold on, plot(a,min(axis):max(axis),'b','linewidth',1);
end

% %---------------------------------------------------------------------------
% %<><><><><><><><><><><><><><> Local Effect <><><><><><><><><><><><><><><
% %---------------------------------------------------------------------------
% 
% decal=100;
% figure(1),clf
% figure(2),clf
% for i=1:12
%     
%     Mfil=FilterLFP(LFP_LocalEffect_std2(i),[40,60],128);
%     tempA=Data(Mfil)';
%     %tempA=Data(LFP_LocalEffect_std2(i))';
%     MsA=[tempA(:,1:size(tempA,2)-1)];
%     
%     MsA=Data(MsA);
%     MsA(MsA>lim(i))=nan;
%     MsA(MsA<-lim(i))=nan;
%     
%     Mfil=FilterLFP(LFP_LocalEffect_dvt2(i),[40,60],128);
%     tempB=Data(Mfil)';
% %     tempB=Data(LFP_LocalEffect_dvt2(i))';
%     MsB=[tempB(:,1:size(tempB,2)-1)];
%     MsB(MsB>lim(i))=nan;
%     MsB(MsB<-lim(i))=nan;
%     
%     [Ma,S1,Ea]=MeanDifNan(RemoveNan(MsA));
%     [Mb,S2,Eb]=MeanDifNan(RemoveNan(MsB));
%     Mdiff=Ma-Mb;
%     %Mdiff=rescale(Mdiff,i*100,(i+1)*100);
%     
%     [h,p]=ttest2(RemoveNan(MsA),RemoveNan(MsB));
%     
%     rg=Range(LFP_LocalEffect_std2(i),'ms');
%     pr=rescale(p,100, -120);
%     tps=Range(LFP_LocalEffect_std2(i),'ms');
%     
% 
%     
%     %hold on, subplot(13,2,i*2-1)
%     figure(1),hold on, plot(tps(1:end-1),i*decal+SmoothDec((Mdiff),smo),'k','linewidth',1),
%     hold on, plot(rg(p<pval),i*decal+pr(p<pval),'rx')
%     ylabel('Local effect')
%     
%     %hold on, subplot(13,2,i*2)
%     figure(2),hold on, plot(tps(1:end-1),i*decal+SmoothDec((abs(Mdiff)),smo),'b','linewidth',1),
%     hold on, plot(rg(p<pval),i*decal+pr(p<pval),'rx')
%     ylabel('Local effect')
% 
% end
% 
%     figure(1)
%     for a=0:150:600
%         hold on, plot(a,min(axis):max(axis),'b','linewidth',1);
%     end
%     figure(2)
%         for a=0:150:600
%         hold on, plot(a,min(axis):max(axis),'b','linewidth',1);
%         end
%     
% %---------------------------------------------------------------------------
% %<><><><><><><><><><><><><><> Global Effect <><><><><><><><><><><><><><><
% %---------------------------------------------------------------------------
% decal=100;
% figure(3),clf
% figure(4),clf
% for i=1:12
%     tempA=Data(LFP_GlobalEffectLstd_std2(i))';
%     MsA=[tempA(:,1:size(tempA,2)-1)];
%     MsA(MsA>lim(i))=nan;
%     MsA(MsA<-lim(i))=nan;
%     
%     tempB=Data(LFP_GlobalEffectLstd_dvt2(i))';
%     MsB=[tempB(:,1:size(tempB,2)-1)];
%     MsB(MsB>lim(i))=nan;
%     MsB(MsB<-lim(i))=nan;
%     
%     [Ma,S1,Ea]=MeanDifNan(RemoveNan(MsA));
%     [Mb,S2,Eb]=MeanDifNan(RemoveNan(MsB));
%     Mdiff=Ma-Mb;
%     
%     [h,p]=ttest2(RemoveNan(MsA),RemoveNan(MsB));
%     
%     rg=Range(LFP_GlobalEffectLstd_std2(i),'ms');
%     pr=rescale(p,100, -120);
%     tps=Range(LFP_GlobalEffectLstd_std2(i),'ms');
%     
%     figure(3),hold on, plot(tps(1:end-1),i*decal+SmoothDec((Mdiff),smo),'k','linewidth',1),
%     hold on, plot(rg(p<pval),i*decal+pr(p<pval),'rx')
%     ylabel('Global effect local std')
%     figure(4),hold on, plot(tps(1:end-1),i*decal+SmoothDec((abs(Mdiff)),smo),'b','linewidth',1),
%     hold on, plot(rg(p<pval),i*decal+pr(p<pval),'rx')
%     ylabel('Global effect local std')
% end
% 
%     figure(3)
%     for a=0:150:600
%         hold on, plot(a,min(axis):max(axis),'b','linewidth',1);
%     end
%     figure(4)
%         for a=0:150:600
%         hold on, plot(a,min(axis):max(axis),'b','linewidth',1);
%         end
%         
%         
% decal=100;
% figure(5),clf
% figure(6),clf
% for i=1:12
%     tempA=Data(LFP_GlobalEffectLdvt_std2(i))';
%     MsA=[tempA(:,1:size(tempA,2)-1)];
%     MsA(MsA>lim(i))=nan;
%     MsA(MsA<-lim(i))=nan;
%     
%     tempB=Data(LFP_GlobalEffectLdvt_dvt2(i))';
%     MsB=[tempB(:,1:size(tempB,2)-1)];
%     MsB(MsB>lim(i))=nan;
%     MsB(MsB<-lim(i))=nan;
%     
%     [Ma,S1,Ea]=MeanDifNan(RemoveNan(MsA));
%     [Mb,S2,Eb]=MeanDifNan(RemoveNan(MsB));
%     Mdiff=Ma-Mb;
%     
%     [h,p]=ttest2(RemoveNan(MsA),RemoveNan(MsB));
%     
%     rg=Range(LFP_GlobalEffectLdvt_std2(i),'ms');
%     pr=rescale(p,100, -120);
%     tps=Range(LFP_GlobalEffectLdvt_std2(i),'ms');
%     
%     figure(5),hold on, plot(tps(1:end-1),i*decal+SmoothDec((Mdiff),smo),'k','linewidth',1),
%     hold on, plot(rg(p<pval),i*decal+pr(p<pval),'rx')
%     ylabel('Global effect local dvt')
%     figure(6),hold on, plot(tps(1:end-1),i*decal+SmoothDec((abs(Mdiff)),smo),'b','linewidth',1),
%     hold on, plot(rg(p<pval),i*decal+pr(p<pval),'rx')
%     ylabel('Global effect local dvt')
% end
% 
%     figure(5)
%     for a=0:150:600
%         hold on, plot(a,min(axis):max(axis),'b','linewidth',1);
%     end
%     figure(6)
%         for a=0:150:600
%         hold on, plot(a,min(axis):max(axis),'b','linewidth',1);
%         end
% 
% 
% 
% %---------------------------------------------------------------------------
% %<><><><><><><><><><><><><><> Omission Effect <><><><><><><><><><><><><><><
% %--------------------------------------------------------------------------- 
% decal=100;
% figure(7),clf
% figure(8),clf
% for i=1:12
%     tempA=Data(LFP_OmissionEffect_std2(i))';
%     MsA=[tempA(:,1:size(tempA,2)-1)];
%     MsA(MsA>lim(i))=nan;
%     MsA(MsA<-lim(i))=nan;
%     
%     tempB=Data(LFP_OmissionEffect_dvt2(i))';
%     MsB=[tempB(:,1:size(tempB,2)-1)];
%     MsB(MsB>lim(i))=nan;
%     MsB(MsB<-lim(i))=nan;
%     
%     [Ma,S1,Ea]=MeanDifNan(RemoveNan(MsA));
%     [Mb,S2,Eb]=MeanDifNan(RemoveNan(MsB));
%     Mdiff=Ma-Mb;
%     
%     [h,p]=ttest2(RemoveNan(MsA),RemoveNan(MsB));
%     
%     rg=Range(LFP_OmissionEffect_std2(i),'ms');
%     pr=rescale(p,100, -120);
%     tps=Range(LFP_OmissionEffect_std2(i),'ms');
%     
%     figure(7),hold on, plot(tps(1:end-1),i*decal+SmoothDec((Mdiff),smo),'k','linewidth',1),
%     hold on, plot(rg(p<pval),i*decal+pr(p<pval),'rx')
%     ylabel('Omission effect')
%     figure(8),hold on, plot(tps(1:end-1),i*decal+SmoothDec((abs(Mdiff)),smo),'b','linewidth',1),
%     hold on, plot(rg(p<pval),i*decal+pr(p<pval),'rx')
%     ylabel('Omission effect')
% end
% 
%     figure(7)
%     for a=0:150:600
%         hold on, plot(a,min(axis):max(axis),'b','linewidth',1);
%     end
%     figure(8)
%         for a=0:150:600
%         hold on, plot(a,min(axis):max(axis),'b','linewidth',1);
%         end

    