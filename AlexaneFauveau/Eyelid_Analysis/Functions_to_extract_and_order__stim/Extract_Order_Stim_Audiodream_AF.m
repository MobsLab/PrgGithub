%% Fonction pour extraire une stim qui est dans le sommeil: 
function [Sleep_Stim_Epoch_Duration_Wake,Wake_Stim_Epoch_Duration_Wake,Mix_Stim_Epoch_Duration_Wake,Sleep_Stim_Epoch_Duration_Wake_Accelero,Wake_Stim_Epoch_Duration_Wake_Accelero,Mix_Stim_Epoch_Duration_Wake_Accelero,Sleep_Stim_Epoch_Duration_Wake_Piezo,Wake_Stim_Epoch_Duration_Wake_Piezo,Mix_Stim_Epoch_Duration_Wake_Piezo] = Extract_Order_Stim_Audiodream_AF(valeur_volt)
% Be in the following folder: with the journal stim and electroy data

% Give the following :
% SaveFolder
% Sleep_intervalSet
% Wake_intervalSet
% tsd
% valeur_volt

% Give back this : 

f=0;
f=f+1;FolderName{f} = '/media/gruffalo/DataMOBS198/2_PiezoEyelidStim/1597_Eyelid_240516_160804/';
f=f+1;FolderName{f} = '/media/gruffalo/DataMOBS198/2_PiezoEyelidStim/1597_Eyelid_240517_111240/';
f=f+1;FolderName{f} = '/media/gruffalo/DataMOBS198/2_PiezoEyelidStim/1597_Eyelid_240517_145901/';
f=f+1;FolderName{f} = '/media/gruffalo/DataMOBS198/2_PiezoEyelidStim/1597_Eyelid_240517_171645/';



ligne = 0;



%% Create the Stim Epoch
for f = 1:length(FolderName)
    % Load
    cd(FolderName{f});
load ('behavResources.mat')
Stim_Event_Start = [Start(TTLInfo.StimEpoch)];
duration_stim = 0.2e4; 

start_after_stim = 1e4 ; % e4 -> en secondes
Stim_Epoch_Start = Stim_Event_Start+start_after_stim;

end_after_stim = 10e4 ;  
duration_epoch = end_after_stim - start_after_stim;  
Stim_Epoch_End = Stim_Epoch_Start + duration_epoch;

Epoch_Stim = intervalSet(Stim_Epoch_Start, Stim_Epoch_End);
Event_Stim = intervalSet(Stim_Event_Start, Stim_Event_Start+duration_stim);

%% Create the Intervals for Sleep and Wake
% Define time to analyse the state of the mouse before the stim
start_before_stim = 8e4 ; % e4 -> en secondes
end_before_stim = 3e4 ;  

% Load files to give the voltage to each stim and if the stim was during Sleep or Wake
load journal_stim.mat

% Create variables: 
Sleep_Stim_Epoch_Start = [];
Sleep_Stim_Epoch_End = [];


Wake_Stim_Epoch_Start = [];
Wake_Stim_Epoch_End = [];


Mix_Stim_Epoch_Start = [];
Mix_Stim_Epoch_End = [];




%% For OB
load SleepScoring_OBGamma.mat Sleep Wake SmoothGamma;
Sleep_intervalSet_OB = Sleep;
Wake_intervalSet_OB = Wake;
Sleep_intervalSet = Sleep;
Wake_intervalSet = Wake;
tsd = SmoothGamma;

Sleep_Stim_Epoch_Duration_Wake = zeros(1,1);
Wake_Stim_Epoch_Duration_Wake = zeros(1,1);
Mix_Stim_Epoch_Duration_Wake = zeros(1,1);

for i = 1:length(Stim_Epoch_Start)
    if journal_stim{i,1} == valeur_volt; 
        ligne = ligne + 1;
        
        Before_Stim_Epoch_Start = Stim_Event_Start(i) - start_before_stim;
        Before_Stim_Epoch_End = Stim_Epoch_Start(i) - end_before_stim;
        Before_Epoch_Stim = intervalSet(Before_Stim_Epoch_Start, Before_Stim_Epoch_End);
        
        tsd_Before_Epoch = Restrict(tsd,Before_Epoch_Stim);
        
        if length(Range(Restrict(tsd_Before_Epoch,Sleep_intervalSet),'s')) == length(Range(tsd_Before_Epoch,'s'))
            Sleep_Stim_Epoch_Start = [Sleep_Stim_Epoch_Start, Stim_Epoch_Start(i)];
            Sleep_Stim_Epoch_End = [Sleep_Stim_Epoch_End, Stim_Epoch_End(i)];
            Stim_Start = [Stim_Epoch_Start(i)];
            Stim_End = [Stim_Epoch_End(i)];
            Epoch = intervalSet(Stim_Start, Stim_End);
            % Change in other places
            Sleep_Stim_Epoch_Duration_Wake(ligne,1) =  sum(Stop(and(Wake_intervalSet,Epoch),'s') - Start(and(Wake_intervalSet,Epoch),'s'));
            Sleep_Percent_Stim_Epoch_Wake(ligne,1) = Sleep_Stim_Epoch_Duration_Wake(ligne,1)/(sum(Stop(Epoch,'s') - Start(Epoch,'s')));
            clear Epoch
            clear Stim_Start
            clear Stim_End
            
        elseif length(Range(Restrict(tsd_Before_Epoch,Wake_intervalSet),'s')) == length(Range(tsd_Before_Epoch,'s'))
            Wake_Stim_Epoch_Start = [Wake_Stim_Epoch_Start, Stim_Epoch_Start(i)];
            Wake_Stim_Epoch_End = [Wake_Stim_Epoch_End, Stim_Epoch_End(i)];
            Stim_Start = [Stim_Epoch_Start(i)];
            Stim_End = [Stim_Epoch_End(i)];
            Epoch = intervalSet(Stim_Start, Stim_End);
            % Change in other places
            Wake_Stim_Epoch_Duration_Wake(ligne,1) =  sum(Stop(and(Wake_intervalSet,Epoch),'s') - Start(and(Wake_intervalSet,Epoch),'s'));
            Wake_Percent_Stim_Epoch_Wake(ligne,1) = Wake_Stim_Epoch_Duration_Wake(ligne,1)/(sum(Stop(Epoch,'s') - Start(Epoch,'s')));
            clear Epoch
            clear Stim_Start
            clear Stim_End
            
        else
            Mix_Stim_Epoch_Start = [Mix_Stim_Epoch_Start, Stim_Epoch_Start(i)];
            Mix_Stim_Epoch_End = [Mix_Stim_Epoch_End, Stim_Epoch_End(i)];            
            Stim_Start = [Stim_Epoch_Start(i)];
            Stim_End = [Stim_Epoch_End(i)];
            Epoch = intervalSet(Stim_Start, Stim_End);
            Mix_Stim_Epoch_Duration_Wake(ligne,1) =  sum(Stop(and(Wake_intervalSet,Epoch),'s') - Start(and(Wake_intervalSet,Epoch),'s'));
            Mix_Percent_Stim_Epoch_Wake(ligne,1) = Mix_Stim_Epoch_Duration_Wake(ligne,1)/(sum(Stop(Epoch,'s') - Start(Epoch,'s')));
            clear Epoch
            clear Stim_Start
            clear Stim_End
            disp('Stim with both wake and sleep before')
        end
    end
end


%%

% Sleep_Epoch_Stim = intervalSet(Sleep_Stim_Epoch_Start, Sleep_Stim_Epoch_End)
% Wake_Epoch_Stim = intervalSet(Wake_Stim_Epoch_Start, Wake_Stim_Epoch_End)
% Mix_Epoch_Stim = intervalSet(Mix_Stim_Epoch_Start, Mix_Stim_Epoch_End)



%% For accelero
load SleepScoring_Accelero.mat Sleep Wake tsdMovement;
Sleep_intervalSet_Accelero = Sleep;
Wake_intervalSet_Accelero = Wake;
Sleep_intervalSet = Sleep;
Wake_intervalSet = Wake;
tsd = tsdMovement;

Sleep_Stim_Epoch_Duration_Wake_Accelero = zeros(1,1);
Wake_Stim_Epoch_Duration_Wake_Accelero = zeros(1,1);
Mix_Stim_Epoch_Duration_Wake_Accelero = zeros(1,1);


for i = 1:length(Stim_Epoch_Start)
    if journal_stim{i,1} == valeur_volt; 
        ligne = ligne + 1;
        
        Before_Stim_Epoch_Start = Stim_Event_Start(i) - start_before_stim;
        Before_Stim_Epoch_End = Stim_Epoch_Start(i) - end_before_stim;
        Before_Epoch_Stim = intervalSet(Before_Stim_Epoch_Start, Before_Stim_Epoch_End);
        
        tsd_Before_Epoch = Restrict(tsd,Before_Epoch_Stim);
        
        if length(Range(Restrict(tsd_Before_Epoch,Sleep_intervalSet),'s')) == length(Range(tsd_Before_Epoch,'s'))
            Sleep_Stim_Epoch_Start = [Sleep_Stim_Epoch_Start, Stim_Epoch_Start(i)];
            Sleep_Stim_Epoch_End = [Sleep_Stim_Epoch_End, Stim_Epoch_End(i)];
            Stim_Start = [Stim_Epoch_Start(i)];
            Stim_End = [Stim_Epoch_End(i)];
            Epoch = intervalSet(Stim_Start, Stim_End);
            % Change in other places
            Sleep_Stim_Epoch_Duration_Wake_Accelero(ligne,1) =  sum(Stop(and(Wake_intervalSet,Epoch),'s') - Start(and(Wake_intervalSet,Epoch),'s'));
            Sleep_Percent_Stim_Epoch_Wake_Accelero(ligne,1) = Sleep_Stim_Epoch_Duration_Wake_Accelero(ligne,1)/(sum(Stop(Epoch,'s') - Start(Epoch,'s')));
            clear Epoch
            clear Stim_Start
            clear Stim_End
            
        elseif length(Range(Restrict(tsd_Before_Epoch,Wake_intervalSet),'s')) == length(Range(tsd_Before_Epoch,'s'))
            Wake_Stim_Epoch_Start = [Wake_Stim_Epoch_Start, Stim_Epoch_Start(i)];
            Wake_Stim_Epoch_End = [Wake_Stim_Epoch_End, Stim_Epoch_End(i)];
            Stim_Start = [Stim_Epoch_Start(i)];
            Stim_End = [Stim_Epoch_End(i)];
            Epoch = intervalSet(Stim_Start, Stim_End);
            % Change in other places
            Wake_Stim_Epoch_Duration_Wake_Accelero(ligne,1) =  sum(Stop(and(Wake_intervalSet,Epoch),'s') - Start(and(Wake_intervalSet,Epoch),'s'));
            Wake_Percent_Stim_Epoch_Wake_Accelero(ligne,1) = Wake_Stim_Epoch_Duration_Wake_Accelero(ligne,1)/(sum(Stop(Epoch,'s') - Start(Epoch,'s')));
            clear Epoch
            clear Stim_Start
            clear Stim_End
            
        else
            Mix_Stim_Epoch_Start = [Mix_Stim_Epoch_Start, Stim_Epoch_Start(i)];
            Mix_Stim_Epoch_End = [Mix_Stim_Epoch_End, Stim_Epoch_End(i)];            
            Stim_Start = [Stim_Epoch_Start(i)];
            Stim_End = [Stim_Epoch_End(i)];
            Epoch = intervalSet(Stim_Start, Stim_End);
            Mix_Stim_Epoch_Duration_Wake_Accelero(ligne,1) =  sum(Stop(and(Wake_intervalSet,Epoch),'s') - Start(and(Wake_intervalSet,Epoch),'s'));
            Mix_Percent_Stim_Epoch_Wake_Accelero(ligne,1) = Mix_Stim_Epoch_Duration_Wake_Accelero(ligne,1)/(sum(Stop(Epoch,'s') - Start(Epoch,'s')));
            clear Epoch
            clear Stim_Start
            clear Stim_End
            disp('Stim with both wake and sleep before')
        end
    end
end


%% For Piezo:
load PiezoData_SleepScoring.mat SleepEpoch_Piezo WakeEpoch_Piezo Piezo_Mouse_tsd;
Sleep_intervalSet_Piezo= SleepEpoch_Piezo;
Wake_intervalSet_Piezo = WakeEpoch_Piezo;
Sleep_intervalSet = SleepEpoch_Piezo;
Wake_intervalSet = WakeEpoch_Piezo;
tsd = Piezo_Mouse_tsd;

Sleep_Stim_Epoch_Duration_Wake_Piezo = zeros(1,1);
Wake_Stim_Epoch_Duration_Wake_Piezo = zeros(1,1);
Mix_Stim_Epoch_Duration_Wake_Piezo = zeros(1,1);


for i = 1:length(Stim_Epoch_Start)
    if journal_stim{i,1} == valeur_volt; 
        ligne = ligne + 1;
        
        Before_Stim_Epoch_Start = Stim_Event_Start(i) - start_before_stim;
        Before_Stim_Epoch_End = Stim_Epoch_Start(i) - end_before_stim;
        Before_Epoch_Stim = intervalSet(Before_Stim_Epoch_Start, Before_Stim_Epoch_End);
        
        tsd_Before_Epoch = Restrict(tsd,Before_Epoch_Stim);
        
        if length(Range(Restrict(tsd_Before_Epoch,Sleep_intervalSet),'s')) == length(Range(tsd_Before_Epoch,'s'))
            Sleep_Stim_Epoch_Start = [Sleep_Stim_Epoch_Start, Stim_Epoch_Start(i)];
            Sleep_Stim_Epoch_End = [Sleep_Stim_Epoch_End, Stim_Epoch_End(i)];
            Stim_Start = [Stim_Epoch_Start(i)];
            Stim_End = [Stim_Epoch_End(i)];
            Epoch = intervalSet(Stim_Start, Stim_End);
            % Change in other places
            Sleep_Stim_Epoch_Duration_Wake_Piezo(ligne,1) =  sum(Stop(and(Wake_intervalSet,Epoch),'s') - Start(and(Wake_intervalSet,Epoch),'s'));
            Sleep_Percent_Stim_Epoch_Wake_Piezo(ligne,1) = Sleep_Stim_Epoch_Duration_Wake_Piezo(ligne,1)/(sum(Stop(Epoch,'s') - Start(Epoch,'s')));
            clear Epoch
            clear Stim_Start
            clear Stim_End
            
        elseif length(Range(Restrict(tsd_Before_Epoch,Wake_intervalSet),'s')) == length(Range(tsd_Before_Epoch,'s'))
            Wake_Stim_Epoch_Start = [Wake_Stim_Epoch_Start, Stim_Epoch_Start(i)];
            Wake_Stim_Epoch_End = [Wake_Stim_Epoch_End, Stim_Epoch_End(i)];
            Stim_Start = [Stim_Epoch_Start(i)];
            Stim_End = [Stim_Epoch_End(i)];
            Epoch = intervalSet(Stim_Start, Stim_End);
            % Change in other places
            Wake_Stim_Epoch_Duration_Wake_Piezo(ligne,1) =  sum(Stop(and(Wake_intervalSet,Epoch),'s') - Start(and(Wake_intervalSet,Epoch),'s'));
            Wake_Percent_Stim_Epoch_Wake_Piezo(ligne,1) = Wake_Stim_Epoch_Duration_Wake_Piezo(ligne,1)/(sum(Stop(Epoch,'s') - Start(Epoch,'s')));
            clear Epoch
            clear Stim_Start
            clear Stim_End
            
        else
            Mix_Stim_Epoch_Start = [Mix_Stim_Epoch_Start, Stim_Epoch_Start(i)];
            Mix_Stim_Epoch_End = [Mix_Stim_Epoch_End, Stim_Epoch_End(i)];            
            Stim_Start = [Stim_Epoch_Start(i)];
            Stim_End = [Stim_Epoch_End(i)];
            Epoch = intervalSet(Stim_Start, Stim_End);
            Mix_Stim_Epoch_Duration_Wake_Piezo(ligne,1) =  sum(Stop(and(Wake_intervalSet,Epoch),'s') - Start(and(Wake_intervalSet,Epoch),'s'));
            Mix_Percent_Stim_Epoch_Wake_Piezo(ligne,1) = Mix_Stim_Epoch_Duration_Wake_Piezo(ligne,1)/(sum(Stop(Epoch,'s') - Start(Epoch,'s')));
            clear Epoch
            clear Stim_Start
            clear Stim_End
            disp('Stim with both wake and sleep before')
        end
    end

end
end
%% To plot if needed
% % Plot it
% Colors.Sleep = 'r';
% Colors.Wake = 'c';
% Colors.Stim1 = 'y';
% Colors.Stim15 = 'g';
% Colors.Stim2 = 'k';
% t = Range(SmoothGamma);
% begin = t(1);
% endin = t(end);
% 
% figure
% plot(Range(SmoothGamma,'s'),Data(SmoothGamma))
% hold on
% plot(Range(Restrict(SmoothGamma,Epoch_Stim),'s'),Data(Restrict(SmoothGamma,Epoch_Stim)),'g')
% plot(Range(Restrict(SmoothGamma,Wake),'s'),Data(Restrict(SmoothGamma,Wake)),'k')
% hold on 
% plot(Range(Restrict(SmoothGamma,Event_Stim),'s'),Data(Restrict(SmoothGamma,Event_Stim)),'r')
% ylim([0 10]);
% yl=ylim;
% LineHeight = yl(2);
% PlotPerAsLine(Sleep, LineHeight, Colors.Sleep, 'timescaling', 1e4, 'linewidth',100);
% PlotPerAsLine(Wake, LineHeight, Colors.Wake, 'timescaling', 1e4, 'linewidth',100);
% PlotPerAsLine(Sleep_Epoch_Stim, LineHeight, Colors.Stim1, 'timescaling', 1e4, 'linewidth',1000);
% PlotPerAsLine(Wake_Epoch_Stim, LineHeight, Colors.Stim15, 'timescaling', 1e4, 'linewidth',1000);
% PlotPerAsLine(Mix_Epoch_Stim, LineHeight, Colors.Stim2, 'timescaling', 1e4, 'linewidth',1000);



% Colors.Sleep = 'r';
% Colors.Wake = 'c';
% Colors.Stim = 'k';
% t = Range(SmoothGamma);
% begin = t(1);
% endin = t(end);
% 
% y = [1 2 3]
% figure
% LineHeight = y(3)
% PlotPerAsLine(Sleep_intervalSet_OB, LineHeight, Colors.Sleep, 'timescaling', 1e4, 'linewidth',100);
% PlotPerAsLine(Wake_intervalSet_OB, LineHeight, Colors.Wake, 'timescaling', 1e4, 'linewidth',100);
% PlotPerAsLine(Epoch_Stim, LineHeight, Colors.Stim, 'timescaling', 1e4, 'linewidth',100);
% 
% LineHeight = y(2)
% PlotPerAsLine(Sleep_intervalSet_Accelero, LineHeight, Colors.Sleep, 'timescaling', 1e4, 'linewidth',100);
% PlotPerAsLine(Wake_intervalSet_Accelero, LineHeight, Colors.Wake, 'timescaling', 1e4, 'linewidth',100);
% PlotPerAsLine(Epoch_Stim, LineHeight, Colors.Stim, 'timescaling', 1e4, 'linewidth',100);
% 
% LineHeight = y(1)
% PlotPerAsLine(Sleep_intervalSet_Piezo, LineHeight, Colors.Sleep, 'timescaling', 1e4, 'linewidth',100);
% PlotPerAsLine(Wake_intervalSet_Piezo, LineHeight, Colors.Wake, 'timescaling', 1e4, 'linewidth',100);
% PlotPerAsLine(Epoch_Stim, LineHeight, Colors.Stim, 'timescaling', 1e4, 'linewidth',100);




