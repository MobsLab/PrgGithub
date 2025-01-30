%genSpkLocalGlobal
Test=input('RasterPETH (tape 0) or ImagePETH (tape 1) ?? ');

load LocalGlobal
load SpikeData
J1=-2000;
J2=+12000;

if Test==0
    
    %------------------------------------------------------------------------------------------------------------------------
    %                                                       Spike Raster PETH
    %------------------------------------------------------------------------------------------------------------------------
    for i=1:length(S)
        figure, [fh, sq, sw, rasterAx, histAx]=RasterPETH(S{i}, ts(sort([LocalEffect_std])), J1, J2,'BinSize',800);close
        sq_Spk_Local_std{i}=sq;
        sw_Spk_Local_std{i}=sw;
        figure, [fh, sq,sw, rasterAx, histAx]=RasterPETH(S{i}, ts(sort([LocalEffect_dvt])), J1, J2,'BinSize',800);close
        sq_Spk_Local_dvt{i}=sq;
        sw_Spk_Local_dvt{i}=sw;
        figure, [fh, sq, sw, rasterAx, histAx]=RasterPETH(S{i}, ts(sort([GlobalEffectLstd_dvt])), J1, J2,'BinSize',800);close
        sq_Spk_GlobaLstd_dvt{i}=sq;
        sw_Spk_GlobaLstd_dvt{i}=sw;
        figure, [fh, sq, sw, rasterAx, histAx]=RasterPETH(S{i}, ts(sort([GlobalEffectLdvt_dvt])), J1, J2,'BinSize',800);close
        sq_Spk_GlobaLdvt_dvt{i}=sq;
        sw_Spk_GlobaLdvt_dvt{i}=sw;
        figure, [fh, sq, sw, rasterAx, histAx]=RasterPETH(S{i}, ts(sort([OmissionEffect_std])), J1, J2,'BinSize',800);close
        sq_Spk_Omission_std{i}=sq;
        sw_Spk_Omission_std{i}=sw;
        figure, [fh, sq, sw, rasterAx, histAx]=RasterPETH(S{i}, ts(sort([OmissionEffect_dvt])), J1, J2,'BinSize',800);close
        sq_Spk_Omission_dvt{i}=sq;
        sw_Spk_Omission_dvt{i}=sw;
        
        sq_Spk_GlobaLstd_std{i}=sq_Spk_Local_std{i};
        sw_Spk_GlobaLstd_std{i}=sw_Spk_Local_std{i};
        sq_Spk_GlobaLdvt_std{i}=sq_Spk_Local_dvt{i};
        sw_Spk_GlobaLdvt_std{i}=sw_Spk_Local_dvt{i};
        save SpkLocalGlobal sq_Spk_Local_std sw_Spk_Local_std sq_Spk_Local_dvt sw_Spk_Local_dvt
        save SpkLocalGlobal -append sq_Spk_GlobaLstd_std sw_Spk_GlobaLstd_std sq_Spk_GlobaLstd_dvt sw_Spk_GlobaLstd_dvt
        save SpkLocalGlobal -append sq_Spk_GlobaLdvt_std sw_Spk_GlobaLdvt_std sq_Spk_GlobaLdvt_dvt sw_Spk_GlobaLdvt_dvt
        save SpkLocalGlobal -append sq_Spk_Omission_std sw_Spk_Omission_std sq_Spk_Omission_dvt sw_Spk_Omission_dvt
        
    end
    
   
    
elseif Test==1
    %------------------------------------------------------------------------------------------------------------------------
    %                                                       Spike Raster PETH
    %------------------------------------------------------------------------------------------------------------------------
    for i=1:length(S)
        A{i}=tsdarray(S{i});
    end
    
    try
        load SpikePETH
    catch
        for i=1:length(S);
            Qs = MakeQfromS(A{i},200);
            ratek=Qs;
            rate = Data(ratek);
            ratek = tsd(Range(ratek),rate(:,1));
            figure, [fh, rasterAx, histAx, Spk_Local_std(i)] = ImagePETH(ratek, ts(sort([LocalEffect_std])), J1, J2,'BinSize',50);close
            figure, [fh, rasterAx, histAx, Spk_Local_dvt(i)] = ImagePETH(ratek, ts(sort([LocalEffect_dvt])), J1, J2,'BinSize',50);close
            figure, [fh, rasterAx, histAx, Spk_GlobaLstd_dvt(i)] = ImagePETH(ratek, ts(sort([GlobalEffectLstd_dvt])), J1, J2,'BinSize',50);close
            figure, [fh, rasterAx, histAx, Spk_GlobaLdvt_dvt(i)] = ImagePETH(ratek, ts(sort([GlobalEffectLdvt_dvt])), J1, J2,'BinSize',50);close
            figure, [fh, rasterAx, histAx, Spk_Omission_std(i)] = ImagePETH(ratek, ts(sort([OmissionEffect_std])), J1, J2,'BinSize',50);close
            figure, [fh, rasterAx, histAx, Spk_Omission_dvt(i)] = ImagePETH(ratek, ts(sort([OmissionEffect_dvt])), J1, J2,'BinSize',50);close
            Spk_GlobaLstd_std(i)=Spk_Local_std(i);
            Spk_GlobaLdvt_std(i)=Spk_Local_dvt(i);
        end
        save SpikePETH Spk_Local_std Spk_Local_dvt Spk_GlobaLstd_dvt Spk_GlobaLdvt_dvt Spk_GlobaLstd_std Spk_GlobaLdvt_std Spk_Omission_std Spk_Omission_dvt
    end
end
disp('>>>>   ')
disp('>>>>  this is the end ;) ')
disp('>>>>  ')

%------------------------------------------------------------------------------------------------------------------------


