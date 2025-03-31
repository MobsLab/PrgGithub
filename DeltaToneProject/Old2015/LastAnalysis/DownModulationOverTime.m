% --------------------------------------------------------------------------------------------------------------------------------------------
% --------------------------------------------------------------------------------------------------------------------------------------------
%                             INTER-DOWN (UP) CATEGORIZATION AND REPARTITION DURING THE DAY (all mice)
% --------------------------------------------------------------------------------------------------------------------------------------------
% --------------------------------------------------------------------------------------------------------------------------------------------

clear all
close all
exp='Basal';

for mouse=[243 244 251]
    
    Dir=PathForExperimentsDeltaSleep2016('Basal');
    Dir=RestrictPathForExperiment(Dir,'nMice',mouse);
    zz=1;
    
    for i=1:length(Dir.path)
        eval(['cd(Dir.path{',num2str(i),'}'')'])
        disp(' ')
        disp(pwd)
        disp(' ')
        
        % Restriction to silence during SWS Epoch (= Down)
        try
            load DownSpk
            load StateEpochSB SWSEpoch
            sttemp=Start(Down);
            entemp=End(Down);
            intTsd=tsd(sttemp(2:end),(sttemp(2:end)-entemp(1:end-1))/10);
            % Restriction to silence during SWS Epoch (= Down)
            intDown=Restrict(intTsd,SWSEpoch);
            intDownData=Data(intDown);
            intDownTime=Range(intDown);
            
            EpochSize=20;
            START=Start(SWSEpoch);START=START(1);
            END=End(SWSEpoch);END=END(end);
            EpochDur=(END-START)/EpochSize;
            a=0;
            for i=1:EpochSize
                EpochForH{i}=intervalSet(START+EpochDur*(a),START+EpochDur*(i));
                SWSDurForH(i)=sum(End(and(EpochForH{i},SWSEpoch),'s')-Start(and(EpochForH{i},SWSEpoch),'s'));
                a=a+1;
            end
            SWSDurForH_All(:,zz)=SWSDurForH;
            
            % Categorization of Inter-Down Interval
            DownLess400ms=[];
            DownLess600ms=[];
            DownLess800ms=[];
            DownLess1000ms=[];
            DownMore1000ms=[];
            
            for i=1:length(Data(intDown))
                if intDownData(i)<400
                    DownLess400ms=[DownLess400ms,intDownTime(i)];
                elseif intDownData(i)>400 & intDownData(i)<600
                    DownLess600ms=[DownLess600ms,intDownTime(i)];
                elseif intDownData(i)>600 & intDownData(i)<800
                    DownLess800ms=[DownLess800ms,intDownTime(i)];
                elseif intDownData(i)>800 & intDownData(i)<1000
                    DownLess1000ms=[DownLess1000ms,intDownTime(i)];
                elseif intDownData(i)>1000
                    DownMore1000ms=[DownMore1000ms,intDownTime(i)];
                end
            end
            IntDownAll=[];
            for i=1:length(Data(intDown))
                IntDownAll=[IntDownAll,intDownData(i)];
            end
            % Histogramm of Inter-Down Interval
            h1=hist(DownLess400ms,EpochSize); h1All(:,zz)=h1; 
            h2=hist(DownLess600ms,EpochSize); h2All(:,zz)=h2;
            h3=hist(DownLess800ms,EpochSize); h3All(:,zz)=h3;
            h4=hist(DownLess1000ms,EpochSize); h4All(:,zz)=h4;
            h5=hist(DownMore1000ms,EpochSize); h5All(:,zz)=h5;
            hSWS=hist(Start(SWSEpoch),EpochSize); hSWSAll(:,zz)=hSWS;
            
            zz=zz+1;
        end
    end  
    
        smo=0;
        figure('color',[1 1 1])
        hold on, subplot(3,1,1),
        hold on, plot(SmoothDec(mean(h1All,2),smo),'k','linewidth',2)
        hold on, plot(SmoothDec(mean(h2All,2),smo),'b','linewidth',2)
        hold on, plot(SmoothDec(mean(h3All,2),smo),'c','linewidth',2)
        hold on, plot(SmoothDec(mean(h4All,2),smo),'m','linewidth',2)
        hold on, plot(SmoothDec(mean(h5All,2),smo),'r','linewidth',2)
        hold on, title(['Quantity of Up States during all day, mouse #',num2str(mouse),', n=(',num2str(zz),')'])
        hold on, legend(['...<400ms'],['400>...<600ms'],['600>...<800ms'],['800>...<1000ms'],['1000ms>...'])
        hold on, subplot(3,1,2),
        hold on, plot(SmoothDec(mean(h1All,2)./SWSDurForH',smo),'k','linewidth',2)
        hold on, plot(SmoothDec(mean(h2All,2)./SWSDurForH',smo),'b','linewidth',2)
        hold on, plot(SmoothDec(mean(h3All,2)./SWSDurForH',smo),'c','linewidth',2)
        hold on, plot(SmoothDec(mean(h4All,2)./SWSDurForH',smo),'m','linewidth',2)
        hold on, plot(SmoothDec(mean(h5All,2)./SWSDurForH',smo),'r','linewidth',2)
        hold on, title('Ratio of Up States during all day')
        hold on, legend(['...<400ms'],['400>...<600ms'],['600>...<800ms'],['800>...<1000ms'],['1000ms>...'])
        hold on, subplot(3,1,3),
        hold on, plot(SmoothDec(SWSDurForH,smo),'k','linewidth',2)
        hold on, title('Quantity of SWS during all day')
end

% --------------------------------------------------------------------------------------------------------------------------------------------
% --------------------------------------------------------------------------------------------------------------------------------------------
%                                DOWN CATEGORIZATION AND REPARTITION DURING THE DAY (all mice)
% --------------------------------------------------------------------------------------------------------------------------------------------
% --------------------------------------------------------------------------------------------------------------------------------------------

clear all
close all
exp='Basal';

for mouse=[243 244 251]
    
    Dir=PathForExperimentsDeltaSleep2016('Basal');
    Dir=RestrictPathForExperiment(Dir,'nMice',mouse);
    zz=1;
    
    for i=1:length(Dir.path)
        eval(['cd(Dir.path{',num2str(i),'}'')'])
        disp(' ')
        disp(pwd)
        disp(' ')
        
        % Restriction to silence during SWS Epoch (= Down)
        try
            load DownSpk
            load StateEpochSB SWSEpoch
            sttemp=Start(Down);
            entemp=End(Down);
            intTsd=tsd(sttemp(1:end),(entemp(1:end)-sttemp(1:end))/10);
            % Restriction to silence during SWS Epoch (= Down)
            DurDown=Restrict(intTsd,SWSEpoch);
            DurDownData=Data(DurDown);
            DurDownTime=Range(DurDown);
            
            EpochSize=20;
            START=Start(SWSEpoch);START=START(1);
            END=End(SWSEpoch);END=END(end);
            EpochDur=(END-START)/EpochSize;
            a=0;
            for i=1:EpochSize
                EpochForH{i}=intervalSet(START+EpochDur*(a),START+EpochDur*(i));
                SWSDurForH(i)=sum(End(and(EpochForH{i},SWSEpoch),'s')-Start(and(EpochForH{i},SWSEpoch),'s'));
                a=a+1;
            end
            SWSDurForH_All(:,zz)=SWSDurForH;
            
            % Categorization of Inter-Down Interval
            DownLess100ms=[];
            DownLess150ms=[];
            DownLess200ms=[];
            DownLess250ms=[];
            DownMore250ms=[];
            
            for i=1:length(Data(DurDown))
                if DurDownData(i)<100
                    DownLess100ms=[DownLess100ms,DurDownTime(i)];
                elseif DurDownData(i)>100 & DurDownData(i)<150
                    DownLess150ms=[DownLess150ms,DurDownTime(i)];
                elseif DurDownData(i)>150 & DurDownData(i)<200
                    DownLess200ms=[DownLess200ms,DurDownTime(i)];
                elseif DurDownData(i)>200 & DurDownData(i)<250
                    DownLess250ms=[DownLess250ms,DurDownTime(i)];
                elseif DurDownData(i)>250
                    DownMore250ms=[DownMore250ms,DurDownTime(i)];
                end
            end
            DurDownAll=[];
            for i=1:length(Data(DurDown))
                DurDownAll=[DurDownAll,DurDownData(i)];
            end
            % Histogramm of Inter-Down Interval
            h1=hist(DownLess100ms,EpochSize); h1All(:,zz)=h1; 
            h2=hist(DownLess150ms,EpochSize); h2All(:,zz)=h2;
            h3=hist(DownLess200ms,EpochSize); h3All(:,zz)=h3;
            h4=hist(DownLess250ms,EpochSize); h4All(:,zz)=h4;
            h5=hist(DownMore250ms,EpochSize); h5All(:,zz)=h5;
            hSWS=hist(Start(SWSEpoch),EpochSize); hSWSAll(:,zz)=hSWS;
            
            zz=zz+1;
        end
    end  
    
        smo=0;
        figure('color',[1 1 1])
        hold on, subplot(3,1,1),
        hold on, plot(SmoothDec(mean(h1All,2),smo),'k','linewidth',2)
        hold on, plot(SmoothDec(mean(h2All,2),smo),'b','linewidth',2)
        hold on, plot(SmoothDec(mean(h3All,2),smo),'c','linewidth',2)
        hold on, plot(SmoothDec(mean(h4All,2),smo),'m','linewidth',2)
        hold on, plot(SmoothDec(mean(h5All,2),smo),'r','linewidth',2)
        hold on, title(['Quantity of Down States during all day, mouse #',num2str(mouse),', n=(',num2str(zz),')'])
        hold on, legend(['...<100ms'],['100>...<150ms'],['150>...<200ms'],['200>...<250ms'],['250ms>...'])
        hold on, subplot(3,1,2),
        hold on, plot(SmoothDec(mean(h1All,2)./SWSDurForH',smo),'k','linewidth',2)
        hold on, plot(SmoothDec(mean(h2All,2)./SWSDurForH',smo),'b','linewidth',2)
        hold on, plot(SmoothDec(mean(h3All,2)./SWSDurForH',smo),'c','linewidth',2)
        hold on, plot(SmoothDec(mean(h4All,2)./SWSDurForH',smo),'m','linewidth',2)
        hold on, plot(SmoothDec(mean(h5All,2)./SWSDurForH',smo),'r','linewidth',2)
        hold on, title('Ratio of Down States during all day')
        hold on, legend(['...<100ms'],['100>...<150ms'],['150>...<200ms'],['200>...<250ms'],['250ms>...'])
        hold on, subplot(3,1,3),
        hold on, plot(SmoothDec(SWSDurForH,smo),'k','linewidth',2)
        hold on, title('Quantity of SWS during all day')
end