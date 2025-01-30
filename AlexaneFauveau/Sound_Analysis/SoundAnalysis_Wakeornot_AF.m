
load('1618_PiezoData_SleepScoring.mat')

x = [2.5 2.5 2.5 2.5 2.5 2.5 2.5 2.5 2.5]

figure,
plot(Range(Piezo_Mouse_tsd)/3600e4,Data(Smooth_actimetry),'color',[0.3010 0.7450 0.9330])
hold on, plot(Range(Restrict(Smooth_actimetry,SlSc.Piez.Sleep))/3600e4,Data(Restrict(Smooth_actimetry,SlSc.Piez.Sleep)),'r')
hold on, plot(Range(Restrict(Smooth_actimetry,WakeEpoch_Piezo))/3600e4,...
    Data(Restrict(Smooth_actimetry,WakeEpoch_Piezo)),'k')
xlim([0 max(Range(Smooth_actimetry))/3600e4])

plot(Range(SlSc.Piez.Raw)/3600e4,Data(SlSc.Piez.Raw),'color',[0.3010 0.7450 0.9330])
plot(Range(Restrict(Smooth_actimetry,PreStimEpoch))/3600e4, Data(Restrict(Smooth_actimetry,PreStimEpoch)),'k--')
plot(Range(Restrict(Smooth_actimetry,PreStimEpoch_OfInterest))/3600e4, Data(Restrict(Smooth_actimetry,PreStimEpoch_OfInterest)),'g--')


PreStimEpoch_OfInterest

xstim = []
for i = 1:length(Stim_Event)
    xstim = [xstim 4]
end
plot(Stim_Event/3600e4,xstim,'r*','MarkerSize',10)
legend('Sommeil','Eveil','Stimulation','Location','southoutside')
xlabel('Temps(h)')


plot(tps_stim.(SoundTypes{sid}).(SoundValues{st}),xstim,'g*','MarkerSize',20)


for sid = 1:length(SoundTypes)
    for st = 1:length(SoundValues)
    plot(tps_stim.(SoundTypes{sid}).(SoundValues{st})/3600e4,xstim(1:length(tps_stim.(SoundTypes{sid}).(SoundValues{st}))),'g*','MarkerSize',20)
    end
end



plot(Range(Restrict(Smooth_actimetry,PreStimEpoch)), Data(Restrict(Smooth_actimetry,PreStimEpoch)),'k--')

plot(Start(PreStimEpoch),x(1:2),'*','MarkerSize',20)
plot(Start(PreStimEpoch_OfInterest),x(1),'*','MarkerSize',20)

Stim_Event = [Start(TTLInfo.Sounds)*1e4];

Stim_Event(3)-Start(PreStimEpoch(3)


figure,
plot(Range(Smooth_actimetry),Data(Smooth_actimetry))
hold on, plot(Range(Restrict(Smooth_actimetry,SlSc.Piez.Sleep)),Data(Restrict(Smooth_actimetry,SlSc.Piez.Sleep)),'c')
plot(Range(Restrict(Smooth_actimetry,PreStimEpoch)), Data(Restrict(Smooth_actimetry,PreStimEpoch)),'k--')
plot(Range(Restrict(Smooth_actimetry,EpochAfterStim)), Data(Restrict(Smooth_actimetry,EpochAfterStim)),'r')

plot(Start(EpochAfterStim),x(1:6),'y*','MarkerSize',20)
plot(Stop(EpochAfterStim),x(1:6),'k*','MarkerSize',20)

plot(Start(PreStimEpoch),x(1:9),'*','MarkerSize',20)
plot(Start(PreStimEpoch_OfInterest),x(1),'*','MarkerSize',20)

for sv = 1:length(SoundValues)
plot(tps_stim.(SoundTypes{8}).(SoundValues{sv}),x(1:length(tps_stim.(SoundTypes{8}).(SoundValues{sv}))),'r*')
end



