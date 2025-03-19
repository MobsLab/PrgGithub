% This function concatenates all data from one mouse to analyse it as one

% FolderList : list of folders that will be used in order
%
% TypeVariable:
%   - data : loads the piezo tsd
% - soundepoch : gives the epochs when sounds are played, you have to
% specific before which type fo sound you want to look at by typing
% "soundtype" before

function OutPutVar=ConcatenateDataAudiodream_CH(FolderList, Mouse, mouse, TypeVariable, varargin)


if nargin < 2
    error('Incorrect number of parameters (type ''help <a href="matlab:help FindRipplesKJ">FindRipplesKJ</a>'' for details).');
end

% Parse parameter list
for i = 1:2:length(varargin)
    if ~ischar(varargin{i})
        error(['Parameter ' num2str(i+2) ' is not a property (type ''help <a href="matlab:help FindRipplesKJ">FindRipplesKJ</a>'' for details).']);
    end
    switch(lower(varargin{i}))
        case 'soundtype'
            soundtype =  varargin{i+1};
    end
end


switch(lower(TypeVariable))
    
    case 'raw_data'
        
        tps = 0;
        OutPutVar = tsd([],[]);
        for ff = 1:length(FolderList)
            
            cd(FolderList{ff})
            %             load([num2str(Mouse(mouse)),'_PiezoData_Corrected.mat'])
            load([num2str(Mouse),'_PiezoData_Corrected.mat'])
            
            tpsmax = max(Range(Piezo_Mouse_tsd));
            TotEpoch = intervalSet(0,max(Range(Piezo_Mouse_tsd)));
            
            rg = Range(Restrict(Piezo_Mouse_tsd,TotEpoch));
            dt = Data(Restrict(Piezo_Mouse_tsd,TotEpoch));
            OutPutVar = tsd([Range(OutPutVar);rg+tps],[Data(OutPutVar);dt]);
            
            tps = tps + tpsmax;
        end
        
    case 'data'
        
        tps = 0;
        OutPutVar = tsd([],[]);
        for ff = 1:length(FolderList)
            
            cd(FolderList{ff})
            load([num2str(Mouse),'_PiezoData_Corrected.mat'])
            
            tpsmax = max(Range(Piezo_Mouse_tsd));
            TotEpoch = intervalSet(0,max(Range(Piezo_Mouse_tsd)));
            
            rg = Range(Restrict(Piezo_Mouse_tsd,TotEpoch));
            dt = abs(zscore(Data(Restrict(Piezo_Mouse_tsd,TotEpoch))));
            OutPutVar = tsd([Range(OutPutVar);rg+tps],[Data(OutPutVar);dt]);
            
            tps = tps + tpsmax;
        end
        
    case 'data2'
        
        tps = 0;
        OutPutVar = tsd([],[]);
        for ff = 1:length(FolderList)
            
            cd(FolderList{ff})
            load([num2str(Mouse),'_PiezoData_Corrected.mat'])
            
            tpsmax = max(Range(Piezo_Mouse_tsd));
            TotEpoch = intervalSet(0,max(Range(Piezo_Mouse_tsd)));
            
            rg = Range(Restrict(Piezo_Mouse_tsd,TotEpoch));
            dt = runmean(abs(zscore(Data(Restrict(Piezo_Mouse_tsd,TotEpoch)))),10);
            OutPutVar = tsd([Range(OutPutVar);rg+tps],[Data(OutPutVar);dt]);
            
            tps = tps + tpsmax;
        end
        
    case 'allsound'
        
        tps = 0;
        OutPutVar = intervalSet([],[]);
        for ff = 1:length(FolderList)
            cd(FolderList{ff})
            load('behavResources.mat','TTLInfo')
            load([num2str(Mouse),'_PiezoData_Corrected.mat'])
            tpsmax = max(Range(Piezo_Mouse_tsd));
            OutPutVar=intervalSet([Start(OutPutVar);Start(TTLInfo.Sounds)+tps],...
                [Stop(OutPutVar);(Start(TTLInfo.Sounds)+(2*1e4))+tps]);
            tps = tps + tpsmax;
        end

    case 'soundepoch'
        if ~exist('soundtype', 'var')
            error('The "soundtype" parameter must be specified.');
        end
        tps = 0;
        OutPutVar = intervalSet([],[]);
        for ff = 1:length(FolderList)
            cd(FolderList{ff})
            load('behavResources.mat','TTLInfo')
            load([num2str(Mouse),'_PiezoData_Corrected.mat'])
            tpsmax = max(Range(Piezo_Mouse_tsd));
            Epoch = TTLInfo.(strcat(num2str(soundtype),'Epoch'));
            OutPutVar=intervalSet([Start(OutPutVar);Start(Epoch)+tps],...
                [Stop(OutPutVar);Start(Epoch)+(2*1e4)+tps]);
            tps = tps + tpsmax;
        end
        
    case 'sleepepoch'
        
        tps = 0;
        OutPutVar = intervalSet([],[]);
        for ff = 1:length(FolderList)
            cd(FolderList{ff})
            load([num2str(Mouse),'_SleepScoring.mat'])
            load([num2str(Mouse),'_PiezoData_Corrected.mat'])
            tpsmax = max(Range(Piezo_Mouse_tsd));
            OutPutVar=intervalSet([Start(OutPutVar);Start(SleepEpoch_Piezo)+tps],...
                [Stop(OutPutVar);(Stop(SleepEpoch_Piezo)+tps)]);
            tps = tps + tpsmax;
        end
        OutPutVar = mergeCloseIntervals(OutPutVar,1);
        
        
    case 'soundts'
        if ~exist('soundtype', 'var')
            error('The "soundtype" parameter must be specified.');
        end
        tps = 0;
        OutPutVar = ts();
        for ff=1:length(FolderList)
            cd(FolderList{ff})
            load('behavResources.mat','TTLInfo')
            load([num2str(Mouse),'_PiezoData_Corrected.mat'])
            
            tpsmax = max(Range(Piezo_Mouse_tsd));
            TotEpoch = intervalSet(0,max(Range(Piezo_Mouse_tsd)));
            TTL = ts(TTLInfo.(strcat(num2str(soundtype)))*1e4);
            rg = Range(TTL);
            OutPutVar = ts([Range(OutPutVar);rg+tps]);
            
            tps = tps + tpsmax;
            
        end
  
        case 'allttl'
        tps = 0;
        OutPutVar = ts();
        for ff=1:length(FolderList)
            cd(FolderList{ff})
            load('behavResources.mat','TTLInfo')
            load([num2str(Mouse),'_PiezoData_Corrected.mat'])
            
            tpsmax = max(Range(Piezo_Mouse_tsd));
            TotEpoch = intervalSet(0,max(Range(Piezo_Mouse_tsd)));
            TTL = TTLInfo.time_nextsound_corrected;
            rg = Range(TTL);
            OutPutVar = ts([Range(OutPutVar);rg+tps]);
            
            tps = tps + tpsmax;
            
        end
end




















