clear all, close all
channelstoAnalyse={'dHPC_rip','PFCx_deep','Bulb_deep'}
cols=jet(9);
startvals=[1:0.5:20];
envals=[1:0.5:20]+2;
%clear RocVal
for m=1:9
    if m==1
        load('/media/DataMOBsRAID/ProjetAversion/DATA-Fear/Mouse247/20150326-EXT-24h-envC/behavResources.mat')
        cd('/media/DataMOBsRAID/ProjetAversion/DATA-Fear/Mouse247/20150326-EXT-24h-envC/')
        load('/media/DataMOBsRAID/ProjetAversion/DATA-Fear/Mouse247/20150326-EXT-24h-envC/StateEpoch.mat')
    elseif m==2
        load('/media/DataMOBsRAID/ProjetAversion/DATA-Fear/Mouse249/20150506-EXT-24h-envC/behavResources.mat')
        cd '/media/DataMOBsRAID/ProjetAversion/DATA-Fear/Mouse249/20150506-EXT-24h-envC/'
        load('/media/DataMOBsRAID/ProjetAversion/DATA-Fear/Mouse249/20150506-EXT-24h-envC/StateEpoch.mat')
    elseif m==3
        load('/media/DataMOBsRAID/ProjetAversion/DATA-Fear/Mouse250/20150506-EXT-24h-envC/behavResources.mat')
        cd '/media/DataMOBsRAID/ProjetAversion/DATA-Fear/Mouse250/20150506-EXT-24h-envC/'
        load('/media/DataMOBsRAID/ProjetAversion/DATA-Fear/Mouse250/20150506-EXT-24h-envC/StateEpoch.mat')
    elseif m==4
        load('/media/DataMOBsRAID/ProjetAversion/DATA-Fear/Mouse253/20150703-EXT-24h-envC/FEAR-Mouse-253-03072015/behavResources.mat')
        cd('/media/DataMOBsRAID/ProjetAversion/DATA-Fear/Mouse253/20150703-EXT-24h-envC/FEAR-Mouse-253-03072015/')
        load('/media/DataMOBsRAID/ProjetAversion/DATA-Fear/Mouse253/20150703-EXT-24h-envC/FEAR-Mouse-253-03072015/StateEpoch.mat')
    elseif m==5
        load('/media/DataMOBsRAID/ProjetAstro/Mouse241/20150417/EXTplethysmo/BULB-Mouse-241-17042015/behavResources.mat')
        cd('/media/DataMOBsRAID/ProjetAstro/Mouse241/20150417/EXTplethysmo/BULB-Mouse-241-17042015/')
        load('/media/DataMOBsRAID/ProjetAstro/Mouse241/20150417/EXTplethysmo/BULB-Mouse-241-17042015/StateEpoch.mat')
    elseif m==6
        load('/media/DataMOBsRAID/ProjetAstro/Mouse242/20150508/EXTplethy/BULB-Mouse-242-08052015/behavResources.mat')
        cd('/media/DataMOBsRAID/ProjetAstro/Mouse242/20150508/EXTplethy/BULB-Mouse-242-08052015/')
        load('/media/DataMOBsRAID/ProjetAstro/Mouse242/20150508/EXTplethy/BULB-Mouse-242-08052015/StateEpoch.mat')
    elseif m==7
        load('/media/DataMOBsRAID/ProjetAversion/DATA-Fear/Mouse254/20150703-EXT-24h-envC/FEAR-Mouse-254-03072015/behavResources.mat')
        cd('/media/DataMOBsRAID/ProjetAversion/DATA-Fear/Mouse254/20150703-EXT-24h-envC/FEAR-Mouse-254-03072015/')
        load('/media/DataMOBsRAID/ProjetAversion/DATA-Fear/Mouse254/20150703-EXT-24h-envC/FEAR-Mouse-254-03072015/StateEpoch.mat')
    elseif m==8
        load('/media/DataMOBsRAID/ProjetAversion/DATA-Fear/Mouse248/20150326-EXT-24h-envC/behavResources.mat')
        cd '/media/DataMOBsRAID/ProjetAversion/DATA-Fear/Mouse248/20150326-EXT-24h-envC/'
        load('/media/DataMOBsRAID/ProjetAversion/DATA-Fear/Mouse248/20150326-EXT-24h-envC/StateEpoch.mat')
    elseif m==9
        load('/media/DataMOBsRAID/ProjetAversion/DATA-Fear/Mouse230/20150212-EXT-24h-envC/behavResources.mat')
        cd('/media/DataMOBsRAID/ProjetAversion/DATA-Fear/Mouse230/20150212-EXT-24h-envC/')
        load('/media/DataMOBsRAID/ProjetAversion/DATA-Fear/Mouse230/20150212-EXT-24h-envC/StateEpoch.mat')
        FreezeEpoch=And(FreezeEpoch,intervalSet(0,950*1e4));
    end
    clear Fr
    for slidwin=1:length(startvals)
        slidwin
        for ch=1:length(channelstoAnalyse)
            ch
            if exist(['ChannelsToAnalyse/' channelstoAnalyse{ch} '.mat'])>0
                load(['ChannelsToAnalyse/' channelstoAnalyse{ch} '.mat'],'channel');
                if not(isempty(channel))
                    
                    load(['LFPData/LFP',num2str(channel),'.mat'])
                    if m==9
                        TotEpoch=intervalSet(0,950*1e4)-NoiseEpoch-GndNoiseEpoch;
                    else
                        TotEpoch=intervalSet(0,max(Range(LFP)))-NoiseEpoch-GndNoiseEpoch;
                    end
                    FilDelta=FilterLFP(LFP,[startvals(slidwin) envals(slidwin)],1024);
                    HilDelta=hilbert(Data(FilDelta));
                    H=abs(HilDelta);
                    Htsd=tsd(Range(LFP),H);
                    FreezeEpoch=FreezeEpoch-NoiseEpoch-GndNoiseEpoch-WeirdNoiseEpoch;
                    NoFreezeEpoch=TotEpoch-FreezeEpoch;
                    NoFreezeEpoch=NoFreezeEpoch-NoiseEpoch-GndNoiseEpoch-WeirdNoiseEpoch;
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
                    %plot(alpha,beta,'color',cols(ch,:)), hold on
                    RocVal{m}(ch,slidwin)=sum(beta-alpha)/length(beta)+0.5;
                    clear Fr alpha beat Htsd
                else
                    disp('bou')
                    RocVal{m}(ch,slidwin)=NaN;
                    
                end
            end
        end
    end
end

load('/home/vador/Bureau/RocValsAllMice.mat','RocVal')
Mice=[247,249,250,253,241,242,254,248,230];
Grp={'OBx','OBx','OBx','Ctrl','Ctrl','Ctrl','Ctrl','Ctrl','OBx'};
figure
for m=1:9
    try
       if m==1
        load('/media/DataMOBsRAID/ProjetAversion/DATA-Fear/Mouse247/20150326-EXT-24h-envC/behavResources.mat')
        cd('/media/DataMOBsRAID/ProjetAversion/DATA-Fear/Mouse247/20150326-EXT-24h-envC/')
        load('/media/DataMOBsRAID/ProjetAversion/DATA-Fear/Mouse247/20150326-EXT-24h-envC/StateEpoch.mat')
    elseif m==2
        load('/media/DataMOBsRAID/ProjetAversion/DATA-Fear/Mouse249/20150506-EXT-24h-envC/behavResources.mat')
        cd '/media/DataMOBsRAID/ProjetAversion/DATA-Fear/Mouse249/20150506-EXT-24h-envC/'
        load('/media/DataMOBsRAID/ProjetAversion/DATA-Fear/Mouse249/20150506-EXT-24h-envC/StateEpoch.mat')
    elseif m==3
        load('/media/DataMOBsRAID/ProjetAversion/DATA-Fear/Mouse250/20150506-EXT-24h-envC/behavResources.mat')
        cd '/media/DataMOBsRAID/ProjetAversion/DATA-Fear/Mouse250/20150506-EXT-24h-envC/'
        load('/media/DataMOBsRAID/ProjetAversion/DATA-Fear/Mouse250/20150506-EXT-24h-envC/StateEpoch.mat')
    elseif m==4
        load('/media/DataMOBsRAID/ProjetAversion/DATA-Fear/Mouse253/20150703-EXT-24h-envC/FEAR-Mouse-253-03072015/behavResources.mat')
        cd('/media/DataMOBsRAID/ProjetAversion/DATA-Fear/Mouse253/20150703-EXT-24h-envC/FEAR-Mouse-253-03072015/')
        load('/media/DataMOBsRAID/ProjetAversion/DATA-Fear/Mouse253/20150703-EXT-24h-envC/FEAR-Mouse-253-03072015/StateEpoch.mat')
    elseif m==5
        load('/media/DataMOBsRAID/ProjetAstro/Mouse241/20150417/EXTplethysmo/BULB-Mouse-241-17042015/behavResources.mat')
        cd('/media/DataMOBsRAID/ProjetAstro/Mouse241/20150417/EXTplethysmo/BULB-Mouse-241-17042015/')
        load('/media/DataMOBsRAID/ProjetAstro/Mouse241/20150417/EXTplethysmo/BULB-Mouse-241-17042015/StateEpoch.mat')
    elseif m==6
        load('/media/DataMOBsRAID/ProjetAstro/Mouse242/20150508/EXTplethy/BULB-Mouse-242-08052015/behavResources.mat')
        cd('/media/DataMOBsRAID/ProjetAstro/Mouse242/20150508/EXTplethy/BULB-Mouse-242-08052015/')
        load('/media/DataMOBsRAID/ProjetAstro/Mouse242/20150508/EXTplethy/BULB-Mouse-242-08052015/StateEpoch.mat')
    elseif m==7
        load('/media/DataMOBsRAID/ProjetAversion/DATA-Fear/Mouse254/20150703-EXT-24h-envC/FEAR-Mouse-254-03072015/behavResources.mat')
        cd('/media/DataMOBsRAID/ProjetAversion/DATA-Fear/Mouse254/20150703-EXT-24h-envC/FEAR-Mouse-254-03072015/')
        load('/media/DataMOBsRAID/ProjetAversion/DATA-Fear/Mouse254/20150703-EXT-24h-envC/FEAR-Mouse-254-03072015/StateEpoch.mat')
    elseif m==8
        load('/media/DataMOBsRAID/ProjetAversion/DATA-Fear/Mouse248/20150326-EXT-24h-envC/behavResources.mat')
        cd '/media/DataMOBsRAID/ProjetAversion/DATA-Fear/Mouse248/20150326-EXT-24h-envC/'
        load('/media/DataMOBsRAID/ProjetAversion/DATA-Fear/Mouse248/20150326-EXT-24h-envC/StateEpoch.mat')
    elseif m==9
        load('/media/DataMOBsRAID/ProjetAversion/DATA-Fear/Mouse230/20150212-EXT-24h-envC/behavResources.mat')
        cd('/media/DataMOBsRAID/ProjetAversion/DATA-Fear/Mouse230/20150212-EXT-24h-envC/')
        load('/media/DataMOBsRAID/ProjetAversion/DATA-Fear/Mouse230/20150212-EXT-24h-envC/StateEpoch.mat')
        FreezeEpoch=And(FreezeEpoch,intervalSet(0,950*1e4));
    end
        subplot(3,3,m)
        try,plot(startvals+1,RocVal{m}(1,:),'c','linewidth',2), hold on, end
        try,plot(startvals+1,RocVal{m}(2,:),'r','linewidth',2), hold on, end
        try,plot(startvals+1,RocVal{m}(3,:),'b','linewidth',2), hold on, end
        ylabel('ROC value')
        xlabel('freq window')
        title(strcat(num2str(Mice(m)),'  ',Grp{m}))
        plot(startvals,0.5*ones(1,length(startvals)),'k')
        if exist('SpectrumDataL')>0
            if exist(['ChannelsToAnalyse/' channelstoAnalyse{2} '.mat'])>0
            load(['ChannelsToAnalyse/' channelstoAnalyse{2} '.mat'],'channel');
            if not(isempty(channel))
                load(['SpectrumDataL/Spectrum',num2str(channel),'.mat'])
                Sptsd=tsd(t*1e4,Sp);
                Spectr=(mean(Data(Restrict(Sptsd,FreezeEpoch-NoiseEpoch-GndNoiseEpoch-WeirdNoiseEpoch))));
                TotEpoch=intervalSet(0,max(Range(LFP)))-NoiseEpoch-GndNoiseEpoch-WeirdNoiseEpoch;
                NoFreezeEpoch=TotEpoch-FreezeEpoch;
                Spectr2=(mean(Data(Restrict(Sptsd,NoFreezeEpoch-NoiseEpoch-GndNoiseEpoch-WeirdNoiseEpoch))));                %Spectr=10*log10(Spectr);
                Spectr=f.*Spectr;
                Spectr2=f.*Spectr2;
                Spectr=0.85*Spectr/max(Spectr);
                Spectr2=0.85*Spectr2/max(Spectr2);
            end
            end
        end
        plot(f,Spectr,'k')
        plot(f,Spectr2,'--k')        
        xlim([0 11])
        ylim([0.2 0.9])
    end
end

BBXdat=[];
for m=[1,3,9]
BBXdat=[BBXdat;RocVal{m}(2,:)];
end
CTLdat=[];
for m=[4:8]
CTLdat=[CTLdat;RocVal{m}(2,:)];
end
g=shadedErrorBar(startvals+1,mean(BBXdat),[std(BBXdat);std(BBXdat)] )


load('/media/DataMOBsRAID/ProjetAversion/DATA-Fear/Mouse248/20150326-EXT-24h-envC/LFPData/LFP10.mat')
FilDelta=FilterLFP(LFP,[3 6],1024);
HilDelta=hilbert(Data(FilDelta));
load('/media/DataMOBsRAID/ProjetAversion/DATA-Fear/Mouse248/20150326-EXT-24h-envC/LFPData/LFP17.mat')
FilTheta=FilterLFP(LFP,[6 12],1024);
HilTheta=hilbert(Data(FilTheta));
PhThet=atan2(imag(HilTheta),real(HilTheta));
PhDel=atan2(imag(HilDelta),real(HilDelta));
h=hist2d(PhThet,PhDel,[-3.05:0.1:3.05],[-3.05:0.1:3.05]);



