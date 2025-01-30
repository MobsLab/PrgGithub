% definition des periodes diode ON, avec LFP analog input
% 
% A=thresholdIntervals(LFP,0.0001'Direction','Below');
% dropShortIntervals(A, 1*1E4);

[params,movingwin,suffix]=SpectrumParametersML('low'); % low or high
load Diode_ON

structlist={'PFCx_deep','Bulb_deep','dHPC_rip','PiCx','Amyg'};
i=2;
temp=load(['ChannelsToAnalyse/',structlist{i},'.mat']);
temp2=load(['LFPData/LFP',num2str(temp.channel),'.mat']);
%disp(['Computing SpectrumDataL/Spectrum' num2str(temp.channel),'... '])

[Sp,t,f]=mtspecgramc(Data(temp2.LFP),movingwin,params);
Stsd=tsd(t*1E4,Sp);

TotEpoch=intervalSet(t(1)*1E4,t(end)*1E4);
figure;
%s_diode_ON=mean(Data(Restrict(Stsd,diode_ON_segt)));
plot(f,mean(Data(Restrict(Stsd,diode_ON_segt))),'r')
hold on, 

%s_diode_ON=mean(Data(Restrict(Stsd,diode_ON_period1)));
plot(f,mean(Data(Restrict(Stsd,diode_ON_period1))),'o')
%s_diode_ON=mean(Data(Restrict(Stsd,diode_ON_period2)));
plot(f,mean(Data(Restrict(Stsd,diode_ON_period2))),'Color',[1 0 0.3)

% off
%a_diode_OFF=mean(Data(Restrict(Stsd,diode_OFF_period)));
plot(f,mean(Data(Restrict(Stsd,diode_OFF_period))),'b')


legend({['diode ON (' sprintf('%0.0f',tot_length(diode_ON_segt)*1E-4) ' sec)'];['diode OFF (' sprintf('%0.0f',tot_length(TotEpoch-diode_ON_segt)*1E-4) ' sec)']})