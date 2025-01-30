%CodeBulbMarie1


%--------------------------------------------------------------------------

voieLFPwt=16; %auditif
voieEEGwt=15; %auditif

voieLFPwt=13; %par
voieEEGwt=12; %par

% voieLFPwt=10; % Pfc
% voieEEGwt=[]; % Pfc

voieBulbwt=1; 

%--------------------------------------------------------------------------

voieLFPdoKO=14; %auditif
voieEEGdoKO=13; %auditif

% voieLFPdoKO=11; %Par
% voieEEGdoKO=[]; %Par

% voieLFPdoKO=9; %Pfc
% voieEEGdoKO=[]; %Pfc

voieBulbdoKO=1;

%--------------------------------------------------------------------------
%--------------------------------------------------------------------------
%--------------------------------------------------------------------------

EpochPostWT2=intervalSet(Start(EpochPostWT), Start(EpochPostWT)+1500*1E4);

%Mouse 052
[DtDOKOpre,DpDOKOpre,SpDOKOpre,RiDOKOpre]=IdentifyDeltaSpindlesRipples(Restrict(LFPdoKO,EpochPreDoKO),voieLFPdoKO,voieEEGdoKO,8000,0);
[DtDOKOpost,DpDOKOpost,SpDOKOpost,RiDOKOpost]=IdentifyDeltaSpindlesRipples(Restrict(LFPdoKO,EpochPostDoKO),voieLFPdoKO,voieEEGdoKO,8000,0);

%Mouse 051
[DtWTpre,DpWTpre,SpWTpre,RiWTpre]=IdentifyDeltaSpindlesRipples(Restrict(LFPwt,EpochPreWT),voieLFPwt,voieEEGwt,8000,0);
[DtWTpost,DpWTpost,SpWTpost,RiWTpost]=IdentifyDeltaSpindlesRipples(Restrict(LFPwt,EpochPostWT2),voieLFPwt,voieEEGwt,8000,0);



%--------------------------------------------------------------------------
%--------------------------------------------------------------------------
%--------------------------------------------------------------------------

figure, [fh, rasterAx, histAx, matVal1a] = ImagePETH(LFPdoKO{voieLFPdoKO}, DpDOKOpre, -15000, +15000,'BinSize',500);close
try
    figure, [fh, rasterAx, histAx, matVal2a] = ImagePETH(LFPdoKO{voieEEGdoKO}, DpDOKOpre, -15000, +15000,'BinSize',500);close
catch
    close
end
figure, [fh, rasterAx, histAx, matVal3a] = ImagePETH(LFPdoKO{9}, DpDOKOpre, -15000, +15000,'BinSize',500);close
figure, [fh, rasterAx, histAx, matVal4a] = ImagePETH(LFPdoKO{1}, DpDOKOpre, -15000, +15000,'BinSize',500);close
figure, [fh, rasterAx, histAx, matVal5a] = ImagePETH(LFPdoKO{voieLFPdoKO}, DpDOKOpost, -15000, +15000,'BinSize',500);close
try
figure, [fh, rasterAx, histAx, matVal6a] = ImagePETH(LFPdoKO{voieEEGdoKO}, DpDOKOpost, -15000, +15000,'BinSize',500);close
catch
    close
end
figure, [fh, rasterAx, histAx, matVal7a] = ImagePETH(LFPdoKO{9}, DpDOKOpost, -15000, +15000,'BinSize',500);close
figure, [fh, rasterAx, histAx, matVal8a] = ImagePETH(LFPdoKO{1}, DpDOKOpost, -15000, +15000,'BinSize',500);close

%--------------------------------------------------------------------------

figure, [fh, rasterAx, histAx, matVal1b] = ImagePETH(LFPwt{voieLFPwt}, DpWTpre, -15000, +15000,'BinSize',500);close
try
    figure, [fh, rasterAx, histAx, matVal2b] = ImagePETH(LFPwt{voieEEGwt}, DpWTpre, -15000, +15000,'BinSize',500);close
catch
    close
end
figure, [fh, rasterAx, histAx, matVal3b] = ImagePETH(LFPwt{11}, DpWTpre, -15000, +15000,'BinSize',500);close
figure, [fh, rasterAx, histAx, matVal4b] = ImagePETH(LFPwt{1}, DpWTpre, -15000, +15000,'BinSize',500);close
figure, [fh, rasterAx, histAx, matVal5b] = ImagePETH(LFPwt{voieLFPwt}, DpWTpost, -15000, +15000,'BinSize',500);close
try
    figure, [fh, rasterAx, histAx, matVal6b] = ImagePETH(LFPwt{voieEEGwt}, DpWTpost, -15000, +15000,'BinSize',500);close
catch
    close
end
figure, [fh, rasterAx, histAx, matVal7b] = ImagePETH(LFPwt{11}, DpWTpost, -15000, +15000,'BinSize',500);close
figure, [fh, rasterAx, histAx, matVal8b] = ImagePETH(LFPwt{1}, DpWTpost, -15000, +15000,'BinSize',500);close

%--------------------------------------------------------------------------
%--------------------------------------------------------------------------
%--------------------------------------------------------------------------

figure('color',[1 1 1]),
subplot(2,1,1), plot(Range(matVal1a,'ms'),mean(Data(matVal1a)'),'g','linewidth',2)
hold on, plot(Range(matVal2a,'ms'),mean(Data(matVal2a)'),'k')
hold on, plot(Range(matVal3a,'ms'),mean(Data(matVal3a)'),'r')
hold on, plot(Range(matVal1a,'ms'),mean(Data(matVal4a)'),'b'), ylim([-4000 5000])
title('Mouse DoKO')

subplot(2,1,2), plot(Range(matVal5a,'ms'),mean(Data(matVal5a)'),'g','linewidth',2)
hold on, plot(Range(matVal6a,'ms'),mean(Data(matVal6a)'),'k')
hold on, plot(Range(matVal7a,'ms'),mean(Data(matVal7a)'),'r')
hold on, plot(Range(matVal8a,'ms'),mean(Data(matVal8a)'),'b'), ylim([-4000 5000])

figure('color',[1 1 1]),
subplot(2,1,1), plot(Range(matVal1b,'ms'),mean(Data(matVal1b)'),'g','linewidth',2)
hold on, plot(Range(matVal2b,'ms'),mean(Data(matVal2b)'),'k')
hold on, plot(Range(matVal3b,'ms'),mean(Data(matVal3b)'),'r')
hold on, plot(Range(matVal4b,'ms'),mean(Data(matVal4b)'),'b'), ylim([-4000 5000])
title('Mouse WT')

subplot(2,1,2), plot(Range(matVal5b,'ms'),mean(Data(matVal5b)'),'g','linewidth',2)
hold on, plot(Range(matVal6b,'ms'),mean(Data(matVal6b)'),'k')
hold on, plot(Range(matVal7b,'ms'),mean(Data(matVal7b)'),'r')
hold on, plot(Range(matVal8b,'ms'),mean(Data(matVal8b)'),'b'), ylim([-4000 5000])



%--------------------------------------------------------------------------
%--------------------------------------------------------------------------
%--------------------------------------------------------------------------
% 
% figure, [fh, rasterAx, histAx, matVal1c] = ImagePETH(LFPdoKO{14}, DtDOKOpre, -15000, +15000,'BinSize',500);close
% figure, [fh, rasterAx, histAx, matVal2c] = ImagePETH(LFPdoKO{13}, DtDOKOpre, -15000, +15000,'BinSize',500);close
% figure, [fh, rasterAx, histAx, matVal3c] = ImagePETH(LFPdoKO{9}, DtDOKOpre, -15000, +15000,'BinSize',500);close
% figure, [fh, rasterAx, histAx, matVal4c] = ImagePETH(LFPdoKO{1}, DtDOKOpre, -15000, +15000,'BinSize',500);close
% figure, [fh, rasterAx, histAx, matVal5c] = ImagePETH(LFPdoKO{14}, DtDOKOpost, -15000, +15000,'BinSize',500);close
% figure, [fh, rasterAx, histAx, matVal6c] = ImagePETH(LFPdoKO{13}, DtDOKOpost, -15000, +15000,'BinSize',500);close
% figure, [fh, rasterAx, histAx, matVal7c] = ImagePETH(LFPdoKO{9}, DtDOKOpost, -15000, +15000,'BinSize',500);close
% figure, [fh, rasterAx, histAx, matVal8c] = ImagePETH(LFPdoKO{1}, DtDOKOpost, -15000, +15000,'BinSize',500);close
% 
% %--------------------------------------------------------------------------
% 
% figure, [fh, rasterAx, histAx, matVal1d] = ImagePETH(LFPwt{16}, DtWTpre, -15000, +15000,'BinSize',500);close
% figure, [fh, rasterAx, histAx, matVal2d] = ImagePETH(LFPwt{15}, DtWTpre, -15000, +15000,'BinSize',500);close
% figure, [fh, rasterAx, histAx, matVal3d] = ImagePETH(LFPwt{11}, DtWTpre, -15000, +15000,'BinSize',500);close
% figure, [fh, rasterAx, histAx, matVal4d] = ImagePETH(LFPwt{1}, DtWTpre, -15000, +15000,'BinSize',500);close
% figure, [fh, rasterAx, histAx, matVal5d] = ImagePETH(LFPwt{16}, DtWTpost, -15000, +15000,'BinSize',500);close
% figure, [fh, rasterAx, histAx, matVal6d] = ImagePETH(LFPwt{15}, DtWTpost, -15000, +15000,'BinSize',500);close
% figure, [fh, rasterAx, histAx, matVal7d] = ImagePETH(LFPwt{11}, DtWTpost, -15000, +15000,'BinSize',500);close
% figure, [fh, rasterAx, histAx, matVal8d] = ImagePETH(LFPwt{1}, DtWTpost, -15000, +15000,'BinSize',500);close
% 
% %--------------------------------------------------------------------------
% %--------------------------------------------------------------------------
% %--------------------------------------------------------------------------
% 
% figure('color',[1 1 1]),
% subplot(2,1,1), plot(Range(matVal1c,'ms'),mean(Data(matVal1c)'),'g','linewidth',2)
% hold on, plot(Range(matVal1c,'ms'),mean(Data(matVal2c)'),'k')
% hold on, plot(Range(matVal1c,'ms'),mean(Data(matVal3c)'),'r')
% hold on, plot(Range(matVal1c,'ms'),mean(Data(matVal4c)'),'b'), ylim([-4000 5000])
% 
% subplot(2,1,2), plot(Range(matVal1c,'ms'),mean(Data(matVal5c)'),'g','linewidth',2)
% hold on, plot(Range(matVal1c,'ms'),mean(Data(matVal6c)'),'k')
% hold on, plot(Range(matVal1c,'ms'),mean(Data(matVal7c)'),'r')
% hold on, plot(Range(matVal1c,'ms'),mean(Data(matVal8c)'),'b'), ylim([-4000 5000])
% 
% figure('color',[1 1 1]),
% subplot(2,1,1), plot(Range(matVal1d,'ms'),mean(Data(matVal1d)'),'g','linewidth',2)
% hold on, plot(Range(matVal1d,'ms'),mean(Data(matVal2d)'),'k')
% hold on, plot(Range(matVal1d,'ms'),mean(Data(matVal3d)'),'r')
% hold on, plot(Range(matVal1d,'ms'),mean(Data(matVal4d)'),'b'), ylim([-4000 5000])
% 
% subplot(2,1,2), plot(Range(matVal5d,'ms'),mean(Data(matVal5d)'),'g','linewidth',2)
% hold on, plot(Range(matVal5d,'ms'),mean(Data(matVal6d)'),'k')
% hold on, plot(Range(matVal5d,'ms'),mean(Data(matVal7d)'),'r')
% hold on, plot(Range(matVal5d,'ms'),mean(Data(matVal8d)'),'b'), ylim([-4000 5000])
% 


%--------------------------------------------------------------------------
%--------------------------------------------------------------------------
%--------------------------------------------------------------------------


figure, [fh, rasterAx, histAx, matVal1c] = ImagePETH(LFPdoKO{voieLFPdoKO}, SpDOKOpre, -15000, +15000,'BinSize',500);close
try
    figure, [fh, rasterAx, histAx, matVal2c] = ImagePETH(LFPdoKO{voieEEGdoKO}, SpDOKOpre, -15000, +15000,'BinSize',500);close
catch
    close
end
figure, [fh, rasterAx, histAx, matVal3c] = ImagePETH(LFPdoKO{9}, SpDOKOpre, -15000, +15000,'BinSize',500);close
figure, [fh, rasterAx, histAx, matVal4c] = ImagePETH(LFPdoKO{1}, SpDOKOpre, -15000, +15000,'BinSize',500);close
figure, [fh, rasterAx, histAx, matVal5c] = ImagePETH(LFPdoKO{voieLFPdoKO}, SpDOKOpost, -15000, +15000,'BinSize',500);close
try
figure, [fh, rasterAx, histAx, matVal6c] = ImagePETH(LFPdoKO{voieEEGdoKO}, SpDOKOpost, -15000, +15000,'BinSize',500);close
catch
    close
end
figure, [fh, rasterAx, histAx, matVal7c] = ImagePETH(LFPdoKO{9}, SpDOKOpost, -15000, +15000,'BinSize',500);close
figure, [fh, rasterAx, histAx, matVal8c] = ImagePETH(LFPdoKO{1}, SpDOKOpost, -15000, +15000,'BinSize',500);close

%--------------------------------------------------------------------------

figure, [fh, rasterAx, histAx, matVal1d] = ImagePETH(LFPwt{voieLFPwt}, SpWTpre, -15000, +15000,'BinSize',500);close
try
    figure, [fh, rasterAx, histAx, matVal2d] = ImagePETH(LFPwt{voieEEGwt}, SpWTpre, -15000, +15000,'BinSize',500);close
catch
    close
end
figure, [fh, rasterAx, histAx, matVal3d] = ImagePETH(LFPwt{11}, SpWTpre, -15000, +15000,'BinSize',500);close
figure, [fh, rasterAx, histAx, matVal4d] = ImagePETH(LFPwt{1}, SpWTpre, -15000, +15000,'BinSize',500);close
figure, [fh, rasterAx, histAx, matVal5d] = ImagePETH(LFPwt{voieLFPwt}, SpWTpost, -15000, +15000,'BinSize',500);close
try
    figure, [fh, rasterAx, histAx, matVal6d] = ImagePETH(LFPwt{voieEEGwt}, SpWTpost, -15000, +15000,'BinSize',500);close
catch
    close
end
figure, [fh, rasterAx, histAx, matVal7d] = ImagePETH(LFPwt{11}, SpWTpost, -15000, +15000,'BinSize',500);close
figure, [fh, rasterAx, histAx, matVal8d] = ImagePETH(LFPwt{1}, SpWTpost, -15000, +15000,'BinSize',500);close

%--------------------------------------------------------------------------
%--------------------------------------------------------------------------
%--------------------------------------------------------------------------

figure('color',[1 1 1]),
subplot(2,1,1), plot(Range(matVal1c,'ms'),mean(Data(matVal1c)'),'g','linewidth',2)
hold on, plot(Range(matVal2c,'ms'),mean(Data(matVal2c)'),'k')
hold on, plot(Range(matVal3c,'ms'),mean(Data(matVal3c)'),'r')
hold on, plot(Range(matVal4c,'ms'),mean(Data(matVal4c)'),'b'), ylim([-4000 5000]), xlim([-500 500])
title('Mouse DoKO')

subplot(2,1,2), plot(Range(matVal5c,'ms'),mean(Data(matVal5c)'),'g','linewidth',2), xlim([-500 500])
hold on, plot(Range(matVal6c,'ms'),mean(Data(matVal6c)'),'k')
hold on, plot(Range(matVal7c,'ms'),mean(Data(matVal7c)'),'r')
hold on, plot(Range(matVal8c,'ms'),mean(Data(matVal8c)'),'b'), ylim([-4000 5000]), xlim([-500 500])

figure('color',[1 1 1]),
subplot(2,1,1), plot(Range(matVal1d,'ms'),mean(Data(matVal1d)'),'g','linewidth',2)
hold on, plot(Range(matVal2d,'ms'),mean(Data(matVal2d)'),'k')
hold on, plot(Range(matVal3d,'ms'),mean(Data(matVal3d)'),'r')
hold on, plot(Range(matVal4d,'ms'),mean(Data(matVal4d)'),'b'), ylim([-4000 5000]), xlim([-500 500])
title('Mouse WT')

subplot(2,1,2), plot(Range(matVal5d,'ms'),mean(Data(matVal5d)'),'g','linewidth',2)
hold on, plot(Range(matVal6d,'ms'),mean(Data(matVal6d)'),'k')
hold on, plot(Range(matVal7d,'ms'),mean(Data(matVal7d)'),'r')
hold on, plot(Range(matVal8d,'ms'),mean(Data(matVal8d)'),'b'), ylim([-4000 5000]), xlim([-500 500])


%--------------------------------------------------------------------------
%--------------------------------------------------------------------------
%--------------------------------------------------------------------------

[ratioWTpre,REMepochWTpre,Sp1a,t1a,f1a,rWTpre]=QuantifREMSWSPeriods(LFPwt,11,EpochPreWT,2.3);
[ratioKOpre,REMepochKOpre,Sp2a,t2a,f2a,rKOpre]=QuantifREMSWSPeriods(LFPdoKO,13,EpochPreDoKO,2.3);

[ratioWTpost,REMepochWTpost,Sp1b,t1b,f1b,rWTpost]=QuantifREMSWSPeriods(LFPwt,11,EpochPostWT,2.3);
[ratioKOpost,REMepochKOpost,Sp2b,t2b,f2b,rKOpost]=QuantifREMSWSPeriods(LFPdoKO,13,subset(EpochPostDoKO,1),2.3);

[ratioKOpostBis,REMepochKOpostBis,Sp2cBis,t2cBis,f2cBis,rKOpostBis]=QuantifREMSWSPeriods(LFPdoKO,13,subset(EpochPostDoKO,1),2.3);
[ratioKOpostTer,REMepochKOpostTer,Sp2dBis,t2dBis,f2dBis,rKOpostTer]=QuantifREMSWSPeriods(LFPdoKO,13,subset(EpochPostDoKO,2),2.3);



params.Fs=1250;
params.trialave=0;
params.err=[1 0.0500];
params.pad=2;
params.fpass=[0 30];
%params.tapers=[1 2];
movingwin=[3 0.2];
params.tapers=[3 5];

[Sp1a,t1a,f1a]=mtspecgramc(Data(Restrict(LFPwt{1},EpochPreWT)),movingwin,params);
[Sp2a,t2a,f2a]=mtspecgramc(Data(Restrict(LFPdoKO{1},EpochPreDoKO)),movingwin,params);


[Sp1b,t1b,f1b]=mtspecgramc(Data(Restrict(LFPwt{1},EpochPostWT)),movingwin,params);
[Sp2b,t2b,f2b]=mtspecgramc(Data(Restrict(LFPdoKO{1},EpochPostDoKO)),movingwin,params);

[Sp2c,t2c,f2c]=mtspecgramc(Data(Restrict(LFPdoKO{1},subset(EpochPostDoKO,1))),movingwin,params);
[Sp2d,t2d,f2d]=mtspecgramc(Data(Restrict(LFPdoKO{1},subset(EpochPostDoKO,2))),movingwin,params);



figure('color',[1 1 1]),hold on, 
plot(f1a,mean(10*log10(Sp1a)),'k','linewidth',2),caxis([27.3 80.4])
plot(f2a,mean(10*log10(Sp2a)),'r','linewidth',2)
title('Mouse WT (black), doKO (red)')

figure('color',[1 1 1]),hold on, 
plot(f1b,mean(10*log10(Sp1b)),'k','linewidth',2),caxis([27.3 80.4])
plot(f2b,mean(10*log10(Sp2b)),'r','linewidth',2)
title('Mouse WT (black), doKO (red), after DPCPX')

figure('color',[1 1 1]),hold on, 
plot(f1a,mean(10*log10(Sp1a)),'k','linewidth',2),caxis([27.3 80.4])
plot(f1b,mean(10*log10(Sp1b(1:size(Sp1b,1)/2,:))),'r','linewidth',2)
plot(f1b,mean(10*log10(Sp1b(size(Sp1b,1)/2:end,:))),'m','linewidth',2)
title('Mouse WT before, (black), after DPCPX (red), later after DPCPX (magenta)')

figure('color',[1 1 1]),hold on, 
plot(f1a,mean(10*log10(Sp1a)),'k','linewidth',2),caxis([27.3 80.4])
plot(f1b,mean(10*log10(Sp1b)),'r','linewidth',2)
title('Mouse WT before, (black), after DPCPX (red)')


figure('color',[1 1 1]),hold on, 
plot(f2a,mean(10*log10(Sp2a)),'k','linewidth',2),caxis([27.3 80.4])
plot(f2b,mean(10*log10(Sp2b)),'r','linewidth',2)
plot(f2c,mean(10*log10(Sp2c)),'m','linewidth',2)
title('Mouse DoKO before, (black), after DPCPX (red), later after DPCPX (magenta)')


figure('color',[1 1 1]), imagesc(t1a+Start(EpochPreWT,'s'),f1a,10*log10(Sp1a')), axis xy, title('Mouse WT')
hold on, plot(Range(Restrict(Vwt,EpochPreWT),'s'),20+Data(Restrict(Vwt,EpochPreWT))/10,'k')

figure('color',[1 1 1]), imagesc(t2a+Start(EpochPreDoKO,'s'),f2a,10*log10(Sp2a')), axis xy, title('Mouse DoKO')
hold on, plot(Range(Restrict(VdoKO,EpochPreDoKO),'s'),20+Data(Restrict(VdoKO,EpochPreDoKO))/10,'k')

figure('color',[1 1 1]), imagesc(t1b+Start(EpochPostWT,'s'),f1b,10*log10(Sp1b')), axis xy, title('Mouse WT, after DPCPX')
hold on, plot(Range(Restrict(Vwt,EpochPostWT),'s'),20+Data(Restrict(Vwt,EpochPostWT))/10,'k')

st=Start(EpochPostDoKO,'s');

figure('color',[1 1 1]), imagesc(t2b+st(1),f2b,10*log10(Sp2b')), axis xy, title('Mouse DoKO, after DPCPX')
hold on, plot(Range(Restrict(VdoKO,subset(EpochPostDoKO,1)),'s'),20+Data(Restrict(VdoKO,subset(EpochPostDoKO,1)))/10,'k')

figure('color',[1 1 1]), imagesc(t2c+st(2),f2b,10*log10(Sp2c')), axis xy, title('Mouse DoKO, after DPCPX')
hold on, plot(Range(Restrict(VdoKO,subset(EpochPostDoKO,2)),'s'),20+Data(Restrict(VdoKO,subset(EpochPostDoKO,2)))/10,'k')







% 
% LFPnames{1}='Bulb';
% LFPnames{2}='Bulb';
% LFPnames{3}='Bulb';
% LFPnames{4}='Bulb';
% LFPnames{5}='Bulb';
% LFPnames{6}='Bulb';
% LFPnames{7}='Bulb';
% LFPnames{8}='Bulb';
% LFPnames{9}='Pfc LFP';
% LFPnames{10}='Pfc LFP';
% LFPnames{11}='Pfc LFP';
% LFPnames{10}='Par EEG';
% LFPnames{10}='Pfc LFP';
% LFPnames{12}='Par EEG';
% LFPnames{13}='Par LFP';
% LFPnames{14}='Par LFP';
% LFPnames{15}='Aud EEG';
% LFPnames{16}='Aud LFP';
% LFPnames{17}='Aud LFP';
% LFPnames{18}='Tha LFP';
% LFPnames{19}='Tha LFP';
% LFPnames{20}='Hpc';
% LFPnames{21}='Hpc';
% LFPnamesWt=LFPnames;
% 
% LFPnames{1}='Bulb';
% LFPnames{2}='Bulb';
% LFPnames{3}='Bulb';
% LFPnames{4}='Bulb';
% LFPnames{5}='Bulb';
% LFPnames{6}='Bulb';
% LFPnames{7}='Bulb';
% LFPnames{8}='Bulb';
% LFPnames{9}='Pfc LFP';
% LFPnames{10}='Pfc LFP';
% LFPnames{11}='Par LFP';
% LFPnames{12}='Par LFP';
% LFPnames{13}='Aud EEG';
% LFPnames{14}='Aud LFP';
% LFPnames{15}='Tha';
% LFPnames{16}='Tha';
% LFPnames{17}='Tha';
% LFPnames{18}='Hpc';
% LFPnames{19}='Hpc';
% LFPnames{20}='Hpc';
% LFPnamesDoKO=LFPnames;
% 

