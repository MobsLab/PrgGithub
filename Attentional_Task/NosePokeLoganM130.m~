directoryName='/media/DataMOBs10/DataMMN/AttentionalNosePoke/Mouse130';
cd(directoryName)

% ----------   16/05   -------
cd([directoryName,'/20140516/ICSS-Mouse-130-16052014'])

clear ID
load StimTonePoke
ID=zeros(length(PokeEvent(:,1)),1);
idx=find((PokeEvent(:,2)-PokeEvent(:,1))/1E4>0.05);
success=1;
successbis=1;
successter=1;
successquar=1;
init=(PokeEvent(:,1)-ToneEvent(1))/1E4; 
iddd=init(find(init>8));
idddbis=init(find(init>10));
idddter=init(find(init>11));
idddquar=init(find(init>13));
for i=1:length(ToneEvent)
    id=(PokeEvent(idx,1)-ToneEvent(i))/1E4;
    idd=id(find(id>0));
    if length(iddd)>length(idd)
        success=success+1;
    end
    iddd=id(find(id>8));
    if length(idddbis)>length(idd)
        successbis=successbis+1;
    end
    idddbis=id(find(id>10));
    if length(idddter)>length(idd)
        successter=successter+1;
    end
    idddter=id(find(id>11));
    if length(idddquar)>length(idd)
        successquar=successquar+1;
    end
    idddquar=id(find(id>13));
    ID=[ID(1:(length(PokeEvent(:,1))-length(idd)));idd];
    first(i)=min(idd);
end
MeanNonReward16mai=mean(ID);
PercNonReward16mai=100*length(find(ID>8))/length(ID);
MeanFirstNosePoke16mai=mean(first);
PercReward16mai=100*length(find(first<8))/length(first);
PercNosePoke16mai=100*success/length(ToneEvent(:));
PercNosePoke16maibis=100*successbis/length(ToneEvent(:));
PercNosePoke16maiter=100*successter/length(ToneEvent(:));
PercNosePoke16maiquar=100*successquar/length(ToneEvent(:));

figure, plot(ID,'ko-')
hold on, plot(0:0.1:length(ID),MeanNonReward16mai,'b'), title(['Non rewarded nose pokes / nose pokes = ',num2str(PercNonReward16mai),'%'])

% ----------   19/05   -------
cd([directoryName,'/20140519/ICSS-Mouse-130-19052014'])

clear ID
load StimTonePoke
ID=zeros(length(PokeEvent(:,1)),1);
idx=find((PokeEvent(:,2)-PokeEvent(:,1))/1E4>0.05);
success5s=1;
success1s=1;
success5sbis=1;
success1sbis=1;
success5ster=1;
success1ster=1;
success5squar=1;
success1squar=1;
init=(PokeEvent(:,1)-ToneEvent(1))/1E4; init5s=init(1:60); iddd5s=init5s(find(init5s>8));
iddd5sbis=init5s(find(init5s>10));
iddd5ster=init5s(find(init5s>11));
iddd5squar=init5s(find(init5s>13));
init1s=init(61:119); iddd1s=init1s(find(init1s>4));
iddd1sbis=init1s(find(init1s>6));
iddd1ster=init1s(find(init1s>7));
iddd1squar=init1s(find(init1s>9));
for i=1:length(ToneEvent)
    id=(PokeEvent(idx,1)-ToneEvent(i))/1E4;
    idd=id(find(id>0));
    if length(iddd5s)>length(idd) & i<61
        success5s=success5s+1;
    end
    if length(iddd1s)>length(idd) & i>60
        success1s=success1s+1;
    end
    iddd5s=id(find(id>8));
    iddd1s=id(find(id>4));
    if length(iddd5sbis)>length(idd) & i<61
        success5sbis=success5sbis+1;
    end
    if length(iddd1sbis)>length(idd) & i>60
        success1sbis=success1sbis+1;
    end
    iddd5sbis=id(find(id>10));
    iddd1sbis=id(find(id>6));
    if length(iddd5ster)>length(idd) & i<61
        success5ster=success5ster+1;
    end
    if length(iddd1ster)>length(idd) & i>60
        success1ster=success1ster+1;
    end
    iddd5ster=id(find(id>11));
    iddd1ster=id(find(id>7));
    if length(iddd5squar)>length(idd) & i<61
        success5squar=success5squar+1;
    end
    if length(iddd1squar)>length(idd) & i>60
        success1squar=success1squar+1;
    end
    iddd5squar=id(find(id>13));
    iddd1squar=id(find(id>9));
    ID=[ID(1:(length(PokeEvent(:,1))-length(idd)));idd];
    first(i)=min(idd);
end
ID5s=ID(1:60);
first5s=first(1:60);
MeanNonReward=mean(ID5s);
PercNonReward=100*length(find(ID5s>8))/length(ID5s);
MeanFirstNosePoke=mean(first5s);
PercReward=100*length(find(first5s<8))/length(first5s);
PercNosePoke=100*success5s/60;
PercNosePokebis=100*success5sbis/60;
PercNosePoketer=100*success5ster/60;
PercNosePokequar=100*success5squar/60;

ID1s=ID(61:119);
first1s=first(61:119);
MeanNonRewardBis=mean(ID1s);
PercNonRewardBis=100*length(find(ID1s>4))/length(ID1s);
MeanFirstNosePokeBis=mean(first1s);
PercRewardBis=100*length(find(first1s<4))/length(first1s);
PercNosePokeBis=100*success1s/59;
PercNosePokeBisbis=100*success1sbis/59;
PercNosePokeBister=100*success1ster/59;
PercNosePokeBisquar=100*success1squar/59;

MeanNonReward19mai=(MeanNonReward+MeanNonRewardBis)/2;
PercNonReward19mai=(PercNonReward+PercNonRewardBis)/2;
MeanFirstNosePoke19mai=(MeanFirstNosePoke+MeanFirstNosePokeBis)/2;
PercReward19mai=(PercReward+PercRewardBis)/2;
PercNosePoke19mai=(PercNosePoke+PercNosePokeBis)/2;
PercNosePoke19maibis=(PercNosePokebis+PercNosePokeBisbis)/2;
PercNosePoke19maiter=(PercNosePoketer+PercNosePokeBister)/2;
PercNosePoke19maiquar=(PercNosePokequar+PercNosePokeBisquar)/2;

figure, plot(ID,'ko-')
hold on, plot(0:0.1:length(ID),MeanNonReward19mai,'b'), title(['Non rewarded nose pokes / nose pokes = ',num2str(PercNonReward19mai),'%'])

% ----------   20/05   -------
cd([directoryName,'/20140520/ICSS-Mouse-130-20052014'])

clear ID
load StimTonePoke
ID=zeros(length(PokeEvent(:,1)),1);
idx=find((PokeEvent(:,2)-PokeEvent(:,1))/1E4>0.05);
success=1;
successbis=1;
successter=1;
successquar=1;
init=(PokeEvent(:,1)-ToneEvent(1))/1E4; 
iddd=init(find(init>4));

idddbis=init(find(init>6));
idddter=init(find(init>7));
idddquar=init(find(init>9));
for i=1:56%length(ToneEvent)
    id=(PokeEvent(idx,1)-ToneEvent(i))/1E4;
    idd=id(find(id>0));
    if length(iddd)>length(idd)
        success=success+1;
    end
    iddd=id(find(id>4));
    if length(idddbis)>length(idd)
        successbis=successbis+1;
    end
    idddbis=id(find(id>6));
    if length(idddter)>length(idd)
        successter=successter+1;
    end
    idddter=id(find(id>7));
    if length(idddquar)>length(idd)
        successquar=successquar+1;
    end
    idddquar=id(find(id>9));
    ID=[ID(1:(length(PokeEvent(:,1))-length(idd)));idd];
    first(i)=min(idd);
end
MeanNonReward20mai=mean(ID);
PercNonReward20mai=100*length(find(ID>4))/length(ID);
MeanFirstNosePoke20mai=mean(first);
PercReward20mai=100*length(find(first<4))/length(first);
PercNosePoke20mai=100*success/length(ToneEvent(:));
PercNosePoke20maibis=100*successbis/length(ToneEvent(:));
PercNosePoke20maiter=100*successter/length(ToneEvent(:));
PercNosePoke20maiquar=100*successquar/length(ToneEvent(:));

figure, plot(ID,'ko-')
hold on, plot(0:0.1:length(ID),MeanNonReward20mai,'b'), title(['Non rewarded nose pokes / nose pokes = ',num2str(PercNonReward20mai),'%'])

% ----------   21/05   -------
cd([directoryName,'/20140521/ICSS-Mouse-130-21052014'])

clear ID
load StimTonePoke
ID=zeros(length(PokeEvent(:,1)),1);
idx=find((PokeEvent(:,2)-PokeEvent(:,1))/1E4>0.05);
success=1;
successbis=1;
successter=1;
successquar=1;
init=(PokeEvent(:,1)-ToneEvent(1))/1E4; iddd=init(find(init>4));
idddbis=init(find(init>6));
idddter=init(find(init>7));
idddquar=init(find(init>9));
for i=1:length(ToneEvent)
    id=(PokeEvent(idx,1)-ToneEvent(i))/1E4;
    idd=id(find(id>0));
    if length(iddd)>length(idd)
        success=success+1;
    end
    iddd=id(find(id>4));
    if length(idddbis)>length(idd)
        successbis=successbis+1;
    end
    idddbis=id(find(id>6));
    if length(idddter)>length(idd)
        successter=successter+1;
    end
    idddter=id(find(id>7));
    if length(idddquar)>length(idd)
        successquar=successquar+1;
    end
    idddquar=id(find(id>9));
    ID=[ID(1:(length(PokeEvent(:,1))-length(idd)));idd];
    first(i)=min(idd);
end
MeanNonReward21mai=mean(ID);
PercNonReward21mai=100*length(find(ID>4))/length(ID);
MeanFirstNosePoke21mai=mean(first);
PercReward21mai=100*length(find(first<4))/length(first);
PercNosePoke21mai=100*success/length(ToneEvent(:));
PercNosePoke21maibis=100*successbis/length(ToneEvent(:));
PercNosePoke21maiter=100*successter/length(ToneEvent(:));
PercNosePoke21maiquar=100*successquar/length(ToneEvent(:));

figure, plot(ID,'ko-')
hold on, plot(0:0.1:length(ID),MeanNonReward21mai,'b'), title(['Non rewarded nose pokes / nose pokes = ',num2str(PercNonReward21mai),'%'])

% ----------   22/05   -------
cd([directoryName,'/20140522/ICSS-Mouse-130-22052014'])

clear ID
load StimTonePoke
ID=zeros(length(PokeEvent(:,1)),1);
idx=find((PokeEvent(:,2)-PokeEvent(:,1))/1E4>0.05);
success=1;
successbis=1;
successter=1;
successquar=1;
init=(PokeEvent(:,1)-ToneEvent(1))/1E4; iddd=init(find(init>3.5));
idddbis=init(find(init>5.5));
idddter=init(find(init>6.5));
idddquar=init(find(init>8.5));
for i=1:length(ToneEvent)
    id=(PokeEvent(idx,1)-ToneEvent(i))/1E4;
    idd=id(find(id>0));
    if length(iddd)>length(idd)
        success=success+1;
    end
    iddd=id(find(id>3.5));
    if length(idddbis)>length(idd)
        successbis=successbis+1;
    end
    idddbis=id(find(id>5.5));
    if length(idddter)>length(idd)
        successter=successter+1;
    end
    idddter=id(find(id>6.5));
    if length(idddquar)>length(idd)
        successquar=successquar+1;
    end
    idddquar=id(find(id>8.5));
    ID=[ID(1:(length(PokeEvent(:,1))-length(idd)));idd];
    first(i)=min(idd);
end
MeanNonReward22mai=mean(ID);
PercNonReward22mai=100*length(find(ID>3.5))/length(ID);
MeanFirstNosePoke22mai=mean(first);
PercReward22mai=100*length(find(first<3.5))/length(first);
PercNosePoke22mai=100*success/length(ToneEvent(:));
PercNosePoke22maibis=100*successbis/length(ToneEvent(:));
PercNosePoke22maiter=100*successter/length(ToneEvent(:));
PercNosePoke22maiquar=100*successquar/length(ToneEvent(:));

figure, plot(ID,'ko-')
hold on, plot(0:0.1:length(ID),MeanNonReward22mai,'b'), title(['Non rewarded nose pokes / nose pokes = ',num2str(PercNonReward22mai),'%'])

% ----------   03/06   -------
cd([directoryName,'/20140603/ICSS-Mouse-130-03062014'])

clear ID
load StimTonePoke
ID=zeros(length(PokeEvent(:,1)),1);
idx=find((PokeEvent(:,2)-PokeEvent(:,1))/1E4>0.05);
success=1;
successbis=1;
successter=1;
successquar=1;
init=(PokeEvent(:,1)-ToneEvent(1))/1E4; iddd=init(find(init>3.5));
idddbis=init(find(init>5.5));
idddter=init(find(init>6.5));
idddquar=init(find(init>8.5));
for i=1:length(ToneEvent)
    id=(PokeEvent(idx,1)-ToneEvent(i))/1E4;
    idd=id(find(id>0));
    if length(iddd)>length(idd)
        success=success+1;
    end
    iddd=id(find(id>3.5));
    if length(idddbis)>length(idd)
        successbis=successbis+1;
    end
    idddbis=id(find(id>5.5));
    if length(idddter)>length(idd)
        successter=successter+1;
    end
    idddter=id(find(id>6.5));
    if length(idddquar)>length(idd)
        successquar=successquar+1;
    end
    idddquar=id(find(id>8.5));
    ID=[ID(1:(length(PokeEvent(:,1))-length(idd)));idd];
    first(i)=min(idd);
end
MeanNonReward03juin=mean(ID);
PercNonReward03juin=100*length(find(ID>3.5))/length(ID);
MeanFirstNosePoke03juin=mean(first);
PercReward03juin=100*length(find(first<3.5))/length(first);
PercNosePoke03juin=100*success/length(ToneEvent(:));
PercNosePoke03juinbis=100*successbis/length(ToneEvent(:));
PercNosePoke03juinter=100*successter/length(ToneEvent(:));
PercNosePoke03juinquar=100*successquar/length(ToneEvent(:));

figure, plot(ID,'ko-')
hold on, plot(0:0.1:length(ID),MeanNonReward03juin,'b'), title(['Non rewarded nose pokes / nose pokes = ',num2str(PercNonReward03juin),'%'])

% ----------   05/06   -------
cd([directoryName,'/20140605/ICSS-Mouse-130-05062014'])

clear ID
load StimTonePoke
ID=zeros(length(PokeEvent(:,1)),1);
idx=find((PokeEvent(:,2)-PokeEvent(:,1))/1E4>0.05);
success=1;
successbis=1;
successter=1;
successquar=1;
init=(PokeEvent(:,1)-ToneEvent(1))/1E4; iddd=init(find(init>3.1));
idddbis=init(find(init>5.1));
idddter=init(find(init>6.1));
idddquar=init(find(init>8.1));
for i=1:length(ToneEvent)
    id=(PokeEvent(idx,1)-ToneEvent(i))/1E4;
    idd=id(find(id>0));
    if length(iddd)>length(idd)
        success=success+1;
    end
    iddd=id(find(id>3.1));
    if length(idddbis)>length(idd)
        successbis=successbis+1;
    end
    idddbis=id(find(id>5.1));
    if length(idddter)>length(idd)
        successter=successter+1;
    end
    idddter=id(find(id>6.1));
    if length(idddquar)>length(idd)
        successquar=successquar+1;
    end
    idddquar=id(find(id>8.1));
    ID=[ID(1:(length(PokeEvent(:,1))-length(idd)));idd];
    first(i)=min(idd);
end
MeanNonReward05juin=mean(ID);
PercNonReward05juin=100*length(find(ID>3.1))/length(ID);
MeanFirstNosePoke05juin=mean(first);
PercReward05juin=100*length(find(first<3.1))/length(first);
PercNosePoke05juin=100*success/length(ToneEvent(:));
PercNosePoke05juinbis=100*successbis/length(ToneEvent(:));
PercNosePoke05juinter=100*successter/length(ToneEvent(:));
PercNosePoke05juinquar=100*successquar/length(ToneEvent(:));

figure, plot(ID,'ko-')
hold on, plot(0:0.1:length(ID),MeanNonReward05juin,'b'), title(['Non rewarded nose pokes / nose pokes = ',num2str(PercNonReward05juin),'%'])

% ----------   10/06   -------
cd([directoryName,'/20140610/ICSS-Mouse-130-10062014'])

clear ID
load StimTonePoke
ID=zeros(length(PokeEvent(:,1)),1);
idx=find((PokeEvent(:,2)-PokeEvent(:,1))/1E4>0.05);
success=1;
successbis=1;
successter=1;
successquar=1;
init=(PokeEvent(:,1)-ToneEvent(1))/1E4; iddd=init(find(init>3.1));
idddbis=init(find(init>5.1));
idddter=init(find(init>6.1));
idddquar=init(find(init>8.1));
for i=1:length(ToneEvent)
    id=(PokeEvent(idx,1)-ToneEvent(i))/1E4;
    idd=id(find(id>0));
    if length(iddd)>length(idd)
        success=success+1;
    end
    iddd=id(find(id>3.1));
    if length(idddbis)>length(idd)
        successbis=successbis+1;
    end
    idddbis=id(find(id>5.1));
    if length(idddter)>length(idd)
        successter=successter+1;
    end
    idddter=id(find(id>6.1));
    if length(idddquar)>length(idd)
        successquar=successquar+1;
    end
    idddquar=id(find(id>8.1));
    ID=[ID(1:(length(PokeEvent(:,1))-length(idd)));idd];
    first(i)=min(idd);
end
for i=1:length(GenToneEvent)
    idGen=(PokeEvent(idx,1)-GenToneEvent(i))/1E4;
    iddGen=idGen(find(idGen>0));
    firstGeneration(i)=min(iddGen);
end
firstGen=firstGeneration(2:56);
firstGenbis=firstGeneration(57:104);
firstGenter=firstGeneration(105:length(GenToneEvent));
MeanNonReward10juin=mean(ID);
PercNonReward10juin=100*length(find(ID>3.1))/length(ID);
MeanFirstNosePoke10juin=mean(first);
PercReward10juin=100*length(find(first<3.1))/length(first);
PercNosePoke10juin=100*success/length(ToneEvent(:));
PercNosePoke10juinbis=100*successbis/length(ToneEvent(:));
PercNosePoke10juinter=100*successter/length(ToneEvent(:));
PercNosePoke10juinquar=100*successquar/length(ToneEvent(:));
PercGen10juin=100*length(find(firstGen<3.1))/length(firstGen);
PercGen10juinbis=100*length(find(firstGenbis<3.1))/length(firstGenbis);
PercGen10juinter=100*length(find(firstGenter<3.1))/length(firstGenter);

figure, plot(ID,'ko-')
hold on, plot(0:0.1:length(ID),MeanNonReward10juin,'b'), title(['Non rewarded nose pokes / nose pokes = ',num2str(PercNonReward10juin),'%'])

% ----------   11/06   -------
cd([directoryName,'/20140611/ICSS-Mouse-130-11062014'])

clear ID
load StimTonePoke
ID=zeros(length(PokeEvent(:,1)),1);
idx=find((PokeEvent(:,2)-PokeEvent(:,1))/1E4>0.05);
success=1;
successbis=1;
successter=1;
successquar=1;
init=(PokeEvent(:,1)-ToneEvent(1))/1E4; iddd=init(find(init>3.1));
idddbis=init(find(init>5.1));
idddter=init(find(init>6.1));
idddquar=init(find(init>8.1));
for i=1:length(ToneEvent)
    id=(PokeEvent(idx,1)-ToneEvent(i))/1E4;
    idd=id(find(id>0));
    if length(iddd)>length(idd)
        success=success+1;
    end
    iddd=id(find(id>3.1));
    if length(idddbis)>length(idd)
        successbis=successbis+1;
    end
    idddbis=id(find(id>5.1));
    if length(idddter)>length(idd)
        successter=successter+1;
    end
    idddter=id(find(id>6.1));
    if length(idddquar)>length(idd)
        successquar=successquar+1;
    end
    idddquar=id(find(id>8.1));
    ID=[ID(1:(length(PokeEvent(:,1))-length(idd)));idd];
    first(i)=min(idd);
end
for i=1:length(GenToneEvent)
    idGen=(PokeEvent(idx,1)-GenToneEvent(i))/1E4;
    iddGen=idGen(find(idGen>0));
    firstGeneration(i)=min(iddGen);
end
firstGenquar=firstGeneration(2:41);
firstGenquin=firstGeneration(42:139);
firstGensex=firstGeneration(140:length(GenToneEvent));
MeanNonReward11juin=mean(ID);
PercNonReward11juin=100*length(find(ID>3.1))/length(ID);
MeanFirstNosePoke11juin=mean(first);
PercReward11juin=100*length(find(first<3.1))/length(first);
PercNosePoke11juin=100*success/length(ToneEvent(:));
PercNosePoke11juinbis=100*successbis/length(ToneEvent(:));
PercNosePoke11juinter=100*successter/length(ToneEvent(:));
PercNosePoke11juinquar=100*successquar/length(ToneEvent(:));
PercGen11juinquar=100*length(find(firstGenquar<3.1))/length(firstGenquar);
PercGen11juinquin=100*length(find(firstGenquin<3.1))/length(firstGenquin);
PercGen11juinsex=100*length(find(firstGensex<3.1))/length(firstGensex);

figure, plot(ID,'ko-')
hold on, plot(0:0.1:length(ID),MeanNonReward11juin,'b'), title(['Non rewarded nose pokes / nose pokes = ',num2str(PercNonReward11juin),'%'])

% ----------   all days   -------
figure

subplot(2,3,1), col=spring(13);
title(['Mean nose poke after tone emission'])
xlim([0.5 9.5])
ylim([0 25])
line([1 1],[0 MeanNonReward16mai],'linewidth',20,'color',col(3,:))
line([2 2],[0 MeanNonReward19mai],'linewidth',20,'color',col(4,:))
%line([3 3],[0 MeanNonReward20mai],'linewidth',20,'color',col(5,:))
line([4 4],[0 MeanNonReward21mai],'linewidth',20,'color',col(6,:))
line([5 5],[0 MeanNonReward22mai],'linewidth',20,'color',col(7,:))
line([6 6],[0 MeanNonReward03juin],'linewidth',20,'color',col(8,:))
line([7 7],[0 MeanNonReward05juin],'linewidth',20,'color',col(9,:))
line([8 8],[0 MeanNonReward10juin],'linewidth',20,'color',col(10,:))
line([9 9],[0 MeanNonReward11juin],'linewidth',20,'color',col(11,:))
ylabel('Mean time')
set(gca,'xticklabel',{'16/05','19/05','20/05','21/05','22/05','03/06','05/06','10/06','11/06'},'xtick',1:9)

subplot(2,3,2), col=autumn(13);
title(['First nose poke after tone emission'])
xlim([0.5 9.5])
ylim([0 25])
line([1 1],[0 MeanFirstNosePoke16mai],'linewidth',20,'color',col(3,:))
line([2 2],[0 MeanFirstNosePoke19mai],'linewidth',20,'color',col(4,:))
%line([3 3],[0 MeanFirstNosePoke20mai],'linewidth',20,'color',col(5,:))
line([4 4],[0 MeanFirstNosePoke21mai],'linewidth',20,'color',col(6,:))
line([5 5],[0 MeanFirstNosePoke22mai],'linewidth',20,'color',col(7,:))
line([6 6],[0 MeanFirstNosePoke03juin],'linewidth',20,'color',col(8,:))
line([7 7],[0 MeanFirstNosePoke05juin],'linewidth',20,'color',col(9,:))
line([8 8],[0 MeanFirstNosePoke10juin],'linewidth',20,'color',col(10,:))
line([9 9],[0 MeanFirstNosePoke11juin],'linewidth',20,'color',col(11,:))
ylabel('Mean time')
set(gca,'xticklabel',{'16/05','19/05','20/05','21/05','22/05','03/06','05/06','10/06','11/06'},'xtick',1:9)

subplot(2,3,4), col=winter(13);
title(['Percentage of success in rewarding tone attention'])
xlim([0.5 9.5])
ylim([0 100])
line([1 1],[0 PercReward16mai],'linewidth',20,'color',col(3,:))
line([2 2],[0 PercReward19mai],'linewidth',20,'color',col(4,:))
%line([3 3],[0 PercReward20mai],'linewidth',20,'color',col(5,:))
line([4 4],[0 PercReward21mai],'linewidth',20,'color',col(6,:))
line([5 5],[0 PercReward22mai],'linewidth',20,'color',col(7,:))
line([6 6],[0 PercReward03juin],'linewidth',20,'color',col(8,:))
line([7 7],[0 PercReward05juin],'linewidth',20,'color',col(9,:))
line([8 8],[0 PercReward10juin],'linewidth',20,'color',col(10,:))
line([9 9],[0 PercReward11juin],'linewidth',20,'color',col(11,:))
ylabel('% nose poke rewarded')
set(gca,'xticklabel',{'16/05','19/05','20/05','21/05','22/05','03/06','05/06','10/06','11/06'},'xtick',1:9)

% hold on, bar(1,100-PercReward21mai,'y','linewidth',2)
% hold on, bar(6,100-PercReward11juin,'r','linewidth',2)

A=[PercNonReward16mai;PercNonReward19mai;PercNonReward21mai;PercNonReward22mai;PercNonReward03juin;PercNonReward05juin;PercNonReward10juin;PercNonReward11juin];
B=[PercNosePoke16mai;PercNosePoke19mai;PercNosePoke21mai;PercNosePoke22mai;PercNosePoke03juin;PercNosePoke05juin;PercNosePoke10juin;PercNosePoke11juin];
Bbis=[PercNosePoke16maibis;PercNosePoke19maibis;PercNosePoke21maibis;PercNosePoke22maibis;PercNosePoke03juinbis;PercNosePoke05juinbis;PercNosePoke10juinbis;PercNosePoke11juinbis];
Bter=[PercNosePoke16maiter;PercNosePoke19maiter;PercNosePoke21maiter;PercNosePoke22maiter;PercNosePoke03juinter;PercNosePoke05juinter;PercNosePoke10juinter;PercNosePoke11juinter];
Bquar=[PercNosePoke16maiquar;PercNosePoke19maiquar;PercNosePoke21maiquar;PercNosePoke22maiquar;PercNosePoke03juinquar;PercNosePoke05juinquar;PercNosePoke10juinquar;PercNosePoke11juinquar];
C=[PercGen10juin;PercGen10juinbis;PercGen10juinter;PercGen11juinquar;PercGen11juinquin;PercGen11juinsex];
%K=[MeanFirstNosePoke16mai;MeanFirstNosePoke19mai;MeanFirstNosePoke22mai;MeanFirstNosePoke03juin;MeanFirstNosePoke05juin;MeanFirstNosePoke10juin;MeanFirstNosePoke11juin];

subplot(2,3,3)
plot(A,'ko-')
hold on, axis([0.5 9.5 0 100])
ylabel('%')
set(gca,'xticklabel',{'16/05','19/05','21/05','22/05','03/06','05/06','10/06','11/06'},'xtick',1:8)
title(['Non rewarded nose pokes / nose pokes'])

subplot(2,3,5), col=autumn(6);
plot(B,'o-','color',col(2,:))
hold on, plot(Bbis,'o-','color',col(3,:))
hold on, plot(Bter,'o-','color',col(4,:))
hold on, plot(Bquar,'o-','color',col(5,:))
hold on, axis([0.5 9.5 0 100])
ylabel('%')
set(gca,'xticklabel',{'16/05','19/05','21/05','22/05','03/06','05/06','10/06','11/06'},'xtick',1:8)
title(['Failure in attention to rewarding tone (Rule 2)'])
legend('sound+3s','sound+5s','sound+6s','sound+8s')

subplot(2,3,6)
plot(C,'mo-')
hold on, axis([0.5 6.5 0 100])
ylabel('% nose poke')
set(gca,'xticklabel',{'30kHz','25kHz','20kHz','15kHz','10kHz','5kHz'},'xtick',1:6)
title(['Percentage of attention to non rewarding tone'])