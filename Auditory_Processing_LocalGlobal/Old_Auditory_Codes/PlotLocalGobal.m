% PlotLocalGobal

 %1624;
% load NewLFPStim1 tpsSTD
% len=length(tpsSTD{1})-1;;
% tps=tpsSTD{1}(1:len);
% 


load NewLFPstimResamp1 tpsSTD
len=length(tpsSTD{1})-1;
tps=tpsSTD{1}(1:len);







load ManipeName manipe

for elec=1:15;
    
Mlocalstd{elec}=[];
Mlocaldev{elec}=[];
MlocalstdXXXY{elec}=[];
MlocaldevXXXY{elec}=[];
Mglobalstd{elec}=[];
Mglobaldev{elec}=[];

end

for i=1:length(manipe)-2

    filenameLFPStim=['NewLFPstimResamp',num2str(i)];
    eval(['load ',filenameLFPStim,' tpsSTD MatSTD tpsMMN MatMMN']) 

%     disp(' ')
%     disp(['load ',filenameLFPStim,' tpsSTD MatSTD tpsMMN MatMMN']) 
%     disp(' ')
%     disp(filenameLFPStim)
%     disp(' ')    
    
    for elec=1:15;
    

    if length(manipe{i})==2&manipe{i}=='XX'
        Mlocalstd{elec}=[Mlocalstd{elec};MatSTD{elec}(:,1:len)];
    end

    if length(manipe{i})==2&manipe{i}=='YY'
        Mlocalstd{elec}=[Mlocalstd{elec};MatMMN{elec}(:,1:len)];
    end

    if length(manipe{i})==3&manipe{i}=='XXy'      
        % xxx_x xxx_x xxx_X xxx_x : local std / global std
        % xxx_x xxx_x xxx_Y xxx_x : local dev / global dev
       Mlocalstd{elec}=[Mlocalstd{elec};MatSTD{elec}(:,1:len)];
       Mlocaldev{elec}=[Mlocaldev{elec};MatMMN{elec}(:,1:len)];
       Mglobalstd{elec}=[Mglobalstd{elec};MatSTD{elec}(:,1:len)];
       Mglobaldev{elec}=[Mglobaldev{elec};MatMMN{elec}(:,1:len)];        
    end

    if length(manipe{i})==3&manipe{i}=='YYx'      
       % yyy-y yyy-y yyy-X yyy-y : local dev / global dev
       % yyy-y yyy-y yyy-Y yyy-y : local std / global std
       
       Mlocalstd{elec}=[Mlocalstd{elec};MatMMN{elec}(:,1:len)];
       Mlocaldev{elec}=[Mlocaldev{elec};MatSTD{elec}(:,1:len)];
       Mglobalstd{elec}=[Mglobalstd{elec};MatMMN{elec}(:,1:len)];
       Mglobaldev{elec}=[Mglobaldev{elec};MatSTD{elec}(:,1:len)];       
       
    end


    if length(manipe{i})==3&manipe{i}=='XyX'      
       % xxx_y xxx_y xxx_X xxx_y : local std / global dev
       % xxx_y xxx_y xxx_Y xxx_y : local dev / global std
       
       MlocalstdXXXY{elec}=[MlocalstdXXXY{elec};MatSTD{elec}(:,1:len)];
       MlocaldevXXXY{elec}=[MlocaldevXXXY{elec};MatMMN{elec}(:,1:len)];
       Mglobalstd{elec}=[Mglobalstd{elec};MatMMN{elec}(:,1:len)];
       Mglobaldev{elec}=[Mglobaldev{elec};MatSTD{elec}(:,1:len)];
    end

    if length(manipe{i})==3&manipe{i}=='YxY'      
        % yyy-x yyy-x yyy-X yyy-x : local dev / global std
        % yyy-x yyy-x yyy-Y yyy-x : local std / global dev
       
       MlocalstdXXXY{elec}=[MlocalstdXXXY{elec};MatMMN{elec}(:,1:len)];
       MlocaldevXXXY{elec}=[MlocaldevXXXY{elec};MatSTD{elec}(:,1:len)];
       Mglobalstd{elec}=[Mglobalstd{elec};MatSTD{elec}(:,1:len)];
       Mglobaldev{elec}=[Mglobaldev{elec};MatMMN{elec}(:,1:len)];
    end



    end

    
clear tpsSTD 
clear MatSTD 
clear tpsMMN 
clear MatMMN
end







LFPnames{1}='Prefrontal Cortex, superfical layer';
LFPnames{2}='Prefrontal Cortex, superfical layer';
LFPnames{3}='Prefrontal Cortex, superfical layer';
LFPnames{4}='Prefrontal Cortex, superfical layer';

LFPnames{5}='Parietal Cortex, EEG';
LFPnames{6}='Parietal Cortex, ECog';
LFPnames{7}='Parietal Cortex, deep layer';
LFPnames{8}='Parietal Cortex, deep layer';
LFPnames{9}='Parietal Cortex, deep layer';

LFPnames{10}='Auditory Cortex, EEG';
LFPnames{11}='Auditory Cortex, ECog';
LFPnames{12}='Auditory Cortex, deep layer';
LFPnames{13}='Auditory Cortex, deep layer';
LFPnames{14}='Auditory Cortex, superficial layer';
LFPnames{15}='Auditory Cortex, superficial layer';


th=2000;

id1=find(tps>-0.590);
id1=id1(1);
id2=find(tps<0.500);
id2=id2(end);
% Mlocalstd{i}=[];
% Mlocaldev{i}=[];
% MlocalstdBasX{i}=[];
% MlocalstdBasY{i}=[];
% MlocalstdXXXY{i}=[];
% MlocaldevXXXY{i}=[];

% Mglobalstd{i}=[];
% Mglobaldev{i}=[];

% 
% for i=1:15
% 
% 
% Mlocalstd{i}(Mlocalstd{i}(:,id1:id2)>th|Mlocalstd{i}(:,id1:id2)<-th)=nan;
% Mlocaldev{i}(Mlocaldev{i}(:,id1:id2)>th|Mlocaldev{i}(:,id1:id2)<-th)=nan;
% MlocalstdXXXY{i}(MlocalstdXXXY{i}(:,id1:id2)>th|MlocalstdXXXY{i}(:,id1:id2)<-th)=nan;
% MlocaldevXXXY{i}(MlocaldevXXXY{i}(:,id1:id2)>th|MlocaldevXXXY{i}(:,id1:id2)<-th)=nan;
% Mglobalstd{i}(Mglobalstd{i}(:,id1:id2)>th|Mglobalstd{i}(:,id1:id2)<-th)=nan;
% Mglobaldev{i}(Mglobaldev{i}(:,id1:id2)>th|Mglobaldev{i}(:,id1:id2)<-th)=nan;
% 
% end
if 0
    
for i=1:length(Mlocalstd)

   [rows,cols,vals] =find(Mlocalstd{i}(:,id1:id2)>th|Mlocalstd{i}(:,id1:id2)<-th);
   Mlocalstd{i}(rows,:)=[];
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
   

end

end

% 
% for i=1:15
%     a=1;
%     for j=1:size(Mlocalstd{i},1)
%     if length(find(Mlocalstd{i}(j,:)>2000|Mlocalstd{i}(j,:)<-2000))<10
%     MlocalstdC{i}(a,:)=Mlocalstd{i}(j,:);
%     a=a+1;
%     end
%     end
% 
%     a=1;
%     for j=1:size(Mlocaldev{i},1)
%     if length(find(Mlocaldev{i}(j,:)>2000|Mlocaldev{i}(j,:)<-2000))<10
%     MlocaldevC{i}(a,:)=Mlocaldev{i}(j,:);
%     a=a+1;
%     end
%     end
% 
%     a=1;
%     for j=1:size(Mglobalstd{i},1)
%     if length(find(Mglobalstd{i}(j,:)>2000|Mglobalstd{i}(j,:)<-2000))<10
%     MglobalstdC{i}(a,:)=Mglobalstd{i}(j,:);
%     a=a+1;
%     end
%     end
%     
%     a=1;
%     for j=1:size(Mglobaldev{i},1)
%     if length(find(Mglobaldev{i}(j,:)>2000|Mglobaldev{i}(j,:)<-2000))<10
%     MglobaldevC{i}(a,:)=Mglobaldev{i}(j,:);
%     a=a+1;
%     end
%     end
% 
% end
% 
% 







if 1

for elec=1:length(Mlocalstd)
    
figure('color',[1 1 1])

subplot(5,4,1), plot(tps,nanmean(Mlocalstd{elec}),'k')
yl=ylim;
line([0 0],[yl(1) yl(2)],'color','k')
xlim([tps(1) tps(end)])
title('local std')

subplot(5,4,2), plot(tps,nanmean(Mlocaldev{elec}),'r')
title('local dev')
yl=ylim;
line([0 0],[yl(1) yl(2)],'color','k')
xlim([tps(1) tps(end)])

subplot(5,4,3), plot(tps,nanmean(Mglobalstd{elec}),'k')
yl=ylim;
line([0 0],[yl(1) yl(2)],'color','k')
xlim([tps(1) tps(end)])
title('global std')

subplot(5,4,4), plot(tps,nanmean(Mglobaldev{elec}),'r')
yl=ylim;
line([0 0],[yl(1) yl(2)],'color','k')
xlim([tps(1) tps(end)])
title('global dev')

subplot(5,4,[5 9 13]), imagesc(tps,[1:size(Mlocalstd{elec},1)], Mlocalstd{elec})
hold on, line([0 0],[0.5 size(Mlocalstd{elec},1)],'color','k')
caxis([-2500 2500])
subplot(5,4,[6 10 14]), imagesc(tps,[1:size(Mlocaldev{elec},1)], Mlocaldev{elec})
hold on, line([0 0],[0.5 size(Mlocaldev{elec},1)],'color','k')
caxis([-2500 2500])
subplot(5,4,[7 11 15]), imagesc(tps,[1:size(Mglobalstd{elec},1)], Mglobalstd{elec})
hold on, line([0 0],[0.5 size(Mglobalstd{elec},1)],'color','k')
caxis([-2500 2500])
subplot(5,4,[8 12 16]), imagesc(tps,[1:size(Mglobaldev{elec},1)], Mglobaldev{elec})
hold on, line([0 0],[0.5 size(Mglobaldev{elec},1)],'color','k')
caxis([-2500 2500])
numfi=gcf;

load('MyColormaps','mycmap')
set(numfi,'Colormap',mycmap)


subplot(5,4,17:20), hold on
plot(tps,nanmean(Mlocalstd{elec}),'k')
plot(tps,nanmean(Mlocaldev{elec}),'r')
plot(tps,nanmean(Mglobalstd{elec}),'b')
plot(tps,nanmean(Mglobaldev{elec}),'m')
yl=ylim;
line([0 0],[yl(1) yl(2)],'color','k')
xlim([tps(1) tps(end)])
title(LFPnames{elec})
xlim([-0.5 0.5])
end


end




% for i=1:15
% Mlocalstd{i}(Mlocalstd{i}>2000|Mlocalstd{i}<-2000)=nan;
% Mlocaldev{i}(Mlocaldev{i}>2000|Mlocaldev{i}<-2000)=nan;
% Mglobalstd{i}(Mglobalstd{i}>2000|Mglobalstd{i}<-2000)=nan;
% Mglobaldev{i}(Mglobaldev{i}>2000|Mglobaldev{i}<-2000)=nan;
% end
% 
% smo=10;
% ThSig=0.01;
% 
% for elec=1:15
% figure('color',[1 1 1]), hold on
% plot(tps,smooth(nanmean(Mlocalstd{elec}),smo),'k')
% plot(tps,smooth(nanmean(Mlocaldev{elec}),smo),'r')
% plot(tps,smooth(nanmean(Mglobalstd{elec}),smo),'b')
% plot(tps,smooth(nanmean(Mglobaldev{elec}),smo),'m')
% yl=ylim;
% line([0 0],[yl(1) yl(2)],'color','k')
% xlim([tps(1) tps(end)])
% title(LFPnames{elec})
% xlim([-0.7 0.6])
% 
% for i=1:size(Mlocalstd{elec},2)
% [h,p1(elec,i)]=ttest2(Mlocalstd{elec}(:,i),Mlocaldev{elec}(:,i));
% [h,p2(elec,i)]=ttest2(Mlocalstd{elec}(:,i),Mglobalstd{elec}(:,i));
% [h,p3(elec,i)]=ttest2(Mlocalstd{elec}(:,i),Mglobaldev{elec}(:,i));
% [h,p4(elec,i)]=ttest2(Mlocaldev{elec}(:,i),Mglobaldev{elec}(:,i));
% end
% hold on, plot(tps(p1(elec,:)<ThSig),50*p1(elec,p1(elec,:)<ThSig)-160,'r.')
% hold on, plot(tps(p2(elec,:)<ThSig),50*p2(elec,p2(elec,:)<ThSig)-170,'b.')
% hold on, plot(tps(p3(elec,:)<ThSig),50*p3(elec,p3(elec,:)<ThSig)-180,'m.')
% hold on, plot(tps(p4(elec,:)<ThSig),50*p4(elec,p4(elec,:)<ThSig)-190,'g.')
% 
% end
% 













smo=5;
ThSig=0.05;
debStd=1;

for elec=1:15

    figure('color',[1 1 1]), 

subplot(3,1,1), hold on
plot(tps,smooth(nanmean(Mlocalstd{elec}(debStd:end,:)),smo),'k')
plot(tps,smooth(nanmean(Mlocaldev{elec}),smo),'r')
ylim([-500 500])
yl=ylim;
line([0 0],[yl(1) yl(2)],'color','k')
xlim([tps(1) tps(end)])
title(LFPnames{elec})
xlim([-0.7 0.6])


subplot(3,1,2), hold on
plot(tps,smooth(nanmean(MlocalstdXXXY{elec}),smo),'k', 'linewidth',2)
plot(tps,smooth(nanmean(MlocaldevXXXY{elec}),smo),'r', 'linewidth',2)
ylim([-500 500])
yl=ylim;
line([0 0],[yl(1) yl(2)],'color','k')
xlim([tps(1) tps(end)])
title(LFPnames{elec})
xlim([-0.7 0.6])

subplot(3,1,3), hold on
plot(tps,smooth(nanmean(Mglobalstd{elec}),smo),'b', 'linewidth',2)
plot(tps,smooth(nanmean(Mglobaldev{elec}),smo),'m', 'linewidth',2)
ylim([-500 500])
yl=ylim;
line([0 0],[yl(1) yl(2)],'color','k')
xlim([tps(1) tps(end)])
title(LFPnames{elec})
xlim([-0.7 0.6])

for i=1:size(Mlocalstd{elec},2)
[h,p1(elec,i)]=ttest2(Mlocalstd{elec}(debStd:end,i),Mlocaldev{elec}(:,i));
[h,p2(elec,i)]=ttest2(MlocalstdXXXY{elec}(:,i),MlocaldevXXXY{elec}(:,i));
[h,p3(elec,i)]=ttest2(Mglobalstd{elec}(:,i),Mglobaldev{elec}(:,i));
end
subplot(3,1,1), hold on
hold on, plot(tps(p1(elec,:)<ThSig),50*p1(elec,p1(elec,:)<ThSig)-160,'b.')
% %hold on, plot(tps(p2(elec,:)<ThSig),50*p2(elec,p2(elec,:)<ThSig)-170,'b.')
% hold on, plot(tps(p3(elec,:)<ThSig),50*p3(elec,p3(elec,:)<ThSig)-180,'m.')
% hold on, plot(tps(p4(elec,:)<ThSig),50*p4(elec,p4(elec,:)<ThSig)-190,'g.')
subplot(3,1,2), hold on
hold on, plot(tps(p2(elec,:)<ThSig),50*p2(elec,p2(elec,:)<ThSig)-190,'b.')
subplot(3,1,3), hold on
hold on, plot(tps(p3(elec,:)<ThSig),50*p3(elec,p3(elec,:)<ThSig)-190,'m.')
end











% 
% for i=1:15
%     a=1;
%     for j=1:size(Mlocalstd{i},1)
%     if length(find(Mlocalstd{i}(j,:)>2000|Mlocalstd{i}(j,:)<-2000))<10
%     MlocalstdC{i}(a,:)=Mlocalstd{i}(j,:);
%     a=a+1;
%     end
%     end
% 
%     a=1;
%     for j=1:size(Mlocaldev{i},1)
%     if length(find(Mlocaldev{i}(j,:)>2000|Mlocaldev{i}(j,:)<-2000))<10
%     MlocaldevC{i}(a,:)=Mlocaldev{i}(j,:);
%     a=a+1;
%     end
%     end
% 
%     a=1;
%     for j=1:size(Mglobalstd{i},1)
%     if length(find(Mglobalstd{i}(j,:)>2000|Mglobalstd{i}(j,:)<-2000))<10
%     MglobalstdC{i}(a,:)=Mglobalstd{i}(j,:);
%     a=a+1;
%     end
%     end
%     
%     a=1;
%     for j=1:size(Mglobaldev{i},1)
%     if length(find(Mglobaldev{i}(j,:)>2000|Mglobaldev{i}(j,:)<-2000))<10
%     MglobaldevC{i}(a,:)=Mglobaldev{i}(j,:);
%     a=a+1;
%     end
%     end
% 
% end
% 
% 

save LocalGlobal tps Mlocalstd Mlocaldev MlocalstdXXXY MlocaldevXXXY Mglobalstd Mglobaldev LFPnames

