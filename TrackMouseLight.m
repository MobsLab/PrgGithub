function [Pos,PosTh,Vit,ima,Fs]=TrackMouseLight(filenameavi,Fsamp,ref,mask,siz,lux,plo)
%
%filename='C:\Documents and Settings\Sylvain\Bureau\DataK\Mouse007\03032011\M007_03032011_Explo18-1.avi';
try 
    plo;
catch
plo=0;
end

if siz=='s'
    sizDetect=10;% orig=40 ; marie=30
    ThDetect=320; % orig=3200 ; marie=2200
    sizeSquare=30;
elseif siz=='m'
    sizDetect=20;
    ThDetect=1500;
    sizeSquare=60;
else
    sizDetect=100; %100 
    ThDetect=10000;% orig=3000; NewWebCamESPCI=10000
    sizeSquare=100;% orig=50; NewWebCamESPCI=100
end
smoothFactor=1; %orig=1


OBJ = mmreader(filenameavi);
numFrames = get(OBJ, 'numberOfFrames');
  try
if length(numFrames)==0
    lastFrame = read(OBJ, inf);
numFrames = get(OBJ, 'numberOfFrames');
end
  end
  
  
ima=read(OBJ,1);
dur = get(OBJ, 'Duration');
dur=dur/2; % !!!!!!!!!!!!!!!!!!!!!!!!!! a enlever, bidouille!!
dt=dur/numFrames;
%dt=1/30;


% if exist([filename,'.pos'])
%     error('File already exists. Aborting.')
% else

if strcmp(filenameavi(end-5:end-3),'-1.') || strcmp(filenameavi(end-5:end-3),'-2.')
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

%try
%    pas;
%catch
%    pas=10;
%end
%pas=max(1,round(1/Fsamp/dt));
pas=max(1,round(1/Fsamp/dt))/2;

disp(['   pas = ',num2str(pas),'      Begin tracking...'])

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
    
    %Im=SmoothDec(im2,[1 1]);
    %keyboard
    
    
    %      Im=SmoothDec(im2,[2 2]);
    Im=im2;
    %Ims=SmoothDec(Im,[1 1]);
    
    
    clear im
    clear im2
    if ind>1
        x;
        y;
        x=max(x,0);
        y=max(y,0);
        x=min(x,margesupX);
        y=min(y,margesupY);
        
        a=floor(x);
        b=floor(y);
        if a<=sizeSquare+1%31
            XInf=1;
        else
            XInf=a-sizeSquare;%30;
        end
        
        if a>=size(Im,2)-sizeSquare%30
            XSup=size(Im,2);
        else
            XSup=a+sizeSquare;%30;
        end
        
        
        if b<=sizeSquare+1%31
            YInf=1;
        else
            YInf=b-sizeSquare;%30;
        end
        
        if b>=size(Im,1)-sizeSquare;%30
            YSup=size(Im,1);
        else
            YSup=b+sizeSquare;%30;
        end
        
        
        ImR=Im(YInf:YSup,XInf:XSup);
        
        if plo
            figure(1), clf,hold on,imagesc(Im)
            plot(x,y,'ko','markerfacecolor','w')
            try
                rectangle('position',[XInf YInf XSup-XInf YSup-YInf])
                %             catch
                %             keyboard
            end
        end
        
        ImRs=SmoothDec(ImR,[smoothFactor,1]);
        
        % keyboard
        [x, y, bodyline, sqr] = FindFly(ImRs, sizDetect); %10
        
        if plo
            title([num2str(floor((sqr(2)-sqr(1))*(sqr(4)-sqr(3))/10)*10),'  correct ',num2str(co)])
        end
        
       
        
        if (sqr(2)-sqr(1))*(sqr(4)-sqr(3))>ThDetect %380
            
            if plo
                figure(2), clf,hold on,
                imagesc(ImR)
                plot(x,y,'ko','markerfacecolor','w')
            end
            
            x=x+XInf;
            y=y+YInf;
            
            if plo
                figure(3), clf,hold on,imagesc(Im)
                plot(x,y,'ko','markerfacecolor','w')
                rectangle('position',[XInf YInf XSup-XInf YSup-YInf])
                pause(0)
            end
            
            co=1; 
            
          
        
        else
            
%             keyboard

            Ims=SmoothDec(Im,[smoothFactor,1]);
            
            [x, y, bodyline, sqr] = FindFly(Ims, sizDetect); %10
            x=max(x,0);
            y=max(y,0);
            x=min(x,size(Im,2));
            y=min(y,size(Im,1));
            
            if plo
                
                x=x-XInf;
                y=y-YInf;
            
                figure(2), clf,hold on,
                imagesc(ImR)
                plot(x,y,'ko','markerfacecolor','w')
                
                x=x+XInf;
                y=y+YInf;
                
                figure(3), clf,hold on,imagesc(Im)
                plot(x,y,'ko','markerfacecolor','w')
                %rectangle('position',[XInf YInf XSup-XInf YSup-YInf])
            end
            co=0;
        end
        
        
    else
        
        [x, y, bodyline, sqr] = FindFly(Im, 10);
        x=max(x,0);
        y=max(y,0);
        x=min(x,size(Im,2));
        y=min(y,size(Im,1));
        co=1;
        margesupX=size(Im,2);
        margesupY=size(Im,1);
        
        %ind
        %keyboard
    end
    
    %Im=exp(Im);
    
    %             [i,j]=find(Im(:,:)==max(Im));
    
    
    
    Pos(indx,1)=ind*dt;
    Pos(indx,2)=x(1);
    Pos(indx,3)=y(1);
    Pos(indx,4)=co;
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
try
    load([filename,'.mat'])
    save(filename,'-append','Pos','PosTh','Vit','ima','Fs','LowTh','HighTh');
catch
    save(filename,'Pos','PosTh','Vit','ima','Fs','LowTh','HighTh');
end

