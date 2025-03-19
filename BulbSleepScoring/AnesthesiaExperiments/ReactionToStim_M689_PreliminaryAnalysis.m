FileNames = {'/media/DataMOBsRAIDN/ProjetSlSc/IsofluoraneExp/Isoflurane_M689/Isoflurane_0,5_Stims',
    '/media/DataMOBsRAIDN/ProjetSlSc/IsofluoraneExp/Isoflurane_M689/Isoflurane_0,8_Stims',
    '/media/DataMOBsRAIDN/ProjetSlSc/IsofluoraneExp/Isoflurane_M689/Isoflurane_1,0_Stims/Stims_1',
    '/media/DataMOBsRAIDN/ProjetSlSc/IsofluoraneExp/Isoflurane_M689/Isoflurane_1,0_Stims/Stims_2',
    '/media/DataMOBsRAIDN/ProjetSlSc/IsofluoraneExp/Isoflurane_M689/Isoflurane_1,0_Stims/Stims_3',
    '/media/DataMOBsRAIDN/ProjetSlSc/IsofluoraneExp/Isoflurane_M689/Isoflurane_1,5_Stims'};

ResponseSize = NaN(6,6);
Voltage= NaN(6,6);
for an = 1:length(FileNames)
    cd(FileNames{an})
    
    
    load('LFPData/DigInfo1.mat')
    load('behavResources.mat')
    StimStart = thresholdIntervals(DigTSD,0.9,'Direction','Above');
    StimStart = Start(StimStart);
    
    StimLevels = unique(Stim(:,2));
    
    for k = 1:length(StimLevels)
        M = PlotRipRaw(MovAcctsd,StimStart(Stim(:,2)==StimLevels(k))/1e4,1000,0,0);
        %     plot(M(:,1),(M(:,2))), hold on
        ResponseSize(k,an)=max(M(:,2));
        Voltage(k,an) = StimLevels(k);
    end
end
plot(Voltage(:,1),ResponseSize(:,1),'-*b'), hold on
plot(Voltage(:,2),ResponseSize(:,2),'-*c')
plot(Voltage(:,3),ResponseSize(:,3),'-*g')
plot(Voltage(:,6),ResponseSize(:,6),'-*r')
plot(Voltage(:,4),ResponseSize(:,4),'-*g')
plot(Voltage(:,5),ResponseSize(:,5),'-*g')
legend('0.5','0.8','1','1.5')
xlabel('Stim voltage')
ylabel('React size')
title('accelero data')

%%
FileNames = {'/media/DataMOBsRAIDN/ProjetSlSc/IsofluoraneExp/Isoflurane_M689/Isoflurane_0,5_Stims',
    '/media/DataMOBsRAIDN/ProjetSlSc/IsofluoraneExp/Isoflurane_M689/Isoflurane_0,8_Stims',
    '/media/DataMOBsRAIDN/ProjetSlSc/IsofluoraneExp/Isoflurane_M689/Isoflurane_1,0_Stims/Stims_1',
    '/media/DataMOBsRAIDN/ProjetSlSc/IsofluoraneExp/Isoflurane_M689/Isoflurane_1,0_Stims/Stims_2',
    '/media/DataMOBsRAIDN/ProjetSlSc/IsofluoraneExp/Isoflurane_M689/Isoflurane_1,0_Stims/Stims_3',
    '/media/DataMOBsRAIDN/ProjetSlSc/IsofluoraneExp/Isoflurane_M689/Isoflurane_1,5_Stims'};

ResponseSize = NaN(6,6);
Voltage= NaN(6,6);
for an = 1:length(FileNames)
    cd(FileNames{an})
    
    
    load('LFPData/DigInfo1.mat')
    load('behavResources.mat')
    StimStart = thresoldIntervals(DigTSD,0.9,'Direction','Above');
    StimStart = Start(StimStart);
    Piezotsd = tsd(time*1e4,ActiData);
    StimLevels = unique(Stim(:,2));
    
    for k = 1:length(StimLevels)
        M = PlotRipRaw(Piezotsd,StimStart(Stim(:,2)==StimLevels(k))/1e4,1000,0,0);
        %     plot(M(:,1),(M(:,2))), hold on
        ResponseSize(k,an)=max(M(:,2));
        Voltage(k,an) = StimLevels(k);
    end
end
figure
plot(Voltage(:,1),ResponseSize(:,1),'-*b'), hold on
plot(Voltage(:,2),ResponseSize(:,2),'-*c')
plot(Voltage(:,3),ResponseSize(:,3),'-*g')
plot(Voltage(:,6),ResponseSize(:,6),'-*r')
plot(Voltage(:,4),ResponseSize(:,4),'-*g')
plot(Voltage(:,5),ResponseSize(:,5),'-*g')
legend('0.5','0.8','1','1.5')
xlabel('Stim voltage')
ylabel('React size')
title('piezo data')
