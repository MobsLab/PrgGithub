a=0;
a=a+1; Dir.path{a}='/media/DataMOBs/ProjetLPS/Mouse051/20130220/BULB-Mouse-51-20022013';
a=a+1; Dir.path{a}='/media/DataMOBs/ProjetLPS/Mouse051/20130221/BULB-Mouse-51-21022013';
% a=a+1; Dir.path{a}='/media/DataMOBs/ProjetLPS/Mouse051/20130222/BULB-Mouse-51-22022013';
% a=a+1; Dir.path{a}='/media/DataMOBs/ProjetLPS/Mouse051/20130223/BULB-Mouse-51-23022013';
channelstotry=[17,18,19,24,26,33,28,20,21,29,31];

for i=1:a
    i
    try
        cd(num2str(Dir.path{i}));
        load 'StateEpoch.mat'
        load 'SpectrumREM_bulb_high.mat'
        sptsdB=tsd(t*1e4,Sp);
        fB=f;
        load 'SureSWS.mat'
        for n=1:length(channelstotry)
            n
            try
                load(strcat('LFPData/LFP',num2str(channelstotry(n)),'.mat'))
                [REMEpoch2,tot_td,tot_ghi]=Find_REM_Epoch_v2(sptsdB,LFP,SureSWS,GndNoiseEpoch,NoiseEpoch,fB)
                save(strcat('LocalRem_',num2str(channelstotry(n)),'.mat'),'REMEpoch2','tot_td','tot_ghi')
                clear event1
                beginning=start(REMEpoch);
                ending=stop(REMEpoch);
                
                for i=1:length(start(REMEpoch2))
                    event1.time(2*i-1)=beginning(i)/1e4;
                    event1.time(i*2)=ending(i)/1e4;
                    event1.description{2*i-1}='start';
                    event1.description{i*2}='stop';
                end
                SaveEvents(strcat('LocalREM.evt.r', num2str(channelstotry(n))),event1)
            catch 
                n
            end
        end
    end
    
end


 a=0;
      a=a+1; Dir.path{a}='/media/DataMOBs/ProjetDPCPX/Mouse047/20121108/BULB-Mouse-47-08112012';
%     a=a+1; Dir.path{a}='/media/DataMOBs/ProjetDPCPX/Mouse047/20121112/BULB-Mouse-47-12112012';
%         a=a+1; Dir.path{a}='/media/DataMOBsRAID5/ProjetAstro/ProjetCannabinoids/Mouse047/20130111/BULB-Mouse-47-11012013';
channelstotry=[13,15,3,9,7,11,12,4,2,1];


for i=1:a
    i
    try
        cd(num2str(Dir.path{i}));
        load 'StateEpoch.mat'
        load 'SpectrumREM_bulb_high.mat'
        sptsdB=tsd(t*1e4,Sp);
        fB=f;
        load 'SureSWS.mat'
        for n=1:length(channelstotry)
            n
            try
                load(strcat('LFPData/LFP',num2str(channelstotry(n)),'.mat'))
                [REMEpoch2,tot_td,tot_ghi]=Find_REM_Epoch_v2(sptsdB,LFP,SureSWS,GndNoiseEpoch,NoiseEpoch,fB)
                save(strcat('LocalRem_',num2str(channelstotry(n)),'.mat'),'REMEpoch2','tot_td','tot_ghi')
                clear event1
                beginning=start(REMEpoch2);
                ending=stop(REMEpoch2);
                
                for i=1:length(start(REMEpoch2))
                    event1.time(2*i-1)=beginning(i)/1e4;
                    event1.time(i*2)=ending(i)/1e4;
                    event1.description{2*i-1}='start';
                    event1.description{i*2}='stop';
                end
                SaveEvents(strcat('LocalREM.evt.r', num2str(channelstotry(n))),event1)
            catch 
                n
            end
        end
    end
    
end


 a=0;
       a=a+1; Dir.path{a}='/media/DataMOBsRAID5/ProjetAstro/ProjetDPCPX/Mouse060/20130422/BULB-Mouse-60-22042013';
%     a=a+1; Dir.path{a}='/media/DataMOBsRAID5/ProjetAstro/ProjetDPCPX/Mouse060/20130422/BULB-Mouse-60-22042013';
    a=a+1; Dir.path{a}='/media/DataMOBsRAID5/ProjetAstro/ProjetDPCPX/Mouse060/20130415/BULB-Mouse-60-15042013';
    a=a+1; Dir.path{a}='/media/DataMOBsRAID5/ProjetAstro/ProjetCannabinoids/Mouse060/20130430/BULB-Mouse-60-30042013';
%     a=a+1; Dir.path{a}='/media/DataMOBsRAID5/ProjetAstro/ProjetCannabinoids/Mouse060/20130430/BULB-Mouse-60-30042013';
%     a=a+1; Dir.path{a}='/media/DataMOBsRAID5/ProjetAstro/DataPlethysmo/Mouse060/20130503';
    channelstotry=[8,12,11,2,4,6];


for i=1:a
    i
    try
        cd(num2str(Dir.path{i}));
        load 'StateEpoch.mat'
        load 'SpectrumREM_bulb_high.mat'
        sptsdB=tsd(t*1e4,Sp);
        fB=f;
        load 'SureSWS.mat'
        for n=1:length(channelstotry)
            n
            try
                load(strcat('LFPData/LFP',num2str(channelstotry(n)),'.mat'))
                [REMEpoch2,tot_td,tot_ghi]=Find_REM_Epoch_v2(sptsdB,LFP,SureSWS,GndNoiseEpoch,NoiseEpoch,fB)
                save(strcat('LocalRem_',num2str(channelstotry(n)),'.mat'),'REMEpoch2','tot_td','tot_ghi')
                clear event1
                beginning=start(REMEpoch2);
                ending=stop(REMEpoch2);
                
                for i=1:length(start(REMEpoch2))
                    event1.time(2*i-1)=beginning(i)/1e4;
                    event1.time(i*2)=ending(i)/1e4;
                    event1.description{2*i-1}='start';
                    event1.description{i*2}='stop';
                end
                SaveEvents(strcat('LocalREM.evt.r', num2str(channelstotry(n))),event1)
            catch 
                n
            end
        end
    end
    
end


     a=0;
          a=a+1; Dir.path{a}='/media/DataMOBsRAID5/ProjetAstro/ProjetDPCPX/Mouse061/20130422/BULB-Mouse-61-22042013';
%     a=a+1; Dir.path{a}='/media/DataMOBsRAID5/ProjetAstro/ProjetDPCPX/Mouse061/20130422/BULB-Mouse-61-22042013';
    a=a+1; Dir.path{a}='/media/DataMOBsRAID5/ProjetAstro/ProjetDPCPX/Mouse061/20130415/BULB-Mouse-61-15042013';
    a=a+1; Dir.path{a}='/media/DataMOBsRAID5/ProjetAstro/ProjetCannabinoids/Mouse061/20130430/BULB-Mouse-61-30042013';
%     a=a+1; Dir.path{a}='/media/DataMOBsRAID5/ProjetAstro/ProjetCannabinoids/Mouse061/20130430/BULB-Mouse-61-30042013';
%     a=a+1; Dir.path{a}='/media/DataMOBsRAID5/ProjetAstro/DataPlethysmo/Mouse061/20130503';
   
for i=1:a
    i
    try
        cd(num2str(Dir.path{i}));
        load 'StateEpoch.mat'
        load 'SpectrumREM_bulb_high.mat'
        sptsdB=tsd(t*1e4,Sp);
        fB=f;
        load 'SureSWS.mat'
        for n=1:length(channelstotry)
            n
            try
                load(strcat('LFPData/LFP',num2str(channelstotry(n)),'.mat'))
                [REMEpoch2,tot_td,tot_ghi]=Find_REM_Epoch_v2(sptsdB,LFP,SureSWS,GndNoiseEpoch,NoiseEpoch,fB)
                save(strcat('LocalRem_',num2str(channelstotry(n)),'.mat'),'REMEpoch2','tot_td','tot_ghi')
                clear event1
                beginning=start(REMEpoch2);
                ending=stop(REMEpoch2);
                
                for i=1:length(start(REMEpoch2))
                    event1.time(2*i-1)=beginning(i)/1e4;
                    event1.time(i*2)=ending(i)/1e4;
                    event1.description{2*i-1}='start';
                    event1.description{i*2}='stop';
                end
                SaveEvents(strcat('LocalREM.evt.r', num2str(channelstotry(n))),event1)
            catch 
                n
            end
        end
    end
    
end
