function anglecos = ComputeInstantaneuousAngle(x,y,pas)



%version du calcul avec
%avec acos provenant de GoYMaze_5
anglecos = zeros(length(x),1);
TotalAngle = 0;
Start=1;
m = 0;

try
    pas;
catch
pas=1;
end


for k=pas+1:length(anglecos)-pas
       
        x1=x(k+pas)-x(k);
        y1=y(k+pas)-y(k);
    
        x2=x(k)-x(k-pas);
        y2=y(k)-y(k-pas);
                
    %if (y(k)-y(k-1)~=0)&&(y(k+1)-y(k)~=0)&&(x(k)-x(k-1)~=0)&&(x(k+1)-x(k)~=0)
    if ~(sqrt(x1^2+y1^2)*sqrt(x2^2+y2^2))==0
        
        anglecos(k)=abs(acos((x1*x2+y1*y2)/(sqrt(x1^2+y1^2)*sqrt(x2^2+y2^2))))*180/pi;
       
        
    elseif (sqrt(x2^2+y2^2)==0)
       
        anglecos(k) = abs(atan2(y1,x1))*180/pi;

        
    elseif (sqrt(x1^2+y1^2)==0)        
       
        anglecos(k) = abs(atan2(y2,x2))*180/pi;
        
    else
        anglecos(k)=0.0001;       
    end  
    
end
%on enleve le premier point
anglecos(1)=[];
anglecos(end)=[];
anglecos=[anglecos(1); anglecos; anglecos(end)];
anglecos(anglecos==0)=0.0001;

