function PlotErrorBar4(A,B,C,D,info,points)

% if info=0 sans les zeros

try
info;
catch
info=1;
end

try
    points;
catch
    points=2;
end

% if info==0
% 
% [R,S,E]=MeanDifZero(A);
% [Rb,Sb,Eb]=MeanDifZero(B);
% [Rc,Sc,Ec]=MeanDifZero(C);
% [Rd,Sd,Ed]=MeanDifZero(D);
% 
% else

[R,S,E]=MeanDifNan(A);
[Rb,Sb,Eb]=MeanDifNan(B);
[Rc,Sc,Ec]=MeanDifNan(C);
[Rd,Sd,Ed]=MeanDifNan(D);
% end


if info
figure('color',[1 1 1]), 
end
errorbar([R Rb Rc Rd],[E Eb Ec Ed],'+','Color','k')
hold on, bar([R Rb Rc Rd],'k')
xlim([0.5 4.5])

if points==1
plot(1*ones(length(A),1),A,'ko','markerfacecolor','w')
plot(2*ones(length(B),1),B,'ko','markerfacecolor','w')
plot(3*ones(length(C),1),C,'ko','markerfacecolor','w')
plot(4*ones(length(D),1),D,'ko','markerfacecolor','w')
elseif points==2
plot(1*ones(length(A),1),A,'ko','markerfacecolor','w')
plot(2*ones(length(B),1),B,'ko','markerfacecolor','w')
plot(3*ones(length(C),1),C,'ko','markerfacecolor','w')
plot(4*ones(length(D),1),D,'ko','markerfacecolor','w')
    try
        line([ones(length(A),1) 2*ones(length(B),1)]',[A B]','color',[0.6 0.6 0.6])
    end
    try
        line([2*ones(length(B),1) 3*ones(length(C),1)]',[B C]','color',[0.6 0.6 0.6])
    end
    try
        line([3*ones(length(C),1) 4*ones(length(D),1)]',[C D]','color',[0.6 0.6 0.6])
    end
end


fac=1;
thSig=0.05;

try
[h,p1]=ttest2(A,B);

if p1<thSig&p1>0.01

    plot(2,Rb+Eb+Eb/fac,'k*')
    
elseif p1<0.01

    plot(1.9,Rb+Eb+Eb/fac,'k*')
    plot(2.1,Rb+Eb+Eb/fac,'k*')
    
end
end

try
    [h,p2]=ttest2(A,C);

if p2<thSig&p2>0.01

    plot(3,Rc+Ec+Ec/fac,'k*')
    
elseif p2<0.01

    plot(2.9,Rc+Ec+Ec/fac,'k*')
    plot(3.1,Rc+Ec+Ec/fac,'k*')
    
end

end

try
    [h,p3]=ttest2(A,D);


if p3<thSig&p3>0.01

    plot(4,Rd+Ed+Ed/fac,'k*')
    
elseif p3<0.01

    plot(3.9,Rd+Ed+Ed/fac,'k*')
    plot(4.1,Rd+Ed+Ed/fac,'k*')
    
end
end

