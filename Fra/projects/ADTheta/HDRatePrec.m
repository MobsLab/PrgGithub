function HDRatePrec


hm = getenv('HOME');
parent_dir = [ hm '/Data/Angelo'];
sign_thresh = 0.01;

datasets = List2Cell([ parent_dir filesep 'datasets_eeg_peak.list' ] );

A = Analysis(parent_dir);


[A, sr] = getResource(A, 'Spikes2Rate', datasets);


ts = cell(1,20);

for i = 1:20
    ts{i} = zeros(0,1);
end


for j = 1:length(sr)
    for i = 1:20
        ts{i} = [ts{i}; sr{j}{i}(:,1)];
    end
end

for i = 1:20
    [ns(i), dd, delta, pval] = CircularMean(ts{i});
    cs(i) = asin(1.96 * delta / length(ts{i}));
end

errorbar(1:20, ns, cs);



    