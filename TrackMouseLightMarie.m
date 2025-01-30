function Pos=TrackMouseLightMarie(filename)
%filename='C:\Users\Invité\Desktop\Mouse setup\DataSmrAvi\Mouse02_13012011.avi';

tic;

pas=50;

OBJ = mmreader(filename);
numFrames = get(OBJ, 'numberOfFrames');

dt=1/30;

dur = get(OBJ, 'Duration');
dt=dur/numFrames;
rest=rem(numFrames,pas);

disp('begin')


indx=1;
h = waitbar(0, 'Tracking...');

% matlabpool(4)
% parfor proc=1:4
%         for ind=1:10:numFrames



        for ind=round(numFrames*0.3):pas:numFrames
            waitbar(ind/numFrames, h);
            
            vidFrames = read(OBJ,ind);

            Mov=vidFrames(:,:,3,1);

            im=Mov;
            im=single(im);

            im2=1./im;
            im2(isinf(im2))=nan;
            im2(isnan(im2))= max(max(im2));
            Im=SmoothDec(im2,[2 2]);
            clear im
            clear im2
            [x, y, bodyline, sqr] = FindFly(Im, 10);
            Pos(indx,1)=ind*dt;
            Pos(indx,2)=x(1);
            Pos(indx,3)=y(1);
            indx=indx+1;
            save Pos Pos
        end
% end

% matlabpool close

list=(find(isnan(Pos)));
Pos(list')=Pos(list-1);

close(h);

toc

