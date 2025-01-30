function [WAKE,REM,N1,N2,N3,NamesStages,SleepStages,noise,WAKEnoise]=RunSubstages(nameSpectrum)

% [WAKE,REM,N1,N2,N3,NamesStages,SleepStages]=RunSubstages('PFCx_deep');
% [WAKE,REM,N1,N2,N3,NamesStages,SleepStages]=RunSubstages('Movement');
% 
% inputs:
% - nameSpectrum (optional) : give name in channelTo Analyse of the
% spectrum on which polysomno will be superimposed.
%
% needs:
% FindNREMepochsML.m
% DefineSubStages.m
% PlotPolysomnoML.m


clear op NamesOp Dpfc Epoch noise
try
    load NREMepochsML.mat op NamesOp Dpfc Epoch noise
    op; disp('Loading epochs from NREMepochsML.m')
catch
    [op,NamesOp,Dpfc,Epoch,noise]=FindNREMepochsML;
    disp('saving in NREMepochsML.mat')
    save NREMepochsML.mat op NamesOp Dpfc Epoch noise
end
% NamesOp = { PFsupOsci PFdeepOsci BurstDelta REM WAKE SWS PFswa OBswa};

[EP,NamesEP]=DefineSubStages(op,noise);
% NamesEP={ N1 N2 N3 REM WAKE SWS swaPF swaOB TOTSleep};
N1=EP{1}; N2=EP{2}; N3=EP{3}; REM=EP{4}; WAKE=EP{5}; SWS=EP{6}; swaOB=EP{8};

numF=0;


%% do movement

if exist('nameSpectrum','var') && strcmp(nameSpectrum,'Movement')
    clear nameSpectrum
    figure('color',[1 1 1],'Unit','normalized','Position',[0.1 0.1 0.6 0.7])
    numF=gcf;
    load('StateEpoch.mat','Mmov');
    plot(Range(Mmov,'s'),rescale(Data(Mmov),5,10),'k');
end



%% get spectrum if required

if exist('nameSpectrum','var')
    clear Sp t f
    figure('color',[1 1 1],'Unit','normalized','Position',[0.1 0.1 0.6 0.7])
    numF=gcf;
    try
        disp(['... loading ChannelsToAnalyse/',nameSpectrum,'.mat'])
       eval(['temp=load(''ChannelsToAnalyse/',nameSpectrum,'.mat'');']);
        disp(['... loading SpectrumDataL/Spectrum',num2str(temp.channel),'.mat'])
       eval(['load(''SpectrumDataL/Spectrum',num2str(temp.channel),'.mat'',''Sp'',''t'',''f'');']);
       disp('... DONE');
       imagesc(t,f,10*log10(Sp)'), axis xy, caxis([20 60]);
       ylabel(['Spectrum ',nameSpectrum])
    end
end



%% run PlotPolysomnoML
[SleepStages,Epochs,NamesStages]=PlotPolysomnoML(N1,N2,N3,SWS,REM,WAKE,numF);
%[SleepStages,Epochs,NamesStages]=PlotPolysomnoML(N1,N2,N3,SWS,REM,WAKE,numF,swaOB);
% NamesStages = { WAKE REM N1 N2 N3};
% WAKE = Epochs{1};
% REM = Epochs{2};
% N1 = Epochs{3};
% N2 = Epochs{4};
% N3 = Epochs{5};


staW=Start(WAKE); stoW=Stop(WAKE);
staN=Start(noise); stoN=Stop(noise);
sta=staW; sto=stoW; 
for s=1:length(staN)
    ind1=find(staN(s)-stoW<10 & staN(s)-stoW>=0);
    ind2=find(staW-stoN(s)<10 & staW-stoN(s)>=0);
    if ~isempty(ind1)&& ~isempty(ind2)
        sta=[sta;staN(s)];sto=[sto;stoN(s)];
    end
end
WAKEnoise=intervalSet(sort(sta),sort(sto));
mergeCloseIntervals(WAKEnoise,10);
disp(sprintf('WAKEnoise: %d noise episods added to the %d WAKE episods',length(sta)-length(staW),length(staW)));

%% substages
Sta=[];
for ep=1:5
    if ~isempty(Epochs{ep})
        Sta=[Sta ; [Start(EP{ep},'s'),zeros(length(Start(EP{ep})),1)+ep] ];
    end
end
if ~isempty(Sta)
    Sta=sortrows(Sta,1);
    ind=find(diff(Sta(:,2))==0);
    Sta(ind+1,:)=[];
    
    % check REM -> WAKE transition
    a=find([Sta(:,2);0]==4 & [0;Sta(:,2)]==5 );
    ep='';if ~isempty(a),ep=[ep,' Warning! t=[',sprintf(' %g',floor(Sta(a,1))),' ]s'];end
    disp([sprintf('%d transitions WAKE -> REM ',length(a)),ep]);
end