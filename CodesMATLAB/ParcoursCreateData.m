%% -----------------------------------------------------------------------
%ParcoursCreateData
%-------------------------------------------------------------------------

filename=pwd;


%% -----------------------------------------------------------------------
%Effet DataFiles --------------------------------------------------------
%-------------------------------------------------------------------------


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

listdir=dir;

for i=1:length(listdir)

        
        
        if listdir(i).isdir==1&listdir(i).name(1)~='.'

            
                    try                       
        
                    eval(['cd(''',filename,''')'])

                    eval(['cd(''',listdir(i).name,''')'])
%                     try
%                         !rm DataMCLFP.mat
%                     end
                    
                    TransformDataStep1('Neuron') 
                    close all
                    filepath=pwd;
                    
                    
                    protocol{1,1}='Mitral'; % a modifier a la main
                    load Data nbtraces nom
                    if nbtraces>1
                    protocol{1,2}='LFP';
                    else
                    protocol{1,2}='noLFP';
                    end
                    
                    protocol{1,3}='Ctrl'; % a modifier a la main
                    protocol{1,4}='no'; % a modifier a la main (traitement pharmaco)
                    
                    %if listdir(i).name(5)=='S'                     
                    protocol{1,5}='Spont';   % a modifier a la main                 
                    %else                        
                    %protocol{1,5}='60mV';                    
                    %end
                    
                    
                    protocol{1,6}='no';
                    
                    load DataMCLFP cont
                    protocol{1,7}='cont';
                    
                    
                    save Protocol protocol nom filepath
                    end
                    
                    
                    

        end
end





%% -----------------------------------------------------------------------
%Bilan Effets ------------------------------------------------------------
%-------------------------------------------------------------------------



 
 
 
 
 
 
 
 
 
 
 
 %% -----------------------------------------------------------------------
        
