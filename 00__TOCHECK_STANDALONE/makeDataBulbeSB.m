%makeDataBulbeSB

clear all
%% Initiation
clear S LFP TT cellnames lfpnames

warning off
res=pwd;
try 
    setCu; 
catch
    setCu=0;
end

defaultvalues={'yes','yes','yes','yes','yes','30','{''POST''}','yes'};
if exist([cd filesep 'makedataBulbeInputs.mat'])>0
    load('makedataBulbeInputs.mat')
else
answer = inputdlg({'SpikeData (yes/no)','video Tracking','video Freezing','INTAN accelero',...
    'INTAN Digital input','Freq video','Session/InjectionName','INTAN Analog input'},'Inputs for makeData',1,defaultvalues);
end

spk=strcmp(answer{1},'yes');
if spk==1
    answer2 = inputdlg({'Do unit ID analysis?'},'WFInfo',1,{'yes'});
    spkinfo=strcmp(answer2{1},'yes');
end
dotrack=strcmp(answer{2},'yes');
dofreez=strcmp(answer{3},'yes');
doaccelero=strcmp(answer{4},'yes');
dodigitalin=strcmp(answer{5},'yes');redodigitalin=strcmp(answer{5},'redo');
if dodigitalin==1
    answerdigin = inputdlg({'Digital channel','Number of inputs'},'DigIn Info',1);
else
    answerdigin= [];
end

FreqVideo=str2double(answer{6});
eval(['InjectionName=',answer{7},';'])
doanalogin=strcmp(answer{8},'yes');
save makedataBulbeInputs answer answerdigin



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
    else
        disp('Done')
    end
end




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
            clear S
            for i=1:20
                for j=1:200
                    try
                        if length(find(s(:,2)==i&s(:,3)==j))>1
                            j
                            S{a}=tsd(s(find(s(:,2)==i&s(:,3)==j),1)*1E4,s(find(s(:,2)==i&s(:,3)==j),1)*1E4);
                            a
                            TT{a}=[i,j];
                            cellnames{a}=['TT',num2str(i),'c',num2str(j)];
                            
                            W{a} = GetSpikeWaveforms([i j]);
                            disp(['Cluster : ',cellnames{a},' > done'])
                            for elec=1:size(W{a},2)
                                tempW{a}=mean(squeeze( W{a}(:,elec,:)));
                            end
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
            disp('problem for spikes')
        end
        
    else
        S={};S=tsdArray(S);cellnames={};
        save SpikeData S cellnames
        disp('SpikeData has been saved with empty S')
    end
end



%% ------------------------------------------------------------------------
%------------- Get Accelerometer info from INTAN data ---------------------
%--------------------------------------------------------------------------

if doaccelero
    disp(' ');
    disp('Get INTAN Accelerometer')
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
            MovAcctsd=tsd(Rg(1:25:end),double(abs([0;diff(Acc(1:25:end))])));
            
            figure('Color',[1 1 1]), plot(Range(MovAcctsd,'s'),abs(Data(MovAcctsd)))
            title('MovAcctsd from INTAN Accelerometer'); xlim([0 max(Range(MovAcctsd,'s'))]);
            if dofreez
                Movtsd=tsd(double(Range(MovAcctsd)),double(Data(MovAcctsd)));
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
            
            try
                save('behavResources','MovAcctsd','useMovAcctsd','-append')
            catch
                save('behavResources','MovAcctsd','useMovAcctsd')
            end
            disp('Done')
        end
    end
end

% %% ------------------------------------------------------------------------
% %---------- Get Digital Input from INTAN - add to LFP file ----------
% %--------------------------------------------------------------------------

if dodigitalin
    if setCu==0
        SetCurrentSession
        SetCurrentSession('same')
        setCu=1;
    end
    
    %% Alternative
    chanDig=eval(answerdigin{1});
    LongFile=input('Is the file more than an hour long?');
    if LongFile==0
        LFP_temp=GetWideBandData(chanDig);
        LFP_temp=LFP_temp(1:16:end,:);
        DigIN=LFP_temp(:,2);
        TimeIN=LFP_temp(:,1);
    else
        disp('progressive loading')
        load('LFPData/InfoLFP.mat');
        load(['LFPData/LFP',num2str(InfoLFP.channel(1)),'.mat']);
        RecordingLength=max(Range(LFP,'s'));
        DigIN=[];TimeIN=[];
        
        for tt=1:ceil(RecordingLength/1000)
            disp(num2str(tt/ceil(RecordingLength/1000)))
            LFP_temp=GetWideBandData(chanDig,'intervals',[1000*(tt-1) min(1000*tt,RecordingLength)]) ;
            LFP_temp=LFP_temp(1:16:end,:);
            DigIN=[DigIN;LFP_temp(:,2)];
            TimeIN=[TimeIN;LFP_temp(:,1)];
        end
    end
       

    DigOUT=[];
    for k=0:15
        a(k+1)=2^k-0.1;
    end
    
    for k=eval(answerdigin{2}):-1:1
        DigOUT(k,:)=double(DigIN>a(k));
        DigIN(DigIN>a(k))=   DigIN(DigIN>a(k))-a(k)+0.1;
        DigTSD=tsd(TimeIN*1e4,DigOUT(k,:)');
        save(['LFPData/DigInfo',num2str(k),'.mat'],'DigTSD')
    end
    
end

% %% ------------------------------------------------------------------------
% %---------- Get Digital Input from INTAN - add to LFP file ----------
% %--------------------------------------------------------------------------

if doanalogin
    if setCu==0
        SetCurrentSession
        SetCurrentSession('same')
        setCu=1;
    end
    
    %% Alternative
    chanAnlg=input('Please Give analog Channel')
    LFP_temp=GetWideBandData(chanAnlg);
    LFP_temp=LFP_temp(1:16:end,:);
    AnlgTSD=tsd(LFP_temp(:,1)*1e4,LFP_temp(:,2));
    save('AnalogInfo.mat','AnlgTSD')
end



%% ------------------------------------------------------------------------
%------------- GetTimeOfDataRecordingML - add to BehavResources -----------
%--------------------------------------------------------------------------

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
        
    try
        save behavResources -append evt tpsEvt tpsdeb tpsfin nameSession 
    catch
        save behavResources evt tpsEvt tpsdeb tpsfin nameSession 
    end
end

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
%
%% ------------------------------------------------------------------------
%------------------------ Do ChannelToAnalyse -----------------------------
%--------------------------------------------------------------------------
try
    Structure={'Bulb_sup','Bulb_deep','dHPC_sup','dHPC_deep','dHPC_rip','PaCx_sup','PaCx_deep','PFCx_sup','PFCx_deltasup','PFCx_deep','Amyg','PiCx','InsCx','TaeniaTecta','EMG','EKG'};
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


