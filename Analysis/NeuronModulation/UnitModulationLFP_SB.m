function [PhasesSpikes,mu,Kappa,pval,Z]=UnitModulationLFP_SB(S,fil,epoch,nbin,plo,FiltOrPhase)

% This code applies the transformation given in Siapas, 2005 to correct for
% nonuniform distributions of LFP phases
% The code accomodates input of filtered LFP data (set FiltOrPhase to 1 or
% put nothing) and also direct phase input (set FiltOrPhase to 2)
% 
% INPUT :
% S         : tsd with a single neuron's firing
% fil       : the filtered LFP data or direct phase input
% epoch     : epoch to restrict analysis
% nbin      : number of bins to use for histogram
% plo       : 1 for figure, 0 otherwize
%           --> default is 0 (no figure)
% FiltOrPhase : 1 if you're giving filtered data, 0 if its the phase
%              --> default is 1 (filtered data)
%
%
% OUTPUT :
% PhasesSpikes : The phase of all the spikes given as input
% mu           : The preferred phase
% Kappa        : The depth of modulation
% pval         : The significance of modulation
% Z            : The Rayleigh z test statistics

% example :
% [ph,mu, Kappa, pval,B,C]=ModulationTheta(S{numNeurons(1)},fil,Epoch{9},30,1);

%% Remove from paths confilcting CircularMean.m

%%
try FiltOrPhase; catch, FiltOrPhase=1; end
try plo; catch, plo=0; end

% In case of empty epoch or no spikes

if sum(Stop(epoch,'s')-Start(epoch,'s'))==0 | length(Range(Restrict(S,epoch)))==0
    mu.Nontransf = NaN;
    Kappa.Nontransf = NaN;
    pval.Nontransf = NaN;
    mu.Transf = NaN;
    Kappa.Transf = NaN;
    pval.Transf = NaN;
    PhasesSpikes.Transf=[];
    PhasesSpikes.Nontransf=[];
    Z.Transf=[];
    Z.Nontransf=[];
    
else
    
    
    %% Distribution of LFP and spike phases
    if FiltOrPhase==1
        [phaseLFP, phaseSpike] = firingPhaseHilbert(fil, Restrict(tsdArray(S), epoch));
    else
        phaseLFP=fil;
        ph = Restrict(phaseLFP, S, 'align', 'closest', 'time', 'align');
        ph = ph(:);
        phaseSpike = tsdArray(ph);
        clear ph
    end
    
    phaseLFP=Restrict(phaseLFP,epoch);
    % this was the mistake!!!!!!!!!!!!!!!!!!!!!! SB changed this on Jan
    % 2019 because it lead to confusion with the mu value
    % Old :
    %     phaseLFP=tsd(Range(phaseLFP),Data(phaseLFP)-pi);
    %     phaseSpike{1}=tsd(Range(phaseSpike{1}),Data(phaseSpike{1})-pi);
    % New :
    phaseLFP=tsd(Range(phaseLFP),Data(phaseLFP));
    phaseSpike{1}=tsd(Range(phaseSpike{1}),Data(phaseSpike{1}));
    
    
    % Get correction function
    [fedf,xedf]=ecdf(Data(phaseLFP));
    Funct=2*pi*(fedf);
    
    % Correct phases of LFP
    bins = discretize(Data(phaseLFP), xedf);
    
    TransPh=Funct(bins);
    
    PhasesLFP.Nontransf=Data(phaseLFP);
    PhasesLFP.Transf=TransPh;
    clear TransPh BinnedPh
    
    [DistLFP.NonTransf,XLFP.NonTransf]=hist(PhasesLFP.Nontransf,nbin);
    [DistLFP.Transf,XLFP.Transf]=hist(PhasesLFP.Transf,nbin);
    
    %% Modulation neuron by fil
    % Correct phases
    bins = discretize(Data(phaseSpike{1}), xedf);
    
    % if the LFP phases do not completely cover range of phases, there will
    % be nans in 'bins' --> match to closest bin
    if sum(isnan(bins))>0
        BinsToFix=find(isnan(bins));
        TempPhaseVar=Data(phaseSpike{1});
        for fix=1:length(BinsToFix)
            [val,ind]=min(abs(TempPhaseVar(BinsToFix(fix))-xedf));
            bins(BinsToFix(fix))=ind;
        end
    end
    TransPh=Funct(bins);
    
    % Get Phase distributions of LFP
    PhasesSpikes.Nontransf=Data(phaseSpike{1});
    PhasesSpikes.Transf=TransPh;
    
    % remove some paths to get the correct circular mean
    rmpath( [dropbox,'/Kteam/PrgMatlab/FMAToolbox/General/']);
    rmpath([dropbox, '/Kteam/PrgMatlab/Fra/UtilsStats/']);
    
    [mu.Nontransf, Kappa.Nontransf, pval.Nontransf, Rmean, delta, sigma,confDw,confUp] = CircularMean(PhasesSpikes.Nontransf);
    Z.Nontransf = length(PhasesSpikes.Nontransf) * Rmean^2;
    [mu.Transf, Kappa.Transf, pval.Transf, Rmean, delta, sigma,confDw,confUp] = CircularMean(PhasesSpikes.Transf);
    Z.Transf = length(PhasesSpikes.Transf) * Rmean^2;
    % Add the paths back
    addpath(genpath( [dropbox,'/Kteam/PrgMatlab/FMAToolbox/General/']))
    addpath(genpath([dropbox, '/Kteam/PrgMatlab/Fra/UtilsStats/']))

    if plo
        
        [DistSpike.NonTransf,XSpike.NonTransf]=hist(PhasesSpikes.Nontransf,nbin);
        [DistSpike.Transf,XSpike.Transf]=hist(PhasesSpikes.Transf,nbin);
        
        figure('Color',[1 1 1],'units','normalized','outerposition',[0 0 1 1]),
        subplot(1,2,1),
        stairs([XLFP.NonTransf,XLFP.NonTransf+2*pi],[DistLFP.NonTransf,DistLFP.NonTransf],'k','linewidth',3), hold on
        stairs([XLFP.Transf,XLFP.Transf+2*pi],[DistLFP.Transf,DistLFP.Transf],'g','linewidth',2)
        title('Phase distribution LFP (rad)')
        xlabel('Phase (rad)'); ylabel('number of event')
        xlim([0 4*pi])
        legend('Bef transf','Aft transf')
        
        subplot(1,2,2),
        stairs([XSpike.NonTransf,XSpike.NonTransf+2*pi],[DistSpike.NonTransf,DistSpike.NonTransf],'color',[0.6 0.6 0.6],'linewidth',3), hold on
        stairs([XSpike.Transf,XSpike.Transf+2*pi],[DistSpike.Transf,DistSpike.Transf],'g','linewidth',2)
        if FiltOrPhase
            yyaxis right
            for p = 1:nbin
                LitEpoch = thresholdIntervals(phaseLFP,(p-1)*2*pi/nbin,'Direction','Above');
                LitEpoch = and(LitEpoch,thresholdIntervals(phaseLFP,(p)*2*pi/nbin,'Direction','Below'));
                %                 plot(Start(LitEpoch),p,'r*')
                %                 hold on
                MeanFil(p) = nanmean(Data(Restrict(fil,LitEpoch)));
            end
            plot([XSpike.NonTransf,XSpike.NonTransf+2*pi],[MeanFil,MeanFil],'linewidth',2,'color','r')
            ylabel('triggered LFP')
            set(gca,'ycolor','r')
            yyaxis left
        end
        line([1 1]*mu.Nontransf,ylim,'color','k','linewidth',4,'linestyle',':')
        line([1 1]*mu.Transf,ylim,'color',[0.4 0.8 0.4],'linewidth',4,'linestyle',':')
        line([1 1]*mu.Nontransf+2*pi,ylim,'color','k','linewidth',4,'linestyle',':')
        line([1 1]*mu.Transf+2*pi,ylim,'color',[0.4 0.8 0.4],'linewidth',4,'linestyle',':')
        YL = ylim;
        ylim([0 YL(2)*1.2])
        if pval.Nontransf<0.05
        plot([1]*mu.Nontransf,YL(2)*1.1,'*','color','k')
        plot([1]*mu.Nontransf+2*pi,YL(2)*1.1,'*','color','k')
        end
        if pval.Transf<0.05
        plot([1]*mu.Transf,YL(2)*1.1,'*','color',[0.4 0.8 0.4])
        plot([1]*mu.Transf+2*pi,YL(2)*1.1,'*','color',[0.4 0.8 0.4])
        end
        xlim([0 4*pi])
        
        
        
        title(['Phase distribution Spikes (rad) ',num2str(length(PhasesSpikes.Nontransf))])
        xlabel('Phase (rad)'); ylabel('number of event')
        xlim([0 4*pi])
        legend('Bef transf','Aft transf')
    end
end


