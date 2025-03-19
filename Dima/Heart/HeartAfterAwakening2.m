%% HeartAfterWakening
% Get path - Sophie
Dir = PathForExperimentsEmbReact('BaselineSleep');
Dir = RemoveElementsFromDir(Dir,'nmouse', [404 425 430 431 436 437 438 439 444 445 469 470 471 483 484 485 490 507 508 ...
    509 510 512 514 561 566 568 689]); % Left - 567 569 688 739 740 750

% Allocate memory
HR = cell(1,sum(cellfun(@(x) numel(x),Dir.path)));
HRsm = cell(1,sum(cellfun(@(x) numel(x),Dir.path)));
OverallHR = zeros(1,sum(cellfun(@(x) numel(x),Dir.path)));
OverallHRWake = zeros(1,sum(cellfun(@(x) numel(x),Dir.path)));
OverallHRSWS = zeros(1,sum(cellfun(@(x) numel(x),Dir.path)));
OverallHRREM= zeros(1,sum(cellfun(@(x) numel(x),Dir.path)));
a=1;

% Load or calculate the data
for i=1:length(Dir.path)
    for j=1:length(Dir.path{i})
        cd(Dir.path{i}{j});   
        % Heart
        HR{a} = load([Dir.path{i}{j} 'HeartBeatInfo.mat'], 'EKG');
        % StateEpoch
        StateEpoch{a} = load([Dir.path{i}{j} 'StateEpochSB.mat'], 'Wake', 'SWSEpoch', 'REMEpoch');
        a=a+1;
    end
end

% Smooth the data a bit
for i=1:length(HR)
    HRsm{i} = tsd(Range(HR{i}.EKG.HBRate), runmean(Data(HR{i}.EKG.HBRate), 3));
end

% Chunk Wake Epoch in 10 relative to tolal length of Wake Epoch
for i=1:length(StateEpoch)
    time{i} = Range(HR{i}.EKG.HBRate);
    TotalEpoch{i} = intervalSet(time{i}(1),time{i}(end));
    
end
    

% Chunk Wake Epoch in 10 relative to tolal length of Wake Epoch
for i=1:length(StateEpoch)
    LenEpochs{i} = End(StateEpoch{i}.Wake)-Start(StateEpoch{i}.Wake);
    TotalLen{i} = sum(LenEpochs{i});
    chunks{i} = TotalLen{i}/10;
    a=1;
    for i=1:length(LenEpochs{i})
        if LenEpochs{i}(1) > chunks{i}
            Percentiles{i}(a) = intervalSet(Start(StateEpoch{i}.Wake), chunks{i});
            ResidualEpoch = intervalSet(chunks{i}, Start(StateEpoch{i}.Wake));
            a=a+1;
        else
            
        end
    end
end