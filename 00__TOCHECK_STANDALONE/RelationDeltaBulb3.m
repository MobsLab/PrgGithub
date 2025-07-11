%RelationDeltaBulb3


tit='Bulb';

del=400;

a=1;
%NameDir={'PLETHYSMO' 'BASAL' 'DPCPX' 'CANAB'};
%NameDir={'LPS'};
%NameDir={'PLETHYSMO'};
NameDir={'BASAL'};

for i=1:length(NameDir)
Dir=PathForExperimentsML(NameDir{i}); Dir=PathForExperimentsML(NameDir{i});
for man=1:length(Dir.path)
cd(Dir.path{man})

disp(' ')
disp(Dir.name{man})
disp(Dir.path{man})

 try

    clear tref
    clear tDeltaT2
    clear Rip
    
%-----------------------------------------------------------------------    
%-----------------------------------------------------------------------    

%    load DeltaPFCx
%    tit2=', delta pfc';tit3='';
%     
% %     load DeltaPaCx
% %     tit2=', delta parietal';tit3='';
%     
% try
% load behavResources
% tref=Range(Restrict(tDeltaT2,PreEpoch),'s');
% catch
% tref=Range(tDeltaT2,'s');    
% end
    
%-----------------------------------------------------------------------
%-----------------------------------------------------------------------

    load SpindlesRipples Rip
    treftsd=tsd(Rip(:,2)*1E4,Rip);
      try
        load behavResources
        tref=Range(Restrict(treftsd,PreEpoch),'s');
      catch
        tref=Range(treftsd,'s');          
      end
     tit2=', ripples';      
     
%-----------------------------------------------------------------------
%-----------------------------------------------------------------------
% 
% %load SpindlesPaCxDeep
% load SpindlesPaCxSup
% tit2=', spindles Par deep';
% 
% %load SpindlesPFCxDeep
% %load SpindlesPFCxSup
% %tit2=', spindles Pfc deep';
% 
% %treftsd=tsd(SpiTot(:,2)*1E4,SpiTot); tit3=' Tot';
% %treftsd=tsd(SpiHigh(:,2)*1E4,SpiHigh); tit3=' High';
% treftsd=tsd(SpiLow(:,2)*1E4,SpiLow); tit3=' Low';
% %treftsd=tsd(SpiULow(:,2)*1E4,SpiULow); tit3=' ULow';
% 
% try
% load behavResources
% tref=Range(Restrict(treftsd,PreEpoch),'s');
% catch
% tref=Range(treftsd,'s');          
% end

%-----------------------------------------------------------------------
%-----------------------------------------------------------------------
%-----------------------------------------------------------------------




    clear channel
    clear InfoLFP
    load LFPData/InfoLFP
    
    clear listBulb
    clear listBulbDepth
    
    listBulb=InfoLFP.channel(strcmp(InfoLFP.structure,tit));
    listBulbDepth=InfoLFP.depth(strcmp(InfoLFP.structure,tit));
    
    clear id
    [BE,id]=sort(listBulbDepth);
    clear ch1
    clear ch2
    
    le=length(id);
    if le>5
    ch5=listBulb(id(le)); % deep
    ch4=listBulb(id(floor(2*le/3)));
    ch3=listBulb(id(floor(le/2)));% sup
    ch2=listBulb(id(floor(le/3)));   % sup
    ch1=listBulb(id(1));   % sup
    else
    ch5=listBulb(id(5)); % deep
    ch4=listBulb(id(4));
    ch3=listBulb(id(3));% sup
    ch2=listBulb(id(2));   % sup
    ch1=listBulb(id(1));   % sup
    end


    clear LFP
    eval(['load LFPData/LFP',num2str(ch1),'.mat'])
    L1{a}=PlotRipRaw(LFP,tref,del);close

    clear LFP
    eval(['load LFPData/LFP',num2str(ch2),'.mat'])
    L2{a}=PlotRipRaw(LFP,tref,del);close
    
    clear LFP
    eval(['load LFPData/LFP',num2str(ch3),'.mat'])
    L3{a}=PlotRipRaw(LFP,tref,del);close
    
    clear LFP
    eval(['load LFPData/LFP',num2str(ch4),'.mat'])
    L4{a}=PlotRipRaw(LFP,tref,del);close
    
    clear LFP
    eval(['load LFPData/LFP',num2str(ch5),'.mat'])
    L5{a}=PlotRipRaw(LFP,tref,del);close    
    
    N{a}=[Dir.name{man},' ',Dir.group{man}];
    
    a=a+1;


end
 end
end


%-----------------------------------------------------------------------
%-----------------------------------------------------------------------

k=1;
j=1;
for i=1:length(N)
    if N{i}(end)=='T'
    listWT(k)=i;
    k=k+1;
    else
    listKO(j)=i;    
    j=j+1;
    end
end




    

    L1WT=[];
    for i=listWT
        try
    L1WT=[L1WT;L1{i}(:,2)'];
        end
    end
    
    L1KO=[];
    for i=listKO
        try
    L1KO=[L1KO;L1{i}(:,2)'];
        end
    end
    
    L2WT=[];
    for i=listWT
        try
    L2WT=[L2WT;L2{i}(:,2)'];
        end
    end
    
    L2KO=[];
    for i=listKO
        try
    L2KO=[L2KO;L2{i}(:,2)'];
        end
    end
    
    

    L3WT=[];
    for i=listWT
        try
    L3WT=[L3WT;L3{i}(:,2)'];
        end
    end
    
    L3KO=[];
    for i=listKO
        try
    L3KO=[L3KO;L3{i}(:,2)'];
        end
    end
    
    L4WT=[];
    for i=listWT
        try
    L4WT=[L4WT;L4{i}(:,2)'];
        end
    end
    
    L4KO=[];
    for i=listKO
        try
    L4KO=[L4KO;L4{i}(:,2)'];
        end
    end    
    

        L5WT=[];
    for i=listWT
        try
    L5WT=[L5WT;L5{i}(:,2)'];
        end
    end
    
    L5KO=[];
    for i=listKO
        try
    L5KO=[L5KO;L5{i}(:,2)'];
        end
    end
    
    
%-----------------------------------------------------------------------
%-----------------------------------------------------------------------

    
    tps=L1{1}(:,1);
    
    figure('color',[1 1 1]), 
    subplot(5,1,1)
    plot(tps,mean(L1WT),'k','linewidth',2), hold on, 
    plot(tps,mean(L1WT)+stdError(L1WT),'k','linewidth',1)
    plot(tps,mean(L1WT)-stdError(L1WT),'k','linewidth',1)    
    plot(tps,mean(L1KO),'r','linewidth',2)
    plot(tps,mean(L1KO)+stdError(L1KO),'r','linewidth',1)   
    plot(tps,mean(L1KO)-stdError(L1KO),'r','linewidth',1)  
    title([tit,tit2,tit3])
    subplot(5,1,2)
    plot(tps,mean(L2WT),'k','linewidth',2), hold on, 
    plot(tps,mean(L2WT)+stdError(L2WT),'k','linewidth',1)
    plot(tps,mean(L2WT)-stdError(L2WT),'k','linewidth',1)    
    plot(tps,mean(L2KO),'r','linewidth',2)
    plot(tps,mean(L2KO)+stdError(L2KO),'r','linewidth',1)   
    plot(tps,mean(L2KO)-stdError(L2KO),'r','linewidth',1)  
    subplot(5,1,3)
    plot(tps,mean(L3WT),'k','linewidth',2), hold on, 
    plot(tps,mean(L3WT)+stdError(L3WT),'k','linewidth',1)
    plot(tps,mean(L3WT)-stdError(L3WT),'k','linewidth',1)    
    plot(tps,mean(L3KO),'r','linewidth',2)
    plot(tps,mean(L3KO)+stdError(L3KO),'r','linewidth',1)   
    plot(tps,mean(L3KO)-stdError(L3KO),'r','linewidth',1)  
    subplot(5,1,4)
    plot(tps,mean(L4WT),'k','linewidth',2), hold on, 
    plot(tps,mean(L4WT)+stdError(L4WT),'k','linewidth',1)
    plot(tps,mean(L4WT)-stdError(L4WT),'k','linewidth',1)    
    plot(tps,mean(L4KO),'r','linewidth',2)
    plot(tps,mean(L4KO)+stdError(L4KO),'r','linewidth',1)   
    plot(tps,mean(L4KO)-stdError(L4KO),'r','linewidth',1)  
    subplot(5,1,5)
    plot(tps,mean(L5WT),'k','linewidth',2), hold on, 
    plot(tps,mean(L5WT)+stdError(L5WT),'k','linewidth',1)
    plot(tps,mean(L5WT)-stdError(L5WT),'k','linewidth',1)    
    plot(tps,mean(L5KO),'r','linewidth',2)
    plot(tps,mean(L5KO)+stdError(L5KO),'r','linewidth',1)   
    plot(tps,mean(L5KO)-stdError(L5KO),'r','linewidth',1)     
    

 %-----------------------------------------------------------------------
    
    figure('color',[1 1 1])
    subplot(2,1,1), hold on
    plot(tps,mean(L1WT),'color',[0 0 0],'linewidth',1),
    plot(tps,mean(L2WT),'color',[0.1 0.1 0.1],'linewidth',1),
    plot(tps,mean(L3WT),'color',[0.2 0.2 0.2],'linewidth',1),
    plot(tps,mean(L4WT),'color',[0.3 0.3 0.3],'linewidth',1),
    plot(tps,mean(L5WT),'color',[0.4 0.4 0.4],'linewidth',1),
    subplot(2,1,2), hold on
    plot(tps,mean(L1KO),'color',[1 0 0],'linewidth',1)
    plot(tps,mean(L2KO),'color',[0.9 0 0],'linewidth',1)
    plot(tps,mean(L3KO),'color',[0.8 0 0],'linewidth',1)
    plot(tps,mean(L4KO),'color',[0.7 0 0],'linewidth',1)
    plot(tps,mean(L5KO),'color',[0.6 0 0],'linewidth',1)
    title([tit,tit2,tit3])
    
    