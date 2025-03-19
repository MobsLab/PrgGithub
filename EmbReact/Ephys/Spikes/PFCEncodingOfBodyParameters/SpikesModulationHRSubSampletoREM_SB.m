
clear all
nbin = 20;
SessionNames = {'BaselineSleep'};

for ss = 1:length(SessionNames)
    Dir = PathForExperimentsEmbReact(SessionNames{ss});
    
    for d = 1:length(Dir.path)
        cd(Dir.path{d}{1})
        if exist('SpikeData.mat')>0 & exist('HeartBeatInfo.mat')>0
            disp(Dir.path{d}{1})
            
            
            clear S Alleaks Sig1 EKG numNeurons SWSEpoch REMEpoch Wake
            
            mkdir('NeuronsOnHeartBeat')
            % Phase of heart beat
            load('HeartBeatInfo.mat')
            load('LFPData/LFP1.mat')
            AllPeaks = Range(EKG.HBTimes,'s');
            AllPeaks(:,2)=[0:2*pi:2*pi*(length(AllPeaks)-1)];
            Y=interp1(AllPeaks(:,1),AllPeaks(:,2),Range(LFP,'s'));
            PhaseInterpol=tsd(Range(LFP),mod(Y,2*pi));
            Sig1=tsd(Range(PhaseInterpol),-sin(mod(Data(PhaseInterpol),2*pi)-pi/2));
            dat=Data(Sig1);tps=Range(Sig1);
            tps(isnan(dat))=[]; dat(isnan(dat))=[];
            Sig1=tsd(tps,dat);
            
            % Neurons
            load('SpikeData.mat')
            [numNeurons, numtt, TT]=GetSpikesFromStructure('PFCx','remove_MUA',1);
            
            % Epoch
            load('StateEpochSB.mat','SWSEpoch','REMEpoch','Wake','TotalNoiseEpoch')
            
            DurRemEpoch = sum(Stop(REMEpoch,'s')-Start(REMEpoch,'s'));
            % Shorten SWS
            DurSWSAll = cumsum(Stop(SWSEpoch,'s')-Start(SWSEpoch,'s'));
            SWSEpoch = subset(SWSEpoch,[1:find(DurSWSAll>DurRemEpoch,1,'first')]);
            
            % Shorten Wake
            DurWakeAll = cumsum(Stop(Wake,'s')-Start(Wake,'s'));
            Wake = subset(Wake,[1:find(DurWakeAll>DurRemEpoch,1,'first')]);
            
            
            % SWS
            Epoch = SWSEpoch-TotalNoiseEpoch;
            for i=1:length(numNeurons)
                Stemp{numNeurons(i)}=Restrict(S{numNeurons(i)},intervalSet(min(Range(Sig1)),max(Range(Sig1))));
                [PhasesSpikes_temp,mu_temp,Kappa_temp,pval_temp]=SpikeLFPModulationTransform(Stemp{numNeurons(i)},Sig1,Epoch,nbin,0,1);
                PhasesSpikes{i} = PhasesSpikes_temp.Nontransf;
                mu(i) = mu_temp.Nontransf;
                Kappa(i) = Kappa_temp.Nontransf;
                pval(i) = pval_temp.Nontransf;
            end
            save('NeuronsOnHeartBeat/PhaseLocking_SWS_SubsampletoREM','PhasesSpikes','mu','Kappa','pval','Epoch','-v7.3')
            clear PhasesSpikes mu Kappa pval
            
            for i=1:length(numNeurons)
                [C, B] = CrossCorr(Range(Restrict(EKG.HBTimes,Epoch)),Range(S{numNeurons(i)}),5,200);
                AllneurResp(i,:) = C;
                [C, B] = CrossCorr(Range(Restrict(EKG.HBTimes,Epoch))+0.5*1e4,Range(S{numNeurons(i)}),5,200);
                AllneurResp_Shuff500(i,:) = C;
                [C, B] = CrossCorr(Range(Restrict(EKG.HBTimes,Epoch))+1*1e4,Range(S{numNeurons(i)}),5,200);
                AllneurResp_Shuff1000(i,:) = C;
            end
            save('NeuronsOnHeartBeat/TriggeredFiring_SWS_SubsampletoREM','B','AllneurResp','AllneurResp_Shuff500','AllneurResp_Shuff1000','Epoch','-v7.3')
            clear B AllneurResp AllneurResp_Shuff1000 AllneurResp_Shuff500
            
            
            
            
            % Wake
            Epoch = Wake-TotalNoiseEpoch;
            for i=1:length(numNeurons)
                Stemp{numNeurons(i)}=Restrict(S{numNeurons(i)},intervalSet(min(Range(Sig1)),max(Range(Sig1))));
                [PhasesSpikes_temp,mu_temp,Kappa_temp,pval_temp]=SpikeLFPModulationTransform(Stemp{numNeurons(i)},Sig1,Epoch,nbin,0,1);
                PhasesSpikes{i} = PhasesSpikes_temp.Nontransf;
                mu(i) = mu_temp.Nontransf;
                Kappa(i) = Kappa_temp.Nontransf;
                pval(i) = pval_temp.Nontransf;
            end
            save('NeuronsOnHeartBeat/PhaseLocking_Wake_SubsampletoREM','PhasesSpikes','mu','Kappa','pval','Epoch','-v7.3')
            clear PhasesSpikes mu Kappa pval
            
            for i=1:length(numNeurons)
                [C, B] = CrossCorr(Range(Restrict(EKG.HBTimes,Epoch)),Range(S{numNeurons(i)}),5,200);
                AllneurResp(i,:) = C;
                [C, B] = CrossCorr(Range(Restrict(EKG.HBTimes,Epoch))+0.5*1e4,Range(S{numNeurons(i)}),5,200);
                AllneurResp_Shuff500(i,:) = C;
                [C, B] = CrossCorr(Range(Restrict(EKG.HBTimes,Epoch))+1*1e4,Range(S{numNeurons(i)}),5,200);
                AllneurResp_Shuff1000(i,:) = C;
            end
            save('NeuronsOnHeartBeat/TriggeredFiring_Wake_SubsampletoREM','B','AllneurResp','AllneurResp_Shuff500','AllneurResp_Shuff1000','Epoch','-v7.3')
            clear B AllneurResp AllneurResp_Shuff1000 AllneurResp_Shuff500
            
        end
    end
end
