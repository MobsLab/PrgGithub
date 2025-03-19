close all
RootName='/media/MOBSDataRotation/ManipPrefPlace/RoundEnvironment/Mouse';
MiceNum=[261,262];

for mm=1:2
    figure
     for c=1:3
        load([RootName,num2str(MiceNum(mm)),'/Mouse',num2str(MiceNum(mm)),'-Hab',num2str(c),'/information_experiment1.mat'])
        subplot(3,4,c)
        %                 imagesc(RGBoccupation(:,:,1)')
        plot(PosMat(2,:)/10,PosMat(1,:)/10);hold on,
        xlim([0 25]),ylim([10 30])
    end
    for c=1:4
        load([RootName,num2str(MiceNum(mm)),'/Mouse',num2str(MiceNum(mm)),'-Cond',num2str(c),'/information_experiment1.mat'])
        subplot(3,4,c+4)
        %                 imagesc(RGBoccupation(:,:,1)')
        plot(PosMat(2,:)/10,PosMat(1,:)/10);hold on,
        plot(PosMat(2,PosMat(4,:)==1)/10,PosMat(1,PosMat(4,:)==1)/10,'*r');
        xlim([0 25]),ylim([10 30])
    end
    for c=1:4
        load([RootName,num2str(MiceNum(mm)),'/Mouse',num2str(MiceNum(mm)),'-ProbeTest',num2str(c),'/information_experiment1.mat'])
        subplot(3,4,c+8)
%                         imagesc(RGBoccupation(:,:,1)'), hold on,
        plot(PosMat(2,:)/10,PosMat(1,:)/10);
        xlim([0 25]),ylim([10 30])
    end
end

for mm=1:2
    figure
    for c=1:4
        load([RootName,num2str(MiceNum(mm)),'/Mouse',num2str(MiceNum(mm)),'-ProbeTest',num2str(c),'/information_experiment1.mat'])
        lg=length(PosMat);
        for t=1:3
        subplot(3,4,4*(t-1)+c)
        plot(PosMat(2,1+floor(lg/3)*(t-1):floor(lg/3)*t)/10,PosMat(1,1+floor(lg/3)*(t-1):floor(lg/3)*t)/10);
        xlim([0 25]),ylim([10 30])
        if t==1
        title(['Sess',num2str(c)])
        end

        end
        
    end
    
end
