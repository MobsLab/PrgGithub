% Look at HPC phase after subtraction of local channels
%% Are theta and OB ocillations coupled?
%  Only look
%% Comodulation in three states : REM, SWS, Locomotion
clear all
CtrlEphysInvHPC=[253,258,299,395,403,451];
Dir=PathForExperimentFEAR('Fear-electrophy');
Dir=RestrictPathForExperiment(Dir,'nMice',CtrlEphysInvHPC);
Dir=RestrictPathForExperiment(Dir,'Session','EXT-24h');
FreqRange=[1:12;[3:14]];

for mm=1:length(Dir.path)
    mm
    cd(Dir.path{mm})
    keyboard
    CaxLim{1}=[];
    CaxLim{2}=[];
    fig=figure('units','normalized','outerposition',[0 0 1 1]);
    load('behavResources.mat')
    load('OBHPCPhaseCoupling1.mat')
    load('B_Low_Spectrum.mat')
    SptsdB=tsd(Spectro{2}*1e4,Spectro{1});
    SpecOB=mean(Data(Restrict(SptsdB,FreezeEpoch)));
    SpecOB=12*SpecOB./max(SpecOB);
    load('H_Low_Spectrum.mat')
    SptsdH=tsd(Spectro{2}*1e4,Spectro{1});
    SpecH=mean(Data(Restrict(SptsdH,FreezeEpoch)));
    SpecH=12*SpecH./max(SpecH);
    
    FinalSig.Shannon=zeros(size(FreqRange,2),size(FreqRange,2));
    FinalSig.VectLength=zeros(size(FreqRange,2),size(FreqRange,2));
    
    for f=1:size(FreqRange,2)
        for ff=1:size(FreqRange,2)
            Perc95=prctile(IndexRand.Shannon{f,ff},99);
            if Index.Shannon(f,ff)>Perc95
                FinalSig.Shannon(f,ff)=Index.Shannon(f,ff);
            end
            Perc95=prctile(IndexRand.VectLength{f,ff},99);
            if Index.VectLength(f,ff)>Perc95
                FinalSig.VectLength(f,ff)=Index.VectLength(f,ff);
            end
        end
    end
    
    subplot(2,3,1)
    contourf(mean(FreqRange),mean(FreqRange),FinalSig.Shannon),colorbar, hold on
    plot(Spectro{3},SpecOB,'w','linewidth',3)
    plot(Spectro{3},SpecH,'c','linewidth',3)
    xlim([2 12]),ylim([2 12])
    title('OBvsHPC1')
    CaxLim{1}=[CaxLim{1};clim];
    subplot(2,3,4)
    contourf(mean(FreqRange),mean(FreqRange),FinalSig.VectLength),colorbar, hold on
    plot(Spectro{3},SpecOB,'w','linewidth',3)
    plot(Spectro{3},SpecH,'c','linewidth',3)
    xlim([2 12]),ylim([2 12])
    CaxLim{2}=[CaxLim{2};clim];
    
    load('OBHPCPhaseCoupling2.mat')
    
    FinalSig.Shannon=zeros(size(FreqRange,2),size(FreqRange,2));
    FinalSig.VectLength=zeros(size(FreqRange,2),size(FreqRange,2));
    
    for f=1:size(FreqRange,2)
        for ff=1:size(FreqRange,2)
            Perc95=prctile(IndexRand.Shannon{f,ff},99);
            if Index.Shannon(f,ff)>Perc95
                FinalSig.Shannon(f,ff)=Index.Shannon(f,ff);
            end
            Perc95=prctile(IndexRand.VectLength{f,ff},99);
            if Index.VectLength(f,ff)>Perc95
                FinalSig.VectLength(f,ff)=Index.VectLength(f,ff);
            end
        end
    end
    
    subplot(2,3,2)
    contourf(mean(FreqRange),mean(FreqRange),FinalSig.Shannon), colorbar, hold on
    plot(Spectro{3},SpecOB,'w','linewidth',3)
    plot(Spectro{3},SpecH,'c','linewidth',3)
    xlim([2 12]),ylim([2 12])
    title('OBvsHPC2')
    CaxLim{1}=[CaxLim{1};clim];
    subplot(2,3,5)
    contourf(mean(FreqRange),mean(FreqRange),FinalSig.VectLength),colorbar, hold on
    plot(Spectro{3},SpecOB,'w','linewidth',3)
    plot(Spectro{3},SpecH,'c','linewidth',3)
    xlim([2 12]),ylim([2 12])
    CaxLim{2}=[CaxLim{2};clim];
    
    load('OBLocHPCPhaseCoupling.mat')
    
    FinalSig.Shannon=zeros(size(FreqRange,2),size(FreqRange,2));
    FinalSig.VectLength=zeros(size(FreqRange,2),size(FreqRange,2));
    
    for f=1:size(FreqRange,2)
        for ff=1:size(FreqRange,2)
            Perc95=prctile(IndexRand.Shannon{f,ff},99);
            if Index.Shannon(f,ff)>Perc95
                FinalSig.Shannon(f,ff)=Index.Shannon(f,ff);
            end
            Perc95=prctile(IndexRand.VectLength{f,ff},99);
            if Index.VectLength(f,ff)>Perc95
                FinalSig.VectLength(f,ff)=Index.VectLength(f,ff);
            end
        end
    end
    
    subplot(2,3,3)
    contourf(mean(FreqRange),mean(FreqRange),FinalSig.Shannon),colorbar, hold on
    plot(Spectro{3},SpecOB,'w','linewidth',3)
    plot(Spectro{3},SpecH,'c','linewidth',3)
    xlim([2 12]),ylim([2 12])
    title('OBvsHPCLocal')
    CaxLim{1}=[CaxLim{1};clim];
    subplot(2,3,6)
    contourf(mean(FreqRange),mean(FreqRange),FinalSig.VectLength),colorbar, hold on
    plot(Spectro{3},SpecOB,'w','linewidth',3)
    plot(Spectro{3},SpecH,'c','linewidth',3)
    xlim([2 12]),ylim([2 12])
    CaxLim{2}=[CaxLim{2};clim];
    
    for kk=1:3
        subplot(2,3,kk)
        clim(max(CaxLim{1}))
    end
    
    for kk=4:6
        subplot(2,3,kk)
        clim(max(CaxLim{2}))
    end
    
    cd /home/vador/Dropbox/MOBS_workingON/OB4Hz-manuscrit/FigHippocampus/CouplingOBHPC
    saveas(fig,[Dir.name{mm},'OBHPCPhaseCoupling','.fig']);
    saveas(fig,[Dir.name{mm},'OBHPCPhaseCoupling','.png']);
    close all
end


