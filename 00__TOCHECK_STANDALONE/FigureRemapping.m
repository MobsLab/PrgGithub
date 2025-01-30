
%FigureRemapping


if 1

        try
        filename1='/media/Drobo2/DataD2/ICSS-Sleep/Mouse017/20110624/Env2/ICSS-Mouse-17-24062011';
        filename2='/media/Drobo2/DataD2/ICSS-Sleep/Mouse017/20110624/Env1/ICSS-Mouse-17-24062011';
        cd(filename1)
        cd(filename2)        
        catch

      %  filename1a='/Users/karimbenchenane/Documents/Data/DataEnCours/ManipesICSSok/Data/Mouse017/20110624/Env2';
      %  filename2a='/Users/karimbenchenane/Documents/Data/DataEnCours/ManipesICSSok/Data/Mouse017/20110624/Env1';   

        %filename1a='/Users/Bench/Documents/Data/Mouse017/20110624/Env2';
        %filename2a='/Users/Bench/Documents/Data/Mouse017/20110624/Env1'; 
        
        filename1a='/Users/karimbenchenane/Documents/Data/DataEnCours/ManipesICSSok/Data/Mouse017/20110624/Env2';
        filename2a='/Users/karimbenchenane/Documents/Data/DataEnCours/ManipesICSSok/Data/Mouse017/20110624/Env1';      

        end


% 
%         listPlaceCells1=[2 3 4 5];
%         listPlaceCells2=[2 4 8 9 10 11];
        
        listPlaceCells1=[2 3 4 5];
        listPlaceCells2=[2 9 3 7];
        
        DEBsessionPre=1;
        FINsessionPre=6;
        DEBsessionPost=1;
        FINsessionPost=2;


else

            try

        filename1='/media/Drobo2/DataD2/ICSS-Sleep/Mouse029/20120201/ICSS-Mouse-29-01022012';
        filename2='/media/Drobo2/DataD2/ICSS-Sleep/Mouse029/20120201/ICSS-Mouse-29-01022012';
        cd(filename1)
        cd(filename2)        
            catch
       % filename1a='/Users/karimbenchenane/Documents/Data/DataEnCours/ManipesICSSok/Data/Mouse029/20120201';
       % filename2a='/Users/karimbenchenane/Documents/Data/DataEnCours/ManipesICSSok/Data/Mouse029/20120201'; 
        %filename1a='/Users/Bench/Documents/Data/Mouse017/20110624/Env2';
        %filename2a='/Users/Bench/Documents/Data/Mouse017/20110624/Env1'; 
        filename1a='/Users/karimbenchenane/Documents/Data/DataEnCours/ManipesICSSok/Data/Mouse017/20110624/Env2';
        filename2a='/Users/karimbenchenane/Documents/Data/DataEnCours/ManipesICSSok/Data/Mouse017/20110624/Env1';

            end

        listPlaceCells1=[11 19 20 26 30 43];
        listPlaceCells2=[11 19 20 26 30 43];
        DEBsessionPre=1;
        FINsessionPre=1;
        DEBsessionPost=2;
        FINsessionPost=3;

end

filename1=filename1a;
filename2=filename2a;
sav=0;

try
%jj
    %cd('/media/Drobo2/DataD2/ICSS-Sleep/Mouse017/20110624/Env2/ICSS-Mouse-17-24062011')
    cd(filename1)
    load DataRemapping
    MAP;
    clear MAP
    
    filename1=filename1a;
    filename2=filename2a;
    cd(filename2)
    load DataRemapping
    MAP;
    
    sav=0;

        
catch

    %    cd('/media/Drobo2/DataD2/ICSS-Sleep/Mouse017/20110624/Env2/ICSS-Mouse-17-24062011')
    filename1=filename1a;
    filename2=filename2a;
        cd(filename1)
        load DataRemapping
        load SpikeData
        load behavResources
        load Waveforms

    filename1=filename1a;
    filename2=filename2a;

        Epoch=intervalSet((tpsdeb{DEBsessionPre})*1E4,(tpsfin{FINsessionPre})*1E4);

        Mvt=thresholdIntervals(V,15,'Direction','Above');
        Epoch1=intersect(Epoch,Mvt);

        for km=1:length(Start(Epoch1))
        tpsEpoch(km)=End(subset(Epoch1,km),'s')-Start(subset(Epoch1,km),'s');    
        end

        TpsEpoch1=sum(tpsEpoch);

        kl=1;
        for i=listPlaceCells1
        Fr1(kl)=length(Range(Restrict(S{i},Epoch1)))/TpsEpoch1;    
        kl=kl+1;
        end



        a=1;
        for i=listPlaceCells1
            map=PlaceField(Restrict(S{i},intersect(Mvt,Epoch)),Restrict(X,Epoch),Restrict(Y,Epoch));title(cellnames{a})
            wfo{a}=PlotWaveforms(W,i,intersect(Epoch,Mvt));
            NbSpk(a)=length(Data(Restrict(S{i},Epoch)));
            valC{a}=map.count(:);
            valT{a}=map.time(:);
            valFr{a}=map.rate(:);
            MAP{a}=map.rate;
            %[r(a),p(a),rc(a),pc(a)]=PlaceFiledCorrealtionFor2(valC{a},valT{a},4);
            list(a)=i;
            a=a+1;
        end



        % 
        % for i=1:8
        % eval(['saveFigure(',num2str(i),',''FigurePFEnv2',num2str(i),''',''/media/Drobo2/DataD2/ICSS-Sleep/Mouse017/20110624/'')'])
        % end


       % cd('/media/Drobo2/DataD2/ICSS-Sleep/Mouse017/20110624/Env1/ICSS-Mouse-17-24062011')
        cd(filename2)



        load SpikeData
        load behavResources
        load Waveforms
        load DataRemapping

        Epoch=intervalSet((tpsdeb{DEBsessionPost})*1E4,(tpsfin{FINsessionPost})*1E4);

        Mvt=thresholdIntervals(V,15,'Direction','Above');

        Epoch2=intersect(Epoch,Mvt);

        for km=1:length(Start(Epoch2))
        tpsEpoch(km)=End(subset(Epoch2,km),'s')-Start(subset(Epoch2,km),'s');    
        end

        TpsEpoch2=sum(tpsEpoch);

        kl=1;
        for i=listPlaceCells2
        Fr2(kl)=length(Range(Restrict(S{i},Epoch2)))/TpsEpoch2;    
        kl=kl+1;
        end


        for i=listPlaceCells2
            map=PlaceField(Restrict(S{i},intersect(Mvt,Epoch)),Restrict(X,Epoch),Restrict(Y,Epoch));%title(cellnames{a})
            wfo{a}=PlotWaveforms(W,i,intersect(Epoch,Mvt));
            NbSpk(a)=length(Data(Restrict(S{i},Epoch)));
            valC{a}=map.count(:);
            valT{a}=map.time(:);
            valFr{a}=map.rate(:);
            MAP{a}=map.rate;

            list(a)=i;
            a=a+1;
        end

        % 
        % for i=9:16
        % eval(['saveFigure(',num2str(i),',''FigurePFEnv1',num2str(i),''',''/media/Drobo2/DataD2/ICSS-Sleep/Mouse017/20110624/'')'])
        % end

        a=a-1;

        save DataRemapping

end


A=[];
B1=[];
B2=[];
for i=1:a
    A=[A,valFr{i}];
    B1=[B1;mean(squeeze(wfo{i}(:,1,:)))];
    B2=[B2;mean(squeeze(wfo{i}(:,2,:)))];
    
end


[Rfr,Pfr,Rfrc,Pfrc]=PlaceFiledCorrealtion(A,4);

%[Rbeh,Pbeh,Rbehc,Pbehc]=PlaceFiledCorrealtion(B,4);

figure('color',[1 1 1])
subplot(2,1,1), imagesc(Rfr)
% set(gca,'ytick',[1:a])
% set(gca,'yticklabel',namePos(list))
colorbar
title('Correlation Firing Map')
subplot(2,1,2), imagesc(Rfrc)
% set(gca,'ytick',[1:a-1])
% set(gca,'yticklabel',namePos(list))
ca=caxis;
caxis([-max(abs(ca)) max(abs(ca))])
colorbar
title('Corrected Correlation Firing Map')

if 1
            figure('color',[1 1 1])
            subplot(2,1,1), imagesc(Pfr)
%             set(gca,'ytick',[1:a-1])
%             set(gca,'yticklabel',namePos(list))
            caxis([0 0.05])
            colorbar
            title('Significativity Correlation Firing Map')
            subplot(2,1,2), imagesc(Pfrc)
%             set(gca,'ytick',[1:a-1])
%             set(gca,'yticklabel',namePos(list))
            caxis([0 0.05])
            colorbar
            title('Significativity Corrected Correlation Firing Map')
end



if 0
    
            [Rspk1,Pspk1,Rspk1c,Pspk1c]=PlaceFiledCorrealtion(B1',4);

            figure('color',[1 1 1])
            subplot(2,1,1), imagesc(Rspk1)
            % set(gca,'ytick',[1:a])
            % set(gca,'yticklabel',namePos(list))
            colorbar
            title('Correlation spike shape channel 1')
            subplot(2,1,2), imagesc(Rspk1c)
            % set(gca,'ytick',[1:a-1])
            % set(gca,'yticklabel',namePos(list))
            ca=caxis;
            caxis([-max(abs(ca)) max(abs(ca))])
            colorbar
            title('Corrected Correlation spike shape channel 1')

            if 1
                        figure('color',[1 1 1])
                        subplot(2,1,1), imagesc(Pspk1)
            %             set(gca,'ytick',[1:a-1])
            %             set(gca,'yticklabel',namePos(list))
                        caxis([0 0.05])
                        colorbar
                        title('Significativity Correlation spike shape channel 1')
                        subplot(2,1,2), imagesc(Pspk1c)
            %             set(gca,'ytick',[1:a-1])
            %             set(gca,'yticklabel',namePos(list))
                        caxis([0 0.05])
                        colorbar
                        title('Significativity Corrected Correlation spike shape channel 1')
            end



            [Rspk2,Pspk2,Rspk2c,Pspk2c]=PlaceFiledCorrealtion(B2',4);

            figure('color',[1 1 1])
            subplot(2,1,1), imagesc(Rspk1)
            % set(gca,'ytick',[1:a])
            % set(gca,'yticklabel',namePos(list))
            colorbar
            title('Correlation spike shape channel 2')
            subplot(2,1,2), imagesc(Rspk1c)
            % set(gca,'ytick',[1:a-1])
            % set(gca,'yticklabel',namePos(list))
            ca=caxis;
            caxis([-max(abs(ca)) max(abs(ca))])
            colorbar
            title('Corrected Correlation spike shape channel 2')

            if 1
                        figure('color',[1 1 1])
                        subplot(2,1,1), imagesc(Pspk2)
            %             set(gca,'ytick',[1:a-1])
            %             set(gca,'yticklabel',namePos(list))
                        caxis([0 0.05])
                        colorbar
                        title('Significativity Correlation spike shape channel 2')
                        subplot(2,1,2), imagesc(Pspk2c)
            %             set(gca,'ytick',[1:a-1])
            %             set(gca,'yticklabel',namePos(list))
                        caxis([0 0.05])
                        colorbar
                        title('Significativity Corrected Correlation spike shape channel 2')
            end

end


[Rspk,Pspk]=corrcoef([B1 B2]');
Pspk=Pspk-diag(diag(Pspk));

Rspk=Rspk-diag(diag(Rspk));
for i=1:length(Rspk)
    Rspk(i,i)=max(max(Rspk));
end


th=1.2;
Mat=[B1 B2]';

Rspkc=zeros(size(Mat,2),size(Mat,2));
Pspkc=zeros(size(Mat,2),size(Mat,2));
pTTspkc=zeros(size(Mat,2),size(Mat,2));


for i=1:size(Mat,2)
    for j=i+1:size(Mat,2)
        
        valX=Mat(:,i);
        valY=Mat(:,j);
        
        levelxU=max(valX)/th;
        levelxD=min(valX)/th;
        
        levelyU=max(valY)/th;
        levelyD=min(valY)/th;
        
        %[rtemp,ptemp]=corrcoef([valX(find((valX>levelxU&valX<levelxD)|(valY>levelyU&valY<levelyD))),valY(find((valX>levelxU&valX<levelxD)|(valY>levelyU&valY<levelyD)))]);
         [rtemp,ptemp]=corrcoef([valX(find((valX>levelxU|valX<levelxD)|(valY>levelyU|valY<levelyD))) valY(find((valX>levelxU|valX<levelxD)|(valY>levelyU|valY<levelyD)))]);
        
try
    [h,pTTspkc(i,j)]=ttest(valX(find((valX>levelxU|valX<levelxD)|(valY>levelyU|valY<levelyD))), valY(find((valX>levelxU|valX<levelxD)|(valY>levelyU|valY<levelyD)))); 
catch
    pTTspkc(i,j)=nan;
end
    %         figure, hold on
%         plot(valX(find((valX>levelxU|valX<levelxD)|(valY>levelyU|valY<levelyD))))
%         plot(valY(find((valX>levelxU|valX<levelxD)|(valY>levelyU|valY<levelyD))),'r')
      
        Rspkc(i,j)=rtemp(2,1);
        Pspkc(i,j)=ptemp(2,1);
       title(['correlation,',num2str(i),' vs. ',num2str(j), ', r=',num2str(rtemp(2,1)),', p=',num2str(ptemp(2,1))]) 
    end

end

Rspkc=Rspkc+Rspkc';
for i=1:length(Rspkc)
    Rspkc(i,i)=max(max(Rspkc));
end
Pspkc=Pspkc+Pspkc';


pTTspkc=pTTspkc+pTTspkc';


%-------------------------------------------------------------------------------
%-------------------------------------------------------------------------------
%-------------------------------------------------------------------------------


figure('color',[1 1 1]), imagesc([B1 B2])

figure('color',[1 1 1]), imagesc(pTTspkc), caxis([0 0.05]), colorbar
title('Difference spike shape, p value')


figure('color',[1 1 1])
subplot(2,1,1), imagesc(Rspk)
% set(gca,'ytick',[1:a])
% set(gca,'yticklabel',namePos(list))
colorbar
title('Correlation spike shape')
subplot(2,1,2), imagesc(Rspkc)
% set(gca,'ytick',[1:a-1])
% set(gca,'yticklabel',namePos(list))
ca=caxis;
caxis([-max(abs(ca)) max(abs(ca))])
colorbar
title('Corrected Correlation spike shape')

if 1
            figure('color',[1 1 1])
            subplot(2,1,1), imagesc(Pspk)
%             set(gca,'ytick',[1:a-1])
%             set(gca,'yticklabel',namePos(list))
            caxis([0 0.05])
            colorbar
            title('Significativity Correlation spike shape')
            subplot(2,1,2), imagesc(Pspkc)
%             set(gca,'ytick',[1:a-1])
%             set(gca,'yticklabel',namePos(list))
            caxis([0 0.05])
            colorbar
            title('Significativity Corrected Correlation spike shape')
end


%-------------------------------------------------------------------------------
%-------------------------------------------------------------------------------
%-------------------------------------------------------------------------------

%
% figure('color',[1 1 1])
% subplot(2,1,1), bar([r;rc]',1)
% title('Correlation Occupancy Map vs Spike density')
% ylabel('Correlation')
% xlabel('Session')
% subplot(2,1,2), bar([p;pc]',1)
% ylabel('Singificativity Correlation')
% xlabel('Session')


if floor(sqrt(a))==sqrt(a)
    le1=sqrt(a);
    le2=sqrt(a);
else
    le1=floor(sqrt(a))+1;
    le2=floor(sqrt(a)); 
    if le1*le2<a
        le2=le2+1;
    end
end

jk=1;
ik=1;

figure('color',[1 1 1])
for i=1:a
   subplot(le1,le2,i), imagesc(MAP{(i)}), axis xy, colorbar, ca=caxis;
   if i<=length(listPlaceCells1)
       title('Env1')
       Ca1(jk)=ca(2);
       jk=jk+1;
   else
       title('Env2')
       Ca2(ik)=ca(2);
       ik=ik+1;
   end
end


n=1;
if length(listPlaceCells1)==length(listPlaceCells2)
figure('color',[1 1 1])
for i=1:length(listPlaceCells1)
   subplot(length(listPlaceCells1),2,n), imagesc(MAP{(i)}), axis xy,  ca1=caxis;
   subplot(length(listPlaceCells1),2,n+1), imagesc(MAP{(i+length(listPlaceCells1))}), axis xy,ca2=caxis;
   subplot(length(listPlaceCells1),2,n),caxis([0 max(ca1(2),ca2(2))]), title(['Env1, max=',num2str(max(ca1(2),ca2(2))),' Hz'])
   subplot(length(listPlaceCells1),2,n+1),caxis([0 max(ca1(2),ca2(2))]), title(['Env2, max=',num2str(max(ca1(2),ca2(2))),' Hz'])
   n=n+2;
   
end


n=1;
figure('color',[1 1 1])
for i=1:length(listPlaceCells1)
   subplot(length(listPlaceCells1),2,n), imagesc(MAP{(i)}), axis xy,  ca1=caxis;Ca1(i)=ca1(2);
   subplot(length(listPlaceCells1),2,n+1), imagesc(MAP{(i+length(listPlaceCells1))}), axis xy,ca2=caxis;Ca2(i)=ca2(2);
   subplot(length(listPlaceCells1),2,n), title(['Env1, max:',num2str(ca1(2)),' Hz'])
   subplot(length(listPlaceCells1),2,n+1), title(['Env2, max:',num2str(ca2(2)),' Hz'])
   n=n+2;
   
end


%-------------------------------------------------------------------------
%-------------------------------------------------------------------------
%-------------------------------------------------------------------------


figure('color',[1 1 1])
plot(ones(length(Fr1),1),Fr1,'ko')
hold on, plot(2*ones(length(Fr1),1),Fr2,'ko','markerfacecolor','k')
xlim([0 3])
line([ones(length(Fr1),1) 2*ones(length(Fr1),1)]',[Fr1; Fr2],'color','k')
set(gca,'xtick',[1 2])
set(gca,'xticklabel',{'Env 1', 'Env 2'})
ylabel('Mean Firing rate (Hz)')

[p,h]=ttest(Fr1,Fr2);
title(['n=',num2str(length(Fr1)),', p=',num2str(p)])

figure('color',[1 1 1])
plot(ones(length(Fr1),1),log2(Fr1./Fr1),'ko')
hold on, plot(2*ones(length(Fr1),1),log2(Fr2./Fr1),'ko','markerfacecolor','k')
xlim([0 3])
line([ones(length(Fr1),1) 2*ones(length(Fr1),1)]',log2([Fr1./Fr1; Fr2./Fr1]),'color','k')
set(gca,'xtick',[1 2])
set(gca,'xticklabel',{'Env 1', 'Env 2'})
ylabel('Normalized Firing rate (log2 scale)')

[p,h]=ttest(Fr1./Fr1,Fr2./Fr1);
title(['n=',num2str(length(Fr1)),', p=',num2str(p)])

PlotErrorBar2(Fr1',Fr2')
set(gca,'xtick',[1 2])
set(gca,'xticklabel',{'Env 1', 'Env 2'})
ylabel('Mean Firing rate (Hz)')
[h,p]=ttest(Fr1,Fr2);
title(['n=',num2str(length(Fr1)),', p=',num2str(p)])


figure('color',[1 1 1])
plot(ones(length(Fr1),1),Ca1,'ko')
hold on, plot(2*ones(length(Fr1),1),Ca2,'ko','markerfacecolor','k')
xlim([0 3])
line([ones(length(Fr1),1) 2*ones(length(Fr1),1)]',[Ca1; Ca2],'color','k')
set(gca,'xtick',[1 2])
set(gca,'xticklabel',{'Env 1', 'Env 2'})
ylabel('Peak Firing rate (Hz)')

[h,p]=ttest(Ca1,Ca2);
title(['n=',num2str(length(Fr1)),', p=',num2str(p)])



figure('color',[1 1 1])
plot(ones(length(Fr1),1),log2(Ca1./Ca1),'ko')
hold on, plot(2*ones(length(Fr1),1),log2(Ca2./Ca1),'ko','markerfacecolor','k')
xlim([0 3])
line([ones(length(Fr1),1) 2*ones(length(Fr1),1)]',log2([Ca1./Ca1; Ca2./Ca1]),'color','k')
set(gca,'xtick',[1 2])
set(gca,'xticklabel',{'Env 1', 'Env 2'})
ylabel('Normalized Peak firing rate (log2 scale)')

[h,p]=ttest(Ca1./Ca1,Ca2./Ca1);
title(['n=',num2str(length(Fr1)),', p=',num2str(p)])


PlotErrorBar2(Ca1',Ca2')
set(gca,'xtick',[1 2])
set(gca,'xticklabel',{'Env 1', 'Env 2'})
ylabel('Peak Firing rate (Hz)')
[h,p]=ttest(Ca1,Ca2);
title(['n=',num2str(length(Fr1)),', p=',num2str(p)])





for i=1:length(listPlaceCells1)
[r(i),p(i),rc(i),pc(i)]=PlaceFiledCorrealtionFor2(MAP{i}(:),MAP{i+6}(:));
end


PlotErrorBar(r')
set(gca,'xtick',[])
ylabel('Correlation Place Field Env1 vs. Env2')




n=1;
figure('color',[1 1 1])
for i=1:length(listPlaceCells1)
   subplot(length(listPlaceCells1),2,n), imagesc(MAP{(i)}), axis xy,  caxis([0 max(Ca1(i),Ca2(i))])
   subplot(length(listPlaceCells1),2,n+1), imagesc(MAP{(i+length(listPlaceCells1))}), axis xy, caxis([0 max(Ca1(i),Ca2(i))])
   subplot(length(listPlaceCells1),2,n), title(['Env1, max=',num2str(floor(Ca1(i)*100)/100),' Hz']), caxis([0 max(Ca1(i),Ca2(i))])
   subplot(length(listPlaceCells1),2,n+1), title(['Env2, max=',num2str(floor(Ca2(i)*100)/100),' Hz, r=',num2str(floor(r(i)*100)/100),  ', ',num2str(floor(((Fr2(i)-Fr1(i))./Fr1(i))*100)),'%']), caxis([0 max(Ca1(i),Ca2(i))])
   n=n+2;
   
end


else
    
    



        figure('color',[1 1 1])
        plot(ones(length(Fr1),1),Fr1,'ko')
        hold on, plot(2*ones(length(Fr2),1),Fr2,'ko','markerfacecolor','k')
        xlim([0 3])
        set(gca,'xtick',[1 2])
        set(gca,'xticklabel',{'Env 1', 'Env 2'})
        ylabel('Mean Firing rate (Hz)')

        [h,p]=ttest2(Fr1,Fr2);
        title(['n1=',num2str(length(Fr1)),', n2=',num2str(length(Fr2)),', p=',num2str(p)])


        PlotErrorBar2(Fr1',Fr2')
        set(gca,'xtick',[1 2])
        set(gca,'xticklabel',{'Env 1', 'Env 2'})
        ylabel('Mean Firing rate (Hz)')
        [h,p]=ttest2(Fr1,Fr2);
        title(['n1=',num2str(length(Fr1)),', n2=',num2str(length(Fr2)),', p=',num2str(p)])


        figure('color',[1 1 1])
        plot(ones(length(Fr1),1),Ca1,'ko')
        hold on, plot(2*ones(length(Fr2),1),Ca2,'ko','markerfacecolor','k')
        xlim([0 3])
        set(gca,'xtick',[1 2])
        set(gca,'xticklabel',{'Env 1', 'Env 2'})
        ylabel('Peak Firing rate (Hz)')

        [h,p]=ttest2(Ca1,Ca2);
        title(['n1=',num2str(length(Fr1)),', n2=',num2str(length(Fr2)),', p=',num2str(p)])


    
    
end


if sav
clear W

cd(filename1)
save DataRemapping

cd(filename2)
save DataRemapping

end