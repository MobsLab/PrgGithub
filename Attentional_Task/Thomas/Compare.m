function[alldata] = Compare()
alldata=[];
i=0;
getdata=1;
while (getdata==1)
    i=i+1;
    A=uiimport();
    A=A(1).A;
    id=input('Numero de la souris ? \n');
    type=input('Contrôle (0), post-privation (1), post-sleep (2) ? \n');
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

function [y] = changer(str)
if( strcmpi('0',str))
    y = 'Contrôle';
elseif( strcmpi('1',str))
    y = 'Post-Privation';
elseif( strcmpi('2',str))
    y = 'Post-Sleep';
else
    y = str;
end
end



%{
function[] = analyze()
alltest=Compare();
%h=@x;
ids=unique(cat(1,alltest(:).id),'rows');
    
    
conv=zeros(length(cat(1,alltest(:).id)),1);
conv(:)=cat(1,alltest(:).type);
    
conv=num2str(conv);
conv=num2cell(conv);
    
conv2=cellfun(changer,conv)
    
    
conv(cat(1,conv{:})==0)={'Contrôle'};
conv{cell2mat(conv)==1}={'Post-Privation'};
conv(cat(1,conv{:})==2)={'Post-Sleep'};

[a, b, c, d, e, f, g, h, j]=deal([]);
for i=1:length(ids)
    adress=find([alltest(:).id]==ids(i));
    control=find(([alltest(:).type]==0) & ([alltest(:).id]==ids(i)));
    [motivation0,reactiontime0,missed0]=arrayfun(@x,{alltest(control).data});
    postprivation=find(([alltest(:).type]==1) & ([alltest(:).id]==ids(i)));
    [motivation1,reactiontime1,missed1]=arrayfun(@x,{alltest(postprivation).data});
    postsleep=find(([alltest(:).type]==2) & ([alltest(:).id]==ids(i)));
    [motivation2,reactiontime2,missed2]=arrayfun(@x,{alltest(postsleep).data});
        
    n=min(cat(1,length(control),length(postprivation),length(postsleep)));
        
    motivation0=mean(motivation0);
    motivation1=mean(motivation1);
    motivation2=mean(motivation2);
    reactiontime0=mean(reactiontime0);
    reactiontime1=mean(reactiontime1);
    reactiontime2=mean(reactiontime2);
    missed0=mean(missed0);
    missed1=mean(missed1);
    missed2=mean(missed2);
        
    a=[a motivation0];
    b=[b motivation1];
    c=[c motivation2];
    d=[d reactiontime0];
    e=[e reactiontime1];
    f=[f reactiontime2];
    g=[g missed0];
    h=[h missed1];
    j=[j missed2];
        
        %{
        figure
        bar([motivation0;motivation1;motivation2])
        title(['Souris ' num2str(ids(i)) ': Pourcentage de non motivation'])
        figure
        bar([reactiontime0;reactiontime1;reactiontime2])
        title(['Souris ' num2str(ids(i)) ': Temps moyen de réaction'])
        figure
        bar([missed0;missed1;missed2])
        title(['Souris ' num2str(ids(i)) ': Pourcentage de ratés'])
        %}
end
figure
subplot(3,1,1)
bar([a b c])
title(['Pourcentage de non motivation (n=' num2str(length(ids)) ')'])
ylim([0 100])
subplot(3,1,2)
bar([d e f])
title(['Temps moyen de réaction (n=' num2str(length(ids)) ')'])
ylim([0 3.1])
subplot(3,1,3)
bar([g h j])
title(['Pourcentage de ratés (n=' num2str(length(ids)) ')'])
ylim([0 100])
end
%}







