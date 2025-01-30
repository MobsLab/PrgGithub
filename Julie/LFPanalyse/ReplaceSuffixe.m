function ReplaceSuffixe(suffixe2replace, newsuffixe)

% ex : suffixe2replace='Rest-tracking'
list=dir;


for i=1:length(list)
    filename=list(i).name;
    if length(list(i).name)>3 
        if (~isempty(strfind(list(i).name, '.pos'))||~isempty(strfind(list(i).name, '.mat')))% avoid the '.' and '..'
        a=strfind(filename, suffixe2replace);
        le=length(suffixe2replace);
        newname=[filename(1:a-1) newsuffixe filename(le+a:end)];
        copyfile(filename,newname)
        end
    end
    
end