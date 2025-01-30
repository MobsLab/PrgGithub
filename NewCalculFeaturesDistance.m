function [d,LR,features]=NewCalculFeaturesDistance(tetrodeNumber,Epoch,NumSortedUnit,plo,idxCh)

try
    idxCh;
catch
    idxCh=0;
end

try
    tetrodeNumber;
catch
    tetrodeNumber=2;
end

try
    plo;
catch
    plo=1;
end

load SpikeData cellnames

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
numNeurons2=length(cellnames)+1;    
end

nclu=[numNeurons1:numNeurons2-1];



% try
%     W;
% catch
%load Waveforms
try
load Waveforms2
W;
catch
load Waveforms
end
% end

% try
if length(idxCh)==4
for i=nclu  
 W2{i}=W{i}(:,sort(idxCh),:);      
end
W=W2;
end
% catch
%     keyboard
% end




clear wfo

a=1;
for i=nclu
    wfo{a}=PlotWaveforms(W,i,Epoch);close
    a=a+1;
end

A=wfo{1};
CluId=ones(length(wfo{1}),1);

for i=2:length(nclu)
      le=size(A,1); 
    A(le+1:le+1+size(wfo{i},1)-1,:,:)=wfo{i};
    CluId=[CluId;i*ones(size(wfo{i},1),1)];
    %size(A,1)-size(CluId,1)
end

spikes=A;
CalculFeaturesSpikesMClust

NbClu=length(unique(CluId));


%par=PeakData;
%par=wavePCData;

if plo
    
par=energyData;

figure('color',[1 1 1])
for i=1:size(par,2)
    for j=1:size(par,2)
        for k=1:NbClu           
            subplot(size(par,2),size(par,2),MatXY(i,j,size(par,2))), hold on, plot(par(find(CluId==k),i),par(find(CluId==k),j),'.','color',[k/NbClu (NbClu-k)/NbClu 0]);
            
            try
                NumSortedUnit;
            if k==NumSortedUnit
                subplot(size(par,2),size(par,2),MatXY(i,j,size(par,2))), hold on, plot(par(find(CluId==k),i),par(find(CluId==k),j),'k.');
            end
            end
        end
    end
    
end
subplot(size(par,2),size(par,2),1), title('energyData') 


par=energyData2;

figure('color',[1 1 1])
for i=1:size(par,2)
    for j=1:size(par,2)
        for k=1:NbClu           
            subplot(size(par,2),size(par,2),MatXY(i,j,size(par,2))), hold on, plot(par(find(CluId==k),i),par(find(CluId==k),j),'.','color',[k/NbClu (NbClu-k)/NbClu 0]);
            
            try
                NumSortedUnit;
            if k==NumSortedUnit
                subplot(size(par,2),size(par,2),MatXY(i,j,size(par,2))), hold on, plot(par(find(CluId==k),i),par(find(CluId==k),j),'k.');
            end
            end
        end
    end
    
end
subplot(size(par,2),size(par,2),1), title('energyData2') 



par=wavePCData;

figure('color',[1 1 1])
for i=1:size(par,2)
    for j=1:size(par,2)
        for k=1:NbClu           
            subplot(size(par,2),size(par,2),MatXY(i,j,size(par,2))), hold on, plot(par(find(CluId==k),i),par(find(CluId==k),j),'.','color',[k/NbClu (NbClu-k)/NbClu 0]);
            
            try
                NumSortedUnit;
            if k==NumSortedUnit
                subplot(size(par,2),size(par,2),MatXY(i,j,size(par,2))), hold on, plot(par(find(CluId==k),i),par(find(CluId==k),j),'k.');
            end
            end
        end
    end
    
end
subplot(size(par,2),size(par,2),1), title('WavePCData') 


par=PeakData;

figure('color',[1 1 1])
for i=1:size(par,2)
    for j=1:size(par,2)
        for k=1:NbClu           
            subplot(size(par,2),size(par,2),MatXY(i,j,size(par,2))), hold on, plot(par(find(CluId==k),i),par(find(CluId==k),j),'.','color',[k/NbClu (NbClu-k)/NbClu 0]);
            
            try
                NumSortedUnit;
            if k==NumSortedUnit
                subplot(size(par,2),size(par,2),MatXY(i,j,size(par,2))), hold on, plot(par(find(CluId==k),i),par(find(CluId==k),j),'k.');
            end
            end
        end
    end
    
end
subplot(size(par,2),size(par,2),1), title('PeakData') 



par=PeakData3;

figure('color',[1 1 1])
for i=1:size(par,2)
    for j=1:size(par,2)
        for k=1:NbClu           
            subplot(size(par,2),size(par,2),MatXY(i,j,size(par,2))), hold on, plot(par(find(CluId==k),i),par(find(CluId==k),j),'.','color',[k/NbClu (NbClu-k)/NbClu 0]);
            
            try
                NumSortedUnit;
            if k==NumSortedUnit
                subplot(size(par,2),size(par,2),MatXY(i,j,size(par,2))), hold on, plot(par(find(CluId==k),i),par(find(CluId==k),j),'k.');
            end
            end
        end
    end
    
end
subplot(size(par,2),size(par,2),1), title('PeakData3') 


par=PeakDataMi;

figure('color',[1 1 1])
for i=1:size(par,2)
    for j=1:size(par,2)
        for k=1:NbClu           
            subplot(size(par,2),size(par,2),MatXY(i,j,size(par,2))), hold on, plot(par(find(CluId==k),i),par(find(CluId==k),j),'.','color',[k/NbClu (NbClu-k)/NbClu 0]);
            
            try
                NumSortedUnit;
            if k==NumSortedUnit
                subplot(size(par,2),size(par,2),MatXY(i,j,size(par,2))), hold on, plot(par(find(CluId==k),i),par(find(CluId==k),j),'k.');
            end
            end
        end
    end
    
end
subplot(size(par,2),size(par,2),1), title('PeakDataMi') 


par=PeakDataMa;

figure('color',[1 1 1])
for i=1:size(par,2)
    for j=1:size(par,2)
        for k=1:NbClu           
            subplot(size(par,2),size(par,2),MatXY(i,j,size(par,2))), hold on, plot(par(find(CluId==k),i),par(find(CluId==k),j),'.','color',[k/NbClu (NbClu-k)/NbClu 0]);
            
            try
                NumSortedUnit;
            if k==NumSortedUnit
                subplot(size(par,2),size(par,2),MatXY(i,j,size(par,2))), hold on, plot(par(find(CluId==k),i),par(find(CluId==k),j),'k.');
            end
            end
        end
    end
    
end
subplot(size(par,2),size(par,2),1), title('PeakDataMa') 



figure('color',[1 1 1])
for k=1:NbClu           
             hold on, plot(PeakMinData(find(CluId==k)),PeakMaxData(find(CluId==k)),'.','color',[k/NbClu (NbClu-k)/NbClu 0]);     
            try
                NumSortedUnit;
            if k==NumSortedUnit
                hold on, plot(PeakMinData(find(CluId==k)),PeakMaxData(find(CluId==k)),'k.');
            end
            end
end
        title('PeakMinData, PeakMaxData')


end


features=[[1:length(CluId)]' tetrodeNumber*ones(length(CluId),1) CluId energyData energyData2  PeakData PeakData3 PeakDataMi PeakDataMa PeakMinData',PeakMaxData'];

[d,LR] = IsolationDistance(features);

