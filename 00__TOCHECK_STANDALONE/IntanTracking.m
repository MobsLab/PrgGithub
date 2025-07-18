
%---------------------------------------------------

res=pwd;

%---------------------------------------------------
%                   load X,Y,Z signal
%---------------------------------------------------
num=input('how many mice were recorded ?  ');
AHAH=1;

while AHAH<num+1
    
    disp('  ')
    mouse=input('in which mouse file do you want to load LFP files :  ');
    disp('  ')
    
    channel=input('what LFP channel for x,y,z, respectively (e.g.[0 1 2]) :  ');
    
    load([res,'/LFPData',num2str(mouse),'/LFP',num2str(channel(1))]);
    X=Data(LFP);
    Xaxis=X(1:200:end);
    load([res,'/LFPData',num2str(mouse),'/LFP',num2str(channel(2))]);
    Y=Data(LFP);
    Yaxis=Y(1:200:end);
    load([res,'/LFPData',num2str(mouse),'/LFP',num2str(channel(3))]);
    Z=Data(LFP);
    Zaxis=Z(1:200:end);
    
    Time=Range(LFP);
    time=Time(1:200:end-1);
    
    %---------------------------------------------------
    %             creation of velocity vector
    %---------------------------------------------------
    
    Xa=Xaxis(1:end-1);
    Xb=Xaxis(2:end);
    Xdif=Xb-Xa;
    
    Ya=Yaxis(1:end-1);
    Yb=Yaxis(2:end);
    Ydif=Yb-Ya;
    
    Za=Zaxis(1:end-1);
    Zb=Zaxis(2:end);
    Zdif=Zb-Za;
    
    vect=sqrt(Xdif.*Xdif+Ydif.*Ydif+Zdif.*Zdif);
    
    %---------------------------------------------------
    %               plot for verification
    %---------------------------------------------------
    
    SmoVect=SmoothDec(vect,10);
    
    figure, subplot(3,1,1)
    hold on, plot(time(1:end-1),vect,'b')
    hold on, plot(time(1:end-1),SmoVect,'r')
    hold on, title(['Mouse n°',num2str(mouse),'- smoothed value = 10'])
    hold on, subplot(3,1,2)
    hold on, hist(vect,5000)
    hold on, axis([0 2000 0 max(axis)])
    hold on, subplot(3,1,3)
    hold on, hist(SmoVect,5000,'r')
    hold on, axis([0 2000 0 max(axis)])
    h=findobj(gca,'Type','patch');
    set(h,'FaceColor','r','EdgeColor','r')
    
    %---------------------------------------------------
    %             check and end of process
    %---------------------------------------------------
    mkdir([res,'/MovData',num2str(mouse)]);
    
    disp('   ')
    ok=input('is everything ok ? (yes=1/no=0)   ');
    disp('   ')
    a=0;
    
    while a==0
        if ok==1
            disp('  ')
            disp('end of process : save data in Mov.tsd ...')
            disp('  ')
            Mov=tsd(time(1:end-1),SmoVect);
            
            save([res,'/MovData',num2str(mouse),'/Mov'],'Mov');
            a=1;
        elseif ok==0
            smo=input('redefine smoothing value (basal=10) :   ');
            SmoVect=SmoothDec(vect,10);
            
            figure, subplot(3,1,1)
            hold on, plot(time(1:end-1),vect,'b')
            hold on, plot(time(1:end-1),SmoVect,'r')
            hold on, title(['Mouse n°',num2str(mouse),'- smoothed value = 10'])
            hold on, subplot(3,1,2)
            hold on, hist(vect,5000)
            hold on, axis([0 2000 0 max(axis)])
            hold on, subplot(3,1,3)
            hold on, hist(SmoVect,5000,'r')
            hold on, axis([0 2000 0 max(axis)])
            h=findobj(gca,'Type','patch');
            set(h,'FaceColor','r','EdgeColor','r')
            a=0;
            
            disp('  ')
            ok=input('is everything ok ? (yes=1/no=0)   ');
            disp('  ')
        end
    end
    
    AHAH=AHAH+1;
    
end
%---------------------------------------------------

    

