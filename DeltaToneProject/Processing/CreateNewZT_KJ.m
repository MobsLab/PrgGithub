%%CreateNewZT_KJ


try
    load behavResources
    evt;
    disp('Done')
catch

    SetCurrentSession

    evt=GetEvents('output','Descriptions');
    tpsdeb={}; tpsfin={};nameSession={};tpsEvt={};
    try
        if strcmp(evt{1},'0'), evt=evt(2:end);end

        for i=1:length(evt)

            tpsEvt{i}=GetEvents(evt{i});
            if evt{i}(1)=='b'
                tpsdeb=[tpsdeb,tpsEvt{i}];
                nameSession=[nameSession,evt{i}(14:end)];
            elseif evt{i}(1)=='e'
                tpsfin=[tpsfin,tpsEvt{i}];
            end
        end
    catch
        % manual definition  evt (Julie)  SALE !
        disp('manual redefinition of evt, ckeck ouputs')
        res=pwd;
        indMouse=strfind(res,'Mouse-');
        MouseNb=res(indMouse+7:indMouse+9);
        %MouseNb=res(51:53);
        Date=res(indMouse+10:indMouse+17);
        evt={};
        evt{1,1}=['beginning of Sleep-Mouse-' MouseNb '-' Date ];
        evt{1,2}=['end of Sleep-Mouse-' MouseNb '-' Date ];
        load(fullfile('LFPData','LFP0.mat'),'LFP')

        tpsdeb{1}=0;
        rg = Range(LFP)/1e4;
        tpsfin{1}=rg(end);
        tpsEvt={tpsdeb{1} tpsfin{1}};
        %evt.time{1,1}=0;
        %evt.time{1,2}=PosMat(end,1);
        nameSession{1}=evt{1}(14:end);
    end

    try
        save behavResources -append evt tpsEvt tpsdeb tpsfin nameSession 
    catch
        save behavResources evt tpsEvt tpsdeb tpsfin nameSession 
    end
end

try
    load('behavResources.mat','TimeEndRec')
    TimeEndRec; disp('Done')
catch
    disp(' '); disp('GetTimeOfDataRecordingML.m')
    try
        GetTimeOfDataRecordingML;
        disp('Done');
    catch
        disp('Problem... SKIP');
    end
end
    

%% load the necessary information
load('behavResources.mat','TimeEndRec','TimeDebRec','tpsdeb','tpsfin')
load('LFPData/InfoLFP.mat')
load(['LFPData/LFP' num2str(InfoLFP.channel(1))])

nb_epoch = size(TimeDebRec,1);

if nb_epoch==1

    LFPBlock  = Range(LFP);
    BeginTime = TimeDebRec(1,:)*[3600 60 1]';

    NewtsdZT_Data = LFPBlock+BeginTime*1e4;
    NewtsdZT_Times = LFPBlock;

    NewtsdZT = tsd(NewtsdZT_Times,NewtsdZT_Data);
    save('behavResources','NewtsdZT','-append')

else
    NewtsdZT_Data = [];
    NewtsdZT_Times = [];
    for k=1:nb_epoch
        % Get exact beginning and end of the first file
        LittleEpoch = intervalSet(tpsdeb{k}*1e4,tpsfin{k}*1e4);

        % Get the LFP times and set them to zero (the beginning of this file)
        LFPBlock  = Range(Restrict(LFP,LittleEpoch));
        LFPBlock_zero = LFPBlock - LFPBlock(1);

        % Convert the time to seconds since midnight
        BeginTime = TimeDebRec(k,:)*[3600 60 1]';

        NewtsdZT_Data = [NewtsdZT_Data;LFPBlock_zero+BeginTime*1e4];
        NewtsdZT_Times = [NewtsdZT_Times;LFPBlock];

        NewtsdZT = tsd(NewtsdZT_Times,NewtsdZT_Data);
        save('behavResources','NewtsdZT','-append')

    end

end





