function [fbasename mergedir rootdir] = extractfbasename(fname)

[dir f1 f2] =  fileparts(fname);
if ~isempty(dir)
   dir = [dir filesep];
end
fbasename = [f1 f2];
rootdir = [dir fbasename];
mergedir = [rootdir filesep fbasename];
    