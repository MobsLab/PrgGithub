function [Cr,lag,p]=xcorr_mobs(A,B,maxlag)
        

le1=size(A,1);
le2=size(B,1);
a=1;
for i=-maxlag:1:maxlag
    if i<=0
         [R,P]=corrcoef(A(1-i:le1-maxlag-i),B(1:le2-maxlag));
         Cr(a)=R(1,2);
         p(a)=P(2,1);
    else
         [R,P]=corrcoef(A(1:end-maxlag),B(i+1:end-maxlag+i));
         Cr(a)=R(1,2);
         p(a)=P(2,1);
%          if R(1,2)>0.9
%              figure, plot(A(1:end-maxlag),B(i+1:end-maxlag+i),'ko'), title(num2str(i))
%          end
         
    end
    lag(a)=i;
    a=a+1;
end

% [val,ind]=max(r);
% Cr=val;
% p=p(ind);
% lag=i;

