function NewData=DownsInBlocks(y,BlockDur)
NewData=nanmean(reshape([y(:);nan(mod(-numel(y),BlockDur),1)],BlockDur,[]));
end
