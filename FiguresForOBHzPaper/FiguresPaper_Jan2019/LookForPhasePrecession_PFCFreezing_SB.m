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
EpLength = [8,20];
EpLengthLow = [2,8];

TimeBin =2;

numNeurons=[];
FieldNames={'OB1','PFCx'};
MiceDone = {};
XToInterp = [0:0.1:1];

for mm=1:length(Dir.path)
    
    if exist(Dir.path{mm})>0 && strcmp(Dir.group{mm},'CTRL')
        cd(Dir.path{mm})
        
        if exist('NeuronLFPCoupling_OB4HzPaper/AllEpochNeuronModFreqMiniMaxiPhaseCorrected_OB1.mat')>0
            disp(Dir.path{mm})
            
            for eplg = 1:length(EpLength)
                clear PhasetsdSub WfId
                clear PhasesSpikes mu LFP
                clear FreezeEpoch MovAcctsd numNeurons numtt TT FreezeAccEpoch
                
                load('NeuronLFPCoupling_OB4HzPaper/AllEpochNeuronModFreqMiniMaxiPhaseCorrected_OB1.mat')
                load('behavResources.mat')
                
                load('LFPData/InfoLFP.mat')
                load(['LFPData/LFP',num2str(InfoLFP.channel(1)),'.mat'])
                
                if exist('FreezeAccEpoch')>0
                    FreezeEpoch = FreezeAccEpoch;
                end
                
                FreezeEpoch = mergeCloseIntervals(FreezeEpoch,2*1e4);
                FreezeEpoch = dropLongIntervals(FreezeEpoch,EpLength(eplg)*1e4);
                FreezeEpoch = dropShortIntervals(FreezeEpoch,EpLengthLow(eplg)*1e4);
                
                
                if length(Start(FreezeEpoch))==0
                    
                    for sp = 1:length(PhasesSpikes.Nontransf)
                        AllData_Align{eplg}{sp} = nan(length(PhasesSpikes.Nontransf),length(XToInterp));
                    end
                    NormTime_tsd{eplg} = [];
                    Corr{eplg} = [];
                    Pval{eplg}= [];
                    
                else
                    
                    % Make time as a function of freeze period dur
                    Alltime = [];
                    for k = 1:length(Start(FreezeEpoch))
                        times = Range(Restrict(LFP,subset(FreezeEpoch,k)));
                        timesNorm = (times-min(times))./(max(times)-min(times));
                        Alltime = [Alltime;[times,timesNorm]];
                    end
                    NormTime_tsd{eplg} = tsd(Alltime(:,1),Alltime(:,2));
                    
                    
                    for sp = 1:length(PhasesSpikes.Nontransf)
                        NormTime = Data(Restrict(NormTime_tsd{eplg},ts(Range(Restrict(PhasesSpikes.Nontransf{sp},FreezeEpoch)))));
                        for pert = 1:100
                            plot(NormTime,mod(Data(Restrict(PhasesSpikes.Nontransf{sp},FreezeEpoch))+pert*(2*pi/100),2*pi),'*')
                            pause(0.05)
                            [R,P] =  corrcoef(NormTime,mod(Data(Restrict(PhasesSpikes.Nontransf{sp},FreezeEpoch))+pert*(2*pi/100),2*pi));
                            if size(R,1) ==2
                                Corr{eplg}(sp,pert) = R(1,2);
                                Pval{eplg}(sp,pert) = P(1,2);
                            else
                                Corr{eplg}(sp,pert) = NaN;
                                Pval{eplg}(sp,pert) = NaN;
                            end
                        end
                    end
                    
                    
                    [val,ind] = max(Corr{eplg}');
                    
                    clear Fr
                    begin=Start(FreezeEpoch);
                    endin=Stop(FreezeEpoch);
                    
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
                                Fr{ff}(index,1)=nanmean(mod(Data(Restrict(PhasesSpikes.Nontransf{sp},intervalSet(startcounting,stopcounting)))+ind(sp)*(2*pi/100),2*pi));
                                index=index+1;
                            end
                        end
                        
                        
                        AllData_Align{eplg}{sp} = nan(length(begin),11);
                        
                        for ff=1:length(begin)
                            
                            try
                                AllData_Align{eplg}{sp}(ff,:) = interp1([0:TimeBin:(length(Fr{ff})-1)*TimeBin]/((length(Fr{ff})-1)*TimeBin),Fr{ff}',XToInterp);
                            end
                        end
                        
                    end
                end
            end
            delete('NeuronLFPCoupling_OB4HzPaper/PhasePrecessionSearch.mat')
            save('NeuronLFPCoupling_OB4HzPaper/PhasePrecessionSearch.mat','NormTime_tsd','Corr','Pval','AllData_Align','EpLength','EpLengthLow')
            clear('NormTime_tsd','Corr','Pval','AllData_Align')
            
        end
    end
end




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

TimeBin =2;

numNeurons=[];
FieldNames={'OB1','PFCx'};
MiceDone = {};
XToInterp = [0:0.1:1];
AllCorr{1} = [];AllCorr{2} = [];
MaxCorr{1} = [];  MaxCorr{2} = [];
MaxCorrPval{1} = [];  MaxCorrPval{2} = [];

for mm=1:length(Dir.path)
    if exist(Dir.path{mm})>0 && strcmp(Dir.group{mm},'CTRL')
        cd(Dir.path{mm})
        
        if exist('NeuronLFPCoupling_OB4HzPaper/AllEpochNeuronModFreqMiniMaxiPhaseCorrected_OB1.mat')>0
            disp(Dir.path{mm})
            
            load('NeuronLFPCoupling_OB4HzPaper/PhasePrecessionSearch.mat')
                            load('NeuronLFPCoupling_OB4HzPaper/AllEpochNeuronModFreqMiniMaxiPhaseCorrected_OB1.mat')

            for eplg = 1:2
                if not(isempty(Corr{2}))
                    for sp =1:length(AllData_Align{eplg})
                        [val,ind] = max(Corr{eplg}(sp,:)');
                        MaxCorr{eplg} = [MaxCorr{eplg},val];
                        MaxCorrPval{eplg} = [MaxCorrPval{eplg},Pval{eplg}(sp,ind)];
                        AllCorr{eplg} = [AllCorr{eplg};nanmean(AllData_Align{eplg}{sp},1)];
                    end
                end
                
            end
            
        end
    end
    
    
end

AllCorr{2}(MaxCorrPval{1}>0.05 | MaxCorrPval{2}>0.05,:) = [];
MaxCorr{2}(MaxCorrPval{1}>0.05 | MaxCorrPval{2}>0.05) = [];
AllCorr{1}(MaxCorrPval{1}>0.05 | MaxCorrPval{2}>0.05,:) = [];
MaxCorr{1}(MaxCorrPval{1}>0.05 | MaxCorrPval{2}>0.05) = [];

AllNeurNormSh_sorted = sortrows([MaxCorr{1};AllCorr{1}']');
AllNeurNormSh_sorted = AllNeurNormSh_sorted(:,2:end);
AllNeurNormLg_sorted = sortrows([MaxCorr{1};AllCorr{2}']');
AllNeurNormLg_sorted = AllNeurNormLg_sorted(:,2:end);


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

TimeBin =2;

numNeurons=[];
FieldNames={'OB1','PFCx'};
MiceDone = {};
XToInterp = [0:0.1:1];
for mm=1:length(Dir.path)
    if exist(Dir.path{mm})>0 && strcmp(Dir.group{mm},'CTRL')
        cd(Dir.path{mm})
        clear FreezeEpoch FreezeAccEpoch
        if exist('NeuronLFPCoupling_OB4HzPaper/AllEpochNeuronModFreqMiniMaxiPhaseCorrected_OB1.mat')>0
            disp(Dir.path{mm})
            
            clear PhasetsdSub WfId
            clear PhasesSpikes mu LFP
            clear FreezeEpoch MovAcctsd numNeurons numtt TT FreezeAccEpoch
            
            load('NeuronLFPCoupling_OB4HzPaper/AllEpochNeuronModFreqMiniMaxiPhaseCorrected_OB1.mat')
            load('behavResources.mat')
            load('NeuronLFPCoupling_OB4HzPaper/PhasePrecessionSearch.mat')
            load('LFPData/InfoLFP.mat')
            load(['LFPData/LFP',num2str(InfoLFP.channel(1)),'.mat'])
            
            
            if exist('FreezeAccEpoch')>0
                FreezeEpoch = FreezeAccEpoch;
            end
            
            FreezeEpoch = mergeCloseIntervals(FreezeEpoch,2*1e4);
                        
            FreezeEpoch1 = dropLongIntervals(FreezeEpoch,EpLength(1)*1e4);
            FreezeEpoch1 = dropShortIntervals(FreezeEpoch1,EpLengthLow(1)*1e4);
            
            FreezeEpoch2 = dropLongIntervals(FreezeEpoch,EpLength(2)*1e4);
            FreezeEpoch2 = dropShortIntervals(FreezeEpoch2,EpLengthLow(2)*1e4);

            
            AllCorr{1} = [];AllCorr{2} = [];
            MaxCorr{1} = [];  MaxCorr{2} = [];
            MaxCorrPval{1} = [];  MaxCorrPval{2} = [];
            
            
            
            for eplg = 1:2
                if not(isempty(Corr{2}))
                    for sp =1:length(AllData_Align{eplg})
                        [val,ind] = max(Corr{eplg}(sp,:)');
                        MaxCorr{eplg} = [MaxCorr{eplg},val];
                        MaxCorrPval{eplg} = [MaxCorrPval{eplg},Pval{eplg}(sp,ind)];
                    end
                end
            end
            GoodNeurons = find(MaxCorrPval{1}<0.05 & MaxCorrPval{2}<0.05);
            
            % Make time as a function of freeze period dur
            Alltime = [];
            for k = 1:length(Start(FreezeEpoch1))
                times = Range(Restrict(LFP,subset(FreezeEpoch1,k)));
                timesNorm = (times-min(times))./(max(times)-min(times));
                Alltime = [Alltime;[times,timesNorm]];
            end
            NormTime_tsd{1} = tsd(Alltime(:,1),Alltime(:,2));
            
            % Make time as a function of freeze period dur
            Alltime = [];
            for k = 1:length(Start(FreezeEpoch2))
                times = Range(Restrict(LFP,subset(FreezeEpoch2,k)));
                timesNorm = (times-min(times))./(max(times)-min(times));
                Alltime = [Alltime;[times,timesNorm]];
            end
            NormTime_tsd{2} = tsd(Alltime(:,1),Alltime(:,2));
                    
            for sp = 1:length(GoodNeurons)
                subplot(121)
                [val,ind] = max(Corr{1}(GoodNeurons(sp),:)');
                NormTime = Data(Restrict(NormTime_tsd{1},ts(Range(Restrict(PhasesSpikes.Nontransf{GoodNeurons(sp)},FreezeEpoch1)))));
                plot(NormTime,mod(Data(Restrict(PhasesSpikes.Nontransf{GoodNeurons(sp)},FreezeEpoch1))+ind*(2*pi/100),2*pi),'*')
                title(num2str(ind))
                [R,P] =  corrcoef(NormTime,mod(Data(Restrict(PhasesSpikes.Nontransf{GoodNeurons(sp)},FreezeEpoch1))+ind*(2*pi/100),2*pi));
R
val

                subplot(122)
                [val,ind] = max(Corr{2}(GoodNeurons(sp),:)');
                NormTime = Data(Restrict(NormTime_tsd{2},ts(Range(Restrict(PhasesSpikes.Nontransf{GoodNeurons(sp)},FreezeEpoch2)))));
                plot(NormTime,mod(Data(Restrict(PhasesSpikes.Nontransf{GoodNeurons(sp)},FreezeEpoch2))+ind*(2*pi/100),2*pi),'*')
                [R,P] =  corrcoef(NormTime,mod(Data(Restrict(PhasesSpikes.Nontransf{GoodNeurons(sp)},FreezeEpoch2))+ind*(2*pi/100),2*pi));
R
val
                title(num2str(ind))
                keyboard
                
            end
        end
        
    end
end




