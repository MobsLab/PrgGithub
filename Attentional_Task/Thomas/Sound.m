function [A, Y]=Sound()
delete(instrfindall);
canal=serial('COM13');
fopen(canal);
canal.ReadAsyncMode = 'Continuous';
canal.ByteOrder='bigEndian';
%fwrite(canal,30000,'uint16');
timelength=20;
start=input('Taper 1 pour commencer \n');
fwrite(canal,start,'int8');
zero=clock;
A=[];
while(start==1)
    if(canal.Bytesavailable>0)
        temps=etime(clock,zero);
        valeur=fread(canal,1,'int8');
        [temps valeur]
        A=[A;temps valeur];
    end
    if(etime(clock,zero)>timelength)
        start=0;
        fwrite(canal,0);
    end
end

disp('END')
fclose(canal);
delete(instrfindall);
Y=A(25:length(A),:);
Y(:,3)=Y(:,2)*3.3/1024;
figure
plot(Y(:,1),Y(:,3))

end





