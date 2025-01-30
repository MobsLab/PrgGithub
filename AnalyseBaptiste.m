
% clear
% 
% % load('/Users/karimbenchenane/Downloads/DataForKarim_SumUpDrugsUMaze.mat')
% % load('/Users/karimbenchenane/Documents/MATLAB/DataForKarim_SumUpDrugsUMazeCorrected')
 load('/Users/karimbenchenane/Downloads/DataForKarim_SumUpDrugsUMaze (3).mat')

% Sum_Up(11,:)=[];
% Sum_Up(2,:)=[];
% Sum_Up(Sum_Up==0)=nan;
idd=find(Sum_Up(:,1)==0);
Sum_Up(idd,:)=[];

% Sum_Up=Sum_Up(:,[[1:9],[11:end]]);
% Columns_Names=Columns_Names([[1:9],[11:end]]);


Sum_UpIni=Sum_Up;
Columns_NamesIni=Columns_Names;
grIni=Sum_UpIni(:,1);

% idx=find(ismember(Sum_Up(:,1),[1,2,5,6,9,11]));
% % idx=find(Sum_Up(:,1)==1);
% Sum_Up=Sum_Up(idx,:);


% figure, 
% subplot(131),imagesc(Sum_Up'); set(gca,'YTick',1:21,'YTickLabel',Columns_Names)
% subplot(132),imagesc(nanzscore(Sum_Up'));
% subplot(133),imagesc(nanzscore(Sum_Up)');

gr=Sum_Up(:,1);
Sum_Up=nanzscore(Sum_Up);

%Sum_Up(:,1)=gr;

Sum_Up(:,1)=[];
Columns_Names=Columns_Names([2:end]);

Sum_UpPCA=Sum_Up;

r=nancorrcoef(Sum_UpPCA);
[V,L]=pcacov(r);
pc1=V(:,1);
[BE,id]=sort(pc1);

figure, 
subplot(1,5,1:2), hold on,
scatter(V(:,1),V(:,2),85,V(:,3),'filled'), colorbar
line(xlim,[0 0],'linewidth',1,'color','r')
line([0 0],ylim,'linewidth',1,'color','r')
plot(V(1,1),V(1,2),'ro')
for i=1:length(Columns_Names) 
        try,text(V(i,1)+0.005,V(i,2)+0.005,Columns_Names{i}),end
end
subplot(1,5,3),plot(L,'ko-')

subplot(1,5,4:5),imagesc(r(id,id)), 
try
set(gca,'YTick',1:length(Columns_Names),'YTickLabel',Columns_Names(id)), 
end
colorbar
set(gcf,'position',[33 246 1364 522])


figure, hold on, 
plot(V(:,1),1:size(V,1),'ko-'),plot(V(:,2),1:size(V,1),'ro-'), 
line([0 0],ylim,'linewidth',1,'color','k')
try, set(gca,'YTick',1:21,'YTickLabel',Columns_Names), end

% 
% figure, hold on
% scatter(V(:,1),V(:,2),75,V(:,3),'filled'), colorbar
% line(xlim,[0 0],'linewidth',1,'color','r')
% line([0 0],ylim,'linewidth',1,'color','r')
% plot(V(1,1),V(1,2),'ro')
% for i=1:size(V,1)
%     text(V(i,1)+0.005,V(i,2)+0.005,Columns_Names{i})
% end




figure, 
for i=1:length(Mice_Group)
    subplot(3,4,i), hold on
    clear idc temp
    co=[1 (11-i)/11 i/11];
    idc=find(ismember(gr,i));
    for j=1:length(idc)
    temp=Sum_Up(idc(j),:);temp(isnan(temp))=0;
    v1=temp*V(:,1);
    v2=temp*V(:,2);
        plot(v1,v2 ,'.','markersize',20,'color',co)
    end
    xlim([- 6 6]),ylim([- 6 6])
    line([0 0],ylim,'linewidth',1,'color','k')
    line(xlim,[0 0],'linewidth',1,'color','k')
    title(Mice_Group{i})
end


figure, 
for i=1:length(Mice_Group)
    subplot(3,4,i), hold on
    clear idc temp
    co=[1 (11-i)/11 i/11];
    idc=find(ismember(gr,i));
    for j=1:length(idc)
    temp=Sum_Up(idc(j),:);temp(isnan(temp))=0;
    v1=temp*V(:,2);
    v2=temp*V(:,3);
        plot(v1,v2 ,'.','markersize',20,'color',co)
    end
    xlim([- 6 6]),ylim([- 6 6])
    line([0 0],ylim,'linewidth',1,'color','k')
    line(xlim,[0 0],'linewidth',1,'color','k')
    title(Mice_Group{i}) 
end

figure
for i=1:length(Mice_Group)
    subplot(3,4,i), hold on

    clear idc temp
    co=[1 (11-i)/11 i/11];
    idc=find(ismember(gr,i));
    XY(i,:)=[0 0 0];
    for j=1:length(idc)
    temp=Sum_Up(idc(j),:);temp(isnan(temp))=0;
    v1=temp*V(:,1);
    v2=temp*V(:,2);
    v3=temp*V(:,3);
        plot3(v1,v2,v3 ,'.','markersize',20,'color',co)
    XY(i,1)=XY(i,1)+v1;
    XY(i,2)=XY(i,2)+v2;
    XY(i,3)=XY(i,3)+v3;
    end
    XY(i,:)=XY(i,:)/length(idc);
    grid on
    xlim([- 6 6]),ylim([- 6 6]),zlim([- 6 6])
    %line([0 0],ylim,'linewidth',1,'color','k')
    %line(xlim,[0 0],'linewidth',1,'color','k')
    title(Mice_Group{i}) 
end

figure, 
subplot(1,3,1), hold on, 
i=1; plot(XY(1,1),XY(1,2),'o','color','k','markerfacecolor',[1 (11-i)/11 i/11]),
i=2;plot(XY(2,1),XY(2,2),'o','color',[1 (11-i)/11 i/11],'markerfacecolor',[1 (11-i)/11 i/11])
i=5;plot(XY(5,1),XY(5,2),'o','color','k','markerfacecolor',[1 (11-i)/11 i/11])
i=6;plot(XY(6,1),XY(6,2),'o','color',[1 (11-i)/11 i/11],'markerfacecolor',[1 (11-i)/11 i/11])
i=9;plot(XY(9,1),XY(9,2),'o','color',[1 (11-i)/11 i/11],'markerfacecolor',[1 (11-i)/11 i/11])
i=11;plot(XY(11,1),XY(11,2),'o','color',[1 (11-i)/11 i/11],'markerfacecolor',[1 (11-i)/11 i/11])
line([0 0],ylim,'linewidth',1,'color','k')
line(xlim,[0 0],'linewidth',1,'color','k')

subplot(1,3,2), hold on, 
i=1; plot(XY(1,1),XY(1,3),'o','color','k','markerfacecolor',[1 (11-i)/11 i/11]),
i=2;plot(XY(2,1),XY(2,3),'o','color',[1 (11-i)/11 i/11],'markerfacecolor',[1 (11-i)/11 i/11])
i=5;plot(XY(5,1),XY(5,3),'o','color','k','markerfacecolor',[1 (11-i)/11 i/11])
i=6;plot(XY(6,1),XY(6,3),'o','color',[1 (11-i)/11 i/11],'markerfacecolor',[1 (11-i)/11 i/11])
i=9;plot(XY(9,1),XY(9,3),'o','color',[1 (11-i)/11 i/11],'markerfacecolor',[1 (11-i)/11 i/11])
i=11;plot(XY(11,1),XY(11,3),'o','color',[1 (11-i)/11 i/11],'markerfacecolor',[1 (11-i)/11 i/11])
line([0 0],ylim,'linewidth',1,'color','k')
    line(xlim,[0 0],'linewidth',1,'color','k')

subplot(1,3,3), hold on, 
i=1; plot(XY(1,2),XY(1,3),'o','color','k','markerfacecolor',[1 (11-i)/11 i/11]),
i=2;plot(XY(2,2),XY(2,3),'o','color',[1 (11-i)/11 i/11],'markerfacecolor',[1 (11-i)/11 i/11])
i=5;plot(XY(5,2),XY(5,3),'o','color','k','markerfacecolor',[1 (11-i)/11 i/11])
i=6;plot(XY(6,2),XY(6,3),'o','color',[1 (11-i)/11 i/11],'markerfacecolor',[1 (11-i)/11 i/11])
i=9;plot(XY(9,2),XY(9,3),'o','color',[1 (11-i)/11 i/11],'markerfacecolor',[1 (11-i)/11 i/11])
i=11;plot(XY(11,2),XY(11,3),'o','color',[1 (11-i)/11 i/11],'markerfacecolor',[1 (11-i)/11 i/11])
line([0 0],ylim,'linewidth',1,'color','k')
    line(xlim,[0 0],'linewidth',1,'color','k')
   
    
    
    
    
k=0;

a=1;b=2;
k=k+1; 
figure, 
subplot(1,2,1), PlotErrorBar2(Sum_UpIni(find(grIni==1),k+1),Sum_UpIni(find(grIni==2),k+1),0); set(gca,'XTick',1:2,'XTickLabel',Mice_Group([a,b])), try, title(Columns_NamesIni{k+1}), end
subplot(1,2,2), PlotErrorBar2(Sum_Up(find(gr==1),k),Sum_Up(find(gr==2),k),0); set(gca,'XTick',1:2,'XTickLabel',Mice_Group([a,b])),try, title(Columns_Names{k}), end
