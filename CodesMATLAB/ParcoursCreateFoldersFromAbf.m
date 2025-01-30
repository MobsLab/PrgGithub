%% -----------------------------------------------------------------------
%ParcoursCreateFoldersFromAbf
%-------------------------------------------------------------------------

filename=pwd;


listdir=dir;

for i=1:length(listdir)
        
        nom=listdir(i).name;
        le=length(nom);
        if le>4&nom(le-2:le)=='abf'
        try
            eval(['mkdir ',nom(1:le-4)])
            eval(['!mv ',nom,' ',nom(1:le-4)])
        end
        end
        
end