function anglecos = ComputeInstantaneuousAngleReferenceMaze( x, y )



%version du calcul avec
%avec acos provenant de GoYMaze_5
anglecos = zeros(length(x),1);

TotalAngle = 0;
Start=1;
m = 0;
% figure('color',[1 1 1])

for k=2:length(anglecos)-1
       
        x1=x(k+1)-x(k);
        y1=y(k+1)-y(k);
    
                
    %if (y(k)-y(k-1)~=0)&&(y(k+1)-y(k)~=0)&&(x(k)-x(k-1)~=0)&&(x(k+1)-x(k)~=0)
%     if ~(sqrt(x1^2+y1^2)*sqrt(x2^2+y2^2))==0
%         
%         anglecos(k)=abs(acos((x1*x2+y1*y2)/(sqrt(x1^2+y1^2)*sqrt(x2^2+y2^2))))*180/pi;
%        
%         
%     elseif (sqrt(x2^2+y2^2)==0)
%        
%         anglecos(k) = abs(atan2(y1,x1))*180/pi;
% 
%         
%     elseif (sqrt(x1^2+y1^2)==0)        
%        
%         anglecos(k) = abs(atan2(y2,x2))*180/pi;
%         
%     else
%         anglecos(k)=0.0001;       
%     end  
      anglecos(k) = mod(atan2(x1,y1)+pi,2*pi)*180/pi;
%       subplot(2,1,1), hold on
%       plot(x(k),y(k),'ko','markerfacecolor','k')
%       plot(x(k+1),y(k+1),'ro','markerfacecolor','r')
%      
%       subplot(2,1,2), hold on
%       scatter(x(k),y(k),30,anglecos(k),'filled'), colormap(hsv)  
%       pause(1)
end
%on enleve le premier point
anglecos(1)=[];
anglecos(end)=[];
anglecos=[anglecos(1); anglecos; anglecos(end)];
anglecos(anglecos==0)=0.0001;