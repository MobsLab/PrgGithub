clear all
Options.Fs=1250; % sampling rate of LFP
Options.std=[0.4 0.1]; % std limits for first and second round of peak
Options.TimeLim=0.08; % in second, minimum distance between two minima or
Options.NumOctaves=8;
Options.VoicesPerOctave=20;
Options.WVDownsample=1;
Options.TimeBandWidth=40;
Options1=Options;
Options1.Fs=Options.Fs/Options.WVDownsample;


InputInfo.thresh=[3,5];
InputInfo.duration=[0.015,0.02,0.2];
InputInfo.MakeEventFile=1;
InputInfo.EventFileName='HPCRipples';
InputInfo.SaveRipples=1;
InputInfo.MatName='Ripples_WholeSession';

PerDur=4*1e4; % in 1/100th seconds
StepBackFromStart=0.5*1e4;
NumBins=80;
Smax=log(NumBins);
SessTypes={'TestPost','UMazeCond','TestPost_EyeShock','UMazeCond_EyeShock','UMazeCondBlockedShock_EyeShock','UMazeCondBlockedSafe_EyeShock'};
Structures={'B','P','H'};
StructurePairs={'B_P','B_H','P_H'};
PhaseCalc={'PT','WV'};
RiskAssess.H_High=[];
RipTime=[];
for TypeOfEvent=2
    for ss=1:length(SessTypes)
        Files=PathForExperimentsEmbReact(SessTypes{ss});
        MouseToAvoid=[560,117,431]; % mice with noisy data to exclude
        Files=RemoveElementsFromDir(Files,'nmouse',MouseToAvoid);
        disp(SessTypes{ss})
        for mm=1:length(Files.path)
            for c=1:length(Files.path{mm})
                disp(Files.path{mm}{c})
                cd(Files.path{mm}{c})
                
                clear Behav
                load('behavResources_SB.mat')
                
                if  sum(Behav.RAUser.ToShock==TypeOfEvent)>0    & exist('ChannelsToAnalyse/dHPC_rip.mat')>0
                    
                    load('ChannelsToAnalyse/dHPC_rip.mat')
                    load(['LFPData/LFP',num2str(channel),'.mat'])

                    load('StateEpochSB.mat','TotalNoiseEpoch')
                    
%                     InputInfo.Epoch = intervalSet(0,max(Range(LFP))) - TotalNoiseEpoch;
                    
%                     FindRipplesSB(LFP,InputInfo);
                    load('Ripples_WholeSession.mat','Ripples')
                    Riptsd=ts(Ripples(:,1)*1e4);
                    clear Rip
                    
                    Strt=Start(Behav.RAEpoch.ToShock);
                    Stp=Start(Behav.RAEpoch.ToShock);
                    
                    % Trigger on the null derivative (to realign as
                    % well as possible)
                    SmooDiffLinDist=tsd(Range(Behav.LinearDist),[0;diff(runmean(Data(Behav.LinearDist),20))]);
                    EpToUse=subset(Behav.RAEpoch.ToShock,find(Behav.RAUser.ToShock==TypeOfEvent));
                    tpsout=FindClosestZeroCross(Start(EpToUse)-StepBackFromStart,SmooDiffLinDist,1);
                    
                    
                    for int=1:length(tpsout)
                        clear PhaseDiff
                        if tpsout(int)+8*1e4 < max(Range(LFP))
                            Ep=intervalSet(tpsout(int)-8*1e4,tpsout(int)+8*1e4);
                            RipTime=[RipTime;(Range(Restrict(Riptsd,Ep)))-tpsout(int)];
                            
                          
                            Ep=intervalSet(tpsout(int)-8*1e4,tpsout(int)+8*1e4);
                            [Wavelet.spec,Wavelet.freq,Wavelet.coi,Wavelet.OutParams]=cwt_SB(Data(Restrict(LFP,Ep)),Options.Fs/Options.WVDownsample,'NumOctaves',Options.NumOctaves,...
                                'VoicesPerOctave',Options.VoicesPerOctave,'TimeBandwidth',Options.TimeBandWidth);
                            if length(Wavelet.spec)==19999,Wavelet.spec(:,20000)=Wavelet.spec(:,19999);end
                            RiskAssess.H_High=cat(3,RiskAssess.H_High,Wavelet.spec);
                        end
                    end
                end
            end
        end
    end
end

figure
subplot(121)
nhist(RipTime/1e4,'pdf','binfactor',4,'noerror')
subplot(122)
plotscalogramfreq_SB(Wavelet.OutParams.FourierFactor,Wavelet.OutParams.sigmaT,squeeze(mean(abs(RiskAssess.H_High),3)),Wavelet.freq,Wavelet.OutParams.t,Wavelet.OutParams.normalizedfreq)



