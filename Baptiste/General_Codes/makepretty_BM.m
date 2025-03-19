

function makepretty_BM()
% set some graphical attributes of the current axis

set(get(gca, 'XLabel'), 'FontSize', 22);
set(get(gca, 'YLabel'), 'FontSize', 22);
set(gca, 'FontSize', 12);
box off
set(gca,'Linewidth',1)
% set(get(gca, 'Title'), 'FontSize', 18);

ch = get(gca, 'Children');

for c = 1:length(ch)
    thisChild = ch(c);
    if strcmp('line', get(thisChild, 'Type'))
        if strcmp('.', get(thisChild, 'Marker'))
            if get(thisChild, 'MarkerSize')<15
                        set(thisChild, 'MarkerSize', 10);
            end
        end
        if strcmp('-', get(thisChild, 'LineStyle'))
%             set(thisChild, 'LineWidth', 1.5);
        end
    elseif strcmp('stair', get(thisChild, 'Type'))
                    set(thisChild, 'LineWidth', 1.5);
    elseif strcmp('errorbar', get(thisChild, 'Type'))
                    set(thisChild, 'LineWidth', 1.5);

    end
end
