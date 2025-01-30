
%ParcoursAnalysisApril2012


res=pwd;


listdir=dir;
for i=1:length(listdir)
    cd(res)
    if listdir(i).isdir==1&listdir(i).name(1)~='.'
        eval (['cd ',listdir(i).name])
        listsousdir=dir;
        for j=1:length(listsousdir)
            if listsousdir(j).isdir==1&listsousdir(j).name(1)~='.' 
                eval (['cd ',listsousdir(j).name])                                
                listfilesABF=dir;               
                for i=k:length(listfilesABF)                   
                    nom=listfilesABF(k).name;
                    le=length(listfilesABF(k).name);
                    

%-------------------------------------------------------------------------                        
%-------------------------------------------------------------------------
%-------------------------------------------------------------------------                        
                    if nom(le-3:le)='abf'
                        
                        TransformDataStep1('N',nom,[0.3 0.1]);
                        NEWMCAnalysis
                        OLDMCAnalysis 
                        
                        clear nom
                        
                     end   
%-------------------------------------------------------------------------                        
%-------------------------------------------------------------------------
%-------------------------------------------------------------------------                                                
                        
                                      
                end
            end
        end
    end
end

                    