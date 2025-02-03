m=1;Filename{m}='/media/MOBSDataRotation/M253/CalibPAG/Session1_091015/DigDat/M253_PAGCalib_Droite_Sess1_151009_151350';
m=m+1;Filename{m}='/media/MOBSDataRotation/M253/CalibPAG/Session2_121015/DigDat/M253_PAGCalib_Droite_Sess4_151012_122135';
m=m+1;Filename{m}='/media/MOBSDataRotation/M253/CalibPAG/Session3_131015/DigDat/M253_PAGCalib_Droite_Sess5_151013_110324';
m=m+1;Filename{m}='/media/MOBSDataRotation/M253/CalibPAG/Session3_131015/DigDat/M253_PAGCalib_Droite_Sess5_151013_111514';
m=m+1;Filename{m}='/media/MOBSDataRotation/M253/CalibPAG/Session4_141015/DigDat/M253_PAGCalib_Droite_Sess7_151014_105532';
m=m+1;Filename{m}='/media/MOBSDataRotation/M254/CalibPAG/Session1_091015/DigDat/M254_PAGCalib_Droite_Sess3_151009_144856';
m=m+1;Filename{m}='/media/MOBSDataRotation/M254/CalibPAG/Session2_121015/DigDat/M254_PAGCalib_Droite_Sess4_151012_124726';
m=m+1;Filename{m}='/media/MOBSDataRotation/M254/CalibPAG/Session3_131015/DigDat/M254_PAGCalib_Droite_Sess5_151013_113200';
m=m+1;Filename{m}='/media/MOBSDataRotation/M254/CalibPAG/Session4_141015/DigDat/M254_PAGCalib_Droite_Sess7_151013_113200_151014_112213';
%Sess1CalibDroite missing
m=m+1;Filename{m}='/media/MOBSDataRotation/M253/CalibMFB/Session2_07102015/DigDat/M253_MFBCalib_Droite_Sess2_151007_175027';

m=m+1;Filename{m}='/media/MOBSDataRotation/M254/CalibMFB/Session1_07102015/DigDat/M254_MFBCalib_Droite_151007_121708';



for mm=1:m
    try
    mm
    cd(Filename{mm})
    clear DigOut DigIN DigDat
    SetCurrentSession('digitalin-wideband.xml')
    Data=GetWideBandData(0);
    
    DigIN=Data(:,2);
    for k=0:3
        a(k+1)=2^k;
    end
    DigIN=DigIN(1:10:end);
    DigOut=zeros(length(DigIN),4);
    num=1;
    for dd=1:length(DigIN)
        %dd/length(DigIN)
        temp=DigIN(dd);
        binres=zeros(1,4);
        while temp>0
            binres(1,find(a<=temp,1,'last'))=1;
            temp=temp-a(find(a<=temp,1,'last'));
        end
        DigOut(dd,:)=binres;
    end
%     figure
%     plot(Data(1:10:end,1),DigOut(:,1)), hold on
%     plot(Data(1:10:end,1),DigOut(:,2)+2),
%     plot(Data(1:10:end,1),DigOut(:,3)+3),
%     plot(Data(1:10:end,1),DigOut(:,4)+4),
    DigDat{1}=Data(1:10:end,1);
    DigDat{2}=DigOut;
    save('DigDat.mat','DigDat')
    end
end