function SaveLFP(filename_LFP)
try 
    load(filename_LFP)
catch
    disp(['... no file ' filename_LFP ' could be loaded; verify the folder and name'])
    return
end
  
for num = 1:numel(LFP)
    namefile = ['LFP' num2str(num)];
    eval(['LFP' num2str(num) '= LFP{num}'])
    eval(['save(namefile, LFP' num2str(num)])
end