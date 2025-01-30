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

% Rewarding Tone         
        
        info=get(a,{'BytesAvailable'}); % Read Arduino to see if nose poke has been done within the last 10-15 seconds
        if lastval==6
            fwrite(a,5) % Arduino Port n°  
            lastval=5;            
            disp('Rewarding Tone !! ')
            disp('-------------------')
            disp('Go for Nose Poke !!')
            disp('you have 3 seconds ')
            disp([' n= ',num2str(i)])
            disp('-------------------')
        
        elseif  info{1}==init & lastval==5
            
            init=init+1;
            C=3.1;
            pause(C)  % time within loop of ON-photodetector is OPEN (allows rewarding stimulation)
            
            fwrite(a,6)
            init=init+1;
            lastval=6;
            disp('NosePoke OFF !! ')
            disp('---------------')
            
            A=10 + 5*rand;
            disp('--------------------------------------------------------')
            disp(['Wait for Mouse to STOP doing nosepoke for ',num2str(A),' seconds'])
            disp('--------------------------------------------------------')
            pause(A) % time within loop of ON-photodetector is CLOSE (avoids rewarding stimulation)
            i=i+1;
            
        end
      
    end
end

fclose(a)

