%% Mouse 514 - Look at changes in coherence during the day

% Get all files
Dir = GetAllMouseTaskSessions(514);
chan1=[11 10];
[params,movingwin,suffix]=SpectrumParametersML('low'); % low or high

for d = 2:length(Dir)
    cd(Dir{d})
    mkdir('AllSpecHPCProbe')
    mkdir('CohgramcDataL')
    
   load('LFPData/LFP11');
   LFP1 = LFP;
   load('LFPData/LFP10');
   LFP2 = LFP;
   
   LFP = tsd(Range(LFP1),Data(LFP2)-Data(LFP1));
   chan = chan1;
   save('LFPData/LocalOBActivity','LFP','chan')
   
   LFPOBLocal = LFP;
   LFPOB = LFP2;
   
   for kk = 32:47
       load(['LFPData/LFP' num2str(kk) '.mat'])
       chan2 = kk;
       
       % Local OB
       [C,phi,S12,S1,S2,t,f,confC,phistd]=cohgramc(Data(LFP),Data(LFPOBLocal),movingwin,params);
       save(['CohgramcDataL/Cohgram_OBLocalHPC' num2str(kk)],'C','phi','S12','confC','t','f','chan1','chan2')
       
       % Single wire OB
       [C,phi,S12,S1,S2,t,f,confC,phistd]=cohgramc(Data(LFP),Data(LFPOB),movingwin,params);
       save(['CohgramcDataL/Cohgram_OBHPC' num2str(kk)],'C','phi','S12','confC','t','f','chan1','chan2')
       
       % Spectrum
       LowSpectrumSB([cd filesep 'AllSpecHPCProbe' filesep],kk,['HPCProbe' num2str(kk)])

   end
      
end