
clear
Dir = ListOfDreemRecordsRandomStim('all');
p=1;
[signals, ~, stimulations, StageEpochs, labels_eeg] = GetRecordDreem(Dir.filename{p});
[stim_tmp, sham_tmp] = SortDreemStimSham(stimulations);


%ISI
step=100;
edges=0:step:100000;

[isi_stim.y, isi_stim.x] = histcounts(diff(stim_tmp/10), edges);
isi_stim.x = isi_stim.x(1:end-1) + diff(isi_stim.x);

[isi_sham.y, isi_sham.x] = histcounts(diff(sham_tmp/10), edges);
isi_sham.x = isi_sham.x(1:end-1) + diff(isi_sham.x);

%CrossCor
binsize = 100;
nb_bins = 4000;
[CC_tonesham, t1] = CrossCorr(stim_tmp, sham_tmp, binsize, nb_bins);


%% PLot
figure, hold on

subplot(2,2,1), hold on
bar(isi_stim.x, isi_stim.y), hold on
title('stim')

subplot(2,2,2), hold on
bar(isi_sham.x, isi_sham.y), hold on
title('sham')

subplot(2,2,3), hold on
plot(t1/10, CC_tonesham), hold on
title('correlo-tones-sham')