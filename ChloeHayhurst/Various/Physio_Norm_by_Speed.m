function [H,HistData_Physio] = Physio_Norm_by_Speed(SPEED,DATA,Phys)

if strcmp(Phys, 'HR')
    thr_physio1 = 9; thr_physio2 = 14.5;
elseif strcmp(Phys, 'HRVar')
    thr_physio1 = 0; thr_physio2 = .35;
elseif strcmp(Phys, 'Breathing')
    thr_physio1 = 0; thr_physio2 = 15;
end

size_map = 100;
thr_speed = 25;
DATA_interp = Restrict(DATA , SPEED);

Data_speed = runmean_BM(Data(SPEED) , ceil(.3/median(diff(Range(SPEED,'s')))));
Data_physio = runmean_BM(Data(DATA_interp) , ceil(.3/median(diff(Range(SPEED,'s')))));

ind_speed = Data_speed<thr_speed;
ind_physio = (Data_physio>thr_physio1 & Data_physio<thr_physio2);

Data_speed_corr = Data_speed(ind_speed & ind_physio);
Data_physio_corr = Data_physio(ind_speed & ind_physio);
Corr_Speed_Physio = hist2d([Data_speed_corr ; 0; 0; thr_speed ; thr_speed] , [Data_physio_corr; thr_physio1 ; thr_physio2; thr_physio1 ; thr_physio2] , size_map , size_map);
Corr_Speed_Physio = Corr_Speed_Physio/sum(Corr_Speed_Physio(:));
Corr_Speed_Physio = Corr_Speed_Physio';

Corr_Speed_Physio_log = log(Corr_Speed_Physio);
Corr_Speed_Physio_log(Corr_Speed_Physio_log==-Inf) = -1e4;

h=histogram(Data_physio_corr,'NumBins',144,'BinLimits',[thr_physio1 thr_physio2]);
HistData_Physio = h.Values;

h=histogram(Data_physio_corr,'NumBins',144,'BinLimits',[thr_physio1 thr_physio2]);
HistData_Physio = h.Values;

H = sum(Corr_Speed_Physio./ nansum(Corr_Speed_Physio).*(linspace(thr_physio1,thr_physio2,100)'));


end