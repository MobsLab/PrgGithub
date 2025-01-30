function [gam,thet]=GetTransitionData(aft_cell,smooth_ghi,smooth_Theta,sizedt)
% ouput is matrix of transition data

datG=Data(smooth_ghi);
datT=Data(smooth_Theta);
for i=1:2
    clear gamst a b thetst brows
    %get times
    s1=Stop(aft_cell{i,i+1-2*rem(i+1,2)});
    if length(s1)==0
        gam{i}=[];
        thet{i}=[];
    else
        for k=1:length(s1)-1
            gamst(k)=find(Range(smooth_ghi)>s1(k),1,'first');
            thetst(k)=find(Range(smooth_Theta)>s1(k),1,'first');
        end
        
        % gamma get data
        a=gamst'*ones(1,sizedt*2);
        b=a+([-sizedt+1:sizedt]'*ones(1,length(gamst)))';
        [row,col]=find(b<0|b>size(datG,1));
        row=unique(row);
        if length(row)~=0
            for t=1:length(row)
                brows=[1:size(b,1)]; brows=brows(find(brows~=row(t)));
            end
            b=b(brows,:);
        end
        gam{i}=reshape(datG(b),size(b,1),2*sizedt);
        
        % theta
        a=thetst'*ones(1,sizedt*2);
        b=a+([-sizedt+1:sizedt]'*ones(1,length(thetst)))';
        [row,col]=find(b<0|b>size(datG,1));
        row=unique(row);
        if length(row)~=0
            for t=1:length(row)
                brows=[1:size(b,1)]; brows=brows(find(brows~=row(t)));
            end
            b=b(brows,:);
        end
        
        thet{i}=reshape(datT(b),size(b,1),2*sizedt);
    end
end


end

