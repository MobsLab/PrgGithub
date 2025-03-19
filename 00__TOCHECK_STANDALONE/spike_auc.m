function AUCSpike = spike_auc(waveforms)
waveforms = double(waveforms);
area = zeros(1,size(waveforms,2));
for c = 1:size(waveforms,2)
    w = waveforms(:,c);
    [maxval,maxidx]= max(w);
    [minval,minidx]= min(w);
    if maxidx>minidx;
        w = resample(waveforms(:,c),300,12);
        m = max(w);
        w=w./m;
        [m,idx]=min(w);
        w=w(idx:end);
        w=w(w>=0);
        area(c) = trapz(abs(w));
    else
        w = resample(waveforms(:,c),300,12);
        m = max(w);
        w=w./m;
        [m,idx]=max(w);
        w=w(idx:end);
        w=w(w<=0);
        area(c) = trapz(abs(w));
    end;

end