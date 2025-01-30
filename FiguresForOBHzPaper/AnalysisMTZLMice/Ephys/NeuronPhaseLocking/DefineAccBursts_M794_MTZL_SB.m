%%%
clear all,
FileName{1} = '/media/nas4/ProjetMTZL/Mouse794/20181123/M794_SleepPlethysmo_181123_090246';
FileName{2} = '/media/nas4/ProjetMTZL/Mouse794/20181126/M794_SLeepPlethysmo_181126_091803';

clf
for f = 1:2
    cd(FileName{f})
    clear LFP A aint LFPClean AccBurst
    load('LFPData/LFP35.mat')
    a = Data(LFP);
    a(a<-3.5e4)=NaN;
    a(a>-0.5)=NaN;
    aint = naninterp(a);
    A=tsd(Range(LFP),[0;diff(aint)]);
    LFPClean = tsd(Range(LFP),aint);
    LFPClean = tsd(Range(LFP),Data(LFPClean)-movmean(Data(LFPClean),1250*60));
    
    AccBurst = thresholdIntervals(LFPClean,1000,'Direction','Above');
    AccBurst = mergeCloseIntervals(AccBurst,1*1e4);
    AccBurst = dropShortIntervals(AccBurst,1*1e4);
    AccBurst = dropLongIntervals(AccBurst,5*1e4);
    [numNeurons, numtt, TT]=GetSpikesFromStructure('PFCx', 'remove_MUA',1);
    
    
    load('SpikeData.mat')
    mkdir('NeuronResponseToMovement')
    mkdir('NeuronResponseToMovement/IndividualNeuronFigs')
    
    clear sq sweeps
    for n=1:length(numNeurons)
        [fh,sq{n},sweeps{n}] = RasterPETH(S{numNeurons(n)}, ts(Start(AccBurst)), -4*1e4,+4*1e4,'BinSize',1E3,'Markers',{ts(End(AccBurst))},'MarkerTypes',{'ro','r'});title(cellnames{n})
        title(TT{n})
        saveas(fh.Number,['NeuronResponseToMovement/IndividualNeuronFigs/', cellnames{n},'.png'])
        clf
    end
    save('NeuronResponseToMovement/Results.mat','sq','sweeps','AccBurst')
        
    
end
