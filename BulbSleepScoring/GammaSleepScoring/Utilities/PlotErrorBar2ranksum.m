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

Ruse=max(R,Rb);
fac=0.5;
thSig=0.05;

[h(1),p,d]=swtest(A,0.05);
[h(2),p,d]=swtest(B,0.05);
[h(3),p,d]=vartest2(A,B);

if sum(h)==0
    [h,p]=ttest(A,B);
    if p<thSig&p>0.01
        plot(1.5,Ruse+Eb+Eb/fac,'k*')
        
    elseif p<0.01
        plot(1.4,Ruse+Eb+Eb/fac,'k*')
        plot(1.6,Ruse+Eb+Eb/fac,'k*')
        
    end
else p=Inf;

end

if p>0.05
    try
        [p1,h]=ranksum(A,B);
        
        if p1<thSig&p1>0.01
            plot(1.5,Ruse+Eb+Eb/fac,'k*')
            
        elseif p1<0.01
            plot(1.4,Ruse+Eb+Eb/fac,'k*')
            plot(1.6,Ruse+Eb+Eb/fac,'k*')
            
        end
    end
    
    try
        [p2,h]=ranksum(A,C);
        
        if p2<thSig&p2>0.01
            plot(3,Rc+Ec+Ec/fac,'k*')
            
        elseif p2<0.01
            plot(1.4,Rc+Ec+Ec/fac,'k*')
            plot(1.6,Rc+Ec+Ec/fac,'k*')
        end
    end
end

end

