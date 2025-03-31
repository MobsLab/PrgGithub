
function makepretty_CH()
% set some graphical attributes of the current axis

set(get(gca, 'XLabel'), 'FontSize', 18);
set(get(gca, 'YLabel'), 'FontSize', 18);
set(gca, 'FontSize', 18);
box off
set(gca,'Linewidth',2)
set(get(gca, 'Title'), 'FontSize', 20);

ch = get(gca, 'Children');

for c = 1:length(ch)
    thisChild = ch(c);
    if strcmp('line', get(thisChild, 'Type'))
        if strcmp('.', get(thisChild, 'Marker'))
            if get(thisChild, 'MarkerSize')<15
                set(thisChild, 'MarkerSize', 25);
            end
        end
    end
    if strcmp('stair', get(thisChild, 'Type'))
        set(thisChild, 'LineWidth', 2);
    end
    if strcmp('errorbar', get(thisChild, 'Type'))
        set(thisChild, 'LineWidth', 2);
    end
end

