%CompMMNSkullTotal



%cd /Users/karimbenchenane/Documents/Data/DataEnCours/MiceSetUp/MMN/DataMMN

nbManipes=12;

for ki=1:nbManipes
eval(['load behavResources',num2str(ki)]) 
eval(['load LFPData',num2str(ki)]) 

disp(' ')
disp(['Manipe ',num2str(ki)])
disp(' ')
MMNSkull

eval(['a',num2str(ki),'=a;'])
eval(['b',num2str(ki),'=b;'])
eval(['c',num2str(ki),'=c;'])
eval(['d',num2str(ki),'=d;'])
eval(['e',num2str(ki),'=e;'])
eval(['f',num2str(ki),'=f;'])

eval(['MMN',num2str(ki),'=MMN;'])
eval(['sda',num2str(ki),'=sda;'])

eval(['save stim',num2str(ki),' sda MMN'])

end



LFPnames{1}='Prefrontal Cortex, superfical layer';
LFPnames{2}='Prefrontal Cortex, superfical layer';
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


figure('color',[1 1 1]),  hold on

for ki=1:15
    
subplot(5,3,ki), hold on
   

plot(c1{ki},a1{ki},'color','k','linewidth',2)
plot(f4{ki},d4{ki},'color','r','linewidth',2)
title(LFPnames{ki})
ylim([-350 350])
end



for li=1:nbManipes
    
figure('color',[1 1 1]),  hold on

for ki=1:15
    
subplot(5,3,ki), hold on
   
eval(['x1=c',num2str(li),';'])
eval(['x2=f',num2str(li),';'])
eval(['y1=a',num2str(li),';'])
eval(['y2=d',num2str(li),';'])

plot(x1{ki},y1{ki},'color','k','linewidth',1)
plot(x2{ki},y2{ki},'color','r','linewidth',1)
title(LFPnames{ki})
ylim([-350 350])
end
end


X1=[];
X2=[];
Y1=[];
Y2=[];

for ki=1:15
figure('color',[1 1 1]),  hold on
    
for li=1:nbManipes
    
eval(['x1=c',num2str(li),';'])
eval(['x2=f',num2str(li),';'])
eval(['y1=a',num2str(li),';'])
eval(['y2=d',num2str(li),';'])

if length(find(isnan(y1{ki})))<10
X1=[X1,x1{ki}];
Y1=[Y1,y1{ki}];
end

if length(find(isnan(y2{ki})))<10
X2=[X2,x1{ki}];
Y2=[Y2,y2{ki}];
end


plot(x1{ki},y1{ki},'color',[0 li/nbManipes (nbManipes-li)/nbManipes],'linewidth',1)
plot(x2{ki},y2{ki},'color',[li/nbManipes 0 (nbManipes-li)/nbManipes],'linewidth',1)
title(LFPnames{ki})
yl=ylim;
line([0 0],[yl(1) yl(2)],'color','k')
ylim([-350 350])
xlim([-50 400])
end
end


if 0

    tps=x1{1};

    A=[Y1,Y2]';
    A=Y1';
    A=Y2';

    [r1,p1]=corrcoef(A);

    figure('color',[1 1 1]),  hold on
    imagesc(tps,tps,r1)
    line([0 0],[tps(1) tps(end)],'color','k')
    line([tps(1) tps(end)],[0 0],'color','k')

    ylim([-400 400])
    xlim([-400 400])




    B=[Y1,Y2];
    B=Y1;
    B=Y2;

    [r2,p2]=corrcoef(B);

    figure('color',[1 1 1]), 
    imagesc(r2)

    % ylim([1 180])
    % xlim([1 180])

end



