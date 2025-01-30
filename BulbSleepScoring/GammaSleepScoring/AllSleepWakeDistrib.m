%% Cacluate desired Spectra
struc={'B','H','Pi','PF','Pa','PFSup','PaSup','Amyg'};
clear todo chan dataexis
m=1;
filename2{m}='/media/DataMOBsRAID5/ProjetAstro/ProjetDPCPX/Mouse060/20130415/BULB-Mouse-60-15042013/';
todo(m,:)=[1,1,0,1,1,1,1,0];
dataexis(m,:)=[1,1,0,1,1,1,1,0];
chan(m,:)=[1,10,NaN,4,13,6,2,NaN];

m=2;
filename2{m}='/media/DataMOBsRAID5/ProjetAstro/ProjetDPCPX/Mouse082/20130730/BULB-Mouse-82-30072013/';
todo(m,:)=[1,1,0,1,1,1,1,0];
dataexis(m,:)=[1,1,0,1,1,1,1,0];
chan(m,:)=[2,9,NaN,10,7,8,3,NaN];

m=3;
filename2{m}='/media/DataMOBsRAID5/ProjetAstro/ProjetCannabinoids/Mouse083/20130802/BULB-Mouse-83-02082013/';
todo(m,:)=[1,1,0,1,1,1,1,0];
dataexis(m,:)=[1,1,0,1,1,1,1,0];
chan(m,:)=[6,10,NaN,5,13,1,7,NaN];

m=4;
filename2{m}='/media/DataMobs15/OB_behaviour/ProjetLPS/Mouse123/LPS_D1/LPSD1-Mouse-123-31032014/';
todo(m,:)=[1,1,1,1,1,1,1,1];
dataexis(m,:)=[1,1,1,1,1,1,1,1];
chan(m,:)=[15,6,0,4,9,12,NaN,3];

m=5;
filename2{m}='/media/DataMobs15/OB_behaviour/ProjetLPS/Mouse124/LPSD1/LPSD1-Mouse-124-31032014/';
todo(m,:)=[1,1,1,1,0,1,1,1];
dataexis(m,:)=[1,1,1,1,1,0,0,1];
chan(m,:)=[11,2,12,8,4,15,NaN,15];


for file=2:5
    file
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
    if file==[2,5,6]
        TotalEpoch=intervalSet(0,rg(end)/3)-NoiseEpoch-GndNoiseEpoch;
    else
        TotalEpoch=intervalSet(0,rg(end))-NoiseEpoch-GndNoiseEpoch;
    end
    load('StateEpoch.mat')
    try
        load('behavResources.mat','PreEpoch');
        TotalEpoch=And(TotalEpoch,PreEpoch);
    end
    
    for s=[1,2,3,4,5,8]
        disp(struc(s))
        if todo(file,s)==1
                load(cell2mat(strcat(struc(s),'_High_Spectrum.mat')))
                f=Spectro{3};
                sptsd=tsd(Spectro{2}*1e4,Spectro{1});
                sptsd=Restrict(sptsd,TotalEpoch);
                startg=find(f<50,1,'last');
                stopg=find(f>70,1,'first');
                spdat=Data(sptsd);
                tot_ghi=tsd(Range(Restrict(sptsd,TotalEpoch)),sum(spdat(:,startg:stopg)')');
                smooth_ghi=tsd(Range(tot_ghi),smooth(Data(tot_ghi),500));
                [X,Y]=hist(log(Data(Restrict(smooth_ghi,And(MovEpoch,TotalEpoch)))),500);
                specW{file,min(s,6)}(1,:)=X;
                specW{file,min(s,6)}(2,:)=Y;
                [X,Y]=hist(log(Data(Restrict(smooth_ghi,And(ImmobEpoch,TotalEpoch)))),500);
                specS{file,min(s,6)}(1,:)=X;
                specS{file,min(s,6)}(2,:)=Y;
                [X,Y]=hist(log(Data(Restrict(smooth_ghi,TotalEpoch))),500);
                specT{file,min(s,6)}(1,:)=X;
                specT{file,min(s,6)}(2,:)=Y;            
        end
    end
end