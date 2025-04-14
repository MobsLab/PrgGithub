delete(instrfindall);
port=serial('COM12');
fopen(port);
port.ReadAsyncMode = 'Continuous';

fin=0;
intervalle=100;
pause on;
id=input('Numéro souris ? \n');
essai=input('Numéro essai ? \n');
titre=input('Titre expérience : ','s');
start=input('Press 1 to start : ');
fwrite(port,start,'uint8'); 

if(start==1)
    A=[];
    zero=clock;
end


tour=7;
sequence=[0,6,5,4,3,2,1,0];
for i=1:8
    compteur=0;
    affiche=1;
    voltage=sequence(i);
    if(fin==1)
        fin=0;
        fwrite(port,0,'uint8');
    end
    while (start==1 && fin==0)
        if(port.BytesAvailable>0)
            temps=etime(clock,zero);
            valeur=fread(port,1,'uint8');
            if(valeur==2)
                B=[voltage temps 2]
                A=[A;B];
            end
            if(valeur==3)
                if(compteur==0)
                   zerobis=clock;
                   affiche=0;
                end
                compteur=compteur+1;
                B=[voltage temps 3]
                A=[A;B];
            end
        end
        
        if(affiche==0 && etime(clock,zerobis)>80)
            disp('20s avant changement');
            affiche=1;
        end
        
        if(compteur~=0 && etime(clock,zerobis)>intervalle)
            disp('Changement maintenant !');
            fin=1;
            fwrite(port,1,'uint8');
            pause(4);
        end
        
    end
    
    
end

disp(A)

X=[];
for i=1:8
    voltage=sequence(i);
    D=find(A(:,1)==voltage);
    E=[];
    j=1;
    
    while(j<length(D) && D(j+1)-D(j)==1)
        j=j+1;
    end    
    if(i~=8)
        E=A(D(1):D(j),:);
    end
    if(i==8)
        E=A(D(j+1):D(length(D)),:);
    end
    
    num=length(E)/2;
    C=[voltage num];
    X=cat(1,X,C);
end
%{
plot(X(:,1),X(:,2))
xlim([0,6])
ylim([0,60])
title(titre);
xlabel('Voltage');
ylabel('Nombre de stimulations');
%}

C=[4,1,1,1,1,1,1,1];
figure
scatter(X(:,1),X(:,2),30,C,'o')
xlim([0,6])
ylim([0,60])
title(titre);
xlabel('Voltage');
ylabel('Nombre de stimulations');


disp('END')
fclose(port);
delete(instrfindall)

save(['C:\Users\MOBS\Desktop\Thomas\Data\Calibration\Souris' num2str(id) '\TableauSouris' num2str(id) 'Essai' num2str(essai)],'A')