function [Cond,SPK]=ControlOnlineSpikeSorting(ListLFP,varargin)


% Output:
%-------------------------------------------
%         Cond(a,1)=ttet;
%         Cond(a,2)=voie Kluster;
%         Cond(a,3)=NumNeuron;
%         Cond(a,4)=channel Neuroscope;
%         Cond(a,5)=threshold;

    
    load behavResources V
    rgs=Range(V);

    
    
    
    
   
 for i = 1:2:length(varargin),

   %           if ~isa(varargin{i},'char'),
    %            error(['Parameter ' num2str(i) ' is not a property (type ''help ICSSexplo'' for details).']);
     %         end

              switch(lower(varargin{i})),

         

                case 'ListLFP',
                  ListLFP = varargin{i+1};
                                    
                  
                case 'plot',
                  plo = varargin{i+1};
                  if plo=='y'
                  plo=1;
                  end
                
                 
                  
              end
 end
  
    
    
    
    
    try 
        ListLFP;
    catch
        
ListeLFP{1}=[10 11 12 14];
ListeLFP{2}=[16 17 19 20 21 22 23];
    end
    
tpsDeb=rgs(1);
tpsFin=rgs(end);

try 
    plo;
catch
    plo=0;
    SPK={};
    Cond=[];
end

load SpikeData
try
    W;
catch
    load Waveforms
end

load behavResources



numTet=TT{length(S)}(1);
for i=1:numTet
    for j=1:length(S)
        id(j)=TT{j}(1);
    end
    temp=find(id==i);
    ID(i)=temp(1);
end
ID=[ID,length(S)+1];



%-------------------------------------------------------------------------

clear Wt

for k=1:numTet % number of recording electrodes

    for j=1:8 % number of wires
        
        Wt{k,j}=[];
        a=1;
        for i=ID(k):ID(k+1)-1 % number of neurons
            try
                Wt{k,j}(a,:)=mean(squeeze(W{i}(:,j,:)));
            catch
                Wt{k,j}(a,:)=zeros(32,1);
            end
            a=a+1;
        end
    end

end


%-------------------------------------------------------------------------


% for k=1:numTet
%     figure('color',[1 1 1]),
%     for i=1:8
%         
%         subplot(2,8,i), imagesc(Wt{k,i}), caxis([0 max(max(Wt{k,i}))]);set(gca','Ytick',[1:49]), title(['Channel ',num2str(i)]),
%         subplot(2,8,i+8), imagesc(Wt{k,i}), caxis([min(min(Wt{k,i})) 0]);set(gca','Ytick',[1:49]), 
%     end
%     subplot(2,8,1), ylabel(['Tetrode ',num2str(k)])
%     subplot(2,8,9), ylabel(['Tetrode ',num2str(k)])
% 
% end


%-------------------------------------------------------------------------
%-------------------------------------------------------------------------
%-------------------------------------------------------------------------

    clear Choix1Neuron
    clear Choix2Neuron
    clear Minnn
    clear Minnn2
    for k=1:numTet
        figure('color',[1 1 1]),    
        for voie=1:size(W{ID(k)},2)
        try
            a=1;
            for i=ID(k)+1:ID(k+1)-1
            subplot(1,size(W{ID(k)},2),voie), hold on, plot(mean(squeeze(W{i}(:,voie,:))),'k')  
            Minnn(voie,a)=min(mean(squeeze(W{i}(:,voie,:))));
            a=a+1;
            end
            [mE,ide]=sort(Minnn(voie,:),'ascend');
            ide1=ide(1);
            ide2=ide(2);

            Choix1Neuron(k,voie,:)=[ide1+ID(k) mean(squeeze(W{ide1+ID(k)}(:,voie,14))) std(squeeze(W{ide1+ID(k)}(:,voie,14)))];
            Choix2Neuron(k,voie,:)=[ide2+ID(k) mean(squeeze(W{ide2+ID(k)}(:,voie,14))) std(squeeze(W{ide2+ID(k)}(:,voie,14)))];

            subplot(1,size(W{ID(k)},2),voie), hold on, plot(mean(squeeze(W{ide1+ID(k)}(:,voie,:))),'r','linewidth',2)  
            title(['Voie: ',num2str(voie),' ',cellnames{ide1+ID(k)}])
        end
        end
        clear Minnn
    end

    
  %squeeze(Choix1Neuron(1,:,2:3))
  %squeeze(Choix2Neuron(1,:,2:3))
  
  Res{1}=[(squeeze(Choix1Neuron(1,:,2))-squeeze(Choix2Neuron(1,:,2)))' (squeeze(Choix1Neuron(1,:,2))-squeeze(Choix2Neuron(1,:,2)))'./squeeze(Choix1Neuron(1,:,2))'*100]; 
  %squeeze(Choix1Neuron(2,:,2:3))
  %squeeze(Choix2Neuron(2,:,2:3))
  
  Res{2}=[(squeeze(Choix1Neuron(2,:,2))-squeeze(Choix2Neuron(2,:,2)))'  (squeeze(Choix1Neuron(2,:,2))-squeeze(Choix2Neuron(2,:,2)))'./squeeze(Choix1Neuron(2,:,2))'*100];
  
    
%-------------------------------------------------------------------------
%-------------------------------------------------------------------------

    
%  (squeeze(Choix1Neuron(1,:,2))-squeeze(Choix2Neuron(1,:,2)))'
%  (squeeze(Choix1Neuron(2,:,2))-squeeze(Choix2Neuron(2,:,2)))' 

    
    
    if 1
    
a=1;
for ttet=1:numTet
    
    for voie=1:8
        try
        if Res{ttet}(voie,1)<-500&Res{ttet}(voie,2)>20

        NumNeuron=Choix1Neuron(ttet,voie,1);
        channel=ListeLFP{ttet}(voie);

        Epoch=intervalSet(tpsDeb*1E4,tpsFin*1E4);
                if plo
                        clear elec
                        SetCurrentSession('same')
                        [data,indices] = GetWidebandData(channel);
                        elec=tsd(data(:,1)*1E4, data(:,2));
                        clear data
                end

        Dir='Below';
        th=Choix1Neuron(ttet,voie,2)-Res{ttet}(voie,1)/10;
                if plo
                        spk=thresholdIntervals(elec,th, 'Direction',Dir);
                        clear Spk; Spk=Start(spk);SPK{a}=ts(Spk);
                        PlaceField(Restrict(Spk,Epoch),Restrict(X,Epoch),Restrict(Y,Epoch));title(['Online detection , Threshold: ',num2str(th)])
                end        
        
        Cond(a,1)=ttet;
        Cond(a,2)=voie;
        Cond(a,3)=NumNeuron;
        Cond(a,4)=channel;
        Cond(a,5)=floor(th);
        
        a=a+1;



                if plo
                     PlaceField(Restrict(S{NumNeuron},Epoch),Restrict(X,Epoch),Restrict(Y,Epoch));title(cellnames{NumNeuron})
                end
      %keyboard
      
        end
        end
    end

end
 



    end
    