%DrugEffectAnalysis
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


MiceNb(1)=55;
MiceNb(2)=56;
MiceNb(3)=63;

MiceNb(4)=51;
MiceNb(5)=60;
MiceNb(6)=61;

MiceNb(7)=47;
MiceNb(8)=52;
MiceNb(9)=54;
MiceNb(10)=65;
MiceNb(11)=66;


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

for a=1:10
    for b=1:10
        for c=1:2
            
            try
                
cd(filename{a,b,c})

clear SpiH 
clear SpiL 
clear Rip

load StateEpoch

try
load LFPdHPC
for i=1:length(LFP)
    SpiH{1,i}=FindSpindlesKarim(LFP{i},[10 15],SWSEpoch);
    SpiL{1,i}=FindSpindlesKarim(LFP{i},[4 10],SWSEpoch);
    Rip{1,i}=FindRipplesKarim(LFP{i},SWSEpoch);
end
end

try
load LFPPFCx
for i=1:length(LFP)
    SpiH{2,i}=FindSpindlesKarim(LFP{i},[10 15],SWSEpoch);
    SpiL{2,i}=FindSpindlesKarim(LFP{i},[4 10],SWSEpoch);
    Rip{2,i}=FindRipplesKarim(LFP{i},SWSEpoch);
end
end

try
load LFPPaCx
for i=1:length(LFP)
    SpiH{3,i}=FindSpindlesKarim(LFP{i},[10 15],SWSEpoch);
    SpiL{3,i}=FindSpindlesKarim(LFP{i},[4 10],SWSEpoch);
    Rip{3,i}=FindRipplesKarim(LFP{i},SWSEpoch);
end
end

try
load LFPAuCx
for i=1:length(LFP)
    SpiH{4,i}=FindSpindlesKarim(LFP{i},[10 15],SWSEpoch);
    SpiL{4,i}=FindSpindlesKarim(LFP{i},[4 10],SWSEpoch);
    Rip{4,i}=FindRipplesKarim(LFP{i},SWSEpoch);
end
end

try
load LFPAuTh
for i=1:length(LFP)
    SpiH{5,i}=FindSpindlesKarim(LFP{i},[10 15],SWSEpoch);
    SpiL{5,i}=FindSpindlesKarim(LFP{i},[4 10],SWSEpoch);
    Rip{5,i}=FindRipplesKarim(LFP{i},SWSEpoch);
end
end

try
load LFPBulb
for i=1:length(LFP)
    SpiH{6,i}=FindSpindlesKarim(LFP{i},[10 15],SWSEpoch);
    SpiL{6,i}=FindSpindlesKarim(LFP{i},[4 10],SWSEpoch);
    Rip{6,i}=FindRipplesKarim(LFP{i},SWSEpoch);
end
end

save Spindles SpiH SpiL 
save Ripples Rip
            end
        end
    end
end
