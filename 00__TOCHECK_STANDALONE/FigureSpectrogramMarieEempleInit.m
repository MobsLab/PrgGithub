
%FigureSpectrogramMarieEempleInit

Dir1=PathForExperimentsDeltaSleepNew('BASAL');
Dir1=RestrictPathForExperiment(Dir1,'nMice',[243 244 251 252]);
Dir2=PathForExperimentsML('BASAL');
Dir2=RestrictPathForExperiment(Dir2,'Group','WT');
Dir=MergePathForExperiment(Dir1,Dir2);

a=1;
for man=1:length(Dir.path)
        try
   cd(Dir.path{man})
   disp(Dir.path{man})
   [Wake,REMEpoch,N1,N2,N3]=RunSubstages; close all
   for i=1:length(Start(N1))
   dur(a)=End(subset(N1,i),'s')-Start(subset(N1,i),'s');
   a=a+1;
   end
   
   
        end
        
end


id=find(dur>50);

k=1;
a=1;
for man=1:length(Dir.path)
        try
   cd(Dir.path{man})
   disp(Dir.path{man})
    [Wake,REMEpoch,N1,N2,N3]=RunSubstages; 
   for i=1:length(Start(N1))
   if a==id(k)

       
       res=pwd;
    tempchBulb=load([res,'/ChannelsToAnalyse/Bulb_deep.mat'],'channel');
    chBulb=tempchBulb.channel;
    eval(['load(''',res,'','/SpectrumDataL/Spectrum',num2str(chBulb),'.mat'');'])
    SpBulb=Sp;
    fBulb=f;
    tBulb=t;
    tempchHPC=load([res,'/ChannelsToAnalyse/dHPC_deep.mat'],'channel');
    chHPC=tempchHPC.channel;
    eval(['load(''',res,'','/SpectrumDataL/Spectrum',num2str(chHPC),'.mat'');'])
    SpHpc=Sp;
    fHpc=f;
    tHpc=t;
    tempchPFC=load([res,'/ChannelsToAnalyse/PFCx_deep.mat'],'channel');
    chPFC=tempchPFC.channel;
    eval(['load(''',res,'','/SpectrumDataL/Spectrum',num2str(chPFC),'.mat'');'])
    SpPfc=Sp;
    fPfc=f;
    tPfc=t;
    
    figure('color',[1 1 1]), 
    subplot(3,1,1), imagesc(tPfc,fPfc,10*log10(SpPfc')), axis xy, caxis([17 58])
    line([Start(subset(N1,i),'s') Start(subset(N1,i),'s')],ylim)
    line([End(subset(N1,i),'s') End(subset(N1,i),'s')],ylim)
    xlim([Start(subset(N1,i),'s')-200 End(subset(N1,i),'s')+dur(i)+200])
    title(pwd)
    subplot(3,1,2), imagesc(tHpc,fHpc,10*log10(SpHpc')), axis xy,caxis([17 58])
    line([Start(subset(N1,i),'s') Start(subset(N1,i),'s')],ylim)
    line([End(subset(N1,i),'s') End(subset(N1,i),'s')],ylim)
    xlim([Start(subset(N1,i),'s')-200 End(subset(N1,i),'s')+dur(i)+200])
    title(['k=',num2str(k),', a=',num2str(a)])
    subplot(3,1,3), imagesc(tBulb,fBulb,10*log10(SpBulb')), axis xy, caxis([17 58])
    line([Start(subset(N1,i),'s') Start(subset(N1,i),'s')],ylim)
    line([End(subset(N1,i),'s') End(subset(N1,i),'s')],ylim) 
    xlim([Start(subset(N1,i),'s')-200 End(subset(N1,i),'s')+dur(i)+200])
    colormap(jet)
       c=input('Continuer? (1:0) ');
              if c==0
                  c=1;
                  keyboard
              end
              k=k+1;
   end
   a=a+1;
   
   end
        end
        
end
