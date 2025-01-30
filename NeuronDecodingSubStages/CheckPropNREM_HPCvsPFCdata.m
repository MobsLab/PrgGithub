clear all
Binsize = 2*1e4;
Dir = PathForExperimentsERC_Dima('UMazePAG');
ReorderSleepDepth = [3,2,1,4,5];
WiSlSub = [];
for k = 1:length(Dir.path)
    
    cd(Dir.path{k}{1})
    if exist('SleepSubstages.mat')>0
        
        
        disp(Dir.path{k})
        clearvars -except Dir k ReorderSleepDepth Dir Binsize TotalDur
        
        % Load LFP to get time right
        load('LFPData/LFP1.mat')
        AllTime = tsd(Range(LFP),[1:length(Range(LFP))]');
        tps = Range(LFP);
        
        
        
        % Sleep substates
        try,load('SleepSubstages.mat')
        catch
            load('NREMsubstages.mat')
        end
        load('behavResources.mat')
        Epoch = Epoch(ReorderSleepDepth);
        NameEpoch = NameEpoch(ReorderSleepDepth);
        Epoch{5} = and(Epoch{5},or(SessionEpoch.PreSleep,SessionEpoch.PostSleep));
        
        
        for i = 1:5
            TotalDur.HPC(k,i) = length(Data(Restrict(LFP,Epoch{i})))
        end
    end
end


Binsize = 2*1e4;
% Dir=PathForExperimentsEmbReact('BaselineSleep');
ReorderSleepDepth = [3,2,1,4,5];
Dir = PathForExperimentsSleepRipplesSpikes('Basal')

for k = 1:length(Dir.path)
    
    cd(Dir.path{k})
    disp(Dir.path{k})
    clearvars -except Dir k ReorderSleepDepth Dir Binsize TotalDur
    
    % Load LFP to get time right
    load('LFPData/LFP1.mat')
    AllTime = tsd(Range(LFP),[1:length(Range(LFP))]');
    tps = Range(LFP);
    
  
  
    % Sleep substates
    try,load('SleepSubstages.mat')
    catch
        load('NREMsubstages.mat')
    end
    
    Epoch = Epoch(ReorderSleepDepth);
    NameEpoch = NameEpoch(ReorderSleepDepth);
     
        for i = 1:5
            TotalDur.PFC(k,i) = length(Data(Restrict(LFP,Epoch{i})))
        end
end


