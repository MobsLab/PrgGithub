%CompMMNSkull



cd /Users/karimbenchenane/Documents/Data/DataEnCours/MiceSetUp/MMN/DataMMN

LFPnames{1}='Prefrontal Cortex, superfical layer';
LFPnames{2}='g:std XXx,  k: std XXy ;  r: dev XXy ;  b: std XYx;  m: dev XYx';
LFPnames{3}='Prefrontal Cortex, superfical layer';
LFPnames{4}='Prefrontal Cortex, superfical layer';

LFPnames{5}='Parietal Cortex, EEG';
LFPnames{6}='Parietal Cortex, ECog';
LFPnames{7}='Parietal Cortex, deep layer';
LFPnames{8}='Parietal Cortex, deep layer';
LFPnames{9}='Parietal Cortex, deep layer';

LFPnames{10}='Auditory Cortex, EEG';
LFPnames{11}='Auditory Cortex, ECog';
LFPnames{12}='Auditory Cortex, deep layer';
LFPnames{13}='Auditory Cortex, deep layer';
LFPnames{14}='Auditory Cortex, superficial layer';
LFPnames{15}='Auditory Cortex, superficial layer';

load behavResources1
load LFPData1
clear a
clear b
clear c



ref=1;
thLFP=2000;


id=diff(tp1);
std=tp1(id>0.5);

std=ts(std*1E4);

badEpochUp=thresholdIntervals(LFP{ref},thLFP,'Direction','Above');
badEpochDown=thresholdIntervals(LFP{ref},-thLFP,'Direction','Below');
badEpoch=or(badEpochUp,badEpochDown);
badEpoch=mergeCloseIntervals(badEpoch,2000);
badEpoch=dropShortIntervals(badEpoch,1000);



clear tdebtemp
clear tfintemp
for i=1:length(Start(badEpoch));
tdebtemp(i)=Start(subset(badEpoch,i))-0.3E4;    
tfintemp(i)=End(subset(badEpoch,i))+0.5E4;    
end
badEpoch=intervalSet(unique(tdebtemp),unique(tfintemp));
badEpoch=mergeCloseIntervals(badEpoch,100);
rg=Range(LFP{1});

std=Restrict(std,intervalSet(rg(1),rg(end))-badEpoch);
std=Range(std,'s');

%std=std(length(std)/2:end);

for i=1:15
%     LFP{i}=FilterLFP(LFP{i},[1 200],1024);
    LFP{i}=CleanLFP(LFP{i},[-2000 2000]);
end


for i=1:15
   [a{i},b{i},c{i}] = mETAverage(std*1E4,Range(LFP{i}),Data(LFP{i}),1,1000);
end
a1=a;
b1=b;
c1=c;

std1=std;
nstd1=length(std1);

disp(' ')
disp(['std, n=',num2str(length(std1))])
disp(' ')


save stim1 std



load behavResources2
load LFPData2

MMNSkull

a2=a;
b2=b;
c2=c;
d2=d;
e2=e;
f2=f;
std2=std;
MMN2=MMN;
nstd2=length(std2);
nmmn2=length(MMN2);


save stim2 std MMN


load behavResources3
load LFPData3

MMNSkull

a3=a;
b3=b;
c3=c;
d3=d;
e3=e;
f3=f;
std3=std;
MMN3=MMN;
nstd3=length(std3);
nmmn3=length(MMN3);

save stim3 std MMN


LFPnames{2}='g:std XXx,  k: std XXy ;  r: dev XXy ;  b: std XYx;  m: dev XYx';
smo=1;

figure('color',[1 1 1]),  hold on

for i=1:15
    
subplot(5,3,i), hold on
   
   
try
plot(smooth(c1{i},smo),smooth(a1{i},smo),'color',[0.5 0.5 0.5],'linewidth',2)
plot(smooth(c2{i},smo),smooth(a2{i},smo),'color','k','linewidth',2)
plot(smooth(c3{i},smo),smooth(a3{i},smo),'color','b','linewidth',1)
end

try
plot(smooth(f2{i},smo),smooth(d2{i},smo),'color','r','linewidth',1)
plot(smooth(f3{i},smo),smooth(d3{i},smo),'color','m','linewidth',1)
end

line([-50 400],[0 0],'color','k')

yl=ylim;
line([0 0],[yl(1) yl(2)],'color','k')

xlim([-50 400])
ylim([-350 350])

title(LFPnames{i})
end
