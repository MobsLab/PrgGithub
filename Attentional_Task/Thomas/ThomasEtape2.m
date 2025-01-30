port=serial('COM12');
fopen(port)
port.ReadAsyncMode = 'Continuous';

fin=0;
explength=input('Durée expérience ? ');
explength=60*explength;

id=input('Numéro souris ? \n');
essai=input('Numéro essai ? \n');

start=input('Press 1 to start : ');
fwrite(port,start);

if(start==1)
    A=[];
    zero=clock;
end

while (start==1 && fin~=1)
    if(port.BytesAvailable>0)
        temps=etime(clock,zero);
        valeur=fread(port,1,'uint8');
        B=[temps valeur]
        A=[A;B];
        %{
        if(valeur==1)
            B=[temps 1]
            A=[A;B];
        end
        if(valeur==2)
            B=[temps 2]
            A=[A;B];
        end
        if(valeur==3)
            B=[temps 3]
            A=[A;B];
        end
        %}
    end
    
    if(etime(clock,zero)>explength)
        fin=1;
        fwrite(port,1);
    end
end

disp(A)
disp('END')
fclose(port);
clear port;
delete(instrfindall)

save(['C:\Users\MOBS\Desktop\Thomas\Data\Etape2\Souris' num2str(id) '\Souris' num2str(id) 'Essai' num2str(essai)],'A')

K=[1 mean([60.2 59.6 57.5]); 2 mean([65.6 65.3 64.9]); 3 mean([65.8 65.9 64.9]); 4 mean([66.9 69.1 67.9]); 5 mean([68.3 65.3 66.2]); 6 mean([71.6 71.7 72.4]); 7 mean([75.1 74.6 74.6]); 8 mean([76.1 78.3 76.4])]
