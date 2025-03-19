function AnalyseDeltaDelay2016




%% 1 -  Determine Delta occurence during all experiments
smo=1;
figure('color',[1 1 1])
plo=1;
for mouse=[243 244 251 252 293 294 296];
    
    % -----------------------------
    % Basal Days Analysis
    % -----------------------------
    Dir=PathForExperimentsDeltaSleep2016('Basal');
    disp(' ')
    disp('**********************************************************************************************')
    Dir=RestrictPathForExperiment(Dir,'nMice',mouse);
    disp('**********************************************************************************************')
    disp(' ')
    
    % individual value for all days
    a=1;
    for i=1:length(Dir.path)
        disp(' ')
        disp('****************************************************************')
        eval(['cd(Dir.path{',num2str(i),'}'')'])
        disp(pwd)
        
        clear tDelta
        load newDeltaPFCx
        Dpfc=ts(tDelta);
        
        d=diff(Range(Dpfc,'s'));
        [h{a},b]=hist(d,[-0.01:0.02:3]);
        
        a=a+1;
    end
    % mean value for all days
    hold, subplot(5,7,plo)
    for i=1:(a-1)
        hold on, plot(b,h{i},'k','linewidth',1)
        hold on, axis([0 2.9 0 400])
        hold on, xlabel('time(s)'),ylabel('delta number')
        hold on, title(['Basal - mouse n#',num2str(mouse)])
    end
    for i=1:(a-1)
        H(i,:)=h{i};
    end
    hold on, subplot(5,7,plo+7*4)
    hold on, plot(b,SmoothDec(mean(H(1:(a-1),:)),smo),'k','linewidth',2)
    hold on, axis([0 2.9 0 300])
    hold on, xlabel('time(s)'),ylabel('delta number')
    hold on, title(['Basal - mouse n#',num2str(mouse)])
    clear H
    
    % -----------------------------
    % Random Tone Days Analysis
    % -----------------------------
    try
        Dir=PathForExperimentsDeltaSleep2016('RdmTone');
        disp(' ')
        disp('**********************************************************************************************')
        Dir=RestrictPathForExperiment(Dir,'nMice',mouse);
        disp('**********************************************************************************************')
        disp(' ')
        
        % individual value for all days
        a=1;
        for i=1:length(Dir.path)
            disp(' ')
            disp('****************************************************************')
            eval(['cd(Dir.path{',num2str(i),'}'')'])
            disp(pwd)
            
            clear tDelta
            load newDeltaPFCx
            Dpfc=ts(tDelta);
            
            d=diff(Range(Dpfc,'s'));
            [h{a},b]=hist(d,[-0.01:0.02:3]);
            
            a=a+1;
        end
        % mean value for all days
        hold, subplot(5,7,plo+7)
        for i=1:(a-1)
            hold on, plot(b,h{i},'b','linewidth',1)
            hold on, axis([0 2.9 0 400])
            hold on, xlabel('time(s)'),ylabel('delta number')
            hold on, title(['Rdm Tone - mouse n#',num2str(mouse)])
        end
        for i=1:(a-1)
            H(i,:)=h{i};
        end
        hold on, subplot(5,7,plo+7*4)
        if a==2
            hold on, plot(b,SmoothDec(H(1,:),smo),'b','linewidth',2)
        elseif a>2
            hold on, plot(b,SmoothDec(mean(H(1:(a-1),:)),smo),'b','linewidth',2)
        end
        hold on, axis([0 2.9 0 300])
        hold on, xlabel('time(s)'),ylabel('delta number')
        hold on, title(['All mean - mouse n#',num2str(mouse)])
    end
    clear H
    
    % -----------------------------
    % Delta Tone Days Analysis
    % -----------------------------
    try
        Dir=PathForExperimentsDeltaSleep2016('DeltaTone');
        disp(' ')
        disp('**********************************************************************************************')
        Dir=RestrictPathForExperiment(Dir,'nMice',mouse);
        disp('**********************************************************************************************')
        disp(' ')
        
        % individual value for all days
        a=1;
        for i=1:length(Dir.path)
            disp(' ')
            disp('****************************************************************')
            eval(['cd(Dir.path{',num2str(i),'}'')'])
            disp(pwd)
            
            clear tDelta
            load newDeltaPFCx
            Dpfc=ts(tDelta);
            
            d=diff(Range(Dpfc,'s'));
            [h{a},b]=hist(d,[-0.01:0.02:3]);
            
            a=a+1;
        end
        % mean value for all days
        hold, subplot(5,7,plo+7*2)
        for i=1:(a-1)
            hold on, plot(b,h{i},'m','linewidth',1)
            hold on, axis([0 2.9 0 400])
            hold on, xlabel('time(s)'),ylabel('delta number')
            hold on, title(['Delta 140ms Tone - mouse n#',num2str(mouse)])
        end
        for i=1:(a-1)
            H(i,:)=h{i};
        end
        hold on, subplot(5,7,plo+7*4)
        if a==2
            hold on, plot(b,SmoothDec(H(1,:),smo),'m','linewidth',2)
        elseif a>2
            hold on, plot(b,SmoothDec(mean(H(1:(a-1),:)),smo),'m','linewidth',2)
        end
        hold on, axis([0 2.9 0 300])
        hold on, xlabel('time(s)'),ylabel('delta number')
        hold on, title(['All mean - mouse n#',num2str(mouse)])
    end
    clear H
    
    % ---------------------------------------
    % Delta Tone Days Analysis (>140ms delay)
    % ---------------------------------------
    try
        Dir=PathForExperimentsDeltaSleep2016('DeltaToneAll');
        disp(' ')
        disp('**********************************************************************************************')
        Dir=RestrictPathForExperiment(Dir,'nMice',mouse);
        disp('**********************************************************************************************')
        disp(' ')
        
        % individual value for all days
        a=1;
        for i=1:length(Dir.path)
            disp(' ')
            disp('****************************************************************')
            eval(['cd(Dir.path{',num2str(i),'}'')'])
            disp(pwd)
            
            clear tDelta
            load newDeltaPFCx
            Dpfc=ts(tDelta);
            
            d=diff(Range(Dpfc,'s'));
            [h{a},b]=hist(d,[-0.01:0.02:3]);
            
            a=a+1;
        end
        % mean value for all days
        hold, subplot(5,7,plo+7*3)
        for i=1:(a-1)
            hold on, plot(b,h{i},'r','linewidth',1)
            hold on, axis([0 2.9 0 400])
            hold on, xlabel('time(s)'),ylabel('delta number')
            hold on, title(['Delta >140ms Tone - mouse n#',num2str(mouse)])
        end
        for i=1:(a-1)
            H(i,:)=h{i};
        end
        hold on, subplot(5,7,plo+7*4)
        if a==2
            hold on, plot(b,SmoothDec(H(1,:),smo),'r','linewidth',2)
        elseif a>2
            hold on, plot(b,SmoothDec(mean(H(1:(a-1),:)),smo),'r','linewidth',2)
        end
        hold on, axis([0 2.9 0 300])
        hold on, xlabel('time(s)'),ylabel('delta number')
        hold on, title(['All mean - mouse n#',num2str(mouse)])
    end
    clear H
    
    plo=plo+1;
end


%% 2 -  Determine Delta occurence after tone occurence
smo=0;
figure('color',[1 1 1])
plo=1;
ton=1;
a=1;
for mouse=[243 244 251 252 293 294 296];
    % -----------------------------
    % Random Tone Days Analysis
    % -----------------------------
    hold on, subplot(4,7,a)
    b=1;
    try
        Dir=PathForExperimentsDeltaSleep2016('RdmTone');
        disp('**********************************************************************************************')
        Dir=RestrictPathForExperiment(Dir,'nMice',mouse);
        disp('**********************************************************************************************')
        
        % individual value for all days
        for i=1:length(Dir.path)
            disp('****************************************************************')
            eval(['cd(Dir.path{',num2str(i),'}'')'])
            disp(pwd)
            
            load StateEpochSB SWSEpoch
            clear tDelta
            load newDeltaPFCx
            Dpfc=ts(tDelta);
            load DeltaSleepEvent
            
            if ton==1
                Tones=TONEtime1;disp('Tones 1')
            elseif ton==2
                Tones=TONEtime2; disp('Tones 2')
            end
            if mouse<253
                Tones=Tones+0.14*1E4;
            elseif mouse>253
                Tones=Tones;
            end
                
            [C1,B1]=CrossCorr(Tones,Range(Restrict(Dpfc,SWSEpoch)),10,200); C1(B1==0)=0;
            
            if size(Dir.name,2)>1
                hold on, plot(B1/1E3,smoothDec(C1,smo),'k')
                hold on, title(['Rdm Delta - mouse n#',num2str(mouse)])
                b=b+1;
            elseif size(Dir.name,2)==1
                hold on, plot(B1/1E3,smoothDec(C1,smo),'k')
                hold on, title(['Rdm Delta - mouse n#',num2str(mouse)])
                a=a+1;
                b=0;
            end
            
            if b==2;
                hold on, plot(B1/1E3,smoothDec(C1,smo),'b')
                hold on, title(['Rdm Delta - mouse n#',num2str(mouse)])
                a=a+1;
            end
        end
    catch
        hold on, plot(1,1)
        hold on, title(['Rdm Delta - mouse n#',num2str(mouse)])
        a=a+1;
    end
end
% ------------------------------------------------------------------------------------------------------------------------------------------
a=1;
for mouse=[243 244 251 252 293 294 296];    
    % -----------------------
    % Delta Tone Days (140ms)
    % -----------------------
    hold on, subplot(4,7,a+7)
    b=1;
    try
        Dir=PathForExperimentsDeltaSleep2016('DeltaT140');
        disp('**********************************************************************************************')
        Dir=RestrictPathForExperiment(Dir,'nMice',mouse);
        disp('**********************************************************************************************')
        
        % individual value for all days
        for i=1:length(Dir.path)
            disp('****************************************************************')
            eval(['cd(Dir.path{',num2str(i),'}'')'])
            disp(pwd)
            
            load StateEpochSB SWSEpoch
            clear tDelta
            load newDeltaPFCx
            Dpfc=ts(tDelta);
            load DeltaSleepEvent
            
            if ton==1
                Tones=TONEtime1;disp('Tones 1')
            elseif ton==2
                Tones=TONEtime2; disp('Tones 2')
            end
            if mouse<253
                Tones=Tones+0.14*1E4;
            elseif mouse>253
                Tones=Tones;
            end
            
            [C1,B1]=CrossCorr(Tones,Range(Restrict(Dpfc,SWSEpoch)),10,200); C1(B1==0)=0;
            
            if size(Dir.name,2)>1
                hold on, plot(B1/1E3,smoothDec(C1,smo),'k')
                hold on, title(['Delta 140ms- mouse n#',num2str(mouse)])
                b=b+1;
            elseif size(Dir.name,2)==1
                hold on, plot(B1/1E3,smoothDec(C1,smo),'k')
                hold on, title(['Delta 140ms- mouse n#',num2str(mouse)])
                a=a+1;
                b=0;
            end
            
            if b==2;
                hold on, plot(B1/1E3,smoothDec(C1,smo),'b')
                hold on, title(['Delta 140ms- mouse n#',num2str(mouse)])
                a=a+1;
            end
        end
    catch
        hold on, plot(1,1)
                hold on, title(['Delta 140ms- mouse n#',num2str(mouse)])
        a=a+1;
    end
end

% ------------------------------------------------------------------------------------------------------------------------------------------
a=1;
for mouse=[243 244 251 252 293 294 296];    
    % -----------------------
    % Delta Tone Days (320ms)
    % -----------------------
    hold on, subplot(4,7,a+2*7)
    b=1;
    try
        Dir=PathForExperimentsDeltaSleep2016('DeltaT320');
        disp('**********************************************************************************************')
        Dir=RestrictPathForExperiment(Dir,'nMice',mouse);
        disp('**********************************************************************************************')
        
        % individual value for all days
        for i=1:length(Dir.path)
            disp('****************************************************************')
            eval(['cd(Dir.path{',num2str(i),'}'')'])
            disp(pwd)
            
            load StateEpochSB SWSEpoch
            clear tDelta
            load newDeltaPFCx
            Dpfc=ts(tDelta);
            load DeltaSleepEvent
            
            if ton==1
                Tones=TONEtime1;disp('Tones 1')
            elseif ton==2
                Tones=TONEtime2; disp('Tones 2')
            end
            if mouse<253
                Tones=Tones+0.32*1E4;
            elseif mouse>253
                Tones=Tones;
            end
            
            [C1,B1]=CrossCorr(Tones,Range(Restrict(Dpfc,SWSEpoch)),10,200); C1(B1==0)=0;
            
            if size(Dir.name,2)>1
                hold on, plot(B1/1E3,smoothDec(C1,smo),'k')
                hold on, title(['Delta 320ms- mouse n#',num2str(mouse)])
                b=b+1;
            elseif size(Dir.name,2)==1
                hold on, plot(B1/1E3,smoothDec(C1,smo),'k')
                hold on, title(['Delta 320ms- mouse n#',num2str(mouse)])
                a=a+1;
                b=0;
            end
            
            if b==2;
                hold on, plot(B1/1E3,smoothDec(C1,smo),'b')
                hold on, title(['Delta 320ms- mouse n#',num2str(mouse)])
                a=a+1;
            end
        end
    catch
        hold on, plot(1,1)
                hold on, title(['Delta 320ms- mouse n#',num2str(mouse)])
        a=a+1;
    end
end
% ------------------------------------------------------------------------------------------------------------------------------------------
a=1;
for mouse=[243 244 251 252 293 294 296];    
    % -----------------------
    % Delta Tone Days (450ms)
    % -----------------------
    hold on, subplot(4,7,a+3*7)
    b=1;
    try
        Dir=PathForExperimentsDeltaSleep2016('DeltaT480');
        disp('**********************************************************************************************')
        Dir=RestrictPathForExperiment(Dir,'nMice',mouse);
        disp('**********************************************************************************************')
        
        % individual value for all days
        for i=1:length(Dir.path)
            disp('****************************************************************')
            eval(['cd(Dir.path{',num2str(i),'}'')'])
            disp(pwd)
            
            load StateEpochSB SWSEpoch
            clear tDelta
            load newDeltaPFCx
            Dpfc=ts(tDelta);
            load DeltaSleepEvent
            
            if ton==1
                Tones=TONEtime1;disp('Tones 1')
            elseif ton==2
                Tones=TONEtime2; disp('Tones 2')
            end
            if mouse<253
                Tones=Tones+0.45*1E4;
            elseif mouse>253
                Tones=Tones;
            end
            
            [C1,B1]=CrossCorr(Tones,Range(Restrict(Dpfc,SWSEpoch)),10,200); C1(B1==0)=0;
            
            if size(Dir.name,2)>1
                hold on, plot(B1/1E3,smoothDec(C1,smo),'k')
                hold on, title(['Delta 480ms- mouse n#',num2str(mouse)])
                b=b+1;
            elseif size(Dir.name,2)==1
                hold on, plot(B1/1E3,smoothDec(C1,smo),'k')
                hold on, title(['Delta 480ms- mouse n#',num2str(mouse)])
                a=a+1;
                b=0;
            end
            
            if b==2;
                hold on, plot(B1/1E3,smoothDec(C1,smo),'b')
                hold on, title(['Delta 480ms- mouse n#',num2str(mouse)])
                a=a+1;
            end
        end
    catch
        hold on, plot(1,1)
                hold on, title(['Delta 480ms- mouse n#',num2str(mouse)])
        a=a+1;
    end
end

%% 3 -  Plot LFP deep & superficial layer around tone occurence
smo=0;
figure('color',[1 1 1])
plo=1;
ton=1;
a=1;
for mouse=[243 244 251 252 293 294 296];
    % -----------------------------
    % Random Tone Days Analysis
    % -----------------------------
    hold on, subplot(4,7,a)
    b=1;
    try
        Dir=PathForExperimentsDeltaSleep2016('RdmTone');
        disp('**********************************************************************************************')
        Dir=RestrictPathForExperiment(Dir,'nMice',mouse);
        disp('**********************************************************************************************')
        
        % individual value for all days
        for i=1:length(Dir.path)
            disp('****************************************************************')
            eval(['cd(Dir.path{',num2str(i),'}'')'])
            disp(pwd)
            
            load StateEpochSB SWSEpoch
            clear tDelta
            load newDeltaPFCx
            Dpfc=ts(tDelta);
            load DeltaSleepEvent
            
            if ton==1
                Tones=TONEtime1;disp('Tones 1')
            elseif ton==2
                Tones=TONEtime2; disp('Tones 2')
            end
            Tones=Range(Restrict(ts(sort([Tones])),SWSEpoch));
            if mouse<253
                Tones=Tones+0.14*1E4;
            elseif mouse>253
                Tones=Tones;
            end
            Ntones=length(Tones);
            
            load ChannelsToAnalyse/PFCx_deep
            eval(['load LFPData/LFP',num2str(channel)])
            LFPd=LFP;
            clear LFP
            load ChannelsToAnalyse/PFCx_sup
            eval(['load LFPData/LFP',num2str(channel)])
            LFPs=LFP;
            clear LFP
            
            [MPEtonePFCxDeep,TPEtonePFCxDeep]=PlotRipRaw(LFPd,Tones/1E4,1000);close
            [MPEtonePFCxSup,TPEtonePFCxSup]=PlotRipRaw(LFPs,Tones/1E4,1000);close
            tps=MPEtonePFCxDeep(:,1);
            
            
            if size(Dir.name,2)>1
                hold on, plot(tps,nanmean(TPEtonePFCxDeep(1:Ntones,:)),'k')
                hold on, plot(tps,nanmean(TPEtonePFCxSup(1:Ntones,:)),'r')
                hold on, title(['Rdm Delta - mouse n#',num2str(mouse)])
                b=b+1;
            elseif size(Dir.name,2)==1
                hold on, plot(tps,nanmean(TPEtonePFCxDeep(1:Ntones,:)),'k')
                hold on, plot(tps,nanmean(TPEtonePFCxSup(1:Ntones,:)),'r')
                hold on, title(['Rdm Delta - mouse n#',num2str(mouse)])
                a=a+1;
                b=0;
            end
            
            if b==2;
                hold on, plot(tps,nanmean(TPEtonePFCxDeep(1:Ntones,:)),'k')
                hold on, plot(tps,nanmean(TPEtonePFCxSup(1:Ntones,:)),'r')
                hold on, title(['Rdm Delta - mouse n#',num2str(mouse)])
                a=a+1;
            end
        end
    catch
        hold on, plot(1,1)
        hold on, title(['Rdm Delta - mouse n#',num2str(mouse)])
        a=a+1;
    end
end
% ------------------------------------------------------------------------------------------------------------------------------------------
a=1;
for mouse=[243 244 251 252 293 294 296];    
    % -----------------------
    % Delta Tone Days (140ms)
    % -----------------------
    hold on, subplot(4,7,a+7)
    b=1;
    try
        Dir=PathForExperimentsDeltaSleep2016('DeltaT140');
        disp('**********************************************************************************************')
        Dir=RestrictPathForExperiment(Dir,'nMice',mouse);
        disp('**********************************************************************************************')
        
        % individual value for all days
        for i=1:length(Dir.path)
            disp('****************************************************************')
            eval(['cd(Dir.path{',num2str(i),'}'')'])
            disp(pwd)
            
            load StateEpochSB SWSEpoch
            clear tDelta
            load newDeltaPFCx
            Dpfc=ts(tDelta);
            load DeltaSleepEvent
            
            if ton==1
                Tones=TONEtime1;disp('Tones 1')
            elseif ton==2
                Tones=TONEtime2; disp('Tones 2')
            end
            if mouse<253
                Tones=Tones+0.14*1E4;
            elseif mouse>253
                Tones=Tones;
            end
            Ntones=length(Tones);
            
            load ChannelsToAnalyse/PFCx_deep
            eval(['load LFPData/LFP',num2str(channel)])
            LFPd=LFP;
            clear LFP
            load ChannelsToAnalyse/PFCx_sup
            eval(['load LFPData/LFP',num2str(channel)])
            LFPs=LFP;
            clear LFP
            
            [MPEtonePFCxDeep,TPEtonePFCxDeep]=PlotRipRaw(LFPd,Tones/1E4,1000);close
            [MPEtonePFCxSup,TPEtonePFCxSup]=PlotRipRaw(LFPs,Tones/1E4,1000);close
            tps=MPEtonePFCxDeep(:,1);
            
            if size(Dir.name,2)>1
                hold on, plot(tps,nanmean(TPEtonePFCxDeep(1:Ntones,:)),'k')
                hold on, plot(tps,nanmean(TPEtonePFCxSup(1:Ntones,:)),'r')
                hold on, title(['Delta 140ms- mouse n#',num2str(mouse)])
                b=b+1;
            elseif size(Dir.name,2)==1
                hold on, plot(tps,nanmean(TPEtonePFCxDeep(1:Ntones,:)),'k')
                hold on, plot(tps,nanmean(TPEtonePFCxSup(1:Ntones,:)),'r')
                hold on, title(['Delta 140ms- mouse n#',num2str(mouse)])
                a=a+1;
                b=0;
            end
            
            if b==2;
                hold on, plot(tps,nanmean(TPEtonePFCxDeep(1:Ntones,:)),'k')
                hold on, plot(tps,nanmean(TPEtonePFCxSup(1:Ntones,:)),'r')
                hold on, title(['Delta 140ms- mouse n#',num2str(mouse)])
                a=a+1;
            end
        end
    catch
        hold on, plot(1,1)
                hold on, title(['Delta 140ms- mouse n#',num2str(mouse)])
        a=a+1;
    end
end

% ------------------------------------------------------------------------------------------------------------------------------------------
a=1;
for mouse=[243 244 251 252 293 294 296];    
    % -----------------------
    % Delta Tone Days (320ms)
    % -----------------------
    hold on, subplot(4,7,a+2*7)
    b=1;
    try
        Dir=PathForExperimentsDeltaSleep2016('DeltaT320');
        disp('**********************************************************************************************')
        Dir=RestrictPathForExperiment(Dir,'nMice',mouse);
        disp('**********************************************************************************************')
        
        % individual value for all days
        for i=1:length(Dir.path)
            disp('****************************************************************')
            eval(['cd(Dir.path{',num2str(i),'}'')'])
            disp(pwd)
            
            load StateEpochSB SWSEpoch
            clear tDelta
            load newDeltaPFCx
            Dpfc=ts(tDelta);
            load DeltaSleepEvent
            
            if ton==1
                Tones=TONEtime1;disp('Tones 1')
            elseif ton==2
                Tones=TONEtime2; disp('Tones 2')
            end
            if mouse<253
                Tones=Tones+0.32*1E4;
            elseif mouse>253
                Tones=Tones;
            end
            Ntones=length(Tones);
            
            load ChannelsToAnalyse/PFCx_deep
            eval(['load LFPData/LFP',num2str(channel)])
            LFPd=LFP;
            clear LFP
            load ChannelsToAnalyse/PFCx_sup
            eval(['load LFPData/LFP',num2str(channel)])
            LFPs=LFP;
            clear LFP
            
            [MPEtonePFCxDeep,TPEtonePFCxDeep]=PlotRipRaw(LFPd,Tones/1E4,1000);close
            [MPEtonePFCxSup,TPEtonePFCxSup]=PlotRipRaw(LFPs,Tones/1E4,1000);close
            tps=MPEtonePFCxDeep(:,1);
            
            if size(Dir.name,2)>1
                hold on, plot(tps,nanmean(TPEtonePFCxDeep(1:Ntones,:)),'k')
                hold on, plot(tps,nanmean(TPEtonePFCxSup(1:Ntones,:)),'r')
                hold on, title(['Delta 320ms- mouse n#',num2str(mouse)])
                b=b+1;
            elseif size(Dir.name,2)==1
                hold on, plot(tps,nanmean(TPEtonePFCxDeep(1:Ntones,:)),'k')
                hold on, plot(tps,nanmean(TPEtonePFCxSup(1:Ntones,:)),'r')
                hold on, title(['Delta 320ms- mouse n#',num2str(mouse)])
                a=a+1;
                b=0;
            end
            
            if b==2;
               hold on, plot(tps,nanmean(TPEtonePFCxDeep(1:Ntones,:)),'k')
                hold on, plot(tps,nanmean(TPEtonePFCxSup(1:Ntones,:)),'r')
                hold on, title(['Delta 320ms- mouse n#',num2str(mouse)])
                a=a+1;
            end
        end
    catch
        hold on, plot(1,1)
                hold on, title(['Delta 320ms- mouse n#',num2str(mouse)])
        a=a+1;
    end
end
% ------------------------------------------------------------------------------------------------------------------------------------------
a=1;
for mouse=[243 244 251 252 293 294 296];    
    % -----------------------
    % Delta Tone Days (450ms)
    % -----------------------
    hold on, subplot(4,7,a+3*7)
    b=1;
    try
        Dir=PathForExperimentsDeltaSleep2016('DeltaT480');
        disp('**********************************************************************************************')
        Dir=RestrictPathForExperiment(Dir,'nMice',mouse);
        disp('**********************************************************************************************')
        
        % individual value for all days
        for i=1:length(Dir.path)
            disp('****************************************************************')
            eval(['cd(Dir.path{',num2str(i),'}'')'])
            disp(pwd)
            
            load StateEpochSB SWSEpoch
            clear tDelta
            load newDeltaPFCx
            Dpfc=ts(tDelta);
            load DeltaSleepEvent
            
            if ton==1
                Tones=TONEtime1;disp('Tones 1')
            elseif ton==2
                Tones=TONEtime2; disp('Tones 2')
            end
            if mouse<253
                Tones=Tones+0.45*1E4;
            elseif mouse>253
                Tones=Tones;
            end
            Ntones=length(Tones);
            
            load ChannelsToAnalyse/PFCx_deep
            eval(['load LFPData/LFP',num2str(channel)])
            LFPd=LFP;
            clear LFP
            load ChannelsToAnalyse/PFCx_sup
            eval(['load LFPData/LFP',num2str(channel)])
            LFPs=LFP;
            clear LFP
            
            [MPEtonePFCxDeep,TPEtonePFCxDeep]=PlotRipRaw(LFPd,Tones/1E4,1000);close
            [MPEtonePFCxSup,TPEtonePFCxSup]=PlotRipRaw(LFPs,Tones/1E4,1000);close
            tps=MPEtonePFCxDeep(:,1);
            
            if size(Dir.name,2)>1
                hold on, plot(tps,nanmean(TPEtonePFCxDeep(1:Ntones,:)),'k')
                hold on, plot(tps,nanmean(TPEtonePFCxSup(1:Ntones,:)),'r')
                hold on, title(['Delta 480ms- mouse n#',num2str(mouse)])
                b=b+1;
            elseif size(Dir.name,2)==1
                hold on, plot(tps,nanmean(TPEtonePFCxDeep(1:Ntones,:)),'k')
                hold on, plot(tps,nanmean(TPEtonePFCxSup(1:Ntones,:)),'r')
                hold on, title(['Delta 480ms- mouse n#',num2str(mouse)])
                a=a+1;
                b=0;
            end
            
            if b==2;
                hold on, plot(tps,nanmean(TPEtonePFCxDeep(1:Ntones,:)),'k')
                hold on, plot(tps,nanmean(TPEtonePFCxSup(1:Ntones,:)),'r')
                hold on, title(['Delta 480ms- mouse n#',num2str(mouse)])
                a=a+1;
            end
        end
    catch
        hold on, plot(1,1)
                hold on, title(['Delta 480ms- mouse n#',num2str(mouse)])
        a=a+1;
    end
end

%% 1 -  FIND DELTA
% clear tDelta
% load newDeltaPFCx
% Dpfc=ts(tDelta);
% smo=0.5;
% 
% load StateEpochSB SWSEpoch
% 
% load EpochToAnalyse
% for i=1:5
%     EpochToAnalyseSWS{i}=and(EpochToAnalyse{i},SWSEpoch);
% end
% 
% [C1,B1]=CrossCorr(Range(Restrict(Dpfc,SWSEpoch)),Range(Restrict(Dpfc,SWSEpoch)),20,1000); C1(B1==0)=0;
% 
% figure('color',[1 1 1])
% hold on, plot(B1/1E3,smoothDec(C1,smo),'b')


%% 2 -  DEFINE Ripples and Delta EPOCHs

% d=diff(Range(Dpfc,'s'));
% d1=diff(Range(Restrict(Dpfc,EpochToAnalyseSWS{1}),'s'));
% d2=diff(Range(Restrict(Dpfc,EpochToAnalyseSWS{2}),'s'));
% d3=diff(Range(Restrict(Dpfc,EpochToAnalyseSWS{3}),'s'));
% d4=diff(Range(Restrict(Dpfc,EpochToAnalyseSWS{4}),'s'));
% d5=diff(Range(Restrict(Dpfc,EpochToAnalyseSWS{5}),'s'));
% 
% [h,b]=hist(d,[-0.01:0.02:3]);
% [h1,b1]=hist(d1,[-0.2:0.02:3.1]);
% [h2,b2]=hist(d2,[-0.2:0.02:3.1]);
% [h3,b3]=hist(d3,[-0.2:0.02:3.1]);
% [h4,b4]=hist(d4,[-0.2:0.02:3.1]);
% [h5,b5]=hist(d5,[-0.2:0.02:3.1]);
% 
% figure('color',[1 1 1])
% hold on, plot(b,SmoothDec(h,smo),'r','linewidth',2)
% hold on, axis([0 2.9 0 600])
% hold on, xlabel('time(s)'),ylabel('delta number')
% hold on, title('Delta Occurence')
% 
% figure('color',[1 1 1])
% hold on, plot(b1,SmoothDec(h1,smo),'r','linewidth',2)
% hold on, plot(b1,SmoothDec(h2,smo),'m','linewidth',2)
% hold on, plot(b1,SmoothDec(h3,smo),'y','linewidth',2)
% hold on, plot(b1,SmoothDec(h4,smo),'c','linewidth',2)
% hold on, plot(b1,SmoothDec(h5,smo),'b','linewidth',2)
% hold on, axis([0 2.9 0 200])
% hold on, xlabel('time(s)'),ylabel('delta number')
% hold on, title('Delta Occurence for all sleep sessions')
