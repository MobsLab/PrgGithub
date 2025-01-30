%% Are theta and OB ocillations coupled?
%  Only look
%% Comodulation in three states : REM, SWS, Locomotion
clear all

SaveFolderName='/media/DataMOBsRAID/ProjectEmbReact/Figures/Nov2016/CouplageRythmes/Habituation/GammaTriggered/';
Files=PathForExperimentsEmbReact('Habituation');
Struc={'HPC','OB','PFCx'};
% Params low
paramsL.Fs=1250;
paramsL.trialave=0;
paramsL.err=[1 0.0500];
paramsL.pad=2;
paramsL.fpass=[0 20];
movingwinL=[3 0.2];
paramsL.tapers=[3 5];
% Params high
paramsH.Fs=1250;
params.trialave=0;
paramsH.err=[1 0.0500];
paramsH.pad=2;
paramsH.fpass=[20 250];
paramsH.tapers=[2 3];
movingwinH=[0.1 0.005];
% Parameters for triggered specrto
binsize=20; nbins=50;
bandThet=[7 11];
bandLow=[2 4];
bandMid=[12 15];
for pp=7:length(Files.path)
    for c=1
        try
            cd(Files.path{pp}{c})
            clear FilLFPL Hi Lo EpHi Sp Phase y
            
            load('ChannelsToAnalyse/Bulb_deep.mat')
            chB=channel;
            load(['LFPData/LFP',num2str(chB),'.mat']);
            [y, ARmodel] = WhitenSignal(Data(LFP),[],1,[],2);
            LFPAll.OB=tsd(Range(LFP),y);
            [Sp.OB,tspL,fspL]=mtspecgramc(y,movingwinL,paramsL);
            [SpH.OB,tspH,fspH]=mtspecgramc(y,movingwinH,paramsH);
            Hi=mean(Sp.OB(:,find(fspL<bandThet(1),1,'last'):find(fspL<bandThet(2),1,'last'))');
            Mid=mean(Sp.OB(:,find(fspL<bandMid(1),1,'last'):find(fspL<bandMid(2),1,'last'))');
            Lo=mean(Sp.OB(:,find(fspL<bandLow(1),1,'last'):find(fspL<bandLow(2),1,'last'))');
            EpHi=thresholdIntervals(tsd(tspL*1e4,Hi'-Lo'),0);
            EpHi=mergeCloseIntervals(EpHi,3*1e4);
            FilLFP.OB=FilterLFP(tsd(Range(LFP),y),bandThet,1024);
            Hil=hilbert(Data(Restrict(FilLFP.OB,EpHi)));
            Phase.OB=angle(Hil)*180/pi+180;
            snip=ceil(rand(1)*length(Phase.OB));
            Phase.OBR=[Phase.OB(snip:end);Phase.OB(1:snip-1)];
            DatLFP=Data(FilLFP.OB);
            FilLFPR.OB=tsd(Range(FilLFP.OB),[DatLFP(snip:end);DatLFP(1:snip-1)]);
            
            clear y LFP
            try
                load('ChannelsToAnalyse/dHPC_deep.mat')
                chH=channel;
            catch
                
                load('ChannelsToAnalyse/dHPC_rip.mat')
                chH=channel;
            end
            load(['LFPData/LFP',num2str(chH),'.mat']);
            [y, ARmodel] = WhitenSignal(Data(LFP),[],1,[],2);
            [Sp.HPC,tspL,fspL]=mtspecgramc(y,movingwinL,paramsL);
            [SpH.HPC,tspH,fspH]=mtspecgramc(y,movingwinH,paramsH);
            LFPAll.HPC=tsd(Range(LFP),y);
            FilLFP.HPC=FilterLFP(tsd(Range(LFP),y),bandThet,1024);
            Hil=hilbert(Data(Restrict(FilLFP.HPC,EpHi)));
            Phase.HPC=angle(Hil)*180/pi+180;
            snip=ceil(rand(1)*length(Phase.HPC));
            Phase.HPCR=[Phase.HPC(snip:end);Phase.HPC(1:snip-1)];
            DatLFP=Data(FilLFP.HPC);
            FilLFPR.HPC=tsd(Range(FilLFP.HPC),[DatLFP(snip:end);DatLFP(1:snip-1)]);
            
            clear y LFP
            load('ChannelsToAnalyse/PFCx_deep.mat')
            chP=channel;
            load(['LFPData/LFP',num2str(chP),'.mat']);
            [y, ARmodel] = WhitenSignal(Data(LFP),[],1,[],2);
            [Sp.PFCx,tspL,fspL]=mtspecgramc(y,movingwinL,paramsL);
            [SpH.PFCx,tspH,fspH]=mtspecgramc(y,movingwinH,paramsH);
            LFPAll.PFCx=tsd(Range(LFP),y);
            FilLFP.PFCx=FilterLFP(tsd(Range(LFP),y),bandThet,1024);
            Hil=hilbert(Data(Restrict(FilLFP.PFCx,EpHi)));
            Phase.PFCx=angle(Hil)*180/pi+180;
            snip=ceil(rand(1)*length(Phase.PFCx));
            Phase.PFCxR=[Phase.PFCx(snip:end);Phase.PFCx(1:snip-1)];
            DatLFP=Data(FilLFP.PFCx);
            FilLFPR.PFCx=tsd(Range(FilLFP.PFCx),[DatLFP(snip:end);DatLFP(1:snip-1)]);
            
            %             % RealData
            %             for ss=1:3
            %                 for sss=1:3
            %                     if not(ss==sss)
            %                         [temp,xx,yy]=hist2(eval(['Phase.',Struc{ss}]),eval(['Phase.',Struc{sss}]),100,100);
            %                         temp=temp./sum(sum(temp));
            %                         eval(['nn.',Struc{ss},'n',Struc{sss},'=temp'])
            %                     end
            %                 end
            %             end
            %
            %             fig=figure;
            %             for ss=1:3
            %                 for sss=1:3
            %                     if not(ss==sss)
            %                         subplot(3,3,(ss-1)*3+sss)
            %                          imagesc(xx,yy,log(eval(['nn.',Struc{ss},'n',Struc{sss}]))), caxis([-13.5 -7]),axis xy
            %                          xlabel(Struc{ss}),ylabel(Struc{sss})
            %                     else
            %                         subplot(3,3,(ss-1)*3+sss)
            %                         imagesc(tspL,fspL,log(eval(['Sp.',Struc{ss}]))'), axis xy, hold on,
            %                         line([Start(EpHi,'s') Stop(EpHi,'s')]',ones(2,length(Start(EpHi)))*15,'color','k')
            %                         Sptsd=tsd(tspL*1e4,(eval(['Sp.',Struc{ss}])));
            %                         meansp=nanmean(Data(Restrict(Sptsd,EpHi)));
            %                         meansp=meansp/(max(meansp)-min(meansp));
            %                         plot(meansp*300,fspL)
            %                         title(Struc{ss})
            %                     end
            %                 end
            %             end
            %
            %             saveas(fig,[SaveFolderName,'ThetaBandCouplingM',num2str(Files.ExpeInfo{pp}.nmouse),'.png']);
            %             saveas(fig,[SaveFolderName,'ThetaBandCouplingM',num2str(Files.ExpeInfo{pp}.nmouse),'.fig']);
            %             close all
            %
            %             clear nn
            %             % random data
            %             for ss=1:3
            %                 for sss=1:3
            %                     if not(ss==sss)
            %                         [temp,xx,yy]=hist2(eval(['Phase.',Struc{ss},'R']),eval(['Phase.',Struc{sss},'R']),100,100);
            %                         temp=temp./sum(sum(temp));
            %                         eval(['nn.',Struc{ss},'n',Struc{sss},'=temp'])
            %                     end
            %                 end
            %             end
            %
            %             fig=figure;
            %             for ss=1:3
            %                 for sss=1:3
            %                     if not(ss==sss)
            %                         subplot(3,3,(ss-1)*3+sss)
            %                         imagesc(xx,yy,log(eval(['nn.',Struc{ss},'n',Struc{sss}]))), , caxis([-13.5 -7]),axis xy
            %                         xlabel(Struc{ss}),ylabel(Struc{sss})
            %                     else
            %                         subplot(3,3,(ss-1)*3+sss)
            %                         imagesc(tspL,fspL,log(eval(['Sp.',Struc{ss}]))'), axis xy, hold on
            %                         line([Start(EpHi,'s') Stop(EpHi,'s')]',ones(2,length(Start(EpHi)))*15,'color','k')
            %                         Sptsd=tsd(tspL*1e4,(eval(['Sp.',Struc{ss}])));
            %                         meansp=nanmean(Data(Restrict(Sptsd,EpHi)));
            %                         meansp=meansp/(max(meansp)-min(meansp));
            %                         plot(meansp*300,fspL)
            %                         title(Struc{ss})
            %                     end
            %                 end
            %             end
            %
            %             saveas(fig,[SaveFolderName,'ThetaBandCouplingRandM',num2str(Files.ExpeInfo{pp}.nmouse),'.png']);
            %             saveas(fig,[SaveFolderName,'ThetaBandCouplingRandM',num2str(Files.ExpeInfo{pp}.nmouse),'.fig']);
            %             close all
            
            % Trigger gamma on trough of slow oscillation
            for ss=1:3
                GammaMod.Output{ss}=GetPeakAndTroughFreqBand(eval(['FilLFP.',Struc{ss}]),bandThet);
                [GammaMod.Shape{ss},GammaMod.T{ss}]=PlotRipRaw(eval(['LFPAll.',Struc{ss}]),GammaMod.Output{ss}/1e4,500,0,0);
                for sss=1:3
                    SptsdHigh=tsd(tspH*1e4,eval(['SpH.',Struc{sss}]));
                    [GammaMod.Result{ss,sss},~,GammaMod.time{ss,sss}]=AverageSpectrogram(SptsdHigh,fspH,ts(GammaMod.Output{ss}),binsize,nbins,0,0,0);
                end
            end
            
            fig=figure;
            for ss=1:3
                for sss=1:3
                    subplot(3,3,(ss-1)*3+sss)
                    imagesc(GammaMod.time{ss,sss}/1000,fspH,(GammaMod.Result{ss,sss}')'), axis xy, hold on
                    line([0 0],ylim,'color','w')
                    Normalizer=(max(GammaMod.Shape{ss}(:,2))-min(GammaMod.Shape{ss}(:,2)));
                    plot(GammaMod.Shape{ss}(:,1),40*GammaMod.Shape{ss}(:,2)/Normalizer+150,'w')
                    title(['Sl:',Struc{ss},'  Fst:',Struc{sss}])
                                        Clim{ss,sss}=clim;
                end
            end
            saveas(fig,[SaveFolderName,'ThetaBandCouplingWiGammaM',num2str(Files.ExpeInfo{pp}.nmouse),'.png']);
            saveas(fig,[SaveFolderName,'ThetaBandCouplingWiGammaM',num2str(Files.ExpeInfo{pp}.nmouse),'.fig']);
            close all
            
            % Trigger gamma on trough of slow oscillation - random
            for ss=1:3
                GammaModR.Output{ss}=GetPeakAndTroughFreqBand(eval(['FilLFPR.',Struc{ss}]),bandThet);
                [GammaModR.Shape{ss},GammaModR.T{ss}]=PlotRipRaw(eval(['LFPAll.',Struc{ss}]),GammaModR.Output{ss}(1:min([1000,length(GammaModR.Output{ss})]))/1e4,500,0,0);
                for sss=1:3
                    SptsdHigh=tsd(tspH*1e4,eval(['SpH.',Struc{sss}]));
                    [GammaModR.Result{ss,sss},~,GammaModR.time{ss,sss}]=AverageSpectrogram(SptsdHigh,fspH,ts(GammaModR.Output{ss}),binsize,nbins,0,0,0);
                end
            end
            
            fig=figure;
            for ss=1:3
                for sss=1:3
                    subplot(3,3,(ss-1)*3+sss)
                    imagesc(GammaModR.time{ss,sss}/1000,fspH,(GammaModR.Result{ss,sss}')'), axis xy, hold on
                    line([0 0],ylim,'color','w')
                    Normalizer=(max(GammaModR.Shape{ss}(:,2))-min(GammaModR.Shape{ss}(:,2)));
                    plot(GammaModR.Shape{ss}(:,1),40*GammaModR.Shape{ss}(:,2)/Normalizer+150,'w')
                    title(['Sl:',Struc{ss},'  Fst:',Struc{sss}])
                                        clim(Clim{ss,sss})
                end
            end
            saveas(fig,[SaveFolderName,'ThetaBandCouplingWiGammaRandM',num2str(Files.ExpeInfo{pp}.nmouse),'.png']);
            saveas(fig,[SaveFolderName,'ThetaBandCouplingWiGammaRandM',num2str(Files.ExpeInfo{pp}.nmouse),'.fig']);
            close all
            
            % Trigger gamma on trough of slow oscillation
            
            fig=figure;
            for ss=1:3
                for sss=1:3
                    subplot(3,3,(ss-1)*3+sss)
                    a=(GammaMod.Result{ss,sss}');
                    b=(GammaMod.Result{ss,sss}');
                    for t=1:size(a,1)
                        a(t,:)=a(t,:)./mean(b);
                    end
                    imagesc(GammaMod.time{ss,sss}/1000,fspH,a'), axis xy, hold on
                    line([0 0],ylim,'color','w')
                    Normalizer=(max(GammaMod.Shape{ss}(:,2))-min(GammaMod.Shape{ss}(:,2)));
                    plot(GammaMod.Shape{ss}(:,1),40*GammaMod.Shape{ss}(:,2)/Normalizer+150,'w')
                    title(['Sl:',Struc{ss},'  Fst:',Struc{sss}])
                    Clim{ss,sss}=clim;
                end
            end
            saveas(fig,[SaveFolderName,'ThetaBandCouplingWiGammaNormM',num2str(Files.ExpeInfo{pp}.nmouse),'.png']);
            saveas(fig,[SaveFolderName,'ThetaBandCouplingWiGammaNormM',num2str(Files.ExpeInfo{pp}.nmouse),'.fig']);
            close all
            
            % Trigger gamma on trough of slow oscillation - random

            fig=figure;
            for ss=1:3
                for sss=1:3
                    subplot(3,3,(ss-1)*3+sss)
                    a=(GammaModR.Result{ss,sss}');
                    b=(GammaModR.Result{ss,sss}');
                    for t=1:size(a,1)
                        a(t,:)=a(t,:)./mean(b);
                    end
                    
                    imagesc(GammaModR.time{ss,sss}/1000,fspH,a'), axis xy, hold on
                    line([0 0],ylim,'color','w')
                    Normalizer=(max(GammaModR.Shape{ss}(:,2))-min(GammaModR.Shape{ss}(:,2)));
                    plot(GammaModR.Shape{ss}(:,1),40*GammaModR.Shape{ss}(:,2)/Normalizer+150,'w')
                    title(['Sl:',Struc{ss},'  Fst:',Struc{sss}])
                    clim(Clim{ss,sss})
                end
            end
            saveas(fig,[SaveFolderName,'ThetaBandCouplingWiGammaRandNormM',num2str(Files.ExpeInfo{pp}.nmouse),'.png']);
            saveas(fig,[SaveFolderName,'ThetaBandCouplingWiGammaRandNormM',num2str(Files.ExpeInfo{pp}.nmouse),'.fig']);
            close all
            
            save('GammaModualtion.mat','GammaMod','fspH','GammaModR')
        end
    end
end