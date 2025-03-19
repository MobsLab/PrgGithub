
load('PiezoData_SleepScoring.mat','SleepEpoch_Piezo')
load('PiezoData_SleepScoring.mat','WakeEpoch_Piezo')

load('SleepScoring_OBGamma.mat','Sleep')
load('SleepScoring_OBGamma.mat','Wake')
Sleep_OB = Sleep;
Wake_OB = Wake;

load('SleepScoring_Accelero.mat','Sleep')
load('SleepScoring_Accelero.mat','Wake')
Sleep_Accelero = Sleep;
Wake_Accelero = Wake;

Epoch = intervalSet(Stim_Start, Stim_End);
A = Restrict(Piezo_Mouse_tsd, and(WakeEpoch_Piezo,Epoch));
if length(Range(A)) > 0 
    Stim_Epoch_Wake_15(n15p,3) = length(Range(A))/1e4;
else
    Stim_Epoch_Wake_15(n15p,3) = 0;
end

sso = Start(Sleep_OB);
eso = End(Sleep_OB);
interOB = [sso,eso];
sleep_ob = [];
for i = 1:length(interOB)
    interval = interOB(i);
    sleep_ob = [sleep_ob, interOB(i)];
end

ssa = Start(Sleep_Accelero)
esa = End(Sleep_Accelero)
intera = [ssa,esa]
sleep_a = []
for i = 1:length(intera)
    interval = intera(i)
    sleep_a = [sleep_a, intera(i)]
end

ssp = Start(SleepEpoch_Piezo)
esp = End(WakeEpoch_Piezo)
interp = [ssp,esp]
sleep_p = []
for i = 1:length(interp)
    interval = interp(i)
    sleep_p = [sleep_p, interp(i)]
end

all_data = [sleep_ob, sleep_a,sleep_p]

C = corrcoef(all_data)
