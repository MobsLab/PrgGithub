
%% execute this code in folder with all the rhd files

Files = dir;
for f = 1 :length(Files)
    if not(isempty(strfind(Files(f).name,'.rhd')))
        Time(f) =  eval( Files(f).name(end-9:end-4));
    end
end
Time(Time==0) = NaN;
[val,ind] = sort(Time);
ind(isnan(val)) = [];


start = 0;
precision = 'int16';
skip = 0;
duration = Inf;
frequency = 20000;
sizeInBytes = 2;

fidW_amp=fopen('amplifier.dat','w');
fidW_dig=fopen('digitalin.dat','w');
fidW_aux=fopen('auxiliary.dat','w');
fidW_sup=fopen('supply.dat','w');



for filenum = 1 : length(ind)
    disp(Files(ind(filenum)).name)
    read_Intan_RHD2000_file(Files(ind(filenum)).name)
    
    towrite=amplifier_data';
    fwrite(fidW_amp,towrite',precision);
    
    towrite=aux_input_data';
    fwrite(fidW_aux,towrite',precision);
    
    towrite = zeros(1,size(board_dig_in_data,2));
    for dignum = 1:size(board_dig_in_data,1)
        towrite = towrite+board_dig_in_data*2^(dignum-1);
    end
    fwrite(fidW_dig,towrite',precision);
    
    towrite=supply_voltage_data';
    fwrite(fidW_sup,towrite',precision);
    
end
fclose(fidW_amp);
fclose(fidW_dig);
fclose(fidW_aux);
fclose(fidW_sup);

