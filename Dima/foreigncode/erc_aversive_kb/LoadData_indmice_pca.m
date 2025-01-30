% function [b, ss, r, Hab, Cond, Res, replayGtsd, composition] = LoadData_indmice_pca(dir, expe, num_pc, binS, PeriodAnalyse)
function [b, ss, r, Hab, Cond, replayGtsd] = LoadData_indmice_pca(dir, expe, num_pc, binS, PeriodAnalyse)


%% Load data
% Spike
s = load(fullfile(dir, 'SpikeData.mat'), 'S');
% Ripples 
try
    r = load(fullfile(dir, 'SWR.mat'));
catch
    r = load(fullfile(dir, 'Ripples.mat'));
end
rip=ts(r.ripples(:,2)*1E4);
RipEpoch=intervalSet(r.ripples(:,2)*1E4-0.2E4, r.ripples(:,2)*1E4+0.2E4);
% Sleep scoring
try
    ss = load(fullfile(dir, 'SleepScoring_OBGamma.mat'), 'Wake', 'REMEpoch', 'SWSEpoch', 'TotalNoiseEpoch');
catch
    ss = load(fullfile(dir, 'SleepScoring_Accelero.mat'), 'Wake', 'REMEpoch', 'SWSEpoch', 'TotalNoiseEpoch');
end
Wake=ss.Wake-ss.TotalNoiseEpoch;
REMEpoch=ss.REMEpoch-ss.TotalNoiseEpoch;
SWSEpoch=ss.SWSEpoch-ss.TotalNoiseEpoch;

% Behavior
b = load(fullfile(dir, 'behavResources.mat'), 'AlignedXtsd', 'AlignedYtsd', 'SessionEpoch',...
    'FreezeAccEpoch', 'ZoneEpoch', 'TTLInfo', 'Vtsd');
b.StimEpoch = b.TTLInfo.StimEpoch;
if strcmp(expe, 'PAG')
    [SessionHab, TestPre, ~, Cond, FullTask, TestPost] = ReturnMnemozyneEpochs(b.SessionEpoch);
elseif strcmp(expe, 'MFB')
    [SessionHab, TestPre, ~, Cond, FullTask, TestPost] = ReturnMnemozyneEpochs(b.SessionEpoch, 'NumberTests', 8);
end

% Remove noise
Hab=SessionHab-ss.TotalNoiseEpoch;
TestPre=TestPre-ss.TotalNoiseEpoch;
% TestPost=TestPost-ss.TotalNoiseEpoch;
Cond=Cond-ss.TotalNoiseEpoch;
FullTask=FullTask-ss.TotalNoiseEpoch;

%% Do spike time histograms
Q=MakeQfromS(s.S,binS);

Qpre=zscore(full(Data(Restrict(Q,and(SWSEpoch,b.SessionEpoch.PreSleep)))));
Qpost=zscore(full(Data(Restrict(Q,and(SWSEpoch,b.SessionEpoch.PostSleep)))));
QpreREM=zscore(full(Data(Restrict(Q,and(REMEpoch,b.SessionEpoch.PreSleep)))));
QpostREM=zscore(full(Data(Restrict(Q,and(REMEpoch,b.SessionEpoch.PostSleep)))));
QpreRip=zscore(full(Data(Restrict(Q,and(RipEpoch,b.SessionEpoch.PreSleep)))));
QpostRip=zscore(full(Data(Restrict(Q,and(RipEpoch,b.SessionEpoch.PostSleep)))));

Qhab=zscore(full(Data(Restrict(Q,Hab))));
Qcond=zscore(full(Data(Restrict(Q,Cond))));
QcondFree=zscore(full(Data(Restrict(Q,and(Cond,b.FreezeAccEpoch)))));
QcondNoFree=zscore(full(Data(Restrict(Q,Cond-b.FreezeAccEpoch))));
Qfull=zscore(full(Data(Q)));

Qwake=zscore(full(Data(Restrict(Q,FullTask))));
QTestPre=zscore(full(Data(Restrict(Q,TestPre))));
QTestPost=zscore(full(Data(Restrict(Q,TestPost))));    
            
eval(['Qanalyse=Q',PeriodAnalyse,';'])

%% Calculate EV
[EV,REV] = ExplainedVariance(Qpre, Qanalyse, Qpost);

%% Calculate pca
C = corrcoef(Qanalyse);
C(isnan(C))=0;
C=C-diag(diag(C));
[PCweights,L,E] = pcacov(C);

% Elbow rule?
% figure, plot(L,'o-');
% xlabel('Number of PC');
% ylabel('Eigenvalue')
% makepretty

%% Find reactivation scores
% Sleep
scorePRE = zscore(Qpre)*PCweights(:,num_pc);
singleNpre = (zscore(Qpre).^2)*(PCweights(:,num_pc).^2);
replayPRE = scorePRE.^2 - singleNpre;

scorePOST = zscore(Qpost)*PCweights(:,num_pc);
singleNpost = (zscore(Qpost).^2)*(PCweights(:,num_pc).^2);
replayPOST = scorePOST.^2 - singleNpost;

% %REM
% scorePRER = zscore(QpreREM)*PCweights(:,num_pc);
% singleNpreR = (zscore(QpreREM).^2)*(PCweights(:,num_pc).^2);
% replayPRER = scorePRER.^2 - singleNpreR;
% 
scorePOSTR = zscore(QpostREM)*PCweights(:,num_pc);
singleNpostR = (zscore(QpostREM).^2)*(PCweights(:,num_pc).^2);
replayPOSTR = scorePOSTR.^2 - singleNpostR;

% Wake
scoreWAKE = zscore(Qwake)*PCweights(:,num_pc);
singleWAKE = (zscore(Qwake).^2)*(PCweights(:,num_pc).^2);
replayWAKE = scoreWAKE.^2 - singleWAKE;


Qf=full(Data(Q));
scoreG = zscore(Qf)*PCweights(:,num_pc);
singleNG = (zscore(Qf).^2)*(PCweights(:,num_pc).^2);
replayG = scoreG.^2 - singleNG;
replayGtsd=tsd(Range(Q),replayG);

replayWAKEtsd=tsd(Range(Restrict(Q,FullTask)),replayWAKE); 
replayPOSTtsd=tsd(Range(Restrict(Q,and(ss.SWSEpoch,b.SessionEpoch.PostSleep))),replayPOST); 
replayPREtsd=tsd(Range(Restrict(Q,and(ss.SWSEpoch,b.SessionEpoch.PreSleep))),replayPRE); 

%%

% Mhab=(Data(Restrict(replayWAKEtsd,Hab)));
% Mcond=(Data(Restrict(replayWAKEtsd,Cond)));
% McondFree=(Data(Restrict(replayWAKEtsd,and(Cond,b.FreezeAccEpoch))));
% McondNoFree=(Data(Restrict(replayWAKEtsd,Cond-b.FreezeAccEpoch)));
% Mpre=(Data(Restrict(replayWAKEtsd,TestPre)));
% 
% 
% Res=[EV,REV,mean(replayPRE),mean(replayPOST),mean(replayPRER),mean(replayPOSTR),mean(replayWAKE),...
%     mean(Mcond),mean(McondFree),mean(McondNoFree),mean(Mhab),mean(Mpre) L(num_pc)];
% composition = {'EV', 'REV', 'RS_PreS', 'RS_PostS', 'RS_PreSRipples', 'RS_PostSRipples',...
%     'RS_wake', 'RS_Cond', 'RS_CondFreeze', 'RS_CondNoFreeze', 'RS_Hab', 'RS_TestPre', 'PC'};
end
