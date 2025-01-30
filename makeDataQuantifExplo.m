%makeDataQuantifExplo

fff=1;
plo=0;
setCu=0;

FreqVideo=30; % Hz

   
%--------------------------------------------------------------------------
%%BehavResources-----------------------------------------------------------
%--------------------------------------------------------------------------

if 1

    try
    load behavResources
    Pos;
    catch
        
        
            if setCu==0
            SetCurrentSession
            SetCurrentSession('same')
            
            setCu=1;
            end

            evt=GetEvents('output','Descriptions');
            
            for i=1:length(evt)
            tpsEvt{i}=GetEvents(evt{i});
            end
            
            try
            stim=GetEvents('0')*1E4;
            stim=tsd(stim,stim);
            catch
                stim=[];
            end
            
            
            try
            stim=GetEvents('0')*1E4;
            stim=tsd(stim,stim);
            catch
                stim=[];
            end
            
            try
            save behavResources -Append evt tpsEvt stim 
            catch
            save behavResources evt tpsEvt stim 
            end
            
            try
                
                tp1=GetEvents(evt{1});
                if evt{1}=='49'
                tp1=GetEvents(evt{1});
                good1=1;
                elseif evt{2}=='49'
                tp1=GetEvents(evt{2});
                good1=2;
                elseif evt{3}=='49'
                tp1=GetEvents(evt{3});
                good1=3;
                end

                ts1=ts(tp1*1E4);
                save behavResources evt tpsEvt stim tp1 ts1 good1
            catch

                tp1=[];
                ts1=[];
                good1=[];
                save behavResources evt tpsEvt stim tp1 ts1 good1
            end


            try
                
                tp2=GetEvents(evt{1});
                if evt{1}=='50'
                tp2=GetEvents(evt{1});
                good2=1;
                elseif evt{2}=='50'
                tp2=GetEvents(evt{2});
                good2=2;
                elseif evt{3}=='50'
                tp2=GetEvents(evt{3});
                good2=3;
                end

                ts1=ts(tp1*1E4);
                save behavResources evt tpsEvt stim tp2 ts2 good2
            catch

                tp2=[];
                ts2=[];
                good2=[];
                save behavResources evt tpsEvt stim tp2 ts2 good2
            end
            
            
            
            
            
            try

                if evt{1}=='66'
                tpB=GetEvents(evt{1});
                elseif evt{2}=='66'
                tpB=GetEvents(evt{2});
                elseif evt{3}=='66'
                tpB=GetEvents(evt{3});
                elseif evt{4}=='66'
                tpB=GetEvents(evt{4});
                end

                tsB=ts(tpB*1E4);
                
                save behavResources -Append tpB tsB    
            
            end
            
             try

                if evt{1}=='82'
                tpR=GetEvents(evt{1});
                elseif evt{2}=='82'
                tpR=GetEvents(evt{2});
                elseif evt{3}=='82'
                tpR=GetEvents(evt{3});
                elseif evt{4}=='82'
                tpR=GetEvents(evt{4});
                end
  
                tsR=ts(tpR*1E4);
                
                save behavResources -Append tpR tsR
                   
             end
          
            global DATA
            filPos=[DATA.session.basename,'.pos'];
            
            try 
                
                Postemp=load(filPos);  
                try
                load LFPData LFP% error
                rg=Range(LFP{1},'s');
                dur=rg(end)-rg(1);
                catch
                    dur=input('Tu fais un test, quelle est la duree de l''enregistrement? ');
                end
                
                FreqObs=length(Postemp)/dur;
                tps=[1:length(Postemp)]'/FreqObs;
                
                PosTemp=[tps,Postemp];
                Art=100;
                [PosC,speed]=RemoveArtifacts(PosTemp,Art);  
                
                figure(1), clf
                subplot(2,1,1),hold on
                plot(PosTemp(:,2),PosTemp(:,3)), xlim([0 400]), ylim([0 400])
                plot(PosC(:,2),PosC(:,3),'r'), xlim([0 400]), ylim([0 400]),
                try
                    title(namePos{i}(27:end-9));
                end
                
                subplot(2,1,2),hist(speed,100)

                rep=input('Tracking ok? (o/n) : ','s');

                if rep=='n'

                while rep=='n'

                    Art=input('Speed limit for artefacts :');
                    [PosC,speed]=RemoveArtifacts(PosTemp,Art); 

                    if length(PosC)==length(PosTemp)-1
                        PosC=[PosC;PosC(end,:)];
                        speed=[speed;speed(end)];
                        elseif length(PosC)==length(PosTemp)-2
                        PosC=[PosC(1,:);PosC;PosC(end,:)];
                        speed=[speed(1);speed;speed(end)];
                        end


                        figure(1),clf
                        subplot(2,1,1),hold on
                        plot(PosTemp(:,2),PosTemp(:,3)), xlim([0 400]), ylim([0 400])
                        plot(PosC(:,2),PosC(:,3),'r'), xlim([0 400]), ylim([0 400]), 
                        try 
                            title(namePos{i}(27:end-9));
                        end
                        subplot(2,1,2),hist(speed,100)

                        rep=input('Tracking ok? (o/n) : ','s');
                end


                end

                PosC2=[ones(20,1)*PosC(1,2:3); PosC(:,2:3); ones(20,1)*PosC(end,2:3)];
                PosT=resample(PosC2(:,1:2),floor(FreqVideo/FreqObs*1E4),1E4);                     
                
                Postemp=PosT(21:end-20,:);

            

            catch
                
                disp('pas de fichier global .pos')
                                    %-------------------------------------------------------------------------------------------------------------------------------
                                    %-------------------------------------------------------------------------------------------------------------------------------


                                                
                                                res=pwd;
                                                try
                                                eval(['cd(''',res,'-wideband'')'])
                                                ca=11;
                                                nom='wideband';
                                                catch
                                                eval(['cd(''',res,'-EIB'')'])
                                                ca=6;
                                                nom='EIB';
                                                end
                                                
                                                list=dir;
                                                a=1;

                                                for i=1:length(list)
                                                    le=length(list(i).name);
                                                    if length(list(i).name)>12&list(i).name(le-ca:le)==[nom,'.pos']
                                                        list(i).name
                                                        
                                                        Post{a}=load(list(i).name);
                                                        
                                                        %----------------------------------------------------

                                                        positiontemp=Post{a};
                                                        Post{a}=positiontemp(1:end-7,:);
                                                        
                                                        clear positiontemp
                                                        
                                                        %----------------------------------------------------
                                                        try
                                                            load namePos
                                                            namePos
                                                        catch
                                                            namePos{a}=list(i).name(1:le-4);
                                                            a=a+1;
                                                        end
                                                    end

                                                end
                                                eval(['cd(''',res,''')'])


                                     %-------------------------------------------------------------------------------------------------------------------------------
                                    %-------------------------------------------------------------------------------------------------------------------------------


                                                clear tpsdeb
                                                clear tpsfin

                                                for a=1:length(namePos)
                                                    prodtest=0;
                                                    for i=1:length(evt)
                                                        len=length(namePos{a});
                                                        leni=length(evt{i});
                                                        if leni>len & namePos{a}==evt{i}(leni-len+1:leni)    
                                                            if evt{i}(1)=='b'
                                                                tpsdeb{a}=tpsEvt{i};
                                                            elseif evt{i}(1)=='e'
                                                                tpsfin{a}=tpsEvt{i};
                                                            end
                                                        end
                                                    end
                                                end

                                    save behavResources evt namePos tpsEvt stim tpsdeb tpsfin
                                    
                                    %-------------------------------------------------------------------------------------------------------------------------------
                                    %-------------------------------------------------------------------------------------------------------------------------------


                                    Postemp=[];
                                    
                                    StartTracking=[];
                                    StopTracking=[];
                                    StartQuantifExplo=[];
                                    StopQuantifExplo=[]; 
                                    StartICSS=[];
                                    StopICSS=[];
                                    StartSleep=[];
                                    StopSleep=[]; 
                                    StartRest=[];
                                    StopRest=[];
                                    StartExplo=[];
                                    StopExplo=[];
                                    
                                    th=0.95; %threshold for good tracking
                                    if length(Post)==length(tpsfin)

                                        for i=1:length(Post)
                                                dur{i}=tpsfin{i}-tpsdeb{i};
                                                FreqObs{i}=length(Post{i})/dur{i};
                                                tps=[1:length(Post{i})]'/FreqObs{i};
                                                clear PosTemp
                                                
                                                %------- remove artefacts --------
                                              
                                                
                                                PosTemp(:,1)=tps;
                                                try
                                                PosTemp(:,2:3)=Post{i};
                                                catch
                                                PosTemp(:,2:3)=Post{i}(:,1:2);
                                                end
                                                
                                                %------- choix essai Quantif --------
                                                
                                                
                                                clear xplo
                                                clear yplo

                                                if isempty(strfind(namePos{i},'QuantifExplo'))==0 || isempty(strfind(namePos{i},'QExploStopped'))==0
                                                    res=pwd;
                                                    try
                                                eval(['cd(''',res,'-wideband'')'])
                                                catch
                                                eval(['cd(''',res,'-EIB'')'])
                                                    end
                                                   
                                                    
                                                    xplo=tsd(tps*1E4,PosTemp(:,2));
                                                    yplo=tsd(tps*1E4,PosTemp(:,3));
                                                    clear FinalEpoch
                                                    try
                                                        eval(['load FinalEpoch',namePos{i}(27:end-9)])
                                                        eval(['FinalEpoch;'])
                                                        
                                                     xplo=Restrict(xplo,FinalEpoch);
                                                     yplo=Restrict(yplo,FinalEpoch);
                                                    catch 
                                                        
                                                    try    
                                                    [FinalEpoch,xplo,yplo]=controlEpoch(namePos{i},PosTemp);
                                                    catch
                                                        
                                                        
                                                    xplo=tsd(PosTemp(:,1)*1E4,PosTemp(:,2));
                                                    yplo=tsd(PosTemp(:,1)*1E4,PosTemp(:,3));
                                                    
                                                    eval(['load ',namePos{i}])

                                                    Pos=Pos(1:end-7,:);


                                                    if length(Pos)~=length(PosTemp)

                                                        disp('problem')
                                                        FinalEpoch=[];
                                                        X=[];
                                                        Y=[];
                                                        Modif=[];
                                                    else

                                                    figure, plot(PosTemp(:,1),PosTemp(:,2)),title(num2str(PosTemp(end,1)))
                                                    nuum=gcf;
                                                    
                                                    tpsEpochTempsDeb=input('Temps debut ControEpoch: ');
                                                    tpsEpochTempsFin=input('Temps Fin ControEpoch: ');
                                                    tpsFin=input('Temps de Fin: ');
                                                    tpsEpochTempsDeb=tpsEpochTempsDeb*PosTemp(end,1)/tpsFin;
                                                    tpsEpochTempsFin=tpsEpochTempsFin*PosTemp(end,1)/tpsFin;
                                                    
                                                    FinalEpoch=intervalSet(tpsEpochTempsDeb*1E4,tpsEpochTempsFin*1E4);
                                                    
                                                    yl=ylim;
                                                    xl=xlim;
                                                    close(nuum)
                                                    figure(nuum),hold on
                                                    plot(PosTemp(:,1),PosTemp(:,2))
                                                    line([Start(FinalEpoch,'s') Start(FinalEpoch,'s')],yl,'color','g')
                                                    line([End(FinalEpoch,'s') End(FinalEpoch,'s')],yl,'color','r')
                                                    pause(2)
                                                    close(nuum)
                                                    
                                                    end
                                                    end
                                                    
                                                    
                                                    
                                                    xplo=Restrict(xplo,FinalEpoch);
                                                    yplo=Restrict(yplo,FinalEpoch);
                                                 
                                                    eval(['FinalEpoch',namePos{i}(27:end-9),'=FinalEpoch;'])
                                                    eval(['save FinalEpoch',namePos{i}(27:end-9),' FinalEpoch xplo yplo'])
                                                    
                                                    end
                                                    
                                                    eval(['cd(''',res,''')'])
                                                                                  
                                                    
                                                    %---------Convert time
                                                    
                                                    tpsDEBUT=Start(FinalEpoch);
                                                    tpsFIN=End(FinalEpoch);
                                                    
                                                    StartTracking=[StartTracking;(tpsDEBUT+tpsdeb{i}*1E4)];
                                                    StopTracking=[StopTracking;(tpsFIN+tpsdeb{i}*1E4)];
                                                    
                                                    StartQuantifExplo=[StartQuantifExplo;(tpsDEBUT+tpsdeb{i}*1E4)];
                                                    StopQuantifExplo=[StopQuantifExplo;(tpsFIN+tpsdeb{i}*1E4)];
                                                    
                                                else
                                                    
                                                    
                                                    StartTracking=[StartTracking;tpsdeb{i}*1E4];
                                                    StopTracking=[StopTracking;tpsfin{i}*1E4];
                                                    try
                                                    if sum(ismember('ICSS',namePos{i}(10:end)))==4
                                                        StartICSS=[StartICSS,tpsdeb{i}*1E4];
                                                        StopICSS=[StopICSS;tpsfin{i}*1E4];
                                                    end
                                                    end
                                                    try
                                                    if sum(ismember('Sleep',namePos{i}(10:end)))==5
                                                        StartSleep=[StartSleep;tpsdeb{i}*1E4];
                                                        StopSleep=[StopSleep;tpsfin{i}*1E4];
                                                    end
                                                    end
                                                    try
                                                    if sum(ismember('Rest',namePos{i}(10:end)))==4
                                                        StartRest=[StartRest;tpsdeb{i}*1E4];
                                                        StopRest=[StopRest;tpsfin{i}*1E4];
                                                    end
                                                    end
                                                    try
                                                    if sum(ismember('Explo',namePos{i}(10:end)))==5
                                                        StartExplo=[StartExplo;tpsdeb{i}*1E4];
                                                        StopExplo=[StopExplo;tpsfin{i}*1E4];   
                                                    end
                                                    end
                                                        
                                                end
                                                
                                                
                                                %------- remove artefacts -
                                                
                                                
                                                Art=100;
                                             
                                                [PosC,speed]=RemoveArtifacts(PosTemp,Art);  
                                                figure(1),clf
                                                subplot(2,1,1),hold on
                                                plot(PosTemp(:,2),PosTemp(:,3)), xlim([0 400]), ylim([0 400])
                                                plot(PosC(:,2),PosC(:,3),'r'), xlim([0 400]), ylim([0 400]),title(namePos{i}(27:end-9));
                                                
                                                try
                                                
                                                plot(Data(xplo),Data(yplo),'k','linewidth',2), xlim([0 400]), ylim([0 400]),
                                                xploC=tsd(PosC(:,1)*1E4,PosC(:,2));
                                                yploC=tsd(PosC(:,1)*1E4,PosC(:,3));
                                                xploC=Restrict(xploC,FinalEpoch);
                                                yploC=Restrict(yploC,FinalEpoch);
                                                plot(Data(xploC),Data(yploC),'g','linewidth',2), xlim([0 400]), ylim([0 400]),    
                                                
                                                end
                                                subplot(2,1,2),hist(speed,100)

                                                rep=input('Tracking ok? (o/n) : ','s');

                                                while rep=='n'

                                                    Art=input('Speed limit for artefacts (default value 100):');
                                                    [PosC,speed]=RemoveArtifacts(PosTemp,Art); 

                                                    if length(PosC)==length(PosTemp)-1
                                                        PosC=[PosC;PosC(end,:)];
                                                        speed=[speed;speed(end)];
                                                    elseif length(PosC)==length(PosTemp)-2
                                                        PosC=[PosC(1,:);PosC;PosC(end,:)];
                                                        speed=[speed(1);speed;speed(end)];
                                                    end

                                                        figure(1),clf
                                                        subplot(2,1,1),hold on
                                                        plot(PosTemp(:,2),PosTemp(:,3)), xlim([0 400]), ylim([0 400])
                                                        plot(PosC(:,2),PosC(:,3),'r'), xlim([0 400]), ylim([0 400]),title(namePos{i}(27:end-9));
                                                        try
                                                      
                                                        plot(Data(xplo),Data(yplo),'k','linewidth',2), xlim([0 400]), ylim([0 400]),
                                                        xploC=tsd(PosC(:,1)*1E4,PosC(:,2));
                                                        yploC=tsd(PosC(:,1)*1E4,PosC(:,3));
                                                        xploC=Restrict(xploC,FinalEpoch);
                                                        yploC=Restrict(yploC,FinalEpoch);
                                                        plot(Data(xploC),Data(yploC),'g','linewidth',2), xlim([0 400]), ylim([0 400]),  
                                                        end
                                                        subplot(2,1,2),hist(speed,100)

                                                        rep=input('Tracking ok? (o/n) : ','s');
                                                end
                                                 
                                                 clear xplo
                                                 clear yplo
                                                 
 

                                                
                                                PosC2=[ones(3,1)*PosC(1,2:3); PosC(:,2:3); ones(3,1)*PosC(end,2:3)];
                                                %PosT{i}=resample(PosC2(:,1:2),floor(FreqVideo/FreqObs{i}*1E4),1E4);                     
                
                                                %Postemp=[Postemp;PosT{i}(21:end-20,:)];
                                                

                                        end
                                        
                                    try
                                        TrackingEpoch=intervalSet(StartTracking,StopTracking);
                                    end
                                    try
                                        QuantifExploEpoch=intervalSet(StartQuantifExplo,StopQuantifExplo);
                                    end
                                    try
                                        ICSSEpoch=intervalSet(StartICSS,StopICSS);
                                    end
                                    try
                                        SleepEpoch=intervalSet(StartSleep,StopSleep);
                                    end
                                    try
                                        RestEpoch=intervalSet(StartRest,StopRest);
                                    end
                                    try
                                        ExploEpoch=intervalSet(StartExplo,StopExplo);
                                    end
                                    close(1)


                                    else

                                            keyboard

                                    end
                                    
                                    

                                    %-------------------------------------------------------------------------------------------------------------------------------
                                    %-------------------------------------------------------------------------------------------------------------------------------         


                                                file=fopen(filPos,'w');

                                                for j=1:length(Postemp)

                                                fprintf(file,'%f\t',Postemp(j,1));
                                                fprintf(file,'%f\n',Postemp(j,2));

                                                end

                                                fclose(file)
            
            end
            
%-------------------------------------------------------------------------------------------------------------------------------
%-------------------------------------------------------------------------------------------------------------------------------                            

        
            Freq=FreqVideo;
             
            tps=[1:length(Postemp)]'/Freq;
            clear PosTotal
            PosTotal(:,1)=tps;
            PosTotal(:,2:3)=Postemp;
            Pos=PosTotal;

            for i=1:length(Pos)-1
            Vx = (Pos(i,2)-Pos(i+1,2))*30;
            Vy = (Pos(i,3)-Pos(i+1,3))*30;
            Vitesse(i) = sqrt(Vx^2+Vy^2);
            end;

            Speed=SmoothDec(Vitesse',1);

            
            X=tsd(tps*1E4,Pos(:,2));
            Y=tsd(tps*1E4,Pos(:,3));
            V=tsd(tps*1E4,[Speed;Speed(end)]);
           
             stt=Start(TrackingEpoch,'s'); 
             enn= End(TrackingEpoch,'s');
             iddd=find(enn(1:end-1)-stt(2:end)>0);
             stt(iddd+1)=enn(iddd);
             
            TrackingEpoch=intervalSet(stt*1E4, enn*1E4);
            
            
            try  
            save behavResources Pos Speed X Y V evt tpsEvt tpsdeb tpsfin namePos stim TrackingEpoch QuantifExploEpoch ICSSEpoch SleepEpoch RestEpoch
            catch
            try
                save behavResources Pos Speed X Y V evt tpsEvt stim tpsdeb tpsfin namePos 
            catch
                
                save behavResources Pos Speed X Y V evt tpsEvt stim  
            end
            
            disp(' ')
            disp('behavresources partiel')
            end

   end
end

st=Range(stim,'s');
bu = burstinfo(st,0.2);
burst=tsd(bu.t_start*1E4,bu.i_start);
idburst=bu.i_start;


save StimMFB stim burst idburst
