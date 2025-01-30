function A = HcPfcPowerCorrelation(A)
 
 load /home/fpbatta/Data/LPPA/PfcHcSpecgramFreq
 
 
 A = getResource(A, 'PfcSpecgramTrials');
 pfcSpecgram = pfcSpecgramTrials{1};
 
 A = getResource(A, 'HcSpecgramTrials');
 hcSpecgram = hcSpecgramTrials{1};
 
 A = registerResource(A, 'HcPfcPowerCorrTrials', 'numeric', {[], []}, ...
     'hcPfcPowerCorrTrials', ...
     ['power correlation between hc and pfc']);
 
  nf = size(Data(pfcSpecgram),2);
  
 C = corrcoef([Data(pfcSpecgram), Data(hcSpecgram)]);
 
 C = C(nf+1:end,1:nf);
 imagesc(PfcHcSpecgramFreq, PfcHcSpecgramFreq, C);
 
 hcPfcPowerCorrTrials = C;
 keyboard
 A = saveAllResources(A);
 