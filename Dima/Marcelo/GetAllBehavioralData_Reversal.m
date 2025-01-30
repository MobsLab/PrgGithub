%% Main
nMiceSham = [935 938 1138 1140 1142];
nMiceExp = [913 934 1139 1141 1143];
SessionTypes = {'TestPre', 'CondPAG', 'TestPostPAG', 'CondMFB', 'TestPostMFB'};

for imouse = 1:length(nMiceSham)
    eval(['Sham.Mouse' num2str(nMiceSham(imouse)) ' = GetBehavioralData(nMiceSham(imouse), SessionTypes, ''Sham'');']);
end
for imouse = 1:length(nMiceExp)
    eval(['Reversal.Mouse' num2str(nMiceExp(imouse)) ' = GetBehavioralData(nMiceExp(imouse), SessionTypes, ''Exp'');']);
end

maze = [0 0; 0 1; 1 1; 1 0; 0.63 0; 0.63 0.75; 0.35 0.75; 0.35 0; 0 0];
shockZone = [0 0; 0 0.43; 0.35 0.43; 0.35 0; 0 0];

clear nMiceSham nMiceExp SessionTypes imouse
save('ERC_behavReversal.mat');


%% Auxiliary functions
function MouseData = GetBehavioralData(MouseNum, SessionTypes, ExpType)

% Load the data
for itype = 1:length(SessionTypes)
    Dir = PathForExperimentsReversalBehav_MC(SessionTypes{itype});
    Dir = RestrictPathForExperiment(Dir, 'Group', ExpType);
    Dir = RestrictPathForExperiment(Dir, 'nMice', MouseNum);
    
    for itest = 1:length(Dir.path{1})
        whichmouse = isstrprop(Dir.name{1}(end-3:end),'alpha');
        if whichmouse(1)
            temp = load([Dir.path{1}{itest} 'cleanbehavResources.mat'],...
                'CleanAlignedXtsd', 'CleanAlignedYtsd', 'PosMat');
        else
            temp = load([Dir.path{1}{itest} 'behavResources.mat'],...
                'CleanAlignedXtsd', 'CleanAlignedYtsd', 'PosMat');
        end
        
        % Construct X-Y matrix
        time = temp.PosMat(:,1);
        X = Data(temp.CleanAlignedXtsd);
        Y = Data(temp.CleanAlignedYtsd);
        S = temp.PosMat(:,4);
        record = [time X Y S];
        
        % Record down data
        if strcmp(SessionTypes{itype}, 'Hab')
            if itest == 1
                MouseData.Hab = record;
            elseif itest == 4
                MouseData.Extinction = record;
            end
        else
            MouseData.([SessionTypes{itype} num2str(itest)]) = record;
        end
        
    end
end

end