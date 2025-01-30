function [id,tps1,tps2,tps3,M1,M2,M3]=PCAMMNSkullSingle(part, elec, th, tempTh, debStd, smo, ThSig, tps, Mlocalstd,Mlocaldev,MlocalstdXXXY,MlocaldevXXXY,Mglobalstd,Mglobaldev,LFPnames)



disp(' ')
disp('elec, th, tempTh, debStd, smo, ThSig')
disp(' ')

id1=find(tps>-tempTh);
id1=id1(1);
id2=find(tps<tempTh);
id2=id2(end);


Mlocalstd=Mlocalstd{elec};
Mlocaldev=Mlocaldev{elec};
MlocalstdXXXY=MlocalstdXXXY{elec};
MlocaldevXXXY=MlocaldevXXXY{elec};
Mglobalstd=Mglobalstd{elec};
Mglobaldev=Mglobaldev{elec};


   [rows,cols,vals] =find(Mlocalstd(:,id1:id2)>th|Mlocalstd(:,id1:id2)<-th);
   Mlocalstd(rows,:)=[];
   RowsStd=unique(rows);
   clear rows
   
   [rows,cols,vals] =find(Mlocaldev(:,id1:id2)>th|Mlocaldev(:,id1:id2)<-th);
   Mlocaldev(rows,:)=[];
   clear rows
   
   [rows,cols,vals] =find(MlocalstdXXXY(:,id1:id2)>th|MlocalstdXXXY(:,id1:id2)<-th);
   MlocalstdXXXY(rows,:)=[];
   clear rows
   
   [rows,cols,vals] =find(MlocaldevXXXY(:,id1:id2)>th|MlocaldevXXXY(:,id1:id2)<-th);
   MlocaldevXXXY(rows,:)=[];
   clear rows
   
   [rows,cols,vals] =find(Mglobalstd(:,id1:id2)>th|Mglobalstd(:,id1:id2)<-th);
   Mglobalstd(rows,:)=[];
   clear rows
   
   [rows,cols,vals] =find(Mglobaldev(:,id1:id2)>th|Mglobaldev(:,id1:id2)<-th);
   Mglobaldev(rows,:)=[];
   clear rows
   

%end

nBad=find(RowsStd<debStd);
debStd=debStd-length(nBad);

%------------------------------------------------------------------------------------
%------------------------------------------------------------------------------------
%------------------------------------------------------------------------------------



MLocStd=Mlocalstd(debStd:end,:);
MglobStd=Mglobalstd(debStd:end,:);

if part>0
    
   
    [r1,p1]=corrcoef(MLocStd(:,id1:id2)');
    [V1,L1]=pcacov(r1);
    pc11=V1(:,1);
    [BE,id]=sort(pc11);
    idx1(1)=1;
    idx2(1)=length(pc11)/4;
    idx3(1)=length(pc11)-length(pc11)/4;
    idx4(1)=length(pc11);

    [r1,p1]=corrcoef(Mlocaldev(:,id1:id2)');
    [V1,L1]=pcacov(r1);
    pc11=V1(:,1);
    [BE,id]=sort(pc11);
    idx1(2)=1;
    idx2(2)=length(pc11)/4;
    idx3(2)=length(pc11)-length(pc11)/4;
    idx4(2)=length(pc11);
    

    [r1,p1]=corrcoef(MlocalstdXXXY(:,id1:id2)');
    [V1,L1]=pcacov(r1);
    pc11=V1(:,1);
    [BE,id]=sort(pc11);
    idx1(3)=1;
    idx2(3)=length(pc11)/4;
    idx3(3)=length(pc11)-length(pc11)/4;
    idx4(3)=length(pc11);
    

    [r1,p1]=corrcoef(MlocaldevXXXY(:,id1:id2)');
    [V1,L1]=pcacov(r1);
    pc11=V1(:,1);
    [BE,id]=sort(pc11);
    idx1(4)=1;
    idx2(4)=length(pc11)/4;
    idx3(4)=length(pc11)-length(pc11)/4;
    idx4(4)=length(pc11);
    

    [r1,p1]=corrcoef(MglobStd(:,id1:id2)');
    [V1,L1]=pcacov(r1);
    pc11=V1(:,1);
    [BE,id]=sort(pc11);
    idx1(5)=1;
    idx2(5)=length(pc11)/4;
    idx3(5)=length(pc11)-length(pc11)/4;
    idx4(5)=length(pc11);
    

    [r1,p1]=corrcoef(MlocaldevXXXY(:,id1:id2)');
    [V1,L1]=pcacov(r1);
    pc11=V1(:,1);
    [BE,id]=sort(pc11);
    idx1(6)=1;
    idx2(6)=length(pc11)/4;
    idx3(6)=length(pc11)-length(pc11)/4;
    idx4(6)=length(pc11);
   
end

    
    if part==1
        
    elseif part==1
        
    elseif part==3
    
    
    end



%------------------------------------------------------------------------------------
%------------------------------------------------------------------------------------
%------------------------------------------------------------------------------------






figure('color',[1 1 1])

subplot(5,6,1), plot(tps,nanmean(Mlocalstd(debStd:end,:)),'k')
yl=ylim;
line([0 0],[yl(1) yl(2)],'color','k')
xlim([tps(1) tps(end)])
ylim([-300 300])
title('local std XXXX')

subplot(5,6,2), plot(tps,nanmean(Mlocaldev),'r')
title('local dev XXXX')
yl=ylim;
line([0 0],[yl(1) yl(2)],'color','k')
xlim([tps(1) tps(end)])
ylim([-300 300])

subplot(5,6,3), plot(tps,nanmean(MlocalstdXXXY),'k')
yl=ylim;
line([0 0],[yl(1) yl(2)],'color','k')
xlim([tps(1) tps(end)])
title('local std XXXY')
ylim([-300 300])

subplot(5,6,4), plot(tps,nanmean(MlocaldevXXXY),'r')
yl=ylim;
line([0 0],[yl(1) yl(2)],'color','k')
xlim([tps(1) tps(end)])
title('local dev XXXY')
ylim([-300 300])

subplot(5,6,5), plot(tps,nanmean(Mglobalstd),'k')
yl=ylim;
line([0 0],[yl(1) yl(2)],'color','k')
xlim([tps(1) tps(end)])
title('global std')
ylim([-300 300])

subplot(5,6,6), plot(tps,nanmean(Mglobaldev),'r')
yl=ylim;
line([0 0],[yl(1) yl(2)],'color','k')
xlim([tps(1) tps(end)])
title('global dev')
ylim([-300 300])



subplot(5,6,[7 13 19]), imagesc(tps,[1:size(Mlocalstd(debStd:end,:),1)], Mlocalstd(debStd:end,:))
hold on, line([0 0],[0.5 size(Mlocalstd(debStd:end,:),1)],'color','k')
caxis([-2500 2500])

subplot(5,6,[8 14 20]), imagesc(tps,[1:size(Mlocaldev,1)], Mlocaldev)
hold on, line([0 0],[0.5 size(Mlocaldev,1)],'color','k')
caxis([-2500 2500])

subplot(5,6,[9 15 21]), imagesc(tps,[1:size(MlocalstdXXXY,1)], MlocalstdXXXY)
hold on, line([0 0],[0.5 size(MlocalstdXXXY,1)],'color','k')
caxis([-2500 2500])

subplot(5,6,[10 16 22]), imagesc(tps,[1:size(MlocaldevXXXY,1)], MlocaldevXXXY)
hold on, line([0 0],[0.5 size(MlocaldevXXXY,1)],'color','k')
caxis([-2500 2500])

subplot(5,6,[11 17 23]), imagesc(tps,[1:size(Mglobalstd(debStd:end,:),1)], Mglobalstd(debStd:end,:))
hold on, line([0 0],[0.5 size(Mglobalstd(debStd:end,:),1)],'color','k')
caxis([-2500 2500])

subplot(5,6,[12 18 24]), imagesc(tps,[1:size(Mglobaldev,1)], Mglobaldev)
hold on, line([0 0],[0.5 size(Mglobaldev,1)],'color','k')
caxis([-2500 2500])




numfi=gcf;

load('MyColormaps','mycmap')
set(numfi,'Colormap',mycmap)



sc=300;

subplot(5,6,25:26), hold on
plot(tps,SmoothDec(nanmean(Mlocalstd(debStd:end,:)),smo),'color',[0 0.5 0],'linewidth',2)
% plot(tps,SmoothDec(nanmean(Mlocaldev{elec}),smo),'color',[0.6 0 0.6],'linewidth',1)
plot(tps,SmoothDec(nanmean(Mlocaldev),smo),'color',[0.6 0 0.6],'linewidth',2,'linestyle','--')
ylim([-sc sc])
yl=ylim;
line([0 0],[yl(1) yl(2)],'color','k')
xlim([tps(1) tps(end)])
title(LFPnames{elec})
xlim([-0.5 0.5])

subplot(5,6,27:28), hold on
plot(tps,SmoothDec(nanmean(MlocalstdXXXY),smo),'k','color',[0.6 0 0.6],'linewidth',2)
% plot(tps,SmoothDec(nanmean(MlocaldevXXXY{elec}),smo),'r','color',[0 0.5 0],'linewidth',1)
plot(tps,SmoothDec(nanmean(MlocaldevXXXY),smo),'r','color',[0 0.5 0],'linewidth',2,'linestyle','--')
ylim([-sc sc])
yl=ylim;
line([0 0],[yl(1) yl(2)],'color','k')
xlim([tps(1) tps(end)])
title(LFPnames{elec})
xlim([-0.5 0.5])

subplot(5,6,29:30), hold on
plot(tps,SmoothDec(nanmean(Mglobalstd),smo),'color',[0 0.5 0],'linewidth',2)
plot(tps,SmoothDec(nanmean(Mglobaldev),smo),'color',[0.6 0 0.6],'linewidth',2)
ylim([-sc sc])
yl=ylim;
line([0 0],[yl(1) yl(2)],'color','k')
xlim([tps(1) tps(end)])
title(LFPnames{elec})
xlim([-0.5 0.5])





%-------------------------------------------------------------------------
%-------------------------------------------------------------------------
%-------------------------------------------------------------------------



if ThSig>0
    
for i=1:size(Mlocalstd,2)
[h,p1(i)]=ttest2(Mlocalstd(debStd:end,i),Mlocaldev(:,i));
[h,p2(i)]=ttest2(MlocalstdXXXY(:,i),MlocaldevXXXY(:,i));
[h,p3(i)]=ttest2(Mglobalstd(:,i),Mglobaldev(:,i));
end

try
subplot(5,6,25:26), hold on
hold on, plot(tps(p1<ThSig),50*p1(elec,p1<ThSig)-200,'b.')
set(gca,'xtick',[-600 -400 -200 0 200 400 600]/1000)
subplot(5,6,27:28), hold on
hold on, plot(tps(p2<ThSig),50*p2(elec,p2<ThSig)-200,'b.')
set(gca,'xtick',[-600 -400 -200 0 200 400 600]/1000)
subplot(5,6,29:30), hold on
hold on, plot(tps(p3<ThSig),50*p3(elec,p3<ThSig)-200,'b.')
set(gca,'xtick',[-600 -400 -200 0 200 400 600]/1000)
end

end
