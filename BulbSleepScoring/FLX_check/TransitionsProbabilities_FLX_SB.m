clear all
Mice = [666,667,668,669];
for mm=1:4
    FileName = {'/media/DataMOBsRAIDN/ProjectEmbReact/FLX_Ctrl_exp/MouseX/20180221_Day',
        '/media/DataMOBsRAIDN/ProjectEmbReact/FLX_Ctrl_exp/MouseX/20180221_Night',
        '/media/DataMOBsRAIDN/ProjectEmbReact/FLX_Ctrl_exp/MouseX/20180222_Day_saline',
        '/media/DataMOBsRAIDN/ProjectEmbReact/FLX_Ctrl_exp/MouseX/20180222_Night_saline',
        '/media/DataMOBsRAIDN/ProjectEmbReact/FLX_Ctrl_exp/MouseX/20180223_Day_fluoxetine',
        '/media/DataMOBsRAIDN/ProjectEmbReact/FLX_Ctrl_exp/MouseX/20180223_Night_fluoxetine',
        '/media/DataMOBsRAIDN/ProjectEmbReact/FLX_Ctrl_exp/MouseX/20180224_Day_fluoxetine48H',
        '/media/DataMOBsRAIDN/ProjectEmbReact/FLX_Ctrl_exp/MouseX/20180224_Night_fluoxetine48H'};
    FileName = strrep(FileName,'MouseX',['Mouse',num2str(Mice(mm))]);
    
    
    for f = 1:length(FileName)
        cd(FileName{f})
        load('StateEpochSB.mat','REMEpoch','SWSEpoch','Wake')
        Sleep = or(SWSEpoch,REMEpoch);
        
        [aft_cell_SR,bef_cell_SR]=transEpoch(SWSEpoch,REMEpoch);
        [aft_cell_SW,bef_cell_SW]=transEpoch(SWSEpoch,Wake);
        [aft_cell_RW,bef_cell_RW]=transEpoch(REMEpoch,Wake);
        %     [aft_cell,bef_cell]=transEpoch(SWSEpoch,Wake);
% %Start(aft_cell{1,2}) ---> beginning of all SWS that is followed by Wake
% % Start(bef_cell{1,2}) ---> beginning of all SWS that is preceded by Wake
% %Start(bef_cell{2,1})---> beginning of all Wake  that is preceded by SWS
% %Start(aft_cell{2,1})---> beginning of all Wake  that is followed by SWS


      
        TotSWSsteps = floor(sum(Stop(SWSEpoch,'s') - Start(SWSEpoch,'s')));
        SWSToRem = length(Start(aft_cell_SR{1,2}));
        SWSToWake = length(Start(aft_cell_SW{1,2}));
        
        P_S_S(f,mm) = (TotSWSsteps-SWSToRem-SWSToWake) / TotSWSsteps;
        P_S_R(f,mm) = (SWSToRem) / TotSWSsteps;
        P_S_W(f,mm) = (SWSToWake) / TotSWSsteps;
        
        TotREMsteps = floor(sum(Stop(REMEpoch,'s') - Start(REMEpoch,'s')));
        REMToSWS = length(Start(aft_cell_SR{2,1}));
        REMToWake = length(Start(aft_cell_RW{1,2}));
        
        P_R_R(f,mm) = (TotREMsteps-REMToSWS-REMToWake) / TotREMsteps;
        P_R_S(f,mm) = (REMToSWS) / TotREMsteps;
        P_R_W(f,mm) = (REMToWake) / TotREMsteps;
        
        TotWakeSteps = floor(sum(Stop(Wake,'s') - Start(Wake,'s')));
        WakeToSWS = length(Start(aft_cell_SW{2,1}));
        WakeToRem = length(Start(aft_cell_RW{2,1}));
        
        P_W_W(f,mm)= (TotWakeSteps-WakeToSWS-WakeToRem) / TotWakeSteps;
        P_W_S(f,mm) = (WakeToSWS) / TotWakeSteps;
        P_W_R(f,mm) = (WakeToRem) / TotWakeSteps;

        
    end
    
end
clf
subplot(3,3,1)
PlotErrorBarN_KJ([P_W_W(3,:);P_W_W(5,:)]','newfig',0)
subplot(3,3,2)
PlotErrorBarN_KJ([P_W_R(3,:);P_W_R(5,:)]','newfig',0)
subplot(3,3,3)
PlotErrorBarN_KJ([P_W_S(3,:);P_W_S(5,:)]','newfig',0)

subplot(3,3,4)
PlotErrorBarN_KJ([P_S_S(3,:);P_S_S(5,:)]','newfig',0)
subplot(3,3,5)
PlotErrorBarN_KJ([P_S_R(3,:);P_S_R(5,:)]','newfig',0)
subplot(3,3,6)
PlotErrorBarN_KJ([P_S_W(3,:);P_S_W(5,:)]','newfig',0)

subplot(3,3,7)
PlotErrorBarN_KJ([P_R_R(3,:);P_R_R(5,:)]','newfig',0)
subplot(3,3,8)
PlotErrorBarN_KJ([P_R_S(3,:);P_R_S(5,:)]','newfig',0)
subplot(3,3,9)
PlotErrorBarN_KJ([P_R_W(3,:);P_R_W(5,:)]','newfig',0)
