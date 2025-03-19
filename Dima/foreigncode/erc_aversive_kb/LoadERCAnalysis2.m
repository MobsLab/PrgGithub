function LoadERCAnalysis2(dir, expe, num_pc, binS, PeriodAnalyse)



%% Load data
% Spike
s = load([dir, '/SpikeData.mat']);

% Ripples 
try
    r = load(fullfile(dir, 'SWR.mat'));
catch
    r = load(fullfile(dir, 'Ripples.mat'));
end
rip=ts(ripples(:,2)*1E4);
RipEpoch=intervalSet(ripples(:,2)*1E4-0.2E4,ripples(:,2)*1E4+0.2E4);
% Sleep scoring
try
    ss = load(fullfile(dir, 'SleepScoring_OBGamma.mat'), 'Wake', 'REMEpoch', 'SWSEpoch', 'TotalNoiseEpoch');
catch
    ss = load(fullfile(dir, 'SleepScoring_Accelero.mat'), 'Wake', 'REMEpoch', 'SWSEpoch', 'TotalNoiseEpoch');
end
Wake=Wake-TotalNoiseEpoch;
REMEpoch=REMEpoch-TotalNoiseEpoch;
SWSEpoch=SWSEpoch-TotalNoiseEpoch;
% Behavior
b = load(fullfile(dir, 'behavResources.mat'), 'AlignedXtsd', 'AlignedYtsd', 'SessionEpoch',...
    'FreezeEpoch', 'ZoneEpoch', 'TTLInfo', 'Vtsd');
StimEpoch = TTLInfo.StimEpoch;
if strcmp(expe, 'PAG')
    [SessionHab, TestPre, ~, Cond, ~, TestPost] = ReturnMnemozyneEpochs(b.SessionEpoch);
elseif strcmp(expe, 'MFB')
    [SessionHab, TestPre, ~, Cond, FullTask, TestPost] = ReturnMnemozyneEpochs(b.SessionEpoch, 'NumberTests', 8);
end

% Remove noise
Hab=SessionHab-TotalNoiseEpoch;
TestPre=TestPre-TotalNoiseEpoch;
TestPost=TestPost-TotalNoiseEpoch;
Cond=Cond-TotalNoiseEpoch;
FullTask=FullTask-TotalNoiseEpoch;

%%

Q=MakeQfromS(S,binS);

Qpre=zscore(full(Data(Restrict(Q,and(SWSEpoch,SessionEpoch.PreSleep)))));
Qpost=zscore(full(Data(Restrict(Q,and(SWSEpoch,SessionEpoch.PostSleep)))));
QpreREM=zscore(full(Data(Restrict(Q,and(REMEpoch,SessionEpoch.PreSleep)))));
QpostREM=zscore(full(Data(Restrict(Q,and(REMEpoch,SessionEpoch.PostSleep)))));
QpreRip=zscore(full(Data(Restrict(Q,and(RipEpoch,SessionEpoch.PreSleep)))));
QpostRip=zscore(full(Data(Restrict(Q,and(RipEpoch,SessionEpoch.PostSleep)))));

Qhab=zscore(full(Data(Restrict(Q,Hab))));
Qcond=zscore(full(Data(Restrict(Q,Cond))));
QcondFree=zscore(full(Data(Restrict(Q,and(Cond,FreezeEpoch)))));
QcondNoFree=zscore(full(Data(Restrict(Q,Cond-FreezeEpoch))));
Qfull=zscore(full(Data(Q)));

Qwake=zscore(full(Data(Restrict(Q,FullTask))));
QTestPre=zscore(full(Data(Restrict(Q,TestPre))));
QTestPost=zscore(full(Data(Restrict(Q,TestPost))));

%ZoneEpoch

% try
% QCentre=zscore(full(Data(Restrict(Q,ZoneEpoch.Centre))));
% QCentreNoShock=zscore(full(Data(Restrict(Q,ZoneEpoch.CentreNoShock))));
% QCentreShock=zscore(full(Data(Restrict(Q,ZoneEpoch.CentreShock))));
% QFarNoShock=zscore(full(Data(Restrict(Q,ZoneEpoch.FarNoShock))));
% QFarShock=zscore(full(Data(Restrict(Q,ZoneEpoch.FarShock))));
% QInside=zscore(full(Data(Restrict(Q,ZoneEpoch.Inside))));
% QNoShock=zscore(full(Data(Restrict(Q,ZoneEpoch.NoShock))));
% QOutside=zscore(full(Data(Restrict(Q,ZoneEpoch.Outside))));
% QShock=zscore(full(Data(Restrict(Q,ZoneEpoch.Shock))));
% end
            
            
%%

[RpreR,PpreR]=corrcoef(QpreR); 
[RpostR,PpostR]=corrcoef(QpostR); 
[Rpre,Ppre]=corrcoef(Qpre); 
[Rpost,Ppost]=corrcoef(Qpost); 
[Rwake,Pwake]=corrcoef(Qwake); 
[Rcond,Pcond]=corrcoef(Qcond); 
[Rfull,Pfull]=corrcoef(Qfull); 


%%
eval(['Qanalyse=Q',PeriodAnalyse,';'])

%%

[EV,REV,CorrM] = ExplainedVariance(Qpre, Qanalyse, Qpost);

%%

C = corrcoef(Qanalyse);
C(isnan(C))=0;
C=C-diag(diag(C));
[PCweights,L] = pcacov(C);
[BE,id]=sort(PCweights(:,num_pc));
pc=PCweights(:,num_pc);

%%
 figure, plot(sort(L),'o-')

figure, 
subplot(321), imagesc(Rpre(id,id)-diag(diag(Rpre))), title('Pre (NREM)')%, caxis([-0.6 0.6])
subplot(322), imagesc(Rpost(id,id)-diag(diag(Rpost))), title('Post (NREM)')%, caxis([-0.6 0.6])
subplot(323), imagesc(Rwake(id,id)-diag(diag(Rwake))), title('wake')%, caxis([-0.6 0.6])
subplot(324), imagesc(Rcond(id,id)-diag(diag(Rcond))), title('Cond')%, caxis([-0.6 0.6])
subplot(325), imagesc(RpreR(id,id)-diag(diag(Rpre))), title('Pre (REM)')%, caxis([-0.6 0.6])
subplot(326), imagesc(RpostR(id,id)-diag(diag(Rpost))), title('Post (REM)')%, caxis([-0.6 0.6])

%%
scorePRE = zscore(Qpre)*PCweights(:,num_pc);
singleNpre = (zscore(Qpre).^2)*(PCweights(:,num_pc).^2);
replayPRE = scorePRE.^2 - singleNpre;

scorePOST = zscore(Qpost)*PCweights(:,num_pc);
singleNpost = (zscore(Qpost).^2)*(PCweights(:,num_pc).^2);
replayPOST = scorePOST.^2 - singleNpost;

scorePRER = zscore(QpreR)*PCweights(:,num_pc);
singleNpreR = (zscore(QpreR).^2)*(PCweights(:,num_pc).^2);
replayPRER = scorePRER.^2 - singleNpreR;

scorePOSTR = zscore(QpostR)*PCweights(:,num_pc);
singleNpostR = (zscore(QpostR).^2)*(PCweights(:,num_pc).^2);
replayPOSTR = scorePOSTR.^2 - singleNpostR;

scoreWAKE = zscore(Qwake)*PCweights(:,num_pc);
singleWAKE = (zscore(Qwake).^2)*(PCweights(:,num_pc).^2);
replayWAKE = scoreWAKE.^2 - singleWAKE;


Qf=full(Data(Q));
scoreG = zscore(Qf)*PCweights(:,num_pc);
singleNG = (zscore(Qf).^2)*(PCweights(:,num_pc).^2);
replayG = scoreG.^2 - singleNG;
replayGtsd=tsd(Range(Q),replayG);

replayWAKEtsd=tsd(Range(Restrict(Q,FullTask)),replayWAKE); 
replayPOSTtsd=tsd(Range(Restrict(Q,and(SWSEpoch,SessionEpoch.PostSleep))),replayPOST); 
replayPREtsd=tsd(Range(Restrict(Q,and(SWSEpoch,SessionEpoch.PreSleep))),replayPRE); 





%%

[hpre,bpre]=hist(replayPRE,1000);
[hpost,bpost]=hist(replayPOST,1000);
[hpreR,bpreR]=hist(replayPRER,1000);
[hpostR,bpostR]=hist(replayPOSTR,1000);
[hwake,bwake]=hist(replayWAKE,1000);

%%

Mhab=(Data(Restrict(replayWAKEtsd,Hab)));
Mcond=(Data(Restrict(replayWAKEtsd,Cond)));
McondFree=(Data(Restrict(replayWAKEtsd,and(Cond,FreezeEpoch))));
McondNoFree=(Data(Restrict(replayWAKEtsd,Cond-FreezeEpoch)));
Mpre=(Data(Restrict(replayWAKEtsd,TestPre)));


Res=[EV,REV,mean(replayPRE),mean(replayPOST),mean(replayPRER),mean(replayPOSTR),mean(replayWAKE),mean(Mcond),mean(McondFree),mean(McondNoFree),mean(Mhab),mean(Mpre) L(num_pc)];

% try
% Mat(1,1)=mean(Data(Restrict(replayGtsd,ZoneEpoch.Centre)));
% Mat(2,1)=mean(Data(Restrict(replayGtsd,ZoneEpoch.CentreNoShock)));
% Mat(3,1)=mean(Data(Restrict(replayGtsd,ZoneEpoch.CentreShock)));
% Mat(4,1)=mean(Data(Restrict(replayGtsd,ZoneEpoch.FarNoShock)));
% Mat(5,1)=mean(Data(Restrict(replayGtsd,ZoneEpoch.FarShock)));
% Mat(6,1)=mean(Data(Restrict(replayGtsd,ZoneEpoch.Inside)));
% Mat(7,1)=mean(Data(Restrict(replayGtsd,ZoneEpoch.NoShock)));
% Mat(8,1)=mean(Data(Restrict(replayGtsd,ZoneEpoch.Outside)));
% Mat(9,1)=mean(Data(Restrict(replayGtsd,ZoneEpoch.Shock)));
% 
% Mat(1,2)=mean(Data(Restrict(replayGtsd,and(Hab,ZoneEpoch.Centre))));
% Mat(2,2)=mean(Data(Restrict(replayGtsd,and(Hab,ZoneEpoch.CentreNoShock))));
% Mat(3,2)=mean(Data(Restrict(replayGtsd,and(Hab,ZoneEpoch.CentreShock))));
% Mat(4,2)=mean(Data(Restrict(replayGtsd,and(Hab,ZoneEpoch.FarNoShock))));
% Mat(5,2)=mean(Data(Restrict(replayGtsd,and(Hab,ZoneEpoch.FarShock))));
% Mat(6,2)=mean(Data(Restrict(replayGtsd,and(Hab,ZoneEpoch.Inside))));
% Mat(7,2)=mean(Data(Restrict(replayGtsd,and(Hab,ZoneEpoch.NoShock))));
% Mat(8,2)=mean(Data(Restrict(replayGtsd,and(Hab,ZoneEpoch.Outside))));
% Mat(9,2)=mean(Data(Restrict(replayGtsd,and(Hab,ZoneEpoch.Shock))));
% 
% Mat(1,3)=mean(Data(Restrict(replayGtsd,and(Cond,ZoneEpoch.Centre))));
% Mat(2,3)=mean(Data(Restrict(replayGtsd,and(Cond,ZoneEpoch.CentreNoShock))));
% Mat(3,3)=mean(Data(Restrict(replayGtsd,and(Cond,ZoneEpoch.CentreShock))));
% Mat(4,3)=mean(Data(Restrict(replayGtsd,and(Cond,ZoneEpoch.FarNoShock))));
% Mat(5,3)=mean(Data(Restrict(replayGtsd,and(Cond,ZoneEpoch.FarShock))));
% Mat(6,3)=mean(Data(Restrict(replayGtsd,and(Cond,ZoneEpoch.Inside))));
% Mat(7,3)=mean(Data(Restrict(replayGtsd,and(Cond,ZoneEpoch.NoShock))));
% Mat(8,3)=mean(Data(Restrict(replayGtsd,and(Cond,ZoneEpoch.Outside))));
% Mat(9,3)=mean(Data(Restrict(replayGtsd,and(Cond,ZoneEpoch.Shock))));
% end

legen{1}='Centre';
legen{2}='CentreNoShock';
legen{3}='CentreShock';
legen{4}='FarNoShock';
legen{5}='FarShock';
legen{6}='Inside';
legen{7}='NoShock';
legen{8}='Outside';
legen{9}='Shock';
% 
% ststim=Start(StimEpoch);
% for i=1:length(Start(StimEpoch))
%         dx=Data(CleanAlignedXtsd)-Data(Restrict(CleanAlignedXtsd,ts(ststim(i))));
%         dy=Data(CleanAlignedYtsd)-Data(Restrict(CleanAlignedYtsd,ts(ststim(i))));
%         dis=sqrt(dx.^2+dy.^2);
%         distsd{i}=tsd(Range(CleanAlignedXtsd),sqrt(dx.^2+dy.^2));
% end
% 
% clear Hpre Hcond Hpost
% for i=1:length(Start(StimEpoch))
%     [Hpre(i,:),b]=hist(Data(Restrict(distsd{i},TestPre)),[0:0.005:1.25]);
%     [Hcond(i,:),b]=hist(Data(Restrict(distsd{i},Cond)),[0:0.005:1.25]);
%     [Hpost(i,:),b]=hist(Data(Restrict(distsd{i},TestPost)),[0:0.005:1.25]);    
% end
% nbstim=length(Start(StimEpoch));
% 
% pasDis=0.016;
% for k=1:10
%     TotalEpoch{k}=intervalSet([],[]);
%     ststim=Start(StimEpoch);
%     for i=1:length(Start(StimEpoch))
%         dx=Data(CleanAlignedXtsd)-Data(Restrict(CleanAlignedXtsd,ts(ststim(i))));
%         dy=Data(CleanAlignedYtsd)-Data(Restrict(CleanAlignedYtsd,ts(ststim(i))));
%         dis=sqrt(dx.^2+dy.^2);
%         distsd{i}=tsd(Range(CleanAlignedXtsd),sqrt(dx.^2+dy.^2));
%         if k>1
%             EpochD=thresholdIntervals(distsd{i},(k-1)*pasDis,'Direction','Above');
%             EpochU=thresholdIntervals(distsd{i},k*pasDis,'Direction','Below');
%             Epoch=and(EpochD,EpochU);
%         else
%             Epoch=thresholdIntervals(distsd{i},pasDis,'Direction','Below');
%         end
%         st=Start(Epoch);
%         en=End(Epoch);
%         TEpoch=intervalSet(st,en);
%         TotalEpoch{k}=or(TotalEpoch{k},TEpoch);
%     end
%     TotalEpoch{k}=mergeCloseIntervals(TotalEpoch{k},1);
% end

end
