%% Are theta and OB ocillations coupled?
%  Only look
%% Comodulation in three states : REM, SWS, Locomotion
clear all, close all

SaveFolderName='/media/DataMOBsRAID/ProjectEmbReact/Figures/Nov2016/CouplageRythmes/FreezingSounds/';
Dir=PathForExperimentFEAR('Fear-electrophy');
Dir=RestrictPathForExperiment(Dir,'Session','EXT-24h-envC');
Dir=RestrictPathForExperiment(Dir,'nMice',[ 244 241 248 253 254 258 259 299]);

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
bandLow=[3 6];
% Data Combinations
Combi={{'Thet.HPC','Thet.OB'},{'Thet.HPC','Thet.PFCx'},{'Low.OB','Thet.HPC'},{'Low.OB','Thet.PFCx'},{'Low.PFCx','Thet.HPC'},{'Low.PFCx','Low.OB'}};
Sbl=[2,3,4,6,7,8];
SblSp=[1,5,9];
for pp=1:length(Dir.path)
    pp
    try
        cd(Dir.path{pp})
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
        
        load('behavResources.mat')
        CSEpoch=intervalSet(CSPLUS*1e4,CSPLUS*1e4+30*1e4);
        FreezeEpoch=FreezeEpoch-CSEpoch;

        for ss=1:length(Struc)
            load(['LFPData/LFP',num2str(eval(['Channel.',Struc{ss}])),'.mat']);
            LFP=Restrict(LFP,FreezeEpoch);
            [y, ARmodel] = WhitenSignal(Data(LFP),[],1,[],2);
            [temp,tspL,fspL]=mtspecgramc(y,movingwinL,paramsL);
            eval(['SpL.',Struc{ss},'=temp;'])
            [temp,tspH,fspH]=mtspecgramc(y,movingwinH,paramsH);
            eval(['SpH.',Struc{ss},'=temp;'])
            eval(['LFPAll.',Struc{ss},'=tsd([1/1250:1/1250:length(y)/1250]*1e4,Data(LFP));'])
        end
        
        
        
        
        % Filter in the correct frequencies
        % OB and PFC in theta and slow,HPC in theta
        for ss=1:3
            % Theta
            eval(['ToFilt=LFPAll.',Struc{ss},';'])
            temp=FilterLFP(ToFilt,bandThet,1024);
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
                temp=FilterLFP(ToFilt,bandLow,1024);
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
            Phasetsd1=tsd([1/1250:1/1250:length(y)/1250]*1e4,temp1);
            temp1=Data(Phasetsd1);
            temp2=eval(['Phase.',Combi{ss}{2}]);
            Phasetsd2=tsd([1/1250:1/1250:length(y)/1250]*1e4,temp2);
            temp2=Data(Phasetsd2);
            [temp,xx,yy]=hist2(temp1,temp2,100,100);
            temp=temp./sum(sum(temp));
            eval(['nn.',Combi{ss}{1},'n',Combi{ss}{2},'=temp;'])
        end
        
        
        fig=figure;
        for ss=1:6
            eval(['temp=nn.',Combi{ss}{1},'n',Combi{ss}{2},';'])
            subplot(3,3,Sbl(ss))
            imagesc(xx,yy,log(temp)), %caxis([-13.5 -7]),
            axis xy
            xlabel(Combi{ss}{1}),ylabel(Combi{ss}{2})
            CaxRem{ss}=clim;
        end
        
        
        for ss=1:3
            subplot(3,3,SblSp(ss))
            imagesc(tspL,fspL,log(eval(['SpL.',Struc{ss}]))'), axis xy, hold on,
            Sptsd=tsd(tspL*1e4,(eval(['SpL.',Struc{ss}])));
            meansp=nanmean(Data((Sptsd)));
            meansp=meansp/(max(meansp)-min(meansp));
            plot(meansp*50,fspL,'w')
            title(Struc{ss})
        end
        
        saveas(fig,[SaveFolderName,'CrossFreqLow/FzCouplingNoSnd',num2str(Dir.name{pp}),'.png']);
        saveas(fig,[SaveFolderName,'CrossFreqLow/FzCouplingNoSnd',num2str(Dir.name{pp}),'.fig']);
        close all
        
        % Random phases
        for ss=1:6
            temp1=eval(['Phase.',Combi{ss}{1},'R;']);
            Phasetsd1=tsd([1/1250:1/1250:length(y)/1250]*1e4,temp1);
            temp1=Data(Phasetsd1);
            temp2=eval(['Phase.',Combi{ss}{2},'R;']);
            Phasetsd2=tsd([1/1250:1/1250:length(y)/1250]*1e4,temp2);
            temp2=Data(Phasetsd2);
            [temp,xx,yy]=hist2(temp1,temp2,100,100);
            temp=temp./sum(sum(temp));
            eval(['nn.',Combi{ss}{1},'n',Combi{ss}{2},'=temp;'])
        end
        
        fig=figure;
        for ss=1:6
            eval(['temp=nn.',Combi{ss}{1},'n',Combi{ss}{2},';'])
            subplot(3,3,Sbl(ss))
            imagesc(xx,yy,log(temp)), %caxis([-13.5 -7]),
            axis xy
            xlabel(Combi{ss}{1}),ylabel(Combi{ss}{2})
            clim(CaxRem{ss});
        end
        
        
        for ss=1:3
            subplot(3,3,SblSp(ss))
            imagesc(tspL,fspL,log(eval(['SpL.',Struc{ss}]))'), axis xy, hold on,
            Sptsd=tsd(tspL*1e4,(eval(['SpL.',Struc{ss}])));
            meansp=nanmean(Data((Sptsd)));
            meansp=meansp/(max(meansp)-min(meansp));
            plot(meansp*50,fspL,'w')
            title(Struc{ss})
        end
        
        saveas(fig,[SaveFolderName,'CrossFreqLow/FzCouplingRndNoSnd',num2str(Dir.name{pp}),'.png']);
        saveas(fig,[SaveFolderName,'CrossFreqLow/FzCouplingRndNoSnd',num2str(Dir.name{pp}),'.fig']);
        close all
        
        
        % Trigger gamma on trough of slow oscillation in OB
        GammaMod.Output.OBLOW=GetPeakAndTroughFreqBand(eval(['LFPAll.',Struc{2}]),bandLow);
        [GammaMod.Shape.OBLOW,GammaMod.T.OBLOW]=PlotRipRaw(eval(['LFPAll.',Struc{2}]),GammaMod.Output.OBLOW(1:min(1000,length(GammaMod.Output.OBLOW)))/1e4,500,0,0);
        for sss=1:3
            SptsdHigh=tsd(tspH*1e4,eval(['SpH.',Struc{sss}]));
            [GammaMod.Result.OBLOW{sss},~,GammaMod.time.OBLOW{sss}]=AverageSpectrogram(SptsdHigh,fspH,ts(GammaMod.Output.OBLOW),binsize,nbins,0,0,0);
        end
        
        fig=figure;
        for sss=1:3
            subplot(3,3,sss)
            imagesc(GammaMod.time.OBLOW{sss}/1000,fspH,log(GammaMod.Result.OBLOW{sss})), axis xy, hold on
            line([0 0],ylim,'color','w')
            Normalizer=(max(GammaMod.Shape.OBLOW(:,2))-min(GammaMod.Shape.OBLOW(:,2)));
            plot(GammaMod.Shape.OBLOW(:,1),40*GammaMod.Shape.OBLOW(:,2)/Normalizer+150,'w')
            title(['Sl:',Struc{2},'  Fst:',Struc{sss}])
        end
        
        % Trigger gamma on trough of theta oscillation in OB
        GammaMod.Output.OBThet=GetPeakAndTroughFreqBand(eval(['LFPAll.',Struc{2}]),bandThet);
        [GammaMod.Shape.OBThet,GammaMod.T.OBThet]=PlotRipRaw(eval(['LFPAll.',Struc{2}]),GammaMod.Output.OBThet(1:min(1000,length(GammaMod.Output.OBThet)))/1e4,500,0,0);
        for sss=1:3
            SptsdHigh=tsd(tspH*1e4,eval(['SpH.',Struc{sss}]));
            [GammaMod.Result.OBThet{sss},~,GammaMod.time.OBThet{sss}]=AverageSpectrogram(SptsdHigh,fspH,ts(GammaMod.Output.OBThet),binsize,nbins,0,0,0);
        end
        
        for sss=1:3
            subplot(3,3,sss+3)
            imagesc(GammaMod.time.OBLOW{sss}/1000,fspH,log(GammaMod.Result.OBThet{sss})), axis xy, hold on
            line([0 0],ylim,'color','w')
            Normalizer=(max(GammaMod.Shape.OBThet(:,2))-min(GammaMod.Shape.OBThet(:,2)));
            plot(GammaMod.Shape.OBLOW(:,1),40*GammaMod.Shape.OBThet(:,2)/Normalizer+150,'w')
            title(['Sl:',Struc{2},'  Fst:',Struc{sss}])
        end
        
        % Trigger gamma on trough of theta oscillation in HPC
        GammaMod.Output.HPCThet=GetPeakAndTroughFreqBand(eval(['LFPAll.',Struc{1}]),bandThet);
        [GammaMod.Shape.HPCThet,GammaMod.T.OBThet]=PlotRipRaw(eval(['LFPAll.',Struc{1}]),GammaMod.Output.HPCThet(1:min(1000,length(GammaMod.Output.HPCThet)))/1e4,500,0,0);
        for sss=1:3
            SptsdHigh=tsd(tspH*1e4,eval(['SpH.',Struc{sss}]));
            [GammaMod.Result.HPCThet{sss},~,GammaMod.time.HPCThet{sss}]=AverageSpectrogram(SptsdHigh,fspH,ts(GammaMod.Output.HPCThet),binsize,nbins,0,0,0);
        end
        
        for sss=1:3
            subplot(3,3,sss+6)
            imagesc(GammaMod.time.HPCThet{sss}/1000,fspH,log(GammaMod.Result.HPCThet{sss})), axis xy, hold on
            line([0 0],ylim,'color','w')
            Normalizer=(max(GammaMod.Shape.HPCThet(:,2))-min(GammaMod.Shape.HPCThet(:,2)));
            plot(GammaMod.Shape.HPCThet(:,1),40*GammaMod.Shape.HPCThet(:,2)/Normalizer+150,'w')
            title(['Sl:',Struc{1},'  Fst:',Struc{sss}])
        end
        
        saveas(fig,[SaveFolderName,'GammaTriggered/FzGammaNoSnd',num2str(Dir.name{pp}),'.png']);
        saveas(fig,[SaveFolderName,'GammaTriggered/FzGammaNoSnd',num2str(Dir.name{pp}),'.fig']);
        close all
        save('GammaModulation.mat','GammaMod')
        clear GammaMod
        % Trigger gamma on trough of slow oscillation - random
        GammaMod.Output.OBLOW=GetPeakAndTroughFreqBand(eval(['FilLFPR.Low.',Struc{2}]),bandLow);
        [GammaMod.Shape.OBLOW,GammaMod.T.OBLOW]=PlotRipRaw(eval(['LFPAll.',Struc{2}]),GammaMod.Output.OBLOW/1e4,500,0,0);
        for sss=1:3
            SptsdHigh=tsd(tspH*1e4,eval(['SpH.',Struc{sss}]));
            [GammaMod.Result.OBLOW{sss},~,GammaMod.time.OBLOW{sss}]=AverageSpectrogram(SptsdHigh,fspH,ts(GammaMod.Output.OBLOW(1:min(1000,length(GammaMod.Output.OBLOW)))),binsize,nbins,0,0,0);
        end
        
        fig=figure;
        for sss=1:3
            subplot(3,3,sss)
            imagesc(GammaMod.time.OBLOW{sss}/1000,fspH,log(GammaMod.Result.OBLOW{sss})), axis xy, hold on
            line([0 0],ylim,'color','w')
            Normalizer=(max(GammaMod.Shape.OBLOW(:,2))-min(GammaMod.Shape.OBLOW(:,2)));
            plot(GammaMod.Shape.OBLOW(:,1),40*GammaMod.Shape.OBLOW(:,2)/Normalizer+150,'w')
            title(['Sl:',Struc{2},'  Fst:',Struc{sss}])
        end
        
        % Trigger gamma on trough of theta oscillation in OB
        GammaMod.Output.OBThet=GetPeakAndTroughFreqBand(eval(['FilLFPR.Thet.',Struc{2}]),bandThet);
        [GammaMod.Shape.OBThet,GammaMod.T.OBThet]=PlotRipRaw(eval(['LFPAll.',Struc{2}]),GammaMod.Output.OBThet/1e4,500,0,0);
        for sss=1:3
            SptsdHigh=tsd(tspH*1e4,eval(['SpH.',Struc{sss}]));
            [GammaMod.Result.OBThet{sss},~,GammaMod.time.OBThet{sss}]=AverageSpectrogram(SptsdHigh,fspH,ts(GammaMod.Output.OBThet(1:min(1000,length(GammaMod.Output.OBThet)))),binsize,nbins,0,0,0);
        end
        
        for sss=1:3
            subplot(3,3,sss+3)
            imagesc(GammaMod.time.OBLOW{sss}/1000,fspH,log(GammaMod.Result.OBThet{sss})), axis xy, hold on
            line([0 0],ylim,'color','w')
            Normalizer=(max(GammaMod.Shape.OBThet(:,2))-min(GammaMod.Shape.OBThet(:,2)));
            plot(GammaMod.Shape.OBLOW(:,1),40*GammaMod.Shape.OBThet(:,2)/Normalizer+150,'w')
            title(['Sl:',Struc{2},'  Fst:',Struc{sss}])
        end
        
        % Trigger gamma on trough of theta oscillation in HPC
        GammaMod.Output.HPCThet=GetPeakAndTroughFreqBand(eval(['FilLFPR.Thet.',Struc{1}]),bandThet);
        [GammaMod.Shape.HPCThet,GammaMod.T.OBThet]=PlotRipRaw(eval(['LFPAll.',Struc{1}]),GammaMod.Output.HPCThet/1e4,500,0,0);
        for sss=1:3
            SptsdHigh=tsd(tspH*1e4,eval(['SpH.',Struc{sss}]));
            [GammaMod.Result.HPCThet{sss},~,GammaMod.time.HPCThet{sss}]=AverageSpectrogram(SptsdHigh,fspH,ts(GammaMod.Output.HPCThet(1:min(1000,length(GammaMod.Output.HPCThet)))),binsize,nbins,0,0,0);
        end
        
        for sss=1:3
            subplot(3,3,sss+6)
            imagesc(GammaMod.time.HPCThet{sss}/1000,fspH,log(GammaMod.Result.HPCThet{sss})), axis xy, hold on
            line([0 0],ylim,'color','w')
            Normalizer=(max(GammaMod.Shape.HPCThet(:,2))-min(GammaMod.Shape.HPCThet(:,2)));
            plot(GammaMod.Shape.HPCThet(:,1),40*GammaMod.Shape.HPCThet(:,2)/Normalizer+150,'w')
            title(['Sl:',Struc{1},'  Fst:',Struc{sss}])
        end
        
        saveas(fig,[SaveFolderName,'GammaTriggered/FzGammaRandNoSnd',num2str(Dir.name{pp}),'.png']);
        saveas(fig,[SaveFolderName,'GammaTriggered/FzGammaRandNoSnd',num2str(Dir.name{pp}),'.fig']);
        close all
        save('GammaModulationRand.mat','GammaMod')
        clear GammaMod

        % Trigger gamma on trough of slow oscillation in OB
        disp('real')
        GammaMod.Output.OBLOW=GetPeakAndTroughFreqBand(eval(['LFPAll.',Struc{2}]),bandLow);
        [GammaMod.Shape.OBLOW,GammaMod.T.OBLOW]=PlotRipRaw(eval(['LFPAll.',Struc{2}]),GammaMod.Output.OBLOW(1:min(1000,length(GammaMod.Output.OBLOW)))/1e4,500,0,0);
        for sss=1:3
            SptsdHigh=tsd(tspH*1e4,eval(['SpH.',Struc{sss}]));
            [GammaMod.Result.OBLOW{sss},~,GammaMod.time.OBLOW{sss}]=AverageSpectrogram(SptsdHigh,fspH,ts(GammaMod.Output.OBLOW),binsize,nbins,0,0,0);
        end
        
        fig=figure;
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
            title(['Sl:',Struc{2},'  Fst:',Struc{sss}])
        end
        
        % Trigger gamma on trough of theta oscillation in OB
        GammaMod.Output.OBThet=GetPeakAndTroughFreqBand(eval(['LFPAll.',Struc{2}]),bandThet);
        [GammaMod.Shape.OBThet,GammaMod.T.OBThet]=PlotRipRaw(eval(['LFPAll.',Struc{2}]),GammaMod.Output.OBThet(1:min(1000,length(GammaMod.Output.OBThet)))/1e4,500,0,0);
        for sss=1:3
            SptsdHigh=tsd(tspH*1e4,eval(['SpH.',Struc{sss}]));
            [GammaMod.Result.OBThet{sss},~,GammaMod.time.OBThet{sss}]=AverageSpectrogram(SptsdHigh,fspH,ts(GammaMod.Output.OBThet),binsize,nbins,0,0,0);
        end
        
        for sss=1:3
            subplot(3,3,sss+3)
            a=(GammaMod.Result.OBThet{sss}');
            b=(GammaMod.Result.OBThet{sss}');
            for t=1:size(a,1)
                a(t,:)=a(t,:)./mean(b);
            end
            imagesc(GammaMod.time.OBLOW{sss}/1000,fspH,a'), axis xy, hold on
            line([0 0],ylim,'color','w')
            Normalizer=(max(GammaMod.Shape.OBThet(:,2))-min(GammaMod.Shape.OBThet(:,2)));
            plot(GammaMod.Shape.OBLOW(:,1),40*GammaMod.Shape.OBThet(:,2)/Normalizer+150,'w')
            title(['Thet:',Struc{2},'  Fst:',Struc{sss}])
        end
        
        % Trigger gamma on trough of theta oscillation in HPC
        GammaMod.Output.HPCThet=GetPeakAndTroughFreqBand(eval(['LFPAll.',Struc{1}]),bandThet);
        [GammaMod.Shape.HPCThet,GammaMod.T.OBThet]=PlotRipRaw(eval(['LFPAll.',Struc{1}]),GammaMod.Output.HPCThet(1:min(1000,length(GammaMod.Output.HPCThet)))/1e4,500,0,0);
        for sss=1:3
            SptsdHigh=tsd(tspH*1e4,eval(['SpH.',Struc{sss}]));
            [GammaMod.Result.HPCThet{sss},~,GammaMod.time.HPCThet{sss}]=AverageSpectrogram(SptsdHigh,fspH,ts(GammaMod.Output.HPCThet),binsize,nbins,0,0,0);
        end
        
        for sss=1:3
            subplot(3,3,sss+6)
            a=(GammaMod.Result.HPCThet{sss}');
            b=(GammaMod.Result.HPCThet{sss}');
            for t=1:size(a,1)
                a(t,:)=a(t,:)./mean(b);
            end
            imagesc(GammaMod.time.HPCThet{sss}/1000,fspH,a'), axis xy, hold on
            line([0 0],ylim,'color','w')
            Normalizer=(max(GammaMod.Shape.HPCThet(:,2))-min(GammaMod.Shape.HPCThet(:,2)));
            plot(GammaMod.Shape.HPCThet(:,1),40*GammaMod.Shape.HPCThet(:,2)/Normalizer+150,'w')
            title(['Thet:',Struc{1},'  Fst:',Struc{sss}])
        end
        
        saveas(fig,[SaveFolderName,'GammaTriggered/FzGammaNormNoSnd',num2str(Dir.name{pp}),'.png']);
        saveas(fig,[SaveFolderName,'GammaTriggered/FzGammaNormNoSnd',num2str(Dir.name{pp}),'.fig']);
        close all
        
        % Trigger gamma on trough of slow oscillation in OB
        disp('rand')
        GammaMod.Output.OBLOW=GetPeakAndTroughFreqBand(eval(['FilLFPR.Low.',Struc{2}]),bandLow);
        [GammaMod.Shape.OBLOW,GammaMod.T.OBLOW]=PlotRipRaw(eval(['LFPAll.',Struc{2}]),GammaMod.Output.OBLOW(1:min(1000,length(GammaMod.Output.OBLOW)))/1e4,500,0,0);
        for sss=1:3
            SptsdHigh=tsd(tspH*1e4,eval(['SpH.',Struc{sss}]));
            [GammaMod.Result.OBLOW{sss},~,GammaMod.time.OBLOW{sss}]=AverageSpectrogram(SptsdHigh,fspH,ts(GammaMod.Output.OBLOW),binsize,nbins,0,0,0);
        end
        
        fig=figure;
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
            title(['Sl:',Struc{2},'  Fst:',Struc{sss}])
        end
        
        % Trigger gamma on trough of theta oscillation in OB
        GammaMod.Output.OBThet=GetPeakAndTroughFreqBand(eval(['FilLFPR.Thet.',Struc{2}]),bandThet);
        [GammaMod.Shape.OBThet,GammaMod.T.OBThet]=PlotRipRaw(eval(['LFPAll.',Struc{2}]),GammaMod.Output.OBThet(1:min(1000,length(GammaMod.Output.OBThet)))/1e4,500,0,0);
        for sss=1:3
            SptsdHigh=tsd(tspH*1e4,eval(['SpH.',Struc{sss}]));
            [GammaMod.Result.OBThet{sss},~,GammaMod.time.OBThet{sss}]=AverageSpectrogram(SptsdHigh,fspH,ts(GammaMod.Output.OBThet),binsize,nbins,0,0,0);
        end
        
        for sss=1:3
            subplot(3,3,sss+3)
            a=(GammaMod.Result.OBThet{sss}');
            b=(GammaMod.Result.OBThet{sss}');
            for t=1:size(a,1)
                a(t,:)=a(t,:)./mean(b);
            end
            imagesc(GammaMod.time.OBLOW{sss}/1000,fspH,a'), axis xy, hold on
            line([0 0],ylim,'color','w')
            Normalizer=(max(GammaMod.Shape.OBThet(:,2))-min(GammaMod.Shape.OBThet(:,2)));
            plot(GammaMod.Shape.OBLOW(:,1),40*GammaMod.Shape.OBThet(:,2)/Normalizer+150,'w')
            title(['Thet:',Struc{2},'  Fst:',Struc{sss}])
        end
        
        % Trigger gamma on trough of theta oscillation in HPC
        GammaMod.Output.HPCThet=GetPeakAndTroughFreqBand(eval(['FilLFPR.Thet.',Struc{1}]),bandThet);
        [GammaMod.Shape.HPCThet,GammaMod.T.OBThet]=PlotRipRaw(eval(['LFPAll.',Struc{1}]),GammaMod.Output.HPCThet(1:min(1000,length(GammaMod.Output.HPCThet)))/1e4,500,0,0);
        for sss=1:3
            SptsdHigh=tsd(tspH*1e4,eval(['SpH.',Struc{sss}]));
            [GammaMod.Result.HPCThet{sss},~,GammaMod.time.HPCThet{sss}]=AverageSpectrogram(SptsdHigh,fspH,ts(GammaMod.Output.HPCThet),binsize,nbins,0,0,0);
        end
        
        for sss=1:3
            subplot(3,3,sss+6)
            a=(GammaMod.Result.HPCThet{sss}');
            b=(GammaMod.Result.HPCThet{sss}');
            for t=1:size(a,1)
                a(t,:)=a(t,:)./mean(b);
            end
            imagesc(GammaMod.time.HPCThet{sss}/1000,fspH,a'), axis xy, hold on
            line([0 0],ylim,'color','w')
            Normalizer=(max(GammaMod.Shape.HPCThet(:,2))-min(GammaMod.Shape.HPCThet(:,2)));
            plot(GammaMod.Shape.HPCThet(:,1),40*GammaMod.Shape.HPCThet(:,2)/Normalizer+150,'w')
            title(['Thet:',Struc{1},'  Fst:',Struc{sss}])
        end
        
        saveas(fig,[SaveFolderName,'GammaTriggered/FzGammaNormRandNoSnd',num2str(Dir.name{pp}),'.png']);
        saveas(fig,[SaveFolderName,'GammaTriggered/FzGammaNormRandNoSnd',num2str(Dir.name{pp}),'.fig']);
        close all
        
        disp('done')

    end
    
    clear GammaMod  Phase SpL SpH
end
