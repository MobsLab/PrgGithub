% GlobalParcoursQuantifTonesDeltaCorticesRipples



clear
    Generate=1;
    exp='BASAL';
    DeltaLFP=1;
    CorrectionDeltaSPW=1;
    
    ParcoursRipDeltaEvolution(Generate,exp,DeltaLFP,CorrectionDeltaSPW);
    
    clear
    Generate=1;
    
     exp='BASAL';
    close all
    DeltaLFP=1;
    CorrectionDeltaSPW=0;
    ParcoursRipDeltaEvolution(Generate,exp,DeltaLFP,CorrectionDeltaSPW);  
    
    clear
    Generate=1;
    
     exp='BASAL';
    close all    
    DeltaLFP=0;
    CorrectionDeltaSPW=1;
    ParcoursRipDeltaEvolution(Generate,exp,DeltaLFP,CorrectionDeltaSPW);        
     
    clear
    Generate=1;
     exp='BASAL';
    DeltaLFP=0;
    CorrectionDeltaSPW=0;
    ParcoursRipDeltaEvolution(Generate,exp,DeltaLFP,CorrectionDeltaSPW);       
        close all
  
        
        
   
   % exp='BASAL';
   clear
    Generate=1;
    exp='DeltaTone';
    DeltaLFP=1;
    CorrectionDeltaSPW=1;
    ParcoursRipDeltaEvolution(Generate,exp,DeltaLFP,CorrectionDeltaSPW);
    
    clear
    Generate=1;
    close all
    exp='DeltaTone';
    DeltaLFP=1;
    CorrectionDeltaSPW=0;
    ParcoursRipDeltaEvolution(Generate,exp,DeltaLFP,CorrectionDeltaSPW);    
    
    clear
    Generate=1;
    exp='DeltaTone';
    close all    
    DeltaLFP=0;
    CorrectionDeltaSPW=1;
    ParcoursRipDeltaEvolution(Generate,exp,DeltaLFP,CorrectionDeltaSPW);  
    
    clear
    Generate=1;
    exp='DeltaTone';
     DeltaLFP=0;
    CorrectionDeltaSPW=0;
    ParcoursRipDeltaEvolution(Generate,exp,DeltaLFP,CorrectionDeltaSPW);       
        close all
         
        
     % problem /media/DataMOBsRAID/ProjetBreathDeltaFeedback/Mice251-252/20150522/Breath-Mouse-251-252-22052015/Mouse252   
%         
% [rRip,pRip,rD,pD,rDRip,pDRip,rDNoRip,pDNoRip,NbRip,NbDown,NbDownRip,NbDownNoRip,Nb,id,MiceName,PathOK]=ParcoursRipDeltaEvolution(0,'BASAL',1,0);
% [rRip2,pRip2,rD2,pD2,rDRip2,pDRip2,rDNoRip2,pDNoRip2,NbRip2,NbDown2,NbDownRip2,NbDownNoRip2,Nb2,id2,MiceName2,PathOK2]=ParcoursRipDeltaEvolution(0,'DeltaTone',1,0);
% 
% PlotErrorBarN([NbRip(1:13,:),zeros(13,1),NbRip2],1,0); title('Nb Rip')
% PlotErrorBarN([NbDown(1:13,:),zeros(13,1),NbDown2],1,0);title('Nb Down')
% 
% PlotErrorBarN([NbDownRip(1:13,:),zeros(13,1),NbDownRip2],1,0);title('Nb Down with Rip')
% PlotErrorBarN([NbDownNoRip(1:13,:),zeros(13,1),NbDownNoRip2],1,0);title('Nb Down no Rip')


