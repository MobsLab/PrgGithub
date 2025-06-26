
cd('/media/nas8/OB_ferret_AG_BM/Shropshire/freely-moving/20241206_TORCs')
load('SleepScoring_OBGamma.mat', 'CleanStates')

% 1. Define states
stateNames = {'Wake', 'N1', 'N2', 'REM'};
states = {CleanStates.Wake, CleanStates.N1, CleanStates.N2, CleanStates.REM};

% 2. Compute transition intervals
[aft_cell, ~] = transEpoch(states{:});

% 3. Initialize transition count matrix
nStates = length(states);
transMatrix = zeros(nStates, nStates);

for i = 1:nStates
    for j = 1:nStates
        try
        transMatrix(i,j) = length(Start(aft_cell{i,j}));
        end
    end
end

% 4. Optional: Normalize to transition probabilities (per row)
transProb = transMatrix ./ max(sum(transMatrix,2),1);  % avoid division by zero

% 5. Display transition matrix in table format
disp('Raw Transition Counts:')
disp(array2table(transMatrix, 'VariableNames', stateNames, 'RowNames', stateNames))

disp('Transition Probabilities (row-normalized):')
disp(array2table(transProb, 'VariableNames', stateNames, 'RowNames', stateNames))

% 6. Display with imagesc
figure;
imagesc(transProb);
colormap(parula);  % or viridis if added
colorbar;
axis equal tight; axis xy, axis square
colormap viridis

% 7. Set axis labels and ticks
xticks(1:nStates);
yticks(1:nStates);
xticklabels(stateNames);
yticklabels(stateNames);
xlabel('To State');
ylabel('From State');
title('Sleep State Transition Counts');

% 8. Show numeric labels on top
for i = 1:nStates
    for j = 1:nStates
        text(j, i, num2str(round(transProb(i,j) , 2)), ...
            'HorizontalAlignment', 'center', ...
            'VerticalAlignment', 'middle', ...
            'Color', 'w', 'FontWeight', 'bold');
    end
end
