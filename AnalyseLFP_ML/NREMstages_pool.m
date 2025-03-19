% NREMstages_pool.m
%
% list of related scripts in NREMstages_scripts.m

%%
Paths={'SD24h','SD6h','OR'};

%info_channel = mouse DateChange, night sup/deep/ob/hpc, day sup/deep/ob/hpc
a=0;  clear info_channel
a=a+1; info_channel(a,1:10)=[294   NaN     4 3 0 1      31 30 0 4   ];%294
a=a+1; info_channel(a,1:10)=[330   NaN     3 4 1 0      25 30 19 18 ];%330 only 20160623 day and night
a=a+1; info_channel(a,1:10)=[330   NaN     4 0 2 1      25 12 19 18 ];%330
a=a+1; info_channel(a,1:10)=[393   NaN     NaN 1 5 4    NaN 6 14 10 ];%393
a=a+1; info_channel(a,1:10)=[394   NaN     5 4 3 2      25 19 14 12 ];%394 before %try chsup=[];
a=a+1; info_channel(a,1:10)=[394 20160718  NaN 1 5 4    NaN 3 14 11 ];%394 from 20160718
a=a+1; info_channel(a,1:10)=[395   NaN     0 5 4 3      0 17 14 11  ];%395
a=a+1; info_channel(a,1:10)=[400   NaN     NaN 4 3 2    NaN 20 13 12];%400
a=a+1; info_channel(a,1:10)=[402   NaN     4 5 3 2      17 28 14 11 ];%402 %try chsup=[];
a=a+1; info_channel(a,1:10)=[403   NaN     1 0 5 4      12 4 30 27  ];%403 %try chsup=[];
a=a+1; info_channel(a,1:10)=[450   NaN     NaN 5 3 2    NaN 22 14 10];%450 before 20160916
a=a+1; info_channel(a,1:10)=[450 20161009  5 0 4 3      22 6 14 12  ];%450 from 20161010
a=a+1; info_channel(a,1:10)=[451   NaN     NaN 1 5 4    NaN 10 30 27];%451 before 20160916
a=a+1; info_channel(a,1:10)=[451 20161009  0 1 5 4      12 15 30 27 ];%451 from 20161009

%%
clear DirPool
for p=1:length(Paths)
    [Dir,nameSessions]=NREMstages_path(Paths{p});
    
    for a=1:size(Dir,1)
        for man=1:size(Dir,2)
            try
            disp(' '); disp('------------------------------------------')
            disp(Dir{a,man}); cd(Dir{a,man});
            nameMouse{a}=Dir{a,man}(max(strfind(Dir{a,man},'Mouse'))+[5:7]);
            dateM=Dir{a,man}(max(strfind(Dir{a,man},'/201'))+[1:8]);
            if isempty(strfind(Dir{a,man},'night')),IsNight=1; else, IsNight=0;end
            
            % --------------------------------------------------------
            % folder to create
            nameFold=['/media/DataMOBsRAIDN/ProjetNREM/Mouse',nameMouse{a},'/',dateM,'-PoolDayAndNight'];
            if strcmp(dateM,'20160822') && sum(strcmp(nameMouse{a},{'402','403'}))
                nameFold=['/media/DataMOBsRAID/ProjetNREM/Mouse',nameMouse{a},'/',dateM,'-PoolDayAndNight'];
            end
            disp(['Saving in ',nameFold])
            
            if exist(nameFold,'dir') && exist([nameFold,'/LFPData/LFP2.mat'],'file')
                disp('Folder already exists... skipping to avoid overwriting')
            else
                % --------------------------------------------------------
                % get channels to load
                id=find(info_channel(:,1)==str2num(nameMouse{a}));
                if length(id)>1
                    if str2num(dateM) < info_channel(id(2),2), id=id(1); else id=id(2);end
                end
                chans=info_channel(id,4*IsNight+[3:6]);
                
                % PFCx_sup
                disp(sprintf('Loading PFCx_sup : channel %d',chans(1)))
                try temp1=load(sprintf('LFPData/LFP%d.mat',chans(1)),'LFP');end
                % PFCx_deep
                disp(sprintf('Loading PFCx_deep : channel %d',chans(2)))
                temp2=load(sprintf('LFPData/LFP%d.mat',chans(2)),'LFP');
                % Bulb_deep
                disp(sprintf('Loading Bulb_deep : channel %d',chans(3)))
                temp3=load(sprintf('LFPData/LFP%d.mat',chans(3)),'LFP');
                % dHPC_deep
                disp(sprintf('Loading dHPC_deep : channel %d',chans(4)))
                temp4=load(sprintf('LFPData/LFP%d.mat',chans(4)),'LFP');
                
                % --------------------------------------------------------
                % get time of the day
                NewtsdZT=GetZT_ML(Dir{a,man});
                
                % get accelerometer data
                clear MovAcctsd
                tempBeh=load('behavResources.mat','MovAcctsd');
                
                % --------------------------------------------------------
                % concatenate day and night LFPs
                if floor(man/2)~=man/2
                    i_stop=mod(max(Data(NewtsdZT))/3600/1E4,24)*3600*1E4;
                    i_L=max(Range(NewtsdZT))-min(Range(NewtsdZT));
                    disp(sprintf('Day rec stopped at %1.1fh and lasted %1.1fh',i_stop/3600/1E4,i_L/3600/1E4))
                    
                    for ti=1:4, try eval(sprintf('tempLFP%d=temp%d.LFP;',ti,ti));end;end
                    tempMmov=tempBeh.MovAcctsd;
                    info_chan_day=chans;
                end
                if floor(man/2)==man/2 || (floor(man/2)~=man/2 && strcmp(Dir{a,man+1},'NaN'))
                    i_start=mod(min(Data(NewtsdZT))/3600/1E4,24)*3600*1E4;
                    delay=mod(i_start-i_stop,24*3600*1E4)+i_L;
                    disp(sprintf('Night rec started at %1.1fh so %1.1fh after Day rec started',i_start/3600/1E4,delay/3600/1E4))
                    
                    for ti=1:4
                        try
                            eval(sprintf('LFP%d=tsd([Range(tempLFP%d);Range(temp%d.LFP)+delay],[Data(tempLFP%d);Data(temp%d.LFP)]);',ti,ti,ti,ti,ti));
                        end
                    end
                    MovAcctsd=tsd([Range(tempMmov);Range(tempBeh.MovAcctsd)+delay],[Data(tempMmov);Data(tempBeh.MovAcctsd)]);
                    
                    info_chan_night=chans;
                    
                    % --------------------------------------------------------
                    % save
                    mkdir(nameFold);
                    mkdir([nameFold,'/LFPData']);mkdir([nameFold,'/ChannelsToAnalyse']);
                    cd(nameFold)
                    
                    % save info channels and MovAcctsd
                    save('info.mat','info_chan_night','info_chan_day')
                    Channel_SleepScor=4; save('StateEpoch','Channel_SleepScor');
                    useMovAcctsd=1; save('behavResources','MovAcctsd','useMovAcctsd');
                    
                    % save LFPs
                    try
                        LFP=LFP1; channel=1; disp('LFP1');
                        save('LFPData/LFP1.mat','LFP');
                    catch
                        channel=[];
                    end
                    save('ChannelsToAnalyse/PFCx_sup.mat','channel')
                    
                    LFP=LFP2; channel=2; disp('LFP2')
                    save('ChannelsToAnalyse/PFCx_deep.mat','channel')
                    save('LFPData/LFP2.mat','LFP');
                    
                    LFP=LFP3; channel=3; disp('LFP3')
                    save('ChannelsToAnalyse/Bulb_deep.mat','channel')
                    save('LFPData/LFP3.mat','LFP');
                    
                    LFP=LFP4; channel=4; disp('LFP4')
                    save('ChannelsToAnalyse/dHPC_deep.mat','channel')
                    save('LFPData/LFP4.mat','LFP');
                    
                    
                    % --------------------------------------------------------
                    % check
                    %                 I=intervalSet(delay-5*1E4,delay+5*1E4); % 10s  window
                    %                 figure('Color',[1 1 1])
                    %                 for ti=1:4
                    %                     eval(sprintf('lfp=LFP%d;',ti))
                    %                     hold on, plot(Range(lfp,'s'),Data(lfp)+ti*1E3);
                    %                 end
                    %                 line(delay/1E4+[0 0],ylim,'Color',[0.5 0.5 0.5])
                    %                 lnameSessionsnameSessionsegend({'PFsup','PFdeep','OB','HPC'})
                    %                 title(nameFold); xlim([i_L/1E4 delay/1E4+5])
                    
                end
            end
            disp('Done'); clear temp1 temp2 temp3 temp4
            if floor(man/2)==man/2, 
                DirPool{a,man/2}=nameFold;
                PoolSessions{a,man/2}=[nameSessions{man},'-',nameSessions{man-1}];
            end
            end
        end
    end
end

%%
for p=1:length(Paths)
    [Dir,nameSessions]=NREMstages_path(Paths{p});
    for a=1:size(Dir,1)
        for man=1:size(Dir,2)/2
            nameMouse{a}=Dir{a,man}(max(strfind(Dir{a,man},'Mouse'))+[5:7]);
            dateM=Dir{a,2*man}(max(strfind(Dir{a,man},'/201'))+[1:8]);
            nameFold=['/media/DataMOBsRAIDN/ProjetNREM/Mouse',nameMouse{a},'/',dateM,'-PoolDayAndNight'];
            cd(nameFold);
            if ~exist('StateEpoch.mat','file'), sleepscoringML;end
%            RunSubstages;
        end
    end
end