function [mn,sd]=mean2D(val1,val2,val3,noval1,noval2,lim1,lim2)
% val1, val2 :x,y values
% val3 : values to be averaged over x and y
%noval : number of bins for val1 and val 2 respectively
% lim : [max min] of val1 anv val2 repsectively, facultative

try 
    lim1;
    lim2;
    step1=(lim1(1)-lim1(2))/noval1;
    step2=(lim2(1)-lim2(2))/noval2;
    st1=lim1(2);
    st2=lim2(2);

   catch
step1=(max(val1)-min(val1))/noval1;
step2=(max(val2)-min(val2))/noval2;
st1=0;
st2=0;
end
mn=[];
sd=[];
for j=0:noval1-1
    for k=0:noval2-1
        ind=find(val1>(j*step1+st1) & val1<((j+1)*step1+st1) & val2>(k*step2+st2) & val2<((k+1)*step2+st2));
        try
        mn(j+1,k+1)=nanmean(val3(ind));
        sd(j+1,k+1)=nanstd(val3(ind));
        catch
       mn(j+1,k+1)=NaN;
       sd(j+1,k+1)=NaN;
        end
        
        end
    end
end
        
