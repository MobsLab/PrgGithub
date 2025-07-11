%GeneratePosGab

list=dir;

load frame000001
tp=datas.time(4)*3600+datas.time(5)*60+datas.time(6);
tpref=tp;
PosG(:,1)=0;
PosG(:,2)=datas.centroid(1);
PosG(:,3)=datas.centroid(2);
a=2;
for i=4:length(list)
try
    eval(['load(''',list(i).name,''')'])
    %disp(['load(''',list(i).name,''')'])
    tp=datas.time(4)*3600+datas.time(5)*60+datas.time(6);
    %keyboard
    PosG(a,1)=tp-tpref;
    if ischar(datas.centroid(1))==0
    PosG(a,2)=datas.centroid(1);
    else
    PosG(a,2)=nan;    
    end
    
    if ischar(datas.centroid(2))==0
    PosG(a,3)=datas.centroid(2);
    else
    PosG(a,3)=nan;    
    end
    
    a=a+1;
  
end
end



%Completion nan 

listnan=find(isnan(PosG(:,2)));
compt=1;
for k=1:length(listnan)
    
    i=listnan(k);
    if isnan(PosG(i,2))
    if isnan(PosG(i,2))&~isnan(PosG(i+1,2))
        PosG(i,2)=mean([PosG(i-1,2),PosG(i+1,2)]);
        PosG(i,3)=mean([PosG(i-1,3),PosG(i+1,3)]);
        disp('diff 1')
        compt=compt+1;
    elseif isnan(PosG(i,2))&isnan(PosG(i+1,2))&~isnan(PosG(i+2,2))
        PosG(i,2)=PosG(i-1,2)+1/3*(PosG(i+2,2)-PosG(i-1,2));
        PosG(i+1,2)=PosG(i-1,2)+2/3*(PosG(i+2,2)-PosG(i-1,2));
        PosG(i,3)=PosG(i-1,3)+1/3*(PosG(i+2,3)-PosG(i-1,3));
        PosG(i+1,3)=PosG(i-1,3)+2/3*(PosG(i+2,3)-PosG(i-1,3));
        disp('diff 2')
    else
        PosG(i,2)=PosG(i-1,2)+rand(1)-0.5;
        PosG(i,3)=PosG(i-1,3)+rand(1)-0.5;
        disp('big pb')
    end
    end
end


% Compute speed
PosGs=PosG;
PosGs(:,2)=smooth(PosG(:,2),3);
PosGs(:,3)=smooth(PosG(:,3),3);
clear Vitesse
for i=1:length(PosGs)-1
    try
%     try
%     Vx = (PosGs(i-1,2)-PosGs(i+1,2))/(PosGs(i+1,1)-PosGs(i-1,1));
%     Vy = (PosGs(i-1,3)-PosGs(i+1,3))/(PosGs(i+1,1)-PosGs(i-1,1));
%     catch
    Vx = (PosGs(i,2)-PosGs(i+1,2))/(PosGs(i+1,1)-PosGs(i,1));
    Vy = (PosGs(i,3)-PosGs(i+1,3))/(PosGs(i+1,1)-PosGs(i,1));
%     end       

    Vitesse(i) = sqrt(Vx^2+Vy^2);
    
    if isnan(Vitesse(i))
        try
            Vitesse(i)=Vitesse(i+1);
        catch
            Vitesse(i)=Vitesse(i-1);
        end
    end

    if isinf(Vitesse(i))
        try
            Vitesse(i)=Vitesse(i+1);
        catch
            Vitesse(i)=Vitesse(i-1);
        end
    end
    end

end

VitG=smooth(Vitesse',3);

cd ..


save Positions
