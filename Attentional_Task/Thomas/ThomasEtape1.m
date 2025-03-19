port=serial('COM12');
fopen(port)
port.ReadAsyncMode = 'Continuous';

start=0;
fin=0;
explength=input('Durée expérience ? ');
explength=60*explength;

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
        if(valeur==2)
            B=[temps 2]
            A=[A;B];
        end
        if(valeur==3)
            B=[temps 3]
            A=[A;B];
        end
        if(valeur==5)
            B=[temps 5]
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
sum(A(find(A==5)-length(A))-A(find(A==3)-length(A)))
disp('END')
fclose(port);
delete(instrfindall)