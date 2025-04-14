titre=input('Titre Graphique ?','s');
one=uiimport;
two=uiimport;
three=uiimport;
sequence=[0,6,5,4,3,2,1,0];
cellule=struct('A',{one,two,three});

Y=[];
for k=1:3
    W=cellule(k).A;
    W=getfield(W,'A');
    X=[];
    for i=1:8
        voltage=sequence(i);
        D=find(W(:,1)==voltage);
        E=[];
        j=1;
    
        while(j<length(D) && D(j+1)-D(j)==1)
            j=j+1;
        end    
        if(i~=8)
            E=W(D(1):D(j),:);
        end
        if(i==8)
            E=W(D(j+1):D(length(D)),:);
        end
    
        num=length(E)/2;
        C=[voltage num];
        X=cat(1,X,C);
    end
    Y=cat(1,Y,X);
end    

V=[];
for h=1:8
   voltage=sequence(h);
   Z=[voltage (Y(h,2)+Y(h+8,2)+Y(h+16,2))/3];
   V=cat(1,V,Z);
end

C=[4,1,1,1,1,1,1,1,4,1,1,1,1,1,1,1,4,1,1,1,1,1,1,1];
T=[4,1,1,1,1,1,1,1];
figure
scatter(Y(:,1),Y(:,2),30,C,'o')
hold on
scatter(V(:,1),V(:,2),30,T,'o','fill')
xlim([0,6])
ylim([0,60])
title(titre);
xlabel('Voltage');
ylabel('Nombre de stimulations');


