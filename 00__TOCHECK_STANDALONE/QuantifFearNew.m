function [A,t,Atsd,Perc,Freeze,Freeze2,idFr]=QuantifFearNew(filename,fac,th,thtps,ThMice,lim)


%surface mouse = 12000 pixels
%fac = number of frame to identify movment default value 10
%th = threshold freezing default value 1.8
%thtps = minimum time for freezing periods default valut 2s
%ThMice = identification mouse default value 65;


plo=1;

sizDetect=70;  
sizeSquare=40;
smo=1.5;
ThDetect=4800;


margeinfX=50;
margeinfY=20;
margesupX=200;
margesupY=215;
    
    
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
    %figure('color',[1 1 1])
%num2=gcf;
end

pas=floor(fac/2);
%pas=1;

vidFrames1 = read(OBJ,1);
Mov1=vidFrames1(:,:,3,1);
Im1=single(Mov1(margeinfY:margesupY,margeinfX:margesupX));
J=SmoothDec(Im1,[smo,smo]); 

[x, y, bodyline, sqr] = FindFly(max(max(J))-J, 50);

    
idx=1;
t=[1:pas:lim-fac]*dt;    

for ind=1:pas:lim-fac

    vidFrames1 = read(OBJ,ind);
    vidFrames2 = read(OBJ,ind+fac);
    Mov1=vidFrames1(:,:,3,1);
    Mov2=vidFrames2(:,:,3,1);
    Im1=single(Mov1(margeinfY:margesupY,margeinfX:margesupX));
    Im2=single(Mov2(margeinfY:margesupY,margeinfX:margesupX));
    Im1(Im1>ThMice)=ThMice;
    Im2(Im2>ThMice)=ThMice;
        
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
            
            if a>=size(Im1,2)-sizeSquare%30
                XSup=size(Im1,2);
            else
                XSup=a+sizeSquare;%30;
            end
            
            
            if b<=sizeSquare+1%31
                YInf=1;
            else
                YInf=b-sizeSquare;%30;
            end
            
            if b>=size(Im1,1)-sizeSquare;%30
                YSup=size(Im1,1);
            else
                YSup=b+sizeSquare;%30;
            end
            
            
            ImR2=Im2(YInf:YSup,XInf:XSup);
            ImR1=Im1(YInf:YSup,XInf:XSup);            
            
            %Jtemp=single(Mov1(YInf:YSup,XInf:XSup));
            J=SmoothDec(ImR1,[smo,smo]); 
            J=J(5:end-5,5:end-5);
            [x, y, bodyline, sqr] = FindFly(max(max(J))-J, 50);
%             figure(num2), clf,hold on
%             imagesc(J)
%             plot(x,y,'ko','markerfacecolor','w')
            x=x+XInf;
            y=y+YInf;

            if (sqr(2)-sqr(1))*(sqr(4)-sqr(3))<ThDetect %380
                co=0;
                Jtemp=single(Mov1(margeinfY:margesupY,margeinfX:margesupX));
                Jtemp(Jtemp>ThMice)=ThMice;
                %Jtemp=single(Mov1(YInf:YSup,XInf:XSup));
                J=SmoothDec(Jtemp,[smo,smo]); 
                J=J(5:end-5,5:end-5);
                [x, y, bodyline, sqr] = FindFly(max(max(J))-J, 50);
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
            
            if a>=size(Im1,2)-sizeSquare%30
                XSup=size(Im1,2);
            else
                XSup=a+sizeSquare;%30;
            end
            
            
            if b<=sizeSquare+1%31
                YInf=1;
            else
                YInf=b-sizeSquare;%30;
            end
            
            if b>=size(Im1,1)-sizeSquare;%30
                YSup=size(Im1,1);
            else
                YSup=b+sizeSquare;%30;
            end
            
                ImR2=Im2(YInf:YSup,XInf:XSup);
                ImR1=Im1(YInf:YSup,XInf:XSup); 
            else
                co=1;
            end
            
            
            A(idx)=sqrt(sum(sum(((ImR2-ImR1).*(ImR2-ImR1)))))/12000/2*100;


   if plo
    figure(num), clf
    subplot(2,3,1),imagesc(vidFrames1(margeinfY:margesupY,margeinfX:margesupX,:,1)),axis xy    
    subplot(2,3,2),imagesc(vidFrames2(margeinfY:margesupY,margeinfX:margesupX,:,1)),axis xy
    subplot(2,3,3),hold on,axis xy
    imagesc(Im2-Im1),axis xy, caxis([-50 50]), xlim([0 size(Im2,2)]), ylim([0 size(Im2,1)]), title([num2str(floor((sqr(2)-sqr(1))*(sqr(4)-sqr(3))/10)*10),'  correct ',num2str(co)])
    plot(x,y,'ko','markerfacecolor','w')
     try
     rectangle('position',[XInf YInf XSup-XInf YSup-YInf])
    end
    subplot(2,3,4:6),plot(t(1:idx),(A),'k','linewidth',2), title([num2str(floor(t(floor(idx))*10)/10),' s'])
    try
        xlim([t(a)-15 t(idx)])
    end
        ylim([0.5 10])
        
   else
       
           waitbar(ind/numFrames, h);
         
   end
   
    idx=idx+1;    
end



if plo==0
    close(h)
end

Atsd=tsd(t*1E4',SmoothDec(A',1));

[c,s]=kmeans(A,2);
th=mean(A(s==1))+std(A(s==1));
idFr=find(A<th);

Freeze=thresholdIntervals(Atsd,th,'Direction','Below');
Freeze2=dropShortIntervals(Freeze,thtps*1E4);

Perc=sum(End(Freeze2,'s')-Start(Freeze2,'s'))/dur*100;



