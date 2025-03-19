 % creer au prealable un dossier  'corrupted_files' dans le dossier
 % 'F11122014-0001'
res=pwd;
list=dir;
for i=4:length(list)
    
    try
        load(list(i).name)
         disp([ list(i).name ' ok'])
    catch 
     movefile([res '/' list(i).name ],[res '/corrupted_files'])
     disp(['moving ' list(i).name])
    end
end