%test2

% LFPa{1}=LFPt{16}; %auditory cortex
% LFPa{2}=LFPt{18}; % Pfc
% LFPa{3}=LFPt{21}; % hpc
% LFPa{4}=LFPt{22}; % hpc
% LFPa{5}=LFPt{5}; %bulb
% LFPa{6}=LFPt{19}; %pfc 

numLFP=2;
resamfac=20;

EpochOK=SWSEpoch;
%EpochOK=REMEpoch;

if length(Start(REMEpoch))>20
    inter=5;
else
    inter=1;
end

    
clear val
clear S2
clear f2

params.Fs=1250;
params.fpass = [0 40];
params.err = [2, 0.95];
params.trialave = 0;

params.pad=1;
params.tapers=[3,5];
movingwin = [1, 0.05];


a=1;
for i=1:100
    try
[S2{i},f2{i},Serr2]=mtspectrumc(Data(Restrict(LFPt{numLFP},subset(EpochOK,a:a+inter))),params);
 val{i}=tsd(sort(resample(f2{i},1,resamfac)),SmoothDec(resample(S2{i},1,resamfac),5));
 a=a+inter;
    end
end


figure('color',[1 1 1]), hold on
for i=1:100
    try
%    plot(f2{i},SmoothDec(S2{i},100),'color',[i/30 (30-i)/30,0])
    plot(resample(f2{i},1,20),10*log10(SmoothDec(resample(S2{i},1,resamfac),5)),'color',[i/30 (30-i)/30,0],'linewidth',2)
   
    end
end
xlim([0 35])

tref=ts(sort(resample(f2{1},1,resamfac)));
% Smean1=zeros(length(tref),1);
Smean1=[];
a=1;
for i=1:floor(length(val)/2)
%     try
Smean1=[Smean1;Data(Restrict(val{i},tref))'];
a=a+1;
%     end
end

% Smean2=zeros(length(tref),1);
Smean2=[];
b=1;
for i=floor(length(val)/2)+1:floor(length(val))
    try
Smean2=[Smean2;Data(Restrict(val{i},tref))'];
b=b+1;
    end
end

smo=5;
figure, plot(Data(tref),SmoothDec(mean(Smean1),smo),'k'), hold on, plot(Data(tref),SmoothDec(mean(Smean2),smo),'r','linewidth',2), xlim([0 35])
figure, plot(Data(tref),10*log10(SmoothDec(mean(Smean1),smo)),'k'), hold on, plot(Data(tref),10*log10(SmoothDec(mean(Smean2),smo)),'r','linewidth',2), xlim([0 35])

[h,p]=ttest2(Smean1,Smean2);
figure, plot(Data(tref),p)

[h,p]=ttest2(10*log10(Smean1),10*log10(Smean2));
figure, plot(Data(tref),p)



figure, subplot(2,1,1),imagesc(Data(tref),[1:size(Smean1,1)],Smean1),caxis([0 1E5]), subplot(2,1,2), imagesc(Data(tref),[1:size(Smean1,1)],Smean2),caxis([0 1E5])

figure, subplot(2,1,1),imagesc(Data(tref),[1:size(Smean1,1)],SmoothDec((Smean1),[0.001,smo])),caxis([0 1E5]), subplot(2,1,2), imagesc(Data(tref),[1:size(Smean1,1)],SmoothDec((Smean2),[0.001,smo])),caxis([0 1E5])


figure, subplot(2,1,1),imagesc(Data(tref),[1:size(Smean1,1)],SmoothDec(10*log10(Smean1),[0.001,smo])), subplot(2,1,2), imagesc(Data(tref),[1:size(Smean1,1)],SmoothDec(10*log10(Smean2),[0.001,smo]))


