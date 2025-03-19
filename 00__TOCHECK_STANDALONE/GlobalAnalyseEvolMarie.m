%GlobalAnalyseEvolMarie

% Analyse global du sommeil macroscopique et puissance 





%NameDir={'BASAL', 'DPCPX', 'LPS', 'CANAB'};
%NameDir={'BASAL', 'PLETHYSMO','DPCPX', 'LPS', 'CANAB'};
%NameDir={'BASAL', 'DPCPX'};
%NameDir={'PLETHYSMO'};
NameDir={'BASAL'};

RemovePreEpoch=1;
DurSt=[];
StateBefSt=[];
SpS1t=[];
SpS2t=[];
SpS3t=[];

DurStKO=[];
StateBefStKO=[];
SpS1tKO=[];
SpS2tKO=[];
SpS3tKO=[];

NbSpit=[];
NbSpiRt=[];
NbSpiWt=[];

NbSpitKO=[];
NbSpiRtKO=[];
NbSpiWtKO=[];

a=1;
b=1;

    for i=1:length(NameDir)
        Dir=PathForExperimentsML(NameDir{i});
        
        for man=1:length(Dir.path)
                        disp('  ')
            disp(Dir.path{man})
            disp(Dir.group{man})
            disp(' ')
            try
                
            cd(Dir.path{man})
            
            clear DurS
            clear DurR
            clear DurW
            clear StateBefS
            clear StateBefR
            clear StateBefW
            clear SpS1
            clear SpS2
            clear SpS3
            clear SpR1
            clear SpR2
            clear SpR3
            clear SpW1
            clear SpW2
            clear SpW3
            clear freq
            clear rS
            clear pS
            clear rR
            clear pR
            clear rW
            clear pW
            clear NbSpi
            clear NbSpiR
            clear NbSpiW
              
            
    
             if Dir.group{man}(1)=='W'
                 
              try
                   
                  [DurS,DurR,DurW,StateBefS,StateBefR,StateBefW,SpS1,SpS2,SpS3,SpR1,SpR2,SpR3,SpW1,SpW2,SpW3,freq,rS,pS,rR,pR,rW,pW,NbSpi,NbSpiR,NbSpiW]=AnalyseEvolMarie(RemovePreEpoch);                
                  
                  try
                      
                  test=NbSpi';
                  test=test(:);
                  NbSpit=[NbSpit;test'];
                  
                  test=NbSpiR';
                  test=test(:);
                  NbSpiRt=[NbSpiRt;test'];
                  
                  test=NbSpiW';
                  test=test(:);
                  NbSpiWt=[NbSpiWt;test'];
                  
                  DurSt=[DurSt;DurS];
                  StateBefSt=[StateBefSt;StateBefS];
                  rSt(a)=rS;
                  pSt(a)=pS;
                  SpS1t=[SpS1t;SpS1'];
                  SpS2t=[SpS2t;SpS2'];
                  SpS3t=[SpS3t;SpS3'];
                 
                  
                  NameWT{a}=pwd;
                  
                  disp('Analysis done')
                  disp(' ')
                  a=a+1; 
                  end
              end
              
             else
                 
                 try
                   
                  [DurS,DurR,DurW,StateBefS,StateBefR,StateBefW,SpS1,SpS2,SpS3,SpR1,SpR2,SpR3,SpW1,SpW2,SpW3,freq,rS,pS,rR,pR,rW,pW,NbSpi,NbSpiR,NbSpiW]=AnalyseEvolMarie(RemovePreEpoch);                
                  
                  try
                  test=NbSpi';
                  test=test(:);
                  NbSpitKO=[NbSpitKO;test'];
                  
                  test=NbSpiR';
                  test=test(:);
                  NbSpiRtKO=[NbSpiRtKO;test'];
                  
                  test=NbSpiW';
                  test=test(:);
                  NbSpiWtKO=[NbSpiWtKO;test'];
                  
                  DurStKO=[DurStKO;DurS];
                  StateBefStKO=[StateBefStKO;StateBefS];
                  rStKO(b)=rS;
                  pStKO(b)=pS;
                  SpS1tKO=[SpS1tKO;SpS1'];
                  SpS2tKO=[SpS2tKO;SpS2'];
                  SpS3tKO=[SpS3tKO;SpS3'];
                  
                  NameKO{b}=pwd;
                  
                  disp('Analysis done')
                  disp(' ')
                  b=b+1;
                  
                  end
                  
                  

              end 

             
             end
             
             end
             
        end
    end
%     
% [r,p,var,accumulated,MAP]=PlotCorrelationDensity(DurSt(:,5),DurSt(:,3),70,0,100);   close
% [r2,p2,var2,accumulated2,MAP2]=PlotCorrelationDensity(StateBefSt(:,4),DurSt(:,3),300,0,100); close 

try
figure('color',[1 1 1]), 
subplot(2,5,1), plot(DurSt(:,5),DurSt(:,3),'k.','markersize',1)
% subplot(2,5,2), imagesc(10:20,1:100,MAP(:,:,1)), axis xy

[H,h1,h2]=hist2d(DurSt(:,5),DurSt(:,3),9:0.5:21,-5:5:105);
subplot(2,5,2), contourf(h1-0.5,h2-5,SmoothDec(H',[1 1]),[0:0.1:9],'linestyle','none'), axis xy
hold on, plot(DurSt(:,5),DurSt(:,3),'w.','markersize',1)

% subplot(2,5,2), imagesc(10:20,1:100,log(MAP(:,:,1)+eps)), axis xy, caxis([-2 -0.7])
subplot(2,5,3), plot(DurSt(:,5),DurSt(:,6),'k.','markersize',1)
subplot(2,5,4), plot(DurSt(:,5),DurSt(:,7),'k.','markersize',1)
subplot(2,5,5), plot(DurSt(:,5),DurSt(:,8),'k.','markersize',1)

subplot(2,5,6), plot(StateBefSt(:,4),DurSt(:,3),'k.','markersize',1)
[H,h1,h2]=hist2d(StateBefSt(:,4),DurSt(:,3),9:0.5:21,-5:5:105);
subplot(2,5,7), contourf(h1-0.5,h2-5,SmoothDec(H',[1 1]),[0:0.1:9],'linestyle','none'), axis xy
hold on, plot(StateBefSt(:,4),DurSt(:,3),'w.','markersize',1)
% subplot(2,5,7), imagesc(10:20,1:100,MAP2(:,:,1)), axis xy
% subplot(2,5,7), imagesc(0:100,1:100,log(MAP2(:,:,1)+eps)), axis xy, caxis([-2 -0.7])
subplot(2,5,8), plot(StateBefSt(:,4),DurSt(:,6),'k.','markersize',1)
subplot(2,5,9), plot(StateBefSt(:,4),DurSt(:,7),'k.','markersize',1)
subplot(2,5,10), plot(StateBefSt(:,4),DurSt(:,8),'k.','markersize',1)
    
% [r,p,var,accumulated,MAPKO]=PlotCorrelationDensity(DurStKO(:,5),DurStKO(:,3),70,0,100);   close
% [r2,p2,var2,accumulated2,MAP2KO]=PlotCorrelationDensity(StateBefStKO(:,4),DurStKO(:,3),300,0,100); close 

figure('color',[1 1 1]), 
subplot(2,5,1), plot(DurStKO(:,5),DurStKO(:,3),'k.','markersize',1)
[H,h1,h2]=hist2d(DurStKO(:,5),DurStKO(:,3),9:0.5:21,-5:5:105);
subplot(2,5,2), contourf(h1-0.5,h2-5,SmoothDec(H',[1 1]),[0:0.1:9],'linestyle','none'), axis xy
hold on, plot(DurStKO(:,5),DurStKO(:,3),'w.','markersize',1)

% subplot(2,5,2), imagesc(10:20,1:100,MAPKO(:,:,1)), axis xy
% subplot(2,5,2), imagesc(10:20,1:100,log(MAPKO(:,:,1)+eps)), axis xy, caxis([-2 -0.7])
subplot(2,5,3), plot(DurStKO(:,5),DurStKO(:,6),'k.','markersize',1)
subplot(2,5,4), plot(DurStKO(:,5),DurStKO(:,7),'k.','markersize',1)
subplot(2,5,5), plot(DurStKO(:,5),DurStKO(:,8),'k.','markersize',1)

subplot(2,5,6), plot(StateBefStKO(:,4),DurStKO(:,3),'k.','markersize',1)
[H,h1,h2]=hist2d(StateBefStKO(:,4),DurStKO(:,3),9:0.5:21,-5:5:105);
subplot(2,5,7), contourf(h1-0.5,h2-5,SmoothDec(H',[1 1]),[0:0.1:9],'linestyle','none'), axis xy
hold on, plot(StateBefStKO(:,4),DurStKO(:,3),'w.','markersize',1)
% subplot(2,5,7), imagesc(10:20,1:100,MAP2KO(:,:,1)), axis xy
% subplot(2,5,7), imagesc(0:100,1:100,log(MAP2KO(:,:,1)+eps)), axis xy, caxis([-2 -0.7])
subplot(2,5,8), plot(StateBefStKO(:,4),DurStKO(:,6),'k.','markersize',1)
subplot(2,5,9), plot(StateBefStKO(:,4),DurStKO(:,7),'k.','markersize',1)
subplot(2,5,10), plot(StateBefStKO(:,4),DurStKO(:,8),'k.','markersize',1)


end


try
    
%  
% figure('color',[1 1 1]), 
% subplot(3,4,1), plot(NbSpi(:,1),'ko-'),title('SWSEpoch')
% hold on, plot(1,NbSpi(1,1),'ko','markerfacecolor','r')
% hold on, plot(2,NbSpi(2,1),'ko','markerfacecolor','k')
% plot(NbSpi(:,4),'ro-')
% subplot(3,4,2), plot(NbSpi(:,2)/60,'ko-')
% hold on, plot(1,NbSpi(1,2)/60,'ko','markerfacecolor','r')
% hold on, plot(2,NbSpi(2,2)/60,'ko','markerfacecolor','k')
% plot(NbSpi(:,5)/60,'ro-')
% subplot(3,4,3), plot(NbSpi(:,3),'ko-')
% hold on, plot(1,NbSpi(1,3),'ko','markerfacecolor','r')
% hold on, plot(2,NbSpi(2,3),'ko','markerfacecolor','k')
% plot(NbSpi(:,6),'ro-')
% ylim([0 0.12])
% subplot(3,4,4), plot(NbSpi(:,3)./NbSpi(:,6)*100,'bo-')
%     
    
figure('color',[1 1 1]), 
subplot(2,4,1), hold on
plot(NbSpit(:,1:6:end)','k.-'),title('SWSEpoch WT')
plot(NbSpit(:,4:6:end)','r.-')
subplot(2,4,2), hold on, plot(NbSpit(:,2:6:end)'/60,'k.-')
%hold on, plot(1,NbSpit(:,2:6:end)'/60,'ko','markerfacecolor','r')
%hold on, plot(2,NbSpit(:,2:6:end)'/60,'ko','markerfacecolor','k')
plot(NbSpit(:,5:6:end)'/60,'r.-')
subplot(2,4,3), hold on, plot(NbSpit(:,3:6:end)','k.-')
%hold on, plot(1,NbSpit(1,3:6:end)','ko','markerfacecolor','r')
%hold on, plot(2,NbSpit(2,3:6:end)','ko','markerfacecolor','k')
plot(NbSpit(:,6:6:end)','r.-')
ylim([0 0.12])
subplot(2,4,4), plot(NbSpit(:,3:6:end)'./NbSpit(:,6:6:end)'*100,'b.-')
hold on, plot(NbSpit(:,3:6:end)'./(ones(size(NbSpit,2)/6,1)*NbSpit(:,3+6)')*100,'m.-')
  
subplot(2,4,5), hold on
plot(nanmean(NbSpit(:,1:6:end)',2),'k.-'),title('SWSEpoch')
plot(nanmean(NbSpit(:,4:6:end)',2),'r.-')
subplot(2,4,6), hold on, plot(nanmean(NbSpit(:,2:6:end)'/60,2),'k.-')
%hold on, plot(1,NbSpit(:,2:6:end)'/60,'ko','markerfacecolor','r')
%hold on, plot(2,NbSpit(:,2:6:end)'/60,'ko','markerfacecolor','k')
plot(nanmean(NbSpit(:,5:6:end)'/60,2),'r.-')
subplot(2,4,7), hold on, plot(nanmean(NbSpit(:,3:6:end)',2),'k.-')
%hold on, plot(1,NbSpit(1,3:6:end)','ko','markerfacecolor','r')
%hold on, plot(2,NbSpit(2,3:6:end)','ko','markerfacecolor','k')
plot(nanmean(NbSpit(:,6:6:end)',2),'r.-')
ylim([0 0.12])
subplot(2,4,8), plot(nanmean(NbSpit(:,3:6:end)'./NbSpit(:,6:6:end)'*100,2),'b.-')
hold on, plot(nanmean(NbSpit(:,3:6:end)'./(ones(size(NbSpit,2)/6,1)*NbSpit(:,3+6)')*100,2),'m.-')



   
figure('color',[1 1 1]), 
subplot(2,4,1), hold on
plot(NbSpitKO(:,1:6:end)','k.-'),title('SWSEpoch KO')
plot(NbSpitKO(:,4:6:end)','r.-')
subplot(2,4,2), hold on, plot(NbSpitKO(:,2:6:end)'/60,'k.-')
%hold on, plot(1,NbSpit(:,2:6:end)'/60,'ko','markerfacecolor','r')
%hold on, plot(2,NbSpit(:,2:6:end)'/60,'ko','markerfacecolor','k')
plot(NbSpitKO(:,5:6:end)'/60,'r.-')
subplot(2,4,3), hold on, plot(NbSpitKO(:,3:6:end)','k.-')
%hold on, plot(1,NbSpit(1,3:6:end)','ko','markerfacecolor','r')
%hold on, plot(2,NbSpit(2,3:6:end)','ko','markerfacecolor','k')
plot(NbSpitKO(:,6:6:end)','r.-')
ylim([0 0.12])
subplot(2,4,4), plot(NbSpitKO(:,3:6:end)'./NbSpitKO(:,6:6:end)'*100,'b.-')
hold on, plot(NbSpitKO(:,3:6:end)'./(ones(size(NbSpitKO,2)/6,1)*NbSpitKO(:,3+6)')*100,'m.-')
  
subplot(2,4,5), hold on
plot(nanmean(NbSpitKO(:,1:6:end)',2),'k.-'),title('SWSEpoch')
plot(nanmean(NbSpitKO(:,4:6:end)',2),'r.-')
subplot(2,4,6), hold on, plot(nanmean(NbSpitKO(:,2:6:end)'/60,2),'k.-')
%hold on, plot(1,NbSpit(:,2:6:end)'/60,'ko','markerfacecolor','r')
%hold on, plot(2,NbSpit(:,2:6:end)'/60,'ko','markerfacecolor','k')
plot(nanmean(NbSpitKO(:,5:6:end)'/60,2),'r.-')
subplot(2,4,7), hold on, plot(nanmean(NbSpitKO(:,3:6:end)',2),'k.-')
%hold on, plot(1,NbSpit(1,3:6:end)','ko','markerfacecolor','r')
%hold on, plot(2,NbSpit(2,3:6:end)','ko','markerfacecolor','k')
plot(nanmean(NbSpitKO(:,6:6:end)',2),'r.-')
ylim([0 0.12])
subplot(2,4,8), plot(nanmean(NbSpitKO(:,3:6:end)'./NbSpitKO(:,6:6:end)'*100,2),'b.-')
hold on, plot(nanmean(NbSpitKO(:,3:6:end)'./(ones(size(NbSpitKO,2)/6,1)*NbSpitKO(:,3+6)')*100,2),'m.-')









% 
% 
% figure('color',[1 1 1]), 
% subplot(2,4,1), hold on
% plot(NbSpiRt(:,1:6:end)','ko-'),title('REMEpoch WT')
% plot(NbSpiRt(:,4:6:end)','ro-')
% subplot(2,4,2), hold on, plot(NbSpiRt(:,2:6:end)'/60,'ko-')
% %hold on, plot(1,NbSpit(:,2:6:end)'/60,'ko','markerfacecolor','r')
% %hold on, plot(2,NbSpit(:,2:6:end)'/60,'ko','markerfacecolor','k')
% plot(NbSpiRt(:,5:6:end)'/60,'ro-')
% subplot(2,4,3), hold on, plot(NbSpiRt(:,3:6:end)','ko-')
% %hold on, plot(1,NbSpit(1,3:6:end)','ko','markerfacecolor','r')
% %hold on, plot(2,NbSpit(2,3:6:end)','ko','markerfacecolor','k')
% plot(NbSpiRt(:,6:6:end)','ro-')
% ylim([0 0.12])
% subplot(2,4,4), plot(NbSpiRt(:,3:6:end)'./NbSpiRt(:,6:6:end)'*100,'bo-')
% hold on, plot(NbSpiRt(:,3:6:end)'./(ones(size(NbSpiRt,2)/6,1)*NbSpiRt(:,3+6)')*100,'mo-')
%   
% subplot(2,4,5), hold on
% plot(nanmean(NbSpiRt(:,1:6:end)',2),'ko-'),title('REMEpoch')
% plot(nanmean(NbSpiRt(:,4:6:end)',2),'ro-')
% subplot(2,4,6), hold on, plot(nanmean(NbSpiRt(:,2:6:end)'/60,2),'ko-')
% %hold on, plot(1,NbSpit(:,2:6:end)'/60,'ko','markerfacecolor','r')
% %hold on, plot(2,NbSpit(:,2:6:end)'/60,'ko','markerfacecolor','k')
% plot(nanmean(NbSpiRt(:,5:6:end)'/60,2),'ro-')
% subplot(2,4,7), hold on, plot(nanmean(NbSpiRt(:,3:6:end)',2),'ko-')
% %hold on, plot(1,NbSpit(1,3:6:end)','ko','markerfacecolor','r')
% %hold on, plot(2,NbSpit(2,3:6:end)','ko','markerfacecolor','k')
% plot(nanmean(NbSpiRt(:,6:6:end)',2),'ro-')
% ylim([0 0.12])
% subplot(2,4,8), plot(nanmean(NbSpiRt(:,3:6:end)'./NbSpiRt(:,6:6:end)'*100,2),'bo-')
% hold on, plot(nanmean(NbSpiRt(:,3:6:end)'./(ones(size(NbSpiRt,2)/6,1)*NbSpiRt(:,3+6)')*100,2),'mo-')
% 
% 
% 
%    
% figure('color',[1 1 1]), 
% subplot(2,4,1), hold on
% plot(NbSpiRtKO(:,1:6:end)','ko-'),title('REMEpoch KO')
% plot(NbSpiRtKO(:,4:6:end)','ro-')
% subplot(2,4,2), hold on, plot(NbSpiRtKO(:,2:6:end)'/60,'ko-')
% %hold on, plot(1,NbSpit(:,2:6:end)'/60,'ko','markerfacecolor','r')
% %hold on, plot(2,NbSpit(:,2:6:end)'/60,'ko','markerfacecolor','k')
% plot(NbSpiRtKO(:,5:6:end)'/60,'ro-')
% subplot(2,4,3), hold on, plot(NbSpiRtKO(:,3:6:end)','ko-')
% %hold on, plot(1,NbSpit(1,3:6:end)','ko','markerfacecolor','r')
% %hold on, plot(2,NbSpit(2,3:6:end)','ko','markerfacecolor','k')
% plot(NbSpiRtKO(:,6:6:end)','ro-')
% ylim([0 0.12])
% subplot(2,4,4), plot(NbSpiRtKO(:,3:6:end)'./NbSpiRtKO(:,6:6:end)'*100,'bo-')
% hold on, plot(NbSpiRtKO(:,3:6:end)'./(ones(size(NbSpiRtKO,2)/6,1)*NbSpiRtKO(:,3+6)')*100,'mo-')
%   
% subplot(2,4,5), hold on
% plot(nanmean(NbSpiRtKO(:,1:6:end)',2),'ko-'),title('REMEpoch')
% plot(nanmean(NbSpiRtKO(:,4:6:end)',2),'ro-')
% subplot(2,4,6), hold on, plot(nanmean(NbSpiRtKO(:,2:6:end)'/60,2),'ko-')
% %hold on, plot(1,NbSpit(:,2:6:end)'/60,'ko','markerfacecolor','r')
% %hold on, plot(2,NbSpit(:,2:6:end)'/60,'ko','markerfacecolor','k')
% plot(nanmean(NbSpiRtKO(:,5:6:end)'/60,2),'ro-')
% subplot(2,4,7), hold on, plot(nanmean(NbSpiRtKO(:,3:6:end)',2),'ko-')
% %hold on, plot(1,NbSpit(1,3:6:end)','ko','markerfacecolor','r')
% %hold on, plot(2,NbSpit(2,3:6:end)','ko','markerfacecolor','k')
% plot(nanmean(NbSpiRtKO(:,6:6:end)',2),'ro-')
% ylim([0 0.12])
% subplot(2,4,8), plot(nanmean(NbSpiRtKO(:,3:6:end)'./NbSpiRtKO(:,6:6:end)'*100,2),'bo-')
% hold on, plot(nanmean(NbSpiRtKO(:,3:6:end)'./(ones(size(NbSpiRtKO,2)/6,1)*NbSpiRtKO(:,3+6)')*100,2),'mo-')
% 
% 
% 

















% 
% 
% figure('color',[1 1 1]), 
% subplot(2,4,1), hold on
% plot(NbSpiWt(:,1:6:end)','ko-'),title('Wake WT')
% plot(NbSpiWt(:,4:6:end)','ro-')
% subplot(2,4,2), hold on, plot(NbSpiWt(:,2:6:end)'/60,'ko-')
% %hold on, plot(1,NbSpit(:,2:6:end)'/60,'ko','markerfacecolor','r')
% %hold on, plot(2,NbSpit(:,2:6:end)'/60,'ko','markerfacecolor','k')
% plot(NbSpiWt(:,5:6:end)'/60,'ro-')
% subplot(2,4,3), hold on, plot(NbSpiWt(:,3:6:end)','ko-')
% %hold on, plot(1,NbSpit(1,3:6:end)','ko','markerfacecolor','r')
% %hold on, plot(2,NbSpit(2,3:6:end)','ko','markerfacecolor','k')
% plot(NbSpiWt(:,6:6:end)','ro-')
% ylim([0 0.12])
% subplot(2,4,4), plot(NbSpiWt(:,3:6:end)'./NbSpiWt(:,6:6:end)'*100,'bo-')
% hold on, plot(NbSpiWt(:,3:6:end)'./(ones(size(NbSpiWt,2)/6,1)*NbSpiWt(:,3+6)')*100,'mo-')
%   
% subplot(2,4,5), hold on
% plot(nanmean(NbSpiWt(:,1:6:end)',2),'ko-'),title('Wake')
% plot(nanmean(NbSpiWt(:,4:6:end)',2),'ro-')
% subplot(2,4,6), hold on, plot(nanmean(NbSpiWt(:,2:6:end)'/60,2),'ko-')
% %hold on, plot(1,NbSpit(:,2:6:end)'/60,'ko','markerfacecolor','r')
% %hold on, plot(2,NbSpit(:,2:6:end)'/60,'ko','markerfacecolor','k')
% plot(nanmean(NbSpiWt(:,5:6:end)'/60,2),'ro-')
% subplot(2,4,7), hold on, plot(nanmean(NbSpiWt(:,3:6:end)',2),'ko-')
% %hold on, plot(1,NbSpit(1,3:6:end)','ko','markerfacecolor','r')
% %hold on, plot(2,NbSpit(2,3:6:end)','ko','markerfacecolor','k')
% plot(nanmean(NbSpiWt(:,6:6:end)',2),'ro-')
% ylim([0 0.12])
% subplot(2,4,8), plot(nanmean(NbSpiWt(:,3:6:end)'./NbSpiWt(:,6:6:end)'*100,2),'bo-')
% hold on, plot(nanmean(NbSpiWt(:,3:6:end)'./(ones(size(NbSpiWt,2)/6,1)*NbSpiWt(:,3+6)')*100,2),'mo-')
% 
% 
% 
%    
% figure('color',[1 1 1]), 
% subplot(2,4,1), hold on
% plot(NbSpiWtKO(:,1:6:end)','ko-'),title('Wake KO')
% plot(NbSpiWtKO(:,4:6:end)','ro-')
% subplot(2,4,2), hold on, plot(NbSpiWtKO(:,2:6:end)'/60,'ko-')
% %hold on, plot(1,NbSpit(:,2:6:end)'/60,'ko','markerfacecolor','r')
% %hold on, plot(2,NbSpit(:,2:6:end)'/60,'ko','markerfacecolor','k')
% plot(NbSpiWtKO(:,5:6:end)'/60,'ro-')
% subplot(2,4,3), hold on, plot(NbSpiWtKO(:,3:6:end)','ko-')
% %hold on, plot(1,NbSpit(1,3:6:end)','ko','markerfacecolor','r')
% %hold on, plot(2,NbSpit(2,3:6:end)','ko','markerfacecolor','k')
% plot(NbSpiWtKO(:,6:6:end)','ro-')
% ylim([0 0.12])
% subplot(2,4,4), plot(NbSpiWtKO(:,3:6:end)'./NbSpiWtKO(:,6:6:end)'*100,'bo-')
% hold on, plot(NbSpiWtKO(:,3:6:end)'./(ones(size(NbSpiWtKO,2)/6,1)*NbSpiWtKO(:,3+6)')*100,'mo-')
%   
% subplot(2,4,5), hold on
% plot(nanmean(NbSpiWtKO(:,1:6:end)',2),'ko-'),title('Wake')
% plot(nanmean(NbSpiWtKO(:,4:6:end)',2),'ro-')
% subplot(2,4,6), hold on, plot(nanmean(NbSpiWtKO(:,2:6:end)'/60,2),'ko-')
% %hold on, plot(1,NbSpit(:,2:6:end)'/60,'ko','markerfacecolor','r')
% %hold on, plot(2,NbSpit(:,2:6:end)'/60,'ko','markerfacecolor','k')
% plot(nanmean(NbSpiWtKO(:,5:6:end)'/60,2),'ro-')
% subplot(2,4,7), hold on, plot(nanmean(NbSpiWtKO(:,3:6:end)',2),'ko-')
% %hold on, plot(1,NbSpit(1,3:6:end)','ko','markerfacecolor','r')
% %hold on, plot(2,NbSpit(2,3:6:end)','ko','markerfacecolor','k')
% plot(nanmean(NbSpiWtKO(:,6:6:end)',2),'ro-')
% ylim([0 0.12])
% subplot(2,4,8), plot(nanmean(NbSpiWtKO(:,3:6:end)'./NbSpiWtKO(:,6:6:end)'*100,2),'bo-')
% hold on, plot(nanmean(NbSpiWtKO(:,3:6:end)'./(ones(size(NbSpiWtKO,2)/6,1)*NbSpiWtKO(:,3+6)')*100,2),'mo-')
% 
% 
% 







end




try
    
figure('color',[1 1 1]), 
subplot(3,2,1), plot(freq,SpS1t','k'), hold on, plot(freq,SpS1tKO','r')
subplot(3,2,2), plot(freq,mean(SpS1t)','k'), hold on, plot(freq,mean(SpS1tKO)','r')
subplot(3,2,3), plot(freq,SpS2t','k'), hold on, plot(freq,SpS2tKO','r')
subplot(3,2,4), plot(freq,mean(SpS2t)','k'), hold on, plot(freq,mean(SpS2tKO)','r')
subplot(3,2,5), plot(freq,SpS3t','k'), hold on, plot(freq,SpS3tKO','r')
subplot(3,2,6), plot(freq,mean(SpS3t)','k'), hold on, plot(freq,mean(SpS3tKO)','r')    
    
    
end



try
  
tiDur{1}='Dur SWS (s)';
tiDur{2}='Dur Slow Osc (s)';
tiDur{3}='Ratio Slow Osc';
tiDur{4}='Start SWS';
tiDur{5}='Hour SWS';
tiDur{6}='Power SWS';
tiDur{7}='Power Slow Osc';
tiDur{8}='Power No Slow osc';

id=find(DurSt(:,2)>3);
idKO=find(DurStKO(:,2)>3);

figure('color',[1 1 1]), 
for k=1:8
    subplot(2,4,k), PlotErrorBar2(DurSt(id,k),DurStKO(idKO,k),0,0)
set(gca,'xtick',[1:2])
set(gca,'xticklabel',{'WT', 'KO'})
ylabel(tiDur{k})
end


idw=find(DurWt(:,2)>3);
idwKO=find(DurWtKO(:,2)>3);

figure('color',[1 1 1]), 
for k=1:8
    subplot(2,4,k), PlotErrorBar2(DurWt(idw,k),DurWtKO(idwKO,k),0,0)
set(gca,'xtick',[1:2])
set(gca,'xticklabel',{'WT', 'KO'})
ylabel(tiDur{k})
end



end


    