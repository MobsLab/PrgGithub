
function LocalDvt

init=1;
A=rand*100;

if A>20
    %fwrite(a,8); % Arduino Port n°
    disp('------------------')
    disp('> Local Deviant <')  % block XXXX-Y
    disp('------------------')
    kitkat=rand+0.5;
    disp(['> Pause : ', num2str(kitkat)])  % block XXXX-Y
    pause(kitkat)
    
elseif A<20
    
    %fwrite(a,8); % Arduino Port n°
    disp('------------------')
    disp('> Local Deviant <')  % block XXXX-Y
    disp('------------------')
    kitkat=rand+0.5;
    disp(['> Pause : ', num2str(kitkat)])  % block XXXX-Y
    pause(kitkat)
    
    disp('--------------------')
    disp('> Attentional Tone <')
    disp('--------------------')
    
    % Rewarding Tone
    
    info=get(a,{'BytesAvailable'}); % Read Arduino to see if nose poke has been done within the last 10-15 seconds
    
    if lastval==6
        %fwrite(a,5) % Arduino Port n°
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
        
        B=10 + 5*rand;
        disp('--------------------------------------------------------')
        disp(['Wait for Mouse to STOP doing nosepoke for ',num2str(A),' seconds'])
        disp('--------------------------------------------------------')
        pause(B) % time within loop of ON-photodetector is CLOSE (avoids rewarding stimulation)
        %i=i+1;
        
    end
end
    
end