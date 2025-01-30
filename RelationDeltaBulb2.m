%RelationDeltaBulb2

%tit='dHPC';
%tit='Bulb';
tit='PaCx';
%tit='PFCx';
del=400;

a=1;
%NameDir={'PLETHYSMO' 'BASAL' 'DPCPX' 'CANAB'};
%NameDir={'LPS'};
%NameDir={'PLETHYSMO'}; fac=1E7;
NameDir={'BASAL'}; fac=1;

for i=1:length(NameDir)
Dir=PathForExperimentsML(NameDir{i}); Dir=PathForExperimentsML(NameDir{i});

for man=1:5:length(Dir.path)
%for man=1:length(Dir.path)

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
%    tit2=', delta pfc'; tit3='';
%     
    load DeltaPaCx
    tit2=', delta parietal'; tit3='';
    
    try
    load behavResources
    tref=Range(Restrict(tDeltaT2,PreEpoch),'s');
    catch
    tref=Range(tDeltaT2,'s');    
    end
    
%-----------------------------------------------------------------------
%-----------------------------------------------------------------------

%     load SpindlesRipples Rip
%     treftsd=tsd(Rip(:,2)*1E4,Rip);
%       try
%         load behavResources
%         tref=Range(Restrict(treftsd,PreEpoch),'s');
%       catch
%         tref=Range(treftsd,'s');          
%       end
%      tit2=', ripples';    


%-----------------------------------------------------------------------
%-----------------------------------------------------------------------


% %load SpindlesPaCxDeep
% %load SpindlesPaCxSup
% %tit2=', spindles Par';
% 
% %load SpindlesPFCxDeep
%  load SpindlesPFCxSup
%  tit2=', spindles Pfc';
% 
% %treftsd=tsd(SpiTot(:,2)*1E4,SpiTot); tit3=' Tot';
% %treftsd=tsd(SpiHigh(:,2)*1E4,SpiHigh); tit3=' High';
% treftsd=tsd(SpiLow(:,2)*1E4,SpiLow); tit3=' Low';
% %treftsd=tsd(SpiULow(:,2)*1E4,SpiULow); tit3=' ULow';
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
    
    ch1=listBulb(id(end)); % deep
    ch2=listBulb(id(1));   % sup
    

%     load ChannelsToAnalyse/Bulb_deep.mat
%     eval(['load LFPData/LFP',num2str(channel),'.mat'])
    clear LFP
    eval(['load LFPData/LFP',num2str(ch1),'.mat'])
    
    D{a}=PlotRipRaw(LFP,tref,del);close

%     clear channel
%     load ChannelsToAnalyse/Bulb_sup.mat
%     eval(['load LFPData/LFP',num2str(channel),'.mat'])
    
    clear LFP
    eval(['load LFPData/LFP',num2str(ch2),'.mat'])
    
    S{a}=PlotRipRaw(LFP,tref,del);close

    N{a}=[Dir.name{man},' ',Dir.group{man}];
    
    a=a+1;


  end   %try 27

end
end





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




    

    sWT=[];
    for i=listWT
        try
    sWT=[sWT;S{i}(:,2)'];
        end
    end
    
    sKO=[];
    for i=listKO
        try
    sKO=[sKO;S{i}(:,2)'];
        end
    end
    
tps=S{1}(:,1);

    figure('color',[1 1 1]), 
    subplot(2,1,1)
    plot(tps,mean(sWT),'k','linewidth',2), hold on, 
    plot(tps,mean(sWT)+stdError(sWT),'k','linewidth',1)
    plot(tps,mean(sWT)-stdError(sWT),'k','linewidth',1)    
    plot(tps,mean(sKO),'r','linewidth',2)
    plot(tps,mean(sKO)+stdError(sKO),'r','linewidth',1)   
    plot(tps,mean(sKO)-stdError(sKO),'r','linewidth',1)  
    title([tit,tit2,tit3])

    dWT=[];
    for i=listWT
        try
    dWT=[dWT;D{i}(:,2)'];
        end
    end
    
    dKO=[];
    for i=listKO
    try
        dKO=[dKO;D{i}(:,2)'];
    end
    end

%    figure('color',[1 1 1]), 
    subplot(2,1,2)
    plot(tps,mean(dWT),'k','linewidth',2), hold on, 
    plot(tps,mean(dWT)+stdError(dWT),'k','linewidth',1)
    plot(tps,mean(dWT)-stdError(dWT),'k','linewidth',1)    
    plot(tps,mean(dKO),'r','linewidth',2)
    plot(tps,mean(dKO)+stdError(dKO),'r','linewidth',1)   
    plot(tps,mean(dKO)-stdError(dKO),'r','linewidth',1)   
    title([tit,tit2,tit3])


