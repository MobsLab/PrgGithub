function [REMEpoch,SWSEpoch,Wake,Sleep]=FindBehavEpochPreDefinesThresholds(gamma_thresh,theta_thresh,smooth_ghi,smooth_Theta,TotNoiseEpoch)

ThetaI=[3 3]; %merge and drop
mindur=3; %abs cut off for events;
mw_dur=5; %max length of microarousal
sl_dur=15; %min duration of sleep around microarousal
ms_dur=10; % max length of microsleep
wa_dur=20; %min duration of wake around microsleep

r=Range(smooth_ghi);
TotalEpoch=intervalSet(0*1e4,r(end));
TotalEpoch=TotalEpoch-TotNoiseEpoch;

clear SWSEpoch REMEpoch wakeper
smooth_ghi=Restrict(smooth_ghi,TotalEpoch);
ghi_new=Restrict(smooth_ghi,TotalEpoch);
theta_new=Restrict(smooth_Theta,TotalEpoch);

clear sleepper
sleepper=thresholdIntervals(smooth_ghi,gamma_thresh,'Direction','Below');
sleepper=mergeCloseIntervals(sleepper,mindur*1e4);
sleepper=dropShortIntervals(sleepper,mindur*1e4);
clear ThetaEpoch
ThetaEpoch=thresholdIntervals(smooth_Theta,theta_thresh,'Direction','Above');
ThetaEpoch=mergeCloseIntervals(ThetaEpoch,ThetaI(1)*1E4);
ThetaEpoch=dropShortIntervals(ThetaEpoch,ThetaI(2)*1E4);

% We presume that after a REM phase (ie theta during sleep), the end of the
% sleep phase is aligned with the end of REM
tep=Start(ThetaEpoch);
tep2=Stop(ThetaEpoch);
sep=Stop(sleepper);
for t=1:length(Start(ThetaEpoch))
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
str=Start(sleepper);
str((Start(sleepper)<sep==0))=[];
sep((Start(sleepper)<sep==0))=[];
sleepper=intervalSet(str,sep);

sep=Start(sleepper);
for t=1:length(Start(ThetaEpoch))
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
str=Stop(sleepper);
str((Stop(sleepper)>sep==0))=[];
sep((Stop(sleepper)>sep==0))=[];
sleepper=intervalSet(sep,Stop(sleepper));

wakeper=TotalEpoch-sleepper;
wakeper=dropShortIntervals(wakeper,mindur*1e4); % wake per near noise
TotSleep=sleepper;
TotWake=wakeper;
TotSleep=CleanUpEpoch(TotSleep);
TotWake=CleanUpEpoch(TotWake);
REMEpoch=and(sleepper,ThetaEpoch);
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

MicroWake=MicroWake-TotNoiseEpoch;

% modif KB-------------------
try
    MicroWake=MicroWake-TotalNoiseEpoch;
end
% modif KB-------------------


strSleep=CleanUpEpoch(strSleep);
MicroWake=CleanUpEpoch(MicroWake);
strWake=strWake-TotNoiseEpoch; strWake=CleanUpEpoch(strWake);

Wake=wakeper-strWake; Wake=CleanUpEpoch(Wake);
Wake=Wake-MicroWake; Wake=CleanUpEpoch(Wake);
Sleep=Sleep-strSleep; Sleep=CleanUpEpoch(Sleep);


end