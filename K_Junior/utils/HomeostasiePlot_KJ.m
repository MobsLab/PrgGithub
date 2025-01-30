function [haxes] = HomeostasiePlot_KJ(Hstat,varargin)

% function pval= PlotErrorBarN_KJ(A,varargin)
%
% INPUT:
% - Hstat                       can be a matrice, line corresponds to dots & columns to bars
%                           or a cell Array
%
% - newfig (optional)       = 1 to display in a new figure, 0 to add on existing 
%
%
% OUTPUT:
% - haxes
%
%       see PlotErrorBarN PlotErrorLineN_KJ PlotErrorSpreadN_KJ
%


%% CHECK INPUTS

if nargin < 1 || mod(length(varargin),2) ~= 0
  error('Incorrect number of parameters.');
end

% Parse parameter list
for i = 1:2:length(varargin)
    if ~ischar(varargin{i})
        error(['Parameter ' num2str(i+2) ' is not a property.']);
    end
    switch(lower(varargin{i}))
        case 'newfig'
            newfig = varargin{i+1};
            if newfig~=0 && newfig ~=1
                error('Incorrect value for property ''newfig''.');
            end
        otherwise
            error(['Unknown property ''' num2str(varargin{i}) '''.']);
    end
end

%check if exist and assign default value if not
if ~exist('newfig','var')
    newfig=1;
end

color_nrem = 'b';
color_rem  = [0 0.5 0];
color_wake = 'k';
color_curve = [0.5 0.5 0.5];
color_S = 'b';
color_peaks = 'r';
color_fit = 'k';


% S process
x_intervals = Hstat.x_intervals;

%global
x_peaks = Hstat.x_peaks;
y_peaks = Hstat.y_peaks;
Sprocess.x = x_intervals(x_intervals>=x_peaks(1) & x_intervals<=x_peaks(end));
Sprocess.y = interp1(x_peaks, y_peaks, Sprocess.x, 'pchip'); 



%% DISPLAY

%insert graph in an existing figure or create a new one
if newfig
    figure('color',[1 1 1]),
end
figure(gcf), hold on,

plot(Hstat.x_intervals, Hstat.y_density, 'color', color_curve, 'linewidth',2),
plot(Sprocess.x, Sprocess.y, color_S),
scatter(Hstat.x_peaks, Hstat.y_peaks, 20,'r','filled')
plot(Hstat.x_intervals, Hstat.reg0,'color',color_fit,'linewidth',2);


haxes = gca;

end


