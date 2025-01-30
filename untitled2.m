
    
%% ------------------------------   Local   -----------------------------------------
for i=LFP1:LFP2;
    %----------------------------------------------------------------------
    % Effet Local Deviant A
    %----------------------------------------------------------------------
    figure, plot(Range(matVal{i,1},'ms'),mean(Data(matVal{i,1})'),'k','linewidth',1)
    hold on, plot(Range(matVal{i,3},'ms'),mean(Data(matVal{i,3})'),'r','linewidth',1)
    hold on, title(['effet LOCAL: FreqAAAAA(bl) vs FreqBBBBA(red) +  - channeln� ',num2str(i)]) 
    hold on, axis([-100 1100 -1000 800])
    for a=0:150:600
        hold on, plot(a,min(axis):max(axis),'b','linewidth',1);
    end

   
    %----------------------------------------------------------------------
    % Effet Local Deviant B
    %----------------------------------------------------------------------    
    figure, plot(Range(matVal{i,2},'ms'),mean(Data(matVal{i,2})'),'k','linewidth',1)
    hold on, plot(Range(matVal{i,4},'ms'),mean(Data(matVal{i,4})'),'r','linewidth',1)
        for a=0:150:600
        hold on, plot(a,min(axis):max(axis),'b','linewidth',1);
        end
    hold on, title(['effet LOCAL: FreqBBBBB(bl) vs FreqAAAAB(red)  + - channeln�',num2str(i)])



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



%% -------------------------   Global (local deviant)  -----------------------------------------


    %----------------------------------------------------------------------
    % Effet Global Deviant A (local deviant)
    %----------------------------------------------------------------------    
    figure, plot(Range(matVal{i,3},'ms'),mean(Data(matVal{i,3})'),'k','linewidth',1)
    hold on, plot(Range(matVal{i,5},'ms'),mean(Data(matVal{i,5})'),'r','linewidth',1)
        for a=0:150:600
        hold on, plot(a,min(axis):max(axis),'b','linewidth',1);
        end
    hold on, title(['effet GLOBAL (local dvt): FreqBBBBA(bl) vs RareBBBBA(red)  - channel n�',num2str(i)])
    hold on, axis([-100 1100 -1500 1000])
    %----------------------------------------------------------------------
    % Effet Global Deviant B (local deviant)
    %---------------------------------------------------------------------- 
    figure, plot(Range(matVal{i,4},'ms'),mean(Data(matVal{i,4})'),'k','linewidth',1)
    hold on, plot(Range(matVal{i,6},'ms'),mean(Data(matVal{i,6})'),'r','linewidth',1)
        for a=0:150:600
        hold on, plot(a,min(axis):max(axis),'b','linewidth',1);
        end
    hold on, title(['effet GLOBAL(local dvt): FreqAAAAB(black) vs RareAAAAB(red)   - channel n�',num2str(i)])
    hold on, axis([-100 1100 -1500 1000])     

%% -----------------------------   Omission   -----------------------------------------


    %----------------------------------------------------------------------
    % Effet Omission son A
    %---------------------------------------------------------------------- 
    figure, plot(Range(matVal{i,9},'ms'),mean(Data(matVal{i,9})'),'k','linewidth',1)
    hold on, plot(Range(matVal{i,10},'ms'),mean(Data(matVal{i,10})'),'r','linewidth',1)
        for a=0:150:600
        hold on, plot(a,min(axis):max(axis),'b','linewidth',1);
        end
    hold on, title(['effet Omission: omission A attendue(black) VS omission A rare (red) ',num2str(i)])
    hold on, axis([-100 1100 -1500 1000])


    %----------------------------------------------------------------------
    % Effet Omission son B
    %---------------------------------------------------------------------- 
    figure, plot(Range(matVal{i,11},'ms'),mean(Data(matVal{i,11})'),'k','linewidth',1)
    hold on, plot(Range(matVal{i,12},'ms'),mean(Data(matVal{i,12})'),'r','linewidth',1)
        for a=0:150:600
        hold on, plot(a,min(axis):max(axis),'b','linewidth',1);
        end
    hold on, title(['effet Omission: omission B attendue (black) VS omission B rare (red)',num2str(i)])
    hold on, axis([-100 1100 -1500 1000])
    

end

