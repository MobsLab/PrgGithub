%figure;
Mice = fieldnames(DATAtableCleared);
maxTSLS = 0;
for i = 1:length(Mice)
    maxTSLS = max(maxTSLS, max(DATAtable.(Mice{i}).TimeSinceLastShock));
end 

%clear MedianTSLSMouse
MedianTSLSMouse = zeros(MiceNumber, ceil(maxTSLS));
for i = 1:length(Mice)
    
    shock = diff(DATAtable.(Mice{i}).EyelidNumber);
    indx = find(shock)+1;
    arrayTSLSMouse = zeros(length(indx)-1, max(diff(indx)));
    arrayOBFreqMouse = zeros(length(indx)-1, max(diff(indx)));
    resMouse = zeros(length(indx)-1, ceil(max(DATAtable.(Mice{i}).TimeSinceLastShock)));
    for j = 1:length(indx)-1
        arrayTSLSMouse(j,1:indx(j+1)-indx(j)) = DATAtable.(Mice{i}).TimeSinceLastShock(indx(j):indx(j+1)-1);
        arrayOBFreqMouse(j,1:indx(j+1)-indx(j)) = DATAtable.(Mice{i}).OB_Frequency(indx(j):indx(j+1)-1);
        resMouse(j, ceil(arrayTSLSMouse(j,1:indx(j+1)-indx(j)))) = arrayOBFreqMouse(j,1:indx(j+1)-indx(j));
    end
    resMouse(resMouse==0) = NaN;
    MedianTSLSMouse(i,1:size(resMouse,2)) = nanmedian(resMouse, 1);
    %MedianTSLSMouse(i:i+size(resMouse,1)-1,1:size(resMouse,2)) = resMouse;
    
    %plot(nanmedian(resMouse, 1)), hold on 
end


NumberOfMicePerEpisode = sum(isnan(MedianTSLSMouse), 1);
Conf_Inter = nanstd(MedianTSLSMouse) ./ sqrt(NumberOfMicePerEpisode);
Mean_All_Sp = nanmedian(MedianTSLSMouse);
figure
h=shadedErrorBar(1:300, runmean(Mean_All_Sp(1:300),4), runmean(Conf_Inter(1:300),4),'-k',1);%, hold on
% color= [0.3, 0.745, 0.93]; h.mainLine.Color=color; h.patch.FaceColor=color; h.edge(1).Color=color; h.edge(2).Color=color;

%shadedErrorBar(1:ceil(maxTSLS), Mean_All_Sp, Conf_Inter,'-k',1), hold on 
%plot([30 30], [-0.1 0.9], 'r--')
title('Decrease of Breathing after a shock')
xlim([0 300])
%text(34, 0.05, {'Chosen'; 'Charectristic Time'})
ylabel('Breathing (Hz)')
xlabel('Time Since Last Shock (seconds)')
%plot(2.2*exp(-[0:300] / 30) + 3.6)



figure;
Xlogspace = logspace(-3, -1, 50);
for i = 1:49:50
    for j = 0:40:40
        plot(1:5760, sigm(Xlogspace(i), 5760*(0.1+0.02*j),1:5760)), hold on 
    end 
end 

figure;
Xlogspace = logspace(-4, -2, 50);
for i = 1:49:50
    for j = 0:40:40
        plot(1:5760, sigm(Xlogspace(i), 5760*(0.1+0.02*j),1:5760)), hold on 
    end 
end 


