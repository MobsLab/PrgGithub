channelstoAnalyse={'dHPC_rip','PFCx_deep','Bulb_deep','MoCx_deep','PaCx_deep'};
clear RocVal
for m=1
    if m==1
        load('/media/DataMOBsRAID/ProjetAversion/DATA-Fear/Mouse244/20150506-EXT-24h-envC/behavResources.mat')
        cd '/media/DataMOBsRAID/ProjetAversion/DATA-Fear/Mouse244/20150506-EXT-24h-envC/'
    else
        % only one freezing period...
        load('/media/DataMOBsRAID/ProjetAversion/DATA-Fear/Mouse243/20150506-EXT-24h-envC/behavResources.mat')
        cd '/media/DataMOBsRAID/ProjetAversion/DATA-Fear/Mouse243/20150506-EXT-24h-envC/'
    end
cols=jet(9);
startvals=[2:10];
envals=[2:10]+2;
for slidwin=1:length(startvals)
    slidwin
    for ch=1:length(channelstoAnalyse)
        ch
        load(['ChannelsToAnalyse/' channelstoAnalyse{ch}],'channel');
        load(['LFPData/LFP',num2str(channel),'.mat'])
        TotEpoch=intervalSet(0,max(Range(LFP)));
        FilDelta=FilterLFP(LFP,[startvals(slidwin) envals(slidwin)],1024);
        HilDelta=hilbert(Data(FilDelta));
        H=abs(HilDelta);
        Htsd=tsd(Range(LFP),H);
        NoFreezeEpoch=TotEpoch-FreezeEpoch;
        begin=Start(FreezeEpoch);
        endin=Stop(FreezeEpoch);
        Fr{ch,1}=zeros(1,1);
        index=1;
        for ff=1:length(begin)
            dur=endin(ff)-begin(ff);
            numbins=round(dur/(2*1E4));
            epdur=(dur/1E4)/numbins;
            for nn=1:numbins
                startcounting=begin(ff)+(nn-1)*dur/numbins;
                stopcounting=begin(ff)+nn*dur/numbins;
                Fr{ch,1}(index,1)=mean(Data(Restrict(Htsd,intervalSet(startcounting,stopcounting))));
                index=index+1;
            end
        end
        
        begin=Start(NoFreezeEpoch);
        endin=Stop(NoFreezeEpoch);
        Fr{ch,2}=zeros(1,1);
        index=1;
        for ff=1:length(begin)
            dur=endin(ff)-begin(ff);
            numbins=round(dur/(2*1E4));
            epdur=(dur/1E4)/numbins;
            for nn=1:numbins
                startcounting=begin(ff)+(nn-1)*dur/numbins;
                stopcounting=begin(ff)+nn*dur/numbins;
                Fr{ch,2}(index,1)=mean(Data(Restrict(Htsd,intervalSet(startcounting,stopcounting))));
                index=index+1;
            end
        end
        
        
        alpha=[];
        beta=[];
        minval=min([Fr{ch,2};Fr{ch,1}]);
        maxval=max([Fr{ch,2};Fr{ch,1}]);
        delval=(maxval-minval)/20;
        for z=[min([Fr{ch,2};Fr{ch,1}])-delval:delval:max([Fr{ch,2};Fr{ch,1}])+delval]
            alpha=[alpha,sum(Fr{ch,2}>z)/length(Fr{ch,2})];
            beta=[beta,sum(Fr{ch,1}>z)/length(Fr{ch,1})];
        end
        plot(alpha,beta,'color',cols(ch,:)), hold on
        RocVal{m}(ch,slidwin)=sum(beta-alpha)/length(beta)+0.5;
        clear Fr alpha beat Htsd
    end
end
end

save('/home/vador/Bureau/RocValsGMice.mat','RocVal')


figure
plot(startvals+1,RocVal{1}','linewidth',2)
ylabel('ROC value')
xlabel('freq window')
legend(channelstoAnalyse)
