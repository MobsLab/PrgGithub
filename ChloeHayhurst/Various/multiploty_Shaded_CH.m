function [ax,hlines] = multiploty_Shaded_CH(set1,set2,set3,xlabels,ylabels,varargin)
% MULTIPLOTYYY - Extends plotyy to include a third y-axis and allows the
% user to plot multiple lines on each set of axes.
%
% Syntax:  [ax,hlines] = plotyyy(set1,set2,set3,ylabels)
%
% Inputs: set1 is a cell array with the xdata and ydata for the first axes
%         set2 is a cell array with the xdata and ydata for the second axes
%         set3 is a cell array with the xdata and ydata for the third axes
%         ylabels is a 3x1 cell array containing the ylabel strings
%
% Outputs: ax -     3x1 double array containing the axes' handles
%          hlines - 3x1 cell array containing the lines' handles
%

for i = 1:2:length(varargin)
    if ~ischar(varargin{i})
        error(['Parameter ' num2str(i+2) ' is not a property.']);
    end
    switch lower(varargin{i})
        case 'smooth'
            smooth = varargin{i+1}; % smoothing factor for runmean
        case 'fig'
            fig = varargin{i+1}; % smoothing factor for runmean
    end
end


if ~exist('smooth','var')
    smooth = 0;
end

if ~exist('fig','var')
    fig = figure('units','normalized','Color',[1 1 1]);
end

validateattributes(set1,{'cell'},{})
validateattributes(set2,{'cell'},{})
validateattributes(set3,{'cell'},{})

% Plot the first set of lines
ax(1) = axes('Parent',fig);
Data_to_use = set1{1,2};
Conf_Inter = nanstd(Data_to_use)/sqrt(size(Data_to_use,1));
Mean_All_Sp = nanmean(Data_to_use);
hlines{1} = shadedErrorBar(set1{1,1} , runmean_BM(Mean_All_Sp,smooth) , runmean(Conf_Inter,smooth),'-b',1);
hlines{1}.mainLine.LineWidth = 2;
xlabel(xlabels)
ax(1).YColor = 'b';
ax(1).LineWidth = 2;
ax(1).FontSize = 15;
% 
% lines = set(hlines{1}(1),'LineStyle');
% lines(end) = [];
% nlines = numel(lines);
% markers = set(hlines{1}(1),'Marker');
% markers(end) = [];
% nmarkers = numel(markers);
% 
% if numel(hlines{1}) > 1
%     for idx = 1:numel(hlines{1})
%         hlines{1}(idx).LineStyle = lines{rem(idx,nlines)+1};
%         if numel(hlines{1}) > 4
%             hlines{1}(idx).Marker = markers{rem(idx,nmarkers)+1};
%         end
%     end
% end

% Plot the second set of lines

ax(2) = axes('Parent',fig);
Data_to_use = set2{1,2};
Conf_Inter = nanstd(Data_to_use)/sqrt(size(Data_to_use,1));
Mean_All_Sp = nanmean(Data_to_use);
hlines{2} = shadedErrorBar(set2{1,1} , runmean_BM(Mean_All_Sp,smooth) , runmean(Conf_Inter,smooth),'-r',1);
hlines{2}.mainLine.LineWidth = 2;
ax(2).YColor = 'b';
ax(2).LineWidth = 2;
ax(2).FontSize = 15;

set(ax(2),'YAxisLocation','right','Color','none','YColor',[1 0 0],...
    'xlim',get(ax(2),'xlim'),'xtick',[],'box','off','XColor','k');
ax(2).LineWidth = 2;
ax(2).FontSize = 15;
% 
% if numel(hlines{2}) > 1
%     for idx = 1:numel(hlines{2})
%         set(hlines{2}(idx),'LineStyle',lines{rem(idx,nlines)+1})
%         if numel(hlines{2}) > 4
%             set(hlines{2}(idx),'Marker',markers{rem(idx,nmarkers)+1});
%         end
%     end
% end

% Set the axes position and size
pos = [0.1  0.1  0.7  0.8];
offset = pos(3)/5.5;

pos(3) = pos(3) - offset/2;
ax(1).Position = pos;
ax(2).Position = pos;

% Determine the position of the third axes
pos3 = [pos(1) pos(2) pos(3)+offset pos(4)];

% Determine the proper x-limits for the third axes
limx1 = ax(1).XLim;
limx3 = [limx1(1)   limx1(1) + 1.2*(limx1(2)-limx1(1))];

ax(3) = axes('Parent',fig);
Data_to_use = set3{1,2};
Conf_Inter = nanstd(Data_to_use)/sqrt(size(Data_to_use,1));
Mean_All_Sp = nanmean(Data_to_use);
hlines{3} = shadedErrorBar(set3{1,1} , runmean_BM(Mean_All_Sp,smooth) , runmean(Conf_Inter,smooth),'-g',1);
hlines{3}.mainLine.LineWidth = 2;
ax(3).YColor = 'g';
ax(3).LineWidth = 2;
ax(3).FontSize = 15;

set(ax(3),'Position',pos3,'box','off',...
   'Color','none','XColor','k','YColor','g',...   
   'xtick',[],'xlim',limx3,'yaxislocation','right',...
   'XColor','none');

ax(3).LineWidth = 2;
ax(3).FontSize = 15;
% 
% 
% if numel(hlines{3}) > 1
%     for idx = 1:numel(hlines{3})
%         set(hlines{3}(idx),'LineStyle',lines{rem(idx,nlines)+1})
%         if numel(hlines{3}) > 4
%             set(hlines{3}(idx),'Marker',markers{rem(idx,nmarkers)+1});
%         end
%     end
% end

% Label all three y-axes
ax(1).YLabel.String = ylabels{1};
ax(2).YLabel.String = ylabels{2};
ax(3).YLabel.String = ylabels{3};
