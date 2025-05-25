function[] = CorrectAmp(data)
%alltest=blabla();
alltest=Cherchefichiers();
ids=unique(cat(1,alltest(:).id),'rows');
conv=cat(1,alltest(:).type);
types=unique(cat(1,alltest(:).type));
types=sort(types);
conv=num2str(conv);

conv2=strcat('-',conv,'dB');
totalmeanmissed=sortrows(cat(1,alltest(:).id));
totalmeanmissed=num2str(totalmeanmissed);
conv3=[totalmeanmissed conv2];
[totalmeanmissed,totalstdmissed,totalmeantime,totalstdtime,totalmeanmotiv,totalstdmotiv,motivpoints,missedpoints,timepoints]=deal([]);
for i=1:length(types)
    adress=find([alltest(:).type]==types(i));
    bigmissed=[];
    bigmotiv=[];
    bigtime=[];
    for j=1:length(adress)
        [motiv,time,missed]=y({alltest(adress(j)).data}, {alltest(adress(j)).type/1000});
        bigmissed=[bigmissed missed];
        bigmotiv=[bigmotiv motiv];
        bigtime=[bigtime time];
        motivpoints=[motivpoints;motiv i];
        timepoints=[timepoints;time i];
        missedpoints=[missedpoints;missed i];
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
end
figure
subplot(1,3,1)
bar([totalmeanmissed])
hold on
errorbar(totalmeanmissed,totalstdmissed,'Linestyle','none','Marker','o','MarkerSize',0.1,'MarkerFaceColor','b')
hold on
scatter(missedpoints(:,2),missedpoints(:,1),'MarkerEdgeColor','b','MarkerFaceColor','w','Marker','o')
set(gca,'XtickLabel',strcat('-', num2str(types),'dB'))
%set(gca,'YtickLabel', sprintf('%d%%|', 0:20:100))
ylabel('Percentage of missed NP (%)')
xlabel('Relative Sound intensity (dB)')
title(['Missed NP percentage per intensity (n=' num2str(length(ids)) ')'])
ylim([0 100])
subplot(1,3,2)
bar([totalmeantime])
hold on
errorbar(totalmeantime,totalstdtime,'Linestyle','none','Marker','o','MarkerSize',0.1,'MarkerFaceColor','b')
hold on
scatter(timepoints(:,2),timepoints(:,1),'MarkerEdgeColor','b','MarkerFaceColor','w','Marker','o')
set(gca,'XtickLabel',strcat('-', num2str(types),'dB'))
%set(gca,'YtickLabel', sprintf('%ds|', 0:1:4))
ylabel('Average reaction time (s)')
xlabel('Relative Sound intensity (dB)')
title(['Average reaction time per intensity (n=' num2str(length(ids)) ')'])
ylim([0 4])
subplot(1,3,3)
bar([totalmeanmotiv])
hold on
errorbar(totalmeanmotiv,totalstdmotiv,'Linestyle','none','Marker','o','MarkerSize',0.1,'MarkerFaceColor','b')
hold on
scatter(motivpoints(:,2),motivpoints(:,1),'MarkerEdgeColor','b','MarkerFaceColor','w','Marker','o')
set(gca,'XtickLabel',strcat('-', num2str(types),'dB'))
%set(gca,'YtickLabel', sprintf('%d%%|', 0:20:100))
ylabel('Percentage of passive state (%)')
xlabel('Relative Sound intensity (dB)')
title(['Passive state percentage per intensity (n=' num2str(length(ids)) ')'])
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
    type=input('Volume (dB) ? \n');
    if(i==1)
        alldata=struct('data',A,'type',type,'id',id);
    else
        alldata(i).data=A;
        alldata(i).type=type;
        alldata(i).id=id;
    end
    getdata=input('Continuer à importer des données ? (1 pour OUI, 0 pour NON) \n');
end
end

function[y] = glue(x)

[i, j]=size(x);
for k=1:j
    p=sprintf('%s',x{[1;2],k});
    y{k}=p;
end
end

function [y]=changerson(str)
y=strcat('-',str);
%{
str
if(strcmpi('100',str))
    y = '-Contrôle';
elseif(strcmpi('1',str))
    y = '-Post-Privation';
elseif(strcmpi('2',str))
    y = '-Post-Sleep';
else
    y = str;
end
%}
end


