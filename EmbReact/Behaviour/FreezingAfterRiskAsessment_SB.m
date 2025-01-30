clear all
clear ZoneTime
BefTime=30*1e4;
tps=[0:0.01:BefTime*2/1e4];
StepBackFromStart=0.5*1e4;

SessTypes={'UMazeCond','TestPost','Extinction','UMazeCond_EyeShock','UMazeCondBlockedShock_EyeShock','UMazeCondBlockedSafe_EyeShock','TestPost_EyeShock',...
    'UMazeCondExplo_PreDrug' 'UMazeCondBlockedShock_PreDrug' 'UMazeCondBlockedSafe_PreDrug' ...
    'UMazeCondExplo_PostDrug' 'UMazeCondBlockedShock_PostDrug' 'UMazeCondBlockedSafe_PostDrug',...
    'TestPost_PostDrug'};
RiskAsess.ToShockMov=[];RiskAsess.ToShockType=[];RiskAsess.ToShockPos=[];
RiskAsess.ToShockOBWv=[];RiskAsess.ToShockOBPt=[];RiskAsess.ToShockFz=[];
RiskAsess.MouseID = []; RiskAsess.ToShockOBSpec = [];
RiskAsess.Ripples = [];

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
                
                
                if isfield(Behav,'RAEpoch')
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
                    if not(isempty(Start(Behav.RAEpoch.ToShock)))
                        SmooDiffLinDist=tsd(Range(Behav.LinearDist),[0;diff(runmean(Data(Behav.LinearDist),20))]);
                        %                 tpsout=FindClosestZeroCross(Start(Behav.RAEpoch.ToShock)-StepBackFromStart,SmooDiffLinDist,1);
                        tpsout = Start(Behav.RAEpoch.ToShock);
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
                                
                                RiskAsess.ToShockType(EpNum) = Behav.RAUser.ToShock(t);
                                RiskAsess.MouseID(EpNum) = Files.ExpeInfo{mm}{c}.nmouse;
                                
                                dattemp=interp1(Range(Restrict(Behav.Vtsd,LitEp))-Start(LitEp),Data(Restrict(Behav.Vtsd,LitEp)),tps*1e4);
                                RiskAsess.ToShockMov(EpNum,:) = dattemp;
                                
                                dattemp=interp1(Range(Restrict(SmooDiffLinDist,LitEp))-Start(LitEp),Data(Restrict(Behav.LinearDist,LitEp)),tps*1e4);
                                RiskAsess.ToShockPos(EpNum,:) = dattemp;
                                
                                dattemp=interp1(Range(Restrict(Freezetsd,LitEp))-Start(LitEp),Data(Restrict(Freezetsd,LitEp)),tps*1e4);
                                RiskAsess.ToShockFz(EpNum,:) = dattemp;
                                
                                dattemp=interp1(Range(Restrict(LocalFreq.PT,LitEp))-Start(LitEp),Data(Restrict(LocalFreq.PT,LitEp)),tps*1e4);
                                RiskAsess.ToShockOBPt(EpNum,:) = dattemp;
                                
                                dattemp=interp1(Range(Restrict(LocalFreq.WV,LitEp))-Start(LitEp),Data(Restrict(LocalFreq.WV,LitEp)),tps*1e4);
                                RiskAsess.ToShockOBWv(EpNum,:) = dattemp;
                                
                                dattemp=interp1(Range(Restrict(Sptsd,LitEp))-Start(LitEp),Data(Restrict(Sptsd,LitEp)),tps*1e4);
                                RiskAsess.ToShockOBSpec(EpNum,:,:) = dattemp;
                                
                                dattemp=interp1(Range(Restrict(Ripplestsd,LitEp))-Start(LitEp),Data(Restrict(Ripplestsd,LitEp)),tps*1e4);
                                RiskAsess.Ripples(EpNum,:) = dattemp;
                                
                                dattemp=interp1(Range(Restrict(HBRate,LitEp))-Start(LitEp),Data(Restrict(HBRate,LitEp)),tps*1e4);
                                RiskAsess.HB(EpNum,:) = dattemp;
                                
                                EpNum = EpNum+1;
                                
                            end
                        end
                    end
                end
            end
        end
    end
end


%%
OBFreq = (movmedian(RiskAsess.ToShockOBPt,100,2) +movmedian(RiskAsess.ToShockOBWv,100,2)  )/2;
tps=[0:0.01:BefTime/1E4*2];

figure
RAlevel = 1;
FreezeProp = nanmean(RiskAsess.ToShockFz(:,1500:end)');
EventsToUse  = find(RiskAsess.ToShockType>=RAlevel & FreezeProp>-1);
subplot(611)
plot(tps(100:end-100)-BefTime/1E4,nanmean(RiskAsess.ToShockPos(EventsToUse,100:end-100))')
ylabel('Linear position')
xlabel('time (s)')
xlim([-BefTime BefTime]/1E4)

subplot(612)
plot(tps(100:end-100)-BefTime/1E4,nanmean(RiskAsess.ToShockMov(EventsToUse,100:end-100))')
ylabel('Speed')
xlabel('time (s)')
xlim([-BefTime BefTime]/1E4)

subplot(613)
bar(tps(100:end-100)-BefTime/1E4,nanmean(RiskAsess.ToShockFz(EventsToUse,100:end-100))')
ylabel('Frezing level')
xlabel('time (s)')
xlim([-BefTime BefTime]/1E4)

subplot(614)
plot(tps(100:end-100)-BefTime/1E4,nanmean(RiskAsess.HB(EventsToUse,100:end-100))')
ylabel('Hear rate')
xlabel('time (s)')
xlim([-BefTime BefTime]/1E4)

subplot(615)
plot(tps(100:end-100)-BefTime/1E4,nanmean(OBFreq(EventsToUse,100:end-100))')
ylabel('OB frequency')
xlabel('time (s)')
xlim([-BefTime BefTime]/1E4)

subplot(616)
plot(tps(100:end-100)-BefTime/1E4,nanmean(RiskAsess.Ripples(EventsToUse,100:end-100))')
ylabel('Ripple density')
xlabel('time (s)')
xlim([-BefTime BefTime]/1E4)


EventsToUse  = find(RiskAsess.ToShockType>=RAlevel & FreezeProp>2);

PostFreeze.HB = [];
PostFreeze.Ripple = [];
PostFreeze.OB = [];
FzDur = [];
for ev = 1:length(EventsToUse)
    
    PostFreeze.HB = [PostFreeze.HB,nanmean(RiskAsess.HB(EventsToUse(ev),RiskAsess.ToShockFz(EventsToUse(ev),:)>1))];
    PostFreeze.Ripple = [PostFreeze.Ripple,nanmean(RiskAsess.Ripples(EventsToUse(ev),RiskAsess.ToShockFz(EventsToUse(ev),:)>1))];
    PostFreeze.OB = [PostFreeze.OB,nanmean(OBFreq(EventsToUse(ev),RiskAsess.ToShockFz(EventsToUse(ev),:)>1))];
    FzDur = [FzDur,nansum(RiskAsess.ToShockFz(EventsToUse(ev),:))];
    
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
    plot(tps-BefTime/1E4,RiskAsess.ToShockPos(EventsToUse(i),:))
    ylabel('Linear position')
    makepretty
    
    subplot(412)
    plot(tps-BefTime/1E4,RiskAsess.HB(EventsToUse(i),:))
    ylabel('heart rate')
    makepretty
    
    subplot(4,1,3:4)
    imagesc(tps-BefTime/1E4,1:20,log(squeeze(RiskAsess.ToShockOBSpec(EventsToUse(i),:,:)))'), axis xy
    ylabel('freq')
    makepretty
    pause
    clf
end


figure
FreezeProp = nanmean(RiskAsess.ToShockFz(:,3200:end)');
EventsToUse  = find(RiskAsess.ToShockType>=RAlevel & FreezeProp>2);
for ev = 1:length(EventsToUse)
   
Timing(ev) = nanmean(OBFreq(EventsToUse(ev),3200:end));
end
[val,ind] = sort(Timing);
EventsToUse = EventsToUse(ind);

figure
subplot(131)
imagesc(tps-BefTime/1E4,1:45,OBFreq(EventsToUse,:).*double(RiskAsess.ToShockFz(EventsToUse,:)>0))
colormap([[0,0,0];jet(10)])
caxis([1 6])
 xlabel('time (s)')
title('Ob freq')
ylabel('# RA event')

subplot(132)
imagesc(tps-BefTime/1E4,1:45,RiskAsess.HB(EventsToUse,:).*double(RiskAsess.ToShockFz(EventsToUse,:)>0))
colormap([[0,0,0];jet(10)])
caxis([8 13])
xlabel('time (s)')
title('heart rate')

subplot(133)
imagesc(tps-BefTime/1E4,1:45,RiskAsess.Ripples(EventsToUse,:).*double(RiskAsess.ToShockFz(EventsToUse,:)>0))
colormap([[0,0,0];jet(10)])
caxis([0 5])
xlabel('time (s)')
title('ripple freq')
ylabel('# RA event')
