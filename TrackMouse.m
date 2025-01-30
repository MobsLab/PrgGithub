function [Pos,Track,dur]=TrackMouse(filename)




% [Pos,Track]=TrackMouse(filename); save RawData3 Track Pos
% Warning: The end of file was reached before the requested frames were read
% completely.  Frames 1 through 41690 were returned. 
% Warning: The end of file was reached before the requested frames were read
% completely.  Frames 41691 through 55804 were returned. 
% Warning: The end of file was reached before the requested frames were read
% completely.  Frames 55805 through 60761 were returned. 
% Warning: The end of file was reached before the requested frames were read
% completely.  Frames 60762 through 62489 were returned. 
% Warning: The end of file was reached before the requested frames were read
% completely.  Frames 62490 through 63104 were returned. 
% Warning: The end of file was reached before the requested frames were read
% completely.  Frames 63105 through 63320 were returned. 
% Warning: The end of file was reached before the requested frames were read
% completely.  Frames 63321 through 63397 were returned. 
% Warning: The end of file was reached before the requested frames were read
% completely.  Frames 63398 through 63425 were returned. 
% Warning: The end of file was reached before the requested frames were read
% completely.  Frames 63426 through 63435 were returned. 
% Warning: The end of file was reached before the requested frames were read
% completely.  Frames 63436 through 63439 were returned. 
% Warning: The end of file was reached before the requested frames were read
% completely.  Frames 63440 through 63440 were returned.


tic;

pas=10;

OBJ = mmreader(filename);
numFrames = get(OBJ, 'numberOfFrames');

dt=1/30;

dur = get(OBJ, 'Duration');
dt=dur/numFrames;

vidFrames = read(OBJ);

Mov=vidFrames(:,:,3,:);
clear vidFrames
Mov=squeeze(Mov);
numFrames=length(Mov);

im=Mov(:,:,1);
Yi=size(im,1); %240
Xj=size(im,2);
B=zeros(Yi,Xj);
for i=1:Yi
for j=1:Xj
    B(i,j)=sqrt((i-Yi/2)*(i-Yi/2)+(j-Xj/2)*(j-Xj/2));
end
end


Pos=zeros(length(numFrames),3);
Track=Mov(:,:,1:pas:numFrames);

indx=1;
h = waitbar(0, 'Tracking...');
% matlabpool(4)
% parfor proc=1:4
%         for ind=1:10:numFrames
        for ind=1:pas:numFrames
            waitbar(ind/numFrames*10, h);
            im=Mov(:,:,ind);
            im=single(im);
            im(B>160)=100;
            im2=1./im;
            im2(isinf(im2))=nan;
            im2(isnan(im2))= max(max(im2));
            Im=SmoothDec(im2,[2 2]);
            clear im
            clear im2
            [x(ind), y(ind), bodyline, sqr] = FindFly(Im, 10);
            Pos(indx,1)=ind*dt;
            Pos(indx,2)=x(ind);
            Pos(indx,3)=y(ind);
            indx=indx+1;
        end
% end

% matlabpool close

list=(find(isnan(Pos)));
Pos(list')=Pos(list-1);

close(h);

toc

