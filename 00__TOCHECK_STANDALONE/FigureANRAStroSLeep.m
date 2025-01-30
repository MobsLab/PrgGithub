%FigureANRAStroSleep

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

 
    
    
    
res=pwd;
tempchBulb=load([res,'/ChannelsToAnalyse/Bulb_deep.mat'],'channel');
chBulb=tempchBulb.channel;
eval(['load(''',res,'','/SpectrumDataL/Spectrum',num2str(chBulb),'.mat'');'])

% try
load StateEpochSB SWSEpoch REMEpoch Wake
load SleepStagesPaCxDeep S12 S34 S5

try
   PreEpoch;
   SWSEpoch=Restrict(SWSEpoch,PreEpoch);
    REMEpoch=Restrict(REMEpoch,PreEpoch);
    Wake=Restrict(Wake,PreEpoch);
    S12=Restrict(S12,PreEpoch);
    S34=Restrict(S34,PreEpoch);
end

clear op
clear EpochSlow
[EpochSlow,val,val2]=FindSlowOscBulb(Sp,t,f,SWSEpoch,1,[5 6]);

   
op{1}=S12;
op{2}=S34;
op{4}=EpochSlow{11};
op{5}=REMEpoch;
   


 if Dir.group{man}(1)=='W'|Dir.group{man}(1)=='C'


     

DurPeriods(a,1)=sum(End(S12,'s')-Start(S12,'s'));
DurPeriods(a,2)=sum(End(S34,'s')-Start(S34,'s'));
DurPeriods(a,3)=sum(End(EpochSlow{11},'s')-Start(EpochSlow{11},'s'));
DurPeriods(a,4)=sum(End(REMEpoch,'s')-Start(REMEpoch,'s'));

 clear Sp
    clear f
    clear t
    
    try
        try
            tempchBulb=load([res,'/ChannelsToAnalyse/PFCx_deep.mat'],'channel');
        chBulb=tempchBulb.channel;
        eval(['load(''',res,'','/SpectrumDataL/Spectrum',num2str(chBulb),'.mat'');'])
            Sp;
%         catch
%         load LFPData/InfoLFP
%         [params,movingwin,suffix]=SpectrumParametersML('low');
%         ComputeSpectrogram_newML(movingwin,params,InfoLFP,'PFCx','All',suffix);
%         eval(['load(''',res,'','/SpectrumDataL/Spectrum',num2str(chBulb),'.mat'');'])
        end
    
    Stsd=tsd(t*1E4,Sp);
    for kl=1:length(op)
    temp{kl}=mean(Data(Restrict(Stsd,op{kl})));
    temp2{kl}=tsd(f,temp{kl}');
    end
    SpPFC1(a,:)=Data(Restrict(temp2{1},freq))';
    SpPFC2(a,:)=Data(Restrict(temp2{2},freq))';
    SpPFC3(a,:)=Data(Restrict(temp2{3},freq))';
    SpPFC4(a,:)=Data(Restrict(temp2{4},freq))';
%     SpPFC5(a,:)=Data(Restrict(temp2{5},freq))';
  
   
%     end
    
    clear Sp
    clear f
    clear t
    clear temp
    clear temp2
%    try
       
    clear ChBulb
    try
      tempchBulb=load([res,'/ChannelsToAnalyse/PaCx_deep.mat'],'channel');
    chBulb=tempchBulb.channel;
    eval(['load(''',res,'','/SpectrumDataL/Spectrum',num2str(chBulb),'.mat'');'])
        Sp;
%     catch
%     load LFPData/InfoLFP
%     [params,movingwin,suffix]=SpectrumParametersML('low');
%     ComputeSpectrogram_newML(movingwin,params,InfoLFP,'PaCx','All',suffix);
%     eval(['load(''',res,'','/SpectrumDataL/Spectrum',num2str(chBulb),'.mat'');'])
        end
    
    Stsd=tsd(t*1E4,Sp);
    for kl=1:length(op)
    temp{kl}=mean(Data(Restrict(Stsd,op{kl})));
    temp2{kl}=tsd(f,temp{kl}');
    end
    SpPaC1(a,:)=Data(Restrict(temp2{1},freq))';
    SpPaC2(a,:)=Data(Restrict(temp2{2},freq))';
    SpPaC3(a,:)=Data(Restrict(temp2{3},freq))';
    SpPaC4(a,:)=Data(Restrict(temp2{4},freq))';
%     SpPaC5(a,:)=Data(Restrict(temp2{5},freq))';

   
%    end
   
   
    clear Sp
    clear f
    clear t
    clear temp
    clear temp2
    
%    try
       try
    clear ChBulb
      tempchBulb=load([res,'/ChannelsToAnalyse/Bulb_deep.mat'],'channel');
    chBulb=tempchBulb.channel;
    eval(['load(''',res,'','/SpectrumDataL/Spectrum',num2str(chBulb),'.mat'');'])

        Sp;
%     catch
%     load LFPData/InfoLFP
%     [params,movingwin,suffix]=SpectrumParametersML('low');
%     ComputeSpectrogram_newML(movingwin,params,InfoLFP,'Bulb','All',suffix);
%     eval(['load(''',res,'','/SpectrumDataL/Spectrum',num2str(chBulb),'.mat'');'])
     end
        
    Stsd=tsd(t*1E4,Sp);
     for kl=1:length(op)
    temp{kl}=mean(Data(Restrict(Stsd,op{kl})));
    temp2{kl}=tsd(f,temp{kl}');
     end
    SpBulb1(a,:)=Data(Restrict(temp2{1},freq))';
    SpBulb2(a,:)=Data(Restrict(temp2{2},freq))';
    SpBulb3(a,:)=Data(Restrict(temp2{3},freq))';
    SpBulb4(a,:)=Data(Restrict(temp2{4},freq))';
%     SpBulb5(a,:)=Data(Restrict(temp2{5},freq))';
    
   
%    end

  cellnames{a}=pwd;         
  a=a+1;
  
    end
    
close all
          


 else
          
    
     
     
DurPeriodsKO(b,1)=sum(End(S12,'s')-Start(S12,'s'));
DurPeriodsKO(b,2)=sum(End(S34,'s')-Start(S34,'s'));
% DurPeriodsKO(b,3)=sum(End(BurstDeltaEpoch,'s')-Start(BurstDeltaEpoch,'s'));
DurPeriodsKO(b,3)=sum(End(EpochSlow{11},'s')-Start(EpochSlow{11},'s'));
DurPeriodsKO(b,4)=sum(End(REMEpoch,'s')-Start(REMEpoch,'s'));

 clear Sp
    clear f
    clear t
    clear temp
    clear temp2    
    
    try
    
        try
        tempchBulb=load([res,'/ChannelsToAnalyse/PFCx_deep.mat'],'channel');
        chBulb=tempchBulb.channel;
        eval(['load(''',res,'','/SpectrumDataL/Spectrum',num2str(chBulb),'.mat'');'])
            Sp;
%         catch
%         load LFPData/InfoLFP
%         [params,movingwin,suffix]=SpectrumParametersML('low');
%         ComputeSpectrogram_newML(movingwin,params,InfoLFP,'PFCx','All',suffix);
%         eval(['load(''',res,'','/SpectrumDataL/Spectrum',num2str(chBulb),'.mat'');'])
        end
    
        Stsd=tsd(t*1E4,Sp);
        for kl=1:length(op)
        temp{kl}=mean(Data(Restrict(Stsd,op{kl})));
        temp2{kl}=tsd(f,temp{kl}');
        end
        SpPFC1KO(b,:)=Data(Restrict(temp2{1},freq))';
        SpPFC2KO(b,:)=Data(Restrict(temp2{2},freq))';
        SpPFC3KO(b,:)=Data(Restrict(temp2{3},freq))';
        SpPFC4KO(b,:)=Data(Restrict(temp2{4},freq))';
    %     SpPFC5KO(b,:)=Data(Restrict(temp2{5},freq))';

   
%     end
    
    clear Sp
    clear f
    clear t
    clear temp
    clear temp2
    %    try
       
    clear ChBulb
    try
      tempchBulb=load([res,'/ChannelsToAnalyse/PaCx_deep.mat'],'channel');
    chBulb=tempchBulb.channel;
    eval(['load(''',res,'','/SpectrumDataL/Spectrum',num2str(chBulb),'.mat'');'])
        Sp;
%     catch
%     load LFPData/InfoLFP
%     [params,movingwin,suffix]=SpectrumParametersML('low');
%     ComputeSpectrogram_newML(movingwin,params,InfoLFP,'PaCx','All',suffix);
%     eval(['load(''',res,'','/SpectrumDataL/Spectrum',num2str(chBulb),'.mat'');'])
        end
    
    Stsd=tsd(t*1E4,Sp);
    for kl=1:length(op)
    temp{kl}=mean(Data(Restrict(Stsd,op{kl})));
    temp2{kl}=tsd(f,temp{kl}');
    end
    SpPaC1KO(b,:)=Data(Restrict(temp2{1},freq))';
    SpPaC2KO(b,:)=Data(Restrict(temp2{2},freq))';
    SpPaC3KO(b,:)=Data(Restrict(temp2{3},freq))';
    SpPaC4KO(b,:)=Data(Restrict(temp2{4},freq))';
%     SpPaC5KO(b,:)=Data(Restrict(temp2{5},freq))';

   
%    end
   
   
    clear Sp
    clear f
    clear t
    clear temp
    clear temp2
    
%    try
       try
    clear ChBulb
      tempchBulb=load([res,'/ChannelsToAnalyse/Bulb_deep.mat'],'channel');
    chBulb=tempchBulb.channel;
    eval(['load(''',res,'','/SpectrumDataL/Spectrum',num2str(chBulb),'.mat'');'])

        Sp;
%     catch
%     load LFPData/InfoLFP
%     [params,movingwin,suffix]=SpectrumParametersML('low');
%     ComputeSpectrogram_newML(movingwin,params,InfoLFP,'Bulb','All',suffix);
%     eval(['load(''',res,'','/SpectrumDataL/Spectrum',num2str(chBulb),'.mat'');'])
     end
        
    Stsd=tsd(t*1E4,Sp);
     for kl=1:length(op)
    temp{kl}=mean(Data(Restrict(Stsd,op{kl})));
    temp2{kl}=tsd(f,temp{kl}');
     end
    SpBulb1KO(b,:)=Data(Restrict(temp2{1},freq))';
    SpBulb2KO(b,:)=Data(Restrict(temp2{2},freq))';
    SpBulb3KO(b,:)=Data(Restrict(temp2{3},freq))';
    SpBulb4KO(b,:)=Data(Restrict(temp2{4},freq))';
%     SpBulb5KO(b,:)=Data(Restrict(temp2{5},freq))';
    
   
  

  cellnamesKO{b}=pwd;         
  b=b+1;
    end
 
  close all
  
      
            end
           
     
 end
% catch
%     keyboard
end
 %end
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
try
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

end

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
