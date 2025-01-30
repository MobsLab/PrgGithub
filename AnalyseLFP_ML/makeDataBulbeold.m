%makeDataBulbe


%% Initiation
warning off
spk=1;
res=pwd;

try load('behavResources.mat','InjectionName');InjectionName; catch, InjectionName=input('Give Names of injections (e.g. {''VEH'' ''CP''} or {''POST''}) :');end
if ~exist([res,'/SpikeData.mat'],'file')
    disp('If you do not want to use spike information for now')
    disp('enter ''S={};S=tsdArray(S);cellnames={}; save SpikeData S cellnames'' after K>>')
    disp('then enter ''return''');
    keyboard;
end
try, setCu; catch, setCu=0;end




%try load('Ref.mat','FreqVideoRec'); FreqVideoRec; catch, FreqVideoRec=input('Give Video frequency of acquisition: ');end
FreqVideo=30;
cd(res)

clear S LFP TT cellnames lfpnames

%% ------------------------------------------------------------------------
%----------------------- Spikes -------------------------------------------
%--------------------------------------------------------------------------


if spk
    
    try
        load SpikeData
        S;
        
    catch
        keyboard
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
            
            global DATA
            tetrodeChannels=DATA.spikeGroups.groups;
            
            save SpikeData -v7.3 S s TT cellnames tetrodeChannels
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
    
    try clear reverseData;load([res,'/LFPData/ErrorREVERSE.mat'],'reverseData'); disp('!!! Reversing LFP signal !');end
    
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
            try
                InfoLFP=listLFP_to_InfoLFP_ML(res);
            catch
                disp('retry listLFP_to_InfoLFP_ML');keyboard;
            end
            
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
                if exist('reverseData','var'), LFP=tsd(LFP_temp(:,1)*1E4,-LFP_temp(:,2));end
                save([res,'/LFPData/LFP',num2str(InfoLFP.channel(i))],'LFP');
                clear LFP LFP_temp
            end
            disp('Done')
        catch
            disp('problem for lfp')
            keyboard
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
        
        evt=GetEvents('output','Descriptions');
       
        for i=1:length(evt)
            tpsEvt{i}=GetEvents(evt{i});
        end
        if strcmp(evt{1},'0'), evt=evt(2:end);tpsEvt=tpsEvt(2:end);end
         
        %Pos = GetPositions('mode','all','coordinates','video');
        global DATA
        filPos=[DATA.session.basename,'.pos'];
        
        try
            Postemp=load(filPos);
            
            try
                %load([res '/LFPData/LFP' num2str(InfoLFP.channel(1)) '.mat'])% modif Julie 03.03.2015
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
            
            if strcmp(rep,'n')
                
                while strcmp(rep,'n')
                    
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
                    
                    %Post{a}=[positiontemp;ones(5,1)*[positiontemp(end,1) positiontemp(end,2)]];
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
                    % check that the files used for position and for concatenation are consistent (using (the last part of the name)
                    if leni>len && ( strcmp(namePos{a},evt{i}(leni-len+1:leni)) || strcmp(namePos{a}(end-20:end),evt{i}(end-20:end)) )
                        if evt{i}(1)=='b'
                            tpsdeb{a}=tpsEvt{i};
                        elseif evt{i}(1)=='e'
                            tpsfin{a}=tpsEvt{i};
                        end
                    end
                end
            end
            
            if ~exist('tpsdeb','var')
                for a=1:length(namePos)
                    for i=1:length(evt)
                        Possl=strfind(namePos{a},'-');
                        evtsl=strfind(evt{i},'-');
                        if ~isempty(Possl) && strcmp(namePos{a}(Possl(end-3):Possl(end)-1),evt{i}(evtsl(end-2):end))
                            if evt{i}(1)=='b'
                                tpsdeb{a}=tpsEvt{i};
                            elseif evt{i}(1)=='e'
                                tpsfin{a}=tpsEvt{i};
                            end
                        end
                    end
                end
            end
            
            save behavResources evt namePos tpsEvt tpsdeb tpsfin
            
            %-------------------------------------------------------------------------------------------------------------------------------
            %-------------------------------------------------------------------------------------------------------------------------------
            
            
            th=0.95; %threshold for good tracking
            Postemp=[];
            dur={};FreqObs={};
            StartTracking=[];        StopTracking=[];
            StartWake=[];            StopWake=[];
            StartSleep=[];           StopSleep=[];
            StartRest=[];            StopRest=[];
            StartExplo=[];           StopExplo=[];
            StartPre=[];             StopPre=[];
            for injN=1:length(InjectionName), StartPost{injN}=[]; StopPost{injN}=[];end
            
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
                        try 
                            PosTemp(:,2:3)=Post{i}(:,1:2);
                        catch
                            disp('WARNING empty file !!!!!!!')
                            PosTemp(1,1)=0;PosTemp(:,2:3)=[224,48];
                        end
                        
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
                    
                    PreInj=1;
                    for injN=1:length(InjectionName)
                        if isempty(strfind(namePos{i},InjectionName{injN}))==0
                            try StartPost{injN}=[StartPost{injN};tpsdeb{i}*1E4]; catch, StartPost{injN}=[tpsdeb{i}*1E4];end
                            try StopPost{injN}=[StopPost{injN};tpsfin{i}*1E4]; catch, StopPost{injN}=[tpsfin{i}*1E4];end
                            PreInj=0;
                        end
                    end
                    if PreInj
                        StartPre=[StartPre;tpsdeb{i}*1E4];
                        StopPre=[StopPre;tpsfin{i}*1E4];
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
                    %plot(PosTemp(:,2),PosTemp(:,3)), xlim([0 400]), ylim([0 400])
                    %plot(PosC(:,2),PosC(:,3),'r'), xlim([0 400]), ylim([0 400]),title(namePos{i}(24:end-dirnamepref));
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
                    
                    while strcmp(rep,'n')
                        
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
                
                for injN=1:length(InjectionName)
                    try
                        eval([InjectionName{injN},'Epoch=intervalSet(StartPost{injN},StopPost{injN});']);
                    catch
                        try
                            eval(['t',InjectionName{injN},'Epoch=intervalSet(StartPost{injN},StopPost{injN});'])
                            disp([InjectionName{injN},' name starts with a number.. renaming it t',InjectionName{injN}])
                            InjectionName{injN}=['t',InjectionName{injN}];
                        catch
                            disp(['Unknown problem with creation of ',InjectionName{injN},'Epoch'])
                            keyboard
                        end
                        
                    end
                end
                
                close(1);
                
                
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
            
            fclose(file);
            
        end
        
        %-------------------------------------------------------------------------------------------------------------------------------
        %-------------------------------------------------------------------------------------------------------------------------------
        
        
        Freq=FreqVideo;
        %
        tps=[1:length(Postemp)]'/Freq;
        %             % tps=rescale(tps,deb,lfp(end,1)-fin)*1E4;
        %             tps2=rescale(tps,lfp(1,1),lfp(end,1))*1E4;
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
        
        
        
        %save behavResources Pos PosC speed X Y V X2 Y2 V2
        try
            save behavResources Pos Speed X Y V evt tpsEvt tpsdeb tpsfin namePos WakeEpoch SleepEpoch RestEpoch TrackingEpoch
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
            save('behavResources','PreEpoch','InjectionName','-append')
            for injN=1:length(InjectionName)
                eval(['save behavResources -append ',InjectionName{injN},'Epoch']);
            end
        catch
            disp(['Pre and ',InjectionName{:},'Epoch not found'])
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
                %try
                    clear Movtsd
                    %res=pwd;
                    load(list(i).name,'Movtsd');
                    %eval(['load ',res,'/',list(i).name,' Movtsd'])
                    eval('Freeztemp=Data(Movtsd);') % eval imp to avoid an error msg 'undefined variable 'Movtsd'
                    Freez{a}=Freeztemp(1:end-7);
                    nameFreez{a}=list(i).name;
                    a=a+1; clear Movtsd
%                 catch
%                     disp(['... MISSING Movtsd for ',list(i).name(1:end-length(nom)-4)]);
%                     ImmobOK=0;
%                 end
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
                    % check that files for freezing and for concatenation have consistent names
                    if isempty(strfind(Fevt{i}, nameFreez{a}(end-length(nom)-16:end-4)))==0 %   17 : length of '-230-13022015-03-' + '.mat' -1
                        if Fevt{i}(1)=='b'
                            Ftpsdeb{a}=FtpsEvt{i};
                        elseif Fevt{i}(1)=='e'
                            Ftpsfin{a}=FtpsEvt{i};
                        end
                    end
                end
            end
            
             if ~exist('Ftpsdeb','var')
                for a=1:length(nameFreez)
                    for i=1:length(Fevt)
                        Possl=strfind(nameFreez{a},'-');
                        evtsl=strfind(Fevt{i},'-');
                        if ~isempty(Possl) && strcmp(nameFreez{a}(Possl(end-3):Possl(end)-1),Fevt{i}(evtsl(end-2):end))
                            if Fevt{i}(1)=='b'
                                Ftpsdeb{a}=FtpsEvt{i};
                            elseif Fevt{i}(1)=='e'
                                Ftpsfin{a}=FtpsEvt{i};
                            end
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
                        disp('error in makeDataBulbe at 684')
                        keyboard
                    end
                end
            end
            Freq=FreqVideo;
            
            
            %
            %             Ok=0;DiffBord=[Ftpsfin{end},Ftpsfin{end}];
            %             while Ok~=1;
            %                 if length(Freeztemp)==length(Posglobal)
            %                     Ok=1;
            %                 elseif length(Freeztemp)~=length(Posglobal) && abs(DiffBord(end))>abs(DiffBord(end-1))
            %                     Ok=1;
            %                     disp(['Pos and Movtsd are not the same length.. Difference= ',num2str(floor(DiffBord(end-1)*10)/10),'s'])
            %                      Freeztemp=[];
            %                     for i=1:length(nameFreez)
            %                         Freeztemp=[Freeztemp;FreezT{i}(Bord-1:end-Bord)];
            %                     end
            %                 else
            %                     Bord=Bord-1;
            %                     Freeztemp=[];
            %                     for i=1:length(nameFreez)
            %                         Freeztemp=[Freeztemp;FreezT{i}(Bord:end-Bord+1)];
            %                     end
            %                     DiffBord=[DiffBord,length(Freeztemp)-length(Pos)];
            %                 end
            %             end
            %
            dur=Ftpsfin{end}-Ftpsdeb{1};
            FreqObs=length(Freeztemp)/dur;
            tps=[1:length(Freeztemp)]'/FreqObs;
            
            %             % tps=rescale(tps,deb,lfp(end,1)-fin)*1E4;
            %             tps2=rescale(tps,lfp(1,1),lfp(end,1))*1E4;
            Movtsd=tsd(tps*1E4,Freeztemp);
            %Movtsd=Restrict(Movtsd,X);
            
            save('behavResources','Movtsd','-append')
            disp('Done')
            
        else
            disp('problem add freezing')
        end
    end
end

%% ------------------------------------------------------------------------
%------------- Get Accelerometer info from INTAN data ---------------------
%--------------------------------------------------------------------------
try
    load('behavResources.mat','MovAcctsd')
    Range(MovAcctsd); disp('Done')
catch
    disp(' '); disp('Get Accelerometer info from INTAN data')
    cha=InfoLFP.channel(strcmp(InfoLFP.structure,'Accelero'));
    if isempty(cha)
        disp('skip')
    else
        clear X Y Z
        disp('... Loading LFP.mat (wait!)')
        X=load(['LFPData/LFP',num2str(cha(1)),'.mat'],'LFP');
        Y=load(['LFPData/LFP',num2str(cha(2)),'.mat'],'LFP');
        Z=load(['LFPData/LFP',num2str(cha(3)),'.mat'],'LFP');
        
        disp('... Creating movement Vector')
        MX=Data(X.LFP);
        MY=Data(Y.LFP);
        MZ=Data(Z.LFP);
        Rg=Range(X.LFP);
        Acc=MX.*MX+MY.*MY+MZ.*MZ;
        %Acc=sqrt(MX.*MX+MY.*MY+MZ.*MZ);
        disp('... DownSampling at 50Hz');
        MovAcctsd=tsd(Rg(1:25:end),abs([0;diff(Acc(1:25:end))]));
        
        figure('Color',[1 1 1]), plot(Range(MovAcctsd,'s'),abs(Data(MovAcctsd)))
        title('MovAcctsd from INTAN Accelerometer'); xlim([0 max(Range(MovAcctsd,'s'))]);
        YL=ylim; hold on, plot(Range(Movtsd,'s'),rescale(Data(Movtsd),YL(1),YL(2)),'r')
        xlabel('Time (s)'); ylabel('abs(diff(X^2+Y^2+Z^2))');legend({'MovAcctsd','Movtsd'})
        
        ButtonName=questdlg('Use MovAcctsd for sleepscoringML ?','MovAcctsd or Movtsd','MovAcctsd','Movtsd','MovAcctsd');
        switch ButtonName
            case 'MovAcctsd'
                useMovAcctsd=1;
            case 'Movtsd'
                useMovAcctsd=0;
        end
        
        save('behavResources','MovAcctsd','useMovAcctsd','-append')
        disp('Done')
    end
end

%% ------------------------------------------------------------------------
%------------- GetTimeOfDataRecordingML - add to BehavResources -----------
%--------------------------------------------------------------------------
try
    load('behavResources.mat','TimeEndRec')
    TimeEndRec; disp('Done')
catch
    disp(' '); disp('GetTimeOfDataRecordingML.m')
    try
        TimeEndRec = GetTimeOfDataRecordingML;
        disp('Done');
    catch
        disp('Problem... SKIP');
    end
end


%% ------------------------------------------------------------------------
%------------------------ sleepscoringML ----------------------------------
%--------------------------------------------------------------------------

disp(' ');
disp('---------------------------');
disp('------ sleepscoringML ------');
clear LFP
try, sleepscoringML
catch keyboard; end
% 
% disp(' ');
% disp('---------------------------');
% disp('------ CodeBulbML2 ------');
% try, CodeBulbML2 % creates LFPA, a small structure that contains a sample of LFP
% catch keyboard; end
% 
% disp(' ');
% disp('---------------------------');
% disp('------ CodeBulbInjectionML ------');
% disp(['Do you want to anlyse effect of ',Manipe,' on DataMOBS? '])
% if strfind(res,'DataMOBs')==0, disp('(you may need to copy makeDataBulb outputs on /DataMOBs first)');end
% ok=input('(y/n) : ','s');
% if ok=='y'
%     try CodeBulbInjectionML
%     catch keyboard; end
% end;
