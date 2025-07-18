function [dis,dis1,dis2,U] = GetPointUmazeDistance_KB(x,y,th,U)

% USE: 
% [dis,dis1,dis2,U] = GetPointUmazeDistance(x,y,0.07);
% U(3,1)=0.65;U(8,1)=0.65;
% [dis,dis1,dis2,U] = GetPointUmazeDistance(x,y,0.07,U);
%

try 
    th;
catch
    th=0.10;
end

try
    U;
    x1=U(1,1);x2=U(2,1);x3=U(3,1);x4=U(4,1);x5=U(5,1);x6=U(6,1);x7=U(7,1);x8=U(8,1);
    y1=U(1,2);y2=U(2,2);y3=U(3,2);y4=U(4,2);y5=U(5,2);y6=U(6,2);y7=U(7,2);y8=U(8,2);   
catch
    clear U
    x1=0;y1=0;
    x2=0.35;y2=0;
    x3=0.65;y3=0; %x3=0.7;
    x4=0.95;y4=0;
    x5=0;y5=0.95;
    x6=0.95;y6=0.95;
    x7=0.35; y7=0.8;
    x8=0.65; y8=0.8; %x8=0.7;
    U(:,1)=[x1,x2,x3,x4,x5,x6,x7,x8];
    U(:,2)=[y1,y2,y3,y4,y5,y6,y7,y8];
end

distance1 = pointToSegmentDistance(x,y,x1,y1,x5,y5)';
distance2 = pointToSegmentDistance(x,y,x1,y1,x2,y2)';
distance3 = pointToSegmentDistance(x,y,x2,y2,x7,y7)';
distance4 = pointToSegmentDistance(x,y,x5,y5,x6,y6)';
distance5 = pointToSegmentDistance(x,y,x7,y7,x8,y8)';
distance6 = pointToSegmentDistance(x,y,x8,y8,x3,y3)';
distance7 = pointToSegmentDistance(x,y,x3,y3,x4,y4)';
distance8 = pointToSegmentDistance(x,y,x6,y6,x4,y4)';

dis2=min([distance1,distance2,distance3,distance4,distance5,distance6,distance7,distance8]');
dis1=min([distance1,distance2,distance3,distance4,distance5,distance6,distance7,distance8]');

dis=dis1;dis(dis<th)=0;
id=find(x>0.35&x<0.7);
dis(id)=nan;
dis1(id)=nan;

id2=find(y>0.85);
id3=find(y>0.7);

dis(id2)=nan;
dis1(id2)=nan;
%dis2(id3)=nan;


figure, 
subplot(2,3,1),
plot(x,y,'.-','color',[0.8 0.8 0.9]), title('dis1')
hold on,scatter(x,y,30,dis1,'filled'), colorbar
line([x1,x5],[y1,y5],'color','k','linewidth',5)
line([x1,x2],[y1,y2],'color','k','linewidth',5)
line([x2,x7],[y2,y7],'color','k','linewidth',5)
line([x5,x6],[y5,y6],'color','k','linewidth',5)
line([x7,x8],[y7,y8],'color','k','linewidth',5)
line([x8,x3],[y8,y3],'color','k','linewidth',5)
line([x3,x4],[y3,y4],'color','k','linewidth',5)
line([x6,x4],[y6,y4],'color','k','linewidth',5)

subplot(2,3,2),
plot(x,y,'.-','color',[0.8 0.8 0.9]), title('dis2')
hold on,scatter(x,y,30,dis2,'filled'), colorbar
line([x1,x5],[y1,y5],'color','k','linewidth',5)
line([x1,x2],[y1,y2],'color','k','linewidth',5)
line([x2,x7],[y2,y7],'color','k','linewidth',5)
line([x5,x6],[y5,y6],'color','k','linewidth',5)
line([x7,x8],[y7,y8],'color','k','linewidth',5)
line([x8,x3],[y8,y3],'color','k','linewidth',5)
line([x3,x4],[y3,y4],'color','k','linewidth',5)
line([x6,x4],[y6,y4],'color','k','linewidth',5)


subplot(2,3,3),
plot(x,y,'.-','color',[0.8 0.8 0.9]), title('dis')
hold on,scatter(x,y,30,dis,'filled'), colorbar
line([x1,x5],[y1,y5],'color','k','linewidth',5)
line([x1,x2],[y1,y2],'color','k','linewidth',5)
line([x2,x7],[y2,y7],'color','k','linewidth',5)
line([x5,x6],[y5,y6],'color','k','linewidth',5)
line([x7,x8],[y7,y8],'color','k','linewidth',5)
line([x8,x3],[y8,y3],'color','k','linewidth',5)
line([x3,x4],[y3,y4],'color','k','linewidth',5)
line([x6,x4],[y6,y4],'color','k','linewidth',5)

subplot(2,3,4),hist(dis1,50), line([th th],ylim,'color','r')
subplot(2,3,5),hist(dis2,50), line([th th],ylim,'color','r')
subplot(2,3,6),hist(dis(dis>0),50), line([th th],ylim,'color','r'), disT=dis;disT(isnan(disT))=[];title([num2str(length(disT(disT>0))/length(disT)*100),' %'])

