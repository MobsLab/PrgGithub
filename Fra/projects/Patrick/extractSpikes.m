function extractSpikes(m, name)

da = dictArray;
da{'pyrSpikes'} = [1 2 3];
da{'intSpikes'} = [3 4 5];
da{'stimTimes' }= [ 7 8 ];

res = getSpikesFromMarkers(m, da);
pyrSpikes = res.pyrSpikes;
intSpikes = res.intSpikes;
stimTimes = res.stimTimes;

save(name, 'pyrSpikes', 'intSpikes', 'stimTimes');

