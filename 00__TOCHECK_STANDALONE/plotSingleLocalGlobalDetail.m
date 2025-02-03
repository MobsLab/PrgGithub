
function plotSingleLocalGlobalDetail(elec, th, tempTh, debStd, smo, ThSig, tps, Mlocalstd,Mlocaldev,MlocalstdXXXY,MlocaldevXXXY,Mglobalstd,Mglobaldev,LFPnames)


try 
    LFPnames;
catch
    LFPnames=[];
end



sc=300;
xsca=0.5;


disp(' ')
disp('elec, th, tempTh, debStd, smo, ThSig')
disp(' ')

id1=find(tps>-tempTh);
id1=id1(1);
id2=find(tps<tempTh);
id2=id2(end);

%keyboard

%for i=1:15
i=elec;

   [rows,cols,vals] =find(Mlocalstd{i}(:,id1:id2)>th|Mlocalstd{i}(:,id1:id2)<-th);
   Mlocalstd{i}(rows,:)=[];
   RowsStd=unique(rows);
   clear rows
   
   [rows,cols,vals] =find(Mlocaldev{i}(:,id1:id2)>th|Mlocaldev{i}(:,id1:id2)<-th);
   Mlocaldev{i}(rows,:)=[];
   clear rows
   
   [rows,cols,vals] =find(MlocalstdXXXY{i}(:,id1:id2)>th|MlocalstdXXXY{i}(:,id1:id2)<-th);
   MlocalstdXXXY{i}(rows,:)=[];
   clear rows
   
   [rows,cols,vals] =find(MlocaldevXXXY{i}(:,id1:id2)>th|MlocaldevXXXY{i}(:,id1:id2)<-th);
   MlocaldevXXXY{i}(rows,:)=[];
   clear rows
   
   [rows,cols,vals] =find(Mglobalstd{i}(:,id1:id2)>th|Mglobalstd{i}(:,id1:id2)<-th);
   Mglobalstd{i}(rows,:)=[];
   clear rows
   
   [rows,cols,vals] =find(Mglobaldev{i}(:,id1:id2)>th|Mglobaldev{i}(:,id1:id2)<-th);
   Mglobaldev{i}(rows,:)=[];
   clear rows
   

%end

nBad=find(RowsStd<debStd);
debStd=debStd-length(nBad);


% smoo=0;
% 
% if smoo
%     
%     try
%         load LocalGlobalSmooth
%     catch
%         
% for i=1:15
%     try
%         i
%         
% Mlocalstd{i}=SmoothDec(Mlocalstd{i},[0.01,smo]);
% Mlocaldev{i}=SmoothDec(Mlocaldev{i},[0.01,smo]);
% 
% MlocalstdXXXY{i}=SmoothDec(MlocalstdXXXY{i},[0.01,smo]);
% MlocaldevXXXY{i}=SmoothDec(MlocaldevXXXY{i},[0.01,smo]);
% 
% Mglobalstd{i}=SmoothDec(Mglobalstd{i},[0.01,smo]);
% Mglobaldev{i}=SmoothDec(Mglobaldev{i},[0.01,smo]);
%     catch
%         keyboard
%     end
% 
% end
% 
% save LocalGlobalSmooth smo tps Mlocalstd Mlocaldev MlocalstdXXXY MlocaldevXXXY Mglobalstd Mglobaldev LFPnames
% 
% end
% 
% end









figure('color',[1 1 1])

%--------------------------------------------------------------------------
%--------------------------------------------------------------------------
%--------------------------------------------------------------------------
if length(tps)>size(Mlocalstd{elec},2)
    tpsTemp=tps(1:size(Mlocalstd{elec},2));
else
    Mlocalstd{elec}=Mlocalstd{elec}(:,1:length(tps));
    tpsTemp=tps;
end
subplot(2,3,1), hold on, plot(tpsTemp,nanmean(Mlocalstd{elec}(debStd:end,:)),'k','linewidth',2)
ylim([-sc sc])
yl=ylim;
line([0 0],[yl(1) yl(2)],'color','k')
xlim([tpsTemp(1) tpsTemp(end)])

title('local std XXXX')

subplot(2,3,4), hold on
plot(tpsTemp,SmoothDec(nanmean(Mlocalstd{elec}(debStd:end,:)),smo),'color',[0 0.5 0],'linewidth',2)
% plot(tps,SmoothDec(nanmean(Mlocaldev{elec}),smo),'color',[0.6 0 0.6],'linewidth',1)
%plot(tps,SmoothDec(nanmean(Mlocaldev{elec}),smo),'color',[0.6 0 0.6],'linewidth',2,'linestyle','--')
ylim([-sc sc])
yl=ylim;
line([0 0],[yl(1) yl(2)],'color','k')
xlim([tpsTemp(1) tpsTemp(end)])
try
    title(LFPnames{elec})
end
xlim([-0.5 0.5])

%--------------------------------------------------------------------------
%--------------------------------------------------------------------------
%--------------------------------------------------------------------------

if length(tps)>size(Mlocaldev{elec},2)
    tpsTemp=tps(1:size(Mlocaldev{elec},2));
else
    Mlocaldev{elec}=Mlocaldev{elec}(:,1:length(tps));
    tpsTemp=tps;
end

subplot(2,3,1), hold on, plot(tpsTemp,nanmean(Mlocaldev{elec}),'r','linewidth',2)
title('local dev XXXX')
ylim([-sc sc])
yl=ylim;
line([0 0],[yl(1) yl(2)],'color','k')
xlim([tpsTemp(1) tpsTemp(end)])
%ylim([-300 300])
xlim([-xsca xsca])

subplot(2,3,4), hold on
%plot(tps,SmoothDec(nanmean(Mlocalstd{elec}(debStd:end,:)),smo),'color',[0 0.5 0],'linewidth',2)
% plot(tps,SmoothDec(nanmean(Mlocaldev{elec}),smo),'color',[0.6 0 0.6],'linewidth',1)
plot(tpsTemp,SmoothDec(nanmean(Mlocaldev{elec}),smo),'color',[0.6 0 0.6],'linewidth',2)%,'linestyle','--')
ylim([-sc sc])
yl=ylim;
line([0 0],[yl(1) yl(2)],'color','k')
xlim([tpsTemp(1) tpsTemp(end)])
try
    title(LFPnames{elec})
end
xlim([-xsca xsca])

%--------------------------------------------------------------------------
%--------------------------------------------------------------------------
%--------------------------------------------------------------------------


if length(tps)>size(MlocalstdXXXY{elec},2)
    tpsTemp=tps(1:size(MlocalstdXXXY{elec},2));
else
    MlocalstdXXXY{elec}=MlocalstdXXXY{elec}(:,1:length(tps));
    tpsTemp=tps;
end
subplot(2,3,2), hold on, plot(tpsTemp,nanmean(MlocalstdXXXY{elec}),'k','linewidth',2)
ylim([-sc sc])
yl=ylim;
line([0 0],[yl(1) yl(2)],'color','k')
xlim([tpsTemp(1) tpsTemp(end)])
title('local std XXXY')
%ylim([-300 300])
xlim([-xsca xsca])


subplot(2,3,5), hold on
plot(tpsTemp,SmoothDec(nanmean(MlocalstdXXXY{elec}),smo),'k','color',[0.6 0 0.6],'linewidth',2)
% plot(tps,SmoothDec(nanmean(MlocaldevXXXY{elec}),smo),'r','color',[0 0.5 0],'linewidth',1)
ylim([-sc sc])
yl=ylim;
line([0 0],[yl(1) yl(2)],'color','k')
xlim([tpsTemp(1) tpsTemp(end)])
try
    title(LFPnames{elec})
end
xlim([-xsca xsca])

%--------------------------------------------------------------------------
%--------------------------------------------------------------------------
%--------------------------------------------------------------------------


if length(tps)>size(MlocaldevXXXY{elec},2)
    tpsTemp=tps(1:size(MlocaldevXXXY{elec},2));
else
    MlocaldevXXXY{elec}=MlocaldevXXXY{elec}(:,1:length(tps));
    tpsTemp=tps;
end


subplot(2,3,2), hold on, plot(tpsTemp,nanmean(MlocaldevXXXY{elec}),'r','linewidth',2)
ylim([-sc sc])
yl=ylim;
line([0 0],[yl(1) yl(2)],'color','k')
xlim([tpsTemp(1) tpsTemp(end)])
title('local dev XXXY')
%ylim([-300 300])
xlim([-xsca xsca])

subplot(2,3,5), hold on, plot(tpsTemp,SmoothDec(nanmean(MlocaldevXXXY{elec}),smo),'r','color',[0 0.5 0],'linewidth',2)%,'linestyle','--')
ylim([-sc sc])
yl=ylim;
line([0 0],[yl(1) yl(2)],'color','k')
xlim([tpsTemp(1) tpsTemp(end)])
try
    title(LFPnames{elec})
end
xlim([-xsca xsca])

%--------------------------------------------------------------------------
%--------------------------------------------------------------------------
%--------------------------------------------------------------------------


if length(tps)>size(Mglobalstd{elec},2)
    tpsTemp=tps(1:size(Mglobalstd{elec},2));
else
    Mglobalstd{elec}=Mglobalstd{elec}(:,1:length(tps));
    tpsTemp=tps;
end

subplot(2,3,3), hold on, plot(tpsTemp,nanmean(Mglobalstd{elec}),'k','linewidth',2)
ylim([-sc sc])
yl=ylim;
line([0 0],[yl(1) yl(2)],'color','k')
xlim([tpsTemp(1) tpsTemp(end)])
title('global std')
%ylim([-300 300])
xlim([-xsca xsca])



subplot(2,3,6), hold on, plot(tpsTemp,SmoothDec(nanmean(Mglobalstd{elec}),smo),'color',[0 0.5 0],'linewidth',2)
ylim([-sc sc])
yl=ylim;
line([0 0],[yl(1) yl(2)],'color','k')
xlim([tpsTemp(1) tpsTemp(end)])
try
    title(LFPnames{elec})
end
xlim([-xsca xsca])




%--------------------------------------------------------------------------
%--------------------------------------------------------------------------
%--------------------------------------------------------------------------


if length(tps)>size(Mglobaldev{elec},2)
    tpsTemp=tps(1:size(Mglobaldev{elec},2));
else
    Mglobaldev{elec}=Mglobaldev{elec}(:,1:length(tps));
    tpsTemp=tps;
end




subplot(2,3,3), hold on, plot(tpsTemp,nanmean(Mglobaldev{elec}),'r','linewidth',2)
ylim([-sc sc])
yl=ylim;
line([0 0],[yl(1) yl(2)],'color','k')
xlim([tpsTemp(1) tpsTemp(end)])
title('global dev')
%ylim([-300 300])
xlim([-xsca xsca])

subplot(2,3,6), hold on, plot(tpsTemp,SmoothDec(nanmean(Mglobaldev{elec}),smo),'color',[0.6 0 0.6],'linewidth',2)
ylim([-sc sc])
yl=ylim;
line([0 0],[yl(1) yl(2)],'color','k')
xlim([tpsTemp(1) tpsTemp(end)])
try
    title(LFPnames{elec})
end
xlim([-xsca xsca])


%--------------------------------------------------------------------------
%--------------------------------------------------------------------------
%--------------------------------------------------------------------------


numfi=gcf;

load('MyColormaps','mycmap')
set(numfi,'Colormap',mycmap)







%-------------------------------------------------------------------------
%-------------------------------------------------------------------------
%-------------------------------------------------------------------------



% 
% 
% figure('color',[1 1 1]), 
% 
% subplot(3,1,1), hold on
% plot(tps,smooth(nanmean(Mlocalstd{elec}(debStd:end,:)),smo),'k')
% plot(tps,smooth(nanmean(Mlocaldev{elec}),smo),'r')
% ylim([-500 500])
% yl=ylim;
% line([0 0],[yl(1) yl(2)],'color','k')
% xlim([tps(1) tps(end)])
% title(LFPnames{elec})
% xlim([-0.6 0.6])
% 
% 
% subplot(3,1,2), hold on
% plot(tps,smooth(nanmean(MlocalstdXXXY{elec}),smo),'k', 'linewidth',2)
% plot(tps,smooth(nanmean(MlocaldevXXXY{elec}),smo),'r', 'linewidth',2)
% ylim([-500 500])
% yl=ylim;
% line([0 0],[yl(1) yl(2)],'color','k')
% xlim([tps(1) tps(end)])
% title(LFPnames{elec})
% xlim([-0.6 0.6])
% 
% subplot(3,1,3), hold on
% plot(tps,smooth(nanmean(Mglobalstd{elec}),smo),'b', 'linewidth',2)
% plot(tps,smooth(nanmean(Mglobaldev{elec}),smo),'m', 'linewidth',2)
% ylim([-500 500])
% yl=ylim;
% line([0 0],[yl(1) yl(2)],'color','k')
% xlim([tps(1) tps(end)])
% title(LFPnames{elec})
% xlim([-0.6 0.6])
if ThSig>0
     MlocalstdSmo=SmoothDec(Mlocalstd{elec}(debStd:end,:),[0.001, smo]);
    MlocaldevSmo=SmoothDec(Mlocaldev{elec},[0.001,smo]);
    MlocalstdXXXYSmo=SmoothDec(MlocalstdXXXY{elec},[0.001,smo]);
    MlocaldevXXXYSmo=SmoothDec(MlocaldevXXXY{elec},[0.001,smo]);
    MglobalstdSmo=SmoothDec(Mglobalstd{elec},[0.001,smo]);
    MglobaldevSmo=SmoothDec(Mglobaldev{elec},[0.001,smo]);   
for i=1:size(Mlocalstd{elec},2)
  

    try
        [h,p1s(elec,i)]=ttest2(MlocalstdSmo(:,i),MlocaldevSmo(:,i));
    end
    try
        [h,p2s(elec,i)]=ttest2(MlocalstdXXXYSmo(:,i),MlocaldevXXXYSmo(:,i));
    end
    try
        [h,p3s(elec,i)]=ttest2(MglobalstdSmo(:,i),MglobaldevSmo(:,i));
    end

    try
        [h,p1(elec,i)]=ttest2(Mlocalstd{elec}(debStd:end,i),Mlocaldev{elec}(:,i));
    end
    try
        [h,p2(elec,i)]=ttest2(MlocalstdXXXY{elec}(:,i),MlocaldevXXXY{elec}(:,i));
    end
    try
        [h,p3(elec,i)]=ttest2(Mglobalstd{elec}(:,i),Mglobaldev{elec}(:,i));
    end
end


try
subplot(2,3,4), hold on
hold on, plot(tps(p1s(elec,:)<ThSig),50*p1s(elec,p1s(elec,:)<ThSig)-200,'b.')
set(gca,'xtick',[-600 -400 -200 0 200 400 600]/1000)
end

try
subplot(2,3,5), hold on
hold on, plot(tps(p2s(elec,:)<ThSig),50*p2s(elec,p2s(elec,:)<ThSig)-200,'b.')
set(gca,'xtick',[-600 -400 -200 0 200 400 600]/1000)
end
try
subplot(2,3,6), hold on
hold on, plot(tps(p3s(elec,:)<ThSig),50*p3s(elec,p3s(elec,:)<ThSig)-200,'b.')
set(gca,'xtick',[-600 -400 -200 0 200 400 600]/1000)
end



try
subplot(2,3,1), hold on
hold on, plot(tps(p1(elec,:)<ThSig),50*p1(elec,p1(elec,:)<ThSig)-200,'b.')
set(gca,'xtick',[-600 -400 -200 0 200 400 600]/1000)
end

try
subplot(2,3,2), hold on
hold on, plot(tps(p2(elec,:)<ThSig),50*p2(elec,p2(elec,:)<ThSig)-200,'b.')
set(gca,'xtick',[-600 -400 -200 0 200 400 600]/1000)
end
try
subplot(2,3,3), hold on
hold on, plot(tps(p3(elec,:)<ThSig),50*p3(elec,p3(elec,:)<ThSig)-200,'b.')
set(gca,'xtick',[-600 -400 -200 0 200 400 600]/1000)
end

end
