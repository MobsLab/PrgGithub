%FigureSuppREactivationMFB


filename='/Users/karimbenchenane/Documents/Data/DataEnCours/ManipesICSSok/Data/';




%--------------------------------------------------------------------------
%--------------------------------------------------------------------------
%--------------------------------------------------------------------------

if 1

        cd /Users/karimbenchenane/Documents/Data/DataEnCours/ManipesICSSok/Data/Figures


        try 
            load CorrelationReactivationMFB
            Crwa;
            CrSl;


        catch





                cd([filename,'Mouse026/20120109'])

                load SpikeData
                load behavResources


                NeuronNum=6;
                SessionPlaceCells=[7 9 11];
                EpochCtrl1=intervalSet(tpsdeb{7}*1E4,tpsfin{7}*1E4);
                EpochCtrl2=intervalSet(tpsdeb{9}*1E4,tpsfin{9}*1E4);
                EpochCtrl=or(EpochCtrl1,EpochCtrl2);
                EpochCtrl3=intervalSet(tpsdeb{11}*1E4,tpsfin{11}*1E4);
                EpochCtrl=or(EpochCtrl,EpochCtrl3);

                EpochSleep=intervalSet(tpsdeb{4}*1E4,tpsfin{5}*1E4);


                % 
                % a=19; 
                % param1=20;param2=100;
                % [Cwa,Bwa]=CrossCorr(Range(Restrict(S{NeuronNum},EpochCtrl)),Range(Restrict(S{a},EpochCtrl)),param1,param2); 
                % figure('color',[1 1 1]), hold on, bar(Bwa,Cwa,1,'k'), yl=ylim; line([0 0],yl,'color','r'), xlim([-param1*param2/2 param1*param2/2])
                % 
                % PlaceField(Restrict(S{a},EpochCtrl), Restrict(X,EpochCtrl),Restrict(Y,EpochCtrl));
                % PlaceField(Restrict(S{NeuronNum},EpochCtrl), Restrict(X,EpochCtrl),Restrict(Y,EpochCtrl));
                % 
                % EpochSleep=intervalSet(tpsdeb{4}*1E4,tpsfin{5}*1E4);
                % 
                % param1=2;param2=100;
                % [Csl,Bsl]=CrossCorr(Range(Restrict(S{NeuronNum},EpochSleep)),Range(Restrict(S{a},EpochSleep)),param1,param2); 
                % figure('color',[1 1 1]), hold on, bar(Bsl,Csl,1,'k'), yl=ylim; line([0 0],yl,'color','r'), xlim([-param1*param2/2 param1*param2/2])
                % 
                % 
                % 
                % a=2; 
                % param1=20;param2=100;
                % [Cwa,Bwa]=CrossCorr(Range(Restrict(S{NeuronNum},EpochCtrl)),Range(Restrict(S{a},EpochCtrl)),param1,param2); 
                % figure('color',[1 1 1]), hold on, bar(Bwa,Cwa,1,'k'), yl=ylim; line([0 0],yl,'color','r'), xlim([-param1*param2/2 param1*param2/2]), title(['CrossCorrelogram Wake ', cellnames{NeuronNum}, ' vs. ', cellnames{a}])
                % 
                % PlaceField(Restrict(S{a},EpochCtrl), Restrict(X,EpochCtrl),Restrict(Y,EpochCtrl));
                % PlaceField(Restrict(S{NeuronNum},EpochCtrl), Restrict(X,EpochCtrl),Restrict(Y,EpochCtrl));
                % 
                % EpochSleep=intervalSet(tpsdeb{4}*1E4,tpsfin{5}*1E4);
                % 
                % param1=2;param2=100;
                % [Csl,Bsl]=CrossCorr(Range(Restrict(S{NeuronNum},EpochSleep)),Range(Restrict(S{a},EpochSleep)),param1,param2); 
                % figure('color',[1 1 1]), hold on, bar(Bsl,Csl,1,'k'), yl=ylim; line([0 0],yl,'color','r'), xlim([-param1*param2/2 param1*param2/2]), title(['CrossCorrelogram Sleep ', cellnames{NeuronNum}, ' vs. ', cellnames{a}])
                % 
                % 


                b=1;

                for a=1:length(S)

                    param1=20;param2=200;
                    [Cwa,Bwa]=CrossCorr(Range(Restrict(S{NeuronNum},EpochCtrl)),Range(Restrict(S{a},EpochCtrl)),param1,param2); 
                    %figure('color',[1 1 1]), hold on, bar(Bwa,Cwa,1,'k'), yl=ylim; line([0 0],yl,'color','r'), xlim([-param1*param2/2 param1*param2/2]), title(['CrossCorrelogram Wake ', cellnames{NeuronNum}, ' vs. ', cellnames{a}])

                %    PlaceField(Restrict(S{a},EpochCtrl), Restrict(X,EpochCtrl),Restrict(Y,EpochCtrl));
                 %   PlaceField(Restrict(S{NeuronNum},EpochCtrl), Restrict(X,EpochCtrl),Restrict(Y,EpochCtrl));



                    param1=5;param2=100;
                    [Csl,Bsl]=CrossCorr(Range(Restrict(S{NeuronNum},EpochSleep)),Range(Restrict(S{a},EpochSleep)),param1,param2); 
                  %  figure('color',[1 1 1]), hold on, bar(Bsl,Csl,1,'k'), yl=ylim; line([0 0],yl,'color','r'), xlim([-param1*param2/2 param1*param2/2]), title(['CrossCorrelogram Sleep ', cellnames{NeuronNum}, ' vs. ', cellnames{a}])

                    CrSl(b,1)=mean(Csl([[1:20],[80:100]]));
                    CrSl(b,2)=mean(Csl([40:60]));
                    CrSl(b,3)=a;

                    Crwa(b,1)=mean(Cwa([[1:50],[150:200]]));
                    Crwa(b,2)=mean(Cwa([98:102]));
                    Crwa(b,3)=a;

                    b=b+1;

                    close all

                end




                %--------------------------------------------------------------------------
                %--------------------------------------------------------------------------
                %--------------------------------------------------------------------------



                cd([filename,'Mouse029/20120207'])
                load behavResources
                load SpikeData
                NeuronNum=12;
                SessionPlaceCells=[1 2];

                EpochCtrl=intervalSet(tpsdeb{1}*1E4,tpsfin{2}*1E4);
                EpochSleep=intervalSet(tpsdeb{8}*1E4,tpsfin{13}*1E4);


                for a=1:length(S)

                    param1=20;param2=200;
                    [Cwa,Bwa]=CrossCorr(Range(Restrict(S{NeuronNum},EpochCtrl)),Range(Restrict(S{a},EpochCtrl)),param1,param2); 
                   % figure('color',[1 1 1]), hold on, bar(Bwa,Cwa,1,'k'), yl=ylim; line([0 0],yl,'color','r'), xlim([-param1*param2/2 param1*param2/2]), title(['CrossCorrelogram Wake ', cellnames{NeuronNum}, ' vs. ', cellnames{a}])

                   % PlaceField(Restrict(S{a},EpochCtrl), Restrict(X,EpochCtrl),Restrict(Y,EpochCtrl));
                    %PlaceField(Restrict(S{NeuronNum},EpochCtrl), Restrict(X,EpochCtrl),Restrict(Y,EpochCtrl));



                    param1=5;param2=100;
                    [Csl,Bsl]=CrossCorr(Range(Restrict(S{NeuronNum},EpochSleep)),Range(Restrict(S{a},EpochSleep)),param1,param2); 
                  %  figure('color',[1 1 1]), hold on, bar(Bsl,Csl,1,'k'), yl=ylim; line([0 0],yl,'color','r'), xlim([-param1*param2/2 param1*param2/2]), title(['CrossCorrelogram Sleep ', cellnames{NeuronNum}, ' vs. ', cellnames{a}])

                    CrSl(b,1)=mean(Csl([[1:20],[80:100]]));
                    CrSl(b,2)=mean(Csl([40:60]));
                    CrSl(b,3)=a;

                    Crwa(b,1)=mean(Cwa([[1:50],[150:200]]));
                    Crwa(b,2)=mean(Cwa([98:102]));
                    Crwa(b,3)=a;

                    b=b+1;

                    close all

                end

                %--------------------------------------------------------------------------
                %--------------------------------------------------------------------------
                %--------------------------------------------------------------------------



                cd([filename,'Mouse035/20120515'])
                load behavResources
                load stimMFB
                load SpikeData


                NeuronNum=23;
                SessionPlaceCells=[3 4];

                EpochCtrl=intervalSet(tpsdeb{3}*1E4,tpsfin{4}*1E4);
                %EpochSleep=intervalSet(tpsdeb{4}*1E4,tpsfin{5}*1E4);
                EpochSleep=intervalSet(tpsdeb{7}*1E4,tpsfin{9}*1E4);

                for a=1:length(S)

                    param1=20;param2=200;
                    [Cwa,Bwa]=CrossCorr(Range(Restrict(S{NeuronNum},EpochCtrl)),Range(Restrict(S{a},EpochCtrl)),param1,param2); 
                   % figure('color',[1 1 1]), hold on, bar(Bwa,Cwa,1,'k'), yl=ylim; line([0 0],yl,'color','r'), xlim([-param1*param2/2 param1*param2/2]), title(['CrossCorrelogram Wake ', cellnames{NeuronNum}, ' vs. ', cellnames{a}])

                   % PlaceField(Restrict(S{a},EpochCtrl), Restrict(X,EpochCtrl),Restrict(Y,EpochCtrl));
                   % PlaceField(Restrict(S{NeuronNum},EpochCtrl), Restrict(X,EpochCtrl),Restrict(Y,EpochCtrl));



                    param1=5;param2=100;
                    [Csl,Bsl]=CrossCorr(Range(Restrict(S{NeuronNum},EpochSleep)),Range(Restrict(S{a},EpochSleep)),param1,param2); 
                   % figure('color',[1 1 1]), hold on, bar(Bsl,Csl,1,'k'), yl=ylim; line([0 0],yl,'color','r'), xlim([-param1*param2/2 param1*param2/2]), title(['CrossCorrelogram Sleep ', cellnames{NeuronNum}, ' vs. ', cellnames{a}])

                    CrSl(b,1)=mean(Csl([[1:20],[80:100]]));
                    CrSl(b,2)=mean(Csl([40:60]));
                    CrSl(b,3)=a;

                    Crwa(b,1)=mean(Cwa([[1:50],[150:200]]));
                    Crwa(b,2)=mean(Cwa([98:102]));
                    Crwa(b,3)=a;

                    b=b+1;

                    close all

                end


                %--------------------------------------------------------------------------
                %--------------------------------------------------------------------------
                %--------------------------------------------------------------------------




                cd([filename,'Mouse042/20120801'])
                load behavResources
                load stimMFB
                load SpikeData


                NeuronNum=12;
                SessionPlaceCells=[4 12];


                EpochCtrl1=intervalSet(tpsdeb{4}*1E4,tpsfin{4}*1E4);
                EpochCtrl2=intervalSet(tpsdeb{12}*1E4,tpsfin{12}*1E4);
                EpochCtrl=or(EpochCtrl1,EpochCtrl2);

                EpochSleep=intervalSet(tpsdeb{6}*1E4,tpsfin{10}*1E4);



                for a=1:length(S)

                    param1=20;param2=200;
                    [Cwa,Bwa]=CrossCorr(Range(Restrict(S{NeuronNum},EpochCtrl)),Range(Restrict(S{a},EpochCtrl)),param1,param2); 
                   % figure('color',[1 1 1]), hold on, bar(Bwa,Cwa,1,'k'), yl=ylim; line([0 0],yl,'color','r'), xlim([-param1*param2/2 param1*param2/2]), title(['CrossCorrelogram Wake ', cellnames{NeuronNum}, ' vs. ', cellnames{a}])

                    %PlaceField(Restrict(S{a},EpochCtrl), Restrict(X,EpochCtrl),Restrict(Y,EpochCtrl));
                    %PlaceField(Restrict(S{NeuronNum},EpochCtrl), Restrict(X,EpochCtrl),Restrict(Y,EpochCtrl));



                    param1=5;param2=100;
                    [Csl,Bsl]=CrossCorr(Range(Restrict(S{NeuronNum},EpochSleep)),Range(Restrict(S{a},EpochSleep)),param1,param2); 
                   % figure('color',[1 1 1]), hold on, bar(Bsl,Csl,1,'k'), yl=ylim; line([0 0],yl,'color','r'), xlim([-param1*param2/2 param1*param2/2]), title(['CrossCorrelogram Sleep ', cellnames{NeuronNum}, ' vs. ', cellnames{a}])

                    CrSl(b,1)=mean(Csl([[1:20],[80:100]]));
                    CrSl(b,2)=mean(Csl([40:60]));
                    CrSl(b,3)=a;

                    Crwa(b,1)=mean(Cwa([[1:50],[150:200]]));
                    Crwa(b,2)=mean(Cwa([98:102]));
                    Crwa(b,3)=a;

                    b=b+1;

                    close all

                end



                %--------------------------------------------------------------------------
                %--------------------------------------------------------------------------
                %--------------------------------------------------------------------------


end



figure('color',[1 1 1]), plot((Crwa(:,2)-Crwa(:,1))./Crwa(:,2),(CrSl(:,2)-CrSl(:,1))./CrSl(:,2),'ko','markerfacecolor','k')
hold on, line([-0.5 1.2],[-0.5 1.2],'color','r','linewidth',2), xlim([-0.5 1.2]), ylim([-0.5 1.2])
ylabel('Correlation during Sleep')
xlabel('Correlation during Wake')

end

%--------------------------------------------------------------------------
%--------------------------------------------------------------------------
%--------------------------------------------------------------------------



filename='/Users/karimbenchenane/Documents/Data/DataEnCours/ManipesICSSok/Data/';
        cd([filename,'Mouse035/20120515'])
        load behavResources
        load stimMFB
        load SpikeData


        NeuronNum=23;
        SessionPlaceCells=[3 4];

        EpochCtrl=intervalSet(tpsdeb{3}*1E4,tpsfin{4}*1E4);
        %EpochSleep=intervalSet(tpsdeb{4}*1E4,tpsfin{5}*1E4);
        EpochSleep=intervalSet(tpsdeb{7}*1E4,tpsfin{9}*1E4);

        MatrixClusters(S,[5,10,23])
        MatrixClusters(Restrict(S,EpochCtrl),[5,10,23])
        
a=10;
% smo=10;
% param1=20;param2=200;
% [Cwa,Bwa]=CrossCorr(Range(Restrict(S{NeuronNum},EpochCtrl)),Range(Restrict(S{a},EpochCtrl)),param1,param2);%plot(Bwa,Cwa','k','linewidth',2), yl=ylim; line([0 0],yl,'color','r')
% [Csl,Bsl]=CrossCorr(Range(Restrict(S{NeuronNum},EpochSleep)),Range(Restrict(S{a},EpochSleep)),param1,param2); %figure, plot(Bsl,Csl','k','linewidth',2), yl=ylim; line([0 0],yl,'color','r')
% figure('color',[1 1 1]),  plot(Bwa,smooth(Cwa,smo)','k','linewidth',2), yl=ylim; line([0 0],yl,'color','r'), title('wake')
% figure('color',[1 1 1]),  plot(Bsl,smooth(Csl,smo)','k','linewidth',2), yl=ylim; line([0 0],yl,'color','r'), title('sleep')
% figure('color',[1 1 1]),  bar(Bwa,smooth(Cwa,smo),1,'k'), yl=ylim; line([0 0],yl,'color','r'), title('wake')
% figure('color',[1 1 1]),  bar(Bsl,smooth(Csl,smo),1,'k'), yl=ylim; line([0 0],yl,'color','r'), title('sleep')
% 
% smo=5;
% [Cwa,Bwa]=CrossCorr(Range(Restrict(S{NeuronNum},EpochCtrl)),Range(Restrict(S{a},EpochCtrl)),param1,param2);%plot(Bwa,Cwa','k','linewidth',2), yl=ylim; line([0 0],yl,'color','r')
% [Csl,Bsl]=CrossCorr(Range(Restrict(S{NeuronNum},EpochSleep)),Range(Restrict(S{a},EpochSleep)),param1,param2); %figure, plot(Bsl,Csl','k','linewidth',2), yl=ylim; line([0 0],yl,'color','r')
% figure('color',[1 1 1]),  plot(Bwa,smooth(Cwa,smo)','k','linewidth',2), yl=ylim; line([0 0],yl,'color','r'), title('wake')
% figure('color',[1 1 1]),  plot(Bsl,smooth(Csl,smo)','k','linewidth',2), yl=ylim; line([0 0],yl,'color','r'), title('sleep')
% figure('color',[1 1 1]),  bar(Bwa,smooth(Cwa,smo),1,'k'), yl=ylim; line([0 0],yl,'color','r'), title('wake')
% figure('color',[1 1 1]),  bar(Bsl,smooth(Csl,smo),1,'k'), yl=ylim; line([0 0],yl,'color','r'), title('sleep')

smo=10;
smo=2.5;
param1=5;param2=600;
[Cwa,Bwa]=CrossCorr(Range(Restrict(S{NeuronNum},EpochCtrl)),Range(Restrict(S{a},EpochCtrl)),param1,param2);%plot(Bwa,Cwa','k','linewidth',2), yl=ylim; line([0 0],yl,'color','r')
[Csl,Bsl]=CrossCorr(Range(Restrict(S{NeuronNum},EpochSleep)),Range(Restrict(S{a},EpochSleep)),param1,param2); %figure, plot(Bsl,Csl','k','linewidth',2), yl=ylim; line([0 0],yl,'color','r')
%figure('color',[1 1 1]),  plot(Bwa,smooth(Cwa,smo)','k','linewidth',2), yl=ylim; line([0 0],yl,'color','r'), title('wake')
%figure('color',[1 1 1]),  plot(Bsl,smooth(Csl,smo)','k','linewidth',2), yl=ylim; line([0 0],yl,'color','r'), title('sleep')
figure('color',[1 1 1]),  bar(Bwa,smooth(Cwa,smo),1,'k'), yl=ylim; line([0 0],yl,'color','r'), title('wake'), xlim([-430 430])
Crtsd=tsd(Bwa*10,smooth(Cwa,smo));
Fil=FilterLFP(Crtsd,[0.0001 11],96);
hold on, plot(Range(Fil,'ms'),Data(Fil),'g','linewidth',2)
figure('color',[1 1 1]),  bar(Bsl,smooth(Csl,smo),1,'k'), yl=ylim; line([0 0],yl,'color','r'), title('sleep'), xlim([-430 430])

smo=5;
param1=5;param2=600;
[Cwa,Bwa]=CrossCorr(Range(Restrict(S{NeuronNum},EpochCtrl)),Range(Restrict(S{a},EpochCtrl)),param1,param2);%plot(Bwa,Cwa','k','linewidth',2), yl=ylim; line([0 0],yl,'color','r')
[Csl,Bsl]=CrossCorr(Range(Restrict(S{NeuronNum},EpochSleep)),Range(Restrict(S{a},EpochSleep)),param1,param2); %figure, plot(Bsl,Csl','k','linewidth',2), yl=ylim; line([0 0],yl,'color','r')
%figure('color',[1 1 1]),  plot(Bwa,smooth(Cwa,smo)','k','linewidth',2), yl=ylim; line([0 0],yl,'color','r'), title('wake')
%figure('color',[1 1 1]),  plot(Bsl,smooth(Csl,smo)','k','linewidth',2), yl=ylim; line([0 0],yl,'color','r'), title('sleep')
figure('color',[1 1 1]),  bar(Bwa,smooth(Cwa,smo),1,'k'), yl=ylim; line([0 0],yl,'color','r'), title('wake'), xlim([-430 430])
Crtsd=tsd(Bwa*10,smooth(Cwa,smo));
Fil=FilterLFP(Crtsd,[0.0001 11],96);
hold on, plot(Range(Fil,'ms'),Data(Fil),'g','linewidth',2)
figure('color',[1 1 1]),  bar(Bsl,smooth(Csl,smo),1,'k'), yl=ylim; line([0 0],yl,'color','r'), title('sleep'), xlim([-430 430])


map=PlaceField(Restrict(S{NeuronNum},EpochCtrl), Restrict(X,EpochCtrl),Restrict(Y,EpochCtrl));close
map2=PlaceField(Restrict(S{a},EpochCtrl), Restrict(X,EpochCtrl),Restrict(Y,EpochCtrl));close
figure('color',[1 1 1]), imagesc(map2.rate), axis xy, colorbar
figure('color',[1 1 1]), imagesc(map.rate), axis xy, colorbar


      
a=5;

% 
% smo=10;
% param1=20;param2=200;
% [Cwa,Bwa]=CrossCorr(Range(Restrict(S{NeuronNum},EpochCtrl)),Range(Restrict(S{a},EpochCtrl)),param1,param2);%plot(Bwa,Cwa','k','linewidth',2), yl=ylim; line([0 0],yl,'color','r')
% [Csl,Bsl]=CrossCorr(Range(Restrict(S{NeuronNum},EpochSleep)),Range(Restrict(S{a},EpochSleep)),param1,param2); %figure, plot(Bsl,Csl','k','linewidth',2), yl=ylim; line([0 0],yl,'color','r')
% figure('color',[1 1 1]),  plot(Bwa,smooth(Cwa,smo)','k','linewidth',2), yl=ylim; line([0 0],yl,'color','r'), title('wake'), xlim([-430 430])
% figure('color',[1 1 1]),  plot(Bsl,smooth(Csl,smo)','k','linewidth',2), yl=ylim; line([0 0],yl,'color','r'), title('sleep'), xlim([-430 430])
% figure('color',[1 1 1]),  bar(Bwa,smooth(Cwa,smo),1,'k'), yl=ylim; line([0 0],yl,'color','r'), title('wake'), xlim([-430 430])
% figure('color',[1 1 1]),  bar(Bsl,smooth(Csl,smo),1,'k'), yl=ylim; line([0 0],yl,'color','r'), title('sleep'), xlim([-430 430])
% 
% smo=5;
% [Cwa,Bwa]=CrossCorr(Range(Restrict(S{NeuronNum},EpochCtrl)),Range(Restrict(S{a},EpochCtrl)),param1,param2);%plot(Bwa,Cwa','k','linewidth',2), yl=ylim; line([0 0],yl,'color','r')
% [Csl,Bsl]=CrossCorr(Range(Restrict(S{NeuronNum},EpochSleep)),Range(Restrict(S{a},EpochSleep)),param1,param2); %figure, plot(Bsl,Csl','k','linewidth',2), yl=ylim; line([0 0],yl,'color','r')
% figure('color',[1 1 1]),  plot(Bwa,smooth(Cwa,smo)','k','linewidth',2), yl=ylim; line([0 0],yl,'color','r'), title('wake'), xlim([-430 430])
% figure('color',[1 1 1]),  plot(Bsl,smooth(Csl,smo)','k','linewidth',2), yl=ylim; line([0 0],yl,'color','r'), title('sleep'), xlim([-430 430])
% figure('color',[1 1 1]),  bar(Bwa,smooth(Cwa,smo),1,'k'), yl=ylim; line([0 0],yl,'color','r'), title('wake'), xlim([-430 430])
% figure('color',[1 1 1]),  bar(Bsl,smooth(Csl,smo),1,'k'), yl=ylim; line([0 0],yl,'color','r'), title('sleep'), xlim([-430 430])

smo=10;
param1=5;param2=600;
[Cwa,Bwa]=CrossCorr(Range(Restrict(S{NeuronNum},EpochCtrl)),Range(Restrict(S{a},EpochCtrl)),param1,param2);%plot(Bwa,Cwa','k','linewidth',2), yl=ylim; line([0 0],yl,'color','r')
[Csl,Bsl]=CrossCorr(Range(Restrict(S{NeuronNum},EpochSleep)),Range(Restrict(S{a},EpochSleep)),param1,param2); %figure, plot(Bsl,Csl','k','linewidth',2), yl=ylim; line([0 0],yl,'color','r')
%figure('color',[1 1 1]),  plot(Bwa,smooth(Cwa,smo)','k','linewidth',2), yl=ylim; line([0 0],yl,'color','r'), title('wake'), xlim([-430 430])
%figure('color',[1 1 1]),  plot(Bsl,smooth(Csl,smo)','k','linewidth',2), yl=ylim; line([0 0],yl,'color','r'), title('sleep'), xlim([-430 430])
figure('color',[1 1 1]),  bar(Bwa,smooth(Cwa,smo),1,'k'), yl=ylim; line([0 0],yl,'color','r'), title('wake'), xlim([-430 430])
figure('color',[1 1 1]),  bar(Bsl,smooth(Csl,smo),1,'k'), yl=ylim; line([0 0],yl,'color','r'), title('sleep'), xlim([-430 430])

smo=5;
[Cwa,Bwa]=CrossCorr(Range(Restrict(S{NeuronNum},EpochCtrl)),Range(Restrict(S{a},EpochCtrl)),param1,param2);%plot(Bwa,Cwa','k','linewidth',2), yl=ylim; line([0 0],yl,'color','r')
[Csl,Bsl]=CrossCorr(Range(Restrict(S{NeuronNum},EpochSleep)),Range(Restrict(S{a},EpochSleep)),param1,param2); %figure, plot(Bsl,Csl','k','linewidth',2), yl=ylim; line([0 0],yl,'color','r')
%figure('color',[1 1 1]),  plot(Bwa,smooth(Cwa,smo)','k','linewidth',2), yl=ylim; line([0 0],yl,'color','r'), title('wake'), xlim([-430 430])
%figure('color',[1 1 1]),  plot(Bsl,smooth(Csl,smo)','k','linewidth',2), yl=ylim; line([0 0],yl,'color','r'), title('sleep'), xlim([-430 430])
figure('color',[1 1 1]),  bar(Bwa,smooth(Cwa,smo),1,'k'), yl=ylim; line([0 0],yl,'color','r'), title('wake'), xlim([-430 430])
Crtsd=tsd(Bwa*10,smooth(Cwa,smo));
Fil=FilterLFP(Crtsd,[0.0001 11],96);
hold on, plot(Range(Fil,'ms'),Data(Fil),'g','linewidth',2)
figure('color',[1 1 1]),  bar(Bsl,smooth(Csl,smo),1,'k'), yl=ylim; line([0 0],yl,'color','r'), title('sleep'), xlim([-430 430])


map=PlaceField(Restrict(S{NeuronNum},EpochCtrl), Restrict(X,EpochCtrl),Restrict(Y,EpochCtrl));close
map2=PlaceField(Restrict(S{a},EpochCtrl), Restrict(X,EpochCtrl),Restrict(Y,EpochCtrl));close
figure('color',[1 1 1]), imagesc(map2.rate), axis xy, colorbar
figure('color',[1 1 1]), imagesc(map.rate), axis xy, colorbar




%--------------------------------------------------------------------------
%--------------------------------------------------------------------------
%--------------------------------------------------------------------------

filename='/Users/karimbenchenane/Documents/Data/DataEnCours/ManipesICSSok/Data/';
cd([filename,'Mouse029/20120207'])
        load behavResources
        load SpikeData
        NeuronNum=12;
        SessionPlaceCells=[1 2];

        EpochCtrl=intervalSet(tpsdeb{1}*1E4,tpsfin{2}*1E4);
        EpochSleep=intervalSet(tpsdeb{8}*1E4,tpsfin{13}*1E4);
        
        
        a=8;
        
smo=10;
param1=5;param2=600;
[Cwa,Bwa]=CrossCorr(Range(Restrict(S{NeuronNum},EpochCtrl)),Range(Restrict(S{a},EpochCtrl)),param1,param2);%plot(Bwa,Cwa','k','linewidth',2), yl=ylim; line([0 0],yl,'color','r')
[Csl,Bsl]=CrossCorr(Range(Restrict(S{NeuronNum},EpochSleep)),Range(Restrict(S{a},EpochSleep)),param1,param2); %figure, plot(Bsl,Csl','k','linewidth',2), yl=ylim; line([0 0],yl,'color','r')
%figure('color',[1 1 1]),  plot(Bwa,smooth(Cwa,smo)','k','linewidth',2), yl=ylim; line([0 0],yl,'color','r'), title('wake'), xlim([-430 430])
%figure('color',[1 1 1]),  plot(Bsl,smooth(Csl,smo)','k','linewidth',2), yl=ylim; line([0 0],yl,'color','r'), title('sleep'), xlim([-430 430])
figure('color',[1 1 1]),  bar(Bwa,smooth(Cwa,smo),1,'k'), yl=ylim; line([0 0],yl,'color','r'), title('wake'), xlim([-430 430])
Crtsd=tsd(Bwa*10,smooth(Cwa,smo));
Fil=FilterLFP(Crtsd,[0.0001 11],96);
hold on, plot(Range(Fil,'ms'),Data(Fil),'g','linewidth',2)
figure('color',[1 1 1]),  bar(Bsl,smooth(Csl,smo),1,'k'), yl=ylim; line([0 0],yl,'color','r'), title('sleep'), xlim([-430 430])

smo=5;
[Cwa,Bwa]=CrossCorr(Range(Restrict(S{NeuronNum},EpochCtrl)),Range(Restrict(S{a},EpochCtrl)),param1,param2);%plot(Bwa,Cwa','k','linewidth',2), yl=ylim; line([0 0],yl,'color','r')
[Csl,Bsl]=CrossCorr(Range(Restrict(S{NeuronNum},EpochSleep)),Range(Restrict(S{a},EpochSleep)),param1,param2); %figure, plot(Bsl,Csl','k','linewidth',2), yl=ylim; line([0 0],yl,'color','r')
%figure('color',[1 1 1]),  plot(Bwa,smooth(Cwa,smo)','k','linewidth',2), yl=ylim; line([0 0],yl,'color','r'), title('wake'), xlim([-430 430])
%figure('color',[1 1 1]),  plot(Bsl,smooth(Csl,smo)','k','linewidth',2), yl=ylim; line([0 0],yl,'color','r'), title('sleep'), xlim([-430 430])
figure('color',[1 1 1]),  bar(Bwa,smooth(Cwa,smo),1,'k'), yl=ylim; line([0 0],yl,'color','r'), title('wake'), xlim([-430 430])
Crtsd=tsd(Bwa*10,smooth(Cwa,smo));
Fil=FilterLFP(Crtsd,[0.0001 11],96);
hold on, plot(Range(Fil,'ms'),Data(Fil),'g','linewidth',2)

figure('color',[1 1 1]),  bar(Bsl,smooth(Csl,smo),1,'k'), yl=ylim; line([0 0],yl,'color','r'), title('sleep'), xlim([-430 430])


map=PlaceField(Restrict(S{NeuronNum},EpochCtrl), Restrict(X,EpochCtrl),Restrict(Y,EpochCtrl));close
map2=PlaceField(Restrict(S{a},EpochCtrl), Restrict(X,EpochCtrl),Restrict(Y,EpochCtrl));close
figure('color',[1 1 1]), imagesc(map2.rate), axis xy, colorbar
figure('color',[1 1 1]), imagesc(map.rate), axis xy, colorbar

        a=9;

smo=10;
param1=5;param2=600;
[Cwa,Bwa]=CrossCorr(Range(Restrict(S{NeuronNum},EpochCtrl)),Range(Restrict(S{a},EpochCtrl)),param1,param2);%plot(Bwa,Cwa','k','linewidth',2), yl=ylim; line([0 0],yl,'color','r')
[Csl,Bsl]=CrossCorr(Range(Restrict(S{NeuronNum},EpochSleep)),Range(Restrict(S{a},EpochSleep)),param1,param2); %figure, plot(Bsl,Csl','k','linewidth',2), yl=ylim; line([0 0],yl,'color','r')
%figure('color',[1 1 1]),  plot(Bwa,smooth(Cwa,smo)','k','linewidth',2), yl=ylim; line([0 0],yl,'color','r'), title('wake'), xlim([-430 430])
%figure('color',[1 1 1]),  plot(Bsl,smooth(Csl,smo)','k','linewidth',2), yl=ylim; line([0 0],yl,'color','r'), title('sleep'), xlim([-430 430])
figure('color',[1 1 1]),  bar(Bwa,smooth(Cwa,smo),1,'k'), yl=ylim; line([0 0],yl,'color','r'), title('wake'), xlim([-430 430])
Crtsd=tsd(Bwa*10,smooth(Cwa,smo));
Fil=FilterLFP(Crtsd,[0.0001 11],96);
hold on, plot(Range(Fil,'ms'),Data(Fil),'g','linewidth',2)
figure('color',[1 1 1]),  bar(Bsl,smooth(Csl,smo),1,'k'), yl=ylim; line([0 0],yl,'color','r'), title('sleep'), xlim([-430 430])

smo=5;
[Cwa,Bwa]=CrossCorr(Range(Restrict(S{NeuronNum},EpochCtrl)),Range(Restrict(S{a},EpochCtrl)),param1,param2);%plot(Bwa,Cwa','k','linewidth',2), yl=ylim; line([0 0],yl,'color','r')
[Csl,Bsl]=CrossCorr(Range(Restrict(S{NeuronNum},EpochSleep)),Range(Restrict(S{a},EpochSleep)),param1,param2); %figure, plot(Bsl,Csl','k','linewidth',2), yl=ylim; line([0 0],yl,'color','r')
%figure('color',[1 1 1]),  plot(Bwa,smooth(Cwa,smo)','k','linewidth',2), yl=ylim; line([0 0],yl,'color','r'), title('wake'), xlim([-430 430])
%figure('color',[1 1 1]),  plot(Bsl,smooth(Csl,smo)','k','linewidth',2), yl=ylim; line([0 0],yl,'color','r'), title('sleep'), xlim([-430 430])
figure('color',[1 1 1]),  bar(Bwa,smooth(Cwa,smo),1,'k'), yl=ylim; line([0 0],yl,'color','r'), title('wake'), xlim([-430 430])
Crtsd=tsd(Bwa*10,smooth(Cwa,smo));
Fil=FilterLFP(Crtsd,[0.0001 11],96);
hold on, plot(Range(Fil,'ms'),Data(Fil),'g','linewidth',2)
figure('color',[1 1 1]),  bar(Bsl,smooth(Csl,smo),1,'k'), yl=ylim; line([0 0],yl,'color','r'), title('sleep'), xlim([-430 430])


map=PlaceField(Restrict(S{NeuronNum},EpochCtrl), Restrict(X,EpochCtrl),Restrict(Y,EpochCtrl));close
map2=PlaceField(Restrict(S{a},EpochCtrl), Restrict(X,EpochCtrl),Restrict(Y,EpochCtrl));close
figure('color',[1 1 1]), imagesc(map2.rate), axis xy, colorbar
figure('color',[1 1 1]), imagesc(map.rate), axis xy, colorbar

MatrixClusters(S,[12,8,9])

if 0
    
load Waveforms
wfo=PlotWaveforms(W,9,EpochCtrl);
wfo8=PlotWaveforms(W,8,EpochCtrl);
wfo12=PlotWaveforms(W,12,EpochCtrl);

figure('color',[1 1 1]),
for i=1:5
subplot(5,1,i), hold on
plot(mean(squeeze(wfo8(:,i,:))),'k','linewidth',2)
hold on, plot(mean(squeeze(wfo(:,i,:))),'b','linewidth',2)
hold on, plot(mean(squeeze(wfo12(:,i,:))),'r','linewidth',2)
end



figure('color',[1 1 1]),
for i=1:5
subplot(4,5,i), hold on
plot(mean(squeeze(wfo8(:,i,:))),'k','linewidth',2), ylim([-3000 1000])
end

for i=6:10
subplot(4,5,i), hold on
plot(mean(squeeze(wfo(:,i-5,:))),'b','linewidth',2), ylim([-3000 1000])
end

for i=11:15
subplot(4,5,i), hold on
plot(mean(squeeze(wfo12(:,i-10,:))),'r','linewidth',2), ylim([-3000 1000])
end

for i=16:20
subplot(4,5,i), hold on
hold on, plot(mean(squeeze(wfo12(:,i-15,:))),'r','linewidth',2)%, ylim([-3000 1000])
plot(mean(squeeze(wfo8(:,i-15,:))),'k','linewidth',2)%, ylim([-3000 1000])
hold on, plot(mean(squeeze(wfo(:,i-15,:))),'b','linewidth',2)%, ylim([-3000 1000])

end


end



%--------------------------------------------------------------------------
%--------------------------------------------------------------------------
%--------------------------------------------------------------------------




% 
% 
% sleep
% 
% cd([filename,'Mouse026/20120109'])
% load SpikeData
% load behavResources
% load StimMFB
% load Celltypes
% 
% PlaceCellTrig=6; 
% listneurones=[[8:16],[18,19 21,23,24]];
% nchannelSpk=1;
% 
% 
% 
% 
% cd([filename,'Mouse029/20120207'])
% load SpikeData
% load behavResources
% load StimMFB
% load Celltypes
% 
% PlaceCellTrig=12; 
% listneurones=[29:41];
% nchannelSpk=4;
% 
% 
% 
% 
% cd([filename,'Mouse035/20120515'])
% load SpikeData
% load behavResources
% load StimMFB
% load Celltypes
% 
% PlaceCellTrig=23; 
% listneurones=[2:17];
% nchannelSpk=3;
% 
% 
% 
% 
% 
% cd([filename,'Mouse042/20120801'])
% load SpikeData
% load behavResources
% load StimMFB
% load Celltypes
% PlaceCellTrig=12; 
% listneurones=[2:5];
% nchannelSpk=6;
