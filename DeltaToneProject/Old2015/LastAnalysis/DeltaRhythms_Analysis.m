function DeltaRhythms_Analysis(struc,plo)
% <><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><>
% <><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><>
a=0;
a=a+1; Path_M243_basal{a}='/media/DataMOBsRAID/ProjetBreathDeltaFeedback/Mice243-244/20150222/Breath-Mouse-243-244-22022015/Mouse243';
a=a+1; Path_M243_basal{a}='/media/DataMOBsRAID/ProjetBreathDeltaFeedback/Mice243-244/20150329/Electrophy/Breath-Mouse-243-244-29032015/Mouse243';
a=a+1; Path_M243_basal{a}='/media/DataMOBsRAID/ProjetBreathDeltaFeedback/Mice243-244/20150331/Electrophy/Breath-Mouse-243-244-31032015/Mouse243';
a=a+1; Path_M243_basal{a}='/media/DataMOBsRAID/ProjetBreathDeltaFeedback/Mice243-244/20150401/Breath-Mouse-243-244-01042015/Mouse243';
a=a+1; Path_M243_basal{a}='/media/DataMOBsRAID/ProjetBreathDeltaFeedback/Mice243-244/20150409/Breath-Mouse-243-244-09042015/Mouse243';

a=0;
a=a+1; Path_M244_basal{a}='/media/DataMOBsRAID/ProjetBreathDeltaFeedback/Mice243-244/20150222/Breath-Mouse-243-244-22022015/Mouse244';
a=a+1; Path_M244_basal{a}='/media/DataMOBsRAID/ProjetBreathDeltaFeedback/Mice243-244/20150329/Electrophy/Breath-Mouse-243-244-29032015/Mouse244';
a=a+1; Path_M244_basal{a}='/media/DataMOBsRAID/ProjetBreathDeltaFeedback/Mice243-244/20150331/Electrophy/Breath-Mouse-243-244-31032015/Mouse244';
a=a+1; Path_M244_basal{a}='/media/DataMOBsRAID/ProjetBreathDeltaFeedback/Mice243-244/20150401/Breath-Mouse-243-244-01042015/Mouse244';
a=a+1; Path_M244_basal{a}='/media/DataMOBsRAID/ProjetBreathDeltaFeedback/Mice243-244/20150409/Breath-Mouse-243-244-09042015/Mouse244';

% <><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><>
a=0;
%a=a+1; Path_Mouse243_Delta{a}='/media/DataMOBsRAID/ProjetBreathDeltaFeedback/Mice243-244/20150416/Breath-Mouse-243-244-16042015/mouse243';  % 16-04-2015 > random tone effect
a=a+1; Path_Mouse243_Delta{a}='/media/DataMOBsRAID/ProjetBreathDeltaFeedback/Mice243-244/20150421/Breath-Mouse-243-21042015';               % 21-04-2015 > delay 140ms
a=a+1; Path_Mouse243_Delta{a}='/media/DataMOBsRAID/ProjetBreathDeltaFeedback/Mice243-244/20150417/Breath-Mouse-243-244-17042015/Mouse243';  % 17-04-2015 > delay 200ms
a=a+1; Path_Mouse243_Delta{a}='/media/DataMOBsRAID/ProjetBreathDeltaFeedback/Mice243-244/20150423/Breath-Mouse-243-23042015';               % 23-04-2015 > delay 320ms
a=a+1; Path_Mouse243_Delta{a}='/media/DataMOBs28/Mice-243-244/20150425/Breath-Mouse-243-25042015';                                          % 25-04-2015 > delay 480ms
a=a+1; Path_Mouse243_Delta{a}='/media/DataMOBs28/Mice-243-244/20150429/Breath-Mouse-243-29042015';                                          % 25-04-2015 > delay 3*140ms

a=0;
%a=a+1; Path_Mouse244_Delta{a}='/media/DataMOBsRAID/ProjetBreathDeltaFeedback/Mice243-244/20150417/Breath-Mouse-243-244-17042015/Mouse244';  % 17-04-2015 > random tone effect
a=a+1; Path_Mouse244_Delta{a}='/media/DataMOBsRAID/ProjetBreathDeltaFeedback/Mice243-244/20150422/Breath-Mouse-244-22042015';               % 22-04-2015 > delay 140ms
a=a+1; Path_Mouse244_Delta{a}='/media/DataMOBsRAID/ProjetBreathDeltaFeedback/Mice243-244/20150416/Breath-Mouse-243-244-16042015/Mouse244';  % 16-04-2015 > delay 200ms
a=a+1; Path_Mouse244_Delta{a}='/media/DataMOBs28/Mice-243-244/20150424/Breath-Mouse-244-24042015';                                          % 24-04-2015 > delay 320ms
a=a+1; Path_Mouse244_Delta{a}='/media/DataMOBs28/Mice-243-244/20150426/Breath-Mouse-244-26042015';                                          % 26-04-2015 > delay 480ms
a=a+1; Path_Mouse244_Delta{a}='/media/DataMOBs28/Mice-243-244/20150430/Breath-Mouse-244-30042015';                                          % 25-04-2015 > delay 3*140ms
% <><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><>
% <><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><>

try 
    struc
catch
    struc='PaCx';
end

% <><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><>
% <><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><>
%---------------------------------------------------------------------------------------------------------------------------------------------------
%                                                       LOAD  EPOCH & DELTA for BASAL SLEEP
%---------------------------------------------------------------------------------------------------------------------------------------------------
% <><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><>
% <><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><>

% <><><><><><><><><><><><><><>  Mouse 243 : basal sleep <><><><><><><><><><><><><><> 
for a=1:length(Path_M243_basal)
    cd(Path_M243_basal{a})
    res=pwd;
    
    % define 5 succesive Sleep epochs 
    load StateEpochSB SWSEpoch
    BegSWS=Start(SWSEpoch); BegSWS=BegSWS(1);
    EndSWS=Stop(SWSEpoch); EndSWS=EndSWS(end);
    DurSWS=EndSWS-BegSWS;
    for i=1:5
        EpochSleep{i}=intervalSet(BegSWS+((DurSWS/5)*(i-1)),BegSWS+((DurSWS/5)*(i))); 
    end
    
    % restrict Delta occurence to the 5 succesive Sleep epochs 
    load([res,'/newDelta',struc]);
    for i=1:5
        Delta_M243_basal{a,i}=Restrict(ts(tDelta),EpochSleep{i});
        DurDeltaEpoch_M243_basal{a,i}=tot_length(EpochSleep{i},'s');
    end
end

% <><><><><><><><><><><><><><>  Mouse 243 : delta sleep <><><><><><><><><><><><><><> 
for a=1:length(Path_Mouse243_Delta)
    cd(Path_Mouse243_Delta{a})
    res=pwd;
    
    % find Delta triggered session
    load behavResources
    b=1;
    for i=1:length(evt)/2
        textt=evt(i);
       if ~isempty(strfind(evt{i},'Delta'))
            DeltaSession(b)=i;
            b=b+1;
        end
    end
    EpochSleep{1}=intervalSet(tpsdeb{1}*1E4,tpsdeb{DeltaSession(1)}*1E4);
    EpochSleep{2}=intervalSet(tpsdeb{DeltaSession(1)}*1E4,tpsfin{DeltaSession(1)}*1E4);
    EpochSleep{3}=intervalSet(tpsfin{DeltaSession(1)}*1E4,tpsdeb{DeltaSession(2)}*1E4);
    EpochSleep{4}=intervalSet(tpsdeb{DeltaSession(2)}*1E4,tpsfin{DeltaSession(2)}*1E4);
    EpochSleep{5}=intervalSet(tpsfin{DeltaSession(2)}*1E4,tpsfin{end}*1E4);

   
    % restrict Delta occurence to the 5 succesive Sleep epochs 
    load([res,'/newDelta',struc]);
    for i=1:5
        Delta_M243_Tone{a,i}=Restrict(ts(tDelta),EpochSleep{i});
        DurDeltaEpoch_M243_Tone{a,i}=tot_length(EpochSleep{i},'s');
    end
end



% <><><><><><><><><><><><><><>  Mouse 244 : basal sleep <><><><><><><><><><><><><><> 
for a=1:length(Path_M244_basal)
    cd(Path_M244_basal{a})
    res=pwd;
    
    % define 5 succesive Sleep epochs 
    load StateEpochSB SWSEpoch
    BegSWS=Start(SWSEpoch); BegSWS=BegSWS(1);
    EndSWS=Stop(SWSEpoch); EndSWS=EndSWS(end);
    DurSWS=EndSWS-BegSWS;
    for i=1:5
        EpochSleep{i}=intervalSet(BegSWS+((DurSWS/5)*(i-1)),BegSWS+((DurSWS/5)*(i))); 
    end
    
    % restrict Delta occurence to the 5 succesive Sleep epochs 
    load([res,'/newDelta',struc]);
    for i=1:5
        Delta_M244_basal{a,i}=Restrict(ts(tDelta),EpochSleep{i});
        DurDeltaEpoch_M244_basal{a,i}=tot_length(EpochSleep{i},'s');
    end
end

% <><><><><><><><><><><><><><>  Mouse 244 : delta sleep <><><><><><><><><><><><><><> 
for a=1:length(Path_Mouse244_Delta)
    cd(Path_Mouse244_Delta{a})
    res=pwd;
    
    % find Delta triggered session
    load behavResources
    b=1;
    for i=1:length(evt)/2
        textt=evt(i);
       if ~isempty(strfind(evt{i},'Delta'))
            DeltaSession(b)=i;
            b=b+1;
       end
    end
    
    if length(DeltaSession)==2
        EpochSleep{1}=intervalSet(tpsdeb{1}*1E4,tpsdeb{DeltaSession(1)}*1E4);
        EpochSleep{2}=intervalSet(tpsdeb{DeltaSession(1)}*1E4,tpsfin{DeltaSession(1)}*1E4);
        EpochSleep{3}=intervalSet(tpsfin{DeltaSession(1)}*1E4,tpsdeb{DeltaSession(2)}*1E4);
        EpochSleep{4}=intervalSet(tpsdeb{DeltaSession(2)}*1E4,tpsfin{DeltaSession(2)}*1E4);
        EpochSleep{5}=intervalSet(tpsfin{DeltaSession(2)}*1E4,tpsfin{end}*1E4);
    end
    if length(DeltaSession)==3
        EpochSleep{1}=intervalSet(tpsdeb{1}*1E4,tpsdeb{DeltaSession(1)}*1E4);
        EpochSleep{2}=intervalSet(tpsdeb{DeltaSession(1)}*1E4,tpsfin{DeltaSession(2)}*1E4);
        EpochSleep{3}=intervalSet(tpsfin{DeltaSession(2)}*1E4,tpsdeb{DeltaSession(3)}*1E4);
        EpochSleep{4}=intervalSet(tpsdeb{DeltaSession(3)}*1E4,tpsfin{DeltaSession(3)}*1E4);
        EpochSleep{5}=intervalSet(tpsfin{DeltaSession(3)}*1E4,tpsfin{end}*1E4);
    end
    clear DeltaSession
   
    % restrict Delta occurence to the 5 succesive Sleep epochs 
    load([res,'/newDelta',struc]);
    for i=1:5
        Delta_M244_Tone{a,i}=Restrict(ts(tDelta),EpochSleep{i});
        DurDeltaEpoch_M244_Tone{a,i}=tot_length(EpochSleep{i},'s');
    end
end

% <><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><>
% <><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><>
%---------------------------------------------------------------------------------------------------------------------------------------------------
%                                                           FIND RHYTHMS and BURST of DELTA
%---------------------------------------------------------------------------------------------------------------------------------------------------
% <><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><>
% <><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><>

% <><><><><><><><><><><><><><>  Mouse 243 : basal sleep <><><><><><><><><><><><><><> 
for a=1:length(Path_Mouse243_basal)
    for i=1:5
        d=diff(Range(Delta_M243_basal{a,i},'s'));
        [delayDelta_M243_basal{a,i},b1]=hist(d,[-0.01:0.02:3.1]); clear d;
        
        try [BurstDeltaEpoch,NbD]=FindDeltaBurst2(Delta_M243_basal{a,i},0.6); 
        BurstDeltaEpoch_M243_basal(a,i)=BurstDeltaEpoch;
        d=diff(Range(Restrict(Delta_M243_basal{a,i},BurstDeltaEpoch),'s'));
        [delayBurst_M243_basal{a,i},b2]=hist(d, [-0.01:0.02:3.1]); clear d; end
    end
end

% <><><><><><><><><><><><><><>  Mouse 243 : delta sleep <><><><><><><><><><><><><><> 
for a=1:length(Path_Mouse243_Delta)
    for i=1:5
        d=diff(Range(Delta_M243_Tone{a,i},'s'));
        [delayDelta_M243_Tone{a,i},b1]=hist(d,[-0.01:0.02:3.1]); clear d;
        
        try [BurstDeltaEpoch,NbD]=FindDeltaBurst2(Delta_M243_Tone{a,i},0.6); 
        BurstDeltaEpoch_M243_Tone(a,i)=BurstDeltaEpoch;
        d=diff(Range(Restrict(Delta_M243_Tone{a,i},BurstDeltaEpoch),'s'));
        [delayBurst_M243_Tone{a,i},b2]=hist(d, [-0.01:0.02:3.1]); clear d; end
    end
end



% <><><><><><><><><><><><><><>  Mouse 244 : basal sleep <><><><><><><><><><><><><><> 
for a=1:length(Path_Mouse244_basal)
    for i=1:5
        d=diff(Range(Delta_M244_basal{a,i},'s'));
        [delayDelta_M244_basal{a,i},b1]=hist(d,[-0.01:0.02:3.1]); clear d;
        
        try [BurstDeltaEpoch,NbD]=FindDeltaBurst2(Delta_M244_basal{a,i},0.6); 
        BurstDeltaEpoch_M244_basal(a,i)=BurstDeltaEpoch;
        d=diff(Range(Restrict(Delta_M244_basal{a,i},BurstDeltaEpoch),'s'));
        [delayBurst_M244_basal{a,i},b2]=hist(d, [-0.01:0.02:3.1]); clear d; end
    end
end

% <><><><><><><><><><><><><><>  Mouse 244 : delta sleep <><><><><><><><><><><><><><> 
for a=1:length(Path_Mouse244_Delta)
    for i=1:5
        d=diff(Range(Delta_M244_Tone{a,i},'s'));
        [delayDelta_M244_Tone{a,i},b1]=hist(d,[-0.01:0.02:3.1]); clear d;
        
        try [BurstDeltaEpoch,NbD]=FindDeltaBurst2(Delta_M244_Tone{a,i},0.6); 
        BurstDeltaEpoch_M244_Tone(a,i)=BurstDeltaEpoch;
        d=diff(Range(Restrict(Delta_M244_Tone{a,i},BurstDeltaEpoch),'s'));
        [delayBurst_M244_Tone{a,i},b2]=hist(d, [-0.01:0.02:3.1]); clear d; end
    end
end



% <><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><>
% <><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><>
%---------------------------------------------------------------------------------------------------------------------------------------------------
%                                                                     MEAN ALL THAT
%---------------------------------------------------------------------------------------------------------------------------------------------------
% <><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><>
% <><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><>
% Delta Quantity > BASAL SLEEP
QDelta_M243_basal(1)=mean([length(Delta_M243_basal{1,1}),length(Delta_M243_basal{3,1}),length(Delta_M243_basal{4,1}),length(Delta_M243_basal{5,1})],2);
for i=2:5
    QDelta_M243_basal(i)=mean([length(Delta_M243_basal{1,i}),length(Delta_M243_basal{2,i}),length(Delta_M243_basal{3,i}),length(Delta_M243_basal{4,i}),length(Delta_M243_basal{5,i})],2);
end
for i=1:5
    QDelta_M244_basal(i)=mean([length(Delta_M244_basal{1,i}),length(Delta_M244_basal{2,i}),length(Delta_M244_basal{3,i}),length(Delta_M244_basal{4,i}),length(Delta_M244_basal{5,i})],2);
end

QtDelta_M243_basal(1)=mean([length(Delta_M243_basal{1,1})/DurDeltaEpoch_M243_basal{1,i},length(Delta_M243_basal{3,1})/DurDeltaEpoch_M243_basal{3,i},length(Delta_M243_basal{4,1})/DurDeltaEpoch_M243_basal{4,i},length(Delta_M243_basal{5,1})/DurDeltaEpoch_M243_basal{5,i}],2);
for i=2:5
    QtDelta_M243_basal(i)=mean([length(Delta_M243_basal{1,i})/DurDeltaEpoch_M243_basal{1,i},length(Delta_M243_basal{2,i})/DurDeltaEpoch_M243_basal{2,i},length(Delta_M243_basal{3,i})/DurDeltaEpoch_M243_basal{3,i},length(Delta_M243_basal{4,i})/DurDeltaEpoch_M243_basal{4,i},length(Delta_M243_basal{5,i})/DurDeltaEpoch_M243_basal{5,i}],2);
end
for i=1:5
    QtDelta_M244_basal(i)=mean([length(Delta_M244_basal{1,i})/DurDeltaEpoch_M244_basal{1,i},length(Delta_M244_basal{2,i})/DurDeltaEpoch_M244_basal{2,i},length(Delta_M244_basal{3,i})/DurDeltaEpoch_M244_basal{3,i},length(Delta_M244_basal{4,i})/DurDeltaEpoch_M244_basal{4,i},length(Delta_M244_basal{5,i})/DurDeltaEpoch_M244_basal{5,i}],2);
end

% Delta Quantity > DELTA SLEEP
for a=1:length(Path_Mouse243_Delta)
    QDelta_M243_Tone{a}=[length(Delta_M243_Tone{a,1}); length(Delta_M243_Tone{a,2}); length(Delta_M243_Tone{a,3}); length(Delta_M243_Tone{a,4}) ;length(Delta_M243_Tone{a,5})];
end
for a=1:length(Path_Mouse244_Delta)
    QDelta_M244_Tone{a}=[length(Delta_M244_Tone{a,1}); length(Delta_M244_Tone{a,2}); length(Delta_M244_Tone{a,3}); length(Delta_M244_Tone{a,4}) ;length(Delta_M244_Tone{a,5})];
end

for a=1:length(Path_Mouse243_Delta)
    QtDelta_M243_Tone{a}=[length(Delta_M243_Tone{a,1})/DurDeltaEpoch_M243_Tone{a,1}; length(Delta_M243_Tone{a,2})/DurDeltaEpoch_M243_Tone{a,2}; length(Delta_M243_Tone{a,3})/DurDeltaEpoch_M243_Tone{a,3}; length(Delta_M243_Tone{a,4})/DurDeltaEpoch_M243_Tone{a,4}; length(Delta_M243_Tone{a,5})/DurDeltaEpoch_M243_Tone{a,5}];
end
for a=1:length(Path_Mouse244_Delta)
    QtDelta_M244_Tone{a}=[length(Delta_M244_Tone{a,1})/DurDeltaEpoch_M244_Tone{a,1}; length(Delta_M244_Tone{a,2})/DurDeltaEpoch_M244_Tone{a,2}; length(Delta_M244_Tone{a,3})/DurDeltaEpoch_M244_Tone{a,3}; length(Delta_M244_Tone{a,4})/DurDeltaEpoch_M244_Tone{a,4}; length(Delta_M244_Tone{a,5})/DurDeltaEpoch_M244_Tone{a,5}];
end
% <><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><>

% DELTA Distribution > BASAL SLEEP
for i=1:5
    MeanDelayDelta_M243_basal{i}=mean([delayDelta_M243_basal{1,i}',delayDelta_M243_basal{2,i}',delayDelta_M243_basal{3,i}',delayDelta_M243_basal{4,i}',delayDelta_M243_basal{5,i}'],2);
end
for i=1:5
    MeanDelayDelta_M244_basal{i}=mean([delayDelta_M244_basal{1,i}',delayDelta_M244_basal{2,i}',delayDelta_M244_basal{3,i}',delayDelta_M244_basal{4,i}',delayDelta_M244_basal{5,i}'],2);
end

% <><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><>

% BURST Quantity > BASAL SLEEP
QBurst_M243(1)=mean([length(Start(BurstDeltaEpoch_M243_basal(1,1))),length(Start(BurstDeltaEpoch_M243_basal(3,1))),length(Start(BurstDeltaEpoch_M243_basal(4,1))),length(Start(BurstDeltaEpoch_M243_basal(5,1)))],2);
for i=2:5
    QBurst_M243_basal(i)=mean([length(Start(BurstDeltaEpoch_M243_basal(1,i))),length(Start(BurstDeltaEpoch_M243_basal(2,i))),length(Start(BurstDeltaEpoch_M243_basal(3,i))),length(Start(BurstDeltaEpoch_M243_basal(4,i))),length(Start(BurstDeltaEpoch_M243_basal(5,i)))],2);
end
for i=1:5
    QBurst_M244_basal(i)=mean([length(Start(BurstDeltaEpoch_M244_basal(1,i))),length(Start(BurstDeltaEpoch_M244_basal(2,i))),length(Start(BurstDeltaEpoch_M244_basal(3,i))),length(Start(BurstDeltaEpoch_M244_basal(4,i))),length(Start(BurstDeltaEpoch_M244_basal(5,i)))],2);
end

QtBurstM243_basal(1)=mean([length(Start(BurstDeltaEpoch_M243_basal(1,1)))/DurDeltaEpoch_M243_basal{1,i},length(Start(BurstDeltaEpoch_M243_basal(3,1)))/DurDeltaEpoch_M243_basal{3,i},length(Start(BurstDeltaEpoch_M243_basal(4,1)))/DurDeltaEpoch_M243_basal{4,i},length(Start(BurstDeltaEpoch_M243_basal(5,1)))/DurDeltaEpoch_M243_basal{5,i}],2);
for i=2:5
    QtBurst_M243_basal(i)=mean([length(Start(BurstDeltaEpoch_M243_basal(1,i)))/DurDeltaEpoch_M243_basal{1,i},length(Start(BurstDeltaEpoch_M243_basal(2,i)))/DurDeltaEpoch_M243_basal{2,i},length(Start(BurstDeltaEpoch_M243_basal(3,i)))/DurDeltaEpoch_M243_basal{3,i},length(Start(BurstDeltaEpoch_M243_basal(4,i)))/DurDeltaEpoch_M243_basal{4,i},length(Start(BurstDeltaEpoch_M243_basal(5,i)))/DurDeltaEpoch_M243_basal{5,i}],2);
end
for i=1:5
    QtBurst_M244_basal(i)=mean([length(Start(BurstDeltaEpoch_M244_basal(1,i)))/DurDeltaEpoch_M244_basal{1,i},length(Start(BurstDeltaEpoch_M244_basal(2,i)))/DurDeltaEpoch_M244_basal{2,i},length(Start(BurstDeltaEpoch_M244_basal(3,i)))/DurDeltaEpoch_M244_basal{3,i},length(Start(BurstDeltaEpoch_M244_basal(4,i)))/DurDeltaEpoch_M244_basal{4,i},length(Start(BurstDeltaEpoch_M244_basal(5,i)))/DurDeltaEpoch_M244_basal{5,i}],2);
end

% Burst Quantity > DELTA SLEEP
for a=1:length(Path_Mouse243_Delta)-1
    QBurst_M243_Tone{a}=[length(Start(BurstDeltaEpoch_M243_Tone(a,1)));length(Start(BurstDeltaEpoch_M243_Tone(a,2)));length(Start(BurstDeltaEpoch_M243_Tone(a,3)));length(Start(BurstDeltaEpoch_M243_Tone(a,4)));length(Start(BurstDeltaEpoch_M243_Tone(a,5)))];
end
for a=1:length(Path_Mouse244_Delta)
    QBurst_M244_Tone{a}=[length(Start(BurstDeltaEpoch_M244_Tone(a,1)));length(Start(BurstDeltaEpoch_M244_Tone(a,2)));length(Start(BurstDeltaEpoch_M244_Tone(a,3)));length(Start(BurstDeltaEpoch_M244_Tone(a,4)));length(Start(BurstDeltaEpoch_M244_Tone(a,5)))];
end

for a=1:length(Path_Mouse243_Delta)
    QtBurst_M243_Tone{a}=[length(Start(BurstDeltaEpoch_M243_Tone(a,1)))/DurDeltaEpoch_M243_Tone{a,1},length(Start(BurstDeltaEpoch_M243_Tone(a,2)))/DurDeltaEpoch_M243_Tone{a,2},length(Start(BurstDeltaEpoch_M243_Tone(a,2)))/DurDeltaEpoch_M243_Tone{a,3},length(Start(BurstDeltaEpoch_M243_Tone(a,4)))/DurDeltaEpoch_M243_Tone{a,4},length(Start(BurstDeltaEpoch_M243_Tone(a,5)))/DurDeltaEpoch_M243_Tone{a,5}];
end
for a=1:length(Path_Mouse243_Delta)
    QtBurst_M244_Tone{a}=[length(Start(BurstDeltaEpoch_M244_Tone(a,1)))/DurDeltaEpoch_M244_Tone{a,1},length(Start(BurstDeltaEpoch_M244_Tone(a,2)))/DurDeltaEpoch_M244_Tone{a,2},length(Start(BurstDeltaEpoch_M244_Tone(a,2)))/DurDeltaEpoch_M244_Tone{a,3},length(Start(BurstDeltaEpoch_M244_Tone(a,4)))/DurDeltaEpoch_M244_Tone{a,4},length(Start(BurstDeltaEpoch_M244_Tone(a,5)))/DurDeltaEpoch_M244_Tone{a,5}];
end

% <><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><>

% BURST distribution > BASAL SLEEP
MeanDelayBurst_M243_basal{1}=mean([delayBurst_M243_basal{1,i}',delayBurst_M243_basal{3,i}',delayBurst_M243_basal{4,i}',delayBurst_M243_basal{5,i}'],2);
for i=2:5
    MeanDelayBurst_M243_basal{i}=mean([delayBurst_M243_basal{1,i}',delayBurst_M243_basal{2,i}',delayBurst_M243_basal{3,i}',delayBurst_M243_basal{4,i}',delayBurst_M243_basal{5,i}'],2);
end

for i=1:5
    MeanDelayBurst_M244_basal{i}=mean([delayBurst_M244_basal{1,i}',delayBurst_M244_basal{2,i}',delayBurst_M244_basal{3,i}',delayBurst_M244_basal{4,i}',delayBurst_M244_basal{5,i}'],2);
end


% <><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><>
% <><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><>
%---------------------------------------------------------------------------------------------------------------------------------------------------
%                                                                     PLOT ALL THAT
%---------------------------------------------------------------------------------------------------------------------------------------------------
% <><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><>
% <><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><>
try plo
catch
    plo=0;
end

if plo==1
    
    % Delta Quantity for mice 243 & 244
    l{1}='Basal';l{2}='delay: 140ms';l{3}='delay: 200ms';l{4}='delay: 320ms';l{5}='delay: 480ms';l{6}='delay: 3*140ms';
    gg{1}='9-11h';gg{2}='11-13h (Delta)';gg{3}='13-15h';gg{4}='15-17h (Delta)';gg{5}='17-19h';
%     figure('color',[1 1 1])
%     hold on, subplot(2,1,1)
%     hold on, h=bar([QDelta_M243_basal',QDelta_M243_Tone{1},QDelta_M243_Tone{2},QDelta_M243_Tone{3}]);
%     hold on, legend(h,l)
%     hold on, title(' Quantity of Delta Waves - (Mouse 243)')
%     set(gca,'xtick',[1:5],'xticklabel',gg)
%     hold on, subplot(2,1,2)
%     hold on, h=bar([QDelta_M244_basal',QDelta_M244_Tone{1},QDelta_M244_Tone{2},QDelta_M244_Tone{3}]);
%     hold on, legend(h,l)
%     hold on, title(' Quantity of Delta Waves - (Mouse 244)')
%     set(gca,'xtick',[1:5],'xticklabel',gg)
    
    % Delta Frequency for mice 243 & 244
    figure('color',[1 1 1])
    hold on, subplot(2,1,1)
    hold on, h=bar([QtDelta_M243_basal',QtDelta_M243_Tone{1},QtDelta_M243_Tone{2},QtDelta_M243_Tone{3},QtDelta_M243_Tone{4},QtDelta_M243_Tone{5}]);
    hold on, legend(h,l)
    hold on, title(' Delta/sec - (Mouse 243)')
    set(gca,'xtick',[1:5],'xticklabel',gg)
    hold on, subplot(2,1,2)
    hold on, h=bar([QtDelta_M244_basal',QtDelta_M244_Tone{1},QtDelta_M244_Tone{2},QtDelta_M244_Tone{3},QtDelta_M244_Tone{4},QtDelta_M244_Tone{5}]);
    hold on, legend(h,l)
    hold on, title(' Delta/sec - (Mouse 244)')
    set(gca,'xtick',[1:5],'xticklabel',gg)
    
    % Burst Quantity for mice 243 & 244
%     figure('color',[1 1 1])
%     hold on, subplot(2,1,1)
%     hold on, h=bar([QBurst_M243_basal',QBurst_M243_Tone{1},QBurst_M243_Tone{2},QBurst_M243_Tone{3}]);
%     hold on, legend(h,l)
%     hold on, title(' Quantity of Burst - (Mouse 243)')
%     set(gca,'xtick',[1:5],'xticklabel',gg)
%     hold on, subplot(2,1,2)
%     hold on, h=bar([QBurst_M244_basal',QBurst_M244_Tone{1},QBurst_M244_Tone{2},QBurst_M244_Tone{3}]);
%     hold on, legend(h,l)
%     hold on, title(' Quantity of Burst - (Mouse 244)')
%     set(gca,'xtick',[1:5],'xticklabel',gg)
    
    % Burst Frequency for mice 243 & 244
    figure('color',[1 1 1])
    hold on, subplot(2,1,1)
    hold on, h=bar([QtBurst_M243_basal',QtBurst_M243_Tone{1}',QtBurst_M243_Tone{2}',QtBurst_M243_Tone{3}',QtBurst_M243_Tone{4}',QtBurst_M243_Tone{5}']);
    hold on, legend(h,l)
    hold on, title(' Burst/sec - (Mouse 243)')
    set(gca,'xtick',[1:5],'xticklabel',gg)
    hold on, subplot(2,1,2)
    hold on, h=bar([QtBurst_M244_basal',QtBurst_M244_Tone{1}',QtBurst_M244_Tone{2}',QtBurst_M244_Tone{3}',QtBurst_M244_Tone{4}',QtBurst_M244_Tone{5}']);
    hold on, legend(h,l)
    hold on, title(' Burst/sec - (Mouse 244)')
    set(gca,'xtick',[1:5],'xticklabel',gg)
    
    
    ll{1}='PRE';ll{2}='Delta';ll{3}='POST';
    % Mouse 243 - delay distribution
    figure('color',[1 1 1]),
    hold on, subplot(6,2,1)
    hold on, plot(b1,smooth(MeanDelayDelta_M243_basal{1,1},3),'k'),
    hold on, plot(b1,smooth(MeanDelayDelta_M243_basal{1,2},3),'r'),
    hold on, plot(b1,smooth(MeanDelayDelta_M243_basal{1,3},3),'b'), xlim([0 2]), ylim([0 100])
    hold on, legend(ll)
    hold on, title('Delta delay Basal Sleep - 9h-13h -Mouse 243')
    hold on, subplot(6,2,2)
    hold on, plot(b1,smooth(MeanDelayDelta_M243_basal{1,3},3),'k'),
    hold on, plot(b1,smooth(MeanDelayDelta_M243_basal{1,4},3),'r'),
    hold on, plot(b1,smooth(MeanDelayDelta_M243_basal{1,5},3),'b'), xlim([0 2]), ylim([0 100])
    hold on, legend(ll)
    hold on, title('Delta delay Basal Sleep - 13h-19h - Mouse 243')
    hold on, subplot(6,2,3)
    hold on, plot(b1,smooth(delayDelta_M243_Tone{1,1},2),'k'),
    hold on, plot(b1,smooth(delayDelta_M243_Tone{1,2},2),'r'),
    hold on, plot(b1,smooth(delayDelta_M243_Tone{1,3},2),'b'), xlim([0 2]), ylim([0 100])
    hold on, line([0.3 0.3],[0 150])
    hold on, legend(ll)
    hold on, title('Delta delay Tone (delay=140ms) - 9h-13h')
    hold on, subplot(6,2,4)
    hold on, plot(b1,smooth(delayDelta_M243_Tone{1,3},2),'k'),
    hold on, plot(b1,smooth(delayDelta_M243_Tone{1,4},2),'r'),
    hold on, plot(b1,smooth(delayDelta_M243_Tone{1,5},2),'b'), xlim([0 2]), ylim([0 100])
    hold on, line([0.3 0.3],[0 150])
    hold on, legend(ll)
    hold on, title('Delta delay Tone (delay=140ms) - 13h-19h')
    hold on, subplot(6,2,5)
    hold on, plot(b1,smooth(delayDelta_M243_Tone{2,1},2),'k'),
    hold on, plot(b1,smooth(delayDelta_M243_Tone{2,2},2),'r'),
    hold on, plot(b1,smooth(delayDelta_M243_Tone{2,3},2),'b'), xlim([0 2]), ylim([0 100])
    hold on, line([0.36 0.36],[0 150])
    hold on, legend(ll)
    hold on, title('Delta delay Tone (delay=200ms) - 9h-13h')
    hold on, subplot(6,2,6)
    hold on, plot(b1,smooth(delayDelta_M243_Tone{2,3},2),'k'),
    hold on, plot(b1,smooth(delayDelta_M243_Tone{2,4},2),'r'),
    hold on, plot(b1,smooth(delayDelta_M243_Tone{2,5},2),'b'), xlim([0 2]), ylim([0 100])
    hold on, line([0.36 0.36],[0 150])
    hold on, legend(ll)
    hold on, title('Delta delay Tone (delay=200ms) - 13h-19h')
    hold on, subplot(6,2,7)
    hold on, plot(b1,smooth(delayDelta_M243_Tone{3,1},2),'k'),
    hold on, plot(b1,smooth(delayDelta_M243_Tone{3,2},2),'r'),
    hold on, plot(b1,smooth(delayDelta_M243_Tone{3,3},2),'b'), xlim([0 2]), ylim([0 100])
    hold on, line([0.48 0.48],[0 150])
    hold on, legend(ll)
    hold on, title('Delta delay Tone (delay=320ms) - 9h-13h')
    hold on, subplot(6,2,8)
    hold on, plot(b1,smooth(delayDelta_M243_Tone{3,3},2),'k'),
    hold on, plot(b1,smooth(delayDelta_M243_Tone{3,4},2),'r'),
    hold on, plot(b1,smooth(delayDelta_M243_Tone{3,5},2),'b'), xlim([0 2]), ylim([0 100])
    hold on, line([0.48 0.48],[0 150])
    hold on, legend(ll)
    hold on, title('Delta delay Tone (delay=320ms) - 13h-19h')
    hold on, subplot(6,2,9)
    hold on, plot(b1,smooth(delayDelta_M243_Tone{4,1},2),'k'),
    hold on, plot(b1,smooth(delayDelta_M243_Tone{4,2},2),'r'),
    hold on, plot(b1,smooth(delayDelta_M243_Tone{4,3},2),'b'), xlim([0 2]), ylim([0 100])
    hold on, line([0.65 0.65],[0 150])
    hold on, legend(ll)
    hold on, title('Delta delay Tone (delay=490ms) - 9h-13h')
    hold on, subplot(6,2,10)
    hold on, plot(b1,smooth(delayDelta_M243_Tone{4,3},2),'k'),
    hold on, plot(b1,smooth(delayDelta_M243_Tone{4,4},2),'r'),
    hold on, plot(b1,smooth(delayDelta_M243_Tone{4,5},2),'b'), xlim([0 2]), ylim([0 100])
    hold on, line([0.65 0.65],[0 150])
    hold on, legend(ll)
    hold on, title('Delta delay Tone (delay=490ms) - 13h-19h')
    hold on, subplot(6,2,11)
    hold on, plot(b1,smooth(delayDelta_M243_Tone{5,1},2),'k'),
    hold on, plot(b1,smooth(delayDelta_M243_Tone{5,2},2),'r'),
    hold on, plot(b1,smooth(delayDelta_M243_Tone{5,3},2),'b'), xlim([0 2]), ylim([0 100])
    hold on, line([0.65 0.65],[0 150])
    hold on, legend(ll)
    hold on, title('Delta delay Tone (delay=3*140) - 9h-13h')
    hold on, subplot(6,2,12)
    hold on, plot(b1,smooth(delayDelta_M243_Tone{5,3},2),'k'),
    hold on, plot(b1,smooth(delayDelta_M243_Tone{5,4},2),'r'),
    hold on, plot(b1,smooth(delayDelta_M243_Tone{5,5},2),'b'), xlim([0 2]), ylim([0 100])
    hold on, line([0.65 0.65],[0 150])
    hold on, legend(ll)
    hold on, title('Delta delay Tone (delay=3*140) - 13h-19h')
    
    % Mouse 244 - delay distribution
    figure('color',[1 1 1]),
    hold on, subplot(6,2,1)
    hold on, plot(b1,smooth(MeanDelayDelta_M244_basal{1,1},3),'k'),
    hold on, plot(b1,smooth(MeanDelayDelta_M244_basal{1,2},3),'r'),
    hold on, plot(b1,smooth(MeanDelayDelta_M244_basal{1,3},3),'b'), xlim([0 2]),  ylim([0 150])
    hold on, legend(ll)
    hold on, title('Delta delay Basal Sleep - 9h-13h -Mouse 244')
    hold on, subplot(6,2,2)
    hold on, plot(b1,smooth(MeanDelayDelta_M244_basal{1,3},3),'k'),
    hold on, plot(b1,smooth(MeanDelayDelta_M244_basal{1,4},3),'r'),
    hold on, plot(b1,smooth(MeanDelayDelta_M244_basal{1,5},3),'b'), xlim([0 2]), ylim([0 150])
    hold on, legend(ll)
    hold on, title('Delta delay Basal Sleep - 13h-19h - Mouse 244')
    hold on, subplot(6,2,3)
    hold on, plot(b1,smooth(delayDelta_M244_Tone{1,1},2),'k'),
    hold on, plot(b1,smooth(delayDelta_M244_Tone{1,2},2),'r'),
    hold on, plot(b1,smooth(delayDelta_M244_Tone{1,3},2),'b'), xlim([0 2]), ylim([0 150])
    hold on, line([0.3 0.3],[0 150])
    hold on, legend(ll)
    hold on, title('Delta delay Tone (delay=140ms) - 9h-13h')
    hold on, subplot(6,2,4)
    hold on, plot(b1,smooth(delayDelta_M244_Tone{1,3},2),'k'),
    hold on, plot(b1,smooth(delayDelta_M244_Tone{1,4},2),'r'),
    hold on, plot(b1,smooth(delayDelta_M244_Tone{1,5},2),'b'), xlim([0 2]), ylim([0 150])
    hold on, line([0.3 0.3],[0 150])
    hold on, legend(ll)
    hold on, title('Delta delay Tone (delay=140ms) - 13h-19h')
    hold on, subplot(6,2,5)
    hold on, plot(b1,smooth(delayDelta_M244_Tone{2,1},2),'k'),
    hold on, plot(b1,smooth(delayDelta_M244_Tone{2,2},2),'r'),
    hold on, plot(b1,smooth(delayDelta_M244_Tone{2,3},2),'b'), xlim([0 2]), ylim([0 150])
    hold on, line([0.36 0.36],[0 150])
    hold on, legend(ll)
    hold on, title('Delta delay Tone (delay=200ms) - 9h-13h')
    hold on, subplot(6,2,6)
    hold on, plot(b1,smooth(delayDelta_M244_Tone{2,3},2),'k'),
    hold on, plot(b1,smooth(delayDelta_M244_Tone{2,4},2),'r'),
    hold on, plot(b1,smooth(delayDelta_M244_Tone{2,5},2),'b'), xlim([0 2]), ylim([0 150])
    hold on, line([0.36 0.36],[0 150])
    hold on, legend(ll)
    hold on, title('Delta delay Tone (delay=200ms) - 13h-19h')
    hold on, subplot(6,2,7)
    hold on, plot(b1,smooth(delayDelta_M244_Tone{3,1},2),'k'),
    hold on, plot(b1,smooth(delayDelta_M244_Tone{3,2},2),'r'),
    hold on, plot(b1,smooth(delayDelta_M244_Tone{3,3},2),'b'), xlim([0 2]), ylim([0 150])
    hold on, line([0.48 0.48],[0 150])
    hold on, legend(ll)
    hold on, title('Delta delay Tone (delay=320ms) - 9h-13h')
    hold on, subplot(6,2,8)
    hold on, plot(b1,smooth(delayDelta_M244_Tone{3,3},2),'k'),
    hold on, plot(b1,smooth(delayDelta_M244_Tone{3,4},2),'r'),
    hold on, plot(b1,smooth(delayDelta_M244_Tone{3,5},2),'b'), xlim([0 2]), ylim([0 150])
    hold on, line([0.48 0.48],[0 150])
    hold on, legend(ll)
    hold on, title('Delta delay Tone (delay=320ms) - 13h-19h')
    hold on, subplot(6,2,9)
    hold on, plot(b1,smooth(delayDelta_M244_Tone{4,1},2),'k'),
    hold on, plot(b1,smooth(delayDelta_M244_Tone{4,2},2),'r'),
    hold on, plot(b1,smooth(delayDelta_M244_Tone{4,3},2),'b'), xlim([0 2]), ylim([0 150])
    hold on, line([0.65 0.65],[0 150])
    hold on, legend(ll)
    hold on, title('Delta delay Tone (delay=490ms) - 9h-13h')
    hold on, subplot(6,2,10)
    hold on, plot(b1,smooth(delayDelta_M244_Tone{4,3},2),'k'),
    hold on, plot(b1,smooth(delayDelta_M244_Tone{4,4},2),'r'),
    hold on, plot(b1,smooth(delayDelta_M244_Tone{4,5},2),'b'), xlim([0 2]), ylim([0 150])
    hold on, line([0.65 0.65],[0 150])
    hold on, legend(ll)
    hold on, title('Delta delay Tone (delay=490ms) - 13h-19h')
    hold on, subplot(6,2,11)
    hold on, plot(b1,smooth(delayDelta_M244_Tone{5,1},2),'k'),
    hold on, plot(b1,smooth(delayDelta_M244_Tone{5,2},2),'r'),
    hold on, plot(b1,smooth(delayDelta_M244_Tone{5,3},2),'b'), xlim([0 2]), ylim([0 100])
    hold on, line([0.65 0.65],[0 150])
    hold on, legend(ll)
    hold on, title('Delta delay Tone (delay=3*140) - 9h-13h')
    hold on, subplot(6,2,12)
    hold on, plot(b1,smooth(delayDelta_M244_Tone{5,3},2),'k'),
    hold on, plot(b1,smooth(delayDelta_M244_Tone{5,4},2),'r'),
    hold on, plot(b1,smooth(delayDelta_M244_Tone{5,5},2),'b'), xlim([0 2]), ylim([0 100])
    hold on, line([0.65 0.65],[0 150])
    hold on, legend(ll)
    hold on, title('Delta delay Tone (delay=3*140) - 13h-19h')
    
    lll{1}='Delta-PRE';lll{2}='Delta-POST';
    % Mouse 243 - delay distribution differences
    figure('color',[1 1 1]),
    hold on, subplot(6,2,1)
    hold on, plot(b1,smooth(MeanDelayDelta_M243_basal{1,2}-MeanDelayDelta_M243_basal{1,1},3),'k'),
    hold on, plot(b1,smooth(MeanDelayDelta_M243_basal{1,2}-MeanDelayDelta_M243_basal{1,3},3),'b'), , xlim([0 2]), ylim([-45 45])
    hold on, legend(lll)
    hold on, title('Delta delay Basal Sleep - 9h-13h -Mouse 243')
    hold on, subplot(6,2,2)
    hold on, plot(b1,smooth(MeanDelayDelta_M243_basal{1,4}-MeanDelayDelta_M243_basal{1,3},3),'k'),
    hold on, plot(b1,smooth(MeanDelayDelta_M243_basal{1,4}-MeanDelayDelta_M243_basal{1,5},3),'b'), , xlim([0 2]), ylim([-45 45])
    hold on, legend(lll)
    hold on, title('Delta delay Basal Sleep - 13h-19h - Mouse 243')
    hold on, subplot(6,2,3)
    hold on, plot(b1,smooth(delayDelta_M243_Tone{1,2}-delayDelta_M243_Tone{1,1},3),'k'),
    hold on, plot(b1,smooth(delayDelta_M243_Tone{1,2}-delayDelta_M243_Tone{1,3},3),'b'), , xlim([0 2]), ylim([-45 45])
    hold on, line([0.3 0.3],[-45 45])
    hold on, legend(lll)
    hold on, title('Delta delay Tone (delay=140ms) - 9h-13h')
    hold on, subplot(6,2,4)
    hold on, plot(b1,smooth(delayDelta_M243_Tone{1,4}-delayDelta_M243_Tone{1,3},3),'k'),
    hold on, plot(b1,smooth(delayDelta_M243_Tone{1,4}-delayDelta_M243_Tone{1,5},3),'b'), , xlim([0 2]), ylim([-45 45])
    hold on, line([0.3 0.3],[-45 45])
    hold on, legend(lll)
    hold on, title('Delta delay Tone (delay=140ms) - 13h-19h')
    hold on, subplot(6,2,5)
    hold on, plot(b1,smooth(delayDelta_M243_Tone{2,2}-delayDelta_M243_Tone{2,1},3),'k'),
    hold on, plot(b1,smooth(delayDelta_M243_Tone{2,2}-delayDelta_M243_Tone{2,3},3),'b'), , xlim([0 2]), ylim([-45 45])
    hold on, line([0.36 0.36],[-45 45])
    hold on, legend(lll)
    hold on, title('Delta delay Tone (delay=200ms) - 9h-13h')
    hold on, subplot(6,2,6)
    hold on, plot(b1,smooth(delayDelta_M243_Tone{2,4}-delayDelta_M243_Tone{2,3},3),'k'),
    hold on, plot(b1,smooth(delayDelta_M243_Tone{2,4}-delayDelta_M243_Tone{2,5},3),'b'), , xlim([0 2]), ylim([-45 45])
    hold on, line([0.36 0.36],[-45 45])
    hold on, legend(lll)
    hold on, title('Delta delay Tone (delay=200ms) - 13h-19h')
    hold on, subplot(6,2,7)
    hold on, plot(b1,smooth(delayDelta_M243_Tone{3,2}-delayDelta_M243_Tone{3,1},3),'k'),
    hold on, plot(b1,smooth(delayDelta_M243_Tone{3,2}-delayDelta_M243_Tone{3,3},3),'b'), , xlim([0 2]), ylim([-45 45])
    hold on, line([0.48 0.48],[-45 45])
    hold on, legend(lll)
    hold on, title('Delta delay Tone (delay=320ms) - 9h-13h')
    hold on, subplot(6,2,8)
    hold on, plot(b1,smooth(delayDelta_M243_Tone{3,4}-delayDelta_M243_Tone{3,3},3),'k'),
    hold on, plot(b1,smooth(delayDelta_M243_Tone{3,4}-delayDelta_M243_Tone{3,5},3),'b'), , xlim([0 2]), ylim([-45 45])
    hold on, line([0.48 0.48],[-45 45])
    hold on, legend(lll)
    hold on, title('Delta delay Tone (delay=320ms) - 13h-19h')
    hold on, subplot(6,2,9)
    hold on, plot(b1,smooth(delayDelta_M243_Tone{4,2}-delayDelta_M243_Tone{4,1},3),'k'),
    hold on, plot(b1,smooth(delayDelta_M243_Tone{4,2}-delayDelta_M243_Tone{4,3},3),'b'), , xlim([0 2]), ylim([-45 45])
    hold on, line([0.65 0.65],[-45 45])
    hold on, legend(lll)
    hold on, title('Delta delay Tone (delay=490ms) - 9h-13h')
    hold on, subplot(6,2,10)
    hold on, plot(b1,smooth(delayDelta_M243_Tone{4,4}-delayDelta_M243_Tone{4,3},3),'k'),
    hold on, plot(b1,smooth(delayDelta_M243_Tone{4,4}-delayDelta_M243_Tone{4,5},3),'b'), , xlim([0 2]), ylim([-45 45])
    hold on, line([0.65 0.65],[-45 45])
    hold on, legend(lll)
    hold on, title('Delta delay Tone (delay=490ms) - 13h-19h')
    hold on, subplot(6,2,11)
    hold on, plot(b1,smooth(delayDelta_M243_Tone{5,2}-delayDelta_M243_Tone{5,1},3),'k'),
    hold on, plot(b1,smooth(delayDelta_M243_Tone{5,2}-delayDelta_M243_Tone{5,3},3),'b'), , xlim([0 2]), ylim([-45 45])
    hold on, line([0.65 0.65],[-45 45])
    hold on, legend(lll)
    hold on, title('Delta delay Tone (delay=3*140) - 9h-13h')
    hold on, subplot(6,2,12)
    hold on, plot(b1,smooth(delayDelta_M243_Tone{5,4}-delayDelta_M243_Tone{5,3},3),'k'),
    hold on, plot(b1,smooth(delayDelta_M243_Tone{5,4}-delayDelta_M243_Tone{5,5},3),'b'), , xlim([0 2]), ylim([-45 45])
    hold on, line([0.65 0.65],[-45 45])
    hold on, legend(lll)
    hold on, title('Delta delay Tone (delay=3*140) - 13h-19h')
    
    % Mouse 244 - delay distribution differences
    figure('color',[1 1 1]),
    hold on, subplot(6,2,1)
    hold on, plot(b1,smooth(MeanDelayDelta_M244_basal{1,2}-MeanDelayDelta_M244_basal{1,1},3),'k'),
    hold on, plot(b1,smooth(MeanDelayDelta_M244_basal{1,2}-MeanDelayDelta_M244_basal{1,3},3),'b'), , xlim([0 2]), ylim([-45 45])
    hold on, legend(lll)
    hold on, title('Delta delay Basal Sleep - 9h-13h -Mouse 244')
    hold on, subplot(6,2,2)
    hold on, plot(b1,smooth(MeanDelayDelta_M244_basal{1,4}-MeanDelayDelta_M244_basal{1,3},3),'k'),
    hold on, plot(b1,smooth(MeanDelayDelta_M244_basal{1,4}-MeanDelayDelta_M244_basal{1,5},3),'b'), , xlim([0 2]), ylim([-45 45])
    hold on, legend(lll)
    hold on, title('Delta delay Basal Sleep - 13h-19h - Mouse 244')
    hold on, subplot(6,2,3)
    hold on, plot(b1,smooth(delayDelta_M243_Tone{1,2}-delayDelta_M243_Tone{1,1},3),'k'),
    hold on, plot(b1,smooth(delayDelta_M243_Tone{1,2}-delayDelta_M243_Tone{1,3},3),'b'), , xlim([0 2]), ylim([-45 45])
    hold on, line([0.3 0.3],[-45 45])
    hold on, legend(lll)
    hold on, title('Delta delay Tone (delay=140ms) - 9h-13h')
    hold on, subplot(6,2,4)
    hold on, plot(b1,smooth(delayDelta_M244_Tone{1,4}-delayDelta_M244_Tone{1,3},3),'k'),
    hold on, plot(b1,smooth(delayDelta_M244_Tone{1,4}-delayDelta_M244_Tone{1,5},3),'b'), , xlim([0 2]), ylim([-45 45])
    hold on, line([0.3 0.3],[-45 45])
    hold on, legend(lll)
    hold on, title('Delta delay Tone (delay=140ms) - 13h-19h')
    hold on, subplot(6,2,5)
    hold on, plot(b1,smooth(delayDelta_M244_Tone{2,2}-delayDelta_M244_Tone{2,1},3),'k'),
    hold on, plot(b1,smooth(delayDelta_M244_Tone{2,2}-delayDelta_M244_Tone{2,3},3),'b'), , xlim([0 2]), ylim([-45 45])
    hold on, line([0.36 0.36],[-45 45])
    hold on, legend(lll)
    hold on, title('Delta delay Tone (delay=200ms) - 9h-13h')
    hold on, subplot(6,2,6)
    hold on, plot(b1,smooth(delayDelta_M244_Tone{2,4}-delayDelta_M244_Tone{2,3},3),'k'),
    hold on, plot(b1,smooth(delayDelta_M244_Tone{2,4}-delayDelta_M244_Tone{2,5},3),'b'), , xlim([0 2]), ylim([-45 45])
    hold on, line([0.36 0.36],[-45 45])
    hold on, legend(lll)
    hold on, title('Delta delay Tone (delay=200ms) - 13h-19h')
    hold on, subplot(6,2,7)
    hold on, plot(b1,smooth(delayDelta_M244_Tone{3,2}-delayDelta_M244_Tone{3,1},3),'k'),
    hold on, plot(b1,smooth(delayDelta_M244_Tone{3,2}-delayDelta_M244_Tone{3,3},3),'b'), , xlim([0 2]), ylim([-45 45])
    hold on, line([0.48 0.48],[-45 45])
    hold on, legend(lll)
    hold on, title('Delta delay Tone (delay=320ms) - 9h-13h')
    hold on, subplot(6,2,8)
    hold on, plot(b1,smooth(delayDelta_M244_Tone{3,4}-delayDelta_M244_Tone{3,3},3),'k'),
    hold on, plot(b1,smooth(delayDelta_M244_Tone{3,4}-delayDelta_M244_Tone{3,5},3),'b'), , xlim([0 2]), ylim([-45 45])
    hold on, line([0.48 0.48],[-45 45])
    hold on, legend(lll)
    hold on, title('Delta delay Tone (delay=320ms) - 13h-19h')    
    hold on, subplot(6,2,9)
    hold on, plot(b1,smooth(delayDelta_M244_Tone{4,2}-delayDelta_M244_Tone{4,1},3),'k'),
    hold on, plot(b1,smooth(delayDelta_M244_Tone{4,2}-delayDelta_M244_Tone{4,3},3),'b'), , xlim([0 2]), ylim([-45 45])
    hold on, line([0.65 0.65],[-45 45])
    hold on, legend(lll)
    hold on, title('Delta delay Tone (delay=490ms) - 9h-13h')
    hold on, subplot(6,2,10)
    hold on, plot(b1,smooth(delayDelta_M244_Tone{4,4}-delayDelta_M244_Tone{4,3},3),'k'),
    hold on, plot(b1,smooth(delayDelta_M244_Tone{4,4}-delayDelta_M244_Tone{4,5},3),'b'), , xlim([0 2]), ylim([-45 45])
    hold on, line([0.65 0.65],[-45 45])
    hold on, legend(lll)
    hold on, title('Delta delay Tone (delay=490ms) - 13h-19h')
    hold on, subplot(6,2,11)
    hold on, plot(b1,smooth(delayDelta_M244_Tone{5,2}-delayDelta_M244_Tone{5,1},3),'k'),
    hold on, plot(b1,smooth(delayDelta_M244_Tone{5,2}-delayDelta_M244_Tone{5,3},3),'b'), , xlim([0 2]), ylim([-45 45])
    hold on, line([0.65 0.65],[-45 45])
    hold on, legend(lll)
    hold on, title('Delta delay Tone (delay=3*140) - 9h-13h')
    hold on, subplot(6,2,12)
    hold on, plot(b1,smooth(delayDelta_M244_Tone{5,4}-delayDelta_M244_Tone{5,3},3),'k'),
    hold on, plot(b1,smooth(delayDelta_M244_Tone{5,4}-delayDelta_M244_Tone{5,5},3),'b'), , xlim([0 2]), ylim([-45 45])
    hold on, line([0.65 0.65],[-45 45])
    hold on, legend(lll)
    hold on, title('Delta delay Tone (delay=3*140) - 13h-19h')
    
    
    ll{1}='PRE';ll{2}='Delta';ll{3}='POST';
    % Mouse 243 - Burst distribution
    figure('color',[1 1 1]),
    hold on, subplot(6,2,1)
    hold on, plot(b2,smooth(MeanDelayBurst_M243_basal{1,1},3),'k'),
    hold on, plot(b2,smooth(MeanDelayBurst_M243_basal{1,2},3),'r'),
    hold on, plot(b2,smooth(MeanDelayBurst_M243_basal{1,3},3),'b'), xlim([0 1]), ylim([0 40])
    hold on, legend(ll)
    hold on, title('Delta Burst Basal Sleep - 9h-13h -Mouse 243')
    hold on, subplot(6,2,2)
    hold on, plot(b1,smooth(MeanDelayBurst_M243_basal{1,3},3),'k'),
    hold on, plot(b1,smooth(MeanDelayBurst_M243_basal{1,4},3),'r'),
    hold on, plot(b1,smooth(MeanDelayBurst_M243_basal{1,5},3),'b'), xlim([0 1]), ylim([0 40])
    hold on, legend(ll)
    hold on, title('Delta Burst Basal Sleep - 13h-19h - Mouse 243')
    hold on, subplot(6,2,3)
    hold on, plot(b1,smooth(delayBurst_M243_Tone{1,1},3),'k'),
    hold on, plot(b1,smooth(delayBurst_M243_Tone{1,2},3),'r'),
    hold on, plot(b1,smooth(delayBurst_M243_Tone{1,3},3),'b'), xlim([0 1]), ylim([0 40])
    hold on, line([0.3 0.3],[0 150])
    hold on, legend(ll)
    hold on, title('Delta Burst Tone (delay=140ms) - 9h-13h')
    hold on, subplot(6,2,4)
    hold on, plot(b1,smooth(delayBurst_M243_Tone{1,3},3),'k'),
    hold on, plot(b1,smooth(delayBurst_M243_Tone{1,4},3),'r'),
    hold on, plot(b1,smooth(delayBurst_M243_Tone{1,5},3),'b'), xlim([0 1]), ylim([0 40])
    hold on, line([0.3 0.3],[0 150])
    hold on, legend(ll)
    hold on, title('Delta Burst Tone (delay=140ms) - 13h-19h')
    hold on, subplot(6,2,5)
    hold on, plot(b1,smooth(delayBurst_M243_Tone{2,1},3),'k'),
    hold on, plot(b1,smooth(delayBurst_M243_Tone{2,2},3),'r'),
    hold on, plot(b1,smooth(delayBurst_M243_Tone{2,3},3),'b'), xlim([0 1]), ylim([0 40])
    hold on, line([0.36 0.36],[0 150])
    hold on, legend(ll)
    hold on, title('Delta Burst Tone (delay=200ms) - 9h-13h')
    hold on, subplot(6,2,6)
    hold on, plot(b1,smooth(delayBurst_M243_Tone{2,3},3),'k'),
    hold on, plot(b1,smooth(delayBurst_M243_Tone{2,4},3),'r'),
    hold on, plot(b1,smooth(delayBurst_M243_Tone{2,5},3),'b'), xlim([0 1]), ylim([0 40])
    hold on, line([0.36 0.36],[0 150])
    hold on, legend(ll)
    hold on, title('Delta Burst Tone (delay=200ms) - 13h-19h')
    hold on, subplot(6,2,7)
    hold on, plot(b1,smooth(delayBurst_M243_Tone{3,1},3),'k'),
    hold on, plot(b1,smooth(delayBurst_M243_Tone{3,2},3),'r'),
    hold on, plot(b1,smooth(delayBurst_M243_Tone{3,3},3),'b'), xlim([0 1]), ylim([0 40])
    hold on, line([0.48 0.48],[0 150])
    hold on, legend(ll)
    hold on, title('Delta Burst Tone (delay=320ms) - 9h-13h')
    hold on, subplot(6,2,8)
    hold on, plot(b1,smooth(delayBurst_M243_Tone{3,3},3),'k'),
    hold on, plot(b1,smooth(delayBurst_M243_Tone{3,4},3),'r'),
    hold on, plot(b1,smooth(delayBurst_M243_Tone{3,5},3),'b'), xlim([0 1]), ylim([0 40])
    hold on, line([0.48 0.48],[0 150])
    hold on, legend(ll)
    hold on, title('Delta Burst Tone (delay=320ms) - 13h-19h')
    hold on, subplot(6,2,9)
    hold on, plot(b1,smooth(delayBurst_M243_Tone{4,1},3),'k'),
    hold on, plot(b1,smooth(delayBurst_M243_Tone{4,2},3),'r'),
    hold on, plot(b1,smooth(delayBurst_M243_Tone{4,3},3),'b'), xlim([0 1]), ylim([0 80])
    hold on, line([0.65 0.65],[0 150])
    hold on, legend(ll)
    hold on, title('Delta Burst Tone (delay=490ms) - 9h-13h')
    hold on, subplot(6,2,10)
    hold on, plot(b1,smooth(delayBurst_M243_Tone{4,3},3),'k'),
    hold on, plot(b1,smooth(delayBurst_M243_Tone{4,4},3),'r'),
    hold on, plot(b1,smooth(delayBurst_M243_Tone{4,5},3),'b'), xlim([0 1]), ylim([0 80])
    hold on, line([0.65 0.65],[0 150])
    hold on, legend(ll)
    hold on, title('Delta Burst Tone (delay=490ms) - 13h-19h')
    hold on, subplot(6,2,11)
    hold on, plot(b1,smooth(delayBurst_M243_Tone{5,1},3),'k'),
    hold on, plot(b1,smooth(delayBurst_M243_Tone{5,2},3),'r'),
    hold on, plot(b1,smooth(delayBurst_M243_Tone{5,3},3),'b'), xlim([0 1]), ylim([0 80])
    hold on, line([0.65 0.65],[0 150])
    hold on, legend(ll)
    hold on, title('Delta Burst Tone (delay=3*140) - 9h-13h')
    hold on, subplot(6,2,12)
    hold on, plot(b1,smooth(delayBurst_M243_Tone{5,3},3),'k'),
    hold on, plot(b1,smooth(delayBurst_M243_Tone{5,4},3),'r'),
    hold on, plot(b1,smooth(delayBurst_M243_Tone{5,5},3),'b'), xlim([0 1]), ylim([0 80])
    hold on, line([0.65 0.65],[0 150])
    hold on, legend(ll)
    hold on, title('Delta Burst Tone (delay=3*140) - 13h-19h')
    
    ll{1}='PRE';ll{2}='Delta';ll{3}='POST';
    % Mouse 244 - Burst distribution
    figure('color',[1 1 1]),
    hold on, subplot(6,2,1)
    hold on, plot(b2,smooth(MeanDelayBurst_M244_basal{1,1},3),'k'),
    hold on, plot(b2,smooth(MeanDelayBurst_M244_basal{1,2},3),'r'),
    hold on, plot(b2,smooth(MeanDelayBurst_M244_basal{1,3},3),'b'), xlim([0 1]), ylim([0 80])
    hold on, legend(ll)
    hold on, title('Delta Burst Basal Sleep - 9h-13h -Mouse 244')
    hold on, subplot(6,2,2)
    hold on, plot(b1,smooth(MeanDelayBurst_M244_basal{1,3},3),'k'),
    hold on, plot(b1,smooth(MeanDelayBurst_M244_basal{1,4},3),'r'),
    hold on, plot(b1,smooth(MeanDelayBurst_M244_basal{1,5},3),'b'), xlim([0 1]), ylim([0 80])
    hold on, legend(ll)
    hold on, title('Delta Burst Basal Sleep - 13h-19h - Mouse 244')
    hold on, subplot(6,2,3)
    hold on, plot(b1,smooth(delayBurst_M244_Tone{1,1},3),'k'),
    hold on, plot(b1,smooth(delayBurst_M244_Tone{1,2},3),'r'),
    hold on, plot(b1,smooth(delayBurst_M244_Tone{1,3},3),'b'), xlim([0 1]), ylim([0 80])
    hold on, line([0.3 0.3],[0 150])
    hold on, legend(ll)
    hold on, title('Delta Burst Tone (delay=140ms) - 9h-13h')
    hold on, subplot(6,2,4)
    hold on, plot(b1,smooth(delayBurst_M244_Tone{1,3},3),'k'),
    hold on, plot(b1,smooth(delayBurst_M244_Tone{1,4},3),'r'),
    hold on, plot(b1,smooth(delayBurst_M244_Tone{1,5},3),'b'), xlim([0 1]), ylim([0 80])
    hold on, line([0.3 0.3],[0 150])
    hold on, legend(ll)
    hold on, title('Delta Burst Tone (delay=140ms) - 13h-19h')
    hold on, subplot(6,2,5)
    hold on, plot(b1,smooth(delayBurst_M244_Tone{2,1},3),'k'),
    hold on, plot(b1,smooth(delayBurst_M244_Tone{2,2},3),'r'),
    hold on, plot(b1,smooth(delayBurst_M244_Tone{2,3},3),'b'), xlim([0 1]), ylim([0 80])
    hold on, line([0.36 0.36],[0 150])
    hold on, legend(ll)
    hold on, title('Delta Burst Tone (delay=200ms) - 9h-13h')
    hold on, subplot(6,2,6)
    hold on, plot(b1,smooth(delayBurst_M244_Tone{2,3},3),'k'),
    hold on, plot(b1,smooth(delayBurst_M244_Tone{2,4},3),'r'),
    hold on, plot(b1,smooth(delayBurst_M244_Tone{2,5},3),'b'), xlim([0 1]), ylim([0 80])
    hold on, line([0.36 0.36],[0 150])
    hold on, legend(ll)
    hold on, title('Delta Burst Tone (delay=200ms) - 13h-19h')
    hold on, subplot(6,2,7)
    hold on, plot(b1,smooth(delayBurst_M244_Tone{3,1},3),'k'),
    hold on, plot(b1,smooth(delayBurst_M244_Tone{3,2},3),'r'),
    hold on, plot(b1,smooth(delayBurst_M244_Tone{3,3},3),'b'), xlim([0 1]), ylim([0 80])
    hold on, line([0.48 0.48],[0 150])
    hold on, legend(ll)
    hold on, title('Delta Burst Tone (delay=320ms) - 9h-13h')
    hold on, subplot(6,2,8)
    hold on, plot(b1,smooth(delayBurst_M244_Tone{3,3},3),'k'),
    hold on, plot(b1,smooth(delayBurst_M244_Tone{3,4},3),'r'),
    hold on, plot(b1,smooth(delayBurst_M244_Tone{3,5},3),'b'), xlim([0 1]), ylim([0 80])
    hold on, line([0.48 0.48],[0 150])
    hold on, legend(ll)
    hold on, title('Delta Burst Tone (delay=320ms) - 13h-19h')
    hold on, subplot(6,2,9)
    hold on, plot(b1,smooth(delayBurst_M244_Tone{4,1},3),'k'),
    hold on, plot(b1,smooth(delayBurst_M244_Tone{4,2},3),'r'),
    hold on, plot(b1,smooth(delayBurst_M244_Tone{4,3},3),'b'), xlim([0 1]), ylim([0 80])
    hold on, line([0.65 0.65],[0 150])
    hold on, legend(ll)
    hold on, title('Delta Burst Tone (delay=490ms) - 9h-13h')
    hold on, subplot(6,2,10)
    hold on, plot(b1,smooth(delayBurst_M244_Tone{4,3},3),'k'),
    hold on, plot(b1,smooth(delayBurst_M244_Tone{4,4},3),'r'),
    hold on, plot(b1,smooth(delayBurst_M244_Tone{4,5},3),'b'), xlim([0 1]), ylim([0 80])
    hold on, line([0.65 0.65],[0 150])
    hold on, legend(ll)
    hold on, title('Delta Burst Tone (delay=490ms) - 13h-19h')
    hold on, subplot(6,2,11)
    hold on, plot(b1,smooth(delayBurst_M244_Tone{5,1},3),'k'),
    hold on, plot(b1,smooth(delayBurst_M244_Tone{5,2},3),'r'),
    hold on, plot(b1,smooth(delayBurst_M244_Tone{5,3},3),'b'), xlim([0 1]), ylim([0 80])
    hold on, line([0.65 0.65],[0 150])
    hold on, legend(ll)
    hold on, title('Delta Burst Tone (delay=3*140) - 9h-13h')
    hold on, subplot(6,2,12)
    hold on, plot(b1,smooth(delayBurst_M244_Tone{5,3},3),'k'),
    hold on, plot(b1,smooth(delayBurst_M244_Tone{5,4},3),'r'),
    hold on, plot(b1,smooth(delayBurst_M244_Tone{5,5},3),'b'), xlim([0 1]), ylim([0 80])
    hold on, line([0.65 0.65],[0 150])
    hold on, legend(ll)
    hold on, title('Delta Burst Tone (delay=3*140) - 13h-19h')
    
    
end
end

