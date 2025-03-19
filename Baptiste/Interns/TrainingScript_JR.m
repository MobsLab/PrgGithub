
%% 
% only sqline
Mouse=[1144,1146,1147,1170,1171,1174,9184,1189,9205,1251,1253,1254,688,739,777,779,849,893,1096,829,851,857,858,859,1005,1006,1184 1205 1224 1225 1226]; 


GetEmbReactMiceFolderList_BM
edit Drugs_Groups_UMaze_BM.m

Session_type={'TestPre'};

% generate data
for sess=1:length(Session_type) 
    [OutPutData.(Session_type{sess}) , Epoch1.(Session_type{sess}) , NameEpoch] = MeanValuesPhysiologicalParameters_BM(Mouse,lower(Session_type{sess}),'accelero','linearposition','heartrate','respi_freq_BM','speed','masktemperature', 'ob_gamma_freq');
end

for mouse=1:length(Mouse)
    Mouse_names{mouse}=['M' num2str(Mouse(mouse))];
    ZoneEpoch.(Mouse_names{mouse}) = ConcatenateDataFromFolders_SB(TestPreSess.(Mouse_names{mouse}),'epoch','epochname','zoneepoch');
end


%% Corner occupency and assymetry in the u-maze exploration in pre-test

for mouse=1:length(Mouse)
%        h=histogram(Data(TSD_DATA.(Session_type{sess}).respi_freq_bm.tsd{mouse,Side_ind(side)}) , 'BinLimits' , [1 8] , 'NumBins',91); % 91=nansum(and(1<Spectro{3},Spectro{3}<8))
    h=histogram(Data(OutPutData.TestPre.linearposition.tsd{mouse, 1}) , 100);
    Distrib_LinearPosition(mouse,:)=h.Values;
    Distrib_LinearPosition_Norm(mouse,:)=Distrib_LinearPosition(mouse,:)/sum(Distrib_LinearPosition(mouse,:));
end


for mouse=1:length(Mouse)
    CornerOccupancy(mouse)=sum(Distrib_LinearPosition(mouse,:)<10 | and(Distrib_LinearPosition(mouse,:)>31,Distrib_LinearPosition(mouse,:)<38) | and(Distrib_LinearPosition(mouse,:)>63,Distrib_LinearPosition(mouse,:)<70) | Distrib_LinearPosition(mouse,:)>90)/100;
end
AsymetryIndex = sum(Distrib_LinearPosition(:,1:50),2)./sum(Distrib_LinearPosition(:,1:100),2);

% Plot section
figure
Conf_Inter=nanstd(Distrib_LinearPosition_Norm)/sqrt(size(Distrib_LinearPosition_Norm,1));
shadedErrorBar([1:100],nanmean(Distrib_LinearPosition_Norm),Conf_Inter,'k',1); hold on;
makepretty
ylabel('proportion')
xlabel('linear position')
xticks([0 100]); xticklabels({'0' , '1'})
hline(.01,'--r')
vline([10 31 38 63 70 90],'-r')
title('Occupancy linear postion, all mice, Test Pre')

figure
plot(CornerOccupancy)
ylabel('anxiety index')
hold on 
plot(sum(Distrib_LinearPosition(:,1:50),2)./sum(Distrib_LinearPosition(:,1:100),2),'g')

figure
PlotCorrelations_BM(AsymetryIndex , CornerOccupancy , 30, 0 , 'r')
axis square
xlabel('Assymetry index')
ylabel('Corner occupancy')


% en bleu taux d'anxiété (taux d'occupation des coins par les souris)
% en vert taux d'assymétrie (si sup a 0.5 la souris est plus souvent a
% droite et inversement)



%% HIGH SPEED CORRELATION WITH LOW CORNER OCCUPANCY


for mouse=1:length(Mouse)
%        h=histogram(Data(TSD_DATA.(Session_type{sess}).speed.tsd{mouse,Side_ind(side)}) , 'BinLimits' , [0 100] , 'NumBins',100); % 100=nansum(and(1<Spectro{3},Spectro{3}<8))
    h=histogram(Data(OutPutData.TestPre.speed.tsd{mouse, 1}) , 100);
    Distrib_speed(mouse,:)=h.Values;
    Distrib_speed_Norm(mouse,:)=Distrib_speed(mouse,:)/sum(Distrib_speed(mouse,:));
end

for mouse=1:length(Mouse)
    highactivity(mouse)=sum(Distrib_speed(mouse,:)>30)/100;
end

for mouse=1:length(Mouse)
    CornerOccupancy(mouse)=sum(Distrib_LinearPosition(mouse,:)<10 | and(Distrib_LinearPosition(mouse,:)>31,Distrib_LinearPosition(mouse,:)<38) | and(Distrib_LinearPosition(mouse,:)>63,Distrib_LinearPosition(mouse,:)<70) | Distrib_LinearPosition(mouse,:)>90)/100;
end
% correction
CornerOccupancy(CornerOccupancy==1)=NaN;


%Plot Section

figure
Conf_Inter=nanstd(Distrib_speed_Norm)/sqrt(size(Distrib_speed_Norm,1));
shadedErrorBar([1:100],nanmean(Distrib_speed_Norm),Conf_Inter,'k',1); hold on;
makepretty
ylabel('proportion')
xlabel('speed')
axis([0 70 0 0.2])
title('Speed proportion, all mice, test pre')


figure
PlotCorrelations_BM(highactivity , CornerOccupancy , 30, 0 , 'r')
axis square
xlabel('High activity index')
ylabel('Corner occupancy')
title('Correlation high activity/corner occupancy')
% Correlation btw high speed ratio (threshold at 30) and corner occupancy
% (calculated with liner position distribution)




%% CORRELATION SPEED/RESPI FREQ

for mouse=1:length(Mouse)
    h=histogram(Data(OutPutData.TestPre.respi_freq_BM.tsd{mouse, 1}) , 100);
    Distrib_respi(mouse,:)=h.Values;
    Distrib_respi_Norm(mouse,:)=Distrib_respi(mouse,:)/sum(Distrib_respi(mouse,:));
    testnormality_respi(mouse)=chi2gof(Distrib_respi_Norm(mouse,:));
end

% Correlation respifreq/speed for one mouse

figure
PlotCorrelations_BM(Distrib_speed_Norm(10,:) , Distrib_respi_Norm(10,:) , 30, 0 , 'r')
axis square
xlabel('Speed index')
ylabel('Respiratory frequency index')
title('Correlation between respiratory frequency and speed indexes for one mouse ')





%% HEARTRATE

for mouse=1:length(Mouse)
    try
        h=histogram(Data(OutPutData.TestPre.heartrate.tsd{mouse, 1}) , 100);
    catch ME
        OutPutData.TestPre.heartrate.tsd{mouse, 1}(OutPutData.TestPre.heartrate.tsd{mouse, 1}==0) = NaN
    end
    Distrib_heart(mouse,:)=h.Values;
    Distrib_heart_Norm(mouse,:)=Distrib_heart(mouse,:)/sum(Distrib_heart(mouse,:));
    testnormality_heart(mouse)=chi2gof(Distrib_heart_Norm(mouse,:));
end


% Plot Section

Data(OutPutData.TestPre.heartrate.tsd{30, 1})(Data(OutPutData.TestPre.heartrate.tsd{30, 1})==0)=NaN;


figure
PlotCorrelations_BM(Data(OutPutData.TestPre.heartrate.tsd{30, 1}) , Data(OutPutData.TestPre.respi_freq_BM.tsd{30, 1}) , 30, 0 , 'r')
axis square
xlabel('Heartrate ')
ylabel('Respiratory frequency')
title('Correlation between respiratory frequency and heart frequency for one mouse ')





%% Correlation btw heart rate and respiratory freq for all the mice

OutPutData.TestPre.heartrate.mean(OutPutData.TestPre.heartrate.mean==0)=NaN

figure
PlotCorrelations_BM( OutPutData.TestPre.heartrate.mean(:,1) , OutPutData.TestPre.respi_freq_BM.mean(:,1) , 30, 0 , 'r')
axis square
xlabel('Heartrate')
ylabel('Respiratory frequency')
axis([9 15 6.5 9.5])
title('Correlation Heart rate mean / Respiratory frequency mean for all mice')



%% MASK TEMPERATURE

for mouse=1:59   % strange values for mice 60 and 61 so we stop with mouse 59
    try
        h=histogram(Data(OutPutData.TestPre.masktemperature.tsd{mouse, 1}) , 100);
    catch ME
        OutPutData.TestPre.masktemperature.tsd{mouse, 1}(OutPutData.TestPre.masktemperature.tsd{mouse, 1}==0) = NaN
    end 
    Distrib_masktemp(mouse,:)=h.Values;
    testnormality_temp(mouse)=chi2gof(Distrib_masktemp(mouse,:));
end



figure
PlotCorrelations_BM( Data(OutPutData.TestPre.masktemperature.tsd{4, 1})(1:len, 1), Data(OutPutData.TestPre.heartrate.tsd{4, 1})(1:len, 1) , 30, 0 , 'r')
axis square
xlabel('Heartrate')
ylabel('Mask temperature')
title('Correlation Heart rate / Mask temperature for one m')



%% Correlation btw heart rate mean and distance travelled for all mice

figure
PlotCorrelations_BM(zscore(OutPutData.TestPre.heartrate.mean(:,1)) , zscore(OutPutData.TestPre.speed.mean(:,1)) , 30, 0 , 'r')
axis square
xlabel('Heartrate')
ylabel('Speed')
title('Correlation Heart rate mean / speed mean for all mice')


% For one mouse :
mouse=3;
D = interp1(linspace(0,1,length(Range(OutPutData.TestPre.speed.tsd{mouse, 1}))) , Data(OutPutData.TestPre.speed.tsd{mouse, 1}) , linspace(0,1,length(Range(OutPutData.TestPre.heartrate.tsd{mouse, 1}))));

figure
plot(runmean(Data(OutPutData.TestPre.heartrate.tsd{mouse, 1}),30) , D , '.r','MarkerSize',10)
hotmap = hist2d(runmean(Data(OutPutData.TestPre.heartrate.tsd{mouse, 1}),30) , D , 50 , 50);
imagesc(SmoothDec(hotmap,1)); axis xy;  colormap jet;




%% MOBILE/IMMOBILE MOUSE 

% Taux de mobilité

for mouse=1:length(Mouse)
    h=histogram(Data(OutPutData.TestPre.speed.tsd{mouse, 1}) ,'BinLimits',[0 25],'NumBins',100);
    Distrib_speed(mouse,:)=h.Values;
    Distrib_speed_Norm(mouse,:)=Distrib_speed(mouse,:)/sum(Distrib_speed(mouse,:));
end


for mouse=1:length(Mouse)
    activity(mouse)=sum(Distrib_speed(mouse,:)>5)/sum(Distrib_speed(mouse,:)) ;
end

% Correlation with heart rate mean

figure
PlotCorrelations_BM( activity , OutPutData.TestPre.heartrate.mean(:,1) , 30, 0 , 'r')
axis square
xlabel('activity index')
ylabel('heartrate mean')
title('Correlation Heart rate mean / activity index for all mice')
% Pb bcse of heart rate mean that is almost the same for every mice

% Correlation with high heart rate index


for mouse=1:length(Mouse)
    try 
        highhrate_index(mouse)=sum(Distrib_heart(mouse,:)> mean(Data(OutPutData.TestPre.heartrate.tsd{mouse, 1}))) / length(Data(OutPutData.TestPre.heartrate.tsd{mouse, 1})) ;   
    end 
end

highhrate_index(highhrate_index==0)=NaN % Correction
highhrate_index(highhrate_index>0.012)=NaN
activity(activity>0.025)=NaN

figure
PlotCorrelations_BM( activity , highhrate_index , 30, 0 , 'r')
axis square
xlabel('activity index')
ylabel('high heartrate index')
title('Correlation High Heart rate / activity index for all mice')


% Correlation with anxiety index

CornerOccupancy(CornerOccupancy>0.8)=NaN

figure
PlotCorrelations_BM( activity , CornerOccupancy , 30, 0 , 'r')
axis square
xlabel('activity index')
ylabel('Corner occupancy index')
axis([0.006 0.018 0.2 0.75])
title('Correlation Activity/Anxiety for all mice')

% Evolution oh heart rate correlation with breathing frequency when mobile/immobile

Delta_heartrate=zeros(length(Mouse),1)
Delta_breath=zeros(length(Mouse),1)


for mouse=1:length(Mouse)
    %     try
    %         if length(Data(OutPutData.TestPre.speed.tsd{mouse, 1})) < Data(OutPutData.TestPre.heartrate.tsd{mouse, 1})
    if ~isempty(OutPutData.TestPre.heartrate.tsd{mouse, 1})
        Data_HR = Data(OutPutData.TestPre.heartrate.tsd{mouse, 1});
        Data_Speed = Data(OutPutData.TestPre.speed.tsd{mouse, 1});
        Data_Respi = Data(OutPutData.TestPre.respi_freq_BM.tsd{mouse, 1});
        Data_Speed_interp = interp1(linspace(0,1,length(Range(OutPutData.TestPre.speed.tsd{mouse, 1}))) , Data_Speed , linspace(0,1,length(Range(OutPutData.TestPre.heartrate.tsd{mouse, 1}))));
        Data_Respi_interp = interp1(linspace(0,1,length(Range(OutPutData.TestPre.respi_freq_BM.tsd{mouse, 1}))) , Data_Respi , linspace(0,1,length(Range(OutPutData.TestPre.heartrate.tsd{mouse, 1}))));
        Perc_90 = percentile(Data(OutPutData.TestPre.speed.tsd{mouse, 1}),90);
        Perc_10 = percentile(Data(OutPutData.TestPre.speed.tsd{mouse, 1}),10);
        Data_HR_Running(mouse) = nanmean(Data_HR(Data_Speed_interp>Perc_90));
        Data_Respi_Running(mouse) = nanmean(Data_Respi_interp(Data_Speed_interp>Perc_90));
        Data_HR_Immobile(mouse) = nanmean(Data_HR(Data_Speed_interp<Perc_10));
        Data_Respi_Immobile(mouse) = nanmean(Data_Respi_interp(Data_Speed_interp<Perc_10));
        
        %             [M,I]=percentile(Data(OutPutData.TestPre.speed.tsd{mouse, 1}));
        %             [m,i]=min(Data(OutPutData.TestPre.speed.tsd{mouse, 1}));
        %             Delta_heartrate(mouse,1)=D0(I) - D0(i);
        %             Delta_breath(mouse,1)=D2(I) - D2(i);
        %         end
        %         if length(Data(OutPutData.TestPre.speed.tsd{mouse, 1})) >= Data(OutPutData.TestPre.heartrate.tsd{mouse, 1})
        %             D0 = Data(OutPutData.TestPre.speed.tsd{mouse, 1});
        %             D1 = interp1(linspace(0,1,length(Range(OutPutData.TestPre.heartrate.tsd{mouse, 1}))) , Data(OutPutData.TestPre.heartrate.tsd{mouse, 1}) , linspace(0,1,length(Range(OutPutData.TestPre.speed.tsd{mouse, 1}))));
        %             D2 = interp1(linspace(0,1,length(Range(OutPutData.TestPre.respi_freq_BM.tsd{mouse, 1}))) , Data(OutPutData.TestPre.respi_freq_BM.tsd{mouse, 1}) , linspace(0,1,length(Range(OutPutData.TestPre.speed.tsd{mouse, 1}))));
        %             [M,I]=max(Data(OutPutData.TestPre.speed.tsd{mouse, 1}));
        %             [m,i]=min(Data(OutPutData.TestPre.speed.tsd{mouse, 1}));
        %             Delta_heartrate(mouse,1)=D1(I) - D1(i);
        %             Delta_breath(mouse,1)=D2(I) - D2(i);
        %         end
        %     end
    end
end

Delta_HR = Data_HR_Running-Data_HR_Immobile;
Delta_Respi = Data_Respi_Running-Data_Respi_Immobile;


% for mouse=1:length(Mouse)
%     if ~isempty(OutPutData.TestPre.heartrate.tsd{mouse, 1})
%         a = size(Data(OutPutData.TestPre.speed.tsd{mouse, 1}) , 1);
%         b = size(Data(OutPutData.TestPre.heartrate.tsd{mouse, 1}) , 1);
%         c = size(Data(OutPutData.TestPre.respi_freq_BM.tsd{mouse, 1}) , 1);
%         
%         if or(b<a , b<c)
%             keyboard
%         end
%     end
% end



figure
PlotCorrelations_BM( Delta_heartrate(:,1) , Delta_breath(:,1) , 30, 0 , 'r')
axis square
xlabel('Delta Heartrate')
ylabel('Delta Breathinf frequency')
title('Correlation between Delta(heart rate) and Delta(breathing frequency) when mice are mobile/unmobile')

figure
PlotCorrelations_BM(Delta_HR , Delta_Respi , 30, 0 , 'r')
axis square
xlabel('Delta Heartrate')
ylabel('Delta Breathinf frequency')
title('Correlation between Delta(heart rate) and Delta(breathing frequency) when mice are mobile/unmobile')
vline(0,'--k')
hline(0,'--k')


figure
subplot(211)
plot(Data_HR_Running ,'.b','MarkerSize',30)
hold on
plot(Data_HR_Immobile ,'.r','MarkerSize',30)
hline(nanmean(Data_HR_Running),'--b')
hline(nanmean(Data_HR_Immobile),'--r')

subplot(212)
plot(Data_Respi_Running ,'.b','MarkerSize',30)
hold on
plot(Data_Respi_Immobile ,'.r','MarkerSize',30)
hline(nanmean(Data_Respi_Running),'--b')
hline(nanmean(Data_Respi_Immobile),'--r')



% Confirmation des résultats précédents

for mouse=1:length(Mouse)
    if ~isempty(OutPutData.TestPre.heartrate.tsd{mouse, 1})
        Data_HR = Data(OutPutData.TestPre.heartrate.tsd{mouse, 1});
        Data_Speed = Data(OutPutData.TestPre.speed.tsd{mouse, 1});
        Data_Respi = Data(OutPutData.TestPre.respi_freq_BM.tsd{mouse, 1});
        Data_Speed_interp = interp1(linspace(0,1,length(Range(OutPutData.TestPre.speed.tsd{mouse, 1}))) , Data_Speed , linspace(0,1,length(Range(OutPutData.TestPre.heartrate.tsd{mouse, 1}))));
        Data_Respi_interp = interp1(linspace(0,1,length(Range(OutPutData.TestPre.respi_freq_BM.tsd{mouse, 1}))) , Data_Respi , linspace(0,1,length(Range(OutPutData.TestPre.heartrate.tsd{mouse, 1}))));
        Perc_90 = percentile(Data(OutPutData.TestPre.heartrate.tsd{mouse, 1}),90);
        Perc_10 = percentile(Data(OutPutData.TestPre.heartrate.tsd{mouse, 1}),10);
        Data_Speed_Running(mouse) = nanmean(Data_Speed_interp(Data_HR>Perc_90));
        Data_Respi_Running(mouse) = nanmean(Data_Respi_interp(Data_HR>Perc_90));
        Data_HR_Running(mouse) = nanmean(Data_HR(Data_HR>Perc_90));
        Data_Speed_Immobile(mouse) = nanmean(Data_Speed_interp(Data_HR<Perc_10));
        Data_Respi_Immobile(mouse) = nanmean(Data_Respi_interp(Data_HR<Perc_10));
        Data_HR_Immobile(mouse) = nanmean(Data_HR(Data_HR<Perc_10));
    end 
end 
    
Delta_Speed = Data_Speed_Running-Data_Speed_Immobile;
Delta_Respi = Data_Respi_Running-Data_Respi_Immobile;
Delta_HR = Data_HR_Running-Data_HR_Immobile;


figure
PlotCorrelations_BM( Delta_Respi , Delta_Speed , 30, 0 , 'r')
axis square
xlabel('Delta Respi')
ylabel('Delta Speed')
title('Correlation between Delta(Respi) and Delta(Speed) when mice are mobile/unmobile')
vline(0,'k')
hline(0,'k')

% Correlation des 3 Delta
Delta_HR(Delta_HR>7)=NaN;
Delta_Speed(Delta_HR>7)=NaN;
Delta_Respi(Delta_HR>7)=NaN;

figure
plot3(Delta_HR, Delta_Speed, Delta_Respi, '.r','MarkerSize',30)
xlabel('Delta Heartrate')
ylabel('Delta Speed')
zlabel('Delta Respi')
title('3D Plot of the three Delta when mice are running/immobile(indicators are heartrate percentiles)')




%% NOMBRE D ENTREES PAR ZONE

ZoneEpoch.(Mouse_names{mouse}){1}

fn=fieldnames(ZoneEpoch);
for mouse=1:numel(fn)
    number_entries_shock_zone(mouse) = sum(Stop(ZoneEpoch.(fn{mouse}){1})-Start(ZoneEpoch.(fn{mouse}){1})>1e4);
    number_entries_safe_zone(mouse) = sum(Stop(ZoneEpoch.(fn{mouse}){2})-Start(ZoneEpoch.(fn{mouse}){2})>1e4);
end

figure
subplot(211)
h1 = histogram (number_entries_shock_zone,'BinLimits',[0 40],'NumBins',40);
Distrib_entries_shock_zone = h1.Values
xlabel('number of entries in the shock zone')
ylabel('population s size')
title('Distribution of the number of entries in the shock zone among all mice')
ylim([0 25])
subplot(212)
h2 = histogram (number_entries_safe_zone,'BinLimits',[0 40],'NumBins',40);
Distrib_entries_safe_zone = h2.Values
xlabel('number of entries in the safe zone')
ylabel('population s size')
title('Distribution of the number of entries in the safe zone among all mice')
ylim([0 25])
% Not easy to extract two separated populations from these distributions

figure
PlotCorrelations_BM( number_entries_shock_zone , number_entries_safe_zone, 30, 0 , 'r')
xlim([0 45])
ylim([0 45])

figure
h3 = histogram (number_entries_shock_zone+number_entries_safe_zone,'BinLimits',[0 80],'NumBins',20);


% Another activity index 

max_entries_shockzone = max(number_entries_chock_zone)

for mouse = 1:length(Mouse)
    activity_index_zones(mouse) = number_entries_shock_zone(mouse) / max_entries_shockzone
end


% Correlation with anxiety index

figure
PlotCorrelations_BM( activity_index_zones , CornerOccupancy, 30, 0 , 'r')
axis square
xlabel(' Activity index (entries in shock zones)')
ylabel('Anxiety index (corner occupancy)')
title('Correlation between Activity index and Anxiety index')


% Correlation with the other activity index

activity(or(activity>0.015, activity<0.005))=NaN

figure
PlotCorrelations_BM( activity_index_zones , activity, 30, 0 , 'r')
axis square
xlabel(' Activity index (entries in shock zones)')
ylabel('Activity index (mobility rate calculated with speed)')
title('Correlation between both activity indexes')



%% TEMPS PASSE PAR ZONE

fn=fieldnames(ZoneEpoch);
for mouse=1:numel(fn)
    zone_shock_entries=Start(ZoneEpoch.(fn{mouse}){1});
    zone_shock_exits=Stop(ZoneEpoch.(fn{mouse}){1});
    time_shock_zone(mouse)= sum(zone_shock_exits-zone_shock_entries);
end

figure
h3 = histogram(time_shock_zone)
title('Tim
times_shock=h3.Values



%% Evolution of heart rate and breathing frequency and gamma power during a session

for mouse=1:83
    Respi_All_interp(mouse,:) = runmean(interp1(linspace(0,1,length(Range(OutPutData.TestPre.respi_freq_BM.tsd{mouse, 1}))) , Data(OutPutData.TestPre.respi_freq_BM.tsd{mouse, 1}) , linspace(0,1,200)) , ceil(.5/median(diff(Range(OutPutData.TestPre.respi_freq_BM.tsd{mouse, 1},'s')))));
    if ~isempty(OutPutData.TestPre.heartrate.tsd{mouse, 1})
        HR_All_interp(mouse,:) = runmean(interp1(linspace(0,1,length(Range(OutPutData.TestPre.heartrate.tsd{mouse, 1}))) , Data(OutPutData.TestPre.heartrate.tsd{mouse, 1}) , linspace(0,1,200)) , ceil(.5/median(diff(Range(OutPutData.TestPre.respi_freq_BM.tsd{mouse, 1},'s')))));
    end
end

for mouse=1:61
    if ~isempty(OutPutData.TestPre.ob_gamma_freq.tsd{mouse, 1})
        Gamma_All_interp(mouse,:) = runmean(interp1(linspace(0,1,length(Range(OutPutData.TestPre.ob_gamma_freq.tsd{mouse, 1}))) , Data(OutPutData.TestPre.ob_gamma_freq.tsd{mouse, 1}) , linspace(0,1,200)), ceil(.5/median(diff(Range(OutPutData.TestPre.ob_gamma_freq.tsd{mouse, 1})))));
    end
    for i=1:length(Gamma_All_interp(1,:))
        if isnan(Gamma_All_interp(mouse,i))
            Gamma_All_interp(mouse,i) = 0;
        end
    end
end
Gamma_All_interp([60 61],:)=NaN;
Gamma_All_interp(Gamma_All_interp==0)=NaN;

for mouse=1:83
    Gammapower_All_interp(mouse,:) = runmean(interp1(linspace(0,1,length(Range(OutPutData.TestPre.ob_gamma_power.tsd{mouse, 1}))) , Data(OutPutData.TestPre.ob_gamma_power.tsd{mouse, 1}) , linspace(0,1,200)) , ceil(.5/median(diff(Range(OutPutData.TestPre.ob_gamma_power.tsd{mouse, 1},'s')))));
end

for mouse=1:71
    Gammafreq_All_interp(mouse,:) = runmean(interp1(linspace(0,1,length(Range(OutPutData.TestPre.ob_gamma_freq.tsd{mouse, 1}))) , Data(OutPutData.TestPre.ob_gamma_freq.tsd{mouse, 1}) , linspace(0,1,200)) , ceil(.5/median(diff(Range(OutPutData.TestPre.ob_gamma_freq.tsd{mouse, 1},'s')))));
end



% Corrections

mtemp_All_interp([60 61],:)=NaN;
mtemp_All_interp(mtemp_All_interp==0)=NaN;


% Plot Section (evolutions)

figure
subplot(511)
plot(nanmean(Respi_All_interp))
vline([50 100 150],'--r')
makepretty
title('Evolution of respiratory frequency for all mice')
subplot(512)
plot(nanmean(HR_All_interp))
vline([50 100 150],'--r')
makepretty
title('Evolution of heartrate for all mice')
subplot(513)
plot(nanmean(Gamma_All_interp))
vline([50 100 150],'--r')
makepretty
title('Evolution of gamma frequency for all mice')
subplot(514)
plot(nanmean(Gammapower_All_interp))
vline([50 100 150],'--r')
makepretty
title('Evolution of gamma power for all mice')
subplot(515)
plot(nanmean(mtemp_All_interp))
vline([50 100 150],'--r')
makepretty
title('Evolution of mask temperature for all mice')

figure
plot(runmean(Data((OutPutData.TestPre.ob_gamma_freq.tsd{50, 1})),1000))
title('OB gamma power evolution for one mouse')
xlabel('time')
ylabel('OB gamma power')



%% Differences between the beginning and the end of the session 

for mouse=1:83
    Respi_All_interp(mouse,:) = runmean(interp1(linspace(0,1,length(Range(OutPutData.TestPre.respi_freq_BM.tsd{mouse, 1}))) , Data(OutPutData.TestPre.respi_freq_BM.tsd{mouse, 1}) , linspace(0,1,200)) , ceil(.5/median(diff(Range(OutPutData.TestPre.respi_freq_BM.tsd{mouse, 1},'s')))));
    len = length(Respi_All_interp(1,:));
    Respi_beginning = mean(Respi_All_interp(mouse, 1:20));
    Respi_end = mean(Respi_All_interp(mouse, (len-20):end));
    Diff_respi(mouse) = Respi_end - Respi_beginning;
end

for mouse=1:83
    if ~isempty(OutPutData.TestPre.heartrate.tsd{mouse, 1})
        HR_All_interp(mouse,:) = runmean(interp1(linspace(0,1,length(Range(OutPutData.TestPre.heartrate.tsd{mouse, 1}))) , Data(OutPutData.TestPre.heartrate.tsd{mouse, 1}) , linspace(0,1,200)) , ceil(.5/median(diff(Range(OutPutData.TestPre.respi_freq_BM.tsd{mouse, 1},'s')))));
        len = length(HR_All_interp(1,:));
        HR_beginning = mean(HR_All_interp(mouse, 1:20));
        HR_end = mean(HR_All_interp(mouse, (len-20):end));
        Diff_HR(mouse) = HR_end - HR_beginning;
    end
end 

for mouse=1:71
    if ~isempty(OutPutData.TestPre.ob_gamma_freq.tsd{mouse, 1})
        Gamma_All_interp(mouse,:) = runmean(interp1(linspace(0,1,length(Range(OutPutData.TestPre.ob_gamma_freq.tsd{mouse, 1}))) , Data(OutPutData.TestPre.ob_gamma_freq.tsd{mouse, 1}) , linspace(0,1,200)) , ceil(.5/median(diff(Range(OutPutData.TestPre.ob_gamma_freq.tsd{mouse, 1},'s')))));
        len = length(Gamma_All_interp(1,:));
        Gamma_beginning = mean(Gamma_All_interp(mouse, 1:20));
        Gamma_end = mean(Gamma_All_interp(mouse, (len-20):end));
        Diff_Gamma(mouse) = Gamma_end - Gamma_beginning;
    end
end 

for mouse=1:83
    if ~isempty(OutPutData.TestPre.ob_gamma_power.tsd{mouse, 1})
        Gammapower_All_interp(mouse,:) = runmean(interp1(linspace(0,1,length(Range(OutPutData.TestPre.ob_gamma_power.tsd{mouse, 1}))) , Data(OutPutData.TestPre.ob_gamma_power.tsd{mouse, 1}) , linspace(0,1,200)) , ceil(.5/median(diff(Range(OutPutData.TestPre.ob_gamma_power.tsd{mouse, 1},'s')))));
        len = length(Gammapower_All_interp(1,:));
        Gammapower_beginning = mean(Gammapower_All_interp(mouse, 1:20));
        Gammapower_end = mean(Gammapower_All_interp(mouse, (len-20):end));
        Diff_Gammapower(mouse) = Gammapower_end - Gammapower_beginning;
    end
end 

for mouse=1:61
    if ~isempty(OutPutData.TestPre.masktemperature.tsd{mouse, 1})
        mtemp_All_interp(mouse,:) = runmean(interp1(linspace(0,1,length(Range(OutPutData.TestPre.masktemperature.tsd{mouse, 1}))) , Data(OutPutData.TestPre.masktemperature.tsd{mouse, 1}) , linspace(0,1,200)) , ceil(.5/median(diff(Range(OutPutData.TestPre.masktemperature.tsd{mouse, 1},'s')))));
        len = length(mtemp_All_interp(1,:));
        mtemp_beginning = mean(mtemp_All_interp(mouse, 1:20));
        mtemp_end = mean(mtemp_All_interp(mouse, (len-20):end));
        Diff_mtemp(mouse) = mtemp_end - mtemp_beginning;
    end
end 



% Corrections

Diff_mtemp(Diff_mtemp>1500) = NaN



figure
suptitle('Distributions of differences between variables at the beginning and at the end of the session')
subplot(511)
h_HR_diff = histogram(Diff_HR,30)
title('heartrate')
ylabel('heartrate (Hz)')
subplot(512)
h_respi_diff = histogram(Diff_respi,20)
title('respiratory frequency')
ylabel('breathing frequency (Hz)')
subplot(513)
h_Gamma_diff = histogram(Diff_Gamma,20)
Distrib_Gamma_Diff = h_Gamma_diff.Values
title('OB gamma frequency')
ylabel('frequency (Hz)')
subplot(514)
h_Gammapower_diff = histogram(Diff_Gammapower,20)
Distrib_Gammapower_Diff = h_Gammapower_diff.Values
title('OB gamma power')
ylabel('power (W)')
subplot(515)
h_mtemp_diff = histogram(Diff_mtemp,15)
Distrib_mtemp_Diff = h_mtemp_diff.Values
title('mask temperature')
xlabel('delta')
ylabel('temperature (C)')






