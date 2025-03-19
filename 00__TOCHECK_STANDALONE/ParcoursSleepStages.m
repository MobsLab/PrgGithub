%ParcoursSleepStages



%% INPUTS

NameDir={'BASAL' 'PLETHYSMO' 'CANAB' 'DPCPX' 'LPS'};
%NameDir={'BASAL'};
NameDir={'PLETHYSMO'};
struct1='PaCx';  % For detection of spindles or delta waves
prof1='deep';    % For detection of spindles 

struct2='PaCx';  %LFP to analyse
prof2='deep';    %LFP to analyse

delta=1;
spindles=0;
ripples=1;

si=1000;


%% Run GenerateSpindlesData


a=1;
MdeltaT=[];
MdeltaP=[];    
MSpiToT=[];
MSpiHigh=[];
MSpiLow=[];
MSpiULow=[];
MRipples=[];
numSourisBis=[];
    clear tps
    clear numSouris
    
for i=1:length(NameDir)
    Dir=PathForExperimentsML(NameDir{i});
    for man=1:length(Dir.path)
        cd(Dir.path{man})
        
        disp('   ')
       
        disp(['   * * * ',Dir.name{man},' * * * '])
        
        
          try
    
 %---------------------------------------------------------------------------------------------------------------------------------------      
 %---------------------------------------------------------------------------------------------------------------------------------------      
 
 
                    numSouris(a)=str2num(Dir.name{man}(end-1:end));
                           
                    
                    clear LFP
                    clear LFP1
                    clear LFP2
                    clear channel
                    try
                    eval(['load ChannelsToAnalyse/',struct2,'_',prof2])
                    catch
                        try
                        if struct2=='Bulb'&prof2=='deep'
                        load SpectrumDataL/UniqueChannelBulb.mat
                        channel=channelToAnalyse;
                        end
                        end
                    end
                    
                        eval(['load LFPData/LFP',num2str(channel)])
                    LFP1=LFP; 

                    
                    
                    try
                        load behavResources PreEpoch VEHEpoch
                        try
                        Epoch=or(PreEpoch,VEHEpoch);
                        catch
                            Epoch=PreEpoch;
                        end
                        clear S12
                        clear S34
                        clear REMEpoch
                        clear WakeEpoch
                        clear SleepStages
                        load SleepStagesPaCxDeep
                        Epoch=and(Epoch,S34);
                    catch
                        
                        rg=Range(LFP1);
                        Epoch=intervalSet(rg(1),rg(end));
                        clear S12
                        clear S34
                        clear REMEpoch
                        clear WakeEpoch
                        clear SleepStages
                        load SleepStagesPaCxDeep
                        Epoch=and(Epoch,S34);
                        
                    end
            
               
if spindles
    
            if struct1=='PaCx'&prof1(1)=='d'
                load SpindlesPaCxDeep
            elseif struct1=='PaCx'&prof1(1)=='s'
                load SpindlesPaCxSup
            elseif struct1=='PaCx'&prof1(1)=='d'
                load SpindlesPFCxDeep    
            elseif struct1=='PFCx'&prof1(1)=='s'
                load SpindlesPFCxSup
            end
                    clear M1
                    M1=PlotRipRaw(LFP1,Range(Restrict(ts(SpiTot(:,2)*1E4),Epoch),'s'),si);close
                    MSpiToT=[MSpiToT;M1(:,2)'];
                    nSpiTot(a)=length(Range(Restrict(ts(SpiTot(:,2)*1E4),Epoch),'s'))/sum(End(Epoch,'s')-Start(Epoch,'s'));
                    
                    clear M1
                    M1=PlotRipRaw(LFP1,Range(Restrict(ts(SpiHigh(:,2)*1E4),Epoch),'s'),si);close
                    MSpiHigh=[MSpiHigh;M1(:,2)'];
                    nSpiHigh(a)=length(Range(Restrict(ts(SpiHigh(:,2)*1E4),Epoch),'s'))/sum(End(Epoch,'s')-Start(Epoch,'s'));
                    
                    clear M1
                    M1=PlotRipRaw(LFP1,Range(Restrict(ts(SpiLow(:,2)*1E4),Epoch),'s'),si);close
                    MSpiLow=[MSpiLow;M1(:,2)'];
                    nSpiLow(a)=length(Range(Restrict(ts(SpiLow(:,2)*1E4),Epoch),'s'))/sum(End(Epoch,'s')-Start(Epoch,'s'));
                    
                    clear M1
                    
                    M1=PlotRipRaw(LFP1,Range(Restrict(ts(SpiULow(:,2)*1E4),Epoch),'s'),si);close
                    MSpiULow=[MSpiULow;M1(:,2)'];
                    nSpiULow(a)=length(Range(Restrict(ts(SpiULow(:,2)*1E4),Epoch),'s'))/sum(End(Epoch,'s')-Start(Epoch,'s'));
                    
end

                    try
                        tps;
                    catch
                        try
                        if length(M1(:,1))>10
                        tps=M1(:,1);
                        end
                        end
                    end
if delta
    
                    
            if struct1=='PaCx'
                load DeltaPaCx
            else
                load DeltaPFCx
            end
            
            
                    M1=PlotRipRaw(LFP1,Range(Restrict(tDeltaT2,Epoch),'s'),si);close
                    MdeltaT=[MdeltaT;M1(:,2)'];
                    nDeltaT(a)=length(Range(Restrict(tDeltaT2,Epoch),'s'))/sum(End(Epoch,'s')-Start(Epoch,'s'));
                    
                    M1=PlotRipRaw(LFP1,Range(Restrict(tDeltaP2,Epoch),'s'),si);close                
                    MdeltaP=[MdeltaP;M1(:,2)'];
                    nDeltaP(a)=length(Range(Restrict(tDeltaP2,Epoch),'s'))/sum(End(Epoch,'s')-Start(Epoch,'s'));
                    
end
                    try
                        tps;
                    catch
                        try
                        if length(M1(:,1))>10
                        tps=M1(:,1);
                        end
                        end
                    end

if ripples   
    
                    load SpindlesRipples Rip
                    disp('Ripples OK')
                    M1=PlotRipRaw(LFP1,Range(Restrict(ts(Rip(:,2)*1E4),Epoch),'s'),si);close  
                    if length(M1(:,2))>10
                    MRipples=[MRipples;M1(:,2)'];
                    numSourisBis=[numSourisBis;str2num(Dir.name{man}(end-1:end))];
                    end
                    nRipples(a)=length(Range(Restrict(ts(Rip(:,2)*1E4),Epoch),'s'))/sum(End(Epoch,'s')-Start(Epoch,'s'));
    
end

                    try
                        tps;
                    catch
                        try
                        if length(M1(:,1))>10
                        tps=M1(:,1);
                        end
                        end
                    end


 %---------------------------------------------------------------------------------------------------------------------------------------                 
 %---------------------------------------------------------------------------------------------------------------------------------------                   
                    a=a+1;
            
        catch
            disp(' ')
            disp(['problem for ',Dir.name{man}])
            %disp(['step ParcoursSleepStages:  i=',num2str(i),' & man=',num2str(man)])
           % keyboard
            
        end
        
        
    end
end


cd /media/DataMOBsRAID5/ProjetAstro/DataPlethysmo




 %---------------------------------------------------------------------------------------------------------------------------------------                 
 %---------------------------------------------------------------------------------------------------------------------------------------                   
 %---------------------------------------------------------------------------------------------------------------------------------------                 
 %---------------------------------------------------------------------------------------------------------------------------------------                   

%  


 if length(numSourisBis)>1

    listKO=find(numSourisBis==47|numSourisBis==52|numSourisBis==54|numSourisBis==65|numSourisBis==66);
    listWT=find(numSourisBis==51|numSourisBis==60|numSourisBis==61|numSourisBis==82|numSourisBis==83);
    ti=1;
 else
     if size(numSouris,1)==1
         numSouris=numSouris';
     end
    listKO=find(numSouris==47|numSouris==52|numSouris==54|numSouris==65|numSouris==66);
    listWT=find(numSouris==51|numSouris==60|numSouris==61|numSouris==82|numSouris==83);
    ti=0;
 end
 
    

if delta
    
    Mref=MdeltaT;

    figure('color',[1 1 1]), hold on, 
    subplot(2,2,[1,3]),hold on,
    plot(tps,nanmean(Mref(listWT,:)),'k','linewidth',4), 
    plot(tps,nanmean(Mref(listWT,:))+nanstd(Mref(listWT,:)),'k','linewidth',1), 
    plot(tps,nanmean(Mref(listWT,:))-nanstd(Mref(listWT,:)),'k','linewidth',1), 
    plot(tps,nanmean(Mref(listKO,:)),'r','linewidth',4),
    plot(tps,nanmean(Mref(listKO,:))+nanstd((Mref(listKO,:))),'r','linewidth',1),
    plot(tps,nanmean(Mref(listKO,:))-nanstd((Mref(listKO,:))),'r','linewidth',1),
    plot(tps,nanmean(Mref(listKO,:)),'r','linewidth',2)
    title('Delta waves (through)')
    subplot(2,2,2), imagesc(Mref(listWT,:)),if ti==1 title(num2str(numSourisBis(listWT)')), else title(num2str(numSouris(listWT)')), end,colorbar
    subplot(2,2,4), imagesc(Mref(listKO,:)),if ti==1 title(num2str(numSourisBis(listKO)')), else title(num2str(numSouris(listKO)')), end,colorbar

    Mref=MdeltaP;

    figure('color',[1 1 1]), hold on, 
    subplot(2,2,[1,3]),hold on,
    plot(tps,nanmean(Mref(listWT,:)),'k','linewidth',4), 
    plot(tps,nanmean(Mref(listWT,:))+nanstd(Mref(listWT,:)),'k','linewidth',1), 
    plot(tps,nanmean(Mref(listWT,:))-nanstd(Mref(listWT,:)),'k','linewidth',1), 
    plot(tps,nanmean(Mref(listKO,:)),'r','linewidth',4),
    plot(tps,nanmean(Mref(listKO,:))+nanstd((Mref(listKO,:))),'r','linewidth',1),
    plot(tps,nanmean(Mref(listKO,:))-nanstd((Mref(listKO,:))),'r','linewidth',1),
    plot(tps,nanmean(Mref(listKO,:)),'r','linewidth',2)
   title('Delta waves (peaks)')
    subplot(2,2,2), imagesc(Mref(listWT,:)),if ti==1 title(num2str(numSourisBis(listWT)')), else title(num2str(numSouris(listWT)')), end,colorbar
    subplot(2,2,4), imagesc(Mref(listKO,:)),if ti==1 title(num2str(numSourisBis(listKO)')), else title(num2str(numSouris(listKO)')), end,colorbar

PlotErrorBar2(nDeltaP(listWT)',nDeltaP(listKO)'),   title('Delta waves (peaks)'),set(gca,'xtick',[1 2]),set(gca,'xticklabel',{'wt' 'ko'})
PlotErrorBar2(nDeltaT(listWT)',nDeltaT(listKO)'),title('Delta waves (through)'),set(gca,'xtick',[1 2]),set(gca,'xticklabel',{'wt' 'ko'})

end




if spindles
    
     Mref=MSpiToT;
     
     [BE,id]=min(Mref(:,1100:1400)');id=id+1099;
     for j=1:size(Mref,1)
         M(j,:)=Mref(j,id(j)-800:id(j)+800);
     end
     tps2=tps(floor(2501/2)-800:floor(2501/2)+800);
     Mref=M;
     
    figure('color',[1 1 1]), hold on, 
    subplot(2,2,[1,3]),hold on,
    plot(tps2,nanmean(Mref(listWT,:)),'k','linewidth',4), 
    plot(tps2,nanmean(Mref(listWT,:))+nanstd(Mref(listWT,:)),'k','linewidth',1), 
    plot(tps2,nanmean(Mref(listWT,:))-nanstd(Mref(listWT,:)),'k','linewidth',1), 
    plot(tps2,nanmean(Mref(listKO,:)),'r','linewidth',4),
    plot(tps2,nanmean(Mref(listKO,:))+nanstd((Mref(listKO,:))),'r','linewidth',1),
    plot(tps2,nanmean(Mref(listKO,:))-nanstd((Mref(listKO,:))),'r','linewidth',1),
    plot(tps2,nanmean(Mref(listKO,:)),'r','linewidth',2)
   title('Spindles')
    subplot(2,2,2), imagesc(Mref(listWT,:)),if ti==1 title(num2str(numSourisBis(listWT)')), else title(num2str(numSouris(listWT)')), end,colorbar
    subplot(2,2,4), imagesc(Mref(listKO,:)),if ti==1 title(num2str(numSourisBis(listKO)')), else title(num2str(numSouris(listKO)')), end,colorbar
    
    
     Mref=MSpiHigh;
     
     [BE,id]=min(Mref(:,1100:1400)');id=id+1099;
     for j=1:size(Mref,1)
         M(j,:)=Mref(j,id(j)-800:id(j)+800);
     end
     tps2=tps(floor(2501/2)-800:floor(2501/2)+800);
     Mref=M;
     
    figure('color',[1 1 1]), hold on, 
    subplot(2,2,[1,3]),hold on,
    plot(tps2,nanmean(Mref(listWT,:)),'k','linewidth',4), 
    plot(tps2,nanmean(Mref(listWT,:))+nanstd(Mref(listWT,:)),'k','linewidth',1), 
    plot(tps2,nanmean(Mref(listWT,:))-nanstd(Mref(listWT,:)),'k','linewidth',1), 
    plot(tps2,nanmean(Mref(listKO,:)),'r','linewidth',4),
    plot(tps2,nanmean(Mref(listKO,:))+nanstd((Mref(listKO,:))),'r','linewidth',1),
    plot(tps2,nanmean(Mref(listKO,:))-nanstd((Mref(listKO,:))),'r','linewidth',1),
    plot(tps2,nanmean(Mref(listKO,:)),'r','linewidth',2)
   title('High Spindles')
    subplot(2,2,2), imagesc(Mref(listWT,:)),if ti==1 title(num2str(numSourisBis(listWT)')), else title(num2str(numSouris(listWT)')), end,colorbar
    subplot(2,2,4), imagesc(Mref(listKO,:)),if ti==1 title(num2str(numSourisBis(listKO)')), else title(num2str(numSouris(listKO)')), end,colorbar

    Mref=MSpiLow;
    
     [BE,id]=min(Mref(:,1100:1400)');id=id+1099;
     for j=1:size(Mref,1)
         M(j,:)=Mref(j,id(j)-800:id(j)+800);
     end
     tps2=tps(floor(2501/2)-800:floor(2501/2)+800);
     Mref=M;
     
    figure('color',[1 1 1]), hold on, 
    subplot(2,2,[1,3]),hold on,
    plot(tps2,nanmean(Mref(listWT,:)),'k','linewidth',4), 
    plot(tps2,nanmean(Mref(listWT,:))+nanstd(Mref(listWT,:)),'k','linewidth',1), 
    plot(tps2,nanmean(Mref(listWT,:))-nanstd(Mref(listWT,:)),'k','linewidth',1), 
    plot(tps2,nanmean(Mref(listKO,:)),'r','linewidth',4),
    plot(tps2,nanmean(Mref(listKO,:))+nanstd((Mref(listKO,:))),'r','linewidth',1),
    plot(tps2,nanmean(Mref(listKO,:))-nanstd((Mref(listKO,:))),'r','linewidth',1),
    plot(tps2,nanmean(Mref(listKO,:)),'r','linewidth',2)
  title('Low Spindles') 
    subplot(2,2,2), imagesc(Mref(listWT,:)),if ti==1 title(num2str(numSourisBis(listWT)')), else title(num2str(numSouris(listWT)')), end,colorbar
    subplot(2,2,4), imagesc(Mref(listKO,:)),if ti==1 title(num2str(numSourisBis(listKO)')), else title(num2str(numSouris(listKO)')), end,colorbar
    
    
    
    Mref=MSpiULow;

     [BE,id]=min(Mref(:,1100:1400)');id=id+1099;
     for j=1:size(Mref,1)
         M(j,:)=Mref(j,id(j)-800:id(j)+800);
     end
     tps2=tps(floor(2501/2)-800:floor(2501/2)+800);
     Mref=M;
     
    figure('color',[1 1 1]), hold on, 
    subplot(2,2,[1,3]),hold on,
    plot(tps2,nanmean(Mref(listWT,:)),'k','linewidth',4), 
    plot(tps2,nanmean(Mref(listWT,:))+nanstd(Mref(listWT,:)),'k','linewidth',1), 
    plot(tps2,nanmean(Mref(listWT,:))-nanstd(Mref(listWT,:)),'k','linewidth',1), 
    plot(tps2,nanmean(Mref(listKO,:)),'r','linewidth',4),
    plot(tps2,nanmean(Mref(listKO,:))+nanstd((Mref(listKO,:))),'r','linewidth',1),
    plot(tps2,nanmean(Mref(listKO,:))-nanstd((Mref(listKO,:))),'r','linewidth',1),
    plot(tps2,nanmean(Mref(listKO,:)),'r','linewidth',2)
  title('Ultra low Spindles')
    subplot(2,2,2), imagesc(Mref(listWT,:)),if ti==1 title(num2str(numSourisBis(listWT)')), else title(num2str(numSouris(listWT)')), end,colorbar
    subplot(2,2,4), imagesc(Mref(listKO,:)),if ti==1 title(num2str(numSourisBis(listKO)')), else title(num2str(numSouris(listKO)')), end,colorbar

    
    
PlotErrorBar2(nSpiTot(listWT)',nSpiTot(listKO)'),   title('Spindles'),set(gca,'xtick',[1 2]),set(gca,'xticklabel',{'wt' 'ko'})
PlotErrorBar2(nSpiHigh(listWT)',nSpiHigh(listKO)'),title('High spindles'),set(gca,'xtick',[1 2]),set(gca,'xticklabel',{'wt' 'ko'})
PlotErrorBar2(nSpiLow(listWT)',nSpiLow(listKO)'),   title('Low spindles'),set(gca,'xtick',[1 2]),set(gca,'xticklabel',{'wt' 'ko'})
PlotErrorBar2(nSpiULow(listWT)',nSpiULow(listKO)'),title('Ultra low spindles'),set(gca,'xtick',[1 2]),set(gca,'xticklabel',{'wt' 'ko'})



end




if ripples

    listKO=find(numSourisBis==47|numSourisBis==52|numSourisBis==54|numSourisBis==65|numSourisBis==66);
    listWT=find(numSourisBis==51|numSourisBis==60|numSourisBis==82|numSourisBis==83);   

    Mref=MRipples;

    figure('color',[1 1 1]), hold on, 
    subplot(2,2,[1,3]),hold on,
    plot(tps,nanmean(Mref(listWT,:)),'k','linewidth',4), 
    plot(tps,nanmean(Mref(listWT,:))+nanstd(Mref(listWT,:)),'k','linewidth',1), 
    plot(tps,nanmean(Mref(listWT,:))-nanstd(Mref(listWT,:)),'k','linewidth',1), 
    plot(tps,nanmean(Mref(listKO,:)),'r','linewidth',4),
    plot(tps,nanmean(Mref(listKO,:))+nanstd((Mref(listKO,:))),'r','linewidth',1),
    plot(tps,nanmean(Mref(listKO,:))-nanstd((Mref(listKO,:))),'r','linewidth',1),
    plot(tps,nanmean(Mref(listKO,:)),'r','linewidth',2)
 title('Ripples')
    subplot(2,2,2), imagesc(Mref(listWT,:)),if ti==1 title(num2str(numSourisBis(listWT)')), else title(num2str(numSouris(listWT)')), end,colorbar
    subplot(2,2,4), imagesc(Mref(listKO,:)),if ti==1 title(num2str(numSourisBis(listKO)')), else title(num2str(numSouris(listKO)')), end,colorbar

PlotErrorBar2(nRipples(listWT)',nRipples(listKO)'),   title('Ripples'),set(gca,'xtick',[1 2]),set(gca,'xticklabel',{'wt' 'ko'})


end


