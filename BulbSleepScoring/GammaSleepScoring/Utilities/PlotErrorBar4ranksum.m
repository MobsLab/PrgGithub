function PlotErrorBar4ranksum(A,B,C,D,fig,points)
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
[Rc,Sc,Ec]=MeanDifNan(C);
[Rd,Sd,Ed]=MeanDifNan(D);

if fig
    figure('Color',[1 1 1])
end
hold on, errorbar([R Rb Rc Rd],[E Eb Ec Ed],'+','Color','k')
bar([R Rb Rc Rd],'k')
xlim([0 5])

if points==1
    plot(1*ones(length(A),1),A,'ko','markerfacecolor','w')
    plot(2*ones(length(B),1),B,'ko','markerfacecolor','w')
    plot(3*ones(length(C),1),C,'ko','markerfacecolor','w')
    plot(4*ones(length(D),1),C,'ko','markerfacecolor','w')
elseif points==2
    plot(1*ones(length(A),1),A,'ko','markerfacecolor','w')
    plot(2*ones(length(B),1),B,'ko','markerfacecolor','w')
    plot(3*ones(length(C),1),C,'ko','markerfacecolor','w')
    plot(4*ones(length(D),1),D,'ko','markerfacecolor','w')
    try
        line([ones(length(A),1) 2*ones(length(B),1)]',[A B]','color',[0.6 0.6 0.6])
        line([3*ones(length(A),1) 4*ones(length(C),1)]',[C D]','color',[0.6 0.6 0.6])

    end
end


fac=0.5;
thSig=0.05;

[h(1),p,d]=swtest(A,0.05);
[h(2),p,d]=swtest(B,0.05);
[h(3),p,d]=vartest2(A,B);
Ruse=max(R,Rb);
Euse=max(E,Eb);

if sum(h)==0
    [h,p]=ttest(A,B);
    if p<thSig&p>0.01
        plot(1.5,Ruse+Euse+Euse/fac,'k*')
        
    elseif p<0.01
        plot(1.4,Ruse+Euse+Euse/fac,'k*')
        plot(1.6,Ruse+Euse+Euse/fac,'k*')
        
    end
else p=Inf;
    
end

if p>0.05
    try
        [p1,h]=ranksum(A,B);
        
        if p1<thSig&p1>0.01
            plot(1.5,Ruse+Euse+Euse/fac,'k*')
            
        elseif p1<0.01
            plot(1.4,Ruse+Euse+Euse/fac,'k*')
            plot(1.6,Ruse+Euse+Euse/fac,'k*')
            
        end
    end
    
   
end


%% Other set
[h(1),p,d]=swtest(C,0.05);
[h(2),p,d]=swtest(D,0.05);
[h(3),p,d]=vartest2(C,D);
Ruse=max(Rd,Rc);
Euse=max(Ed,Ec);
if sum(h)==0
    [h,p]=ttest(C,D);
    if p<thSig&p>0.01
        plot(3.5,Ruse+Euse+Euse/fac,'k*')
        
    elseif p<0.01
        plot(3.4,Ruse+Euse+Euse/fac,'k*')
        plot(3.6,Ruse+Euse+Euse/fac,'k*')
        
    end
else p=Inf;
    
end

if p>0.05
    try
        [p1,h]=ranksum(C,D);
        
        if p1<thSig&p1>0.01
            plot(3.5,Ruse+Euse+Euse/fac,'k*')
            
        elseif p1<0.01
            plot(3.4,Ruse+Euse+Euse/fac,'k*')
            plot(3.6,Ruse+Euse+Euse/fac,'k*')
            
        end
    end
    
end

end

