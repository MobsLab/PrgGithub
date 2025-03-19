%% Are theta and OB ocillations coupled?
%  Only look
%% Comodulation in three states : REM, SWS, Locomotion
clear all
CtrlEphys=[242,248,244,243,253,254,258,259,299,394,395,402,403,450,451];
Dir=PathForExperimentFEAR('Fear-electrophy');
Dir=RestrictPathForExperiment(Dir,'nMice',CtrlEphys);
Dir=RestrictPathForExperiment(Dir,'Session','EXT-24h');
KeepFirstSessionOnly=[1,3,4,6,8:length(Dir.path)];
SaveFolderName='/home/vador/Documents/AllNeurModulation/';
Struc={'HPC','OB','PFCx'};
[params,movingwin,suffix]=SpectrumParametersML('low');
FreqBand={[3,6],[3,6],[3,6]};
% Parameters for triggered specrto
for mm=KeepFirstSessionOnly
    
    cd(Dir.path{mm})

    clear FilLFPL Hi Lo EpHi Sp Phase y
    load('behavResources.mat')
    load('StateEpochSB.mat')
    
    FreezeEpoch=FreezeEpoch-TotalNoiseEpoch;
    
    load('ChannelsToAnalyse/Bulb_deep.mat')
    chB=channel;
    load(['LFPData/LFP',num2str(chB),'.mat']);
    [y, ARmodel] = WhitenSignal(Data(LFP),[],1,[],2);
    LFPAll.OB=tsd(Range(LFP),y);
    FilLFP.OB=FilterLFP(tsd(Range(LFP),y),FreqBand{2},1024);
    Hil=hilbert(Data(Restrict(FilLFP.OB,FreezeEpoch)));
    Phase.OB=angle(Hil)*180/pi+180;
    snip=ceil(rand(1)*length(Phase.OB));
    Phase.OBR=[Phase.OB(snip:end);Phase.OB(1:snip-1)];
    
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
    LFPAll.HPC=tsd(Range(LFP),y);
    FilLFP.HPC=FilterLFP(tsd(Range(LFP),y),FreqBand{1},1024);
    Hil=hilbert(Data(Restrict(FilLFP.HPC,FreezeEpoch)));
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
    LFPAll.PFCx=tsd(Range(LFP),y);
    FilLFP.PFCx=FilterLFP(tsd(Range(LFP),y),FreqBand{2},1024);
    Hil=hilbert(Data(Restrict(FilLFP.PFCx,FreezeEpoch)));
    Phase.PFCx=angle(Hil)*180/pi+180;
    snip=ceil(rand(1)*length(Phase.PFCx));
    Phase.PFCxR=[Phase.PFCx(snip:end);Phase.PFCx(1:snip-1)];
    DatLFP=Data(FilLFP.PFCx);
    FilLFPR.PFCx=tsd(Range(FilLFP.PFCx),[DatLFP(snip:end);DatLFP(1:snip-1)]);
    
    % RealData
    for ss=1:3
        for sss=1:3
            if not(ss==sss)
                [temp,xx,yy]=hist2(eval(['Phase.',Struc{ss}]),eval(['Phase.',Struc{sss}]),100,100);
                temp=temp./sum(sum(temp));
                eval(['nn.',Struc{ss},'n',Struc{sss},'=temp'])
            end
        end
    end
    %
    fig=figure;
    for ss=1:3
        for sss=1:3
            if not(ss==sss)
                subplot(3,3,(ss-1)*3+sss)
                imagesc(xx,yy,log(eval(['nn.',Struc{ss},'n',Struc{sss}]))), %caxis([-13.5 -7]),
                axis xy
                xlabel(Struc{ss}),ylabel(Struc{sss})
                line([0 360],[0 360],'linewidth',3,'color','w')
            end
        end
    end
    keyboard
    saveas(fig,[SaveFolderName,'36BandCoupling',num2str(Dir.name{mm}),'.png']);
    saveas(fig,[SaveFolderName,'36BandCoupling',num2str(Dir.name{mm}),'.fig']);
    close all
    
end
