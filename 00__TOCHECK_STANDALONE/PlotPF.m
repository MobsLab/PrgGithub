
function PlotPF(map,varargin)

% option
%----------------
%  'smoothing'
%  'limitexplo'
%  'figure'

 for i = 1:2:length(varargin),

              switch(lower(varargin{i})),

                case 'smoothing',
                  smo = varargin{i+1};
                  if ~isa(smo,'numeric'),
                    error('Incorrect value for property ''smoothing'' (type ''help PlaceField'' for details).');
                  end
                  
                case 'limitexplo',
                  lim = varargin{i+1};
                  
                case 'figure',
                  fig = varargin{i+1};
                  
              end
 end






try
    smo;
data=SmoothDec(map.rate,[smo smo]);
p=SmoothDec(map.time,[smo smo]);
catch

data=map.rate;
p=map.time;
end

try 
    lim;
catch
    lim=0.8;
end

try
    fig;
catch
    fig='new';
end

typeplot='brightness';

gamma=1;
drawBar='off';
cutoffs = [];
type='linear';

axisxy='on';
[y,x] = size(data);
x = 1:x;y = 1:y;

%--------------------------------------------------------------------------


% for i=1:length(p)
% for j=1:length(p)
% dimm(i,j)=1/p(i,j);
% end
% end

dimm=p;
dimm(dimm<lim)=eps;

dimm=log10(dimm);

%dimm=dimm/max(max(dimm));
dimm=rescale(dimm,0,1);

HSV(:,:,2) = ones(size(data));
if ~isempty(cutoffs),
m = cutoffs(1);
M = cutoffs(2);
else
m = min(min(data));
M = max(max(data));
end

HSV(:,:,1) = (2/3) - (2/3)*Clip((data-m)/(M-m),0,1).^gamma;
colorspace='rgb';


HSV(:,:,3) = dimm;
mapp = hsv2rgb(HSV);
if strcmp(axisxy,'off')
y=y(end:-1:1);
end

if strcmp(fig,'new')
figure('Color',[1 1 1])
end

a = gca;

K = imagesc(x,y,mapp,[m M]); colorbar








