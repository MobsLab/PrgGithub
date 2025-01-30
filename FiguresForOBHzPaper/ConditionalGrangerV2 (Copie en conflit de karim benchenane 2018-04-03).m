clear all,close all

clear all
Dir=PathForExperimentFEAR('Fear-electrophy-plethysmo');
ntrials   = 1;     % number of trials
nvars = 3; % number of variables

regmode   = 'OLS';  % VAR model estimation regression mode ('OLS', 'LWR' or empty for default)
icregmode = 'LWR';  % information criteria regression mode ('OLS', 'LWR' or empty for default)
morder    = 'AIC';  % model order to use ('actual', 'AIC', 'BIC' or supplied numerical value)
momax     = 100;     % maximum model order for model order estimation
acmaxlags = [];   % maximum autocovariance lags (empty for automatic calculation)
tstat     = '';     % statistical test for MVGC:  'F' for Granger's F-test (default) or 'chi2' for Geweke's chi2 test
alpha     = 0.05/(nvars^2);   % significance level for significance test
mhtc      = 'FDR';  % multiple hypothesis test correction (see routine 'significance')
fs        = 125;    % sample rate (Hz)
fres      = [];     % frequency resolution (empty for automatic calculation)

for mm=2%:length(Dir.path) % mouse 1 has no reliable PFCx
    cd(Dir.path{mm})
    clear FreezeEpoch NoFreezeEpoch BreathNoiseEpoch TotalNoiseEpoch
    load('behavResources.mat')
    load('BreathingInfo.mat','BreathNoiseEpoch')
    load('StateEpochSB.mat','TotalNoiseEpoch')
    TotalNoiseEpoch=or(TotalNoiseEpoch,BreathNoiseEpoch);
    FreezeEpoch=FreezeEpoch-TotalNoiseEpoch;FreezeEpoch=dropShortIntervals(FreezeEpoch,3*1e4);
    NoFreezeEpoch=NoFreezeEpoch-TotalNoiseEpoch;NoFreezeEpoch=dropShortIntervals(NoFreezeEpoch,3*1e4);
    Ep{1}=FreezeEpoch; Ep{2}=NoFreezeEpoch,
    load('ChannelsToAnalyse/Bulb_deep.mat')
    load(['LFPData/LFP',num2str(channel),'.mat'])
    FilLFP=FilterLFP((LFP),[1 80],1024);
    DataLFP.OB=FilLFP;
    load('ChannelsToAnalyse/PFCx_deep.mat')
    load(['LFPData/LFP',num2str(channel),'.mat'])
    FilLFP=FilterLFP((LFP),[1 80],1024);
    DataLFP.P=FilLFP;
    load('ChannelsToAnalyse/Respi.mat')
    load(['LFPData/LFP',num2str(channel),'.mat'])
    FilLFP=FilterLFP((LFP),[1 80],1024);
    DataLFP.Respi=FilLFP;
    
    
    for ep=1:2
        for st=1:length(Start(Ep{ep}))
            LitEpToUse=subset(Ep{ep},st);
            EpDur{ep,st}=Stop(LitEpToUse,'s')-Start(LitEpToUse,'s');
            %% Parameters
            X=[Data(Restrict(DataLFP.Respi,LitEpToUse)),Data(Restrict(DataLFP.OB,LitEpToUse)),Data(Restrict(DataLFP.P,LitEpToUse))]';
            X=X(:,1:10:end);
            nobs      = size(X,2);   % number of observations per trial
            
            %% Model order estimation (<mvgc_schema.html#3 |A2|>)
            % Calculate information criteria up to specified maximum model order.
            ptic('\n*** tsdata_to_infocrit\n');
            [AIC,BIC,moAIC{ep,st},moBIC{ep,st}] = tsdata_to_infocrit(X,momax,icregmode);
            ptoc('*** tsdata_to_infocrit took ');
            % Use BIC order
            morder = moAIC{ep,st};
            
            %% VAR model estimation (<mvgc_schema.html#3 |A2|>)
            % Estimate VAR model of selected order from data.
            ptic('\n*** tsdata_to_var... ');
            [A,SIG] = tsdata_to_var(X,morder,regmode);
            ptoc;
            
            % Check for failed regression
            assert(~isbad(A),'VAR estimation failed');
            
            %% Autocovariance calculation (<mvgc_schema.html#3 |A5|>)
            % The autocovariance sequence drives many Granger causality calculations (see
            % next section). Now we calculate the autocovariance sequence G according to the
            % VAR model, to as many lags as it takes to decay to below the numerical
            % tolerance level, or to acmaxlags lags if specified (i.e. non-empty).
            
            ptic('*** var_to_autocov... ');
            [G{ep,st},info{ep,st}] = var_to_autocov(A,SIG,acmaxlags);
            ptoc;
            
            % The above routine does a LOT of error checking and issues useful diagnostics.
            % If there are problems with your data (e.g. non-stationarity, colinearity,
            % etc.) there's a good chance it'll show up at this point - and the diagnostics
            % may supply useful information as to what went wrong. It is thus essential to
            % report and check for errors here.
            
            var_info(info{ep,st},true); % report results (and bail out on error)
            
            %% Granger causality calculation: time domain  (<mvgc_schema.html#3 |A13|>)
            % Calculate time-domain pairwise-conditional causalities - this just requires
            % the autocovariance sequence.
            
            ptic('*** autocov_to_pwcgc... ');
            F{ep,st} = autocov_to_pwcgc(G{ep,st});
            ptoc;
            
            % Check for failed GC calculation
            
            assert(~isbad(F{ep,st},false),'GC calculation failed');
            
            % Significance test using theoretical null distribution, adjusting for multiple
            % hypotheses.
            
            pval{ep,st} = mvgc_pval(F{ep,st},morder,nobs,ntrials,1,1,nvars-2,''); % take careful note of arguments!
            sig{ep,st}  = significance(pval{ep,st},alpha,mhtc);
            
            % Plot time-domain causal graph, p-values and significance.
            CausDens{ep,st} = mean(F{ep,st}(~isnan(F{ep,st})));
            
%             % Theoretical confidence intervals.
%             
%             [FTUP,FTLO] = mvgc_confint(alpha,F{ep,st},morder,nobs,ntrials,1,1,nvars-2,tstat);
% 
%             % Critical GC value.
%             
%             FTCRIT = mvgc_cval(alpha,morder,nobs,ntrials,1,1,nvars-2,tstat);
%             
%             %% Bootstrap
%             
%             ptic('\n*** bootstrap_tsdata_to_pwcgc\n');
%             FSAMP = bootstrap_tsdata_to_pwcgc(X,morder,nsamps);
%             ptoc('*** bootstrap_tsdata_to_pwcgc took ',[],1);
%             
%             % (We should really check for failed bootstrap estimates here.)
%             
%             % Bootstrap (empirical) confidence intervals.
%             
%             [FSUP,FSLO] = empirical_confint(alpha,FSAMP);
            
            
            %% Granger causality calculation: frequency domain  (<mvgc_schema.html#3 |A14|>)
            
            % Calculate spectral pairwise-conditional causalities at given frequency
            % resolution - again, this only requires the autocovariance sequence.
            
            %     ptic('\n*** autocov_to_spwcgc... ');
            %     f{ep,st} = autocov_to_spwcgc(G{ep,st},fres{ep,st});
            %     ptoc;
            %
            %     % Check for failed spectral GC calculation
            %
            %     assert(~isbad(f{ep,st},false),'spectral GC calculation failed');
            %
            %
            clear X
        end
    end
    
    save('ConditionalGranger.mat','pval','sig','CausalDens','F','G','info','moBIC','moAIC','EpDur')
    clear('pval','sig','CausalDens','F','G','info','moBIC','moAIC','EpDur')
    
end
