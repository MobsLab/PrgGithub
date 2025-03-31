% script to generate a reference iamge without mouse
% 23.09.2016

%res='/media/DataMobs31/OPTO_CHR2_DATA/behavior_matlab/FEAR-Mouse-367-14072016-01-HABenvC-4Hz/F14072016-0001';
res='/media/DataMobs31/OPTO_CHR2_DATA/behavior_matlab/FEAR-Mouse-363-14072016-01-HABenvBraye-10Hz/F14072016-0001';
i=30; % i< 10
j=55;% j>10
load([ res '/frame0000' num2str(i) '.mat'])
a1=datas.image;
figure, imagesc(datas.image);, title(['frame00000' num2str(i)  ])
load([ res '/frame0000' num2str(j) '.mat'])
a2=datas.image;
figure, imagesc(datas.image), title(['frame00000' num2str(j) ])


% coupure horizontale
coupure=150;

%figure, imagesc(a2+a2)
figure, imagesc([a1(1:coupure,:);a2(coupure+1:end,:)])
figure, imagesc([a2(1:coupure,:);a1(coupure+1:end,:)])
%datas.image=[a2(1:coupure,:);a1(coupure+1:end,:)];
datas.image=[a1(1:coupure,:);a2(coupure+1:end,:)];
 


load([res '/frame000001.mat']);
save frame000001sauvegarde.mat datas
datas.image=[a1(1:coupure,:);a2(coupure+1:end,:)];
save frame000001.mat datas

save GenerateImageRefWithoutMouse