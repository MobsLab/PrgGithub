function [GC2,CAUSF,Peri,nameCh]=Granger_ToolKB(deb,ch)

% Granger_ToolKB
%-----------------------------------------------------------------------
% PURPOSE:  Show Granger causality between several signals
%
% INPUTS:   None
%
% OUTPUT:   graphical output
%          
%-----------------------------------------------------------------------

FilFreq=[0];

partGC=0;

%   demo parameters
inter=10;
try
    deb;
    deb=deb+10;
catch
deb=10;
end
fin=deb+inter;
Epoch=intervalSet(deb*1E4,fin*1E4);


%load SleepStagesPaCxDeep
%Epoch=subset(S12,6);
%Epoch=subset(S34,8);

clear SWSEpoch
try
load StateEpochSB SWSEpoch REMEpoch Wake
MovEpoch=Wake;
SWSEpoch;
catch
load StateEpoch SWSEpoch REMEpoch MovEpoch

end


%Epoch=subset(SWSEpoch,1);
%Epoch=REMEpoch;
%Epoch=REMEpoch;
%Epoch=subset(MovEpoch,3);

Fs      =   120;                    % sampling frequency  (for spectral analysis only)
[X,nameCh]       =   LoadingFiles(Epoch,Fs,FilFreq,ch); % Signals - Between a and b in seconds
% X       =   LoadingFiles(Epoch,Fs); % Signals - Between a and b in seconds
%X       =   LoadingFiles(Epoch,Fs,[10 150]); % Signals - Between a and b in seconds
N       =   length(X);              % number of observations
PVAL    =   0.05;                   % probability threshold for Granger causality significance
NLAGS   =   -1;                     % if -1, best model order is assessed automatically
freqs   =   [0.5:0.5:floor(Fs/2)];    % frequency range to analyze (spectral analysis only)

%   add toolbox filepaths
%ccaStartup;

disp(' ')
disp('***************** Granger Analysis *****************')
disp(' ')
sfile = ['Granger_Tool',num2str(1),'.net'];
nvar = size(X,1);

% detrend and demean data
disp('detrending and demeaning data');
X = cca_detrend(X);
X = cca_rm_temporalmean(X);

% check covariance stationarity
disp('checking for covariance stationarity ...');
uroot = cca_check_cov_stat(X,10);
inx = find(uroot);
if sum(uroot) == 0,
    disp('OK, data is covariance stationary by ADF');
else
    disp('WARNING, data is NOT covariance stationary by ADF');
    disp(['unit roots found in variables: ',num2str(inx(1))]);
end

% check covariance stationarity again using KPSS test
[kh,kpss] = cca_kpss(X);
inx = find(kh==0);
if isempty(inx),
    disp('OK, data is covariance stationary by KPSS');
else
    disp('WARNING, data is NOT covariance stationary by KPSS');
    disp(['unit roots found in variables: ',num2str(inx)]);
end
    
% find best model order
if NLAGS == -1,
    disp('finding best model order ...');
    [bic,aic] = cca_find_model_order_optimized(X,8,15);
    disp(['best model order by Bayesian Information Criterion = ',num2str(bic)]);
    disp(['best model order by Aikaike Information Criterion = ',num2str(aic)]);
    NLAGS = bic;
end

%-------------------------------------------------------------------------
% analyze time-domain granger

% find time-domain conditional Granger causalities [THIS IS THE KEY FUNCTION]
disp('finding conditional Granger causalities ...');
ret = cca_granger_regress(X,NLAGS,1);   % STATFLAG = 1 i.e. compute stats

% check that residuals are white
dwthresh = 0.05/nvar;    % critical threshold, Bonferroni corrected
waut = zeros(1,nvar);
for ii=1:nvar,
    if ret.waut<dwthresh,
        waut(ii)=1;
    end
end
inx = find(waut==1);
if isempty(inx),
    disp('All residuals are white by corrected Durbin-Watson test');
else
    disp(['WARNING, autocorrelated residuals in variables: ',num2str(inx)]);
end

% check model consistency, ie. proportion of correlation structure of the
% data accounted for by the MVAR model
if ret.cons>=80,
    disp(['Model consistency is OK (>80%), value=',num2str(ret.cons)]);
else
    disp(['Model consistency is <80%, value=',num2str(ret.cons)]);
end
        
% analyze adjusted r-square to check that model accounts for the data (2nd
% check)
rss = ret.rss_adj;
inx = find(rss<0.3);
if isempty(inx)
    disp(['Adjusted r-square is OK: >0.3 of variance is accounted for by model, val=',num2str(mean(rss))]);
else
    disp(['WARNING, low (<0.3) adjusted r-square values for variables: ',num2str(inx)]);
    disp(['corresponding values are ',num2str(rss(inx))]);
    disp('try a different model order');
end

% find significant Granger causality interactions (Bonferonni correction)
[PR,q] = cca_findsignificance(ret,PVAL,1);
disp(['testing significance at P < ',num2str(PVAL), ', corrected P-val = ',num2str(q)]);

% extract the significant causal interactions only
GC = ret.gc;
GC2 = GC.*PR;


% calculate causal connectivity statistics
disp('calculating causal connectivity statistics');
causd = cca_causaldensity(GC,PR);
causf = cca_causalflow(GC,PR);

CAUSF=causf;

disp(['time-domain causal density = ',num2str(causd.cd)]);
disp(['time-domain causal density (weighted) = ',num2str(causd.cdw)]);

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
if partGC
% calculate partial G-causality
disp('finding Partial Granger causalities ...');
retP= cca_partialgc(X,NLAGS,-1);   % STATFLAG = 1 i.e. compute stats
end

% find significant Granger causality interactions (Bonferonni correction)
[PRp,qp] = cca_findsignificance(ret,PVAL,1);
disp(['testing significance at P < ',num2str(PVAL), ', corrected P-val = ',num2str(qp)]);

try
% extract the significant causal interactions only
GCp = retP.fg;
GCp2 = GCp.*PRp;
end
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% calculate G-autonomies 
retA = cca_autonomy_regress(X,NLAGS);

% analyze adjusted r-square to check that model accounts for the data
rss = retA.rss_adj;
inx = find(rss<0.3);
if isempty(inx)
    disp('Adjusted r-square is OK: >0.3 of variance is accounted for by model');
else
    disp(['WARNING, low adjusted r-square values for variables: ',num2str(inx)]);
    disp(['corresponding values are ',num2str(rss(inx))]);
end

%   extract significant autonomies
[PRa,qa] = cca_findsignificance_autonomy(retA,PVAL,1);
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

% create Pajek readable file
% cca_pajek(PR,GC,sfile);
cca_pajek(PR,GC,sfile,nameCh);

%-------------------------------------------------------------------------
% plot time-domain granger results
figure(1); clf reset;
FSIZE = 8;
colormap(flipud(bone));

% plot raw time series
for i=2:nvar,
    X(i,:) = X(i,:)+(10*(i-1));
end
subplot(231);
set(gca,'FontSize',FSIZE);
plot(X');
axis('square');
set(gca,'Box','off');
xlabel('time');
set(gca,'YTick',[]);
xlim([0 N]);
title('Causal Connectivity Toolbox v2.0');

% plot granger causalities as matrix
subplot(232);
set(gca,'FontSize',FSIZE);
imagesc(GC2);
axis('square');
set(gca,'Box','off');
title(['Granger causality, p<',num2str(PVAL)]);
xlabel('from');
ylabel('to');
set(gca,'XTick',[1:N]);
try
set(gca,'XTickLabel',nameCh);
catch
set(gca,'XTickLabel',1:N);
end
set(gca,'YTick',[1:N]);
try
set(gca,'YTickLabel',nameCh);
catch
set(gca,'YTickLabel',1:N);
end

% plot Partial granger causalities as matrix
try
    subplot(233);
    set(gca,'FontSize',FSIZE);
    imagesc(GCp2);
    axis('square');
    set(gca,'Box','off');
    title(['Partial Granger causality, p<',num2str(PVAL)]);
    xlabel('from');
    ylabel('to');
    set(gca,'XTick',[1:N]);
    try
    set(gca,'XTickLabel',nameCh);
    catch
    set(gca,'XTickLabel',1:N);
    end
    set(gca,'YTick',[1:N]);
    try
    set(gca,'YTickLabel',nameCh);
    catch
    set(gca,'YTickLabel',1:N);
    end
end


% plot granger causalities as a network
subplot(234);
cca_plotcausality(GC2,nameCh,5);

% plot causal flow  (bar = unweighted, line = weighted)
subplot(235);
set(gca,'FontSize',FSIZE);
set(gca,'Box','off');
mval1 = max(abs(causf.flow));
mval2 = max(abs(causf.wflow));
mval = max([mval1 mval2]);
bar(1:nvar,causf.flow,'m');
ylim([-(mval+1) mval+1]);
xlim([0.5 nvar+0.5]);
set(gca,'XTick',[1:nvar]);
try
set(gca,'XTickLabel',nameCh);
catch
set(gca,'XTickLabel',1:nvar);
end
title('causal flow');
ylabel('out-in');
hold on;
plot(1:nvar,causf.wflow);
axis('square');

% plot unit causal densities  (bar = unweighted, line = weighted)
subplot(236);
set(gca,'FontSize',FSIZE);
set(gca,'Box','off');
mval1 = max(abs(causd.ucd));
mval2 = max(abs(causd.ucdw));
mval = max([mval1 mval2]);
bar(1:nvar,causd.ucd,'m');
ylim([-0.25 mval+1]);
xlim([0.5 nvar+0.5]);
set(gca,'XTick',[1:nvar]);
try
set(gca,'XTickLabel',nameCh);
catch
set(gca,'XTickLabel',1:nvar);
end
title('unit causal density');
hold on;
plot(1:nvar,causd.ucdw);
axis('square');

%-------------------------------------------------------------------------
% analyze frequency-domain granger

SPECTHRESH = 0.2.*ones(1,length(freqs));    % bootstrap not used

% find pairwise frequency-domain Granger causalities [KEY FUNCTION]
disp('finding pairwise frequency-domain Granger causalities ...');
[GW,COH,pp]=cca_pwcausal(X,1,N,NLAGS,Fs,freqs,0);

% calculate freq domain causal connectivity statistics
disp('calculating causal connectivity statistics');
causd = cca_causaldensity_spectral(GW,SPECTHRESH);
causf = cca_causalflow_spectral(GW,SPECTHRESH);

totalcd = sum(causd.scdw);
disp(['freq-domain causal density (weighted) = ',num2str(totalcd)]);

%-------------------------------------------------------------------------
% plot frequency-domain granger results
figure(2); clf reset;
FSIZE = 8;
colormap(flipud(bone));

% plot fft for each variable
ct = 1;
for i=1:nvar,
    subplot(3,nvar,ct);
    cca_spec(X(i,:),Fs,max(freqs),1);
    title(['v',num2str(i)]);
    if i==1,
        ylabel('fft: amplitude');
    end
    ct = ct+1;
    set(gca,'Box','off');
end

% plot causal density spectrum for each variable
for i=1:nvar,
    subplot(3,nvar,ct);
    plot(causd.sucdw(i,:));
    if i==1,
        ylabel('unit cd');
    end
    ct = ct+1;
    set(gca,'Box','off');
end

% plot causal flow spectrum for each variable
for i=1:nvar,
    subplot(3,nvar,ct);
    plot(causf.swflow(i,:));
    if i==1,
        ylabel('unit flow');
    end
    ct = ct+1;
    set(gca,'Box','off');
end

% plot network causal density
figure(3); clf reset;
plot(causd.scdw);
set(gca,'Box','off');
title(['spectral cd, total=',num2str(totalcd),', thresh=',num2str(SPECTHRESH)]);
xlabel('Hz');
ylabel('weighted cd');

% plot causal interactions
figure(4); clf reset;
cca_plotcausality_spectral(GW,freqs);

% plot coherence
figure(5); clf reset;
cca_plotcoherence(COH,freqs);

%   plot autonomy
figure(6); clf reset;
GA = retA.gaut;
GA = GA.*PRa;
bar(1:length(GA),GA);
xlabel('variable');
ylabel('G-autonomy');
set(gca,'Box','off');

disp('  ')
disp(['SWS: ',num2str(sum(End(and(SWSEpoch,Epoch),'s')-Start(and(SWSEpoch,Epoch),'s'))),',  REM: ',num2str(sum(End(and(REMEpoch,Epoch),'s')-Start(and(REMEpoch,Epoch),'s'))),',  Wake: ',num2str(sum(End(and(MovEpoch,Epoch),'s')-Start(and(MovEpoch,Epoch),'s')))])
disp('  ')


Peri(1)=sum(End(and(SWSEpoch,Epoch),'s')-Start(and(SWSEpoch,Epoch),'s'));
Peri(3)=sum(End(and(REMEpoch,Epoch),'s')-Start(and(REMEpoch,Epoch),'s'));
Peri(2)=sum(End(and(MovEpoch,Epoch),'s')-Start(and(MovEpoch,Epoch),'s'));


% Image
figure(7);

subplot(223);

load LFPData/InfoLFP;
% na=InfoLFP.structure;
na=nameCh;
le=length(na);
na{le+1}='Respi';
try
cca_plotcausality(GC2,na,5);
catch
    cca_plotcausality(GC2,[],5);
end

subplot(224);
set(gca,'FontSize',FSIZE);
imagesc(GC2);
axis('square');
set(gca,'Box','off');
title(['Granger causality, p<',num2str(PVAL)]);
xlabel('from');
ylabel('to');
set(gca,'XTick',[1:N]);
try
set(gca,'XTickLabel',nameCh);
catch
set(gca,'XTickLabel',1:N);
end
set(gca,'YTick',[1:N]);
try
set(gca,'YTickLabel',nameCh);
catch
set(gca,'YTickLabel',1:N);
end
tesst=gray;
colormap;
colormap(tesst(end:-1:1,:));

state = ['SWS: ',num2str(sum(End(and(SWSEpoch,Epoch),'s')-Start(and(SWSEpoch,Epoch),'s'))),',  REM: ',num2str(sum(End(and(REMEpoch,Epoch),'s')-Start(and(REMEpoch,Epoch),'s'))),',  Wake: ',num2str(sum(End(and(MovEpoch,Epoch),'s')-Start(and(MovEpoch,Epoch),'s')))];
 annotation('textbox', [0.1 0.2 .4 .3], 'FitBoxToText', 'ON', 'Fontsize', 9, ...
            'String', state);

       if 0
try
res=pwd;
cd /media/DataMOBsRAID5/ProjetAstro/DataPlethysmo
mkdir test_img
eval(['cd(''',res,''')'])
fname = sprintf('/media/DataMOBsRAID5/ProjetAstro/DataPlethysmo/test_img/Noscall%d_%d.png', deb,fin);
saveas(figure(7),fname)
end
       end
figure(7)
