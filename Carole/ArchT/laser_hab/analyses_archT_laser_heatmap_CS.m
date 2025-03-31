%% for all ArchT mice
clear all
Mice=[915,916,917,918,919,920];
type=[{' ArchT'},{' ArchT'},{' ArchT'},{' ArchT'},{' mCherry'},{' mCherry'}]
ordre=[1,2,4,5,3,6];
figure

for i=1:length(Mice)
    %go to mouse folder
    clear ModIndx
    clear DigTSD
    clear FiringOff
    clear FiringOn
    clear FiringInClose
    mouse_num=Mice(i);
    path=strcat('/media/gruffalo/09E7077B1FE07CCB/ARCHT/ArchT/', num2str(mouse_num), '/laser_hab'); % /!\ a modifier !!!!!!!
    cd(path);
    [numNeurons, numtt, TT]=GetSpikesFromStructure('PFCx', 'remove_MUA',1);
    load('SpikeData.mat');
    %%
    load('LFPData/DigInfo9.mat');

    StimOn = thresholdIntervals(DigTSD,0.9,'Direction','Above');
    StimOff = intervalSet(0,900*1e4)-StimOn;
    %StimOnClose = intervalSet(Start(StimOn),Start(StimOn)+1*1e4);
    clear RemResp
    %%
    for sp = 1:length(numNeurons)
    [Y,X] = hist(Range(S{numNeurons(sp)},'s'),[0:0.1:900]);
    PETHtsd = tsd([0:0.1:900]*1e4,Y');
    
    %subplot(211)
    %plot(X,zscore(Y)), hold on
    %plot(Range(DigTSD,'s'),Data(DigTSD))
    %subplot(212)
    [M,T]=PlotRipRaw(PETHtsd,Start(StimOn,'s'),90000,0,0);
    %plot(M(:,1),M(:,2))
    %TetName(sp) = TT{sp}(1);
    RemResp(sp,:) = M(:,2);
    %line([0 0],ylim,'color','k'),line([45 45],ylim,'color','k')
    FiringOff(sp) = length(Range(Restrict(S{numNeurons(sp)},StimOff)))./sum(Stop(StimOff,'s')-Start(StimOff,'s'));
    FiringOn(sp) = length(Range(Restrict(S{numNeurons(sp)},StimOn)))./sum(Stop(StimOn,'s')-Start(StimOn,'s'));
    
    %FiringOnClose(sp) = length(Range(Restrict(S{numNeurons(sp)},StimOnClose)))./sum(Stop(StimOnClose,'s')-Start(StimOnClose,'s'));
    end
    %%
    ModIndx = ((FiringOn-FiringOff)./(FiringOn+FiringOff));
    subplot(2,3,ordre(i))
    imagesc(M(:,1),1:length(FiringOff),SmoothDec(sortrows([ModIndx',ZScoreWiWindowSB(RemResp,[700:850])]),[0.1,3]))
    xlim([-25 65])
    clim([-2 2])
    line([0 0],ylim,'linewidth',2,'color',[0.55 0 0])
    line([45 45],ylim,'linewidth',2,'color',[0.3 0.3 0.3])
    colormap redblue
    title(strcat(num2str(mouse_num),',  ',type{i}))
    xlabel('time (s)')
    ylabel('units')
end


    
    
    
  