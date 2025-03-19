clear all

permutnum = 100;
dorand = 0;
testonfr = 0;
Binsize = 2*1e4;
Dir = PathForExperimentsSleepRipplesSpikes('Basal')
cols = lines(6);

for k = 1:length(Dir.path)
    clf
    clear SaveW SaveBiais
    cd(Dir.path{k})
    disp(Dir.path{k})
    
    % Load LFP to get time right
    load('LFPData/LFP1.mat')
    AllTime = tsd(Range(LFP),[1:length(Range(LFP))]');
    tps = Range(LFP);
    
    % Get the neurons from the PFCx
    load('SpikeData.mat')
    [numNeurons, numtt, TT] = GetSpikesFromStructure('PFCx','remove_MUA',1);
    try,S = tsdArray(S);end
    S = S(numNeurons);
    S{1} = tsd([0;Range(S{1});max(Range(LFP))],[0;Range(S{1});max(Range(LFP))]);
    Q = MakeQfromS(S,Binsize);
    % DatQ = zscore(Data(Q));
    % Q = tsd(Range(Q),DatQ);
    
    % Arrange everything (downstates and sleep epochs) with the right bins
    load('DownState.mat')
    
    % Downs
    timeEvents = Data(Restrict(AllTime,down_PFCx));
    binsEvents = tsdArray(tsd([0;tps(timeEvents);max(Range(LFP))],[0;tps(timeEvents);max(Range(LFP))]));
    QEvents = MakeQfromS(binsEvents,2*1e4);
    QDown = tsd(Range(QEvents),Data(QEvents)/2500); % divide by number of bins in 2seconds
    DatQ = Data(Q);
    for sp = 1:length(numNeurons)
        DatQ(:,sp) = DatQ(:,sp)./(1-Data(QDown));
    end
    Q_downcorr = tsd(Range(Q),DatQ);
    
    % Sleep substates
    try,load('SleepSubstages.mat')
    catch
        load('NREMsubstages.mat')
    end
    
    % Movement
    clear MovAcctsd
    try,load('behavResources.mat'),
        MovAcctsd;
    catch
        MovAcctsd = tsd([],[]);
    end
    
    
    clear Vals
    
    for ep = 1:5
        timeEvents = Data(Restrict(AllTime,Epoch{ep}));
        binsEvents = tsdArray(tsd([0;tps(timeEvents);max(Range(LFP))],[0;tps(timeEvents);max(Range(LFP))]));
        QEvents = MakeQfromS(binsEvents,2*1e4);
        dat_temp = Data(QEvents)/2500;
        tps_temp = Range(QEvents);
        tps_temp(dat_temp<0.75) = [];
        CleanedEpoch.(NameEpoch{ep}) = intervalSet(tps_temp,tps_temp+2*1e4);
        Vals.(NameEpoch{ep}) = Data(Restrict(Q,CleanedEpoch.(NameEpoch{ep})));
        Tps.(NameEpoch{ep}) = Range(Restrict(Q,CleanedEpoch.(NameEpoch{ep})));
        Vals_downcorr.(NameEpoch{ep}) = Data(Restrict(Q_downcorr,CleanedEpoch.(NameEpoch{ep})));
    end
    
    
    % get lowest number of trials of all classes so that have same number of
    % elements per class
    fields = fieldnames(Vals);
    for f = 1:length(fields)
        Vals.(fields{f}) = full(Vals.(fields{f}));
        numelem(f) = size(Vals.(fields{f}),1);
    end
    Minnumelem = min(numelem);
    
    % make sur its divisible by 4 (for rand)
    Minnumelem = floor(Minnumelem/4)*4;
    
    
    
    % Binary decoder for each class vs each class
    for f = 1:length(fields)
        for ff = 1:length(fields)
            
            if f==ff
                Acc_ConfMat(f,ff) = NaN;
                Acc_ConfMat(ff,f) = NaN;
                
                SaveW(f,ff,:) = nan(1,size(Vals.(fields{f}),2));
                SaveBiais(f,ff) = NaN;
            else
                
                % train on the middle
                Div3 = floor(size(Vals.(fields{f}),1)/3);
                Div3_2 = floor(size(Vals.(fields{ff}),1)/3);
                
%                 A = Vals.(fields{f})(Div3:Div3*2,:);
%                 B = Vals.(fields{ff})(Div3_2:Div3_2*2,:);
                A = Vals.(fields{f})(:,:);
                B = Vals.(fields{ff})(:,:);

                if dorand
                    A_temp = [A(1:Minnumelem/4,:);B(Minnumelem/4+1:Minnumelem/2,:)];
                    B = [A(Minnumelem/4+1:Minnumelem/2,:);B(1:Minnumelem/4,:)];
                    A = A_temp;
                    A_temp = [A_test(1:Minnumelem/4,:);B_test(Minnumelem/4+1:Minnumelem/2,:)];
                    B_test = [A_test(Minnumelem/4+1:Minnumelem/2,:);B_test(1:Minnumelem/4,:)];
                    A_test = A_temp;
                end
                
                % vector : subtraction of average activity on training trials
                W = nanmean(A) - nanmean(B);
                if testonfr
                    W = W.*0+1;
                    if nanmean(A*W')<nanmean(B*W')
                        W = -W;
                    end
                end
                W = W./norm(W);
                
                % Bias : centre between tow sets of data after projection
                Biais = (nanmean(A*W') + nanmean(B*W'))/2;
                
                SaveW(f,ff,:) = W;
                SaveBiais(f,ff) = Biais;
            end
            
        end
    end
    
    ValsForTesting = Data(Q);
    
    
    clear ValueToUse
    for f1 = 1:length(fields)
        for f2 = 1:length(fields)
            ValueToUse(f1,f2,:) = (ValsForTesting*squeeze(SaveW(f1,f2,:)))-SaveBiais(f1,f2);
            if f1 ==f2
                ValueToUse(f1,f2,:) = ValueToUse(f1,f2,:)*NaN;
            end
            % the value should be positive if the trial is f1
        end
    end
    % average over second dimension, to get the lines where f1=f
    [maxval,maxcol] = nanmax(squeeze(nanmean(ValueToUse,2)));
    
    maxcol(maxcol==1) = 10;
    maxcol(maxcol==2) = 20;
    maxcol(maxcol==3) = 30;
    
    maxcol(maxcol==10) = 2;
    maxcol(maxcol==20) = 1.5;
    maxcol(maxcol==30) = 1;
    maxcol(maxcol==4) = 3;
    maxcol(maxcol==5) = 4;
    
    %% Substages
    
    % figure
    clf
    [SleepStages, Epochs, time_in_substages, meanDuration_substages, percentvalues_NREM] = MakeIDfunc_Sleepstages;
    subplot(511)
    ylabel_substage = {'N3','N2','N1','REM','WAKE'};
    ytick_substage = [1 1.5 2 3 4]; %ordinate in graph
    colori = {[0.5 0.3 1], [1 0.5 1], [0.8 0 0.7], [0.1 0.7 0], [0.5 0.2 0.1]}; %substage color
    plot(Range(SleepStages,'s')/3600,Data(SleepStages),'k'), hold on,
    for ep=1:length(Epochs)
        plot(Range(Restrict(SleepStages,Epochs{ep}),'s')/3600 ,Data(Restrict(SleepStages,Epochs{ep})),'.','Color',colori{ep}), hold on,
        
    end
    xlim([0 max(Range(SleepStages,'s')/3600)]), ylim([0.5 5]), set(gca,'Ytick',ytick_substage,'YTickLabel',ylabel_substage), hold on,
    title('Hypnogram'); xlabel('Time (h)')
%     TimeLims = max(Range(SleepStages,'s')/3600)/3;
%     line([TimeLims TimeLims*2],[4.5 4.5],'linewidth',2,'color','b')
    
    subplot(512)
    tps = Range(Q,'h');
    res = maxcol;
    colfilt(maxcol,[1,3],'sliding',@mode);
    plot(tps,res,'k'), hold on
    coloribis ={ [0.8 0 0.7],[1 0.5 1],[0.5 0.3 1], [0.1 0.7 0], [0.5 0.2 0.1]}; %substage color
    vals = unique(res);
    vals(vals==0) = [];
    for ep=1:length(Epochs)
        plot(tps(res==vals(ep)),res(res==vals(ep)),'.','Color',coloribis{ep}), hold on,
    end
    xlim([0 max(Range(SleepStages,'s')/3600)]), ylim([0.5 5]), set(gca,'Ytick',[1,1.5,2,3,4],'YTickLabel',ylabel_substage), hold on,
    title('Neuron hypnogram sl=3s'); xlabel('Time (h)')
    
    subplot(513)
    tps = Range(Q,'h');
    res = colfilt(maxcol,[1,5],'sliding',@mode);
    plot(tps,res,'k'), hold on
    coloribis ={ [0.8 0 0.7],[1 0.5 1],[0.5 0.3 1], [0.1 0.7 0], [0.5 0.2 0.1]}; %substage color
    vals = unique(res);
    vals(vals==0) = [];
    for ep=1:length(Epochs)
        plot(tps(res==vals(ep)),res(res==vals(ep)),'.','Color',coloribis{ep}), hold on,
    end
    xlim([0 max(Range(SleepStages,'s')/3600)]), ylim([0.5 5]), set(gca,'Ytick',[1,1.5,2,3,4],'YTickLabel',ylabel_substage), hold on,
    title('Neuron hypnogram sl=10s'); xlabel('Time (h)')
    
    subplot(514)
    AvWeights  = squeeze(nanmean(SaveW,2));
    [val,ind] = max((AvWeights));
    DatQ = zscore(Data(Q));
    imagesc(Range(Q,'h'),size(DatQ,2),sortrows([ind;DatQ]'))
    clim([-1.5 1.5])
    xlim([0 max(Range(SleepStages,'s')/3600)])
    title('Neuron sorted by preferred state'); xlabel('Time (h)')
    
    
    subplot(515)
    plot(Range(MovAcctsd,'h'),Data(MovAcctsd),'k')
    xlim([0 max(Range(SleepStages,'s')/3600)])
    title('Movement'); xlabel('Time (h)')
    
    saveas(15,[dropbox '/Mobs_member/SophieBagur/Figures/N1N2N3NeuronFiring/HypnogramOnNeuronsNoSubSelMouse',num2str(k),'.png'])
    saveas(15,[dropbox '/Mobs_member/SophieBagur/Figures/N1N2N3NeuronFiring/HypnogramOnNeuronsNoSubSelMouse',num2str(k),'.fig'])
    
    
end

