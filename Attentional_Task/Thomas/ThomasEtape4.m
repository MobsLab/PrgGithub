delete(instrfindall);
port=serial('COM12');
fopen(port)
port.ReadAsyncMode = 'Continuous';
port.ByteOrder='bigEndian';

id=input('Numero Souris ?');
essai=input('Numero Essai ?');
soundlength=input('Duree du son (ms) ? ');
volume=input('Volume (dB) ? ');

if(soundlength==1000)
    timefile='1s';
elseif(soundlength==5000)
    timefile='5s';
elseif(soundlength==500)
    timefile='0.5s';
elseif(soundlength==100)
    timefile='0.1s';
elseif(soundlength==50)
    timefile='0.05s';
elseif(soundlength==20)
    timefile='0.02s';
elseif(soundlength==10)
    timefile='0.01s';
elseif(soundlength==7)
    timefile='0.007s';
elseif(soundlength==5)
    timefile='0.005s';
elseif(soundlength==3)
    timefile='0.003s';
elseif(soundlength==2)
    timefile='0.002s';
elseif(soundlength==1)
    timefile='0.001s';
end

titre=['C:\Users\MOBS\Desktop\Thomas\Data\Etape4\' num2str(volume) 'dB\' num2str(id) '\Souris' num2str(id) 'Essai' num2str(essai) '.mat'];
if (exist(titre,'file')==2)
   disp('Erreur : fichier d�j� existant !');
   return;
end    

cycles=input('How many tones ? ');
fwrite(port,cycles,'uint8');

fwrite(port,soundlength,'uint16');

if(soundlength==1000)
    timefile='1s';
elseif(soundlength==5000)
    timefile='5s';
elseif(soundlength==500)
    timefile='0.5s';
elseif(soundlength==100)
    timefile='0.1s';
end

%%name=['C:\Users\MOBS\Desktop\Thomas\Data\Etape4\' num2str(id) '\' timefile '\Souris' num2str(id) 'Essai' num2str(essai)];

%%if (exist('name','file')==2)
    %%disp('File already exists, program interrupted to avoid overwriting')
    %%return
%%end


start=input('Press 1 to start : ');
%fwrite(port,start,'uint8');
 
if(start==1)
    fwrite(port,start,'uint8');
    A=[];
    zero=clock;
end

while (start==1)
    if(port.BytesAvailable>0)
        temps=etime(clock,zero);
        valeur=fread(port,1,'int8');
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
            [temps valeur]
            start=0;
        elseif(valeur==2 || valeur==3 || valeur==5)
            B=[temps valeur]
            A=[A;B];
        elseif(valeur==1)
            B=[temps valeur]
            A=[A;B];
            turn=length(find(A==1));
            message=[num2str(turn) ' out of ' num2str(cycles)];
            disp(message);
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

if(isempty(A)==1)
    disp('Pas de donn�es')
    return;
end
save(['C:\Users\MOBS\Desktop\Thomas\Data\Etape4\' num2str(volume) 'dB\' num2str(id) '\Souris' num2str(id) 'Essai' num2str(essai) '.mat'],'A')

