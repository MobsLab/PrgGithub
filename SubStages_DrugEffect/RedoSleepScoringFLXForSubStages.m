clear all
Mice = [666,667,668,669];
for mm=2:4
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
        SleepScoring_Accelero_OBgamma_AddToFlx_SB('recompute',1,'PlotFigure',0)
    end
end