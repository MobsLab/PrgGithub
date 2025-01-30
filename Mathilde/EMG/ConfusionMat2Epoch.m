function [C,C1,C2,cm,grouprem,grouplow]=ConfusionMat2Epoch(Epochpredicted,Epochtrue,label,ts1,plo)

try
    ts1;
    rg=Range(ts1);
catch
    stT=Start(Epochtrue);
    stP=Start(Epochpredicted);
    enT=End(Epochtrue);
    enP=End(Epochpredicted);
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

rgrem=Range(Restrict(ts1,Epochtrue));
rglow=Range(Restrict(ts1,Epochpredicted));
grouprem=zeros(length(rg),1);
grouplow=zeros(length(rg),1);
grouprem(ismember(rg,rgrem))=1;
grouplow(ismember(rg,rglow))=1;
C = confusionmat(grouprem,grouplow);


sC1=sum(C,1);
C1(1,:)=C(1,:)./sC1*100;
C1(2,:)=C(2,:)./sC1*100;

sC2=sum(C,2);
C2(:,1)=C(:,1)./sC2*100;
C2(:,2)=C(:,2)./sC2*100;


if plo
    try
        label;
        catch
    label={'ctrl','target'};
    end
    
    figure('color',[1 1 1]),
    cm=confusionchart(C,label);
    cm.RowSummary = 'row-normalized';
    cm.ColumnSummary = 'column-normalized';
else
    cm=[];
end

    


