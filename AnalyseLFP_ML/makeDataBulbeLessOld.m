%makeDataBulbe


%% Initiation
warning off
res=pwd;
try, setCu; catch, setCu=0;end

defaultvalues={'yes','yes','yes','yes','yes','30','{''POST''}'};
try
    load('makedataBulbeInputs')
    defaultvalues=answer;
end
answer = inputdlg({'SpikeData (yes/no)','video Tracking','video Freezing','INTAN accelero',...
    'INTAN Digital input','Freq video','Session/InjectionName'},'Inputs for makeData',1,defaultvalues);

eval(['InjectionName=',answer{7},';'])
spk=strcmp(answer{1},'yes');
track=strcmp(answer{2},'yes');
dofreez=strcmp(answer{3},'yes');
doaccelero=strcmp(answer{4},'yes');
dodigitalin=strcmp(answer{5},'yes');
FreqVideo=str2double(answer{6});
save makedataBulbeInputs answer

clear S LFP TT cellnames lfpnames

%% ------------------------------------------------------------------------
%----------------------- Spikes -------------------------------------------
%--------------------------------------------------------------------------

disp(' '); disp('SpikeData')
try
    load SpikeData
    S;
    if isempty(S),  error;end
    disp('Done')
    
catch
    if spk
        %keyboard
        try
            if setCu==0
                SetCurrentSession
                SetCurrentSession('same')
                setCu=1;
            end
            
            global DATA
            tetrodeChannels=DATA.spikeGroups.groups;
            
            
            s=GetSpikes('output','full');
            a=1;
            %
            %             IncludedIndex=[];ExcludedIndex=[];
            %             try load('LFPData/InfoLFP.mat','InfoLFP');end
            
            for i=1:18
                for j=1:200
                    try
                        if length(find(s(:,2)==i&s(:,3)==j))>1
                            S{a}=tsd(s(find(s(:,2)==i&s(:,3)==j),1)*1E4,s(find(s(:,2)==i&s(:,3)==j),1)*1E4);
                            TT{a}=[i,j];
                            cellnames{a}=['TT',num2str(i),'c',num2str(j)];
                            
                            W{a} = GetSpikeWaveforms([i j]);
                            
                            %                             try
                            %                                 if sum(ismember(tetrodeChannels{i},InfoLFP.channel))~=0
                            %                                     IncludedIndex=[IncludedIndex,a];
                            %                                 else
                            %                                     ExcludedIndex=[ExcludedIndex,a];
                            %                                 end
                            %                             end
                            a=a+1;
                        end
                    end
                end
            end
            
            try
                S=tsdArray(S);
            end
            
            %             if ~isempty(ExcludedIndex)
            %                 disp('Some neurons do not belong to this mouse ?')
            %                 ButtonName=questdlg('Separate SpikeData ?','Save all spikes','Save two different files','Save two different files');
            %             else
            %                 ButtonName='Save all spikes';
            %             end
            %             switch ButtonName
            %                 case 'Save all spikes'
            save SpikeData -v7.3 S s TT cellnames tetrodeChannels
            save Waveforms -v7.3 W cellnames
            disp('Done')
            %
            %                 case 'Save two different files'
            %                     savS=S;
            %                     savTT=TT;
            %                     savcellnames=cellnames;
            %                     savW=W;
            %
            %                     % included spikes
            %                     S=savS{IncludedIndex};
            %                     TT=savTT{IncludedIndex};
            %                     cellnames=savcellnames{IncludedIndex};
            %                     W=savW{IncludedIndex};
            %
            %                     disp('... saving Spikes from this mouse')
            %                     save SpikeData -v7.3 S s TT cellnames tetrodeChannels
            %                     save Waveforms -v7.3 W cellnames
            %
            %                     % excluded spikes
            %                     S=savS{ExcludedIndex};
            %                     TT=savTT{ExcludedIndex};
            %                     cellnames=savcellnames{ExcludedIndex};
            %                     W=savW{ExcludedIndex};
            %
            %                     disp('... saving Spikes from the other mouse in SpikeData_2 and Waveforms_2')
            %                     save SpikeData_2 -v7.3 S s TT cellnames tetrodeChannels
            %                     save Waveforms_2 -v7.3 W cellnames
            %             end
            
        catch
            disp('problem for spikes')
        end
        
    else
        S={};S=tsdArray(S);cellnames={};
        save SpikeData S cellnames
        disp('SpikeData has been saved with empty S')
    end
end
%% ------------------------------------------------------------------------
%------------------------- LFP --------------------------------------------
%--------------------------------------------------------------------------
if 1
    disp(' '); disp('LFP Data')
    
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

disp(' ');
disp('behavResources')
try
    load behavResources
    evt;
    disp('Done')
catch
    
    if setCu==0
        SetCurrentSession
        SetCurrentSession('same')
        setCu=1;
    end
    
    evt=GetEvents('output','Descriptions');
    if strcmp(evt{1},'0'), evt=evt(2:end);tpsEvt=tpsEvt(2:end);end
    
    tpsdeb={}; tpsfin={};nameSession={};
    for i=1:length(evt)
        tpsEvt{i}=GetEvents(evt{i});
        if evt{i}(1)=='b'
            tpsdeb=[tpsdeb,tpsEvt{i}];
            nameSession=[nameSession,evt{i}(14:end)];
        elseif evt{i}(1)=='e'
            tpsfin=[tpsfin,tpsEvt{i}];
        end
    end
    
    
    save behavResources evt tpsEvt tpsdeb tpsfin nameSession 
    
    
    
    %--------------------------------------------------------------------
    %------- Epochs --------
    
    nameEpochs=['Wake','Sleep','Rest','Explo',InjectionName,'Pre'];
    for injN=1:length(nameEpochs), StartEp{injN}=[]; StopEp{injN}=[];end
    
    PreInj=1;
    for i=1:length(nameSession)
        for injN=1:length(nameEpochs)-1
            if isempty(strfind(nameSession{i},nameEpochs{injN}))==0
                StartEp{injN}=[StartEp{injN};tpsdeb{i}*1E4];
                StopEp{injN}=[StopEp{injN};tpsfin{i}*1E4];
                if ismember(nameEpochs{injN},InjectionName), PreInj=0;end
            end
        end
        if PreInj
            injN=length(nameEpochs);
            StartEp{injN}=[StartEp{injN};tpsdeb{i}*1E4];
            StopEp{injN}=[StopEp{injN};tpsfin{i}*1E4];
        end
    end
    
    for injN=1:length(nameEpochs)
        try
            disp([nameEpochs{injN},'Epoch'])
            eval([nameEpochs{injN},'Epoch=intervalSet(StartEp{injN},StopEp{injN});'])
            eval(['save behavResources -append ',nameEpochs{injN},'Epoch']);
        catch
            try
                eval(['t',nameEpochs{injN},'Epoch=intervalSet(StartPost{injN},StopPost{injN});'])
                disp([nameEpochs{injN},' name starts with a number.. renaming it t',nameEpochs{injN}])
                nameEpochs{injN}=['t',nameEpochs{injN}];
                eval(['save behavResources -append t',nameEpochs{injN},'Epoch']);
            catch
                disp(['Unknown problem with creation of ',nameEpochs{injN},'Epoch'])
                keyboard
            end
        end
        
    end

    save behavResources -append nameEpochs InjectionName
   
end




%% ------------------------------------------------------------------------
%----------------------- Tracking -----------------------------------------
%--------------------------------------------------------------------------

if track
    disp(' ');
    disp('BehavResources - add Tracking')
    
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
            
            save behavResources -append namePos
            
            %-------------------------------------------------------------------------------------------------------------------------------
            %-------------------------------------------------------------------------------------------------------------------------------
            
            
            th=0.95; %threshold for good tracking
            Postemp=[];
            dur={};FreqObs={};
            StartTracking=[];        StopTracking=[];

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
        
        save behavResources -append Pos Speed X Y V namePos TrackingEpoch
        disp('Done')
    end
end


%% ------------------------------------------------------------------------
%---------------- BehavResources - add Freezing ---------------------------
%--------------------------------------------------------------------------

if dofreez
    
    clear Movtsd
    disp(' ');
    disp('BehavResources - add Freezing')
    
    try
        load behavResources
        Movtsd;
        disp('Done')
        
    catch
        disp('pas de variable globale Movtsd')
        
        if setCu==0
            SetCurrentSession
            SetCurrentSession('same')
            setCu=1;
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
                clear temp
                temp=load(list(i).name);
                %eval(['load ',res,'/',list(i).name,' Movtsd'])
                eval('Freeztemp=Data(temp.Movtsd);') % eval imp to avoid an error msg 'undefined variable 'Movtsd'
                try eval('FreezEp{a}=temp.FreezeEpoch;') ; end
                Freez{a}=Freeztemp(1:end-7);
                nameFreez{a}=list(i).name;
                a=a+1;
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
                for i=1:length(evt)
                    % check that files for freezing and for concatenation have consistent names
                    if isempty(strfind(evt{i}, nameFreez{a}(end-length(nom)-16:end-4)))==0 %   17 : length of '-230-13022015-03-' + '.mat' -1
                        if evt{i}(1)=='b'
                            Ftpsdeb{a}=tpsEvt{i};
                        elseif evt{i}(1)=='e'
                            Ftpsfin{a}=tpsEvt{i};
                        end
                    end
                end
            end
            
             if ~exist('Ftpsdeb','var')
                for a=1:length(nameFreez)
                    for i=1:length(evt)
                        Possl=strfind(nameFreez{a},'-');
                        evtsl=strfind(evt{i},'-');
                        if ~isempty(Possl) && strcmp(nameFreez{a}(Possl(end-3):Possl(end)-1),evt{i}(evtsl(end-2):end))
                            if evt{i}(1)=='b'
                                Ftpsdeb{a}=tpsEvt{i};
                            elseif evt{i}(1)=='e'
                                Ftpsfin{a}=tpsEvt{i};
                            end
                        end
                    end
                end
            end
            
            save('behavResources','-append','nameFreez','Ftpsdeb','Ftpsfin')
            
            %-------------------------------------------------------------------------------------------------------------------------------
            %-------------------------------------------------------------------------------------------------------------------------------
            
            Freeztemp=[];FreezEptemp=[];
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
                    
                    try FreezEptemp=[FreezEptemp;[Start(FreezEp{i}),Stop(FreezEp{i})]+Ftpsdeb{i}];end
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
            
            try 
                FreezEpoch=intervalSet(FreezEptemp(:,1),FreezEptemp(:,2));
                disp('Adding FreezEpoch to behavResources.mat')
                save('behavResources','-append','FreezEpoch')
            end
            save('behavResources','-append','Movtsd')
            disp('Done')
            
        else
            disp('problem add freezing')
        end
    end
end


%% ------------------------------------------------------------------------
%------------- Get Accelerometer info from INTAN data ---------------------
%--------------------------------------------------------------------------

if doaccelero
    try
        load('behavResources.mat','MovAcctsd')
        Range(MovAcctsd); disp('Done')
    catch
        disp(' '); disp('Get Accelerometer info from INTAN data')
        cha=InfoLFP.channel(strcmp(InfoLFP.structure,'Accelero'));
        if isempty(cha)
            disp('No Accelero found in InfoLFP.mat')
            disp('Get accelero LFP.mat')

            [listfile,pathffile]=uigetfile('*.*','Get accelero LFP.mat','MultiSelect','on');
            if listfile==0
                 disp('skip')
                 doaccelero=0;
            else
                clear X Y Z
                disp('... Loading LFP.mat (wait!)')
                X=load([pathffile,listfile{1}],'LFP');
                Y=load([pathffile,listfile{2}],'LFP');
                Z=load([pathffile,listfile{3}],'LFP');
            end

        else
            clear X Y Z
            disp('... Loading LFP.mat (wait!)')
            X=load(['LFPData/LFP',num2str(cha(1)),'.mat'],'LFP');
            Y=load(['LFPData/LFP',num2str(cha(2)),'.mat'],'LFP');
            Z=load(['LFPData/LFP',num2str(cha(3)),'.mat'],'LFP');
        end
        
        if doaccelero
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
            if dofreez
                YL=ylim; hold on, plot(Range(Movtsd,'s'),rescale(Data(Movtsd),YL(1),YL(2)),'r');
                legend({'MovAcctsd','Movtsd'})
                ButtonName=questdlg('Use MovAcctsd for sleepscoringML ?','MovAcctsd or Movtsd','MovAcctsd','Movtsd','MovAcctsd');
                switch ButtonName
                    case 'MovAcctsd'
                        useMovAcctsd=1;
                    case 'Movtsd'
                        useMovAcctsd=0;
                end
            else
                legend('MovAcctsd')
                useMovAcctsd=1;
            end
            xlabel('Time (s)'); ylabel('abs(diff(X^2+Y^2+Z^2))');
                
            save('behavResources','MovAcctsd','useMovAcctsd','-append')
            disp('Done')
        end
    end
end

%% ------------------------------------------------------------------------
%---------- Get Digital Input from INTAN - add to BehavResources ----------
%--------------------------------------------------------------------------

if dodigitalin
    if setCu==0
        SetCurrentSession
        SetCurrentSession('same')
        setCu=1;
    end
    global DATA
    
    disp(' ');disp('Get digitalin.dat')
    [listfile,pathffile]=uigetfile('*.*','Get digitalin.dat','MultiSelect','on');
    if listfile==0
        disp('skip')
    else
        fileinfo=dir([pathffile,listfile]);
        num_samples=(fileinfo.bytes/2);
        fid=fopen([pathffile,listfile],'r');
        digital_data=fread(fid,num_samples,'uint16');
        fclose(fid);
        
        tps=[1:length(digital_data)]*1E4/DATA.rates.wideband;
        DIGtsd=tsd(tps,digital_data);
        for i=1:16
            ep1=thresholdIntervals(DIGtsd,i-0.5,'Direction','Above');
            ep2=thresholdIntervals(DIGtsd,i+0.5,'Direction','Below');
            ep=and(ep1,ep2);
            
            if ~isempty(Start(ep))
                disp(['saving DIG',num2str(i),' in behavResources.mat'])
                eval(['DIG',num2str(i),'=ts(Start(ep));'])
                eval(['save behavResources -append DIG',num2str(i)])
            end
        end
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
