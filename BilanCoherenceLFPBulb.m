%BilanCoherenceLFPBulb
a=1;

try
    hpc;
catch
    
hpc=1;
end


cd \\NASDELUXE\DataMOBsRAID5\ProjetAstro\DataPlethysmo\Mouse051
% load listLFP
% listLFP
%         name: {'PFCx'  'PaCx'  'AuCx'  'dHPC'  'AuTh'}
%     channels: {[5 6 7]  [8 12 13]  [9 10 11]  [2 3 4]  [14 15 16]}
%        depth: {[1 -1 1]  [1 1 -1]  [1 1 0]  [1 1 1]  [1 1 1]}
       load LFPData LFP
       para{1}=LFP;
       load StateEpoch
       para{2}=SWSEpoch;
       para{3}=REMEpoch;
       para{4}=MovEpoch;
  [C,f,S1,S2,fb,Cb,S1b,S2b,fc,Cc,S1c,S2c]=CohAnalysisRespiLFPBulb(0,5,para);
  Cwt{a,1}=C;
  fwt{a,1}=f;
  Cwt{a,2}=Cb;
  fwt{a,2}=fb;  
  Cwt{a,3}=Cc;
  fwt{a,3}=fc;  
  if hpc
  [C,f,S1,S2,fb,Cb,S1b,S2b,fc,Cc,S1c,S2c]=CohAnalysisRespiLFPBulb(0,2,para); %12
  else
  [C,f,S1,S2,fb,Cb,S1b,S2b,fc,Cc,S1c,S2c]=CohAnalysisRespiLFPBulb(0,12,para); %12      
  end
  Cwt{a,4}=C;
  fwt{a,4}=f;
  Cwt{a,5}=Cb;
  fwt{a,5}=fb;  
  Cwt{a,6}=Cc;
  fwt{a,6}=fc; 
  if hpc
  [C,f,S1,S2,fb,Cb,S1b,S2b,fc,Cc,S1c,S2c]=CohAnalysisRespiLFPBulb(5,2,para);
  else
  [C,f,S1,S2,fb,Cb,S1b,S2b,fc,Cc,S1c,S2c]=CohAnalysisRespiLFPBulb(5,12,para);      
  end
  Cwt{a,7}=C;
  fwt{a,7}=f;
  Cwt{a,8}=Cb;
  fwt{a,8}=fb;
  Cwt{a,9}=Cc;
  fwt{a,9}=fc;  
  a=a+1;
  
cd \\NASDELUXE\DataMOBsRAID5\ProjetAstro\DataPlethysmo\Mouse060
% load listLFP
% listLFP
%         name: {'Bulb'  'PFCx'  'PaCx'  'AuCx'  'dHPC'}
%     channels: {[8 9 10 11 12]  [5 6 7]  [13 14 15]  [16]  [2 3 4]}
%        depth: {[4 3 2 1 0]  [1 1 0]  [0 1 1]  [-1]  [3 2 1]}
       load LFPData LFP
       para{1}=LFP;
       load StateEpoch
       para{2}=SWSEpoch;
       para{3}=REMEpoch;
       para{4}=MovEpoch;
  [C,f,S1,S2,fb,Cb,S1b,S2b,fc,Cc,S1c,S2c]=CohAnalysisRespiLFPBulb(0,5,para);
  Cwt{a,1}=C;
  fwt{a,1}=f;
  Cwt{a,2}=Cb;
  fwt{a,2}=fb;  
  Cwt{a,3}=Cc;
  fwt{a,3}=fc;  
  if hpc
  [C,f,S1,S2,fb,Cb,S1b,S2b,fc,Cc,S1c,S2c]=CohAnalysisRespiLFPBulb(0,2,para); %14
  else
        [C,f,S1,S2,fb,Cb,S1b,S2b,fc,Cc,S1c,S2c]=CohAnalysisRespiLFPBulb(0,14,para); %14
  end
  Cwt{a,4}=C;
  fwt{a,4}=f;
  Cwt{a,5}=Cb;
  fwt{a,5}=fb;  
  Cwt{a,6}=Cc;
  fwt{a,6}=fc; 
  if hpc
  [C,f,S1,S2,fb,Cb,S1b,S2b,fc,Cc,S1c,S2c]=CohAnalysisRespiLFPBulb(5,2,para);
  else
     [C,f,S1,S2,fb,Cb,S1b,S2b,fc,Cc,S1c,S2c]=CohAnalysisRespiLFPBulb(5,14,para);  
  end
  Cwt{a,7}=C;
  fwt{a,7}=f;
  Cwt{a,8}=Cb;
  fwt{a,8}=fb;
  Cwt{a,9}=Cc;
  fwt{a,9}=fc;  
  a=a+1;
  
cd \\NASDELUXE\DataMOBsRAID5\ProjetAstro\DataPlethysmo\Mouse061
% load listLFP
% listLFP
%         name: {'Bulb'  'PFCx'  'PaCx'  'AuCx'  'dHPC'}
%     channels: {[11 12 13 14 15]  [8 9 10]  [5 6 7]  [16]  [2 3 4]}
%        depth: {[4 3 2 1 0]  [0 1 2]  [0 1 1]  [-1]  [3 2 1]}
       load LFPData LFP
       para{1}=LFP;
       load StateEpoch
       para{2}=SWSEpoch;
       para{3}=REMEpoch;
       para{4}=MovEpoch;
  [C,f,S1,S2,fb,Cb,S1b,S2b,fc,Cc,S1c,S2c]=CohAnalysisRespiLFPBulb(0,10,para);
  Cwt{a,1}=C;
  fwt{a,1}=f;
  Cwt{a,2}=Cb;
  fwt{a,2}=fb;  
  Cwt{a,3}=Cc;
  fwt{a,3}=fc;  
  if hpc
  [C,f,S1,S2,fb,Cb,S1b,S2b,fc,Cc,S1c,S2c]=CohAnalysisRespiLFPBulb(0,2,para);  %6
  else
   [C,f,S1,S2,fb,Cb,S1b,S2b,fc,Cc,S1c,S2c]=CohAnalysisRespiLFPBulb(0,6,para);  %6   
  end
  Cwt{a,4}=C;
  fwt{a,4}=f;
  Cwt{a,5}=Cb;
  fwt{a,5}=fb;  
  Cwt{a,6}=Cc;
  fwt{a,6}=fc; 
  if hpc
  [C,f,S1,S2,fb,Cb,S1b,S2b,fc,Cc,S1c,S2c]=CohAnalysisRespiLFPBulb(10,2,para);
  else
       [C,f,S1,S2,fb,Cb,S1b,S2b,fc,Cc,S1c,S2c]=CohAnalysisRespiLFPBulb(10,6,para); 
  end
  Cwt{a,7}=C;
  fwt{a,7}=f;
  Cwt{a,8}=Cb;
  fwt{a,8}=fb;
  Cwt{a,9}=Cc;
  fwt{a,9}=fc;  
  a=a+1;
  
%--------------------------------------------------------------------------
a=1;

cd \\NASDELUXE\DataMOBsRAID5\ProjetAstro\DataPlethysmo\Mouse054\Cx
% load listLFP
% listLFP
%         name: {'PFCx'  'PaCx'  'AuCx'  'dHPC'  'AuTh'}
%     channels: {[8 9 10]  [11 12 13]  [5 6 7]  [14 15 16]  [2 3 4]}
%        depth: {[0 1 1]  [0 1 1]  [0 1 1]  [1 1 1]  [1 1 1]}
       load LFPData LFP
       para{1}=LFP;
       load StateEpoch
       para{2}=SWSEpoch;
       para{3}=REMEpoch;
       para{4}=MovEpoch;
  [C,f,S1,S2,fb,Cb,S1b,S2b,fc,Cc,S1c,S2c]=CohAnalysisRespiLFPBulb(0,9,para);
  Cko{a,1}=C;
  fko{a,1}=f;
  Cko{a,2}=Cb;
  fko{a,2}=fb;
  Cko{a,3}=Cc;
  fko{a,3}=fc;
  if hpc
  [C,f,S1,S2,fb,Cb,S1b,S2b,fc,Cc,S1c,S2c]=CohAnalysisRespiLFPBulb(0,14,para); %12
  else
  [C,f,S1,S2,fb,Cb,S1b,S2b,fc,Cc,S1c,S2c]=CohAnalysisRespiLFPBulb(0,12,para); %12      
  end
  Cko{a,4}=C;
  fko{a,4}=f;
  Cko{a,5}=Cb;
  fko{a,5}=fb;
  Cko{a,6}=Cc;
  fko{a,6}=fc;
  if hpc
  [C,f,S1,S2,fb,Cb,S1b,S2b,fc,Cc,S1c,S2c]=CohAnalysisRespiLFPBulb(9,14,para);
  else
  [C,f,S1,S2,fb,Cb,S1b,S2b,fc,Cc,S1c,S2c]=CohAnalysisRespiLFPBulb(9,12,para);      
  end
  Cko{a,7}=C;
  fko{a,7}=f;
  Cko{a,8}=Cb;
  fko{a,8}=fb;
  Cko{a,9}=Cc;
  fko{a,9}=fc;
  a=a+1;
  
cd \\NASDELUXE\DataMOBsRAID5\ProjetAstro\DataPlethysmo\Mouse065
% load listLFP
% listLFP
%         name: {'Bulb'  'PFCx'  'PaCx'  'AuCx'  'dHPC'}
%     channels: {[12 13 14 15 16]  [2 3 4]  [5 6 7]  [8]  [9 10 11]}
%        depth: {[4 3 2 1 0]  [0 2 1]  [0 1 1]  [-1]  [3 2 1]}
       load LFPData LFP
       para{1}=LFP;
       load StateEpoch
       para{2}=SWSEpoch;
       para{3}=REMEpoch;
       para{4}=MovEpoch;
       
  [C,f,S1,S2,fb,Cb,S1b,S2b,fc,Cc,S1c,S2c]=CohAnalysisRespiLFPBulb(0,3,para);
  Cko{a,1}=C;
  fko{a,1}=f;
  Cko{a,2}=Cb;
  fko{a,2}=fb;
  Cko{a,3}=Cc;
  fko{a,3}=fc;
  
  [C,f,S1,S2,fb,Cb,S1b,S2b,fc,Cc,S1c,S2c]=CohAnalysisRespiLFPBulb(0,10,para);  %6
  Cko{a,4}=C;
  fko{a,4}=f;
  Cko{a,5}=Cb;
  fko{a,5}=fb;
  Cko{a,6}=Cc;
  fko{a,6}=fc;
  
  [C,f,S1,S2,fb,Cb,S1b,S2b,fc,Cc,S1c,S2c]=CohAnalysisRespiLFPBulb(3,10,para);
  Cko{a,7}=C;
  fko{a,7}=f;
  Cko{a,8}=Cb;
  fko{a,8}=fb;
  Cko{a,9}=Cc;
  fko{a,9}=fc;
  a=a+1;

cd \\NASDELUXE\DataMOBsRAID5\ProjetAstro\DataPlethysmo\Mouse066
% load listLFP
% listLFP
% name: {'Bulb'  'PFCx'  'PaCx'  'AuCx'  'dHPC'}
%     channels: {[9 10 11 12 13]  [6 7 8]  [5 14 15]  [16]  [2 3 4]}
%        depth: {[4 3 2 1 0]  [0 1 1]  [0 1 1]  [-1]  [1 2 3]}
       load LFPData LFP
       para{1}=LFP;
       load StateEpoch
       para{2}=SWSEpoch;
       para{3}=REMEpoch;
       para{4}=MovEpoch;
  [C,f,S1,S2,fb,Cb,S1b,S2b,fc,Cc,S1c,S2c]=CohAnalysisRespiLFPBulb(0,7,para);
  Cko{a,1}=C;
  fko{a,1}=f;
  Cko{a,2}=Cb;
  fko{a,2}=fb;
  Cko{a,3}=Cc;
  fko{a,3}=fc;
  
  [C,f,S1,S2,fb,Cb,S1b,S2b,fc,Cc,S1c,S2c]=CohAnalysisRespiLFPBulb(0,2,para);  %14
  Cko{a,4}=C;
  fko{a,4}=f;
  Cko{a,5}=Cb;
  fko{a,5}=fb;
  Cko{a,6}=Cc;
  fko{a,6}=fc;
  
  [C,f,S1,S2,fb,Cb,S1b,S2b,fc,Cc,S1c,S2c]=CohAnalysisRespiLFPBulb(7,2,para);
  Cko{a,7}=C;
  fko{a,7}=f;
  Cko{a,8}=Cb;
  fko{a,8}=fb;
  Cko{a,9}=Cc;
  fko{a,9}=fc;
  a=a+1;


  
  
 %------------------------------------------------------------------------- 
  
 clear CkoR
 clear CwtR
freq=[0:0.3:20]; 

try
 for i=1:9
 freqts=ts(freq);
 CkoR{1,i}=Data(Restrict(tsd(fko{1,i},Cko{1,i}),freqts));
 CwtR{1,i}=Data(Restrict(tsd(fwt{1,i},Cwt{1,i}),freqts));
  CkoR{2,i}=Data(Restrict(tsd(fko{2,i},Cko{2,i}),freqts));
 CwtR{2,i}=Data(Restrict(tsd(fwt{2,i},Cwt{2,i}),freqts));
  CkoR{3,i}=Data(Restrict(tsd(fko{3,i},Cko{3,i}),freqts));
 CwtR{3,i}=Data(Restrict(tsd(fwt{3,i},Cwt{3,i}),freqts));
 end
 
catch
    
  for i=1:9
 freqts=ts(freq);
 CkoR{1,i}=Data(Restrict(tsd(fko{1,i},Cko{1,i}'),freqts));
 CwtR{1,i}=Data(Restrict(tsd(fwt{1,i},Cwt{1,i}'),freqts));
  CkoR{2,i}=Data(Restrict(tsd(fko{2,i},Cko{2,i}'),freqts));
 CwtR{2,i}=Data(Restrict(tsd(fwt{2,i},Cwt{2,i}'),freqts));
  CkoR{3,i}=Data(Restrict(tsd(fko{3,i},Cko{3,i}'),freqts));
 CwtR{3,i}=Data(Restrict(tsd(fwt{3,i},Cwt{3,i}'),freqts));
  end
 
end
  
%  
%  b=1;
%   for i=4:6
%  freqts=ts(freq);
%  CkoR{b,1}=Data(Restrict(tsd(fko{i,1},Cko{i,1}),freqts));
%   CkoR{b,2}=Data(Restrict(tsd(fko{i,2},Cko{i,2}),freqts));
%   CkoR{b,3}=Data(Restrict(tsd(fko{i,3},Cko{i,3}),freqts));
%   b=b+1;
%   end
 
for idxx=1:9
smo=7;

 figure('color',[1 1 1]),
 subplot(2,1,1),hold on, title(num2str(idxx))
 try
     plot(freq,smooth(CwtR{1,idxx},smo),'k','linewidth',2)
 end
 try
     plot(freq,smooth(CwtR{2,idxx},smo),'k','linewidth',2)
 end
 try
     plot(freq,smooth(CwtR{3,idxx},smo),'k','linewidth',2)
 end
 hold on,
 try
 plot(freq,smooth(CkoR{1,idxx},smo),'r','linewidth',2)
 end
 try
     plot(freq,smooth(CkoR{2,idxx},smo),'r','linewidth',2)
 end
 try
     plot(freq,smooth(CkoR{3,idxx},smo),'r','linewidth',2)
 end
 subplot(2,1,2),hold on, 
 test=[smooth(CwtR{1,idxx},smo),smooth(CwtR{2,idxx},smo),smooth(CwtR{3,idxx},smo)]';
try
     testKO=[smooth(CkoR{1,idxx},smo),smooth(CkoR{2,idxx},smo),smooth(CkoR{3,idxx},smo)]';
catch
 testKO=[smooth(CkoR{2,idxx},smo),smooth(CkoR{3,idxx},smo)]';
end
plot(freq,mean(test),'k','linewidth',2)
 plot(freq,mean(test)+stdError(test),'k','linewidth',1)
 plot(freq,mean(test)-stdError(test),'k','linewidth',1)
    plot(freq,mean(testKO),'r','linewidth',2)
    plot(freq,mean(testKO)+stdError(testKO),'r','linewidth',1)
    plot(freq,mean(testKO)-stdError(testKO),'r','linewidth',1)
end
 
%--------------------------------------------------------------------------
 
 
 CwtRswsRPfc=[CwtR{1,1}';CwtR{2,1}';CwtR{3,1}']; 
 CwtRremRPfc=[CwtR{1,2}';CwtR{2,2}';CwtR{3,2}'];
 CwtRwakRPfc=[CwtR{1,3}';CwtR{2,3}';CwtR{3,3}'];

 CwtRswsRPar=[CwtR{1,4}';CwtR{2,4}';CwtR{3,6}']; 
 CwtRremRPar=[CwtR{1,5}';CwtR{2,5}';CwtR{3,6}'];
 CwtRwakRPar=[CwtR{1,6}';CwtR{2,6}';CwtR{3,6}'];
 
 CwtRswsPfcPar=[CwtR{1,7}';CwtR{2,7}';CwtR{3,7}']; 
 CwtRremPfcPar=[CwtR{1,8}';CwtR{2,8}';CwtR{3,8}'];
 CwtRwakPfcPar=[CwtR{1,9}';CwtR{2,9}';CwtR{3,9}'];
 
 
 CkoRswsRPfc=[CkoR{1,1}';CkoR{2,1}';CkoR{3,1}']; 
 CkoRremRPfc=[CkoR{1,2}';CkoR{2,2}';CkoR{3,2}'];
 CkoRwakRPfc=[CkoR{1,3}';CkoR{2,3}';CkoR{3,3}'];

 CkoRswsRPar=[CkoR{1,4}';CkoR{2,4}';CkoR{3,6}']; 
 CkoRremRPar=[CkoR{1,5}';CkoR{2,5}';CkoR{3,6}'];
 CkoRwakRPar=[CkoR{1,6}';CkoR{2,6}';CkoR{3,6}'];
 
 CkoRswsPfcPar=[CkoR{1,7}';CkoR{2,7}';CkoR{3,7}']; 
 CkoRremPfcPar=[CkoR{1,8}';CkoR{2,8}';CkoR{3,8}'];
 CkoRwakPfcPar=[CkoR{1,9}';CkoR{2,9}';CkoR{3,9}'];
 
 
 smo=7;
  figure('color',[1 1 1]),
  subplot(3,3,1),
 hold on, plot(freq,smooth(mean(CwtRswsRPfc),smo),'k','linewidth',2),title('Respi Pfc')
%  plot(freq,smooth(mean(CwtRswsRPfc)+stdError(CwtRswsRPfc),smo),'k','linewidth',1)
%  plot(freq,smooth(mean(CwtRswsRPfc)-stdError(CwtRswsRPfc),smo),'k','linewidth',1)
 hold on, plot(freq,smooth(mean(CkoRswsRPfc),smo),'r','linewidth',2)
%  plot(freq,smooth(mean(CkoRswsRPfc)+stdError(CkoRswsRPfc),smo),'r','linewidth',1)
%  plot(freq,smooth(mean(CkoRswsRPfc)-stdError(CkoRswsRPfc),smo),'r','linewidth',1)
 ylabel('SWS')
 ylim([0.2 0.8])
 
 subplot(3,3,4),
 hold on, plot(freq,smooth(mean(CwtRremRPfc),smo),'k','linewidth',2)
 if size(CkoRremRPfc,1)==1
      hold on, plot(freq,smooth((CkoRremRPfc),smo),'r','linewidth',2)
 else
 hold on, plot(freq,smooth(mean(CkoRremRPfc),smo),'r','linewidth',2)
 end
 ylabel('REM')
  ylim([0.2 0.8])
  subplot(3,3,7),
 hold on, plot(freq,smooth(mean(CwtRwakRPfc),smo),'k','linewidth',2)
 hold on, plot(freq,smooth(mean(CkoRwakRPfc),smo),'r','linewidth',2)
 ylabel('Wake')
  ylim([0.2 0.8])
  
   subplot(3,3,2),
 hold on, plot(freq,smooth(mean(CwtRswsRPar),smo),'k','linewidth',2), 
 if hpc
     title('Respi Hpc')
 else
     title('Respi Par')
 end
 hold on, plot(freq,smooth(mean(CkoRswsRPar),smo),'r','linewidth',2)
  ylim([0.2 0.8])
 subplot(3,3,5),
 hold on, plot(freq,smooth(mean(CwtRremRPar),smo),'k','linewidth',2)
 hold on, plot(freq,smooth(mean(CkoRremRPar),smo),'r','linewidth',2)
  ylim([0.2 0.8])
  subplot(3,3,8),
 hold on, plot(freq,smooth(mean(CwtRwakRPar),smo),'k','linewidth',2)
 hold on, plot(freq,smooth(mean(CkoRwakRPar),smo),'r','linewidth',2)
  ylim([0.2 0.8])
 
   subplot(3,3,3),
 hold on, plot(freq,smooth(mean(CwtRswsPfcPar),smo),'k','linewidth',2)

  if hpc
     title('Pfc Hpc')
 else
     title('Pfc Par')
  end
  hold on, plot(freq,smooth(mean(CkoRswsPfcPar),smo),'r','linewidth',2)
  ylim([0.2 0.8])
 subplot(3,3,6),
 hold on, plot(freq,smooth(mean(CwtRremPfcPar),smo),'k','linewidth',2)
  if size(CkoRremPfcPar,1)==1
      hold on, plot(freq,smooth((CkoRremPfcPar),smo),'r','linewidth',2)
 else
 hold on, plot(freq,smooth(mean(CkoRremPfcPar),smo),'r','linewidth',2)
  end
  
 ylim([0.2 0.8])
  subplot(3,3,9),
 hold on, plot(freq,smooth(mean(CwtRwakPfcPar),smo),'k','linewidth',2)
 hold on, plot(freq,smooth(mean(CkoRwakPfcPar),smo),'r','linewidth',2)
  ylim([0.2 0.8])
 
 