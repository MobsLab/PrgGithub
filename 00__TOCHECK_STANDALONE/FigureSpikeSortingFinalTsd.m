function [dF,LRF,featuresF,d,LR,Res,Res2,Fi,ID,hf,bf,bi,h,H,h2,hb,hc,DetectedSpike,FalseDetectedSpike,DetectedSpikeAll,FalseDetectedSpikeAll]=FigureSpikeSortingFinalTsd(tetrodeNumber,NumSortedUnit,PeriodSpikeSorting,ana)
%
%
% FigureSpikeSortingFinalTsd(tetrodeNumber,NumSortedUnit,PeriodSpikeSorting,ana)
%

if 0
close all
end

%--------------------------------------------------------------------------
%% Parameters-------------------------------------------------------------
%--------------------------------------------------------------------------

% 
% tetrodeNumber=2;
% PeriodSpikeSorting=[1:4];
% NumSortedUnit=6;


%--------------------------------------------------------------------------
%% Parameters-------------------------------------------------------------
%--------------------------------------------------------------------------

try
    ana;
catch
    ana=1;
end

plo=1;
DoIsolationDistance=0;
DoWaveforms=0;
dis=0.0008;
% dis=0.0015;

%--------------------------------------------------------------------------
%% ------------------------------------------------------------------------
%--------------------------------------------------------------------------


load behavResources

try
load SpikeData2
S;
catch
load SpikeData
end

%namePos'


NumTet=[];
a=1;
j=str2num(cellnames{1}(3));
for i=1:length(cellnames)
    try
        if cellnames{i}(3)==num2str(j)
            NumTet(a,1)=i;
            NumTet(a,2)=j;
            a=a+1;
            j=j+1;
        end
    end 
end 


numNeurons1=NumTet(find(NumTet(:,2)==tetrodeNumber),1);
numNeurons2=NumTet(find(NumTet(:,2)==tetrodeNumber+1),1);
if length(numNeurons2)<1
numNeurons2=length(S)+1;    
end

numNeurons=[numNeurons1:numNeurons2-1];


for i=1:length(PeriodSpikeSorting)
    Epoch1=intervalSet(tpsdeb{PeriodSpikeSorting(i)}*1E4,tpsfin{PeriodSpikeSorting(i)}*1E4);
    try
        Epoch=or(Epoch,Epoch1);
    catch
        Epoch=Epoch1;
    end
end

stim1=Restrict(stim,Epoch);
st=Range(stim1,'s');
%dis=0.001;

ID=[];
cont=0;
clear id
for i=1:length(st)  
    pb=0;
    for j=numNeurons
        clear rg
        rg=Range(S{j},'s');
        clear id
        id=find(abs(st(i)-rg)<dis);
        if length(id)==1
            ID=[ID;[id rg(id) j*ones(length(id),1) i*ones(length(id),1) length(id)*ones(length(id),1)]];
            pb=1; 
        elseif length(id)>1 
            [Cond,Loc]=ismember(NumSortedUnit,id);
            if Cond
                ID=[ID;[id(Loc) rg(id(Loc)) j*ones(length(id(Loc)),1) i*ones(length(id(Loc)),1) length(id(Loc))*ones(length(id(Loc)),1)]];
            pb=1; 
            else
                ID=[ID;[id rg(id) j*ones(length(id),1) i*ones(length(id),1) length(id)*ones(length(id),1)]];
                pb=1; 
            end
        end  


    end
    if pb==0
        cont=cont+1;
    end
    
end

% ID=[];
% cont=0;
% clear id
% for i=1:length(st)  
%     pb=0;
%     for j=numNeurons
%         clear rg
%         rg=Range(S{j},'s');
%         clear id
%         id=find(abs(st(i)-rg)<dis);
%         if length(id)>0
%              ID=[ID;[id rg(id) j*ones(length(id),1) i*ones(length(id),1) length(id)*ones(length(id),1)]];
%              pb=1;     
%         end
%         
%     end
%     if pb==0
%         cont=cont+1;
%     end
%     
% end

positi=length(find((ID(:,3))==NumSortedUnit));
Percpositi=positi/length(st);
falsepositive=length(find((ID(:,3))~=NumSortedUnit));
Percfalsepositive=falsepositive/length(st);


Res(1)=positi;
Res(2)=Percpositi;
Res(3)=falsepositive;
Res(4)=Percfalsepositive;
Res(5)=cont;
Res(6)=length(st);
%Res(7)=length(Range(Restrict(S{NumSortedUnit},Epoch))); 

[h,b]=hist(ID(:,3),numNeurons);
figure, 
subplot(2,2,1), hold on
bar(b,h,1,'facecolor','k')
bar(b(1)-1,cont,1,'facecolor','r'), title([num2str(length(st)),' detections, ',num2str(cont),' missed'])
[BE,idx]=max(h);

bf=[b(1)-1,b];
hf=[cont,h];

temp1=1:length(hf);
A=hf(NumSortedUnit+1);
B=hf(2);
C=(sum(hf)-hf(NumSortedUnit+1)-hf(1)-hf(2))/(length(b)-2);
D=hf(1);
E=(sum(hf)-hf(NumSortedUnit+1)-hf(1)-hf(2));
F=max(hf(find(temp1>2&temp1~=NumSortedUnit+1)));

Res2=[A,B,C,D,E,F];

subplot(2,2,2),
pie([A,B,C,D])

subplot(2,2,4),
pie([A,B,C])


%load Waveforms
%PlotWaveforms(W,b(idx),Epoch);

%iid=find(NumTet(:,2)==tetrodeNumber);
%PlotWaveforms(W,NumTet(iid,1)+NumSortedUnit-1,Epoch);
clear W
% load Waveforms
try
load Waveforms2
W;
catch
load Waveforms
end


wfo=PlotWaveforms(W,b(idx),Epoch,0);
for i=1:size(wfo,2)
    temp(i,:)=mean(squeeze(wfo(:,i,:)));
end
temp2=temp(:,14);
[BE,id]=min(temp2);

bin=[-4000:10:100];
[h,bi]=hist(squeeze(wfo(:,id,14)),bin);
% figure, plot(bi,h), title('Detected neuron')
wfo1=PlotWaveforms(W,b(1),Epoch,0);
[h2,bi]=hist(squeeze(wfo1(:,id,14)),bin);
% figure, plot(bi,h2), title(num2str(1))    
H=zeros(1,length(bin));
    
for i=2:length(b)
    if i~=idx
        try
            wfo1=PlotWaveforms(W,b(i),Epoch,0);
            [htemp,bi]=hist(squeeze(wfo1(:,id,14)),bin);
        %     figure, plot(bi,h2), title(num2str(i))
            H=H+htemp;
        end
    end
    
end
%figure('color',[1 1 1])

i1=1;
i2=1;
for i=1:size(ID,1)
    rg=Range(S{ID(i,3)},'s');
    id2=find(rg==ID(i,2));
%     wfo=PlotWaveforms(W,ID(i,3),Epoch,0);
%     for i=1:size(wfo,2)
%         DetectedSpike(i,1:32)=squeeze(wfo(id2,id,:));
        if ID(i,3)==b(NumSortedUnit)
            DetectedSpike(i1,1:32)=squeeze(W{ID(i,3)}(id2,id,:));
            NumDetectedSpike(i1)=ID(i,3);
            for k=1:size(W{ID(i,3)},2)
            DetectedSpikeAll(i1,k,:)=squeeze(W{ID(i,3)}(id2,k,:));
            end
            i1=i1+1;
        else
            FalseDetectedSpike(i2,1:32)=squeeze(W{ID(i,3)}(id2,id,:));
            NumFalseDetectedSpike(i2)=ID(i,3);
            for k=1:size(W{ID(i,3)},2)
            FalseDetectedSpikeAll(i2,k,:)=squeeze(W{ID(i,3)}(id2,k,:));
            end
            i2=i2+1;
        end
        
         %pause(3)
%     end
%     NoDetectedSpike(i)=ID(i,3);
end

numfig=gcf;

figure('color',[1 1 1]),hold on, 
plot(DetectedSpike','k')
hold on, plot(FalseDetectedSpike','r')
title(pwd)

figure('color',[1 1 1]),hold on, 
for i=1:size(DetectedSpikeAll,2)
subplot(size(DetectedSpikeAll,2),1,i), hold on
    plot(4000+squeeze(DetectedSpikeAll(:,i,1:32))','k')
    plot(squeeze(DetectedSpikeAll(:,i,1:32))','k')
    plot(squeeze(FalseDetectedSpikeAll(:,i,1:32))','r')
end
subplot(size(DetectedSpikeAll,2),1,1),
title([num2str(size(DetectedSpikeAll,1)),' vs. ', num2str(size(FalseDetectedSpikeAll,1)),' ',pwd])



[hb,bi]=hist(DetectedSpike(:,14),bin);
[hc,bi]=hist(FalseDetectedSpike(:,14),bin);

figure(numfig)
subplot(2,2,3), hold on
plot(bi,H,'k','linewidth',2)
plot(bi,h,'r','linewidth',2)
plot(bi,hb,'b','linewidth',2)
ylim([0 3*max(h)])




if ana
    
%     [dF,LRF,featuresF]=NewCalculFeaturesDistance(tetrodeNumber,Epoch,NumSortedUnit,0);
% 
%     [d,LR] = IsolationDistance(featuresF(find(featuresF(:,3)>1),:));

    
    
                if size(W{1},2)<=4

                [dF,LRF,featuresF]=NewCalculFeaturesDistance(tetrodeNumber,Epoch,NumSortedUnit,0);

                [d,LR] = IsolationDistance(featuresF(find(featuresF(:,3)>1),:));

                else

                 b=1;
                 
                for i=0:size(W{1},2)-1, B=circshift([1:size(W{1},2)]',i);

                    try
                    [dF2{b},LRF2{b},featuresF2{b}]=NewCalculFeaturesDistance(tetrodeNumber,Epoch,NumSortedUnit,0,B(1:4));

                    [d2{b},LR2{b}] = IsolationDistance(featuresF2{b}(find(featuresF2{b}(:,3)>1),:));

                    
                    catch
                        
                       dF2{b}=0;
                       LRF2{b}=0;
                       featuresF2{b}=0;
                       d2{b}=0;
                       LR2{b}=0;
                       
                    end
                    
                    try
                        dFtemp(b,:)=[(dF2{b}(NumSortedUnit-1)),(d2{b}(NumSortedUnit-1)),(LRF2{b}(NumSortedUnit-1)),(LR2{b}(NumSortedUnit-1))];
                    catch
                        dFtemp(b,:)=[0 0 0 0];
                    end
                    
                    b=b+1;
                end

                [BE,idDF]=max(dFtemp(:,2));

                dF=dF2{idDF};
                LRF=LRF2{idDF};
                featuresF=featuresF2{idDF};
                d=d2{idDF};
                LR=LR2{idDF};

                end




    
    
    disp(' ')
    disp([num2str(dF(NumSortedUnit-1)),' ',num2str(d(NumSortedUnit-1)),' ',num2str(LRF(NumSortedUnit-1)),' ',num2str(LR(NumSortedUnit-1))])
    disp(' ')

    Fi=[(dF(NumSortedUnit-1)),(d(NumSortedUnit-1)),(LRF(NumSortedUnit-1)),(LR(NumSortedUnit-1))];

else
    
    dF=0;
    LRF=0;
    featuresF=0;
    d=0;
    LR=0;
    Fi=0;
end

% [h1,b1]=hist(clu(ID(:,1)),0:length(S)-1);
% [BE,idx]=max(h1);
% [h2,b2]=hist(ID(:,5),0:length(S));
% 
% figure('color',[1 1 1]),
% subplot(2,1,1), bar(b1,h1,1), %title(['False positive: ',num2str(falsepositive),'   (',num2str(floor(10*falsepositive/length(st)*100)/10),'%)']);
% subplot(2,1,2), bar(b2,h2,1),% title(['False negative: ',num2str(cont),'   (',num2str(floor(10*cont/length(st)*100)/10),'%)']);


% figure('color',[1 1 1]),
% subplot(2,1,1), bar(b1,h1,1), %title(['False positive: ',num2str(falsepositive),'   (',num2str(floor(10*falsepositive/length(st)*100)/10),'%)']);
% subplot(2,1,2), bar(b2,h2,1),% title(['False negative: ',num2str(cont),'   (',num2str(floor(10*cont/length(st)*100)/10),'%)']);


