%BilanAnalysisDrugs

GenereData=0;
Ripl=0;

n=1;



% 
% * * * manipe DPCPX (new dose) * * *
% --- VEH - DPCPX ---
% '/media/DataMOBs/ProjetDPCPX/Mouse051/20130313/BULB-Mouse-51-13032013'
% '/media/DataMOBs/ProjetDPCPX/Mouse054/20130308/BULB-Mouse-54-08032013'
% '/media/DataMOBs/ProjetDPCPX/Mouse054/20130312/BULB-Mouse-54-12032013'
% '/media/DataMOBs/ProjetDPCPX/Mouse060/20130422/BULB-Mouse-60-22042013'
% '/media/DataMOBs/ProjetDPCPX/Mouse061/20130422/BULB-Mouse-61-22042013'
% 
% 
% * * * manipe Basal * * *
% '/media/DataMOBs/ProjetDPCPX/Mouse051/20121017/BULB-Mouse-51-17102012/'
% '/media/DataMOBs/ProjetDPCPX/Mouse052/20121113/BULB-Mouse-52-13112012/'
% '/media/DataMOBs/ProjetDPCPX/Mouse061/20130415/BULB-Mouse-61-15042013/'
% '/media/DataMOBs/ProjetDPCPX/Mouse060/20130415/BULB-Mouse-60-15042013/'
% '/media/DataMOBs/ProjetDPCPX/Mouse047/20121012/BULB-Mouse-47-12102012/'
% 

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

%--------------------------------------------------------------------------

%listLFP.channels{strcmp(listLFP.name,'dHPC')}
a=0;

%--------------------------------------------------------------------------
%--------------------------------------------------------------------------
% Basal
%--------------------------------------------------------------------------
%--------------------------------------------------------------------------

%Basal
cd \\NASDELUXE\DataMOBs\ProjetDPCPX\Mouse047\20121012\BULB-Mouse-47-12102012
pwd
if GenereData
    
    load('listLFP.mat');
    prof=listLFP.depth{strcmp(listLFP.name,'PFCx')};
    id1=find(prof==-1);
    id2=find(prof==0);
    if length(id1)>0
        num=id1;
    elseif length(id2)>0
        num=id2;
    else
        num=1;
    end
     
    num(2)=1;
    RiCh=listLFP.channels{strcmp(listLFP.name,'dHPC')};
    %47 nan 51 9 52 6 54 29 61 8 60 8 65 nan 66 8
    %num(2)=find(RiCh==nan);
    
    [R,D]=AnalysisLPSSingleDay(num,'com');close all
    
%     
% load SpindlesRipples Spi
% Bilan=R{34};
% Spi=R{49};
% id=find(Bilan(:,1)<85&Bilan(:,2)<20&Bilan(:,3)<20&Bilan(:,4)<20); 
% SpiC=Spi(id,:);
% save SpiCorrected SpiC Spi
% R{53}=SpiC;
save BilanDrugEffect -v7.3 R D num

else
    
    load BilanDrugEffect
    disp('Basal 47')
    DisplayResultsEffectDrug(R,D,n,Ripl)
    disp('Basal 47')
%     
% load SpindlesRipples Spi
% Bilan=R{34};
% Spi=R{49};
% id=find(Bilan(:,1)<85&Bilan(:,2)<20&Bilan(:,3)<20&Bilan(:,4)<20); 
% SpiC=Spi(id,:);
% save SpiCorrected SpiC Spi
% R{53}=SpiC;
% save BilanDrugEffect -v7.3 R D num

    a=a+1; RT{a}=R;
end

%--------------------------------------------------------------------------
cd \\NASDELUXE\DataMOBs\ProjetDPCPX\Mouse051\20121017\BULB-Mouse-51-17102012
pwd
if GenereData
    load('listLFP.mat');
    prof=listLFP.depth{strcmp(listLFP.name,'PFCx')};
    id1=find(prof==-1);
    id2=find(prof==0);
    if length(id1)>0
        num=id1;
    elseif length(id2)>0
        num=id2;
    else
        num=1;
    end
     num(2)=1;
    RiCh=listLFP.channels{strcmp(listLFP.name,'dHPC')};
    %47 nan 51 9 52 6 54 29 61 8 60 8 65 nan 66 8
%     num(2)=find(RiCh==9);
    
    [R,D]=AnalysisLPSSingleDay(num,'com');close all
       
% load SpindlesRipples Spi
% Bilan=R{34};
% Spi=R{49};
% id=find(Bilan(:,1)<85&Bilan(:,2)<20&Bilan(:,3)<20&Bilan(:,4)<20); 
% SpiC=Spi(id,:);
% save SpiCorrected SpiC Spi
% R{53}=SpiC;
save BilanDrugEffect -v7.3 R D num

else
    
    load BilanDrugEffect
    disp('Basal 51')
    DisplayResultsEffectDrug(R,D,n,Ripl)
    disp('Basal 51')
%         
% load SpindlesRipples Spi
% Bilan=R{34};
% Spi=R{49};
% id=find(Bilan(:,1)<85&Bilan(:,2)<20&Bilan(:,3)<20&Bilan(:,4)<20); 
% SpiC=Spi(id,:);
% save SpiCorrected SpiC Spi
% R{53}=SpiC;
% save BilanDrugEffect -v7.3 R D num
        a=a+1; RT{a}=R;
end

%--------------------------------------------------------------------------
cd \\NASDELUXE\DataMOBs\ProjetDPCPX\Mouse052\20121113\BULB-Mouse-52-13112012
pwd
if GenereData
    load('listLFP.mat');
    prof=listLFP.depth{strcmp(listLFP.name,'PFCx')};
    id1=find(prof==-1);
    id2=find(prof==0);
    if length(id1)>0
        num=id1;
    elseif length(id2)>0
        num=id2;
    else
        num=1;
    end
    num(2)=1;
    RiCh=listLFP.channels{strcmp(listLFP.name,'dHPC')};
    %47 nan 51 9 52 6 54 29 61 8 60 8 65 nan 66 8
    num(2)=find(RiCh==6);
    [R,D]=AnalysisLPSSingleDay(num,'com');close all
% %     load SpindlesRipples Spi
% % Bilan=R{34};
% % Spi=R{49};
% % id=find(Bilan(:,1)<85&Bilan(:,2)<20&Bilan(:,3)<20&Bilan(:,4)<20); 
% % SpiC=Spi(id,:);
% % save SpiCorrected SpiC Spi
% R{53}=SpiC;
save BilanDrugEffect -v7.3 R D num

else
    
    load BilanDrugEffect
    disp('Basal 52')
    DisplayResultsEffectDrug(R,D,n,Ripl)
    disp('Basal 52')
%     load SpindlesRipples Spi
% Bilan=R{34};
% Spi=R{49};
% id=find(Bilan(:,1)<85&Bilan(:,2)<20&Bilan(:,3)<20&Bilan(:,4)<20); 
% SpiC=Spi(id,:);
% save SpiCorrected SpiC Spi
% R{53}=SpiC;
% save BilanDrugEffect -v7.3 R D num
        a=a+1; RT{a}=R;
end

%--------------------------------------------------------------------------
cd \\NASDELUXE\DataMOBsRAID5\ProjetAstro\ProjetDPCPX\Mouse060\20130415\BULB-Mouse-60-15042013
pwd
if GenereData
    load('listLFP.mat');
    prof=listLFP.depth{strcmp(listLFP.name,'PFCx')};
    id1=find(prof==-1);
    id2=find(prof==0);
    if length(id1)>0
        num=id1;
    elseif length(id2)>0
        num=id2;
    else
        num=1;
    end
    num(2)=1;
    RiCh=listLFP.channels{strcmp(listLFP.name,'dHPC')};
    %47 nan 51 9 52 6 54 29 61 8 60 8 65 nan 66 8
    num(2)=find(RiCh==8);
    [R,D]=AnalysisLPSSingleDay(num,'com');close all
%        
% load SpindlesRipples Spi
% Bilan=R{34};
% Spi=R{49};
% id=find(Bilan(:,1)<85&Bilan(:,2)<20&Bilan(:,3)<20&Bilan(:,4)<20); 
% SpiC=Spi(id,:);
% save SpiCorrected SpiC Spi
% R{53}=SpiC;
save BilanDrugEffect -v7.3 R D num

else
    
    load BilanDrugEffect
    disp('Basal 60')
    DisplayResultsEffectDrug(R,D,n,Ripl)
    disp('Basal 60')
%         
% load SpindlesRipples Spi
% Bilan=R{34};
% Spi=R{49};
% id=find(Bilan(:,1)<85&Bilan(:,2)<20&Bilan(:,3)<20&Bilan(:,4)<20); 
% SpiC=Spi(id,:);
% save SpiCorrected SpiC Spi
% R{53}=SpiC;
% save BilanDrugEffect -v7.3 R D num
        a=a+1; RT{a}=R;
end

%--------------------------------------------------------------------------
cd \\NASDELUXE\DataMOBsRAID5\ProjetAstro\ProjetDPCPX\Mouse061\20130415\BULB-Mouse-61-15042013
pwd
if GenereData
    load('listLFP.mat');
    prof=listLFP.depth{strcmp(listLFP.name,'PFCx')};
    id1=find(prof==-1);
    id2=find(prof==0);
    if length(id1)>0
        num=id1;
    elseif length(id2)>0
        num=id2;
    else
        num=1;
    end
     num(2)=1;
    RiCh=listLFP.channels{strcmp(listLFP.name,'dHPC')};
    %47 nan 51 9 52 6 54 29 61 8 60 8 65 nan 66 8
    num(2)=find(RiCh==8);
    [R,D]=AnalysisLPSSingleDay(num,'com');close all
%        
% load SpindlesRipples Spi
% Bilan=R{34};
% Spi=R{49};
% id=find(Bilan(:,1)<85&Bilan(:,2)<20&Bilan(:,3)<20&Bilan(:,4)<20); 
% SpiC=Spi(id,:);
% save SpiCorrected SpiC Spi
% R{53}=SpiC;
save BilanDrugEffect -v7.3 R D num

else
    disp('Basal 61')
    load BilanDrugEffect
    DisplayResultsEffectDrug(R,D,n,Ripl)
disp('Basal 61')
%     
% load SpindlesRipples Spi
% Bilan=R{34};
% Spi=R{49};
% id=find(Bilan(:,1)<85&Bilan(:,2)<20&Bilan(:,3)<20&Bilan(:,4)<20); 
% SpiC=Spi(id,:);
% save SpiCorrected SpiC Spi
% R{53}=SpiC;
% save BilanDrugEffect -v7.3 R D num
    a=a+1; RT{a}=R;
end

%--------------------------------------------------------------------------

%--------------------------------------------------------------------------
%--------------------------------------------------------------------------
%EffectDPCPX  High dose
%--------------------------------------------------------------------------
%--------------------------------------------------------------------------

%DPCPX
cd \\NASDELUXE\DataMOBs\ProjetDPCPX\Mouse051\20130313\BULB-Mouse-51-13032013
pwd
if GenereData
    load('listLFP.mat');
    prof=listLFP.depth{strcmp(listLFP.name,'PFCx')};
    id1=find(prof==-1);
    id2=find(prof==0);
    if length(id1)>0
        num=id1;
    elseif length(id2)>0
        num=id2;
    else
        num=1;
    end
    num(2)=1;
    RiCh=listLFP.channels{strcmp(listLFP.name,'dHPC')};
    %47 nan 51 9 52 6 54 29 61 8 60 8 65 nan 66 8
    %num(2)=find(RiCh==9);
    [R,D]=AnalysisLPSSingleDay(num,'DPC');close all
%       
% load SpindlesRipples Spi
% Bilan=R{34};
% Spi=R{49};
% id=find(Bilan(:,1)<85&Bilan(:,2)<20&Bilan(:,3)<20&Bilan(:,4)<20); 
% SpiC=Spi(id,:);
% save SpiCorrected SpiC Spi
% R{53}=SpiC;
save BilanDrugEffect -v7.3 R D num
else
    
    load BilanDrugEffect
    disp('DPCPX 51 ')
    DisplayResultsEffectDrug(R,D,n,Ripl)
disp('DPCPX 51 ')
%     
% load SpindlesRipples Spi
% Bilan=R{34};
% Spi=R{49};
% id=find(Bilan(:,1)<85&Bilan(:,2)<20&Bilan(:,3)<20&Bilan(:,4)<20); 
% SpiC=Spi(id,:);
% save SpiCorrected SpiC Spi
% R{53}=SpiC;
% save BilanDrugEffect -v7.3 R D num
    a=a+1; RT{a}=R;
end

%--------------------------------------------------------------------------
cd \\NASDELUXE\DataMOBs\ProjetDPCPX\Mouse054\20130308\BULB-Mouse-54-08032013
pwd
if GenereData
    load('listLFP.mat');
    prof=listLFP.depth{strcmp(listLFP.name,'PFCx')};
    id1=find(prof==-1);
    id2=find(prof==0);
    if length(id1)>0
        num=id1;
    elseif length(id2)>0
        num=id2;
    else
        num=1;
    end
    num(2)=1;
    RiCh=listLFP.channels{strcmp(listLFP.name,'dHPC')};
    %47 nan 51 9 52 6 54 29 61 8 60 8 65 nan 66 8
    num(2)=find(RiCh==29);
    [R,D]=AnalysisLPSSingleDay(num,'DPC');close all
%         
% load SpindlesRipples Spi
% Bilan=R{34};
% Spi=R{49};
% id=find(Bilan(:,1)<85&Bilan(:,2)<20&Bilan(:,3)<20&Bilan(:,4)<20); 
% SpiC=Spi(id,:);
% save SpiCorrected SpiC Spi
% R{53}=SpiC;
save BilanDrugEffect -v7.3 R D num

else
    disp('Basal 54 (dKO) DPCPX')
    load BilanDrugEffect
    DisplayResultsEffectDrug(R,D,n,Ripl)
disp('DPCPX 54 (dKO) ')
%     
% load SpindlesRipples Spi
% Bilan=R{34};
% Spi=R{49};
% id=find(Bilan(:,1)<85&Bilan(:,2)<20&Bilan(:,3)<20&Bilan(:,4)<20); 
% SpiC=Spi(id,:);
% save SpiCorrected SpiC Spi
% R{53}=SpiC;
% save BilanDrugEffect -v7.3 R D num
    a=a+1; RT{a}=R;
end

%--------------------------------------------------------------------------
cd \\NASDELUXE\DataMOBs\ProjetDPCPX\Mouse054\20130312\BULB-Mouse-54-12032013
pwd
if GenereData
    load('listLFP.mat');
    prof=listLFP.depth{strcmp(listLFP.name,'PFCx')};
    id1=find(prof==-1);
    id2=find(prof==0);
    if length(id1)>0
        num=id1;
    elseif length(id2)>0
        num=id2;
    else
        num=1;
    end
    num(2)=1;
    RiCh=listLFP.channels{strcmp(listLFP.name,'dHPC')};
    %47 nan 51 9 52 6 54 29 61 8 60 8 65 nan 66 8
    num(2)=find(RiCh==29);
    [R,D]=AnalysisLPSSingleDay(num,'DPC');close all
%        
% load SpindlesRipples Spi
% Bilan=R{34};
% Spi=R{49};
% id=find(Bilan(:,1)<85&Bilan(:,2)<20&Bilan(:,3)<20&Bilan(:,4)<20); 
% SpiC=Spi(id,:);
% save SpiCorrected SpiC Spi
% R{53}=SpiC;
save BilanDrugEffect -v7.3 R D num

else
    disp('Basal 54 bis (dKO) DPCPX')
    load BilanDrugEffect
    DisplayResultsEffectDrug(R,D,n,Ripl)
disp('DPCPX 54 bis (dKO) ')
%     
% load SpindlesRipples Spi
% Bilan=R{34};
% Spi=R{49};
% id=find(Bilan(:,1)<85&Bilan(:,2)<20&Bilan(:,3)<20&Bilan(:,4)<20); 
% SpiC=Spi(id,:);
% save SpiCorrected SpiC Spi
% R{53}=SpiC;
% save BilanDrugEffect -v7.3 R D num
    a=a+1; RT{a}=R;
end

%--------------------------------------------------------------------------
cd \\NASDELUXE\DataMOBsRAID5\ProjetAstro\ProjetDPCPX\Mouse060\20130422\BULB-Mouse-60-22042013
pwd
if GenereData
    load('listLFP.mat');
    prof=listLFP.depth{strcmp(listLFP.name,'PFCx')};
    id1=find(prof==-1);
    id2=find(prof==0);
    if length(id1)>0
        num=id1;
    elseif length(id2)>0
        num=id2;
    else
        num=1;
    end
    num(2)=1;
    RiCh=listLFP.channels{strcmp(listLFP.name,'dHPC')};
    %47 nan 51 9 52 6 54 29 61 8 60 8 65 nan 66 8
    num(2)=find(RiCh==8);
    [R,D]=AnalysisLPSSingleDay(num,'DPC');close all
%      
% load SpindlesRipples Spi
% Bilan=R{34};
% Spi=R{49};
% id=find(Bilan(:,1)<85&Bilan(:,2)<20&Bilan(:,3)<20&Bilan(:,4)<20); 
% SpiC=Spi(id,:);
% save SpiCorrected SpiC Spi
% R{53}=SpiC;
save BilanDrugEffect -v7.3 R D num

else
    disp('Basal 60 DPCPX')
    load BilanDrugEffect
    DisplayResultsEffectDrug(R,D,n,Ripl)
disp('DPCPX 60 ')
%     
% load SpindlesRipples Spi
% Bilan=R{34};
% Spi=R{49};
% id=find(Bilan(:,1)<85&Bilan(:,2)<20&Bilan(:,3)<20&Bilan(:,4)<20); 
% SpiC=Spi(id,:);
% save SpiCorrected SpiC Spi
% R{53}=SpiC;
% save BilanDrugEffect -v7.3 R D num
    a=a+1; RT{a}=R;
end

%--------------------------------------------------------------------------
cd \\NASDELUXE\DataMOBsRAID5\ProjetAstro\ProjetDPCPX\Mouse061\20130422\BULB-Mouse-61-22042013
pwd
if GenereData
    load('listLFP.mat');
    prof=listLFP.depth{strcmp(listLFP.name,'PFCx')};
    id1=find(prof==-1);
    id2=find(prof==0);
    if length(id1)>0
        num=id1;
    elseif length(id2)>0
        num=id2;
    else
        num=1;
    end

   num(2)=1;
    RiCh=listLFP.channels{strcmp(listLFP.name,'dHPC')};
    %47 nan 51 9 52 6 54 29 61 8 60 8 65 nan 66 8
    num(2)=find(RiCh==8);
    [R,D]=AnalysisLPSSingleDay(num,'DPC');close all
%     
% load SpindlesRipples Spi
% Bilan=R{34};
% Spi=R{49};
% id=find(Bilan(:,1)<85&Bilan(:,2)<20&Bilan(:,3)<20&Bilan(:,4)<20); 
% SpiC=Spi(id,:);
% save SpiCorrected SpiC Spi
% R{53}=SpiC;
save BilanDrugEffect -v7.3 R D num
else
    disp('Basal 61 DPCPX')
    load BilanDrugEffect
    DisplayResultsEffectDrug(R,D,n,Ripl)
disp('DPCPX 61 ')
%     
% load SpindlesRipples Spi
% Bilan=R{34};
% Spi=R{49};
% id=find(Bilan(:,1)<85&Bilan(:,2)<20&Bilan(:,3)<20&Bilan(:,4)<20); 
% SpiC=Spi(id,:);
% save SpiCorrected SpiC Spi
% R{53}=SpiC;
% save BilanDrugEffect -v7.3 R D num
    a=a+1; RT{a}=R;
end

%--------------------------------------------------------------------------
%--------------------------------------------------------------------------
%--------------------------------------------------------------------------
%EffectLPS;
%--------------------------------------------------------------------------
%--------------------------------------------------------------------------

%Mouse°51
num=[2,1];
cd \\NASDELUXE\DataMOBs\ProjetLPS\Mouse051\20130220\BULB-Mouse-51-20022013
pwd
if GenereData
    % load('listLFP.mat');
    % prof=listLFP.depth{strcmp(listLFP.name,'PFCx')};
    % id1=find(prof==-1);
    % id2=find(prof==0);
    % if length(id1)>0
    %     num=id1;
    % elseif length(id2)>0
    %     num=id2;
    % else
    %     num=1;
    % end
    [R,D]=AnalysisLPSSingleDay(num,'veh');close all
%       
% load SpindlesRipples Spi
% Bilan=R{34};
% Spi=R{49};
% id=find(Bilan(:,1)<85&Bilan(:,2)<20&Bilan(:,3)<20&Bilan(:,4)<20); 
% SpiC=Spi(id,:);
% save SpiCorrected SpiC Spi
% R{53}=SpiC;
save BilanDrugEffect -v7.3 R D num

else
    disp('Veh 51 ')
    load BilanDrugEffect
    DisplayResultsEffectDrug(R,D,n,Ripl)
    disp('Veh 51 ')
%         
% load SpindlesRipples Spi
% Bilan=R{34};
% Spi=R{49};
% id=find(Bilan(:,1)<85&Bilan(:,2)<20&Bilan(:,3)<20&Bilan(:,4)<20); 
% SpiC=Spi(id,:);
% save SpiCorrected SpiC Spi
% R{53}=SpiC;
% save BilanDrugEffect -v7.3 R D num
        a=a+1; RT{a}=R;
end

%--------------------------------------------------------------------------
num=[2,1];
cd \\NASDELUXE\DataMOBs\ProjetLPS\Mouse051\20130221\BULB-Mouse-51-21022013
pwd
if GenereData
    % load('listLFP.mat');
    % prof=listLFP.depth{strcmp(listLFP.name,'PFCx')};
    % id1=find(prof==-1);
    % id2=find(prof==0);
    % if length(id1)>0
    %     num=id1;
    % elseif length(id2)>0
    %     num=id2;
    % else
    %     num=1;
    % end
    [R,D]=AnalysisLPSSingleDay(num,'LPS');close all
%       
% load SpindlesRipples Spi
% Bilan=R{34};
% Spi=R{49};
% id=find(Bilan(:,1)<85&Bilan(:,2)<20&Bilan(:,3)<20&Bilan(:,4)<20); 
% SpiC=Spi(id,:);
% save SpiCorrected SpiC Spi
% R{53}=SpiC;
save BilanDrugEffect -v7.3 R D num

else
    disp('LPS 51 ')
    load BilanDrugEffect
    DisplayResultsEffectDrug(R,D,n,Ripl)
disp('LPS 51 ')
%     
% load SpindlesRipples Spi
% Bilan=R{34};
% Spi=R{49};
% id=find(Bilan(:,1)<85&Bilan(:,2)<20&Bilan(:,3)<20&Bilan(:,4)<20); 
% SpiC=Spi(id,:);
% save SpiCorrected SpiC Spi
% R{53}=SpiC;
% save BilanDrugEffect -v7.3 R D num
    a=a+1; RT{a}=R;
end

%--------------------------------------------------------------------------
num=[2,1];
cd \\NASDELUXE\DataMOBs\ProjetLPS\Mouse051\20130222\BULB-Mouse-51-22022013
pwd
if GenereData
    % load('listLFP.mat');
    % prof=listLFP.depth{strcmp(listLFP.name,'PFCx')};
    % id1=find(prof==-1);
    % id2=find(prof==0);
    % if length(id1)>0
    %     num=id1;
    % elseif length(id2)>0
    %     num=id2;
    % else
    %     num=1;
    % end
    [R,D]=AnalysisLPSSingleDay(num,'non');close all
%       
% load SpindlesRipples Spi
% Bilan=R{34};
% Spi=R{49};
% id=find(Bilan(:,1)<85&Bilan(:,2)<20&Bilan(:,3)<20&Bilan(:,4)<20); 
% SpiC=Spi(id,:);
% save SpiCorrected SpiC Spi
% R{53}=SpiC;
save BilanDrugEffect -v7.3 R D num

else
    disp('LPS d1 51')
    load BilanDrugEffect
    DisplayResultsEffectDrug(R,D,n,Ripl)
    disp('LPS d1 51')
%         
% load SpindlesRipples Spi
% Bilan=R{34};
% Spi=R{49};
% id=find(Bilan(:,1)<85&Bilan(:,2)<20&Bilan(:,3)<20&Bilan(:,4)<20); 
% SpiC=Spi(id,:);
% save SpiCorrected SpiC Spi
% R{53}=SpiC;
% save BilanDrugEffect -v7.3 R D num
        a=a+1; RT{a}=R;
end

%--------------------------------------------------------------------------
num=[2,1];
cd \\NASDELUXE\DataMOBs\ProjetLPS\Mouse051\20130223\BULB-Mouse-51-23022013
pwd
if GenereData
    % load('listLFP.mat');
    % prof=listLFP.depth{strcmp(listLFP.name,'PFCx')};
    % id1=find(prof==-1);
    % id2=find(prof==0);
    % if length(id1)>0
    %     num=id1;
    % elseif length(id2)>0
    %     num=id2;
    % else
    %     num=1;
    % end
    [R,D]=AnalysisLPSSingleDay(num,'non');close all
%     
% load SpindlesRipples Spi
% Bilan=R{34};
% Spi=R{49};
% id=find(Bilan(:,1)<85&Bilan(:,2)<20&Bilan(:,3)<20&Bilan(:,4)<20); 
% SpiC=Spi(id,:);
% save SpiCorrected SpiC Spi
% R{53}=SpiC;
save BilanDrugEffect -v7.3 R D num

else
        disp('LPS d2 51')
    load BilanDrugEffect
    DisplayResultsEffectDrug(R,D,n,Ripl)
    disp('LPS d2 51')
%         
% load SpindlesRipples Spi
% Bilan=R{34};
% Spi=R{49};
% id=find(Bilan(:,1)<85&Bilan(:,2)<20&Bilan(:,3)<20&Bilan(:,4)<20); 
% SpiC=Spi(id,:);
% save SpiCorrected SpiC Spi
% R{53}=SpiC;
% save BilanDrugEffect -v7.3 R D num
        a=a+1; RT{a}=R;
end


%--------------------------------------------------------------------------
%--------------------------------------------------------------------------
%--------------------------------------------------------------------------

%Mouse°54
num=[1,1];
cd \\NASDELUXE\DataMOBs\ProjetLPS\Mouse054\20130319\BULB-Mouse-54-19032013
pwd
if GenereData
    load('listLFP.mat');
    prof=listLFP.depth{strcmp(listLFP.name,'PFCx')};
    id1=find(prof==-1);
    id2=find(prof==0);
    if length(id1)>0
        num=id1;
    elseif length(id2)>0
        num=id2;
    else
        num=1;
    end
         num(2)=1;
    RiCh=listLFP.channels{strcmp(listLFP.name,'dHPC')};
    %47 nan 51 9 52 6 54 29 61 8 60 8 65 nan 66 8;
     num(2)=find(RiCh==29);
    [R,D]=AnalysisLPSSingleDay(num,'veh');close all
%     
% load SpindlesRipples Spi
% Bilan=R{34};
% Spi=R{49};
% id=find(Bilan(:,1)<85&Bilan(:,2)<20&Bilan(:,3)<20&Bilan(:,4)<20); 
% SpiC=Spi(id,:);
% save SpiCorrected SpiC Spi
% R{53}=SpiC;
save BilanDrugEffect -v7.3 R D num
else
        disp('veh 54')
    load BilanDrugEffect
    DisplayResultsEffectDrug(R,D,n,Ripl)
        disp('veh 54')
%             
% load SpindlesRipples Spi
% Bilan=R{34};
% Spi=R{49};
% id=find(Bilan(:,1)<85&Bilan(:,2)<20&Bilan(:,3)<20&Bilan(:,4)<20); 
% SpiC=Spi(id,:);
% save SpiCorrected SpiC Spi
% R{53}=SpiC;
% save BilanDrugEffect -v7.3 R D num
            a=a+1; RT{a}=R;
end

%--------------------------------------------------------------------------
cd \\NASDELUXE\DataMOBs\ProjetLPS\Mouse054\20130320\BULB-Mouse-54-20032013
pwd
if GenereData
    load('listLFP.mat');
    prof=listLFP.depth{strcmp(listLFP.name,'PFCx')};
    id1=find(prof==-1);
    id2=find(prof==0);
    if length(id1)>0
        num=id1;
    elseif length(id2)>0
        num=id2;
    else
        num=1;
    end
         num(2)=1;
    RiCh=listLFP.channels{strcmp(listLFP.name,'dHPC')};
    %47 nan 51 9 52 6 54 29 61 8 60 8 65 nan 66 8
     num(2)=find(RiCh==29);
    [R,D]=AnalysisLPSSingleDay(num,'LPS');close all
%       
% load SpindlesRipples Spi
% Bilan=R{34};
% Spi=R{49};
% id=find(Bilan(:,1)<85&Bilan(:,2)<20&Bilan(:,3)<20&Bilan(:,4)<20); 
% SpiC=Spi(id,:);
% save SpiCorrected SpiC Spi
% R{53}=SpiC;
save BilanDrugEffect -v7.3 R D num

else
          disp('LPS 54')  
    load BilanDrugEffect
    DisplayResultsEffectDrug(R,D,n,Ripl)
          disp('LPS 54')  
%               
% load SpindlesRipples Spi
% Bilan=R{34};
% Spi=R{49};
% id=find(Bilan(:,1)<85&Bilan(:,2)<20&Bilan(:,3)<20&Bilan(:,4)<20); 
% SpiC=Spi(id,:);
% save SpiCorrected SpiC Spi
% R{53}=SpiC;
% save BilanDrugEffect -v7.3 R D num
              a=a+1; RT{a}=R;
end

%--------------------------------------------------------------------------
cd \\NASDELUXE\DataMOBs\ProjetLPS\Mouse054\20130321\BULB-Mouse-54-21032013
pwd
if GenereData
    load('listLFP.mat');
    prof=listLFP.depth{strcmp(listLFP.name,'PFCx')};
    id1=find(prof==-1);
    id2=find(prof==0);
    if length(id1)>0
        num=id1;
    elseif length(id2)>0
        num=id2;
    else
        num=1;
    end
         num(2)=1;
    RiCh=listLFP.channels{strcmp(listLFP.name,'dHPC')};
    %47 nan 51 9 52 6 54 29 61 8 60 8 65 nan 66 8
     num(2)=find(RiCh==29);
    [R,D]=AnalysisLPSSingleDay(num,'non');close all
%      
% load SpindlesRipples Spi
% Bilan=R{34};
% Spi=R{49};
% id=find(Bilan(:,1)<85&Bilan(:,2)<20&Bilan(:,3)<20&Bilan(:,4)<20); 
% SpiC=Spi(id,:);
% save SpiCorrected SpiC Spi
% R{53}=SpiC;
save BilanDrugEffect -v7.3 R D num

else
          disp('LPS d1 54')      
    load BilanDrugEffect
    DisplayResultsEffectDrug(R,D,n,Ripl)
          disp('LPS d1 54')  
%               
% load SpindlesRipples Spi
% Bilan=R{34};
% Spi=R{49};
% id=find(Bilan(:,1)<85&Bilan(:,2)<20&Bilan(:,3)<20&Bilan(:,4)<20); 
% SpiC=Spi(id,:);
% save SpiCorrected SpiC Spi
% R{53}=SpiC;
% save BilanDrugEffect -v7.3 R D num
              a=a+1; RT{a}=R;
end

%--------------------------------------------------------------------------
cd \\NASDELUXE\DataMOBs\ProjetLPS\Mouse054\20130322\BULB-Mouse-54-22032013
pwd
if GenereData
    load('listLFP.mat');
    prof=listLFP.depth{strcmp(listLFP.name,'PFCx')};
    id1=find(prof==-1);
    id2=find(prof==0);
    if length(id1)>0
        num=id1;
    elseif length(id2)>0
        num=id2;
    else
        num=1;
    end
         num(2)=1;
    RiCh=listLFP.channels{strcmp(listLFP.name,'dHPC')};
    %47 nan 51 9 52 6 54 29 61 8 60 8 65 nan 66 8
     num(2)=find(RiCh==29);
    [R,D]=AnalysisLPSSingleDay(num,'non');close all
%        
% load SpindlesRipples Spi
% Bilan=R{34};
% Spi=R{49};
% id=find(Bilan(:,1)<85&Bilan(:,2)<20&Bilan(:,3)<20&Bilan(:,4)<20); 
% SpiC=Spi(id,:);
% save SpiCorrected SpiC Spi
% R{53}=SpiC;
save BilanDrugEffect -v7.3 R D num

else
          disp('LPS d2 54')        
    load BilanDrugEffect
    DisplayResultsEffectDrug(R,D,n,Ripl)
          disp('LPS d2 54')  
%               
% load SpindlesRipples Spi
% Bilan=R{34};
% Spi=R{49};
% id=find(Bilan(:,1)<85&Bilan(:,2)<20&Bilan(:,3)<20&Bilan(:,4)<20); 
% SpiC=Spi(id,:);
% save SpiCorrected SpiC Spi
% R{53}=SpiC;
% save BilanDrugEffect -v7.3 R D num
              a=a+1; RT{a}=R;
end

%--------------------------------------------------------------------------
%--------------------------------------------------------------------------


cd \\NASDELUXE\DataMOBs\ProjetLPS\Mouse055\20130402\BULB-Mouse-55-56-02042013
pwd
if GenereData
    load('listLFP.mat');
    prof=listLFP.depth{strcmp(listLFP.name,'PFCx')};
    id1=find(prof==-1);
    id2=find(prof==0);
    if length(id1)>0
        num=id1;
    elseif length(id2)>0
        num=id2;
    else
        num=1;
    end
     num(2)=1;
    RiCh=listLFP.channels{strcmp(listLFP.name,'dHPC')};
    %47 nan 51 9 52 6 54 29 61 8 60 8 65 nan 66 8
%     num(2)=find(RiCh==29);
     num=[2,1];
    [R,D]=AnalysisLPSSingleDay(num,'non');close all
%     
% load SpindlesRipples Spi
% Bilan=R{34};
% Spi=R{49};
% id=find(Bilan(:,1)<85&Bilan(:,2)<20&Bilan(:,3)<20&Bilan(:,4)<20); 
% SpiC=Spi(id,:);
% save SpiCorrected SpiC Spi
% R{53}=SpiC;
save BilanDrugEffect -v7.3 R D num
    
    disp('Veh 55')        
 
    DisplayResultsEffectDrug(R,D,n,Ripl)
          disp('Veh 55')
              a=a+1; RT{a}=R;
              

else
          disp('Veh 55')        
    load BilanDrugEffect
    DisplayResultsEffectDrug(R,D,n,Ripl)
          disp('Veh 55')
              
% load SpindlesRipples Spi
% Bilan=R{34};
% Spi=R{49};
% id=find(Bilan(:,1)<85&Bilan(:,2)<20&Bilan(:,3)<20&Bilan(:,4)<20); 
% SpiC=Spi(id,:);
% save SpiCorrected SpiC Spi
% R{53}=SpiC;
% save BilanDrugEffect -v7.3 R D num
              a=a+1; RT{a}=R;
end
    
cd \\NASDELUXE\DataMOBs\ProjetLPS\Mouse055\20130403\BULB-Mouse-55-03042013
pwd
if GenereData
    % load('listLFP.mat');
    % prof=listLFP.depth{strcmp(listLFP.name,'PFCx')};
    % id1=find(prof==-1);
    % id2=find(prof==0);
    % if length(id1)>0
    %     num=id1;
    % elseif length(id2)>0
    %     num=id2;
    % else
    %     num=1;
    % end
     num=[2,1];
    [R,D]=AnalysisLPSSingleDay(num,'LPS');close all
     
% load SpindlesRipples Spi
% Bilan=R{34};
% Spi=R{49};
% id=find(Bilan(:,1)<85&Bilan(:,2)<20&Bilan(:,3)<20&Bilan(:,4)<20); 
% SpiC=Spi(id,:);
% save SpiCorrected SpiC Spi
% R{53}=SpiC;
save BilanDrugEffect -v7.3 R D num

              disp('LPS 55')        
    DisplayResultsEffectDrug(R,D,n,Ripl)
          disp('LPS 55')  
              a=a+1; RT{a}=R;
              
              
else
          disp('LPS 55')        
    load BilanDrugEffect
    DisplayResultsEffectDrug(R,D,n,Ripl)
          disp('LPS 55')  
              
% load SpindlesRipples Spi
% Bilan=R{34};
% Spi=R{49};
% id=find(Bilan(:,1)<85&Bilan(:,2)<20&Bilan(:,3)<20&Bilan(:,4)<20); 
% SpiC=Spi(id,:);
% save SpiCorrected SpiC Spi
% R{53}=SpiC;
% save BilanDrugEffect -v7.3 R D num
              a=a+1; RT{a}=R;
end


cd \\NASDELUXE\DataMOBs\ProjetLPS\Mouse055\20130404\BULB-Mouse-55-04042013
pwd
if GenereData
    % load('listLFP.mat');
    % prof=listLFP.depth{strcmp(listLFP.name,'PFCx')};
    % id1=find(prof==-1);
    % id2=find(prof==0);
    % if length(id1)>0
    %     num=id1;
    % elseif length(id2)>0
    %     num=id2;
    % else
    %     num=1;
    % end
     num=[2,1];
    [R,D]=AnalysisLPSSingleDay(num,'non');close all
   
    
% load SpindlesRipples Spi
% Bilan=R{34};
% Spi=R{49};
% id=find(Bilan(:,1)<85&Bilan(:,2)<20&Bilan(:,3)<20&Bilan(:,4)<20); 
% SpiC=Spi(id,:);
% save SpiCorrected SpiC Spi
% R{53}=SpiC;
% save BilanDrugEffect -v7.3 R D num
       disp('LPS d1 55')        

    DisplayResultsEffectDrug(R,D,n,Ripl)
          disp('LPS d1 55')  
              a=a+1; RT{a}=R;
              
              
else
          disp('LPS d1 55')        
    load BilanDrugEffect
    DisplayResultsEffectDrug(R,D,n,Ripl)
          disp('LPS d1 55')  
              
% load SpindlesRipples Spi
% Bilan=R{34};
% Spi=R{49};
% id=find(Bilan(:,1)<85&Bilan(:,2)<20&Bilan(:,3)<20&Bilan(:,4)<20); 
% SpiC=Spi(id,:);
% save SpiCorrected SpiC Spi
% R{53}=SpiC;
% save BilanDrugEffect -v7.3 R D num
              a=a+1; RT{a}=R;
end

cd \\NASDELUXE\DataMOBs\ProjetLPS\Mouse055\20130405\BULB-Mouse-55-05042013
pwd
if GenereData
    % load('listLFP.mat');
    % prof=listLFP.depth{strcmp(listLFP.name,'PFCx')};
    % id1=find(prof==-1);
    % id2=find(prof==0);
    % if length(id1)>0
    %     num=id1;
    % elseif length(id2)>0
    %     num=id2;
    % else
    %     num=1;
    % end
     num=[2,1];
    [R,D]=AnalysisLPSSingleDay(num,'non');close all
       
% load SpindlesRipples Spi
% Bilan=R{34};
% Spi=R{49};
% id=find(Bilan(:,1)<85&Bilan(:,2)<20&Bilan(:,3)<20&Bilan(:,4)<20); 
% SpiC=Spi(id,:);
% save SpiCorrected SpiC Spi
% R{53}=SpiC;
save BilanDrugEffect -v7.3 R D num
          disp('LPS d2 55')        
    DisplayResultsEffectDrug(R,D,num(1),Ripl)
          disp('LPS d2 55')  
              a=a+1; RT{a}=R;
              
else
          disp('LPS d2 55')        
    load BilanDrugEffect
    DisplayResultsEffectDrug(R,D,n,Ripl)
          disp('LPS d2 55')  
              
% load SpindlesRipples Spi
% Bilan=R{34};
% Spi=R{49};
% id=find(Bilan(:,1)<85&Bilan(:,2)<20&Bilan(:,3)<20&Bilan(:,4)<20); 
% SpiC=Spi(id,:);
% save SpiCorrected SpiC Spi
% R{53}=SpiC;
% save BilanDrugEffect -v7.3 R D num
              a=a+1; RT{a}=R;
end

%--------------------------------------------------------------------------
%--------------------------------------------------------------------------
%--------------------------------------------------------------------------


%Mouse°56
cd \\NASDELUXE\DataMOBs\ProjetLPS\Mouse056\20130409\BULB-Mouse-56-09042013
pwd
if GenereData
    load('listLFP.mat');
    prof=listLFP.depth{strcmp(listLFP.name,'PFCx')};
    id1=find(prof==-1);
    id2=find(prof==0);
    if length(id1)>0
        num=id1;
    elseif length(id2)>0
        num=id2;
    else
        num=1;
    end
     
    RipCh=listLFP.channels{strcmp(listLFP.name,'dHPC')};
    try
        num(2)=find(ismember(RipCh,Ripnum(56)));
    catch
        num(2)=1;    
    end
    
    [R,D]=AnalysisLPSSingleDay(num,'veh');close all
       
    save BilanDrugEffect -v7.3 R D num
          disp('Veh 56')        
    DisplayResultsEffectDrug(R,D,num(1),Ripl)
          disp('Veh 56')  
              a=a+1; RT{a}=R;
              
else
          disp('Veh 56')        
    load BilanDrugEffect
    DisplayResultsEffectDrug(R,D,n,Ripl)
          disp('Veh 56')  
              
%     save BilanDrugEffect -v7.3 R D num
              a=a+1; RT{a}=R;
end

%--------------------------------------------------------------------------
cd \\NASDELUXE\DataMOBs\ProjetLPS\Mouse056\20130410\BULB-Mouse-56-10042013
pwd
if GenereData
    load('listLFP.mat');
    prof=listLFP.depth{strcmp(listLFP.name,'PFCx')};
    id1=find(prof==-1);
    id2=find(prof==0);
    if length(id1)>0
        num=id1;
    elseif length(id2)>0
        num=id2;
    else
        num=1;
    end
     
    RipCh=listLFP.channels{strcmp(listLFP.name,'dHPC')};
    try
        num(2)=find(ismember(RipCh,Ripnum(56)));
    catch
        num(2)=1;    
    end
    
    [R,D]=AnalysisLPSSingleDay(num,'LPS');close all
       
    save BilanDrugEffect -v7.3 R D num
          disp('LPS 56')        
    DisplayResultsEffectDrug(R,D,num(1),Ripl)
          disp('LPS 56')  
              a=a+1; RT{a}=R;
              
else
          disp('LPS 56')        
    load BilanDrugEffect
    DisplayResultsEffectDrug(R,D,n,Ripl)
          disp('LPS 56')  
              
%     save BilanDrugEffect -v7.3 R D num
              a=a+1; RT{a}=R;
end

%--------------------------------------------------------------------------
% cd %missed
% a=a+1; RT{a}=[];

%--------------------------------------------------------------------------
cd \\NASDELUXE\DataMOBs\ProjetLPS\Mouse056\20130412\BULB-Mouse-56-12042013
pwd
if GenereData
    load('listLFP.mat');
    prof=listLFP.depth{strcmp(listLFP.name,'PFCx')};
    id1=find(prof==-1);
    id2=find(prof==0);
    if length(id1)>0
        num=id1;
    elseif length(id2)>0
        num=id2;
    else
        num=1;
    end
     
    RipCh=listLFP.channels{strcmp(listLFP.name,'dHPC')};
    try
        num(2)=find(ismember(RipCh,Ripnum(56)));
    catch
        num(2)=1;    
    end
    
    [R,D]=AnalysisLPSSingleDay(num,'non');close all
       
    save BilanDrugEffect -v7.3 R D num
          disp('LPS d2 56')        
    DisplayResultsEffectDrug(R,D,num(1),Ripl)
          disp('LPS d2 56')  
              a=a+1; RT{a}=R;
              
else
          disp('LPS d2 56')        
    load BilanDrugEffect
    DisplayResultsEffectDrug(R,D,n,Ripl)
          disp('LPS d2 56')  
              
%     save BilanDrugEffect -v7.3 R D num
              a=a+1; RT{a}=R;
end
%--------------------------------------------------------------------------


%Mouse°63
cd \\NASDELUXE\DataMOBs\ProjetLPS\Mouse063\20130424\BULB-Mouse-63-24042013
pwd
if GenereData
    load('listLFP.mat');
    prof=listLFP.depth{strcmp(listLFP.name,'PFCx')};
    id1=find(prof==-1);
    id2=find(prof==0);
    if length(id1)>0
        num=id1;
    elseif length(id2)>0
        num=id2;
    else
        num=1;
    end
     
    RipCh=listLFP.channels{strcmp(listLFP.name,'dHPC')};
    try
        num(2)=find(ismember(RipCh,Ripnum(63)));
    catch
        num(2)=1;    
    end
    
    [R,D]=AnalysisLPSSingleDay(num,'veh');close all
       
    save BilanDrugEffect -v7.3 R D num
          disp('Veh 63')        
    DisplayResultsEffectDrug(R,D,num(1),Ripl)
          disp('Veh 63')  
              a=a+1; RT{a}=R;
              
else
          disp('Veh 63')        
    load BilanDrugEffect
    DisplayResultsEffectDrug(R,D,n,Ripl)
          disp('Veh 63')  
              
%     save BilanDrugEffect -v7.3 R D num
              a=a+1; RT{a}=R;
end

%--------------------------------------------------------------------------
cd \\NASDELUXE\DataMOBs\ProjetLPS\Mouse063\20130425\BULB-Mouse-63-25042013
pwd
if GenereData
    load('listLFP.mat');
    prof=listLFP.depth{strcmp(listLFP.name,'PFCx')};
    id1=find(prof==-1);
    id2=find(prof==0);
    if length(id1)>0
        num=id1;
    elseif length(id2)>0
        num=id2;
    else
        num=1;
    end
     
    RipCh=listLFP.channels{strcmp(listLFP.name,'dHPC')};
    try
        num(2)=find(ismember(RipCh,Ripnum(63)));
    catch
        num(2)=1;    
    end
    
    [R,D]=AnalysisLPSSingleDay(num,'LPS');close all
       
    save BilanDrugEffect -v7.3 R D num
          disp('LPS 63')        
    DisplayResultsEffectDrug(R,D,num(1),Ripl)
          disp('LPS 63')  
              a=a+1; RT{a}=R;
              
else
          disp('LPS 63')        
    load BilanDrugEffect
    DisplayResultsEffectDrug(R,D,n,Ripl)
          disp('LPS 63')  
              
%     save BilanDrugEffect -v7.3 R D num
              a=a+1; RT{a}=R;
end
%--------------------------------------------------------------------------
cd \\NASDELUXE\DataMOBs\ProjetLPS\Mouse063\20130426\BULB-Mouse-63-26042013
pwd
if GenereData
    load('listLFP.mat');
    prof=listLFP.depth{strcmp(listLFP.name,'PFCx')};
    id1=find(prof==-1);
    id2=find(prof==0);
    if length(id1)>0
        num=id1;
    elseif length(id2)>0
        num=id2;
    else
        num=1;
    end
     
    RipCh=listLFP.channels{strcmp(listLFP.name,'dHPC')};
    try
        num(2)=find(ismember(RipCh,Ripnum(63)));
    catch
        num(2)=1;    
    end
    
    [R,D]=AnalysisLPSSingleDay(num,'non');close all
       
    save BilanDrugEffect -v7.3 R D num
          disp('LPS d1 63')        
    DisplayResultsEffectDrug(R,D,num(1),Ripl)
          disp('LPS d1 63')  
              a=a+1; RT{a}=R;
              
else
          disp('LPS d1 63')        
    load BilanDrugEffect
    DisplayResultsEffectDrug(R,D,n,Ripl)
          disp('LPS d1 63')  
              
%     save BilanDrugEffect -v7.3 R D num
              a=a+1; RT{a}=R;
end


%--------------------------------------------------------------------------
cd \\NASDELUXE\DataMOBs\ProjetLPS\Mouse063\20130427\BULB-Mouse-63-27042013
pwd
if GenereData
    load('listLFP.mat');
    prof=listLFP.depth{strcmp(listLFP.name,'PFCx')};
    id1=find(prof==-1);
    id2=find(prof==0);
    if length(id1)>0
        num=id1;
    elseif length(id2)>0
        num=id2;
    else
        num=1;
    end
     
    RipCh=listLFP.channels{strcmp(listLFP.name,'dHPC')};
    try
        num(2)=find(ismember(RipCh,Ripnum(63)));
    catch
        num(2)=1;    
    end
    
    [R,D]=AnalysisLPSSingleDay(num,'non');close all
       
    save BilanDrugEffect -v7.3 R D num
          disp('LPS d2 63')        
    DisplayResultsEffectDrug(R,D,num(1),Ripl)
          disp('LPS d2 63')  
              a=a+1; RT{a}=R;
              
else
          disp('LPS d2 63')        
    load BilanDrugEffect
    DisplayResultsEffectDrug(R,D,n,Ripl)
          disp('LPS d2 63')  
              
%     save BilanDrugEffect -v7.3 R D num
              a=a+1; RT{a}=R;
end
%--------------------------------------------------------------------------





%--------------------------------------------------------------------------
%--------------------------------------------------------------------------
%--------------------------------------------------------------------------

% Veh
%--------------------------------------------------------------------------
cd \\NASDELUXE\DataMOBs\ProjetDPCPX\Mouse047\20121112\BULB-Mouse-47-12112012
pwd
if GenereData
    load('listLFP.mat');
    prof=listLFP.depth{strcmp(listLFP.name,'PFCx')};
    id1=find(prof==-1);
    id2=find(prof==0);
    if length(id1)>0
        num=id1;
    elseif length(id2)>0
        num=id2;
    else
        num=1;
    end
     
    RipCh=listLFP.channels{strcmp(listLFP.name,'dHPC')};
    try
        num(2)=find(ismember(RipCh,Ripnum(47)));
    catch
        num(2)=1;    
    end
    
    [R,D]=AnalysisLPSSingleDay(num,'veh');close all
       
    save BilanDrugEffect -v7.3 R D num
          disp('Veh 47')        
    DisplayResultsEffectDrug(R,D,num(1),Ripl)
          disp('Veh 47')  
              a=a+1; RT{a}=R;
              
else
          disp('Veh 47')        
    load BilanDrugEffect
    DisplayResultsEffectDrug(R,D,n,Ripl)
          disp('Veh 47')  
              
%     save BilanDrugEffect -v7.3 R D num
              a=a+1; RT{a}=R;
end

cd \\NASDELUXE\DataMOBs\ProjetDPCPX\Mouse051\20121109\BULB-Mouse-51-09112012

pwd
if GenereData
    load('listLFP.mat');
    prof=listLFP.depth{strcmp(listLFP.name,'PFCx')};
    id1=find(prof==-1);
    id2=find(prof==0);
    if length(id1)>0
        num=id1;
    elseif length(id2)>0
        num=id2;
    else
        num=1;
    end
     
    RipCh=listLFP.channels{strcmp(listLFP.name,'dHPC')};
    try
        num(2)=find(ismember(RipCh,Ripnum(51)));
    catch
        num(2)=1;    
    end
    
    [R,D]=AnalysisLPSSingleDay(num,'veh');close all
       
    save BilanDrugEffect -v7.3 R D num
          disp('Veh 51')        
    DisplayResultsEffectDrug(R,D,num(1),Ripl)
          disp('Veh 51')  
              a=a+1; RT{a}=R;
              
else
          disp('Veh 51')        
    load BilanDrugEffect
    DisplayResultsEffectDrug(R,D,n,Ripl)
          disp('Veh 51')  
              
%     save BilanDrugEffect -v7.3 R D num
              a=a+1; RT{a}=R;
end


%'/media/DataMOBs/ProjetDPCPX/Mouse052/20121116/BULB-Mouse-52-16112012'

%--------------------------------------------------------------------------
% CP cannabinoids
%--------------------------------------------------------------------------
cd \\NASDELUXE\DataMOBsRAID5\ProjetAstro\ProjetCannabinoids\Mouse047\20130111\BULB-Mouse-47-11012013
pwd
if GenereData
    load('listLFP.mat');
    prof=listLFP.depth{strcmp(listLFP.name,'PFCx')};
    id1=find(prof==-1);
    id2=find(prof==0);
    if length(id1)>0
        num=id1;
    elseif length(id2)>0
        num=id2;
    else
        num=1;
    end
     
    RipCh=listLFP.channels{strcmp(listLFP.name,'dHPC')};
    try
        num(2)=find(ismember(RipCh,Ripnum(47)));
    catch
        num(2)=1;    
    end
    
    [R,D]=AnalysisLPSSingleDay(num,'Can');close all
       
    save BilanDrugEffect -v7.3 R D num
          disp('Veh 47')        
    DisplayResultsEffectDrug(R,D,num(1),Ripl)
          disp('Veh 47')  
              a=a+1; RT{a}=R;
              
else
          disp('Veh 47')        
    load BilanDrugEffect
    DisplayResultsEffectDrug(R,D,n,Ripl)
          disp('Veh 47')  
              
%     save BilanDrugEffect -v7.3 R D num
              a=a+1; RT{a}=R;
end




cd \\NASDELUXE\DataMOBsRAID5\ProjetAstro\ProjetCannabinoids\Mouse051\20130110\BULB-Mouse-51-10012013
pwd
if GenereData
    load('listLFP.mat');
    prof=listLFP.depth{strcmp(listLFP.name,'PFCx')};
    id1=find(prof==-1);
    id2=find(prof==0);
    if length(id1)>0
        num=id1;
    elseif length(id2)>0
        num=id2;
    else
        num=1;
    end
     
    RipCh=listLFP.channels{strcmp(listLFP.name,'dHPC')};
    try
        num(2)=find(ismember(RipCh,Ripnum(51)));
    catch
        num(2)=1;    
    end
    
    [R,D]=AnalysisLPSSingleDay(num,'Can');close all
       
    save BilanDrugEffect -v7.3 R D num
          disp('Can 51')        
    DisplayResultsEffectDrug(R,D,num(1),Ripl)
          disp('Can 51')  
              a=a+1; RT{a}=R;
              
else
          disp('Can 51')        
    load BilanDrugEffect
    DisplayResultsEffectDrug(R,D,n,Ripl)
          disp('Can 51')  
              
%     save BilanDrugEffect -v7.3 R D num
              a=a+1; RT{a}=R;
end



cd \\NASDELUXE\DataMOBsRAID5\ProjetAstro\ProjetCannabinoids\Mouse052\20130122\BULB-Mouse-52-22012013

pwd
if GenereData
    load('listLFP.mat');
    prof=listLFP.depth{strcmp(listLFP.name,'PFCx')};
    id1=find(prof==-1);
    id2=find(prof==0);
    if length(id1)>0
        num=id1;
    elseif length(id2)>0
        num=id2;
    else
        num=1;
    end
     
    RipCh=listLFP.channels{strcmp(listLFP.name,'dHPC')};
    try
        num(2)=find(ismember(RipCh,Ripnum(52)));
    catch
        num(2)=1;    
    end
    
    [R,D]=AnalysisLPSSingleDay(num,'Can');close all
       
    save BilanDrugEffect -v7.3 R D num
          disp('Can 52')        
    DisplayResultsEffectDrug(R,D,num(1),Ripl)
          disp('Can 52')  
              a=a+1; RT{a}=R;
              
else
          disp('Can 52')        
    load BilanDrugEffect
    DisplayResultsEffectDrug(R,D,n,Ripl)
          disp('Can 52')  
              
%     save BilanDrugEffect -v7.3 R D num
              a=a+1; RT{a}=R;
end



cd \\NASDELUXE\DataMOBsRAID5\ProjetAstro\ProjetCannabinoids\Mouse054\20130314\BULB-Mouse-54-14032013

pwd
if GenereData
    load('listLFP.mat');
    prof=listLFP.depth{strcmp(listLFP.name,'PFCx')};
    id1=find(prof==-1);
    id2=find(prof==0);
    if length(id1)>0
        num=id1;
    elseif length(id2)>0
        num=id2;
    else
        num=1;
    end
     
    RipCh=listLFP.channels{strcmp(listLFP.name,'dHPC')};
    try
        num(2)=find(ismember(RipCh,Ripnum(54)));
    catch
        num(2)=1;    
    end
    
    [R,D]=AnalysisLPSSingleDay(num,'Can');close all
       
    save BilanDrugEffect -v7.3 R D num
          disp('Can 54')        
    DisplayResultsEffectDrug(R,D,num(1),Ripl)
          disp('Can 54')  
              a=a+1; RT{a}=R;
              
else
          disp('Can 54')        
    load BilanDrugEffect
    DisplayResultsEffectDrug(R,D,n,Ripl)
          disp('Can 54')  
              
%     save BilanDrugEffect -v7.3 R D num
              a=a+1; RT{a}=R;
end





%--------------------------------------------------------------------------
%--------------------------------------------------------------------------
%--------------------------------------------------------------------------

% load SpindlesRipples Spi
% Bilan=R{34};
% Spi=R{49};
% id=find(Bilan(:,1)<85&Bilan(:,2)<20&Bilan(:,3)<20&Bilan(:,4)<20); 
% SpiC=Spi(id,:);
% save SpiCorrected SpiC Spi
% R{53}=SpiC;
% save BilanDrugEffect -v7.3 R D num



close all

% cd \\NASDELUXE\DataMOBs\ProjetDPCPX
% save DataBilanAnalysisDrugs RT

% cd \\NASDELUXE\DataMOBs
cd C:\Users\MOBs3
save DataBilanNoelia RT



