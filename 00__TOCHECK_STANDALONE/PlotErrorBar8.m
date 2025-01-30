function PlotErrorBar8(A,B,C,D,E,F,G,H,fig,points)

% if fig=0 sans figure


try
    points;
catch
    points=2;
end

try
fig;
catch
fig=1;
end

[Ra,Sa,Ea]=MeanDifNan(A);
[Rb,Sb,Eb]=MeanDifNan(B);
[Rc,Sc,Ec]=MeanDifNan(C);
[Rd,Sd,Ed]=MeanDifNan(D);
[Re,Se,Ee]=MeanDifNan(E);
[Rf,Sf,Ef]=MeanDifNan(F);
[Rg,Sg,Eg]=MeanDifNan(G);
[Rh,Sh,Eh]=MeanDifNan(H);
% 
% [R,S,E]=MeanDifZero(A);
% [Rb,Sb,Eb]=MeanDifZero(B);
% [Rc,Sc,Ec]=MeanDifZero(C);
% [Rd,Sd,Ed]=MeanDifZero(D);
% 


if fig
figure('color',[1 1 1]), hold on
end


hold on, errorbar([Ra Rb Rc Rd Re Rf Rg Rh],[Ea Eb Ec Ed Ee Ef Eg Eh],'+','Color','k')
bar([Ra Rb Rc Rd Re Rf Rg Rh],'k')
xlim([0.5 8.5])

if points==1
plot(1*ones(length(A),1),A,'ko','markerfacecolor','w')
plot(2*ones(length(B),1),B,'ko','markerfacecolor','w')
plot(3*ones(length(C),1),C,'ko','markerfacecolor','w')
plot(4*ones(length(D),1),D,'ko','markerfacecolor','w')
plot(5*ones(length(E),1),E,'ko','markerfacecolor','w')
plot(6*ones(length(F),1),F,'ko','markerfacecolor','w')
plot(7*ones(length(G),1),G,'ko','markerfacecolor','w')
plot(8*ones(length(H),1),H,'ko','markerfacecolor','w')
elseif points==2
plot(1*ones(length(A),1),A,'ko','markerfacecolor','w')
plot(2*ones(length(B),1),B,'ko','markerfacecolor','w')
plot(3*ones(length(C),1),C,'ko','markerfacecolor','w')
plot(4*ones(length(D),1),D,'ko','markerfacecolor','w')
plot(5*ones(length(E),1),E,'ko','markerfacecolor','w')
plot(6*ones(length(F),1),F,'ko','markerfacecolor','w')
plot(7*ones(length(G),1),G,'ko','markerfacecolor','w')
plot(8*ones(length(H),1),H,'ko','markerfacecolor','w')
try
line([ones(length(A),1) 2*ones(length(B),1)]',[A B]','color',[0.6 0.6 0.6])
line([2*ones(length(B),1) 3*ones(length(C),1)]',[B C]','color',[0.6 0.6 0.6])
line([3*ones(length(C),1) 4*ones(length(D),1)]',[C D]','color',[0.6 0.6 0.6])
catch
try
    line([ones(length(A),1) 3*ones(length(C),1)]',[A C]','color',[0.6 0.6 0.6])
    line([3*ones(length(C),1) 4*ones(length(D),1)]',[C D]','color',[0.6 0.6 0.6])      
end
end
try
line([4*ones(length(D),1) 5*ones(length(E),1)]',[D E]','color',[0.6 0.6 0.6])
end
try
line([5*ones(length(E),1) 6*ones(length(F),1)]',[E F]','color',[0.6 0.6 0.6])
line([6*ones(length(F),1) 7*ones(length(G),1)]',[F G]','color',[0.6 0.6 0.6])
line([7*ones(length(G),1) 8*ones(length(H),1)]',[G H]','color',[0.6 0.6 0.6])
catch
    try
line([5*ones(length(E),1) 7*ones(length(G),1)]',[E G]','color',[0.6 0.6 0.6])
line([7*ones(length(G),1) 8*ones(length(H),1)]',[G H]','color',[0.6 0.6 0.6])    
    end
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


try
    [h,p4]=ttest2(A,E);


if p4<thSig&p4>0.01

    plot(5,Re+Ee+Ee/fac,'k*')
    
elseif p4<0.01

    plot(4.9,Re+Ee+Ee/fac,'k*')
    plot(5.1,Re+Ee+Ee/fac,'k*')
    
end
end



try
    [h,p5]=ttest2(A,F);


if p5<thSig&p5>0.01

    plot(6,Rf+Ef+Ef/fac,'k*')
    
elseif p5<0.01

    plot(5.9,Rf+Ef+Ef/fac,'k*')
    plot(6.1,Rf+Ef+Ef/fac,'k*')
    
end
end



try
    [h,p5]=ttest2(A,G);


if p5<thSig&p5>0.01

    plot(7,Rg+Eg+Eg/fac,'k*')
    
elseif p5<0.01

    plot(6.9,Rg+Eg+Eg/fac,'k*')
    plot(7.1,Rg+Eg+Eg/fac,'k*')
    
end
end


try
    [h,p5]=ttest2(A,H);


if p5<thSig&p5>0.01

    plot(8,Rh+Eh+Eh/fac,'k*')
    
elseif p5<0.01

    plot(7.9,Rh+Eh+Eh/fac,'k*')
    plot(8.1,Rh+Eh+Eh/fac,'k*')
    
end
end

