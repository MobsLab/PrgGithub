clear all
load('/media/nas8-2/ProjetEmbReact/transfer/AllSessions_BM.mat')
Group=[7 8];
for group=1:length(Group)
    Mouse=Drugs_Groups_UMaze_BM(Group(group));
    for mouse=1:length(Mouse)
        Mouse_names{mouse}=['M' num2str(Mouse(mouse))];
        
        Path{group}{mouse} = CondSess.(Mouse_names{mouse});
    end
end

for group = 1:2
    for mouse = 1:length(Path{group})
        for folder = 1:length(Path{group}{mouse})
            disp(Path{group}{mouse}{folder})
            cd(Path{group}{mouse}{folder})
            % Clean Up OB
            load('ChannelsToAnalyse/Bulb_deep.mat')
            CleanVHCStimLFPS(Path{group}{mouse}{folder},channel)
            % Recalculate spectrum
             LowSpectrumSB(Path{group}{mouse}{folder},['LFP',num2str(channel),'_VHCClean'],'B_vHC_Clean');
        end
    end
end

clear Respi LinPos FreezeEpoch Spec_Clean Spec
for group = 1:2
    for mouse = 1:length(Path{group})
        
        Spec_Clean{group}{mouse} = ConcatenateDataFromFolders_SB(Path{group}{mouse},'spectrum','prefix','B_vHC_Clean_Low');
        Spec{group}{mouse} = ConcatenateDataFromFolders_SB(Path{group}{mouse},'spectrum','prefix','B_Low');
        FreezeEpoch{group}{mouse} = ConcatenateDataFromFolders_SB(Path{group}{mouse},'epoch','epochname','freezeepoch');
        LinPos{group}{mouse} = ConcatenateDataFromFolders_SB(Path{group}{mouse},'linpos_sampetps');
        Respi{group}{mouse} = ConcatenateDataFromFolders_SB(Path{group}{mouse},'respi_freq_bm_clean');
        
       
       end
end



%%
LimResp =4.5;
for group = 1:2
    for mouse = 1:length(Path{group})
        
        SafeFreeze = and(FreezeEpoch{group}{mouse} ,thresholdIntervals(LinPos{group}{mouse},0.6,'Direction','Above'));
        ShockFreeze = and(FreezeEpoch{group}{mouse} ,thresholdIntervals(LinPos{group}{mouse},0.4,'Direction','Below'));
        
        CleanSpec_Sf{group}(mouse,:) = nanmean((Data(Restrict(Spec_Clean{group}{mouse},SafeFreeze))));
        CleanSpec_Sk{group}(mouse,:) = nanmean((Data(Restrict(Spec_Clean{group}{mouse},ShockFreeze))));
        
        DirtySpec_Sf{group}(mouse,:) = nanmean((Data(Restrict(Spec{group}{mouse},and(FreezeEpoch{group}{mouse} ,SafeFreeze)))));
        DirtySpec_Sk{group}(mouse,:) = nanmean((Data(Restrict(Spec{group}{mouse},and(FreezeEpoch{group}{mouse} ,ShockFreeze)))));
        
        DurHighBreathFz{group}(mouse) = sum(Data(Restrict(Respi{group}{mouse},FreezeEpoch{group}{mouse}))>LimResp);
        DurLowBreathFz{group}(mouse) = sum(Data(Restrict(Respi{group}{mouse},FreezeEpoch{group}{mouse}))<LimResp);

    end
end
    
figure
clf
plot(DurHighBreathFz{1},  DurLowBreathFz{1},'.')
hold on
plot(DurHighBreathFz{2},  DurLowBreathFz{2},'r.')
set(gca,'XScale','log','YScale','log')
makepretty

[AllDat.Rip{1},AllDat.Rip{2}] = GetStressScoreValuesRippleCtrlInhib_UMaze;


figure
subplot(121)
shadedErrorBar(Spectro{3},nanmean(CleanSpec_Sk{1}),stdError(CleanSpec_Sk{1}))
hold on
shadedErrorBar(Spectro{3},nanmean(CleanSpec_Sk{2}),stdError(CleanSpec_Sk{2}),'r')

subplot(122)
shadedErrorBar(Spectro{3},nanmean(CleanSpec_Sf{1}),stdError(CleanSpec_Sf{1}))
hold on
shadedErrorBar(Spectro{3},nanmean(CleanSpec_Sf{2}),stdError(CleanSpec_Sf{2}),'b')

figure
subplot(121)
shadedErrorBar(Spectro{3},nanmean(DirtySpec_Sk{1}),stdError(DirtySpec_Sk{1}))
hold on
shadedErrorBar(Spectro{3},nanmean(DirtySpec_Sk{2}),stdError(DirtySpec_Sk{2}),'r')

subplot(122)
shadedErrorBar(Spectro{3},nanmean(DirtySpec_Sf{1}),stdError(DirtySpec_Sf{1}))
hold on
shadedErrorBar(Spectro{3},nanmean(DirtySpec_Sf{2}),stdError(DirtySpec_Sf{2}),'b')


for group = 1:2
    for mouse = 1:length(Path{group})
CleanSpec_Sf1{group}(mouse,:) = CleanSpec_Sf{group}(mouse,:) ./ nansum(CleanSpec_Sf{group}(mouse,20:end) );
CleanSpec_Sk1{group}(mouse,:) = CleanSpec_Sk{group}(mouse,:) ./ nansum(CleanSpec_Sk{group}(mouse,20:end) );
    end
end

figure
subplot(121)
shadedErrorBar(Spectro{3},nanmean(CleanSpec_Sk1{1}),stdError(CleanSpec_Sk1{1}))
hold on
shadedErrorBar(Spectro{3},nanmean(CleanSpec_Sk1{2}),stdError(CleanSpec_Sk1{2}),'r')

subplot(122)
shadedErrorBar(Spectro{3},nanmean(CleanSpec_Sf1{1}),stdError(CleanSpec_Sf1{1}))
hold on
shadedErrorBar(Spectro{3},nanmean(CleanSpec_Sf1{2}),stdError(CleanSpec_Sf1{2}),'b')


figure
subplot(121)
shadedErrorBar(Spectro{3},nanmean(CleanSpec_Sk1{1}),stdError(CleanSpec_Sk1{1}),'m')
hold on
shadedErrorBar(Spectro{3},nanmean(CleanSpec_Sf1{1}),stdError(CleanSpec_Sf1{1}),'c')

subplot(122)
shadedErrorBar(Spectro{3},nanmean(CleanSpec_Sk1{2}),stdError(CleanSpec_Sk1{2}),'r')
hold on
shadedErrorBar(Spectro{3},nanmean(CleanSpec_Sf1{2}),stdError(CleanSpec_Sf1{2}),'b')


%%
clear Respi LinPos FreezeEpoch
for group = 1:2
    for mouse = 1:length(Path{group})
        
        
        %         plot(nanmean(Data(Restrict(Spec_Clean,and(FreezeEpoch,thresholdIntervals(LinPos,0.5,'Direction','Above'))))))
        %         hold on,
        %         plot(nanmean(Data(Restrict(Spec,and(FreezeEpoch,thresholdIntervals(LinPos,0.5,'Direction','Above'))))))
        %
        dat = (Data(Restrict(Spec_Clean,and(FreezeEpoch{group}{mouse} ,thresholdIntervals(LinPos{group}{mouse},0.5,'Direction','Above')))));
        CleanSpec_Sf{group}(mouse,:) = nanmean(dat(end/2:end));
        dat = (Data(Restrict(Spec_Clean,and(FreezeEpoch{group}{mouse} ,thresholdIntervals(LinPos{group}{mouse},0.5,'Direction','Below')))));
        CleanSpec_Sk{group}(mouse,:) = nanmean(dat(end/2:end));
        

    end
end