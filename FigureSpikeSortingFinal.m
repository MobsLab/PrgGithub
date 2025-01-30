function [ID,clu,spk,dF,LRF,featuresF,w,WaveFT,PeakMinData,PeakMaxData, PeakDataMi,PeakDataMa]=FigureSpikeSortingFinal(tetrodeNumber,PeriodSpikeSorting,NumSortedUnit,DoWaveforms,DoIsolationDistance,plo)


%--------------------------------------------------------------------------
%% Parameters-------------------------------------------------------------
%--------------------------------------------------------------------------

try
    tetrodeNumber;
catch
    tetrodeNumber=1;
end
try
    PeriodSpikeSorting;
catch
    PeriodSpikeSorting=[1];
end
try
    NumSortedUnit;
catch
    NumSortedUnit=6;
end

%--------------------------------------------------------------------------
%% Parameters-------------------------------------------------------------
%--------------------------------------------------------------------------

try
    plo;
catch
plo=1;
end

try
    DoIsolationDistance;
catch
    DoIsolationDistance=0;
end

try
    DoWaveforms;
catch
    DoWaveforms=0;
end
dis=0.0008;


%--------------------------------------------------------------------------
%% ------------------------------------------------------------------------
%--------------------------------------------------------------------------

tic

%SetCurrentSession
load behavResources

list=dir;
for i=1:length(list)
    try
        lelist=length(list(i).name);
        if list(i).name(lelist-5:lelist)==['.clu.',num2str(tetrodeNumber)]&list(i).name(1)=='I';
            SetCurrentSession([list(i).name(1:lelist-6),'.xml'])
            clu=load(list(i).name);
            list(i).name
        end

    end
end

% ICSS-Mouse-26-11012012.clu.1
%clu=load('ICSS-Mouse-26-11012012.clu.1');

clu(1)=[];
%clu(clu==6)=5;

nbClu=length(unique(clu));
disp(' ')
disp(['Nombre de clusters: ',num2str(nbClu)])
disp(' ')

spk=GetSpikes([tetrodeNumber -1]);
features = GetSpikeFeatures(tetrodeNumber);
%features(features(:,3)==6,3)=5;


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

Wo = GetSpikeWaveforms([tetrodeNumber NumSortedUnit],'intervals',[Start(Epoch,'s') End(Epoch,'s')]);
PlotWaveforms({Wo},1,Epoch);title('sorted unit');


ID=[];
cont=1;
clear id

for i=1:length(st)
    
    clear id
    id=find(abs(st(i)-spk)<dis);
    if length(id)==1
        ID=[ID;[id spk(id) clu(id) i*ones(length(id),1) length(id)*ones(length(id),1)]];
    elseif length(id)>1  
        [Cond,Loc]=ismember(NumSortedUnit,id);
        if Cond
            ID=[ID;[id(Loc) spk(id(Loc)) clu(id(Loc)) i*ones(length(id(Loc)),1) length(id(Loc))*ones(length(id(Loc)),1)]];
        else
            ID=[ID;[id spk(id) clu(id) i*ones(length(id),1) length(id)*ones(length(id),1)]];
        end
        
    else
        cont=cont+1;
    end
end
 

[h1,b1]=hist(clu(ID(:,1)),0:nbClu);
[BE,idx]=max(h1);
[h2,b2]=hist(ID(:,5),0:nbClu);

falsepositive=length(find(clu(ID(:,1))~=NumSortedUnit));
Percfalsepositive=falsepositive/length(st);
 
 
%% fig 1
figure('color',[1 1 1]),
 subplot(2,1,1), bar(b1,h1,1), title(['False positive: ',num2str(falsepositive),'   (',num2str(floor(10*falsepositive/length(st)*100)/10),'%)']);
 subplot(2,1,2), bar(b2,h2,1), title(['False negative: ',num2str(cont),'   (',num2str(floor(10*cont/length(st)*100)/10),'%)']);
 
 
 if DoIsolationDistance
 
 %%
        [d1,LRatio1] = IsolationDistance(features);

        cl2=clu;
        spk2=spk;

        clu2(ID(:,1))=max(clu)+1;

        if 0
                features2=features;
                features2(ID(:,1),3)=max(clu)+1;
        else
                features2=features;
                clu2(ID(ID(:,3)==NumSortedUnit,1))=max(clu)+1;
                features2(ID(ID(:,3)==NumSortedUnit,1),3)=max(clu)+1;
        end


        features3=features2;
        features3(features3(:,3)==0,:)=[];
        features3(features3(:,3)==1,:)=[];

        features4=features3;
        features4(features4(:,3)==NumSortedUnit,:)=[];

        [d2,LRatio2] = ComputeOnceMahal(features4,[tetrodeNumber max(clu)+1]);

        [d3,LRatio3] = IsolationDistance(features2,'units',[tetrodeNumber NumSortedUnit]);

        %unit=[[1 2];[1 3];[1 4];[1 5];[1 6]];
        unit=[tetrodeNumber*ones(nbClu,1),[0:nbClu-1]'];

        [d4,LRatio4] = IsolationDistance(features2,'units',unit);

        unit=[tetrodeNumber*ones(nbClu+1,1),[0:nbClu]'];
        unit(NumSortedUnit+1,:)=[];
        [d5,LRatio5] = IsolationDistance(features2,'units',unit);


        %% fig 2
%         a=4;b=11;
        % b=b+1;figure(4),clf, plot(features2(:,a),features2(:,b),'k.'),hold on, plot(features2(features2(:,3)==6,a),features2(features2(:,3)==6,b),'bo'), plot(features2(features2(:,3)==7,a),features2(features2(:,3)==7,b),'o','markerfacecolor','r')
%          b=b+1;
         
         
         for kj=1:100
              try
                dis(kj)=abs(mean(features3(features3(:,3)==NumSortedUnit,kj))- mean(features3(features3(:,3)~=NumSortedUnit,kj)));
              end
          end
          
          [BE,id]=sort(dis,'descend');
          a=id(1); b=id(2);
          
          
         figure('color',[1 1 1]),clf, 
         plot(features3(:,a),features3(:,b),'k.'),

         for j=1:nbClu
            hold on, plot(features3(features3(:,3)==j,a),features3(features3(:,3)==j,b),'.','color',[0 j/nbClu (nbClu-j)/nbClu]),      
         end
         plot(features3(features3(:,3)==NumSortedUnit,a),features3(features3(:,3)==NumSortedUnit,b),'k.')
         plot(features3(features3(:,3)==nbClu,a),features3(features3(:,3)==nbClu,b),'ro','markerfacecolor','r')
            title(['Dimension: ',num2str(a-3),' vs ',num2str(b-3)])

         %  
        %  hold on, plot(features3(features3(:,3)==2,a),features3(features3(:,3)==2,b),'co'), 
        %  hold on, plot(features3(features3(:,3)==3,a),features3(features3(:,3)==3,b),'mo'), 
        %  hold on, plot(features3(features3(:,3)==4,a),features3(features3(:,3)==4,b),'yo'), 
        %  hold on, plot(features3(features3(:,3)==5,a),features3(features3(:,3)==5,b),'go'), 
        %  hold on, plot(features3(features3(:,3)==6,a),features3(features3(:,3)==6,b),'bo'), 
        %  plot(features3(features3(:,3)==7,a),features3(features3(:,3)==7,b),'o','markerfacecolor','r')


        %%

        stt=Start(Epoch,'s');
        enn=End(Epoch,'s');

        % features5=features3;
        % features5(features5(:,1)>End(Epoch,'s'),:)=[];
         features5=[];
         for i=1:length(stt)
             features5=[features5;features3(find(features3(:,1)<enn(i)&features3(:,1)>stt(i)),:)];
         end
         [BE,idxx]=sort(features5(:,1));
         features5=features5(idxx,:);

          [d6,LRatio6] = ComputeOnceMahal(features5,[tetrodeNumber max(clu)+1]);
          [d7,LRatio7] = ComputeOnceMahal(features5,[tetrodeNumber NumSortedUnit]);
          [d8,LRatio8] = IsolationDistance(features5);


        %  a=4;b=12;
        %  figure('color',[1 1 1]),clf, hold on 
        %  plot(features5(:,a),features5(:,b),'k.'),
        %  hold on, plot(features5(features5(:,3)==2,a),features5(features5(:,3)==2,b),'c.','markerfacecolor','c'), 
        %  hold on, plot(features5(features5(:,3)==3,a),features5(features5(:,3)==3,b),'m.','markerfacecolor','m'), 
        %  hold on, plot(features5(features5(:,3)==4,a),features5(features5(:,3)==4,b),'y.','markerfacecolor','y'), 
        %  hold on, plot(features5(features5(:,3)==5,a),features5(features5(:,3)==5,b),'b.','markerfacecolor','b'), 
        %  hold on, plot(features5(features5(:,3)==6,a),features5(features5(:,3)==6,b),'b.','markerfacecolor','b'), 
        %  plot(features5(features5(:,3)==7,a),features5(features5(:,3)==7,b),'ro','markerfacecolor','r')
        %  

        %% fig 3
          
          for kj=1:100
              try
                dis(kj)=abs(mean(features5(features5(:,3)==NumSortedUnit,kj))- mean(features5(features5(:,3)~=NumSortedUnit,kj)));
              end
          end
          
          [BE,id]=sort(dis,'descend');
          a=id(1); b=id(2);
          
         figure('color',[1 1 1]),clf, hold on
         plot(features5(:,a),features5(:,b),'k.'),
         for j=1:nbClu
            hold on, plot(features5(features5(:,3)==j,a),features5(features5(:,3)==j,b),'.','color',[0 j/nbClu (nbClu-j)/nbClu]),      
         end
         plot(features5(features5(:,3)==NumSortedUnit,a),features5(features5(:,3)==NumSortedUnit,b),'k.')
         plot(features5(features5(:,3)==nbClu,a),features5(features5(:,3)==nbClu,b),'ro','markerfacecolor','r')
         title(['Dimension: ',num2str(a-3),' vs ',num2str(b-3)])

         

         %%

        PlotErrorBar5(d1,d2,d3,d4,d5)
        PlotErrorBar5(LRatio1,LRatio2,LRatio3,LRatio4,LRatio5)

        PlotErrorBar8(d1,d2,d3,d4,d5,d6,d7,d8)
        PlotErrorBar8(LRatio1,LRatio2,LRatio3,LRatio4,LRatio5,LRatio6,LRatio7,LRatio8)


 end
 
%%
 
 if DoWaveforms

                      for k=0:nbClu-1
                            w{k+1} = GetSpikeWaveforms([tetrodeNumber k],'intervals',[Start(Epoch,'s') End(Epoch,'s')]);
                      end

                %         w{1} = GetSpikeWaveforms([1 0],'intervals',[Start(Epoch,'s') End(Epoch,'s')]);
                %         w{2} = GetSpikeWaveforms([1 1],'intervals',[Start(Epoch,'s') End(Epoch,'s')]);
                %         w{3} = GetSpikeWaveforms([1 2],'intervals',[Start(Epoch,'s') End(Epoch,'s')]);
                %         w{4} = GetSpikeWaveforms([1 3],'intervals',[Start(Epoch,'s') End(Epoch,'s')]);
                %         w{5} = GetSpikeWaveforms([1 4],'intervals',[Start(Epoch,'s') End(Epoch,'s')]);
                %         w{6} = GetSpikeWaveforms([1 5],'intervals',[Start(Epoch,'s') End(Epoch,'s')]);
                %         w{7} = GetSpikeWaveforms([1 6],'intervals',[Start(Epoch,'s') End(Epoch,'s')]);

                 for k=0:nbClu-1
                            s{k+1}=GetSpikes([tetrodeNumber k]);
                 end


                %         s{1}=GetSpikes([1 0]);
                %         s{2}=GetSpikes([1 1]);
                %         s{3}=GetSpikes([1 2]);
                %         s{4}=GetSpikes([1 3]);
                %         s{5}=GetSpikes([1 4]);
                %         s{6}=GetSpikes([1 5]);
                %         s{7}=GetSpikes([1 6]);


                        for j=0:nbClu-1

                            clear le

                           % try
                                a=1;
                                for i=1:size(ID,1)
                                    if clu(ID(i,1))==j
                                    le(a)=length(find(clu(1:ID(i,1)-1)==j));
                                    a=a+1;
                                    end
                                end

                                try
                                    di=size(w{nbClu},1);
                                catch
                                    di=0;
                                end

                                try

                                    w{nbClu}(di+1:di+length(le),:,:)=(w{j+1}(le+1,:,:));
                                    
                                    WaveFT{k,j+1}=w{j+1}(le+1,:,:);
                                    
                                    if plo

                %%                        fig 4
                                        figure('color',[1 1 1]), 
                                        for kj=1:size(w{1}(1,:,:),2)
                                        subplot(size(w{1}(1,:,:),2),1,kj), plot(squeeze(w{j+1}(le+1,kj,:))','k'),title(num2str(j))
                                        end
                                        %subplot(4,1,2), plot(squeeze(w{j+1}(le+1,2,:))','k')
                                        %subplot(4,1,3), plot(squeeze(w{j+1}(le+1,3,:))','k')
                                        %subplot(4,1,4), plot(squeeze(w{j+1}(le+1,4,:))','k')

                                    end
                                end

                           % end
                        end


                        %% fig 5
                        wfinal=PlotWaveforms({w{nbClu}},1,Epoch);title('spike detection')
                        PlotWaveforms({w{NumSortedUnit+1}},1,Epoch);title('sorted unit')

%                         PlotWaveforms(w,NumSortedUnit,Epoch);title('sorted unit')

 
 end
 
 try
     WaveFT;
 catch
     WaveFT=[];
 end
 
 try
     w;
 catch
     w=[];
 end
 
     
[dF,LRF,featuresF]=NewCalculFeaturesDistance(tetrodeNumber,Epoch,NumSortedUnit);


load SpikeData cellnames

NumTet=[];
a=1;
j=1;
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
    load Waveforms
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

le=size(A,1); 
A(le+1:le+1+size(wfinal,1)-1,:,:)=wfinal;
CluId=[CluId;(i+1)*ones(size(wfinal,1),1)];


spikes=A;
tps=1:size(spikes,1);
V=tsd(tps*1E4,spikes);

[PeakMinData,PeakMaxData, PeakDataMi,PeakDataMa,PeakNames,PeakPars] = SpikeFeaturesKB(V);



toc

