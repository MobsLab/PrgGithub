%ScaFreqLocalGlobalPCACellAssembly

Epoch=intervalSet(TglobalSTD-500,TglobalSTD+500);
%Epoch=intervalSet(0,8900*1E4);
[sigHiCo, sigLoCo, nbBinsHiCo,nbBinsLoCo,QHiCo,rHiCo,QLoCo,rLoCo,pc1hc]=PCACellAssemblyPPC(S,Epoch,50,1:2);

filenameSav='/media/HD-EG5/DataMMN/FigureSPresDehaene';

smo=1.5;
% 
% num=num+1;
sav=0;

freqSca=[2500 5000 7500 10000 12500 15000 17500];
EpochSca{1}=intervalSet(50*1E4, 200*1E4);
EpochSca{2}=intervalSet(210*1E4, 350*1E4);
EpochSca{3}=intervalSet(360*1E4, 500*1E4);
EpochSca{4}=intervalSet(510*1E4, 650*1E4);
EpochSca{5}=intervalSet(660*1E4 ,800*1E4);
EpochSca{6}=intervalSet(810*1E4 ,950*1E4);
EpochSca{7}=intervalSet(960*1E4 ,1100*1E4);


deb=6000;
fin=6000;

for i=1:7
figure('color',[1 1 1]),
[fh,sqSca{i},sweepsSca{i}] = RasterPETH(sigHiCo, Restrict(tstim1,EpochSca{i}), -deb, +fin,'BinSize',100,'Markers',{ts1},'MarkerTypes',{'c.'});title(['Cell Assembly ',num2str(freqSca(i)),' Hz'])%, close
end
timesstp=[-deb:(fin+deb+1)/length(Data(sqSca{1})):fin]/10;

figure('color',[1 1 1]),
for i=1:7
subplot(2,1,1), hold on, plot(timesstp,SmoothDec(Data(sqSca{i}),smo)/length(sweepsSca{i}),'color',[i/7 0 (7-i)/7]), ylabel('Firing rate (Hz)')
subplot(2,1,2), hold on, plot(timesstp,zscore(SmoothDec(Data(sqSca{i}),smo)/length(sweepsSca{i})),'color',[i/7 0 (7-i)/7]), ylabel('Firing rate (zscore)')
yl=ylim;
line([0 0],yl,'color','k')
% line([-100 -100],yl,'color','k')
% line([-200 -200],yl,'color','k')
% line([-300 -300],yl,'color','k')
% line([-400 -400],yl,'color','k')
end
subplot(2,1,1), title(['Cell Assembly, 2500-17500 Hz'])
yl=ylim;
line([0 0],yl,'color','k')
clear MSca
for i=1:7
MSca(i,:)=SmoothDec(Data(sqSca{i}),smo)/length(sweepsSca{i});
end
figure('color',[1 1 1]),
imagesc(timesstp, freqSca/1000, MSca), axis xy
ylabel('Sound Frequency (kHz)')
xlabel('time (ms)')
colorbar
yl=ylim;
line([0 0],yl,'color','k')
% line([-100 -100],yl,'color','k')
% line([-200 -200],yl,'color','k')
% line([-300 -300],yl,'color','k')
% line([-400 -400],yl,'color','k')
title(['Cell Assembly, 2500-17500 Hz'])




% 
% 

if sav

            figure('color',[1 1 1]), [fh,sq,sweeps] = RasterPETH(sigHiCo, ts(TlocalSTD), -6000, +6000,'BinSize',100);
            figure('color',[1 1 1]), [fh2,sq2,sweeps2] = RasterPETH(sigHiCo, ts(TlocalDEV), -6000, +6000,'BinSize',100);
            figure('color',[1 1 1]), [fh3,sq3,sweeps3] = RasterPETH(sigHiCo, ts(TglobalSTD), -6000, +6000,'BinSize',100);
            figure('color',[1 1 1]), [fh4,sq4,sweeps4] = RasterPETH(sigHiCo, ts(TglobalDEV), -6000, +6000,'BinSize',100);

            deb=6000;
            fin=6000;
            timesstp2=[-deb:(fin+deb+1)/length(Data(sqSca{1})):fin]/10;
            smo2=0.5; 
            figure('color',[1 1 1]), 
            subplot(2,1,1), plot(timesstp2,SmoothDec(Data(sq),smo2)/length(sweeps),'k')
            hold on, plot(timesstp2,SmoothDec(Data(sq2),smo2)/length(sweeps2),'r')
            title([' Cell Assembly Local Effect'])
            yl=ylim;
            line([0 0],yl,'color','k')
            xlim([-550 550])
            subplot(2,1,2), plot(timesstp2,SmoothDec(Data(sq3),smo2)/length(sweeps3),'k')
            hold on, plot(timesstp2,SmoothDec(Data(sq4),smo2)/length(sweeps4),'r')
            title('Global Effect')
            yl=ylim;
            line([0 0],yl,'color','k')
            xlim([-550 550])


            for i=1:20
                try
             eval(['saveFigure(',num2str(i),',''Figure-CellAssembly-Mouse039-10kHz-',num2str(i),''',''',filenameSav,''')'])
                end

            end

end




% 
% 
