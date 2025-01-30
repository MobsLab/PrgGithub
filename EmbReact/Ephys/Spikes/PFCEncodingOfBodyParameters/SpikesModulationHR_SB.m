
clear all
nbin = 20;
SessionNames = {'BaselineSleep'};

for ss = 1:length(SessionNames)
    Dir = PathForExperimentsEmbReact(SessionNames{ss});
    
    for d = 1:length(Dir.path)
        cd(Dir.path{d}{1})
        if exist('SpikeData.mat')>0 & exist('HeartBeatInfo.mat')>0
            
            
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
            save('NeuronsOnHeartBeat/PhaseLocking_SWS','PhasesSpikes','mu','Kappa','pval','Epoch','-v7.3')
            clear PhasesSpikes mu Kappa pval
            
            for i=1:length(numNeurons)
                [C, B] = CrossCorr(Range(Restrict(EKG.HBTimes,Epoch)),Range(S{numNeurons(i)}),5,200);
                AllneurResp(i,:) = C;
                [C, B] = CrossCorr(Range(Restrict(EKG.HBTimes,Epoch))+0.5*1e4,Range(S{numNeurons(i)}),5,200);
                AllneurResp_Shuff500(i,:) = C;
                [C, B] = CrossCorr(Range(Restrict(EKG.HBTimes,Epoch))+1*1e4,Range(S{numNeurons(i)}),5,200);
                AllneurResp_Shuff1000(i,:) = C;
            end
            save('NeuronsOnHeartBeat/TriggeredFiring_SWS','B','AllneurResp','AllneurResp_Shuff500','AllneurResp_Shuff1000','Epoch','-v7.3')
            clear B AllneurResp AllneurResp_Shuff1000 AllneurResp_Shuff500

            
            % REM
            Epoch = REMEpoch-TotalNoiseEpoch;
            for i=1:length(numNeurons)
                Stemp{numNeurons(i)}=Restrict(S{numNeurons(i)},intervalSet(min(Range(Sig1)),max(Range(Sig1))));
                [PhasesSpikes_temp,mu_temp,Kappa_temp,pval_temp]=SpikeLFPModulationTransform(Stemp{numNeurons(i)},Sig1,Epoch,nbin,0,1);
                PhasesSpikes{i} = PhasesSpikes_temp.Nontransf;
                mu(i) = mu_temp.Nontransf;
                Kappa(i) = Kappa_temp.Nontransf;
                pval(i) = pval_temp.Nontransf;
            end
            save('NeuronsOnHeartBeat/PhaseLocking_REM','PhasesSpikes','mu','Kappa','pval','Epoch','-v7.3')
            clear PhasesSpikes mu Kappa pval
            
            for i=1:length(numNeurons)
                [C, B] = CrossCorr(Range(Restrict(EKG.HBTimes,Epoch)),Range(S{numNeurons(i)}),5,200);
                AllneurResp(i,:) = C;
                [C, B] = CrossCorr(Range(Restrict(EKG.HBTimes,Epoch))+0.5*1e4,Range(S{numNeurons(i)}),5,200);
                AllneurResp_Shuff500(i,:) = C;
                [C, B] = CrossCorr(Range(Restrict(EKG.HBTimes,Epoch))+1*1e4,Range(S{numNeurons(i)}),5,200);
                AllneurResp_Shuff1000(i,:) = C;
            end
            save('NeuronsOnHeartBeat/TriggeredFiring_REM','B','AllneurResp','AllneurResp_Shuff500','AllneurResp_Shuff1000','Epoch','-v7.3')
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
            save('NeuronsOnHeartBeat/PhaseLocking_Wake','PhasesSpikes','mu','Kappa','pval','Epoch','-v7.3')
            clear PhasesSpikes mu Kappa pval
            
            for i=1:length(numNeurons)
                [C, B] = CrossCorr(Range(Restrict(EKG.HBTimes,Epoch)),Range(S{numNeurons(i)}),5,200);
                AllneurResp(i,:) = C;
                [C, B] = CrossCorr(Range(Restrict(EKG.HBTimes,Epoch))+0.5*1e4,Range(S{numNeurons(i)}),5,200);
                AllneurResp_Shuff500(i,:) = C;
                [C, B] = CrossCorr(Range(Restrict(EKG.HBTimes,Epoch))+1*1e4,Range(S{numNeurons(i)}),5,200);
                AllneurResp_Shuff1000(i,:) = C;
            end
            save('NeuronsOnHeartBeat/TriggeredFiring_Wake','B','AllneurResp','AllneurResp_Shuff500','AllneurResp_Shuff1000','Epoch','-v7.3')
            clear B AllneurResp AllneurResp_Shuff1000 AllneurResp_Shuff500
            
        end
    end
end


%% Look at the results
figure
ha = tight_subplot(6,6);
num =  1;
for ss = 1:length(SessionNames)
    Dir = PathForExperimentsEmbReact(SessionNames{ss});
    mm = 1;
    KappaSigUnits.Wake{ss} = [];
    MuSigUnits.Wake{ss}  = [];
    KappaSigUnits.REM{ss} = [];
    MuSigUnits.REM{ss}  = [];
    
    KappaSigUnits.NREM{ss} = [];
    MuSigUnits.NREM{ss}  = [];
    
    for d = 1:length(Dir.path)
        cd(Dir.path{d}{1})
        if exist('SpikeData.mat')>0 & exist('HeartBeatInfo.mat')>0
            
            
            load('NeuronsOnHeartBeat/PhaseLocking_Wake_SubsampletoREM')
            NumUnit.Wake{ss}(mm) = length(pval);
            PropSigUnits.Wake{ss}(mm) = sum(pval<0.05)/length(pval);
            KappaSigUnits.Wake{ss} = [KappaSigUnits.Wake{ss},Kappa(pval<0.05)];
            MuSigUnits.Wake{ss} = [MuSigUnits.Wake{ss},mu(pval<0.05)];
            
            load('NeuronsOnHeartBeat/PhaseLocking_REM')
            NumUnit.REM{ss}(mm) = length(pval);
            PropSigUnits.REM{ss}(mm) = sum(pval<0.05)/length(pval);
            KappaSigUnits.REM{ss} = [KappaSigUnits.REM{ss},pval(pval<0.05)];
            MuSigUnits.REM{ss} = [MuSigUnits.REM{ss},mu(pval<0.05)];
            GoodUnits = find(pval<0.05);

            for k = 1:length(GoodUnits)
                subplot(ha(num))
                [Y,X] = hist([PhasesSpikes{GoodUnits(k)};PhasesSpikes{GoodUnits(k)}+2*pi],60);
                bar(X,runmean(Y,2),'FaceColor','k','EdgeColor','k')
                %                 xlim([0 4*pi])
                xlim([0+0.5 4*pi-0.5])
                set(gca,'XTick',[],'YTick',[])

%                 pause
                num = num+1;
            end
            load('NeuronsOnHeartBeat/PhaseLocking_SWS_SubsampletoREM')
            NumUnit.NREM{ss}(mm) = length(pval);
            PropSigUnits.NREM{ss}(mm) = sum(pval<0.05)/length(pval);
            KappaSigUnits.NREM{ss} = [KappaSigUnits.NREM{ss},Kappa(pval<0.05)];
            MuSigUnits.NREM{ss} = [MuSigUnits.NREM{ss},mu(pval<0.05)];
            mm=mm+1;
            
        end
    end
end


figure('color','w')
for ss = 1:length(SessionNames)

    subplot(1,4,ss)
    PlotErrorBarN_KJ(100*[PropSigUnits.NREM{ss};PropSigUnits.REM{ss};PropSigUnits.Wake{ss}]','newfig',0)
    set(gca,'Xtick',[1,2,3],'XTickLabel',{'NREM','REM','Wake'})
    line(xlim,[5 5],'color','r')
    ylabel('% sig modulated units')
    ylim([0 20])
    title(SessionNames{ss})
    set(gca,'linewidth',2,'FontSize',12)
    
end


figure
clf
for ss = 1:length(SessionNames)

    subplot(1,4,ss)
    PlotErrorBarN_KJ({KappaSigUnits.NREM{ss},KappaSigUnits.REM{ss},KappaSigUnits.Wake{ss}},'newfig',0,'paired',0)
    set(gca,'Xtick',[1,2,3],'XTickLabel',{'NREM','REM','Wake'})
    ylabel('Kappa of sig units')
    title(SessionNames{ss})
    ylim([0 1.2])
    set(gca,'linewidth',2,'FontSize',12)
    
end


figure
clf
for ss = 1:length(SessionNames)

    subplot(1,4,ss)
    nhist({MuSigUnits.NREM{ss},MuSigUnits.REM{ss},MuSigUnits.Wake{ss}},'binfactor',5,'samebins','noerror')
    xlabel('Angle of sig units')
    title(SessionNames{ss})
    set(gca,'linewidth',2,'FontSize',12)
    
end




%% Nice example
clf
bar(X,Y,'FaceColor','k','EdgeColor','k')
ylabel('Spike count')
hold on
yyaxis right
t=mu(GoodUnits(k));
modRatio=Kappa(GoodUnits(k));
t = mod(t+pi,2*pi)-pi;
vm = von_mises_pdf(X-pi,t+pi,modRatio);
plot([0 X 4*pi],2*nmbBin*[vm(1) vm vm(end)],'lineWidth',2,'Color','r');
ylim([-25 25])
xlabel('Phase of Heart Beat')
set(gca,'linewidth',2,'FontSize',20,'YTick',[100])
box off
