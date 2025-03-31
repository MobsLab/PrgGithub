

function makepretty()
% set some graphical attributes of the current axis

set(get(gca, 'XLabel'), 'FontSize', 16);
set(get(gca, 'YLabel'), 'FontSize', 16);
set(gca, 'FontSize', 15);
box off
set(gca,'Linewidth',2)
set(get(gca, 'Title'), 'FontSize', 17);

ch = get(gca, 'Children');

for c = 1:length(ch)
    thisChild = ch(c);
    if strcmp('line', get(thisChild, 'Type')) 
        if strcmp('.', get(thisChild, 'Marker'))
            set(thisChild, 'MarkerSize', 15);
        end
        if strcmp('-', get(thisChild, 'LineStyle'))
            set(thisChild, 'LineWidth', 2.0);
        end
    end
end
