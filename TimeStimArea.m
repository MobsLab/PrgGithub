%function TimeStimArea



% Compute time spent in the stimulation area
% Compute correlation coeff between explo and StimExplo



disp('pas fini')

CorrelationCoef=[];
TimeInStimArea=[];
QuadrantTime=[];

    for q=[N,M]
        
        i=rem(q,NbTrials);
        if i==0
            i=NbTrials;
        end
        if ismember(q,N)
            j=1; %pre
        elseif ismember(q,M)
            j=2; %post
        end
        
        Epoch=subset(QuantifExploEpoch,q);
        durEpoch=End(Epoch,'s')-Start(Epoch,'s');
        Xij=Restrict(X,Epoch);
        Yij=Restrict(Y,Epoch);
        
        [Oc,OcS,OcR,OcRS]=OccupancyMapKB(Xij,Yij,'axis',[0 15],'smoothing',smo,'size',sizeMap,'limitmaze',limMaz);close
        
        mSij=OcRS;
        mSij(PF==0)=0;
        mSbij=OcRS;
        mSbij(PFb==0)=0;

        TimeInStimArea(i,j)=sum(sum(mSij));
        TimeInLargeStimArea(i,j)=sum(sum(mSbij));
        %r=corrcoef(mapS.rate(:),OcRS(:));
        r=corrcoef(mapS.rate(find(BW==1)),OcRS(find(BW==1)));
        val1=mapS.rate(find(BW==1));
        val2=OcRS(find(BW==1));
        
        level1=max(val1)/5;
        level2=max(val2)/5;
       
        [rcorrected,p1corrected]=corrcoef(val1(find(val1>level1|val2>level2)),val2(find(val1>level1|val2>level2)));

        CorrelationCoef(i,j)=r(1,2);
        CorrelationCoefCorrected(i,j)=rcorrected(1,2);
        
        Angij=Restrict(Ang,Epoch);
        try
            int=thresholdIntervals(Restrict(dis,Epoch),Limdist,'Direction','Below');
            intr=dropShortIntervals(int,tpsTh);
            %int1r=int1;
            rg=Start(intr,'s');
            ref=Range(Restrict(dis,Epoch),'s');
            tps=rg(1)-ref(1);
            trajdir=intervalSet(ref(1)*1E4,rg(1)*1E4);
            StdAngle(i,j)=std(Data(Restrict(Angij,trajdir)));    
        catch
            tps=limTemp;
            StdAngle(i,j)=nanmean(Data(Ang2));
            
        end
        
        zone1=thresholdIntervals(Xij,ce(1),'Direction','Above');
        zone2=thresholdIntervals(Xij,ce(1),'Direction','Below');
        zone3=thresholdIntervals(Yij,ce(2),'Direction','Above');
        zone4=thresholdIntervals(Yij,ce(2),'Direction','Below');
        
        zoneNE=and(zone1,zone3);
        zoneSE=and(zone1,zone4);
        zoneNW=and(zone2,zone3);
        zoneSW=and(zone2,zone4);
        % 1+5 NE, 2+6 SE, 3+7 NW, 4+8 SW 
        QuadrantTime(i,(j-1)*4+1)=length(Data(Restrict(Xij,zoneNE)))/30;
        QuadrantTime(i,(j-1)*4+2)=length(Data(Restrict(Xij,zoneSE)))/30;
        QuadrantTime(i,(j-1)*4+3)=length(Data(Restrict(Xij,zoneNW)))/30;
        QuadrantTime(i,(j-1)*4+4)=length(Data(Restrict(Xij,zoneSW)))/30;
    end

    
    
    
    

%%% Time spent in  Stimulation area
durEpoch1=sum(End(Epoch1,'s')-Start(Epoch1,'s'));
durEpoch2=sum(End(Epoch2,'s')-Start(Epoch2,'s'));

[Df1,Sf1,Ef1]=MeanDifNan(TimeInStimArea(:,1));
[Df2,Sf2,Ef2]=MeanDifNan(TimeInStimArea(:,2));
[Df3,Sf3,Ef3]=MeanDifNan(TimeInLargeStimArea(:,1));
[Df4,Sf4,Ef4]=MeanDifNan(TimeInLargeStimArea(:,2));
[h,pTiA]=ttest(TimeInStimArea(:,1),TimeInStimArea(:,2));
[h,pTiLA]=ttest(TimeInLargeStimArea(:,1),TimeInLargeStimArea(:,2));
    
figure('color',[1 1 1]),
subplot(2,3,1:2); hold on,
errorbar([Df1,Df2,Df3,Df4],[Ef1,Ef2,Ef3,Ef4],'k+')
bar([Df1,Df2,Df3,Df4],'k'), xlim([0 5])
% bar([sum(sum(m1S))/durEpoch1 sum(sum(m2S))/durEpoch2 sum(sum(m1Sb))/durEpoch1 sum(sum(m2Sb))/durEpoch2],'k')
ylabel(['Time spent in  ',num2str(nom),' (%)'])
xlabel(['larged p=',num2str(pTiA),' unlarged p=',num2str(pTiLA)])
set(gca,'xtick',1:4)
set(gca,'xticklabel',legend)

numfig=gcf;

subplot(2,3,3)

[r1,p1]=corrcoef(mapS.rate(find(BW==1)),OcRS1(find(BW==1)));
[r2,p2]=corrcoef(mapS.rate(find(BW==1)),OcRS2(find(BW==1)));

val1=mapS.rate(find(BW==1));
val2=OcRS1(find(BW==1));
val3=OcRS2(find(BW==1));

level1=max(val1)/5;
level2=max(val2)/5;
level3=max(val3)/5;

[r1corrected,p1c]=corrcoef(val1(find(val1>level1|val2>level2)),val2(find(val1>level1|val2>level2)));
[r2corrected,p2c]=corrcoef(val1(find(val1>level1|val3>level3)),val3(find(val1>level1|val3>level3)));

r1=r1(1,2);
r2=r2(1,2);
r1c=r1corrected(1,2);
r2c=r2corrected(1,2);

CorrelationCoef(10,1)=r1;CorrelationCoef(11,1)=p1(1,2);
CorrelationCoef(10,2)=r2;CorrelationCoef(11,2)=p2(1,2);
CorrelationCoefCorrected(10,1)=r1c; CorrelationCoefCorrected(11,1)=p1c(1,2);
CorrelationCoefCorrected(10,2)=r2c; CorrelationCoefCorrected(11,2)=p2c(1,2);

bar([r1 r2 r1c r2c],'k')
ylabel(['Correlation Occ. Map vs ',num2str(nom)])
xlabel(['p value= ',num2str(floor(p1(1,2)*1000)/1000),'  ',num2str(floor(p2(1,2)*1000)/1000),'  ',num2str(floor(p1c(1,2)*1000)/1000),'  ',num2str(floor(p2c(1,2)*1000)/1000)])
set(gca,'xtick',1:4)
set(gca,'xticklabel',legend)




    