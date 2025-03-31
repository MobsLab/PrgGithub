% Make basic figures to show neuronmodulation by OB% Calculate spectra,coherence and Granger
clear all
obx=0;
% Get data

% close all
[params,movingwin,suffix]=SpectrumParametersML('low');
rmpath('/home/vador/Dropbox/Kteam/PrgMatlab/Fra/UtilsStats')
rmpath('/Users/sophiebagur/Dropbox/PrgMatlab/Fra/UtilsStats')

% Get sessions
Dir = PathForExperimentFEAR('Fear-electrophy');

% EpLength = [6,14,22,40];
EpLength = [6,14];
EpLengthLow = [2,6];

TimeBin =3;

numNeurons=[];
num=1;
FieldNames={'OB1','PFCx'};
MiceDone = {};
nbin=30;
mousenum = 0;
for mm=1:length(Dir.path)
    if exist(Dir.path{mm})>0 && strcmp(Dir.group{mm},'CTRL')  && sum(strcmp(MiceDone,Dir.name{mm}))==0
        cd(Dir.path{mm})
        
        if exist('NeuronLFPCoupling_OB4HzPaper/AllEpochNeuronModFreqMiniMaxiPhaseCorrected_OB1.mat')>0
            disp(Dir.path{mm})
            mousenum = mousenum+1;
            MiceDone{mousenum} = Dir.name{mm};
            
            for eplg = 1:length(EpLength)
                clear PhasetsdSub WfId
                clear PhasesSpikes mu
                load('NeuronLFPCoupling_OB4HzPaper/AllEpochNeuronModFreqMiniMaxiPhaseCorrected_OB1.mat')
                clear FreezeEpoch MovAcctsd
                load('behavResources.mat')
                FreezeEpoch = mergeCloseIntervals(FreezeEpoch,EpLengthLow(eplg)*1e4);
                FreezeEpoch = dropShortIntervals(FreezeEpoch,EpLength(eplg)*1e4);
                
                for sp = 1:length(PhasesSpikes.Nontransf)
                    try
                        [mutemp, ~, pval, ~, ~, ~,~,~] = CircularMean(Data(Restrict(PhasesSpikes.Nontransf{sp},FreezeEpoch)));
                    catch
                        mutemp = NaN;
                        pval = NaN;
                    end
                    
                    Dat = (Data(PhasesSpikes.Nontransf{sp})-mutemp);
                    Dat(Dat<-pi) = 2*pi+Dat(Dat<-pi);
                    Dat(Dat>pi) = Dat(Dat>pi)-2*pi;
                    
                    Phasetsd.AbsDist{sp} = tsd(Range(PhasesSpikes.Nontransf{sp}),abs(Dat));
                    Phasetsd.SignedDist{sp} = tsd(Range(PhasesSpikes.Nontransf{sp}),(Dat));
                    Phasetsd.JustPhase{sp} = PhasesSpikes.Nontransf{sp};
                    
                    pvalAll{mousenum,eplg}(sp) = pval;
                    PathToNeuron{mousenum,eplg}{sp} = Dir.path{mm};
                    
                    %                                     subplot(211)
                    %                                     hist(Data(Restrict(PhasesSpikes.Nontransf{sp},FreezeEpoch)),60)
                    %                                     line([1 1]*mutemp,ylim,'color','r')
                    %                                     title(num2str( pvalAll{mousenum}(sp) ))
                    %                                     subplot(212)
                    %                                     hist(Data(Restrict(PhasetsdSub{sp} ,FreezeEpoch)),60)
                    %                                     line([1 1]*-pi,ylim,'color','r')
                    %                                     line([1 1]*pi,ylim,'color','r')
                    %                                     pause(0.1)
                    %
                    
                end
                
                PhaseTypes = fieldnames(Phasetsd);
                
                if length(Start(FreezeEpoch))==0
                    for type = 1:length(PhaseTypes)
                        
                        for sp = 1:length(PhasesSpikes.Nontransf)
                            AllData_Beg.(PhaseTypes{type}){eplg}{mousenum}{sp} = nan(length(begin),ceil(max(endin-begin)/(TimeBin*1e4)));
                            AllData_End.(PhaseTypes{type}){eplg}{mousenum}{sp} = nan(length(begin),ceil(max(endin-begin)/(TimeBin*1e4)));
                            AllData_Align.(PhaseTypes{type}){eplg}{mousenum}{sp} = nan(length(begin),11);
                        end
                    end
                    
                else
                    
                    
                    clear Fr
                    begin=Start(FreezeEpoch);
                    endin=Stop(FreezeEpoch);
                    for type = 1:length(PhaseTypes)
                        
                        for sp = 1:length(PhasesSpikes.Nontransf)
                            index=1;
                            for ff=1:length(begin)
                                dur=endin(ff)-begin(ff);
                                numbins=round(dur/(TimeBin*1E4));
                                epdur=(dur/1E4)/numbins;
                                index = 1;
                                for nn=1:numbins
                                    startcounting=begin(ff)+(nn-1)*dur/numbins;
                                    stopcounting=begin(ff)+nn*dur/numbins;
                                    Fr{ff}(index,1)=nanmean(Data(Restrict(Phasetsd.(PhaseTypes{type}){sp},intervalSet(startcounting,stopcounting))));
                                    index=index+1;
                                end
                            end
                            
                            
                            AllData_Beg.(PhaseTypes{type}){eplg}{mousenum}{sp} = nan(length(begin),ceil(max(endin-begin)/(TimeBin*1e4)));
                            AllData_End.(PhaseTypes{type}){eplg}{mousenum}{sp} = nan(length(begin),ceil(max(endin-begin)/(TimeBin*1e4)));
                            AllData_Align.(PhaseTypes{type}){eplg}{mousenum}{sp} = nan(length(begin),11);
                            
                            for ff=1:length(begin)
                                
                                AllData_End.(PhaseTypes{type}){eplg}{mousenum}{sp}(ff,end-length(Fr{ff})+1:end) = Fr{ff};
                                AllData_Beg.(PhaseTypes{type}){eplg}{mousenum}{sp}(ff,1:length(Fr{ff})) = Fr{ff};
                                try
                                    AllData_Align.(PhaseTypes{type}){eplg}{mousenum}{sp}(ff,:) = interp1([0:TimeBin:(length(Fr{ff})-1)*TimeBin]/((length(Fr{ff})-1)*TimeBin),Fr{ff}',[0:0.1:1]);
                                end
                            end
                            
                        end
                    end
                end
            end
            
        end
    end
end

AlphaAll = [0.05,0.001,0.0001];

% Beg
figure
clf
for type = 1:length(PhaseTypes)
    
    AllNeurNorm = [];
    AllPval = [];
    for mm = 1 :length(AllData_Align.(PhaseTypes{type}))
        for sp = 1:length(AllData_Align.(PhaseTypes{type}){mm})
            AllNeurNorm = [AllNeurNorm;nanmean(AllData_Beg.(PhaseTypes{type}){mm}{sp}(:,1:5))];
            AllPval = [AllPval;pvalAll{mm,1}(sp)];
        end
    end
    
    
    AllPval(sum(isnan(AllNeurNorm'))>0) = [];
    AllNeurNorm(sum(isnan(AllNeurNorm'))>0,:) = [];
    
    subplot(3,3,1+3*(type-1))
    for a = 1:3
        errorbar(3:3:15,nanmean((AllNeurNorm(AllPval<AlphaAll(a),:)')'),stdError((AllNeurNorm(AllPval<AlphaAll(a),:)')'),'linewidth',2), hold on
    end
    legend('a<0.05','a<0.01','a<0.001')
    ylabel('average'),xlabel('freezing norm time')
    title(PhaseTypes{type})
    
    subplot(3,3,2+3*(type-1))
    for a = 1:3
        errorbar(3:3:15,nanmean(nanzscore(AllNeurNorm(AllPval<AlphaAll(a),:)')'),stdError(nanzscore(AllNeurNorm(AllPval<AlphaAll(a),:)')'),'linewidth',2), hold on
    end
    ylabel('average after z-scoring'),xlabel('freezing norm time')
    title(PhaseTypes{type})
    
     AllNeurNorm = [];
    AllPval = [];
    for mm = 1 :length(AllData_Align.(PhaseTypes{type}))
        for sp = 1:length(AllData_Align.(PhaseTypes{type}){mm})
            AllNeurNorm = [AllNeurNorm;nanmean(AllData_End.(PhaseTypes{type}){mm}{sp}(:,end-4:end))];
            AllPval = [AllPval;pvalAll{mm,1}(sp)];
        end
    end
    
    
    AllPval(sum(isnan(AllNeurNorm'))>0) = [];
    AllNeurNorm(sum(isnan(AllNeurNorm'))>0,:) = [];
    
    subplot(3,3,1+3*(type-1))
    for a = 1:3
        errorbar(18:3:30,nanmean((AllNeurNorm(AllPval<AlphaAll(a),:)')'),stdError((AllNeurNorm(AllPval<AlphaAll(a),:)')'),'linewidth',2), hold on
    end
    legend('a<0.05','a<0.01','a<0.001')
    ylabel('average'),xlabel('freezing norm time')
    title(PhaseTypes{type})
    
    subplot(3,3,2+3*(type-1))
    for a = 1:3
        errorbar(18:3:30,nanmean(nanzscore(AllNeurNorm(AllPval<AlphaAll(a),:)')'),stdError(nanzscore(AllNeurNorm(AllPval<AlphaAll(a),:)')'),'linewidth',2), hold on
    end
    ylabel('average after z-scoring'),xlabel('freezing norm time')
    title(PhaseTypes{type})
    

    
end


%% Norm
figure
clf
for type = 1:length(PhaseTypes)
    
    AllNeurNorm = [];
    AllPval = [];
    for mm = 1 :length(AllData_Align.(PhaseTypes{type}))
        for sp = 1:length(AllData_Align.(PhaseTypes{type}){mm})
            AllNeurNorm = [AllNeurNorm;nanmean(AllData_Align.(PhaseTypes{type}){mm}{sp})];
            AllPval = [AllPval;pvalAll{mm,1}(sp)];
        end
    end
    AllPval(sum(isnan(AllNeurNorm'))>0) = [];
    AllNeurNorm(sum(isnan(AllNeurNorm'))>0,:) = [];
    
    subplot(3,3,1+3*(type-1))
    for a = 1:3
        errorbar(0:0.1:1,nanmean((AllNeurNorm(AllPval<AlphaAll(a),:)')'),stdError((AllNeurNorm(AllPval<AlphaAll(a),:)')'),'linewidth',2), hold on
    end
    legend('a<0.05','a<0.01','a<0.001')
    ylabel('average'),xlabel('freezing norm time')
    title(PhaseTypes{type})
    
    subplot(3,3,2+3*(type-1))
    for a = 1:3
        errorbar(0:0.1:1,nanmean(nanzscore(AllNeurNorm(AllPval<AlphaAll(a),:)')'),stdError(nanzscore(AllNeurNorm(AllPval<AlphaAll(a),:)')'),'linewidth',2), hold on
    end
    ylabel('average after z-scoring'),xlabel('freezing norm time')
    title(PhaseTypes{type})
    
    subplot(3,3,3+3*(type-1))
    [pval{type},eb] = PlotErrorBarN_KJ([nanmean(AllNeurNorm(AllPval<0.01,1:2)');nanmean(AllNeurNorm(AllPval<0.01,9:10)')]','paired',1,'newfig',0);
    ylabel('average')
    title(PhaseTypes{type})
    
end


%%
figure
for type = 1:3
    
    AllNeurNormSh = [];
    AllPvalSh = [];
    for mm = 1 :length(AllData_Align.(PhaseTypes{type}){1})
        for sp = 1:length(AllData_Align.(PhaseTypes{type}){1}{mm})
            AllNeurNormSh = [AllNeurNormSh;nanmean(AllData_Align.(PhaseTypes{type}){1}{mm}{sp})];
            AllPvalSh = [AllPvalSh;pvalAll{mm,1}(sp)];
        end
    end
    
    AllNeurNormLg = [];
    AllPvalLg = [];
    for mm = 1 :length(AllData_Align.(PhaseTypes{type}){2})
        for sp = 1:length(AllData_Align.(PhaseTypes{type}){2}{mm})
            AllNeurNormLg = [AllNeurNormLg;nanmean(AllData_Align.(PhaseTypes{type}){2}{mm}{sp},1)];
            AllPvalLg = [AllPvalLg;pvalAll{mm,2}(sp)];
        end
    end
    
    BadNeurons = sum(isnan(AllNeurNormSh'))>0 | sum(isnan(AllNeurNormLg'))>0;
    AllPvalSh(BadNeurons) = [];
    AllNeurNormSh(BadNeurons,:) = [];
    AllPvalLg(BadNeurons) = [];
    AllNeurNormLg(BadNeurons,:) = [];
    [R,P] = corr([0:10]',AllNeurNormSh');
    AllNeurNormLg(P>0.05,:) = [];
    AllNeurNormSh(P>0.05,:) = [];

    
    subplot(2,3,type)
    [R,P] = corr([0:10]',AllNeurNormLg');
    AllNeurNormLg_sorted = sortrows([R;AllNeurNormLg']');
    AllNeurNormLg_sorted = AllNeurNormLg_sorted(:,2:end);
    AllNeurNormSh_sorted = sortrows([R;AllNeurNormSh']');
    AllNeurNormSh_sorted = AllNeurNormSh_sorted(:,2:end);
    
    imagesc(corrcoef([AllNeurNormSh_sorted;AllNeurNormLg_sorted]'))
        clim([-0.8 0.8])

    subplot(2,3,type+3)
    [R,P] = corr([0:10]',AllNeurNormSh');
    AllNeurNormLg_sorted = sortrows([R;AllNeurNormLg']');
    AllNeurNormLg_sorted = AllNeurNormLg_sorted(:,2:end);
    AllNeurNormSh_sorted = sortrows([R;AllNeurNormSh']');
    AllNeurNormSh_sorted = AllNeurNormSh_sorted(:,2:end);
    
    imagesc(corrcoef([AllNeurNormSh_sorted;AllNeurNormLg_sorted]'))
    clim([-0.8 0.8])
end