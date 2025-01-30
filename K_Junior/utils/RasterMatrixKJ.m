function raster_tsd = RasterMatrixKJ(S, center, t_start, t_end, idx_order)

% Generate matrix of rasters 
%
%%  USAGE
% raster_matrix = RasterMatrixKJ(S, center, TStart, TEnd, idx_order);
%
%% INPUT
%
%    S              tsd : signal used to compute raster 
%                   e.g. LFP, MUA, SUA...
%
%    center         ts : center of the rasters, generally events 
%                   e.g. down states, stimuli...
%    t_start        num : time where the rasters start from the stimuli (in 1E-4s)
%                   (negative if before)
%    t_end          num : time where the rasters end from the stimuli (in 1E-4s)
%                   (negative if before)
%    idx_order(opt) List of index ordered to sort the rasters
%
%% OUTPUT
%
%    raster_matrix    matrix of rasters
%
%% 
%  NOTE
%    
%
%  SEE
%
%    See also RasterImagePlot, ImagePETHOrdered, ImagePETH



%split signal for each intervalSet
is = intervalSet(Range(center)+t_start, Range(center)+t_end);
sweeps = intervalSplit(S, is, 'OffsetStart', t_start);
try 
    idx_order;
    sweeps = sweeps(idx_order);
end

if isfinite(t_start)
  for i = 1:length(sweeps)
    Si{i} = Restrict(sweeps{i}, t_start, t_end);
  end
else 
  Si = sweeps;
end

%standard size of sweeps
freqsampling = round(1/median(diff(Range(S,'s'))));
size_standard = (t_end-t_start)*freqsampling*1e-4;

%check size of sweeps
for i = 1:length(Si)
    size_sweeps(i) = length(Si{i});
end

%correct size eventually
idx_size = find(size_sweeps~=size_standard);
for i=1:length(idx_size)
    k=idx_size(i); 
    data = Data(Si{k});
    
    rg = Range(Si{find(size_sweeps==size_standard,1)});
    size_data = length(data);
    if size_data<size_standard
        try
            data = [data(1)*ones(size_standard - size_data,1); data];
        catch
            data = ones(size_standard,1);
        end
    else
        data = data(1:size_standard);
    end
    
    disp(['size corrected for sweep ' num2str(k) '(' num2str(size_data) 'to' num2str(size_standard) ')'])
    Si{k} = tsd(rg, data);
end


%Results
matVal = zeros(length(Si),size_standard);
for i = 1:length(Si)
  matVal(i,:) = Data(Si{i})';
end

times = Range(Si{1});
raster_tsd = tsd(times,matVal');


end