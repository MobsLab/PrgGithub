%ParvCode3

SWSleep=0;

if SWSleep
   
    te='SWS';
else
    te='Theta';
end

sav=1;






try
    
            if SWSleep

            load DataSWSSkull
            else
            load DataThetaSkull

            end
            ca1=0.1;
            ca2=1;

        figure('color',[1 1 1]),
        subplot(1,3,1), imagesc(Ra)
        subplot(1,3,2), imagesc(R2a),title([te,', Frequency : ', num2str([1 4]), ' Hz'])
        subplot(1,3,3), imagesc(Ra-R2a)
        subplot(1,3,1), caxis([-ca1 ca2])
        subplot(1,3,2), caxis([-ca1 ca2])
        subplot(1,3,3), caxis([-ca1 ca2])


        figure('color',[1 1 1]),
        subplot(1,3,1), imagesc(Rb)
        subplot(1,3,2), imagesc(R2b),title([te,', Frequency : ', num2str([10 15]), ' Hz'])
        subplot(1,3,3), imagesc(Rb-R2b)
        subplot(1,3,1), caxis([-ca1 ca2])
        subplot(1,3,2), caxis([-ca1 ca2])
        subplot(1,3,3), caxis([-ca1 ca2])

        figure('color',[1 1 1]),
        subplot(1,3,1), imagesc(Rc)
        subplot(1,3,2), imagesc(R2c),title([te,', Frequency : ', num2str([20 40]), ' Hz'])
        subplot(1,3,3), imagesc(Rc-R2c)
        subplot(1,3,1), caxis([-ca1 ca2])
        subplot(1,3,2), caxis([-ca1 ca2])
        subplot(1,3,3), caxis([-ca1 ca2])

        figure('color',[1 1 1]),
        subplot(1,3,1), imagesc(Rd)
        subplot(1,3,2), imagesc(R2d),title([te,', Frequency : ', num2str([60 90]), ' Hz'])
        subplot(1,3,3), imagesc(Rd-R2d)
        subplot(1,3,1), caxis([-ca1 ca2])
        subplot(1,3,2), caxis([-ca1 ca2])
        subplot(1,3,3), caxis([-ca1 ca2])

        figure('color',[1 1 1]),
        subplot(1,3,1), imagesc(Re)
        subplot(1,3,2), imagesc(R2e),title([te,', Frequency : ', num2str([130 200]), ' Hz'])
        subplot(1,3,3), imagesc(Re-R2e)
        subplot(1,3,1), caxis([-ca1 ca2])
        subplot(1,3,2), caxis([-ca1 ca2])
        subplot(1,3,3), caxis([-ca1 ca2])

        figure('color',[1 1 1]),
        subplot(1,3,1), imagesc(Rf)
        subplot(1,3,2), imagesc(R2f),title([te,', Frequency : ', num2str([5 10]), ' Hz'])
        subplot(1,3,3), imagesc(Rf-R2f)
        subplot(1,3,1), caxis([-ca1 ca2])
        subplot(1,3,2), caxis([-ca1 ca2])
        subplot(1,3,3), caxis([-ca1 ca2])

    
catch
    

            clear R
            clear R2

            FilterParam=[1 4];

            a=10;b=15;
            for i=1:15
            for j=i:15
            r=ParvCode2(i,j,FilterParam,0.3,0.7);close
            R(i,j)=r(1);
            R2(i,j)=r(2);
            end
            end

            R=R+R';
            R2=R2+R2';

            Ra=R-diag(diag(R));
            R2a=R2-diag(diag(R2));

            for i=1:15
            Ra(i,i)=1;
            R2a(i,i)=1;
            end

            figure('color',[1 1 1]),
            subplot(1,3,1), imagesc(Ra)
            subplot(1,3,2), imagesc(R2a),title(['Frequency : ', num2str(FilterParam), ' Hz'])
            subplot(1,3,3), imagesc(Ra-R2a)


            clear R
            clear R2


            FilterParam=[10 15];

            a=10;b=15;
            for i=1:15
            for j=i:15
            r=ParvCode2(i,j,FilterParam,0.3,0.7);close
            R(i,j)=r(1);
            R2(i,j)=r(2);
            end
            end
            R=R+R';
            R2=R2+R2';

            Rb=R-diag(diag(R));
            R2b=R2-diag(diag(R2));

            for i=1:15
            Rb(i,i)=1;
            R2b(i,i)=1;
            end

            figure('color',[1 1 1]),
            subplot(1,3,1), imagesc(Rb)
            subplot(1,3,2), imagesc(R2b),title(['Frequency : ', num2str(FilterParam), ' Hz'])
            subplot(1,3,3), imagesc(Rb-R2b)



            clear R
            clear R2


            FilterParam=[20 40];

            a=10;b=15;
            for i=1:15
            for j=i:15
            r=ParvCode2(i,j,FilterParam,0.3,0.7);close
            R(i,j)=r(1);
            R2(i,j)=r(2);
            end
            end
            R=R+R';
            R2=R2+R2';

            Rc=R-diag(diag(R));
            R2c=R2-diag(diag(R2));

            for i=1:15
            Rc(i,i)=1;
            R2c(i,i)=1;
            end

            figure('color',[1 1 1]),
            subplot(1,3,1), imagesc(Rc)
            subplot(1,3,2), imagesc(R2c),title(['Frequency : ', num2str(FilterParam), ' Hz'])
            subplot(1,3,3), imagesc(Rc-R2c)


            clear R
            clear R2

            FilterParam=[60 90];

            a=10;b=15;
            for i=1:15
            for j=i:15
            r=ParvCode2(i,j,FilterParam,0.3,0.7);close
            R(i,j)=r(1);
            R2(i,j)=r(2);
            end
            end
            R=R+R';
            R2=R2+R2';

            Rd=R-diag(diag(R));
            R2d=R2-diag(diag(R2));

            for i=1:15
            Rd(i,i)=1;
            R2d(i,i)=1;
            end

            figure('color',[1 1 1]),
            subplot(1,3,1), imagesc(Rd)
            subplot(1,3,2), imagesc(R2d),title(['Frequency : ', num2str(FilterParam), ' Hz'])
            subplot(1,3,3), imagesc(Rd-R2d)

            clear R
            clear R2


            FilterParam=[130 200];
            a=10;b=15;
            for i=1:15
            for j=i:15
            r=ParvCode2(i,j,FilterParam,0.3,0.7);close
            R(i,j)=r(1);
            R2(i,j)=r(2);
            end
            end
            R=R+R';
            R2=R2+R2';

            Re=R-diag(diag(R));
            R2e=R2-diag(diag(R2));

            for i=1:15
            Re(i,i)=1;
            R2e(i,i)=1;
            end

            figure('color',[1 1 1]),
            subplot(1,3,1), imagesc(Re)
            subplot(1,3,2), imagesc(R2e),title(['Frequency : ', num2str(FilterParam), ' Hz'])
            subplot(1,3,3), imagesc(Re-R2e)





            clear R
            clear R2


            FilterParam=[5 10];
            a=10;b=15;
            for i=1:15
            for j=i:15
            r=ParvCode2(i,j,FilterParam,0.3,0.7);close
            R(i,j)=r(1);
            R2(i,j)=r(2);
            end
            end
            R=R+R';
            R2=R2+R2';

            Rf=R-diag(diag(R));
            R2f=R2-diag(diag(R2));

            for i=1:15
            Rf(i,i)=1;
            R2f(i,i)=1;
            end

            figure('color',[1 1 1]),
            subplot(1,3,1), imagesc(Rf)
            subplot(1,3,2), imagesc(R2f),title(['Frequency : ', num2str(FilterParam), ' Hz'])
            subplot(1,3,3), imagesc(Rf-R2f)






end



if sav


if SWSleep


figure(1)
set(1,'Position',[10 477 1636 410])
subplot(1,3,1), caxis([-ca1 ca2]),colorbar
subplot(1,3,2), caxis([-ca1 ca2]),colorbar
subplot(1,3,3), caxis([-ca1 ca2]),colorbar
saveFigure(1,'CorrelationSkull1SWS','/Users/karimbenchenane/Documents/Data/DataEnCours/MiceSetUp/MMN/DataMMN')
figure(6)
set(6,'Position',[10 477 1636 410])
subplot(1,3,1), caxis([-ca1 ca2]),colorbar
subplot(1,3,2), caxis([-ca1 ca2]),colorbar
subplot(1,3,3), caxis([-ca1 ca2]),colorbar
saveFigure(6,'CorrelationSkull2SWS','/Users/karimbenchenane/Documents/Data/DataEnCours/MiceSetUp/MMN/DataMMN')
figure(2)
set(2,'Position',[10 477 1636 410])
subplot(1,3,1), caxis([-ca1 ca2]),colorbar
subplot(1,3,2), caxis([-ca1 ca2]),colorbar
subplot(1,3,3), caxis([-ca1 ca2]),colorbar
saveFigure(2,'CorrelationSkull3SWS','/Users/karimbenchenane/Documents/Data/DataEnCours/MiceSetUp/MMN/DataMMN')
figure(3)
set(3,'Position',[10 477 1636 410])
subplot(1,3,1), caxis([-ca1 ca2]),colorbar
subplot(1,3,2), caxis([-ca1 ca2]),colorbar
subplot(1,3,3), caxis([-ca1 ca2]),colorbar
saveFigure(3,'CorrelationSkull4SWS','/Users/karimbenchenane/Documents/Data/DataEnCours/MiceSetUp/MMN/DataMMN')
figure(4)
set(4,'Position',[10 477 1636 410])
subplot(1,3,1), caxis([-ca1 ca2]),colorbar
subplot(1,3,2), caxis([-ca1 ca2]),colorbar
subplot(1,3,3), caxis([-ca1 ca2]),colorbar
saveFigure(4,'CorrelationSkull5SWS','/Users/karimbenchenane/Documents/Data/DataEnCours/MiceSetUp/MMN/DataMMN')
figure(5)
set(5,'Position',[10 477 1636 410])
subplot(1,3,1), caxis([-ca1 ca2]),colorbar
subplot(1,3,2), caxis([-ca1 ca2]),colorbar
subplot(1,3,3), caxis([-ca1 ca2]),colorbar
saveFigure(5,'CorrelationSkull6SWS','/Users/karimbenchenane/Documents/Data/DataEnCours/MiceSetUp/MMN/DataMMN')

else
    

figure(1)
set(1,'Position',[10 477 1636 410])
subplot(1,3,1), caxis([-ca1 ca2]),colorbar
subplot(1,3,2), caxis([-ca1 ca2]),colorbar
subplot(1,3,3), caxis([-ca1 ca2]),colorbar
saveFigure(1,'CorrelationSkull1Theta','/Users/karimbenchenane/Documents/Data/DataEnCours/MiceSetUp/MMN/DataMMN')
figure(6)
set(6,'Position',[10 477 1636 410])
subplot(1,3,1), caxis([-ca1 ca2]),colorbar
subplot(1,3,2), caxis([-ca1 ca2]),colorbar
subplot(1,3,3), caxis([-ca1 ca2]),colorbar
saveFigure(6,'CorrelationSkull2Theta','/Users/karimbenchenane/Documents/Data/DataEnCours/MiceSetUp/MMN/DataMMN')
figure(2)
set(2,'Position',[10 477 1636 410])
subplot(1,3,1), caxis([-ca1 ca2]),colorbar
subplot(1,3,2), caxis([-ca1 ca2]),colorbar
subplot(1,3,3), caxis([-ca1 ca2]),colorbar
saveFigure(2,'CorrelationSkull3Theta','/Users/karimbenchenane/Documents/Data/DataEnCours/MiceSetUp/MMN/DataMMN')
figure(3)
set(3,'Position',[10 477 1636 410])
subplot(1,3,1), caxis([-ca1 ca2]),colorbar
subplot(1,3,2), caxis([-ca1 ca2]),colorbar
subplot(1,3,3), caxis([-ca1 ca2]),colorbar
saveFigure(3,'CorrelationSkull4Theta','/Users/karimbenchenane/Documents/Data/DataEnCours/MiceSetUp/MMN/DataMMN')
figure(4)
set(4,'Position',[10 477 1636 410])
subplot(1,3,1), caxis([-ca1 ca2]),colorbar
subplot(1,3,2), caxis([-ca1 ca2]),colorbar
subplot(1,3,3), caxis([-ca1 ca2]),colorbar
saveFigure(4,'CorrelationSkull5Theta','/Users/karimbenchenane/Documents/Data/DataEnCours/MiceSetUp/MMN/DataMMN')
figure(5)
set(5,'Position',[10 477 1636 410])
subplot(1,3,1), caxis([-ca1 ca2]),colorbar
subplot(1,3,2), caxis([-ca1 ca2]),colorbar
subplot(1,3,3), caxis([-ca1 ca2]),colorbar
saveFigure(5,'CorrelationSkull6Theta','/Users/karimbenchenane/Documents/Data/DataEnCours/MiceSetUp/MMN/DataMMN')
    
    
end
    
end

