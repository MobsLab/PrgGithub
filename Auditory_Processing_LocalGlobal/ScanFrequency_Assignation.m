%ScanFrequency_Assignation

try
    load IntanEvt
catch
    load EventIntanDAC
    load EventIntanDIGin
    
    save IntanEvt Event1 Event2 Event3 Event4 Event5 Event6
end

%-----------------------------------------------------------------------------------------------------------
%                     Determination des temps de chaque frequences et intensités
%-----------------------------------------------------------------------------------------------------------

Fq5kHz_int1= Event1(1:50);
Fq15kHz_int1= Event2(1:50);
Fq25kHz_int1= Event3(1:50);
Fq5kHz_int3= Event4(1:50);
Fq15kHz_int3= Event5(1:50);
Fq25kHz_int3= Event6(1:50);

Fq5kHz_int2= Event1(51:100);
Fq15kHz_int2= Event2(51:100);
Fq25kHz_int2= Event3(51:100);
Fq5kHz_int4= Event4(51:100);
Fq15kHz_int4= Event5(51:100);
Fq25kHz_int4= Event6(51:100);

Fq10kHz_int1= Event1(101:150);
Fq20kHz_int1= Event2(101:150);
Fq30kHz_int1= Event3(101:150);
Fq10kHz_int3= Event4(101:150);
Fq20kHz_int3= Event5(101:150);
Fq30kHz_int3= Event6(101:150);

Fq10kHz_int2= Event1(151:length(Event1));
Fq20kHz_int2= Event2(151:length(Event2));
Fq30kHz_int2= Event3(151:length(Event3));
Fq10kHz_int4= Event4(151:length(Event4));
Fq20kHz_int4= Event5(151:length(Event5));
Fq30kHz_int4= Event6(151:length(Event6));

save ScanFrequency Fq5kHz_int1 Fq5kHz_int2 Fq5kHz_int3 Fq5kHz_int4
save ScanFrequency -append Fq10kHz_int1 Fq10kHz_int2 Fq10kHz_int3 Fq10kHz_int4
save ScanFrequency -append Fq15kHz_int1 Fq15kHz_int2 Fq15kHz_int3 Fq15kHz_int4
save ScanFrequency -append Fq20kHz_int1 Fq20kHz_int2 Fq20kHz_int3 Fq20kHz_int4
save ScanFrequency -append Fq25kHz_int1 Fq25kHz_int2 Fq25kHz_int3 Fq25kHz_int4
save ScanFrequency -append Fq30kHz_int1 Fq30kHz_int2 Fq30kHz_int3 Fq30kHz_int4

%-----------------------------------------------------------------------------------------------------------

