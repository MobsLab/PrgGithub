cd H:\Data_electrophy_astros\New

listdir=dir;                    % listdir = la liste du contenu du dossier 'New' (structure)

for mois=1:length(listdir)
    
    cd H:\Data_electrophy_astros\New

		if listdir(mois).isdir==1&listdir(mois).name(1)~='.'

        
        cd (listdir(mois).name) % on ouvre le sous-dossier 'mois'
        
        listsousdir=dir;         % listsousdir = la liste du contenu du dossier 'mois' (structure)
        
           fid = fopen('list.txt','w');
           
           

                for i=1:length(listsousdir)
            
                    if listsousdir(i).name(1)~='.'      %premi�re lettre de name diff�rente d'un point
            
                         nom=listsousdir(i).name;
                         le=length(listsousdir(i).name);
            
                            try
				                 if nom(le-2:le)=='abf';
            
                                        fprintf(fid,'%s\r\n',nom);  %   %s c'est ce qui d�signe ta chaine de caract�re que tu sp�cifies apres
                                                                    %   \r\n c'est pour faire changer de ligne
                                 end
                            end
                            
           
                    end
            
                end

           
           
           
           
         fclose(fid);
         
        end
    
end

               
         

