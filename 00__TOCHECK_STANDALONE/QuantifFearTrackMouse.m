function [Pos,PosTh,Vit,ima,Fs]=QuantifFearTrackMouse(filename,Fsamp,ref,mask,siz,lux)
%
%filename='C:\Documents and Settings\Sylvain\Bureau\DataK\Mouse007\03032011\M007_03032011_Explo18-1.avi';

plo=0;


if siz=='s'
    sizDetect=40;
    ThDetect=3200;   
    sizeSquare=30;
elseif siz=='m'
    sizDetect=60;
    ThDetect=6200;   
    sizeSquare=40;
else
    sizDetect=100;
    ThDetect=7000;
    sizeSquare=50;
end


fileaviname=[filename,'.avi'];

le=length(filename);

if filename(le-1:le)=='-1'
    filename=filename(1:le-2);
end

% if exist([filename,'.pos'])
%     
%     error('File already exists. Aborting.')
%     
% else
    
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
    
    OBJ = mmreader(fileaviname);
    numFrames = get(OBJ, 'numberOfFrames');
    ima=read(OBJ,1);
    
    %dt=1/30;
    
    dur = get(OBJ, 'Duration');
    dt=dur/numFrames;
    
    pas=round(1/Fsamp/dt);
    
    disp(['pas = ',num2str(pas)])
    disp('  ')
    
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
        
        try
            im=im-ref;
        end
        
        try
            im(find(mask==0))=0;
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
            
            [x, y, bodyline, sqr] = FindFly(ImR, sizDetect); %10
            
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

                            [x, y, bodyline, sqr] = FindFly(Im, sizDetect); %10
                            x=max(x,0);
                            y=max(y,0);
                            x=min(x,size(Im,2));
                            y=min(y,size(Im,1));

                        if plo    
                            
                            
                        figure(2), clf,hold on,
                        imagesc(ImR)
                        plot(x,y,'ko','markerfacecolor','w')
                        
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
    PosTh=Pos(find(Vit>vitTh & Vit<10*median(Vit)),:);
    % PosTh=Pos(find(Vit>vitTh,:);
    
    toc
    
    
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

disp(['Sampling frequency :',num2str(1/median(diff(Pos(:,1)))),'Hz']);

Fs=1/median(diff(Pos(:,1)));
eval(['save ',filename,' Pos PosTh Vit ima Fs LowTh HighTh'])

