%% Load the FolderPath 
FolderPath_2Eyelid_Audiodream_AF


clear all
%% Create the FolderName

i=0;
i=i+1;FolderName{i} = '/media/gruffalo/DataMOBS198/2_PiezoEyelidStim/1597_Eyelid_240516_160804/';
i=i+1;FolderName{i} = '/media/gruffalo/DataMOBS198/2_PiezoEyelidStim/1597_Eyelid_240517_111240/';
i=i+1;FolderName{i} = '/media/gruffalo/DataMOBS198/2_PiezoEyelidStim/1597_Eyelid_240517_145901/';
i=i+1;FolderName{i} = '/media/gruffalo/DataMOBS198/2_PiezoEyelidStim/1597_Eyelid_240517_171645/';
i=i+1;FolderName{i} = '/media/gruffalo/DataMOBS198/2_PiezoEyelidStim/1597_Eyelid_240527_131121/';


megaT_1V_ob = [];
megaT_15V_ob = [];
megaT_2V_ob = [];
megaT_1V_accelero = [];
megaT_15V_accelero = [];
megaT_2V_accelero = [];
megaT_1V_piezo = [];
megaT_15V_piezo = [];
megaT_2V_piezo = [];

megaM_1V_ob = [];
megaM_15V_ob = [];
megaM_2V_ob = [];
megaM_1V_accelero = [];
megaM_15V_accelero = [];
megaM_2V_accelero = [];
megaM_1V_piezo = [];
megaM_15V_piezo = [];
megaM_2V_piezo = [];

position_1V_piezo = 0;
position_15V_piezo = 0;
position_2V_piezo = 0;

position_1V_accelero = 0;
position_15V_accelero = 0;
position_2V_accelero = 0;

position_1V_ob = 0;
position_15V_ob = 0;
position_2V_ob = 0;

for i = 1:length(FolderName)
    % Load
    cd(FolderName{i});

    % Load piezo
    load('PiezoData_SleepScoring.mat', 'Piezo_Mouse_tsd')
    Piezo_Mouse_tsd = tsd(Range(Piezo_Mouse_tsd),sqrt((Data(Piezo_Mouse_tsd)-mean(Data(Piezo_Mouse_tsd))).^2));
    % Load stim times
    load('behavResources.mat', 'TTLInfo')
    StimTime = Start(TTLInfo.StimEpoch,'s');
    % Load stim ID
    load('journal_stim.mat')
    StimValue =  cell2mat(journal_stim(:,1));
    PlotOrNot = 0;
    PlotNewfig =0;
    [M,T] = PlotRipRaw(Piezo_Mouse_tsd,StimTime(StimValue==1),[-20 20]*1e3,0,PlotOrNot,PlotNewfig);
%     figure
%     imagesc(M(:,1),1:length(StimTime(StimValue==2)),(T))
    megaT_1V_piezo = [megaT_1V_piezo ;T];
    megaM_1V_piezo = [megaM_1V_piezo ;M];        
        LimsTime = [1,10];
        StartAveraging = find(M(:,1)>LimsTime(1),1,'first');
        StopAveraging = find(M(:,1)>LimsTime(2),1,'first');
        AverageGammaPostStim = mean(T(:,StartAveraging:StopAveraging),2);
        LimsTime = [-5,-1];
        StartAveraging = find(M(:,1)>LimsTime(1),1,'first');
        StopAveraging = find(M(:,1)>LimsTime(2),1,'first');
        AverageGammaPreStim = mean(T(:,StartAveraging:StopAveraging),2);
        
        for n = 1:length(AverageGammaPostStim)
        AverageGammaPostStim_1V_piezo(position_1V_piezo+n,1) = AverageGammaPostStim(n);
        end
        position_1V_piezo = length(AverageGammaPostStim_1V_piezo);
        
    [M,T] = PlotRipRaw(Piezo_Mouse_tsd,StimTime(StimValue==1.5),[-20 20]*1e3,0,PlotOrNot,PlotNewfig);
    megaT_15V_piezo = [megaT_15V_piezo ;T];
    megaM_15V_piezo = [megaM_15V_piezo ;M];
        LimsTime = [1,10];
        StartAveraging = find(M(:,1)>LimsTime(1),1,'first');
        StopAveraging = find(M(:,1)>LimsTime(2),1,'first');
        AverageGammaPostStim = mean(T(:,StartAveraging:StopAveraging),2);
        LimsTime = [-5,-1];
        StartAveraging = find(M(:,1)>LimsTime(1),1,'first');
        StopAveraging = find(M(:,1)>LimsTime(2),1,'first');
        AverageGammaPreStim = mean(T(:,StartAveraging:StopAveraging),2);
        
        for n = 1:length(AverageGammaPostStim)
        AverageGammaPostStim_15V_piezo(position_15V_piezo+n,1) = AverageGammaPostStim(n);
        end
        position_15V_piezo = length(AverageGammaPostStim_15V_piezo);
        
        try
    [M,T] = PlotRipRaw(Piezo_Mouse_tsd,StimTime(StimValue==2),[-20 20]*1e3,0,PlotOrNot,PlotNewfig);
    megaT_2V_piezo = [megaT_2V_piezo ;T];
    megaM_2V_piezo = [megaM_2V_piezo ;M];
        LimsTime = [1,10];
        StartAveraging = find(M(:,1)>LimsTime(1),1,'first');
        StopAveraging = find(M(:,1)>LimsTime(2),1,'first');
        AverageGammaPostStim = mean(T(:,StartAveraging:StopAveraging),2);
        LimsTime = [-5,-1];
        StartAveraging = find(M(:,1)>LimsTime(1),1,'first');
        StopAveraging = find(M(:,1)>LimsTime(2),1,'first');
        AverageGammaPreStim = mean(T(:,StartAveraging:StopAveraging),2);
        
        for n = 1:length(AverageGammaPostStim)
        AverageGammaPostStim_2V_piezo(position_2V_piezo+n,1) = AverageGammaPostStim(n);
        end
        position_2V_piezo = length(AverageGammaPostStim_2V_piezo);
        end
        
    % Load accelero
    load('behavResources.mat', 'MovAcctsd')
    [M,T] = PlotRipRaw(MovAcctsd,StimTime(StimValue==1),[-20 20]*1e3,0,PlotOrNot,PlotNewfig);
    megaT_1V_accelero = [megaT_1V_accelero ;T];
    megaM_1V_accelero = [megaM_1V_accelero ;M];
        LimsTime = [1,10];
        StartAveraging = find(M(:,1)>LimsTime(1),1,'first');
        StopAveraging = find(M(:,1)>LimsTime(2),1,'first');
        AverageGammaPostStim = mean(T(:,StartAveraging:StopAveraging),2);
        LimsTime = [-5,-1];
        StartAveraging = find(M(:,1)>LimsTime(1),1,'first');
        StopAveraging = find(M(:,1)>LimsTime(2),1,'first');
        AverageGammaPreStim = mean(T(:,StartAveraging:StopAveraging),2);
        
        for n = 1:length(AverageGammaPostStim)
            AverageGammaPostStim_1V_accelero(position_1V_accelero+n,1) = AverageGammaPostStim(n);
        end
        position_1V_accelero = length(AverageGammaPostStim_1V_accelero);
    
        
    [M,T] = PlotRipRaw(MovAcctsd,StimTime(StimValue==1.5),[-20 20]*1e3,0,PlotOrNot,PlotNewfig);
    megaT_15V_accelero = [megaT_15V_accelero ;T];
    megaM_15V_accelero = [megaM_15V_accelero ;M];
        LimsTime = [1,10];
        StartAveraging = find(M(:,1)>LimsTime(1),1,'first');
        StopAveraging = find(M(:,1)>LimsTime(2),1,'first');
        AverageGammaPostStim = mean(T(:,StartAveraging:StopAveraging),2);
        LimsTime = [-5,-1];
        StartAveraging = find(M(:,1)>LimsTime(1),1,'first');
        StopAveraging = find(M(:,1)>LimsTime(2),1,'first');
        AverageGammaPreStim = mean(T(:,StartAveraging:StopAveraging),2);
        
        for n = 1:length(AverageGammaPostStim)
            AverageGammaPostStim_15V_accelero(position_15V_accelero+n,1) = AverageGammaPostStim(n);
        end
        position_15V_accelero = length(AverageGammaPostStim_15V_accelero);
    
    try
    [M,T] = PlotRipRaw(MovAcctsd,StimTime(StimValue==2),[-20 20]*1e3,0,PlotOrNot,PlotNewfig);
    megaT_2V_accelero = [megaT_2V_accelero ;T];
    megaM_2V_accelero = [megaM_2V_accelero ;M];
        LimsTime = [1,10];
        StartAveraging = find(M(:,1)>LimsTime(1),1,'first');
        StopAveraging = find(M(:,1)>LimsTime(2),1,'first');
        AverageGammaPostStim = mean(T(:,StartAveraging:StopAveraging),2);
        LimsTime = [-5,-1];
        StartAveraging = find(M(:,1)>LimsTime(1),1,'first');
        StopAveraging = find(M(:,1)>LimsTime(2),1,'first');
        AverageGammaPreStim = mean(T(:,StartAveraging:StopAveraging),2);
        
        for n = 1:length(AverageGammaPostStim)
            AverageGammaPostStim_2V_accelero(position_2V_accelero+n,1) = AverageGammaPostStim(n);
        end
        position_2V_accelero = length(AverageGammaPostStim_2V_accelero);
    end
    
    % Recalculate gamm no smoothing
    load('ChannelsToAnalyse/Bulb_deep.mat','channel')
    load([cd,'/LFPData/LFP',num2str(channel)],'LFP');
    FilGamma=FilterLFP(LFP,[50 70],1024);
    HilGamma=hilbert(Data(FilGamma));
    H=abs(HilGamma);
    tot_ghi=tsd(Range(LFP),H);

    [M,T] = PlotRipRaw(tot_ghi,StimTime(StimValue==1),[-20 20]*1e3,0,PlotOrNot,PlotNewfig);
    megaT_1V_ob = [megaT_1V_ob ;T];
    megaM_1V_ob = [megaM_1V_ob ;M];
        LimsTime = [1,10];
        StartAveraging = find(M(:,1)>LimsTime(1),1,'first');
        StopAveraging = find(M(:,1)>LimsTime(2),1,'first');
        AverageGammaPostStim = mean(T(:,StartAveraging:StopAveraging),2);
        LimsTime = [-5,-1];
        StartAveraging = find(M(:,1)>LimsTime(1),1,'first');
        StopAveraging = find(M(:,1)>LimsTime(2),1,'first');
        AverageGammaPreStim = mean(T(:,StartAveraging:StopAveraging),2);
        
        for n = 1:length(AverageGammaPostStim)
            AverageGammaPostStim_1V_ob(position_1V_ob+n,1) = AverageGammaPostStim(n);
        end
        position_1V_ob = length(AverageGammaPostStim_1V_ob);
        
    [M,T] = PlotRipRaw(tot_ghi,StimTime(StimValue==1.5),[-20 20]*1e3,0,PlotOrNot,PlotNewfig);
    megaT_15V_ob = [megaT_15V_ob ;T];
    megaM_15V_ob = [megaM_15V_ob ;M];
        LimsTime = [1,10];
        StartAveraging = find(M(:,1)>LimsTime(1),1,'first');
        StopAveraging = find(M(:,1)>LimsTime(2),1,'first');
        AverageGammaPostStim = mean(T(:,StartAveraging:StopAveraging),2);
        LimsTime = [-5,-1];
        StartAveraging = find(M(:,1)>LimsTime(1),1,'first');
        StopAveraging = find(M(:,1)>LimsTime(2),1,'first');
        AverageGammaPreStim = mean(T(:,StartAveraging:StopAveraging),2);
        
        for n = 1:length(AverageGammaPostStim)
            AverageGammaPostStim_15V_ob(position_15V_ob+n,1) = AverageGammaPostStim(n);
        end
        position_15V_ob = length(AverageGammaPostStim_15V_ob);

    try
    [M,T] = PlotRipRaw(tot_ghi,StimTime(StimValue==2),[-20 20]*1e3,0,PlotOrNot,PlotNewfig);
    megaT_2V_ob = [megaT_2V_ob ;T];
    megaM_2V_ob = [megaM_2V_ob ;M];
        LimsTime = [1,10];
        StartAveraging = find(M(:,1)>LimsTime(1),1,'first');
        StopAveraging = find(M(:,1)>LimsTime(2),1,'first');
        AverageGammaPostStim = mean(T(:,StartAveraging:StopAveraging),2);
        LimsTime = [-5,-1];
        StartAveraging = find(M(:,1)>LimsTime(1),1,'first');
        StopAveraging = find(M(:,1)>LimsTime(2),1,'first');
        AverageGammaPreStim = mean(T(:,StartAveraging:StopAveraging),2);
        
        for n = 1:length(AverageGammaPostStim)
            AverageGammaPostStim_2V_ob(position_2V_ob+n,1) = AverageGammaPostStim(n);
        end
        position_2V_ob = length(AverageGammaPostStim_2V_ob);
    end
    
    
    disp('One done')

end



%%
groups = {'1','1.5','2'};
fig = figure;
suptitle('Puissance en fonction de la stim')
subplot(1,3,1)
A = {AverageGammaPostStim_1V_ob,AverageGammaPostStim_15V_ob,AverageGammaPostStim_2V_ob};
Cols = {[0.9290 0.6940 0.1250],[0 1 0],[0.3010 0.7450 0.9330]};
X = [1,2,3];
Legends = {'1','1.5','2'};
ShowPoints = 1;
[boxhandle, pointshandle] = MakeBoxPlot_DB(A,Cols,X,Legends,ShowPoints,'connectdots',1);
xlabel('Volt')
ylabel('Puissance')
title('OB')
set(gca, 'XTickLabel',groups);
b.FaceColor = 'flat';
b.CData(1,:) = [0.9290 0.6940 0.1250];
b.CData(2,:) = [0 1 0];
b.CData(3,:) = [0.3010 0.7450 0.9330];

subplot(1,3,2)
A = {AverageGammaPostStim_1V_accelero,AverageGammaPostStim_15V_accelero,AverageGammaPostStim_2V_accelero};
Cols = {[0.9290 0.6940 0.1250],[0 1 0],[0.3010 0.7450 0.9330]};
X = [1,2,3];
Legends = {'1','1.5','2'};
ShowPoints = 1;
[boxhandle, pointshandle] = MakeBoxPlot_DB(A,Cols,X,Legends,ShowPoints,'connectdots',1);
xlabel('Volt')
ylabel('Puissance')
title('Accelero')
set(gca, 'XTickLabel',groups);
b.FaceColor = 'flat';
b.CData(1,:) = [0.9290 0.6940 0.1250];
b.CData(2,:) = [0 1 0];
b.CData(3,:) = [0.3010 0.7450 0.9330];


subplot(1,3,3)
A = {AverageGammaPostStim_1V_piezo,AverageGammaPostStim_15V_piezo,AverageGammaPostStim_2V_piezo};
Cols = {[0.9290 0.6940 0.1250],[0 1 0],[0.3010 0.7450 0.9330]};
X = [1,2,3];
Legends = {'1','1.5','2'};
ShowPoints = 1;
[boxhandle, pointshandle] = MakeBoxPlot_DB(A,Cols,X,Legends,ShowPoints,'connectdots',1);
xlabel('Volt')
ylabel('Puissance')
title('Piezo')
set(gca, 'XTickLabel',groups);
b.FaceColor = 'flat';
b.CData(1,:) = [0.9290 0.6940 0.1250];
b.CData(2,:) = [0 1 0];
b.CData(3,:) = [0.3010 0.7450 0.9330];




%% Pour Comparer les groupes au même Voltage : 

% zscore
zcore_AverageGammaPostStim_1V_ob = zscore(AverageGammaPostStim_1V_ob(:,1));
zcore_AverageGammaPostStim_15V_ob = zscore(AverageGammaPostStim_15V_ob(:,1));
zcore_AverageGammaPostStim_2V_ob = zscore(AverageGammaPostStim_2V_ob(:,1));

zcore_AverageGammaPostStim_1V_accelero = zscore(AverageGammaPostStim_1V_accelero(:,1));
zcore_AverageGammaPostStim_15V_accelero = zscore(AverageGammaPostStim_15V_accelero(:,1));
zcore_AverageGammaPostStim_2V_accelero = zscore(AverageGammaPostStim_2V_accelero(:,1));

zcore_AverageGammaPostStim_1V_piezo = zscore(AverageGammaPostStim_1V_piezo(:,1));
zcore_AverageGammaPostStim_15V_piezo = zscore(AverageGammaPostStim_15V_piezo(:,1));
zcore_AverageGammaPostStim_2V_piezo = zscore(AverageGammaPostStim_2V_piezo(:,1));





groups = {'OB','Movement','Actimetry'};
fig = figure;
suptitle('zscore des données brutes dans la période 1 à 15s suivant une stim')
subplot(1,3,1)
A = {zcore_AverageGammaPostStim_1V_ob,zcore_AverageGammaPostStim_1V_accelero,zcore_AverageGammaPostStim_1V_piezo};
Cols = {[0.9290 0.6940 0.1250],[0 1 0],[0.3010 0.7450 0.9330]};
X = [1,2,3];
Legends = {'OB','Movement','Actimetry'};
ShowPoints = 1;
[boxhandle, pointshandle] = MakeBoxPlot_DB(A,Cols,X,Legends,ShowPoints,'connectdots',1);
xlabel('Méthodes')
ylabel('zscore')
title('1 Volt')
set(gca, 'XTickLabel',groups);
b.FaceColor = 'flat';
b.CData(1,:) = [0.9290 0.6940 0.1250];
b.CData(2,:) = [0 1 0];
b.CData(3,:) = [0.3010 0.7450 0.9330];
ylim([-1 5])

subplot(1,3,2)
A = {zcore_AverageGammaPostStim_15V_ob,zcore_AverageGammaPostStim_15V_accelero,zcore_AverageGammaPostStim_15V_piezo};
Cols = {[0.9290 0.6940 0.1250],[0 1 0],[0.3010 0.7450 0.9330]};
X = [1,2,3];
Legends = {'OB','Movement','Actimetry'};
ShowPoints = 1;
[boxhandle, pointshandle] = MakeBoxPlot_DB(A,Cols,X,Legends,ShowPoints,'connectdots',1);
xlabel('Méthodes')
ylabel('zscore')
title('1.5 Volt')
set(gca, 'XTickLabel',groups);
b.FaceColor = 'flat';
b.CData(1,:) = [0.9290 0.6940 0.1250];
b.CData(2,:) = [0 1 0];
b.CData(3,:) = [0.3010 0.7450 0.9330];
ylim([-1 5])


subplot(1,3,3)
A = {zcore_AverageGammaPostStim_2V_ob,zcore_AverageGammaPostStim_2V_accelero,zcore_AverageGammaPostStim_2V_piezo};
Cols = {[0.9290 0.6940 0.1250],[0 1 0],[0.3010 0.7450 0.9330]};
X = [1,2,3];
Legends = {'OB','Movement','Actimetry'};
ShowPoints = 1;
[boxhandle, pointshandle] = MakeBoxPlot_DB(A,Cols,X,Legends,ShowPoints,'connectdots',1);
xlabel('Méthodes')
ylabel('zscore')
title('2 Volt')
set(gca, 'XTickLabel',groups);
b.FaceColor = 'flat';
b.CData(1,:) = [0.9290 0.6940 0.1250];
b.CData(2,:) = [0 1 0];
b.CData(3,:) = [0.3010 0.7450 0.9330];
ylim([-1 5])




% Calculate mean activity after stim
LimsTime = [1,10];
StartAveraging = find(M(:,1)>LimsTime(1),1,'first');
StopAveraging = find(M(:,1)>LimsTime(2),1,'first');
AverageGammaPostStim = mean(T(:,StartAveraging:StopAveraging),2);
LimsTime = [-5,-1];
StartAveraging = find(M(:,1)>LimsTime(1),1,'first');
StopAveraging = find(M(:,1)>LimsTime(2),1,'first');
AverageGammaPreStim = mean(T(:,StartAveraging:StopAveraging),2);



%%
figure, 
suptitle('Corrélations des valeurs brutes pendant la période 1 à 10s après la stim')
subplot(331)
plot(AverageGammaPostStim_1V_ob,AverageGammaPostStim_1V_accelero,'.')
xlabel('OB Gamma')
ylabel('Accéléromètre')
title('1 Volt')

subplot(332)
plot(AverageGammaPostStim_1V_ob,AverageGammaPostStim_1V_piezo,'.')
xlabel('OB Gamma')
ylabel('Piezo')
title('1 Volt')

subplot(333)
plot(AverageGammaPostStim_1V_accelero,AverageGammaPostStim_1V_piezo,'.')
xlabel('Accéléromètre')
ylabel('Piezo')
title('1 Volt')

subplot(334)
plot(AverageGammaPostStim_15V_ob,AverageGammaPostStim_15V_accelero,'.')
xlabel('OB Gamma')
ylabel('Accéléromètre')
title('1.5 Volt')

subplot(335)
plot(AverageGammaPostStim_15V_ob,AverageGammaPostStim_15V_piezo,'.')
xlabel('OB Gamma')
ylabel('Piezo')
title('1.5 Volt')

subplot(336)
plot(AverageGammaPostStim_15V_accelero,AverageGammaPostStim_15V_piezo,'.')
xlabel('Accéléromètre')
ylabel('Piezo')
title('1.5 Volt')

subplot(337)
plot(AverageGammaPostStim_2V_ob,AverageGammaPostStim_2V_accelero,'.')
xlabel('OB Gamma')
ylabel('Accéléromètre')
title('2 Volt')

subplot(338)
plot(AverageGammaPostStim_2V_ob,AverageGammaPostStim_2V_piezo,'.')
xlabel('OB Gamma')
ylabel('Piezo')
title('2 Volt')

subplot(339)
plot(AverageGammaPostStim_2V_accelero,AverageGammaPostStim_2V_piezo,'.')
xlabel('Accéléromètre')
ylabel('Piezo')
title('2 Volt')




%%


figure, 
suptitle('Corrélations des valeurs brutes pendant la période 1 à 10s après la stim')
subplot(131)
plot(AverageGammaPostStim_1V_ob,AverageGammaPostStim_1V_accelero,'r.','MarkerSize',20)
hold on 
plot(AverageGammaPostStim_15V_ob,AverageGammaPostStim_15V_accelero,'g.','MarkerSize',20)
hold on
plot(AverageGammaPostStim_2V_ob,AverageGammaPostStim_2V_accelero,'k.','MarkerSize',20)
xlabel('OB Gamma')
ylabel('Accéléromètre')


subplot(132)
plot(AverageGammaPostStim_1V_ob,AverageGammaPostStim_1V_piezo,'r.','MarkerSize',20)
hold on 
plot(AverageGammaPostStim_15V_ob,AverageGammaPostStim_15V_piezo,'g.','MarkerSize',20)
hold on
plot(AverageGammaPostStim_2V_ob,AverageGammaPostStim_2V_piezo,'k.','MarkerSize',20)
xlabel('OB Gamma')
ylabel('Piézo')
ylim([0 1])

subplot(133)
plot(AverageGammaPostStim_1V_accelero,AverageGammaPostStim_1V_piezo,'r.','MarkerSize',20)
hold on 
plot(AverageGammaPostStim_15V_accelero,AverageGammaPostStim_15V_piezo,'g.','MarkerSize',20)
hold on
plot(AverageGammaPostStim_2V_accelero,AverageGammaPostStim_2V_piezo,'k.','MarkerSize',20)
xlabel('Accéléromètre')
ylim([0 1])
ylabel('Piézo')




%% Make a vector with all value of ob, piezo or accelero together
for i = 1:length(AverageGammaPostStim_1V_ob)
    AverageGammaPostStim_ob(i,1) = AverageGammaPostStim_1V_ob(i,1);
end
l=length(AverageGammaPostStim_ob);
for i = 1:length(AverageGammaPostStim_15V_ob)
    AverageGammaPostStim_ob(i+l,1) = AverageGammaPostStim_15V_ob(i,1);
end
l=length(AverageGammaPostStim_ob);
for i = 1:length(AverageGammaPostStim_2V_ob)
    AverageGammaPostStim_ob(i+l,1) = AverageGammaPostStim_2V_ob(i,1);
end


for i = 1:length(AverageGammaPostStim_1V_accelero)
    AverageGammaPostStim_accelero(i,1) = AverageGammaPostStim_1V_accelero(i,1);
end
l=length(AverageGammaPostStim_accelero);
for i = 1:length(AverageGammaPostStim_15V_accelero)
    AverageGammaPostStim_accelero(i+l,1) = AverageGammaPostStim_15V_accelero(i,1);
end
l=length(AverageGammaPostStim_accelero);
for i = 1:length(AverageGammaPostStim_2V_accelero)
    AverageGammaPostStim_accelero(i+l,1) = AverageGammaPostStim_2V_accelero(i,1);
end

for i = 1:length(AverageGammaPostStim_1V_piezo)
    AverageGammaPostStim_piezo(i,1) = AverageGammaPostStim_1V_piezo(i,1);
end
l=length(AverageGammaPostStim_piezo);
for i = 1:length(AverageGammaPostStim_15V_piezo)
    AverageGammaPostStim_piezo(i+l,1) = AverageGammaPostStim_15V_piezo(i,1);
end
l=length(AverageGammaPostStim_piezo);
for i = 1:length(AverageGammaPostStim_2V_piezo)
    AverageGammaPostStim_piezo(i+l,1) = AverageGammaPostStim_2V_piezo(i,1);
end

