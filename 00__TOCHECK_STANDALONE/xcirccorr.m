function [C,lag,pval]=xcirccorr(x,y)

if length(x)~=length(y)
    disp('problem length(x) must be equal to length(y)')
end


for i=1:length(y)-1

    y2=[y(i:length(y));y(1:i-1)];

    if 0
        C(i)=circcorrcoef(x,y2);
        pval(i)=0;
    else
        [C(i) pval(i)] = circ_corrcc(x,y2);
    end
    lag(i)=i;
end
lag=[1:length(C)]/length(C)*360;

C2=[C,C];
lag2=[1:length(C2)]/length(C2)*360*2;
pval2=[pval,pval];

if 0
numfig=gcf;
figure(numfig+1), plot(lag2,C2,'k'),xlim([0 720]),hold on, plot(lag2(pval2<0.05),C2(pval2<0.05),'r.')
figure(numfig)
end


%--------------------------------------------------------------------------
%--------------------------------------------------------------------------
%--------------------------------------------------------------------------
