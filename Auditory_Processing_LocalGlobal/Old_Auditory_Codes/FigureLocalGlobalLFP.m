% Figure Plot LocalGlobal
% Pour plotter deux protocoles (avec deux matVal distincts): protocole =3
%
%% if plo= 1 =>  LFP:matVal{i,j}
% if plo= 2 =>  Spk:matValSpk{i,j}
% i=> numero de la voie LFP/numero du neurone
% j=> associe a chaque variante de son dans le protocole Local/Global/Omission
% 1: Local Standard - Global Standard A
% 2: Local Standard - Global Standard B
% 3: Local Deviant - Global Standard A
% 4: Local Deviant - Global Standard B
% 5: Local Deviant - Global Deviant A
% 6: Local Deviant - Global Deviant B
% 7: Local Standard - Global Deviant A
% 8: Local Standard - Global Deviant B
% 9: Omission AAAA (bloc Omission only)
% 10: Omission rare A (during classical bloc - occurence 10%)
% 11: Omission BBBB (bloc Omission only)
% 12: Omission rare A (during classical bloc - occurence 10%)


function [M1,M2,matVal]=FigureLocalGlobal(protocole,LFP1,LFP2)

pval=0.05;

load LFPData
try
    load SpikeData
end

if protocole==1;
    try
        load matVal1
    end

end
%
%
if protocole==2;
    try
        load matVal2
    end

end
%
%
if protocole==3;
    try 
        load matVal1
    end
        M1=matVal;
    try
        load matVal2
    end
    M2=matVal;
    rg=Range(matVal{1,1});
    rg=rg(1:1499);
    [matVal,LFP]=PoolDataLocalGlobal(M1,M2,rg);
end


    
%% ------------------------------   Local   -----------------------------------------
for i=LFP1:LFP2;
    %----------------------------------------------------------------------
    % Effet Local Deviant A
    %----------------------------------------------------------------------
    figure, plot(Range(matVal{i,1},'ms'),mean(Data(matVal{i,1})'),'k','linewidth',1)
    hold on, plot(Range(matVal{i,3},'ms'),mean(Data(matVal{i,3})'),'r','linewidth',1)
    %hold on, plot(Range(matVal{i,2},'ms'),mean(Data(matVal{i,2})'),'g','linewidth',1)
    hold on, title(['effet LOCAL: FreqAAAAA(bl) vs FreqBBBBA(red) - channeln� ',num2str(i)]) 
    hold on, axis([-100 1100 -1000 800])
    for a=0:150:600
        hold on, plot(a,min(axis):max(axis),'b','linewidth',1);
    end
    [h,p]=ttest2(Data(matVal{i,1})',Data(Restrict(matVal{i,3},matVal{i,1}))');
    rg=Range(matVal{i,1},'ms');
    pr=rescale(p,500, 600);
    hold on, plot(rg(p<pval),pr(p<pval),'bx')  
%     
%     [h,p]=ttest2(Data(matVal{i,2})',Data(Restrict(matVal{i,3},matVal{i,2}))');
%     rg=Range(matVal{i,1},'ms');
%     pr=rescale(p,400, 500);
%     hold on, plot(rg(p<pval),pr(p<pval),'gx')  
   
    %----------------------------------------------------------------------
    % Effet Local Deviant B
    %----------------------------------------------------------------------    
    figure, plot(Range(matVal{i,2},'ms'),mean(Data(matVal{i,2})'),'k','linewidth',1)
    hold on, plot(Range(matVal{i,4},'ms'),mean(Data(matVal{i,4})'),'r','linewidth',1)
    %hold on, plot(Range(matVal{i,1},'ms'),mean(Data(matVal{i,1})'),'g','linewidth',1)
        for a=0:150:600
        hold on, plot(a,min(axis):max(axis),'b','linewidth',1);
        end
    hold on, title(['effet LOCAL: FreqBBBBB(bl) vs FreqAAAAB(red)  - channeln�',num2str(i)])
    
    [h,p]=ttest2(Data(matVal{i,2})',Data(Restrict(matVal{i,4},matVal{i,2}))');
    rg=Range(matVal{i,1},'ms');
    pr=rescale(p,500, 600);
    hold on, plot(rg(p<pval),pr(p<pval),'bx')  
%     
%     [h,p]=ttest2(Data(matVal{i,1})',Data(Restrict(matVal{i,4},matVal{i,1}))');
%     rg=Range(matVal{i,1},'ms');
%     pr=rescale(p,400, 500);
%     hold on, plot(rg(p<pval),pr(p<pval),'gx')  


%% -------------------------   Global (local standard)  -----------------------------------------


    %----------------------------------------------------------------------
    % Effet Global Deviant A (local standard)
    %----------------------------------------------------------------------    
    figure, plot(Range(matVal{i,1},'ms'),mean(Data(matVal{i,1})'),'k','linewidth',1)
    hold on, plot(Range(matVal{i,7},'ms'),mean(Data(matVal{i,7})'),'r','linewidth',1)
        for a=0:150:600
        hold on, plot(a,min(axis):max(axis),'b','linewidth',1);
        end
    hold on, title(['effet GLOBAL (local std): FreqAAAAA(bl) vs RareAAAAA(red) - channeln°',num2str(i)])
    hold on, axis([-100 1100 -1500 1000])
    
    [h,p]=ttest2(Data(matVal{i,1})',Data(Restrict(matVal{i,7},matVal{i,1}))');
    rg=Range(matVal{i,1},'ms');
    pr=rescale(p,500, 600);
    hold on, plot(rg(p<pval),pr(p<pval),'bx')  

  
    %----------------------------------------------------------------------
    % Effet Global Deviant B (local standard)
    %---------------------------------------------------------------------- 
    figure, plot(Range(matVal{i,2},'ms'),mean(Data(matVal{i,2})'),'k','linewidth',1)
    hold on, plot(Range(matVal{i,8},'ms'),mean(Data(matVal{i,8})'),'r','linewidth',1)    
        for a=0:150:600
        hold on, plot(a,min(axis):max(axis),'b','linewidth',1);
        end
    hold on, title(['effet GLOBAL(local std): FreqBBBBB(bl) vs RareBBBBB(red) - channel n�',num2str(i)])
    hold on, axis([-100 1100 -1500 1000]) 
    
    [h,p]=ttest2(Data(matVal{i,2})',Data(Restrict(matVal{i,8},matVal{i,2}))');
    rg=Range(matVal{i,1},'ms');
    pr=rescale(p,500, 600);
    hold on, plot(rg(p<pval),pr(p<pval),'bx')  


%% -------------------------   Global (local deviant)  -----------------------------------------


    %----------------------------------------------------------------------
    % Effet Global Deviant A (local deviant)
    %----------------------------------------------------------------------    
    figure, plot(Range(matVal{i,3},'ms'),mean(Data(matVal{i,3})'),'k','linewidth',1)
    hold on, plot(Range(matVal{i,5},'ms'),mean(Data(matVal{i,5})'),'r','linewidth',1)
    %hold on, plot(Range(matVal{i,1},'ms'),mean(Data(matVal{i,1})'),'g','linewidth',1)
        for a=0:150:600
        hold on, plot(a,min(axis):max(axis),'b','linewidth',1);
        end
    hold on, title(['effet GLOBAL (local dvt): FreqBBBBA(bl) vs RareBBBBA(red) - channel n�',num2str(i)])
    hold on, axis([-100 1100 -1500 1000])
    
    [h,p]=ttest2(Data(matVal{i,3})',Data(Restrict(matVal{i,5},matVal{i,3}))');
    rg=Range(matVal{i,1},'ms');
    pr=rescale(p,500, 600);
    hold on, plot(rg(p<pval),pr(p<pval),'bx')  
%     
%     [h,p]=ttest2(Data(matVal{i,1})',Data(Restrict(matVal{i,5},matVal{i,1}))');
%     rg=Range(matVal{i,1},'ms');
%     pr=rescale(p,400, 500);
%     hold on, plot(rg(p<pval),pr(p<pval),'gx')  
    
    %----------------------------------------------------------------------
    % Effet Global Deviant B (local deviant)
    %---------------------------------------------------------------------- 
    figure, plot(Range(matVal{i,4},'ms'),mean(Data(matVal{i,4})'),'k','linewidth',1)
    hold on, plot(Range(matVal{i,6},'ms'),mean(Data(matVal{i,6})'),'r','linewidth',1)
    %hold on, plot(Range(matVal{i,1},'ms'),mean(Data(matVal{i,1})'),'g','linewidth',1)    
        for a=0:150:600
        hold on, plot(a,min(axis):max(axis),'b','linewidth',1);
        end
    hold on, title(['effet GLOBAL(local dvt): FreqAAAAB(black) vs RareAAAAB(red)- channel n�',num2str(i)])
    hold on, axis([-100 1100 -1500 1000]) 
    
    [h,p]=ttest2(Data(matVal{i,4})',Data(Restrict(matVal{i,6},matVal{i,4}))');
    rg=Range(matVal{i,1},'ms');
    pr=rescale(p,500, 600);
    hold on, plot(rg(p<pval),pr(p<pval),'bx')  
%     
%     [h,p]=ttest2(Data(matVal{i,1})',Data(Restrict(matVal{i,6},matVal{i,1}))');
%     rg=Range(matVal{i,1},'ms');
%     pr=rescale(p,400, 500);
%     hold on, plot(rg(p<pval),pr(p<pval),'gx')  


%% -----------------------------   Omission   -----------------------------------------


%     %----------------------------------------------------------------------
%     % Effet Omission son A
%     %---------------------------------------------------------------------- 
%     figure, plot(Range(matVal{i,9},'ms'),mean(Data(matVal{i,9})'),'k','linewidth',1)
%     hold on, plot(Range(matVal{i,10},'ms'),mean(Data(matVal{i,10})'),'r','linewidth',1)
%         for a=0:150:600
%         hold on, plot(a,min(axis):max(axis),'b','linewidth',1);
%         end
%     hold on, title(['effet Omission: omission A attendue(black) VS omission A rare (red) ',num2str(i)])
%     hold on, axis([-100 1100 -1500 1000])
%     
%     [h,p]=ttest2(Data(matVal{i,7})',Data(Restrict(matVal{i,8},matVal{i,7}))');
%     rg=Range(matVal{i,1},'ms');
%     pr=rescale(p,500, 600);
%     hold on, plot(rg(p<pval),pr(p<pval),'bx')  
% 
%     %----------------------------------------------------------------------
%     % Effet Omission son B
%     %---------------------------------------------------------------------- 
%     figure, plot(Range(matVal{i,11},'ms'),mean(Data(matVal{i,11})'),'k','linewidth',1)
%     hold on, plot(Range(matVal{i,12},'ms'),mean(Data(matVal{i,12})'),'r','linewidth',1)
%         for a=0:150:600
%         hold on, plot(a,min(axis):max(axis),'b','linewidth',1);
%         end
%     hold on, title(['effet Omission: omission B attendue (black) VS omission B rare (red)',num2str(i)])
%     hold on, axis([-100 1100 -1500 1000])
%     
%     [h,p]=ttest2(Data(matVal{i,9})',Data(Restrict(matVal{i,10},matVal{i,9}))');
%     rg=Range(matVal{i,1},'ms');
%     pr=rescale(p,500, 600);
%     hold on, plot(rg(p<pval),pr(p<pval),'bx')  
end
end
