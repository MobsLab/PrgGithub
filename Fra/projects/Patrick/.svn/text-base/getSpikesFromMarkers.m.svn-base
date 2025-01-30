function res = getSpikesFromMarkers(m, da)

d = Data(m);
d = d(:,1);
t = Range(m);


for i = keys(da)
    i = i{1};
    s = da{i};
    ix = find(ismember(d, s));
    TTS = ts(t(ix));
    eval(['res.' i ' = TTS;']);
end

