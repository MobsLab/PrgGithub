%makeDataIntan
clear all
if ~exist('Pathway','var')
    Pathway=pwd;
end
if ~exist('dispAllInfo','var')
    dispAllInfo=0;
end

% Initiation
disp('  ')
DualRecording=input('How many mice were recorded ?     ');
disp('  ')
disp('  ')
lfp=input('Do you want to generate LFPData ?  (yes=1/no=0)    ');
disp('  ')
disp('  ')
spk=input('Do you want to generate SpikeData ?  (yes=1/no=0)    ');
disp('  ')
Events=input('Do you want to generate EventData ?  (yes=1/no=0)    ');
disp('  ')


setCu=0;
res=pwd;
FreqVideo=15;
cd(res)

clear S
clear LFP
clear TT  % n° tetrode
clear cellnames
clear lfpnames



% ------------------------------------------------------------------------
%------------------------- LFP --------------------------------------------
%--------------------------------------------------------------------------


if lfp==1
    
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
            
            if DualRecording==1
                
                if ~exist([Pathway,'/LFPData'],'dir'),
                    mkdir([Pathway,'/LFPData']);
                end
                
                InfoLFP=listLFP_to_InfoLFP_ML(res);
                %InfoLFP=listLFP_to_InfoLFP_GL(res);
                
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
                    disp(['loading and saving LFP',num2str(InfoLFP.channel(i)),' in LFPData','...']);
                    LFP=tsd(LFP_temp(:,1)*1E4,LFP_temp(:,2));
                    
                    n=InfoLFP.channel(i);
                    save([res,'/LFPData','/LFP',num2str(n)],'LFP');
                    clear LFP LFP_temp
                    save([res,'/LFPData','/InfoLFP'],'InfoLFP');
                end
                
            elseif ~DualRecording==1
                
                MiceNumber=input('Enter names of instantaneous recorded mice:  ');
                for a=1:length(MiceNumber)
                    if ~exist([Pathway,'/LFPData',num2str(MiceNumber(a))],'dir'),
                        mkdir([Pathway,'/LFPData',num2str(MiceNumber(a))]);
                    end
                    
                    InfoLFP=listLFP_to_InfoLFP_GL(res);
                    
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
                        disp(['loading and saving LFP',num2str(InfoLFP.channel(i)),' in LFPData',num2str(MiceNumber(a)),'...']);
                        LFP=tsd(LFP_temp(:,1)*1E4,LFP_temp(:,2));
                        if i==1
                            Tmax=max(Range(LFP,'s'));
                        end
                        n=InfoLFP.channel(i);
                        save([res,'/LFPData',num2str(MiceNumber(a)),'/LFP',num2str(n)],'LFP');
                        clear LFP LFP_temp
                        save([res,'/LFPData',num2str(MiceNumber(a)),'/InfoLFP'],'InfoLFP');
                    end
                    
                end
            end
            
            disp('LFPData Done')
        end
    end
end


%--------------------------------------------------------------------------
%--------------------------- Spikes ---------------------------------------
%--------------------------------------------------------------------------

if spk==1
    try
        load SpikeData
        S;
        
    catch
        try
            SetCurrentSession
            SetCurrentSession('same')
            setCu=1;
            
            s=GetSpikes('output','full');
            a=1;
            for i=1:50
                for j=1:600
                    try
                        if length(find(s(:,2)==i&s(:,3)==j))>1
                            S{a}=tsd(s(find(s(:,2)==i&s(:,3)==j),1)*1E4,s(find(s(:,2)==i&s(:,3)==j),1)*1E4);
                            TT{a}=[i,j];
                            cellnames{a}=['TT',num2str(i),'c',num2str(j)];
                            W{a} = GetSpikeWaveforms([i j]);
                            tempW{a}=mean(squeeze( W{a}(:,elec,:)));
                            a=a+1;
                        end
                    end
                    
                end
            end
            
            try
                S=tsdArray(S);
            end
            
            %% Get WF information - SB 20/04/2016
            
            %save SpikeData S s TT W cellnames
            
            save SpikeData -v7.3 S s TT cellnames
            save Waveforms -v7.3 W cellnames
            clear W
            W=tempW;
            clear tempW
            for ww=1:length(W)
                for elec=1:4
                    try
                        Peak{ww}(elec)=min(W{ww}(elec,:));
                    end
                end
                [~,BestElec{ww}]=min(Peak{ww});
                Params{ww}(1)=length(Data(S{numNeurons(ww)}))/Tmax; % Get the FR
                WaveToUse=W{ww}(BestElec{ww},:);
                WaveToUseResample = resample(WaveToUse,300,1);
                % Get half width using null derivative
                [~,valmin]=min(WaveToUseResample);
                
                DD=diff(WaveToUseResample);
                diffpeak=find(DD(valmin:end)==max(DD(valmin:end)))+valmin;
                DD=DD(diffpeak:end);
                valmax=find(DD<max(abs(diff(WaveToUseResample)))*0.01,1,'first')+diffpeak;
                Params{ww}(2)=(valmax-valmin)*5e-5/300;
                [~,valmin2]=min(WaveToUseResample);
                WaveToUseResample=WaveToUseResample(valmin2:end);
                valzero=find(WaveToUseResample>0,1,'first');
                WaveToCalc=WaveToUseResample(valzero:end);
                Params{ww}(3)=sum(abs(WaveToCalc));
                
            end
            save('MeanWaveform.mat','BestElec','Peak','Params','W')
            
            
            %% Check for monosynaptic interactions
            for sp1=1:length(numNeurons)-1
                sp1
                for sp2=sp1+1:length(numNeurons)
                    
                    [H0,B] = CrossCorr(Range(S{numNeurons(sp1)}),Range(S{numNeurons(sp2)}),1,100);
                    Lim(1)=mean(H0([1:40,70:end]))+6*std(H0([1:40,70:end])); %be more demanding for excitation
                    Lim(2)=mean(H0([1:40,70:end]))-4*std(H0([1:40,70:end]));
                    bIx = find(B>=Window(1) & B<=Window(2));
                    h1 = H0(bIx);
                    bIx = find(B>=-Window(2) & B<=-Window(1));
                    h2 = H0(bIx);
                    h=[h1,h2];
                    
                    if sum(sum(h>Lim(1))>0 | sum(h<Lim(2))>0)>0
                        
                        [H0,Hm,HeI,HeS,Hstd,B,HMaxMin] = XcJitter_SB(Range(S{numNeurons(sp1)}),Range(S{numNeurons(sp2)}),0.5,80,0.99,100);
                        [SynC,ConStr] = XcConnection_SB(H0,Hm,HeI,HeS,Hstd,B,HMaxMin,Window);
                        if (SynC(1))==-1 | abs(SynC(2))==-1
                            %                         disp('sig')
                            %                         figure
                            %                         bar(B,H0)
                            %                         hold on
                            %                         plot(B,HeI,'g','linewidth',2)
                            %                         plot(B,HeS,'g','linewidth',2)
                            %                         plot(B,HMaxMin(1,1),'r','linewidth',2)
                            %                         plot(B,HMaxMin(2,1),'r','linewidth',2)
                            %                         plot(B,HMaxMin(1,2),'b','linewidth',2)
                            %                         plot(B,HMaxMin(2,2),'b','linewidth',2)
                            %
                            %                         keyboard
                            %                         clf
                        end
                        SpikeConn(sp1,sp2)=SynC(1);
                        SpikeConn(sp2,sp1)=SynC(2);
                        
                    else
                        SpikeConn(sp1,sp2)=0;
                        SpikeConn(sp2,sp1)=0;
                    end
                end
            end
            save('SpikeConnexions.mat','SpikeConn','numNeurons')

            
        catch
            disp('problem for spikes')
            S=tsdArray({});
            save SpikeData S
        end
    end
end


% -------------------------------------------------------------------------
%----------------- Sleep scoring (with BulbInformation) -------------------
%--------------------------------------------------------------------------
disp('  ')
SS=input('Do you want to generate Sleep scoring now? (yes=1/no=0)    ');
disp('  ')

if SS==1
    BulbSleepScriptGL;
end

% -------------------------------------------------------------------------
%----------- Respiratory Information (with accelerometer) -----------------
%--------------------------------------------------------------------------
disp('  ')
Resp=input('Do you want to generate Repsiration through accelerometer? (yes=1/no=0)    ');
disp('  ')

if Resp==1
    GetRespiFromAccelerometer;
end

% -------------------------------------------------------------------------
%----------------- BehavResources -----------------------------------------
%--------------------------------------------------------------------------

if 0
    disp(' ');
    disp('behavResources')
    try
        load behavResources
        Pos;
        disp('Done')
    catch
        % -----------------------------------------------------------------
        if setCu==0
            SetCurrentSession
            SetCurrentSession('same')
            setCu=1;
        end
        
        evt=GetEvents('output','Descriptions');
        tpsdeb={}; tpsfin={};nameSession={};tpsEvt={};
        
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
        
        save behavResources evt tpsEvt tpsdeb tpsfin nameSession
        
        
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
        save behavResources -Append stim
        
        
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
    end
end

% ---------------------------------------------------------------------
% ---------------------------------------------------------------------
SetCurrentSession
SetCurrentSession('same')
% ---------------------------------------------------------------------
% ---------------------------------------------------------------------

clear AllEvents
if Events
    [FileName,PathName,FilterIndex] = uigetfile('*.evt','Select Event Files','MultiSelect','on');
    if not(iscell(FileName))
        FileName2{1}=FileName;
        FileName=FileName2;
    end
    for t=1:length(FileName)
        AllEvents{t}.Name=FileName{t}(end-6:end-4);
        disp(FileName{t}(end-6:end-4))
        AllEvents{t}.Descr=input('Describe this event');
        fid=fopen(FileName{t});
        AllEvents{t}.Data(1) = eval(strtok(fgetl(fid)));
        tline=fgetl(fid);
        while ischar(tline)
            disp(tline)
            AllEvents{t}.Data =[ AllEvents{t}.Data, eval(strtok(tline))];
            tline=fgetl(fid);
        end
    end
end
try
    save behavResources -Append AllEvents
catch
    save behavResources AllEvents
    
end









