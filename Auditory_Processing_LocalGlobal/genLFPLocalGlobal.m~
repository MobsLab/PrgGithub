%genLFPLocalGlobal

load LocalGlobal
res=pwd;
smo=2;
load([res,'/LFPData/InfoLFP']);
J1=-2000;
J2=+12000;

PostFilter=input('Is there necessary to remove noise epoch (e.g. 50Hz period) ? (y=1/n=0)     >');

if PostFilter==0
    %-----------------------------------------------------------------------------------------------------------------------------------------
    %                                                     analysis PETH without post-filtering
    %-----------------------------------------------------------------------------------------------------------------------------------------
    
    LocalEffect_std=[Event_LstdGstd_A;Event_LstdGstd_B];
    LocalEffect_dvt=[Event_LdvtGstd_A;Event_LdvtGstd_B];
    
    GlobalEffectLstd_std=[Event_LstdGstd_A;Event_LstdGstd_B];
    GlobalEffectLstd_dvt=[Event_LstdGdvt_A;Event_LstdGdvt_B];
    
    GlobalEffectLdvt_std=[Event_LdvtGstd_A;Event_LdvtGstd_B];
    GlobalEffectLdvt_dvt=[Event_LdvtGdvt_A;Event_LdvtGdvt_B];
    
    OmissionEffect_std=[Event_OmiFreq_A;Event_OmiFreq_B];
    OmissionEffect_dvt=[Event_OmiRare_A;Event_OmiRare_B];
    
    
    i=1;
    for num=0:length(InfoLFP.structure)-1;
        clear LFP
        load([res,'/LFPData/LFP',num2str(num)]);
        LFP2=ResampleTSD(LFP,500);
        
        figure, [fh, rasterAx, histAx, LFP_LocalEffect_std(i)]=ImagePETH(LFP2, ts(sort([LocalEffect_std])), J1, J2,'BinSize',800);close
        figure, [fh, rasterAx, histAx, LFP_LocalEffect_dvt(i)]=ImagePETH(LFP2, ts(sort([LocalEffect_dvt])), J1, J2,'BinSize',800);close
        figure, [fh, rasterAx, histAx, LFP_GlobalEffectLstd_dvt(i)]=ImagePETH(LFP2, ts(sort([GlobalEffectLstd_dvt])), J1, J2,'BinSize',800);close
        figure, [fh, rasterAx, histAx, LFP_GlobalEffectLdvt_dvt(i)]=ImagePETH(LFP2, ts(sort([GlobalEffectLdvt_dvt])), J1, J2,'BinSize',800);close
        figure, [fh, rasterAx, histAx, LFP_OmissionEffect_std(i)]=ImagePETH(LFP2, ts(sort([OmissionEffect_std])), J1, J2,'BinSize',800);close
        figure, [fh, rasterAx, histAx, LFP_OmissionEffect_dvt(i)]=ImagePETH(LFP2, ts(sort([OmissionEffect_dvt])), J1, J2,'BinSize',800);close
        LFP_GlobalEffectLstd_std(i)=LFP_LocalEffect_std(i);
        LFP_GlobalEffectLdvt_std(i)=LFP_LocalEffect_dvt(i);
        i=i+1;
    end
    
    save LFPLocalGlobal LFP_LocalEffect_std LFP_LocalEffect_dvt LFP_GlobalEffectLstd_std LFP_GlobalEffectLstd_dvt
    save LFPLocalGlobal -append LFP_GlobalEffectLdvt_std LFP_GlobalEffectLdvt_dvt LFP_OmissionEffect_std LFP_OmissionEffect_dvt
    
elseif PostFilter==1
    %-----------------------------------------------------------------------------------------------------------------------------------------
    %                                                     analysis PETH without post-filtering
    %-----------------------------------------------------------------------------------------------------------------------------------------
    noise=input('select a channel high noise period to remove:');
    
    load([res,'/LFPData/LFP',num2str(noise)]);
    Fil=FilterLFP(LFP,[45 55],512);
    h=hilbert(Data(Fil));
    Pourri=tsd(Range(Fil),abs(h));
    FiftyHz=thresholdIntervals(Pourri,800,'Direction','Above');
    FiftyHz=mergeCloseIntervals(FiftyHz,4E4);
    FiftyHz=intervalSet(Start(FiftyHz)-1E4,End(FiftyHz)+1E4);
    FiftyHz=mergeCloseIntervals(FiftyHz,4E4);
    
    rgt=Range(LFP);
    EpochT=intervalSet(rgt(1),rgt(end));
    GoodPeriods=EpochT-FiftyHz;
    
    
    LocalEffect_std=[Event_LstdGstd_A;Event_LstdGstd_B];
    LocalEffect_dvt=[Event_LdvtGstd_A;Event_LdvtGstd_B];
    
    GlobalEffectLstd_std=[Event_LstdGstd_A;Event_LstdGstd_B];
    GlobalEffectLstd_dvt=[Event_LstdGdvt_A;Event_LstdGdvt_B];
    
    GlobalEffectLdvt_std=[Event_LdvtGstd_A;Event_LdvtGstd_B];
    GlobalEffectLdvt_dvt=[Event_LdvtGdvt_A;Event_LdvtGdvt_B];
    
    OmissionEffect_std=[Event_OmiFreq_A;Event_OmiFreq_B];
    OmissionEffect_dvt=[Event_OmiRare_A;Event_OmiRare_B];
    
    
    i=1;
    for num=0:length(InfoLFP.structure)-1;
        clear LFP
        load([res,'/LFPData/LFP',num2str(num)]);
        LFP2=ResampleTSD(LFP,500);
        
        figure, [fh, rasterAx, histAx, LFP_LocalEffect_std(i)]=ImagePETH(LFP2, Restrict(ts(sort([LocalEffect_std])),GoodPeriods), J1, J2,'BinSize',800);close
        figure, [fh, rasterAx, histAx, LFP_LocalEffect_dvt(i)]=ImagePETH(LFP2, Restrict(ts(sort([LocalEffect_dvt])),GoodPeriods), J1, J2,'BinSize',800);close
        figure, [fh, rasterAx, histAx, LFP_GlobalEffectLstd_dvt(i)]=ImagePETH(LFP2, Restrict(ts(sort([GlobalEffectLstd_dvt])),GoodPeriods), J1, J2,'BinSize',800);close
        figure, [fh, rasterAx, histAx, LFP_GlobalEffectLdvt_dvt(i)]=ImagePETH(LFP2, Restrict(ts(sort([GlobalEffectLdvt_dvt])),GoodPeriods), J1, J2,'BinSize',800);close
        figure, [fh, rasterAx, histAx, LFP_OmissionEffect_std(i)]=ImagePETH(LFP2, Restrict(ts(sort([OmissionEffect_std])),GoodPeriods), J1, J2,'BinSize',800);close
        figure, [fh, rasterAx, histAx, LFP_OmissionEffect_dvt(i)]=ImagePETH(LFP2, Restrict(ts(sort([OmissionEffect_dvt])),GoodPeriods), J1, J2,'BinSize',800);close
        LFP_GlobalEffectLstd_std(i)=LFP_LocalEffect_std(i);
        LFP_GlobalEffectLdvt_std(i)=LFP_LocalEffect_dvt(i);
        i=i+1;
    end
    
    save LFPLocalGlobalGoodPeriod LFP_LocalEffect_std LFP_LocalEffect_dvt LFP_GlobalEffectLstd_std LFP_GlobalEffectLstd_dvt
    save LFPLocalGlobalGoodPeriod -append LFP_GlobalEffectLdvt_std LFP_GlobalEffectLdvt_dvt LFP_OmissionEffect_std LFP_OmissionEffect_dvt
    
end
%-----------------------------------------------------------------------------------------------------------------------------------------





