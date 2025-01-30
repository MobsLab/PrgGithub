% PoolDataActi.m
%
% other related scripts and functions :
%   - AnalyseActimeterML.m
%   - ActimetrySleepScorCompar.m
%   - ActiToData.m
%   - ActimetryQuantifSleep.m
%   - GetAllDataActi.m

% -------------------------------------------------------------------------
% -------------------------------------------------------------------------
%% indicate Folder
cd('/media/DataMOBsRAID/ProjetSLEEPActi')
if isempty(strfind(pwd,'/'));mark='\'; else, mark='/';end

disp('Choose all the folder to pool (recurent chose, stop by ''cancel'')');
namePool='SLEEPActi-Pooled';
ok=0; d=0;
while ok~=1
    d=d+1;
    temp=uigetdir(pwd,'get session folder e.g SLEEPActi-20150620-0002');
    if temp==0
        ok=1; 
    else
        dirname{d}=temp; 
        disp(dirname{d});
        namePool=[namePool,'-',temp(end-3:end)];
    ende09-signal.dat
         loading 0025-cag
end
mkdir(namePool);
save([namePool,mark,'TsdData.mat'],'dirname')

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




