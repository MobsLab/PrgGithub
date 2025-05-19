%ControlRespi


%--------------------------------------------------------------------------
if 0
    
cd \\NASDELUXE\DataMOBs\DataPlethysmo\Mouse060

load('\\NASDELUXE\DataMOBs\DataPlethysmo\Mouse060\BULB-Mouse-60-03052013-01-Rest-respiration.mat')
load('\\NASDELUXE\DataMOBs\DataPlethysmo\Mouse060\BULB-Mouse-60-03052013-01-Rest-wideband.mat')
val=BULB_Mouse_60_03052013_01_Rest_wideband_Ch2.values;
inte=BULB_Mouse_60_03052013_01_Rest_wideband_Ch2.interval;
trigg2=BULB_Mouse_60_03052013_01_Rest_wideband_Ch22.times;
trigg=BULB_Mouse_60_03052013_01_Rest_respiration_Ch2.times;

end

%--------------------------------------------------------------------------

if 0
    
cd \\NASDELUXE\DataMOBs\DataPlethysmo\Mouse066

load('\\NASDELUXE\DataMOBs\DataPlethysmo\Mouse066\BULB-Mouse-66-14052013-03-Rest-respiration.mat')
load('\\NASDELUXE\DataMOBs\DataPlethysmo\Mouse066\BULB-Mouse-66-14052013-03-Rest-wideband.mat')
val=BULB_Mouse_66_14052013_03_Rest_wideband_Ch2.values;
inte=BULB_Mouse_66_14052013_03_Rest_wideband_Ch2.interval;
trigg2=BULB_Mouse_66_14052013_03_Rest_wideband_Ch22.times;

trigg=BULB_Mouse_66_14052013_03_Rest_respiration_Ch2.times;
valRespi=BULB_Mouse_66_14052013_03_Rest_respiration_Ch25.values;
inteRespi=BULB_Mouse_66_14052013_03_Rest_respiration_Ch25.interval;

end

%--------------------------------------------------------------------------
tpsRespi=([1:length(valRespi)]-1)*inteRespi;
tps=([1:length(val)]-1)*inte;

trigg=trigg(trigg<tps(end));
trigg2=trigg2(trigg2<tps(end));

trigg=trigg(trigg<tpsRespi(end));
trigg2=trigg2(trigg2<tpsRespi(end));

%--------------------------------------------------------------------------


figure('color',[1 1 1]), 
plot(([1:length(val)]-1)*inte,val)
hold on, plot(trigg,-0.49988+zeros(length(trigg),1),'ro','markerfacecolor','r')
hold on, plot(trigg2,-0.5+zeros(length(trigg2),1),'ko','markerfacecolor','k')
hold on, plot(trigg2(1:2:end),-0.5+zeros(length(trigg2(1:2:end)),1),'ko','markerfacecolor','w')
ylim([-0.5 -0.4998])
%xlim([9.5 9.6])

A=trigg;
B=trigg-trigg2(2:2:end);
slop=(B(end)-B(1))/(A(end)-A(1))
figure('color',[1 1 1]), plot(A,B,'ko-')
title(num2str(slop))
del=trigg2(1)-trigg2(2);

figure('color',[1 1 1]), 
subplot(2,2,1),plot(([1:length(val)]-1)*inte,val)
hold on, plot(trigg,-0.49988+zeros(length(trigg),1),'ro','markerfacecolor','r')
hold on, plot(trigg2,-0.5+zeros(length(trigg2),1),'ko','markerfacecolor','k')
hold on, plot(trigg2(1:2:end),-0.5+zeros(length(trigg2(1:2:end)),1),'ko','markerfacecolor','w')
ylim([-0.5 -0.4998])
xlim([trigg(1)-0.05 trigg(1)+0.1])
% title(BULB_Mouse_60_03052013_01_Rest_wideband_Ch2.title)

subplot(2,2,2),plot(([1:length(val)]-1)*inte,val)
hold on, plot(trigg,-0.49988+zeros(length(trigg),1),'ro','markerfacecolor','r')
hold on, plot(trigg2,-0.5+zeros(length(trigg2),1),'ko','markerfacecolor','k')
hold on, plot(trigg2(1:2:end),-0.5+zeros(length(trigg2(1:2:end)),1),'ko','markerfacecolor','w')
ylim([-0.5 -0.4998])
xlim([trigg(end)-0.05 trigg(end)+0.1])
% title(BULB_Mouse_60_03052013_01_Rest_wideband_Ch2.title)

subplot(2,2,3),plot(([1:length(val)]-1)*inte,val)
hold on, plot(trigg*(1-slop)+del,-0.49988+zeros(length(trigg),1),'ro','markerfacecolor','r')
hold on, plot(trigg2,-0.5+zeros(length(trigg2),1),'ko','markerfacecolor','k')
hold on, plot(trigg2(1:2:end),-0.5+zeros(length(trigg2(1:2:end)),1),'ko','markerfacecolor','w')
ylim([-0.5 -0.4998])
xlim([trigg(1)-0.05 trigg(1)+0.1])
title('corrected')

subplot(2,2,4),plot(([1:length(val)]-1)*inte,val)
hold on, plot(trigg*(1-slop)+del,-0.49988+zeros(length(trigg),1),'ro','markerfacecolor','r')
hold on, plot(trigg2,-0.5+zeros(length(trigg2),1),'ko','markerfacecolor','k')
hold on, plot(trigg2(1:2:end),-0.5+zeros(length(trigg2(1:2:end)),1),'ko','markerfacecolor','w')
ylim([-0.5 -0.4998])
xlim([trigg(end)-0.05 trigg(end)+0.1])
title('corrected')



if 0
    

            try
            rg=Range(LFP{8});
            catch
                rg=tps*1E4;
            end

                EpochT=intervalSet(0,rg(end));

             load LFPData RespiTSD

            [zeroCrossTsd,AmplitudeRespi,zeroCross,zeroMeanValue]=FindZeroCross(RespiTSD,[3.4*1E-3,10]);
            rg=Range(zeroCrossTsd,'s');
            tps=rg(1:2:end);
            tps2=rg(2:2:end);
            diftps=tps(2:end)-tps2(1:end-1);

            idsup=find(diftps>0.45);
            idinf=find(diftps<0.2);
            idint=find(diftps>0.33&diftps<0.35);
            t1=tps2(idinf(idinf>2)-1);
            t2=tps2(idsup(idsup>2)-1);
            t3=tps2(idint(idint>2)-1);

            figure('color',[1 1 1])
            hold on, plot(Range(RespiTSD,'s'),Data(RespiTSD),'r')
            plot(Range(zeroCrossTsd,'s'),zeros(length(Range(zeroCrossTsd,'s')),1),'ko')
            plot(t1,zeros(length(t1),1)+0.0001,'bo','markerfacecolor','b')
            plot(t2,zeros(length(t2),1)+0.0001,'ro','markerfacecolor','r')
            plot(t3,zeros(length(t3),1)+0.0001,'ko','markerfacecolor','y')
            plot(tps2,zeros(length(tps2),1),'ko','markerfacecolor','k')
            a=0;
            a=a+10; xlim([a a+10]), ylim([-0.0005 0.0005])

            load LFPData LFP
            load StateEpoch

            Epoch=SWSEpoch;
            Epoch=MovEpoch;

            figure, [fh, rasterAx, histAx, matVal1] = ImagePETH(RespiTSD, Restrict(ts(t1*1E4),Epoch), -5000, +5000,'BinSize',1000); title('respi short')
            figure, [fh, rasterAx, histAx, matVal2] = ImagePETH(RespiTSD, Restrict(ts(t2*1E4),Epoch), -5000, +5000,'BinSize',1000);title('respi long')
            figure, [fh, rasterAx, histAx, matVal3] = ImagePETH(RespiTSD, Restrict(ts(t3*1E4),Epoch), -5000, +5000,'BinSize',1000);title('respi medium')

            figure, [fh, rasterAx, histAx, matVal81] = ImagePETH(LFP{9}, Restrict(ts(t1*1E4),Epoch), -5000, +5000,'BinSize',1000);title('bulb short')
            figure, [fh, rasterAx, histAx, matVal82] = ImagePETH(LFP{9}, Restrict(ts(t2*1E4),Epoch), -5000, +5000,'BinSize',1000);title('bulb long')
            figure, [fh, rasterAx, histAx, matVal83] = ImagePETH(LFP{9}, Restrict(ts(t3*1E4),Epoch), -5000, +5000,'BinSize',1000);title('bulb medium')
            % 
            % figure, [fh, rasterAx, histAx, matVal61] = ImagePETH(LFP{6}, Restrict(ts(t1*1E4),Epoch), -5000, +5000,'BinSize',1000);title('Pfc short')
            % figure, [fh, rasterAx, histAx, matVal62] = ImagePETH(LFP{6}, Restrict(ts(t2*1E4),Epoch), -5000, +5000,'BinSize',1000);title('Pfc long')
            % figure, [fh, rasterAx, histAx, matVal63] = ImagePETH(LFP{6}, Restrict(ts(t3*1E4),Epoch), -5000, +5000,'BinSize',1000);title('Pfc medium')

            figure, [fh, rasterAx, histAx, matVal71] = ImagePETH(LFP{7}, Restrict(ts(t1*1E4),Epoch), -5000, +5000,'BinSize',1000);title('Pfc short')
            figure, [fh, rasterAx, histAx, matVal72] = ImagePETH(LFP{7}, Restrict(ts(t2*1E4),Epoch), -5000, +5000,'BinSize',1000);title('Pfc long')
            figure, [fh, rasterAx, histAx, matVal73] = ImagePETH(LFP{7}, Restrict(ts(t3*1E4),Epoch), -5000, +5000,'BinSize',1000);title('Pfc medium')
            % 
            % figure, [fh, rasterAx, histAx, matVal31] = ImagePETH(LFP{3}, Restrict(ts(t1*1E4),Epoch), -5000, +5000,'BinSize',1000);title('Hpc short')
            % figure, [fh, rasterAx, histAx, matVal32] = ImagePETH(LFP{3}, Restrict(ts(t2*1E4),Epoch), -5000, +5000,'BinSize',1000);title('Hpc long')
            % figure, [fh, rasterAx, histAx, matVal33] = ImagePETH(LFP{3}, Restrict(ts(t3*1E4),Epoch), -5000, +5000,'BinSize',1000);title('Hpc medium')


            %--------------------------------------------------------------------------
            %--------------------------------------------------------------------------

            M1=Data(matVal1)';
            [M1o,M1f,id1]=ReordPCA(M1,400:600);

            % 
            M2=Data(matVal2)';
            [M2o,M2f,id2]=ReordPCA(M2,400:600);
            M3=Data(matVal3)';
            [M3o,M3f,id3]=ReordPCA(M3,400:600);

            M81=Data(matVal81)';
            [M81o,M81f,id81]=ReordPCA(M81,400:600);
            M82=Data(matVal82)';
            [M82o,M82f,id82]=ReordPCA(M82,400:600);
            M83=Data(matVal83)';
            [M83o,M83f,id83]=ReordPCA(M83,400:600);

            M61=Data(matVal61)';
            [M61o,M61f,id61]=ReordPCA(M61,400:600);
            M62=Data(matVal62)';
            [M62o,M62f,id62]=ReordPCA(M62,400:600);
            M63=Data(matVal63)';
            [M63o,M63f,id63]=ReordPCA(M63,400:600);

            M71=Data(matVal71)';
            [M71o,M71f,id71]=ReordPCA(M71,400:600);
            M72=Data(matVal72)';
            [M72o,M72f,id72]=ReordPCA(M72,400:600);
            M73=Data(matVal73)';
            [M73o,M73f,id73]=ReordPCA(M73,400:600);

            M31=Data(matVal31)';
            [M31o,M31f,id31]=ReordPCA(M31,400:600);
            M32=Data(matVal32)';
            [M32o,M32f,id32]=ReordPCA(M32,400:600);
            M33=Data(matVal33)';
            [M33o,M33f,id33]=ReordPCA(M33,400:600);

            %--------------------------------------------------------------------------

            figure('color',[1 1 1]), 
            subplot(3,5,1),imagesc(Range(matVal1,'s'),1:length(id1),M1),axis xy, title('respi')
            subplot(3,5,2),imagesc(Range(matVal81,'s'),1:length(id81),M81),axis xy, title('Bulb')
            subplot(3,5,3),imagesc(Range(matVal61,'s'),1:length(id61),M61),axis xy, title('Pfc')
            subplot(3,5,4),imagesc(Range(matVal71,'s'),1:length(id71),M71),axis xy, title('Pfc')
            subplot(3,5,5),imagesc(Range(matVal31,'s'),1:length(id31),M31),axis xy, title('Hpc')

            subplot(3,5,6),imagesc(Range(matVal1,'s'),1:length(id1),M1o),axis xy
            subplot(3,5,7),imagesc(Range(matVal81,'s'),1:length(id81),M81o),axis xy
            subplot(3,5,8),imagesc(Range(matVal61,'s'),1:length(id61),M61o),axis xy
            subplot(3,5,9),imagesc(Range(matVal71,'s'),1:length(id71),M71o),axis xy
            subplot(3,5,10),imagesc(Range(matVal31,'s'),1:length(id31),M31o),axis xy

            subplot(3,5,11),imagesc(Range(matVal1,'s'),1:length(id1)*2/3,M1f),axis xy
            subplot(3,5,12),imagesc(Range(matVal81,'s'),1:length(id81)*2/3,M81f),axis xy
            subplot(3,5,13),imagesc(Range(matVal61,'s'),1:length(id61)*2/3,M61f),axis xy
            subplot(3,5,14),imagesc(Range(matVal71,'s'),1:length(id71)*2/3,M71f),axis xy
            subplot(3,5,15),imagesc(Range(matVal31,'s'),1:length(id31)*2/3,M31f),axis xy

            %--------------------------------------------------------------------------

            figure('color',[1 1 1]), 
            subplot(3,5,1),imagesc(Range(matVal2,'s'),1:length(id2),M2),axis xy, title('respi')
            subplot(3,5,2),imagesc(Range(matVal82,'s'),1:length(id82),M82),axis xy, title('Bulb')
            subplot(3,5,3),imagesc(Range(matVal62,'s'),1:length(id62),M62),axis xy, title('Pfc')
            subplot(3,5,4),imagesc(Range(matVal72,'s'),1:length(id72),M72),axis xy, title('Pfc')
            subplot(3,5,5),imagesc(Range(matVal32,'s'),1:length(id32),M32),axis xy, title('Hpc')

            subplot(3,5,6),imagesc(Range(matVal2,'s'),1:length(id2),M2o),axis xy
            subplot(3,5,7),imagesc(Range(matVal82,'s'),1:length(id82),M82o),axis xy
            subplot(3,5,8),imagesc(Range(matVal62,'s'),1:length(id62),M62o),axis xy
            subplot(3,5,9),imagesc(Range(matVal72,'s'),1:length(id72),M72o),axis xy
            subplot(3,5,10),imagesc(Range(matVal32,'s'),1:length(id32),M32o),axis xy

            subplot(3,5,11),imagesc(Range(matVal2,'s'),1:length(id2)*2/3,M2f),axis xy
            subplot(3,5,12),imagesc(Range(matVal82,'s'),1:length(id82)*2/3,M82f),axis xy
            subplot(3,5,13),imagesc(Range(matVal62,'s'),1:length(id62)*2/3,M62f),axis xy
            subplot(3,5,14),imagesc(Range(matVal72,'s'),1:length(id72)*2/3,M72f),axis xy
            subplot(3,5,15),imagesc(Range(matVal32,'s'),1:length(id32)*2/3,M32f),axis xy

            %--------------------------------------------------------------------------

            figure('color',[1 1 1]), 
            subplot(3,5,1),imagesc(Range(matVal3,'s'),1:length(id3),M2),axis xy, title('respi')
            subplot(3,5,2),imagesc(Range(matVal83,'s'),1:length(id83),M82),axis xy, title('Bulb')
            subplot(3,5,3),imagesc(Range(matVal63,'s'),1:length(id63),M62),axis xy, title('Pfc')
            subplot(3,5,4),imagesc(Range(matVal73,'s'),1:length(id73),M72),axis xy, title('Pfc')
            subplot(3,5,5),imagesc(Range(matVal33,'s'),1:length(id33),M32),axis xy, title('Hpc')

            subplot(3,5,6),imagesc(Range(matVal3,'s'),1:length(id3),M2o),axis xy
            subplot(3,5,7),imagesc(Range(matVal83,'s'),1:length(id83),M82o),axis xy
            subplot(3,5,8),imagesc(Range(matVal63,'s'),1:length(id63),M62o),axis xy
            subplot(3,5,9),imagesc(Range(matVal73,'s'),1:length(id73),M72o),axis xy
            subplot(3,5,10),imagesc(Range(matVal33,'s'),1:length(id33),M32o),axis xy

            subplot(3,5,11),imagesc(Range(matVal3,'s'),1:length(id3)*2/3,M3f),axis xy
            subplot(3,5,12),imagesc(Range(matVal83,'s'),1:length(id83)*2/3,M83f),axis xy
            subplot(3,5,13),imagesc(Range(matVal63,'s'),1:length(id63)*2/3,M63f),axis xy
            subplot(3,5,14),imagesc(Range(matVal73,'s'),1:length(id73)*2/3,M73f),axis xy
            subplot(3,5,15),imagesc(Range(matVal33,'s'),1:length(id33)*2/3,M33f),axis xy


            %--------------------------------------------------------------------------
            %--------------------------------------------------------------------------
            %--------------------------------------------------------------------------

            figure('color',[1 1 1]), 
            subplot(2,2,1), plot(Range(matVal1,'s'),mean(M1),'k','linewidth',2)
            hold on, plot(Range(matVal2,'s'),mean(Data(matVal2)'),'r','linewidth',2)
            hold on, plot(Range(matVal81,'s'),40*mean(Data(matVal81)'),'b','linewidth',2)
            hold on, plot(Range(matVal82,'s'),40*mean(Data(matVal82)'),'m','linewidth',2)
            title('Bulb')
            subplot(2,2,2), plot(Range(matVal1,'s'),mean(Data(matVal1)'),'k','linewidth',2)
            hold on, plot(Range(matVal2,'s'),mean(Data(matVal2)'),'r','linewidth',2)
            hold on, plot(Range(matVal61,'s'),100*mean(Data(matVal61)'),'b','linewidth',2)
            hold on, plot(Range(matVal62,'s'),100*mean(Data(matVal62)'),'m','linewidth',2)
            title('Pfc')
            subplot(2,2,3), plot(Range(matVal1,'s'),mean(Data(matVal1)'),'k','linewidth',2)
            hold on, plot(Range(matVal2,'s'),mean(Data(matVal2)'),'r','linewidth',2)
            hold on, plot(Range(matVal71,'s'),100*mean(Data(matVal71)'),'b','linewidth',2)
            hold on, plot(Range(matVal72,'s'),100*mean(Data(matVal72)'),'m','linewidth',2)
            title('Pfc')
            subplot(2,2,4),plot(Range(matVal1,'s'),mean(Data(matVal1)'),'k','linewidth',2)
            hold on, plot(Range(matVal2,'s'),mean(Data(matVal2)'),'r','linewidth',2)
            hold on, plot(Range(matVal31,'s'),100*mean(Data(matVal31)'),'b','linewidth',2)
            hold on, plot(Range(matVal32,'s'),100*mean(Data(matVal32)'),'m','linewidth',2)
            title('Hpc')

            figure('color',[1 1 1]), 
            subplot(2,2,1), plot(Range(matVal1,'s'),mean(Data(matVal1)'),'k','linewidth',2)
            hold on, plot(Range(matVal3,'s'),mean(Data(matVal3)'),'r','linewidth',2)
            hold on, plot(Range(matVal81,'s'),40*mean(Data(matVal81)'),'b','linewidth',2)
            hold on, plot(Range(matVal83,'s'),40*mean(Data(matVal83)'),'m','linewidth',2)
            title('Bulb')
            subplot(2,2,2), plot(Range(matVal1,'s'),mean(Data(matVal1)'),'k','linewidth',2)
            hold on, plot(Range(matVal3,'s'),mean(Data(matVal3)'),'r','linewidth',2)
            hold on, plot(Range(matVal61,'s'),100*mean(Data(matVal61)'),'b','linewidth',2)
            hold on, plot(Range(matVal63,'s'),100*mean(Data(matVal63)'),'m','linewidth',2)
            title('Pfc')
            subplot(2,2,3), plot(Range(matVal1,'s'),mean(Data(matVal1)'),'k','linewidth',2)
            hold on, plot(Range(matVal3,'s'),mean(Data(matVal3)'),'r','linewidth',2)
            hold on, plot(Range(matVal71,'s'),100*mean(Data(matVal71)'),'b','linewidth',2)
            hold on, plot(Range(matVal73,'s'),100*mean(Data(matVal73)'),'m','linewidth',2)
            title('Pfc')
            subplot(2,2,4),plot(Range(matVal1,'s'),mean(Data(matVal1)'),'k','linewidth',2)
            hold on, plot(Range(matVal3,'s'),mean(Data(matVal3)'),'r','linewidth',2)
            hold on, plot(Range(matVal31,'s'),100*mean(Data(matVal31)'),'b','linewidth',2)
            hold on, plot(Range(matVal33,'s'),100*mean(Data(matVal33)'),'m','linewidth',2)
            title('Hpc')

            
end
