function[conv2, conv3] = CorrectSound()
%alltest=blabla();
alltest=CherchefichiersTemps();
ids=unique(cat(1,alltest(:).id),'rows');
conv=cat(1,alltest(:).type);

conv=num2str(conv);

conv2=strcat('-',conv,'ms');
b=sortrows(cat(1,alltest(:).id));
b=num2str(b);
conv3=[b conv2];
[~, b]=deal([]);
for i=1:length(ids)
    adress=find([alltest(:).id]==ids(i));
    a=[];
    for j=1:length(adress)
        [~, ~, missed]=y({alltest(adress(j)).data}, {alltest(adress(j)).type/1000});
        a=[a missed];
    end
    b=[b a];

end
figure
bar([b])
set(gca,'XtickLabel',conv3)
title(['Pourcentage de rates (n=' num2str(length(ids)) ')'])
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

function [y]=changerson(str)
y=strcat('-',str);
%{
str
if(strcmpi('100',str))
    y = '-Contr�le';
elseif(strcmpi('1',str))
    y = '-Post-Privation';
elseif(strcmpi('2',str))
    y = '-Post-Sleep';
else
    y = str;
end
%}
end


