% NosePokeDisplay.m
%
% You need to have copied NosePoke data into a 4culumn matrix
% NosePokeMat_name={'Voltage','%time','Session','PRE/ICSS/POST'};


%% inputs
SavFigure=1;



%% initialization
res=pwd;
try 
    NumMouse;
catch
    NumMouse=input('Enter num of the mouse (e.g. 107): ');
end
load(['NosePoke',num2str(NumMouse),'.mat'],'NosePokeMat','NosePokeMat_name')

ICSSvolt=unique(NosePokeMat(NosePokeMat(:,4)==2,1));
Numsession=unique(NosePokeMat(:,3));

sizeA=max(length(NosePokeMat(NosePokeMat(:,4)==1,2)),length(NosePokeMat(NosePokeMat(:,4)==3,2)));
A=NaN(sizeA,length(ICSSvolt)+2);
scrz=get(0,'ScreenSize');




%% Compute Boxplot Matrix

% PRE
temp=NosePokeMat(NosePokeMat(:,4)==1,2);
A(1:length(temp),1)=temp;
A_name{1}='PRE';
for i=1:length(Numsession)
    Abar(1,i)=nanmean(NosePokeMat(NosePokeMat(:,4)==1 & NosePokeMat(:,3)==i,2));
    Abar_Name{i}=['Session ',num2str(Numsession(i))];
end
Abar_mean(1)=nanmean(temp);
Abar_std(1)=stdError(temp);

% POST
temp=NosePokeMat(NosePokeMat(:,4)==3,2);
A(1:length(temp),2+length(ICSSvolt))=temp;
A_name{2+length(ICSSvolt)}='POST';
for i=1:length(Numsession)
    Abar(2+length(ICSSvolt),i)=nanmean(NosePokeMat(NosePokeMat(:,4)==3 & NosePokeMat(:,3)==i,2));
end
Abar_mean(2+length(ICSSvolt))=nanmean(temp);
Abar_std(2+length(ICSSvolt))=stdError(temp);

% ICSS
for uu=1:length(ICSSvolt)
    temp=NosePokeMat(NosePokeMat(:,4)==2 & NosePokeMat(:,1)==ICSSvolt(length(ICSSvolt)-uu+1),2);
    A(1:length(temp),uu+1)=temp;
    A_name{uu+1}=[num2str(ICSSvolt(length(ICSSvolt)-uu+1)),'V'];
    for i=1:length(Numsession)
        Abar(uu+1,i)=nanmean(NosePokeMat(NosePokeMat(:,4)==2 & NosePokeMat(:,1)==ICSSvolt(length(ICSSvolt)-uu+1) & NosePokeMat(:,3)==i,2));
    end
    Abar_mean(uu+1)=nanmean(temp);
    Abar_std(uu+1)=stdError(temp);
end




%% display

figure('Color',[1 1 1],'position',scrz), NumFig=gcf;
subplot(2,2,1:2)
boxplot(A)
[i,j]=find(~isnan(A));
hold on, plot(j,A(~isnan(A)),'k.','MarkerSize',20)
set(gca,'XTick',1:size(A,2))
set(gca,'XTickLabel',A_name)
ylabel('% time in NosePoke')
xlabel('Session voltage')
title(['NOSE POKE MOUSE ',num2str(NumMouse)])

subplot(2,2,3)
bar(Abar)
set(gca,'XTick',1:size(A,2))
set(gca,'XTickLabel',A_name)
legend(Abar_Name)
title('Bar per session')

subplot(2,2,4)
bar(Abar_mean)
hold on, errorbar(Abar_mean,Abar_std,'+k')
set(gca,'XTick',1:size(A,2))
set(gca,'XTickLabel',A_name)
title('All sessions')



%% save figures

if SavFigure
    saveFigure(NumFig,['BilanNosePoke',num2str(NumMouse)],res)
end



