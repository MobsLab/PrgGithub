%%rdmColorsKJ
% 09.01.2019 KJ
%
%
% colors = rdmColorsKJ(n_colors,bg,func)
%
%   see 
%       distinguishable_colors
%


function colors = rdmColorsKJ(n_colors,bg)

    % Parse the inputs
    if (nargin < 2)
        bg = [1 1 1];  % default white background
    else
        if iscell(bg)
        % User specified a list of colors as a cell aray
            bgc = bg;
            for i = 1:length(bgc)
                bgc{i} = parsecolor(bgc{i});
            end
        bg = cat(1,bgc{:});
        else
        % User specified a numeric array of colors (n-by-3)
            bg = parsecolor(bg);
        end
    end
    
    %use distinguishable_colors function
    dist_colors = distinguishable_colors(n_colors,bg);
    
    %convert to cell
    for i=1:size(dist_colors,1)
        colors{i} = dist_colors(i,:);
    end
    
    
end