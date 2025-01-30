clear all
TimeAroundEvent = 2;
Binsize = 0.05*1e4;

% Options For calculation
AfterOnly = 'BefAndAfter'; % If is set to 'AferOnly', only do post-acc time, if ''BefAndAfter' before and after
NormBreathPhase = 'NormBreath'; % If is set to 'NormBreath', norm by breathingPhase, If is set to 'NoNormBreath' doesn't

% load correct LFP for accelero and clean it up
load('LFPData/LFP34.mat')
a = Data(LFP);
a(a<-3.5e4)=NaN;
a(a>-1)=NaN;
aint = naninterp(a);
A=tsd(Range(LFP),[0;diff(aint)]);
LFPClean = tsd(Range(LFP),aint);
LFPClean = tsd(Range(LFP),Data(LFPClean)-movmean(Data(LFPClean),1250*60))

% Get breathing phase
load('BreathingInfo_ZeroCross.mat')
AllPeaks=[0:2*pi:2*pi*(length(Data(Breathtsd))-1)];
Y=interp1(Range(Breathtsd,'s'),AllPeaks,Range(LFP,'s'));
PhaseInterpol=tsd(Range(LFP),mod(Y,2*pi));

% Load the times of detected events
load('NeuronResponseToMovement/Results.mat')

% Classify the types of movement
[MAcc,TAcc]=PlotRipRaw(LFPClean,Start(AccBurst,'s'),5000,0,0);
[EigVect,EigVals]=PerformPCA(zscore(TAcc')');
times = Start(AccBurst);
timesStp = Stop(AccBurst);
[val,ind] = sort(EigVect(:,2));
times = Start(AccBurst);
timessorted = times(ind);
EventType{1} = sort(timessorted(1:400)); % Normal events
EventType{2} = sort(timessorted(900:1300)); % MTZl specific events
EventType{3} = sort(timessorted); % All events
EventNames = {'Type1','Type2','All'};

% load spikes
load('SpikeData.mat')
Q = MakeQfromS(S,Binsize);
Qdat = Data(Q);

% Get neuron phases
load('NeuronModulation/NeuronMod_Respi_ZeroCross_total_nonoise.mat')

% Get breathing phase distribution aroudn events
clear hPhase
for ev = 1:3
    switch AfterOnly
        case 'AferOnly'
            for i=0:TimeAroundEvent./(Binsize/1E4)
                [hPhase{ev}(i+1,:),b]=hist(Data(Restrict(PhaseInterpol,intervalSet(EventType{ev}+(i-1)*1E3,EventType{ev}+i*1E3))),[0.05:0.1:6.25]);
            end
        case 'BefAndAfter'
            for i=-TimeAroundEvent./(Binsize/1E4):TimeAroundEvent./(Binsize/1E4)
                [hPhase{ev}(i+TimeAroundEvent./(Binsize/1E4)+1,:),b]=hist(Data(Restrict(PhaseInterpol,intervalSet(EventType{ev}+(i-1)*Binsize*10,EventType{ev}+i*Binsize*10))),[0.05:0.1:6.25]);
            end
    end
    hPhase{ev}(:,1) = [];
    hPhase{ev}(:,end) = [];
    hPhase{ev}(end,:) = [];
end

AnglesRest = [0.15:0.1:6.15];
Angles = [0.05:0.1:6.25];
fig = figure(1);
mkdir(['NeuronResponseToMovement/ModulationAroundAccEvents50ms_' AfterOnly '_' NormBreathPhase])
for n = 1 :size(Qdat,2)
    
    % Using Nontransf to be comparable with what we infer from the
    % breathing phase x average spiking activity
    PhaseNeur = tsd(Range(Restrict(S{n},epoch)),PhasesSpikes.Nontransf{n});
    
    for ev = 1:3
        [MSp{ev},TSp{ev}]=PlotRipRaw(tsd(Range(Q),Qdat(:,n)),sort(EventType{ev}/1e4),TimeAroundEvent*1e3,0,0);
        

        switch AfterOnly
            case 'AferOnly'
            AngDist{ev} = nanmean(hPhase{ev}.*repmat(MSp{ev}(ceil(size(MSp{ev},1)/2)+1:end,2),1,61));
            case 'BefAndAfter'
            AngDist{ev} = nanmean(hPhase{ev}.*repmat(MSp{ev}(:,2),1,61));
        end

        
        switch NormBreathPhase
            case 'NormBreath'
                AngDist{ev} = AngDist{ev}./nanmean(hPhase{ev});
        end
        
        AngDist{ev} = 1000*AngDist{ev} /max(AngDist{ev});
        AngDist{ev} = naninterp(interp1(AnglesRest,AngDist{ev},Angles));
        
        AngForKappa{ev} = [];
        for k = 1 : length(Angles)
            % Need to add a bit of noise (the size of the bin)
            AngForKappa{ev} = [AngForKappa{ev},ones(1,ceil(AngDist{ev}(k))).*(randn(1,ceil(AngDist{ev}(k)))*0.05+Angles(k))];
        end
        
                
        [muPred{ev}(n), KappaPred{ev}(n), pvalPred{ev}, Rmean, delta, sigma,confDw,confUp] = CircularMean(AngForKappa{ev});
        
        subplot(1,3,ev)
        EpShor = intervalSet(EventType{ev}-2*1E4,EventType{ev}+2*1E4);
        EpShor = mergeCloseIntervals(EpShor,2*1E4);
        [muData{ev}(n), KappaData{ev}(n), pvalData{ev}(n), Rmean, delta, sigma,confDw,confUp] = CircularMean(Data(Restrict(PhaseNeur,EpShor)));
        hist([Data(Restrict(PhaseNeur,EpShor));Data(Restrict(PhaseNeur,EpShor))+2*pi],60), hold on
        YL = ylim;
        plot([1]*muData{ev}(n),YL(2)*1.1,'*','color','b')
        plot([1]*muData{ev}(n)+2*pi,YL(2)*1.1,'*','color','b')
        yyaxis right
        plot([Angles,Angles+2*pi],[AngDist{ev},AngDist{ev}],'linewidth',2,'color','r'), hold on
        YL = ylim;
        plot([1]*muPred{ev}(n),YL(2)+0.1*(YL(2)-YL(1)),'*','color','r')
        plot([1]*muPred{ev}(n)+2*pi,YL(2)+0.1*(YL(2)-YL(1)),'*','color','r')
        title(EventNames{ev})
        
        
        
    end
    saveas(fig.Number,['NeuronResponseToMovement/ModulationAroundAccEvents50ms_' AfterOnly '_' NormBreathPhase '/' cellnames{n} '.png'])
    saveas(fig.Number,['NeuronResponseToMovement/ModulationAroundAccEvents50ms_' AfterOnly '_' NormBreathPhase '/' cellnames{n} '.fig'])
    
        clf 
end

save(['NeuronResponseToMovement/ModulationAroundAccEvents50ms_' AfterOnly '_' NormBreathPhase '/ModulationAroundAccEvents_' AfterOnly '_' NormBreathPhase '.mat'], 'muData','KappaData','pvalData','muPred','KappaPred','pvalPred')

%% Look at results
load('NeuronResponseToMovement/ModulationAroundAccEvents_BefAndAfter_NoNormBreath/ModulationAroundAccEvents_BefAndAfter_NoNormBreath.mat')
load('NeuronResponseToMovement/ModulationAroundAccEvents_AferOnly_NoNormBreath/ModulationAroundAccEvents_AferOnly_NoNormBreath.mat')
load('NeuronResponseToMovement/ModulationAroundAccEvents_AferOnly_NormBreath/ModulationAroundAccEvents_AferOnly_NormBreath.mat')
load('NeuronResponseToMovement/ModulationAroundAccEvents50ms_AferOnly_NoNormBreath/ModulationAroundAccEvents_AferOnly_NoNormBreath.mat')
load('NeuronResponseToMovement/ModulationAroundAccEvents50ms_BefAndAfter_NoNormBreath/ModulationAroundAccEvents_BefAndAfter_NoNormBreath.mat')
load('NeuronResponseToMovement/ModulationAroundAccEvents_BefAndAfter_NormBreath/ModulationAroundAccEvents_BefAndAfter_NormBreath.mat')
load('NeuronResponseToMovement/ModulationAroundAccEvents_BefAndAfter_NormBreath/ModulationAroundAccEvents_BefAndAfter_NormBreath.mat')

EventNames = {'Type1','Type2','All'};
figure(1)
clf
subplot(121)
nhist(KappaData,'binfactor',2,'noerror')
xlim([0 0.4])
title('Real Kappa')
subplot(122)
nhist(KappaPred,'binfactor',2,'noerror')
xlim([0 0.4])
legend(EventNames)
title('Pred Kappa')

figure(2)
clf
for k =1:3
subplot(1,3,k)
plot(KappaData{k}   ,KappaPred{k} ,'*' ) 
xlabel('Real Kappa')
ylabel('Pred Kappa')
title(EventNames{k})
end

figure(3)
clf
for k =1:3
subplot(1,3,k)
plot(muData{k}   ,muPred{k} ,'*' ) 
xlabel('Real mu')
ylabel('Pred mu')
title(EventNames{k})
end

%% Correlate Kappa with firing response


%% How AccBurst is defined
%   load('LFPData/LFP34.mat')
%     a = Data(LFP);
%     a(a<-3.5e4)=NaN;
%     a(a>-1)=NaN;
%     aint = naninterp(a);
%     A=tsd(Range(LFP),[0;diff(aint)]);
%     LFPClean = tsd(Range(LFP),aint);
%     LFPClean = tsd(Range(LFP),Data(LFPClean)-movmean(Data(LFPClean),1250*60));
%     
%     AccBurst = thresholdIntervals(LFPClean,1000,'Direction','Above');
%     AccBurst = mergeCloseIntervals(AccBurst,1*1e4);
%     AccBurst = dropShortIntervals(AccBurst,1*1e4);
%     AccBurst = dropLongIntervals(AccBurst,5*1e4);
