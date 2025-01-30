function MatriceREM10_20s
load('Ordered_REM')
%%load Ordered REM
REM10s=Ordered_REM(:,2);
REM10_20s=Ordered_REM(:,6);
REM20_30s=Ordered_REM(:,10);
REM30setplus=Ordered_REM(:,14);
%%%Pour l'HPC (à changer si le load est différent)
load('dHPC_deep_Low_Spectrum');
SpectroH2=Spectro;



figure


events=REM10_20s*1E4;
events(isnan(events))=[];
%events=(Start(REMEpoch)/1E4)+10

%events=StartStim_dansREM;

fq=find(SpectroH2{3}>6&SpectroH2{3}<8.5);
fq2=find(SpectroH2{3}>3&SpectroH2{3}<5);
thetaPower2=10*log10(mean(SpectroH2{1}(:,fq),2));
thetaPower=10*log10(mean(SpectroH2{1}(:,fq),2))./(10*log10(mean(SpectroH2{1}(:,fq2),2)));
vv2=tsd(SpectroH2{2}*1E4,thetaPower2);
vv=tsd(SpectroH2{2}*1E4,thetaPower);
[m2,s2,tps2]=mETAverage(events,Range(vv2),Data(vv2),200,2000);
[m1,s1,tps1]=mETAverage(events,Range(vv),Data(vv),200,2000);
[MH,SH,tH]=AverageSpectrogram(tsd(SpectroH2{2}*1E4,10*log10(SpectroH2{1})),SpectroH2{3},ts(events),500,300);
hold on, plot(tps2/1E3,rescale(m2,0,20),'r','linewidth',2)
hold on, plot(tps1/1E3,rescale(m1,0,20),'k','linewidth',2)



figure, [fh, rasterAx, histAx, matVal] = ImagePETH(vv2, ts(events), -30E4, +30E4,'BinSize',1000);
matriceREM10_20s=Data(matVal)
save('matriceREM10_20s.mat','matriceREM10_20s')

end