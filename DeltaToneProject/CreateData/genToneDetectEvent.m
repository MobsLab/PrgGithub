res=pwd;

disp(' <><><><><><><><><><>  ')
basename=input('give xml file basename:    ');
disp(' <><><><><><><><><><>  ')

load behavResources
cd([res,'/Info'])

disp(' <><><><><><><><><><>  ')
sessionDelta=input(' Which sessions for Delta Tone  ?      ');
disp(' <><><><><><><><><><>  ')
sessionSleep=input(' Which sessions for Basal Sleep ?      ');
disp(' <><><><><><><><><><>  ')

% Detection with triggered tone
for i=sessionDelta
    load([res,'/Info/',basename,'-0',num2str(i),'-DeltaSleep-fires_matrix']);
    FIRES{i}=fires(:,1)+tpsdeb{i}*1E4;
    %load([res,'/Info/',basename,'-0',num2str(i),'-DeltaSleep-fires_actual_time']);
    %FIRESactual{i}=fires_actual_time(:,1)+tpsdeb{i}*1E4;
end
TONEtime1=[FIRES{1,sessionDelta(1)};FIRES{1,sessionDelta(2)}];
%TONEtime2=[FIRESactual{1,sessionDelta(1)};FIRESactual{1,sessionDelta(2)}];


% Detection all
for i=sessionSleep
    try
    load([res,'/Info/',basename,'-0',num2str(i),'-Sleep-detections_matrix']);
    detect{i}=detections(:,1)+tpsdeb{i}*1E4;
    end
end
for i=sessionDelta
    try
    load([res,'/Info/',basename,'-0',num2str(i),'-DeltaSleep-detections_matrix']);
    detect{i}=detections(:,1)+tpsdeb{i}*1E4;
    end
end
if length(tpsdeb)==5
    DeltaDetect=[detect{1,1};detect{1,2};detect{1,3};detect{1,4};detect{1,5}];
elseif length(tpsdeb)==6
    DeltaDetect=[detect{1,1};detect{1,2};detect{1,3};detect{1,4};detect{1,5};detect{1,6}];
end

% Restrit DeltaDetect to remove delta followed by tone
for i=1:length(TONEtime1(:,1))
    a(i)=find(DeltaDetect(:,1)==TONEtime1(i,1));
end
DeltaDetect(a,:)=[];

save DeltaSleepEvent DeltaDetect TONEtime1 %TONEtime2

%<><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><>

%cd([res,'/',basename])
load StateEpochSB SWSEpoch
TONEtime1_SWS=Range(Restrict(ts(sort([TONEtime1])),SWSEpoch));
%TONEtime2_SWS=Range(Restrict(ts(sort([TONEtime2])),SWSEpoch));
DeltaDetect_SWS=Range(Restrict(ts(sort([DeltaDetect])),SWSEpoch));


load StateEpochSB REMEpoch
TONEtime1_REM=Range(Restrict(ts(sort([TONEtime1])),REMEpoch));
%TONEtime2_REM=Range(Restrict(ts(sort([TONEtime2])),REMEpoch));
DeltaDetect_REM=Range(Restrict(ts(sort([DeltaDetect])),REMEpoch));


load StateEpochSB Wake
TONEtime1_Wake=Range(Restrict(ts(sort([TONEtime1])),Wake));
%TONEtime2_Wake=Range(Restrict(ts(sort([TONEtime2])),Wake));
DeltaDetect_Wake=Range(Restrict(ts(sort([DeltaDetect])),Wake));

%save DeltaSleepEvent DeltaDetect TONEtime1 TONEtime2
save DeltaSleepEvent -append  TONEtime1_SWS DeltaDetect_SWS %TONEtime2_SWS  
save DeltaSleepEvent -append  TONEtime1_REM DeltaDetect_REM %TONEtime2_REM  
save DeltaSleepEvent -append  TONEtime1_Wake DeltaDetect_Wake %TONEtime2_Wake  

disp(['tone during SWS =',num2str(length(TONEtime1_SWS))])
disp(['tone during REM =',num2str(length(TONEtime1_REM))])
disp(['tone during Wake =',num2str(length(TONEtime1_Wake))])

disp(' ')
disp(['DeltaDetect during SWS =',num2str(length(DeltaDetect_SWS))])
disp(['DeltaDetect during REM =',num2str(length(DeltaDetect_REM))])
disp(['DeltaDetect during Wake =',num2str(length(DeltaDetect_Wake))])

%<><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><>