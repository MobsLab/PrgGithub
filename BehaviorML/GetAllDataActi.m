%  GetAllDataActi.m
%
% other related scripts and functions :
%   - AnalyseActimeterML.m
%   - ActimetrySleepScorCompar.m
%   - ActiToData.m
%   - PoolDataActi.m
%   - ActimetryQuantifSleep.m
%   - an_actiML.m

% -------------------------------------------------------------------------
%% ----------------- Get all day of recording -----------------------------
% -------------------------------------------------------------------------
cd /media/DataMOBsRAID/ProjetSLEEPActi
res=pwd;
if isempty(strfind(res,'/'));mark='\'; else, mark='/';end


disp(' ')
disp('Getting all day of recording present in DataMOBsRAID/ProjetSLEEPActi')

list=dir; a=0;
for i=3:length(list)
    if length(list(i).name)>14 && strcmp(list(i).name(1:14),'SLEEPActi-2015')
        a=a+1;
        ListName{a}=list(i).name;
        
        if ~exist([list(i).name,mark,'TsdData.mat'],'file')
try            ActimetryQuantifSleep(list(i).name);end
            close all
        else
            disp(['          ',list(i).name,' ->  ActimetryQuantifSleep ok'])
        end
    end
end




% -------------------------------------------------------------------------
%% ----------------- complete or add Data ---------------------------------
% -------------------------------------------------------------------------
numCage=1;
char_i=num2str(numCage); if numCage<10, char_i=['0',char_i];end

FileTosave=['SLEEPActi-ALLData',mark,'Cage',char_i,mark,'TsdData.mat'];
try
    load(FileTosave)
    ActiTsd; do_it=0;
    disp(['Data has been loaded from ',FileTosave])
catch
    do_it=1; 
    NameList={};
    ActiTsd=tsd([],[]);
    DataScor=[];
    tpsEnd=[];
    evtScoring=tsd([],[]);
    evtSound=tsd([],[]);
    evtcalib=tsd([],[]);
    evtStim=ts([]);
end

indexAdd=[];
for a=1:length(ListName)
    if sum(strcmp(NameList,ListName{a}))==0
        indexAdd=[indexAdd,a];
        NameList=[NameList,ListName{a}];
        do_it=1; 
    end
end


%save(FileTosave,'-append','NameList')

%% Add data
if do_it
    for a=indexAdd
        cd([res,mark,ListName{a}])
        num=ListName{a}(end-3:end);
        
        if ~exist('tpsEnd','var')
            Tpsfile=dir([num,'-time.dat']);
            DateVector=datevec(Tpsfile.date) ;
            disp(['    Time of recording = ',Tpsfile.date])
            tpsEnd(a,1:6)=DateVector;
        end
        
    end
    
end

%% Resort data



% ------------------------------------------------------------------------
% --------------------------------------------------------------------------
%% Get scor Data
% do not take in account the ZT of recording...

disp(' ');
disp(['       * * ',namePool,' * * ']);
PoolDataScor=[];
PoolDataScor2=[];
TimeEnd=0;
for i=1:12
    if i<10, char_i=['0',num2str(i)]; else, char_i=num2str(i);end
     disp(['Cage #',char_i])
     
    for d=1:length(dirname)
         disp(dirname{d})
        try
            % ----------------
            % DataScor
            if i==1
                clear DataScor DataScor2 tpsEnd nameLabel
                load([dirname{d},mark,'TsdData.mat'],'DataScor','DataScor2','tpsEnd','nameLabel');
                PoolDataScor=[PoolDataScor;DataScor];
                PoolDataScor2=[PoolDataScor2;DataScor2];
                disp('   DataScor loaded from TsdData.mat')
                TimeEnd=TimeEnd+tpsEnd;
            end
            
            % ----------------
            % Actitsd
            eval(['temp=load(''',dirname{d},mark,'TsdData.mat'',''Acti',char_i,''');'])
            eval(['tA=temp.Acti',char_i,';'])
            try
                eval(['temptsd=Acti',char_i,';'])
                eval(['Acti',char_i,'=cat(temptsd,tsd(Range(tA)+max(Range(temptsd)),Data(tA)));'])
            catch
                eval(['Acti',char_i,'=tA;'])
            end
            
            % ----------------
            % evt
            eval(['temp=load(''',dirname{d},mark,'TsdData.mat'',''evtScoring',char_i,''',''evtSound',char_i,...
                ''',''evtStim',char_i,''',''evtcalib',char_i,''');'])
            eval(['tSc=temp.evtScoring',char_i,';']) % EVT_WAKE_UP = 1; EVT_FALL_ASLEEP = -1;
            eval(['tSn=temp.evtSound',char_i,';'])% EVT_SOUND_STOP = 10; EVT_SOUND = 11;
            eval(['tSt=temp.evtStim',char_i,';'])%EVT_SOUND_OSC = 12;
            eval(['tCa=temp.evtcalib',char_i,';'])% EVT_SOUND_STIM = 14
            
            try
                eval(['tempEvt=evtScoring',char_i,';']) 
                eval(['evtScoring',char_i,'=cat(tempEvt,tsd(Range(tSc)+ceil(max(Range(temptsd))),Data(tSc)));'])
                eval(['tempEvt=evtSound',char_i,';']) 
                eval(['evtSound',char_i,'=cat(tempEvt,tsd(Range(tSn)+ceil(max(Range(temptsd))),Data(tSn)));'])
                eval(['tempEvt=evtStim',char_i,';']) 
                eval(['evtStim',char_i,'=cat(tempEvt,tsd(Range(tSt)+ceil(max(Range(temptsd))),Data(tSt)));'])
                eval(['tempEvt=evtcalib',char_i,';']) 
                eval(['evtcalib',char_i,'=cat(tempEvt,tsd(Range(tCa)+ceil(max(Range(temptsd))),Data(tCa)));'])
                
            catch
                eval(['evtScoring',char_i,'=tSc;'])
                eval(['evtSound',char_i,'=tSn;'])
                eval(['evtStim',char_i,'=tSt;'])
                eval(['evtcalib',char_i,'=tCa;'])
            end
            
        catch
            error('   PROBLEM ! run ActimetryQuantifSleep.m ')
        end
    end
    DataScor=PoolDataScor;
    DataScor2=PoolDataScor2;
    tpsEnd=TimeEnd;
    eval(['save(''',namePool,mark,'TsdData.mat'',''-append'',''nameLabel'',''tpsEnd'',''DataScor'',''DataScor2'',''Acti',char_i,...
        ''',''evtScoring',char_i,''',''evtSound',char_i,''',''evtStim',char_i,''',''evtcalib',char_i,''');'])
end


% -------------------------------------------------------------------------
% -------------------------------------------------------------------------
%% Concatenate and respect ZT

