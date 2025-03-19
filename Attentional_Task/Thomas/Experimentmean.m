function[] = Experimentmean()
wantbatch=input('Quel numero de protocole ? \n');
couleurs=[1 1 0;1 0 0;0 1 0;0 1 0;1 1 1;0 0 0;0 1 1];
colorvector=[];
groupes=[];
%wantbatch=3;
alltest=CherchefichiersPrivation(wantbatch);
ids=unique(cat(1,alltest(:).id),'rows');
ids=str2num(ids);
conv=cat(1,alltest(:).type);
types=unique(cat(1,alltest(:).type));
types=sort(types,'ascend');
types2=arrayfun(@changertype,num2str(types),'UniformOutput',false);

conv=num2str(conv);

conv2=strcat('-',conv,'ms');
totalmeanmissed=sortrows(cat(1,alltest(:).id));
totalmeanmissed=num2str(totalmeanmissed);
conv3=[totalmeanmissed conv2];
[totalmeanmissed,totalstdmissed,totalmeantime,totalstdtime,totalmeanmotiv,totalstdmotiv,missedpoints,timepoints,motivpoints,totaldistrib2]=deal([]);
totaldistrib={};
for i=1:length(types)
    adress=find([alltest(:).type]==types(i));
    bigmissed=[];
    bigmotiv=[];
    bigtime=[];
    bigdistrib=[];
    for j=1:length(adress)
        [motiv,time,missed,distrib]=y({alltest(adress(j)).data}, {alltest(adress(j)).type/1000});
        bigmissed=[bigmissed missed];
        bigmotiv=[bigmotiv motiv];
        bigtime=[bigtime time];
        missedpoints=[missedpoints;missed i];
        timepoints=[timepoints;time i];
        motivpoints=[motivpoints;motiv i];
        bigdistrib=[bigdistrib;distrib];
        ok=0;
        h=1;
        while(ok==0)
            if(str2num(alltest(adress(j)).id)==ids(h))
                colorvector=[colorvector;couleurs(h,1)];
                groupes=[groupes;ids(h)];
                ok=1;
            else
                h=h+1;
            end
        end
        
    end
    meanmissed=mean(bigmissed);
    stdmissed=std(bigmissed);
    meantime=mean(bigtime);
    stdtime=std(bigtime);
    meanmotiv=mean(bigmotiv);
    stdmotiv=std(bigmotiv);
    totalstdmissed=[totalstdmissed stdmissed];
    totalmeanmissed=[totalmeanmissed meanmissed];
    totalmeantime=[totalmeantime meantime];
    totalstdtime=[totalstdtime stdtime];
    totalmeanmotiv=[totalmeanmotiv meanmotiv];
    totalstdmotiv=[totalstdmotiv stdmotiv];
    totaldistrib=[totaldistrib bigdistrib];
    %totaldistrib2=[totaldistrib2 bigdistrib];
end
figure
subplot(2,3,4:6);
t=0:0.5:10;
t=t';
distribcontrole=hist(totaldistrib{1},t);
distribcontrole=100*distribcontrole/length(totaldistrib{1});
distribprivation=hist(totaldistrib{2},t);
distribprivation=100*distribprivation/length(totaldistrib{2});
distribsleep=hist(totaldistrib{3},t);
distribsleep=100*distribsleep/length(totaldistrib{3});
distribcontrole=transpose(distribcontrole);
distribprivation=transpose(distribprivation);
distribsleep=transpose(distribsleep);
mark1=ones(length(t),1);
mark0=0*mark1;
mark2=2*mark1;
greatdistrib=[[t;t;t],[distribcontrole;distribprivation;distribsleep],[mark0;mark1;mark2]];
greatdistrib=sortrows(greatdistrib,1);
%bar(t,[distribcontrole,distribprivation,distribsleep],0.5);
z=gscatter(greatdistrib(:,1),greatdistrib(:,2),greatdistrib(:,3));
set(z,'LineStyle','-','Marker','none')
%counts2=hist(totaldistrib,0:0.5:15);
%counts2=100*counts2/length(totaldistrib);
%bar(0:0.5:15,counts2,'barwidth',0.5)
xlim([0;10])
ylim([0;50])
title('Distribution du premier NP (Controle=0,Post-Privation=1,Post-Sleep=2)')
xlabel('Delai (s)')
ylabel('Probabilité (%)')

%figure
subplot(2,3,1)
bar([totalmeanmissed],0.3)
hold on
errorbar(totalmeanmissed,totalstdmissed,'Linestyle','none','Marker','o','MarkerSize',1,'MarkerFaceColor','b')
hold on
%scatter(missedpoints(:,2),missedpoints(:,1),30,colorvector,'MarkerFaceColor','w','MarkerEdgeColor','b')
doleg='off';
sizes=repmat([30],length(groupes),1);
gscatter(missedpoints(:,2),missedpoints(:,1),groupes)
set(gca,'XtickLabel',types2)
%set(gca,'YtickLabel', sprintf('%d%%|', 0:20:100))
xlabel('Conditions')
ylabel('Percentage of missed NP (%)')
title(['Missed NP percentage per condition (n=' num2str(size(ids,1)) ')'])
ylim([0 100])
subplot(2,3,2)
bar([totalmeantime],0.3)
hold on
errorbar(totalmeantime,totalstdtime,'Linestyle','none','Marker','o','MarkerSize',1,'MarkerFaceColor','b')
hold on
gscatter(timepoints(:,2),timepoints(:,1),groupes)
%scatter(timepoints(:,2),timepoints(:,1),'SizeData',30,'MarkerFaceColor','w','MarkerEdgeColor','b')
set(gca,'XtickLabel',types2)
%set(gca,'YtickLabel', sprintf('%ds|', 0:1:4))
xlabel('Conditions')
ylabel('Average reaction time (s)')
title(['Mean reaction time per condition (n=' num2str(size(ids,1)) ')'])
ylim([0 4])
subplot(2,3,3)
bar([totalmeanmotiv],0.3)
hold on
errorbar(totalmeanmotiv,totalstdmotiv,'Linestyle','none','Marker','o','MarkerSize',1,'MarkerFaceColor','b')
hold on
gscatter(motivpoints(:,2),motivpoints(:,1),groupes)
scatter(motivpoints(:,2),motivpoints(:,1),'SizeData',30,'MarkerFaceColor','w','MarkerEdgeColor','b')
set(gca,'XtickLabel',types2)
%set(gca,'YtickLabel', sprintf('%d%%|', 0:20:100))
xlabel('Conditions')
ylabel('Percentage of passive state (%)')
title(['Passive state percentage per condition (n=' num2str(size(ids,1)) ')'])
ylim([0 100])
end
    
function[alldata] = blabla()
alldata=[];
i=0;
getdata=1;
while (getdata==1)
    i=i+1;
    A=uiimport();
    A=A(1).A;
    id=input('Numero de la souris ? \n');
    type=input('Duree du son (ms) ? \n');
    if(i==1)
        alldata=struct('data',A,'type',type,'id',id);
    else
        alldata(i).data=A;
        alldata(i).type=type;
        alldata(i).id=id;
    end
    getdata=input('Continuer a importer des donnï¿½es ? (1 pour OUI, 0 pour NON) \n');
end
end

function[y] = glue(x)

[i, j]=size(x);
for k=1:j
    p=sprintf('%s',x{[1;2],k});
    y{k}=p;
end
end

function [y]=changertype(str)
if(strcmpi('0',str))
    y = ' Controle';
elseif(strcmpi('1',str))
    y = ' Post-Privation';
elseif(strcmpi('2',str))
    y = ' Post-Sleep';
else
    y = str;
end
end


