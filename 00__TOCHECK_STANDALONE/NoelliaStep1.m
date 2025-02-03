   %NoelliaStep1
   
   
clear Cl 
clear Ch
clear Bl
clear Bh    
clear listOK

clear VEHEpoch
clear LPSEPoch
clear PreEpoch
clear H24Epoch
clear H48Epoch
clear NoiseEpoch
clear WeirdNoiseEpoch
clear GndNoiseEpoch

clear Epoch     
                                         
                                         
   clear PreEpoch 
   clear VEHEpoch 
   clear LPSEpoch 
   clear H24Epoch 
   clear H48Epoch
  % clear
   load behavResources PreEpoch VEHEpoch LPSEpoch H24Epoch H48Epoch 
                                        
                                        load StateEpoch NoiseEpoch WeirdNoiseEpoch GndNoiseEpoch SWSEpoch
                                        
                                        load Spindles SpiH SpiL 
%                                         size(SpiH{1,1})
%                                         size(SpiL{1,1})
                                        
                                        %load Ripples Rip
                                        load SpindlesRipples Rip
                                        disp('loaded')
                                        pwd

                                        
                                        clear Epoch                                 
%                                         pause(0)
                                                                       
%                                         pause(1)
                                        
                                        try 
                                            if length(Start(PreEpoch))>0
                                                    Epoch{1}=PreEpoch;
                                                    
                                            end
                                        end
                                        try
                                            Epoch{2}=VEHEpoch;
                                            disp('veh')
                                            listOK=[1,2];
                                        end
                                        try
                                            Epoch{3}=LPSEpoch;
                                            disp('LPS')
                                            listOK=[1,3];
                                        end
                                        try
                                            Epoch{4}=H24Epoch;
                                            disp('LPS Day 1')
                                            listOK=[4];
                                        end
                                        try
                                            Epoch{5}=H48Epoch;
                                              disp('LPS Day 2')
                                              listOK=[5];
                                        end
                                        
%                                         pause(1)
                                        
%--------------------------------------------------------------------------                                       
                                        try
                                            Epoch
                                        catch
                                           keyboard
                                        end
%--------------------------------------------------------------------------                                                                               
                                        