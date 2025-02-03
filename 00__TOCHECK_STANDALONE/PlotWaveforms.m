function wfo=PlotWaveforms(W,n,Epoch,plo)

%wfo=PlotWaveforms(W,n,Epoch,plo)

try
    plo;
catch
    plo=1;
end

wfo=W{n};
load SpikeData cellnames

try
    
    Epoch;
    load SpikeData
    id=[];
    rg=Range(S{n});
    for i=1:length(Start(Epoch))
        st=Start(subset(Epoch,i));
        en=End(subset(Epoch,i));
        idx=find(rg>st&rg<en);
        id=[id;idx];
    end
    
    wfo=wfo(id,:,:);
        
end

if length(wfo)<500
    pas=2;
elseif length(wfo)<5000
    pas=10;
else
    pas=100;
end


if plo
    
    figure('color',[1 1 1])
    a=1;
    for i=1:size(wfo,2)
        subplot(size(wfo,2),2,a),hold on
        plot(mean(squeeze(wfo(:,i,:))),'k','linewidth',2)
        plot(mean(squeeze(wfo(:,i,:)))-std((squeeze(wfo(:,i,:)))),'color',[0.7 0.7 0.7])
        plot(mean(squeeze(wfo(:,i,:)))+std(squeeze(wfo(:,i,:))),'color',[0.7 0.7 0.7])

        subplot(size(wfo,2),2,a+1),hold on
        plot((squeeze(wfo(1:pas:end,i,:)))','k')

        a=a+2;
    end

    subplot(size(wfo,2),2,1)
    title(['Number of spikes: ',num2str(length(wfo))])

    subplot(size(wfo,2),2,2)
    title(cellnames{n})

end