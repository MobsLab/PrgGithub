%  ParcoursAbfHistLR2
try 
freq;
catch
freq=10000;
end


% cd H:\Data_electrophy_astros\New\Septembre_2010


% listdir=dir;
% 
% for mois=1:length(listdir)
% %  for mois=1:7
% 
% 	cd H:\Data_electrophy_astros\2008\OB
% 
% 	if listdir(mois).isdir==1&listdir(mois).name(1)~='.'
% 
% %  	disp('ok step 1')
% 
% 	cd (listdir(mois).name)
% 
% 	listsousdir=dir;
% 
% 		for i=1:length(listsousdir)
% %  		for i=1:3

listdir=dir;

for i=1:length(listdir)
    
    	cd H:\Data_electrophy_astros\New\Septembre_2010

        if listdir(i).name(1)~='.'

        nom=listdir(i).name;
        le=length(listdir(i).name);			

                    try
                        if nom(le-2:le)=='abf';
                        nom	
                        
                        
                            try
                                eval(['cd ', nom(1:le-4)])
                                load Data
                                load DataAjust
                                
                            catch

                                data=abfloadKB(nom);

                                nbtraces=size(data,2)-1;

                                mkdir(pwd,nom(1:le-4))

                                eval(['cd ', nom(1:le-4)])
        %                         
                                save Data data freq nbtraces nom 
                                
                                
                                
                                HistVmLR
                                
                                
                            end
                               
                        
                        close all
        % 				cd ..


                        end
                    end

        end
end
		