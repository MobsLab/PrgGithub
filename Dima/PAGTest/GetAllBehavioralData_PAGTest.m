%% Main

% parameter to set manually
% expe = 'pag';  % 'pag' or 'mfb'
SessionTypes = {'TestPre', 'Cond', 'TestImmediat', 'TestPost'};
% maze limits
maze = [0 0; 0 1; 1 1; 1 0; 0.63 0; 0.63 0.75; 0.35 0.75; 0.35 0; 0 0];
shockZone = [0 0; 0 0.43; 0.35 0.43; 0.35 0; 0 0]; 

% specific parameters
nMice = {'783', '785', '785_2', '786', '786_2', '787', '787_2', '788'};
% loop for mouse: get behav data
for imouse = 1:length(nMice)
    id = strfind(nMice{imouse}, '_');
    if ~isempty(id)
        mouseNum = str2double(nMice{imouse}(1:id-1));
        check = 2;
    else
        mouseNum = str2double(nMice{imouse});
        check = 1;
    end
    eval(['Mouse' nMice{imouse} ' = GetBehavioralDataPAG(mouseNum, SessionTypes, check);']);
end
clear nMice SessionTypes imouse
% save behav data
save('ERC_behavAversivePAGTest.mat');



%% Auxiliary functions
% PAG
function MouseData = GetBehavioralDataPAG(MouseNum, SessionTypes, check)
% Load the data
for itype = 1:length(SessionTypes)
    
    Dir = PathForExperimentsPAGTest_Dima(SessionTypes{itype});
    Dir = RestrictPathForExperiment(Dir, 'nMice', MouseNum);
    
    if strcmp(SessionTypes{itype}, 'TestImmediat') && MouseNum == 787 && check == 2
        MouseData.([SessionTypes{itype}]) = [];
    else
        for itest = 1:length(Dir.path{check})
            
            temp = load([Dir.path{check}{itest} 'behavResources.mat'],...
                'AlignedXtsd', 'AlignedYtsd', 'PosMat');
            
            % Construct X-Y matrix
            time = temp.PosMat(:,1);
            if isfield(temp, 'AlignedXtsd')
                X = Data(temp.AlignedXtsd);
                Y = Data(temp.AlignedYtsd);
            else
                X = Data(temp.AlignedXtsd);
                Y = Data(temp.AlignedYtsd);
                
            end
            S = temp.PosMat(:,4);
            record = [time X Y S];
            
            % Record down data
            
            if ~strcmp(SessionTypes{itype}, 'TestImmediat')
                MouseData.([SessionTypes{itype} num2str(itest)]) = record;
            else
                MouseData.([SessionTypes{itype}]) = record;
            end
            
        end
        
    end
    
end

end
