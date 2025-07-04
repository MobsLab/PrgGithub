%FigureArticleBilanBehavior


sav=0;



%%
%--------------------------------------------------------------------------
%Analy=3-----OK------------------------------------------------------------
%--------------------------------------------------------------------------

clear
close all

Analy=3;allBefore=1; tr=4;LimiTrials=1;Protocol=4; renorm=1; renormAll=0; Bis=0;  BilanManipeTotalMac

if sav
    
    for i=1:20
        try
            eval(['saveFigure(',num2str(i),',''CumDisZoneWake', num2str(i),''',''/Users/karimbenchenane/Documents/Data/DataEnCours/ManipesICSSok/Data'')'])
        end
    end

end

close all
clear

Analy=3;allBefore=1; tr=4;LimiTrials=1;Protocol=1; renorm=1; renormAll=0; Bis=0;  BilanManipeTotalMac

if sav 
    for i=1:20
        try
            eval(['saveFigure(',num2str(i),',''CumDisZoneSleep', num2str(i),''',''/Users/karimbenchenane/Documents/Data/DataEnCours/ManipesICSSok/Data'')'])
        end
    end
end

close all
clear

%%
%--------------------------------------------------------------------------
%Analy=1-----OK------------------------------------------------------------
%--------------------------------------------------------------------------



%close all,clear, Analy=1;allBefore=1; tr=4;LimiTrials=1;Protocol=4; renorm=0; renormAll=0; Bis=1;  BilanManipeTotalMac
close all,clear, Analy=1;allBefore=1; tr=4;LimiTrials=1;Protocol=4; renorm=1; renormAll=0; Bis=0;  BilanManipeTotalMac

if sav
    for i=1:20
        try
            eval(['saveFigure(',num2str(i),',''TimeSpentZoneWake', num2str(i),''',''/Users/karimbenchenane/Documents/Data/DataEnCours/ManipesICSSok/Data'')'])
        end
    end
end

close all
clear



% close all,clear, Analy=1;allBefore=1; tr=4;LimiTrials=1;Protocol=1;
% renorm=0; renormAll=0; Bis=1;  BilanManipeTotalMac
close all,clear, Analy=1;allBefore=1; tr=4;LimiTrials=1;Protocol=1; renorm=1; renormAll=0; Bis=0;  BilanManipeTotalMac

if sav
    for i=1:20
        try
            eval(['saveFigure(',num2str(i),',''TimeSpentZoneSleep', num2str(i),''',''/Users/karimbenchenane/Documents/Data/DataEnCours/ManipesICSSok/Data'')'])
        end
end
end

close all
clear


%%
%--------------------------------------------------------------------------
%Analy=2-----OK------------------------------------------------------------
%--------------------------------------------------------------------------


close all,clear, Analy=2;allBefore=1; tr=4;LimiTrials=1;Protocol=4; renorm=0; renormAll=0; Bis=0;  BilanManipeTotalMac

ICSSEffWake=ICSSEff;

title('Wake')

if sav    
    for i=1:20
        try
            eval(['saveFigure(',num2str(i),',''TimeToGoZoneWake', num2str(i),''',''/Users/karimbenchenane/Documents/Data/DataEnCours/ManipesICSSok/Data'')'])
        end
    end
end

% close all
% clear


 close all, 
Analy=2;allBefore=1; tr=4;LimiTrials=1;Protocol=1; renorm=0; renormAll=0; Bis=0;  BilanManipeTotalMac


title('Sleep')


if sav
    for i=1:20
        try
            eval(['saveFigure(',num2str(i),',''TimeToGoZoneSleep', num2str(i),''',''/Users/karimbenchenane/Documents/Data/DataEnCours/ManipesICSSok/Data'')'])
        end
    end
end

close all 

A=Ccorr(2,:)';
B=Ccorr(1,:)';
C=[ICSSEff,ICSSEffWake]';
PlotErrorBar3(B,A,C)
ylabel('Correlation between Occupation and place field')
set(gca,'xtick',[1 2 3])
set(gca,'xticklabel',{'before','after','Wake ICSS'})
 

thSig=0.05;

try
[h,p1]=ttest2(A,B);  
E=mean(A)+stdError(A);
if p1<thSig&p1>0.01
    plot(2,3/2*E,'k*')
elseif p1<0.01
    plot(1.9,3/2*E,'k*')
    plot(2.1,3/2*E,'k*')
end
end

try
    [h,p2]=ttest2(B,C);
    E=mean(C)+stdError(C);
if p2<0thSig&p2>0.01
    plot(3,3/2*E,'k*')
elseif p2<0.01
    plot(2.9,3/2*E,'k*')
    plot(3.1,3/2*E,'k*')
end
end
        
  
try
    [h,p3]=ttest2(A,C);
    E=mean(C)+stdError(C);
if p3<0thSig&p2>0.01
    plot(3,3/2.5*E,'b*')
elseif p3<0.01
    plot(2.9,3/2.5*E,'b*')
    plot(3.1,3/2.5*E,'b*')
end
end
     
title('Sleep vs Mean ICSS total')

if sav
    saveFigure(1, 'CorrelationFinal','/Users/karimbenchenane/Documents/Data/DataEnCours/ManipesICSSok/Data')
end

% close all
% clear

