function [Pos,PosTh,Vit,ima,Fs]=TrackMouseLightML(filenameavi,Fsamp,ref,mask,siz,lux)
%
%filename='C:\Documents and Settings\Sylvain\Bureau\DataK\Mouse007\03032011\M007_03032011_Explo18-1.avi';

plo=1;

smoothFactor=10;
if siz=='s'
    sizDetect=10;% orig=40 ; marie=30
elseif siz=='m'
    sizDetect=20;
else
    sizDetect=100; %100 
end

OBJ = mmreader(filenameavi);
numFrames = get(OBJ, 'numberOfFrames');
ima=read(OBJ,1);
dur = get(OBJ, 'Duration');
dt=dur/numFrames;
%dt=1/30;


if strcmp(filenameavi(end-5:end),'-1.avi') || strcmp(filenameavi(end-5:end),'-2.avi')
    filename=filenameavi(1:end-6);
else
    filename=filenameavi(1:end-4);
end


try
    lux;
catch
    lux=1;
end

tic;

pas=round(1/Fsamp/dt);
disp(['   pas = ',num2str(pas),'      Begin tracking...'])

indx=1;
h = waitbar(0, 'Tracking...');


for ind=1:pas:numFrames
    waitbar(ind/numFrames, h);
    
    vidFrames = read(OBJ,ind);
    Mov=vidFrames(:,:,3,1);
    
    im=Mov;
    im=single(im);
    
    try
        im=im-ref;
    end
    
    try
        im(mask==0)=0; % im(find(mask==0))=0;
    end
    
    if lux==1
        im2=-im;
    else
        im2=im;
    end
    
    im2(isinf(im2))=nan;
    im2(isnan(im2))= max(max(im2));

    Im=SmoothDec(im2,[smoothFactor,1]);
    
    clear im im2
    
    [x, y] = FindFlyML(Im, sizDetect);
    
    if plo
        figure(2), clf,hold on,
        imagesc(Im)
        plot(x,y,'ko','markerfacecolor','w')
    end
    

    Pos(indx,1)=ind*dt;
    Pos(indx,2)=x;
    Pos(indx,3)=y;
    Pos(indx,4)=1;
    indx=indx+1;

end
% end



% matlabpool close

list=(find(isnan(Pos)));
Pos(list')=Pos(list-1);

Ndt=dt*pas;

close(h);

for i=1:length(Pos)-1
    Vx = (Pos(i,2)-Pos(i+1,2))/(Ndt);
    Vy = (Pos(i,3)-Pos(i+1,3))/(Ndt);
    Vitesse(i) = sqrt(Vx^2+Vy^2);
end;

Vit=SmoothDec(Vitesse',1);
% M=M(Vit>vitTh,:);


% Remove low speed + Remove artefacts - too high speed

vitTh=percentile(Vit,20);
PosTh=Pos(Vit>vitTh & Vit<10*median(Vit),:);
% PosTh=Pos(find(Vit>vitTh,:);

toc;


file = fopen([filename,'.pos'],'w');

for i = 1:length(Pos),
    fprintf(file,'%f\t',Pos(i,2));
    fprintf(file,'%f\t',Pos(i,3));
    fprintf(file,'%f\n',Pos(i,4));
end


fclose(file);
% end

LowTh=vitTh;
HighTh=10*median(Vit);

disp(['   Sampling frequency :',num2str(1/median(diff(Pos(:,1)))),'Hz']);

Fs=1/median(diff(Pos(:,1)));
save(filename,'Pos','PosTh','Vit','ima','Fs','LowTh','HighTh');

