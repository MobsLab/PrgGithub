Dir = PathForExperimentsMtzlProject('SoundTestPlethysmo');

OptionsMiniMaxi.Fs=1250; % sampling rate of LFP
OptionsMiniMaxi.FilBand=[1 20];
OptionsMiniMaxi.std=[0.5 0.2];
OptionsMiniMaxi.TimeLim=0.07;

FolderName='FilteredLFP';


for mm=1:length(Dir.path)
    
    cd(Dir.path{mm}{1})
    if exist('SpikeData.mat')>0
        disp(Dir.path{mm}{1})
        clear S Kappa PhasesSpikes numNeurons Kappa pval LFP chH channel  Signal Y PhaseInterpol
        
        try
            load('ChannelsToAnalyse/dHPC_deep.mat')
            chH=channel;
        catch
            try
                try
                    load('ChannelsToAnalyse/dHPC_rip.mat')
                    chH=channel;
                catch
                    load('ChannelsToAnalyse/dHPC_sup.mat')
                    chH=channel;
                    
                end
            catch
                chH=input('please give hippocampus channel for theta ');
            end
        end
        
        load(strcat('LFPData/LFP',num2str(chH),'.mat'));
        
        % MiniMaxi
        Signal=LFP;
        AllPeaks=FindPeaksForFrequency(Signal,OptionsMiniMaxi,0);
        AllPeaks(:,3)=[0:pi:pi*(length(AllPeaks)-1)];
        Y=interp1(AllPeaks(:,1),AllPeaks(:,3),Range(Signal,'s'));
        if AllPeaks(1,2)==1
            PhaseInterpol=tsd(Range(Signal),mod(Y,2*pi));
        else
            PhaseInterpol=tsd(Range(Signal),mod(Y+pi,2*pi));
        end
        mkdir(FolderName)
        save([FolderName,'/MiniMaxiLFP','HPC','.mat'],'channel','AllPeaks','OptionsMiniMaxi','PhaseInterpol','-v7.3')
        
        
        load('ExpeInfo.mat')
        
        DRG{mm} = ExpeInfo.DrugInjected;
        
        
        
        Sig1=tsd(Range(PhaseInterpol),-sin(mod(Data(PhaseInterpol),2*pi)-pi/2));
        dat=Data(Sig1);tps=Range(Sig1);
        tps(isnan(dat))=[]; dat(isnan(dat))=[];
        Sig1=tsd(tps,dat);
        %% get the n° of the neurons of PFCx
        numtt=[]; % nb tetrodes ou montrodes du PFCx
        load LFPData/InfoLFP.mat
        chans=InfoLFP.channel(strcmp(InfoLFP.structure,'PFCx'));
        load('SpikeData.mat')
        
        
        for cc=1:length(chans)
            for tt=1:length(tetrodeChannels) % tetrodeChannels= tetrodes ou montrodes (toutes)
                if ~isempty(find(tetrodeChannels{tt}==chans(cc)))
                    numtt=[numtt,tt];
                end
            end
        end
        
        numNeurons=[]; % neurones du PFCx
        for i=1:length(S);
            if ismember(TT{i}(1),numtt)
                numNeurons=[numNeurons,i];
            end
        end
        
        numMUA=[];
        for k=1:length(numNeurons)
            j=numNeurons(k);
            if TT{j}(2)==1
                numMUA=[numMUA, k];
            end
        end
        numNeurons(numMUA)=[];
        nbin = 30;
        clear pval Kappa
        for i=1:length(numNeurons)
            [PhasesSpikes.Real{i},mu.Real{i},Kappa.Real{i},pval.Real{i}]=SpikeLFPModulationTransform(S{numNeurons(i)},Sig1,intervalSet(0,max(Range(LFP))),nbin,0,1);
            PKeep{mm}(i) = pval.Real{i}.Transf;
            KappaKeep{mm}(i) = Kappa.Real{i}.Transf;
            
        end
        
    end
end


MTZLanimals = 3:5;
SALanimals = 7:9;
PMTZL=[];
KappaMTZL=[];
KappaSAL=[];
PSAL=[];
for mm = MTZLanimals
    PMTZL = [PMTZL,PKeep{mm}];
    KappaMTZL = [KappaMTZL,KappaKeep{mm}];
end


for mm = SALanimals
    PSAL = [PSAL,PKeep{mm}];
    KappaSAL = [KappaSAL,KappaKeep{mm}];
    
end

figure
subplot(2,2,1)
pie([sum(PMTZL<0.05)./length(PMTZL),1-sum(PMTZL<0.05)./length(PMTZL)],[0,0],{'Sig','NoSig'})
title('MTZL - 20units, 3animals')

subplot(2,2,2)
pie([sum(PSAL<0.05)./length(PSAL),1-sum(PSAL<0.05)./length(PSAL)],[0,0],{'Sig','NoSig'})
title('SAL - 39units, 3animals')

subplot(2,2,3:4)
nhist({KappaMTZL(PMTZL<0.05),KappaSAL(PSAL<0.05)})
legend('MTZL','SAL')
xlabel('Kappa ')
title('Distribution of Kappa for sig units')




[h,p, chi2stat,df] =prop_test([sum(PMTZL<0.05),sum(PSAL<0.05)],[length(PMTZL),length(PSAL)],'true');

