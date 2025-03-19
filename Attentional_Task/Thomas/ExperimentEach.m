function[] = ExperimentEach()
wantbatch=input('Quel numero de protocole ? \n');
%wantbatch=2;
alltest=CherchefichiersPrivation(wantbatch);
ids=unique(cat(1,alltest(:).id),'rows');
ids=sortrows(ids);
idsall=cat(1,alltest(:).id);
idsall=sortrows(idsall);
conv=cat(1,alltest(:).type);
shorttypes=unique(cat(1,alltest(:).type),'rows');
shorttypes=sortrows(shorttypes);
types=cat(1,alltest(:).type);
types2=arrayfun(@changertype2,num2str(types),'UniformOutput',false);
conv=num2str(conv);
conv2=strcat('-',conv,'ms');
totalmeanmissed=sortrows(cat(1,alltest(:).id));
totalmeanmissed=num2str(totalmeanmissed);
conv3=[totalmeanmissed conv2];
[totalmeanmissed,totalstdmissed,totalmeantime,totalstdtime,totalmeanmotiv,totalstdmotiv,missedpoints,timepoints,motivpoints]=deal([]);
for k=1:size(ids,1)
    for i=1:size(shorttypes,1)
        adress=find(cat(1,alltest(:).type)==shorttypes(i) & str2num(cat(1,alltest(:).id))==str2num(ids(k,:)));
        bigmissed=[];
        bigmotiv=[];
        bigtime=[];
        bigdistrib=[];
        for j=1:length(adress)
            [motiv,time,missed,distrib]=y({alltest(adress(j)).data}, {alltest(adress(j)).type/1000});
            bigmissed=[bigmissed missed];
            bigmotiv=[bigmotiv motiv];
            bigtime=[bigtime time];
            missedpoints=[missedpoints;missed (k-1)*3+(i)];
            timepoints=[timepoints;time (k-1)*3+(i)];
            motivpoints=[motivpoints;motiv (k-1)*3+(i)];
            bigdistrib=[bigdistrib;distrib];
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
end
cumu=[idsall {types2}];
categories={};
for m=1:size(idsall,1)
    each=([cumu{1,1}(m,:) cumu{1,2}(m,:)]);
    categories=[categories;each];
end
for m=1:size(categories,1)
    categories{m,1}=[categories{m,1} categories{m,2}];
end
v=length(wantbatch);
figure
subplot(1,3,1)
bar([totalmeanmissed])
hold on
errorbar(totalmeanmissed,totalstdmissed,'Linestyle','none','Marker','o','MarkerSize',1,'MarkerFaceColor','b')
hold on
scatter(missedpoints(:,2),missedpoints(:,1),'SizeData',30,'MarkerFaceColor','w','MarkerEdgeColor','b')
set(gca,'XtickLabel',categories(:,1))
%set(gca,'YtickLabel', sprintf('%d%%|', 0:20:100))
xlabel('Conditions')
ylabel('Percentage of missed NP (%)')
title(['Missed NP percentage per condition (n=' num2str(size(ids,1)) ')' '(m=' num2str(v) ')'])
ylim([0 100])
subplot(1,3,2)
bar([totalmeantime])
hold on
errorbar(totalmeantime,totalstdtime,'Linestyle','none','Marker','o','MarkerSize',1,'MarkerFaceColor','b')
hold on
scatter(timepoints(:,2),timepoints(:,1),'SizeData',30,'MarkerFaceColor','w','MarkerEdgeColor','b')
set(gca,'XtickLabel',categories(:,1))
%set(gca,'YtickLabel', sprintf('%ds|', 0:1:4))
xlabel('Conditions')
ylabel('Average reaction time (s)')
title(['Mean reaction time per condition (n=' num2str(size(ids,1)) ')' '(m=' num2str(v) ')'])
ylim([0 4])
subplot(1,3,3)
bar([totalmeanmotiv])
hold on
errorbar(totalmeanmotiv,totalstdmotiv,'Linestyle','none','Marker','o','MarkerSize',1,'MarkerFaceColor','b')
hold on
scatter(motivpoints(:,2),motivpoints(:,1),'SizeData',30,'MarkerFaceColor','w','MarkerEdgeColor','b')
set(gca,'XtickLabel',categories(:,1))
%set(gca,'YtickLabel', sprintf('%d%%|', 0:20:100))
xlabel('Conditions')
ylabel('Percentage of passive state (%)')
title(['Passive state percentage per condition (n=' num2str(size(ids,1)) ')' '(m=' num2str(v) ')'])
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
    type=input('Dur�e du son (ms) ? \n');
    if(i==1)
        alldata=struct('data',A,'type',type,'id',id);
    else
        alldata(i).data=A;
        alldata(i).type=type;
        alldata(i).id=id;
    end
    getdata=input('Continuer a importer des donnees ? (1 pour OUI, 0 pour NON) \n');
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

function [y]=changertype2(str)
if(strcmpi('0',str))
    y = ':0';
elseif(strcmpi('1',str))
    y = ':1';
elseif(strcmpi('2',str))
    y = ':2';
else
    y = str;
end
end

