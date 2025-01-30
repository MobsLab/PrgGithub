% function AttentionalNosePoke
global a
a= serial('COM6');   % port used for communication between MatLab and

disp('')
start=input(' press 1 when you want to start ');
disp('')


fopen(a)


if start == 1;
    
    disp('              >   120 seconds')
    disp(' ')
    pause(60)
    disp('              >   60 seconds')
    disp(' ')
    pause(50)
    disp('              >   10 seconds')
    disp(' ')
    pause(5) 
    disp('              >   5 seconds')
    disp(' ')
    pause(5)
    disp('              >   START! Have fun mouse ;)')
    disp(' ')
    
    
    init=1;
    i=1;
    lastval=6;
    s=0;
    tps_1=clock;
    
    while i<30 ;
        
% Local Global Sequence Occurency      

        tps=clock;
      
        if etime(tps,tps_1)>11
         
        BlocAAAAA;
        BlocAAAAB;
        BlocAAAA;
        BlocAAAAB;
        BlocAAAAA;
        BlocAAAAB;
        BlocAAAAA;
        BlocAAAAB;
        BlocAAAAA;
        BlocAAAA;
        BlocAAAAB;
        BlocAAAAA;
        BlocAAAAB;
        BlocAAAAA;
        
        
        E=2*rand+2;
        pause(E)
        tps_1=clock;
        
        end


      
    end
end

fclose(a)

