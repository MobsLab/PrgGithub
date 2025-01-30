
%NoelliaStep2
   clear Cl
   clear Ch
   clear Bl
   clear Bh
   clear NBRipples
   clear NBSpindlesL
   clear NBSpindlesLH
   
for i=1:3
spiL=SpiL{2,i};
try
spitsdL=tsd(spiL(:,2)*1E4,spiL);
catch
spitsdL=[];
end

spiH=SpiH{2,i};
try
spitsdH=tsd(spiH(:,2)*1E4,spiH);
catch
spitsdH=[];
end
riptsd=tsd(Rip(:,2)*1E4,Rip);
%%
%                                              try
for j=listOK

%                                                     try
%                                                         length(Start(Epoch{j}))
%                                                         pwd
%                                                         if length(Start(Epoch{j}))>0

%                                                         try 
%                                                                                     disp('step1')
                try
                    Epoch{j}=Epoch{j}-NoiseEpoch ;
                end
                try
                    Epoch{j}=Epoch{j}-WeirdNoiseEpoch ;
                end
                try
                    Epoch{j}=Epoch{j}-GndNoiseEpoch;
                end
                try
                    Epoch{j}=mergecloseEpoch(Epoch{j},0.01);
                end
%                                                                     disp(
%                                                                     'step2')
                    riptsdtemp=Restrict(riptsd,Epoch{j});
                    rip=Data(riptsdtemp);

                    NBRipples{j}=length(rip)/sum(End(and(Epoch{j},SWSEpoch),'s')-Start(and(Epoch{j},SWSEpoch),'s'));

                    try
                        if pwd=='\\NASDELUXE\DataMOBs\ProjetLPS\Mouse055\20130403\BULB-Mouse-55-03042013'

                            sttopppp
                        end

                    spitsdLtemp=Restrict(spitsdL,Epoch{j});
                    spiL=Data(spitsdLtemp);
                    [Cl{i,j},Bl{i,j}]=CrossCorr(rip(:,2)*1E4,spiL(:,1)*1E4,200,200);
                    NBSpindlesL{i,j}=size(spiL,1)/sum(End(and(Epoch{j},SWSEpoch),'s')-Start(and(Epoch{j},SWSEpoch),'s'));
                    catch
                       NBSpindlesL{i,j}=0; 
                       Cl{i,j}=[];
                       Bl{i,j}=[];

                    end

%                                                                         isp('step3')
                    try
                    spitsdHtemp=Restrict(spitsdH,Epoch{j});
                    spiH=Data(spitsdHtemp);
                   [Ch{i,j},Bh{i,j}]=CrossCorr(rip(:,2)*1E4,spiH(:,1)*1E4,200,200);  
                   NBSpindlesH{i,j}=size(spiH,1)/sum(End(and(Epoch{j},SWSEpoch),'s')-Start(and(Epoch{j},SWSEpoch),'s'));  
                   catch
                       NBSpindlesH{i,j}=0; 
                       Ch{i,j}=[];
                       Bh{i,j}=[];
                    end

%                                                                         disp('step4')

%                                                                         disp('step5')



%                                                                         ClT{j}=[ClT{j};Cl{i,j}'];
%                                                                         ChT{j}=[ChT{j};Ch{i,j}'];   
                    %size(Ch)
                    %keyboard
%                                                                         nbSpindlesL{j}=[nbSpindlesL{j},size(spiL,1)];
%                                                                         nbSpindlesH{j}=[nbSpindlesH{j},size(spiH,1)];                                                                    
%                                                                         nbRipples{j}=[nbRipples{j},length(rip)];

                    spitsdLtemp=Restrict(spitsdL,Epoch{j});
                    spiL=Data(spitsdLtemp);
                    spitsdHtemp=Restrict(spitsdH,Epoch{j});
                    spiH=Data(spitsdHtemp);
                    riptsdtemp=Restrict(riptsd,Epoch{j});
                    rip=Data(riptsdtemp);
                    [M1hr{i,j},M2hr{i,j},M3hr{i,j},M1s{i,j},M2s{i,j},M3s{i,j},M1l{i,j},M2l{i,j},M3l{i,j},M1pr{i,j},M2pr{i,j},M3pr{i,j}]=PETHSpindlesRipples(spiH,spiL,rip) ;                                                             
                    subplot(2,2,1), title(pwd)
                    subplot(2,2,3), title(['i: ',num2str(i),', j: ', num2str(j)])

                    if j==2
                        disp('Veh')

                    end
                    if j==3
                        disp('LPS')
                   end
                    if j==4
                        disp('H24')

                    end
                    if j==5
                        disp('H48')
                        %figure, plot(Bl{3,5},Cl{3,5})
                    end
%                                                             end

%                                                         end
    clear riptsdtemp
    clear spitsdHtemp
    clear spitsdLtemp

%                                                     catch
%                                                         disp('pb')
%                                                         pwd 
%                                                         j
%                                                         i
%                                                         
%                                                     end
end
end
                            
                                                %%
                                            
                                  save CrossRipSpi Cl Ch Bl Bh  
%                                     NBSpindlesL{j}=size(spiL,1);
%                                     NBSpindlesH{j}=size(spiH,1);                                                                    
%                                     NBRipples{j}=length(rip);
                                    save NBRipSpindels NBSpindlesL NBSpindlesH NBRipples
                                    save PETHSpiRip M1hr M2hr M3hr M1s M2s M3s M1l M2l M3l M1pr M2pr M3pr
                            
                                  figure('color',[1 1 1]),nbfig=1;
                                  for i=1:3
                                      for j=1:5
                                        try  
                                  subplot(3,size(Cl,2),nbfig), hold on, 
                                  plot(Bl{i,j}/1E3,Cl{i,j},'k')
                                  plot(Bh{i,j}/1E3,Ch{i,j},'r')
                                  title([num2str(NBSpindlesL{i,j}),' ',num2str(NBSpindlesH{i,j})])
                                  nbfig=nbfig+1;
                                        end
                                      end
                                  end
                                  subplot(3,size(Cl,2),1), ylabel(pwd)
                                  
                                  
                                  
                                  
                                  
                                  
                                         
                                         