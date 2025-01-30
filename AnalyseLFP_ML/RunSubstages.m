function [WAKE,REM,N1,N2,N3,NamesStages,SleepStages,noise,WAKEnoise]=RunSubstages(DoNew,nameSpectrum)

% [WAKE,REM,N1,N2,N3,NamesStages,SleepStages]=RunSubstages('PFCx_deep');
% [WAKE,REM,N1,N2,N3,NamesStages,SleepStages]=RunSubstages('Movement');
% 
% inputs:
% - DoNew (optional) : use new method of substages based on delta ISI distrib
% - nameSpectrum (optional) : give name in channelTo Analyse of the
% spectrum on which polysomno will be superimposed.
%
% needs:
% FindNREMepochsML.m
% DefineSubStages.m
% PlotPolysomnoML.m

if ~exist('DoNew','var')
    DoNew=0;
end

clear opNew op NamesOp Dpfc Epoch noise wholeEpoch
try
    load NREMepochsML.mat opNew op NamesOp Dpfc Epoch noise
    op; noise ;disp('... loading epochs from NREMepochsML.m')
    
    % ------------------ opNew --------------
    if ~exist('opNew','var') && DoNew
        opNew=op;
        if ~isempty(Range(Dpfc))
            disp('   opNew not defined : run FindDeltaBurst2.m')
            opNew{3}=FindDeltaBurst2(Restrict(Dpfc,Epoch),1.08,1); % new threshold by fitinf ISI delta
            opNew{10}=FindDeltaBurst2(Restrict(Dpfc,Epoch),2.2,1);
            opNew{11}=FindDeltaBurst2(Restrict(Dpfc,Epoch),1.08,0);
            opNew{12}=FindDeltaBurst2(Restrict(Dpfc,Epoch),2.2,0);
        end
        save NREMepochsML.mat -append opNew
    end
    
catch
    [op,NamesOp,Dpfc,Epoch,noise,opNew]=FindNREMepochsML;
    save NREMepochsML.mat op NamesOp Dpfc Epoch noise opNew
    disp('saving in NREMepochsML.mat')
end
% NamesOp = { PFsupOsci PFdeepOsci BurstDelta REM WAKE SWS PFswa OBswa};

if DoNew
    [EP,~]=DefineSubStagesNew(opNew,noise,0,1);
else
    [EP,~]=DefineSubStages(op,noise);
end
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
% SleepStages = tsd (WAKE=4, REM=3, N1=2, N2=1.5, N3=1, undetermined/noise=4.5)

start_W=Start(WAKE); stop_W=Stop(WAKE);
start_N=Start(noise); stop_N=Stop(noise);
sta=start_W; sto=stop_W;
for s=1:length(start_N)
    ind1=find(start_N(s)-stop_W<10 & start_N(s)-stop_W>=0,1);
    ind2=find(start_W-stop_N(s)<10 & start_W-stop_N(s)>=0,1);
    if ~isempty(ind1)&& ~isempty(ind2)
        sta=[sta;start_N(s)];sto=[sto;stop_N(s)];
    end
end
WAKEnoise=intervalSet(sort(sta),sort(sto));
mergeCloseIntervals(WAKEnoise,10);
disp(sprintf('WAKEnoise: %d noise episods added to the %d WAKE episods',length(sta)-length(start_W),length(start_W)));


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

