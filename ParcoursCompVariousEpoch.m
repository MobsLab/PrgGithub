%ParcoursCompVariousEpoch

%NameDir={'BASAL'};

a=1;
b=1;
          Spb1=[];
          Spb2=[];
          Spb3=[];
          Spb4=[];
          Spb5=[];          
          Sppf1=[];
          Sppf2=[];
          Sppf3=[];
          Sppf4=[];
          Sppf5=[];          
          Sppa1=[];
          Sppa2=[];
          Sppa3=[];
          Sppa4=[];
          Sppa5=[];          
          Spb1KO=[];
          Spb2KO=[];
          Spb3KO=[];
          Spb4KO=[];
          Spb5KO=[];          
          Sppf1KO=[];
          Sppf2KO=[];
          Sppf3KO=[];
          Sppf4KO=[];
          Sppf5KO=[];          
          Sppa1KO=[];
          Sppa2KO=[];
          Sppa3KO=[];
          Sppa4KO=[];
          Sppa5KO=[];
          
freq=0.1:0.1:20;          

%for i=1:length(NameDir)
 
if 0
    Dir=PathForExperimentsML('BASAL');
    %Dir=RestrictPathForExperiment(Dir,'Group','WT');
else   
    Dir1=PathForExperimentsBULB('SLEEPBasal');
    Dir1=RestrictPathForExperiment(Dir1,'Group','CTRL');
    Dir2=PathForExperimentsML('BASAL');%'BASAL','PLETHYSMO','DPCPX', 'LPS', 'CANAB';
    % Dir2=RestrictPathForExperiment(Dir2,'Group',{'WT','C57'});
    Dir=MergePathForExperiment(Dir1,Dir2);
end

for man=1:length(Dir.path)
disp('  ')
disp(Dir.path{man})
disp(Dir.group{man})
disp(' ')
cd(Dir.path{man})
 try
    
    clear SWSEpoch 
    clear Wake 
    clear REMEpoch 
    clear TotalNoiseEpoch
    load StateEpochSB SWSEpoch Wake REMEpoch TotalNoiseEpoch
    clear PreEpoch
    load behavResources PreEpoch
    clear c
     clear SpBulb1
     clear SpBulb2
     clear SpBulb3
     clear SpBulb4
     clear SpBulb5     
     clear SpPFC1
     clear SpPFC2
     clear SpPFC3
     clear SpPFC4
     clear SpPFC5     
     clear SpPaC1
     clear SpPaC2
     clear SpPaC3
     clear SpPaC4   
     clear SpPaC5  
     clear DurPeriods
     clear Ct1
     clear Bt1
     clear Ct2
     clear Bt2
    clear Prop
    clear vX
 if Dir.group{man}(1)=='W'|Dir.group{man}(1)=='C'


     
          try
              PreEpoch;
         [c,SpBulb1,SpBulb2,SpBulb3,SpBulb4,SpBulb5,SpPFC1,SpPFC2,SpPFC3,SpPFC4,SpPFC5,SpPaC1,SpPaC2,SpPaC3,SpPaC4,SpPaC5,f,Ct1,Bt1,Ct2,Bt2,DurPeriods,Prop,vX,mHpc1a(a,:),sHpc1a,tpsHpc1a,mHpc1b(a,:),sHpc1b,tpsHpc1b,mHpc1c(a,:),sHpc1c,tpsHpc1c,mHpc2a(a,:),sHpc2a,tpsHpc2a,mHpc2b(a,:),sHpc2b,tpsHpc2b,mHpc2c(a,:),sHpc2c,tpsHpc2c]=CompVariousEpoch(PreEpoch); close all  
          catch
         [c,SpBulb1,SpBulb2,SpBulb3,SpBulb4,SpBulb5,SpPFC1,SpPFC2,SpPFC3,SpPFC4,SpPFC5,SpPaC1,SpPaC2,SpPaC3,SpPaC4,SpPaC5,f,Ct1,Bt1,Ct2,Bt2,DurPeriods,Prop,vX,mHpc1a(a,:),sHpc1a,tpsHpc1a,mHpc1b(a,:),sHpc1b,tpsHpc1b,mHpc1c(a,:),sHpc1c,tpsHpc1c,mHpc2a(a,:),sHpc2a,tpsHpc2a,mHpc2b(a,:),sHpc2b,tpsHpc2b,mHpc2c(a,:),sHpc2c,tpsHpc2c]=CompVariousEpoch;  close all   
          end
          cellnames{a}=pwd;
          DelPFCWT(a,:)=c(1,:);
          DelPaCWT(a,:)=c(2,:);
          RipWT(a,:)=c(3,:);
          SpiPFCWT(a,:)=c(4,:);
          SpiPaCWT(a,:)=c(5,:);  
          DtWT(a,:)=DurPeriods;
          CrossWT{a,1}=Ct1;
          CrossWT{a,2}=Bt1; 
          CrossWT{a,3}=Ct2; 
          CrossWT{a,4}=Bt2;          
          Pwt{a}=Prop;
          Vwt{a}=vX;          
          a=a+1;
%                       SpBulb1=tsd(f,SpBulb1');
%             SpBulb1=Data(Restrict(SpBulb1,freq))';
%             SpBulb2=tsd(f,SpBulb2');
%             SpBulb2=Data(Restrict(SpBulb2,freq))';
%             SpBulb3=tsd(f,SpBulb3');
%             SpBulb3=Data(Restrict(SpBulb3,freq))';
%             SpBulb4=tsd(f,SpBulb4');
%             SpBulb4=Data(Restrict(SpBulb4,freq))';
%  
%             SpPFC1=tsd(f,SpPFC1');
%             SpPFC1=Data(Restrict(SpPFC1,freq))';
%             SpPFC2=tsd(f,SpPFC2');
%             SpPFC2=Data(Restrict(SpPFC2,freq))';
%             SpPFC3=tsd(f,SpPFC3');
%             SpPFC3=Data(Restrict(SpPFC3,freq))';
%             SpPFC4=tsd(f,SpPFC4');
%             SpPFC4=Data(Restrict(SpPFC4,freq))';
%             
%             SpPaC1=tsd(f,SpPaC1');
%             SpPaC1=Data(Restrict(SpPaC1,freq))';
%             SpPaC2=tsd(f,SpPFC2');
%             SpPaC2=Data(Restrict(SpPaC2,freq))';
%             SpPaC3=tsd(f,SpPaC3');
%             SpPaC3=Data(Restrict(SpPaC3,freq))';
%             SpPaC4=tsd(f,SpPaC4');
%             SpPaC4=Data(Restrict(SpPaC4,freq))';
            
          Spb1=[Spb1;SpBulb1];
          Spb2=[Spb2;SpBulb2];
          Spb3=[Spb3;SpBulb3];
          Spb4=[Spb4;SpBulb4];
          Spb5=[Spb5;SpBulb5];
          
          Sppf1=[Sppf1;SpPFC1];
          Sppf2=[Sppf2;SpPFC2];
          Sppf3=[Sppf3;SpPFC3];
          Sppf4=[Sppf4;SpPFC4];
          Sppf5=[Sppf5;SpPFC5];
          
          Sppa1=[Sppa1;SpPaC1];
          Sppa2=[Sppa2;SpPaC2];
          Sppa3=[Sppa3;SpPaC3];
          Sppa4=[Sppa4;SpPaC4];
          Sppa5=[Sppa5;SpPaC5];
          


 else
           try

               try
              PreEpoch;
         [c,SpBulb1,SpBulb2,SpBulb3,SpBulb4,SpBulb5,SpPFC1,SpPFC2,SpPFC3,SpPFC4,SpPFC5,SpPaC1,SpPaC2,SpPaC3,SpPaC4,SpPaC5,f,Ct1,Bt1,Ct2,Bt2,DurPeriods,Prop,vX,mHpc1aKO(b,:),sHpc1aKO,tpsHpc1aKO,mHpc1bKO(b,:),sHpc1bKO,tpsHpc1bKO,mHpc1cKO(b,:),sHpc1cKO,tpsHpc1cKO,mHpc2aKO(b,:),sHpc2aKO,tpsHpc2aKO,mHpc2bKO(b,:),sHpc2bKO,tpsHpc2bKO,mHpc2cKO(b,:),sHpc2cKO,tpsHpc2cKO]=CompVariousEpoch(PreEpoch); close all  
          catch
         [c,SpBulb1,SpBulb2,SpBulb3,SpBulb4,SpBulb5,SpPFC1,SpPFC2,SpPFC3,SpPFC4,SpPFC5,SpPaC1,SpPaC2,SpPaC3,SpPaC4,SpPaC5,f,Ct1,Bt1,Ct2,Bt2,DurPeriods,Prop,vX,mHpc1aKO(b,:),sHpc1aKO,tpsHpc1aKO,mHpc1bKO(b,:),sHpc1bKO,tpsHpc1bKO,mHpc1cKO(b,:),sHpc1cKO,tpsHpc1cKO,mHpc2aKO(b,:),sHpc2aKO,tpsHpc2aKO,mHpc2bKO(b,:),sHpc2bKO,tpsHpc2bKO,mHpc2cKO(b,:),sHpc2cKO,tpsHpc2cKO]=CompVariousEpoch;      close all  
               end
        cellnamesKO{b}=pwd;
          DtKO(b,:)=DurPeriods;
          DelPFCKO(b,:)=c(1,:);
          DelPaCKO(b,:)=c(2,:);
          RipKO(b,:)=c(3,:);
          SpiPFCKO(b,:)=c(4,:);
          SpiPaCKO(b,:)=c(5,:);    
          CrossKO{b,1}=Ct1;
          CrossKO{b,2}=Bt1; 
          CrossKO{b,3}=Ct2; 
          CrossKO{b,4}=Bt2;  
          Pko{b}=Prop;
          Vko{b}=vX;           
           b=b+1;

%             SpBulb1=tsd(f,SpBulb1');
%             SpBulb1=Data(Restrict(SpBulb1,freq))';
%             SpBulb2=tsd(f,SpBulb2');
%             SpBulb2=Data(Restrict(SpBulb2,freq))';
%             SpBulb3=tsd(f,SpBulb3');
%             SpBulb3=Data(Restrict(SpBulb3,freq))';
%             SpBulb4=tsd(f,SpBulb4');
%             SpBulb4=Data(Restrict(SpBulb4,freq))';
%  
%             SpPFC1=tsd(f,SpPFC1');
%             SpPFC1=Data(Restrict(SpPFC1,freq))';
%             SpPFC2=tsd(f,SpPFC2');
%             SpPFC2=Data(Restrict(SpPFC2,freq))';
%             SpPFC3=tsd(f,SpPFC3');
%             SpPFC3=Data(Restrict(SpPFC3,freq))';
%             SpPFC4=tsd(f,SpPFC4');
%             SpPFC4=Data(Restrict(SpPFC4,freq))';
%             
%             SpPaC1=tsd(f,SpPaC1');
%             SpPaC1=Data(Restrict(SpPaC1,freq))';
%             SpPaC2=tsd(f,SpPaC2');
%             SpPaC2=Data(Restrict(SpPaC2,freq))';
%             SpPaC3=tsd(f,SpPaC3');
%             SpPaC3=Data(Restrict(SpPaC3,freq))';
%             SpPaC4=tsd(f,SpPaC4');
%             SpPaC4=Data(Restrict(SpPaC4,freq))';
            
          Spb1KO=[Spb1KO;SpBulb1];
          Spb2KO=[Spb2KO;SpBulb2];
          Spb3KO=[Spb3KO;SpBulb3];
          Spb4KO=[Spb4KO;SpBulb4];
          Spb5KO=[Spb5KO;SpBulb5];
          
          Sppf1KO=[Sppf1KO;SpPFC1];
          Sppf2KO=[Sppf2KO;SpPFC2];
          Sppf3KO=[Sppf3KO;SpPFC3];
          Sppf4KO=[Sppf4KO;SpPFC4];
          Sppf5KO=[Sppf5KO;SpPFC5];
          
          Sppa1KO=[Sppa1KO;SpPaC1];
          Sppa2KO=[Sppa2KO;SpPaC2];
          Sppa3KO=[Sppa3KO;SpPaC3];
          Sppa4KO=[Sppa4KO;SpPaC4];
          Sppa5KO=[Sppa5KO;SpPaC5];          
%            catch
%                keyboard
            end
           
     
 end
% catch
%     keyboard
end
 end
% end

% try
%     save('/home/vador/Dropbox/MOBsProjetBULB/FiguresDataClub_8juin2015/CrossCorr8juneML.mat','CrossW','Bt1','Bt2','Dir')
% end
f=freq;

tiOp{1}='S12';
tiOp{2}='S34';
tiOp{3}='Burst Delta';
tiOp{4}='Slow Bulb';
tiOp{5}='REM';

tic{1}='Delta Pfc';
tic{2}='Delta Par';
tic{3}='Ripples';
tic{4}='Spindles Pfc';
tic{5}='Spindles Par';

figure('color',[1 1 1])
subplot(5,2,1), PlotErrorBarN(DelPFCWT,0); ylabel(tic{1}),title('WT')
set(gca,'Xtick',[1:5])
set(gca,'XTickLabel',tiOp)
subplot(5,2,2),PlotErrorBarN(DelPFCKO,0);title('KO')
set(gca,'Xtick',[1:5])
set(gca,'XTickLabel',tiOp)

subplot(5,2,3),PlotErrorBarN(DelPaCWT,0); ylabel(tic{2})
set(gca,'Xtick',[1:5])
set(gca,'XTickLabel',tiOp)
subplot(5,2,4), PlotErrorBarN(DelPaCKO,0);
set(gca,'Xtick',[1:5])
set(gca,'XTickLabel',tiOp)

subplot(5,2,5),PlotErrorBarN(RipWT,0); ylabel(tic{3})
set(gca,'Xtick',[1:5])
set(gca,'XTickLabel',tiOp)
subplot(5,2,6), PlotErrorBarN(RipKO,0);
set(gca,'Xtick',[1:5])
set(gca,'XTickLabel',tiOp)

subplot(5,2,7),PlotErrorBarN(SpiPFCWT,0); ylabel(tic{4})
set(gca,'Xtick',[1:5])
set(gca,'XTickLabel',tiOp)
subplot(5,2,8), PlotErrorBarN(SpiPFCKO,0);
set(gca,'Xtick',[1:5])
set(gca,'XTickLabel',tiOp)

subplot(5,2,9),PlotErrorBarN(SpiPaCWT,0); ylabel(tic{5})
set(gca,'Xtick',[1:5])
set(gca,'XTickLabel',tiOp)
subplot(5,2,10), PlotErrorBarN(SpiPaCKO,0);
set(gca,'Xtick',[1:5])
set(gca,'XTickLabel',tiOp)




% figure('color',[1 1 1])
% subplot(2,4,1), imagesc(Spb1)
% subplot(2,4,2), imagesc(Spb2)
% subplot(2,4,3), imagesc(Spb3)
% subplot(2,4,4), imagesc(Spb4)
% 
% subplot(2,4,5), imagesc(Spb1KO)
% subplot(2,4,6), imagesc(Spb2KO)
% subplot(2,4,7), imagesc(Spb3KO)
% subplot(2,4,8), imagesc(Spb4KO)




% figure('color',[1 1 1])
% subplot(2,4,1), imagesc(Sppf1)
% subplot(2,4,2), imagesc(Sppf2)
% subplot(2,4,3), imagesc(Sppf3)
% subplot(2,4,4), imagesc(Sppf4)
% 
% subplot(2,4,5), imagesc(Sppf1KO)
% subplot(2,4,6), imagesc(Sppf2KO)
% subplot(2,4,7), imagesc(Sppf3KO)
% subplot(2,4,8), imagesc(Sppf4KO)
% 
% 
% figure('color',[1 1 1])
% subplot(2,4,1), imagesc(Sppa1)
% subplot(2,4,2), imagesc(Sppa2)
% subplot(2,4,3), imagesc(Sppa3)
% subplot(2,4,4), imagesc(Sppa4)
% 
% subplot(2,4,5), imagesc(Sppa1KO)
% subplot(2,4,6), imagesc(Sppa2KO)
% subplot(2,4,7), imagesc(Sppa3KO)
% subplot(2,4,8), imagesc(Sppa4KO)



figure('color',[1 1 1])
subplot(3,6,1), plot(f,Spb1(:,1:length(f)),'k'), title(tiOp{1}), hold on, plot(f,mean(Spb1(:,1:length(f))),'r','linewidth',2), ylim([0 2E6])
subplot(3,6,2), plot(f,Spb2(:,1:length(f)),'k'), title(tiOp{2}), hold on, plot(f,mean(Spb2(:,1:length(f))),'m','linewidth',2), ylim([0 2E6])
subplot(3,6,3), plot(f,Spb3(:,1:length(f)),'k'), title(tiOp{3}), hold on, plot(f,mean(Spb3(:,1:length(f))),'y','linewidth',2), ylim([0 2E6])
subplot(3,6,4), plot(f,Spb4(:,1:length(f)),'k'), title(tiOp{4}), hold on, plot(f,mean(Spb4(:,1:length(f))),'b','linewidth',2), ylim([0 2E6])
subplot(3,6,5), plot(f,Spb5(:,1:length(f)),'k'), title(tiOp{5}), hold on, plot(f,mean(Spb5(:,1:length(f))),'g','linewidth',2), ylim([0 2E6])
subplot(3,6,6), hold on, 
plot(f,mean(Spb1(:,1:length(f))),'r','linewidth',1), ylim([0 2E6]), title('WT'), ylabel('Bulb')
plot(f,mean(Spb2(:,1:length(f))),'m','linewidth',1), ylim([0 2E6])
plot(f,mean(Spb3(:,1:length(f))),'k','linewidth',1), ylim([0 2E6])
plot(f,mean(Spb4(:,1:length(f))),'b','linewidth',1), ylim([0 2E6])
plot(f,mean(Spb5(:,1:length(f))),'g','linewidth',1), ylim([0 2E6])

subplot(3,6,7), plot(f,Sppf1,'k'), hold on, plot(f,mean(Sppf1),'r','linewidth',2), ylim([0 3E5]), ylabel('PFC')
subplot(3,6,8), plot(f,Sppf2,'k'), hold on, plot(f,mean(Sppf2),'m','linewidth',2), ylim([0 3E5])
subplot(3,6,9), plot(f,Sppf3,'k'), hold on, plot(f,mean(Sppf3),'y','linewidth',2), ylim([0 3E5])
subplot(3,6,10), plot(f,Sppf4,'k'), hold on, plot(f,mean(Sppf4),'b','linewidth',2), ylim([0 3E5])
subplot(3,6,11), plot(f,Sppf5,'k'), hold on, plot(f,mean(Sppf5),'g','linewidth',2), ylim([0 3E5])
subplot(3,6,12), hold on, 
plot(f,mean(Sppf1),'r','linewidth',1), ylim([0 3E5])
plot(f,mean(Sppf2),'m','linewidth',1), ylim([0 3E5])
plot(f,mean(Sppf3),'k','linewidth',1), ylim([0 3E5])
plot(f,mean(Sppf4),'b','linewidth',1), ylim([0 3E5])
plot(f,mean(Sppf5),'g','linewidth',1), ylim([0 3E5])

subplot(3,6,13), plot(f,Sppa1,'k'), hold on, plot(f,mean(Sppa1),'r','linewidth',2), ylim([0 3E5]), ylabel('Par')
subplot(3,6,14), plot(f,Sppa2,'k'), hold on, plot(f,mean(Sppa2),'m','linewidth',2), ylim([0 3E5])
subplot(3,6,15), plot(f,Sppa3,'k'), hold on, plot(f,mean(Sppa3),'y','linewidth',2), ylim([0 3E5])
subplot(3,6,16), plot(f,Sppa4,'k'), hold on, plot(f,mean(Sppa4),'b','linewidth',2), ylim([0 3E5])
subplot(3,6,17), plot(f,Sppa5,'k'), hold on, plot(f,mean(Sppa5),'g','linewidth',2), ylim([0 3E5])
subplot(3,6,18), hold on, 
plot(f,mean(Sppa1),'r','linewidth',1), ylim([0 3E5])
plot(f,mean(Sppa2),'m','linewidth',1), ylim([0 3E5])
plot(f,mean(Sppa3),'k','linewidth',1), ylim([0 3E5])
plot(f,mean(Sppa4),'b','linewidth',1), ylim([0 3E5])
plot(f,mean(Sppa5),'g','linewidth',1), ylim([0 3E5])



figure('color',[1 1 1])
subplot(3,6,1), plot(f,Spb1KO(:,1:length(f)),'k'), title(tiOp{1}), hold on, plot(f,mean(Spb1KO(:,1:length(f))),'r','linewidth',2), ylim([0 2E6])
subplot(3,6,2), plot(f,Spb2KO(:,1:length(f)),'k'), title(tiOp{2}), hold on, plot(f,mean(Spb2KO(:,1:length(f))),'m','linewidth',2), ylim([0 2E6])
subplot(3,6,3), plot(f,Spb3KO(:,1:length(f)),'k'), title(tiOp{3}), hold on, plot(f,mean(Spb3KO(:,1:length(f))),'y','linewidth',2), ylim([0 2E6])
subplot(3,6,4), plot(f,Spb4KO(:,1:length(f)),'k'), title(tiOp{4}), hold on, plot(f,mean(Spb4KO(:,1:length(f))),'b','linewidth',2), ylim([0 2E6])
subplot(3,6,5), plot(f,Spb5KO(:,1:length(f)),'k'), title(tiOp{5}), hold on, plot(f,mean(Spb5KO(:,1:length(f))),'g','linewidth',2), ylim([0 2E6])

subplot(3,6,6), hold on, 
plot(f,mean(Spb1KO(:,1:length(f))),'r','linewidth',1), ylim([0 2E6]), title('KO'), ylabel('Bulb')
plot(f,mean(Spb2KO(:,1:length(f))),'m','linewidth',1), ylim([0 2E6])
plot(f,mean(Spb3KO(:,1:length(f))),'k','linewidth',1), ylim([0 2E6])
plot(f,mean(Spb4KO(:,1:length(f))),'b','linewidth',1), ylim([0 2E6])
plot(f,mean(Spb5KO(:,1:length(f))),'g','linewidth',1), ylim([0 2E6])

subplot(3,6,7), plot(f,Sppf1KO,'k'), hold on, plot(f,mean(Sppf1KO),'r','linewidth',2), ylim([0 3E5]), ylabel('PFC')
subplot(3,6,8), plot(f,Sppf2KO,'k'), hold on, plot(f,mean(Sppf2KO),'m','linewidth',2), ylim([0 3E5])
subplot(3,6,9), plot(f,Sppf3KO,'k'), hold on, plot(f,mean(Sppf3KO),'y','linewidth',2), ylim([0 3E5])
subplot(3,6,10), plot(f,Sppf4KO,'k'), hold on, plot(f,mean(Sppf4KO),'b','linewidth',2), ylim([0 3E5])
subplot(3,6,11), plot(f,Sppf5KO,'k'), hold on, plot(f,mean(Sppf5KO),'g','linewidth',2), ylim([0 3E5])
subplot(3,6,12), hold on, 
plot(f,mean(Sppf1KO),'r','linewidth',1), ylim([0 3E5])
plot(f,mean(Sppf2KO),'m','linewidth',1), ylim([0 3E5])
plot(f,mean(Sppf3KO),'k','linewidth',1), ylim([0 3E5])
plot(f,mean(Sppf4KO),'b','linewidth',1), ylim([0 3E5])
plot(f,mean(Sppf5KO),'g','linewidth',1), ylim([0 3E5])

subplot(3,6,13), plot(f,Sppa1KO,'k'), hold on, plot(f,mean(Sppa1KO),'r','linewidth',2), ylim([0 3E5]), ylabel('Par')
subplot(3,6,14), plot(f,Sppa2KO,'k'), hold on, plot(f,mean(Sppa2KO),'m','linewidth',2), ylim([0 3E5])
subplot(3,6,15), plot(f,Sppa3KO,'k'), hold on, plot(f,mean(Sppa3KO),'y','linewidth',2), ylim([0 3E5])
subplot(3,6,16), plot(f,Sppa4KO,'k'), hold on, plot(f,mean(Sppa4KO),'b','linewidth',2), ylim([0 3E5])
subplot(3,6,17), plot(f,Sppa5KO,'k'), hold on, plot(f,mean(Sppa5KO),'g','linewidth',2), ylim([0 3E5])

subplot(3,6,18), hold on, 
plot(f,mean(Sppa1KO),'r','linewidth',1), ylim([0 3E5])
plot(f,mean(Sppa2KO),'m','linewidth',1), ylim([0 3E5])
plot(f,mean(Sppa3KO),'k','linewidth',1), ylim([0 3E5])
plot(f,mean(Sppa4KO),'b','linewidth',1), ylim([0 3E5])
plot(f,mean(Sppa5KO),'g','linewidth',1), ylim([0 3E5])




id=find(f>1.5&f<3.5);
id2=find(f>5&f<10);

% 
% id=find(f>10&f<15);
% id2=find(f>15&f<20);


figure('color',[1 1 1]),
subplot(3,2,1), PlotErrorbarN([nanmean(Spb1(:,id),2),mean(Spb2(:,id),2),mean(Spb3(:,id),2),mean(Spb4(:,id),2)],0); ylabel('bulb'), title('WT, 1.5-3.5 Hz')
set(gca,'Xtick',[1:4])
set(gca,'XTickLabel',tiOp)
subplot(3,2,3), PlotErrorbarN([mean(Sppf1(:,id),2),mean(Sppf2(:,id),2),mean(Sppf3(:,id),2),mean(Sppf4(:,id),2)],0); ylabel('PFC')
set(gca,'Xtick',[1:4])
set(gca,'XTickLabel',tiOp)
subplot(3,2,5), PlotErrorbarN([mean(Sppa1(:,id),2),mean(Sppa2(:,id),2),mean(Sppa3(:,id),2),mean(Sppa4(:,id),2)],0); ylabel('Par')
set(gca,'Xtick',[1:4])
set(gca,'XTickLabel',tiOp)

subplot(3,2,2), PlotErrorbarN([mean(Spb1(:,id2),2),mean(Spb2(:,id2),2),mean(Spb3(:,id2),2),mean(Spb4(:,id2),2)],0); ylabel('bulb'), title('WT, 5-10 Hz')
set(gca,'Xtick',[1:4])
set(gca,'XTickLabel',tiOp)
subplot(3,2,4), PlotErrorbarN([mean(Sppf1(:,id2),2),mean(Sppf2(:,id2),2),mean(Sppf3(:,id2),2),mean(Sppf4(:,id2),2)],0); ylabel('PFC')
set(gca,'Xtick',[1:4])
set(gca,'XTickLabel',tiOp)
subplot(3,2,6), PlotErrorbarN([mean(Sppa1(:,id2),2),mean(Sppa2(:,id2),2),mean(Sppa3(:,id2),2),mean(Sppa4(:,id2),2)],0); ylabel('Par')
set(gca,'Xtick',[1:4])
set(gca,'XTickLabel',tiOp)




figure('color',[1 1 1]),
subplot(3,2,1), PlotErrorbarN([nanmean(Spb1KO(:,id),2),nanmean(Spb2KO(:,id),2),nanmean(Spb3KO(:,id),2),nanmean(Spb4KO(:,id),2)],0); ylabel('bulb'), title('KO, 1.5-3.5 Hz')
set(gca,'Xtick',[1:4])
set(gca,'XTickLabel',tiOp)
try
subplot(3,2,3), PlotErrorbarN([mean(Sppf1KO(:,id),2),mean(Sppf2KO(:,id),2),mean(Sppf3KO(:,id),2),mean(Sppf4KO(:,id),2)],0); ylabel('PFC')
set(gca,'Xtick',[1:4])
set(gca,'XTickLabel',tiOp)
end
try
    subplot(3,2,5), PlotErrorbarN([mean(Sppa1KO(:,id),2),mean(Sppa2KO(:,id),2),nanmean(Sppa3KO(:,id),2),mean(Sppa4KO(:,id),2)],0); ylabel('Par')
set(gca,'Xtick',[1:4])
set(gca,'XTickLabel',tiOp)
end

subplot(3,2,2), PlotErrorbarN([nanmean(Spb1KO(:,id2),2),nanmean(Spb2KO(:,id2),2),nanmean(Spb3KO(:,id2),2),nanmean(Spb4KO(:,id2),2)],0); ylabel('bulb'), title('KO, 5-10 Hz')
set(gca,'Xtick',[1:4])
set(gca,'XTickLabel',tiOp)
try
subplot(3,2,4), PlotErrorbarN([nanmean(Sppf1KO(:,id2),2),nanmean(Sppf2KO(:,id2),2),nanmean(Sppf3KO(:,id2),2),nanmean(Sppf4KO(:,id2),2)],0); ylabel('PFC')
set(gca,'Xtick',[1:4])
set(gca,'XTickLabel',tiOp)
end
try
    subplot(3,2,6), PlotErrorbarN([mean(Sppa1KO(:,id2),2),mean(Sppa2KO(:,id2),2),mean(Sppa3KO(:,id2),2),mean(Sppa4KO(:,id2),2)],0); ylabel('Par')
set(gca,'Xtick',[1:4])
set(gca,'XTickLabel',tiOp)
end





figure('color',[1 1 1]), 
for i=1:5
    for j=1:5
        subplot(5,5,MatXY(i,j,5)), hold on, 
        plot(DtWT(:,i),DtWT(:,j),'ko','markerfacecolor','k')
        plot(DtKO(:,i),DtKO(:,j),'ro')
        xlabel(tiOp{i})
        ylabel(tiOp{j})
        
    end
end


clear PTwt
for i=1:length(Pwt)
    try
    PTwt=PTwt+(Pwt{i})/sum(diag(Pwt{i}))*100;
    catch
    PTwt=Pwt{i}/sum(diag(Pwt{i}))*100; 

    end
end

clear PTko
for i=1:length(Pko)
    try
    PTko=PTko+(Pko{i}/sum(diag(Pko{i})))*100;
    catch
    PTko=(Pko{i}/sum(diag(Pko{i})))*100;
    end
end

figure('color',[1 1 1]), 
subplot(1,2,1), imagesc(PTwt/length(Pwt))
set(gca,'Xtick',[1:5])
set(gca,'XTickLabel',tiOp)
set(gca,'Ytick',[1:5])
set(gca,'YTickLabel',tiOp)
title('WT')

subplot(1,2,2), imagesc(PTko/length(Pko))
set(gca,'Xtick',[1:5])
set(gca,'XTickLabel',tiOp)
set(gca,'Ytick',[1:5])
set(gca,'YTickLabel',tiOp)
title('KO')




%           CrossKO{b,1}=Ct1;
%           CrossKO{b,2}=Bt1; 
%           CrossKO{b,3}=Ct2; 
%           CrossKO{b,4}=Bt2;  
tps1=CrossKO{1,2}{1}/1E3;
tps2=CrossKO{1,2}{3}/1E3;
% 
% for k=1:8
%     figure('color',[1 1 1])
%     a=1;
%     for i=1:8
%         if k>2&k<5
%             tps=tps2;
%         else
%             tps=tps1;
%         end
%         subplot(2,2,1), hold on, plot(tps,CrossKO{i,1}{k},'r'),xlim([tps(1) tps(end)]), yl=ylim; line([0 0],yl,'color','b')
%         subplot(2,2,2), hold on, plot(tps,CrossKO{i,3}{k},'r'),xlim([tps(1) tps(end)]), yl=ylim; line([0 0],yl,'color','b')
%         subplot(2,2,3), hold on, plot(tps,zscore(CrossKO{i,1}{k}),'r'),xlim([tps(1) tps(end)]), yl=ylim; line([0 0],yl,'color','b')
%         subplot(2,2,4), hold on, plot(tps,zscore(CrossKO{i,3}{k}),'r'),xlim([tps(1) tps(end)]), yl=ylim; line([0 0],yl,'color','b')     
%     end
%     for i=1:11
%         if k>2&k<5
%             tps=tps2;
%         else
%             tps=tps1;
%         end
%     subplot(2,2,1), hold on, plot(tps,CrossWT{i,1}{k},'k'),xlim([tps(1) tps(end)]), yl=ylim; line([0 0],yl,'color','b')
%     subplot(2,2,2), hold on, plot(tps,CrossWT{i,3}{k},'k'),xlim([tps(1) tps(end)]), yl=ylim; line([0 0],yl,'color','b')
%         subplot(2,2,3), hold on, plot(tps,zscore(CrossWT{i,1}{k}),'k'),xlim([tps(1) tps(end)]), yl=ylim; line([0 0],yl,'color','b')
%         subplot(2,2,4), hold on, plot(tps,zscore(CrossWT{i,3}{k}),'k') ,xlim([tps(1) tps(end)]), yl=ylim; line([0 0],yl,'color','b')     
%     end
% end
% 


for k=1:8
    CrWT1{k}=[];
    CrKO1{k}=[];
    CrWT1z{k}=[];
    CrKO1z{k}=[];    
    CrWT2{k}=[];
    CrKO2{k}=[];
    CrWT2z{k}=[];
    CrKO2z{k}=[];      
for i=1:11
CrWT1{k}=[CrWT1{k};CrossWT{i,1}{k}'];
CrWT1z{k}=[CrWT1z{k};zscore(CrossWT{i,1}{k})'];
CrWT2{k}=[CrWT2{k};CrossWT{i,3}{k}'];
CrWT2z{k}=[CrWT2z{k};zscore(CrossWT{i,3}{k})'];
end
for i=1:8
CrKO1{k}=[CrKO1{k};CrossWT{i,1}{k}'];
CrKO1z{k}=[CrKO1z{k};zscore(CrossWT{i,1}{k})'];
CrKO2{k}=[CrKO2{k};CrossWT{i,3}{k}'];
CrKO2z{k}=[CrKO2z{k};zscore(CrossWT{i,3}{k})'];
end

end


figure('color',[1 1 1]), 
for k=1:8

    if k>2&k<5
    tps=tps2;
    else
    tps=tps1;
    end
subplot(4,2,k), hold on, 
plot(tps,mean(CrWT1{k}),'k','linewidth',2)
plot(tps,mean(CrWT1{k})+stdError(CrWT1{k}),'k')
plot(tps,mean(CrWT1{k})-stdError(CrWT1{k}),'k')
plot(tps,mean(CrKO1{k}),'r','linewidth',2)
plot(tps,mean(CrKO1{k})+stdError(CrKO1{k}),'r')
plot(tps,mean(CrKO1{k})-stdError(CrKO1{k}),'r')
xlim([tps(1) tps(end)]), yl=ylim; line([0 0],yl,'color','b')


end

% 
% figure('color',[1 1 1]), 
% for k=1:8
% 
%     if k>2&k<5
%     tps=tps2;
%     else
%     tps=tps1;
%     end
% subplot(4,2,k), hold on, 
% plot(tps,mean(CrWT1z{k}),'k','linewidth',2)
% plot(tps,mean(CrWT1z{k})+stdError(CrWT1z{k}),'k')
% plot(tps,mean(CrWT1z{k})-stdError(CrWT1z{k}),'k')
% plot(tps,mean(CrKO1z{k}),'r','linewidth',2)
% plot(tps,mean(CrKO1z{k})+stdError(CrKO1z{k}),'r')
% plot(tps,mean(CrKO1z{k})-stdError(CrKO1z{k}),'r')
% xlim([tps(1) tps(end)]), yl=ylim; line([0 0],yl,'color','b')
% end



figure('color',[1 1 1]), 
for k=1:8

    if k>2&k<5
    tps=tps2;
    else
    tps=tps1;
    end

subplot(4,2,k), hold on, 
plot(tps,mean(CrWT2{k}),'k','linewidth',2)
plot(tps,mean(CrWT2{k})+stdError(CrWT2{k}),'k')
plot(tps,mean(CrWT2{k})-stdError(CrWT2{k}),'k')
plot(tps,mean(CrKO2{k}),'r','linewidth',2)
plot(tps,mean(CrKO2{k})+stdError(CrKO2{k}),'r')
plot(tps,mean(CrKO2{k})-stdError(CrKO2{k}),'r')
xlim([tps(1) tps(end)]), yl=ylim; line([0 0],yl,'color','b')


end

% 
% figure('color',[1 1 1]), 
% for k=1:8
% 
%     if k>2&k<5
%     tps=tps2;
%     else
%     tps=tps1;
%     end
% 
% subplot(4,2,k), hold on, 
% plot(tps,mean(CrWT2z{k}),'k','linewidth',2)
% plot(tps,mean(CrWT2z{k})+stdError(CrWT2z{k}),'k')
% plot(tps,mean(CrWT2z{k})-stdError(CrWT2z{k}),'k')
% plot(tps,mean(CrKO2z{k}),'r','linewidth',2)
% plot(tps,mean(CrKO2z{k})+stdError(CrKO2z{k}),'r')
% plot(tps,mean(CrKO2z{k})-stdError(CrKO2z{k}),'r')
% xlim([tps(1) tps(end)]), yl=ylim; line([0 0],yl,'color','b')
% 
% 
% end




















% % % 
% % % 
% % % 
% % % 
% % % 
% % % 
% % % 
% % % 
% % % 
% % % 
% % % 
% % % 
% % % 
% % % 
% % % 
% % % 
% % % 
% % %  freq=0.1:0.1:20;  
% % % 
% % % f=freq;
% % % 
% % % tiOp{1}='S12';
% % % tiOp{2}='S34';
% % % tiOp{3}='Burst Delta';
% % % tiOp{4}='Slow Bulb';
% % % 
% % % tic{1}='Delta Pfc';
% % % tic{2}='Delta Par';
% % % tic{3}='Ripples';
% % % tic{4}='Spindles Pfc';
% % % tic{5}='Spindles Par';
% % % 
% % % figure('color',[1 1 1])
% % % subplot(5,2,1), PlotErrorBarN(DelPFCWT,0); ylabel(tic{1})
% % % set(gca,'Xtick',[1:4])
% % % set(gca,'XTickLabel',tiOp)
% % % subplot(5,2,2),PlotErrorBarN(DelPFCKO,0);
% % % set(gca,'Xtick',[1:4])
% % % set(gca,'XTickLabel',tiOp)
% % % 
% % % subplot(5,2,3),PlotErrorBarN(DelPaCWT,0); ylabel(tic{2})
% % % set(gca,'Xtick',[1:4])
% % % set(gca,'XTickLabel',tiOp)
% % % subplot(5,2,4), PlotErrorBarN(DelPaCKO,0);
% % % set(gca,'Xtick',[1:4])
% % % set(gca,'XTickLabel',tiOp)
% % % 
% % % subplot(5,2,5),PlotErrorBarN(RipWT,0); ylabel(tic{3})
% % % set(gca,'Xtick',[1:4])
% % % set(gca,'XTickLabel',tiOp)
% % % subplot(5,2,6), PlotErrorBarN(RipKO,0);
% % % set(gca,'Xtick',[1:4])
% % % set(gca,'XTickLabel',tiOp)
% % % 
% % % subplot(5,2,7),PlotErrorBarN(SpiPFCWT,0); ylabel(tic{4})
% % % set(gca,'Xtick',[1:4])
% % % set(gca,'XTickLabel',tiOp)
% % % subplot(5,2,8), PlotErrorBarN(SpiPFCKO,0);
% % % set(gca,'Xtick',[1:4])
% % % set(gca,'XTickLabel',tiOp)
% % % 
% % % subplot(5,2,9),PlotErrorBarN(SpiPaCWT,0); ylabel(tic{5})
% % % set(gca,'Xtick',[1:4])
% % % set(gca,'XTickLabel',tiOp)
% % % subplot(5,2,10), PlotErrorBarN(SpiPaCKO,0);
% % % set(gca,'Xtick',[1:4])
% % % set(gca,'XTickLabel',tiOp)
% % % 
% % % 
% % % 
% % % 
% % % figure('color',[1 1 1])
% % % subplot(2,4,1), imagesc(Spb1)
% % % subplot(2,4,2), imagesc(Spb2)
% % % subplot(2,4,3), imagesc(Spb3)
% % % subplot(2,4,4), imagesc(Spb4)
% % % 
% % % subplot(2,4,5), imagesc(Spb1KO)
% % % subplot(2,4,6), imagesc(Spb2KO)
% % % subplot(2,4,7), imagesc(Spb3KO)
% % % subplot(2,4,8), imagesc(Spb4KO)
% % % 
% % % 
% % % 
% % % 
% % % figure('color',[1 1 1])
% % % subplot(2,4,1), imagesc(Sppf1)
% % % subplot(2,4,2), imagesc(Sppf2)
% % % subplot(2,4,3), imagesc(Sppf3)
% % % subplot(2,4,4), imagesc(Sppf4)
% % % 
% % % subplot(2,4,5), imagesc(Sppf1KO)
% % % subplot(2,4,6), imagesc(Sppf2KO)
% % % subplot(2,4,7), imagesc(Sppf3KO)
% % % subplot(2,4,8), imagesc(Sppf4KO)
% % % 
% % % 
% % % figure('color',[1 1 1])
% % % subplot(2,4,1), imagesc(Sppa1)
% % % subplot(2,4,2), imagesc(Sppa2)
% % % subplot(2,4,3), imagesc(Sppa3)
% % % subplot(2,4,4), imagesc(Sppa4)
% % % 
% % % subplot(2,4,5), imagesc(Sppa1KO)
% % % subplot(2,4,6), imagesc(Sppa2KO)
% % % subplot(2,4,7), imagesc(Sppa3KO)
% % % subplot(2,4,8), imagesc(Sppa4KO)
% % % 
% % % 
% % % 
% % % figure('color',[1 1 1])
% % % subplot(3,5,1), plot(f,Spb1(:,1:length(f)),'k'), title(tiOp{1}), hold on, plot(f,mean(Spb1(:,1:length(f))),'r','linewidth',2), ylim([0 2E6])
% % % subplot(3,5,2), plot(f,Spb2(:,1:length(f)),'k'), title(tiOp{2}), hold on, plot(f,mean(Spb2(:,1:length(f))),'m','linewidth',2), ylim([0 2E6])
% % % subplot(3,5,3), plot(f,Spb3(:,1:length(f)),'k'), title(tiOp{3}), hold on, plot(f,mean(Spb3(:,1:length(f))),'y','linewidth',2), ylim([0 2E6])
% % % subplot(3,5,4), plot(f,Spb4(:,1:length(f)),'k'), title(tiOp{4}), hold on, plot(f,mean(Spb4(:,1:length(f))),'b','linewidth',2), ylim([0 2E6])
% % % subplot(3,5,5), hold on, 
% % % plot(f,mean(Spb1(:,1:length(f))),'r','linewidth',1), ylim([0 2E6])
% % % plot(f,mean(Spb2(:,1:length(f))),'m','linewidth',1), ylim([0 2E6])
% % % plot(f,mean(Spb3(:,1:length(f))),'k','linewidth',1), ylim([0 2E6])
% % % plot(f,mean(Spb4(:,1:length(f))),'b','linewidth',1), ylim([0 2E6])
% % % 
% % % subplot(3,5,6), plot(f,Sppf1,'k'), hold on, plot(f,mean(Sppf1),'r','linewidth',2), ylim([0 3E5])
% % % subplot(3,5,7), plot(f,Sppf2,'k'), hold on, plot(f,mean(Sppf2),'m','linewidth',2), ylim([0 3E5])
% % % subplot(3,5,8), plot(f,Sppf3,'k'), hold on, plot(f,mean(Sppf3),'y','linewidth',2), ylim([0 3E5])
% % % subplot(3,5,9), plot(f,Sppf4,'k'), hold on, plot(f,mean(Sppf4),'b','linewidth',2), ylim([0 3E5])
% % % subplot(3,5,10), hold on, 
% % % plot(f,mean(Sppf1),'r','linewidth',1), ylim([0 3E5])
% % % plot(f,mean(Sppf2),'m','linewidth',1), ylim([0 3E5])
% % % plot(f,mean(Sppf3),'k','linewidth',1), ylim([0 3E5])
% % % plot(f,mean(Sppf4),'b','linewidth',1), ylim([0 3E5])
% % % 
% % % subplot(3,5,11), plot(f,Sppa1,'k'), hold on, plot(f,mean(Sppa1),'r','linewidth',2), ylim([0 3E5])
% % % subplot(3,5,12), plot(f,Sppa2,'k'), hold on, plot(f,mean(Sppa2),'m','linewidth',2), ylim([0 3E5])
% % % subplot(3,5,13), plot(f,Sppa3,'k'), hold on, plot(f,mean(Sppa3),'y','linewidth',2), ylim([0 3E5])
% % % subplot(3,5,14), plot(f,Sppa4,'k'), hold on, plot(f,mean(Sppa4),'b','linewidth',2), ylim([0 3E5])
% % % subplot(3,5,15), hold on, 
% % % plot(f,mean(Sppa1),'r','linewidth',1), ylim([0 3E5])
% % % plot(f,mean(Sppa2),'m','linewidth',1), ylim([0 3E5])
% % % plot(f,mean(Sppa3),'k','linewidth',1), ylim([0 3E5])
% % % plot(f,mean(Sppa4),'b','linewidth',1), ylim([0 3E5])
% % % 
% % % 
% % % 
% % % 
% % % id=find(f>1.5&f<3.5);
% % % id2=find(f>5&f<10);
% % % figure('color',[1 1 1]),
% % % subplot(3,2,1), PlotErrorbarN([nanmean(Spb1(:,id),2),mean(Spb2(:,id),2),mean(Spb3(:,id),2),mean(Spb4(:,id),2)],0); ylabel('bulb')
% % % set(gca,'Xtick',[1:4])
% % % set(gca,'XTickLabel',tiOp)
% % % subplot(3,2,3), PlotErrorbarN([mean(Sppf1(:,id),2),mean(Sppf2(:,id),2),mean(Sppf3(:,id),2),mean(Sppf4(:,id),2)],0); ylabel('PFC')
% % % set(gca,'Xtick',[1:4])
% % % set(gca,'XTickLabel',tiOp)
% % % subplot(3,2,5), PlotErrorbarN([mean(Sppa1(:,id),2),mean(Sppa2(:,id),2),mean(Sppa3(:,id),2),mean(Sppa4(:,id),2)],0); ylabel('Par')
% % % set(gca,'Xtick',[1:4])
% % % set(gca,'XTickLabel',tiOp)
% % % 
% % % subplot(3,2,2), PlotErrorbarN([mean(Spb1(:,id2),2),mean(Spb2(:,id2),2),mean(Spb3(:,id2),2),mean(Spb4(:,id2),2)],0); ylabel('bulb')
% % % set(gca,'Xtick',[1:4])
% % % set(gca,'XTickLabel',tiOp)
% % % subplot(3,2,4), PlotErrorbarN([mean(Sppf1(:,id2),2),mean(Sppf2(:,id2),2),mean(Sppf3(:,id2),2),mean(Sppf4(:,id2),2)],0); ylabel('PFC')
% % % set(gca,'Xtick',[1:4])
% % % set(gca,'XTickLabel',tiOp)
% % % subplot(3,2,6), PlotErrorbarN([mean(Sppa1(:,id2),2),mean(Sppa2(:,id2),2),mean(Sppa3(:,id2),2),mean(Sppa4(:,id2),2)],0); ylabel('Par')
% % % set(gca,'Xtick',[1:4])
% % % set(gca,'XTickLabel',tiOp)
% % % 
% % % 
% % % 
% % % 
% % % id=find(f>1.5&f<3.5);
% % % id2=find(f>5&f<10);
% % % figure('color',[1 1 1]),
% % % subplot(3,2,1), PlotErrorbarN([nanmean(Spb1KO(:,id),2),nanmean(Spb2KO(:,id),2),nanmean(Spb3KO(:,id),2),nanmean(Spb4KO(:,id),2)],0); ylabel('bulb')
% % % set(gca,'Xtick',[1:4])
% % % set(gca,'XTickLabel',tiOp)
% % % try
% % % subplot(3,2,3), PlotErrorbarN([mean(Sppf1KO(:,id),2),mean(Sppf2KO(:,id),2),mean(Sppf3KO(:,id),2),mean(Sppf4KO(:,id),2)],0); ylabel('PFC')
% % % set(gca,'Xtick',[1:4])
% % % set(gca,'XTickLabel',tiOp)
% % % end
% % % try
% % %     subplot(3,2,5), PlotErrorbarN([mean(Sppa1KO(:,id),2),mean(Sppa2KO(:,id),2),nanmean(Sppa3KO(:,id),2),mean(Sppa4KO(:,id),2)],0); ylabel('Par')
% % % set(gca,'Xtick',[1:4])
% % % set(gca,'XTickLabel',tiOp)
% % % end
% % % 
% % % subplot(3,2,2), PlotErrorbarN([nanmean(Spb1KO(:,id2),2),nanmean(Spb2KO(:,id2),2),nanmean(Spb3KO(:,id2),2),nanmean(Spb4KO(:,id2),2)],0); ylabel('bulb')
% % % set(gca,'Xtick',[1:4])
% % % set(gca,'XTickLabel',tiOp)
% % % try
% % % subplot(3,2,4), PlotErrorbarN([nanmean(Sppf1KO(:,id2),2),nanmean(Sppf2KO(:,id2),2),nanmean(Sppf3KO(:,id2),2),nanmean(Sppf4KO(:,id2),2)],0); ylabel('PFC')
% % % set(gca,'Xtick',[1:4])
% % % set(gca,'XTickLabel',tiOp)
% % % end
% % % try
% % %     subplot(3,2,6), PlotErrorbarN([mean(Sppa1KO(:,id2),2),mean(Sppa2KO(:,id2),2),mean(Sppa3KO(:,id2),2),mean(Sppa4KO(:,id2),2)],0); ylabel('Par')
% % % set(gca,'Xtick',[1:4])
% % % set(gca,'XTickLabel',tiOp)
% % % end
% % % Warning: Could not find an exact (case-sensitive) match for 'PlotErrorbarN'.
% % % /home/vador/Dropbox/Kteam/PrgMatlab/BehaviorML/PlotErrorBarN.m is a case-insensitive match and will be used instead.
% % % You can improve the performance of your code by using exact
% % % name matches and we therefore recommend that you update your
% % % usage accordingly. Alternatively, you can disable this warning using
% % % warning('off','MATLAB:dispatcher:InexactCaseMatch').
% % % This warning will become an error in future releases. 
% % % ylim([0 2E6])
% % % ylim([0 3.5E5])
% % % ylim([0 3E5])
% % % ylim([0 2E6])
% % % ylim([0 3.5E5])
% % % ylim([0 3E5])
% % % ylim([0 16E4*])
% % % ??? ylim([0 16E4*])
% % %                  |
% % % Error: Unbalanced or unexpected parenthesis or bracket.
% % %  
% % % ylim([0 16E4])
% % % ylim([0 2E5])
% % % ylim([0 2E5])
% % % ylim([0 5E4])
% % % ylim([0 8E4])
% % % ylim([0 8E4])
% % % ylim([0 8E4])
% % % ylim([0 12E4])
% % % ylim([0 15E4])
% % % 
% % % figure('color',[1 1 1])
% % % subplot(3,5,1), plot(f,Spb1KO(:,1:length(f)),'k'), title(tiOp{1}), hold on, plot(f,mean(Spb1KO(:,1:length(f))),'r','linewidth',2), ylim([0 2E6])
% % % subplot(3,5,2), plot(f,Spb2KO(:,1:length(f)),'k'), title(tiOp{2}), hold on, plot(f,mean(Spb2KO(:,1:length(f))),'m','linewidth',2), ylim([0 2E6])
% % % subplot(3,5,3), plot(f,Spb3KO(:,1:length(f)),'k'), title(tiOp{3}), hold on, plot(f,mean(Spb3KO(:,1:length(f))),'y','linewidth',2), ylim([0 2E6])
% % % subplot(3,5,4), plot(f,Spb4KO(:,1:length(f)),'k'), title(tiOp{4}), hold on, plot(f,mean(Spb4KO(:,1:length(f))),'b','linewidth',2), ylim([0 2E6])
% % % subplot(3,5,5), hold on, 
% % % plot(f,mean(Spb1KO(:,1:length(f))),'r','linewidth',1), ylim([0 2E6]), title('KO')
% % % plot(f,mean(Spb2KO(:,1:length(f))),'m','linewidth',1), ylim([0 2E6])
% % % plot(f,mean(Spb3KO(:,1:length(f))),'k','linewidth',1), ylim([0 2E6])
% % % plot(f,mean(Spb4KO(:,1:length(f))),'b','linewidth',1), ylim([0 2E6])
% % % 
% % % subplot(3,5,6), plot(f,Sppf1KO,'k'), hold on, plot(f,mean(Sppf1KO),'r','linewidth',2), ylim([0 3E5])
% % % subplot(3,5,7), plot(f,Sppf2KO,'k'), hold on, plot(f,mean(Sppf2KO),'m','linewidth',2), ylim([0 3E5])
% % % subplot(3,5,8), plot(f,Sppf3KO,'k'), hold on, plot(f,mean(Sppf3KO),'y','linewidth',2), ylim([0 3E5])
% % % subplot(3,5,9), plot(f,Sppf4KO,'k'), hold on, plot(f,mean(Sppf4KO),'b','linewidth',2), ylim([0 3E5])
% % % subplot(3,5,10), hold on, 
% % % plot(f,mean(Sppf1KO),'r','linewidth',1), ylim([0 3E5])
% % % plot(f,mean(Sppf2KO),'m','linewidth',1), ylim([0 3E5])
% % % plot(f,mean(Sppf3KO),'k','linewidth',1), ylim([0 3E5])
% % % plot(f,mean(Sppf4KO),'b','linewidth',1), ylim([0 3E5])
% % % 
% % % subplot(3,5,11), plot(f,Sppa1KO,'k'), hold on, plot(f,mean(Sppa1KO),'r','linewidth',2), ylim([0 3E5])
% % % subplot(3,5,12), plot(f,Sppa2KO,'k'), hold on, plot(f,mean(Sppa2KO),'m','linewidth',2), ylim([0 3E5])
% % % subplot(3,5,13), plot(f,Sppa3KO,'k'), hold on, plot(f,mean(Sppa3KO),'y','linewidth',2), ylim([0 3E5])
% % % subplot(3,5,14), plot(f,Sppa4KO,'k'), hold on, plot(f,mean(Sppa4KO),'b','linewidth',2), ylim([0 3E5])
% % % subplot(3,5,15), hold on, 
% % % plot(f,mean(Sppa1KO),'r','linewidth',1), ylim([0 3E5])
% % % plot(f,mean(Sppa2KO),'m','linewidth',1), ylim([0 3E5])
% % % plot(f,mean(Sppa3KO),'k','linewidth',1), ylim([0 3E5])
% % % plot(f,mean(Sppa4KO),'b','linewidth',1), ylim([0 3E5])
% % % title('WT')
% % % title('WT')
% % % title('WT')
% % % title('WT')
% % % title('WT')
% % % title('KO')
% % % title('KO')
% % % title('KO')
% % % close all
% % % 
% % % tiOp{1}='S12';
% % % tiOp{2}='S34';
% % % tiOp{3}='Burst Delta';
% % % tiOp{4}='Slow Bulb';
% % % 
% % % tic{1}='Delta Pfc';
% % % tic{2}='Delta Par';
% % % tic{3}='Ripples';
% % % tic{4}='Spindles Pfc';
% % % tic{5}='Spindles Par';
% % % 
% % % figure('color',[1 1 1])
% % % subplot(5,2,1), PlotErrorBarN(DelPFCWT,0); ylabel(tic{1}),title('WT')
% % % set(gca,'Xtick',[1:4])
% % % set(gca,'XTickLabel',tiOp)
% % % subplot(5,2,2),PlotErrorBarN(DelPFCKO,0);title('KO')
% % % set(gca,'Xtick',[1:4])
% % % set(gca,'XTickLabel',tiOp)
% % % 
% % % subplot(5,2,3),PlotErrorBarN(DelPaCWT,0); ylabel(tic{2})
% % % set(gca,'Xtick',[1:4])
% % % set(gca,'XTickLabel',tiOp)
% % % subplot(5,2,4), PlotErrorBarN(DelPaCKO,0);
% % % set(gca,'Xtick',[1:4])
% % % set(gca,'XTickLabel',tiOp)
% % % 
% % % subplot(5,2,5),PlotErrorBarN(RipWT,0); ylabel(tic{3})
% % % set(gca,'Xtick',[1:4])
% % % set(gca,'XTickLabel',tiOp)
% % % subplot(5,2,6), PlotErrorBarN(RipKO,0);
% % % set(gca,'Xtick',[1:4])
% % % set(gca,'XTickLabel',tiOp)
% % % 
% % % subplot(5,2,7),PlotErrorBarN(SpiPFCWT,0); ylabel(tic{4})
% % % set(gca,'Xtick',[1:4])
% % % set(gca,'XTickLabel',tiOp)
% % % subplot(5,2,8), PlotErrorBarN(SpiPFCKO,0);
% % % set(gca,'Xtick',[1:4])
% % % set(gca,'XTickLabel',tiOp)
% % % 
% % % subplot(5,2,9),PlotErrorBarN(SpiPaCWT,0); ylabel(tic{5})
% % % set(gca,'Xtick',[1:4])
% % % set(gca,'XTickLabel',tiOp)
% % % subplot(5,2,10), PlotErrorBarN(SpiPaCKO,0);
% % % set(gca,'Xtick',[1:4])
% % % set(gca,'XTickLabel',tiOp)
% % % 
% % % 
% % % 
% % % 
% % % % figure('color',[1 1 1])
% % % % subplot(2,4,1), imagesc(Spb1)
% % % % subplot(2,4,2), imagesc(Spb2)
% % % % subplot(2,4,3), imagesc(Spb3)
% % % % subplot(2,4,4), imagesc(Spb4)
% % % % 
% % % % subplot(2,4,5), imagesc(Spb1KO)
% % % % subplot(2,4,6), imagesc(Spb2KO)
% % % % subplot(2,4,7), imagesc(Spb3KO)
% % % % subplot(2,4,8), imagesc(Spb4KO)
% % % 
% % % 
% % % 
% % % 
% % % % figure('color',[1 1 1])
% % % % subplot(2,4,1), imagesc(Sppf1)
% % % % subplot(2,4,2), imagesc(Sppf2)
% % % % subplot(2,4,3), imagesc(Sppf3)
% % % % subplot(2,4,4), imagesc(Sppf4)
% % % % 
% % % % subplot(2,4,5), imagesc(Sppf1KO)
% % % % subplot(2,4,6), imagesc(Sppf2KO)
% % % % subplot(2,4,7), imagesc(Sppf3KO)
% % % % subplot(2,4,8), imagesc(Sppf4KO)
% % % % 
% % % % 
% % % % figure('color',[1 1 1])
% % % % subplot(2,4,1), imagesc(Sppa1)
% % % % subplot(2,4,2), imagesc(Sppa2)
% % % % subplot(2,4,3), imagesc(Sppa3)
% % % % subplot(2,4,4), imagesc(Sppa4)
% % % % 
% % % % subplot(2,4,5), imagesc(Sppa1KO)
% % % % subplot(2,4,6), imagesc(Sppa2KO)
% % % % subplot(2,4,7), imagesc(Sppa3KO)
% % % % subplot(2,4,8), imagesc(Sppa4KO)
% % % 
% % % 
% % % 
% % % figure('color',[1 1 1])
% % % subplot(3,5,1), plot(f,Spb1(:,1:length(f)),'k'), title(tiOp{1}), hold on, plot(f,mean(Spb1(:,1:length(f))),'r','linewidth',2), ylim([0 2E6])
% % % subplot(3,5,2), plot(f,Spb2(:,1:length(f)),'k'), title(tiOp{2}), hold on, plot(f,mean(Spb2(:,1:length(f))),'m','linewidth',2), ylim([0 2E6])
% % % subplot(3,5,3), plot(f,Spb3(:,1:length(f)),'k'), title(tiOp{3}), hold on, plot(f,mean(Spb3(:,1:length(f))),'y','linewidth',2), ylim([0 2E6])
% % % subplot(3,5,4), plot(f,Spb4(:,1:length(f)),'k'), title(tiOp{4}), hold on, plot(f,mean(Spb4(:,1:length(f))),'b','linewidth',2), ylim([0 2E6])
% % % subplot(3,5,5), hold on, 
% % % plot(f,mean(Spb1(:,1:length(f))),'r','linewidth',1), ylim([0 2E6]), title('WT')
% % % plot(f,mean(Spb2(:,1:length(f))),'m','linewidth',1), ylim([0 2E6])
% % % plot(f,mean(Spb3(:,1:length(f))),'k','linewidth',1), ylim([0 2E6])
% % % plot(f,mean(Spb4(:,1:length(f))),'b','linewidth',1), ylim([0 2E6])
% % % 
% % % subplot(3,5,6), plot(f,Sppf1,'k'), hold on, plot(f,mean(Sppf1),'r','linewidth',2), ylim([0 3E5])
% % % subplot(3,5,7), plot(f,Sppf2,'k'), hold on, plot(f,mean(Sppf2),'m','linewidth',2), ylim([0 3E5])
% % % subplot(3,5,8), plot(f,Sppf3,'k'), hold on, plot(f,mean(Sppf3),'y','linewidth',2), ylim([0 3E5])
% % % subplot(3,5,9), plot(f,Sppf4,'k'), hold on, plot(f,mean(Sppf4),'b','linewidth',2), ylim([0 3E5])
% % % subplot(3,5,10), hold on, 
% % % plot(f,mean(Sppf1),'r','linewidth',1), ylim([0 3E5])
% % % plot(f,mean(Sppf2),'m','linewidth',1), ylim([0 3E5])
% % % plot(f,mean(Sppf3),'k','linewidth',1), ylim([0 3E5])
% % % plot(f,mean(Sppf4),'b','linewidth',1), ylim([0 3E5])
% % % 
% % % subplot(3,5,11), plot(f,Sppa1,'k'), hold on, plot(f,mean(Sppa1),'r','linewidth',2), ylim([0 3E5])
% % % subplot(3,5,12), plot(f,Sppa2,'k'), hold on, plot(f,mean(Sppa2),'m','linewidth',2), ylim([0 3E5])
% % % subplot(3,5,13), plot(f,Sppa3,'k'), hold on, plot(f,mean(Sppa3),'y','linewidth',2), ylim([0 3E5])
% % % subplot(3,5,14), plot(f,Sppa4,'k'), hold on, plot(f,mean(Sppa4),'b','linewidth',2), ylim([0 3E5])
% % % subplot(3,5,15), hold on, 
% % % plot(f,mean(Sppa1),'r','linewidth',1), ylim([0 3E5])
% % % plot(f,mean(Sppa2),'m','linewidth',1), ylim([0 3E5])
% % % plot(f,mean(Sppa3),'k','linewidth',1), ylim([0 3E5])
% % % plot(f,mean(Sppa4),'b','linewidth',1), ylim([0 3E5])
% % % 
% % % 
% % % 
% % % 
% % % figure('color',[1 1 1])
% % % subplot(3,5,1), plot(f,Spb1KO(:,1:length(f)),'k'), title(tiOp{1}), hold on, plot(f,mean(Spb1KO(:,1:length(f))),'r','linewidth',2), ylim([0 2E6])
% % % subplot(3,5,2), plot(f,Spb2KO(:,1:length(f)),'k'), title(tiOp{2}), hold on, plot(f,mean(Spb2KO(:,1:length(f))),'m','linewidth',2), ylim([0 2E6])
% % % subplot(3,5,3), plot(f,Spb3KO(:,1:length(f)),'k'), title(tiOp{3}), hold on, plot(f,mean(Spb3KO(:,1:length(f))),'y','linewidth',2), ylim([0 2E6])
% % % subplot(3,5,4), plot(f,Spb4KO(:,1:length(f)),'k'), title(tiOp{4}), hold on, plot(f,mean(Spb4KO(:,1:length(f))),'b','linewidth',2), ylim([0 2E6])
% % % subplot(3,5,5), hold on, 
% % % plot(f,mean(Spb1KO(:,1:length(f))),'r','linewidth',1), ylim([0 2E6]), title('KO')
% % % plot(f,mean(Spb2KO(:,1:length(f))),'m','linewidth',1), ylim([0 2E6])
% % % plot(f,mean(Spb3KO(:,1:length(f))),'k','linewidth',1), ylim([0 2E6])
% % % plot(f,mean(Spb4KO(:,1:length(f))),'b','linewidth',1), ylim([0 2E6])
% % % 
% % % subplot(3,5,6), plot(f,Sppf1KO,'k'), hold on, plot(f,mean(Sppf1KO),'r','linewidth',2), ylim([0 3E5])
% % % subplot(3,5,7), plot(f,Sppf2KO,'k'), hold on, plot(f,mean(Sppf2KO),'m','linewidth',2), ylim([0 3E5])
% % % subplot(3,5,8), plot(f,Sppf3KO,'k'), hold on, plot(f,mean(Sppf3KO),'y','linewidth',2), ylim([0 3E5])
% % % subplot(3,5,9), plot(f,Sppf4KO,'k'), hold on, plot(f,mean(Sppf4KO),'b','linewidth',2), ylim([0 3E5])
% % % subplot(3,5,10), hold on, 
% % % plot(f,mean(Sppf1KO),'r','linewidth',1), ylim([0 3E5])
% % % plot(f,mean(Sppf2KO),'m','linewidth',1), ylim([0 3E5])
% % % plot(f,mean(Sppf3KO),'k','linewidth',1), ylim([0 3E5])
% % % plot(f,mean(Sppf4KO),'b','linewidth',1), ylim([0 3E5])
% % % 
% % % subplot(3,5,11), plot(f,Sppa1KO,'k'), hold on, plot(f,mean(Sppa1KO),'r','linewidth',2), ylim([0 3E5])
% % % subplot(3,5,12), plot(f,Sppa2KO,'k'), hold on, plot(f,mean(Sppa2KO),'m','linewidth',2), ylim([0 3E5])
% % % subplot(3,5,13), plot(f,Sppa3KO,'k'), hold on, plot(f,mean(Sppa3KO),'y','linewidth',2), ylim([0 3E5])
% % % subplot(3,5,14), plot(f,Sppa4KO,'k'), hold on, plot(f,mean(Sppa4KO),'b','linewidth',2), ylim([0 3E5])
% % % subplot(3,5,15), hold on, 
% % % plot(f,mean(Sppa1KO),'r','linewidth',1), ylim([0 3E5])
% % % plot(f,mean(Sppa2KO),'m','linewidth',1), ylim([0 3E5])
% % % plot(f,mean(Sppa3KO),'k','linewidth',1), ylim([0 3E5])
% % % plot(f,mean(Sppa4KO),'b','linewidth',1), ylim([0 3E5])
% % % 
% % % 
% % % 
% % % 
% % % 
% % % id=find(f>1.5&f<3.5);
% % % id2=find(f>5&f<10);
% % % figure('color',[1 1 1]),
% % % subplot(3,2,1), PlotErrorbarN([nanmean(Spb1(:,id),2),mean(Spb2(:,id),2),mean(Spb3(:,id),2),mean(Spb4(:,id),2)],0); ylabel('bulb'), title('WT')
% % % set(gca,'Xtick',[1:4])
% % % set(gca,'XTickLabel',tiOp)
% % % subplot(3,2,3), PlotErrorbarN([mean(Sppf1(:,id),2),mean(Sppf2(:,id),2),mean(Sppf3(:,id),2),mean(Sppf4(:,id),2)],0); ylabel('PFC')
% % % set(gca,'Xtick',[1:4])
% % % set(gca,'XTickLabel',tiOp)
% % % subplot(3,2,5), PlotErrorbarN([mean(Sppa1(:,id),2),mean(Sppa2(:,id),2),mean(Sppa3(:,id),2),mean(Sppa4(:,id),2)],0); ylabel('Par')
% % % set(gca,'Xtick',[1:4])
% % % set(gca,'XTickLabel',tiOp)
% % % 
% % % subplot(3,2,2), PlotErrorbarN([mean(Spb1(:,id2),2),mean(Spb2(:,id2),2),mean(Spb3(:,id2),2),mean(Spb4(:,id2),2)],0); ylabel('bulb'), title('WT')
% % % set(gca,'Xtick',[1:4])
% % % set(gca,'XTickLabel',tiOp)
% % % subplot(3,2,4), PlotErrorbarN([mean(Sppf1(:,id2),2),mean(Sppf2(:,id2),2),mean(Sppf3(:,id2),2),mean(Sppf4(:,id2),2)],0); ylabel('PFC')
% % % set(gca,'Xtick',[1:4])
% % % set(gca,'XTickLabel',tiOp)
% % % subplot(3,2,6), PlotErrorbarN([mean(Sppa1(:,id2),2),mean(Sppa2(:,id2),2),mean(Sppa3(:,id2),2),mean(Sppa4(:,id2),2)],0); ylabel('Par')
% % % set(gca,'Xtick',[1:4])
% % % set(gca,'XTickLabel',tiOp)
% % % 
% % % 
% % % 
% % % 
% % % id=find(f>1.5&f<3.5);
% % % id2=find(f>5&f<10);
% % % figure('color',[1 1 1]),
% % % subplot(3,2,1), PlotErrorbarN([nanmean(Spb1KO(:,id),2),nanmean(Spb2KO(:,id),2),nanmean(Spb3KO(:,id),2),nanmean(Spb4KO(:,id),2)],0); ylabel('bulb'), title('KO')
% % % set(gca,'Xtick',[1:4])
% % % set(gca,'XTickLabel',tiOp)
% % % try
% % % subplot(3,2,3), PlotErrorbarN([mean(Sppf1KO(:,id),2),mean(Sppf2KO(:,id),2),mean(Sppf3KO(:,id),2),mean(Sppf4KO(:,id),2)],0); ylabel('PFC')
% % % set(gca,'Xtick',[1:4])
% % % set(gca,'XTickLabel',tiOp)
% % % end
% % % try
% % %     subplot(3,2,5), PlotErrorbarN([mean(Sppa1KO(:,id),2),mean(Sppa2KO(:,id),2),nanmean(Sppa3KO(:,id),2),mean(Sppa4KO(:,id),2)],0); ylabel('Par')
% % % set(gca,'Xtick',[1:4])
% % % set(gca,'XTickLabel',tiOp)
% % % end
% % % 
% % % subplot(3,2,2), PlotErrorbarN([nanmean(Spb1KO(:,id2),2),nanmean(Spb2KO(:,id2),2),nanmean(Spb3KO(:,id2),2),nanmean(Spb4KO(:,id2),2)],0); ylabel('bulb'), title('KO')
% % % set(gca,'Xtick',[1:4])
% % % set(gca,'XTickLabel',tiOp)
% % % try
% % % subplot(3,2,4), PlotErrorbarN([nanmean(Sppf1KO(:,id2),2),nanmean(Sppf2KO(:,id2),2),nanmean(Sppf3KO(:,id2),2),nanmean(Sppf4KO(:,id2),2)],0); ylabel('PFC')
% % % set(gca,'Xtick',[1:4])
% % % set(gca,'XTickLabel',tiOp)
% % % end
% % % try
% % %     subplot(3,2,6), PlotErrorbarN([mean(Sppa1KO(:,id2),2),mean(Sppa2KO(:,id2),2),mean(Sppa3KO(:,id2),2),mean(Sppa4KO(:,id2),2)],0); ylabel('Par')
% % % set(gca,'Xtick',[1:4])
% % % set(gca,'XTickLabel',tiOp)
% % % end
% % % ylim([0 2E6])
% % % ylim([0 3.5E5])
% % % ylim([0 3.5E5])
% % % ylim([0 3.5E5])
% % % ylim([0 3.5E5])
% % % ylim([0 2E5])
% % % ylim([0 2E5])
% % % ylim([0 7E4])
% % % ylim([0 7E4])
% % % ylim([0 17E4])
% % % ylim([0 17E4])