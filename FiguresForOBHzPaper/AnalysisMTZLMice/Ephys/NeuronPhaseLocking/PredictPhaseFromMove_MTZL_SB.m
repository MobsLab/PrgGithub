clear all
% Declare variables
TimeAroundEvent = 2; % in seconds, how long before and after do we look
Binsize = 0.05*1e4; % binsize for historgam of breathing phases and for spike counts
BinsizeNeur = 0.5*1E4;
NumBins = 30; % Number of pins for entropy calculation of phase difference distribution
AnglesRest = [0.15:0.1:6.15]; % angles of phase locking
Angles = [0.05:0.1:6.25]; % angles for phase locking -  to avoid border effects

% Options For calculation
AfterOnly = 'BefAndAfter'; % If is set to 'AferOnly', only do post-acc time, if ''BefAndAfter' before and after
NormBreathPhase = 'NormBreath'; % If is set to 'NormBreath', norm by breathingPhase, If is set to 'NoNormBreath' doesn't

% Get the data locations
Dir = PathForExperimentsMtzlProject('SleepPlethysmograph');
PossibleZscr = [1,1.5,2];
StrongEvents = 1;

for Zscr = 1
    
    ZscoreThresh = PossibleZscr(Zscr);
    
    for d = 1:length(Dir.path)
        for dd = 1:length(Dir.path{d})
            cd(Dir.path{d}{dd})
            
            disp(Dir.path{d}{dd})
            [numNeurons, numtt, TT]=GetSpikesFromStructure('PFCx', 'remove_MUA',1);
            if not(isempty(numNeurons))
                % Get accelero channels
                load('LFPData/InfoLFP.mat')
                channel_accelero = InfoLFP.channel(strcmp(InfoLFP.structure,'Accelero'));
                load('LFPData/LFP1.mat')
                
                % Get breathing phase
                load('BreathingInfo_ZeroCross.mat')
                AllPeaks=[0:2*pi:2*pi*(length(Data(Breathtsd))-1)];
                Y=interp1(Range(Breathtsd,'s'),AllPeaks,Range(LFP,'s'));
                PhaseInterpol=tsd(Range(LFP),mod(Y,2*pi));
                
                % load spikes
                load('SpikeData.mat')
                clear Qdat QdatNew Q QGoodBin
                Q = MakeQfromS(S,BinsizeNeur);
                QGoodBin = MakeQfromS(S,Binsize);
                Qdat = Data(Q);
                
                for n = 1 :size(Qdat,2)
                    QdatNew(:,n) = interp1(Range(Q),full(Qdat(:,n)'),Range(QGoodBin))';
                end
                Qdat = QdatNew;
                % Get neuron phases
                
                for chan = 1: length(channel_accelero)
                    SaveNeurResp = [];
                    % Load the times of detected events
                    load('NeuronModulation/NeuronMod_Respi_ZeroCross_total_nonoise.mat')
                    load(['NeuronResponseToMovement/MovementEvents_ZScore',strrep(num2str(ZscoreThresh),'.',','),'chan',num2str(channel_accelero(chan)),'.mat'],'AccBurst')
                    times = Start(AccBurst);
                    if StrongEvents
                        [MBr,TBr]=PlotRipRaw(PhaseInterpol,Start(AccBurst,'s'),5000,0,0);
                        A = (zscore(TBr')');
                        B = repmat(nanmean(A),size(A,1),1);
                        [R,P] = corr(A',B');
                        R = R(:,1);
                        times = times(R(:,1)>0.2);
                    end
                    
                    % Get breathing phase distribution aroudn events
                    clear hPhase
                    switch AfterOnly
                        case 'AferOnly'
                            for i=0:TimeAroundEvent./(Binsize/1E4)
                                [hPhase(i+1,:),b]=hist(Data(Restrict(PhaseInterpol,intervalSet(times+(i-1)*1E3,times+i*1E3))),[0.05:0.1:6.25]);
                            end
                        case 'BefAndAfter'
                            for i=-TimeAroundEvent./(Binsize/1E4):TimeAroundEvent./(Binsize/1E4)
                                [hPhase(i+TimeAroundEvent./(Binsize/1E4)+1,:),b]=hist(Data(Restrict(PhaseInterpol,intervalSet(times+(i-1)*Binsize,times+i*Binsize))),[0.05:0.1:6.25]);
                            end
                    end
                    hPhase(:,1) = [];
                    hPhase(:,end) = [];
                    hPhase(end,:) = [];
                    clear muPred KappaPred
                    for n = 1 :size(Qdat,2)
                        try
                            % Using Nontransf to be comparable with what we infer from the
                            % breathing phase x average spiking activity
                            PhaseNeur = tsd(Range(Restrict(S{n},epoch)),PhasesSpikes.Nontransf{n});
                            
                            
                            [MSp,TSp]=PlotRipRaw(tsd(Range(QGoodBin),sparse(Qdat(:,n))),sort(times/1e4),TimeAroundEvent*1e3,0,0);
                            
                            SaveNeurResp(n,:) = MSp(:,2);
                            switch AfterOnly
                                case 'AferOnly'
                                    AngDist = nanmean(hPhase.*repmat(MSp(ceil(size(MSp,1)/2)+1:end,2),1,61));
                                case 'BefAndAfter'
                                    AngDist = nanmean(hPhase.*repmat(MSp(:,2),1,61));
                            end
                            
                            
                            switch NormBreathPhase
                                case 'NormBreath'
                                    AngDist = AngDist./nanmean(hPhase);
                            end
                            
                            AngDist = 1000*AngDist /max(AngDist);
                            AngDist = naninterp(interp1(AnglesRest,AngDist,Angles));
                            
                            AngForKappa = [];
                            for k = 1 : length(Angles)
                                % Need to add a bit of noise (the size of the bin)
                                AngForKappa = [AngForKappa,ones(1,ceil(AngDist(k))).*(randn(1,ceil(AngDist(k)))*0.05+Angles(k))];
                            end
                            
                            rmpath(genpath([dropbox, '/Kteam/PrgMatlab/FMAToolbox/General']));
                            rmpath(genpath([dropbox, '/Kteam/PrgMatlab/Fra/UtilsStats']));
                            [muPred(n), KappaPred(n), pvalPred, Rmean, delta, sigma,confDw,confUp] = CircularMean(AngForKappa);
                            addpath(genpath([dropbox, '/Kteam/PrgMatlab/FMAToolbox/General']));
                            addpath(genpath([dropbox, '/Kteam/PrgMatlab/Fra/UtilsStats']));
                        catch
                            muPred(n)= NaN; KappaPred(n) = NaN;
                        end
                        
                    end
                    
                    muPredForEnt = muPred(numNeurons);
                    muPredForEnt(isnan(muPred))=[];
                    mu.Transf = mu.Transf(numNeurons);
                    mu.Transf(isnan(muPred))=[];
                    AllPhaseDiff = muPredForEnt-mu.Transf;
                    [Y1,X1]=hist(AllPhaseDiff,NumBins);
                    Y1=Y1/sum(Y1);
                    Smax=log(NumBins);
                    
                    Y1(Y1==0) = [];
                    Sent=-sum(Y1.*log(Y1));
                    Index.Shannon=(Smax-Sent)/Smax;
                    Index.VectLength=sqrt(sum(cos(AllPhaseDiff)).^2+sum(sin(AllPhaseDiff)).^2)/length(AllPhaseDiff);
                    
                    if not(StrongEvents)
                        save(['NeuronResponseToMovement/NeuronPredictedPhaseMovementEventsNeurBinSize',num2str(BinsizeNeur),'_ZScore',strrep(num2str(ZscoreThresh),'.',','),'chan',num2str(channel_accelero(chan)),'.mat'],'Index','BinsizeNeur','muPred','KappaPred','times','SaveNeurResp','hPhase')
                    else
                        save(['NeuronResponseToMovement/NeuronPredictedPhaseMovementEventsStrongCorrNeurBinSize',num2str(BinsizeNeur),'_ZScore',strrep(num2str(ZscoreThresh),'.',','),'chan',num2str(channel_accelero(chan)),'.mat'],'BinsizeNeur','Index','muPred','KappaPred','times','SaveNeurResp','hPhase')
                    end
                    clear Index muPred KappaPred times
                end
            end
        end
    end
end


%
clear all

% Get the data locations
Dir = PathForExperimentsMtzlProject('SleepPlethysmograph');
ZscoreThresh = 1;
%figure
BinsizeNeur = 0.5*1E4;
for chan = 2
    figure
    subplot(131)
    hold on
    line([0 4*pi],[0 4*pi],'linewidth',2,'color','b')
    line([0 2*pi],[0 2*pi]+2*pi,'linewidth',2,'color','b')
    line([0 2*pi]+2*pi,[0 2*pi],'linewidth',2,'color','b')
    AllNeurResp = [];
    IndexMTZL = [];
    IndexSAL = [];
    AllPhaseDiffMTZL = [];
    AllPhaseDiffSAL = [];
    for d = 1:length(Dir.path)
        for dd = 1:length(Dir.path{d})
            cd(Dir.path{d}{dd})
            disp(Dir.path{d}{dd})
            if strcmp(Dir.ExpeInfo{d}{dd}.DrugInjected,'METHIMAZOLE')==1
                % Get the PFC neurons
                [numNeurons, numtt, TT]=GetSpikesFromStructure('PFCx', 'remove_MUA',1);
                
                if not(isempty(numNeurons))
                    
                    load('LFPData/InfoLFP.mat')
                    channel_accelero = InfoLFP.channel(strcmp(InfoLFP.structure,'Accelero'));
                    load('NeuronModulation/NeuronMod_Respi_ZeroCross_total_nonoise.mat','mu','pval','Kappa')
                    
                    clear muPredch muPredFinal
                    load(['NeuronResponseToMovement/NeuronPredictedPhaseMovementEventsStrongCorrNeurBinSize',num2str(BinsizeNeur),'_ZScore',strrep(num2str(ZscoreThresh),'.',','),'chan',num2str(channel_accelero(chan)),'.mat'],'Index','muPred','KappaPred','times')
                    load(['NeuronResponseToMovement/NeuronPredictedPhaseMovementEventsStrongCorrNeurBinSize',num2str(500),'_ZScore',strrep(num2str(ZscoreThresh),'.',','),'chan',num2str(channel_accelero(chan)),'.mat'],'SaveNeurResp')
                    muPredFinal = muPred;
                    
                    muPredFinal = muPredFinal(numNeurons);
                    KappaPred  = KappaPred(numNeurons);
                    mu.Transf = mu.Transf(numNeurons);
                    Kappa.Transf = Kappa.Transf(numNeurons);
                    pval.Transf = pval.Transf(numNeurons);
                    SaveNeurResp = SaveNeurResp(numNeurons,:);
                    
                    muPredFinal = muPredFinal(pval.Transf<0.05);
                    mu.Transf = mu.Transf(pval.Transf<0.05);
                    SaveNeurResp = SaveNeurResp(pval.Transf<0.05,:);
                    Kappa.Transf = Kappa.Transf(pval.Transf<0.05);
                    KappaPred  = KappaPred(pval.Transf<0.05);
                    
                    subplot(131)
                    hold on
                    plot([muPredFinal,muPredFinal+2*pi,muPredFinal,muPredFinal+2*pi],[mu.Transf,mu.Transf+2*pi,mu.Transf+2*pi,mu.Transf],'k.','MarkerSize',5)
                    
                    IndexMTZL = [IndexMTZL,[Index.Shannon;Index.VectLength]];
                    AllPhaseDiffMTZL = [AllPhaseDiffMTZL,[muPredFinal;mu.Transf]];
                    AllNeurResp = [AllNeurResp;SaveNeurResp];
                    
                    %             else
                    %                 subplot(122)
                    %                 hold on
                    %                 plot([muPredFinal,muPredFinal+2*pi,muPredFinal,muPredFinal+2*pi],[mu.Transf,mu.Transf+2*pi,mu.Transf+2*pi,mu.Transf],'*')
                    %                 IndexSAL = [IndexSAL,[Index.Shannon;Index.VectLength]];
                    %                 AllPhaseDiffSAL = [AllPhaseDiffSAL,muPredFinal-mu.Transf];
                    %
                end
            end
        end
        
    end
    subplot(131)
    xlabel('Phase-Measured')
    ylabel('Phase-Predicted')
    set(gca,'FontSize',20,'Linewidth',2)
    xlim([-0.5 4*pi+0.5])
    ylim([-0.5 4*pi+0.5])
    
    subplot(132)
    hist(AllPhaseDiffMTZL(1,:)-AllPhaseDiffMTZL(2,:),30)
    set(gca,'FontSize',20,'Linewidth',2)
    box off
    xlim([-2*pi 2*pi])
    xlabel('Predicted - Measured Phase')
    ylabel('Counts')
    line([0 0],ylim,'color','k','linewidth',2)
    
    subplot(133)
    A = (zscore(AllNeurResp')');
    B = mean(A(:,40:50)')
    imagesc([-2:0.05:2],1:length(B),SmoothDec(sortrows([B',A]),[0.1 1])), clim([-2 2])
    set(gca,'FontSize',20,'Linewidth',2)
    box off
    xlabel('Time to event (s)')
    ylabel('Neuron Count')
    line([0 0],ylim,'color','k','linewidth',2)
    
end


AllPhaseDiffMTZL = abs(AllPhaseDiffMTZL);
AllPhaseDiffMTZL(AllPhaseDiffMTZL>pi) = pi-(AllPhaseDiffMTZL(AllPhaseDiffMTZL>pi)-pi);
[R,P] = circ_corrcc(AllPhaseDiffMTZL(1,:),(AllPhaseDiffMTZL(2,:)));

figure
IndexMTZL = [];
IndexSAL = [];
AllPhaseDiffMTZL = [];
AllPhaseDiffSAL = [];
BinsizeNeur = 0.5*1E4;

for d = 1:length(Dir.path)
    for dd = 1:length(Dir.path{d})
        cd(Dir.path{d}{dd})
        
        % Get the PFC neurons
        [numNeurons, numtt, TT]=GetSpikesFromStructure('PFCx', 'remove_MUA',1);
        
        if not(isempty(numNeurons))
            
            load('LFPData/InfoLFP.mat')
            channel_accelero = InfoLFP.channel(strcmp(InfoLFP.structure,'Accelero'));
            load('NeuronModulation/NeuronMod_Respi_ZeroCross_total_nonoise.mat','mu')
            
            clear muPredch muPredFinal
            for chan = 1:length(channel_accelero)
                load(['NeuronResponseToMovement/NeuronPredictedPhaseMovementEventsStrongCorrNeurBinSize',num2str(BinsizeNeur),'_ZScore',strrep(num2str(ZscoreThresh),'.',','),'chan',num2str(channel_accelero(chan)),'.mat'],'BinsizeNeur','Index','muPred','KappaPred','times')
                muPredch(chan,:) = muPred;
            end
            [val,ind] = min(abs(muPredch-mu.Transf));
            for a = 1:size(muPredch,2)
                muPredFinal(a) = muPredch(ind(a),a);
            end
            
            muPredFinal = muPredFinal(numNeurons);
            mu.Transf = mu.Transf(numNeurons);
            
            if strcmp(Dir.ExpeInfo{d}{dd}.DrugInjected,'METHIMAZOLE')==1
                figure
                subplot(121)
                plot([muPredFinal,muPredFinal+2*pi,muPredFinal,muPredFinal+2*pi],[mu.Transf,mu.Transf+2*pi,mu.Transf+2*pi,mu.Transf],'*')
                title((Dir.path{d}{dd}))
                subplot(122)
                hist(muPredFinal-mu.Transf,20)
            end
        end
        
    end
    
end
    
