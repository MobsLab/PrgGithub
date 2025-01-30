%QuantifExplo

%-----------------------
% initiate
load('behavResources.mat')

res=pwd;
eval(['cd ',res,'-wideband'])

%-----------
list=dir;
a=0; Nb=[];

for i=1:length(list)
    le=length(list(i).name);
    if length(list(i).name)>12 & list(i).name(le-11:le)=='wideband.pos'
        disp(list(i).name);
        a=a+1;        
        namePos{a}=list(i).name(1:le-4);
        if sum(ismember('QuantifExplo',namePos{a}))==12
            Nb=[Nb,a];
        end
    end
end

figure('Color',[1 1 1]);f=gcf;

c=1; n=0;
S=Start(TrackingEpoch);

for i=1:length(S)
    sub=subset(TrackingEpoch,i);
    if ismember(S(i),Start(QuantifExploEpoch))==1
        n=n+1;
        figure(f), hold on,subplot(ceil(length(namePos)/4),4,Nb(c)), plot(Data(Restrict(X,sub)),Data(Restrict(Y,sub)),'k');
        GoodDur=round((End(sub)-Start(sub))/10000);
        title(namePos{Nb(c)}(27:end-9)); xlim([50 350]);ylim([0 300]);
        
        if ceil(n/8)==n/8
            c=c+1;
        end        
    else
        figure(f), hold on,subplot(ceil(length(namePos)/4),4,i-n+c-1), plot(Data(Restrict(X,sub)),Data(Restrict(Y,sub)),'k');
        GoodDur=round((End(sub)-Start(sub))/10000);
        title([namePos{i-n+c-1}(27:end-9),' (', num2str(round(GoodDur/60)),'min)']); xlim([50 350]);ylim([0 300]);
    end
end

Nquant=0;
for a=1:length(namePos)
    
    if sum(ismember('QuantifExplo',namePos{a}))==12
        Nquant=Nquant+1;
        try
            load(['FinalEpoch',namePos{a}(27:end-9)])
        catch
            disp('no FinalEpochQuantifExplo')
        end
        figure('Color',[1 1 1]);
        g(Nquant)=gcf;
    L=length(Start(FinalEpoch));
    if  L==8|L==4
        for i=1:L
            subepoch=subset(FinalEpoch,i);
            Xsub=Data(Restrict(X,subepoch)); Ysub=Data(Restrict(Y,subepoch));
            figure(g(Nquant)), %hold on, plot(DXepoch(end),DYepoch(end),'ko');
            hold on, subplot(1,2,ceil(i/4)), hold on, scatter(Xsub,Ysub,5,Range(Restrict(Y,subepoch)));
            Dur(i)=floor((Stop(subepoch)-Start(subepoch))/1E4);

            if i==4||i==8
                %legend([num2str(a-3),' (',num2str(Dur(a-3)),'s)'],[num2str(a-2),' (',num2str(Dur(a-2)),'s)'],[num2str(a-1),' (',num2str(Dur(a-1)),'s)'],[num2str(a),' (',num2str(Dur(a)),'s)'])
                title([namePos{a}(27:end-9),' -',num2str(ceil(i/(L/2)))]);xlim([0 300]);ylim([0 300]);
            end
            plot(Xsub(1),Ysub(1),'bo','markerfacecolor','b','linewidth',5)
            %plot(Xsub(end),Ysub(end),'ro','markerfacecolor','r','linewidth',5)
        end
    else
        disp(['probleme: nb session=',num2str(L)])

    end
    end
end
quant='n';


 