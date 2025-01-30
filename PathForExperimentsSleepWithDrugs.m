function Dir=PathForExperimentsSleepWithDrugs(experiment)


%% Fluoxetine acute experiment
% FLX_DayPre
% FLX_NightPre
% FLX_DaySaline - injected 0.3mL of saline before recording
% FLX_NightSaline
% FLX_DayFlx - injection 0.3mL of Fluoxetine (15mg/kg) before recording
% FLX_NightFlx
% FLX_DayFlx24h
% FLX_NightFlx24h

%% Fluoxetine chronic experiment
% FLX_Ch_Baseline
% FLX_Ch_Admin
 
%% LPS
% Mice 51,55,56,63 were not recorded all day
% Mouse 124 was recorded for longer periods of time
% Mouse 123 is excluded (died after LPS injection)
% LPS_Exp1_Sal : injected with 0.1mL of saline in middle of recording
% LPS_Exp1_LPS : injected with 0.1mL of LPS (10ug) in middle of recording
% LPS_Exp1_LPS24h
% LPS_Exp1_Day48h

a=0;
if strcmpi(experiment,'FLX_DayPre')
    
    a=a+1; Dir.path{a}{1}='/media/DataMOBsRAIDN/ProjectEmbReact/FLX_Ctrl_exp/Mouse666/20180221_Day/';
    a=a+1; Dir.path{a}{1}='/media/DataMOBsRAIDN/ProjectEmbReact/FLX_Ctrl_exp/Mouse667/20180221_Day/';
    a=a+1; Dir.path{a}{1}='/media/DataMOBsRAIDN/ProjectEmbReact/FLX_Ctrl_exp/Mouse668/20180221_Day/';
    a=a+1; Dir.path{a}{1}='/media/DataMOBsRAIDN/ProjectEmbReact/FLX_Ctrl_exp/Mouse669/20180221_Day/';
    
elseif  strcmpi(experiment,'FLX_NightPre')
    
    a=a+1; Dir.path{a}{1}='/media/DataMOBsRAIDN/ProjectEmbReact/FLX_Ctrl_exp/Mouse666/20180221_Night/';
    a=a+1; Dir.path{a}{1}='/media/DataMOBsRAIDN/ProjectEmbReact/FLX_Ctrl_exp/Mouse667/20180221_Night/';
    a=a+1; Dir.path{a}{1}='/media/DataMOBsRAIDN/ProjectEmbReact/FLX_Ctrl_exp/Mouse668/20180221_Night/';
    a=a+1; Dir.path{a}{1}='/media/DataMOBsRAIDN/ProjectEmbReact/FLX_Ctrl_exp/Mouse669/20180221_Night/';
    
elseif  strcmpi(experiment,'FLX_DaySaline')
    
    a=a+1; Dir.path{a}{1}='/media/DataMOBsRAIDN/ProjectEmbReact/FLX_Ctrl_exp/Mouse666/20180222_Day_saline/';
    a=a+1; Dir.path{a}{1}='/media/DataMOBsRAIDN/ProjectEmbReact/FLX_Ctrl_exp/Mouse667/20180222_Day_saline/';
    a=a+1; Dir.path{a}{1}='/media/DataMOBsRAIDN/ProjectEmbReact/FLX_Ctrl_exp/Mouse668/20180222_Day_saline/';
    a=a+1; Dir.path{a}{1}='/media/DataMOBsRAIDN/ProjectEmbReact/FLX_Ctrl_exp/Mouse669/20180222_Day_saline/';
    
elseif  strcmpi(experiment,'FLX_NightSaline')
    
    a=a+1; Dir.path{a}{1}='/media/DataMOBsRAIDN/ProjectEmbReact/FLX_Ctrl_exp/Mouse666/20180222_Night_saline/';
    a=a+1; Dir.path{a}{1}='/media/DataMOBsRAIDN/ProjectEmbReact/FLX_Ctrl_exp/Mouse667/20180222_Night_saline/';
    a=a+1; Dir.path{a}{1}='/media/DataMOBsRAIDN/ProjectEmbReact/FLX_Ctrl_exp/Mouse668/20180222_Night_saline/';
    a=a+1; Dir.path{a}{1}='/media/DataMOBsRAIDN/ProjectEmbReact/FLX_Ctrl_exp/Mouse669/20180222_Night_saline/';
    
elseif  strcmpi(experiment,'FLX_DayFlx')
    
    a=a+1; Dir.path{a}{1}='/media/DataMOBsRAIDN/ProjectEmbReact/FLX_Ctrl_exp/Mouse666/20180223_Day_fluoxetine/';
    a=a+1; Dir.path{a}{1}='/media/DataMOBsRAIDN/ProjectEmbReact/FLX_Ctrl_exp/Mouse667/20180223_Day_fluoxetine/';
    a=a+1; Dir.path{a}{1}='/media/DataMOBsRAIDN/ProjectEmbReact/FLX_Ctrl_exp/Mouse668/20180223_Day_fluoxetine/';
    a=a+1; Dir.path{a}{1}='/media/DataMOBsRAIDN/ProjectEmbReact/FLX_Ctrl_exp/Mouse669/20180223_Day_fluoxetine/';
    
elseif  strcmpi(experiment,'FLX_NightFlx')
    
    a=a+1; Dir.path{a}{1}='/media/DataMOBsRAIDN/ProjectEmbReact/FLX_Ctrl_exp/Mouse666/20180223_Night_fluoxetine/';
    a=a+1; Dir.path{a}{1}='/media/DataMOBsRAIDN/ProjectEmbReact/FLX_Ctrl_exp/Mouse667/20180223_Night_fluoxetine/';
    a=a+1; Dir.path{a}{1}='/media/DataMOBsRAIDN/ProjectEmbReact/FLX_Ctrl_exp/Mouse668/20180223_Night_fluoxetine/';
    a=a+1; Dir.path{a}{1}='/media/DataMOBsRAIDN/ProjectEmbReact/FLX_Ctrl_exp/Mouse669/20180223_Night_fluoxetine/';
    
elseif  strcmpi(experiment,'FLX_DayFlx24h')
    
    a=a+1; Dir.path{a}{1}='/media/DataMOBsRAIDN/ProjectEmbReact/FLX_Ctrl_exp/Mouse666/20180224_Day_fluoxetine48H/';
    a=a+1; Dir.path{a}{1}='/media/DataMOBsRAIDN/ProjectEmbReact/FLX_Ctrl_exp/Mouse667/20180224_Day_fluoxetine48H/';
    a=a+1; Dir.path{a}{1}='/media/DataMOBsRAIDN/ProjectEmbReact/FLX_Ctrl_exp/Mouse668/20180224_Day_fluoxetine48H/';
    a=a+1; Dir.path{a}{1}='/media/DataMOBsRAIDN/ProjectEmbReact/FLX_Ctrl_exp/Mouse669/20180224_Day_fluoxetine48H/';
    
elseif  strcmpi(experiment,'FLX_NightFlx24h')
    
    a=a+1; Dir.path{a}{1}='/media/DataMOBsRAIDN/ProjectEmbReact/FLX_Ctrl_exp/Mouse666/20180224_Night_fluoxetine48H/';
    a=a+1; Dir.path{a}{1}='/media/DataMOBsRAIDN/ProjectEmbReact/FLX_Ctrl_exp/Mouse667/20180224_Night_fluoxetine48H/';
    a=a+1; Dir.path{a}{1}='/media/DataMOBsRAIDN/ProjectEmbReact/FLX_Ctrl_exp/Mouse668/20180224_Night_fluoxetine48H/';
    a=a+1; Dir.path{a}{1}='/media/DataMOBsRAIDN/ProjectEmbReact/FLX_Ctrl_exp/Mouse669/20180224_Night_fluoxetine48H/';
    
elseif  strcmpi(experiment,'FLX_Ch_Baseline')
    
    % Mouse 875
    a=a+1; Dir.path{a}{1}='/media/nas4/ProjetEmbReact/Mouse875/20190411/';
    load([Dir.path{a}{1},'ExpeInfo.mat']),Dir.ExpeInfo{a}{1}=ExpeInfo;
    
     % Mouse 876
    a=a+1; Dir.path{a}{1}='/media/nas4/ProjetEmbReact/Mouse876/20190411/';
    load([Dir.path{a}{1},'ExpeInfo.mat']),Dir.ExpeInfo{a}{1}=ExpeInfo;
    
     % Mouse 877
   % a=a+1; Dir.path{a}{1}='/media/nas4/ProjetEmbReact/Mouse877/20190417/';
   % load([Dir.path{a}{1},'ExpeInfo.mat']),Dir.ExpeInfo{a}{1}=ExpeInfo;
    
    % Mouse 1001
    a=a+1;Dir.path{a}{1}='/media/nas4/ProjetEmbReact/Mouse1001/20191029/';
    load([Dir.path{a}{1},'ExpeInfo.mat']),Dir.ExpeInfo{a}{1}=ExpeInfo;
    Dir.path{a}{2}='/media/nas4/ProjetEmbReact/Mouse1001/20191030/';
    load([Dir.path{a}{2},'ExpeInfo.mat']),Dir.ExpeInfo{a}{2}=ExpeInfo;
    
    % Mouse 1002
    a=a+1;Dir.path{a}{1}='/media/nas4/ProjetEmbReact/Mouse1002/20191029/';
    load([Dir.path{a}{1},'ExpeInfo.mat']),Dir.ExpeInfo{a}{1}=ExpeInfo;
    Dir.path{a}{2}='/media/nas4/ProjetEmbReact/Mouse1002/20191030/';
    load([Dir.path{a}{2},'ExpeInfo.mat']),Dir.ExpeInfo{a}{2}=ExpeInfo;

    % Mouse 1003
    a=a+1;Dir.path{a}{1}='/media/nas4/ProjetEmbReact/Mouse1003/20191023/';
    load([Dir.path{a}{1},'ExpeInfo.mat']),Dir.ExpeInfo{a}{1}=ExpeInfo;
    
    % Mouse 1009
    a=a+1;Dir.path{a}{1}='/media/nas4/ProjetEmbReact/Mouse1009/20191119/';
    load([Dir.path{a}{1},'ExpeInfo.mat']),Dir.ExpeInfo{a}{1}=ExpeInfo;
    Dir.path{a}{2}='/media/nas4/ProjetEmbReact/Mouse1009/20191120/';
    load([Dir.path{a}{2},'ExpeInfo.mat']),Dir.ExpeInfo{a}{2}=ExpeInfo;
   
    % Mouse 1056
    a=a+1;Dir.path{a}{1}='/media/nas4/ProjetEmbReact/Mouse1056/20200226/';
    load([Dir.path{a}{1},'ExpeInfo.mat']),Dir.ExpeInfo{a}{1}=ExpeInfo;
    Dir.path{a}{2}='/media/nas4/ProjetEmbReact/Mouse1056/20200227/';
    load([Dir.path{a}{2},'ExpeInfo.mat']),Dir.ExpeInfo{a}{2}=ExpeInfo;
    
    % Mouse 1058
    a=a+1;Dir.path{a}{1}='/media/nas4/ProjetEmbReact/Mouse1058/20200226/';
    load([Dir.path{a}{1},'ExpeInfo.mat']),Dir.ExpeInfo{a}{1}=ExpeInfo;
    Dir.path{a}{2}='/media/nas4/ProjetEmbReact/Mouse1058/20200227/';
    load([Dir.path{a}{2},'ExpeInfo.mat']),Dir.ExpeInfo{a}{2}=ExpeInfo;
    
    % Mouse 1095
    a=a+1;Dir.path{a}{1}='/media/nas4/ProjetEmbReact/Mouse1095/20200630/';
    load([Dir.path{a}{1},'ExpeInfo.mat']),Dir.ExpeInfo{a}{1}=ExpeInfo;
    Dir.path{a}{2}='/media/nas4/ProjetEmbReact/Mouse1095/20200701/';
    load([Dir.path{a}{2},'ExpeInfo.mat']),Dir.ExpeInfo{a}{2}=ExpeInfo;
    
elseif  strcmpi(experiment,'FLX_Ch_Admin')
    
    % Mouse 875
    a=a+1; Dir.path{a}{1}='/media/nas4/ProjetEmbReact/Mouse875/20190514/';
    load([Dir.path{a}{1},'ExpeInfo.mat']),Dir.ExpeInfo{a}{1}=ExpeInfo;
    Dir.path{a}{2}='/media/nas4/ProjetEmbReact/Mouse875/20190516/';
    load([Dir.path{a}{2},'ExpeInfo.mat']),Dir.ExpeInfo{a}{2}=ExpeInfo;
    Dir.path{a}{3}='/media/nas4/ProjetEmbReact/Mouse875/20190523/';
    load([Dir.path{a}{3},'ExpeInfo.mat']),Dir.ExpeInfo{a}{3}=ExpeInfo;
    Dir.path{a}{4}='/media/nas4/ProjetEmbReact/Mouse875/20190530/';
    load([Dir.path{a}{4},'ExpeInfo.mat']),Dir.ExpeInfo{a}{4}=ExpeInfo;

    % Mouse 876
    a=a+1; Dir.path{a}{1}='/media/nas4/ProjetEmbReact/Mouse876/20190507/';
    load([Dir.path{a}{1},'ExpeInfo.mat']),Dir.ExpeInfo{a}{1}=ExpeInfo;
    Dir.path{a}{2}='/media/nas4/ProjetEmbReact/Mouse876/20190509/';
    load([Dir.path{a}{2},'ExpeInfo.mat']),Dir.ExpeInfo{a}{2}=ExpeInfo;
    Dir.path{a}{3}='/media/nas4/ProjetEmbReact/Mouse876/20190516/';
    load([Dir.path{a}{3},'ExpeInfo.mat']),Dir.ExpeInfo{a}{3}=ExpeInfo;
    Dir.path{a}{4}='/media/nas4/ProjetEmbReact/Mouse876/20190523/';
    load([Dir.path{a}{4},'ExpeInfo.mat']),Dir.ExpeInfo{a}{4}=ExpeInfo;

    % Mouse 877
   % a=a+1;Dir.path{a}{1}='/media/nas4/ProjetEmbReact/Mouse877/20190513/';
%    % load([Dir.path{a}{1},'ExpeInfo.mat']),Dir.ExpeInfo{a}{1}=ExpeInfo;
%     Dir.path{a}{2}='/media/nas4/ProjetEmbReact/Mouse877/20190520/';
%     load([Dir.path{a}{2},'ExpeInfo.mat']),Dir.ExpeInfo{a}{2}=ExpeInfo;
%     Dir.path{a}{3}='/media/nas4/ProjetEmbReact/Mouse877/20190527/';
%     load([Dir.path{a}{3},'ExpeInfo.mat']),Dir.ExpeInfo{a}{3}=ExpeInfo;

    % Mouse 1001
    a=a+1;Dir.path{a}{1}='/media/nas4/ProjetEmbReact/Mouse1001/20191101/';
    load([Dir.path{a}{1},'ExpeInfo.mat']),Dir.ExpeInfo{a}{1}=ExpeInfo;
    Dir.path{a}{2}='/media/nas4/ProjetEmbReact/Mouse1001/20191104/';
    load([Dir.path{a}{2},'ExpeInfo.mat']),Dir.ExpeInfo{a}{2}=ExpeInfo;
    Dir.path{a}{3}='/media/nas4/ProjetEmbReact/Mouse1001/20191111/';
    load([Dir.path{a}{3},'ExpeInfo.mat']),Dir.ExpeInfo{a}{3}=ExpeInfo;
    Dir.path{a}{4}='/media/nas4/ProjetEmbReact/Mouse1001/20191114/';
    load([Dir.path{a}{4},'ExpeInfo.mat']),Dir.ExpeInfo{a}{4}=ExpeInfo;
    
    % Mouse 1002
    a=a+1;Dir.path{a}{1}='/media/nas4/ProjetEmbReact/Mouse1002/20191107/';
    load([Dir.path{a}{1},'ExpeInfo.mat']),Dir.ExpeInfo{a}{1}=ExpeInfo;
    Dir.path{a}{2}='/media/nas4/ProjetEmbReact/Mouse1002/20191111/';
    load([Dir.path{a}{2},'ExpeInfo.mat']),Dir.ExpeInfo{a}{2}=ExpeInfo;
    Dir.path{a}{3}='/media/nas4/ProjetEmbReact/Mouse1002/20191119/';
    load([Dir.path{a}{3},'ExpeInfo.mat']),Dir.ExpeInfo{a}{3}=ExpeInfo;

    % Mouse 1003
    a=a+1;Dir.path{a}{1}='/media/nas4/ProjetEmbReact/Mouse1003/20191027/';
    load([Dir.path{a}{1},'ExpeInfo.mat']),Dir.ExpeInfo{a}{1}=ExpeInfo;
    Dir.path{a}{2}='/media/nas4/ProjetEmbReact/Mouse1003/20191028/';
    load([Dir.path{a}{2},'ExpeInfo.mat']),Dir.ExpeInfo{a}{2}=ExpeInfo;
    Dir.path{a}{3}='/media/nas4/ProjetEmbReact/Mouse1003/20191104/';
    load([Dir.path{a}{3},'ExpeInfo.mat']),Dir.ExpeInfo{a}{3}=ExpeInfo;
    Dir.path{a}{4}='/media/nas4/ProjetEmbReact/Mouse1003/20191114/';
    load([Dir.path{a}{4},'ExpeInfo.mat']),Dir.ExpeInfo{a}{4}=ExpeInfo;
    
    % Mouse 1009
    a=a+1;Dir.path{a}{1}='/media/nas4/ProjetEmbReact/Mouse1009/20191122/';
    load([Dir.path{a}{1},'ExpeInfo.mat']),Dir.ExpeInfo{a}{1}=ExpeInfo;
    Dir.path{a}{2}='/media/nas4/ProjetEmbReact/Mouse1009/20191125/';
    load([Dir.path{a}{2},'ExpeInfo.mat']),Dir.ExpeInfo{a}{2}=ExpeInfo;
    Dir.path{a}{3}='/media/nas4/ProjetEmbReact/Mouse1009/20191126/';
    load([Dir.path{a}{3},'ExpeInfo.mat']),Dir.ExpeInfo{a}{3}=ExpeInfo;

    % Mouse 1056
    a=a+1;Dir.path{a}{1}='/media/nas4/ProjetEmbReact/Mouse1056/20200303/';
    load([Dir.path{a}{1},'ExpeInfo.mat']),Dir.ExpeInfo{a}{1}=ExpeInfo;
    Dir.path{a}{2}='/media/nas4/ProjetEmbReact/Mouse1056/20200303/';
    load([Dir.path{a}{2},'ExpeInfo.mat']),Dir.ExpeInfo{a}{2}=ExpeInfo;
    Dir.path{a}{3}='/media/nas4/ProjetEmbReact/Mouse1056/20200310/';
    load([Dir.path{a}{3},'ExpeInfo.mat']),Dir.ExpeInfo{a}{3}=ExpeInfo;
    
    % Mouse 1058
    a=a+1;Dir.path{a}{1}='/media/nas4/ProjetEmbReact/Mouse1058/20200303/';
    load([Dir.path{a}{1},'ExpeInfo.mat']),Dir.ExpeInfo{a}{1}=ExpeInfo;
    Dir.path{a}{2}='/media/nas4/ProjetEmbReact/Mouse1058/20200306/';
    load([Dir.path{a}{2},'ExpeInfo.mat']),Dir.ExpeInfo{a}{2}=ExpeInfo;
    
    % Mouse 1095
    a=a+1;Dir.path{a}{1}='/media/nas4/ProjetEmbReact/Mouse1095/20200710/';
    load([Dir.path{a}{1},'ExpeInfo.mat']),Dir.ExpeInfo{a}{1}=ExpeInfo;
    Dir.path{a}{2}='/media/nas4/ProjetEmbReact/Mouse1095/20200714/';
    load([Dir.path{a}{2},'ExpeInfo.mat']),Dir.ExpeInfo{a}{2}=ExpeInfo;
    Dir.path{a}{3}='/media/nas4/ProjetEmbReact/Mouse1095/20200723/';
    load([Dir.path{a}{3},'ExpeInfo.mat']),Dir.ExpeInfo{a}{3}=ExpeInfo;

        
elseif  strcmpi(experiment,'LPS_Exp1_Sal')
    
    a=a+1; Dir.path{a}{1}='/media/DataMOBs/ProjetLPS/Mouse051/20130220/BULB-Mouse-51-20022013/';
    a=a+1; Dir.path{a}{1}='/media/DataMOBs/ProjetLPS/Mouse055/20130402/BULB-Mouse-55-56-02042013/';
    a=a+1; Dir.path{a}{1}='/media/DataMOBs/ProjetLPS/Mouse056/20130409/BULB-Mouse-56-09042013/';
    a=a+1; Dir.path{a}{1}='/media/DataMOBs/ProjetLPS/Mouse063/20130424/BULB-Mouse-63-24042013/';
    a=a+1; Dir.path{a}{1}='/media/DataMOBsRAIDN/ProjetLPS/Mouse124/LPSD2/LPSD2-Mouse-124-01042014/';
    
elseif  strcmpi(experiment,'LPS_Exp1_LPS')
    
    a=a+1; Dir.path{a}{1}='/media/DataMOBs/ProjetLPS/Mouse051/20130221/BULB-Mouse-51-21022013/';
    a=a+1; Dir.path{a}{1}='/media/DataMOBs/ProjetLPS/Mouse055/20130403/BULB-Mouse-55-03042013/';
    a=a+1; Dir.path{a}{1}='/media/DataMOBs/ProjetLPS/Mouse056/20130410/BULB-Mouse-56-10042013/';
    a=a+1; Dir.path{a}{1}='/media/DataMOBs/ProjetLPS/Mouse063/20130425/BULB-Mouse-63-25042013/';
    a=a+1; Dir.path{a}{1}='/media/DataMOBsRAIDN/ProjetLPS/Mouse124/LPSD3/LPSD3-Mouse-124-02042014/';
    
elseif  strcmpi(experiment,'LPS_Exp1_LPS24h')
    
    a=a+1; Dir.path{a}{1}='/media/DataMOBs/ProjetLPS/Mouse051/20130222/BULB-Mouse-51-22022013/';
    a=a+1; Dir.path{a}{1}='/media/DataMOBs/ProjetLPS/Mouse055/20130404/BULB-Mouse-55-04042013/';
    
    a=a+1; Dir.path{a}{1}='/media/DataMOBs/ProjetLPS/Mouse063/20130426/BULB-Mouse-63-26042013/';
    a=a+1; Dir.path{a}{1}='/media/DataMOBsRAIDN/ProjetLPS/Mouse124/LPSD4/LPSD4-Mouse-124-03042014/';
    
elseif  strcmpi(experiment,'LPS_Exp1_Day48h')
    
    a=a+1; Dir.path{a}{1}='/media/DataMOBs/ProjetLPS/Mouse051/20130223/BULB-Mouse-51-23022013/';
    a=a+1; Dir.path{a}{1}='/media/DataMOBs/ProjetLPS/Mouse055/20130405/BULB-Mouse-55-05042013/';
    a=a+1; Dir.path{a}{1}='/media/DataMOBs/ProjetLPS/Mouse056/20130412/BULB-Mouse-56-12042013/';
    a=a+1; Dir.path{a}{1}='/media/DataMOBs/ProjetLPS/Mouse063/20130427/BULB-Mouse-63-27042013/';
    a=a+1; Dir.path{a}{1}='/media/DataMOBsRAIDN/ProjetLPS/Mouse124/LPSD5/LPSD5-Mouse-124-04042014/';
    
end