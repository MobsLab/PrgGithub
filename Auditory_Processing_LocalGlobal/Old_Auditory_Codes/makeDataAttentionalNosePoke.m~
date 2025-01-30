%makeDataNosePoke


% Initiation
spk=1;
setCu=0;
res=pwd;
FreqVideo=15;
cd(res)

clear S
clear LFP
clear TT
clear cellnames
clear lfpnames

%--------------------------------------------------------------------------
%--------------------------- Spikes ---------------------------------------
%--------------------------------------------------------------------------

spk=1;

if spk
    
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
% ------------------------------------------------------------------------
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
        % ---------------------------------------------------------------------
        if setCu==0
            SetCurrentSessionAttentionalTemp
            SetCurrentSessionAttentionalTemp('same')
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
                    SetCurrentSessionAttentional4
                    SetCurrentSessionAttentional4('same')
% ---------------------------------------------------------------------
% ---------------------------------------------------------------------

