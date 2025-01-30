% Epochs
Epochs253MFB2=intervalSet([212,756,892,1048,1188,1317,1522]*1e4,([212,756,892,1048,1188,1317,1522]+100)*1e4);
Epochs254MFB1=intervalSet([21,170,315,478,620,748,880]*1e4,([21,170,315,478,620,748,880]+100)*1e4);


EpochsAll = {Epochs253MFB2,Epochs254MFB1};
NPDURallMFB = {};

location= {'/media/MOBSDataRotation/M253/CalibMFB/Session2_07102015/DigDat/M253_MFBCalib_Droite_Sess2_151007_175027',
    '/media/MOBSDataRotation/M254/CalibMFB/Session1_07102015/DigDat/M254_MFBCalib_Droite_151007_121708'};

for i=1:length(location)
    datafile = [location{i} '/DigDat.mat'];
    DATA1 = load(datafile);
    DATA1 = struct2array(DATA1);
    poke = DATA1{1,2}(:,1);
    PAG = DATA1{1,2}(:,2);
    MFB = DATA1{1,2}(:,3);
    Start = DATA1{1,2}(:,4);
    tps=DATA1{1,1}-90.74;
    dt=median(diff(tps));
    PokeInfo=tsd(tps*1e4,poke);
    Epochs = EpochsAll{i};
        save('PokeData.mat','tps','PAG','MFB','poke')

nb_pokes = 0;
len = length(poke);
durpoke = [];

M=diff(MFB);P=diff(PAG);
MFBInfo = tsd(tps(2:end)*1e4,M);
PAGInfo = tsd(tps(2:end)*1e4,P);

% Temps passé en NP
figure

if i<2
    mouse = 'M253';
else
    mouse = 'M254';
end

subplot(2,3,1), hold on
Cols=jet(2);
for j=1
    ShortEpochs=thresholdIntervals(PokeInfo,0.5,'Direction','Below');
    ShortEpochs=mergeCloseIntervals(ShortEpochs,j*1e4);
    % Durrée totale NP
    for k=1:length(start(Epochs))
        NPDUR(k)=length(Data(Restrict(PokeInfo,And(subset(Epochs,k),ShortEpochs))))/length(Data(Restrict(PokeInfo,subset(Epochs,k))));
    end
    plot(NPDUR,'color',Cols(j,:))
    hold on
end
title(['Duree totale NP ' mouse])
NPDURallMFB{i} = NPDUR;
clear NPDUR


%Nombre de stims
subplot(2,3,2), hold on
for k=1:length(start(Epochs))
    Temp=Data(Restrict(MFBInfo,subset(Epochs,k)));
    NB_MFB(k) = length(find(Temp==1));
    Temp=Data(Restrict(PAGInfo,subset(Epochs,k)));
    NB_PAG(k) = length(find(Temp==1));
end
plot(NB_MFB,'k');
title(['Nb stims  ' mouse])
clear NB_MFB

%Durée des pokes
subplot(2,3,3)
Cols=jet(5);
for j=[1:1:5]
    ShortEpochs=thresholdIntervals(PokeInfo,0.5,'Direction','Below');
    ShortEpochs=mergeCloseIntervals(ShortEpochs,j*1e4);
    
     for k=1:length(start(Epochs))
         Ddur(k) = median(((stop(And(ShortEpochs, subset(Epochs,k)))-start(and(ShortEpochs, subset(Epochs,k)))))*1e-4);
     end
    plot(Ddur,'color',Cols(j,:));hold on;
end
title(['duree med poke  ' mouse])
clear Ddur

%Durée max sans poke
subplot(2,3,4)
clear Max
ShortEpochs=thresholdIntervals(PokeInfo,0.5,'Direction','Above');
for k=1:length(start(Epochs))
    if isempty(stop(And(ShortEpochs, subset(Epochs,k))))
        Max(k) = 0;
    else 
    
    Max(k) = max(((stop(And(ShortEpochs, subset(Epochs,k)))-start(and(ShortEpochs, subset(Epochs,k)))))*1e-4);
    end
end
plot(Max)
title(['duree max sans poke  ' mouse])
clear Max


% 
% %Départ après PAG
% subplot(2,3,5)
% clear departPAG
% ShortEpochs=thresholdIntervals(PokeInfo,0.5,'Direction','Below');
% for q=[1:1:5]
%     ShortEpochs=mergeCloseIntervals(ShortEpochs,q*1e4);
% for k=1:length(start(Epochs))
%    SubShort=(And(subset(Epochs,k),ShortEpochs));
%    if isempty(start(SubShort))
%        mnval(k) = 0;
%    else
%    for j=1:length(start(SubShort))
%        STOP=stop(SubShort)/1e4;
%        st=STOP(j);
%        TempMFB=Data(Restrict(MFBInfo,subset(Epochs,k)));
%        MFBst = find(TempMFB==1)*dt +start(Subset(Epochs,k))/1e4;
%        tmp=st-MFBst; tmp(tmp<0)=[];
%        MFBmin = min(tmp);
%        TempPAG=Data(Restrict(PAGInfo,subset(Epochs,k)));
%        PAGst = find(TempPAG==1)*dt +start(Subset(Epochs,k))/1e4;
%        tmp=st-PAGst; tmp(tmp<0)=[];
%        PAGmin = min(abs(st-PAGst));
%        if min(([MFBmin,PAGmin])) == MFBmin
%            departPAG{k}(j) = 0;
%        else
%            departPAG{k}(j) = 1;
%        end
%    
%    end
%    mnval(k)=mean(departPAG{k});
%    end
% end
% plot(mnval,'color',Cols(q,:)), hold on
% clear departPAG mnval
% end
% title(['Prop depart apres PAG  '  mouse])
%  

end


