
Dir{1}=PathForExperiments_Opto_MC('PFC_Control_20Hz');
Dir{2}=PathForExperiments_Opto_MC('PFC_Stim_20Hz');
% Dir{1}=PathForExperiments_DREADD_MC('1Inj2mg_Nacl');
% Dir{2}=PathForExperiments_DREADD_MC('1Inj2mg_CNO');



windowsize=400; %in ms

number=1;
for i=1:length(Dir{1}.path)
    cd(Dir{1}.path{i}{1});
    
    [M,T] = PlotWaveformRipples_MC(0);
    dataRippCtrl{i}=T;
    stdErrCtrl{i}=M(:,4);
    
    for ii=1:length(dataRippCtrl)
        AvDataRippCtrl(ii,:)=nanmean(dataRippCtrl{ii}(:,:),1);
        AvStdErrCtrl(ii,:)=nanmean(stdErrCtrl{ii}(:,:),2);
        
    end
    
%     MouseId(number) = Dir{1}.nMice{i} ;
%     number=number+1;
end


numberOpto=1;
for j=1:length(Dir{2}.path)
    cd(Dir{2}.path{j}{1});
    
    [M,T] = PlotWaveformRipples_MC(0);
    dataRippOpto{j}=T;
    stdErrOpto{j}=M(:,4);
    
    for jj=1:length(dataRippOpto)
        AvDataRippOpto(jj,:)=nanmean(dataRippOpto{jj}(:,:),1);
        
        AvStdErrOpto(jj,:)=nanmean(stdErrOpto{jj}(:,:),2);
    end
    
%     MouseId(numberOpto) = Dir{2}.nMice{j} ;
%     numberOpto=numberOpto+1;
end


%%
figure, subplot(121), shadedErrorBar(M(:,1),mean(AvDataRippCtrl),mean(AvStdErrCtrl,1),'-k',1);
% ylim([-1500 1000])
xlim([-0.05 0.2])
line([0 0], ylim,'color','k','linestyle',':')
title('ctrl n = 4')
subplot(122), shadedErrorBar(M(:,1),mean(AvDataRippOpto),mean(AvStdErrOpto,1),'-k',1);
% ylim([-1500 1000])
xlim([-0.05 0.2])
line([0 0], ylim,'color','k','linestyle',':')
title('opto n = 4')
