%% Ripple detection
%INPUTINFO structure

clear all
GetRipShape=0;
SessNames={'UMazeCond' 'SleepPreUMaze' 'SleepPostUMaze'  'UMazeCondNight' 'SoundCond' 'SoundTest' };

for ss=1:length(SessNames)
    Dir=PathForExperimentsEmbReact(SessNames{ss});
    MouseToAvoid=[117,431]; % mice with noisy data to exclude
    Dir=RemoveElementsFromDir(Dir,'nmouse',MouseToAvoid);
    disp(SessNames{ss})
    for d=1:length(Dir.path)
        Allrips=[];
        for dd=1:length(Dir.path{d})
            cd(Dir.path{d}{dd})
            
            if  not(isempty(Dir.ExpeInfo{d}{dd}.Ripples)) & not(isnan(Dir.ExpeInfo{d}{dd}.Ripples))
                if Dir.ExpeInfo{d}{dd}.SleepSession==0
                    load('behavResources_SB.mat')
                    Go = not(isempty(Start(Behav.FreezeEpoch)));
                else
                    Go=1;
                end
                
                if Go
                    cd(Dir.path{d}{dd})
                    disp(Dir.path{d}{dd})
                    
                    if Dir.ExpeInfo{d}{dd}.SleepSession==0
                        clear SleepyEpoch
                        load('behavResources_SB.mat')
                        if not(isempty(Behav.FreezeAccEpoch))
                            Behav.FreezeEpoch=Behav.FreezeAccEpoch;
                        end
                        load('StateEpochSB.mat','TotalNoiseEpoch','SleepyEpoch')
                        RemovEpoch=or(or(TTLInfo.StimEpoch,TotalNoiseEpoch),SleepyEpoch);
                    end
                    
                    load('Ripples.mat')
                    if GetRipShape
                        load('ChannelsToAnalyse/dHPC_rip.mat')
                        load(['LFPData/LFP',num2str(channel),'.mat'])
                        
                        if size(RipplesR,1)>1
                            [M,T]=PlotRipRaw(LFP,RipplesR(:,2)/1e3,100,0,0);
                            Allrips=[Allrips;T];
                        end
                    end
                    load('H_VHigh_Spectrum.mat')
                    Sptsd=tsd(Spectro{2}*1e4,Spectro{1});
                    %
                    Riptsd=ts(RipplesR(:,2)*10);
                    if ss==1
                        %% On the shock side
                        LitEp=and(Behav.FreezeEpoch,Behav.ZoneEpoch{1})-RemovEpoch;
                        if not(isempty(Start(LitEp)))
                            NumRip.Shock{d}(dd)=length(Range(Restrict(Riptsd,LitEp)));
                            DurPer.Shock{d}(dd)=nansum(Stop(LitEp,'s')-Start(LitEp,'s'));
                            Spec.Shock{d}(dd,:)=nanmean(Data(Restrict(Sptsd,LitEp)));
                        else
                            NumRip.Shock{d}(dd)=NaN;
                            DurPer.Shock{d}(dd)=NaN;
                            Spec.Shock{d}(dd,:)=nan(1,length(Spectro{3}));
                        end
                        
                        %% On the safe side
                        LitEp=and(Behav.FreezeEpoch,or(Behav.ZoneEpoch{2},Behav.ZoneEpoch{5}))-RemovEpoch;
                        if not(isempty(Start(LitEp)))
                            NumRip.Safe{d}(dd)=length(Range(Restrict(Riptsd,LitEp)));
                            DurPer.Safe{d}(dd)=nansum(Stop(LitEp,'s')-Start(LitEp,'s'));
                            Spec.Safe{d}(dd,:)=nanmean(Data(Restrict(Sptsd,LitEp)));
                        else
                            NumRip.Safe{d}(dd)=NaN;
                            DurPer.Safe{d}(dd)=NaN;
                            Spec.Safe{d}(dd,:)=nan(1,length(Spectro{3}));
                        end
                        
                    elseif ss==5
                        LitEp=Behav.FreezeEpoch-RemovEpoch;
                        if not(isempty(Start(LitEp)))
                            NumRip.Cond{d}(dd)=length(Range(Restrict(Riptsd,LitEp)));
                            DurPer.Cond{d}(dd)=nansum(Stop(LitEp,'s')-Start(LitEp,'s'));
                            Spec.Cond{d}(dd,:)=nanmean(Data(Restrict(Sptsd,LitEp)));
                        else
                            NumRip.Cond{d}(dd)=NaN;
                            DurPer.Cond{d}(dd)=NaN;
                            Spec.Cond{d}(dd,:)=nan(1,length(Spectro{3}));
                        end
                        
                    elseif ss==6
                        LitEp=and(Behav.FreezeEpoch,intervalSet(0,800*1e4))-RemovEpoch;
                        if not(isempty(Start(LitEp)))
                            NumRip.Test{d}(dd)=length(Range(Restrict(Riptsd,LitEp)));
                            DurPer.Test{d}(dd)=nansum(Stop(LitEp,'s')-Start(LitEp,'s'));
                            Spec.Test{d}(dd,:)=nanmean(Data(Restrict(Sptsd,LitEp)));
                        else
                            NumRip.Test{d}(dd)=NaN;
                            DurPer.Test{d}(dd)=NaN;
                            Spec.Test{d}(dd,:)=nan(1,length(Spectro{3}));
                        end
                        
                    elseif ss==4
                        %% On the shock side
                        LitEp=and(Behav.FreezeEpoch,Behav.ZoneEpoch{1})-RemovEpoch;
                        if not(isempty(Start(LitEp)))
                            NumRip.ShockNight{d}(dd)=length(Range(Restrict(Riptsd,LitEp)));
                            DurPer.ShockNight{d}(dd)=nansum(Stop(LitEp,'s')-Start(LitEp,'s'));
                            Spec.ShockNight{d}(dd,:)=nanmean(Data(Restrict(Sptsd,LitEp)));
                        else
                            NumRip.ShockNight{d}(dd)=NaN;
                            DurPer.ShockNight{d}(dd)=NaN;
                            Spec.ShockNight{d}(dd,:)=nan(1,length(Spectro{3}));
                        end
                        %% On the safe side
                        LitEp=and(Behav.FreezeEpoch,or(Behav.ZoneEpoch{2},Behav.ZoneEpoch{5}))-RemovEpoch;
                        if not(isempty(Start(LitEp)))
                            NumRip.SafeNight{d}(dd)=length(Range(Restrict(Riptsd,LitEp)));
                            DurPer.SafeNight{d}(dd)=nansum(Stop(LitEp,'s')-Start(LitEp,'s'));
                            Spec.SafeNight{d}(dd,:)=nanmean(Data(Restrict(Sptsd,LitEp)));
                        else
                            NumRip.SafeNight{d}(dd)=NaN;
                            DurPer.SafeNight{d}(dd)=NaN;
                            Spec.SafeNight{d}(dd,:)=nan(1,length(Spectro{3}));
                        end
                    elseif ss==2
                        load('StateEpochSB.mat','TotalNoiseEpoch','SWSEpoch')
                        if not(isempty(Start(SWSEpoch)))
                            NumRip.SleepPre{d}(dd)=length(Range(Restrict(Riptsd,SWSEpoch)));
                            DurPer.SleepPre{d}(dd)=nansum(Stop(SWSEpoch,'s')-Start(SWSEpoch,'s'));
                            Spec.SleepPre{d}(dd,:)=nanmean(Data(Restrict(Sptsd,SWSEpoch)));
                        else
                            NumRip.SleepPre{d}(dd)=NaN;
                            DurPer.SleepPre{d}(dd)=NaN;
                            Spec.SleepPre{d}(dd,:)=nan(1,length(Spectro{3}));
                        end
                    elseif ss==3
                        load('StateEpochSB.mat','TotalNoiseEpoch','SWSEpoch')
                        if not(isempty(Start(SWSEpoch)))
                            NumRip.SleepPost{d}(dd)=length(Range(Restrict(Riptsd,SWSEpoch)));
                            DurPer.SleepPost{d}(dd)=nansum(Stop(SWSEpoch,'s')-Start(SWSEpoch,'s'));
                            Spec.SleepPost{d}(dd,:)=nanmean(Data(Restrict(Sptsd,SWSEpoch)));
                        else
                            NumRip.SleepPost{d}(dd)=NaN;
                            DurPer.SleepPost{d}(dd)=NaN;
                            Spec.SleepPost{d}(dd,:)=nan(1,length(Spectro{3}));
                        end
                        
                    end
                    
                end
            end
        end
        %         if ss==1
        %             RipShape.UMaze{d}=Allrips;
        %         elseif ss==2
        %             RipShape.Cond{d}=Allrips;
        %         elseif ss==3
        %             RipShape.Test{d}=Allrips;
        %         elseif ss==4
        %             RipShape.UMazeNight{d}=Allrips;
        %         end
        %         clear T
    end
end

figure
FreqRipUMaze=[];DurFzMaze=[];
for d=1:length(NumRip.Shock)
    if not(isempty(DurPer.Shock{d})) | not(isempty(DurPer.Safe{d}))
        FreqRipUMaze=[FreqRipUMaze;[ nansum(NumRip.Safe{d})./ nansum(DurPer.Safe{d}), nansum(NumRip.Shock{d})./ nansum(DurPer.Shock{d})]];
        DurFzMaze=[DurFzMaze;[ nansum(DurPer.Safe{d}),nansum(DurPer.Shock{d})]]
    end
end
FreqRipUMazeNight=[];DurFzMazeNight=[];
for d=1:length(NumRip.ShockNight)
    if not(isempty(DurPer.ShockNight{d})) | not(isempty(DurPer.SafeNight{d}))
        FreqRipUMazeNight=[FreqRipUMazeNight;[ nansum(NumRip.SafeNight{d})./ nansum(DurPer.SafeNight{d}), nansum(NumRip.ShockNight{d})./ nansum(DurPer.ShockNight{d})]];
        DurFzMazeNight=[DurFzMazeNight;[ nansum(DurPer.SafeNight{d}),nansum(DurPer.ShockNight{d})]]
    end
end
FreqRipTest=[NumRip.Test{:}]./[DurPer.Test{:}];
FreqRipCond=[NumRip.Cond{:}]./[DurPer.Cond{:}];
FreqRipSleepPre=[NumRip.SleepPre{:}]./[DurPer.SleepPre{:}];
FreqRipSleepPost=[NumRip.SleepPost{:}]./[DurPer.SleepPost{:}];
clf
plotSpread({FreqRipUMaze(:,1),FreqRipUMaze(:,2),FreqRipCond,FreqRipTest,FreqRipSleepPre,FreqRipSleepPost},'showMM',4)
set(gca,'XTick',[1:6],'XTickLabel',{'UmazeSafe','UmazeShock','Cond','Test','SleepPre','SleepPost'})


figure
SpecShock=[];SpecSafe=[];
for d=1:length(Spec.Shock)
    if not(isempty(Spec.Shock{d})) | not(isempty(Spec.Shock{d}))
        SpecShock=[SpecShock;nanmean(Spec.Shock{d})./nanmean(nanmean(Spec.Shock{d}))];
        SpecSafe=[SpecSafe;nanmean(Spec.Safe{d})./nanmean(nanmean(Spec.Safe{d}))];
    end
end
SpecShockNight=[];SpecSafeNight=[];
for d=1:length(Spec.ShockNight)
    if not(isempty(Spec.ShockNight{d})) | not(isempty(Spec.ShockNight{d}))
        SpecShockNight=[SpecShockNight;nanmean(Spec.ShockNight{d})./nanmean(nanmean(Spec.ShockNight{d}))];
        SpecSafeNight=[SpecSafeNight;nanmean(Spec.SafeNight{d})./nanmean(nanmean(Spec.SafeNight{d}))];
    end
end
SpecTest=[reshape([Spec.Test{:}],length(Spectro{3}),8)]';
SpecCond=[reshape([Spec.Cond{:}],length(Spectro{3}),8)]';
SpecSleepPost=[reshape([Spec.SleepPost{:}],length(Spectro{3}),9)]';
SpecSleepPre=[reshape([Spec.SleepPre{:}],length(Spectro{3}),8)]';

figure
subplot(131)
plot(Spectro{3},runmean(nanmean(log(SpecSafe)),3),'b'), hold on
plot(Spectro{3},runmean(nanmean(log(SpecShock)),3),'r'),
g=shadedErrorBar(Spectro{3},runmean(nanmean(log(SpecSafe)),3),[stdError(log(SpecSafe));stdError(log(SpecSafe))],'b'), hold on
g=shadedErrorBar(Spectro{3},runmean(nanmean(log(SpecShock)),3),[stdError(log(SpecShock));stdError(log(SpecShock))],'r'), hold on
% subplot(132)
% g=shadedErrorBar(Spectro{3},nanmean(log(SpecSafeNight)),[stdError(log(SpecSafeNight));stdError(log(SpecSafeNight))],'b'), hold on
% g=shadedErrorBar(Spectro{3},nanmean(log(SpecShockNight)),[stdError(log(SpecShockNight));stdError(log(SpecShockNight))],'r'), hold on
legend('safe','shock')
title('UMaze')
box off
subplot(132)
plot(Spectro{3},runmean(nanmean(log(SpecTest)),3),'b'), hold on
plot(Spectro{3},runmean(nanmean(log(SpecCond)),3),'r'),
g=shadedErrorBar(Spectro{3},runmean(nanmean(log(SpecTest)),3),[stdError(log(SpecTest));stdError(log(SpecTest))],'b'), hold on
g=shadedErrorBar(Spectro{3},runmean(nanmean(log(SpecCond)),3),[stdError(log(SpecCond));stdError(log(SpecCond))],'r'), hold on
legend('test','cond')
title('SoundCond')
box off
subplot(133)
plot(Spectro{3},runmean(nanmean(log(SpecSleepPre)),3),'b'), hold on
plot(Spectro{3},runmean(nanmean(log(SpecSleepPost)),3),'r'),
g=shadedErrorBar(Spectro{3},runmean(nanmean(log(SpecSleepPre)),3),[stdError(log(SpecSleepPre));stdError(log(SpecSleepPre))],'b'), hold on
g=shadedErrorBar(Spectro{3},runmean(nanmean(log(SpecSleepPost)),3),[stdError(log(SpecSleepPost));stdError(log(SpecSleepPost))],'r'), hold on
legend('sleep1','sleep2')
title('Sleep')
box off

