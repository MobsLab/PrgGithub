clear all
clear ZoneTime
BefTime=15*1e4;
tps=[0:0.01:BefTime*2/1e4];
StepBackFromStart=0.5*1e4;

SessTypes={'UMazeCond','UMazeCond_EyeShock','UMazeCondBlockedShock_EyeShock','UMazeCondBlockedSafe_EyeShock',...
    'UMazeCondExplo_PreDrug' 'UMazeCondBlockedShock_PreDrug' 'UMazeCondBlockedSafe_PreDrug' ...
    'UMazeCondExplo_PostDrug' 'UMazeCondBlockedShock_PostDrug' 'UMazeCondBlockedSafe_PostDrug'};
PostStim.ToShockMov=[];PostStim.ToShockType=[];PostStim.ToShockPos=[];
PostStim.ToShockOBWv=[];PostStim.ToShockOBPt=[];PostStim.ToShockFz=[];
PostStim.MouseID = []; PostStim.ToShockOBSpec = [];
PostStim.Ripples = [];

EpNum = 1;

for ss=1:length(SessTypes)
    MouseToAvoid=[117,431]; % mice with noisy data to exclude
    Files=PathForExperimentsEmbReact([SessTypes{ss}]);
    Files=RemoveElementsFromDir(Files,'nmouse',MouseToAvoid);
    
    
    for mm=1:length(Files.path)-1
        
        
        for c=1:length(Files.path{mm})
            try
                cd(Files.path{mm}{c})
                clear Behav LocalFreq Spectro
                load('behavResources_SB.mat')
                
                
                if isfield(TTLInfo,'StimEpoch')
                    if isempty(Behav.FreezeAccEpoch)
                        Behav.FreezeAccEpoch = Behav.FreezeEpoch;
                        Behav.MovAcctsd = Behav.Vtsd;
                    end
                    
                    tpsfz = [0:1:max(Range(Behav.MovAcctsd,'s'))]'*1E4;
                    dat = hist(Range(Restrict(Behav.MovAcctsd,Behav.FreezeAccEpoch),'s'),[0:1:max(Range(Behav.MovAcctsd,'s'))]);
                    Freezetsd = tsd(tpsfz',dat');
                    
                    load('InstFreqAndPhase_B.mat')
                    load('B_Low_Spectrum.mat')
                    Sptsd = tsd(Spectro{2}*1E4,Spectro{1});
                    
                    if exist('Ripples.mat')>0
                        load('Ripples.mat')
                        dat = hist(Range(Restrict(Behav.MovAcctsd,RipplesEpochR),'s'),[0:1:max(Range(Behav.MovAcctsd,'s'))]);
                        Ripplestsd = tsd(tpsfz',dat');
                    else
                        Ripplestsd = tsd(tpsfz',tpsfz'*NaN);
                    end
                    
                    if exist('HeartBeatInfo.mat')>0
                        load('HeartBeatInfo.mat')
                        HBRate = EKG.HBRate;
                    else
                        HBRate = tsd(tpsfz',tpsfz'*NaN);
                    end
                    
                    % Shock
                    if not(isempty(Start(TTLInfo.StimEpoch)))
                        SmooDiffLinDist=tsd(Range(Behav.LinearDist),[0;diff(runmean(Data(Behav.LinearDist),20))]);
                        %                 tpsout=FindClosestZeroCross(Start(Behav.RAEpoch.ToShock)-StepBackFromStart,SmooDiffLinDist,1);
                        tpsout = Start(TTLInfo.StimEpoch);
                        for t=1:length(tpsout)
                            try
                                
                                LitEp=intervalSet(tpsout(t)-BefTime,tpsout(t)+BefTime);
                                dattemp=interp1(Range(Restrict(Behav.Vtsd,LitEp))-Start(LitEp),Data(Restrict(Behav.Vtsd,LitEp)),tps*1e4);
                                dattemp=interp1(Range(Restrict(SmooDiffLinDist,LitEp))-Start(LitEp),Data(Restrict(Behav.LinearDist,LitEp)),tps*1e4);
                                dattemp=interp1(Range(Restrict(Freezetsd,LitEp))-Start(LitEp),Data(Restrict(Freezetsd,LitEp)),tps*1e4);
                                dattemp=interp1(Range(Restrict(LocalFreq.PT,LitEp))-Start(LitEp),Data(Restrict(LocalFreq.PT,LitEp)),tps*1e4);
                                dattemp=interp1(Range(Restrict(LocalFreq.WV,LitEp))-Start(LitEp),Data(Restrict(LocalFreq.WV,LitEp)),tps*1e4);
                                dattemp=interp1(Range(Restrict(Sptsd,LitEp))-Start(LitEp),Data(Restrict(Sptsd,LitEp)),tps*1e4);
                                dattemp=interp1(Range(Restrict(Ripplestsd,LitEp))-Start(LitEp),Data(Restrict(Ripplestsd,LitEp)),tps*1e4);
                                dattemp=interp1(Range(Restrict(HBRate,LitEp))-Start(LitEp),Data(Restrict(HBRate,LitEp)),tps*1e4);
                                
                                PostStim.ToShockType(EpNum) = Behav.RAUser.ToShock(t);
                                PostStim.MouseID(EpNum) = Files.ExpeInfo{mm}{c}.nmouse;
                                
                                dattemp=interp1(Range(Restrict(Behav.Vtsd,LitEp))-Start(LitEp),Data(Restrict(Behav.Vtsd,LitEp)),tps*1e4);
                                PostStim.ToShockMov(EpNum,:) = dattemp;
                                
                                dattemp=interp1(Range(Restrict(SmooDiffLinDist,LitEp))-Start(LitEp),Data(Restrict(Behav.LinearDist,LitEp)),tps*1e4);
                                PostStim.ToShockPos(EpNum,:) = dattemp;
                                
                                dattemp=interp1(Range(Restrict(Freezetsd,LitEp))-Start(LitEp),Data(Restrict(Freezetsd,LitEp)),tps*1e4);
                                PostStim.ToShockFz(EpNum,:) = dattemp;
                                
                                dattemp=interp1(Range(Restrict(LocalFreq.PT,LitEp))-Start(LitEp),Data(Restrict(LocalFreq.PT,LitEp)),tps*1e4);
                                PostStim.ToShockOBPt(EpNum,:) = dattemp;
                                
                                dattemp=interp1(Range(Restrict(LocalFreq.WV,LitEp))-Start(LitEp),Data(Restrict(LocalFreq.WV,LitEp)),tps*1e4);
                                PostStim.ToShockOBWv(EpNum,:) = dattemp;
                                
                                dattemp=interp1(Range(Restrict(Sptsd,LitEp))-Start(LitEp),Data(Restrict(Sptsd,LitEp)),tps*1e4);
                                PostStim.ToShockOBSpec(EpNum,:,:) = dattemp;
                                
                                dattemp=interp1(Range(Restrict(Ripplestsd,LitEp))-Start(LitEp),Data(Restrict(Ripplestsd,LitEp)),tps*1e4);
                                PostStim.Ripples(EpNum,:) = dattemp;
                                
                                dattemp=interp1(Range(Restrict(HBRate,LitEp))-Start(LitEp),Data(Restrict(HBRate,LitEp)),tps*1e4);
                                PostStim.HB(EpNum,:) = dattemp;
                                
                                EpNum = EpNum+1;
                                
                            end
                        end
                    end
                end
            end
        end
    end
end

cd /media/nas6/ProjetEmbReact
save('FzSHock','PostStim','-v7.3')
%%
OBFreq = (movmedian(PostStim.ToShockOBPt,100,2) +movmedian(PostStim.ToShockOBWv,100,2)  )/2;
tps=[0:0.01:BefTime/1E4*2];

figure
RAlevel = 1;
FreezeProp = nanmean(PostStim.ToShockFz(:,1500:end)');
EventsToUse  = find(PostStim.ToShockType>=RAlevel & FreezeProp>-1);
subplot(611)
plot(tps(100:end-100)-BefTime/1E4,nanmean(PostStim.ToShockPos(EventsToUse,100:end-100))')
ylabel('Linear position')
xlabel('time (s)')
xlim([-BefTime BefTime]/1E4)

subplot(612)
plot(tps(100:end-100)-BefTime/1E4,nanmean(PostStim.ToShockMov(EventsToUse,100:end-100))')
ylabel('Speed')
xlabel('time (s)')
xlim([-BefTime BefTime]/1E4)

subplot(613)
bar(tps(100:end-100)-BefTime/1E4,nanmean(PostStim.ToShockFz(EventsToUse,100:end-100))')
ylabel('Frezing level')
xlabel('time (s)')
xlim([-BefTime BefTime]/1E4)

subplot(614)
plot(tps(100:end-100)-BefTime/1E4,nanmean(PostStim.HB(EventsToUse,100:end-100))')
ylabel('Hear rate')
xlabel('time (s)')
xlim([-BefTime BefTime]/1E4)

subplot(615)
plot(tps(100:end-100)-BefTime/1E4,nanmean(OBFreq(EventsToUse,100:end-100))')
ylabel('OB frequency')
xlabel('time (s)')
xlim([-BefTime BefTime]/1E4)

subplot(616)
plot(tps(100:end-100)-BefTime/1E4,nanmean(PostStim.Ripples(EventsToUse,100:end-100))')
ylabel('Ripple density')
xlabel('time (s)')
xlim([-BefTime BefTime]/1E4)


EventsToUse  = find(PostStim.ToShockType>=RAlevel & FreezeProp>2);

PostFreeze.HB = [];
PostFreeze.Ripple = [];
PostFreeze.OB = [];
FzDur = [];
for ev = 1:length(EventsToUse)
    
    PostFreeze.HB = [PostFreeze.HB,nanmean(PostStim.HB(EventsToUse(ev),PostStim.ToShockFz(EventsToUse(ev),:)>1))];
    PostFreeze.Ripple = [PostFreeze.Ripple,nanmean(PostStim.Ripples(EventsToUse(ev),PostStim.ToShockFz(EventsToUse(ev),:)>1))];
    PostFreeze.OB = [PostFreeze.OB,nanmean(OBFreq(EventsToUse(ev),PostStim.ToShockFz(EventsToUse(ev),:)>1))];
    FzDur = [FzDur,nansum(PostStim.ToShockFz(EventsToUse(ev),:))];
    
end


figure
subplot(131)
MakeSpreadAndBoxPlot_SB({PostFreeze.HB,PostFreeze.HB},{},[],{},1,0)
xlim([1 3])
ylim([0 15])
set(gca,'XTick',[])
ylabel('HR (Hz)')

subplot(132)
MakeSpreadAndBoxPlot_SB({PostFreeze.Ripple,PostFreeze.Ripple},{},[],{},1,0)
xlim([1 3])
ylim([0 2])
set(gca,'XTick',[])
ylabel('Ripples/s ')

subplot(133)
MakeSpreadAndBoxPlot_SB({PostFreeze.OB,PostFreeze.OB},{},[],{},1,0)
xlim([1 3])
ylim([0 8])
set(gca,'XTick',[])
ylabel('OB (Hz)')



figure
scatter3(PostFreeze.HB,PostFreeze.Ripple,PostFreeze.OB,100,FzDur,'filled')

figure
plot(PostFreeze.OB,FzDur,'.')

clf
for i = 1:length(EventsToUse)
    subplot(411)
    plot(tps-BefTime/1E4,PostStim.ToShockPos(EventsToUse(i),:))
    ylabel('Linear position')
    makepretty
    
    subplot(412)
    plot(tps-BefTime/1E4,PostStim.HB(EventsToUse(i),:))
    ylabel('heart rate')
    makepretty
    
    subplot(4,1,3:4)
    imagesc(tps-BefTime/1E4,1:20,log(squeeze(PostStim.ToShockOBSpec(EventsToUse(i),:,:)))'), axis xy
    ylabel('freq')
    makepretty
    pause
    clf
end


figure
FreezeProp = nanmean(PostStim.ToShockFz(:,3200:end)');
EventsToUse  = find(PostStim.ToShockType>=RAlevel & FreezeProp>2);
for ev = 1:length(EventsToUse)
   
Timing(ev) = find(PostStim.ToShockFz(EventsToUse(ev),3200:end)>0,1,'first');end
[val,ind] = sort(Timing);
EventsToUse = EventsToUse(ind);

figure
subplot(131)
imagesc(tps-BefTime/1E4,1:45,OBFreq(EventsToUse,:).*double(PostStim.ToShockFz(EventsToUse,:)>0))
colormap([[0,0,0];jet(10)])
caxis([1 6])
 xlabel('time (s)')
title('Ob freq')
ylabel('# RA event')

subplot(132)
imagesc(tps-BefTime/1E4,1:45,PostStim.HB(EventsToUse,:).*double(PostStim.ToShockFz(EventsToUse,:)>0))
colormap([[0,0,0];jet(10)])
caxis([8 13])
xlabel('time (s)')
title('heart rate')

subplot(133)
imagesc(tps-BefTime/1E4,1:45,PostStim.ToShockPos(EventsToUse,:).*double(PostStim.ToShockFz(EventsToUse,:)>0))
colormap([[0,0,0];jet(10)])
caxis([0 5])
xlabel('time (s)')
title('ripple freq')
ylabel('# RA event')
