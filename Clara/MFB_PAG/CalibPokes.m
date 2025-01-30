M253_PAG2 = load('/media/MOBSDataRotation/M253/CalibPAG/Session2_121015/DigDat/M253_PAGCalib_Droite_Sess4_151012_122135/DigDat.mat');
M253_PAG2=struct2array(M253_PAG2);

poke = M253_PAG2{1,2}(:,1);
PAG = M253_PAG2{1,2}(:,2);
MFB = M253_PAG2{1,2}(:,3);
Start = M253_PAG2{1,2}(:,4);
tps=M253_PAG2{1,1}-90.74;
dt=median(diff(tps));
PokeInfo=tsd(tps*1e4,poke);
Epochs=intervalSet([84,263,408,543,680,915]*1e4,([84,263,408,543,680,915]+100)*1e4) %M253PAG2

% M253 PAG3 [7,142,274,406,536,808,959,1139]
% M253 PAG4 [55,186,319,457,583,730,858,1011,1167]

% M254 PAG1 [96,257,434,735]
% M254 PAG2 [40,187,316,450,598,742,910,1046]
% M254 PAG3 []
% M254 PAG4 []



nb_pokes = 0;
len = length(poke);
durpoke = [];

M=diff(MFB);P=diff(PAG);
MFBInfo = tsd(tps(2:end)*1e4,M);
PAGInfo = tsd(tps(2:end)*1e4,P);

% Temps passé en NP
figure
Cols=jet(10);
for j=[1:1:10]
    ShortEpochs=thresholdIntervals(PokeInfo,0.5,'Direction','Below');
    ShortEpochs=mergeCloseIntervals(ShortEpochs,j*1e4);
    % Durrée totale NP
    for k=1:length(start(Epochs))
        NPDUR(k)=length(Data(Restrict(PokeInfo,And(subset(Epochs,k),ShortEpochs))))/length(Data(Restrict(PokeInfo,subset(Epochs,k))));
        
    end
    plot(NPDUR,'color',Cols(j,:))
    hold on
end
title('Duree totale NP')

%Nombre de stims
figure
for k=1:length(start(Epochs))
    Temp=Data(Restrict(MFBInfo,subset(Epochs,k)));
    NB_MFB(k) = length(find(Temp==1));
    Temp=Data(Restrict(PAGInfo,subset(Epochs,k)));
    NB_PAG(k) = length(find(Temp==1));
end
plot(NB_MFB,'k')
title('Nb stims')

%Durée des pokes
figure
clear Ddur
Cols=jet(5);
for j=[1:1:5]
    ShortEpochs=thresholdIntervals(PokeInfo,0.5,'Direction','Below');
    ShortEpochs=mergeCloseIntervals(ShortEpochs,j*1e4);
    
     for k=1:length(start(Epochs))
         Ddur(k) = median(((stop(And(ShortEpochs, subset(Epochs,k)))-start(and(ShortEpochs, subset(Epochs,k)))))*1e-4);
     end
    plot(Ddur,'color',Cols(j,:));hold on;
end
title('duree med poke')

%Durée max sans poke
figure
ShortEpochs=thresholdIntervals(PokeInfo,0.5,'Direction','Above');
for k=1:length(start(Epochs))
    Max(k) = max(((stop(And(ShortEpochs, subset(Epochs,k)))-start(and(ShortEpochs, subset(Epochs,k)))))*1e-4);
end
plot(Max)
title('duree max sans poke')


%Départ après PAG
figure
clear departPAG
ShortEpochs=thresholdIntervals(PokeInfo,0.5,'Direction','Below');
for q=[1:1:5]
    ShortEpochs=mergeCloseIntervals(ShortEpochs,q*1e4);
for k=1:length(start(Epochs))
   SubShort=(And(subset(Epochs,k),ShortEpochs));
   for j=1:length(start(SubShort))
       STOP=stop(SubShort)/1e4;
       st=STOP(j);
       TempMFB=Data(Restrict(MFBInfo,subset(Epochs,k)));
       MFBst = find(TempMFB==1)*dt +start(Subset(Epochs,k))/1e4;
       tmp=st-MFBst; tmp(tmp<0)=[];
       MFBmin = min(tmp);
       TempPAG=Data(Restrict(PAGInfo,subset(Epochs,k)));
       PAGst = find(TempPAG==1)*dt +start(Subset(Epochs,k))/1e4;
       tmp=st-PAGst; tmp(tmp<0)=[];
       PAGmin = min(abs(st-PAGst));
       if min(([MFBmin,PAGmin])) == MFBmin
           departPAG{k}(j) = 0;
       else
           departPAG{k}(j) = 1;
       end
   end
end
for k=1:length(start(Epochs))
mnval(k)=mean(departPAG{k});
end
plot(mnval,'color',Cols(q,:)), hold on
clear departPAG
end
title('Prop départ après PAG')

% figure
% 
% plot(departPAG);

%Nombre de pokes
D=diff(poke);
nb_pokes=length(find(D==-1));
durpoke=(find(D==1)-find(D==-1))*dt;

% %Durée des pokes
% 
% notpoking = find(poke);

%%%timeseries

% %trop lent!!!
% for n = 2:len
%     if poke(n-1) == 1;
%         if poke(n) == 0;
%             durpoke(n,1) = M253_PAG4{1,1}(n);
%             nstop = n;
%             nextpoke = poke(nstop+1);
%             while nextpoke == 0
%                 nstop = nstop+1;
%                 if cputime > 120
%                     break
%                 end
%             end
%             durpoke(n,2) = M253_PAG4{1,1}(nstop);
%         end
%     end
%     if cputime>200
%         break
%     end
% end
% 


% 
% 
% durpoke(:,3) = durpoke(:,2) - durpoke(:,1);
% 
% 
% 
% % Départ après PAG
