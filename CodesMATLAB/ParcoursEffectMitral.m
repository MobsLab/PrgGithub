%% -----------------------------------------------------------------------
%ParcoursEffectMitral
%-------------------------------------------------------------------------

filename='/Users/karimbenchenane/Documents/Data/DataEnCours/Lisa/NewPaper/DataNewPaper/DataMitralKO';


%% -----------------------------------------------------------------------
%Effet Ctrl --------------------------------------------------------
%-------------------------------------------------------------------------

eval(['cd(''',filename,''')'])
%cd CtrlSpont
cd Ctrl60mV

listdir=dir;

for i=1:length(listdir)

        eval(['cd(''',filename,''')'])
        %cd CtrlSpont
        cd Ctrl60mV
        
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

        eval(['cd(''',filename,''')'])
        %cd CtrlSpont
        cd Ctrl60mV
        
        
        if listdir(i).isdir==1&listdir(i).name(1)~='.'

            
                    try                       
        
                    eval(['cd(''',filename,''')'])
                    %cd CtrlSpont 
                    cd Ctrl60mV
                    eval(['cd(''',listdir(i).name,''')'])
                    
                    TransformDataStep1('Neuron') 
                    close all
                    filepath=pwd;
                    
                    
                    protocol{1,1}='Mitral';
                    load Data nbtraces nom
                    if nbtraces>1
                    protocol{1,2}='LFP';
                    else
                    protocol{1,2}='noLFP';
                    end
                    
                    protocol{1,3}='Ctrl';
                    protocol{1,4}='no';
%                     protocol{1,5}='Spont';
                    protocol{1,5}='60mV';                    
                    protocol{1,6}='no';                    
                    protocol{1,7}='cont';
                                        
                    save Protocol protocol nom filepath
                    end
                    
                    
                    

        end
end
        
 
%% -----------------------------------------------------------------------
%Effet doKO --------------------------------------------------------
%-------------------------------------------------------------------------
 

eval(['cd(''',filename,''')'])
%cd doKOSpont
cd doKO60mV

listdir=dir;

for i=1:length(listdir)

        eval(['cd(''',filename,''')'])
%        cd doKOSpont
        cd doKO60mV
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

        eval(['cd(''',filename,''')'])
        %cd doKOSpont
        cd doKO60mV
        
        
        if listdir(i).isdir==1&listdir(i).name(1)~='.'

            
                    try                       
        
                    eval(['cd(''',filename,''')'])
                    %cd doKOSpont 
                    cd doKO60mV
                    eval(['cd(''',listdir(i).name,''')'])
                    
                    TransformDataStep1('Neuron') 
                    close all
                    filepath=pwd;
                    
                    
                    protocol{1,1}='Mitral';
                    load Data nbtraces nom
                    if nbtraces>1
                    protocol{1,2}='LFP';
                    else
                    protocol{1,2}='noLFP';
                    end
                    
                    protocol{1,3}='doKO';
                    protocol{1,4}='no';
%                     protocol{1,5}='Spont';                    
                    protocol{1,5}='60mV';                                        
                    protocol{1,6}='no';                    
                    protocol{1,7}='cont';                    
                    
                    save Protocol protocol nom filepath
                    end
                    
                    
                    

        end
end
        
 



%% -----------------------------------------------------------------------
%Bilan Effets ------------------------------------------------------------
%-------------------------------------------------------------------------



 
 
 
 
 
 
 
 
 
 
 
 %% -----------------------------------------------------------------------
        
