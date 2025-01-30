function A = DisplayCohgram(A)

doTrialByTrialFigs = false;
doMeanFig = true;
A = getResource(A, 'PfcHcStartTrialByTrialCohgram');
A = getResource(A, 'PfcHcStartTrialByTrialCohgramFreq');
A = getResource(A, 'PfcHcStartTrialByTrialCohgramTimes');
A = getResource(A, 'CohgramTrialsCorrectError');

A = getResource(A, 'PfcStartTrialByTrialSpecgram');
A = getResource(A, 'PfcStartTrialByTrialSpecgramFreq');

A = registerResource(A, 'PostTrialThetaCoherencyCorrect', 'numeric', {1,1}, ...
    'postTrialThetaCoherencyCorrect', ...
    ['coherence in the last past of the cohgram, correct trials']);

A = registerResource(A, 'PostTrialThetaCoherencyError', 'numeric', {1,1}, ...
    'postTrialThetaCoherencyError', ...
    ['coherence in the last past of the cohgram, error trials ']);


A = registerResource(A, 'PostTrialThetaPfcSpecgramCorrect', 'numeric', {1,1}, ...
    'postTrialThetaPfcSpecgramCorrect', ...
    ['theta pfc specgram  in the last past of the cohgram, correct trials']);

A = registerResource(A, 'PostTrialThetaPfcSpecgramError', 'numeric', {1,1}, ...
    'postTrialThetaPfcSpecgramError', ...
    ['theta pfc specgram in the last past of the cohgram, error trials ']);


dpc = Data(pfcHcStartTrialByTrialCohgram{1});
ce = cohgramTrialsCorrectError{1} ;
ixCorr = find(cohgramTrialsCorrectError{1} == 1);
ixErr = find(cohgramTrialsCorrectError{1} == 0);

minT = min(find(pfcHcStartTrialByTrialCohgramTimes>5));
maxT = min(find(pfcHcStartTrialByTrialCohgramTimes>10));
minF = min(find(pfcHcStartTrialByTrialCohgramFreq>5));
maxF = min(find(pfcHcStartTrialByTrialCohgramFreq>10));

dpcThetaPostCorr = dpc(ixCorr,minT:maxT,minF:maxF);
dpcThetaPostErr = dpc(ixErr,minT:maxT,minF:maxF);

postTrialThetaCoherencyCorrect = mean(dpcThetaPostCorr(:));
postTrialThetaCoherencyError = mean(dpcThetaPostErr(:));


pcCorr = squeeze(mean(dpc(ixCorr,:,:), 1));
pcErr = squeeze(mean(dpc(ixErr,:,:), 1));

dps = Data(pfcStartTrialByTrialSpecgram{1});
psCorr = squeeze(mean(dps(ixCorr,:,:)));
psErr = squeeze(mean(dps(ixErr,:,:)));
lt = linspace(-5, 20, size(dps,1));
minT = min(find(lt > 0));
maxT = min(find(lt > 5));

minF = min(find(pfcStartTrialByTrialSpecgramFreq > 5));
maxF = min(find(pfcStartTrialByTrialSpecgramFreq > 10));
dpsThetaPostCorr = dps(ixCorr,minT:maxT,minF:maxF);
dpsThetaPostErr = dps(ixErr,minT:maxT,minF:maxF);

postTrialThetaPfcSpecgramCorrect = mean(dpsThetaPostCorr(:));
postTrialThetaPfcSpecgramError = mean(dpsThetaPostErr(:));


 if doMeanFig
     figure(1)
     imagesc(pfcHcStartTrialByTrialCohgramTimes, pfcHcStartTrialByTrialCohgramFreq, pcCorr');
     caxis([0 0.8 ]);
     axis xy
     title('correct');
     figure(2)
     imagesc(pfcHcStartTrialByTrialCohgramTimes, pfcHcStartTrialByTrialCohgramFreq, pcErr');
     caxis([0 0.8 ]);
     axis xy
     title('error');


      figure(3)
     imagesc(linspace(-5, 20, size(dps,1)), pfcStartTrialByTrialSpecgramFreq, log10(psCorr'));
     axis xy
     cax = caxis;
     figure(4)
     imagesc(linspace(-5, 20, size(dps,1)), pfcStartTrialByTrialSpecgramFreq, log10(psErr'));
     axis xy
     caxis(cax);

     keyboard
 end

 cax = [];
 if doTrialByTrialFigs
     for i = 1:length(ce)
         figure(1)
         imagesc(pfcHcStartTrialByTrialCohgramTimes, pfcHcStartTrialByTrialCohgramFreq,...
             (squeeze(dpc(i,:,:)))')
         caxis([0 0.8])
         axis xy
         if ce(i)
             title([num2str(i) '  - correct']);
         else
             title([num2str(i) '  - error']);
         end
         figure(2);
         imagesc(lt, pfcStartTrialByTrialSpecgramFreq, log10((squeeze(dps(i,:,:)))'));
         if ~isempty(cax)
             caxis(cax);
         else
             cax = caxis;
         end
         axis xy
         if ce(i)
             title([num2str(i) '  - correct']);
         else
             title([num2str(i) '  - error']);

         end
         keyboard
     end
 end
 

     
 A = saveAllResources(A);
 