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

function [sq,sweeps]=FigureLocalGlobalSpike(Protocole,Spike1,Spike2)
%% ----------------------- Spikes ------------------------------------------
pval=0.05;
disp('    ----->  PETH generation for Spike');
load SpikeData;
if Protocole==1;
    try
        load SQ1 
        load SWEEPS1
        load LocalGlobalAssignment
    end
else
    try
        load SQ2 
        load SWEEPS2
        load LocalGlobalAssignment2
    end
end

%% ------------------------------   Local   -----------------------------------------
for i=[8 10 14 15 18];
    %----------------------------------------------------------------------
    % Effet Local Deviant A
    %----------------------------------------------------------------------
    figure, plot((Range(sq{i,1}, 'ms')), Data(sq{i,1})/length(sweeps),'k','linewidth',2)
    hold on, plot(Range(sq{i,3},'ms'),Data(sq{i,3})/length(sweeps),'r','linewidth',2)
    %hold on, plot(Range(sq{i,2},'ms'),Data(sq{i,2})/length(sweeps),'g','linewidth',2)
    hold on, title(['effet LOCAL: FreqAAAAA(bl) vs FreqBBBBA(red) +  freqBBBBB (gr) - Spike ',num2str(i)]) 
    for a=0:150:600
        hold on, plot(a,min(axis):max(axis),'b','linewidth',1);
    end
    hold on, axis([-50 950 0 2000])
    [h,p]=ttest2(Data(sq{i,1})',Data(Restrict(sq{i,3},sq{i,1}))');
    rg=Range(sq{i,1},'ms');
    pr=rescale(p,500, 600);
    hold on, plot(rg(p<pval),pr(p<pval),'bx') 

    %----------------------------------------------------------------------
    % Effet Local Deviant B
    %----------------------------------------------------------------------    
    figure, plot((Range(sq{i,2}, 'ms')), Data(sq{i,2})/length(sweeps),'k','linewidth',2)
    hold on, plot(Range(sq{i,4},'ms'),Data(sq{i,4})/length(sweeps),'r','linewidth',2)
    %hold on, plot(Range(sq{i,1},'ms'),Data(sq{i,1})/length(sweeps),'g','linewidth',2)
        for a=0:150:600
        hold on, plot(a,min(axis):max(axis),'b','linewidth',1);
        end
    hold on, title(['effet LOCAL: FreqBBBBB(bl) vs FreqAAAAB(red)  +  freqAAAAA(gr) - channeln�',num2str(i)])
    hold on, axis([-50 950 0 2000])



%% -------------------------   Global (local standard)  -----------------------------------------


    %----------------------------------------------------------------------
    % Effet Global Deviant A (local standard)
    %----------------------------------------------------------------------    
    figure, plot((Range(sq{i,1}, 'ms')), Data(sq{i,1})/length(sweeps),'k','linewidth',2)
    hold on, plot(Range(sq{i,7},'ms'),Data(sq{i,7})/length(sweeps),'r','linewidth',2)
        for a=0:150:600
        hold on, plot(a,min(axis):max(axis),'b','linewidth',1);
        end
    hold on, title(['effet GLOBAL (local std): FreqAAAAA(bl) vs RareAAAAA(red) - channeln°',num2str(i)])
    hold on, axis([-50 950 0 2000])
    

  
    %----------------------------------------------------------------------
    % Effet Global Deviant B (local standard)
    %---------------------------------------------------------------------- 
    figure, plot((Range(sq{i,2}, 'ms')), Data(sq{i,1})/length(sweeps),'k','linewidth',2)
    hold on, plot(Range(sq{i,8},'ms'),Data(sq{i,8})/length(sweeps),'r','linewidth',2)
        for a=0:150:600
        hold on, plot(a,min(axis):max(axis),'b','linewidth',1);
        end
    hold on, title(['effet GLOBAL(local std): FreqBBBBB(bl) vs RareBBBBB(red) - channel n�',num2str(i)])
    hold on, axis([-50 950 0 2000])
    



%% -------------------------   Global (local deviant)  -----------------------------------------


    %----------------------------------------------------------------------
    % Effet Global Deviant A (local deviant)
    %----------------------------------------------------------------------    
    figure, plot((Range(sq{i,3}, 'ms')), Data(sq{i,3})/length(sweeps),'k','linewidth',2)
    hold on, plot(Range(sq{i,5},'ms'),Data(sq{i,5})/length(sweeps),'r','linewidth',2)
    %hold on, plot(Range(sq{i,1},'ms'),Data(sq{i,1})/length(sweeps),'g','linewidth',2)
        for a=0:150:600
            hold on, plot(a,min(axis):max(axis),'b','linewidth',1);
        end
    hold on, title(['effet GLOBAL (local dvt): FreqBBBBA(bl) vs RareBBBBA(red) + freqBBBBB(gr) - channel n�',num2str(i)])
    hold on, axis([-50 950 0 2000]) 

    
    %----------------------------------------------------------------------
    % Effet Global Deviant B (local deviant)
    %---------------------------------------------------------------------- 
    figure, plot((Range(sq{i,4}, 'ms')), Data(sq{i,4})/length(sweeps),'k','linewidth',2)
    hold on, plot(Range(sq{i,6},'ms'),Data(sq{i,6})/length(sweeps),'r','linewidth',2)
    %hold on, plot(Range(sq{i,1},'ms'),Data(sq{i,1})/length(sweeps),'g','linewidth',2)
        for a=0:150:600
            hold on, plot(a,min(axis):max(axis),'b','linewidth',1);
        end
    hold on, title(['effet GLOBAL(local dvt): FreqAAAAB(black) vs RareAAAAB(red)   +  freqAAAAA(gr) - channel n�',num2str(i)])
    hold on, axis([-50 950 0 2000])



%% -----------------------------   Omission   -----------------------------------------


    %----------------------------------------------------------------------
    % Effet Omission son A
    %---------------------------------------------------------------------- 
    figure, plot((Range(sq{i,9}, 'ms')), Data(sq{i,9})/length(sweeps),'k','linewidth',2)
    hold on, plot(Range(sq{i,10},'ms'),Data(sq{i,10})/length(sweeps),'r','linewidth',2)
    for a=0:150:600
        hold on, plot(a,min(axis):max(axis),'b','linewidth',1);
    end
    hold on, title(['effet Omission: omission A attendue(black) VS omission A rare (red) ',num2str(i)])
    hold on, axis([-50 950 0 2000])
    


    %----------------------------------------------------------------------
    % Effet Omission son B
    %---------------------------------------------------------------------- 
    figure, plot((Range(sq{i,11}, 'ms')), Data(sq{i,11})/length(sweeps),'k','linewidth',2)
    hold on, plot(Range(sq{i,12},'ms'),Data(sq{i,12})/length(sweeps),'r','linewidth',2)
    for a=0:150:600
        hold on, plot(a,min(axis):max(axis),'b','linewidth',1);
    end
    hold on, title(['effet Omission: omission B attendue (black) VS omission B rare (red)',num2str(i)])
    hold on, axis([-50 950 0 2000])
    

    end
end

