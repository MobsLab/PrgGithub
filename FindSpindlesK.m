function Spi=FindSpindlesK(LFP,fre,Epoch)


length(Start(Epoch))

try
    Epoch;
catch
    rg=Range(LFP);
    Epoch=intervalSet(rg(1),rg(end));
end
    
clear Spi
clear ripples
h = waitbar(0,'Please wait...');

Spi=[];
for i=1:length(Start(Epoch))
    waitbar(i/length(Start(Epoch)),h)
      try
        LFPtemp=ResampleTSD(Restrict(LFP,subset(Epoch,i)),250);
        Filsp=FilterLFP(LFPtemp,fre,128);
        rgFilsp=Range(Filsp,'s');
        
        %spindles=FindSpindles(Data(Filsp),'show','on');
        spindles=FindSpindles(Data(Filsp));
        
        spindles(:,1:2)=spindles(:,1:2)+rgFilsp(1);
        Spi=[Spi;spindles];

      end
end

close (h)

  
       
       

   
   
   
        
  