function PlotErrorBar2ranksum(A,B,fig,points)

% if info=0 sans les zeros

try
fig;
catch
fig=1;
end

try
    points;
catch
    points=2;
end

[R,S,E]=MeanDifNan(A);
[Rb,Sb,Eb]=MeanDifNan(B);

if fig
figure('Color',[1 1 1])
end
hold on, errorbar([R Rb],[E Eb],'+','Color','k')
bar([R Rb],'k')
xlim([0 3])

if points==1
plot(1*ones(length(A),1),A,'ko','markerfacecolor','w')
plot(2*ones(length(B),1),B,'ko','markerfacecolor','w')
elseif points==2
plot(1*ones(length(A),1),A,'ko','markerfacecolor','w')
plot(2*ones(length(B),1),B,'ko','markerfacecolor','w')
try
line([ones(length(A),1) 2*ones(length(B),1)]',[A B]','color',[0.6 0.6 0.6])
end
end


fac=1;
thSig=0.05;

try
[h,p1]=ranksum(A,B);

if p1<thSig&p1>0.01
    plot(2,Rb+Eb+Eb/fac,'k*')
    
elseif p1<0.01
    plot(1.9,Rb+Eb+Eb/fac,'k*')
    plot(2.1,Rb+Eb+Eb/fac,'k*')
    
end
end

try
    [h,p2]=ranksum(A,C);

if p2<thSig&p2>0.01
    plot(3,Rc+Ec+Ec/fac,'k*')
    
elseif p2<0.01
    plot(2.9,Rc+Ec+Ec/fac,'k*')
    plot(3.1,Rc+Ec+Ec/fac,'k*')   
end
end

end

