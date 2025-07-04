function [Pos,PosTh,Vit,ima]=TrackMouseLight(filename,pas)
%
%filename='C:\Documents and Settings\Sylvain\Bureau\DataK\Mouse007\03032011\M007_03032011_Explo18-1.avi';

fileaviname=[filename,'.avi'];

tic;

try
    pas;
catch
    pas=10;
end

OBJ = mmreader(fileaviname);
numFrames = get(OBJ, 'numberOfFrames');
ima=read(OBJ,1);

dt=1/30;

dur = get(OBJ, 'Duration');
dt=dur/numFrames;


disp('begin')


indx=1;
h = waitbar(0, 'Tracking...');

% matlabpool(4)
% parfor proc=1:4
%         for ind=1:10:numFrames



        for ind=1:pas:numFrames
            waitbar(ind/numFrames, h);
            
            vidFrames = read(OBJ,ind);

            Mov=vidFrames(:,:,3,1);

            im=Mov;
            im=single(im);

            im2=1./im;
            im2(isinf(im2))=nan;
            im2(isnan(im2))= max(max(im2));
            Im=SmoothDec(im2,[2 2]);
            Im=exp(Im);
            
%             [i,j]=find(Im(:,:)==max(Im));
            clear im
            clear im2
            [x, y, bodyline, sqr] = FindFly(Im, 10);
            Pos(indx,1)=ind*dt;
            Pos(indx,2)=x(1);
            Pos(indx,3)=y(1);
            indx=indx+1;
%             save Pos Pos
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


% Remove low speed
vitTh=percentile(Vit,20);
PosTh=Pos(find(Vit>vitTh),:);

toc

le=length(filename);

if filename(le-1:le)=='-1'
    filename=filename(1:le-2);
end

if exist([filename,'.pos']) 
    
    error('File already exists. Aborting.')
    
else

file = fopen([filename,'.pos'],'w');

for i = 1:length(Pos),
	fprintf(file,'%f\t',Pos(i,1));
    fprintf(file,'%f\t',Pos(i,2));
 	fprintf(file,'%f\n',Pos(i,3));
end


fclose(file);
end


disp(['Sampling frequency :',num2str(1/median(diff(Pos(:,1)))),'Hz'])

