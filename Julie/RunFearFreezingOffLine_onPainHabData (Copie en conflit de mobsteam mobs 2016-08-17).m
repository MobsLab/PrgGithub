res=pwd;
%list=dir('/media/DataMobs31/PAIN_DATA');
list=dir(res);

for i=1:length(list)
     if list(i).isdir~=1&list(i).name(1)~='.' &list(i).name(1:4)=='Pain'  % if the folder is indeed a mouse name folder
%         load('Inputs_for_Hab2Data_22souris.mat');
        load('Inputs_for_PainData_22souris.mat');
        %load('Inputs_for_PainData.mat');
        Ffile=list(i).name;
        save Behavior.mat BW_threshold2 smaller_object_size2 shape_ratio2 imageRef name_folder thtps_immob SmoothFact th_immob Ratio_IMAonREAL mask PosMat Movtsd FreezeEpoch Freeze 
        save Behavior.mat Ffile -Append

        FearFreezingOfflineVideo
        mkdir([ res '/' list(i).name(end-7:end-4) ])
        movefile('Behavior.mat',[res '/' list(i).name(end-7:end-4) '/'])
        
     end
end
