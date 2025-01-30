function[] = Controlemean()
wantessais=input('Quels essais ? \n');
mode=input('Mode ? \n');
couleurs=[1 1 0;1 0 0;0 1 0;0 1 0;1 1 1;0 0 0;0 1 1];
colorvector=[];
groupes=[];
%wantbatch=3;
alltest=CherchefichiersControle(wantessais);
ids=unique(cat(1,alltest(:).id),'rows');
ids=str2num(ids);
essais=unique(cat(1,alltest(:).essai),'rows');
%essais=str2num(essais);
essais=sortrows(essais);
essais2=str2num(essais);
%essais2=arrayfun(@changertype,num2str(essais),'UniformOutput',false);
totalmeanmissed=sortrows(cat(1,alltest(:).id));
totalmeanmissed=num2str(totalmeanmissed);
[totalmeanmissed,totalstdmissed,totalmeantime,totalstdtime,totalmeanmotiv,totalstdmotiv,missedpoints,timepoints,motivpoints]=deal([]);
if (mode==1)
    for i=1:length(essais2)
        adress=find(str2num(cat(1,alltest(:).essai))==essais2(i));
        bigmissed=[];
        bigmotiv=[];
        bigtime=[];
        bigdistrib=[];
        for j=1:length(adress)
            [motiv,time,missed,distrib]=y({alltest(adress(j)).data}, {0.005});
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
                    %colorvector=[colorvector;couleurs(h,1)];
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
    end
    figure
    subplot(1,3,1)
    bar([totalmeanmissed])
    hold on
    errorbar(totalmeanmissed,totalstdmissed,'Linestyle','none','Marker','o','MarkerSize',1,'MarkerFaceColor','b')
    hold on
    %scatter(missedpoints(:,2),missedpoints(:,1),30,colorvector,'MarkerFaceColor','w','MarkerEdgeColor','b')
    doleg='off';
    sizes=repmat([30],length(groupes),1);
    gscatter(missedpoints(:,2),missedpoints(:,1),groupes)
    set(gca,'XtickLabel',essais2)
    %set(gca,'YtickLabel', sprintf('%d%%|', 0:20:100))
    xlabel('Essais')
    ylabel('Percentage of missed NP (%)')
    title(['Missed NP percentage per condition (n=' num2str(size(ids,1)) ')'])
    ylim([0 100])
    subplot(1,3,2)
    bar([totalmeantime])
    hold on
    errorbar(totalmeantime,totalstdtime,'Linestyle','none','Marker','o','MarkerSize',1,'MarkerFaceColor','b')
    hold on
    gscatter(timepoints(:,2),timepoints(:,1),groupes)
    %scatter(timepoints(:,2),timepoints(:,1),'SizeData',30,'MarkerFaceColor','w','MarkerEdgeColor','b')
    set(gca,'XtickLabel',essais2)
    %set(gca,'YtickLabel', sprintf('%ds|', 0:1:4))
    xlabel('Conditions')
    ylabel('Average reaction time (s)')
    title(['Mean reaction time per condition (n=' num2str(size(ids,1)) ')'])
    ylim([0 4])
    subplot(1,3,3)
    bar([totalmeanmotiv])
    hold on
    errorbar(totalmeanmotiv,totalstdmotiv,'Linestyle','none','Marker','o','MarkerSize',1,'MarkerFaceColor','b')
    hold on
    gscatter(motivpoints(:,2),motivpoints(:,1),groupes)
    scatter(motivpoints(:,2),motivpoints(:,1),'SizeData',30,'MarkerFaceColor','w','MarkerEdgeColor','b')
    set(gca,'XtickLabel',essais2)
    %set(gca,'YtickLabel', sprintf('%d%%|', 0:20:100))
    xlabel('Conditions')
    ylabel('Percentage of passive state (%)')
    title(['Passive state percentage per condition (n=' num2str(size(ids,1)) ')'])
    ylim([0 100])
end
if (mode==2)
    for i=1:length(ids)
        adress=find(str2num(cat(1,alltest(:).id))==ids(i));
        bigmissed=[];
        bigmotiv=[];
        bigtime=[];
        bigdistrib=[];
        for j=1:length(adress)
            [motiv,time,missed,distrib]=y({alltest(adress(j)).data}, {0.005});
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
                if(str2num(alltest(adress(j)).essai)==essais2(h))
                    %colorvector=[colorvector;couleurs(h,1)];
                    groupes=[groupes;essais(h,1:2)];
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
    end
    figure
    subplot(1,3,1)
    bar([totalmeanmissed])
    hold on
    errorbar(totalmeanmissed,totalstdmissed,'Linestyle','none','Marker','o','MarkerSize',1,'MarkerFaceColor','b')
    hold on
    %scatter(missedpoints(:,2),missedpoints(:,1),30,colorvector,'MarkerFaceColor','w','MarkerEdgeColor','b')
    doleg='off';
    sizes=repmat([30],length(groupes),1);
    gscatter(missedpoints(:,2),missedpoints(:,1),groupes)
    set(gca,'XtickLabel',ids)
    %set(gca,'YtickLabel', sprintf('%d%%|', 0:20:100))
    xlabel('Essais')
    ylabel('Percentage of missed NP (%)')
    title(['Missed NP percentage per condition (m=' num2str(size(essais2,1)) ')'])
    ylim([0 100])
    subplot(1,3,2)
    bar([totalmeantime])
    hold on
    errorbar(totalmeantime,totalstdtime,'Linestyle','none','Marker','o','MarkerSize',1,'MarkerFaceColor','b')
    hold on
    gscatter(timepoints(:,2),timepoints(:,1),groupes)
    %scatter(timepoints(:,2),timepoints(:,1),'SizeData',30,'MarkerFaceColor','w','MarkerEdgeColor','b')
    set(gca,'XtickLabel',ids)
    %set(gca,'YtickLabel', sprintf('%ds|', 0:1:4))
    xlabel('Conditions')
    ylabel('Average reaction time (s)')
    title(['Mean reaction time per condition (m=' num2str(size(essais2,1)) ')'])
    ylim([0 4])
    subplot(1,3,3)
    bar([totalmeanmotiv])
    hold on
    errorbar(totalmeanmotiv,totalstdmotiv,'Linestyle','none','Marker','o','MarkerSize',1,'MarkerFaceColor','b')
    hold on
    gscatter(motivpoints(:,2),motivpoints(:,1),groupes)
    scatter(motivpoints(:,2),motivpoints(:,1),'SizeData',30,'MarkerFaceColor','w','MarkerEdgeColor','b')
    set(gca,'XtickLabel',ids)
    %set(gca,'YtickLabel', sprintf('%d%%|', 0:20:100))
    xlabel('Conditions')
    ylabel('Percentage of passive state (%)')
    title(['Passive state percentage per condition (m=' num2str(size(essais2,1)) ')'])
    ylim([0 100])
end
if (mode==3)
    for i=1:length(essais2)
        adress=find(str2num(cat(1,alltest(:).essai))==essais2(i));
        bigmissed=[];
        bigmotiv=[];
        bigtime=[];
        bigdistrib=[];
        for j=1:length(adress)
            [motiv,time,missed,distrib]=y({alltest(adress(j)).data}, {0.005});
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
                    %colorvector=[colorvector;couleurs(h,1)];
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
    end
    figure
    %scatter(missedpoints(:,2),missedpoints(:,1),30,colorvector,'MarkerFaceColor','w','MarkerEdgeColor','b')
    z=gscatter(missedpoints(:,2),missedpoints(:,1),groupes)
    set(z,'LineStyle','-')
    %set(gca,'YtickLabel', sprintf('%d%%|', 0:20:100))
    xlabel('Essais')
    ylabel('Percentage of missed NP (%)')
    title(['Missed NP percentage per condition (n=' num2str(size(ids,1)) ')'])
    ylim([0 100])
end
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
    getdata=input('Continuer a importer des donn�es ? (1 pour OUI, 0 pour NON) \n');
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


