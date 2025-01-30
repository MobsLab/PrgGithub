% PFCspikesDuringSounds_ChR2
% 24.08.2016

% from PFCspikesDuringSounds
% 29.05.2015

cd /media/DataMOBsRAID/ProjetAversion/DATA-Fear
res=pwd;
Dir=PathForExperimentFEAR('Fear-electrophy');
Dir = RestrictPathForExperiment(Dir,'nMice',[363]);
Dir = RestrictPathForExperiment(Dir,'Session','EXT-24h');
[nameMice, IXnameMice]=unique(Dir.name);
nameGroups={'OBX', 'CTRL'};

cd /media/DataMOBsRAID/ProjetAversion/DATA-Fear/Mouse363/20160717-EXT-24h-laser10
load('/media/DataMOBsRAID/ProjetAversion/DATA-Fear/Mouse363/20160717-EXT-24h-laser10/LFPData/InfoLFP.mat')
load('/media/DataMOBsRAID/ProjetAversion/DATA-Fear/Mouse363/20160717-EXT-24h-laser10/SpikeData.mat')
load('/media/DataMOBsRAID/ProjetAversion/DATA-Fear/Mouse363/20160717-EXT-24h-laser10/behavResources.mat')

temp=load('LFPData/LFP1.mat');
tps=Range(temp.LFP); %tps est en 10-4sec
TotEpoch=intervalSet(tps(1),tps(end));
                    
%% get the n° of the neurons of PFCx  from ModulationPFCneuronsByBulb.m
chans=InfoLFP.channel(strcmp(InfoLFP.structure,'PFCx'));
numtt=[]; % nb tetrodes ou montrodes du PFCx
for cc=1:length(chans) 
    for tt=1:length(tetrodeChannels) % tetrodeChannels= tetrodes ou montrodes (toutes)
        if ~isempty(find(tetrodeChannels{tt}==chans(cc)))
            numtt=[numtt,tt];
        end
    end
end
numNeurons=[]; % neurones du PFCx
for i=1:length(S);
    if ismember(TT{i}(1),numtt)
      numNeurons=[numNeurons,i];  
    end
end

% pour 363 EXT-24 only
beauxneurons=[2 3 7 8 12 13 20 21];

numMUA=[];
for k=1:length(numNeurons)
    j=numNeurons(k);
    if TT{j}(2)==1
        numMUA=[numMUA, j];
    end
end


%% get CS plus and CSmin times

% Define who received WN as CS+ and who as CS-
% group CS+=bip
CSplu_bip_GpNb=[];
CSplu_bip_Gp={};
for k=1:length(CSplu_bip_GpNb)
    CSplu_bip_Gp{k}=num2str(CSplu_bip_GpNb(k));
end
CSplu_bip_Gp=CSplu_bip_Gp';

% group CS+=WN
CSplu_WN_GpNb=[363 367];
CSplu_WN_Gp={};
for k=1:length(CSplu_WN_GpNb)
    CSplu_WN_Gp{k}=num2str(CSplu_WN_GpNb(k));
end
CSplu_WN_Gp=CSplu_WN_Gp';

% get start times of sounds from TTL
DiffTimes=diff(TTL(:,1));
ind=DiffTimes>2;
times=TTL(:,1);
event=TTL(:,2);
CStimes=times([1; find(ind)+1]);  %temps du premier TTL de chaque s�rie de son
CSevent=event([1; find(ind)+1]);  %valeur du premier TTL de chaque s�rie de son (CS+ ou CS-)

% definir CS+ et CS- selon les groupes
m='363';
if sum(strcmp(num2str(m),CSplu_bip_Gp))==1
    CSpluCode=4; %bip
    CSminCode=3; %White Noise
elseif sum(strcmp(num2str(m),CSplu_WN_Gp))==1
    CSpluCode=3;
    CSminCode=4;
end

CSp=CStimes(CSevent==CSpluCode)*1E4;
CSm=CStimes(CSevent==CSminCode)*1E4;

%% raster

fre=Start(FreezeEpoch);
en=End(FreezeEpoch);       

% triggé sur le début des sons
%for i=1:size(S)
for i=numNeurons
%figure, [fh,sq,sweeps] = RasterPETH(S{i}, ts(CSp), -100000,+100000,'BinSize',1000,'Markers',{ts(en)},'MarkerTypes',{'r*','r'});
figure('Position',[290   540   560   420]), [fh,sq,sweeps] = RasterPETH(S{i}, ts(CSp), -100000,+100000,'BinSize',1000,'Markers',{ts(en)},'MarkerTypes',{'r*','r'});
title(cellnames{i})
end

% Bip des CS+ et Bip des CS-
clear BipP
BipP=TTL(TTL(:,2)==CSpluCode,1)*1E4;
clear BipM
BipM=TTL(TTL(:,2)==CSminCode,1)*1E4;

%for i=numNeurons
for i=beauxneurons
if isempty(find(numMUA==i))
    %%% Bip
    %figure('Position',[1983  541 560  420]), clf, [fh,sq,sweeps] = RasterPETH(S{i}, ts(BipP), -8000,+16000,'BinSize',100,'Markers',{ts(CSp)},'MarkerTypes',{'r*','r'});title(['Cs+, ',cellnames{i}])
    %figure('Position',[2600  541 560  420]), clf, [fh,sq,sweeps] = RasterPETH(S{i}, ts(BipM), -8000,+16000,'BinSize',100,'Markers',{ts(CSm)},'MarkerTypes',{'r*','r'});title(['Cs-, ',cellnames{i}])
    %%% Sounds
    %figure('Position',[100  541 560  420]), clf, [fh,sq,sweeps] = RasterPETH(S{i}, ts(CSp), -200000,+460000,'BinSize',1000,'Markers',{ts(BipP)},'MarkerTypes',{'r*','r'});title(['Cs+, ',cellnames{i}])
    %figure('Position',[700  541 560  420]), clf, [fh,sq,sweeps] = RasterPETH(S{i}, ts(CSm), -200000,+460000,'BinSize',1000,'Markers',{ts(BipM)},'MarkerTypes',{'r*','r'});title(['Cs-, ',cellnames{i}])
    %%% freezing
    %figure('Position',[100  10 560  420]), clf, [fh,sq,sweeps] = RasterPETH(S{i}, ts(fre), -80000,+100000,'BinSize',500,'Markers',{ts(en)},'MarkerTypes',{'r*','r'});title(['Freezing start, ',cellnames{i}])
    %figure('Position',[700  10 560  420]), clf, [fh,sq,sweeps] = RasterPETH(S{i}, ts(en), -80000,+100000,'BinSize',500,'Markers',{ts(fre)},'MarkerTypes',{'r*','r'});title(['Freezing end, ',cellnames{i}])
    %%% BipCSP+, + ou - laser
    figure('Position',[1983  10 560  420]), clf, [fh,sq,sweeps] = RasterPETH(S{i}, Restrict(ts(BipP),StimLaserON), -8000,+16000,'BinSize',100,'Markers',{ts(CSp)},'MarkerTypes',{'r*','r'});title(['Cs+ laser ON, ',cellnames{i}])
    figure('Position',[2600  10 560  420]), clf, [fh,sq,sweeps] = RasterPETH(S{i}, Restrict(ts(BipP),TotEpoch-StimLaserON), -8000,+16000,'BinSize',100,'Markers',{ts(CSm)},'MarkerTypes',{'r*','r'});title(['Cs+ laser OFF, ',cellnames{i}])
end
    pause(4)
end

    close all
rg=Range(LFP);
Epoch=intervalSet(rg(1),rg(end));    

rg=Range(LFP);
TotRpoch=intervalSet(rg(1),rg(end));

for i=1:length(S)
Fr(1,i)=length(Range(Restrict(S{i},TotRpoch)))/sum(End(TotRpoch,'s')-Start(TotRpoch,'s'));
Fr(2,i)=length(Range(Restrict(S{i},FreezeEpoch)))/sum(End(FreezeEpoch,'s')-Start(FreezeEpoch,'s'));
Fr(3,i)=length(Range(Restrict(S{i},TotRpoch-FreezeEpoch)))/sum(End(TotRpoch-FreezeEpoch,'s')-Start(TotRpoch-FreezeEpoch,'s'));

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


