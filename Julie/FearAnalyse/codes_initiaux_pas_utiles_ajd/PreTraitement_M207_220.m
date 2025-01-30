% PreTraitement_M207_220
clear all 
close all

plo=0;

datalocation='server';

if strcmp(datalocation, 'DataMOBs14')    
    FolderPath='/media/DataMOBs14/ProjetAversion/ManipDec14Bulbectomie';
    for m=207:213
        FileInfo{1,m}=[FolderPath '/M' ,num2str(m),'/20141209/FEAR-Mouse-' ,num2str(m), '-09122014-HABpleth/FEAR-Mouse-' ,num2str(m), '-09122014-HABpleth-respi/'];
        FileInfo{2,m}=[FolderPath '/M' ,num2str(m),'/20141211/FEAR-Mouse-' ,num2str(m), '-11122014-EXTpleth/FEAR-Mouse-' ,num2str(m), '-11122014-EXTpleth-respi/'];  
        finalFileInfo{1,m}=[FolderPath '/M' ,num2str(m),'/20141209/FEAR-Mouse-' ,num2str(m), '-09122014-HABpleth/SyncedData/'];
        finalFileInfo{2,m}=[FolderPath '/M' ,num2str(m),'/20141211/FEAR-Mouse-' ,num2str(m), '-11122014-EXTpleth/SyncedData/'];  
    end
    for m=214:220
        FileInfo{1,m}=[FolderPath '/M' ,num2str(m),'/20141216/FEAR-Mouse-' ,num2str(m), '-16122014-HABpleth/FEAR-Mouse-' ,num2str(m), '-16122014-HABpleth-respi/'];
        FileInfo{2,m}=[FolderPath '/M' ,num2str(m),'/20141218/FEAR-Mouse-' ,num2str(m), '-18122014-EXTpleth/FEAR-Mouse-' ,num2str(m), '-18122014-EXTpleth-respi/']; 
        finalFileInfo{1,m}=[FolderPath '/M' ,num2str(m),'/20141216/FEAR-Mouse-' ,num2str(m), '-16122014-HABpleth/SyncedData/'];
        finalFileInfo{2,m}=[FolderPath '/M' ,num2str(m),'/20141218/FEAR-Mouse-' ,num2str(m), '-18122014-EXTpleth/SyncedData/']; 
    end
elseif strcmp(datalocation, 'server')
     FolderPath='/media/DataMOBsRAID/Projet Aversion/ManipDec14Bulbectomie';
    for m=207:213
        FileInfo{1,m}=[FolderPath '/M' ,num2str(m),'/20141209/FEAR-Mouse-' ,num2str(m), '-09122014-HABpleth/FEAR-Mouse-' ,num2str(m), '-09122014-HABpleth-respi/'];
        FileInfo{2,m}=[FolderPath '/M' ,num2str(m),'/20141211/FEAR-Mouse-' ,num2str(m), '-11122014-EXTpleth/FEAR-Mouse-' ,num2str(m), '-11122014-EXTpleth-respi/'];  
        finalFileInfo{1,m}=[FolderPath '/M' ,num2str(m),'/20141209/FEAR-Mouse-' ,num2str(m), '-09122014-HABpleth/SyncedData/'];
        finalFileInfo{2,m}=[FolderPath '/M' ,num2str(m),'/20141211/FEAR-Mouse-' ,num2str(m), '-11122014-EXTpleth/SyncedData/'];
    end
    for m=214:220
        FileInfo{1,m}=[FolderPath '/M' ,num2str(m),'/20141216/FEAR-Mouse-' ,num2str(m), '-16122014-HABpleth/FEAR-Mouse-' ,num2str(m), '-16122014-HABpleth-respi/'];
        FileInfo{2,m}=[FolderPath '/M' ,num2str(m),'/20141218/FEAR-Mouse-' ,num2str(m), '-18122014-EXTpleth/FEAR-Mouse-' ,num2str(m), '-18122014-EXTpleth-respi/']; 
        finalFileInfo{1,m}=[FolderPath '/M' ,num2str(m),'/20141216/FEAR-Mouse-' ,num2str(m), '-16122014-HABpleth/SyncedData/'];
        finalFileInfo{2,m}=[FolderPath '/M' ,num2str(m),'/20141218/FEAR-Mouse-' ,num2str(m), '-18122014-EXTpleth/SyncedData/']; 
    end 
end

cd(FolderPath)

mice=[207;208;209;210;214;215;216;211;212;213;217;218;219;220];
%mice=[208;209;210;214;215;216;211;212;213;217;218;219;220];
StepName={'HAB','EXT'};
load('default_event_info.mat') % needed if pb in evt info

for step=2:2 % HAB then EXT
    
    for mousenb=1:length(mice)
        m=mice(mousenb);
        
        filename{1}= FileInfo{step,m};
        finalfilename=finalFileInfo{step,m};
        mousetitle=['Mouse ' num2str(m) ' ' StepName{step}];
        
        cd (filename{1})
        SetCurrentSession
        warning off
        spk=1;
        res=pwd;


        if 1
            disp(' ');
            disp('LFP Data')

            try 
                load([res,'/LFPData/InfoLFP.mat'],'InfoLFP');
                load([res,'/LFPData/LFP',num2str(InfoLFP.channel(1))],'LFP');
                FragmentLFP='n';
            catch
                % loop to load old data where all LFPs were gathered in a single
                % file (.mat) but really heavy to load ) ->then fragmented into LFP0.mat LFP1.mat
                try
                    load LFPData
                    Range(LFP{1});
                    FragmentLFP=input('LFPData.mat exists, do you want to fragment LFPData.mat in folder LFPData (y/n) ? ','s');
                catch
                    FragmentLFP='y';
                end
            end

            if FragmentLFP=='y';
                try
                    % infoLFP for each channel
                    disp(' ');
                    disp('...Creating InfoLFP.mat')
                    try
                        InfoLFP=listLFP_to_InfoLFP_ML(res);
                    catch
                        disp('retry listLFP_to_InfoLFP_ML');keyboard;
                    end

                    % LFPs
                    disp(' ');
                    disp('...Creating LFPData.mat')


                    for i=1:length(InfoLFP.channel)
                        LFP_temp=GetLFP(InfoLFP.channel(i));
                        disp(['loading and saving LFP',num2str(InfoLFP.channel(i)),' in LFPData...']);
                        LFP=tsd(LFP_temp(:,1)*1E4,LFP_temp(:,2));
                        if exist('reverseData','var'), LFP=tsd(LFP_temp(:,1)*1E4,-LFP_temp(:,2));end
                        save([res,'/LFPData/LFP',num2str(InfoLFP.channel(i))],'LFP');
                        clear LFP LFP_temp
                    end
                    disp('Done')
                catch
                    disp(['problem for lfp ' mousetitle])
                    keyboard
                end
            end
        end

        % Events
        global DATA
        res=pwd;
        if res(3)=='\' ||res(1)=='\'
            windob=1;
        else
            windob=0;
        end

        if windob
            sepMark='\';
        else
            sepMark='/';
        end

        % build  EventInfo.mat (times and types of events: evtname (CS+/ CS- / BegEnd /Synchro)
        path = DATA.session.path;
        basename = DATA.session.name;

        DATA.events.time = [];
        DATA.events.description = {};
        DATA.events.evtname = [];
        % this lines erquires to supress 'wideband in the filename of the event
        % files
        eventFiles = dir([path sepMark basename '*.e*.evt']); % avoid .all.evt and .cat.avt
        if ~isempty(eventFiles),
            for i = 1:(length(eventFiles)),
                events = LoadEvents([path sepMark eventFiles(i).name]);
                if isempty(events.time), continue; end
                DATA.events.time = [DATA.events.time ; events.time];
                DATA.events.description = {DATA.events.description{:} events.description{:}}';        
                DATA.events.evtname = [DATA.events.evtname ;str2num(eventFiles(i).name(end-5:end-4))*ones(length(events.time),1)];
                disp(['... loaded event file ''' eventFiles(i).name '''']);
            end
        else
            disp('... (no event file found)');
        end
        EventInfo=DATA.events;
        %%%%%% manual correction for missing event infotmation
        % for M209 HAB pleth
        if strcmp(filename{1}, [FolderPath '/M207/20141209/FEAR-Mouse-207-09122014-HABpleth/FEAR-Mouse-207-09122014-HABpleth-respi/'])
            beginingtime=4.8;
            EventInfo.time=default_times+beginingtime;% 
            EventInfo.evtname=default_evtnames;
        elseif strcmp(filename{1}, [FolderPath '/M208/20141209/FEAR-Mouse-208-09122014-HABpleth/FEAR-Mouse-208-09122014-HABpleth-respi/'])
            beginingtime=7.5;
            EventInfo.time=default_times+beginingtime;% 
            EventInfo.evtname=default_evtnames;
        elseif strcmp(filename{1}, [FolderPath '/M209/20141209/FEAR-Mouse-209-09122014-HABpleth/FEAR-Mouse-209-09122014-HABpleth-respi/'])
            beginingtime=8;
            EventInfo.time=default_times+beginingtime;% 
            EventInfo.evtname=default_evtnames;
        elseif strcmp(filename{1}, [FolderPath 'M214/20141216/FEAR-Mouse-214-16122014-HABpleth/FEAR-Mouse-214-16122014-HABpleth-respi/'])
            EventInfo.evtname(EventInfo.time==270.358)=[]; % 270 : an artifact has generated a ttl on all channels
            EventInfo.time(EventInfo.time==270.358)=[];
        elseif strcmp(filename{1}, [FolderPath '/M212/20141209/FEAR-Mouse-212-09122014-HABpleth/FEAR-Mouse-212-09122014-HABpleth-respi/'])
            beginingtime=8.2;
            EventInfo.time=default_times+beginingtime;% 
            EventInfo.evtname=default_evtnames;
        elseif strcmp(filename{1}, [FolderPath '/M208/20141211/FEAR-Mouse-208-11122014-EXTpleth/FEAR-Mouse-208-11122014-EXTpleth-respi/'])
            load([FolderPath '/M207/20141211/FEAR-Mouse-207-11122014-EXTpleth/FEAR-Mouse-207-11122014-EXTpleth-respi/EventInfo.mat']);
        elseif strcmp(filename{1}, [FolderPath '/M210/20141211/FEAR-Mouse-210-11122014-EXTpleth/FEAR-Mouse-210-11122014-EXTpleth-respi/'])
            EventInfo.time=[EventInfo.time(1:11); 1200; EventInfo.time(12:15)];
            EventInfo.evtname=[EventInfo.evtname(1:11); 5; EventInfo.evtname(12:15)];
            
        end
            
        save('EventInfo.mat','EventInfo')
        % create CStime.mat
        if ~isempty(strfind(mousetitle, 'EXT'))
            CStime=EventInfo.time(1:12)*1000;
            save ('CStimes.mat', 'CStime')
        end
        clear LFP DATA
        SetCu=0;


        %%%%%%%%%%%%%%%% Filter Respi data 
        cd ([filename{1} '/LFPData/'])
        if exist('LFPData/rawLFP1.mat')
            load('LFPData/rawLFP1.mat')
            if plo
            figure, plot(Range(LFP), Data(LFP),'Color','k'), hold on
            end
        else
            load(['LFPData/LFP1.mat'])
            if plo
            figure, plot(Range(LFP), Data(LFP),'Color','k'), hold on
            end
        end
        set(gcf, 'Position',  [1700 300 1900 400])
        save(['rawLFP1.mat'],'LFP'); % save unfiltered data
        LFP=FilterLFP(LFP, [0.01 40]);
        save(['LFP1.mat'],'LFP');
        if plo
        plot(Range(LFP), Data(LFP),'Color','b'), hold on
        legend( 'respi RAW', 'respi FILTERED')
        title (mousetitle)
        saveas(gcf,  'Respi-raw+filtered.fig')
        end
        %%%%%%%%%%%%%%%%%%% Spike2 cut down to size for respi file
        %SyncMatlab
        BegEndmatlab=EventInfo.time(EventInfo.evtname==5);

        load('LFPData/LFP0.mat')
        if ~isempty(strfind(mousetitle, 'HAB'))
            if plo
            figure, plot(Range(LFP), Data(LFP),'Color','g'), hold on
            end
        elseif ~isempty(strfind(mousetitle, 'EXT'))
            if plo
            %figure, plot(Range(LFP), Data(LFP)*(10^-3)-600,'Color','g'), hold on
             figure, plot(Range(LFP), Data(LFP)*(10^-2)-800,'Color','g'), hold on
            end
        end
        set(gcf, 'Position',  [1700 300 1900 400])
        
        Epoch=intervalSet(BegEndmatlab(1)*1e4,BegEndmatlab(2)*1e4);
        LFP=Restrict(LFP,Epoch);
        if ~isdir(finalfilename)
            mkdir(finalfilename)
        end
        save([finalfilename,'Sounds.mat'],'LFP');
        % figure, plot(Range(LFP), Data(LFP)*(10^-3)-600,'Color','k'), hold on
        if ~isempty(strfind(mousetitle, 'HAB'))
            if plo
            plot(Range(LFP), Data(LFP),'Color','k')
            end
        elseif ~isempty(strfind(mousetitle, 'EXT'))
            if plo
            %plot(Range(LFP), Data(LFP)*(10^-3)-600,'Color','k')
            plot(Range(LFP), Data(LFP)*(10^-2)-800,'Color','k')
            end
        end
        % % for sound file
        load('LFPData/LFP1.mat')
        if plo
        plot(Range(LFP), Data(LFP),'Color','r'),
        end
        Epoch=intervalSet(BegEndmatlab(1)*1e4,BegEndmatlab(2)*1e4);
        LFP=Restrict(LFP,Epoch);
        save([finalfilename,'LFP1.mat'],'LFP');
        %save([finalfilename,'Respi.mat'],'LFP');
        if plo
        plot(Range(LFP), Data(LFP),'Color','b'),
        legend('sounds', 'cut sounds', 'respi', 'cutrespi')
        title (mousetitle)
        saveas(gcf, [finalfilename 'Respi+sounds.fig'])
        end
        
    end %loop on mice 
end
% Remove the window during which no LFP data was acquired in the respi and
% behavior fiel

