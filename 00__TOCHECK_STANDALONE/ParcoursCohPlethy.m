%ParcoursCohPlethy




cd /media/DataMOBsRAID5/ProjetAstro/DataPlethysmo

%---------------------------------------------------------------------------------------------------------------------------------    
%---------------------------------------------------------------------------------------------------------------------------------    

try
    DataSet;  % if DataSet=1 all data; if DataSet=0 only Plethysmo
catch
    DataSet=0;
end

try
    struct;
    struct1=struct{1};
    struct2=struct{2};
    prof=struct{3};
catch
    struct1='PaCx';
    struct2='PFCx'; % ou respi si respi=1
    prof='deep';
    %prof='sup';
end


params.tapers=[3 9];
params.pad=1;
params.fpass=[0 100];   
params.err=[1 0.05];

movingwin=[3 0.1]; 


%---------------------------------------------------------------------------------------------------------------------------------
%---------------------------------------------------------------------------------------------------------------------------------

   
try
if struct2=='Respi'
    respi=1;
else
    respi=0;
end
catch
    respi=0;
end


try
  
    if DataSet
        try
        clear cS12t
        eval(['load DataCoherenceAll',struct1,'Vs',struct2,prof,'Tapers',num2str(params.tapers(1)),num2str(params.tapers(2)),'Mov',num2str(movingwin(1))])
        cS12t;
        catch
        clear cS12t
        eval(['load DataCoherenceAll',struct2,'Vs',struct1,prof,'Tapers',num2str(params.tapers(1)),num2str(params.tapers(2)),'Mov',num2str(movingwin(1))])
        cS12t;       

        end
    
    else
              try
                
        clear cS12t
        eval(['load DataCoherence',struct1,'Vs',struct2,prof,'Tapers',num2str(params.tapers(1)),num2str(params.tapers(2)),'Mov',num2str(movingwin(1))])
        cS12t;
              catch
           
        clear cS12t
        eval(['load DataCoherence',struct2,'Vs',struct1,prof,'Tapers',num2str(params.tapers(1)),num2str(params.tapers(2)),'Mov',num2str(movingwin(1))])
        cS12t;       

              end
    end
        
        
    
catch
    
    
 


        a=0;

        if DataSet

            wt=[1 12];
            ko=[13 24];

         % --- WT ---
            % Mouse 51
            a=a+1; Dir.path{a}='/media/DataMOBs/ProjetDPCPX/Mouse051/20130313/BULB-Mouse-51-13032013';
            a=a+1; Dir.path{a}='/media/DataMOBs/ProjetDPCPX/Mouse051/20121219/BULB-Mouse-51-19122012';
            a=a+1; Dir.path{a}='/media/DataMOBs/ProjetDPCPX/Mouse051/20121227/BULB-Mouse-51-27122012';

            % Mouse 60
            a=a+1; Dir.path{a}='/media/DataMOBsRAID5/ProjetAstro/ProjetDPCPX/Mouse060/20130422/BULB-Mouse-60-22042013';
            a=a+1; Dir.path{a}='/media/DataMOBsRAID5/ProjetAstro/ProjetDPCPX/Mouse060/20130415/BULB-Mouse-60-15042013';
            a=a+1; Dir.path{a}='/media/DataMOBsRAID5/ProjetAstro/ProjetCannabinoids/Mouse060/20130430/BULB-Mouse-60-30042013';

            % Mouse 61
            a=a+1; Dir.path{a}='/media/DataMOBsRAID5/ProjetAstro/ProjetDPCPX/Mouse061/20130422/BULB-Mouse-61-22042013';
            a=a+1; Dir.path{a}='/media/DataMOBsRAID5/ProjetAstro/ProjetDPCPX/Mouse061/20130415/BULB-Mouse-61-15042013';
            a=a+1; Dir.path{a}='/media/DataMOBsRAID5/ProjetAstro/ProjetCannabinoids/Mouse061/20130430/BULB-Mouse-61-30042013';

            % Mouse 82
            %a=a+1; Dir.path{a}='/media/DataMOBsRAID5/ProjetAstro/ProjetDPCPX/Mouse082/20130723/BULB-Mouse-82-23072013';
            a=a+1; Dir.path{a}='/media/DataMOBsRAID5/ProjetAstro/ProjetDPCPX/Mouse082/20130729/BULB-Mouse-82-29072013';

            % Mouse 83
            a=a+1; Dir.path{a}='/media/DataMOBsRAID5/ProjetAstro/ProjetDPCPX/Mouse083/20130723/BULB-Mouse-83-23072013';
            a=a+1; Dir.path{a}='/media/DataMOBsRAID5/ProjetAstro/ProjetDPCPX/Mouse083/20130729/BULB-Mouse-83-29072013';



         % --- dKO ---
            % Mouse 47
            a=a+1; Dir.path{a}='/media/DataMOBs/ProjetDPCPX/Mouse047/20121108/BULB-Mouse-47-08112012';
            a=a+1; Dir.path{a}='/media/DataMOBs/ProjetDPCPX/Mouse047/20121112/BULB-Mouse-47-12112012';
            %a=a+1; Dir.path{a}='/media/DataMOBs/ProjetDPCPX/Mouse047/20121220/BULB-Mouse-47-20122012';I_CA=[I_CA,a];

            % Mouse 52
            a=a+1; Dir.path{a}='/media/DataMOBs/ProjetDPCPX/Mouse052/20121114/BULB-Mouse-52-14112012';
            a=a+1; Dir.path{a}='/media/DataMOBs/ProjetDPCPX/Mouse052/20121116/BULB-Mouse-52-16112012';
            a=a+1; Dir.path{a}='/media/DataMOBs/ProjetDPCPX/Mouse052/20121221/BULB-Mouse-52-21122012';

            % Mouse 54
            a=a+1; Dir.path{a}='/media/DataMOBs/ProjetDPCPX/Mouse054/20130308/BULB-Mouse-54-08032013';
            a=a+1; Dir.path{a}='/media/DataMOBs/ProjetLPS/Mouse054/20130319/BULB-Mouse-54-19032013';
            a=a+1; Dir.path{a}='/media/DataMOBs/ProjetLPS/Mouse054/20130320/BULB-Mouse-54-20032013';

            % Mouse 65
            a=a+1; Dir.path{a}='/media/DataMOBsRAID5/ProjetAstro/ProjetDPCPX/Mouse065/20130513/BULB-Mouse-65-13052013';
            a=a+1; Dir.path{a}='/media/DataMOBsRAID5/ProjetAstro/ProjetDPCPX/Mouse065/20130515/BULB-Mouse-65-15052013';

            % Mouse 66
            a=a+1; Dir.path{a}='/media/DataMOBsRAID5/ProjetAstro/ProjetDPCPX/Mouse066/20130513/BULB-Mouse-66-13052013' ;
            a=a+1; Dir.path{a}='/media/DataMOBsRAID5/ProjetAstro/ProjetDPCPX/Mouse066/20130515/BULB-Mouse-66-15052013' ;


        else

            wt=[1 7];
            ko=[8 11];
            a=a+1; Dir.path{a}='/media/DataMOBsRAID5/ProjetAstro/DataPlethysmo/Mouse051';
            a=a+1; Dir.path{a}='/media/DataMOBsRAID5/ProjetAstro/DataPlethysmo/Mouse060/20130503';
            a=a+1; Dir.path{a}='/media/DataMOBsRAID5/ProjetAstro/DataPlethysmo/Mouse061/20130503';
            a=a+1; Dir.path{a}='/media/DataMOBsRAID5/ProjetAstro/DataPlethysmo/Mouse082/20130724';
            a=a+1; Dir.path{a}='/media/DataMOBsRAID5/ProjetAstro/DataPlethysmo/Mouse082/20130827';
            a=a+1; Dir.path{a}='/media/DataMOBsRAID5/ProjetAstro/DataPlethysmo/Mouse083/20130724';
            a=a+1; Dir.path{a}='/media/DataMOBsRAID5/ProjetAstro/DataPlethysmo/Mouse083/20130827';

            %a=a+1; Dir.path{a}='/media/DataMOBsRAID5/ProjetAstro/DataPlethysmo/Mouse054/BO';
            a=a+1; Dir.path{a}='/media/DataMOBsRAID5/ProjetAstro/DataPlethysmo/Mouse054/Cx';
            a=a+1; Dir.path{a}='/media/DataMOBsRAID5/ProjetAstro/DataPlethysmo/Mouse065/20130514';
            %a=a+1; Dir.path{a}='/media/DataMOBsRAID5/ProjetAstro/DataPlethysmo/Mouse065/20130527';
            a=a+1; Dir.path{a}='/media/DataMOBsRAID5/ProjetAstro/DataPlethysmo/Mouse066/20130514';
            a=a+1; Dir.path{a}='/media/DataMOBsRAID5/ProjetAstro/DataPlethysmo/Mouse066/20130528';


        end


        for i=1:length(Dir.path)
            Dir.name{i}=Dir.path{i}(strfind(Dir.path{i},'Mouse'):strfind(Dir.path{i},'Mouse')+7);
        end




        %---------------------------------------------------------------------------------------------------------------------------------    
        %---------------------------------------------------------------------------------------------------------------------------------    

        cS12t=[];
        cS34t=[];
        cREMt=[];
        cWaket=[];
        cWakeThetat=[];
        cWakeNonThetat=[];



        %---------------------------------------------------------------------------------------------------------------------------------    
        %---------------------------------------------------------------------------------------------------------------------------------    

        b=1;

            for i=1:a

                 try

                    cd(Dir.path{i})
                    disp(['   * * * ',Dir.name{i},' * * * '])

                    clear S12
                    clear S34
                    clear REMEpoch
                    clear WakeEpoch
                    clear SleepStages

                    load SleepStagesPaCxDeep
                    S12;

                    clear LFP
                    clear LFP1
                    clear LFP2
                    clear channel
                    try 
                        eval(['load ChannelsToAnalyse/',struct1,'_',prof])
                    catch
                        if strcmp(struct1,'Bulb') && strcmp(prof,'deep')
                            load('SpectrumDataL/UniqueChannelBulb.mat')
                            channel=channelToAnalyse;
                        end
                    end
                    eval(['load LFPData/LFP',num2str(channel)])
                    LFP1=LFP;


                    if respi

                        clear RespiTSD
                        load LFPData RespiTSD
                        LFP2=RespiTSD;

                    else
                        clear LFP
                        eval(['load ChannelsToAnalyse/',struct2,'_',prof])
                        eval(['load LFPData/LFP',num2str(channel)])
                        LFP2=LFP;

                    end

                    clear cS12
                    clear cS34
                    clear cREM
                    clear cWake
                    clear cWakeTheta
                    clear cWakeNonTheta
                    
                    try
                    load behavResources PreEpoch VEHEpoch
                    end
                    try
                        LFP1=Restrict(LFP1,or(PreEpoch,VEHEpoch));
                    end
                    try
                        LFP1=Restrict(LFP1,PreEpoch);
                    end
                    try
                        LFP2=Restrict(LFP2,or(PreEpoch,VEHEpoch));
                    end
                    try
                        LFP2=Restrict(LFP2,PreEpoch);
                    end
                    
                    [C,t,f,cS12,cS34,cREM,cWake,cWakeTheta,cWakeNonTheta]=CohPlethy(LFP1,LFP2,S12,S34,REMEpoch,WakeEpoch,SleepStages,params,movingwin); 
                    title(Dir.name{i})
                    close

                    cS12t=[cS12t;cS12'];
                    cS34t=[cS34t;cS34'];
                    cREMt=[cREMt;cREM'];
                    cWaket=[cWaket;cWake'];
                    cWakeThetat=[cWakeThetat;cWakeTheta'];
                    cWakeNonThetat=[cWakeNonThetat;cWakeNonTheta'];


                catch

                    disp([' ATTENTION,  problem ',Dir.name{i}])
                    problem(b)=i;
                    b=b+1;
                end



            end

        %---------------------------------------------------------------------------------------------------------------------------------    
        %---------------------------------------------------------------------------------------------------------------------------------    

        try
        le1=length(find(problem<ko(1)));
        catch
            le1=0;
        end

        try
        le2=length(find(problem>wt(2)));
        catch
            le2=0;
        end


           freq=[params.fpass(1):0.1:params.fpass(2)];

            clear LFP
            clear LFP1
            clear LFP2
            clear RespiTSD
            clear S12
            clear S34
            clear REMEpoch
            clear WakeEpoch
            clear SleepStages
            clear SWAEpoch
            clear S5

            cd /media/DataMOBsRAID5/ProjetAstro/DataPlethysmo

            if DataSet
            eval(['save DataCoherenceAll',struct1,'Vs',struct2,prof,'Tapers',num2str(params.tapers(1)),num2str(params.tapers(2)),'Mov',num2str(movingwin(1))])
            else
             eval(['save DataCoherence',struct1,'Vs',struct2,prof,'Tapers',num2str(params.tapers(1)),num2str(params.tapers(2)),'Mov',num2str(movingwin(1))])   
            end
            
    
end




%---------------------------------------------------------------------------------------------------------------------------------    
%% -------------------------------------------------------------------------------------------------------------------------------    
%---------------------------------------------------------------------------------------------------------------------------------    
%---------------------------------------------------------------------------------------------------------------------------------    


smo=1;
xl=[0 40];
maa=0.9;


%---------------------------------------------------------------------------------------------------------------------------------    
%% -------------------------------------------------------------------------------------------------------------------------------    
%---------------------------------------------------------------------------------------------------------------------------------    
%---------------------------------------------------------------------------------------------------------------------------------    
 

        try
        le1=length(find(problem<ko(1)));
        catch
            le1=0;
        end

        try
        le2=length(find(problem>wt(2)));
        catch
            le2=0;
        end


    try
        xl;
        xl(2)=xl(2)-3;
    catch
        disp('calcul xl')
        xl=[params.fpass(1) params.fpass(2)-3];
    end
    
    
    if DataSet
            wt=[1 12];
            ko=[13 24];
    else
        ko=[8 11];
        wt=[1 7];
    end
    
   
    
    
    if size(cS12t,1)<ko(2)
        disp(' ')
        disp('-----  Problem  -----')
        disp(' ')
    end
    
    
    figure('color',[1 1 1]),
    subplot(2,1,1),
    plot(freq,SmoothDec(nanmean(cS12t(1:wt(2)-le1,:)),smo),'linewidth',2)
    hold on, plot(freq,SmoothDec(nanmean(cS34t(1:wt(2)-le1,:)),smo),'color',[0 0.4 0],'linewidth',2)
    hold on, plot(freq,SmoothDec(nanmean(cREMt(1:wt(2)-le1,:)),smo),'r','linewidth',2)
    hold on, plot(freq,SmoothDec(nanmean(cWaket(1:wt(2)-le1,:)),smo),'k','linewidth',2),ylim([0.4 maa]),xlim(xl)
    if ko(2)-le1-le2>ko(1)&size(cS12t,1)>ko(2)-le1-le2
        subplot(2,1,2),
        plot(freq,SmoothDec(nanmean(cS12t(ko(1)-le1:ko(2)-le1-le2,:)),smo),'linewidth',2)
        hold on, plot(freq,SmoothDec(nanmean(cS34t(ko(1)-le1:ko(2)-le1-le2,:)),smo),'color',[0 0.4 0],'linewidth',2)
        hold on, plot(freq,SmoothDec(nanmean(cREMt(ko(1)-le1:ko(2)-le1-le2,:)),smo),'r','linewidth',2)
        hold on, plot(freq,SmoothDec(nanmean(cWaket(ko(1)-le1:ko(2)-le1-le2,:)),smo),'k','linewidth',2),ylim([0.4 maa]),xlim(xl)
    else
            
        try
        subplot(2,1,2),
        plot(freq,(SmoothDec(cS12t(ko(1)-le1,:),smo)),'linewidth',2)
        hold on, plot(freq,(SmoothDec(cS34t(ko(1)-le1,:),smo)),'color',[0 0.4 0],'linewidth',2)
        hold on, plot(freq,(SmoothDec(cREMt(ko(1)-le1,:),smo)),'r','linewidth',2)
        hold on, plot(freq,(SmoothDec(cWaket(ko(1)-le1,:),smo)),'k','linewidth',2),ylim([0.4 maa]),xlim(xl)     
        end
    end
    
    subplot(2,1,1),title(['Coherence ',struct1,' vs. ',struct2,', ',prof])
    set(gcf,'position',[376   480   339   420])
    
    figure('color',[1 1 1]),
    subplot(2,2,1), hold on
    plot(freq,SmoothDec(nanmean(cS12t(1:wt(2)-le1,:)),smo),'k','linewidth',2),ylim([0.4 maa]),xlim(xl)
    if ko(2)-le1-le2>ko(1)&size(cS12t,1)>ko(2)-le1-le2
        plot(freq,SmoothDec(nanmean(cS12t(ko(1)-le1:ko(2)-le1-le2,:)),smo),'r','linewidth',2),ylim([0.4 maa]),xlim(xl)
    else
        try
        plot(freq,(SmoothDec(cS12t(ko(1)-le1,:),smo)),'r','linewidth',2),ylim([0.4 maa]),xlim(xl)
        end
    end
    
    title('Light sleep')
    ylabel(['Coherence ',struct1,' vs. ',struct2,', ',prof])
    
    subplot(2,2,2), hold on
    hold on, plot(freq,SmoothDec(nanmean(cS34t(1:wt(2)-le1,:)),smo),'k','linewidth',2),ylim([0.4 maa]),xlim(xl)
    if ko(2)-le1-le2>ko(1)&size(cS12t,1)>ko(2)-le1-le2
        hold on, plot(freq,SmoothDec(nanmean(cS34t(ko(1)-le1:ko(2)-le1-le2,:)),smo),'r','linewidth',2),ylim([0.4 maa]),xlim(xl)
    else
            try
        plot(freq,(SmoothDec(cS34t(8-le1,:),smo)),'r','linewidth',2),ylim([0.4 maa]),xlim(xl)
            end
    end
    
    title('SWS')
    
    subplot(2,2,3), hold on
    hold on, plot(freq,SmoothDec(nanmean(cREMt(1:wt(2)-le1,:)),smo),'k','linewidth',2),ylim([0.4 maa]),xlim(xl)
    if ko(2)-le1-le2>ko(1)&size(cS12t,1)>ko(2)-le1-le2
        hold on, plot(freq,SmoothDec(nanmean(cREMt(ko(1)-le1:ko(2)-le1-le2,:)),smo),'r','linewidth',2),ylim([0.4 maa]),xlim(xl)
    else
            try
        plot(freq,(SmoothDec(cREMt(ko(1)-le1,:),smo)),'r','linewidth',2),ylim([0.4 maa]),xlim(xl)
            end
    end
    
    title('REM')
    ylabel(['Coherence ',struct1,' vs. ',struct2,', ',prof])
    
    subplot(2,2,4), hold on
    hold on, plot(freq,SmoothDec(nanmean(cWaket(1:wt(2)-le1,:)),smo),'k','linewidth',2),ylim([0.4 maa]),xlim(xl)
    if ko(2)-le1-le2>ko(1)&size(cS12t,1)>ko(2)-le1-le2
        hold on, plot(freq,SmoothDec(nanmean(cWaket(ko(1)-le1:ko(2)-le1-le2,:)),smo),'r','linewidth',2),ylim([0.4 maa]),xlim(xl)
    else
            try
        plot(freq,(SmoothDec(cWaket(ko(1)-le1,:),smo)),'r','linewidth',2),ylim([0.4 maa]),xlim(xl)
            end
    end
    
    title('Wake')
    set(gcf,'position',[722   481   488   420])
    
    
    figure('color',[1 1 1]),
    subplot(1,3,1), hold on
    plot(freq,SmoothDec(nanmean(cWaket(1:wt(2)-le1,:)),smo),'k','linewidth',2),ylim([0.4 maa]),xlim(xl)
    if ko(2)-le1-le2>ko(1)&size(cS12t,1)>ko(2)-le1-le2
        plot(freq,SmoothDec(nanmean(cWaket(ko(1)-le1:ko(2)-le1-le2,:)),smo),'r','linewidth',2),ylim([0.4 maa]),xlim(xl)
    else
            try
        plot(freq,(SmoothDec(cWaket(ko(1)-le1,:),smo)),'r','linewidth',2),ylim([0.4 maa]),xlim(xl)
            end
    end
    
    title('Wake')
    ylabel(['Coherence ',struct1,' vs. ',struct2,', ',prof])
    
    subplot(1,3,2), hold on
    hold on, plot(freq,SmoothDec(nanmean(cWakeThetat(1:wt(2)-le1,:)),smo),'k','linewidth',2),ylim([0.4 maa]),xlim(xl)
    if ko(2)-le1-le2>ko(1)&size(cS12t,1)>ko(2)-le1-le2
        hold on, plot(freq,SmoothDec(nanmean(cWakeThetat(ko(1)-le1:ko(2)-le1-le2,:)),smo),'r','linewidth',2),ylim([0.4 maa]),xlim(xl)
    else
            try
        plot(freq,(SmoothDec(cWakeThetat(ko(1)-le1,:),smo)),'r','linewidth',2),ylim([0.4 maa]),xlim(xl)
            end
    end
    
    title('Wake Theta')
    
    subplot(1,3,3), hold on
    hold on, plot(freq,SmoothDec(nanmean(cWakeNonThetat(1:wt(2)-le1,:)),smo),'k','linewidth',2),ylim([0.4 maa]),xlim(xl)
    if ko(2)-le1-le2>ko(1)&size(cS12t,1)>ko(2)-le1-le2
        hold on, plot(freq,SmoothDec(nanmean(cWakeNonThetat(ko(1)-le1:ko(2)-le1-le2,:)),smo),'r','linewidth',2),ylim([0.4 maa]),xlim(xl)
    else
            try
        plot(freq,(SmoothDec(cWakeNonThetat(ko(1)-le1,:),smo)),'r','linewidth',2),ylim([0.4 maa]),xlim(xl)
            end
    end
    
    title('Wake Non Theta')
    
    set(gcf,'position',[379   162   831   234])
    

  

%---------------------------------------------------------------------------------------------------------------------------------    
%---------------------------------------------------------------------------------------------------------------------------------    
%---------------------------------------------------------------------------------------------------------------------------------    
%---------------------------------------------------------------------------------------------------------------------------------    
 


    
    
    
    
    