
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

%% Old code

for m=3:5
    try
     cd(filename{m})
load('BlbSpectrum.mat');
load('StateEpochSB.mat');
load(strcat(filename2{m},'LFPData/LFP',num2str(chB),'.mat'))
load(strcat(filename2{m},'behavResources.mat'))
try
    PreEpoch;
catch
    PreEpoch=intervalSet([],[]);
end

fB=SpectroB{3};
tB=SpectroB{2};
SpB=SpectroB{1};

sptsd=tsd(tB*10000,SpB);
sptsd=Restrict(sptsd,Epoch);
startg=find(fB<60,1,'last');
stopg=find(fB>80,1,'first');
spdat=Data(sptsd);
tot_ghi=tsd(Range(Restrict(sptsd,Epoch)),sum(spdat(:,startg:stopg)')');
tot_ghi=Restrict(tot_ghi,Epoch);

smfact=floor([0.1,0.2,0.5,1,2,3,4,5,7,10,15,30,40,60]/median(diff(Range(tot_ghi,'s'))));
clear smooth_ghi
for i=1:length(smfact);
smooth_ghi{i}=tsd(Range(tot_ghi),smooth(Data(tot_ghi),smfact(i)));
end
h=figure;
set(h,'color',[1 1 1],'Position',[1 1 1600 600])
subplot(131)
cc=jet(length(smfact));
for i=1:length(smfact)
[Y,X]=hist(log(Data(smooth_ghi{i})),700);
plot(X,Y/sum(Y),'color',cc(i,:))
hold on
end
    
%% From Filtered Data

Filgamma=FilterLFP(LFP,[60 80],1024);
if size(start(PreEpoch),1)~=0
Filgamma=Restrict(Filgamma,PreEpoch-NoiseEpoch-GndNoiseEpoch);
else
     r=Range(LFP);
     TotalEpoch=intervalSet(0,r(end));
     Filgamma=Restrict(Filgamma,TotalEpoch-NoiseEpoch-GndNoiseEpoch);
end

Hilgamma=hilbert(Data(Filgamma));
Hilgamma=tsd(Range(Filgamma),abs(Hilgamma));
Filgamma=tsd(Range(Filgamma),Data(Filgamma).^2);

smfact=floor([0.1,0.2,0.5,1,2,3,4,5,7,10,15,30,40,60]/median(diff(Range(Filgamma,'s'))));
clear smooth_ghi_fil
for i=1:length(smfact)
smooth_ghi_fil{i}=tsd(Range(Filgamma),smooth(Data(Filgamma),smfact(i)));
end

subplot(132)
cc=jet(length(smfact));
for i=1:length(smfact)

[Y,X]=hist(log(Data(smooth_ghi_fil{i})),700);
plot(X,Y/sum(Y),'color',cc(i,:))
hold on
end
a=xlim;
xlim([0 a(2)])

%From Hilbert
clear smooth_ghi_hil
for i=1:length(smfact)
smooth_ghi_hil{i}=tsd(Range(Hilgamma),smooth(Data(Hilgamma),smfact(i)));
end

subplot(133)
cc=jet(length(smfact));
for i=1:length(smfact)
[Y,X]=hist(log(Data(smooth_ghi_hil{i})),700);
plot(X,Y/sum(Y),'color',cc(i,:))
hold on
end
save('diffmethods.mat','smooth_ghi_hil','smooth_ghi_fil','smooth_ghi','-v7.3')
saveas(h,'diffmethods.jpg')
saveas(h,'diffmethods.fig')
saveFigure(h,'diffmethods',filename{m});
close all
clear PreEpoch
catch
    m
end
end



%Fit one gaussian, two gaussian - distance between peaks

for m=3:5
clear rms dist
    cd(filename{m})
load('diffmethods.mat')
clear  cf2 cf1 goodness2 goodness1 
for i=1:length(smfact)
[Y,X]=hist(log(Data(smooth_ghi{i})),700);
a=find(Y>10,1,'first');
Y=Y(a:end);
X=X(a:end);
% [dip(i), p_value(i), xlow(i),xup(i)]=HartigansDipSignifTest(sort(log(Data(smooth_ghi{i}))),500)
[cf2{i},goodness2{i}]=createFit2gauss(X,Y/sum(Y));
[cf1{i},goodness1{i}]=createFit1gauss(X,Y/sum(Y));
hold on
end

for i=1:length(smfact)
rms{1}(i,1)=goodness1{i}.sse;
rms{1}(i,2)=goodness2{i}.sse;
rms{1}(i,3)=goodness1{i}.rsquare;
rms{1}(i,4)=goodness2{i}.rsquare;
rms{1}(i,5)=goodness1{i}.adjrsquare;
rms{1}(i,6)=goodness2{i}.adjrsquare;
rms{1}(i,7)=goodness1{i}.rmse;
rms{1}(i,8)=goodness2{i}.rmse;
% dipt{1}(i,1)=p_value(i);
% dipt{1}(i,2)=dip(i);

a= coeffvalues(cf2{i});
dist{1}(i,1)=abs(a(2)-a(5));
b=(a(3)-a(6))^2/(a(3)^2+a(6)^2);
dist{1}(i,2)=1-sqrt(2*a(3)*a(6)/(a(3)^2+a(6)^2))*exp(-0.25*b);
end

clear  cf2 cf1 goodness2 goodness1 

for i=1:length(smfact)
[Y,X]=hist(log(Data(smooth_ghi_fil{i})),700);
% [dip(i), p_value(i), xlow(i),xup(i)]=HartigansDipSignifTest(sort(log(Data(smooth_ghi_fil{i}))),500)
a=find(Y>10,1,'first');
Y=Y(a:end);
X=X(a:end);
[cf2{i},goodness2{i}]=createFit2gauss(X,Y/sum(Y));
[cf1{i},goodness1{i}]=createFit1gauss(X,Y/sum(Y));
hold on
end

for i=1:length(smfact)
rms{2}(i,1)=goodness1{i}.sse;
rms{2}(i,2)=goodness2{i}.sse;
rms{2}(i,3)=goodness1{i}.rsquare;
rms{2}(i,4)=goodness2{i}.rsquare;
rms{2}(i,5)=goodness1{i}.adjrsquare;
rms{2}(i,6)=goodness2{i}.adjrsquare;
rms{2}(i,7)=goodness1{i}.rmse;
rms{2}(i,8)=goodness2{i}.rmse;
a= coeffvalues(cf2{i});
% dipt{2}(i,1)=p_value(i);
% dipt{2}(i,2)=dip(i);
dist{2}(i,1)=abs(a(2)-a(5));
b=(a(3)-a(6))^2/(a(3)^2+a(6)^2);
dist{2}(i,2)=1-sqrt(2*a(3)*a(6)/(a(3)^2+a(6)^2))*exp(-0.25*b);
end

clear  cf2 cf1 goodness2 goodness1 

for i=1:length(smfact)
[Y,X]=hist(log(Data(smooth_ghi_hil{i})),700);
a=find(Y>10,1,'first');
Y=Y(a:end);
X=X(a:end);
% [dip(i), p_value(i), xlow(i),xup(i)]=HartigansDipSignifTest(sort(log(Data(smooth_ghi_hil{i}))),500)
[cf2{i},goodness2{i}]=createFit2gauss(X,Y/sum(Y));
[cf1{i},goodness1{i}]=createFit1gauss(X,Y/sum(Y));
hold on
end

for i=1:length(smfact)
rms{3}(i,1)=goodness1{i}.sse;
rms{3}(i,2)=goodness2{i}.sse;
rms{3}(i,3)=goodness1{i}.rsquare;
rms{3}(i,4)=goodness2{i}.rsquare;
rms{3}(i,5)=goodness1{i}.adjrsquare;
rms{3}(i,6)=goodness2{i}.adjrsquare;
rms{3}(i,7)=goodness1{i}.rmse;
rms{3}(i,8)=goodness2{i}.rmse;a= coeffvalues(cf2{i});
% dipt{3}(i,1)=p_value(i);
% dipt{3}(i,2)=dip(i);
dist{3}(i,1)=abs(a(2)-a(5));
b=(a(3)-a(6))^2/(a(3)^2+a(6)^2);
dist{3}(i,2)=1-sqrt(2*a(3)*a(6)/(a(3)^2+a(6)^2))*exp(-0.25*b);
end
save('diffmethods2.mat','rms','dist')
end



%% diff frequencies
smooth=500;
freq=[30 50;40 60; 50 70;60 80;70 90;80 100];
for m=4:5
    try
        cd(filename{m})
        clear PreEpoch
        load('BlbSpectrum.mat');
        load('StateEpochSB.mat');
        load(strcat(filename2{m},'LFPData/LFP',num2str(chB),'.mat'))
        load(strcat(filename2{m},'behavResources.mat'))
        load(strcat(filename2{m},'StateEpoch.mat'))
        
        try
            PreEpoch;
            Sleep=Or(REMEpoch,SWSEpoch);
            Sleep=CleanUpEpoch(Sleep);
            Sleep=Sleep-NoiseEpoch-GndNoiseEpoch;
            r=Range(LFP);
            Wake=intervalSet(0,r(end));
            Wake=Wake-Sleep;
            Wake=CleanUpEpoch(Wake);
            Wake=Wake-NoiseEpoch-GndNoiseEpoch;
            Wake=CleanUpEpoch(Wake);
            Wake=And(Wake,PreEpoch);
            Wake=CleanUpEpoch(Wake);
            Sleep=And(Sleep,PreEpoch);
            Sleep=CleanUpEpoch(Sleep);
            
            
        catch
            Sleep=Or(REMEpoch,SWSEpoch);
            Sleep=CleanUpEpoch(Sleep);
            Sleep=Sleep-NoiseEpoch-GndNoiseEpoch;
            r=Range(LFP);
            Wake=intervalSet(0,r(end));
            Wake=Wake-Sleep;
            Wake=CleanUpEpoch(Wake);
            Wake=Wake-NoiseEpoch-GndNoiseEpoch;
            Wake=CleanUpEpoch(Wake);
        end
        
        fB=SpectroB{3};
        tB=SpectroB{2};
        SpB=SpectroB{1};
        
        sptsd=tsd(tB*10000,SpB);
        sptsd=Restrict(sptsd,Epoch);
        for k=1:size(freq,1)
            fr=freq(k,:);
            startg=find(fB<fr(1),1,'last');
            stopg=find(fB>fr(2),1,'first');
            spdat=Data(sptsd);
            tot_ghi=tsd(Range(Restrict(sptsd,Epoch)),sum(spdat(:,startg:stopg)')');
            tot_ghi=Restrict(tot_ghi,Epoch);
            smooth_ghi=tsd(Range(tot_ghi),smooth(Data(tot_ghi),500));
            
            %% From Filtered Data
            
%             Filgamma=FilterLFP(LFP,fr,1024);
%             Hilgamma=hilbert(Data(Filgamma));
%             Hilgamma=tsd(Range(Filgamma),abs(Hilgamma));
%             Filgamma=tsd(Range(Filgamma),Data(Filgamma).^2);
            ratio(m,k)=mean(Data(Restrict(smooth_ghi,Sleep)))/mean(Data(Restrict(smooth_ghi,Wake)));
%             ratio{m,k}(2)=mean(Data(Restrict(Filgamma,Sleep)))/mean(Data(Restrict(smooth_ghi,Wake)));
%             ratio{m,k}(3)=mean(Data(Restrict(Hilgamma,Sleep)))/mean(Data(Restrict(smooth_ghi,Wake)));
            
        end
    end
end
% 
% h=figure;
% set(h,'color',[1 1 1],'Position',[1 1 1600 600])
% cc=hsv(3);
% for m=3:5
% for k=1:size(freq,1)
%     a(k)=ratio{m,k}(1);
%     b(k)=ratio{m,k}(2);
%     c(k)=ratio{m,k}(3);
% end
% subplot(131)
% plot( mean(freq'),a/min(a),'linewidth',2,'color',cc(m-2,:))
% hold on
% subplot(132)
% plot( mean(freq'),b/min(b),'linewidth',2,'color',cc(m-2,:))
% hold on
% subplot(133)
% plot( mean(freq'),c/min(c),'linewidth',2,'color',cc(m-2,:))
% hold on
% end
% 
