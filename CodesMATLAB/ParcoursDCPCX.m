%% -----------------------------------------------------------------------
%ParcoursDCPCX
%-------------------------------------------------------------------------

filename='/Users/karimbenchenane/Documents/Data/DataEnCours/Lisa/NewPaper/DataNewPaper/DataPharmaco/DPCPX';


%% -----------------------------------------------------------------------
%Effet DCPCX Ctrl --------------------------------------------------------
%-------------------------------------------------------------------------

eval(['cd(''',filename,''')'])
cd Ctrl



listdir=dir;

for i=1:length(listdir)

        eval(['cd(''',filename,''')'])
        cd Ctrl
        
        if listdir(i).isdir==1&listdir(i).name(1)~='.'

            
                    try                       
                    eval(['cd(''',listdir(i).name,'/DataSpont'')'])               
                    cd post
                    filepath=pwd;
                    !rm DataMCLFP.mat
                    TransformDataStep1('Neuron') 
                    close all
                    
                    protocol{1,1}='Mitral';
                    load Data nbtraces nom
                    if nbtraces>1
                    protocol{1,2}='LFP';
                    else
                    protocol{1,2}='noLFP';
                    end
                    
                    protocol{1,3}='Ctrl';
                    protocol{1,4}='DCPCX';
                    protocol{1,5}='Spont';                    
                    protocol{1,6}='post';                    
                    
                    save Protocol protocol nom filepath
                    end
                    
                    try
                    eval(['cd(''',filename,''')'])
                    cd Ctrl
                    eval(['cd(''',listdir(i).name,'/DataSpont'')'])
                    cd pre
                    filepath=pwd;
                    !rm DataMCLFP.mat
                    TransformDataStep1('Neuron') 
                    close all
                    
                    protocol{1,1}='Mitral';
                    load Data nbtraces nom
                    if nbtraces>1
                    protocol{1,2}='LFP';
                    else
                    protocol{1,2}='noLFP';
                    end
                    protocol{1,3}='Ctrl';
                    protocol{1,4}='DCPCX';
                    protocol{1,5}='Spont';                    
                    protocol{1,6}='pre';                    
                    
                    save Protocol protocol nom filepath
                    end
                    
                    
                    try
                    eval(['cd(''',filename,''')'])
                    cd Ctrl                    
                    eval(['cd(''',listdir(i).name,'/DataSpont'')'])
                    cd transition
                    filepath=pwd;
                    !rm DataMCLFP.mat
                    TransformDataStep1('Neuron') 
                    close all
                    
                    protocol{1,1}='Mitral';
                    load Data nbtraces nom
                    if nbtraces>1
                    protocol{1,2}='LFP';
                    else
                    protocol{1,2}='noLFP';
                    end
                    protocol{1,3}='Ctrl';
                    protocol{1,4}='DCPCX';
                    protocol{1,5}='Spont';                    
                    protocol{1,6}='transition';                    
                    
                    save Protocol protocol nom filepath                    
                    end
                    
                    

        end
end
        
 
%% -----------------------------------------------------------------------
%Effet DCPCX doKO --------------------------------------------------------
%-------------------------------------------------------------------------
 

eval(['cd(''',filename,''')'])
cd doKO
        
 
listdir=dir;

for i=1:length(listdir)

        eval(['cd(''',filename,''')'])
        cd doKO
        
        if listdir(i).isdir==1&listdir(i).name(1)~='.'

                     try
                    eval(['cd(''',filename,''')'])
                    cd doKO                        
                    eval(['cd(''',listdir(i).name,'/DataSpont'')'])
                    cd post
                    filepath=pwd;
                    !rm DataMCLFP.mat
                    TransformDataStep1('Neuron') 
                    close all
                    
                    protocol{1,1}='Mitral';
                    load Data nbtraces nom
                    if nbtraces>1
                    protocol{1,2}='LFP';
                    else
                    protocol{1,2}='noLFP';
                    end
                    protocol{1,3}='doKO';
                    protocol{1,4}='DCPCX';
                    protocol{1,5}='Spont';                    
                    protocol{1,6}='post';                   
                    
                    save Protocol protocol nom filepath
                     end
                    

                    eval(['cd(''',filename,''')'])
                    cd doKO                  
                    eval(['cd(''',listdir(i).name,'/DataSpont'')'])
                    cd pre
                    filepath=pwd;
                    try
                        !rm DataMCLFP.mat
                    TransformDataStep1('Neuron') 
                    close all
                    
                    protocol{1,1}='Mitral';
                    load Data nbtraces nom
                    if nbtraces>1
                    protocol{1,2}='LFP';
                    else
                    protocol{1,2}='noLFP';
                    end
                    protocol{1,3}='doKO';
                    protocol{1,4}='DCPCX';
                    protocol{1,5}='Spont';                    
                    protocol{1,6}='pre';                       
                    
                    save Protocol protocol nom filepath
                    end
                    

                    eval(['cd(''',filename,''')'])
                    cd doKO                   
                    eval(['cd(''',listdir(i).name,'/DataSpont'')'])
                    cd transition
                    filepath=pwd;
                    
                    try
                    !rm DataMCLFP.mat
                    TransformDataStep1('Neuron')
                    close all
                    
                    protocol{1,1}='Mitral';
                    load Data nbtraces nom
                    if nbtraces>1
                    protocol{1,2}='LFP';
                    else
                    protocol{1,2}='noLFP';
                    end
                    protocol{1,3}='doKO';
                    protocol{1,4}='DCPCX';
                    protocol{1,5}='Spont';                    
                    protocol{1,6}='transition';                     
                    
                    save Protocol protocol nom filepath                    
                    end
                    
%                     end



        end
end
        
 



%% -----------------------------------------------------------------------
%Bilan Effets ------------------------------------------------------------
%-------------------------------------------------------------------------



 
 
 
 
 
 
 
 
 
 
 
 %% -----------------------------------------------------------------------
        
