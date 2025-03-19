clear all
Dir = PathForExperimentsMtzlProject('SleepPlethysmograph');
nbin = 30;
rmpath('/home/vador/Dropbox/Kteam/PrgMatlab/Fra/UtilsStats')

for d = 1:length(Dir.path)
    for dd = 1:length(Dir.path{d})
        cd(Dir.path{d}{dd})
        
        if exist('SpikeData.mat')>0 %& not(exist('NeuronModulation/NeuronMod_Respi_ZeroCross_total_nonoise'))>0
            try
                
                % get RespiNoise
                if not(exist('RespiNoise.mat'))>0
                    clear channel
                    load('ChannelsToAnalyse/Respi.mat')
                    chR=channel;
                    [Epoch,TotalNoiseEpoch,SubNoiseEpoch,Info]=FindNoiseEpoch_Respi(chR);
                    save('RespiNoise.mat','Epoch','TotalNoiseEpoch','SubNoiseEpoch','Info')
                end
                
                disp(Dir.path{d}{dd})
                % get the breathing info
                clear LFP Breathtsd S
                load('LFPData/LFP0.mat')
                
                load('BreathingInfo_ZeroCross.mat')
                AllPeaks=[0:2*pi:2*pi*(length(Data(Breathtsd))-1)];
                Y=interp1(Range(Breathtsd,'s'),AllPeaks,Range(LFP,'s'));
                PhaseInterpol=tsd(Range(LFP),mod(Y,2*pi));
                
                Sig1=tsd(Range(PhaseInterpol),-sin(mod(Data(PhaseInterpol),2*pi)-pi/2));
                dat=Data(Sig1);tps=Range(Sig1);datPh=Data(PhaseInterpol);
                datPh(isnan(dat))=[]; tps(isnan(dat))=[]; dat(isnan(dat))=[];
                CR=tsd(tps,dat);
                PhaseInterpol=tsd(tps,datPh);
                zr = hilbert(Data(CR));
                
                phzr = atan2(imag(zr), real(zr));
                phzr(phzr < 0) = phzr(phzr < 0) + 2 * pi;
                phaseTsd = tsd(Range(CR), phzr);
                
                load('SleepScoring_Accelero.mat','Epoch','TotalNoiseEpoch')
                Epoch = Epoch-TotalNoiseEpoch;
                RespiEpoch = load('RespiNoise.mat','TotalNoiseEpoch');
                Epoch = Epoch-RespiEpoch.TotalNoiseEpoch;

                GetModulationAllUnits_UserPhase_SB(phaseTsd,'Respi','ZeroCross','plo',1,'epoch',Epoch,'epoch_name','Total_NoNoise');
                
            end
        end
    end
end
addpath('/home/vador/Dropbox/Kteam/PrgMatlab/Fra/UtilsStats')



%% Look at results
%% figure
clear all
Dir = PathForExperimentsMtzlProject('SleepPlethysmograph');
nbin = 30;
rmpath('/home/vador/Dropbox/Kteam/PrgMatlab/Fra/UtilsStats')
num=1;
RestrictLengthEpoch = 60*10;

for d = 1:length(Dir.path)
    for dd = 1:length(Dir.path{d})
        cd(Dir.path{d}{dd})
        
        if (exist('NeuronModulation/NeuronMod_Respi_ZeroCross_total_nonoise'))>0
            clear Kappa pval
            load(('NeuronModulation/NeuronMod_Respi_ZeroCross_total_nonoise'))
            load('SleepSubstages.mat')
            load('SpikeData.mat')
            
            [numNeurons, numtt, TT]=GetSpikesFromStructure('PFCx', 'remove_MUA',1);
            if not(isempty(numNeurons))
                MouseNum{num} = Dir.ExpeInfo{d}{1}.nmouse;
                load('SleepScoring_Accelero.mat','tsdMovement')
%                 Epoch{6} = and(thresholdIntervals(tsdMovement,1e7,'Direction','Below'),Epoch{5});
%                 Epoch{7} = or(or(Epoch{5},Epoch{4}),Epoch{7});
                
                DRUG{num} = Dir.ExpeInfo{d}{dd}.DrugInjected;
                load('BreathingInfo_ZeroCross.mat')
                
                for ep = 1:5
                    clear Kappa pval mu
                    Dur = Stop(Epoch{ep},'s')-Start(Epoch{ep},'s');
                    LastGoodInterval = find(cumsum(Dur)>RestrictLengthEpoch,1,'first');    
                    if not(isempty(LastGoodInterval))
                        EpochROI = subset(Epoch{ep},1:LastGoodInterval);

                    for nn = 1:length(numNeurons)
                        Phasetsd = tsd(Range(Restrict(S{numNeurons(nn)},epoch)), PhasesSpikes.Transf{numNeurons(nn)});
                        
                        
                        
                        rmpath(genpath([dropbox, '/Kteam/PrgMatlab/FMAToolbox/General']));
                            rmpath(genpath([dropbox, '/Kteam/PrgMatlab/Fra/UtilsStats']));
                            [mu(nn),Kappa(nn), pval(nn), Rmean, delta, sigma,confDw,confUp] = CircularMean(Data(Restrict(Phasetsd,EpochROI)));
                            addpath(genpath([dropbox, '/Kteam/PrgMatlab/FMAToolbox/General']));
                            addpath(genpath([dropbox, '/Kteam/PrgMatlab/Fra/UtilsStats']));

                        Ztemp(nn) = length(Data(Restrict(Phasetsd,EpochROI))) * Rmean.^2;
                    end
                    
                    KAPPA{ep}{num} = Kappa;
                    PVAL{ep}{num} = pval;
                    MU{ep}{num} = mu;
                    Z{ep}{num} = Ztemp;
                    
                    BreathFreq{ep}{num} = hist(Data(Restrict(Frequecytsd,EpochROI)),[0:0.5:15]);
                    else
                        for nn = 1:length(numNeurons)
                            
                            KAPPA{ep}{num} = NaN;
                            PVAL{ep}{num} = NaN;
                            MU{ep}{num} = NaN;
                            Z{ep}{num} = NaN;
                        end
                        BreathFreq{ep}{num} = NaN*([0:0.5:15]);
                    end
                end
                
                
                                
                
                num = num+1;
            end
        end
    end
end

DRUG{1} = 'SALINE';
DRUG{2} = 'SALINE';

figure
clf
clear val
Type = {'SALINE','MTZLRecovery','METHIMAZOLE'};
Cols = {'b','m','r'};
Order = [1:8];
pseuil = 0.01;
QualSeuil = 10;
for mm = 1:num-1
    for ep = 7
        val(ep) = sum(PVAL{ep}{mm}<pseuil)/length(PVAL{ep}{mm});
        KappaToPlot{ep} = KAPPA{ep}{mm}(PVAL{ep}{mm}<pseuil);
        if isempty(KappaToPlot{ep})
            KappaToPlot{ep} = NaN;
        end
    end
    subplot(3,num-1,Order(mm))
    bar(val,'FaceColor',Cols{find(not(cellfun(@isempty,strfind(Type,DRUG{mm}))))}),
    ylim([0 1.3])
    title([num2str(length(PVAL{ep}{mm})) ' units'])
    text(3,1.1,num2str(MouseNum{mm}))
    set(gca,'XTick',[1:6],'XTickLabel',{'N1','N2','N3','RM','WK','QWk'})
    if mm==1
        ylabel('PropModUnits')
    end
    
    subplot(3,num-1,Order(mm)+num-1)
    for ep = 1:6
        plot(f,Coherence{ep}{mm},'linewidth',3), ylim([0.3 1]), hold on
    end
    if mm==1
        ylabel('Respi-OB Coh')
    end
    xlabel('Freq (Hz)')
    subplot(3,num-1,Order(mm)+(num-1)*2)
    PlotErrorSpreadN_KJ(KappaToPlot,'newfig',0)
    set(gca,'XTick',[1:6],'XTickLabel',{'N1','N2','N3','RM','WK','QWk'})
    ylim([0 0.8])
    if mm==1
        ylabel('Kappa')
    end
end


pseuil = 0.05;
QualSeuil = 2;
for ep=1:5
    fig = figure;

    AllKappa.METHIMAZOLE=[];
    AllKappa.SALINE=[];
    Allpval.METHIMAZOLE=[];
    Allpval.SALINE=[];
    Allmu.METHIMAZOLE=[];
    Allmu.SALINE=[];
    PvalPerAnimal.METHIMAZOLE=[];
    PvalPerAnimal.SALINE=[];
    AllZ.METHIMAZOLE=[];
    AllZ.SALINE=[];
    AllNeuronNum.METHIMAZOLE=[];
       AllNeuronNum.SALINE=[];

    for mm = 1:num-1
        UnitQual{mm} = ones(1,length(KAPPA{ep}{mm}));
        AllKappa.(DRUG{mm}) = [AllKappa.(DRUG{mm}), KAPPA{ep}{mm}(UnitQual{mm}<QualSeuil)];
        Allpval.(DRUG{mm}) = [Allpval.(DRUG{mm}), PVAL{ep}{mm}(UnitQual{mm}<QualSeuil)];
        Allmu.(DRUG{mm}) = [Allmu.(DRUG{mm}), MU{ep}{mm}(UnitQual{mm}<QualSeuil)];
        PvalPerAnimal.(DRUG{mm})=[PvalPerAnimal.(DRUG{mm}),nanmean(PVAL{ep}{mm}(UnitQual{mm}<QualSeuil)<pseuil)];
        AllZ.(DRUG{mm}) = [AllZ.(DRUG{mm}), Z{ep}{mm}(UnitQual{mm}<QualSeuil)];
        AllNeuronNum.(DRUG{mm}) = [AllNeuronNum.(DRUG{mm}), length(KAPPA{ep}{mm})];
        
    end
    
    clf
    subplot(2,3,1)
    pie([sum(Allpval.SALINE<pseuil)./length(Allpval.SALINE),1-sum(Allpval.SALINE<pseuil)./length(Allpval.SALINE)],[0,0],{'Sig','NoSig'})
    title(['SAL - ',num2str(length(Allpval.SALINE)),'units, 3animals'])
    
    subplot(2,3,2)
    pie([sum(Allpval.METHIMAZOLE<pseuil)./length(Allpval.METHIMAZOLE),1-sum(Allpval.METHIMAZOLE<pseuil)./length(Allpval.METHIMAZOLE)],[0,0],{'Sig','NoSig'})
    title(['MTZL -',num2str(length(Allpval.METHIMAZOLE)),'units, 3animals'])
    
    subplot(2,3,3)
    PlotErrorBarN_KJ({PvalPerAnimal.SALINE*100,PvalPerAnimal.METHIMAZOLE*100},'newfig',0,'paired',0)
    set(gca,'XTick',[1:2],'XTickLabel',{'SAL','MTZL'})
    ylabel('% mod untis per session')
    
    subplot(2,3,4)
    nhist({AllKappa.SALINE(Allpval.SALINE<pseuil),AllKappa.METHIMAZOLE(Allpval.METHIMAZOLE<pseuil)})
    legend('SAL','MTZL')
    xlabel('Kappa ')
    title('Kappa for sig units')
    xlim([0 1])
    
    subplot(2,3,5)
    [Y,X] = hist(Allmu.SALINE(Allpval.SALINE<pseuil),[0.25:0.5:2*pi-0.25]);
    stairs([X,X+2*pi],[Y/sum(Y),Y/sum(Y)],'color','b','linewidth',2),hold on
    [Y,X] = hist(Allmu.METHIMAZOLE(Allpval.METHIMAZOLE<pseuil),[0.25:0.5:2*pi-0.25]);
    stairs([X,X+2*pi],[Y/sum(Y),Y/sum(Y)],'color','r','linewidth',2),hold on
    xlim([0 4*pi])
    legend('SAL','MTZL')
    xlabel('Pref phase')
    title('Pref phase for sig units')
    
    subplot(2,3,6)
    [Y1,X1]=(hist(log(AllZ.METHIMAZOLE),100));
    plot(X1,100*(1-cumsum(Y1)/sum(Y1)),'r','linewidth',2), hold on
    [Y1,X1]=(hist(log(AllZ.SALINE),100));
    plot(X1,100*(1-cumsum(Y1)/sum(Y1)),'b','linewidth',2), hold on
    xlim([0 6])
    xlabel('ln(Z)')
    ylabel('Neurons %')
    box off
    line([1 1],ylim)
    legend('MTZL','SAL')
    
    
      %  saveas(fig,['AllMiceSleepPlethysmo_Stat',NameEpoch{ep},'_pseuil',num2str(pseuil),'.fig']);
      %  saveas(fig,['AllMiceSleepPlethysmo_Stat',NameEpoch{ep},'_pseuil',num2str(pseuil),'.png']);
end


subplot(2,3,1)
pie([sum(Allpval.SALINE<pseuil)./length(Allpval.SALINE),1-sum(Allpval.SALINE<pseuil)./length(Allpval.SALINE)],[0,0],{'Sig','NoSig'})
colormap(([0.2 0.2 0.2;0.8 0.8 0.8]))
freezeColors
title(['CTRL - ',num2str(length(Allpval.SALINE)),'units, ',num2str(length(PvalPerAnimal.SALINE)),'animals'])

subplot(2,3,2)
pie([sum(Allpval.METHIMAZOLE<pseuil)./length(Allpval.METHIMAZOLE),1-sum(Allpval.METHIMAZOLE<pseuil)./length(Allpval.METHIMAZOLE)],[0,0],{'Sig','NoSig'})
colormap(([0.5 0 0.1;1 0.4 0.4]))
freezeColors
title(['MTZL - ',num2str(length(Allpval.METHIMAZOLE)),'units, ',num2str(length(PvalPerAnimal.METHIMAZOLE)),'animals'])

subplot(2,3,3)
MakeSpreadAndBoxPlot_SB({PvalPerAnimal.SALINE(AllNeuronNum.SALINE>6)*100,PvalPerAnimal.METHIMAZOLE(AllNeuronNum.METHIMAZOLE>6)*100},{[0.8 0.8 0.8],[1 0.4 0.4]},[1 2],{'CTRL','MTZL'})
ylabel('% modulated units')
[p,h,stats] = ranksum(PvalPerAnimal.SALINE(AllNeuronNum.SALINE>6)*100,PvalPerAnimal.METHIMAZOLE(AllNeuronNum.METHIMAZOLE>6)*100);
sigstar({[1,2]},p);

[h,p, chi2stat,df] =prop_test([sum(Allpval.CTRL<0.05),sum(Allpval.METHIMAZOLE<0.05)],[length(Allpval.CTRL),length(Allpval.METHIMAZOLE)],'true');


subplot(2,3,4)
colormap([1 0.4 0.4;0.8 0.8 0.8])
nhist({AllKappa.METHIMAZOLE(Allpval.METHIMAZOLE<pseuil),AllKappa.SALINE(Allpval.SALINE<pseuil)},'binfactor',5,'samebins','color','colormap','noerror')
legend('MTZL','CTRL')
xlabel('Kappa (sig units only)')
ylabel('Counts')
xlim([0 1])
set(gca,'FontSize',20,'Linewidth',2)

subplot(2,3,5)
nhist({Allmu.METHIMAZOLE(Allpval.METHIMAZOLE<pseuil),Allmu.SALINE(Allpval.SALINE<pseuil)},'noerror','binfactor',4,'color','colormap')
legend('MTZL','CTRL')
xlabel('Pref phase (rad.)')
ylabel('Counts')
set(gca,'FontSize',20,'Linewidth',2)
ylim([0 0.5])

subplot(2,3,6)
[Y1,X1]=(hist(log(AllZ.SALINE),100));
plot(X1,100*(1-cumsum(Y1)/sum(Y1)),'color',[0.8 0.8 0.8],'linewidth',2), hold on
[Y1,X1]=(hist(log(AllZ.METHIMAZOLE),100));
plot(X1,100*(1-cumsum(Y1)/sum(Y1)),'color',[1 0.4 0.4],'linewidth',2), hold on
xlabel('ln(Z)')
ylabel('% units')
box off
line([1 1],ylim,'color','k')
legend('CTRL','MTZL')
xlim([0 6])
set(gca,'FontSize',20,'Linewidth',2)


% %% Noise respi was found with this code
% % clear all
% % Dir = PathForExperimentsMtzlProject('SleepPlethysmograph');
% % nbin = 30;
% % rmpath('/home/vador/Dropbox/Kteam/PrgMatlab/Fra/UtilsStats')
% %
% % for d = length(Dir.path):-1:1
% %     for dd = 1:length(Dir.path{d})
% %         cd(Dir.path{d}{dd})
% %
% %         if exist('SpikeData.mat')>0
% %             try
%                 clear channel
%                 load('ChannelsToAnalyse/Respi.mat')
%                 chR=channel;
%                 [Epoch,TotalNoiseEpoch,SubNoiseEpoch,Info]=FindNoiseEpoch_Respi(chR);
%                 save('RespiNoise.mat','Epoch','TotalNoiseEpoch','SubNoiseEpoch','Info')
% %             end
% %         end
% %     end
% % ended
% 
% 
% % Bulb Neuron example