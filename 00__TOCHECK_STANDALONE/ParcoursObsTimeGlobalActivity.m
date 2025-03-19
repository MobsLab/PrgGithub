%ParcoursObsTimeGlobalActivity

ref='Dpa';

NameDir={'BASAL'};

RemovePreEpoch=1;

Mb=[];
MbKO=[];
Mh=[];
MhKO=[];
Mp=[];
MpKO=[];
Mpar=[];
MparKO=[];
a=1;
b=1;

    for i=1:length(NameDir)
        Dir=PathForExperimentsML(NameDir{i});
        
        for man=1:length(Dir.path)
                        disp('  ')
                        disp('***********************************')
            disp(Dir.path{man})
            disp(Dir.group{man})
            disp(' ')
            cd(Dir.path{man})
            clear rip
            clear dHPCrip
            clear tim
            clear tDeltaT2
            clear SpiHigh
            clear SpiLow
            clear spiL
            clear spiH
            clear M1t
            clear tps1
            clear M2t
            clear tps2
            clear id
            clear Mhpc
            clear Mpa
            clear Mpf
            clear MauC
            clear Mauth
           
            clear Mbulb 
            clear Mpir
            clear Mamy
            clear Mden
            try
            load behavResources PreEpoch
            load StateEpochSB SWSEpoch REMEpoch Wake
            
            switch ref
                case 'Rip'
            load RipplesdHPC25
            rip=ts(dHPCrip(:,2)*1E4);
            tim=rip;
            
                case 'Dpf'
            load DeltaPFCx
            tim=tDeltaT2;
            
                case 'Dpa'
            load DeltaPaCx
            tim=tDeltaT2;
            
                case 'Sad'
            load SpindlesPaCxDeep
            spiH=ts(SpiHigh(:,2)*1E4);
            spiL=ts(SpiLow(:,2)*1E4);
            tim=spiH;
            
                case 'Sas'
            load SpindlesPaCxSup
            spiH=ts(SpiHigh(:,2)*1E4);
            spiL=ts(SpiLow(:,2)*1E4);
            tim=spiH;
            
                case 'Spd'
            load SpindlesPFCxDeep
            spiH=ts(SpiHigh(:,2)*1E4);
            spiL=ts(SpiLow(:,2)*1E4);
            tim=spiH;
            
                case 'Sps'
            load SpindlesPFCxSup
            spiH=ts(SpiHigh(:,2)*1E4);
            spiL=ts(SpiLow(:,2)*1E4);
            tim=spiH;
            
            end
            
            
            tim=Restrict(tim,and(PreEpoch,SWSEpoch));
            %tim=Restrict(tim,and(PreEpoch,Wake));            
            
            
             if Dir.group{man}(1)=='W'
                 
              try
                      
                  [M1t,tps1,M2t,tps2,id,Mhpc,Mpa,Mpf,MauC,Mauth,Mbulb,Mpir,Mamy,Mden]=ObsTimeGlobalActivity(tim); 
                  set(gcf,'position',[1787          52        1166         886])
%                   saveFigure(1,'FigObsTimeGlobalActivityDeltaPfc',pwd)
                  close all
                  try
                  for i=1:size(Mbulb,1)
                  Mb=[Mb;Mbulb{i,1}];
                  end
                  end
                  
                  try
                  for i=1:size(Mhpc,1)
                  Mh=[Mh;Mhpc{i,1}];
                  end
                  end
                  
                  try
                  for i=1:size(Mpf,1)
                  Mp=[Mp;Mpf{i,1}];
                  end
                  end
                  
                  try
                  for i=1:size(Mpa,1)
                  Mpar=[Mpar;Mpa{i,1}];
                  end
                  end
                  
                 na{a}=pwd;
                 a=a+1;
              end
              
             else
                 
                 try
                     
                    [M1t,tps1,M2t,tps2,id,Mhpc,Mpa,Mpf,MauC,Mauth,Mbulb,Mpir,Mamy,Mden]=ObsTimeGlobalActivity(tim); 
                    set(gcf,'position',[1787          52        1166         886])
%                     saveFigure(1,'FigObsTimeGlobalActivityDeltaPfcKO',pwd)
                    close all
                  try
                  for i=1:size(Mbulb,1)
                  MbKO=[MbKO;Mbulb{i,1}];
                  end  
                  end
                  
                  try                   
                  for i=1:size(Mhpc,1)
                  MhKO=[MhKO;Mhpc{i,1}];
                  end
                  end
                  
                  try
                  for i=1:size(Mpf,1)
                  MpKO=[MpKO;Mpf{i,1}];
                  end
                  end
                  
                  try
                  for i=1:size(Mpa,1)
                  MparKO=[MparKO;Mpa{i,1}];
                  end
                  end
                  
                  
                 nako{b}=pwd;
                 b=b+1;                  
                 end      
                     
             end
             
            end
        
        end
    end
    
    
    figure('color',[1 1 1]), 
    subplot(3,1,1), plot(Mb','k'),xlim([4000 6500]), title('Bulb')
    subplot(3,1,2), plot(MbKO','r'),xlim([4000 6500]), 
    subplot(3,1,3), hold on, plot(mean(Mb)','k'),plot(mean(MbKO)','r'),xlim([4000 6500])
    
      figure('color',[1 1 1]), 
    subplot(3,1,1), plot(Mh','k'),xlim([4000 6500]), title('hpc')
    subplot(3,1,2), plot(MhKO','r'),xlim([4000 6500]), 
    subplot(3,1,3), hold on, plot(mean(Mh)','k'),plot(mean(MhKO)','r'),xlim([4000 6500])
    
        figure('color',[1 1 1]), 
    subplot(3,1,1), plot(Mp','k'),xlim([4000 6500]), title('Pfc')
    subplot(3,1,2), plot(MpKO','r'),xlim([4000 6500]), 
    subplot(3,1,3), hold on, plot(mean(Mp)','k'),plot(mean(MpKO)','r'),xlim([4000 6500])
    
    figure('color',[1 1 1]), 
    subplot(3,1,1), plot(Mpar','k'),xlim([4000 6500]), title('Par')
    subplot(3,1,2), plot(MparKO','r'),xlim([4000 6500]), 
    subplot(3,1,3), hold on, plot(mean(Mpar)','k'),plot(mean(MparKO)','r'),xlim([4000 6500])
    

    
    