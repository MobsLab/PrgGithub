
basename=input('give basename for evt. saving (i.e. xml name)     ');


load ToneEvent
evt.time=SingleTone/1E4;
for i=1:length(evt.time)
evt.description{i}='ton';
end
CreateEvent(evt,basename,'ton')

load newDeltaPaCx
evt.time=tDelta/1E4;
for i=1:length(evt.time)
evt.description{i}='dPa';
end
CreateEvent(evt,basename,'dPa')

load newDeltaMoCx
evt.time=tDelta/1E4;
for i=1:length(evt.time)
evt.description{i}='dMo';
end
CreateEvent(evt,basename,'dMo')

load newDeltaPFCx
evt.time=tDelta/1E4;
for i=1:length(evt.time)
evt.description{i}='dPF';
end
CreateEvent(evt,basename,'dPF')



load DeltaPFCx
evt.time=Range(tDelta)/1E4;
for i=1:length(evt.time)
evt.description{i}='dPF';
end
CreateEvent(evt,basename,'dPF')

