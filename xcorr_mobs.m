function [Cr,lag,p]=xcorr_mobs(A,B,maxlag,pas)
        
%[Cr,lag,p]=xcorr_mobs(A,B,maxlag,pas)
% B reference
% A in function of B


try
    pas;
catch
    pas=1;
end

le1=size(A,1);
le2=size(B,1);
a=1;
for i=-maxlag:pas:maxlag
    if i<=0
         [R,P]=corrcoef(A(1-i:le1-maxlag-i),B(1:le2-maxlag));
         Cr(a)=R(1,2);
         p(a)=P(2,1);
    else
         [R,P]=corrcoef(A(1:le1-maxlag),B(i+1:le2-maxlag+i));
         Cr(a)=R(1,2);
         p(a)=P(2,1);         
    end
    lag(a)=i;
    a=a+1;
end

% [val,ind]=max(r);
% Cr=val;
% p=p(ind);
% lag=i;

