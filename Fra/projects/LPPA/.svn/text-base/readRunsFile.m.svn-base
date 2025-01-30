function [trialDirection, correctError, lightPosition] = readRunsFile(fname)

fh = fopen(fname, 'r');

trialDirection = [];
correctError = [];
lightPosition = [];
ln = fgetl(fh);
while ln ~= -1
    a = sscanf(ln, '%d\t%c\t%c\t%c');
    if a(2) == 'L'
        lightPosition = [lightPosition ; 1];
    elseif a(2) == 'R'
        lightPosition = [lightPosition ; 0];
    else
        error('invalid light posiion');
    end
    if a(3) == 'C'
        correctError = [correctError ; 1];
    elseif a(3) == 'E'
        correctError = [correctError ; 0];
    else
        error('invalid correct/error');
    end
    if a(4) == 'L'
        trialDirection = [trialDirection ; 1];
    elseif a(4) == 'R'
        trialDirection = [trialDirection ; 0];
    else
        error('invalid light posiion');
    end
    ln = fgetl(fh);
end
    
    