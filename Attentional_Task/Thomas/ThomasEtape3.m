delete(instrfindall);
port=serial('COM12');
fopen(port);
port.ReadAsyncMode = 'Continuous';
port.ByteOrder='bigEndian';

id=input('Numéro Souris ?');
essai=input('Numéro Essai ?');

cycles=input('How many tones?');
fwrite(port,cycles,'uint8');

soundlength=input('Durée du son (ms) ?');
fwrite(port,soundlength,'uint16');

start=input('Press 1 to start: ');
fwrite(port,start);

%while (start==0)
%
%
%end  
if(start==1)
    A=[];
    zero=clock;
end
while (start==1)
    if(port.BytesAvailable>0)
        temps=etime(clock,zero);
        valeur=fread(port,1,'uint8');
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
        if(valeur==4)
            start=0;
        elseif(valeur==1 || valeur==2 || valeur==3 || valeur==5)
            B=[temps valeur]
            A=[A;B];
        end
    end
end

disp(A)
disp('END')
fclose(port);
clear port;
delete(instrfindall)

if(soundlength==1000)
    timefile='1s';
elseif(soundlength==5000)
    timefile='5s';
elseif(soundlength==500)
    timefile='0.5s';
elseif(soundlength==100)
    timefile='0.1s';
end    


save(['C:\Users\MOBS\Desktop\Thomas\Data\Etape3\' timefile '\' num2str(id) '\Souris' num2str(id) 'Essai' num2str(essai)],'A')


