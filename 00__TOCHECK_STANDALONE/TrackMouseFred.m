function [Pos,Track]=TrackMouseFred(filename)

dt=1/30;

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

OBJ = mmreader(filename);
numFrames = get(OBJ, 'numberOfFrames');

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

Pos=zeros(floor(length(numFrames)/4),3);
Track=Mov(:,:,1:10:numFrames);
try
    matlabpool close
end
matlabpool(4)
parfor proc=1:4          
      
            im3d=Mov(:,:,(proc+(proc-1)/(2*proc)):10:(proc/4)*numFrames);
            im3d=single(im3d);
            im3d(B>160)=100;
            im3d=1./im3d;
            im3d(isinf(im3d))=nan;
            im3d(isnan(im3d))= max(im3d(:)); 
            
            indx=1;
            x=[];
            y=[];
            t=[];
            
            for ind=1:size(im3d,3)                
                im2=im3d(:,:,ind);
                im2=squeeze(im2);
                Im=SmoothDec(im2,[2 2]);                
%                 Im=im2;
                [xfly, yfly, bodyline, sqr] = FindFly(Im, 10);
                x=[x ; xfly];
                y=[y ; yfly];
                t=[t; ind*dt];
                
%             Pos(ind,1,proc)=ind*dt;
%             Pos(ind,2,proc)=xfly;
%             Pos(ind,3,proc)=yfly;

            
            end          
            x
%             Pos(:,1,proc)=t;
%             Pos(:,2,proc)=x;
%             Pos(:,3,proc)=y;
end

%  Pos=[ Pos(:,:,1); Pos(:,:,2); Pos(:,:,3); Pos(:,:,4)];
matlabpool close

% list=(find(isnan(Pos)));
% Pos(list')=Pos(list-1);

