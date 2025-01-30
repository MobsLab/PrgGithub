%makeDataNosePoke


%% Initiation
spk=1;
setCu=0;
res=pwd;
FreqVideo=15;
cd(res)

clear LFP lfpnames

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
        %try  eval(['cd(''',res,'-wideband'')']); dirnamepref=9; catch, eval(['cd(''',res,'-EIB'')']); dirnamepref=4;end
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
        
    end
end
