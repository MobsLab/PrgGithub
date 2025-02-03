function map=PlotCorrMatrix(data,p,psg,varargin)

% 
% INPUT:
% --------------------------------------------
% data
% p
% psg : significativity
% 
% optional:
%     typ=2;
%     threshold=0.01;
%     gamma=1;
%     drawBar='on';
%     cutoffs = [];
%     colorspace = 'rgb';
%     type = 'linear';
%
% 
% OUTPUT:
% -------------------------------------------- 
% 
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
%    =========================================================================
%
%  NOTE
%
%    The luminance map is used to dimm the color map. A single scalar value
%    can is interpreted as a constant luminance map. If this parameter is not
%    provided, normal equiluminance is assumed (i.e. scalar value of 1).



%%

typeplot='brightness';
threshold=0.01;
gamma=1;
drawBar='off';
cutoffs = [];
type='linear';
fig='new';
axisxy='off';
legend={};

 % Parse parameter list
for i = 1:2:length(varargin),
    
  if ~isa(varargin{i},'char'),
    error(['Parameter ' num2str(i+2) ' is not a property (type ''help PlotCorrMatrix'' for details).']);
  end
      
  switch(lower(varargin{i})),
      
    case 'typeplot',
    	typeplot = lower(varargin{i+1});
      if ~IsStringInList(typeplot,'brightness','threshold'),
        error('Incorrect value for property ''TypePlot'' (type ''help PlotCorrMatrix'' for details).');
      end

    case 'axisxy',
    	axisxy = lower(varargin{i+1});
      if ~IsStringInList(axisxy,'on','off'),
        error('Incorrect value for property ''axisxy'' (type ''help PlotCorrMatrix'' for details).');
      end

    case 'legend',
%     	legend = lower(varargin{i+1});
    	legend = (varargin{i+1});
      
    case 'figure',
    	fig = lower(varargin{i+1});
      if ~IsStringInList(fig,'new','existing'),
        error('Incorrect value for property ''figure'' (type ''help PlotCorrMatrix'' for details).');
      end
      
      
    case 'threshold',
      threshold = varargin{i+1};
      if ~isa(threshold,'numeric'),
        error('Incorrect value for property ''threshold'' (type ''help PlotCorrMatrix'' for details).');
      end
      if length(threshold) ~= 1 | threshold < 0,
        error('Incorrect value for property ''threshold'' (type ''help PlotCorrMatrix'' for details).');
      end

    case 'x',
      x = varargin{i+1};
      if ~isa(x,'numeric'),
        error('Incorrect value for property ''x'' (type ''help PlotCorrMatrix'' for details).');
      end

    case 'y',
      y = varargin{i+1};
      if ~isa(x,'numeric'),
        error('Incorrect value for property ''y'' (type ''help PlotCorrMatrix'' for details).');
      end

    case 'cutoffs',
      cutoffs = varargin{i+1};
      if ~isa(cutoffs,'numeric') | length(cutoffs) ~= 2 | cutoffs < 0,
        error('Incorrect value for property ''cutoffs'' (type ''help PlotCorrMatrix'' for details).');
      end

    case 'gamma',
      gamma = varargin{i+1};
      if ~isa(gamma,'numeric') | length(gamma) ~= 1 | gamma < 0,
        error('Incorrect value for property ''gamma'' (type ''help PlotCorrMatrix'' for details).');
      end

    case 'bar',
    	drawBar = lower(varargin{i+1});
      if ~IsStringInList(drawBar,'on','off'),
        error('Incorrect value for property ''bar'' (type ''help PlotCorrMatrix'' for details).');
      end

    case 'type',
    	type = lower(varargin{i+1});
      if ~IsStringInList(type,'linear','angular'),
        error('Incorrect value for property ''type'' (type ''help PlotCorrMatrix'' for details).');
      end

    otherwise,

        error(['Unknown property ''' num2str(varargin{i}) ''' (type ''help PlotCorrMatrix'' for details).']);

  end
end

%%

if strcmp(typeplot,'threshold'),

        if strcmp(fig,'new')
        figure('Color',[1 1 1])
        end
        
        map=data;
        map(p>psg)=0;    
        imagesc(map)
            if strcmp(axisxy,'on')
        axis xy
            end
    
            
        if strcmp(drawBar,'on')
            colorbar
        end
        
        
        
        a = gca;
            if length(legend)>1
    set(a,'ydir','normal','tickdir','out','box','off');
    set(a,'xtick',[1:length(legend)])
    set(a,'xticklabel',legend)
    set(a,'ytick',[1:length(legend)])
    set(a,'yticklabel',legend)
    set(a,'xtick',[1:length(legend)])
    set(a,'xticklabel',legend)
            end
    
else
    %--------------------------------------------------------------------------

    
    [y,x] = size(data);
    x = 1:x;y = 1:y;

    %--------------------------------------------------------------------------

    p(p==0)=1E-4;

    for i=1:size(p,1)
        for j=1:size(p,2)
            dimm(i,j)=1./p(i,j);
        end
    end
    
psg=psg/4*3;
    lim=1/psg*2;
    dimm(dimm>lim)=lim;

    %dimm=dimm/max(max(dimm));
    %dimm=dimm/0.2;
   dimm=rescale(dimm,0,1);

    % dimm=1;

    %--------------------------------------------------------------------------
    %%
    % As H(:,1) varies from 0 to 1, the resulting color varies from red through yellow,
    % green, cyan, blue, and magenta, and returns to red. When H(:,2) is 0, the colors
    % are unsaturated (i.e., shades of gray). When H(:,2) is 1, the colors are fully 
    % saturated (i.e., they contain no white component). As H(:,3) varies from 0 to 1,
    % the brightness increases. 

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
        colorspace='rgb';
    else
        HSV(:,:,1) = Clip((data-m)/(M-m),0,1).^gamma;
        colorspace='hsv';
    end

    % if length(dimm) == 1,
    % 	dimm = dimm*ones(size(data));
    % end

    % HSV(:,:,3) = 1./(1+threshold./(dimm+eps));
    HSV(:,:,3) = dimm;

    if strcmp(colorspace,'rgb'),
      map = hsv2rgb(HSV);
    elseif strcmp(colorspace,'hsv'),
      map = HSV;
    end

    %%
    %--------------------------------------------------------------------------


        
    
    
    if strcmp(axisxy,'off')
        y=y(end:-1:1);
    end
        
    if strcmp(fig,'new')
    figure('Color',[1 1 1])
    end
    
    a = gca;
    K = imagesc(x,y,map,[m M]);
    
    if length(legend)>1
    set(a,'ydir','normal','tickdir','out','box','off');
    set(a,'xtick',[1:length(legend)])
    set(a,'xticklabel',legend)
    set(a,'ytick',[1:length(legend)])
    set(a,'yticklabel',legend)
    set(a,'xtick',[1:length(legend)])
    set(a,'xticklabel',legend)
    end
    
    if strcmp(drawBar,'on'),
        
        if strcmp(type,'linear'),
            barHSV(:,1) = (2/3) - (2/3)*(0:.01:1)'.^gamma;
        else
            barHSV(:,1) = (0:.01:1)'.^gamma;
        end
        barHSV(:,2) = ones(101,1);
        barHSV(:,3) = ones(101,1);
        
%         for i=1:64
%         coul(i,:)=[i/64 0 (64-i)/64];
%         end
%         h=hist(10*randn(100000,1)+32,64);
%         h=h/max(h);
%         h1=h/1.5+0.4;
%         h2=abs(1-h);
%         coul(:,1)=coul(:,1)-h1'+h2'/4;
%         coul(:,3)=coul(:,3)-h1'+h2'/4;
%         coul(:,2)=coul(:,2)+0.1;
%         coul(coul<0)=0;
%         coul(coul>1)=1;
        
        
%         colormap(hsv2rgb(barHSV));
        colormap(coul);

        
        
        b = colorbar('vert');
        set(b,'xtick',[],'tickdir','out','box','off');
        axes(a);
        
    end




end
%%








