%GenerateMLocaGlobal


rg=Range(LFP{1});
EpochOK=intervalSet(rg(1),rg(end));


for i=1:length(LFP)
    
figure, [fh, rasterAx, histAx, matVal1] = ImagePETH(LFP{i}, Restrict(ts(TStdXX),EpochOK), -10000, +20000,'BinSize',500);close
figure, [fh, rasterAx, histAx, matVal2] = ImagePETH(LFP{i}, Restrict(ts(TDevXX),EpochOK), -10000, +20000,'BinSize',500);close
figure, [fh, rasterAx, histAx, matVal3] = ImagePETH(LFP{i}, Restrict(ts(TStdXY),EpochOK), -10000, +20000,'BinSize',500);close
figure, [fh, rasterAx, histAx, matVal4] = ImagePETH(LFP{i}, Restrict(ts(TDevXY),EpochOK), -10000, +20000,'BinSize',500);close
figure, [fh, rasterAx, histAx, matVal5] = ImagePETH(LFP{i}, Restrict(ts(TlocalSTD),EpochOK), -10000, +20000,'BinSize',500);close
figure, [fh, rasterAx, histAx, matVal6] = ImagePETH(LFP{i}, Restrict(ts(TlocalDEV),EpochOK), -10000, +20000,'BinSize',500);close
figure, [fh, rasterAx, histAx, matVal7] = ImagePETH(LFP{i}, Restrict(ts(TglobalSTD),EpochOK), -10000, +20000,'BinSize',500);close
figure, [fh, rasterAx, histAx, matVal8] = ImagePETH(LFP{i}, Restrict(ts(TglobalDEV),EpochOK), -10000, +20000,'BinSize',500);close


MlocalstdXXXX{i}=Data(matVal1)';
MlocaldevXXXX{i}=Data(matVal2)';
MlocalstdXXXY{i}=Data(matVal3)';
MlocaldevXXXY{i}=Data(matVal4)';
Mlocalstd{i}=Data(matVal5)';
Mlocaldev{i}=Data(matVal6)';
Mglobalstd{i}=Data(matVal7)';
Mglobaldev{i}=Data(matVal8)';

end
tps=Range(matVal8,'s');

save MatLocalGlobal10000  -v7.3 tps MlocalstdXXXX MlocaldevXXXX MlocalstdXXXY MlocaldevXXXY Mlocalstd Mlocaldev Mglobalstd Mglobaldev

