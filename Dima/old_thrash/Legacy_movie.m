
%% Dynamic real vs inferred (TODO!!! - put the start with big points, put boundaries)
toplot = DecodedData(DecodedData(:,4)<0.015,:);
numit = ceil(length(DecodedData)/50);
figure('Units', 'normalized', 'OuterPosition', [0.1 0.2 0.8 0.5])
hold on
for it = 1:numit
    subplot(121);
    hold on
    timeplotted =  PosMat((it-1)*50+1:it*50,1);
    scatter(PosMat((it-1)*50+1:it*50,3), PosMat((it-1)*50+1:it*50,2), 16, timeplotted);
    xlim([20 60]);
    ylim([20 53]);
    title('Real position')
    subplot(122);
    hold on
    idx_first = find(toplot(:,1)>=timeplotted(1), 1);
    idx_last = find(toplot(:,1)<=timeplotted(end), 1, 'last');
    scatter(toplot(idx_first:idx_last, 2), toplot(idx_first:idx_last, 3), 16, toplot(idx_first:idx_last,1));
    xlim([0.37 1]);
    ylim([0.39 0.95])
    title('Inferred Position')
    pause(1)
    
end