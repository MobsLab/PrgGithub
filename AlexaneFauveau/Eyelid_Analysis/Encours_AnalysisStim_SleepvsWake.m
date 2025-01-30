%% Code to Extract the Epoch after the stim, and look to duration of wake : 

%% For SleepScoring Data : 
% For 1 volt
valeur_volt = 1;
[Sleep_Stim_Epoch_Duration_Wake_1_OB,Wake_Stim_Epoch_Duration_Wake_1_OB,Mix_Stim_Epoch_Duration_Wake_1_OB,Sleep_Stim_Epoch_Duration_Wake_1_Accelero,Wake_Stim_Epoch_Duration_Wake_1_Accelero,Mix_Stim_Epoch_Duration_Wake_1_Accelero,Sleep_Stim_Epoch_Duration_Wake_1_Piezo,Wake_Stim_Epoch_Duration_Wake_1_Piezo,Mix_Stim_Epoch_Duration_Wake_1_Piezo] = Extract_Order_Stim_Audiodream_AF(valeur_volt);

% For 1.5 volt
valeur_volt = 1.5;
[Sleep_Stim_Epoch_Duration_Wake_15_OB,Wake_Stim_Epoch_Duration_Wake_15_OB,Mix_Stim_Epoch_Duration_Wake_15_OB,Sleep_Stim_Epoch_Duration_Wake_15_Accelero,Wake_Stim_Epoch_Duration_Wake_15_Accelero,Mix_Stim_Epoch_Duration_Wake_15_Accelero,Sleep_Stim_Epoch_Duration_Wake_15_Piezo,Wake_Stim_Epoch_Duration_Wake_15_Piezo,Mix_Stim_Epoch_Duration_Wake_15_Piezo] = Extract_Order_Stim_Audiodream_AF(valeur_volt);

% For 1.5 volt
valeur_volt = 2;
[Sleep_Stim_Epoch_Duration_Wake_2_OB,Wake_Stim_Epoch_Duration_Wake_2_OB,Mix_Stim_Epoch_Duration_Wake_2_OB,Sleep_Stim_Epoch_Duration_Wake_2_Accelero,Wake_Stim_Epoch_Duration_Wake_2_Accelero,Mix_Stim_Epoch_Duration_Wake_2_Accelero,Sleep_Stim_Epoch_Duration_Wake_2_Piezo,Wake_Stim_Epoch_Duration_Wake_2_Piezo,Mix_Stim_Epoch_Duration_Wake_2_Piezo] = Extract_Order_Stim_Audiodream_AF(valeur_volt);


% Plot the figure : 
%%
x = [0 1 2 3 4 5 6 7 8 9 10]
y = x

figure, 
suptitle('Corrélations des durées de réveil pendant la période 1 à 10s après la stim pendant du sommeil')
subplot(131)
plot(Sleep_Stim_Epoch_Duration_Wake_1_OB,Sleep_Stim_Epoch_Duration_Wake_1_Accelero,'b.','MarkerSize',20)
hold on 
plot(Sleep_Stim_Epoch_Duration_Wake_15_OB,Sleep_Stim_Epoch_Duration_Wake_15_Accelero,'g.','MarkerSize',20)
hold on
plot(Sleep_Stim_Epoch_Duration_Wake_2_OB,Sleep_Stim_Epoch_Duration_Wake_2_Accelero,'k.','MarkerSize',20)
hold on 
plot(x,y,'b--')
xlabel('OB Gamma')
ylabel('Accéléromètre')
ylim([0 10])
title('1 Volt')

subplot(132)
plot(Stim_Epoch_Wake_1(:,1),Stim_Epoch_Wake_1(:,3),'y.','MarkerSize',20)
hold on 
plot(Stim_Epoch_Wake_15(:,1),Stim_Epoch_Wake_15(:,3),'g.','MarkerSize',20)
hold on
plot(Stim_Epoch_Wake_2(:,1),Stim_Epoch_Wake_2(:,3),'k.','MarkerSize',20)
hold on 
plot(x,y,'b--')
xlabel('OB Gamma')
ylabel('Piezo')
ylim([0 10])
title('1.5 Volt')

subplot(133)
plot(Stim_Epoch_Wake_1(:,2),Stim_Epoch_Wake_1(:,3),'y.','MarkerSize',20)
hold on 
plot(Stim_Epoch_Wake_15(:,2),Stim_Epoch_Wake_15(:,3),'g.','MarkerSize',20)
hold on
plot(Stim_Epoch_Wake_2(:,2),Stim_Epoch_Wake_2(:,3),'k.','MarkerSize',20)
hold on 
plot(x,y,'b--')
xlabel('Accéléromètre')
ylabel('Piezo')
ylim([0 10])
title('2 Volt')







