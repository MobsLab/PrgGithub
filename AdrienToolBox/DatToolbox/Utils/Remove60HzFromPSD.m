function ix = Remove60HzFromPSD(f)

nHarm = floor(max(f)/60);
ix = [];
for ii=1:nHarm
    ix = [ix;find(f>ii*60-4&f<ii*60+4)];
end

ix = find(~ismember([1:length(f)],ix));

