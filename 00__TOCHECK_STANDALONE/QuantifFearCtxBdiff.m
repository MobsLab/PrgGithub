function [A,t,Atsd,Perc,Freeze,Freeze2]=QuantifFearCtxBdiff(filename,filenameRef,fac,th,thtps,lim)


%surface mouse = 12000 pixels
%fac = number of frame to identify movment default value 7
%th = threshold freezing default value 2
%thtps = minimum time for freezing periods default valut 2s
%filename = video souris
%filenameref = video de r�ference du contexte sans souris

plo=1;


OBJ = mmreader(filename);
OBJ2 = mmreader(filenameRef);
numFrames = get(OBJ, 'numberOfFrames');
dur = get(OBJ, 'Duration');
dt=dur/numFrames; 

f=1/dt;


try 
    lim;
catch
    lim=numFrames;
end


if plo==0
    h = waitbar(0, 'Tracking...');
else
    figure('color',[1 1 1])
num=gcf;
end

%pas=floor(fac/2);
pas=1;

a=1;
t=[1:pas:lim-fac]*dt;

%diff�renciel entre la vid�o et la video ref�rence sans souris, puis entre
%deux images de la vid�o, ave un intervalle=fac

for ind=1:pas:lim-fac

    vidFramesRef = read(OBJ2,ind);
    vidFramesRef (vidFramesRef>50)=50;
    vidFramesA = read(OBJ,ind);
    vidFrames1 = vidFramesRef-vidFramesA;
    vidFrames1 (vidFrames1>80)=200;
    vidFramesB = read(OBJ,ind+fac);
    vidFrames2 = vidFramesRef-vidFramesB;
    vidFrames2 (vidFrames2>80)=200;
                
    Mov1=vidFrames1(:,:,3,1);
    Mov2=vidFrames2(:,:,3,1);
    Im1=single(Mov1(30:210,55:200));
    Im2=single(Mov2(30:210,55:200));
    Im1(Im1>65)=65;
    Im2(Im2>65)=65;
    A(a)=sqrt(sum(sum(((Im2-Im1).*(Im2-Im1)))))/12000/2*100;

%image et graphique en % de diff�rence
   if plo
    figure(num), clf
    subplot(2,3,1),imagesc(vidFramesRef(30:210,55:200,:,1))
    subplot(2,3,2),imagesc(vidFrames1(30:210,55:200,:,1))    
    subplot(2,3,3),imagesc(vidFrames2(30:210,55:200,:,1))
    subplot(2,3,4),imagesc(Im2-Im1), caxis([-50 50])
    subplot(2,3,5:6),plot(t(1:a),(A),'k','linewidth',2), title([num2str(t(floor(a))),'s'])  
    try
        xlim([t(a)-15 t(a)]);
    end
        ylim([0 10]);
        
   else
       
           waitbar(ind/numFrames, h);
         
   end
   
    a=a+1;    
end



if plo==0
    close(h)
end

Atsd=tsd(t*1E4',SmoothDec(A',1));
Freeze=thresholdIntervals(Atsd,th,'Direction','Below');
Freeze2=dropShortIntervals(Freeze,thtps*1E4);

Perc=sum(End(Freeze2,'s')-Start(Freeze2,'s'))/dur*100;


%calcul du pourcentage de freezing minute par minute
%for i=(1:9);
%min(i)=((i*1800):(((i+1)*1800)-fac))*dt;


%Atsd(i)=tsd(min(i)*1E4',SmoothDec(A',1));
%FreezeMin(i)=thresholdIntervals(Atsd(i),th,'Direction','Below');
%Freeze2Min(i)=dropShortIntervals(FreezeMin(i),thtps*1E4);

%PercMin(i)=sum(End(Freeze2Min(i),'s')-Start(Freeze2Min(i),'s'))/dur*100;
%end
%Perc=(PercMin(0):PercMin(9));

keyboard

