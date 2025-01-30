function AnalyseMNT(folderName,filename,NameManipe)

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%% INPUTS
NameManipedefault='MNT2';
tjitterArduino=0.3; % step of arduino activation
freq=25000; % frequence acquisition en Hz
StartChannel=11;
StopChannel=12;
StimTrigChannel=10;
StimPulseChannel=0;
PhotoDetectors=[1:8];
BasenameDO='Di_D1_';
LengthStim=5; % time in seconde

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%% INITIATE
disp(' ')
if ~exist('folderName','var')
    folderName=pwd;
end
if isempty(strfind(folderName,'/')), mark='\'; else mark='/';end
if ~exist('filename','var')
    filename=input('Enter file name to open : ','s');
end
if strcmp(filename(end-3:end),'.mat')
    filename=filename(1:end-4);
end
if ~exist('NameManipe','var')
    NameManipe=NameManipedefault;
end
disp([' *** ',filename,' ***']);
load([folderName,mark,filename]);

filenameS=[filename(1:strfind(filename,'-wideband')-1),'-A'];

tempn=strfind(filename,'-');
tempn=tempn(tempn>strfind(filename,'Mouse-'));
n_mouse=str2num(filename(tempn(1)+1:tempn(2)-1));
n_day=str2num(filename(strfind(filename,'Day')+3));
n_session=str2num(filename(strfind(filename,'Session')+7));


%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%% GET VARIABLES
varNames=who;
filenamevar=filename;
filenamevar(strfind(filename,'-'))='_';

% save variables
save([folderName,mark,filenameS],'StartChannel','StopChannel','StimTrigChannel','StimPulseChannel','PhotoDetectors','BasenameDO')
save([folderName,mark,filenameS],'-append','n_mouse','n_day','n_session')

for i=1:length(varNames)
    if strfind(varNames{i},filenamevar)
        eval(['temp=',varNames{i},'.title;']);
        
        if  strfind(temp,BasenameDO)
            clear Por Lev
            eval(['Por=',varNames{i},'.times;']);
            eval(['Lev=',varNames{i},'.level;']);
            % is start/stop or stim
            if strcmp(temp,[BasenameDO,num2str(StartChannel)])
                TpsStart=Por(Lev==0); save([folderName,mark,filenameS],'-append','TpsStart')
                disp([temp,' --> TpsStart']);
            elseif strcmp(temp,[BasenameDO,num2str(StopChannel)])
                TpsStop=Por(Lev==0);save([folderName,mark,filenameS],'-append','TpsStop')
                disp([temp,' --> TpsStop']);
            elseif strcmp(temp,[BasenameDO,num2str(StimTrigChannel)])
                TStimTrig=ts(Por(Lev==0)*1E4);save([folderName,mark,filenameS],'-append','TStimTrig')
                disp([temp,' --> TStimTrig']);
            elseif strcmp(temp,[BasenameDO,num2str(StimPulseChannel)])
                TStimPulse=ts(Por(Lev==0)*1E4);save([folderName,mark,filenameS],'-append','TStimPulse')
                disp([temp,' --> TStimPulse']);
           
            end
        elseif strcmp(temp,'Di_D1')
            eval(['lenghtRec=',varNames{i},'.length;']);
            disp([temp,' -> length recording =',num2str(floor(lenghtRec/freq)),'s'])
        else
            disp(temp);
        end
    end
end    
if ~exist('TpsStop','var')
    if exist('lenghtRec','var')
        TpsStop=lenghtRec/freq;
    else
        TpsStop=input('Enter manually time of aquisition stop (in s): ');
    end
    save([folderName,mark,filenameS],'-append','TpsStop')
end
if ~exist('TpsStart','var')
    TpsStart=0;
    save([folderName,mark,filenameS],'-append','TpsStart')
end
    
for i=1:length(varNames)
    if strfind(varNames{i},filenamevar)
        eval(['temp=',varNames{i},'.title;']);
        
        if  strfind(temp,BasenameDO)
            clear Por Lev
            eval(['Por=',varNames{i},'.times;']);
            eval(['Lev=',varNames{i},'.level;']);
            % is photodetector
            for pd=PhotoDetectors
                if strcmp(temp,[BasenameDO,num2str(pd)])
                    % Port is an intervalSet
                    sti=Por(Lev==0); 
                    ste=Por(Lev==1);
                    
                    sti=sti(sti<TpsStop)-tjitterArduino;
                    ste=ste(ste<=TpsStop);
                    Lev=Lev(Por<TpsStop);
                    if ~isempty(Lev)
                        if Lev(length(Lev))==0
                            ste=[ste;TpsStop];
                        end
                        if Lev(1)==1
                            sti=[0;sti];
                        end
                        
                        if length(ste)==length(sti)
                            eval(['Port',num2str(pd),'=intervalSet(sti*1E4,ste*1E4);'])
                            eval(['save(''',[folderName,mark,filenameS],'.mat'',','''-append'',','''Port',num2str(pd),''');'])
                            disp([temp,' --> Port',num2str(pd)]);
                        else
                            keyboard
                        end
                    end
                end
            end
        end
    end
end
disp(['... All has been saved in ',filenameS])


%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%% ASK WHICH REWARDED PORTS

aa=strfind(folderName,NameManipe);
try
    load([folderName(1:aa+length(NameManipe)),'Config_',NameManipe,'_',num2str(n_mouse)])
    ConfigurationsMNT;
catch
    disp('Enter the different configurations name (eg {''A'',''B'',''C'',''D''}) ')
    ConfigurationsMNT=input(': ');
    disp('Enter rewarded ports for each config (eg [1 4])')
    for i=1:length(ConfigurationsMNT)
        ok=0;
        while ok==0
            try
                ConfigurationsMNT{2,i}=input(['config ',ConfigurationsMNT{1,i},' : ']);
                ok=1;
            catch
                fprintf('Error -> ')
            end
        end
    end
    save([folderName(1:aa+length(NameManipe)),'Config_',NameManipe,'_',num2str(n_mouse)],'ConfigurationsMNT')
end
save([folderName,mark,filenameS],'-append','ConfigurationsMNT')

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%% ANALYSE REWARDED PORTS
disp(' ')
% -------------------
% Time in each port
TimeInPorts=zeros(2,8); % time in ports and rewarded time in ports
StimInPorts=zeros(1,8); % number of stim in each port
TimeRealStim=[]; % time of the begining of each stimulation period
AllVisit=[];
 for i=1:8
    % is visited?
    try
        eval(['TimeInPorts(1,',num2str(i),')=sum(Stop(Port',num2str(i),',''s'')-Start(Port',num2str(i),',''s''));']);
         eval(['AllVisit=[AllVisit;[Start(Port',num2str(i),',''s''),Stop(Port',num2str(i),',''s''),zeros(length(Start(Port',num2str(i),')),1)+i]];'])
    catch
        eval(['Port',num2str(i),'=intervalSet([],[]);'])
        disp([' empty Port',num2str(i)]);
        eval(['save(''',[folderName,mark,filenameS],'.mat'',','''-append'',','''Port',num2str(i),''');'])
    end
    
    % stims
    try
        eval(['temp=Range(Restrict(TStimTrig,Port',num2str(i),'),''s'');'])
        TempD=[6;diff(temp)];
        eval(['StimInPorts(',num2str(i),')=length(temp(TempD>LengthStim));'])
        TimeRealStim=[TimeRealStim;temp(TempD>5)];% remove re-entry >5ms
        
        StimON=intervalSet(temp(TempD>5)*1E4,(temp(TempD>5)+LengthStim)*1E4);
        eval(['StimOnI=and(Port',num2str(i),',StimON);']);
        TimeOnI=sum(Stop(StimOnI,'s')-Start(StimOnI,'s'));
        eval(['TimeInPorts(2,',num2str(i),')=TimeOnI;'])
        disp(['  -> ',num2str(length(temp(TempD>5))),' stim in port ',num2str(i),' (',num2str(TimeOnI),'s)'])
    end
 end
 TimeRealStim=sort(TimeRealStim);
 disp(['mean delay between 2stims: ',num2str(mean(diff(TimeRealStim))),'s'])
 tAllVisit=sortrows(AllVisit,1);
 
 delay_reEntry=[1,5]; %remove re-entry<1s and <5s
 
 for ttt=1:2
     % temp= tIN / tOUT / port / lasting / NewPort / delayWithLastPort
     tempvar=[tAllVisit,tAllVisit(:,2)-tAllVisit(:,1),[1;diff(tAllVisit(:,3))]~=0,[tAllVisit(1,1);(tAllVisit(2:end,1)-tAllVisit(1:end-1,2))]];
     
     tempvar(:,7)=(tempvar(:,5)~=0 | tempvar(:,6)> delay_reEntry(ttt));
     vartest=zeros(length(tempvar),1);
     vartestch=zeros(length(tempvar),1);
     indexVar=find(tempvar(:,7));
     
     for jj=1:length(tempvar)
         if (tempvar(jj,5)==0) && (tempvar(jj,7)==0)
             cumsumtemp=cumsumtemp+tempvar(jj,4);
         else
             try vartestch(indexVar(find(indexVar==jj)-1))=cumsumtemp;end
             cumsumtemp=tempvar(jj,4);
         end
         vartest(jj)=cumsumtemp;
     end
     vartestch(indexVar(end))=cumsumtemp;
     tempvar(:,8)=vartestch;
     
     if ttt==1
         TrueVisit=tempvar(find(tempvar(:,7)),[3,6,8]);
     else
         TrueVisit_5sDelay=tempvar(find(tempvar(:,7)),[3,6,8]);
     end
     
 end
 
 
% -------------------
% check config and rewarded ports
try 
    lisMNT=dir([folderName,mark,filename(1:strfind(filename,'-wideband')-1)]);
    for i=3:length(lisMNT)
        if length(lisMNT(i).name)>16 && strcmp(lisMNT(i).name(1:16),'reference_image_')
            configu=lisMNT(i).name(17);
        end
    end
catch
    disp(' !!!! PROBLEM !!!! No reference_image with config')
end

okk=0;
while okk~=1
    if ~exist('configu','var'),
        disp(['problem! Folder ',filename(1:strfind(filename,'-wideband')-1),' does not exist!']);
        configu=input('Enter the config (eg A) : ','s');
    end
    
    RewardedPorts=ConfigurationsMNT{2,strcmp(ConfigurationsMNT(1,:),configu)};
    disp(['Configuration ',configu,': rewarded ports = ',num2str(RewardedPorts)])
    
    % check that good config was given
    okk=1;
    for i=find(StimInPorts~=0)
        if ~ismember(i,RewardedPorts)
            disp(['Problem !! Given config does not match rewarded ports : ',num2str(find(StimInPorts~=0))])
            okk=0; clear configu
        end
    end
end

save([folderName,mark,filenameS],'-append','TimeInPorts','RewardedPorts','TimeRealStim','StimInPorts','tAllVisit','TrueVisit','TrueVisit_5sDelay')

% -------------------


%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%% DISPLAY
A=[TimeInPorts(1,:)-TimeInPorts(2,:);TimeInPorts(2,:)];
figure('Color',[1 1 1]), 
subplot(2,1,1), bar(100*A'/(TpsStop-TpsStart),'stacked')
xlabel('Port Num'); ylabel('% Time of the session')
title(filenameS), ylim([0, 100])
legend({'without stim','with stim'})

subplot(2,1,2), bar(100*A'/sum(TimeInPorts(1,:)),'stacked')
xlabel('Port Num'); ylabel('% of all the Time spent in ports')
line([0,9],[100/8,100/8],'Color','r'); text(4,100/7,'Chance Level','Color','r')
title(filenameS), ylim([0, 100])




