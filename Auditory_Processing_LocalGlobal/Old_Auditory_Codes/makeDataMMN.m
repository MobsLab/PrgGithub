%makeDataMMN


%% Initiation
spk=1;
setCu=0;
res=pwd;
FreqVideo=15;
cd(res)

clear S LFP TT cellnames lfpnames

%% ------------------------------------------------------------------------
%----------------------- Spikes -------------------------------------------
%--------------------------------------------------------------------------


if spk
    
    try
        load SpikeData
        S;
        

        try
            if setCu==0
                SetCurrentSession
                SetCurrentSession('same')
                setCu=1;
            end
            
            s=GetSpikes('output','full');
            a=1;
            for i=1:18
                for j=1:200
                    try
                        if length(find(s(:,2)==i&s(:,3)==j))>1
                            S{a}=tsd(s(find(s(:,2)==i&s(:,3)==j),1)*1E4,s(find(s(:,2)==i&s(:,3)==j),1)*1E4);
                            TT{a}=[i,j];
                            cellnames{a}=['TT',num2str(i),'c',num2str(j)];
                            
                            W{a} = GetSpikeWaveforms([i j]);
                            
                            a=a+1;
                        end
                    end
                end
            end
            
            try
                S=tsdArray(S);
            end
            
            save SpikeData -v7.3 S s TT cellnames
            save Waveforms -v7.3 W cellnames
            
        catch
            disp('problem for spikes')
        end
    end
end


%% ------------------------------------------------------------------------
%------------------------- LFP --------------------------------------------
%--------------------------------------------------------------------------
if 1
    disp(' ');
    disp('LFP Data')
    
    try 
        load([res,'/LFPData/InfoLFP.mat'],'InfoLFP');
        load([res,'/LFPData/LFP',num2str(InfoLFP.channel(1))],'LFP');
        FragmentLFP='n';
    catch
        
        try
            load LFPData
            Range(LFP{1});
            FragmentLFP=input('LFPData.mat exists, do you want to fragment LFPData.mat in folder LFPData (y/n) ? ','s');
        catch
            FragmentLFP='y';
        end
    end
    
    if FragmentLFP=='y';
        try
            % infoLFP for each channel
            disp(' ');
            disp('...Creating InfoLFP.mat')
            InfoLFP=listLFP_to_InfoLFP_ML(res);
            
            % LFPs
            disp(' ');
            disp('...Creating LFPData.mat')
            
            if setCu==0
                SetCurrentSession
                SetCurrentSession('same')
                setCu=1;
            end
            
            for i=1:length(InfoLFP.channel)
                LFP_temp=GetLFP(InfoLFP.channel(i));
                disp(['loading and saving LFP',num2str(InfoLFP.channel(i)),' in LFPData...']);
                LFP=tsd(LFP_temp(:,1)*1E4,LFP_temp(:,2));
                save([res,'/LFPData/LFP',num2str(InfoLFP.channel(i))],'LFP');
                clear LFP LFP_temp
            end
            disp('Done')
        catch
            disp('problem for lfp')
            %keyboard
        end
    end
end

%% ------------------------------------------------------------------------
%----------------- BehavResources -----------------------------------------
%--------------------------------------------------------------------------

if 1
    disp(' ');
    disp('behavResources')
    try
        load behavResources
        Pos;
        disp('Done')
    catch
        try  eval(['cd(''',res,'-wideband'')']); dirnamepref=9; catch, eval(['cd(''',res,'-EIB'')']); dirnamepref=4;end
        if setCu==0
            SetCurrentSession
            SetCurrentSession('same')
            setCu=1;
        end
        % ---------------------------------------------------------------------
        
        
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
                save behavResources evt tpsEvt stim tp1 ts1 good1 stim
            catch

                tp1=[];
                ts1=[];
                good1=[];
                save behavResources evt tpsEvt stim tp1 ts1 good1 stim
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
                save behavResources evt tpsEvt stim tp2 ts2 good2 stim
            catch

                tp2=[];
                ts2=[];
                good2=[];
                save behavResources evt tpsEvt stim tp2 ts2 good2 stim
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
        % ---------------------------------------------------------------------
        global DATA
        filPos=[DATA.session.basename,'.pos'];
        
        try
            Postemp=load(filPos);
            
            try
                load(['LFP',listLFP.name{1}],'LFP');
                rg=Range(LFP{1},'s');
                dur=rg(end)-rg(1);
            catch
                dur=input('Tu fais un test, quelle est la duree de l''enregistrement? ');
            end
            
            FreqObs=length(Postemp)/dur;
            tps=[1:length(Postemp)]'/FreqObs;
            
            
            
            % Remove Artefacts with speed
            %----------------------------
            PosTemp=[tps,Postemp];
            Art=100;
            [PosC,speed]=RemoveArtifacts(PosTemp,Art);
            
            figure(1), clf
            subplot(2,1,1),hold on
            plot(PosTemp(:,2),PosTemp(:,3)), xlim([0 400]), ylim([0 400])
            plot(PosC(:,2),PosC(:,3),'r'), xlim([0 400]), ylim([0 400]),
            try
                title(namePos{i}(24:end-dirnamepref));
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
                        title(namePos{i}(24:end-dirnamepref));
                    end
                    subplot(2,1,2),hist(speed,100)
                    
                    rep=input('Tracking ok? (o/n) : ','s');
                end
            end
            
            PosC2=[ones(20,1)*PosC(1,2:3); PosC(:,2:3); ones(20,1)*PosC(end,2:3)];
            PosT=resample(PosC2(:,1:2),floor(FreqVideo/FreqObs*1E4),1E4);
            
            Postemp=PosT(21:end-20,:);
            
            
        catch
            
            disp('No global file .pos')
            %-------------------------------------------------------------------------------------------------------------------------------
            %-------------------------------------------------------------------------------------------------------------------------------
            
            %res=pwd;
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
                    disp(['... ',list(i).name]);
                    
                    Post{a}=load(list(i).name);
                    
                    %----------------------------------------------------
                    
                    positiontemp=Post{a};
                    
                    Post{a}=positiontemp(1:end-7,:);
                    
                    clear positiontemp
                    
                    %----------------------------------------------------
                    try
                        load namePos
                        namePos;
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
                    if leni>len && ( strcmp(namePos{a},evt{i}(leni-len+1:leni)) || strcmp(namePos{a}(end-25:end),evt{i}(end-25:end)) )
                        if evt{i}(1)=='b'
                            tpsdeb{a}=tpsEvt{i};
                        elseif evt{i}(1)=='e'
                            tpsfin{a}=tpsEvt{i};
                        end
                    end
                end
            end
            
            save behavResources evt namePos tpsEvt tpsdeb tpsfin
            
            %-------------------------------------------------------------------------------------------------------------------------------
            %-------------------------------------------------------------------------------------------------------------------------------
            
            
            th=0.95;
            Postemp=[];
            dur={};FreqObs={};
            StartTracking=[];        StopTracking=[];
            StartWake=[];            StopWake=[];
            StartSleep=[];           StopSleep=[];
            StartRest=[];            StopRest=[];
            StartExplo=[];           StopExplo=[];
            StartPre=[];             StopPre=[];

            
            if length(Post)==length(tpsfin)
                
                for i=1:length(Post)
                    try
                    dur{i}=tpsfin{i}-tpsdeb{i};
                    FreqObs{i}=length(Post{i})/dur{i};
                    tps=[1:length(Post{i})]'/FreqObs{i};
                    catch
                        keyboard
                    end
                    clear PosTemp
                    
                    %------- remove artefacts --------
                    PosTemp(:,1)=tps;
                    try
                        PosTemp(:,2:3)=Post{i};
                    catch
                        PosTemp(:,2:3)=Post{i}(:,1:2);
                    end
                    
                    %------- Epochs --------
                    
                    StartTracking=[StartTracking;tpsdeb{i}*1E4];
                    StopTracking=[StopTracking;tpsfin{i}*1E4];
                    
                    if isempty(strfind(namePos{i},'Wake'))==0
                        StartWake=[StartWake,tpsdeb{i}*1E4];
                        StopWake=[StopWake;tpsfin{i}*1E4];
                        
                    elseif isempty(strfind(namePos{i},'Sleep'))==0
                        StartSleep=[StartSleep;tpsdeb{i}*1E4];
                        StopSleep=[StopSleep;tpsfin{i}*1E4];
                        
                    elseif isempty(strfind(namePos{i},'Rest'))==0
                        StartRest=[StartRest;tpsdeb{i}*1E4];
                        StopRest=[StopRest;tpsfin{i}*1E4];
                        
                    elseif isempty(strfind(namePos{i},'Explo'))==0
                        StartExplo=[StartExplo;tpsdeb{i}*1E4];
                        StopExplo=[StopExplo;tpsfin{i}*1E4];
                    end
                    

                    
                    %------- remove artefacts -
                    Art=100;
                    try
                    [PosC,speed]=RemoveArtifacts(PosTemp,Art);
                    catch
                        PosC=PosTemp; speed=ones(1,PosC);disp('dicredit speed values');
                    end
                    figure(1),clf
                    subplot(2,1,1),hold on
                    plot(PosTemp(:,2),PosTemp(:,3)),title(namePos{i}(24:end-dirnamepref));
                    plot(PosC(:,2),PosC(:,3),'r'),
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
                        plot(PosC(:,2),PosC(:,3),'r'), xlim([0 400]), ylim([0 400]),title(namePos{i}(24:end-dirnamepref));
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
try
    PosT{i}=resample(PosC2(:,1:2),floor(FreqVideo/FreqObs{i}*1E4),1E4);
catch
    keyboard
end

                    Postemp=[Postemp;PosT{i}(21:end-20,:)];
                    
                    %keyboard
                end
                
                try
                    TrackingEpoch=intervalSet(StartTracking,StopTracking);
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
                try
                    WakeEpoch=intervalSet(StartWake,StopWake);
                end
                try
                    PreEpoch=intervalSet(StartPre,StopPre);
                end
                
                close(1);
                
                
                
            end
            
            
            
            %-------------------------------------------------------------------------------------------------------------------------------
            %-------------------------------------------------------------------------------------------------------------------------------
            
            
            file=fopen(filPos,'w');
            
            for j=1:length(Postemp)
                
                fprintf(file,'%f\t',Postemp(j,1));
                fprintf(file,'%f\n',Postemp(j,2));
                
            end
            
            fclose(file);
            
        end
        
        %-------------------------------------------------------------------------------------------------------------------------------
        %-------------------------------------------------------------------------------------------------------------------------------
        
        
        Freq=FreqVideo;
        %
        tps=[1:length(Postemp)]'/Freq;

        clear PosTotal
        PosTotal(:,1)=tps;
        PosTotal(:,2:3)=Postemp;
        Pos=PosTotal;
        
        
        for i=1:length(Pos)-1
            Vx = (Pos(i,2)-Pos(i+1,2))*30;
            Vy = (Pos(i,3)-Pos(i+1,3))*30;
            Vitesse(i) = sqrt(Vx^2+Vy^2);
        end
        
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
            save behavResources Pos Speed X Y V evt tpsEvt tpsdeb tpsfin namePos WakeEpoch SleepEpoch RestEpoch TrackingEpoch stim
            disp('Done')
        catch
            try
                save behavResources Pos Speed X Y V evt tpsEvt tpsdeb tpsfin namePos
            catch
                
                save behavResources Pos Speed X Y V evt tpsEvt
            end
            
            disp(' ')
            disp('behavresources partiel')
        end
        try
            save('behavResources','PreEpoch','-append')
        end
    end
end
%% ------------------------------------------------------------------------
%---------------- BehavResources - add Freezing ---------------------------
%--------------------------------------------------------------------------

if 1
    clear Movtsd
    disp(' ');
    disp('BehavResources - add Freezing')
    
    try
        load behavResources
        X;
        Movtsd;
        disp('Done')
        
    catch
        disp('pas de variable globale Movtsd')
        
        if setCu==0
            SetCurrentSession
            SetCurrentSession('same')
            setCu=1;
        end
        
        Fevt=GetEvents('output','Descriptions');
        for i=1:length(Fevt)
            FtpsEvt{i}=GetEvents(Fevt{i});
        end
        
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
        ImmobOK=1;
        for i=1:length(list)
            if length(list(i).name)>length(nom)+3 && strcmp(list(i).name(end-length(nom)-3:end),[nom,'.mat'])
                try
                    load(list(i).name);
                    disp(['... ',list(i).name]);
                    Freeztemp=Data(Movtsd);
                    Freez{a}=Freeztemp(1:end-7);
                    nameFreez{a}=list(i).name;
                    a=a+1;
                catch
                    disp(['... MISSING Movtsd for ',list(i).name(1:end-length(nom)-4)]);
                    ImmobOK=0;
                end
            end
        end
        eval(['cd(''',res,''')'])
        
        %-------------------------------------------------------------------------------------------------------------------------------
        %-------------------------------------------------------------------------------------------------------------------------------
        
        clear Ftpsdeb
        clear Ftpsfin
        
        if ImmobOK
            for a=1:length(nameFreez)
                prodtest=0;
                for i=1:length(Fevt)
                    if isempty(strfind(Fevt{i}, nameFreez{a}(end-29:end-4)))==0
                        if Fevt{i}(1)=='b'
                            Ftpsdeb{a}=FtpsEvt{i};
                        elseif Fevt{i}(1)=='e'
                            Ftpsfin{a}=FtpsEvt{i};
                        end
                    end
                end
            end
            
            save('behavResources','Fevt','nameFreez','FtpsEvt','Ftpsdeb','Ftpsfin','-append')
            
            %-------------------------------------------------------------------------------------------------------------------------------
            %-------------------------------------------------------------------------------------------------------------------------------
            
            Freeztemp=[];
            Bord=21;
            
            if length(nameFreez)==length(Ftpsfin)
                for i=1:length(nameFreez)
                    try
                    dur{i}=Ftpsfin{i}-Ftpsdeb{i};
                    FreqObs{i}=length(Freez{i})/dur{i};
                    
                    FreezC=[ones(3,1)*Freez{i}(1); Freez{i}; ones(3,1)*Freez{i}(end)];
                    FreezC=double(FreezC);
                    FreezT{i}=resample(FreezC,floor(FreqVideo/FreqObs{i}*1E4),1E4);
                    
                    Freeztemp=[Freeztemp;FreezT{i}(21:end-20)];
                    catch
                        disp('error in makeDataMMN at 663')
                        keyboard
                    end
                end
            end
            Freq=FreqVideo;
            
            

            dur=Ftpsfin{end}-Ftpsdeb{1};
            FreqObs=length(Freeztemp)/dur;
            tps=[1:length(Freeztemp)]'/FreqObs;
            

            Movtsd=tsd(tps*1E4,Freeztemp);

            
            save('behavResources','Movtsd','-append')
            disp('Done')
            
        else
            disp('problem add freezing')
        end
    end
end

disp(' ');
disp('---------------------------');
disp('------ sleepscoringML ------');
clear LFP
try, sleepscoringML
catch keyboard; end

