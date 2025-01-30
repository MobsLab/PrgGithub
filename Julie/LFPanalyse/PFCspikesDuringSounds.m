% PFCspikesDuringSounds
% 29.05.2015

cd /media/DataMOBsRAID/ProjetAversion/DATA-Fear/Mouse248/20150326-EXT-24h-envC/
load('/media/DataMOBsRAID/ProjetAversion/DATA-Fear/Mouse248/20150326-EXT-24h-envC/SpikeData.mat')
load('/media/DataMOBsRAID/ProjetAversion/DATA-Fear/Mouse248/20150326-EXT-24h-envC/behavResources.mat')

fre=Start(FreezeEpoch);
en=End(FreezeEpoch);

CSp=StimInfo(StimInfo(:,2)==7,1)*1E4;
CSm=StimInfo(StimInfo(:,2)==5,1)*1E4;

for i=1:size(S)
figure, [fh,sq,sweeps] = RasterPETH(S{i}, ts(CSp), -100000,+100000,'BinSize',1000,'Markers',{ts(en)},'MarkerTypes',{'r*','r'});
title(cellnames{i})
end

clear BipP
a=1;
for i=1:length(CSp)
    for j=1:27
    BipP(a)=CSp(i)+(j-1)*1.0999E4;
    a=a+1;
    end
end


clear BipM
a=1;
for i=1:length(CSm)
    for j=1:27
    BipM(a)=CSm(i)+(j-1)*1.0999E4;
    a=a+1;
    end
end

% 
%  i=14;
% figure('color',[1 1 1]), [fh,sq,sweeps] = RasterPETH(S{i}, ts(BipP), -8000,+16000,'BinSize',100,'Markers',{ts(CSp)},'MarkerTypes',{'r*','r'});title(cellnames{i})


% for i=1:length(S)
    for i=[8 9 10 11 13 14]
figure(1), clf, [fh,sq,sweeps] = RasterPETH(S{i}, ts(BipP), -8000,+16000,'BinSize',100,'Markers',{ts(CSp)},'MarkerTypes',{'r*','r'});title(['Cs+, ',cellnames{i}])
figure(2), clf, [fh,sq,sweeps] = RasterPETH(S{i}, ts(BipM), -8000,+16000,'BinSize',100,'Markers',{ts(CSm)},'MarkerTypes',{'r*','r'});title(['Cs-, ',cellnames{i}])
figure(3), clf, [fh,sq,sweeps] = RasterPETH(S{i}, ts(CSp), -200000,+460000,'BinSize',1000,'Markers',{ts(BipP)},'MarkerTypes',{'r*','r'});title(['Cs+, ',cellnames{i}])
figure(4), clf, [fh,sq,sweeps] = RasterPETH(S{i}, ts(CSm), -200000,+460000,'BinSize',1000,'Markers',{ts(BipM)},'MarkerTypes',{'r*','r'});title(['Cs-, ',cellnames{i}])
figure(5), clf, [fh,sq,sweeps] = RasterPETH(S{i}, ts(fre), -80000,+100000,'BinSize',500,'Markers',{ts(en)},'MarkerTypes',{'r*','r'});title(['Freezing+, ',cellnames{i}])
figure(6), clf, [fh,sq,sweeps] = RasterPETH(S{i}, ts(en), -80000,+100000,'BinSize',500,'Markers',{ts(fre)},'MarkerTypes',{'r*','r'});title(['Freezing+, ',cellnames{i}])
pause(4)
    end

    close all
rg=Range(LFP);
Epoch=intervalSet(rg(1),rg(end));    

rg=Range(LFP);
Epoch=intervalSet(rg(1),rg(end));

for i=1:length(S)
Fr(1,i)=length(Range(Restrict(S{i},Epoch)))/sum(End(Epoch,'s')-Start(Epoch,'s'));
Fr(2,i)=length(Range(Restrict(S{i},FreezeEpoch)))/sum(End(FreezeEpoch,'s')-Start(FreezeEpoch,'s'));
Fr(3,i)=length(Range(Restrict(S{i},Epoch-FreezeEpoch)))/sum(End(Epoch-FreezeEpoch,'s')-Start(Epoch-FreezeEpoch,'s'));

Epoch1=intervalSet(Start(FreezeEpoch)-3E4,Start(FreezeEpoch));
Epoch2=intervalSet(Start(FreezeEpoch),Start(FreezeEpoch)+3E4);
Fr(4,i)=length(Range(Restrict(S{i},Epoch1)))/sum(End(Epoch1,'s')-Start(Epoch1,'s'));
Fr(5,i)=length(Range(Restrict(S{i},FreezeEpoch)))/sum(End(FreezeEpoch,'s')-Start(FreezeEpoch,'s'));
Fr(6,i)=length(Range(Restrict(S{i},Epoch2)))/sum(End(Epoch2,'s')-Start(Epoch2,'s'));

end

PlotErrorBarN(Fr');
set(gca,'Xtick',1:6)
set(gca,'Xticklabel',{'Total', 'Freeze', 'NoFreeze','Before (3s)','Freeze','After (3s)'})
ylabel('Firing rate (Hz)')

% attention tester : est-cze que les spikes qu'on détecte pendant les sons
% ne sont aps des artefacts muscualires : regarder les WF pendant des
% périodes spécifique
Epoch=intervalset(BipP-50,BipP+50); % ou 
Epoch=intervalset(BipP-200,BipP+200);
wfo=PlotWaveforms(W,14,Epoch);


