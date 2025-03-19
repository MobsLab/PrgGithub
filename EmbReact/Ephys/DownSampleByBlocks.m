function out=DownSampleByBlocks(dat_tsd,dt_end,opt)

% downsamples dat_tsd to the new frequency 1/dt_end by applying the
% function opt ('mean','median','max') to blocks of rigth size
dt=median(diff(Range(dat_tsd,'s')));
Resample = ceil(dt_end./dt);
data = Data(dat_tsd);
tps = Range(dat_tsd);

tps_out= nanmean(reshape([tps(:); nan(mod(-numel(tps),Resample),1)],Resample,[]));

switch opt
    case 'mean'
        data_out = nanmean(reshape([data(:); nan(mod(-numel(data),Resample),1)],Resample,[]));
    case 'max'
        data_out = nanmax(reshape([data(:); nan(mod(-numel(data),Resample),1)],Resample,[]));
    case 'median'
        data_out = nanmedian(reshape([data(:); nan(mod(-numel(data),Resample),1)],Resample,[]));
    case 'std'
        data_out = nanstd(reshape([data(:); nan(mod(-numel(data),Resample),1)],Resample,[]));
        
end

out = tsd(tps_out,data_out');

end