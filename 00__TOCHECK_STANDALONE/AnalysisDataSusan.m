function [spkLCbef,spkLCaft,sleepSpecgramFreq,sleepBeforeSpec,sleepAfterSpec]=AnalysisDataSusan(numRat)

res=pwd;

eval(['cd(''\\NASDELUXE\DataMOBsRAID5\DataRats\HardDiskAdrien2\LC\Rat',num2str(numRat),''')'])

eval(['load(''\\NASDELUXE\DataMOBsRAID5\DataRats\HardDiskAdrien2\LC\Rat',num2str(numRat),'\sleepPfcSpecgram.mat'')'])
eval(['load(''\\NASDELUXE\DataMOBsRAID5\DataRats\HardDiskAdrien2\LC\Rat',num2str(numRat),'\Rat',num2str(numRat),'_spkLC_Before.mat'')'])
eval(['load(''\\NASDELUXE\DataMOBsRAID5\DataRats\HardDiskAdrien2\LC\Rat',num2str(numRat),'\Rat',num2str(numRat),'_eegHcp_Before.mat'')'])
spkLCbef=spkLC;

eval(['load(''\\NASDELUXE\DataMOBsRAID5\DataRats\HardDiskAdrien2\LC\Rat',num2str(numRat),'\Rat',num2str(numRat),'_spkLC_After.mat'')'])
eval(['load(''\\NASDELUXE\DataMOBsRAID5\DataRats\HardDiskAdrien2\LC\Rat',num2str(numRat),'\Rat',num2str(numRat),'_eegHcp_After.mat'')'])
spkLCaft=spkLC;

try
figure('color',[1 1 1]), imagesc(Range(sleepBeforeSpec{1},'s'),sleepSpecgramFreq,10*log10(Data(sleepBeforeSpec{1})')), axis xy,caxis([-75 -20])
hold on, plot(Range(spkLCbef{1},'s'),ones(1,length(Range(spkLCbef{1}))),'k.')
title(['Before, rat',num2str(numRat)])
end


try
figure('color',[1 1 1]), imagesc(Range(sleepAfterSpec{1},'s'),sleepSpecgramFreq,10*log10(Data(sleepAfterSpec{1})')), axis xy,caxis([-75 -20])
hold on, plot(Range(spkLCaft{1},'s'),ones(1,length(Range(spkLCaft{1}))),'k.')
title(['After, rat',num2str(numRat)])
end

eval(['cd(''',res,''')'])

