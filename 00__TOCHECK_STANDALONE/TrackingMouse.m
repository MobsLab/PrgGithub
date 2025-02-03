function [Pos,PosTh,Vit,vidFrames]=TrackingMouse(filename,pas)

tic;

try
    pas;
catch
    pas=30;
end

dt=1/30;

AviName=[filename,'.avi'];
ActualDirectory=pwd;

file=fullfile(ActualDirectory,AviName);
%mkdir([filename,'Movie']);
%outputFolder=fullfile(cd,[filename,'Movie']);
%mycommand=['!','ffmpeg',' -i ',file,' ',outputFolder,'/image%d.png']; 
%eval(mycommand)                  

eval(['cd ', filename,'Movie'])

disp('begin')

indx=1;
h = waitbar(0, 'Tracking...');


listfiles=dir;

numFrames=length(listfiles)-2;

% matlabpool(4)
% parfor proc=1:4
%         for ind=1:10:numFrames

        for ind=1:pas:numFrames;
            
            waitbar(ind/numFrames, h);
            
            eval(['vidFrames = imread([''image'',num2str(ind),''.png'']);'])

            Mov=vidFrames(:,:,3);
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
  %          save Pos Pos
        end
% end

% matlabpool close

list=(find(isnan(Pos)));
Pos(list')=Pos(list-1);

close(h);

Ndt=dt*pas;

for i=1:length(Pos)-1
    Vx = (Pos(i,2)-Pos(i+1,2))/(Ndt);
    Vy = (Pos(i,3)-Pos(i+1,3))/(Ndt);
    Vitesse(i) = sqrt(Vx^2+Vy^2);
end;

Vit=SmoothDec(Vitesse',1);
% M=M(Vit>vitTh,:);


% Remove low speed
vitTh=percentile(Vit,50);
PosTh=Pos(find(Vit>vitTh),:);


eval(['cd(''',ActualDirectory,''')'])


le=length(filename);

if filename(le-1:le)=='-1'
    filename=filename(1:le-2);
end

if exist([filename,'.pos']) 
    
    error('File already exists. Aborting.')
    
else

filef = fopen([filename,'.pos'],'w');

for i = 1:length(Pos),
    fprintf(filef,'%f\t',Pos(i,2));
 	fprintf(filef,'%f\n',Pos(i,3));
end


fclose(filef);
end


disp(['Sampling frequency :',num2str(1/median(diff(Pos(:,1)))),'Hz'])


tpp=toc/60;
disp([num2str(floor(tpp)),'min'])

disp(['Number de fremes ',num2str(numFrames/pas)])



