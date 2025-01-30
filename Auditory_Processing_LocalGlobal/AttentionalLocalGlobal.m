% AttentionalNosePoke
res=pwd;
smo=2;
load([res,'/LFPData/InfoLFP']);

load behavResources

%------------------------------------------------------
% Determination des temps de chaque sons/sequences/stim
%------------------------------------------------------
RwdToneEvt=Event17;
disp(['nombre de sons récompensant :   ', num2str(length(RwdToneEvt))])

StandardEvt=Event18;
disp(['nombre de sons standard :   ', num2str(length(StandardEvt))])

DeviantEvt=Event19;
disp(['nombre de sons déviants :   ', num2str(length(DeviantEvt))])

OmissionEvt=Event20;
disp(['nombre de sons Omission :   ', num2str(length(OmissionEvt))])

RwdStimEvt=Event21;
disp(['nombre de stimulations récompensantes :   ', num2str(length(RwdStimEvt))])

save AttentionalEvent RwdToneEvt StandardEvt DeviantEvt OmissionEvt RwdStimEvt


%---------------------------------------------------
% LFP 3 : Find all the NosePoke time
%--------------------------------------------------
num=input('  LFP channel for Nose Poke ? (usual:1) ');
load([res,'/LFPData/LFP',num2str(num)]);
LFP2=ResampleTSD(LFP,500);
i=num+1;

signalPoke=Data(LFP2);
tpsPoke=Range(LFP2);
C=find(signalPoke<-3000);

a=1;
PokeEvent=[];
PokeEvent(a,1)=tpsPoke(C(1));
a=2;
for j=1:length(C)-1
    if C(j+1)-C(j)>2;
        PokeEvent(a,1)=tpsPoke(C(j+1));   % début du nose poke
        a=a+1;
    end
end
a=1;
for j=1:length(C)-1
    if C(j+1)-C(j)>2;
        PokeEvent(a,2)=tpsPoke(C(j));    % fin du nose poke
        a=a+1;
    end
end
PokeEvent(a,2)=tpsPoke(C(j));
PokeEvent=PokeEvent/1E4;
save AttentionalEvent -append PokeEvent

figure, plot(Range(LFP,'s'),Data(LFP),'k'), title([InfoLFP.structure(num+1),'n= ',num2str(length(PokeEvent))])
hold on, plot(PokeEvent(:,1),10,'rd','markerfacecolor','r','MarkerSize',5);
hold on, plot(PokeEvent(:,2),10,'bd','markerfacecolor','b','MarkerSize',5);


% plot the nose poke triggered to the tone
%-----------------------------------------
J1=-0.5*1E4;
J2=+20*1E4;
figure, [fh, rasterAx, histAx, ToneToLFP(i)]=ImagePETH(LFP2, ts(RwdToneEvt(1:length(RwdToneEvt-1))), J1, J2,'BinSize',800); title('NosePoke triggered to Rewarding Tone (500ms)')


% plot the nose poke triggered to the Rewarding Tone
%---------------------------------------------------
clear ID
load AttentionalEvent
RwdTime=input('  How long the rewarding window is open after tone onset ? ');

idx=find((PokeEvent(:,2)-PokeEvent(:,1))>0.05);
for i=1:length(RwdToneEvt), 
    id=(PokeEvent(idx,1)-RwdToneEvt(i)); 
    idd=id(find(id>0));
    ID(i)=min(idd);
end
MeanReward=mean(ID);
PercReward=length(find(ID<RwdTime))/length(ID)*100;

save Results MeanReward PercReward

figure, plot(ID,'ko-')
hold on, plot(0:0.1:length(ID),RwdTime,'b'), title(['Success for Rewarding Tone (%) = ',num2str(PercReward)])


% plot the nose poke triggered to the non-rewarding tone
%-------------------------------------------------------
clear IDNonRwd
load AttentionalEvent
idx=find((PokeEvent(:,2)-PokeEvent(:,1))>0.05);
NonRwdEvt=[StandardEvt' DeviantEvt' OmissionEvt'];
NonRwdEvt=NonRwdEvt';

for i=2:length(NonRwdEvt),
    id=(PokeEvent(idx,2)-NonRwdEvt(i));
    idd=id(find(id>0));
    IDNonRwd(i)=min(idd);
end
MeanNonRwd=mean(IDNonRwd);
PercNonRwd=length(find(IDNonRwd<RwdTime))/length(IDNonRwd)*100;

save Results MeanNonRwd PercNonRwd

figure, plot(IDNonRwd,'ko-')
hold on, plot(0:0.1:length(IDNonRwd),3,'b'), title(['NosePoke for non-Rewarding Tone (%) = ',num2str(PercNonRwd)])

%--------------------------------------------------------
legend{1}='Rewarding Tone';
legend{2}='Non-Rewarding Tone';

figure, subplot(1,2,1)
hold on, bar(MeanNonRwd,'k','linewidth',1)
hold on, bar(MeanReward,'r','linewidth',1)
set(gca,'xtick',1:2)
set(gca,'xticklabel',legend)
ylabel('mean time after the tone')

hold, subplot(1,2,2)
hold on, bar(PercReward,'r','linewidth',1)
hold on, bar(PercNonRwd,'k','linewidth',1)
set(gca,'xtick',1:2)
set(gca,'xticklabel',legend)
ylabel('% of success to nosepoke within 3seconds')



