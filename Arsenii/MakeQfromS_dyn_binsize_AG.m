function Q = MakeQfromS_dyn_binsize_AG(S, DT, varargin)
%
% DRAFT VERSION. FOR UPDATED LOAD MakeQfromS_AG.m
% Q = MakeQfromS(S, DT, parameters)
%
% INPUTS:
%    S - a cell array of ts objects
%        (as generated, for example, by LoadSpikes)
%    DT - timestep for ctsd (measured in timestamps!) - default binsize
%
% OUTPUTS:
%    Q - a ctsd in which the main structure is a |t| x nCells histogram of firing rates
%
% PARAMETERS:
%    T_start: StartTime for the Q matrix, defaults to min(StartTime(S)) class(ts)
%    T_end: EndTime for the Q matrix, defaults to max(EndTime(S)) class(ts)
%    ProgressBar (default 'text'): if 'text', prints "converting n cells: ..."
%                                  if 'graphics', shows display bar
%                                  else shows nothing

%% temporary
S = selected_cells;
DT = 1e4;

%% Allocate memory
spikeTotal = 0;
cellIndx = [];
timeIndx = [];
T_start = inf;
T_end = -inf;
nCells = length(S{imouse}); % number of cells
for icell = 1:nCells
    merged_epochs_s{icell} = [];
end

%%

for iC = 1:length(S{imouse}) % Working range. Unified timline. Start - the earliest spike. End - the latest spike
    if ~isempty(Data(S{imouse}{iC})) %class(ts)
        T_start = min(T_start, StartTime(S{imouse}{iC})); %class(ts)
        T_end = max(T_end, EndTime(S{imouse}{iC})); %class(ts)
    end
end

for iC = 1:nCells % Make cellIndx - карта соответствия номера спайка номеру нейрона. Make timeIndx (ts) - timestamps of each spike
    if ~isempty(Data(S{imouse}{iC}))  % class(ts)
        spikeTimes = Restrict(S{imouse}{iC}, T_start, T_end); % class(ts)
        nSpikes = length(Data(spikeTimes)); % class(ts). number of spikes for each neuron
        spikeTotal = spikeTotal + nSpikes; % total number of spikes for all neurons
        timeIndx = [timeIndx' Data(spikeTimes)']'; % class(ts). All spike indexes in the vertical array.
        b = ones(nSpikes,1).*iC ;  % set element to 1 if there is a spike. sparse() does the binning
        cellIndx = [cellIndx' b']'; % карта того, какой спайк к какому нейрону относится
    end
end

for iepoch = 1:length(Map_TimeLine{imouse}) %  calculating bins
    if Map_TimeLine{imouse}(iepoch, 3) == 1 % тета
        
        % Make bin intervalsets and calculate binsizes
        Epoch{imouse}{iepoch} = intervalSet(Map_TimeLine{imouse}(iepoch, 1), Map_TimeLine{imouse}(iepoch, 2)); % Каждая тета эпоха
        Epoch_Peaks{imouse}{iepoch} = Restrict(Theta_Peaks{imouse}, Epoch{imouse}{iepoch}); %Пики в тета эпохе
        peaks{imouse}{iepoch} = Range(Epoch_Peaks{imouse}{iepoch}); % time stamps of peaks inside the epoch.
        
        % Create bins and calculate binsizes
        Bins{imouse}{iepoch}{1} = intervalSet(Map_TimeLine{imouse}(iepoch, 1), peaks{imouse}{iepoch}(1));
        Binsizes{imouse}{iepoch}{1} = peaks{imouse}{iepoch}(1) - Map_TimeLine{imouse}(iepoch, 1);
        
        for ibin = 1:(length(peaks{imouse}{iepoch}) - 1)
            Bins{imouse}{iepoch}{ibin + 1} = intervalSet(peaks{imouse}{iepoch}(ibin), peaks{imouse}{iepoch}(ibin + 1));
            Binsizes{imouse}{iepoch}{ibin + 1} = peaks{imouse}{iepoch}(ibin + 1) - peaks{imouse}{iepoch}(ibin);
        end
        
        Bins{imouse}{iepoch}{ibin + 2} = intervalSet(peaks{imouse}{iepoch}(ibin + 1), Map_TimeLine{imouse}(iepoch, 2));
        Binsizes{imouse}{iepoch}{ibin + 2} = Map_TimeLine{imouse}(iepoch, 2) - peaks{imouse}{iepoch}(ibin + 1);
        Binsizes{imouse}{iepoch} = (Binsizes{imouse}{iepoch})';
        
    elseif Map_TimeLine{imouse}(iepoch, 3) == -1 %не тета
        %% Получаем количество бинов
        Bins{imouse}{iepoch}{1} = intervalSet(Map_TimeLine{imouse}(iepoch, 1), Map_TimeLine{imouse}(iepoch, 1) + DT);
        for ibin = 1:(round((Map_TimeLine{imouse}(iepoch, 2) - Map_TimeLine{imouse}(iepoch, 1))/DT) - 1) % кол-во бинов
            Bins{imouse}{iepoch}{ibin + 1} = intervalSet(End(Bins{imouse}{iepoch}{ibin}), End(Bins{imouse}{iepoch}{ibin}) + DT);
        end
        
        % Make a timeline, which consists of stamps of ends of bins
        for iepoch = 1:length(Map_TimeLine{imouse})
            if Map_TimeLine{imouse}(iepoch, 3) == 1
                Bin_ts{imouse}{iepoch} = nan(length(Bins{imouse}{iepoch}), 1);
                Bin_ts{imouse}{iepoch}(1) = Map_TimeLine{imouse}(iepoch, 1);
                Bin_ts{imouse}{iepoch}(2:(end), 1) = peaks{imouse}{iepoch};
                %                 Bin_ts{imouse}{iepoch}(end, 1) = Map_TimeLine{imouse}(iepoch, 2);
            else
                Bin_ts{imouse}{iepoch} = nan(length(Bins{imouse}{iepoch}), 1);
                Bin_ts{imouse}{iepoch}(1) = Map_TimeLine{imouse}(iepoch, 1);
                Bin_ts{imouse}{iepoch}(2:(end), 1) = Map_TimeLine{imouse}(iepoch, 1) + DT*(1:(length(Bins{imouse}{iepoch})-1));
            end
        end
        
        timeline_bins = []
        for iepoch = 1:length(numSpikes{imouse}{icell})
            timeline_bins = [timeline_bins; Bin_ts{imouse}{iepoch}];
        end
        timeline_bins_ts = ts(timeline_bins);
        
        
    end
    %%
    %             timeIndx = round((timeIndx - T_start)/DT)+1; % reset time of first spike in data to zero.
    %             %Определяем в какой бин каждое из этих времен попадает.  Спайки выраженные в форме того, в какой бин они попадают.
    %             %Теперь значение в клетке - номер бина, в который попадает спайк, соответствующий этой клетке.
    %             endIndx = round((T_end - T_start)/DT)+1; %количество бинов.
    %             s = ones(spikeTotal,1); %
    %             nTime = max([timeIndx; endIndx]);
    %
    %             nPoints= size(QData, 1);
    %             times = T_start + DT * (0:(nPoints-1)); %Отметки во времени конца каждого бина
    %             Q = tsd(times, QData);
    
end

Bins{imouse} = (Bins{imouse})';
Bins{imouse}{iepoch} = (Bins{imouse}{iepoch})';

for icell = 1:nCells % binning
    for iepoch = 1:length(Bins{imouse})
        for ibin = 1:length(Bins{imouse}{iepoch})
            Spikes_in_bin{ibin} = Restrict(S{imouse}{icell}, Bins{imouse}{iepoch}{ibin});
            numSpikes{imouse}{icell}{iepoch}{ibin} = length(Spikes_in_bin{ibin}); % number of spikes in an epoch
        end
        numSpikes{imouse}{icell}{iepoch} = (numSpikes{imouse}{icell}{iepoch})';
    end
    numSpikes{imouse}{icell} = (numSpikes{imouse}{icell})';
end
numSpikes{imouse} = (numSpikes{imouse})';

% складываем все в единый таймлан
for icell = 1:nCells
    for iepoch = 1:length(numSpikes{imouse}{icell})
        merged_epochs_s{icell} = [merged_epochs_s{icell}; numSpikes{imouse}{icell}{iepoch}];
    end
end

nTime = length(merged_epochs_s{imouse});

QData{imouse} = nan(nTime, nCells);

for icell = 1:nCells
    merged_epochs_s{icell} = cell2mat(merged_epochs_s{icell});
    QData{imouse}(:, icell) = merged_epochs_s{icell};
end

%% Build Q
Q_sparse = sparse(QData{imouse});
Q = tsd(timeline_bins', Q_sparse);

end