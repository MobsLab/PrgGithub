clear all,close all
m=0;
m=m+1;filename{m}='/media/DataMOBsRAID/ManipsERC/NosePokeERC/Mouse261/MFB/NosePoke-MFBcalib2-19012016-m261/';
m=m+1;filename{m}='/media/DataMOBsRAID/ManipsERC/NosePokeERC/Mouse261/MFB/NosePoke-MFBcalib3-19012016-m261/';
m=m+1;filename{m}='/media/DataMOBsRAID/ManipsERC/NosePokeERC/Mouse261/MFB/NosePoke-MFBdroite4-20012016-m261/';
m=m+1;filename{m}='/media/DataMOBsRAID/ManipsERC/NosePokeERC/Mouse261/MFB/NosePoke-MFBdroite5-20012016-m261/';

m=m+1;filename{m}='/media/DataMOBsRAID/ManipsERC/NosePokeERC/Mouse261/PAG/NosePoke-PAG-21012016-m261/';
m=m+1;filename{m}='/media/DataMOBsRAID/ManipsERC/NosePokeERC/Mouse261/PAG/NosePoke-PAG3-22012016-m261/';

m=m+1;filename{m}='/media/DataMOBsRAID/ManipsERC/NosePokeERC/Mouse262/MFB/NosePoke-MFBcalib2-19012016-m262/';
m=m+1;filename{m}='/media/DataMOBsRAID/ManipsERC/NosePokeERC/Mouse262/MFB/NosePoke-MFBcalib3-19012016-m262/';
m=m+1;filename{m}='/media/DataMOBsRAID/ManipsERC/NosePokeERC/Mouse262/MFB/NosePoke-MFBcalib4-20012016-m262/';
m=m+1;filename{m}='/media/DataMOBsRAID/ManipsERC/NosePokeERC/Mouse262/MFB/NosePoke-MFBcalib5-21012016-m262/';

m=m+1;filename{m}='/media/DataMOBsRAID/ManipsERC/NosePokeERC/Mouse262/PAG/NosePoke-PAG-21012016-m262/';
m=m+1;filename{m}='/media/DataMOBsRAID/ManipsERC/NosePokeERC/Mouse262/PAG/NosePoke-PAG2-21012016-m262/';
m=m+1;filename{m}='/media/DataMOBsRAID/ManipsERC/NosePokeERC/Mouse262/PAG/NosePoke-PAG3-22012016-m262';
DataGroups{1}=[1:3];
DataGroups{2}=[5:6];
DataGroups{3}=[7:9];
DataGroups{4}=[11:13];
    number=0;
for t=1:4
    figure
    cols=copper(length(DataGroups{t}));
    for mm=DataGroups{t}
        number=number+1;
        cd(filename{mm})
        load('PokeInfo.mat')
        Xtsd=tsd(Range(Xtsd),naninterp(Data(Xtsd)));
        xd=Data(Xtsd);
        diffx=(xd(2:end)-xd(1:end-1)).^2;
        Ytsd=tsd(Range(Ytsd),naninterp(Data(Ytsd)));
        yd=Data(Ytsd);
        diffy=(yd(2:end)-yd(1:end-1)).^2;
        vit=interp1(Range(Vtsd),sqrt(diffx+diffy),Range(Poketsd));
        Vtsd=tsd(Range(Poketsd),vit);
        %
        PokeONEpoch=mergeCloseIntervals(PokeONEpoch,2*1e4);
        
        subplot(2,2,1)
        numstims=[];
        for k=1:length(chgvolt)
            numstims(k)=length(Data(Restrict(Poketsd,And(PokeONEpoch,subset(VoltEpochs,k)))))/1000;
        end,
        numstims=sortrows([VoltageUsed(:,1)';numstims]',1);
%         plot(numstims(:,1),numstims(:,2),'color',cols(number,:),'linewidth',2)
%         hold on
%         plot(numstims(:,1),numstims(:,2),'*','color',cols(number,:),'linewidth',2)
%         title('% of time')
        RemPercTime{number}=numstims;
%         numstims=[];
%         for k=1:length(chgvolt)
%             numstims(k)=sum(Range(Restrict(mfbts,subset(VoltEpochs,k)),'s')*0+1);
%         end
%         numstims=sortrows([VoltageUsed(:,1)';numstims]',1);
%         if t==2 | t==4
%             numstims(:,2)=numstims(:,2)/2;
%         end
%         plot(numstims(:,1),numstims(:,2),'color',cols(number,:),'linewidth',2)
%         hold on
%         plot(numstims(:,1),numstims(:,2),'*','color',cols(number,:),'linewidth',2)
%         line([0 max(numstims(:,1))], [25 25])
%         title('number of stims')
        
        
%         
%         %% vitesse
%         subplot(2,2,3)
%         numstims=[];
%         for k=1:length(chgvolt)
%             numstims(k)=nanmean(Data(Restrict(Vtsd,(And(PokeONEpoch,subset(VoltEpochs,k))))));
%         end
%         numstims=sortrows([VoltageUsed(:,1)';numstims]',1);
%         plot(numstims(:,1),numstims(:,2),'color',cols(number,:),'linewidth',2)
%         hold on
%         plot(numstims(:,1),numstims(:,2),'*','color',cols(number,:),'linewidth',2)
%         ylim([0 2])
%         title('average speed during stim')
%         PokeONEpoch=thresholdIntervals(Poketsd,0.5,'Direction','Above');
%         PokeONEpoch=mergeCloseIntervals(PokeONEpoch,0.5*1e4);
%         cols2=jet(length(Start(VoltEpochs)));
%         
%         subplot(2,2,2)
%         for y=1:length(Start(VoltEpochs))
%             [M,S,tt]=mETAverage(Start(And(PokeONEpoch,subset(VoltEpochs,y))),Range(Vtsd),Data(Vtsd),100,50);hold on
%             plot(tt/1E3,M,'color',cols2(y,:),'linewidth',2)
%         end
%         ylim([0 4])
%         
%         % inter-poke interval
%         subplot(2,2,4)
%         numstims=[];
%         for k=1:length(chgvolt)
%             a=Start(And(PokeONEpoch,subset(VoltEpochs,k)),'s');
%             b=Stop(And(PokeONEpoch,subset(VoltEpochs,k)),'s');
%             a(1)=[];
%             b(end)=[];
%             numstims(k)=median(a-b);
%         end
%         numstims=sortrows([VoltageUsed(:,1)';numstims]',1);
%         plot(numstims(:,1),numstims(:,2),'color',cols(number,:),'linewidth',2)
%         hold on
%         plot(numstims(:,1),numstims(:,2),'*','color',cols(number,:),'linewidth',2)
%         title('average inter poke interval')
        
    end
end