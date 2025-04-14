function [A,t,Atsd,Perc,Freeze,Freeze2]=QuantifFear2(filename,fac,th,thtps,lim,siz)


% surface mouse 12000 pixels
% fac number of frame to identify movment default value 7
%th threshold freezing default value 2
%thtps minimum time for freezing periods default valut 3s

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

OBJ = mmreader(filename);
numFrames = get(OBJ, 'numberOfFrames');
dur = get(OBJ, 'Duration');
dt=dur/numFrames;
f=1/dt;



try 
    lim;
catch
    lim=numFrames;
end


if plo==0
    h = waitbar(0, 'Tracking...');
else
    figure('color',[1 1 1])
num=gcf;
end

%pas=floor(fac/2);
pas=fac*2;

 disp(['pas = ',num2str(pas)])
    disp('  ')
    
    disp('begin')

a=1;


t=[1:pas:lim-fac]*dt;

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
            im(mask==0)=0;
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
    
    for ind=1:pas:lim-fac

    vidFrames1 = read(OBJ,ind);
    vidFrames2 = read(OBJ,ind+fac);
    Mov1=vidFrames1(:,:,3,1);
    Mov2=vidFrames2(:,:,3,1);
    Im1=single(Mov1(150:end,20:470));
    Im2=single(Mov2(150:end,20:470));
    Im1(Im1>50)=50;
    Im2(Im2>50)=50;
    A(a)=sqrt(sum(sum(((Im2-Im1).*(Im2-Im1)))))/12000/2*100;


   if plo
    figure(num), clf
    subplot(2,3,1),imagesc(vidFrames1(150:end,20:470,:,1))    
    subplot(2,3,2),imagesc(vidFrames2(150:end,20:470,:,1))
    subplot(2,3,3),imagesc(Im2-Im1), caxis([-50 50])
    subplot(2,3,4:6),plot(t(1:a),(A),'k','linewidth',2), title([num2str(t(floor(a))),' s'])
    try
        xlim([t(a)-30 t(a)])
    end
        ylim([0 10])
        
   else
       
           waitbar(ind/numFrames, h);
         
   end
   
    a=a+1;    
end



if plo==0
    close(h)
end

Atsd=tsd(t*1E4',SmoothDec(A',1));
Freeze=thresholdIntervals(Atsd,th,'Direction','Below');
Freeze2=dropShortIntervals(Freeze,thtps*1E4);

Perc=sum(End(Freeze2,'s')-Start(Freeze2,'s'))/dur*100;

% end

LowTh=vitTh;
HighTh=10*median(Vit);

disp(['Sampling frequency :',num2str(1/median(diff(Pos(:,1)))),'Hz']);

Fs=1/median(diff(Pos(:,1)));
eval(['save ',filename,' Pos PosTh Vit ima Fs LowTh HighTh'])