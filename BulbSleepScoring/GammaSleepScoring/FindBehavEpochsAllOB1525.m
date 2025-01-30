function FindBehavEpochsAllOB1525(TotalEpoch,mindur,mw_dur,sl_dur,ms_dur,wa_dur,filename)

load(strcat(filename,'StateEpochSBAllOB_Bis'))
load(strcat(filename,'StateEpochSB'),'NoiseEpoch','GndNoiseEpoch')

% We presume that after a REM phase (ie theta during sleep), the end of the
% sleep phase is aligned with the end of REM
tep=Start(TenFifEpoch);
tep2=Stop(TenFifEpoch);
sep=Stop(sleepper);
for t=1:length(Start(TenFifEpoch))
    t1=ts(tep(t));
    t2=Restrict(t1,sleepper);
     if length(t2)~=0
         t3=tep2(t);
         [dur,num]=min(abs(sep-t3));
            if dur<5*1e4
                sep(num)=t3;
            end
     end
end
sleepper=intervalSet(Start(sleepper),sep);

sep=Start(sleepper);
for t=1:length(Start(TenFifEpoch))
    t1=ts(tep2(t));
    t2=Restrict(t1,sleepper);
     if length(t2)~=0
         t3=tep2(t);
         [dur,num]=min(abs(sep-t3));
            if dur<5*1e4
                sep(num)=t3;
            end
     end
end
sleepper=intervalSet(sep,Stop(sleepper));

wakeper=TotalEpoch-sleepper;
wakeper=dropShortIntervals(wakeper,mindur*1e4); % wake per near noise
TotSleep=sleepper;
TotWake=wakeper;
TotSleep=CleanUpEpoch(TotSleep);
TotWake=CleanUpEpoch(TotWake);
REMEpoch=and(sleepper,TenFifEpoch);  
SWSEpoch=sleepper-REMEpoch;
SWSEpoch=CleanUpEpoch(SWSEpoch);
REMEpoch=CleanUpEpoch(REMEpoch);

% 
% try
% REMEpoch=REMEpoch-TotalNoiseEpoch; 
% end
% try
% SWSEpoch=SWSEpoch-TotalNoiseEpoch; 
% end


%we're going to presume that the noise during waking is waking so as to
%find microarousals etc
noiswakeper=TotalEpoch-sleepper;
noiswakeper=CleanUpEpoch(noiswakeper);
noiswakeper=dropShortIntervals(noiswakeper,mindur*1e4); % wake per near noise

MicroWake=SandwichEpoch(noiswakeper,sleepper,mw_dur*1e4,sl_dur*1e4);
MicroSleep=SandwichEpoch(sleepper,noiswakeper,ms_dur*1e4,wa_dur*1e4);
MicroWake=CleanUpEpoch(MicroWake);
MicroSleep=CleanUpEpoch(MicroSleep);

noiswakeper=noiswakeper-MicroWake;
Sleep=sleepper-MicroSleep;
noiswakeper=CleanUpEpoch(noiswakeper);
sleepper=CleanUpEpoch(sleepper);

strWake=getshortintervals(noiswakeper,mw_dur*1e4);
strSleep=getshortintervals(sleepper,ms_dur*1e4);
strWake=CleanUpEpoch(strWake);
strSleep=CleanUpEpoch(strSleep);

MicroWake=MicroWake-NoiseEpoch-GndNoiseEpoch; 

% modif KB-------------------
try
MicroWake=MicroWake-TotalNoiseEpoch; 
end
% modif KB-------------------


strSleep=CleanUpEpoch(strSleep);
MicroWake=CleanUpEpoch(MicroWake);
strWake=strWake-NoiseEpoch; strWake=CleanUpEpoch(strWake);
strWake=strWake-GndNoiseEpoch; strWake=CleanUpEpoch(strWake);

% modif KB-------------------
try
strWake=strWake-TotalNoiseEpoch; strWake=CleanUpEpoch(strWake);
end
% modif KB-------------------

Wake=wakeper-strWake; Wake=CleanUpEpoch(Wake);
Wake=Wake-MicroWake; Wake=CleanUpEpoch(Wake);
Sleep=Sleep-strSleep; Sleep=CleanUpEpoch(Sleep);
[aft_cell,bef_cell]=transEpoch(wakeper,REMEpoch);

disp( ' ')
disp(strcat('wake to REM transitions :',num2str(size(Start(aft_cell{1,2}),1))))


% modif KB-------------------
try
    [aft_cell,bef_cell]=transEpoch(TotalNoiseEpoch,Sleep);
catch
    [aft_cell,bef_cell]=transEpoch(or(NoiseEpoch,GndNoiseEpoch),Sleep);
    disp('**********  not all Noise Epoch ************')
end
% modif KB-------------------



nsleep=and(aft_cell{1,2},bef_cell{1,2});
disp(strcat('noise periods during sleep :',num2str(size(Start(nsleep)/1e4,1))))
disp( ' ')


save(strcat(filename,'StateEpochSBAllOB_Bis'),'REMEpoch','SWSEpoch','wakeper','Sleep','Wake','strWake','strSleep','MicroSleep','MicroWake','-v7.3','-append');
end