function [A,t,Atsd,Perc,Freeze,Freeze2]=QuantifFearCtxB(filename,fac,th,thtps,lim)


% surface mouse 12000 pixels
% fac number of frame to identify movment default value 7
%th threshold freezing default value 2
%thtps minimum time for freezing periods default valut 3s

plo=1;


OBJ = mmreader(filename);
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


for ind=1:pas:lim-fac

    vidFrames1 = read(OBJ,ind);
    vidFrames2 = read(OBJ,ind+fac);
    Mov1=vidFrames1(:,:,3,1);
    Mov2=vidFrames2(:,:,3,1);
    Im1=single(Mov1(55:215,80:240));
    Im2=single(Mov2(55:215,80:240));
    Im1(Im1>65)=65;
    Im2(Im2>65)=65;
    A(a)=sqrt(sum(sum(((Im2-Im1).*(Im2-Im1)))))/12000/2*100;


   if plo
    figure(num), clf
    subplot(2,3,1),imagesc(vidFrames1(30:220,55:215,:,1))    
    subplot(2,3,2),imagesc(vidFrames2(30:220,55:215,:,1))
    subplot(2,3,3),imagesc(Im2-Im1), caxis([-50 50])
    subplot(2,3,4:6),plot(t(1:a),(A),'k','linewidth',2), title([num2str(t(floor(a))),' s'])
    try
        xlim([t(a)-30 t(a)])
    end
        ylim([0 10])
        
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




