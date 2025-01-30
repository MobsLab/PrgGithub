function A = DisplaySpeedThetaCoh(A)
 
doFigures = true;
 load /home/fpbatta/Data/LPPA/PfcHcSpecgramFreq
 
 
 A = getResource(A, 'PfcSpecgram');
 pfcSpecgram = pfcSpecgram{1};
 
 A = getResource(A, 'HcSpecgram');
 hcSpecgram = hcSpecgram{1};
 
 A = getResource(A, 'BinnedVelocity');
 binnedVelocity = binnedVelocity{1};
 
 A = registerResource(A, 'PfcThetaVelCorr', 'numeric', {1,1}, ...
     'pfcThetaVelCorr', ...
     ['correlation between theta and velocity in pfc']);
 A = registerResource(A, 'PfcThetaThresh', 'numeric', {1,1}, ...
     'pfcThetaThresh', ...
     ['noise threshold for prefrontla theta']);
 
 A = registerResource(A, 'HcThetaVelCorr', 'numeric', {1,1}, ...
     'hcThetaVelCorr', ...
     ['correlation between theta and velocity in hc']);
 A = registerResource(A, 'HcThetaThresh', 'numeric', {1,1}, ...
     'hcThetaThresh', ...
     ['noise threshold for hippocampal theta']);


 fMin = min(find(PfcHcSpecgramFreq > 5));
 fMax = min(find(PfcHcSpecgramFreq > 10));
 
 dpfc = Data(pfcSpecgram);
 dpfc = sum(dpfc(:,fMin:fMax), 2);
dhc = Data(hcSpecgram);

 dhc = sum(dhc(:,fMin:fMax), 2); 
 
 if doFigures
     figure(1)
     plot(Data(binnedVelocity), dpfc, '.');
     title('prefrontal theta');

     figure(2)
     plot(Data(binnedVelocity), dhc, '.');
     title('hippocampal theta');
     bv = Data(binnedVelocity);
 end
 pfcThresh = input('Enter noise threshold  for prefrontal');
 pfcThetaThresh = pfcThresh;
 ix = find(dpfc < pfcThresh);
 pfcThetaVelCorr = corrcoef(dpfc(ix), bv(ix));
pfcThetaVelCorr =  pfcThetaVelCorr(1,2)
 hcThresh = input('Enter noise threshold  for hippocampus');
 hcThetaThresh = hcThresh;
 ix = find(dhc < hcThresh);
 hcThetaVelCorr = corrcoef(dhc(ix), bv(ix));
hcThetaVelCorr =  hcThetaVelCorr(1,2)

 
 A = saveAllResources(A);
 