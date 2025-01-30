function initResources(d)

if nargin == 0
    d = pwd;
end

p_dir = pwd;
cd(d);
resources = dictArray;
resourceLock = false;
save resources resourceLock -append
cd(p_dir);