SessTypes={'EPM','Habituation','SleepPreUMaze','TestPre','UMazeCond','SleepPostUMaze','TestPost','Extinction','SoundHab',...
    'SleepPreSound','SoundCond','SleepPostSound','SoundTest','BaselineSleep',...
    'HabituationNight' 'SleepPreNight' 'TestPreNight' 'UMazeCondNight' 'SleepPostNight' 'TestPostNight' 'ExtinctionNight'};

[params,movingwin,suffix]=SpectrumParametersML('low'); % low or high

DidntWork={};d=1;
for s=14
    SessTypes{s}
    Files=PathForExperimentsEmbReact(SessTypes{s});
    try
        MouseToAvoid=[117,431]; % mice with noisy data to exclude
        Files=RemoveElementsFromDir(Files,'nmouse',MouseToAvoid);
    end
    if s==15
                MouseToAvoid=[485]; % mice with noisy data to exclude
        Files=RemoveElementsFromDir(Files,'nmouse',MouseToAvoid);

    end
    for pp=1:length(Files.path)
        for c=1%:length(Files.path{pp})
            
                cd(Files.path{pp}{c})
                Files.path{pp}{c}
                clear chH chB chP filename SWSEpoch REMEpoch StimEpoch Epoch LFP
                
                % load channel numbers
                try
                    load('ChannelsToAnalyse/dHPC_rip.mat')
                    chH=channel;clear channel
                catch
                    load('ChannelsToAnalyse/dHPC_deep.mat')
                    chH=channel;clear channel
                end
                
                load('ChannelsToAnalyse/Bulb_deep.mat')
                chB=channel;clear channel
                
                load('ChannelsToAnalyse/PFCx_deep.mat')
                chP=channel;clear channel
                
                clear chLocHpc
                if exist('ChannelsToAnalyse/dHPC_local.mat')>0
                    load('ChannelsToAnalyse/dHPC_local.mat')
                    if not(isempty(channel))
                        chLocHpc=channel;
                        load(strcat('LFPData/LFP',num2str(chLocHpc(1)),'.mat'));
                        LFP1=LFP;
                        load(strcat('LFPData/LFP',num2str(chLocHpc(2)),'.mat'));
                        LFP2=LFP;
                        LFP=tsd(Range(LFP),Data(LFP1)-Data(LFP2));
                        save('LFPData/LocalHPCActivity.mat','LFP','channel')
                        clear channel
                    end
                end
                
                clear chLocOB
                if exist('ChannelsToAnalyse/Bulb_loc.mat')>0
                    load('ChannelsToAnalyse/Bulb_loc.mat')
                    if not(isempty(channel))
                        chLocOB=channel;
                        load(strcat('LFPData/LFP',num2str(chLocOB(1)),'.mat'));
                        LFP1=LFP;
                        load(strcat('LFPData/LFP',num2str(chLocOB(2)),'.mat'));
                        LFP2=LFP;
                        LFP=tsd(Range(LFP),Data(LFP1)-Data(LFP2));
                        save('LFPData/LocalOBActivity.mat','LFP','channel')
                        clear channel
                    end
                end
                
                load(['LFPData/LFP',num2str(chP),'.mat'])
                
                try, load('StateEpochSB.mat','Epoch'),catch, Epoch=intervalSet(0,max(Range(LFP))), end
                try,load('behavResources.mat','StimEpoch'),Epoch=Epoch-StimEpoch; end
                try, load('StateEpochSB.mat','REMEpoch','SWSEpoch'), end
                
                
                try,IsSleep=Files.ExpeInfo{pp}{c}.SleepSession;
                catch,IsSleep=Files.ExpeInfo{pp}.SleepSession; ,end
                filename=cd;
                if filename(end)~='/'
                    filename(end+1)='/';
                end
                
                
                %%Calculate all spectra
                LowSpectrumSB(filename,chB,'B',1);
                LowSpectrumSB(filename,chH,'H',1);
                LowSpectrumSB(filename,chP,'PFCx',1);
                
                if exist('ChannelsToAnalyse/dHPC_local.mat')>0
                    load('ChannelsToAnalyse/dHPC_local.mat')
                    if not(isempty(channel))
                        disp('Calculating local HPC Spectrum')
                        LowSpectrumSB(filename,chLocHpc(1),'H1',1);
                        LowSpectrumSB(filename,chLocHpc(2),'H2',1);
                        load('LFPData/LocalHPCActivity.mat')
                        Spectro=LowSpectrumSBNoSaveCode(LFP,0);
                        ch=chLocHpc;
                        save(strcat('HLoc_Low_Spectrum.mat'),'Spectro','ch','-v7.3')
                    end
                end

                if exist('ChannelsToAnalyse/Bulb_loc.mat')>0
                    load('ChannelsToAnalyse/Bulb_loc.mat')
                    if not(isempty(channel))
                        disp('Calculating local OB Spectrum')
                        LowSpectrumSB(filename,chLocOB(1),'B1',1);
                        LowSpectrumSB(filename,chLocOB(2),'B2',1);
                        load('LFPData/LocalOBActivity.mat')
                        Spectro=LowSpectrumSBNoSaveCode(LFP,0);
                        ch=chLocOB;
                        save(strcat('BLoc_Low_Spectrum.mat'),'Spectro','ch','-v7.3')
                    end
                end
                
                %%Calculate all coherence
                
                LowCohgramSB(filename,chH,'H',chB,'B',1)
                LowCohgramSB(filename,chH,'H',chP,'PFCx',1)
                LowCohgramSB(filename,chB,'B',chP,'PFCx',1)
                
                if exist('ChannelsToAnalyse/dHPC_local.mat')>0
                    load('ChannelsToAnalyse/dHPC_local.mat')
                    if not(isempty(channel))
                        LowCohgramSB(filename,chLocHpc(1),'H1',chB,'B',1)
                        LowCohgramSB(filename,chLocHpc(2),'H2',chB,'B',1)
                        LowCohgramSB(filename,chLocHpc(1),'H1',chP,'PFCx',1)
                        LowCohgramSB(filename,chLocHpc(2),'H2',chP,'PFCx',1)
                        
                        load(['LFPData/LocalHPCActivity.mat']);LFP1=LFP;
                        load(['LFPData/LFP',num2str(chP),'.mat']);LFP2=LFP;
                        ch1=chLocHpc;ch2=chP;
                        [C,phi,S12,S1,S2,t,f,confC,phistd]=cohgramc(Data(LFP1),Data(LFP2),movingwin,params);
                        Coherence={C,t,f};
                        SingleSpectro.ch1={S1,t,f};
                        SingleSpectro.ch2={S2,t,f};
                        CrossSpectro={S12,t,f};
                        save(strcat(filename,'HPCLoc','_','PFCx','_Low_Coherence.mat'),'Coherence','SingleSpectro','CrossSpectro','ch1','ch2','phi','confC','-v7.3')
                        clear C phi S12 S1 S2 t f confC phist Coherence SingleSpectro CrossSpectro ch1 ch2 phi confC
                        
                        if exist('ChannelsToAnalyse/Bulb_loc.mat')>0
                            load('ChannelsToAnalyse/Bulb_loc.mat')
                            if not(isempty(channel))
                                load(['LFPData/LocalOBActivity.mat']);LFP2=LFP;
                                ch1=chLocHpc;ch2=chLocOB;
                                [C,phi,S12,S1,S2,t,f,confC,phistd]=cohgramc(Data(LFP1),Data(LFP2),movingwin,params);
                                Coherence={C,t,f};
                                SingleSpectro.ch1={S1,t,f};
                                SingleSpectro.ch2={S2,t,f};
                                CrossSpectro={S12,t,f};
                                save(strcat(filename,'HPCLoc','_','OBLoc','_Low_Coherence.mat'),'Coherence','SingleSpectro','CrossSpectro','ch1','ch2','phi','confC','-v7.3')
                                clear C phi S12 S1 S2 t f confC phist Coherence SingleSpectro CrossSpectro ch1 ch2 phi confC
                            end
                        end
                        clear LFP1 LFP2 LFP
                    end
                end
                
                if exist('ChannelsToAnalyse/Bulb_loc.mat')>0
                    load('ChannelsToAnalyse/Bulb_loc.mat')
                    if not(isempty(channel))
                        LowCohgramSB(filename,chLocOB(1),'B1',chP,'PFCx',1)
                        LowCohgramSB(filename,chLocOB(2),'B2',chP,'PFCx',1)
                        LowCohgramSB(filename,chLocOB(1),'B1',chH,'H',1)
                        LowCohgramSB(filename,chLocOB(2),'B2',chH,'H',1)
                        
                        load(['LFPData/LocalOBActivity.mat']);LFP1=LFP;
                        load(['LFPData/LFP',num2str(chP),'.mat']);LFP2=LFP;
                        ch1=chLocOB;ch2=chP;
                        [C,phi,S12,S1,S2,t,f,confC,phistd]=cohgramc(Data(LFP1),Data(LFP2),movingwin,params);
                        Coherence={C,t,f};
                        SingleSpectro.ch1={S1,t,f};
                        SingleSpectro.ch2={S2,t,f};
                        CrossSpectro={S12,t,f};
                        save(strcat(filename,'OBLoc','_','PFCx','_Low_Coherence.mat'),'Coherence','SingleSpectro','CrossSpectro','ch1','ch2','phi','confC','-v7.3')
                        clear  C phi S12 S1 S2 t f confC phist Coherence SingleSpectro CrossSpectro ch1 ch2 phi confC
                    end
                    clear LFP1 LFP2 LFP

                end
                
                
            
        end
    end
end

