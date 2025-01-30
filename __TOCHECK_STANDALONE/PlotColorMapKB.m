%PlotColorMapKB - Plot a color map.
%
%  Plot a color map (e.g. the firing field of a place cell).
%
%  USAGE
%
%    PlotColorMap(data,dimm,<options>)
%
%    data           data
%    dimm           optional luminance map
%    <options>      optional list of property-value pairs (see table below)
%
%    =========================================================================
%     Properties    Values
%    -------------------------------------------------------------------------
%     'x'           abscissae
%     'y'           ordinates
%     'threshold'   dimm values below this limit are zeroed (default = 0.01)
%     'cutoffs'     lower and upper cutoff values ([] = autoscale, default)
%     'gamma'       gamma correction (1 = no correction, default)
%     'colorspace'  'HSV' or 'RGB' (default = 'RGB')
%     'bar'         draw a color bar (default = 'off')
%     'type'        either 'linear' or 'circular' (default 'linear')
%     'smooth'       smooth (default = '5')
%    =========================================================================
%
%  NOTE
%
%    The luminance map is used to dimm the color map. A single scalar value
%    can is interpreted as a constant luminance map. If this parameter is not
%    provided, normal equiluminance is assumed (i.e. scalar value of 1).
%
%  EXAMPLE
%
%    fm = FiringMap(positions,spikes);      % firing map for a place cell
%    figure;PlotColorMap(fm.rate,fm.time);  % plot, dimming with occupancy map

% Copyright (C) 2004-2006 by Micha??????l Zugaro
%
% This program is free software; you can redistribute it and/or modify
% it under the terms of the GNU General Public License as published by
% the Free Software Foundation; either version 2 of the License, or
% (at your option) any later version.

function Map=PlotColorMapKB(data,dimm,scal,varargin)

% Default values

% dimm
% scal = echelle

s=5; %smoothing value


cutoffs = [];
gamma = 1;
colorspace = 'rgb';
threshold = 0.01;
drawBar = 0;
type = 'linear';
[y,x] = size(data);
x=[scal(1):(scal(2)-scal(1))/(x-1):scal(2)];
y=[scal(3):(scal(4)-scal(3))/(y-1):scal(4)];


if nargin < 1,
	error('Incorrect number of parameters (type ''help PlotColorMap'' for details).');
end
if nargin == 1,
	dimm = 1;
end

% Parse parameter list
for i = 1:2:length(varargin),
  if ~isa(varargin{i},'char'),
    error(['Parameter ' num2str(i+2) ' is not a property (type ''help PlotColorMap'' for details).']);
  end
  switch(lower(varargin{i})),

    case 'threshold',
      threshold = varargin{i+1};
      if ~isa(threshold,'numeric'),
        error('Incorrect value for property ''threshold'' (type ''help PlotColorMap'' for details).');
      end
      if length(threshold) ~= 1 | threshold < 0,
        error('Incorrect value for property ''threshold'' (type ''help PlotColorMap'' for details).');
      end

    case 'x',
      x = varargin{i+1};
      if ~isa(x,'numeric'),
        error('Incorrect value for property ''x'' (type ''help PlotColorMap'' for details).');
      end

    case 'y',
      y = varargin{i+1};
      if ~isa(x,'numeric'),
        error('Incorrect value for property ''y'' (type ''help PlotColorMap'' for details).');
      end

    case 'cutoffs',
      cutoffs = varargin{i+1};
      if ~isa(cutoffs,'numeric') | length(cutoffs) ~= 2 | cutoffs < 0,
        error('Incorrect value for property ''cutoffs'' (type ''help PlotColorMap'' for details).');
      end

    case 'gamma',
      gamma = varargin{i+1};
      if ~isa(gamma,'numeric') | length(gamma) ~= 1 | gamma < 0,
        error('Incorrect value for property ''gamma'' (type ''help PlotColorMap'' for details).');
      end

    case 'colorspace',
      colorspace = lower(varargin{i+1});
      if ~IsStringInList(colorspace,'hsv','rgb'),
        error('Incorrect value for property ''colorspace'' (type ''help PlotColorMap'' for details).');
      end

    case 'bar',
    	drawBar = lower(varargin{i+1});
      if ~IsStringInList(drawBar,'on','off'),
        error('Incorrect value for property ''bar'' (type ''help PlotColorMap'' for details).');
      end

    case 'type',
    	type = lower(varargin{i+1});
      if ~IsStringInList(type,'linear','angular'),
        error('Incorrect value for property ''type'' (type ''help PlotColorMap'' for details).');
      end

       case 'smooth',
    	s = lower(varargin{i+1});
      
      
    otherwise,
      error(['Unknown property ''' num2str(varargin{i}) ''' (type ''help PlotColorMap'' for details).']);

  end
end

%--------------------------------------------------------------------------------------------------------------------------------

HSV(:,:,2) = ones(size(data));
if ~isempty(cutoffs),
	m = cutoffs(1);
	M = cutoffs(2);
else
	m = min(min(data));
	M = max(max(data));
end

if strcmp(type,'linear'),
	HSV(:,:,1) = (2/3) - (2/3)*Clip((data-m)/(M-m),0,1).^gamma;
else
	HSV(:,:,1) = Clip((data-m)/(M-m),0,1).^gamma;
end
if length(dimm) == 1,
	dimm = dimm*ones(size(data));
end
HSV(:,:,3) = 1./(1+threshold./(dimm+eps));

if strcmp(colorspace,'rgb'),
  map = hsv2rgb(HSV);
elseif strcmp(colorspace,'hsv'),
  map = HSV;
end

%--------------------------------------------------------------------------------------------------------------------------------

Map(:,:,1)=SmoothDec(map(:,:,1),[s,s]);
Map(:,:,2)=SmoothDec(map(:,:,2),[s,s]);
Map(:,:,3)=SmoothDec(map(:,:,3),[s,s]);


a = gca;
p = imagesc(x,y,Map(:,:,1),[m M]);
set(a,'ydir','normal','tickdir','out','box','off');

if strcmp(drawBar,'on'),
	if strcmp(type,'linear'),
		barHSV(:,:,1) = (2/3) - (2/3)*(0:.01:1)'.^gamma;
	else
		barHSV(:,:,1) = (0:.01:1)'.^gamma;
	end
	barHSV(:,2) = ones(101,1);
	barHSV(:,3) = ones(101,1);
	colormap(hsv2rgb(barHSV));
%  	b = colorbar('vert');
%  	set(b,'xtick',[],'tickdir','out','box','off');
	axes(a);
end

%  keyboard
