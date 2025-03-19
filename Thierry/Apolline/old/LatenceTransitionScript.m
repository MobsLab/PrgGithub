clear all
clc

[Result, Nb] = LatenceTransition();

Nb_Trans_REM_SWS = 0;
Nb_Trans_REM_Wake = 0;
Nb_Trans_SWS_REM = 0;
Nb_Trans_SWS_Wake = 0;
Wake = 0;
error = 0;

Delay_Trans_REM_SWS = 0;
Delay_Trans_REM_Wake = 0;
Delay_Trans_SWS_REM = 0;
Delay_Trans_SWS_Wake = 0;

for k = 1:length(Result(:,1))
    k = k;
    if Result(k,1) == 2
        if Result(k,2) == 1
            Nb_Trans_REM_SWS = Nb_Trans_REM_SWS + 1;
            Delay_Trans_REM_SWS = Delay_Trans_REM_SWS + Result(k,3);
        elseif Result(k,2) == 0
            Nb_Trans_REM_Wake = Nb_Trans_REM_Wake + 1;
            Delay_Trans_REM_Wake = Delay_Trans_REM_Wake + Result(k,3);
        else
            error = error +1;
        end
    elseif Result(k,1) == 1
        if Result(k,2) == 2
            Nb_Trans_SWS_REM = Nb_Trans_SWS_REM + 1;
            Delay_Trans_SWS_REM = Delay_Trans_SWS_REM + Result(k,3);
        elseif Result(k,2) == 0
            Nb_Trans_SWS_Wake = Nb_Trans_SWS_Wake + 1;
            Delay_Trans_SWS_Wake = Delay_Trans_SWS_Wake + Result(k,3);
        else
            error = error +1;
        end
    else
        Wake = Wake + 1;
    end
end

Delay_Trans_REM_SWS = Delay_Trans_REM_SWS./Nb_Trans_REM_SWS;
Delay_Trans_REM_Wake = Delay_Trans_REM_Wake./Nb_Trans_REM_Wake;
Delay_Trans_SWS_REM = Delay_Trans_SWS_REM./Nb_Trans_SWS_REM;
Delay_Trans_SWS_Wake = Delay_Trans_SWS_Wake./Nb_Trans_SWS_Wake;


Latence = zeros(7,2);
Latence(1,1) = k;
Latence(2,1) = Nb_Trans_REM_SWS;
Latence(3,1) = Nb_Trans_SWS_REM;
Latence(4,1) = Nb_Trans_SWS_Wake;
Latence(5,1) = Nb_Trans_REM_Wake;
Latence(6,1) = Wake;
Latence(2,1) = error;
Latence(1,2) = NaN;
Latence(2,2) = Delay_Trans_REM_SWS./1e4;
Latence(3,2) = Delay_Trans_SWS_REM./1e4;
Latence(4,2) = Delay_Trans_SWS_Wake./1e4;
Latence(5,2) = Delay_Trans_REM_Wake./1e4;
Latence(6,2) = NaN;
Latence(7,2) = NaN;

Legend_Latence = ["Nb_Stim_Total";"Nb_Trans_REM_SWS";"Nb_Trans_SWS_REM";"Nb_Trans_SWS_Wake";"Nb_Trans_REM_Wake";"Wake";"error"];

save('M675_Stim_Latence.mat','Latence')
save('Legend_Latence.mat','Legend_Latence')