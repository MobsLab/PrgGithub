%% -----------------------------------------------------------------------
%ParcoursDbField
%-------------------------------------------------------------------------

filename=pwd;


%% -----------------------------------------------------------------------
%Effet DataFiles --------------------------------------------------------
%-------------------------------------------------------------------------




listdir=dir;

for i=1:length(listdir)

        
        
        if listdir(i).isdir==1&listdir(i).name(1)~='.'

            
%                     try                       
        
                    eval(['cd(''',filename,''')'])

                    eval(['cd(''',listdir(i).name,''')'])
%                     try
%                         !rm DataMCLFP.mat
%                     end
                    

                    listsousdir=dir;
                    
                        for j=1:length(listsousdir)

                            if listsousdir(j).isdir==1&listsousdir(j).name(1)~='.'

%                                 try
                                    eval(['cd(''',filename,''')'])

                                    eval(['cd(''',listdir(i).name,''')'])
                                    eval(['cd(''',listsousdir(j).name,''')'])
                                    
                                    try
                                        load DataMCLFP
                                        Y;
                                        F;
                                    catch
                                    TransformDataStep1('L') 
                                    load DataMCLFP
                                    end
                                    
                                    try
                                        clear C
                                        load Coherency C
                                        C;
                                    catch
                                        CoherencyMitralField(1);
                                    end
                                    
                                    
                                    
                                    try 
                                        clear CPH
                                        load DataCrossCorrPartFreq CPH
                                        CPH;
                                    catch
                                        plott=1;
                                        CrossCorrParticularFrequency
                                    end
                                    

%                                     end


                                    close all




                                end
                        end
                    
                    
                    

                    
                    
                
%                     end
                    
                    
                    

        end
end





%% -----------------------------------------------------------------------
%Bilan Effets ------------------------------------------------------------
%-------------------------------------------------------------------------



 
 
 
 
 
 
 
 
 
 
 
 %% -----------------------------------------------------------------------
        
