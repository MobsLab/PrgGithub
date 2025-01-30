function [tpsstd,Mstd, tpsmmn,Mmmn]= ObsMMNSkull(numSession, elec, th, tempTh, ThSig)

try
    new;
catch
    new=1;
end

    filenameLFP=['LFPData',num2str(numSession)];
    eval(['load ',filenameLFP]) 

    filename=['behavResources',num2str(numSession)];
    eval(['load ',filename]) 

    if new==1
    filenameStim=['Newstim',num2str(numSession)];
    else
     filenameStim=['stim',num2str(numSession)];   
    end
   
    eval(['load ',filenameStim]) 

    load ManipeName
    
    
    
%    LFP{elec}=FilterLFP(LFP{elec},[0.01 40],1024);
    
    
    
    
    
    if length(sda)>1
    figure('color',[1 1 1]), [fh, rasterAx, histAx, matValSTD] = ImagePETH(LFP{elec}, ts(sda*1E4), -10000, +15000,'BinSize',500);close
    Mstd=Data(matValSTD)';
    tpsstd=Range(matValSTD,'s');
    else
        Mstd=[];
        tpsstd=[];
    end
    
    if length(MMN)>1
    figure('color',[1 1 1]), [fh, rasterAx, histAx, matValMMN] = ImagePETH(LFP{elec}, ts(MMN*1E4), -10000, +15000,'BinSize',500);close
        Mmmn=Data(matValMMN)';
    tpsmmn=Range(matValMMN,'s');
    else
        Mmmn=[];
        tpsmmn=[];
        
    end    

  if length(sda)>1&length(MMN)>1  
tps=tpsstd(1:min(length(tpsmmn),length(tpsstd)));
  elseif length(sda)>1
  tps=tpsstd;
  else
      tps=tpsmmn;
  end
    
    id1=find(tps>-tempTh);
    id1=id1(1);
    id2=find(tps<tempTh);
    id2=id2(end);

try
   [rows,cols,vals] =find(Mstd(:,id1:id2)>th|Mstd(:,id1:id2)<-th);
   Mstd(rows,:)=[];
end
try
    clear rows
   [rows,cols,vals] =find(Mmmn(:,id1:id2)>th|Mmmn(:,id1:id2)<-th);
   Mmmn(rows,:)=[];
end 
   
   
   
   figure('color',[1 1 1])
   try
   subplot(4,2,1), plot(tpsstd, mean(Mstd),'k','linewidth',1)
   yl=ylim;
line([0 0],[yl(1) yl(2)],'color','k')
   title([num2str(length(sda)),'   ', num2str(size(Mstd,1))])
   subplot(4,2,[3,5]), imagesc(tpsstd, [1:size(Mstd,1)], Mstd),caxis([-2500 2500])
   yl=ylim;
line([0 0],[yl(1) yl(2)],'color','k')
   end
   try
      subplot(4,2,2), plot(tpsmmn, mean(Mmmn),'k','linewidth',1)
      ylim([-300 300])
      yl=ylim;
line([0 0],[yl(1) yl(2)],'color','k')
      title([num2str(length(MMN)),'   ', num2str(size(Mmmn,1))])
      subplot(4,2,[4,6]), imagesc(tpsmmn, [1:size(Mmmn,1)], Mmmn) , caxis([-2500 2500])
      numfi=gcf;


load('MyColormaps','mycmap')
set(numfi,'Colormap',mycmap)
      yl=ylim;
line([0 0],[yl(1) yl(2)],'color','k')
   end
   
   subplot(4,2,[7,8])
   try
   plot(tpsstd,mean(Mstd),'k'), 
   end
   try
       hold on, plot(tpsmmn,mean(Mmmn),'r')
   end
   title([manipe{numSession},' ',num2str(numSession)])
      ylim([-300 300])
   yl=ylim;
line([0 0],[yl(1) yl(2)],'color','k')
xlim([-0.6 tempTh])



if ThSig>0
    for ki=1:length(tps)
    [h,p(ki)]=ttest2(Mstd(:,ki),Mmmn(:,ki));
        end
    

    %try
    subplot(4,2,[7,8]), hold on
    hold on, plot(tps(p<ThSig),50*p(p<ThSig)-yl(2)-50,'b.')
    %end
end
      numfi=gcf;


load('MyColormaps','mycmap')
set(numfi,'Colormap',mycmap)