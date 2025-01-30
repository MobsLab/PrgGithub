function A = HcPfcPowerCorrelation(A)
 
 load /home/fpbatta/Data/LPPA/PfcHcSpecgramFreq
 
 
 A = getResource(A, 'PfcSpecgram');
 pfcSpecgram = pfcSpecgram{1};
 
 A = getResource(A, 'HcSpecgram');
 hcSpecgram = hcSpecgram{1};
 
 A = registerResource(A, 'HcPfcPowerCorr', 'numeric', {[], []}, ...
     'hcPfcPowerCorr', ...
     ['power correlation between hc and pfc']);
 
  nf = size(Data(pfcSpecgram),2);
  
 C = corrcoef([Data(pfcSpecgram), Data(hcSpecgram)]);
 
 C = C(nf+1:end,1:nf);
 imagesc(PfcHcSpecgramFreq, PfcHcSpecgramFreq, C);
  keyboard
 hcPfcPowerCorr= C;
 
 A = saveAllResources(A);
 