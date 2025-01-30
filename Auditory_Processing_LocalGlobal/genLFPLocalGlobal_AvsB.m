%genLFPLocalGlobal_AvsB

load LocalGlobal
res=pwd;
smo=2;
load([res,'/LFPData/InfoLFP']);
J1=-2000;
J2=+12000;


%-----------------------------------------------------------------------------------------------------------------------------------------
%                                                     analysis PETH without post-filtering (tone Avs B)
%-----------------------------------------------------------------------------------------------------------------------------------------

i=1;
for num=0:length(InfoLFP.structure)-1;
    clear LFP
    load([res,'/LFPData/LFP',num2str(num)]);
    LFP2=ResampleTSD(LFP,500);
  
    figure, [fh, rasterAx, histAx, LFP_LocalEffect_std_A(i)]=ImagePETH(LFP2, ts(sort([Event_LstdGstd_A])), J1, J2,'BinSize',800);title('Event_LstdGstd');close
    figure, [fh, rasterAx, histAx, LFP_LocalEffect_dvt_A(i)]=ImagePETH(LFP2, ts(sort([Event_LdvtGstd_A])), J1, J2,'BinSize',800);title('Event_LdvtGstd');close
    figure, [fh, rasterAx, histAx, LFP_GlobalEffectLstd_dvt_A(i)]=ImagePETH(LFP2, ts(sort([Event_LstdGdvt_A])), J1, J2,'BinSize',800);title('Event_LstdGdvt');close
    figure, [fh, rasterAx, histAx, LFP_GlobalEffectLdvt_dvt_A(i)]=ImagePETH(LFP2, ts(sort([Event_LdvtGdvt_A])), J1, J2,'BinSize',800);title('Event_LdvtGdvt');close
    figure, [fh, rasterAx, histAx, OmissionEffect_std_A(i)] = ImagePETH(LFP2, ts(sort([Event_OmiFreq_A])), J1, J2,'BinSize',800);title('Event_OmiFreq');close
    figure, [fh, rasterAx, histAx, OmissionEffect_dvt_A(i)] = ImagePETH(LFP2, ts(sort([Event_OmiRare_A])), J1, J2,'BinSize',800);title('Event_OmiRare');close
    LFP_GlobalEffectLdvt_std_A(i)=LFP_LocalEffect_dvt_A(i);
    LFP_GlobalEffectLstd_std_A(i)=LFP_LocalEffect_std_A(i);
    
    figure, [fh, rasterAx, histAx, LFP_LocalEffect_std_B(i)]=ImagePETH(LFP2, ts(sort([Event_LstdGstd_B])), J1, J2,'BinSize',800);title('Event_LstdGstd');close
    figure, [fh, rasterAx, histAx, LFP_LocalEffect_dvt_B(i)]=ImagePETH(LFP2, ts(sort([Event_LdvtGstd_B])), J1, J2,'BinSize',800);title('Event_LdvtGstd');close
    figure, [fh, rasterAx, histAx, LFP_GlobalEffectLstd_dvt_B(i)]=ImagePETH(LFP2, ts(sort([Event_LstdGdvt_B])), J1, J2,'BinSize',800);title('Event_LstdGdvt');close
    figure, [fh, rasterAx, histAx, LFP_GlobalEffectLdvt_dvt_B(i)]=ImagePETH(LFP2, ts(sort([Event_LdvtGdvt_B])), J1, J2,'BinSize',800);title('Event_LdvtGdvt');close
    figure, [fh, rasterAx, histAx, OmissionEffect_std_B(i)] = ImagePETH(LFP2, ts(sort([Event_OmiFreq_B])), J1, J2,'BinSize',800);title('Event_OmiFreq');close
    figure, [fh, rasterAx, histAx, OmissionEffect_dvt_B(i)] = ImagePETH(LFP2, ts(sort([Event_OmiRare_B])), J1, J2,'BinSize',800);title('Event_OmiRare');close
    LFP_GlobalEffectLdvt_std_B(i)=LFP_LocalEffect_dvt_B(i);
    LFP_GlobalEffectLstd_std_B(i)=LFP_LocalEffect_std_B(i);
    
    i=i+1;
end

save LFPLocalGlobal_AvsB MLstdGstd_A MLdevGstd_A MLstdGdev_A MLdvtGdev_A OmiFreq_A OmiRare_A
save LFPLocalGlobal_AvsB -append MLstdGstd_B MLdevGstd_B MLstdGdev_B MLdvtGdev_B OmiFreq_B OmiRare_B



%%----------------------------------------------------------------------------------------------------------- 



