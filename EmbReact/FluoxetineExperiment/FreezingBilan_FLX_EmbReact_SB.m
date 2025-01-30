clear all
SALMice = [688,739,777,779];
FLXMice = [740,750,778,775];
load('B_Low_Spectrum.mat')
fLow = Spectro{3};
load('H_VHigh_Spectrum.mat')
fHigh = Spectro{3};
Cols{1} = [[1 0.6 0.6];[1 0.6 0.6]*0.5] ;
Cols{2} = [[0.6 0.6 1];[0.6 0.6 1]*0.5] ;

SessNames_Combi{1}={'UMazeCondBlockedShock_PostDrug' 'UMazeCondBlockedSafe_PostDrug' 'UMazeCondExplo_PostDrug'...
    'TestPost_PostDrug','ExtinctionBlockedShock_PostDrug' 'ExtinctionBlockedSafe_PostDrug' };
SessNames_Combi{2}={'ExtinctionBlockedShock_PostDrug' 'ExtinctionBlockedSafe_PostDrug'};
SessNames_Combi{3}={'TestPost_PostDrug'};
SessNames_Combi{4}={'UMazeCondBlockedShock_PostDrug' 'UMazeCondBlockedSafe_PostDrug'};
SessNames_Combi{5}={'UMazeCondBlockedShock_PostDrug' 'UMazeCondBlockedSafe_PostDrug' 'UMazeCondExplo_PostDrug'};
SessNum_Combi{1} = [2,2,2,4,2,2];
SessNum_Combi{2} = [2,2];
SessNum_Combi{3} = [4];
SessNum_Combi{4} = [2,2];
SessNum_Combi{5} = [2,2,2];

ReNorm = 1;
fig = figure(1);
clf
for sesstype = 1%:length(SessNames_Combi)
    
    SessNames = SessNames_Combi{sesstype};
    SessNum = SessNum_Combi{sesstype};

    SALFiles = cell(1,4);
    FLXFiles = cell(1,4);
    
    for sess = 1 : length(SessNames)
        Dir=PathForExperimentsEmbReact(SessNames{sess});
        for d = 1:length(Dir.path)
            if sum(ismember(SALMice,Dir.ExpeInfo{d}{1}.nmouse))
                
                for p = 1:SessNum(sess)
                    SALFiles{find(ismember(SALMice,Dir.ExpeInfo{d}{1}.nmouse))}{end+1} = Dir.path{d}{p};
                end
                
            elseif sum(ismember(FLXMice,Dir.ExpeInfo{d}{1}.nmouse))
                for p = 1:SessNum(sess)
                    FLXFiles{find(ismember(FLXMice,Dir.ExpeInfo{d}{1}.nmouse))}{end+1} = Dir.path{d}{p};
                end
            end
            
        end
        
    end
    
    for mm = 1:4
        
        All_B.Sal{mm} = ConcatenateDataFromFolders_SB(SALFiles{mm},'spectrum','prefix','B_Low');
        All_HLow.Sal{mm} = ConcatenateDataFromFolders_SB(SALFiles{mm},'spectrum','prefix','H_Low');
        All_Pos.Sal{mm} = ConcatenateDataFromFolders_SB(SALFiles{mm},'LinearPosition');
        All_Fz.Sal{mm} = ConcatenateDataFromFolders_SB(SALFiles{mm},'Epoch','epochname','freezeepoch');
        All_H.Sal{mm} = ConcatenateDataFromFolders_SB(SALFiles{mm},'spectrum','prefix','H_VHigh');
        All_Zn.Sal{mm} = ConcatenateDataFromFolders_SB(SALFiles{mm},'Epoch','epochname','zoneepoch');
        All_HR.Sal{mm} = ConcatenateDataFromFolders_SB(SALFiles{mm},'heartrate');
        
        All_B.Flx{mm} = ConcatenateDataFromFolders_SB(FLXFiles{mm},'spectrum','prefix','B_Low');
        All_HLow.Flx{mm} = ConcatenateDataFromFolders_SB(FLXFiles{mm},'spectrum','prefix','H_Low');
        All_Pos.Flx{mm} = ConcatenateDataFromFolders_SB(FLXFiles{mm},'LinearPosition');
        All_Fz.Flx{mm} = ConcatenateDataFromFolders_SB(FLXFiles{mm},'Epoch','epochname','freezeepoch');
        All_H.Flx{mm} = ConcatenateDataFromFolders_SB(FLXFiles{mm},'spectrum','prefix','H_VHigh');
        All_Zn.Flx{mm} = ConcatenateDataFromFolders_SB(FLXFiles{mm},'Epoch','epochname','zoneepoch');
        All_HR.Flx{mm} = ConcatenateDataFromFolders_SB(FLXFiles{mm},'heartrate');
        
    end
    
    for m = 1:4
        
        A = Data(All_B.Sal{m});
        B = nanmean(A(:,1:15)');
        C = nanmean(A(:,30:end)');
        Noistsd = tsd(Range(All_B.Sal{m}),(B./C)');
        if sesstype==1
            plot(Data(Restrict(Noistsd,All_Fz.Sal{m})))
            Threshold.Sal(m) = input('Give thresh');
            clf
        end
        NoiseEpochMan.Sal{m} = thresholdIntervals(Noistsd,Threshold.Sal(m),'Direction','Above')

        A = Data(All_B.Flx{m});
        B = nanmean(A(:,1:15)');
        C = nanmean(A(:,30:end)');
        Noistsd = tsd(Range(All_B.Flx{m}),(B./C)');
        if sesstype==1
        plot(Data(Restrict(Noistsd,All_Fz.Flx{m})))
        Threshold.Flx(m) = input('Give thresh');
        clf
        end
        NoiseEpochMan.Flx{m} = thresholdIntervals(Noistsd,Threshold.Flx(m),'Direction','Above')
        
    end
    
    MeanOB.Shk.Flx = [];
    MeanOB.Shk.Sal = [];
    MeanOB.Saf.Flx = [];
    MeanOB.Saf.Sal = [];
    
    MeanHHi.Shk.Flx = [];
    MeanHHi.Shk.Sal = [];
    MeanHHi.Saf.Flx = [];
    MeanHHi.Saf.Sal = [];
    
    MeanHLo.Shk.Flx = [];
    MeanHLo.Shk.Sal = [];
    MeanHLo.Saf.Flx = [];
    MeanHLo.Saf.Sal = [];
    
    MeanHR.Shk.Flx = [];
    MeanHR.Shk.Sal = [];
    MeanHR.Saf.Flx = [];
    MeanHR.Saf.Sal = [];
    
    StdHR.Shk.Flx = [];
    StdHR.Shk.Sal = [];
    StdHR.Saf.Flx = [];
    StdHR.Saf.Sal = [];
    StdHR.Mov.Flx = [];
    StdHR.Mov.Sal = [];
    
    MouseGroup = {'Sal','Flx'};
    
    for m = 1:4
        for gr = 1:2
            MeanOB.Shk.(MouseGroup{gr})(m,:) = nanmean(Data(Restrict(All_B.(MouseGroup{gr}){m},and(All_Fz.(MouseGroup{gr}){m},All_Zn.(MouseGroup{gr}){m}{1})-NoiseEpochMan.(MouseGroup{gr}){m})));
            MeanOB.Saf.(MouseGroup{gr})(m,:) = nanmean(Data(Restrict(All_B.(MouseGroup{gr}){m},and(All_Fz.(MouseGroup{gr}){m},or(All_Zn.(MouseGroup{gr}){m}{2},All_Zn.(MouseGroup{gr}){m}{5}))-NoiseEpochMan.(MouseGroup{gr}){m})));
            
            MeanHHi.Shk.(MouseGroup{gr})(m,:) = nanmean(Data(Restrict(All_H.(MouseGroup{gr}){m},and(All_Fz.(MouseGroup{gr}){m},All_Zn.(MouseGroup{gr}){m}{1})-NoiseEpochMan.(MouseGroup{gr}){m})));
            MeanHHi.Saf.(MouseGroup{gr})(m,:) = nanmean(Data(Restrict(All_H.(MouseGroup{gr}){m},and(All_Fz.(MouseGroup{gr}){m},or(All_Zn.(MouseGroup{gr}){m}{2},All_Zn.(MouseGroup{gr}){m}{5}))-NoiseEpochMan.(MouseGroup{gr}){m})));
            
            MeanHLo.Shk.(MouseGroup{gr})(m,:) = nanmean(Data(Restrict(All_HLow.(MouseGroup{gr}){m},and(All_Fz.(MouseGroup{gr}){m},All_Zn.(MouseGroup{gr}){m}{1})-NoiseEpochMan.(MouseGroup{gr}){m})));
            MeanHLo.Saf.(MouseGroup{gr})(m,:) = nanmean(Data(Restrict(All_HLow.(MouseGroup{gr}){m},and(All_Fz.(MouseGroup{gr}){m},or(All_Zn.(MouseGroup{gr}){m}{2},All_Zn.(MouseGroup{gr}){m}{5}))-NoiseEpochMan.(MouseGroup{gr}){m})));
            
            MeanHR.Shk.(MouseGroup{gr})(m) = nanmean(Data(Restrict(All_HR.(MouseGroup{gr}){m},and(All_Fz.(MouseGroup{gr}){m},All_Zn.(MouseGroup{gr}){m}{1}))));
            MeanHR.Saf.(MouseGroup{gr})(m) = nanmean(Data(Restrict(All_HR.(MouseGroup{gr}){m},and(All_Fz.(MouseGroup{gr}){m},or(All_Zn.(MouseGroup{gr}){m}{2},All_Zn.(MouseGroup{gr}){m}{5})))));
            MeanHR.Mov.(MouseGroup{gr})(m) = nanmean(Data(Restrict(All_HR.(MouseGroup{gr}){m},or(All_Zn.(MouseGroup{gr}){m}{2},All_Zn.(MouseGroup{gr}){m}{1})-All_Fz.(MouseGroup{gr}){m})));
            
            StdHR.Shk.(MouseGroup{gr})(m) = std(Data(Restrict(All_HR.(MouseGroup{gr}){m},and(All_Fz.(MouseGroup{gr}){m},All_Zn.(MouseGroup{gr}){m}{1}))));
            StdHR.Saf.(MouseGroup{gr})(m) = std(Data(Restrict(All_HR.(MouseGroup{gr}){m},and(All_Fz.(MouseGroup{gr}){m},or(All_Zn.(MouseGroup{gr}){m}{2},All_Zn.(MouseGroup{gr}){m}{5})))));
            StdHR.Mov.(MouseGroup{gr})(m) = std(Data(Restrict(All_HR.(MouseGroup{gr}){m},or(All_Zn.(MouseGroup{gr}){m}{2},All_Zn.(MouseGroup{gr}){m}{1})-All_Fz.(MouseGroup{gr}){m})));
        end
    end
    
    
    
    if ReNorm
        for m = 1:4
            for gr = 1:2
                
                MeanOB.Shk.(MouseGroup{gr})(m,:) = MeanOB.Shk.(MouseGroup{gr})(m,:)./sum(MeanOB.Shk.(MouseGroup{gr})(m,1:end));
                MeanOB.Saf.(MouseGroup{gr})(m,:) = MeanOB.Saf.(MouseGroup{gr})(m,:)./sum(MeanOB.Saf.(MouseGroup{gr})(m,1:end));
                
                MeanHLo.Shk.(MouseGroup{gr})(m,:) = MeanHLo.Shk.(MouseGroup{gr})(m,:)./sum(MeanHLo.Shk.(MouseGroup{gr})(m,1:end));
                MeanHLo.Saf.(MouseGroup{gr})(m,:) = MeanHLo.Saf.(MouseGroup{gr})(m,:)./sum(MeanHLo.Saf.(MouseGroup{gr})(m,1:end));
                
                
                MeanHHi.Shk.(MouseGroup{gr})(m,:) = MeanHHi.Shk.(MouseGroup{gr})(m,:)./sum(MeanHHi.Shk.(MouseGroup{gr})(m,1:end));
                MeanHHi.Saf.(MouseGroup{gr})(m,:) = MeanHHi.Saf.(MouseGroup{gr})(m,:)./sum(MeanHHi.Saf.(MouseGroup{gr})(m,1:end));
                
            end
        end
    end
    
    clf
    subplot(321)
    line([-1 0],[-1 0],'color',Cols{1}(2,:),'linewidth',4), hold on
    line([-1 0],[-1 0],'color',Cols{1}(1,:),'linewidth',4)
    line([-1 0],[-1 0],'color',Cols{2}(2,:),'linewidth',4)
    line([-1 0],[-1 0],'color',Cols{2}(1,:),'linewidth',4)
    
    g = shadedErrorBar(fLow,nanmean(MeanOB.Shk.Sal),stdError(MeanOB.Shk.Sal));
    set(g.patch,'FaceColor',Cols{1}(2,:),'FaceAlpha',0.7)
    g = shadedErrorBar(fLow,nanmean(MeanOB.Shk.Flx),stdError(MeanOB.Shk.Flx));
    set(g.patch,'FaceColor',Cols{1}(1,:),'FaceAlpha',0.5)
    
    g = shadedErrorBar(fLow,nanmean(MeanOB.Saf.Sal),stdError(MeanOB.Saf.Sal));
    set(g.patch,'FaceColor',Cols{2}(2,:),'FaceAlpha',0.7)
    g = shadedErrorBar(fLow,nanmean(MeanOB.Saf.Flx),stdError(MeanOB.Saf.Flx));
    set(g.patch,'FaceColor',Cols{2}(1,:),'FaceAlpha',0.5)
    ylim([0 0.02])
    xlim([0 20])
    legend('Shk Sal','Shk Flx','Saf Sal','Saf Flx')
    ylabel('Power - norm')
    xlabel('Frequency(Hz)')
    title('OB spectra')
    
    subplot(322)
    line([-1 0],[-1 0],'color',[0.4 0.4 0.4],'linewidth',4), hold on
    line([-1 0],[-1 0],'color',[0.8 0.8 0.8],'linewidth',4)
    
    Vals = (MeanOB.Shk.Sal-MeanOB.Saf.Sal)'./(MeanOB.Shk.Sal+MeanOB.Saf.Sal)';
    g = shadedErrorBar(fLow,nanmean(Vals'),stdError(Vals'));
    set(g.patch,'FaceColor',[0.4 0.4 0.4],'FaceAlpha',0.7)
    hold on
    Vals = (MeanOB.Shk.Flx-MeanOB.Saf.Flx)'./(MeanOB.Shk.Flx+MeanOB.Saf.Flx)';
    g = shadedErrorBar(fLow,nanmean(Vals'),stdError(Vals'));
    set(g.patch,'FaceColor',[0.8 0.8 0.8],'FaceAlpha',0.7)
    xlim([0 20])
    legend('Sal','Flx')
    ylabel('Power difference')
    xlabel('Frequency(Hz)')
    title('HPC spectra shock - safe')
    box off
    
    subplot(323)
    g = shadedErrorBar(fHigh,nanmean(log(MeanHHi.Shk.Sal)),stdError(log(MeanHHi.Shk.Sal)));
    set(g.patch,'FaceColor',Cols{1}(2,:),'FaceAlpha',0.7)
    hold on
    g = shadedErrorBar(fHigh,nanmean(log(MeanHHi.Shk.Flx)),stdError(log(MeanHHi.Shk.Flx)));
    set(g.patch,'FaceColor',Cols{1}(1,:),'FaceAlpha',0.5)
    
    g = shadedErrorBar(fHigh,nanmean(log(MeanHHi.Saf.Sal)),stdError(log(MeanHHi.Saf.Sal)));
    set(g.patch,'FaceColor',Cols{2}(2,:),'FaceAlpha',0.7)
    hold on
    g = shadedErrorBar(fHigh,nanmean(log(MeanHHi.Saf.Flx)),stdError(log(MeanHHi.Saf.Flx)));
    set(g.patch,'FaceColor',Cols{2}(1,:),'FaceAlpha',0.5)
    ylabel('Power - norm')
    xlabel('Frequency(Hz)')
    title('HPC spectra')
    xlim([20 250])
    box off
    
    subplot(324)
    Vals = (MeanHHi.Shk.Sal-MeanHHi.Saf.Sal)'./(MeanHHi.Shk.Sal+MeanHHi.Saf.Sal)';
    g = shadedErrorBar(fHigh,nanmean(Vals'),stdError(Vals'));
    set(g.patch,'FaceColor',[0.4 0.4 0.4],'FaceAlpha',0.7)
    hold on
    Vals = (MeanHHi.Shk.Flx-MeanHHi.Saf.Flx)'./(MeanHHi.Shk.Flx+MeanHHi.Saf.Flx)';
    try,
    catch
        g = shadedErrorBar(fHigh,nanmean(Vals'),stdError(Vals'));
    end
    set(g.patch,'FaceColor',[0.8 0.8 0.8],'FaceAlpha',0.7)
    ylabel('Power difference')
    xlim([20 250])
    xlabel('Frequency(Hz)')
    title('HPC spectra shock - safe')
    box off
    
    subplot(325)
    bar(1,nanmean(MeanHR.Mov.Sal),'Facecolor',[0.6 1 0.6]), hold on
    plot(1,MeanHR.Mov.Sal,'.k','MarkerSize',10)
    
    bar(4,nanmean(MeanHR.Shk.Sal),'Facecolor',Cols{1}(2,:))
    plot(4,MeanHR.Shk.Sal,'.k','MarkerSize',10)
    
    bar(7,nanmean(MeanHR.Saf.Sal),'Facecolor',Cols{2}(2,:))
    plot(7,MeanHR.Saf.Sal,'.k','MarkerSize',10)
    
    bar(2,nanmean(MeanHR.Mov.Flx),'Facecolor',[0.3 0.5 0.3]), hold on
    plot(2,MeanHR.Mov.Flx,'.k','MarkerSize',10)
    
    bar(5,nanmean(MeanHR.Shk.Flx),'Facecolor',Cols{1}(1,:))
    plot(5,MeanHR.Shk.Flx,'.k','MarkerSize',10)
    
    bar(8,nanmean(MeanHR.Saf.Flx),'Facecolor',Cols{2}(1,:))
    plot(8,MeanHR.Saf.Flx,'.k','MarkerSize',10)
    set(gca,'XTick',[1,2,4,5,7,8],'XTickLabel',{'Mov Sal','Mov Flx','Shock Sal','Shock Flx','Safe Sal','Safe Flx'}),xtickangle(45)
    ylim([6 13])
    ylabel('Heart rate (Hz)')
    title('Heart rate')
    box off
    
    subplot(326)
    bar(1,nanmean(StdHR.Mov.Sal),'Facecolor',[0.6 1 0.6]), hold on
    plot(1,StdHR.Mov.Sal,'.k','MarkerSize',10)
    
    bar(4,nanmean(StdHR.Shk.Sal),'Facecolor',Cols{1}(2,:))
    plot(4,StdHR.Shk.Sal,'.k','MarkerSize',10)
    
    bar(7,nanmean(StdHR.Saf.Sal),'Facecolor',Cols{2}(2,:))
    plot(7,StdHR.Saf.Sal,'.k','MarkerSize',10)
    
    bar(2,nanmean(StdHR.Mov.Flx),'Facecolor',[0.3 0.5 0.3]), hold on
    plot(2,StdHR.Mov.Flx,'.k','MarkerSize',10)
    
    bar(5,nanmean(StdHR.Shk.Flx),'Facecolor',Cols{1}(1,:))
    plot(5,StdHR.Shk.Flx,'.k','MarkerSize',10)
    
    bar(8,nanmean(StdHR.Saf.Flx),'Facecolor',Cols{2}(1,:))
    plot(8,StdHR.Saf.Flx,'.k','MarkerSize',10)
    set(gca,'XTick',[1.5,4.5,7.5],'XTickLabel',{'Mov','Shock','Safe'}),xtickangle(45)
    ylabel('Heart rate Var')
    title('Heart rate var')
    box off
    
%     saveas(1,['/media/DataMOBsRAIDN/ProjectEmbReact/Figures/FluoxetineAnalysis/AnalysisSpet2018/BilanFreezing',num2str(sesstype),'.png'])
%     saveas(1,['/media/DataMOBsRAIDN/ProjectEmbReact/Figures/FluoxetineAnalysis/AnalysisSpet2018/BilanFreezing',num2str(sesstype),'.fig'])

end