% exemple filtre passe bande

data=Data(LFP);

plot(Spectro{3},nanmean(Data(OB_Freeze.Fear.All.M1130)),'k','linewidth',2), ylabel('OB'); xlabel('Frequency (Hz)'); hold on
plot(Spectro{3},data,'k','linewidth',2), ylabel('OB'); xlabel('Frequency (Hz)'); hold on
plot(Spectro{3},data_treated,'r','linewidth',2), ylabel('OB'); xlabel('Frequency (Hz)'); hold on
legend('data','after filter')
makepretty
data=nanmean(Data(OB_Freeze.Fear.All.M1130));

fs = 1250; %freq echantillonnage
fc = 20*2/fs; % freq de coupure haut (la 20Hz)
fb = 1*2/fs; % freq de coupure basse (la 1Hz)
[b,a] = butter(4,[fb fc]);
data_norm = data-mean(data); % mettre la base ligne sinon filtre pas content
data_treated = filter(b,a,data_norm);% fitre

%% parametre spectro dans mon cas
params.fpass=[0 20];
params.tapers=[2 3];
movingwin=[2 0.1];
params.Fs=1250;
[SP,t,f]=mtspecgramc(data_treated',movingwin,params);

%% fit

%
meanSP=mean(Data(SpecOB_Fz.M929.Day2))/mean(mean(Data(SpecOB_Fz.M929.Day2)));

point_1= find(Spectro{3}<2 & Spectro{3}>);
point_2 = find(meanSP==min(meanSP(Spectro{3}>0 & Spectro{3}<4)),1); % a adapt�, d'apr�s la courbe dans discord se serai plutot entre 1 et 3Hz
vect = [point_1,point_2,find(Spectro{3}>6)]; %  a adapt�, toi ca serai plutot f>6
ft = fittype('a*exp(-b*x/c)+d'); % eq utilis� pour le fit
fit_alpha = fit(Spectro{3}(vect)',meanSP(vect)',ft); % calcul du fit

figure
subplot(121), hold on
plot(Spectro{3},meanSP)
plot(fit_alpha,Spectro{3}(vect)',meanSP(vect)')

subplot(1,2,2)
meanSP_to_plot = meanSP-(fit_alpha.a*exp(-fit_alpha.b*Spectro{3}/fit_alpha.c)+fit_alpha.d);
plot(Spectro{3},meanSP_to_plot)


% Smoothingspline fit
point_1= find(Spectro{3}<2);
vect = [point_1,point_2,find(Spectro{3}>6)]; %  a adapt�, toi ca serai plutot f>6
fit_alpha = fit(Spectro{3}(vect)',meanSP(vect)','smoothingspline'); % calcul du fit

plot(fit_alpha(Spectro{3}))

figure
subplot(121), hold on
plot(Spectro{3},meanSP)
plot(fit_alpha,Spectro{3}(vect)',meanSP(vect)')

subplot(122)
meanSP_to_plot = meanSP-fit_alpha(Spectro{3})';
plot(Spectro{3},meanSP_to_plot)



%% original

fs = 500; %freq echantillonnage
fc = 40*2/fs; % freq de coupure haut (la 40Hz)
fb = 1*2/fs; % freq de coupure basse (la 1Hz)
[b,a] = butter(4,[fb fc]);
data = data-mean(data); % mettre la base ligne sinon filtre pas content
data = filter(b,a,data);% fitre

%% parametre spectro dans mon cas
params.fpass=[0 24];
params.tapers=[2 3];
movingwin=[3 0.1];
params.Fs=500;
[SP,t,f]=mtspecgramc(data,movingwin,params);

%% fit
SP=mean(SP);
point_de_depart = find(SP==max(SP(f<5)),1); 
point_2 = find(SP==min(SP(f>3 & f<7)),1); % a adapt�, d'apr�s la courbe dans discord se serai plutot entre 1 et 3Hz
vect = [point_de_depart,point_2,find(f>15)]; %  a adapt�, toi ca serai plutot f>6
ft = fittype('a*exp(-b*x/c)+d'); % eq utilis� pour le fit
fit_alpha = fit(f(vect)',(SP(vect))',ft); % calcul du fit
figure
subplot(1,2,1), hold on
plot(f,SP)
plot(fit_alpha,f(vect)',SP(vect)')

subplot(1,2,2)
SP = SP-(fit_alpha.a*exp(-fit_alpha.b*f/fit_alpha.c)+fit_alpha.d);
plot(f,SP)



