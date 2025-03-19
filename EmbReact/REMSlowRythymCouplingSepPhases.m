%% Are theta and OB ocillations coupled?
%% Is gamma modulated by the trough/peak?
%% Comodulation in three states : REM
clear all

SaveFolderNameG='/media/DataMOBsRAIDN/ProjectEmbReact/Figures/Nov2016/CouplageRythmes/REM/GammaTriggered/';
SaveFolderNameS='/media/DataMOBsRAIDN/ProjectEmbReact/Figures/Nov2016/CouplageRythmes/REM/PhaseCouplingSlow/';
SaveFolderNameSp='/media/DataMOBsRAIDN/ProjectEmbReact/Figures/Nov2016/CouplageRythmes/REM/AvSpec/';
Files=PathForExperimentsDeltaSleep2016('Basal');
Struc={'HPC','OB','PFCx'};
% Params low
[paramsL,movingwinL]=SpectrumParametersML('low',0);
% Params high
paramsH.Fs=1250;
paramsH.trialave=0;
paramsH.err=[1 0.0500];
paramsH.pad=2;
paramsH.fpass=[30 250];
paramsH.tapers=[2 3];
movingwinH=[0.1 0.013];
% Parameters for triggered specrto
binsize=20; nbins=50;
bandThet=[6 10];
bandLow=[2 4];
bandMid=[5 6];
bandVhi=[10 12];
% Data Combinations
Sbl=[2,3,4,6,7,8];
SblSp=[1,5,9];
keepGoodLow=3;
keepNoLow=1;
Combi={{'Thet.HPC','Thet.PFCx'},{'Thet.HPC','Thet.PFCx'},{'Low.OB','Thet.HPC'},{'Low.OB','Thet.PFCx'},{'Low.PFCx','Thet.HPC'},{'Low.PFCx','Low.OB'}};
warning off
for pp=18:length(Files.path)
    pp
    try
        cd(Files.path{pp})
        clear FilLFPL Hi Lo EpHi SpL SpH Phase y REMEpoch FilLFP FilLFPR
        try
            load('ChannelsToAnalyse/dHPC_deep.mat')
            Channel.HPC=channel;
        catch
            
            load('ChannelsToAnalyse/dHPC_rip.mat')
            Channel.HPC=channel;
        end
        
        load('ChannelsToAnalyse/Bulb_deep.mat')
        Channel.OB=channel;
        load('ChannelsToAnalyse/PFCx_deep.mat')
        Channel.PFCx=channel;
        
        for ss=1:length(Struc)
            load(['LFPData/LFP',num2str(eval(['Channel.',Struc{ss}])),'.mat']);
            eval(['LFPAll.',Struc{ss},'=LFP;'])
        end
        load('StateEpochSB.mat','REMEpoch','SWSEpoch')
        
        
        for ss=1:length(Struc)
            ss
            try
                load(['WhitenedHighSpectra/',Struc{ss},'_H_Spectrum.mat'])
                tspH=Spectro{2}; temp=Spectro{1};fspH=Spectro{3};
                eval(['SpH.',Struc{ss},'.tsd=tsd(tspH*1e4,temp);'])
                eval(['SpH.',Struc{ss},'.freq=fspH;'])
            catch
                disp('calculating high spec')
                load(['LFPData/LFP',num2str(eval(['Channel.',Struc{ss}])),'.mat']);
                [y, ARmodel] = WhitenSignal(Data(LFP),[],1,[],2);
                [temp,tspH,fspH]=mtspecgramc(y,movingwinH,paramsH);
                eval(['SpH.',Struc{ss},'.tsd=tsd(tspH*1e4,temp);'])
                eval(['SpH.',Struc{ss},'.freq=fspH;'])
                mkdir('WhitenedHighSpectra')
                Spectro{1}=temp; Spectro{2}=tspH; Spectro{3}=fspH; channel=eval(['Channel.',Struc{ss}]);
                save(['WhitenedHighSpectra/',Struc{ss},'_H_Spectrum.mat'],'Spectro','channel','-v7.3')
                clear Spectro channel
            end
        end
        
        try, load(['SpectrumDataL/Spectrum',num2str(Channel.OB),'.mat'])
            SpL.OB.tsd=tsd(t*1e4,Sp);
            SpL.OB.freq=f;
        catch
            try
                load('B_Low_Spectrum.mat')
            catch
                disp('calculating OB spectrum')
                LowSpectrumSB([cd,filesep],Channel.OB,'B',0)
                load('B_Low_Spectrum.mat')
            end
            SpL.OB.tsd=tsd(Spectro{2}*1e4,Spectro{1});
            SpL.OB.freq=Spectro{3};
        end
        
        try,
            load(['SpectrumDataL/Spectrum',num2str(Channel.HPC),'.mat'])
            SpL.HPC.tsd=tsd(t*1e4,Sp);
            SpL.HPC.freq=f;
        catch
            try
                load('H_Low_Spectrum.mat')
            catch
                disp('calculating HPC spectrum')
                LowSpectrumSB([cd,filesep],Channel.HPC,'H',0)
                load('H_Low_Spectrum.mat')
            end
            SpL.HPC.tsd=tsd(Spectro{2}*1e4,Spectro{1});
            SpL.HPC.freq=Spectro{3};
        end
        
        try,
            load(['SpectrumDataL/Spectrum',num2str(Channel.PFCx),'.mat'])
            SpL.PFCx.tsd=tsd(t*1e4,Sp);
            SpL.PFCx.freq=f;
        catch
            try
                load('PFCx_Low_Spectrum.mat')
            catch
                disp('calculating PFCx spectrum')
                LowSpectrumSB([cd,filesep],Channel.PFCx,'PFCx',0)
                load('.mat')
            end
            SpL.PFCx.tsd=tsd(Spectro{2}*1e4,Spectro{1});
            SpL.PFCx.freq=Spectro{3};
        end
        
        [Epoch,val,val2]=FindSlowOscBulb(Data(SpL.OB.tsd),Range(SpL.OB.tsd,'s'),SpL.OB.freq,REMEpoch,1,[15 20]);
        
        EpLow=Epoch{keepGoodLow};
        EpNoLow=REMEpoch-Epoch{keepNoLow};
        EpToUse={EpNoLow,EpLow,EpLow,EpLow,EpLow,EpLow};
        
        
        fig=figure;
        for ss=1:length(Struc)
            subplot(2,3,ss)
            plot(eval(['SpL.',Struc{ss},'.freq']),mean(Data(Restrict(eval(['SpL.',Struc{ss},'.tsd']),EpLow)))), hold on
            plot(eval(['SpL.',Struc{ss},'.freq']),mean(Data(Restrict(eval(['SpL.',Struc{ss},'.tsd']),EpNoLow))))
            xlim([0 20])
            title(Struc{ss})
            subplot(2,3,ss+3)
            plot(SpH.OB.freq,mean(Data(Restrict(eval(['SpH.',Struc{ss},'.tsd']),EpLow)))), hold on
            plot(SpH.OB.freq,mean(Data(Restrict(eval(['SpH.',Struc{ss},'.tsd']),EpNoLow))))
            xlim([30 250])
        end
        saveas(fig,[SaveFolderNameSp,'MeanSpec',num2str(pp),'.png']);
        saveas(fig,[SaveFolderNameSp,'MeanSpec',num2str(pp),'.fig']);
        close all
        
        % Filter in the correct frequenciescd
        % OB and PFC in theta and slow,HPC in theta
        for ss=1:3
            % Theta
            eval(['ToFilt=LFPAll.',Struc{ss},';'])
            temp=FilterLFP(Restrict(ToFilt,REMEpoch),bandThet,1024);
            eval(['FilLFP.Thet.',Struc{ss},'=temp;']);
            Hil=hilbert(Data(temp));
            eval(['Phase.Thet.',Struc{ss},'=angle(Hil)*180/pi+180;']);
            eval(['snip=ceil(rand(1)*length(Phase.Thet.',Struc{ss},'));']);
            eval(['Phase.Thet.',Struc{ss},'R=[Phase.Thet.',Struc{ss},'(snip:end);Phase.Thet.',Struc{ss},'(1:snip-1)];'])
            eval(['DatLFP=Data(FilLFP.Thet.',Struc{ss},');'])
            eval(['FilLFPR.Thet.',Struc{ss},'=tsd(Range(FilLFP.Thet.',Struc{ss},'),[DatLFP(snip:end);DatLFP(1:snip-1)]);'])
            
            if ss>1
                % Low
                eval(['ToFilt=LFPAll.',Struc{ss},';'])
                temp=FilterLFP(Restrict(ToFilt,REMEpoch),bandLow,1024);
                eval(['FilLFP.Low.',Struc{ss},'=temp;']);
                Hil=hilbert(Data(temp));
                eval(['Phase.Low.',Struc{ss},'=angle(Hil)*180/pi+180;']);
                eval(['snip=ceil(rand(1)*length(Phase.Low.',Struc{ss},'));']);
                eval(['Phase.Low.',Struc{ss},'R=[Phase.Low.',Struc{ss},'(snip:end);Phase.Low.',Struc{ss},'(1:snip-1)];'])
                eval(['DatLFP=Data(FilLFP.Low.',Struc{ss},');'])
                eval(['FilLFPR.Low.',Struc{ss},'=tsd(Range(FilLFP.Low.',Struc{ss},'),[DatLFP(snip:end);DatLFP(1:snip-1)]);'])
            end
            
        end
        
        
        % RealData
        for ss=1:6
            temp1=eval(['Phase.',Combi{ss}{1}]);
            Phasetsd1=tsd(Range(Restrict(LFPAll.OB,REMEpoch)),temp1);
            temp1=Data(Restrict(Phasetsd1,EpToUse{ss}));
            temp2=eval(['Phase.',Combi{ss}{2}]);
            Phasetsd2=tsd(Range(Restrict(LFPAll.OB,REMEpoch)),temp2);
            temp2=Data(Restrict(Phasetsd2,EpToUse{ss}));
            [temp,xx,yy]=hist2(temp1,temp2,100,100);
            temp=temp./sum(sum(temp));
            eval(['nn.',Combi{ss}{1},'n',Combi{ss}{2},'=temp;'])
        end
        
        
        
        fig=figure('Position',[100,100,1000,1000]);;
        for ss=1:6
            eval(['temp=nn.',Combi{ss}{1},'n',Combi{ss}{2},';'])
            subplot(3,3,Sbl(ss))
            imagesc(xx,yy,log(temp)), caxis([-13.5 -7]),axis xy
            xlabel(Combi{ss}{1}),ylabel(Combi{ss}{2})
            CaxRem{ss}=clim;
            
        end
        
        
        for ss=1:3
            subplot(3,3,SblSp(ss))
            Sptsdtemp=eval(['SpL.',Struc{ss},'.tsd']);
            imagesc(Range(Restrict(Sptsdtemp,REMEpoch)),SpL.HPC.freq,log(Data(Restrict(Sptsdtemp,REMEpoch)))'), axis xy, hold on,
            meansp=nanmean(Data(Restrict(Sptsdtemp,EpNoLow)));
            meansp=meansp/(max(meansp)-min(meansp));
            plot(meansp*max(xlim)/2,eval(['SpL.',Struc{ss},'.freq']),'w','linewidth',2)
            meansp=nanmean(Data(Restrict(Sptsdtemp,EpLow)));
            meansp=meansp/(max(meansp)-min(meansp));
            plot(meansp*max(xlim)/2,eval(['SpL.',Struc{ss},'.freq']),'k','linewidth',2)
            title(Struc{ss})
        end
        
        saveas(fig,[SaveFolderNameS,'ThetaLowBandCouplingREMM',num2str(pp),'.png']);
        saveas(fig,[SaveFolderNameS,'ThetaLowBandCouplingREMM',num2str(pp),'.fig']);
        close all
        
        % Random phases
        for ss=1:6
            temp1=eval(['Phase.',Combi{ss}{1},'R;']);
            Phasetsd1=tsd(Range(Restrict(LFPAll.OB,REMEpoch)),temp1);
            temp1=Data(Restrict(Phasetsd1,EpToUse{ss}));
            temp2=eval(['Phase.',Combi{ss}{2},'R;']);
            Phasetsd2=tsd(Range(Restrict(LFPAll.OB,REMEpoch)),temp2);
            temp2=Data(Restrict(Phasetsd2,EpToUse{ss}));
            [temp,xx,yy]=hist2(temp1,temp2,100,100);
            temp=temp./sum(sum(temp));
            eval(['nn.',Combi{ss}{1},'n',Combi{ss}{2},'=temp;'])
        end
        
        fig=figure('Position',[100,100,1000,1000]);;
        for ss=1:6
            eval(['temp=nn.',Combi{ss}{1},'n',Combi{ss}{2},';'])
            subplot(3,3,Sbl(ss))
            imagesc(xx,yy,log(temp)), caxis([-13.5 -7]),axis xy
            xlabel(Combi{ss}{1}),ylabel(Combi{ss}{2})
            clim(CaxRem{ss});
            
        end
        
        
        for ss=1:3
            subplot(3,3,SblSp(ss))
            Sptsdtemp=eval(['SpL.',Struc{ss},'.tsd']);
            imagesc(Range(Restrict(Sptsdtemp,REMEpoch)),SpL.HPC.freq,log(Data(Restrict(Sptsdtemp,REMEpoch)))'), axis xy, hold on,
            meansp=nanmean(Data(Restrict(Sptsdtemp,EpNoLow)));
            meansp=meansp/(max(meansp)-min(meansp));
            plot(meansp*max(xlim)/2,eval(['SpL.',Struc{ss},'.freq']),'w','linewidth',2)
            meansp=nanmean(Data(Restrict(Sptsdtemp,EpLow)));
            meansp=meansp/(max(meansp)-min(meansp));
            plot(meansp*max(xlim)/2,eval(['SpL.',Struc{ss},'.freq']),'k','linewidth',2)
            title(Struc{ss})
        end
        
        saveas(fig,[SaveFolderNameS,'ThetaLowBandCouplingREMRandM',num2str(pp),'.png']);
        saveas(fig,[SaveFolderNameS,'ThetaLowBandCouplingREMRandM',num2str(pp),'.fig']);
        close all
        
        % Trigger gamma on trough of slow oscillation in OB
        GammaMod.Output.OBLOW=GetPeakAndTroughFreqBand(eval(['Restrict(LFPAll.',Struc{2},',EpLow)']),bandLow);
        [GammaMod.Shape.OBLOW,GammaMod.T.OBLOW]=PlotRipRaw(eval(['LFPAll.',Struc{2}]),GammaMod.Output.OBLOW(1:min(1000,length(GammaMod.Output.OBLOW)))/1e4,500,0,0);
        for sss=1:3
            SptsdHigh=eval(['SpH.',Struc{sss},'.tsd']);
            [GammaMod.Result.OBLOW{sss},~,GammaMod.time.OBLOW{sss}]=AverageSpectrogram(SptsdHigh,fspH,ts(GammaMod.Output.OBLOW),binsize,nbins,0,0,0);
        end
        
        fig=figure('Position',[100,100,1000,1000]);;
        for sss=1:3
            subplot(3,3,sss)
            imagesc(GammaMod.time.OBLOW{sss}/1000,fspH,log(GammaMod.Result.OBLOW{sss})), axis xy, hold on
            line([0 0],ylim,'color','w')
            Normalizer=(max(GammaMod.Shape.OBLOW(:,2))-min(GammaMod.Shape.OBLOW(:,2)));
            plot(GammaMod.Shape.OBLOW(:,1),40*GammaMod.Shape.OBLOW(:,2)/Normalizer+150,'w')
            title(['Sl:',Struc{2},'  Fst:',Struc{sss},'LowPer'])
        end
        
        fig2=figure('Position',[100,100,1000,1000]);;
        for sss=1:3
            subplot(3,3,sss)
            a=(GammaMod.Result.OBLOW{sss}');
            b=(GammaMod.Result.OBLOW{sss}');
            for t=1:size(a,1)
                a(t,:)=a(t,:)./mean(b);
            end
            imagesc(GammaMod.time.OBLOW{sss}/1000,fspH,a'), axis xy, hold on
            line([0 0],ylim,'color','w')
            Normalizer=(max(GammaMod.Shape.OBLOW(:,2))-min(GammaMod.Shape.OBLOW(:,2)));
            plot(GammaMod.Shape.OBLOW(:,1),40*GammaMod.Shape.OBLOW(:,2)/Normalizer+150,'w')
            title(['Sl:',Struc{2},'  Fst:',Struc{sss},'LowPer'])
        end
        
        % Trigger gamma on trough of theta oscillation in HPC - during
        % Low Periods
        GammaMod.Output.HPCThetLow=GetPeakAndTroughFreqBand(eval(['Restrict(LFPAll.',Struc{1},',EpLow)']),bandThet);
        [GammaMod.Shape.HPCThetLow,GammaMod.T.HPCThetLow]=PlotRipRaw(eval(['LFPAll.',Struc{1}]),GammaMod.Output.HPCThetLow(1:min(1000,length(GammaMod.Output.HPCThetLow)))/1e4,500,0,0);
        for sss=1:3
            SptsdHigh=eval(['SpH.',Struc{sss},'.tsd']);
            [GammaMod.Result.HPCThetLow{sss},~,GammaMod.time.HPCThetLow{sss}]=AverageSpectrogram(SptsdHigh,fspH,ts(GammaMod.Output.HPCThetLow),binsize,nbins,0,0,0);
        end
        
        figure(fig);
        for sss=1:3
            subplot(3,3,sss+3)
            imagesc(GammaMod.time.HPCThetLow{sss}/1000,fspH,log(GammaMod.Result.HPCThetLow{sss})), axis xy, hold on
            line([0 0],ylim,'color','w')
            Normalizer=(max(GammaMod.Shape.HPCThetLow(:,2))-min(GammaMod.Shape.HPCThetLow(:,2)));
            plot(GammaMod.Shape.HPCThetLow(:,1),40*GammaMod.Shape.HPCThetLow(:,2)/Normalizer+150,'w')
            title(['Sl:',Struc{1},'  Fst:',Struc{sss}, 'LowPer'])
        end
        
        figure(fig2);
        for sss=1:3
            subplot(3,3,sss+3)
            a=(GammaMod.Result.HPCThetLow{sss}');
            b=(GammaMod.Result.HPCThetLow{sss}');
            for t=1:size(a,1)
                a(t,:)=a(t,:)./mean(b);
            end
            imagesc(GammaMod.time.HPCThetLow{sss}/1000,fspH,a'), axis xy, hold on
            line([0 0],ylim,'color','w')
            Normalizer=(max(GammaMod.Shape.HPCThetLow(:,2))-min(GammaMod.Shape.HPCThetLow(:,2)));
            plot(GammaMod.Shape.HPCThetLow(:,1),40*GammaMod.Shape.HPCThetLow(:,2)/Normalizer+150,'w')
            title(['Thet:',Struc{1},'  Fst:',Struc{sss}, 'LowPer'])
        end
        
        % Trigger gamma on trough of theta oscillation in HPC - during
        % No Low Periods
        GammaMod.Output.HPCThetNoLow=GetPeakAndTroughFreqBand(eval(['Restrict(LFPAll.',Struc{1},',EpNoLow)']),bandThet);
        [GammaMod.Shape.HPCThetNoLow,GammaMod.T.HPCThetNoLow]=PlotRipRaw(eval(['LFPAll.',Struc{1}]),GammaMod.Output.HPCThetNoLow(1:min(1000,length(GammaMod.Output.HPCThetNoLow)))/1e4,500,0,0);
        for sss=1:3
            SptsdHigh=eval(['SpH.',Struc{sss},'.tsd']);
            [GammaMod.Result.HPCThetNoLow{sss},~,GammaMod.time.HPCThetNoLow{sss}]=AverageSpectrogram(SptsdHigh,fspH,ts(GammaMod.Output.HPCThetNoLow),binsize,nbins,0,0,0);
        end
        
        figure(fig);
        for sss=1:3
            subplot(3,3,sss+6)
            imagesc(GammaMod.time.HPCThetNoLow{sss}/1000,fspH,log(GammaMod.Result.HPCThetNoLow{sss})), axis xy, hold on
            line([0 0],ylim,'color','w')
            Normalizer=(max(GammaMod.Shape.HPCThetNoLow(:,2))-min(GammaMod.Shape.HPCThetNoLow(:,2)));
            plot(GammaMod.Shape.HPCThetNoLow(:,1),40*GammaMod.Shape.HPCThetNoLow(:,2)/Normalizer+150,'w')
            title(['Sl:',Struc{1},'  Fst:',Struc{sss},'NoLowPer'])
        end
        
        figure(fig2);
        for sss=1:3
            subplot(3,3,sss+6)
            a=(GammaMod.Result.HPCThetNoLow{sss}');
            b=(GammaMod.Result.HPCThetNoLow{sss}');
            for t=1:size(a,1)
                a(t,:)=a(t,:)./mean(b);
            end
            imagesc(GammaMod.time.HPCThetNoLow{sss}/1000,fspH,a'), axis xy, hold on
            line([0 0],ylim,'color','w')
            Normalizer=(max(GammaMod.Shape.HPCThetNoLow(:,2))-min(GammaMod.Shape.HPCThetNoLow(:,2)));
            plot(GammaMod.Shape.HPCThetNoLow(:,1),40*GammaMod.Shape.HPCThetNoLow(:,2)/Normalizer+150,'w')
            title(['Thet:',Struc{1},'  Fst:',Struc{sss}, 'NoLowPer'])
        end
        
        saveas(fig,[SaveFolderNameG,'ThetaBandCouplingWiGammaREMM',num2str(pp),'.png']);
        saveas(fig,[SaveFolderNameG,'ThetaBandCouplingWiGammaREMM',num2str(pp),'.fig']);
        saveas(fig2,[SaveFolderNameG,'ThetaBandCouplingWiGammaREMMNorm',num2str(pp),'.png']);
        saveas(fig2,[SaveFolderNameG,'ThetaBandCouplingWiGammaREMMNorm',num2str(pp),'.fig']);
        save('REMGammaModulation.mat','GammaMod','Epoch')
        close all
        clear GammaMod
        
        %% Random Gamma coupling
        % Trigger gamma on trough of slow oscillation in OB
        GammaMod.Output.OBLOW=GetPeakAndTroughFreqBand(eval(['Restrict(FilLFPR.Low.',Struc{2},',EpLow)']),bandLow);
        [GammaMod.Shape.OBLOW,GammaMod.T.OBLOW]=PlotRipRaw(eval(['LFPAll.',Struc{2}]),GammaMod.Output.OBLOW(1:min(1000,length(GammaMod.Output.OBLOW)))/1e4,500,0,0);
        for sss=1:3
            SptsdHigh=eval(['SpH.',Struc{sss},'.tsd']);
            [GammaMod.Result.OBLOW{sss},~,GammaMod.time.OBLOW{sss}]=AverageSpectrogram(SptsdHigh,fspH,ts(GammaMod.Output.OBLOW),binsize,nbins,0,0,0);
        end
        
        fig=figure('Position',[100,100,1000,1000]);;
        for sss=1:3
            subplot(3,3,sss)
            imagesc(GammaMod.time.OBLOW{sss}/1000,fspH,log(GammaMod.Result.OBLOW{sss})), axis xy, hold on
            line([0 0],ylim,'color','w')
            Normalizer=(max(GammaMod.Shape.OBLOW(:,2))-min(GammaMod.Shape.OBLOW(:,2)));
            plot(GammaMod.Shape.OBLOW(:,1),40*GammaMod.Shape.OBLOW(:,2)/Normalizer+150,'w')
            title(['Sl:',Struc{2},'  Fst:',Struc{sss},'LowPer'])
        end
        
        fig2=figure('Position',[100,100,1000,1000]);;
        for sss=1:3
            subplot(3,3,sss)
            a=(GammaMod.Result.OBLOW{sss}');
            b=(GammaMod.Result.OBLOW{sss}');
            for t=1:size(a,1)
                a(t,:)=a(t,:)./mean(b);
            end
            imagesc(GammaMod.time.OBLOW{sss}/1000,fspH,a'), axis xy, hold on
            line([0 0],ylim,'color','w')
            Normalizer=(max(GammaMod.Shape.OBLOW(:,2))-min(GammaMod.Shape.OBLOW(:,2)));
            plot(GammaMod.Shape.OBLOW(:,1),40*GammaMod.Shape.OBLOW(:,2)/Normalizer+150,'w')
            title(['Sl:',Struc{2},'  Fst:',Struc{sss},'LowPer'])
        end
        
        % Trigger gamma on trough of theta oscillation in HPC - during
        % Low Periods
        GammaMod.Output.HPCThetLow=GetPeakAndTroughFreqBand(eval(['Restrict(FilLFPR.Thet.',Struc{1},',EpLow)']),bandThet);
        [GammaMod.Shape.HPCThetLow,GammaMod.T.HPCThetLow]=PlotRipRaw(eval(['LFPAll.',Struc{1}]),GammaMod.Output.HPCThetLow(1:min(1000,length(GammaMod.Output.HPCThetLow)))/1e4,500,0,0);
        for sss=1:3
            SptsdHigh=eval(['SpH.',Struc{sss},'.tsd']);
            [GammaMod.Result.HPCThetLow{sss},~,GammaMod.time.HPCThetLow{sss}]=AverageSpectrogram(SptsdHigh,fspH,ts(GammaMod.Output.HPCThetLow),binsize,nbins,0,0,0);
        end
        
        figure(fig);
        for sss=1:3
            subplot(3,3,sss+3)
            imagesc(GammaMod.time.HPCThetLow{sss}/1000,fspH,log(GammaMod.Result.HPCThetLow{sss})), axis xy, hold on
            line([0 0],ylim,'color','w')
            Normalizer=(max(GammaMod.Shape.HPCThetLow(:,2))-min(GammaMod.Shape.HPCThetLow(:,2)));
            plot(GammaMod.Shape.HPCThetLow(:,1),40*GammaMod.Shape.HPCThetLow(:,2)/Normalizer+150,'w')
            title(['Sl:',Struc{1},'  Fst:',Struc{sss}, 'LowPer'])
        end
        
        figure(fig2);
        for sss=1:3
            subplot(3,3,sss+3)
            a=(GammaMod.Result.HPCThetLow{sss}');
            b=(GammaMod.Result.HPCThetLow{sss}');
            for t=1:size(a,1)
                a(t,:)=a(t,:)./mean(b);
            end
            imagesc(GammaMod.time.HPCThetLow{sss}/1000,fspH,a'), axis xy, hold on
            line([0 0],ylim,'color','w')
            Normalizer=(max(GammaMod.Shape.HPCThetLow(:,2))-min(GammaMod.Shape.HPCThetLow(:,2)));
            plot(GammaMod.Shape.HPCThetLow(:,1),40*GammaMod.Shape.HPCThetLow(:,2)/Normalizer+150,'w')
            title(['Thet:',Struc{1},'  Fst:',Struc{sss}, 'LowPer'])
        end
        
        % Trigger gamma on trough of theta oscillation in HPC - during
        % No Low Periods
        GammaMod.Output.HPCThetNoLow=GetPeakAndTroughFreqBand(eval(['Restrict(FilLFPR.Thet.',Struc{1},',EpNoLow)']),bandThet);
        [GammaMod.Shape.HPCThetNoLow,GammaMod.T.HPCThetNoLow]=PlotRipRaw(eval(['LFPAll.',Struc{1}]),GammaMod.Output.HPCThetNoLow(1:min(1000,length(GammaMod.Output.HPCThetNoLow)))/1e4,500,0,0);
        for sss=1:3
            SptsdHigh=eval(['SpH.',Struc{sss},'.tsd']);
            [GammaMod.Result.HPCThetNoLow{sss},~,GammaMod.time.HPCThetNoLow{sss}]=AverageSpectrogram(SptsdHigh,fspH,ts(GammaMod.Output.HPCThetNoLow),binsize,nbins,0,0,0);
        end
        
        figure(fig);
        for sss=1:3
            subplot(3,3,sss+6)
            imagesc(GammaMod.time.HPCThetNoLow{sss}/1000,fspH,log(GammaMod.Result.HPCThetNoLow{sss})), axis xy, hold on
            line([0 0],ylim,'color','w')
            Normalizer=(max(GammaMod.Shape.HPCThetNoLow(:,2))-min(GammaMod.Shape.HPCThetNoLow(:,2)));
            plot(GammaMod.Shape.HPCThetNoLow(:,1),40*GammaMod.Shape.HPCThetNoLow(:,2)/Normalizer+150,'w')
            title(['Sl:',Struc{1},'  Fst:',Struc{sss},'NoLowPer'])
        end
        
        figure(fig2);
        for sss=1:3
            subplot(3,3,sss+6)
            a=(GammaMod.Result.HPCThetNoLow{sss}');
            b=(GammaMod.Result.HPCThetNoLow{sss}');
            for t=1:size(a,1)
                a(t,:)=a(t,:)./mean(b);
            end
            imagesc(GammaMod.time.HPCThetNoLow{sss}/1000,fspH,a'), axis xy, hold on
            line([0 0],ylim,'color','w')
            Normalizer=(max(GammaMod.Shape.HPCThetNoLow(:,2))-min(GammaMod.Shape.HPCThetNoLow(:,2)));
            plot(GammaMod.Shape.HPCThetNoLow(:,1),40*GammaMod.Shape.HPCThetNoLow(:,2)/Normalizer+150,'w')
            title(['Thet:',Struc{1},'  Fst:',Struc{sss}, 'NoLowPer'])
        end
        
        saveas(fig,[SaveFolderNameG,'ThetaBandCouplingWiGammaREMMRand',num2str(pp),'.png']);
        saveas(fig,[SaveFolderNameG,'ThetaBandCouplingWiGammaREMMRand',num2str(pp),'.fig']);
        saveas(fig2,[SaveFolderNameG,'ThetaBandCouplingWiGammaREMMNormRand',num2str(pp),'.png']);
        saveas(fig2,[SaveFolderNameG,'ThetaBandCouplingWiGammaREMMNormRand',num2str(pp),'.fig']);
        save('REMGammaModulationRand.mat','GammaMod','Epoch')
        close all
        clear GammaMod
        
    catch
        keyboard
    end
    clear GammaMod  Phase SpL SpH
end
