% CreateModifiedSleepScore
% 16.06.2017 KJ
%
% Generate new sleep scoring:
%   - with delta removed after tones/sham event
%   - with delta added after tones/sham event



clear
Dir=PathForExperimentsDeltaWavesTone('all');

for p=1:length(Dir.path)
    try
        disp(' ')
        disp('****************************************************************')
        eval(['cd(Dir.path{',num2str(p),'}'')'])
        disp(pwd)
        
        clearvars -except Dir p
        
        %% Load Events
        try 
            try
                load('DeltaSleepEvent.mat', 'TONEtime1')
                delay = Dir.delay{p}*1E4;
                tEvents = ts(TONEtime2 + delay);
            catch
                load('DeltaSleepEvent.mat', 'TONEtime2')
                delay = Dir.delay{p}*1E4;
                tEvents = ts(TONEtime1 + delay);
            end
        catch
            load('ShamSleepEvent.mat', 'SHAMtime')
            tEvents = SHAMtime;
        end
        
        %% Substages with removed delta
        clear op NamesOp Dpfc Epoch noise opNew
        try
            load NREMepochs_remove_delta.mat op NamesOp Dpfc Epoch noise opNew
            op; disp('Substages (removed) already generated')
        catch
            [op,NamesOp,Dpfc,Epoch,noise,opNew]=SleepStageModifyDeltaToneKJ(tEvents,'remove');
            disp('saving in NREMepochs_remove_delta.mat')
            save NREMepochs_remove_delta.mat op NamesOp Dpfc Epoch noise opNew
        end
        
        
        %% Substages with added delta
        clear op NamesOp Dpfc Epoch noise opNew
        try
            load NREMepochs_add_delta.mat op NamesOp Dpfc Epoch noise opNew
            op; disp('Substages (added) already generated')
        catch
            [op,NamesOp,Dpfc,Epoch,noise,opNew]=SleepStageModifyDeltaToneKJ(tEvents,'add');
            disp('saving in NREMepochs_add_delta.mat')
            save NREMepochs_add_delta.mat op NamesOp Dpfc Epoch noise opNew
        end

    catch
        disp('error for this record')
    end
end



