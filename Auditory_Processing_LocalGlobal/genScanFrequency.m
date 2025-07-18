%genScanFrequency


load EventIntanDIGin

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

Fq10kHz_int1= Event1(101:149);
Fq20kHz_int1= Event2(101:149);
Fq30kHz_int1= Event3(101:149);
Fq10kHz_int3= Event4(101:149);
Fq20kHz_int3= Event5(101:149);
Fq30kHz_int3= Event6(101:149);

Fq10kHz_int2= Event1(150:length(Event1));
Fq20kHz_int2= Event2(150:length(Event2));
Fq30kHz_int2= Event3(150:length(Event3));
Fq10kHz_int4= Event4(150:length(Event4));
Fq20kHz_int4= Event5(150:length(Event5));
Fq30kHz_int4= Event6(150:length(Event6));

Fq5kHz=[Fq5kHz_int1;Fq5kHz_int2;Fq5kHz_int3;Fq5kHz_int4];
Fq10kHz=[Fq10kHz_int1;Fq10kHz_int2;Fq10kHz_int3;Fq10kHz_int4];
Fq15kHz=[Fq15kHz_int1;Fq15kHz_int2;Fq15kHz_int3;Fq15kHz_int4];
Fq20kHz=[Fq20kHz_int1;Fq20kHz_int2;Fq20kHz_int3;Fq20kHz_int4];
Fq25kHz=[Fq25kHz_int1;Fq25kHz_int2;Fq25kHz_int3;Fq25kHz_int4];
Fq30kHz=[Fq30kHz_int1;Fq30kHz_int2;Fq30kHz_int3;Fq30kHz_int4]; 

save ScanFrequency Fq5kHz Fq10kHz  Fq15kHz Fq20kHz Fq25kHz Fq30kHz
save ScanFrequency -append Fq5kHz_int1 Fq5kHz_int2 Fq5kHz_int3 Fq5kHz_int4
save ScanFrequency -append Fq10kHz_int1 Fq10kHz_int2 Fq10kHz_int3 Fq10kHz_int4  
save ScanFrequency -append Fq15kHz_int1 Fq15kHz_int2 Fq15kHz_int3 Fq15kHz_int4
save ScanFrequency -append Fq20kHz_int1 Fq20kHz_int2 Fq20kHz_int3 Fq20kHz_int4  
save ScanFrequency -append Fq25kHz_int1 Fq25kHz_int2 Fq25kHz_int3 Fq25kHz_int4
save ScanFrequency -append Fq30kHz_int1 Fq30kHz_int2 Fq30kHz_int3 Fq30kHz_int4  

%-----------------------------------------------------------------------------------------------------------

res=pwd;
load([res,'/LFPData/LFP',num2str(0)]);
sou=thresholdIntervals(LFP, -0.01,'Direction','Below');
for j=1:6
    fq=j*5;
    for k=1:4
        a=1;
        eval(['Epoch1=intervalSet(Fq',num2str(fq),'kHz_int',num2str(k),'-0.2E4,Fq',num2str(fq),'kHz_int',num2str(k),');'])
        for i=1:length(Start(Epoch1))
            Epoch=subset(Epoch1,i);
            so=and(Epoch,sou);
            e1=Start(so);
            AllFrequency{j,k}(a)=e1(1);
            a=a+1;
        end
    end
end

%------------------------------
save ScanFrequency -append AllFrequency
%------------------------------

%-----------------------------------------------------------------------------------------------------------
sou=thresholdIntervals(LFP, -0.01,'Direction','Below');

for j=1:6
    a=1;
    eval(['Epoch1=intervalSet(Event',num2str(j),'-0.2E4,Event',num2str(j),');'])
    for i=1:length(Start(Epoch1))
        Epoch=subset(Epoch1,i);
        so=and(Epoch,sou);
        e1=Start(so);
        AllEvent{j}(a)=e1(1);
        a=a+1;
    end
end

%-----------------------------------
save ScanFrequency -append AllEvent
%-----------------------------------



