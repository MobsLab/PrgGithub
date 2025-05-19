function[alldata]=CherchefichiersTemps()
titres=[];

ids=[340;428;447;448];
timelengths=[0.05 0.01 0.007 0.005 0.001];
%volumes=[15 21 27 30 33];

ids2=repmat(ids,1,length(timelengths));
%volumes2=repmat(volumes,length(ids),1);
timelengths2=repmat(timelengths,length(ids),1);
j=1;
delete=[];
taille=size(timelengths2);
taille=taille(1)*taille(2);
for j=1:taille
    existence=0;
    i=1;
    id=ids2(j);
    %volume=volumes2(j);
    timelength=timelengths2(j);
    while existence==0
        essai=i;
        titre=sprintf('C:\\Users\\MOBS\\Desktop\\Thomas\\Data\\Etape4\\21dB\\%d\\%ss\\Souris%dEssai%d.mat',id,num2str(timelength),id,essai);
        if(exist(titre,'file')==2)
            existence=1;
            A=load(titre);
            A=A(1).A;
        	if(j==1)
                alldata=struct('data',A,'type',timelength*1000,'id',id);
            else
                alldata(j).data=A;
                alldata(j).type=timelength*1000;
                alldata(j).id=id;
            end
        end
        
        i=i+1;
        if(i>50)
            existence=1
            delete=[delete;j];
        end
    end
end
alldata(delete)=[];
end