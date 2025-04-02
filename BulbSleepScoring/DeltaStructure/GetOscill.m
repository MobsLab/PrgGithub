%% Get Ripples and Spindles
struc={'B','H','Pi','PF','Pa','PFSpi'};

filename2{1}='/media/DataMOBs/ProjetLPS/Mouse051/20130222/BULB-Mouse-51-22022013/';
todo(1,:)=[1,1,0,1,1];
dataexis(1,:)=[1,1,0,1,1];
chan(1,:)=[4,18,0,20,23];
filename2{2}='/media/DataMOBsRAID5/ProjetAstro/ProjetDPCPX/Mouse060/20130415/BULB-Mouse-60-15042013/';
todo(2,:)=[1,1,0,1,1,1];
dataexis(2,:)=[1,1,0,1,1,1];
chan(2,:)=[1,10,0,4,13,6];
filename2{3}='/media/DataMOBsRAID5/ProjetAstro/ProjetDPCPX/Mouse082/20130730/BULB-Mouse-82-30072013/';
todo(3,:)=[1,0,0,1,1,1];
dataexis(3,:)=[1,1,0,1,1,1];
chan(3,:)=[2,9,0,10,7,8];
filename2{4}='/media/DataMOBsRAID5/ProjetAstro/ProjetCannabinoids/Mouse083/20130802/BULB-Mouse-83-02082013/';
todo(4,:)=[1,1,0,1,1,1];
dataexis(4,:)=[1,1,0,1,1,1];
chan(4,:)=[6,10,0,5,13,5];
filename2{5}='/media/DataMobs15/OB_behaviour/ProjetLPS/Mouse123/LPS_D1/LPSD1-Mouse-123-31032014/';
todo(5,:)=[1,1,1,1,1,1];
dataexis(5,:)=[1,1,1,1,1,1];
chan(5,:)=[15,6,0,4,9,12];
filename2{6}='/media/DataMobs15/OB_behaviour/ProjetLPS/Mouse124/LPSD1/LPSD1-Mouse-124-31032014/';
todo(6,:)=[1,0,1,1,1,1];
dataexis(6,:)=[1,1,1,1,1,1];
chan(6,:)=[11,2,12,8,4,15];

for file=2:6
        cd(filename2{file})
    load('StateEpochSB.mat','NoiseEpoch','GndNoiseEpoch')
    try
        load('LFPData/LFP0.mat')
    catch
        try
            load('LFPData/LFP1.mat')
        catch
            load('LFPData/LFP2.mat')
        end
    end
    rg=Range(LFP);
    TotalEpoch=intervalSet(0,rg(end))-NoiseEpoch-GndNoiseEpoch;
    TotalEpoch=CleanUpEpoch(TotalEpoch);

    %%Ripples
        %% Ripples
            %             load(strcat('LFPData/LFP',num2str(Ripch(m)),'.mat'));
            %             [Rip,usedEpoch]=FindRipplesKarimSB(LFP,SWSEpoch);
            %             Ripples{1}=tsd(Rip(:,2)*1E4,Rip(:,2)*1E4);
            %             Ripples{2}=usedEpoch;
            %             Filsp=FilterLFP(LFP,[120 200],1024);
            %             HilRip=hilbert(Data(Filsp));
            %             HRip=tsd(Range(Filsp),abs(HilRip));
    
    
end