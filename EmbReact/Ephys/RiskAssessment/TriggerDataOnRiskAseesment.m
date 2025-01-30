clear all
clear ZoneTime
BefTime=12*1e4;
tps=[0:0.01:BefTime*2/1e4];
StepBackFromStart=0.5*1e4;

SessTypes={'TestPost','UMazeCond','TestPost_EyeShock','UMazeCond_EyeShock','UMazeCondBlockedShock_EyeShock','UMazeCondBlockedSafe_EyeShock'};
SessTypes={ 'HabituationBlockedShock_PreDrug' 'HabituationBlockedSafe_PreDrug',...
    'TestPre_PreDrug' 'UMazeCondExplo_PreDrug' 'UMazeCondBlockedShock_PreDrug' 'UMazeCondBlockedSafe_PreDrug',...
    'UMazeCondExplo_PostDrug' 'UMazeCondBlockedShock_PostDrug' 'UMazeCondBlockedSafe_PostDrug',...
    'TestPost_PostDrug'  'ExtinctionBlockedShock_PostDrug' 'ExtinctionBlockedSafe_PostDrug'};

Structures={'B','P','H'};
StructurePairs={'B_P','B_H','P_H'};

for TypeOfEvent=2
    clear RiskAssess
    for ss=4:length(SessTypes)
        Files=PathForExperimentsEmbReact(SessTypes{ss});
        MouseToAvoid=[560,117,431,795]; % mice with noisy data to exclude
        Files=RemoveElementsFromDir(Files,'nmouse',MouseToAvoid);
        disp(SessTypes{ss})
        for mm=1:length(Files.path)
            RiskAssess.(SessTypes{ss}).ToSafeMov{mm}=[];RiskAssess.(SessTypes{ss}).ToSafeType{mm}=[];RiskAssess.(SessTypes{ss}).ToSafePos{mm}=[];
            RiskAssess.(SessTypes{ss}).ToShockMov{mm}=[];RiskAssess.(SessTypes{ss}).ToShockType{mm}=[];RiskAssess.(SessTypes{ss}).ToShockPos{mm}=[];
            for st=1:length(Structures)
                RiskAssess.(SessTypes{ss}).ToShockSpec.(Structures{st}){mm}=[];
                RiskAssess.(SessTypes{ss}).ToSafeSpec.(Structures{st}){mm}=[];
                RiskAssess.(SessTypes{ss}).ToShockLFP.(Structures{st}){mm}=[];
                RiskAssess.(SessTypes{ss}).ToSafeLFP.(Structures{st}){mm}=[];
            end
            RiskAssess.(SessTypes{ss}).ToShockSpec.H_High{mm}=[];
            RiskAssess.(SessTypes{ss}).ToSafeSpec.H_High{mm}=[];
            
            for st=1:length(StructurePairs)
                RiskAssess.(SessTypes{ss}).ToShockCoh.(StructurePairs{st}){mm}=[];
                RiskAssess.(SessTypes{ss}).ToSafeCoh.(StructurePairs{st}){mm}=[];
            end
            RiskAssess.(SessTypes{ss}).ToShockEKG{mm}=[]; RiskAssess.(SessTypes{ss}).ToSafeEKG{mm}=[];
            
            for c=1:length(Files.path{mm})
                disp(Files.path{mm}{c})
                cd(Files.path{mm}{c})
                load('ExpeInfo.mat')
                
                clear Behav
                load('behavResources_SB.mat')
                if median(diff(Range(Behav.Vtsd,'s')))>10
                    Behav.Vtsd=tsd(Range(Behav.Vtsd)/1e4,Data(Behav.Vtsd));
                    save('behavResources_SB.mat','Behav','-append')
                end
                
                if  (sum(Behav.RAUser.ToSafe==TypeOfEvent)+sum(Behav.RAUser.ToShock==TypeOfEvent))>0
                    clear Sptsd Cohtsd
                    %                     if exist('InstFreqAndPhase_B.mat')>0
                    %                         load('InstFreqAndPhase_H.mat')
                    %                         Sptsd.H=tsd(Wavelet.OutParams.t*1e4,abs(Wavelet.spec)');
                    %                         load('InstFreqAndPhase_B.mat')
                    %                         Sptsd.B=tsd(Wavelet.OutParams.t*1e4,abs(Wavelet.spec)');
                    %                         load('InstFreqAndPhase_PFCx.mat')
                    %                         freqSpec=Wavelet.freq;
                    %                         Sptsd.P=tsd(Wavelet.OutParams.t*1e4,abs(Wavelet.spec)');
                    %                         load('WaveletCoherenceB_PFCx.mat')
                    %                         Cohtsd.B_P=tsd(Wavelet.OutParams.t*1e4,abs(Wavelet.Coherence)');
                    %                         load('WaveletCoherenceH_B.mat')
                    %                         Cohtsd.B_H=tsd(Wavelet.OutParams.t*1e4,abs(Wavelet.Coherence)');
                    %                         load('WaveletCoherenceH_PFCx.mat')
                    %                         Cohtsd.P_H=tsd(Wavelet.OutParams.t*1e4,abs(Wavelet.Coherence)');
                    %                         freqCoh=Wavelet.freq;
                    %                         clear Wavelet LocalFreq LocalPhase
                    %                     end
                    
                    clear EKG
                    if exist('HeartBeatInfo.mat')>0
                        load('HeartBeatInfo.mat')
                    end
                    
                    %                     %% Load relevant LFPs
                    %                     clear channel LFP LFPdowns
                    %                     try,load('ChannelsToAnalyse/dHPC_rip.mat'), catch,
                    %                         try,load('ChannelsToAnalyse/dHPC_deep.mat'),
                    %                         catch
                    %                         load('ChannelsToAnalyse/dHPC_sup.mat'),
                    %                         end
                    %                     end
                    %                     load(['LFPData/LFP',num2str(channel),'.mat'])
                    %                     AllLFP.H=LFP;
                    %                     clear channel LFP LFPdowns
                                        load('ChannelsToAnalyse/Bulb_deep.mat')
                                        load(['LFPData/LFP',num2str(channel),'.mat'])
                    %                     AllLFP.B=LFP;
                    %                     clear channel LFP LFPdowns
                    %                     try,load('ChannelsToAnalyse/PFCx_deep.mat'), catch, load('ChannelsToAnalyse/dHPC_deep.mat'), end
                    %                     load(['LFPData/LFP',num2str(channel),'.mat'])
                    %                     AllLFP.P=LFP;
                    %                     clear channel LFP LFPdowns
                    %
                    %                     % get VHighSpectrum for HPC if there is a ripples channel
                    %                     if exist('ChannelsToAnalyse/dHPC_rip.mat')>0
                    %                         if exist('H_VHigh_Spectrum.mat')==0
                    %                             VeryHighSpectrum([cd filesep],channel,'H')
                    %                             load('H_VHigh_Spectrum.mat')
                    %                             Sptsd.H_High=tsd(Spectro{2}*1e4,Spectro{1});
                    %                         else
                    %                             load('H_VHigh_Spectrum.mat')
                    %                             Sptsd.H_High=tsd(Spectro{2}*1e4,Spectro{1});
                    %                         end
                    %                         freqHiSpec=Spectro{3};
                    %                     end
                    SmooDiffLinDist=tsd(Range(Behav.LinearDist),[0;diff(runmean(Data(Behav.LinearDist),20))]);
                    RiskAssess.(SessTypes{ss}).Mouse{mm} = ExpeInfo.nmouse;
                    RiskAssess.(SessTypes{ss}).Mouse{mm} = ExpeInfo.DrugInjected;
                    
                    
                    % Shock
                    if sum(Behav.RAUser.ToShock==TypeOfEvent)>0
                        % Trigger on the null derivative (to realign as
                        % well as possible)
                        SmooDiffLinDist=tsd(Range(Behav.LinearDist),[0;diff(runmean(Data(Behav.LinearDist),20))]);
                        EpToUse=subset(Behav.RAEpoch.ToShock,find(Behav.RAUser.ToShock==TypeOfEvent));
                        tpsout=FindClosestZeroCross(Start(EpToUse)-StepBackFromStart,SmooDiffLinDist,1);
                        for t=1:length(tpsout)
                            if (tpsout(t)+BefTime)<max(Range(LFP))
                                LitEp=intervalSet(tpsout(t)-BefTime,tpsout(t)+BefTime);
                                dattemp=interp1(Range(Restrict(Behav.Vtsd,LitEp))-Start(LitEp),Data(Restrict(Behav.Vtsd,LitEp)),tps*1e4);
                                RiskAssess.(SessTypes{ss}).ToShockMov{mm}=[RiskAssess.(SessTypes{ss}).ToShockMov{mm};dattemp];
                                dattemp=interp1(Range(Restrict(Behav.LinearDist,LitEp))-Start(LitEp),Data(Restrict(Behav.LinearDist,LitEp)),tps*1e4);
                                RiskAssess.(SessTypes{ss}).ToShockPos{mm}=[RiskAssess.(SessTypes{ss}).ToShockPos{mm};dattemp];
                                RiskAssess.(SessTypes{ss}).ToShockType{mm}=[RiskAssess.(SessTypes{ss}).ToShockType{mm},Behav.RAUser.ToShock(t)];
                                
                                %                                 try
                                %                                     % Spectra
                                %                                     for st=1:length(Structures)
                                %                                         dattemp=Data(Restrict(Sptsd.(Structures{st}),LitEp));
                                %                                         if length(dattemp)==2999,dattemp(3000,:)=dattemp(2999,:);end
                                %                                         RiskAssess.(SessTypes{ss}).ToShockSpec.(Structures{st}){mm}=cat(3,RiskAssess.(SessTypes{ss}).ToShockSpec.(Structures{st}){mm},dattemp);
                                %                                         dattemp=Data(Restrict(AllLFP.(Structures{st}),LitEp));
                                %                                         if length(dattemp)==29999,dattemp(30000,:)=dattemp(29999,:);end
                                %                                         if length(dattemp)==30001,dattemp(30001,:)=[];end
                                %                                         RiskAssess.(SessTypes{ss}).ToShockLFP.(Structures{st}){mm}=[RiskAssess.(SessTypes{ss}).ToShockLFP.(Structures{st}){mm},dattemp];
                                %                                     end
                                %
                                %                                     if isfield(Sptsd,'H_High')
                                %                                         dattemp=Data(Restrict(Sptsd.H_High,LitEp));
                                %                                         %if length(dattemp)==2999,dattemp(3000,:)=dattemp(2999,:);end
                                %                                         RiskAssess.(SessTypes{ss}).ToShockSpec.H_High{mm}=cat(3,RiskAssess.(SessTypes{ss}).ToShockSpec.H_High{mm},dattemp);
                                %                                     end
                                %
                                %                                     for st=1:length(StructurePairs)
                                %                                         dattemp=Data(Restrict(Cohtsd.(StructurePairs{st}),LitEp));
                                %                                         if length(dattemp)==2999,dattemp(3000,:)=dattemp(2999,:);end
                                %                                         RiskAssess.(SessTypes{ss}).ToShockCoh.(StructurePairs{st}){mm}=cat(3,RiskAssess.(SessTypes{ss}).ToShockCoh.(StructurePairs{st}){mm},dattemp);
                                %                                     end
                                %                                 end
                                
                                if exist('EKG')>0
                                    dattemp=interp1(Range(Restrict(EKG.HBRate,LitEp))-Start(LitEp),Data(Restrict(EKG.HBRate,LitEp)),tps*1e4);
                                    RiskAssess.(SessTypes{ss}).ToShockEKG{mm}=[RiskAssess.(SessTypes{ss}).ToShockEKG{mm};dattemp];
                                end
                            end
                        end
                    end
                    
                    
                    % Safe
                    if sum(Behav.RAUser.ToSafe==TypeOfEvent)>0
                        EpToUse=subset(Behav.RAEpoch.ToSafe,find(Behav.RAUser.ToSafe==TypeOfEvent));
                        tpsout=FindClosestZeroCross(Start(EpToUse)-StepBackFromStart,SmooDiffLinDist,-1);
                        for t=1:length(tpsout)
                            if (tpsout(t)+BefTime)<max(Range(LFP))
                                LitEp=intervalSet(tpsout(t)-BefTime,tpsout(t)+BefTime);
                                dattemp=interp1(Range(Restrict(Behav.Vtsd,LitEp))-Start(LitEp),Data(Restrict(Behav.Vtsd,LitEp)),tps*1e4);
                                RiskAssess.(SessTypes{ss}).ToSafeMov{mm}=[ RiskAssess.(SessTypes{ss}).ToSafeMov{mm};dattemp];
                                dattemp=interp1(Range(Restrict(Behav.LinearDist,LitEp))-Start(LitEp),Data(Restrict(Behav.LinearDist,LitEp)),tps*1e4);
                                RiskAssess.(SessTypes{ss}).ToSafePos{mm}=[RiskAssess.(SessTypes{ss}).ToSafePos{mm};dattemp];
                                RiskAssess.(SessTypes{ss}).ToSafeType{mm}=[RiskAssess.(SessTypes{ss}).ToSafeType{mm},Behav.RAUser.ToSafe(t)];
                                %                                 try
                                %                                     % Spectra
                                %                                     for st=1:length(Structures)
                                %                                         dattemp=Data(Restrict(Sptsd.(Structures{st}),LitEp));
                                %                                         if length(dattemp)==2999,dattemp(3000,:)=dattemp(2999,:);end
                                %                                         RiskAssess.(SessTypes{ss}).ToSafeSpec.(Structures{st}){mm}=cat(3,RiskAssess.(SessTypes{ss}).ToSafeSpec.(Structures{st}){mm},dattemp);
                                %                                         dattemp=Data(Restrict(AllLFP.(Structures{st}),LitEp));
                                %                                         if length(dattemp)==29999,dattemp(30000,:)=dattemp(29999,:);end
                                %                                         if length(dattemp)==30001,dattemp(30001,:)=[];end
                                %                                         RiskAssess.(SessTypes{ss}).ToSafeLFP.(Structures{st}){mm}=[RiskAssess.(SessTypes{ss}).ToSafeLFP.(Structures{st}){mm},dattemp];
                                %                                     end
                                %                                     if isfield(Sptsd,'H_High')
                                %                                         dattemp=Data(Restrict(Sptsd.H_High,LitEp));
                                %                                         %if length(dattemp)==2999,dattemp(3000,:)=dattemp(2999,:);end
                                %                                         RiskAssess.(SessTypes{ss}).ToSafeSpec.H_High{mm}=cat(3,RiskAssess.(SessTypes{ss}).ToSafeSpec.H_High{mm},dattemp);
                                %                                     end
                                %                                     for st=1:length(StructurePairs)
                                %                                         dattemp=Data(Restrict(Cohtsd.(StructurePairs{st}),LitEp));
                                %                                         if length(dattemp)==2999,dattemp(3000,:)=dattemp(2999,:);end
                                %                                         RiskAssess.(SessTypes{ss}).ToSafeCoh.(StructurePairs{st}){mm}=cat(3,RiskAssess.(SessTypes{ss}).ToSafeCoh.(StructurePairs{st}){mm},dattemp);
                                %                                     end
                                %                                 end
                                if exist('EKG')>0
                                    dattemp=interp1(Range(Restrict(EKG.HBRate,LitEp))-Start(LitEp),Data(Restrict(EKG.HBRate,LitEp)),tps*1e4);
                                    RiskAssess.(SessTypes{ss}).ToSafeEKG{mm}=[RiskAssess.(SessTypes{ss}).ToSafeEKG{mm};dattemp];
                                end
                            end
                        end
                        
                    end
                end
            end
        end
    end
    load('InstFreqAndPhase_H.mat')
    cd /media/DataMOBsRAIDN/ProjectEmbReact/Figures/RiskAssessment
    save(['RiskAssessMatDrugs_',num2str(TypeOfEvent),'.mat'],'RiskAssess','-v7.3')
end

