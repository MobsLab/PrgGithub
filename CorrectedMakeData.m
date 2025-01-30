% CorrectedMakeData

load behavResources
% 
% try
%     load StimMFB
%     burst;
% catch
    st=Range(stim,'s');
    bu = burstinfo(st,0.2);
    burst=tsd(bu.t_start*1E4,bu.i_start);
    idburst=bu.i_start;

    save StimMFB stim burst idburst
% end

%--------------------------------------------------------------------------------
%--------------------------------------------------------------------------------
%--------------------------------------------------------------------------------

try
try
    namePos;

catch

  res=pwd;
  eval(['cd(''',res,'-wideband'')'])

  list=dir;
  a=1;

  for i=1:length(list)
      le=length(list(i).name);
      if length(list(i).name)>12&list(i).name(le-11:le)=='wideband.smr'
	  list(i).name
	  
	  
	  %----------------------------------------------------
	  try
	      load namePos
	      namePos
	  catch
	      namePos{a}=list(i).name(1:le-4);
	      a=a+1;
	  end
      end
  end

    eval(['cd(''',res,''')'])
save behavResources -Append namePos
end
end



try
    namePos;

catch

  

  list=dir;
  a=1;

  for i=1:length(list)
      le=length(list(i).name);
      if length(list(i).name)>12&list(i).name(le-11:le)=='wideband.dat'
	  list(i).name
	  
	  
	  %----------------------------------------------------
	  try
	      load namePos
	      namePos
	  catch
	      namePos{a}=list(i).name(1:le-4);
	      a=a+1;
	  end
      end
  end


save behavResources -Append namePos
end









%--------------------------------------------------------------------------------
%--------------------------------------------------------------------------------
%--------------------------------------------------------------------------------



clear tpsdeb
clear tpsfin

for a=1:length(namePos)
    prodtest=0;
    for i=1:length(evt)
        len=length(namePos{a});
        leni=length(evt{i});
        if leni>len & namePos{a}==evt{i}(leni-len+1:leni)    
            if evt{i}(1)=='b'
                tpsdeb{a}=tpsEvt{i};
%                             disp('debut')
%                             
%                             evt{i}
%                             keyboard

            elseif evt{i}(1)=='e'
                tpsfin{a}=tpsEvt{i};
%                             disp('fin')
%                             evt{i}
%                             keyboard
            end
        end
    end
end

save behavResources -Append namePos tpsEvt tpsdeb tpsfin

%--------------------------------------------------------------------------------
%--------------------------------------------------------------------------------
%--------------------------------------------------------------------------------

StartTracking=[];
StopTracking=[];
StartQuantifExplo=[];
StopQuantifExplo=[]; 
StartICSS=[];
StopICSS=[];
StartSleep=[];
StopSleep=[]; 
StartRest=[];
StopRest=[];
StartExplo=[];
StopExplo=[];


for i=1:length(namePos)

    StartTracking=[StartTracking;tpsdeb{i}*1E4];
    StopTracking=[StopTracking;tpsfin{i}*1E4];
    try
    if sum(ismember('ICSS',namePos{i}(10:end)))==4
        StartICSS=[StartICSS,tpsdeb{i}*1E4];
        StopICSS=[StopICSS;tpsfin{i}*1E4];
    end
    end
    try
    if sum(ismember('Sleep',namePos{i}(10:end)))==5
        
        na=namePos{i}(10:end);
        for j=1:length(na)
        if na(j)=='S'&na(j+1)=='l'&na(j+2)=='e'
%         namePos{i}
%         disp(num2str(j))
        StartSleep=[StartSleep;tpsdeb{i}*1E4];
        StopSleep=[StopSleep;tpsfin{i}*1E4];
        end
        end
        
    end
    end
    try
    if sum(ismember('Rest',namePos{i}(10:end)))==4
        StartRest=[StartRest;tpsdeb{i}*1E4];
        StopRest=[StopRest;tpsfin{i}*1E4];
    end
    end
    try
    if sum(ismember('Explo',namePos{i}(10:end)))==5
        StartExplo=[StartExplo;tpsdeb{i}*1E4];
        StopExplo=[StopExplo;tpsfin{i}*1E4];   
    end
    end

end

try
TrackingEpoch=intervalSet(StartTracking,StopTracking);
end
try
QuantifExploEpoch=intervalSet(StartQuantifExplo,StopQuantifExplo);
end
try
ICSSEpoch=intervalSet(StartICSS,StopICSS);
end
try
SleepEpoch=intervalSet(StartSleep,StopSleep);
end
try
RestEpoch=intervalSet(StartRest,StopRest);
end
try
ExploEpoch=intervalSet(StartExplo,StopExplo);
end



save behavResources -Append ExploEpoch RestEpoch SleepEpoch ICSSEpoch QuantifExploEpoch TrackingEpoch 


