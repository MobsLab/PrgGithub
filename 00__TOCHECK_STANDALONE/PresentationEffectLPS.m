function Effect=PresentationEffectLPS(R51d1,R51d2,R51d3,R51d4,R54d1,R54d2,R54d3,R54d4,n1,n2,ti)

   
    
Effect(1,1)=R51d1{n1};
Effect(1,2)=R51d1{n2}; 
Effect(1,3)=R51d2{n1};
Effect(1,4)=R51d2{n2};
Effect(1,5)=R51d3{n1};
Effect(1,6)=R51d3{n2};
Effect(1,7)=R51d4{n1};
Effect(1,8)=R51d4{n2};

Effect(2,1)=R54d1{n1};
Effect(2,2)=R54d1{n2}; 
Effect(2,3)=R54d2{n1};
Effect(2,4)=R54d2{n2};
Effect(2,5)=R54d3{n1};
Effect(2,6)=R54d3{n2};
Effect(2,7)=R54d4{n1};
Effect(2,8)=R54d4{n2};


PlotErrorBar(Effect); 
try 
    title(ti)
end


%     a=a+1; R{a}=Epoch1;           %1 
%     a=a+1; R{a}=DurEpoch1;        %2
%     a=a+1; R{a}=MeanDurEpoch1;    %3
%     a=a+1; R{a}=Epoch2;           %4
%     a=a+1; R{a}=DurEpoch2;        %5
%     a=a+1; R{a}=MeanDurEpoch2;    %6
%     a=a+1; R{a}=Epoch1rem;        %7
%     a=a+1; R{a}=DurEpoch1rem;     %8
%     a=a+1; R{a}=MeanDurEpoch1rem; %9
%     a=a+1; R{a}=Epoch2rem;        %10
%     a=a+1; R{a}=DurEpoch2rem;     %11
%     a=a+1; R{a}=MeanDurEpoch2rem; %12
%     a=a+1; R{a}=sum(End(EpochT1,'s')-Start(EpochT1,'s'));  %13
%     a=a+1; R{a}=sum(End(EpochT2,'s')-Start(EpochT2,'s'));  %14 
%     a=a+1; R{a}=tdelayRemRecording; %15
%     a=a+1; R{a}=tdelayRem1;         %16 
%     a=a+1; R{a}=tdelayRem2;       %17
%     a=a+1; R{a}=befR;             %18
%     a=a+1; R{a}= aftR;            %19
%     a=a+1; R{a}= befS;           %20
%     a=a+1; R{a}=aftS;            %21
%     a=a+1; R{a}=C;;              %22
%     a=a+1; R{a}=B;;              %23
%     a=a+1; R{a}=C1;;             %24
%     a=a+1; R{a}=B1;;             %25
%     a=a+1; R{a}=C2;;             %26
%     a=a+1; R{a}=B2;;             %27
%     a=a+1; R{a}=tPeaksT;;        %28
%     a=a+1; R{a}=peakValue;;      %29
%     a=a+1; R{a}=zeroCrossT;;       %30
%     a=a+1; R{a}=reliab;;           %31
%     a=a+1; R{a}=Bilan;;            %32
%     a=a+1; R{a}=ST;;               %33
%     a=a+1; R{a}=freq;;             %34
%     a=a+1; R{a}=Mh1r;;             %35
%     a=a+1; R{a}=Mh2r;    ;         %36
%     a=a+1; R{a}=Mh3r;;             %37
%     a=a+1; R{a}=Mh1s;;             %38
%     a=a+1; R{a}=Mh2s;;             %39
%     a=a+1; R{a}=Mh3s;  ;        %40
%     a=a+1; R{a}=Mp1r;;          %41
%     a=a+1; R{a}=Mp2r;    ;      %42
%     a=a+1; R{a}=Mp3r;;          %43
%     a=a+1; R{a}=Mp1s;;          %44
%     a=a+1; R{a}=Mp2s;;          %45
%     a=a+1; R{a}=Mp3s;;          %46
%     a=a+1; R{a}=Spi;;           %47
%     a=a+1; R{a}=Rip;;           %48
%     a=a+1; R{a}=num;            %49
%     a=a+1; R{a}=params;            %50%    

%     a=a+1; D{a}=Filt_EEGd;;        %1
%     a=a+1; D{a}=LFPp;;             %2
%     a=a+1; D{a}=LFPh;;             %3
