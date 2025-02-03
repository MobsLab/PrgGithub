%FigureBilanComplexSpikeRipples


try 
   cd /media/HardBackUp/DataSauvegarde/Mouse029/20120203/ICSS-Mouse-29-03022012
            load SpikeData
            load behavResources
            load Waveforms
            load Celltypes
           
    load FigureBilanComplexSpikeRipples
    Ccros;
catch

            cd /media/HardBackUp/DataSauvegarde/Mouse029/20120203/ICSS-Mouse-29-03022012
             load SpikeData
            load behavResources
            load Waveforms
            MFBburst=1; num=1; choicTh=5;ControlStimMFBRipplesSleep  



            %       
            % cd /media/HardBackUp/DataSauvegarde/Mouse029/20120207
            % load SpikeData
            % load behavResources
            % load Waveforms
            % MFBburst=1; num=1; choicTh=5; ControlStimMFBRipplesSleep
            %         
            % cd /media/HardBackUp/DataSauvegarde/Mouse026/20120109/ICSS-Mouse-26-09012011
            % load SpikeData
            % load behavResources
            % load Waveforms
            % MFBburst=1; num=1; choicTh=5;ControlStimMFBRipplesSleep
            % 
            % cd /media/HardBackUp/DataSauvegarde/Mouse035/20120515/ICSS-Mouse-35-15052012
            % load SpikeData
            % load behavResources
            % load Waveforms
            % MFBburst=1; num=1; choicTh=5; ControlStimMFBRipplesSleep
            %            
            % cd /media/HardBackUp/DataSauvegarde/Mouse042/20120801/ICSS-Mouse-42-01082012
            % load SpikeData
            % load behavResources
            % load Waveforms
            % MFBburst=1;
            % num=4; 
            % choicTh=4;ControlStimMFBRipplesSleep
            %         
            %         
            %------------------------------------------------------------      


              try
                  load nchannelSpk nchannelSpk      
                  nchannelSpk;
              end


            for numN=1:length(S)

            try    
            close all, [Res1{numN},Res2{numN},Ccros{numN},Bcros{numN},nchannelSpk,JP1{numN},JP2{numN},dt]=JPETHComplexSpikesRipples(S,W,cellnames,numN,Ripples,SleepEpoch,nchannelSpk);
            catch
            close all, [Res1{numN},Res2{numN},Ccros{numN},Bcros{numN},nchannelSpk,JP1{numN},JP2{numN},dt]=JPETHComplexSpikesRipples(S,W,cellnames,numN,Ripples,SleepEpoch);    
            end

            end


            save nchannelSpk nchannelSpk


end




Rc=[];for i=1:length(S)
Rc=[Rc,Ccros{i}];
end
figure('color',[1 1 1]), bar(Bcros{1},mean(zscore(Rc)'-min(mean(zscore(Rc)'))),1,'k')
figure('color',[1 1 1]), imagesc(zscore(Rc)')


R1=[];R2=[];for i=1:2:length(S)
R1=[R1,Res1{i}(:,2)];
R2=[R2,Res2{i}(:,2)];
end

figure('color',[1 1 1]), imagesc(zscore(R1)')
figure('color',[1 1 1]), imagesc(zscore(R2)')


figure('color',[1 1 1]), hold on, 
plot(Res1{1}(:,1),mean(zscore(R1)'),'k')
plot(Res1{1}(:,1),mean(zscore(R2)'),'r')
yl=ylim;
line([0 0],yl,'color',[0.7 0.7 0.7])
plot(Res1{1}(:,1),mean(zscore(R1)'),'k')
plot(Res1{1}(:,1),mean(zscore(R2)'),'r')
xlim([-65 65])


rg=Res1{1}(:,1);
Mean1=mean(zscore(R1)');
Mean2=mean(zscore(R2)');

PlotErrorBar2(Mean1(find(rg>-40&rg<40))',Mean2(find(rg>-40&rg<40))')



for i=1:length(S)
    sPl=Range(Restrict(S{i},SleepEpoch));

    wfo=PlotWaveforms(W,i,SleepEpoch);close
    LargeSpk=squeeze(wfo(:,nchannelSpk(i),:));
    [BE,id]=sort(LargeSpk(:,14));
    lee=length(id);

    sPl1{i}=tsd(sort(sPl(id(1:1*floor(lee/4)))),sort(sPl(id(1:1*floor(lee/4)))));
    sPl2{i}=tsd(sort(sPl(id(floor(3*lee/4):lee))),sort(sPl(id(floor(3*lee/4):lee))));

end

ScompSpk1=tsdArray(sPl1);
ScompSpk2=tsdArray(sPl2);
 
% 
% bu=Range(Restrict(burst,SleepEpoch));
% BurstEpoch=intervalSet(bu-300,bu+2500);
% 
ripplesEpoch=intervalSet((Ripples(:,1)-0.001)*1E4, (Ripples(:,3)+0.001)*1E4);
ripplesEpoch=mergeCloseIntervals(ripplesEpoch,10);
Epoc=SleepEpoch-ripplesEpoch;
Epoc=Epoc-BurstEpoch;
%--------------------------------------------------------------------------
%--------------------------------------------------------------------------
%--------------------------------------------------------------------------

for i=1:length(S)


    SpkRateNb(1,i)=length(Restrict(S{i},SleepEpoch));
    SpkRateNb(2,i)=length(Restrict(S{i},and(SleepEpoch,thetaPeriod)));
    SpkRateNb(3,i)=length(Restrict(S{i},SleepEpoch-thetaPeriod));
    SpkRateNb(4,i)=length(Restrict(S{i},and(SleepEpoch,ripplesEpoch)));
    SpkRateNb(5,i)=length(Restrict(S{i},and(SleepEpoch,BurstEpoch)));
    SpkRateNb(6,i)=length(Restrict(S{i},(SleepEpoch-ripplesEpoch)));
    SpkRateNb(7,i)=length(Restrict(S{i},(SleepEpoch-BurstEpoch)));
    SpkRateNb(8,i)=length(Restrict(S{i},Epoc));

    ScompSpk1RateNb(1,i)=length(Restrict(ScompSpk1{i},SleepEpoch));
    ScompSpk1RateNb(2,i)=length(Restrict(ScompSpk1{i},and(SleepEpoch,thetaPeriod)));
    ScompSpk1RateNb(3,i)=length(Restrict(ScompSpk1{i},SleepEpoch-thetaPeriod));
    ScompSpk1RateNb(4,i)=length(Restrict(ScompSpk1{i},and(SleepEpoch,ripplesEpoch)));
    ScompSpk1RateNb(5,i)=length(Restrict(ScompSpk1{i},and(SleepEpoch,BurstEpoch)));
    ScompSpk1RateNb(6,i)=length(Restrict(ScompSpk1{i},(SleepEpoch-ripplesEpoch)));
    ScompSpk1RateNb(7,i)=length(Restrict(ScompSpk1{i},(SleepEpoch-BurstEpoch)));
    ScompSpk1RateNb(8,i)=length(Restrict(ScompSpk1{i},Epoc));

    ScompSpk2RateNb(1,i)=length(Restrict(ScompSpk2{i},SleepEpoch));
    ScompSpk2RateNb(2,i)=length(Restrict(ScompSpk2{i},and(SleepEpoch,thetaPeriod)));
    ScompSpk2RateNb(3,i)=length(Restrict(ScompSpk2{i},SleepEpoch-thetaPeriod));
    ScompSpk2RateNb(4,i)=length(Restrict(ScompSpk2{i},and(SleepEpoch,ripplesEpoch)));
    ScompSpk2RateNb(5,i)=length(Restrict(ScompSpk2{i},and(SleepEpoch,BurstEpoch)));
    ScompSpk2RateNb(6,i)=length(Restrict(ScompSpk2{i},(SleepEpoch-ripplesEpoch)));
    ScompSpk2RateNb(7,i)=length(Restrict(ScompSpk2{i},(SleepEpoch-BurstEpoch)));
    ScompSpk2RateNb(8,i)=length(Restrict(ScompSpk2{i},Epoc));



end


    Dur(1)=sum(End(SleepEpoch,'s')-Start(SleepEpoch,'s'));
    Dur(2)=sum(End(and(SleepEpoch,thetaPeriod),'s')-Start(and(SleepEpoch,thetaPeriod),'s'));
    Dur(3)=sum(End(SleepEpoch-thetaPeriod,'s')-Start(SleepEpoch-thetaPeriod,'s'));
    Dur(4)=sum(End(and(SleepEpoch,ripplesEpoch),'s')-Start(and(SleepEpoch,ripplesEpoch),'s'));
    Dur(5)=sum(End(and(SleepEpoch,BurstEpoch),'s')-Start(and(SleepEpoch,BurstEpoch),'s'));
    Dur(6)=sum(End(SleepEpoch-ripplesEpoch,'s')-Start(SleepEpoch-ripplesEpoch,'s'));
    Dur(7)=sum(End(SleepEpoch-BurstEpoch,'s')-Start(SleepEpoch-BurstEpoch,'s'));
    Dur(8)=sum(End(Epoc,'s')-Start(Epoc,'s'));

    
    for i=1:length(S)
        for j=1:8
            ScompSpk1Rate(j,i)=ScompSpk1RateNb(j,i)/Dur(j);
            ScompSpk2Rate(j,i)=ScompSpk2RateNb(j,i)/Dur(j);
            SpkRate(j,i)=SpkRateNb(j,i)/Dur(j);
        end
    end
    


% 
% for i=1:8
% PlotErrorBar3(SpkRate(i,:)', ScompSpk1Rate(i,:)',ScompSpk2Rate(i,:)')
% end
% 
% 
% for i=1:8
% PlotErrorBar2(ScompSpk1Rate(i,:)',ScompSpk2Rate(i,:)')
% end


rczsc=zscore(Rc)';
ComplSpkInd=mean(rczsc(:,55:60)')-mean(rczsc(:,41:46)');
[BE,idxx]=sort(ComplSpkInd);

ComplSpk=find(ComplSpkInd>1.3);

Ti{1}='SleepEpoch';
Ti{2}='REM';
Ti{3}='SWS';
Ti{4}='Ripples';
Ti{5}='Burst';
Ti{6}='SleepEpoch sans Ripples';
Ti{7}='SleepEpoch sans Burst';
Ti{8}='SleepEpoch sans Ripples, ni Burst';    
    
figure('color',[1 1 1]), bar(Bcros{1},mean(rczsc(ComplSpk,:))-min(mean(rczsc(ComplSpk,:))),1,'k')

    for facteur=1:8
            ScompSpk1RateCplxSpk=ScompSpk1Rate(facteur,ComplSpk);
            ScompSpk2RateCplxSpk=ScompSpk2Rate(facteur,ComplSpk);
            PlotErrorBar2(ScompSpk1RateCplxSpk',ScompSpk2RateCplxSpk')
            [h,pCpmSpk(facteur)]=ttest(ScompSpk1RateCplxSpk',ScompSpk2RateCplxSpk');
            [h,pCpmSpk2(facteur)]=ttest2(ScompSpk1RateCplxSpk',ScompSpk2RateCplxSpk');
            title([Ti{facteur},',n',num2str(facteur),', p=',num2str(pCpmSpk(facteur))])
            figure('color',[1 1 1]), hold on,
            plot(ScompSpk1Rate(facteur,:),ScompSpk2Rate(facteur,:),'o','color',[0.7 0.7 0.7],'markerfacecolor',[0.7 0.7 0.7])
            plot(ScompSpk1RateCplxSpk,ScompSpk2RateCplxSpk,'ko','markerfacecolor','k')
            line([0 5],[0 5],'color','r')
            if facteur==4
                xlim([0 5])
                ylim([0 5])
            end
            title([Ti{facteur},',n',num2str(facteur),', p=',num2str(pCpmSpk(facteur))])
            %     figure('color',[1 1 1]), hold on,
            %     scatter(ScompSpk1Rate(facteur,:),ScompSpk2Rate(facteur,:),50,ComplSpkInd,'filled')
            %     line([0 5],[0 5],'color','r')
            %     xlim([0 5])
            %     ylim([0 5])
            PercCpmSpk(facteur)=mean((ScompSpk1RateCplxSpk-ScompSpk2RateCplxSpk)./ScompSpk2RateCplxSpk*100);

end




%--------------------------------------------------------------------------
%--------------------------------------------------------------------------
%--------------------------------------------------------------------------


if 0

load Celltypes

pyr=find(Celltypes==1);%pyr=pyr(3:end);
int=find(Celltypes==0);



ScompSpk1RatePyrTemp=ScompSpk1Rate(4,pyr);
ScompSpk2RatePyrTemp=ScompSpk2Rate(4,pyr);

ScompSpk1RatePyr=ScompSpk1RatePyrTemp;
ScompSpk2RatePyr=ScompSpk2RatePyrTemp;
% 
% ScompSpk1RatePyr=ScompSpk1RatePyrTemp(find(ScompSpk1RatePyrTemp>0.5|ScompSpk2RatePyrTemp>0.5));
% ScompSpk2RatePyr=ScompSpk2RatePyrTemp(find(ScompSpk1RatePyrTemp>0.5|ScompSpk2RatePyrTemp>0.5));



PlotErrorBar2(ScompSpk1RatePyr',ScompSpk2RatePyr')

[h,ppyr]=ttest(ScompSpk1RatePyr',ScompSpk2RatePyr');

ppyr

figure('color',[1 1 1]), hold on,
plot(ScompSpk1Rate(4,(pyr)),ScompSpk2Rate(4,(pyr)),'o','color',[0.7 0.7 0.7],'markerfacecolor',[0.7 0.7 0.7])
plot(ScompSpk1RatePyr,ScompSpk2RatePyr,'ko','markerfacecolor','k')
line([0 5],[0 5],'color','r')
xlim([0 5])
ylim([0 5])

Perc=mean((ScompSpk1RatePyr-ScompSpk2RatePyr)./ScompSpk2RatePyr*100)




ScompSpk1RateIntTemp=ScompSpk1Rate(4,int);
ScompSpk2RateIntTemp=ScompSpk2Rate(4,int);

ScompSpk1RateInt=ScompSpk1RateIntTemp;
ScompSpk2RateInt=ScompSpk2RateIntTemp;
% 
% ScompSpk1RateInt=ScompSpk1RateIntTemp(find(ScompSpk1RateIntTemp>0.5|ScompSpk2RateIntTemp>0.5));
% ScompSpk2RateInt=ScompSpk2RateIntTemp(find(ScompSpk1RateIntTemp>0.5|ScompSpk2RateIntTemp>0.5));


PlotErrorBar2(ScompSpk1RateInt',ScompSpk2RateInt')

[h,pint]=ttest(ScompSpk1RateInt',ScompSpk2RateInt');


PlotErrorBar2(ScompSpk1RateInt',ScompSpk2RateInt')

end 






clear JP1t
clear JP2t
clear JP2tint
clear JP1tint
clear JP1tpyr
clear JP2tpyr

a=0;
for i=find(Celltypes<2)'

%     sum(sum(isnan(JP1{i})))
%     if sum(sum(isnan(JP1{i})))==0
        try
                JP1t=JP1t+JP1{i};
                JP2t=JP2t+JP2{i};    
                a=a+1;
        catch
                JP1t=JP1{i};
                JP2t=JP2{i};    
                a=a+1 ;
        end
%     end
end

% figure, imagesc(dt,dt,JP1t),title(['all ; Ripples(:,2)*1E4, sPl1,sPl2']), axis xy
% figure, imagesc(dt,dt,JP2t),title(['all ; sPl2,Ripples(:,2)*1E4, sPl1']), axis xy

smo=1.5;
figure, imagesc(dt,dt,SmoothDec(JP1t,[smo,smo])),title(['all ; Ripples(:,2)*1E4, sPl1,sPl2']), axis xy
        yl=ylim;
        hold on, line([yl(1) yl(2)],[0 0],'color','w')
        hold on, line([0 0],[yl(1) yl(2)],'color','w')
figure, imagesc(dt,dt,SmoothDec(JP2t,[smo,smo])),title(['all ; sPl2,Ripples(:,2)*1E4, sPl1']), axis xy
        yl=ylim;
        hold on, line([yl(1) yl(2)],[0 0],'color','w')
        hold on, line([0 0],[yl(1) yl(2)],'color','w')

a=0;
for i=find(Celltypes==1)'

%     sum(sum(isnan(JP1{i})))
%     if sum(sum(isnan(JP1{i})))==0
        try
                JP1tpyr=JP1tpyr+JP1{i};
                JP2tpyr=JP2tpyr+JP2{i};    
                a=a+1;
        catch
                JP1tpyr=JP1{i};
                JP2tpyr=JP2{i};    
                a=a+1 ;
        end
%     end
end
% 
% figure, imagesc(dt,dt,JP1tpyr),title(['pyr ; Ripples(:,2)*1E4, sPl1,sPl2']), axis xy
% figure, imagesc(dt,dt,JP2tpyr),title(['pyr ; sPl2,Ripples(:,2)*1E4, sPl1']), axis xy

smo=1.5;
figure, imagesc(dt,dt,SmoothDec(JP1tpyr,[smo,smo])),title(['pyr ; Ripples(:,2)*1E4, sPl1,sPl2']), axis xy
        yl=ylim;
        hold on, line([yl(1) yl(2)],[0 0],'color','w')
        hold on, line([0 0],[yl(1) yl(2)],'color','w')
figure, imagesc(dt,dt,SmoothDec(JP2tpyr,[smo,smo])),title(['pyr ; sPl2,Ripples(:,2)*1E4, sPl1']), axis xy
        yl=ylim;
        hold on, line([yl(1) yl(2)],[0 0],'color','w')
        hold on, line([0 0],[yl(1) yl(2)],'color','w')


a=0;
for i=find(Celltypes==0)'

%     sum(sum(isnan(JP1{i})))
%     if sum(sum(isnan(JP1{i})))==0
        try
                JP1tint=JP1tint+JP1{i};
                JP2tint=JP2tint+JP2{i};    
                a=a+1;
        catch
                JP1tint=JP1{i};
                JP2tint=JP2{i};    
                a=a+1 ;
        end
%     end
end
% 
% figure, imagesc(dt,dt,JP1tint),title(['int ; Ripples(:,2)*1E4, sPl1,sPl2']), axis xy
% figure, imagesc(dt,dt,JP2tint),title(['int ; sPl2,Ripples(:,2)*1E4, sPl1']), axis xy
% 

smo=1.5;
figure, imagesc(dt,dt,SmoothDec(JP1tint,[smo,smo])),title(['int ; Ripples(:,2)*1E4, sPl1,sPl2']), axis xy
        yl=ylim;
        hold on, line([yl(1) yl(2)],[0 0],'color','w')
        hold on, line([0 0],[yl(1) yl(2)],'color','w')
figure, imagesc(dt,dt,SmoothDec(JP2tint,[smo,smo])),title(['int ; sPl2,Ripples(:,2)*1E4, sPl1']), axis xy
        yl=ylim;
        hold on, line([yl(1) yl(2)],[0 0],'color','w')
        hold on, line([0 0],[yl(1) yl(2)],'color','w')

save FigureBilanComplexSpikeRipples Res1 Res2 Ccros Bcros nchannelSpk JP1 JP2 dt SleepEpoch thetaPeriod ripplesEpoch BurstEpoch Epoc Ripples
    
    
%         
%     numN=numN+1;
%     close all, [Res1,Res2,Ccros,Bcros,nchannelSpk]=JPETHComplexSpikesRipples(S,W,cellnames,numN,Ripples,SleepEpoch,nchannelSpk);
%     
    
    