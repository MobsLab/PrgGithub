function [C,C1,C2,cm,groupTrue,groupPredicted]=ConfusionMatEpoch(Epochpredicted,Epochtrue,label,ts1,plo)

%[C,C1,C2,cm]=ConfusionMatEpoch(Epochpredicted,Epochtrue,label,ts1,plo)

try
    ts1;
    rg=Range(ts1);
catch
    for j=1:length(Epochtrue)
        stT(j)=min(Start(Epochtrue{j}));
        enT(j)=max(End(Epochtrue{j}));
    end
    for j=1:length(Epochpredicted)
        stP(j)=min(Start(Epochpredicted{j}));
        enP(j)=max(End(Epochpredicted{j}));
    end
    st=min([stT;stP]);
    en=max([enT;enP]);
    rg=[st:1E3:en];
    ts1=ts(rg);
end

try
    plo;
catch
    plo=1;
end

groupTrue=zeros(length(rg),1);
groupPredicted=zeros(length(rg),1);
    
for j=1:length(Epochtrue)
    rgTrue=Range(Restrict(ts1,Epochtrue{j}));
    rgPredicted=Range(Restrict(ts1,Epochpredicted{j}));
    groupTrue(ismember(rg,rgTrue))=j;
    groupPredicted(ismember(rg,rgPredicted))=j;
end

idT=find((groupTrue==0));
idP=find((groupPredicted==0));

groupTrue([idT;idP])=[];
groupPredicted([idT;idP])=[];

C = confusionmat(groupTrue,groupPredicted);


sC1=sum(C,1);
for i=1:length(C)
    C1(i,:)=C(i,:)./sC1*100;
end
C1=diag(C1);

sC2=sum(C,2);
for i=1:length(C)
    C2(:,i)=C(:,i)./sC2*100;
end
C2=diag(C2);

if plo
    figure('color',[1 1 1]),
    try
    cm=confusionchart(C,label);
    catch
     cm=confusionchart(C);   
    end
    cm.RowSummary = 'row-normalized';
    cm.ColumnSummary = 'column-normalized';
else
    cm=[];
end

    


