%PlotDrugEffectAnalysis
% 
% tic, [Spi1]=FindSpindlesKarim(LFP{1},[10 15],SWSEpoch);toc
% tic, [Spi2]=FindSpindlesKarim(LFP{2},[10 15],SWSEpoch);toc
% tic, [Spi3]=FindSpindlesKarim(LFP{3},[10 15],SWSEpoch);toc
% 
% tic, [Spi1l]=FindSpindlesKarim(LFP{1},[4 10],SWSEpoch);toc
% tic, [Spi2l]=FindSpindlesKarim(LFP{2},[4 10],SWSEpoch);toc
% tic, [Spi3l]=FindSpindlesKarim(LFP{3},[4 10],SWSEpoch);toc
% 
% figure('color',[1 1 1]), hold on
% plot(Range(LFP{1},'s'),Data(LFP{1}),'r')
% plot(Range(LFP{1},'s'),Data(LFP{2}),'k')
% plot(Range(LFP{1},'s'),Data(LFP{3}),'b')
% 
% line([Spi1(:,1) Spi1(:,3)],[-3000 8000],'color','r','linewidth',2)
% line([Spi1(:,1) Spi1(:,2)],[-3000 8000],'color','r','linewidth',2)
% line([Spi2(:,1) Spi2(:,3)],[-3000 8000],'color','k','linewidth',2)
% line([Spi2(:,1) Spi2(:,2)],[-3000 8000],'color','k','linewidth',2)
% line([Spi3(:,1) Spi3(:,3)],[-3000 8000],'color','b','linewidth',2)
% line([Spi3(:,1) Spi3(:,2)],[-3000 8000],'color','b','linewidth',2)
% 
% line([Spi2(:,1) Spi2(:,3)],[-3000 8000],'color','r','linewidth',1)
% line([Spi2(:,1) Spi2(:,3)],[-3000 8000],'color','k','linewidth',1)
% line([Spi2(:,1) Spi2(:,3)],[-3000 8000],'color','b','linewidth',1)


%BilanAnalysisDrugs

% GenereData=0;
% Ripl=0;
% 
% n=1;



%--------------------------------------------------------------------------
% Hpc ripples
%--------------------------------------------------------------------------
% 47 none
% 51
% 52
% 54
% 55
% 61
% 60
Ripnum=zeros(66,1);
Ripnum(51)=9;
Ripnum(52)=6;
Ripnum(54)=29;
Ripnum(56)=11;
Ripnum(60)=8;
Ripnum(61)=8;
Ripnum(66)=8;



% Basal=1;
% Veh=2;
% BasalDP=3;
% VehDP=4;
% DPCPX=5;
% BasalLPS=6;
% VehLPS=7;
% LPSs1=8;
% LPSd2=9;
% BasalCP=10;
% VehCP=11;
% CP=12;

Basal=1;
Veh=2;
DPCPX=3;
VehLPS=4;
LPS=5;
LPSd1=6;
LPSd2=7;
CP=8;

% C57: 55 56 63
% wt: 51p 60 61 
% dKO: 47p(pas d'Hpc) 52p 54p 65 66


MiceNb(1)=55;  % c57
MiceNb(2)=56;  % c57
MiceNb(3)=63;  % c57

MiceNb(4)=51;  % wt
MiceNb(5)=60;  % wt
MiceNb(6)=61;  % wt

MiceNb(7)=47;  % ko
MiceNb(8)=52;  % ko
MiceNb(9)=54;  % ko
MiceNb(10)=65; % ko
MiceNb(11)=66; % ko


%--------------------------------------------------------------------------

%listLFP.channels{strcmp(listLFP.name,'dHPC')}
a=0;
%--------------------------------------------------------------------------
%--------------------------------------------------------------------------
%--------------------------------------------------------------------------
% Basal
%--------------------------------------------------------------------------
%--------------------------------------------------------------------------
filename{1,7,1}='\\NASDELUXE\DataMOBs\ProjetDPCPX\Mouse047\20121012\BULB-Mouse-47-12102012';
%--------------------------------------------------------------------------
filename{1,4,1}='\\NASDELUXE\DataMOBs\ProjetDPCPX\Mouse051\20121017\BULB-Mouse-51-17102012';
%--------------------------------------------------------------------------
filename{1,8,1}='\\NASDELUXE\DataMOBs\ProjetDPCPX\Mouse052\20121113\BULB-Mouse-52-13112012';
%--------------------------------------------------------------------------
filename{1,5,1}='\\NASDELUXE\DataMOBsRAID5\ProjetAstro\ProjetDPCPX\Mouse060\20130415\BULB-Mouse-60-15042013';
%--------------------------------------------------------------------------
filename{1,6,1}='\\NASDELUXE\DataMOBsRAID5\ProjetAstro\ProjetDPCPX\Mouse061\20130415\BULB-Mouse-61-15042013';
%--------------------------------------------------------------------------
%--------------------------------------------------------------------------
%--------------------------------------------------------------------------
%EffectDPCPX  High dose
%--------------------------------------------------------------------------
%--------------------------------------------------------------------------
%DPCPX
filename{3,4,1}='\\NASDELUXE\DataMOBs\ProjetDPCPX\Mouse051\20130313\BULB-Mouse-51-13032013';
%--------------------------------------------------------------------------
filename{3,9,1}='\\NASDELUXE\DataMOBs\ProjetDPCPX\Mouse054\20130308\BULB-Mouse-54-08032013';
%--------------------------------------------------------------------------
filename{3,9,2}='\\NASDELUXE\DataMOBs\ProjetDPCPX\Mouse054\20130312\BULB-Mouse-54-12032013';
%--------------------------------------------------------------------------
filename{3,5,1}='\\NASDELUXE\DataMOBsRAID5\ProjetAstro\ProjetDPCPX\Mouse060\20130422\BULB-Mouse-60-22042013';
%--------------------------------------------------------------------------
filename{3,6,1}='\\NASDELUXE\DataMOBsRAID5\ProjetAstro\ProjetDPCPX\Mouse061\20130422\BULB-Mouse-61-22042013';
%--------------------------------------------------------------------------
%--------------------------------------------------------------------------
%--------------------------------------------------------------------------
%EffectLPS;
%--------------------------------------------------------------------------
%--------------------------------------------------------------------------
%Mouse°51
num=[2,1];
filename{4,4,1}='\\NASDELUXE\DataMOBs\ProjetLPS\Mouse051\20130220\BULB-Mouse-51-20022013';
%--------------------------------------------------------------------------
filename{5,4,1}='\\NASDELUXE\DataMOBs\ProjetLPS\Mouse051\20130221\BULB-Mouse-51-21022013';
%--------------------------------------------------------------------------
filename{6,4,1}='\\NASDELUXE\DataMOBs\ProjetLPS\Mouse051\20130222\BULB-Mouse-51-22022013';
%--------------------------------------------------------------------------
filename{7,4,1}='\\NASDELUXE\DataMOBs\ProjetLPS\Mouse051\20130223\BULB-Mouse-51-23022013';
%--------------------------------------------------------------------------
%--------------------------------------------------------------------------
%--------------------------------------------------------------------------
%Mouse°54
num=[1,1];
filename{4,9,1}='\\NASDELUXE\DataMOBs\ProjetLPS\Mouse054\20130319\BULB-Mouse-54-19032013';
%--------------------------------------------------------------------------
filename{5,9,1}='\\NASDELUXE\DataMOBs\ProjetLPS\Mouse054\20130320\BULB-Mouse-54-20032013';
%--------------------------------------------------------------------------
filename{6,9,1}='\\NASDELUXE\DataMOBs\ProjetLPS\Mouse054\20130321\BULB-Mouse-54-21032013';
%--------------------------------------------------------------------------
filename{7,9,1}='\\NASDELUXE\DataMOBs\ProjetLPS\Mouse054\20130322\BULB-Mouse-54-22032013';
%--------------------------------------------------------------------------
%--------------------------------------------------------------------------
%--------------------------------------------------------------------------
%Mouse°55
filename{4,1,1}='\\NASDELUXE\DataMOBs\ProjetLPS\Mouse055\20130402\BULB-Mouse-55-56-02042013';
%--------------------------------------------------------------------------
filename{5,1,1}='\\NASDELUXE\DataMOBs\ProjetLPS\Mouse055\20130403\BULB-Mouse-55-03042013';
%--------------------------------------------------------------------------
filename{6,1,1}='\\NASDELUXE\DataMOBs\ProjetLPS\Mouse055\20130404\BULB-Mouse-55-04042013';
%--------------------------------------------------------------------------
filename{7,1,1}='\\NASDELUXE\DataMOBs\ProjetLPS\Mouse055\20130405\BULB-Mouse-55-05042013';
%--------------------------------------------------------------------------
%--------------------------------------------------------------------------
%--------------------------------------------------------------------------
%Mouse°56
filename{4,2,1}='\\NASDELUXE\DataMOBs\ProjetLPS\Mouse056\20130409\BULB-Mouse-56-09042013';
%--------------------------------------------------------------------------
filename{5,2,1}='\\NASDELUXE\DataMOBs\ProjetLPS\Mouse056\20130410\BULB-Mouse-56-10042013';
%--------------------------------------------------------------------------
% cd %missed
%--------------------------------------------------------------------------
filename{7,2,1}='\\NASDELUXE\DataMOBs\ProjetLPS\Mouse056\20130412\BULB-Mouse-56-12042013';
%--------------------------------------------------------------------------
%--------------------------------------------------------------------------
%--------------------------------------------------------------------------
%Mouse°63
filename{4,3,1}='\\NASDELUXE\DataMOBs\ProjetLPS\Mouse063\20130424\BULB-Mouse-63-24042013';
%--------------------------------------------------------------------------
filename{5,3,1}='\\NASDELUXE\DataMOBs\ProjetLPS\Mouse063\20130425\BULB-Mouse-63-25042013';
%--------------------------------------------------------------------------
filename{6,3,1}='\\NASDELUXE\DataMOBs\ProjetLPS\Mouse063\20130426\BULB-Mouse-63-26042013';
%--------------------------------------------------------------------------
filename{7,3,1}='\\NASDELUXE\DataMOBs\ProjetLPS\Mouse063\20130427\BULB-Mouse-63-27042013';
%--------------------------------------------------------------------------
%--------------------------------------------------------------------------
%--------------------------------------------------------------------------
% Veh
%--------------------------------------------------------------------------
%--------------------------------------------------------------------------
filename{2,7,1}='\\NASDELUXE\DataMOBs\ProjetDPCPX\Mouse047\20121112\BULB-Mouse-47-12112012';
%--------------------------------------------------------------------------
filename{2,4,1}='\\NASDELUXE\DataMOBs\ProjetDPCPX\Mouse051\20121109\BULB-Mouse-51-09112012';
%--------------------------------------------------------------------------
filename{2,8,1}='\\NASDELUXE\DataMOBs\ProjetDPCPX\Mouse052\20121116\BULB-Mouse-52-16112012';
%--------------------------------------------------------------------------
%--------------------------------------------------------------------------
%--------------------------------------------------------------------------
% CP cannabinoids
%--------------------------------------------------------------------------
%--------------------------------------------------------------------------
filename{8,7,1}='\\NASDELUXE\DataMOBsRAID5\ProjetAstro\ProjetCannabinoids\Mouse047\20130111\BULB-Mouse-47-11012013';
%--------------------------------------------------------------------------
filename{8,4,1}='\\NASDELUXE\DataMOBsRAID5\ProjetAstro\ProjetCannabinoids\Mouse051\20130110\BULB-Mouse-51-10012013';
%--------------------------------------------------------------------------
filename{8,8,1}='\\NASDELUXE\DataMOBsRAID5\ProjetAstro\ProjetCannabinoids\Mouse052\20130122\BULB-Mouse-52-22012013';
%--------------------------------------------------------------------------
filename{8,9,1}='\\NASDELUXE\DataMOBsRAID5\ProjetAstro\ProjetCannabinoids\Mouse054\20130314\BULB-Mouse-54-14032013';
%--------------------------------------------------------------------------
%--------------------------------------------------------------------------
%--------------------------------------------------------------------------
%--------------------------------------------------------------------------
%--------------------------------------------------------------------------

manipeLPS=4:7; %facteur a
C57=1:3; %facteur b
wt=4:6;
ko=7:11;


  for w=1:5
        ClT{w}=[];
        ChT{w}=[];  
        nbSpindlesL{w}=[];
        nbSpindlesH{w}=[];
        nbRipples{w}=[];
  end
  it=0;
  
for b=C57    
for a=manipeLPS                       
for c=1
            
            
% try
                
                %%
                 if [a b c]==[5 2 1]
%                     stttopppppp;
disp('problem')
%                  end
                 else
                     
                            cd(filename{a,b,c})
                            filename{a,b,c}
                            a,b,c
                            it=it+1
                            
                            
                            try
                                    ggload CrossRipSpi
                                     for i=1:3
                                        for j=1:5
                                            ClT{j}=[ClT{j};Cl{i,j}'];
                                            ChT{j}=[ChT{j};Ch{i,j}']; 
                                        end
                                     end



                            catch
                                
                                
                                        load behavResources PreEpoch VEHEpoch LPSEpoch H24Epoch H48Epoch 
                                        
                                        load StateEpoch NoiseEpoch WeirdNoiseEpoch GndNoiseEpoch
                                        
                                        load Spindles SpiH SpiL 
%                                         size(SpiH{1,1})
%                                         size(SpiL{1,1})
                                        
                                        %load Ripples Rip
                                        load SpindlesRipples Rip
                                        disp('loaded')
                                        pwd

                                        
                                        clear Epoch                                 
                                        pause(0)
                                        Epoch{1}=[];
                                        Epoch{2}=[];
                                        Epoch{3}=[];
                                        Epoch{4}=[];
                                        Epoch{5}=[];
                                      
                                        pause(1)
                                        
                                        try 
                                            if length(Start(PreEpoch))>0
                                                    Epoch{1}=PreEpoch;
                                            end
                                        end
                                        try
                                            Epoch{2}=VEHEpoch;
                                        end
                                        try
                                            Epoch{3}=LPSEpoch;
                                        end
                                        try
                                            Epoch{4}=H24Epoch;
                                        end
                                        try
                                            Epoch{5}=H48Epoch;
                                        end
                                        
                                        pause(1)
                                        
%--------------------------------------------------------------------------                                       
                                        try
                                            Epoch
                                        catch
                                           keyboard
                                        end
%--------------------------------------------------------------------------                                                                               
                                        
                                        clear VEHEpoch
                                        clear LPSEPoch
                                        clear PreEpoch
                                        clear H24Epoch
                                        clear H48Epoch
                                        clear NoiseEpoch
                                        clear WeirdNoiseEpoch
                                        clear GndNoiseEpoch
                                        
                                        
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
                                                for j=1:length(Epoch)
                                                    
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
                                                                        spitsdLtemp=Restrict(spitsdL,Epoch{j});
                                                                        spiL=Data(spitsdLtemp);
%                                                                         d
%                                                                         isp('step3')
                                                                        spitsdHtemp=Restrict(spitsdH,Epoch{j});
                                                                        spiH=Data(spitsdHtemp);
%                                                                         disp('step4')
                                                                        riptsdtemp=Restrict(riptsd,Epoch{j});
                                                                        rip=Data(riptsdtemp);
%                                                                         disp('step5')
                                                                        [Cl{i,j},Bl{i,j}]=CrossCorr(rip(:,2)*1E4,spiL(:,1)*1E4,200,200);
                                                                        [Ch{i,j},Bh{i,j}]=CrossCorr(rip(:,2)*1E4,spiH(:,1)*1E4,200,200);

                                                                        ClT{j}=[ClT{j};Cl{i,j}'];
                                                                        ChT{j}=[ChT{j};Ch{i,j}'];   
                                                                        %size(Ch)
                                                                        %keyboard
                                                                        nbSpindlesL{j}=[nbSpindlesL{j},size(spiL,1)];
                                                                        nbSpindlesH{j}=[nbSpindlesH{j},size(spiH,1)];                                                                    
                                                                        nbRipples{j}=[nbRipples{j},length(rip)];


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
                                            clear Epoch
                                            clear riptsd
                                            clear spitsdH
                                            clear spitsdL
                                                %%
                                            
                                  save CrossRipSpi Cl Ch Bl Bh  
                                  tps=Bl{1,1};
                                  clear Cl 
                                  clear Ch
                                  clear Bl
                                  clear Bh    

                            end

                                  
                            
                            if 0
                            load LFPdHPC
                            load LFPPFCx
                            load LFPPaCx
                            load LFPAuCx
                            load LFPAuTh
                            load LFPBulb
                            end

                 end %if 247


% end   %244
  %%                          
end
end
end

%     
% smo=5; 
% figure('color',[1 1 1]), hold on
% plot(tps/1E3,smooth(nanmean(ClT{1}),smo),'b')
% plot(tps/1E3,smooth(nanmean(ClT{1})-stdError(ClT{1}(~isnan(ClT{1}))),smo),'b')
% plot(tps/1E3,smooth(nanmean(ClT{1})+stdError(ClT{1}(~isnan(ClT{1}))),smo),'b')
% hold on, plot(tps/1E3,smooth(nanmean(ClT{2}),smo),'k','linewidth',2)
% hold on, plot(tps/1E3,smooth(nanmean(ClT{3}),smo),'r','linewidth',2)
% hold on, plot(tps/1E3,smooth(nanmean(ClT{4}),smo),'m')
% hold on, plot(tps/1E3,smooth(nanmean(ClT{5}),smo),'m')
% yl=ylim;
% line([0 0],yl,'color',[0.7 0.7 0.7])
% 
% 
% figure('color',[1 1 1]), plot(tps/1E3,smooth(nanmean(ChT{1}),smo),'b')
% hold on, plot(tps/1E3,smooth(nanmean(ChT{2}),smo),'k','linewidth',2)
% hold on, plot(tps/1E3,smooth(nanmean(ChT{3}),smo),'r','linewidth',2)
% hold on, plot(tps/1E3,smooth(nanmean(ChT{4}),smo),'m')
% hold on, plot(tps/1E3,smooth(nanmean(ChT{5}),smo),'m')
% yl=ylim;
% line([0 0],yl,'color',[0.7 0.7 0.7])
% 
% 




smo=5; figure('color',[1 1 1]), 
nb=1;

subplot(2,3,1), 
plot(tps/1E3,smooth(nanmean(ClT{1}(nb:3:end,:)),smo),'b')
hold on, plot(tps/1E3,smooth(nanmean(ClT{2}(nb:3:end,:)),smo),'k','linewidth',2)
hold on, plot(tps/1E3,smooth(nanmean(ClT{3}(nb:3:end,:)),smo),'r','linewidth',2)
hold on, plot(tps/1E3,smooth(nanmean(ClT{4}(nb:3:end,:)),smo),'m')
hold on, plot(tps/1E3,smooth(nanmean(ClT{5}(nb:3:end,:)),smo),'m')
yl=ylim;
line([0 0],yl,'color',[0.7 0.7 0.7])
nb=2;
subplot(2,3,2), 
plot(tps/1E3,smooth(nanmean(ClT{1}(nb:3:end,:)),smo),'b')
hold on, plot(tps/1E3,smooth(nanmean(ClT{2}(nb:3:end,:)),smo),'k','linewidth',2)
hold on, plot(tps/1E3,smooth(nanmean(ClT{3}(nb:3:end,:)),smo),'r','linewidth',2)
hold on, plot(tps/1E3,smooth(nanmean(ClT{4}(nb:3:end,:)),smo),'m')
hold on, plot(tps/1E3,smooth(nanmean(ClT{5}(nb:3:end,:)),smo),'m')
yl=ylim;
line([0 0],yl,'color',[0.7 0.7 0.7])
nb=3;
subplot(2,3,3), plot(tps/1E3,smooth(nanmean(ClT{1}(nb:3:end,:)),smo),'b')
hold on, plot(tps/1E3,smooth(nanmean(ClT{2}(nb:3:end,:)),smo),'k','linewidth',2)
hold on, plot(tps/1E3,smooth(nanmean(ClT{3}(nb:3:end,:)),smo),'r','linewidth',2)
hold on, plot(tps/1E3,smooth(nanmean(ClT{4}(nb:3:end,:)),smo),'m')
hold on, plot(tps/1E3,smooth(nanmean(ClT{5}(nb:3:end,:)),smo),'m')
yl=ylim;
line([0 0],yl,'color',[0.7 0.7 0.7])



nb=1;
subplot(2,3,4), plot(tps/1E3,smooth(nanmean(ChT{1}(nb:3:end,:)),smo),'b')
hold on, plot(tps/1E3,smooth(nanmean(ChT{2}(nb:3:end,:)),smo),'k','linewidth',2)
hold on, plot(tps/1E3,smooth(nanmean(ChT{3}(nb:3:end,:)),smo),'r','linewidth',2)
hold on, plot(tps/1E3,smooth(nanmean(ChT{4}(nb:3:end,:)),smo),'m')
hold on, plot(tps/1E3,smooth(nanmean(ChT{5}(nb:3:end,:)),smo),'m')
yl=ylim;
line([0 0],yl,'color',[0.7 0.7 0.7])

nb=2;
subplot(2,3,5), plot(tps/1E3,smooth(nanmean(ChT{1}(nb:3:end,:)),smo),'b')
hold on, plot(tps/1E3,smooth(nanmean(ChT{2}(nb:3:end,:)),smo),'k','linewidth',2)
hold on, plot(tps/1E3,smooth(nanmean(ChT{3}(nb:3:end,:)),smo),'r','linewidth',2)
hold on, plot(tps/1E3,smooth(nanmean(ChT{4}(nb:3:end,:)),smo),'m')
hold on, plot(tps/1E3,smooth(nanmean(ChT{5}(nb:3:end,:)),smo),'m')
yl=ylim;
line([0 0],yl,'color',[0.7 0.7 0.7])

nb=3;
subplot(2,3,6), plot(tps/1E3,smooth(nanmean(ChT{1}(nb:3:end,:)),smo),'b')
hold on, plot(tps/1E3,smooth(nanmean(ChT{2}(nb:3:end,:)),smo),'k','linewidth',2)
hold on, plot(tps/1E3,smooth(nanmean(ChT{3}(nb:3:end,:)),smo),'r','linewidth',2)
hold on, plot(tps/1E3,smooth(nanmean(ChT{4}(nb:3:end,:)),smo),'m')
hold on, plot(tps/1E3,smooth(nanmean(ChT{5}(nb:3:end,:)),smo),'m')
yl=ylim;
line([0 0],yl,'color',[0.7 0.7 0.7])


