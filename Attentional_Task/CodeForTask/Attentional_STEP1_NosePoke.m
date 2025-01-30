% function AttentionalNosePoke_Step1
global a
a= serial('COM5');   % port used for communication between MatLab and
pause on

disp('-----------------------------------')
cycle=input(' How many tone presentation do you want (standard=100) ? ');
disp('-----------------------------------')

disp('-----------------------------------')
RewardWindow=input(' How duration for rewarding stimulation window (=tone duration +3) ? ');
disp('-----------------------------------')

disp('-----------------------------------')
start=input(' press 1 when you want to start > ');
disp('-----------------------------------')


fopen(a)


if start == 1;
    
    disp('              >   60 seconds')
    disp(' ')
    pause(60)
    disp('              >   30 seconds')
    disp(' ')
    pause(10)

    init=-1;
    i=1;    
    lastval=2;
    
    while i<cycle ;
        info=get(a,{'BytesAvailable'});
        info{1};
        if info{1}==init+1 & lastval==2
            fwrite(a,1)
            disp('-----------------')
            disp('Rewarding Tone !! ')
            disp('-------------------')
            disp('Go for Nose Poke !!')
            disp('you have 3 seconds ')
            disp([' n= ',num2str(i)])
            disp('-------------------')
            init=init+1;
            lastval=1;
            
        elseif info{1}==init+1 & lastval==1
            pause(RewardWindow)  % time within loop of ON-photodetector is OPEN (allowing nose poke to induce rewarding stimulation)
            fwrite(a,2)
            init=init+1;
            lastval=2;
            disp('---------------')
            disp('NosePoke OFF !! ')
            disp('---------------')

            A=7 + 3*rand;
            disp('--------------------------------------------------------')
            disp(['Wait for Mouse to STOP doing nosepoke for ',num2str(A),' seconds'])
            disp('--------------------------------------------------------')
            pause(A) % time within loop of ON-photodetector is CLOSE (avoiding nose poke to induce rewarding stimulation)
            
            i=i+1;
        end
    end
end

fclose(a)

