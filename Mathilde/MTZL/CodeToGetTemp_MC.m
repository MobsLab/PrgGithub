clear all
FolderName{1} = '/media/DataMOBsRAIDN/ProjectEmbReact/Mouse740/25052018/ProjectEmbReact_M740_25052018_SleepPost_PostDrug/raw/FEAR-Mouse-740-25052018-SleepSession_03/'
FolderName{2} = '/media/DataMOBsRAIDN/ProjectEmbReact/Mouse740/25052018/ProjectEmbReact_M740_25052018_SleepPost_PreDrug/raw/FEAR-Mouse-740-25052018-SleepSession_02/'
FolderName{3} = '/media/DataMOBsRAIDN/ProjectEmbReact/Mouse740/25052018/ProjectEmbReact_M740_25052018_SleepPre_PreDrug/raw/FEAR-Mouse-740-25052018-SleepSession_00/'

% MiceNumber = [756 757 758 759 761 762 763 764 765];
MiceNumber = [740];

for mousenum = 2 : 3%length(MiceNumber)
        mousenum
        %cd(['/Users/mobs-user/Documents/DataMathilde/FEAR-Mouse-',num2str(MiceNumber(i)),'-12062018-Hab_00'])
        %     cd(['/home/mobs/Dropbox/Mobs_member/MathildeChouvaeff/DataMathilde/PreInjection/FEAR-Mouse-',num2str(MiceNumber(mousenum)),'-12062018-Hab_00'])
        
        cd(FolderName{mousenum})
       
        
     
        %     OBJ = VideoReader('F12062018-0000.avi');
        %     OBJ = VideoReader('F29052018-0000.avi');
        OBJ = VideoReader('F25052018-0000.avi');
        
        i=1;
        while hasFrame(OBJ)
            vidFrame = readFrame(OBJ);
            vidFrame = squeeze(vidFrame(:,:,1));
            MouseTemp(i) = max(max(vidFrame));
            i=i+1;
        end
        
        save('TemperatureMouseAutomatic.mat','MouseTemp')
        clear MouseTemp vidFrame OBJ
    end



for i = 1 : length(MiceNumber)
    i
    %cd(['/Users/mobs-user/Documents/DataMathilde/FEAR-Mouse-',num2str(MiceNumber(i)),'-12062018-Hab_00'])
%     cd(['/home/mobs/Dropbox/Mobs_member/MathildeChouvaeff/DataMathilde/PreInjection/FEAR-Mouse-',num2str(MiceNumber(i)),'-12062018-Hab_00'])
        cd(FolderName{mousenum})
        
    load('TemperatureMouseAutomatic.mat','MouseTemp')
    load('behavResources.mat','Vtsd')
    subplot(211)
    plot(runmean(double(MouseTemp(1:end)),1)), hold on
    subplot(212)
    plot(runmean(Data(Vtsd),2))
    hold on
end
