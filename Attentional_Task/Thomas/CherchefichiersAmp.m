function[alldata]=CherchefichiersAmp();
titres=[];

ids=[340;428;447;448];
volumes=[15 21 27 30 33];

ids2=repmat(ids,1,length(volumes));
volumes2=repmat(volumes,length(ids),1);
j=1;
taille=size(volumes2);
taille=taille(1)*taille(2);
for j=1:taille
    existence=0;
    i=1;
    id=ids2(j);
    volume=volumes2(j);
    while existence==0
        essai=i;
        titre=sprintf('C:\\Users\\MOBS\\Desktop\\Thomas\\Data\\Etape4\\Calib\\%d\\%ddB\\Souris%dEssai%d.mat',id,volume,id,essai);
        if(exist(titre,'file')==2)
            existence=1;
            titres=[titres;titre];
            A=load(titre);
            A=A(1).A;
        	if(j==1)
                alldata=struct('data',A,'type',volume,'id',id);
            else
                alldata(j).data=A;
                alldata(j).type=volume;
                alldata(j).id=id;
            end
        end
        
        i=i+1;
    end
end
end
