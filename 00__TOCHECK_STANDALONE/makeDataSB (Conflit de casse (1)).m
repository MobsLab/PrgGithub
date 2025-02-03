%makeDataIntan

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
                            a=a+1;
                        end
                    end
                    
                end
            end
            
            try
                S=tsdArray(S);
            end
            
            
            
            %save SpikeData S s TT W cellnames
            
            save SpikeData -v7.3 S s TT cellnames
            save Waveforms -v7.3 W cellnames
            
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

if 1
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

if Events
    [FileName,PathName,FilterIndex] = uigetfile('*.evt','Select Event Files','MultiSelect','on');
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

            save behavResources -Append AllEvents 










