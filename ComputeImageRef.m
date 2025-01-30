function [ref,mask,siz,FreqVideo]=ComputeImageRef(nom,DoCircle)

% createArtificialAviRef=0;
askFrames=1;
try
    DoCircle;
catch
    DoCircle=0;
end
% Envt=1 pour open field
% Envt=2 pour Environnement 2

% if length(nom)==1
%     Envt=nom;
% end



% try
%     
%     load(['C:\Documents and Settings\Sylvain\Bureau\DataK\ImageRef-',num2str(Envt),'.mat'])
%     try
%         ref=ref(:,:,3,1);
%         ref=single(ref);
%     end
%     
% catch
    
%filename=['ImageRef-',num2str(Envt),'.avi'];
OBJ = mmreader(nom);
numFrames = get(OBJ, 'numberOfFrames');
  try
if length(numFrames)==0
    lastFrame = read(OBJ, inf);
numFrames = get(OBJ, 'numberOfFrames');
end
  end
                        

FreqVideo= input('Enter frequency acquisition of Video (or 0 if unknown) : ');
if FreqVideo==0
    lengthavi=input('Enter length of video Ref.avi (s) : ');
    FreqVideo=round( numFrames/lengthavi);
    disp(['FreqVideo =',num2str(FreqVideo) ' frames per second']);
end

if askFrames
    ok='n';
    while ok~='y'
    Frames=input('Give frames of the videoFile to use as reference images (default=[1 10 20]) : ');
    vidFrames1 = read(OBJ,Frames(1)); figure('Color',[1 1 1]), subplot(1,3,1), imagesc(vidFrames1);
    vidFrames2 = read(OBJ,Frames(2));subplot(1,3,2), imagesc(vidFrames2);
    vidFrames3 = read(OBJ,Frames(3));subplot(1,3,3), imagesc(vidFrames3);
    ok=input('Correct reference images (y/n)? ','s');
    close;
    end
    
else
    ima=read(OBJ,1); figure('Color',[1 1 1]), imagesc(ima)
    vidFrames1 = read(OBJ,1);
    try
        vidFrames2 = read(OBJ,10);
        vidFrames3 = read(OBJ,20);
    catch
        vidFrames2 = read(OBJ,2);
        vidFrames3 = read(OBJ,3);
    end
end

% if createArtificialAviRef
%     vidFrames=[vidFrames3(:,1:259,:),vidFrames2(:,260:640,:)];
%     figure('Color',[1 1 1]), imshow(vidFrames)
%     aviobj=avifile('Ref');
%     aviobj = addframe(aviobj,vidFrame);
%     aviobj=close(aviobj);
% end
Mo1=vidFrames1(:,:,3);
Mo2=vidFrames2(:,:,3);
Mo3=vidFrames3(:,:,3);
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
subplot(2,1,1), imagesc(Mo),
subplot(2,1,2), imagesc(Mov); %, title(['threshold : ',num2srt(th)])
hold on, title(nom);

rep='y';

while rep=='y'
    rep=input('Change color threshold ? (y/n) ','s');
    if rep=='y'
        th=input('New threshold (default=70) :');
        
        Mov1=Mo1;
        Mov2=Mo2;
        Mov3=Mo3;
        
        Mov1(Mo1<th)=th;
        Mov2(Mo2<th)=th;
        Mov3(Mo3<th)=th;
        
        Mov=(Mov1+Mov2+Mov3)/3;
        
        figure(num), clf,
        hold on, title(nom);
        subplot(2,1,1), imagesc(Mo), 
        subplot(2,1,2), imagesc(Mov),%, title(['threshold : ',num2srt(th)])
        
    end
end
ref=single(Mov);

ok='y';
disp('Determine the appropriate area on image.')
while ok=='y'
    
    figure(num), clf, 
    subplot(2,1,2), imagesc(vidFrames1); title(nom);
    subplot(2,1,1),imagesc(Mo), 
    
    
    [XGrid,YGrid]=meshgrid(1:size(ref,1),1:size(ref,2));
    if DoCircle
        title('Click on the center then on one point of the circle, then press ENTER') ;
        [y,x]=ginput;
        xc=x(1);yc=y(1);
        Rad=sqrt((y(2)-yc)^2+(x(2)-xc)^2);
        
        A=sqrt((YGrid-yc).*(YGrid-yc)+(XGrid-xc).*(XGrid-xc));
        %figure('Color',[1 1 1]), imagesc(A); axis xy
        mask=A';
        mask(find(mask<=Rad))=0;
        mask(find(mask>Rad))=1;
        
    else
        title('Click to determine a square area, then press ENTER');
        [x,y]=ginput;
        xmi=min(y);
        xma=max(y);
        yma=max(x);
        ymi=min(x);
        XGrid((XGrid>xmi&XGrid<xma))=0;
        YGrid((YGrid<yma&YGrid>ymi))=0;
        mask=XGrid'+YGrid';
        mask(find(mask>0))=1;
        mask(find(mask<0))=0;
        
    end
    
    
    mask=1-abs(mask);
    R=ref;
    R(find(mask==0))=0;
    
    
    figure('Color',[1 1 1])
    hold on, title(nom);
    subplot(2,1,1), imagesc(ref),
    subplot(2,1,2), imagesc(2*R+ref), title('Change the area? (y/n)')
    
    ok=input('Change the area? (y/n) : ','s');
    close
end
close (num)        
%     elseif Envt==1
%     figure('Color',[1 1 1])
%     num3=gcf;
%     subplot(2,1,1), imagesc(ref)
%     subplot(2,1,2), imagesc(2*R+ref), title('changer le contour? (o/n)')
%     
%     ok=input('Changer le contour? (o/n) : ','s');
%     
%     while ok=='o'
%         
% figure(num+1), clf, imagesc(Mo), title('delimiter le centre du cercle')
% hold on, title(nom);
%     [yc,xc]=ginput;
%     figure(num+1), clf, imagesc(Mo); hold on, plot(yc,xc,'ko'); title('delimiter le rayon du cercle')
%     [y,x]=ginput;
%     Rad=sqrt((y-yc)^2+(x-xc)^2);
%     
%     [XGrid,YGrid]=meshgrid(1:size(ref,1),1:size(ref,2));
%     A=sqrt((YGrid-yc).*(YGrid-yc)+(XGrid-xc).*(XGrid-xc));
%     figure, imagesc(A);
%     mask=A';
%     mask(find(mask<=Rad))=1;
%     mask(find(mask>Rad))=0;
%     mask=1-abs(mask);
%     R=ref;
%     R(find(mask==0))=0;
%     figure('Color',[1 1 1])
%     hold on, title(nom);
%     num3=gcf;
%     subplot(2,1,1), imagesc(ref)
%     subplot(2,1,2), imagesc(2*R+ref), title('changer le contour? (o/n)')
%     
%     ok=input('Changer le contour? (o/n) : ','s');
%     
%     end

% 
% if Envt==1
%      save ImageRef-1  ref mask
% elseif Envt==2
%      save ImageRef-2  ref mask
% end
%end

siz=input('Size of the mouse? (l=large m=medium s=small) : ','s');



