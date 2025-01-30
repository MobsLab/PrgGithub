close all,clear all
minFzEpLeng=4; % sec

Files=PathForExperimentsEmbReact('UMazeCond');

for pp=2:length(Files.path)
    num=1;
    for c=1:length(Files.path{pp})
        c
        cd(Files.path{pp}{c})
        
        clear FreezeEpoch StimEpoch
        load('ChannelsToAnalyse/Bulb_deep.mat')
        chB=channel;
        load('ChannelsToAnalyse/PFCx_deep.mat')
        chP=channel;
        load('behavResources.mat')
        try,FreezeEpoch=FreezeEpoch-StimEpoch;end
        FreezeEpoch=dropShortIntervals(FreezeEpoch,minFzEpLeng*1e4);
        FreezeEpoch=CutUpEpochs(FreezeEpoch,5,10)
        if not(isempty(Start(FreezeEpoch)))
            % Get low OB Spectrum
            load('B_Low_Spectrum.mat')
            flow=Spectro{3};
            SptsdBLow=tsd(Spectro{2}*1e4,Spectro{1});
            
            load(['LFPData/LFP',num2str(chB),'.mat'])
            LFPB=LFP;
            
            if exist('OB_Wh_HighSpectra.mat')>0
                load('OB_Wh_HighSpectra.mat')
            else
                % Get high OB Spectrum
                % Whitened high frequencies
                [y, ARmodel] = WhitenSignal(Data(LFP),[],1,[],2);
                % Spectrogram
                params.Fs=1/median(diff(Range(LFP,'s')));
                params.trialave=0;
                params.err=[1 0.0500];
                params.pad=2;
                params.fpass=[20 200];
                params.tapers=[2 3];
                movingwin=[0.1 0.013];
                disp('... Calculating spectrogramm.');
                [Sp,t,f]=mtspecgramc(y,movingwin,params);
                save('OB_Wh_HighSpectra.mat','Sp','t','f')
            end
            SptsdBHigh=tsd(t*1e4,Sp);
            fhigh=f;
            
            % Get high PFCx Spectrum
            load(['LFPData/LFP',num2str(chP),'.mat'])
            LFPP=LFP;
            
            if exist('PFCx_Wh_HighSpectra.mat')>0
                load('PFCx_Wh_HighSpectra.mat')
            else
                % Whitened high frequencies
                [y, ARmodel] = WhitenSignal(Data(LFP),[],1,[],2);
                % Spectrogram
                params.Fs=1/median(diff(Range(LFP,'s')));
                params.trialave=0;
                params.err=[1 0.0500];
                params.pad=2;
                params.fpass=[20 200];
                params.tapers=[2 3];
                movingwin=[0.1 0.013];
                disp('... Calculating spectrogramm.');
                [Sp,t,f]=mtspecgramc(y,movingwin,params);
                save('PFCx_Wh_HighSpectra.mat','Sp','t','f')
                
            end
            SptsdPHigh=tsd(t*1e4,Sp);
            
            
            % Get average freq of freezing periods and trigger Spectra on the troughs
            limvalf=find(flow>1.5,1,'first');
            for f=1:size(Start(FreezeEpoch),1)
                Spectrtemp=flow.*mean(Data(Restrict(SptsdBLow,subset(FreezeEpoch,f))));
                Spectrtemp=Spectrtemp(limvalf:end);
                [val,ind]=max(Spectrtemp);
                
                GammaMod.PeakFreq(num)=flow(ind+limvalf);
                bandP=[max(PeakFreq(num)-1.5,1) PeakFreq(num)+1.5];
                GammaMod.Output{num}=GetPeakAndTroughFreqBand(Restrict(LFP,subset(FreezeEpoch,f)),bandP);
                GammaMod.FzDur(num)=Stop(subset(FreezeEpoch,f),'s')-Start(subset(FreezeEpoch,f),'s');
                WhichZone=[];
                for z=1:length(ZoneEpoch)
                    WhichZone(z)=length(Data(Restrict(LFP,and(subset(FreezeEpoch,f),ZoneEpoch{z}))));
                end
                [val,ind]=max(WhichZone),
                GammaMod.Position(num)=ind;
                [GammaMod.OB.Spec.Result{num},~,GammaMod.OB.Spec.time{num}]=AverageSpectrogram(SptsdBHigh,fhigh,Restrict(ts(Output{num}),subset(FreezeEpoch,f)),binsize,nbins,0,0,1);
                [GammaMod.PFC.Spec.Result{num},~,GammaMod.PFC.Spec.time{num}]=AverageSpectrogram(SptsdPHigh,fhigh,Restrict(ts(Output{num}),subset(FreezeEpoch,f)),binsize,nbins,0,0,1);
                binsize=20; nbins=50;
                [GammaMod.OB.Hil.Result{num},~,GammaMod.OB.Hil.time{num},~]=PhasePowerModulationExclusive(Restrict(LFPB,(subset(FreezeEpoch,f))),bandP',Restrict(LFPB,(subset(FreezeEpoch,f))),binsize,nbins,limFreq,pasfreq);binsize,nbins,limFreq,pas
                [GammaMod.PFC.Hil.Result{num},~,GammaMod.PFC.Hil.time{num},~]=PhasePowerModulationExclusive(Restrict(LFPB,(subset(FreezeEpoch,f))),bandP',Restrict(LFPP,(subset(FreezeEpoch,f))),binsize,nbins,limFreq,pasfreq);
                
                [M,T]=PlotRipRaw(LFPB,Output{num}/1e4,500,0,0);
                GammaMod.OB.LFP.Result{num}=M(:,2);    GammaMod.OB.LFP.time{num}=M(:,1);
                num=num+1;
                %     figure
                %     subplot(2,2,1)
                %     imagesc(GammaMod.OB.Spec.time{num}/1000,fhigh,GammaMod.OB.Spec.Result{num}),axis xy, hold on
                %     line([0 0],ylim,'color','w')
                %     Normalizer=(max(M(:,2))-min(M(:,2)));
                %     plot(M(:,1),40*M(:,2)/Normalizer+150,'w')
                %     title('OB-Spec')
                %     subplot(2,2,2)
                %     imagesc(GammaMod.PFC.Spec.time{num}/1000,fhigh,GammaMod.PFC.Spec.Result{num}),axis xy, hold on
                %     line([0 0],ylim,'color','w')
                %     Normalizer=(max(M(:,2))-min(M(:,2)));
                %     plot(M(:,1),40*M(:,2)/Normalizer+150,'w')
                %     title('PFC-Spec')
                %     subplot(2,2,3)
                %     imagesc(GammaMod.OB.Hil.time{num}{1}/1000,[20:2:200],GammaMod.OB.Hil.Result{num}{1}),axis xy, hold on
                %     line([0 0],ylim,'color','w')
                %     Normalizer=(max(M(:,2))-min(M(:,2)));
                %     plot(M(:,1),40*M(:,2)/Normalizer+150,'w')
                %     title('OB-Hil')
                %     subplot(2,2,4)
                %     imagesc(GammaMod.PFC.Hil.time{num}{1}/1000,[20:2:200],log(GammaMod.PFC.Hil.Result{num}{1})),axis xy, hold on
                %     line([0 0],ylim,'color','w')
                %     Normalizer=(max(M(:,2))-min(M(:,2)));
                %     plot(M(:,1),40*M(:,2)/Normalizer+150,'w')
                %     title('PFC-Hil')
            end
        end
    end
    cd ..
    
    figure
    for frrg=1:2
        if frrg==1
            ToUse=find(PeakFreq<3);
        elseif frrg==2
            ToUse=find(PeakFreq>3.5);
        end
        AvOBSpec{frrg}=zeros(size(GammaMod.OB.Spec.Result{1}));
        AvPFCSpec{frrg}=zeros(size(GammaMod.OB.Spec.Result{1}));
        AvOBShape{frrg}=zeros(size(GammaMod.OB.LFP.Result{1}));
        TotEvents{frrg}=0;
        for i=1:length(ToUse)
            AvOBSpec{frrg}=AvOBSpec{frrg}+GammaMod.OB.Spec.Result{ToUse(i)}*size(Output{ToUse(i)},1);
            AvPFCSpec{frrg}=AvPFCSpec{frrg}+GammaMod.PFC.Spec.Result{ToUse(i)}*size(Output{ToUse(i)},1);
            AvOBShape{frrg}=AvOBShape{frrg}+GammaMod.OB.LFP.Result{ToUse(i)}*size(Output{ToUse(i)},1);
            TotEvents{frrg}=TotEvents{frrg}+size(Output{ToUse(i)},1);
        end
        AvOBSpec{frrg}=AvOBSpec{frrg}/TotEvents{frrg};    AvPFCSpec{frrg}=AvPFCSpec{frrg}/TotEvents{frrg};    AvOBShape{frrg}=AvOBShape{frrg}/TotEvents{frrg};
        
        
        subplot(2,2,2*(frrg)-1)
        imagesc(GammaMod.OB.Spec.time{1}/1000,fhigh,AvOBSpec{frrg}),hold on
        axis xy
        line([0 0],ylim,'color','w')
        Normalizer=(max(AvOBShape{frrg})-min(AvOBShape{frrg}));
        plot(M(:,1),40*AvOBShape{frrg}/Normalizer+150,'w')
        title('OB')
        subplot(2,2,2*frrg)
        imagesc(GammaMod.OB.Spec.time{1}/1000,fhigh,AvPFCSpec{frrg}),hold on
        axis xy
        line([0 0],ylim,'color','w')
        Normalizer=(max(AvOBShape{frrg})-min(AvOBShape{frrg}));
        plot(M(:,1),40*AvOBShape{frrg}/Normalizer+150,'w')
        title('PFC')
    end
    save('GammaCouplingFz.mat','GammaMod','Output','FzDur','PeakFreq')
    clear GammaMod num LFPB LFPP 
end


