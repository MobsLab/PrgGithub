%makeDataBulbe


%% Initiation
warning off
res=pwd;
try, setCu; catch, setCu=0;end

defaultvalues={'yes','yes','yes','yes','yes','30','{''POST''}'};
try
    load('makedataBulbeInputs')
    if length(defaultvalues)==length(answer),defaultvalues=answer;end
end
answer = inputdlg({'SpikeData (yes/no)','video Tracking','video Freezing','INTAN accelero',...
    'INTAN Digital input','Freq video','Session/InjectionName'},'Inputs for makeData',1,defaultvalues);

spk=strcmp(answer{1},'yes');
dotrack=strcmp(answer{2},'yes');
dofreez=strcmp(answer{3},'yes');
doaccelero=strcmp(answer{4},'yes');
dodigitalin=strcmp(answer{5},'yes');redodigitalin=strcmp(answer{5},'redo');
FreqVideo=str2double(answer{6});
eval(['InjectionName=',answer{7},';'])

save makedataBulbeInputs answer

clear S LFP TT cellnames lfpnames

%% ------------------------------------------------------------------------
%----------------------- Spikes -------------------------------------------
%--------------------------------------------------------------------------

disp(' '); disp('SpikeData')
try
    load([res,'/SpikeData'])
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
            
            for i=1:20
                for j=1:200
                    try
                        if length(find(s(:,2)==i&s(:,3)==j))>1
                            S{a}=tsd(s(find(s(:,2)==i&s(:,3)==j),1)*1E4,s(find(s(:,2)==i&s(:,3)==j),1)*1E4);
                            TT{a}=[i,j];
                            cellnames{a}=['TT',num2str(i),'c',num2str(j)];
                            
                            W{a} = GetSpikeWaveforms([i j]);
                            disp(['Cluster : ',cellnames{a},' > done'])
                            a=a+1;
                        end
                    end
                end
                disp(['Tetrodes #',num2str(i),' > done'])
            end
            
            try
                S=tsdArray(S);
            end
            
           
            save SpikeData -v7.3 S s TT cellnames tetrodeChannels
            save Waveforms -v7.3 W cellnames
            disp('Done')
           
            
        catch
            disp('problem for spikes'); keyboard
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
        load LFPData
        Range(LFP{1});
        FragmentLFP=input('LFPData.mat exists, do you want to fragment LFPData.mat in folder LFPData (y/n) ? ','s');
    catch
        FragmentLFP='y';
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
            
            for i=1:length(InfoLFP.channel)
                if ~exist(sprintf('LFPData/LFP%d.mat',InfoLFP.channel(i)),'file')
                    if setCu==0
                        SetCurrentSession
                        SetCurrentSession('same')
                        setCu=1;
                    end
                    
                    disp(['loading and saving LFP',num2str(InfoLFP.channel(i)),' in LFPData...']);
                    LFP_temp=GetLFP(InfoLFP.channel(i));
                    LFP=tsd(LFP_temp(:,1)*1E4,LFP_temp(:,2));
                    if exist('reverseData','var'), LFP=tsd(LFP_temp(:,1)*1E4,-LFP_temp(:,2));end
                    save([res,'/LFPData/LFP',num2str(InfoLFP.channel(i))],'-v7.3','LFP');
                    clear LFP LFP_temp
                end
            end
            
            disp('Done')
        catch
            disp('problem for lfp')
            keyboard
        end
    else
        disp('Done')
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
    tpsdeb={}; tpsfin={};nameSession={};tpsEvt={};
    try
        if strcmp(evt{1},'0'), evt=evt(2:end);end

        for i=1:length(evt)
            
            tpsEvt{i}=GetEvents(evt{i});
            if evt{i}(1)=='b'
                tpsdeb=[tpsdeb,tpsEvt{i}];
                nameSession=[nameSession,evt{i}(14:end)];
            elseif evt{i}(1)=='e'
                tpsfin=[tpsfin,tpsEvt{i}];
            end
        end
    catch
        % manual definition  evt (Julie)  SALE !
        disp('manual redefinition of evt, ckeck ouputs')
        res=pwd;
        indMouse=strfind(res,'Mouse');
        MouseNb=res(indMouse+6:indMouse+8);
        %MouseNb=res(51:53);
        Date=res(indMouse+10:indMouse+17);
        evt={};
        evt{1,1}=['beginning of FEAR-Mouse-' MouseNb '-' Date ];
        evt{1,2}=['end of FEAR-Mouse-' MouseNb '-' Date ];
        load(['FEAR-Mouse-' MouseNb '-' Date '.mat'],'PosMat')
        
        tpsdeb{1}=0;
        tpsfin{1}=PosMat(end,1);
        tpsEvt={tpsdeb{1} tpsfin{1}};
        %evt.time{1,1}=0;
        %evt.time{1,2}=PosMat(end,1);
        nameSession{1}=evt{1}(14:end);
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
            disp(['... ',nameEpochs{injN},'Epoch: (',num2str(floor(sum(StopEp{injN}-StartEp{injN})/1E4)),'s)'])
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
%---------------- BehavResources - Tracking and Freezing ------------------
%--------------------------------------------------------------------------

if dofreez || dotrack
    
    clear Movtsd
    disp(' ');
    disp('BehavResources - add tracking and Freezing')
    
    try
        load behavResources
        if dotrack, Pos;end
        if dofreez, Movtsd;end
        disp('Done')
        
    catch
        
        %------------------------- INITIATE -------------------------------
        if setCu==0
            SetCurrentSession
            SetCurrentSession('same')
            setCu=1;
        end
        
        global DATA
        filPos=[DATA.session.basename,'.pos'];
        
        
        clear Ftpsdeb
        clear Ftpsfin
        try
            a=1;
            for i=1:length(evt)
                % get name of recording sessions
                if evt{i}(1)=='b'
                    Ftpsdeb{a}=tpsEvt{i};
                    nameSess{a}=evt{i}(14:end);

                    Ftpsfin{a}=tpsEvt{strcmp(['end of ',nameSess{a}],evt)};
                    a=a+1;
                end
            end
        catch
            nameSess={};
            disp('pb with nameSess')
        end
        
        
 
        %------------------------------------------------------------------
        
        disp('Indicate Dir of tracking/freezing files')
        dire=uigetdir('*','Indicate Dir of tracking/freezing files');
        list=dir(dire);

        EpTracking=[];doIMAonREAL=1;
        Pos=[]; Freezt=[]; FreezEp=[];
        
        figure('Color',[1 1 1]); numF=gcf;
        for a=1:length(nameSess)
            
            for i=1:length(list)
                if (~isempty(strfind(nameSess{a},list(i).name(1:end-4))) || ~isempty(strfind(list(i).name(1:end-4),nameSess{a})) ) ...
                        && (length(list(i).name)>3 && strcmp(list(i).name(end-3:end),'.mat'))
                    
                    clear temp
                    try temp=load([dire,'/',list(i).name]); catch, temp=load([dire,'\',list(i).name]);end
                    
                    tps=Ftpsdeb{a}:1/FreqVideo:Ftpsfin{a};
                    
                    % A CHANGER DES L'HOMOGENISATION
                    try 
                        eval('FreezEp=[FreezEp;[Start(temp.FreezeEpoch,''s''),Stop(temp.FreezeEpoch,''s'')]+ Ftpsdeb{a}];');
                        doIMAonREAL=0;
                    end
                    
                    
                    %------- position --------
                    if dotrack
                        eval('Postemp=temp.PosMat;')
                        Postemp(:,1)=Postemp(:,1)+Ftpsdeb{a};
                        Postemp(Postemp(:,1)>Ftpsfin{a},:)=[];
                        Postemp(isnan(Postemp(:,2)),:)=[];
                        
                        X=interp1(Postemp(:,1),Postemp(:,2),tps);
                        Y=interp1(Postemp(:,1),Postemp(:,3),tps);
                        
                        if doIMAonREAL
                           X=X./temp.Ratio_IMAonREAL;
                           Y=Y./temp.Ratio_IMAonREAL;
                        end
                        
                        PosC=[tps',X',Y'];
            
                        subplot(2,2,1:2),hold on
                        plot(X,Y); title(list(i).name); 
                    end
                   
                    
                    %------- Freezing --------
                    if dofreez
                        % eval imp to avoid an error msg 'undefined variable 'Movtsd'
                        try
                            eval('Freeztemp=[Range(temp.Movtsd,''s'')+ Ftpsdeb{a}, Data(temp.Movtsd)];')
                        catch
                            eval('Freeztemp=[Range(temp.Imdifftsd,''s'')+ Ftpsdeb{a}, Data(temp.Imdifftsd)];')
                        end
                        Freeztemp(Freeztemp(:,1)>Ftpsfin{a},:)=[];
                        F=interp1(Freeztemp(:,1),Freeztemp(:,2),tps);
                        
                        if doIMAonREAL
                           F=F./(temp.Ratio_IMAonREAL*temp.Ratio_IMAonREAL);
                        end
                        Freezt=[Freezt;[tps',F']];
                        
                        subplot(2,2,3:4),hold on
                        plot(tps,F); title('freezing'); 
                        try
                            rtp=Restrict(tsd(tps'*1E4,F'),intervalSet(Start(temp.FreezeEpoch)+ 1E4*Ftpsdeb{a},Stop(temp.FreezeEpoch)+ 1E4*Ftpsdeb{a}));
                            plot(Range(rtp,'s'),Data(rtp),'r.')
                        end
                        xlim([Ftpsdeb{a},Ftpsfin{a}]); legend({'Movtsd','FreezeEpoch'})
                    end
                    
                    %------- Epochs --------
                    if dotrack
                        EpTracking=[EpTracking;[min(Postemp(:,1)),max(Postemp(:,1))]*1E4];
                    else
                        EpTracking=[EpTracking;[min(Freeztemp(:,1)),max(Freeztemp(:,1))]*1E4];
                    end
                    
                    
                    %------- remove artefacts -
                    rep=input([list(i).name,' ok? (y/n) : '],'s');
                    while rep=='n'
                        if dotrack
                            Art=input('Speed limit for artefacts (default value 100):');
                            [PosC,speed]=RemoveArtifacts([tps',X',Y'],Art);
                            
                            if length(PosC)==length(tps)-1
                                PosC=[PosC;PosC(end,:)];
                                speed=[speed;speed(end)];
                            elseif length(PosC)==length(tps)-2
                                PosC=[PosC(1,:);PosC;PosC(end,:)];
                                speed=[speed(1);speed;speed(end)];
                            end
                            
                            subplot(2,2,1),hold on
                            plot(X,Y), plot(PosC(:,2),PosC(:,3),'r')
                            title(list(i).name); legend({'raw','corrected'})
                            subplot(2,2,2),hist(speed,100);title('speed')
                            
                            rep=input('              ok? (y/n) : ','s');
                        else
                            disp('Keyboard for manual correction of freezing')
                            keyboard;
                            rep='y';
                        end
                    end
                    
                    if dotrack, Pos=[Pos;PosC];end
                end
            end
        end
        
        
        %----------------------- terminate --------------------------------
        if doIMAonREAL, disp('data has been corrected with Ratio_IMAonREAL');end
        TrackingEpoch=intervalSet(EpTracking(:,1),EpTracking(:,2));
        save('behavResources','-append','nameSess','Ftpsdeb','Ftpsfin','TrackingEpoch','doIMAonREAL')
        
        if dotrack
%             for i=1:length(Pos)-1
%                 Vx = (Pos(i,2)-Pos(i+1,2));
%                 Vy = (Pos(i,3)-Pos(i+1,3));
%                 Vitesse(i) = sqrt(Vx^2+Vy^2);
%             end
% replaced by a vestorial computation th e 27.08.2015
            Vx = diff(Pos(:,2));
            Vy = diff(Pos(:,3));
            Vitesse = (Vx.^2+Vy.^2).^0.5;
            
            Speed=SmoothDec(Vitesse',1);
%             X=tsd(tps*1E4,Pos(:,2));
%             Y=tsd(tps*1E4,Pos(:,3));
%             V=tsd(tps*1E4,[Speed;Speed(end)]);
            X=tsd(Pos(:,1)*1E4,Pos(:,2));
            Y=tsd(Pos(:,1)*1E4,Pos(:,3));
            V=tsd(Pos(:,1)*1E4,[Speed;Speed(end)]);
            
            save('behavResources','-append','Pos','X','Y','V');
        end
        
        % --------------
        if dofreez
            Movtsd=tsd(Freezt(:,1)*1E4,Freezt(:,2));
            save('behavResources','-append','Movtsd');
        end
        
        % --------------
        try
            FreezeEpoch=intervalSet(FreezEp(:,1)*1E4,FreezEp(:,2)*1E4);
            disp('Adding FreezEpoch to behavResources.mat')
            save('behavResources','-append','FreezeEpoch')
        end
        
        %------------------------------------------------------------------
        %-------------------- SAVE .pos -----------------------------------
        
        if 0
            figure, plot(Range(X,'s'),Data(X)); hold on, plot(Range(Y,'s'),Data(Y),'g');
            tlim=input('Give [tstart,tend] of tracking epoch (s): ');
            TrackingEpoch=intervalSet(tlim(1)*1E4,tlim(2)*1E4);
            X=Restrict(X,TrackingEpoch); Y=Restrict(Y,TrackingEpoch); 
            try FreqVideo; catch,FreqVideo=30;end
            tps=tlim(1):1/FreqVideo:tlim(2);
            ts_tps=ts(tps*1E4);
            PosResamp=Data(Restrict(X,ts_tps));
            PosResamp(:,2)=Data(Restrict(Y,ts_tps));
            tps_deb=0:1/FreqVideo:tlim(1); 
            if length(tps_deb)>1
                PosResamp=[nan(length(tps_deb)-1,2);PosResamp];
            end
            hold on, plot([tps_deb,tps(2:end)],PosResamp(:,1),'k'); hold on, plot([tps_deb,tps(2:end)],PosResamp(:,2),'c');
            ImageRef=double(ref); mask=double(mask);
            save('behavResources','-append','Pos','X','Y','V','TrackingEpoch','mask','ImageRef');
        else
            PosResamp=Pos;
        end
        
        try filPos; catch SetCurrentSession; global DATA;  filPos=[DATA.session.basename,'.pos'];end
        disp(['... writing ',filPos])
        file=fopen(filPos,'w');
        for j=1:size(PosResamp,1)
            fprintf(file,'%f\t',PosResamp(j,1));
            fprintf(file,'%f\n',PosResamp(j,2));
        end
        fclose(file);
        
        disp('Done')
    end
end


%% ------------------------------------------------------------------------
%------------- Get Accelerometer info from INTAN data ---------------------
%--------------------------------------------------------------------------

if doaccelero
    disp(' ');
    disp('Get INTAN Accelerometer')
    try
        load('behavResources.mat','MovAcctsd','MovAccSmotsd')%Julie
        %load('behavResources.mat','MovAcctsd')
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
            MovAcctsd=tsd(Rg(1:25:end),double(abs([0;diff(Acc(1:25:end))])));
            
            figure('Color',[1 1 1]), plot(Range(MovAcctsd,'s'),abs(Data(MovAcctsd)))
            title('MovAcctsd from INTAN Accelerometer'); xlim([0 max(Range(MovAcctsd,'s'))]);
            if dofreez
                Movtsd=tsd(double(Range(Movtsd)),double(Data(Movtsd)));
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
            
            if dofreez % Julie 28.10.2016
                th_immob_Acc=3E7;% see EstablishAThresholdForFreezingFromAcceleration.m
                th_2merge_FreezAcc=0.5;
                thtps_immob_Acc=2;
                SmoothFactorAcc=3;
                MovAccSmotsd=tsd(Range(MovAcctsd),SmoothDec(Data(MovAcctsd),SmoothFactorAcc));
                FreezeAccEpoch=thresholdIntervals(MovAccSmotsd,th_immob_Acc,'Direction','Below');
                FreezeAccEpoch=mergeCloseIntervals(FreezeAccEpoch,th_2merge_FreezAcc*1E4);
                FreezeAccEpoch=dropShortIntervals(FreezeAccEpoch,thtps_immob_Acc*1E4);
                disp('Saving FreezeAccEpoch')
                save('behavResources','MovAccSmotsd','FreezeAccEpoch','th_immob_Acc','th_2merge_FreezAcc','thtps_immob_Acc','SmoothFactorAcc','-append')
                
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
    disp(' '); disp('Get INTAN digital inputs')
    temp=load('behavResources.mat'); ok=0; i=1;
    while ok==0 && i<20
        try eval(['temp.DIG',num2str(i),';']), ok=1;catch, i=i+1;end
    end
elseif redodigitalin
    disp(' '); disp('Get INTAN digital inputs - erasing previous if exists')
    ok=0;
else
    ok=2;
end

if ok==0
    if setCu==0
        SetCurrentSession
        SetCurrentSession('same')
        setCu=1;
    end
    global DATA
    
    disp('... Get digitalin.dat')
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
        disp('Done')
    end
elseif ok==1
    disp('Done (to force this step again, enter ''redo'' in makeDataInputs')
    
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
%------------------------ Do ChannelToAnalyse -----------------------------
%--------------------------------------------------------------------------
try
    Structure={'Bulb_sup','Bulb_deep','dHPC_sup','dHPC_deep','dHPC_rip','PaCx_sup','PaCx_deep','PFCx_sup','PFCx_deltasup','PFCx_deep','IL','TT','Amyg','PiCx'};
    disp(' ');
    dodisp=0;
    for stru=1:length(Structure)
        try
            temp=load(['ChannelsToAnalyse/',Structure{stru},'.mat']);
            if isempty(temp.channel), defaultansw{stru}='[ ]';else, defaultansw{stru}=num2str(temp.channel);end
            dodisp=1;
        catch
            defaultansw{stru}='NaN';
        end
    end
    if dodisp, disp('ChannelsToAnalyse already defined for some channels, check and add');end
    answer = inputdlg(['Exemple undefined','Example empty',Structure],'ChannelToAnalyse',1,['NaN','[ ]',defaultansw]);
    
    if ~exist('ChannelsToAnalyse','dir'), mkdir('ChannelsToAnalyse');end
    for stru=1:length(Structure)
        channel=str2double(answer{stru+2});
        if strcmp(answer{stru+2},'[ ]'), channel=[];end
        if (~isempty(channel) && ~isnan(channel)) || isempty(channel)
            disp(['Saving ch',answer{stru+2},' for ',Structure{stru},' in ChannelsToAnalyse'])
            save(['ChannelsToAnalyse/',Structure{stru},'.mat'],'channel');
        end
    end
end

%% ------------------------------------------------------------------------
%------------------------ sleepscoringML ----------------------------------
%--------------------------------------------------------------------------

disp(' ');disp('---------------------------');
disp('Run sleepscoringML');
clear LFP
try
    temp=load('StateEpoch.mat','SWSEpoch','REMEpoch');
    temp.REMEpoch; temp.SWSEpoch;
    disp('Done')
catch
    sleepscoringML
end

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
