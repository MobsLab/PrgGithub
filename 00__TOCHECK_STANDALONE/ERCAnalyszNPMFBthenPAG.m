% Epochs
clear all
VoltEpochs{1}=intervalSet([84,263,408,543,680,915]*1e4,([84,263,408,543,680,915]+100)*1e4);
VoltageUsed{1}=[0,0.5,1,1.5,2,2.5];
VoltEpochs{2}=intervalSet([7,142,274,406,536,]*1e4,([7,142,274,406,536,]+100)*1e4);
VoltageUsed{2}=[0,0.5,1,1.5,2];
VoltEpochs{3}=intervalSet([55,186,319,457,583,730,858,1011,1167]*1e4,([55,186,319,457,583,730,858,1011,1167]+100)*1e4);
VoltageUsed{3}=[0,0.5,1,1.5,2,2.5,3,3.5,4];

% VoltEpochs{4}=intervalSet([96,257,434,735]*1e4,([96,257,434,735]+100)*1e4);
% VoltageUsed{4}=[0:0.5:3.5];
VoltEpochs{4}=intervalSet([40,187,316,450,598,742,910,1046]*1e4,([40,187,316,450,598,742,910,1046]+100)*1e4);
VoltageUsed{4}=[0:0.5:3.5];
VoltEpochs{5}=intervalSet([4,148,275,410,555,682,820,960,1080]*1e4,([4,148,275,410,555,682,820,960,1080]+100)*1e4);
VoltageUsed{5}=[0:0.5:4];
VoltEpochs{6}=intervalSet([85,271,399,530,666,798,934,1073,1207]*1e4,([85,271,399,530,666,798,934,1073,1207]+100)*1e4);
VoltageUsed{6}=[0:0.5:4];

location= {
    '/media/MOBSDataRotation/M253/CalibPAG/Session2_121015/DigDat/M253_PAGCalib_Droite_Sess4_151012_122135',
    '/media/MOBSDataRotation/M253/CalibPAG/Session3_131015/DigDat/M253_PAGCalib_Droite_Sess5_151013_110324',
    '/media/MOBSDataRotation/M253/CalibPAG/Session4_141015/DigDat/M253_PAGCalib_Droite_Sess7_151014_105532',
    '/media/MOBSDataRotation/M254/CalibPAG/Session2_121015/DigDat/M254_PAGCalib_Droite_Sess4_151012_124726',
    '/media/MOBSDataRotation/M254/CalibPAG/Session3_131015/DigDat/M254_PAGCalib_Droite_Sess5_151013_113200',
    '/media/MOBSDataRotation/M254/CalibPAG/Session4_141015/DigDat/M254_PAGCalib_Droite_Sess7_151013_113200_151014_112213'};

locationPosMat= {
    '/media/MOBSDataRotation/M253/CalibPAG/Session2_121015/Tracking/Rotation-Mouse-253-12102015-01-PAG_Calib_DroiteDay3Session4/F12102015-0000/PosMat.mat',
    '/media/MOBSDataRotation/M253/CalibPAG/Session3_131015/Tracking/Rotation-Mouse-253-13102015-01-Calib_PAG_DroiteDay4Session5/F13102015-0000/PosMat.mat',
    '/media/MOBSDataRotation/M253/CalibPAG/Session4_141015/Tracking/Rotation-Mouse-253-14102015-01-Calib_PAG_DroiteDay5Session7/F14102015-0000/PosMat.mat',
    '/media/MOBSDataRotation/M254/CalibPAG/Session2_121015/Tracking/Rotation-Mouse-254-12102015-01-PAB_Calib_DroiteDay3Session4/F12102015-0000/PosMat.mat',
    '/media/MOBSDataRotation/M254/CalibPAG/Session3_131015/Tracking/Rotation-Mouse-254-13102015-01-Calib_PAG_DroiteDay4Session5/F13102015-0000/PosMat.mat',
    '/media/MOBSDataRotation/M254/CalibPAG/Session4_141015/Tracking/Rotation-Mouse-254-14102015-01-Calib_PAG_DroiteDay5Session7/F14102015-0000/PosMat.mat'};


DataGroups{1}=[1,2,3];
DataGroups{2}=[4:6];

for t=1:2
    figure
    cols=copper(length(DataGroups{t}));
    number=0;
    for mm=DataGroups{t}
        mm
        number=number+1;
        load(locationPosMat{mm})
        
        cd(location{mm})
        load('PokeData.mat')
        poke=poke(tps>0);
                MFB=MFB(tps>0);
                PAG=PAG(tps>0);
        tps=tps(tps>0);
        xd=naninterp(PosMat(:,2));
        diffx=(xd(2:end)-xd(1:end-1)).^2;
        yd=naninterp(PosMat(:,3));
        diffy=(yd(2:end)-yd(1:end-1)).^2;
        vit=interp1(PosMat(2:end,1),sqrt(diffx+diffy),tps);
        Vtsd=tsd(tps*1e4',vit);
        Poketsd=tsd(tps*1e4,poke);
        PokeONEpoch=thresholdIntervals(Poketsd,0.5,'Direction','Below');
        MFBtsd=tsd(tps*1e4,MFB);
        MFBEpoch=thresholdIntervals(MFBtsd,0.5,'Direction','Above');
        PAGtsd=tsd(tps*1e4,PAG);
        PAGtsd=Restrict(PAGtsd,Range(Vtsd));
        PAGEpoch=thresholdIntervals(PAGtsd,0.5,'Direction','Above');

        PokeONEpoch=mergeCloseIntervals(PokeONEpoch,2*1e4);
        
        subplot(2,2,1)
        numstims=[];
        numstims=[];
        for k=1:length(VoltageUsed{mm})
            numstims(k)=length(Data(Restrict(Poketsd,And(PokeONEpoch,subset(VoltEpochs{mm},k)))))/length(Data(Restrict(Poketsd,subset(VoltEpochs{mm},k))));
        end,
        numstims=sortrows([VoltageUsed{mm};numstims]',1);
        plot(numstims(:,1),numstims(:,2),'color',cols(number,:),'linewidth',2)
        hold on
        plot(numstims(:,1),numstims(:,2),'*','color',cols(number,:),'linewidth',2)
        %       line([0 max(numstims(:,1))], [25 25])
        title('% of time')
        
        subplot(2,2,3)
        numstims=[];
        for k=1:length(VoltageUsed{mm})
            numstims(k)=nanmean(Data(Restrict(Vtsd,(And(PokeONEpoch,subset(VoltEpochs{mm},k))))));
        end
        numstims=sortrows([VoltageUsed{mm};numstims]',1);
        plot(numstims(:,1),numstims(:,2),'color',cols(number,:),'linewidth',2)
        hold on
        plot(numstims(:,1),numstims(:,2),'*','color',cols(number,:),'linewidth',2)
        ylim([0 2])
        title('average speed during stim')
        
        cols2=jet(length(Start(VoltEpochs{mm})));
        subplot(2,2,2)
        for k=1:length(VoltageUsed{mm})
            [M,S,tt]=mETAverage(Start(And(MFBEpoch,subset(VoltEpochs{mm},k))),Range(Vtsd),Data(Vtsd),100,50);hold on
            plot(tt/1E3,M,'color',cols2(k,:),'linewidth',2)
        end
        title('MFB triggered activity')
        
        cols2=jet(length(Start(VoltEpochs{mm})));
        subplot(2,2,4)
        for k=1:length(VoltageUsed{mm})
            [M,S,tt]=mETAverage(Start(And(PAGEpoch,subset(VoltEpochs{mm},k))),Range(Vtsd),Data(Vtsd),100,50);hold on
            plot(tt/1E3,M,'color',cols2(k,:),'linewidth',2)
        end
        title('PAG triggered activity')
        
        %          % inter-poke interval
        %         subplot(2,2,4)
        %         numstims=[];
        %         for k=1:length(VoltageUsed{mm})
        %             a=Start(And(PokeONEpoch,subset(VoltEpochs{mm},k)),'s');
        %             b=Stop(And(PokeONEpoch,subset(VoltEpochs{mm},k)),'s');
        %             a(1)=[];
        %             b(end)=[];
        %             numstims(k)=median(a-b);
        %         end
        %         numstims=sortrows([VoltageUsed{mm};numstims]',1);
        %         plot(numstims(:,1),numstims(:,2),'color',cols(number,:),'linewidth',2)
        %         hold on
        %         plot(numstims(:,1),numstims(:,2),'*','color',cols(number,:),'linewidth',2)
        %         title('average inter poke interval')
        
    end
end


