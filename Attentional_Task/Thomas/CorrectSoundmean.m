function[conv2, conv3] = CorrectSoundmean()
%alltest=blabla();
alltest=CherchefichiersTemps();
ids=unique(cat(1,alltest(:).id),'rows');
conv=cat(1,alltest(:).type);
types=unique(cat(1,alltest(:).type));
types=sort(types,'descend')
conv=num2str(conv);

conv2=strcat('-',conv,'ms');
b=sortrows(cat(1,alltest(:).id));
b=num2str(b);
conv3=[b conv2];
[a, b, c, d, e, missedpoints]=deal([]);
for k=1:length(types)
    adress=find([alltest(:).type]==types(k));
    a=[];
    for i=1:length(adress)
        [m n missed]=y({alltest(adress(i)).data}, {alltest(adress(i)).type/1000});
        a=[a missed]
        missedpoints=[missedpoints;missed k]
    end
    c=mean(a);
    e=std(a);
    d=[d e]
    b=[b c] 

end
figure
bar([b])
hold on
errorbar(b,d,'Linestyle','none','Marker','o','MarkerSize',0.1,'MarkerFaceColor','b')
scatter(missedpoints(:,2),missedpoints(:,1),'MarkerEdgeColor','b','MarkerFaceColor','w','Marker','o')
set(gca,'XtickLabel',strcat(num2str(types),'ms'))
title(['Pourcentage de ratés (n=' num2str(length(ids)) ')'])
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
    type=input('Durée du son (ms) ? \n');
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


