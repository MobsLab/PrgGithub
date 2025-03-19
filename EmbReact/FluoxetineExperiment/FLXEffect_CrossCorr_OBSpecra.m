clear all

SessNames={'UMazeCondBlockedShock_PostDrug' 'UMazeCondBlockedSafe_PostDrug' 'UMazeCondExplo_PostDrug'...
    'TestPost_PostDrug','ExtinctionBlockedShock_PostDrug' 'ExtinctionBlockedSafe_PostDrug' };

GetRidOfHighFreq = 1;

Mice = [688,739,777,779,740,750,778,775];
for m = 1:length(Mice)
    Files={};
    for sess = 1 : length(SessNames)
        Dir=PathForExperimentsEmbReact(SessNames{sess});
        for d = 1:length(Dir.path)
            
            if sum(ismember(Mice(m),Dir.ExpeInfo{d}{1}.nmouse))
                Files{end+1} = Dir.path{d}{1};
                Files{end+1} = Dir.path{d}{2};
            end
        end
    end
    
    
    All_B = ConcatenateDataFromFolders_SB(Files,'spectrum','prefix','B_Low');
    All_HLow = ConcatenateDataFromFolders_SB(Files,'spectrum','prefix','H_Low');
    All_Pos = ConcatenateDataFromFolders_SB(Files,'LinearPosition');
    All_Fz = ConcatenateDataFromFolders_SB(Files,'Epoch','epochname','freezeepoch');
    All_H = ConcatenateDataFromFolders_SB(Files,'spectrum','prefix','H_VHigh');
    
    load('B_Low_Spectrum.mat')
    fLow = Spectro{3};
    load('H_VHigh_Spectrum.mat')
    fHigh = Spectro{3};
    
    Spec{m} = Restrict(All_B,All_Fz);
    
    if GetRidOfHighFreq
        A = SmoothDec(Data(Spec{m}),[2 0.01]);
        [val,ind] = max(A(:,30:end)');
        [sr,srind] = sort(ind);
        FreqOrd = tsd(Range(Spec{m}),fLow(30+ind(srind))');
        GoodEpoch = thresholdIntervals(FreqOrd,6.5,'Direction','Below');
        Spec{m} = Restrict(Spec{m},GoodEpoch);
    end
    
    SpecH{m} = (Restrict(All_H,ts(Range(Spec{m}))));
    Pos{m} = (Restrict(All_Pos,ts(Range(Spec{m}))));
    SpecHLow{m} = (Restrict(All_HLow,ts(Range(Spec{m}))));
    TotFzTime(m) = sum(Stop(All_Fz,'s') - Start(All_Fz,'s'));

    
    subplot(4,8,m)
    [R,P] = corr(Data(Spec{m}),Data(Spec{m}));
    imagesc(fLow,fLow,R), axis xy
    if m==1
        ylabel('OB vs OB')
    end
    title(num2str(Mice(m)))
    subplot(4,8,m+8)
    [R,P] = corr(Data(Spec{m}),Data(SpecH{m}));
    imagesc(fHigh,fLow,R), axis xy
    if m==1
        ylabel('OB vs HPC Hi')
    end
    subplot(4,8,m+16)
    [R,P] = corr(Data(Spec{m}),Data(SpecHLow{m}));
    imagesc(fLow,fLow,R), axis xy
    if m==1
        ylabel('OB vs HPC Low')
    end
    subplot(4,8,m+24)
    [R,P] = corr(Data(SpecHLow{m}),Data(SpecH{m}));
    imagesc(fHigh,fLow,R), axis xy
    if m==1
        ylabel('HPC Low vs HPC Hi')
    end
end

figure
AllR.Sal = zeros(length(fLow),length(fLow));
AllR.Flx = zeros(length(fLow),length(fLow));
HighFreqBand = 5;
for m = 1:4
    [R,P] = corr(Data(Spec{m}),Data(Spec{m}));
    R = R/sum(R(:));
    AllR.Sal=AllR.Sal+R;
    subplot(2,5,m)
    imagesc(fLow,fLow,R), axis xy, hold on
    axis square
    line([HighFreqBand HighFreqBand],ylim,'color','w')
    line(xlim,[HighFreqBand HighFreqBand],'color','w')
    xlim([0 20]), ylim([0 20])
        clim([-0.08 0.35]*1e-3/4)
    title(num2str(Mice(m)))

    [R,P] = corr(Data(Spec{m+4}),Data(Spec{m+4}));
    R = R/sum(R(:));
    AllR.Flx=AllR.Flx+R;
    subplot(2,5,m+5)
    imagesc(fLow,fLow,R), axis xy, hold on
    line([HighFreqBand HighFreqBand],ylim,'color','w')
    line(xlim,[HighFreqBand HighFreqBand],'color','w')
    xlim([0 20]), ylim([0 20])
    axis square
    clim([-0.08 0.35]*1e-3/4)
    title(num2str(Mice(m+4)))

end

subplot(255)
imagesc(fLow,fLow,AllR.Sal)
axis xy
axis square
line([HighFreqBand HighFreqBand],ylim,'color','w')
line(xlim,[HighFreqBand HighFreqBand],'color','w')
clim([-0.08 0.35]*1e-3)
title('Average saline')

subplot(2,5,10)
imagesc(fLow,fLow,AllR.Flx)
axis xy
axis square
line([HighFreqBand HighFreqBand],ylim,'color','w')
line(xlim,[HighFreqBand HighFreqBand],'color','w')
clim([-0.08 0.35]*1e-3)
title('Average flx')


figure
AllR.Sal = zeros(length(fLow),length(fHigh));
AllR.Flx = zeros(length(fLow),length(fHigh));
HighFreqBand = 5;
for m = 1:4
    [R,P] = corr(Data(Spec{m}),Data(SpecH{m}));
    R = R/sum(R(:));
    AllR.Sal=AllR.Sal+R;
    subplot(2,5,m)
    imagesc(fLow,fHigh,R), axis xy, hold on
    axis square
%     xlim([0 20]), ylim([0 20])
%         clim([-0.08 0.35]*1e-3/4)
    title(num2str(Mice(m)))

    [R,P] = corr(Data(Spec{m+4}),Data(SpecH{m+4}));
    R = R/sum(R(:));
    AllR.Flx=AllR.Flx+R;
    subplot(2,5,m+5)
    imagesc(fLow,fHigh,R), axis xy, hold on
%     xlim([0 20]), ylim([0 20])
    axis square
%     clim([-0.08 0.35]*1e-3/4)
    title(num2str(Mice(m+4)))

end

subplot(255)
imagesc(fLow,fHigh,AllR.Sal)
axis xy
axis square
% clim([-0.08 0.35]*1e-3)
title('Average saline')

subplot(2,5,10)
imagesc(fLow,fHigh,AllR.Flx)
axis xy
axis square
% clim([-0.08 0.35]*1e-3)
title('Average flx')


figure
bar(1,nanmean(nanmean(TotFzTime(1:4)')),'FaceColor',Cols{k}(1,:)), hold on
bar(2,nanmean(nanmean([TotFzTime(5:8)]')),'FaceColor',Cols{k}(2,:))
handles = plotSpread({([TotFzTime(1:4)']');([TotFzTime(5:8)']')},'distributionColors',[ 0 0 0;0 0 0]);
set(handles{1},'MarkerSize',10)
set(gca,'XTick',[1,2],'XTickLabel',{'Sal','Flx'}), ylim([0 0.8])
