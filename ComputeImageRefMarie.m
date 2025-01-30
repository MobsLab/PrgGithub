function [ref,mask,siz]=ComputeImageRefMarie(nom,TimeS);

% TimeS= time of the video, in seconde


OBJ = mmreader(nom);
numFrames = get(OBJ, 'numberOfFrames');

for tt=1:length(TimeS)
    ima=read(OBJ,15*TimeS(tt)); figure, imagesc(ima)
end
ok=input('Ref images ok? 1=yes/0=no: ');

while ok~=1
    TimeS=input('Enter new time vector for Ref : ');
    for tt=1:length(TimeS)
        ima=read(OBJ,15*TimeS(tt)); figure, imagesc(ima)
    end
    ok=input('Ref images ok? 1=yes/0=no: ');
end

vidFrames1 = read(OBJ,15*TimeS(1));
vidFrames2 = read(OBJ,15*TimeS(ceil(length(TimeS)/2)));
vidFrames3 = read(OBJ,15*TimeS(end));

Mo1=vidFrames1(:,:,3,1);
Mo2=vidFrames2(:,:,3,1);
Mo3=vidFrames3(:,:,3,1);
Mo1=single(Mo1);
Mo2=single(Mo2);
Mo3=single(Mo3);
Mo=(Mo1+Mo2+Mo3)/3;

Mov1=Mo1;
Mov2=Mo2;
Mov3=Mo3;


th=10;

Mov1(Mo1<th)=th;
Mov2(Mo2<th)=th;
Mov3(Mo3<th)=th;

Mov=(Mov1+Mov2+Mov3)/3;

figure('Color',[1 1 1]),num=gcf; 
subplot(2,1,1), imagesc(Mo)
subplot(2,1,2), imagesc(Mov)%, title(['threshold : ',num2srt(th)])
hold on, title(nom);



rep='o';

while rep=='o'
rep=input('changer le seuil ? (o/n) ','s');
if rep=='o'
    th=input('Nouveau seuil (valeur par defaut 70) :');
    
    Mov1=Mo1;
    Mov2=Mo2;
    Mov3=Mo3;

    Mov1(Mo1<th)=th;
    Mov2(Mo2<th)=th;
    Mov3(Mo3<th)=th;

    Mov=(Mov1+Mov2+Mov3)/3;

figure(num), clf,
hold on, title(nom);
subplot(2,1,1), imagesc(Mo)
subplot(2,1,2), imagesc(Mov)%, title(['threshold : ',num2srt(th)])

end
end

ref=single(Mov);


if 1
    figure(num+1), clf, imagesc(Mo), title('delimiter le contour')
    hold on, title(nom);
    
    [x,y]=ginput;
    xmi=min(y);
    xma=max(y);
    yma=max(x);
    ymi=min(x);
    [XGrid,YGrid]=meshgrid(1:size(ref,1),1:size(ref,2));
    XGrid((XGrid>xmi&XGrid<xma))=0;
    YGrid((YGrid<yma&YGrid>ymi))=0;
    mask=XGrid'+YGrid';
    mask(find(mask>0))=1;
    mask(find(mask<0))=0;
    mask=1-abs(mask);
    R=ref;
    R(find(mask==0))=0;
    
    figure('Color',[1 1 1])
    hold on, title(nom);
    num3=gcf;
    subplot(2,1,1), imagesc(ref)
    subplot(2,1,2), imagesc(2*R+ref), title('changer le contour? (o/n)')
    
    ok=input('Changer le contour? (o/n) : ','s');
    
    while ok=='o'
        
        figure(num+1), clf, imagesc(Mo), title('delimiter le contour')
        hold on, title(nom);
        [x,y]=ginput;
        xmi=min(y);
        xma=max(y);
        yma=max(x);
        ymi=min(x);
        [XGrid,YGrid]=meshgrid(1:size(ref,1),1:size(ref,2));
        XGrid((XGrid>xmi&XGrid<xma))=0;
        YGrid((YGrid<yma&YGrid>ymi))=0;
        mask=XGrid'+YGrid';
        mask(find(mask>0))=1;
        mask(find(mask<0))=0;
        mask=1-abs(mask);
        
        R=ref;
        R(find(mask==0))=0;
        
        
        figure(num3)
        hold on, title(nom);
        subplot(2,1,1), imagesc(ref)
        subplot(2,1,2), imagesc(ref+2*R), title('changer le contour? (o/n)')
        ok=input('Changer le contour? (o/n) : ','s');

    end
    
    
elseif Envt==1
    
    figure(num+1), clf, imagesc(Mo), title('delimiter le centre du cercle')
    hold on, title(nom);
    [yc,xc]=ginput;
    figure(num+1), clf, imagesc(Mo); hold on, plot(yc,xc,'ko'); title('delimiter le rayon du cercle')
    [y,x]=ginput;
    Rad=sqrt((y-yc)^2+(x-xc)^2);
    
    [XGrid,YGrid]=meshgrid(1:size(ref,1),1:size(ref,2));
    A=sqrt((YGrid-yc).*(YGrid-yc)+(XGrid-xc).*(XGrid-xc));
    figure, imagesc(A);
    mask=A';
    mask(find(mask<=Rad))=0;
    mask(find(mask>Rad))=1;
    mask=1-abs(mask);
    R=ref;
    R(find(mask==0))=0;
    figure('Color',[1 1 1])
    num3=gcf;
    subplot(2,1,1), imagesc(ref)
    subplot(2,1,2), imagesc(2*R+ref), title('changer le contour? (o/n)')
    
    ok=input('Changer le contour? (o/n) : ','s');
    
    while ok=='o'
        
figure(num+1), clf, imagesc(Mo), title('delimiter le centre du cercle')
hold on, title(nom);
    [yc,xc]=ginput;
    figure(num+1), clf, imagesc(Mo); hold on, plot(yc,xc,'ko'); title('delimiter le rayon du cercle')
    [y,x]=ginput;
    Rad=sqrt((y-yc)^2+(x-xc)^2);
    
    [XGrid,YGrid]=meshgrid(1:size(ref,1),1:size(ref,2));
    A=sqrt((YGrid-yc).*(YGrid-yc)+(XGrid-xc).*(XGrid-xc));
    figure, imagesc(A);
    mask=A';
    mask(find(mask<=Rad))=1;
    mask(find(mask>Rad))=0;
    mask=1-abs(mask);
    R=ref;
    R(find(mask==0))=0;
    figure('Color',[1 1 1])
    hold on, title(nom);
    num3=gcf;
    subplot(2,1,1), imagesc(ref)
    subplot(2,1,2), imagesc(2*R+ref), title('changer le contour? (o/n)')
    
    ok=input('Changer le contour? (o/n) : ','s');
    
    end
end
% 
% if Envt==1
%      save ImageRef-1  ref mask
% elseif Envt==2
%      save ImageRef-2  ref mask
% end
%end

siz=input('Taille de la souris? (large (l) /medium (m) /small (s)) : ','s');

if exist('Ref','file')
    
    disp('Ref file exists')
    keyboard
else
    save Ref ref mask siz
end

