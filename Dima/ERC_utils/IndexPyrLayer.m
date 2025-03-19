function IndexPyrLayer(Dir)
% 
% Records pyramidal layer spike groups in SpikeData.mat
% Relies on the hardcoded values that were derived from visual data
% inspecion
% 
% by Dima Bryzgalov
% 

for idir = 1:length(Dir.path)
    
    % Get data
    cd(Dir.path{idir}{1});
    load('ExpeInfo.mat');
    
    %Get spike groups
    RippleGroups = GetSpikeGroupsFromPyr(ExpeInfo.nmouse);
    
    % Save the data
    save('SpikeData.mat', 'RippleGroups', '-append');
    
    % Remove ExpeInfo
    clear ExpeInfo
end

end













%% Auxiliary

% Dictionary
function spikegroups = GetSpikeGroupsFromPyr(nmouse)

if nmouse == 797
    spikegroups = 1;
end

if nmouse == 798
    spikegroups = [1 2];
end

if nmouse == 828
    spikegroups = [1 2 5];
end 

if nmouse == 861
    spikegroups = [2 3];
end 

if nmouse == 882
    spikegroups = 1;
end

if nmouse == 905
    spikegroups = [1 2 3];
end

if nmouse == 906
    spikegroups = [5 6];
end

if nmouse == 911
    spikegroups = [1 2];
end

if nmouse == 912
    spikegroups = [1 2 5];
end

if nmouse == 977
    spikegroups = [3 5];
end

if nmouse == 994
    spikegroups = 1:6;
end

if nmouse == 1117
    spikegroups = [2 3 4];
end

if nmouse == 1117
    spikegroups = [2 3 4];
end

if nmouse == 1124
    spikegroups = [2 3];
end

if nmouse == 1161
    spikegroups = [2 3];
end

if nmouse == 1162
    spikegroups = [1 2 3];
end

if nmouse == 1168
    spikegroups = [1 2 3 4];
end

end