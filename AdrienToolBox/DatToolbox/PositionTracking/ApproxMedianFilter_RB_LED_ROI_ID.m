%function whl = ApproxMedianFilter_RB_LED_ROI_ID(file)

% This code tests an approximate median filter for separating out the red
% and blue leds mounted on top of the subjects head
% I was using the DataMax system, which was synced using a red LED. Hence,
% I am tracking the x,y position of the animal as well as when the sync
% light comes on.


%file       = 'Mouse12-120808-01.mpg';
%[~,name,~] = fileparts(file);
% Create Text file for writing out LED locations and sync trigger
%fid        = fopen(sprintf('%s.whl',name),'w+');
% Creater readerobj of file
%readerobj  = VideoReader(file);
width      = readerobj.Width;
height     = readerobj.Height;
threshB    = 50;    % threshold on background substracted image
threshF    = 50;    % threshold on foreground pixel intensity
% Initial frame
Fint       = 1;

% Initialize grid for locating centroid of LED
[X,Y] = meshgrid(1:width,1:height);

% Initialize background as a grayscale image of the first frame
bg_bw     = rgb2gray(read(readerobj,Fint));

% Create ROIs

figure('Name','Tracking ROI')
[ROI,xi,yi] = roipoly(bg_bw);   % create the ROI for the LEDS on the animal
close all


% I will update the ROI position using linear extrapolation
ROIi        = find(ROI);    % numerical indices for nested subsets
% calculate initial centroid of ROI and linear velocity vector
Xm          = X(ROI);
Ym          = Y(ROI);
cntX0       = floor(mean(Xm(:)));
dcntX       = 0;
cntY0       = floor(mean(Ym(:)));
dcntY       = 0;

% Initialize foreground image and difference image
fg          = zeros(size(bg_bw));
fr_diff     = zeros(size(bg_bw));

% Initialize color mask
mask  = zeros(height,width,3,'uint8');

whl = [];

for i = Fint:readerobj.NumberOfFrames
    
    % Access frame of interest
    fr    = read(readerobj,i);
    keyboard
    % Begin processing time
    t1 = tic;
    
    % convert frame to grayscale
    fr_bw = rgb2gray(fr);
    
    % compute difference between grayscale image & background in ROI
    fr_diff(ROI) = abs(double(fr_bw(ROI)) - double(bg_bw(ROI)));
    
    %figure(3),clf
    %imagesc(fr_diff)
    %pause
    % Check for threshold crossings within ROI and update subset of indices
    T            = find(fr_diff(ROIi) > threshB);
    fg(ROIi(T))  = fr_bw(ROIi(T));    
    % Update approximate median filter
    B                                    = find(fr_bw(ROIi) > bg_bw(ROIi));
    bg_bw(ROIi(B))                       = bg_bw(ROIi(B)) + 1;
    bg_bw(ROIi(~ismember(ROIi,B)))= ...
         bg_bw(ROIi(~ismember(ROIi,B))) - 1;

%        bg_bw(ROIi(~ismember_sorted(ROIi,B))) - 1;    % LIGHT SPEED FUNC    
    %%% Label Color Mask
    label         = repmat(logical(fg>threshF),[1 1 3]);
    mask(label)   = fr(label);
    mask(~label)  = 0;
    
    %%% Find centroid of remaining pixels %%%
    bw_mask = rgb2gray(mask);
    [L,Nl]  = bwlabel(double(bw_mask));
    ids     = [];
    
    % Initialize red and blue LEDS as missing (=> -1)
    Rr = [-1 -1];
    Br = [-1 -1];
    
    % Update centroid if connected components are found
    if Nl > 0
        a = regionprops(L,'PixelList');
        
        for ii = 1:Nl
            % Skip single pixels
            if size(a(ii).PixelList,1)<2
                continue
            end
            
            % Access color information and calculate means
            R  = mask(a(ii).PixelList(:,2),a(ii).PixelList(:,1),1);
            mR = mean(R(R>0));
            B  = mask(a(ii).PixelList(:,2),a(ii).PixelList(:,1),3);
            mB = mean(B(B>0));
            
            if mR > mB && mR > 200
                ids = [ids; a(ii).PixelList];
                Rr   = round(mean(a(ii).PixelList,1));
            elseif mR < mB && mB > 200
                ids = [ids; a(ii).PixelList];
                Br   = round(mean(a(ii).PixelList,1));
            else
                continue
            end
        end
    end
    
    % calculate centroid and update ROI
    % update if possible
    if ~isempty(ids)
        cntX   = floor(mean(ids(:,1)));
        cntY   = floor(mean(ids(:,2)));
        dcntX  = cntX-cntX0;
        dcntY  = cntY-cntY0;
        xi     = xi+dcntX;
        yi     = yi+dcntY;
        ROI    = roipoly(height,width,xi,yi);
        ROIi   = find(ROI);
        % shift iteration
        cntX0  = cntX;
        cntY0  = cntY;
        % Write out
    else
        % extrapolate from previous update if no new info
        xi     = xi+dcntX;
        yi     = yi+dcntY;
        ROI    = roipoly(height,width,xi,yi);
        ROIi   = find(ROI);
        % shift iteration
        cntX0  = cntX0+dcntX;
        cntY0  = cntY0+dcntY;
        % Write out
    end
    whl = [whl;[Rr(1),Rr(2),Br(1),Br(2)]];
    
    t2 = toc(t1);
    
    % End processing time
    if mod(i,100)==0
        h = waitbar(i/readerobj.NumberOfFrames);
        disp(['N: ' num2str(Nl)])
        if 0
            figure(1),h1 = subplot(3,1,1);imshow(uint8(fr)), title(sprintf('Frame %d, Time %f, Connected Components %d',i,t2,Nl))
            subplot(3,1,2),imshow(uint8(floor(fr_diff)))
            h2 = subplot(3,1,3);imshow(mask)
            %h3 = impoly(h1,[xj,yj]);
            h4 = impoly(h2,[xi,yi]);
            %setColor(h3,'green')
            setColor(h4,'yellow')
        end
    end
    % zero difference and foreground images
    fr_diff(:) = 0;
    fg(:)      = 0;
end
close(h)