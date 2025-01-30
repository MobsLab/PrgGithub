close all
clear rip spin del
mice=[1,2,3,4,5];
for file=1:5
                load(['/home/mobs/Documents/BulbOscillationEffect/M',num2str(mice(file)),'/OscillInfov5.mat'])
    for nn=1:2
        for id=1:2
            
            for e=1:8
                spin{nn,id,1}(e,file)=Spiinfo{nn,1}(id,e);
            end
            for e=1:8
                spin{nn,id,2}(e,file)=Spiinfo{nn,6}(id,e);
            end
        end
        
        for e=1:8
            del{nn}(e,file)=Delinfo(nn,e);
        end
        
    end
    
    for e=1:8
        try
            rip(e,file)=Ripinfo(1,e);
        catch
            rip(e,file)=NaN;
        end
    end
end


%% Look at bootstrapping results
mice=[1,2,3,4,5];
for file=1:5
    for nn=1:2
        for id=1:2
            load(['/home/mobs/Documents/BulbOscillationEffect/M',num2str(mice(file)),'/Boots/OscillInfov5.mat'])
            
            for e=1:51
                spinB{nn,id,1}(e,file)=Spiinfo{nn,1}(id,e);
            end
            for e=1:51
                spinB{nn,id,2}(e,file)=Spiinfo{nn,6}(id,e);
            end
        end
        
        for e=1:51
            delB{nn}(e,file)=Delinfo(nn,e);
        end
        
    end
    
    for e=1:51
        try
            ripB(e,file)=Ripinfo(1,e);
        catch
            ripB(e,file)=NaN;
        end
    end
end

%% Get spectra info
clear specPF specPa specH BefH BefPa AftPa AftPF BefPF
mice=[1,2,3,4,5];
for file=1:5
            load(['/home/mobs/Documents/BulbOscillationEffect/M',num2str(mice(file)),'/Spectinfov5.mat'])
            
            for e=1:8
                specPF{e}(1,file)=SpecInfo{3}(e,1);
                specPF{e}(2,file)=SpecInfo{3}(e,2);

            end
            for e=1:8
                specPa{e}(1,file)=SpecInfo{4}(e,1);
                specPa{e}(2,file)=SpecInfo{4}(e,2);
                specH{e}(1,file)=SpecInfo{2}(e,1);
                specH{e}(2,file)=SpecInfo{2}(e,2);

            end
            
            BefPF{1}(file,:)=Spectra{3,1}(1:262);
            AftPF{1}(file,:)=Spectra{3,2}(1:262);
            BefPF{2}(file,:)=Spectra{3,3}(1:262);
            AftPF{2}(file,:)=Spectra{3,4}(1:262);
            specPF{9}(1,file)=mean(BefPF{1}(file,find(f>10,1,'first'):find(f<15,1,'last')));
            specPF{9}(2,file)=mean(AftPF{1}(file,find(f>10,1,'first'):find(f<15,1,'last')));
            specPF{10}(1,file)=mean(BefPF{2}(file,find(f>10,1,'first'):find(f<15,1,'last')));
            specPF{10}(2,file)=mean(AftPF{2}(file,find(f>10,1,'first'):find(f<15,1,'last')));
            
            specPF{11}(1,file)=mean(BefPF{1}(file,find(f>1.5,1,'first'):find(f<5,1,'last')));
            specPF{11}(2,file)=mean(AftPF{1}(file,find(f>1.5,1,'first'):find(f<5,1,'last')));
            specPF{12}(1,file)=mean(BefPF{2}(file,find(f>1.5,1,'first'):find(f<5,1,'last')));
            specPF{12}(2,file)=mean(AftPF{2}(file,find(f>1.5,1,'first'):find(f<5,1,'last')));

            BefPa{1}(file,:)=Spectra{1,1}(1:262);
            AftPa{1}(file,:)=Spectra{1,2}(1:262);
            BefPa{2}(file,:)=Spectra{1,3}(1:262);
            AftPa{2}(file,:)=Spectra{1,4}(1:262);
            specPa{9}(1,file)=mean(BefPa{1}(file,find(f>10,1,'first'):find(f<15,1,'last')));
            specPa{9}(2,file)=mean(AftPa{1}(file,find(f>10,1,'first'):find(f<15,1,'last')));
            specPa{10}(1,file)=mean(BefPa{2}(file,find(f>10,1,'first'):find(f<15,1,'last')));
            specPa{10}(2,file)=mean(AftPa{2}(file,find(f>10,1,'first'):find(f<15,1,'last')));;
            specPa{11}(1,file)=mean(AftPa{1}(file,find(f>1.5,1,'first'):find(f<5,1,'last')));
            specPa{11}(2,file)=mean(AftPF{1}(file,find(f>1.5,1,'first'):find(f<5,1,'last')));
            specPa{12}(1,file)=mean(BefPa{2}(file,find(f>1.5,1,'first'):find(f<5,1,'last')));
            specPa{12}(2,file)=mean(AftPa{2}(file,find(f>1.5,1,'first'):find(f<5,1,'last')));

end

%%%%%%%%% FINAL %%%%%%%%%%%%%%%%%%%%%%

figure

nn=1; id=1;
subplot(3,2,1)
a=spin{nn,id,2}(3,1:4);
b=spin{nn,id,2}(4,1:4);
c=spin{nn,id,2}(1,1:4);
d=spin{nn,id,2}(2,1:4);
PlotErrorBar4ranksum(a',b',c',d',0,2)
title('PreFrontal Spindles')
set(gca,'XTick',[1 2 3 4],'XTickLabel',{'High 10%','Low 10%','High 25%','Low 25%'})

nn=2;
subplot(3,2,2)
a=spin{nn,id,2}(3,:);
b=spin{nn,id,2}(4,:);
c=spin{nn,id,2}(1,:);
d=spin{nn,id,2}(2,:);
PlotErrorBar4ranksum(a',b',c',d',0,2)
title('Parietal Spindles')
set(gca,'XTick',[1 2 3 4],'XTickLabel',{'High 10%','Low 10%','High 25%','Low 25%'})

subplot(3,2,3)
nn=1;
a=del{nn}(3,:);
b=del{nn}(4,:);
c=del{nn}(1,:);
d=del{nn}(2,:);
PlotErrorBar4ranksum(a',b',c',d',0,2)
title('Prefrontal Delta Waves')
set(gca,'XTick',[1 2 3 4],'XTickLabel',{'High 10%','Low 10%','High 25%','Low 25%'})


subplot(3,2,4)
nn=2;
a=del{nn}(3,:);
b=del{nn}(4,:);
c=del{nn}(3,:);
d=del{nn}(4,:);
PlotErrorBar4ranksum(a',b',c',d',0,2)
title('Parietal Delta Waves')
set(gca,'XTick',[1 2 3 4],'XTickLabel',{'High 10%','Low 10%','High 25%','Low 25%'})

subplot(3,2,5)
a=rip(3,:);
b=rip(4,:);
c=rip(3,:);
d=rip(4,:);
PlotErrorBar4ranksum(a',b',c',d',0,2)
title('Ripples')
set(gca,'XTick',[1 2 3 4],'XTickLabel',{'High 10%','Low 10%','High 25%','Low 25%'})



figure
subplot(2,2,1)
a= specPF{3}(1,:);
b= specPF{4}(1,:);
PlotErrorBar2ranksum(a',b',0,2)
title('Prefontal Delta')

subplot(2,2,2)
c= specPF{10}(1,:);
d= specPF{10}(2,:);
PlotErrorBar2ranksum(c',d',0,2)
title('Prefontal Spindle')


subplot(2,2,3)
a= specPa{3}(1,:);
b= specPa{4}(1,:);
PlotErrorBar2ranksum(a',b',0,2)
title('Parietal Delta')

subplot(2,2,4)
c= specPa{10}(1,:);
d= specPa{10}(2,:);
PlotErrorBar2ranksum(c',d',0,2)
title('Parietal Spindle')


% 25/25
figure
subplot(2,2,1)
a= specPF{1}(1,:);
b= specPF{2}(1,:);
PlotErrorBar2ranksum(a',b',0,2)
title('Prefontal Delta')

subplot(2,2,2)
c= specPF{9}(1,:);
d= specPF{9}(2,:);
PlotErrorBar2ranksum(c',d',0,2)
title('Prefontal Spindle')

% 10/10
subplot(2,2,3)
a= specPa{1}(1,:);
b= specPa{2}(1,:);
PlotErrorBar2ranksum(a',b',0,2)
title('Parietal Delta')

subplot(2,2,4)
c= specPa{9}(1,:);
d= specPa{9}(2,:);
PlotErrorBar2ranksum(c',d',0,2)
title('Parietal Spindle')




figure
subplot(1,2,1)
    y1=f.*(mean(BefPF{1})-std(BefPF{1})/sqrt(5));                  %#create first curve
    y2=f.*(mean(BefPF{1})+std(BefPF{1})/sqrt(5));                  %#create second curve
    X=[f,fliplr(f)];                %#create continuous x value array for plotting
    Y=[y1,fliplr(y2)];              %#create y values for out and then back
    fl=fill(X,Y,'b');
    set(fl,'FaceColor',[0.4 0.5 1],'EdgeColor',[0.4 0.5 1])
    hold on
    plot(f,f.*(mean(BefPF{1})),'linewidth',3)
    
    y1=f.*(mean(AftPF{1})-std(AftPF{1})/sqrt(5));                  %#create first curve
    y2=f.*(mean(AftPF{1})+std(AftPF{1})/sqrt(5));                  %#create second curve
    X=[f,fliplr(f)];                %#create continuous x value array for plotting
    Y=[y1,fliplr(y2)];              %#create y values for out and then back
    fl=fill(X,Y,'b');
    set(fl,'FaceColor',[1 0.2 0.2],'EdgeColor',[1 0.2 0.2])
    hold on
    plot(f,f.*(mean(AftPF{1})),'r','linewidth',3)

    subplot(1,2,2)
    y1=f.*(mean(BefPa{1})-std(BefPa{1})/sqrt(5));                  %#create first curve
    y2=f.*(mean(BefPa{1})+std(BefPa{1})/sqrt(5));                  %#create second curve
    X=[f,fliplr(f)];                %#create continuous x value array for plotting
    Y=[y1,fliplr(y2)];              %#create y values for out and then back
    fl=fill(X,Y,'b');
    set(fl,'FaceColor',[0.4 0.5 1],'EdgeColor',[0.4 0.5 1])
    hold on
    plot(f,f.*(mean(BefPa{1})),'linewidth',3)
    
    y1=f.*(mean(AftPa{1})-std(AftPa{1})/sqrt(5));                  %#create first curve
    y2=f.*(mean(AftPa{1})+std(AftPa{1})/sqrt(5));                  %#create second curve
    X=[f,fliplr(f)];                %#create continuous x value array for plotting
    Y=[y1,fliplr(y2)];              %#create y values for out and then back
    fl=fill(X,Y,'b');
    set(fl,'FaceColor',[1 0.2 0.2],'EdgeColor',[1 0.2 0.2])
    hold on
    plot(f,f.*(mean(AftPa{1})),'r','linewidth',3)
    
    
figure
subplot(1,2,1)
    y1=mean(BefPF{1})-std(BefPF{1})/sqrt(5);                  %#create first curve
    y2=mean(BefPF{1})+std(BefPF{1})/sqrt(5);                  %#create second curve
    X=[f,fliplr(f)];                %#create continuous x value array for plotting
    Y=[y1,fliplr(y2)];              %#create y values for out and then back
    fl=fill(X,Y,'b');
    set(fl,'FaceColor',[0.4 0.5 1],'EdgeColor',[0.4 0.5 1])
    hold on
    plot(f,mean(BefPF{1}),'linewidth',3)
    
    y1=mean(AftPF{1})-std(AftPF{1})/sqrt(5);                  %#create first curve
    y2=mean(AftPF{1})+std(AftPF{1})/sqrt(5);                  %#create second curve
    X=[f,fliplr(f)];                %#create continuous x value array for plotting
    Y=[y1,fliplr(y2)];              %#create y values for out and then back
    fl=fill(X,Y,'b');
    set(fl,'FaceColor',[1 0.2 0.2],'EdgeColor',[1 0.2 0.2])
    hold on
    plot(f,mean(AftPF{1}),'r','linewidth',3)

    subplot(1,2,2)
    y1=mean(BefPa{1})-std(BefPa{1})/sqrt(5);                  %#create first curve
    y2=mean(BefPa{1})+std(BefPa{1})/sqrt(5);                  %#create second curve
    X=[f,fliplr(f)];                %#create continuous x value array for plotting
    Y=[y1,fliplr(y2)];              %#create y values for out and then back
    fl=fill(X,Y,'b');
    set(fl,'FaceColor',[0.4 0.5 1],'EdgeColor',[0.4 0.5 1])
    hold on
    plot(f,mean(BefPa{1}),'linewidth',3)
    
    y1=mean(AftPa{1})-std(AftPa{1})/sqrt(5);                  %#create first curve
    y2=mean(AftPa{1})+std(AftPa{1})/sqrt(5);                  %#create second curve
    X=[f,fliplr(f)];                %#create continuous x value array for plotting
    Y=[y1,fliplr(y2)];              %#create y values for out and then back
    fl=fill(X,Y,'b');
    set(fl,'FaceColor',[1 0.2 0.2],'EdgeColor',[1 0.2 0.2])
    hold on
    plot(f,mean(AftPa{1}),'r','linewidth',3)
    
        
figure
subplot(1,2,1)
    y1=10*log10(mean(BefPF{1})-std(BefPF{1})/sqrt(5));                  %#create first curve
    y2=10*log10(mean(BefPF{1})+std(BefPF{1})/sqrt(5));                  %#create second curve
    X=[f,fliplr(f)];                %#create continuous x value array for plotting
    Y=[y1,fliplr(y2)];              %#create y values for out and then back
    fl=fill(X,Y,'b');
    set(fl,'FaceColor',[0.4 0.5 1],'EdgeColor',[0.4 0.5 1])
    hold on
    plot(f,10*log10(mean(BefPF{1})),'linewidth',3)
    
    y1=10*log10(mean(AftPF{1})-std(AftPF{1})/sqrt(5));                  %#create first curve
    y2=10*log10(mean(AftPF{1})+std(AftPF{1})/sqrt(5));                  %#create second curve
    X=[f,fliplr(f)];                %#create continuous x value array for plotting
    Y=[y1,fliplr(y2)];              %#create y values for out and then back
    fl=fill(X,Y,'b');
    set(fl,'FaceColor',[1 0.2 0.2],'EdgeColor',[1 0.2 0.2])
    hold on
    plot(f,10*log10(mean(AftPF{1})),'r','linewidth',3)

    subplot(1,2,2)
    y1=10*log10(mean(BefPa{1})-std(BefPa{1})/sqrt(5));                  %#create first curve
    y2=10*log10(mean(BefPa{1})+std(BefPa{1})/sqrt(5));                  %#create second curve
    X=[f,fliplr(f)];                %#create continuous x value array for plotting
    Y=[y1,fliplr(y2)];              %#create y values for out and then back
    fl=fill(X,Y,'b');
    set(fl,'FaceColor',[0.4 0.5 1],'EdgeColor',[0.4 0.5 1])
    hold on
    plot(f,10*log10(mean(BefPa{1})),'linewidth',3)
    
    y1=10*log10(mean(AftPa{1})-std(AftPa{1})/sqrt(5));                  %#create first curve
    y2=10*log10(mean(AftPa{1})+std(AftPa{1})/sqrt(5));                  %#create second curve
    X=[f,fliplr(f)];                %#create continuous x value array for plotting
    Y=[y1,fliplr(y2)];              %#create y values for out and then back
    fl=fill(X,Y,'b');
    set(fl,'FaceColor',[1 0.2 0.2],'EdgeColor',[1 0.2 0.2])
    hold on
    plot(f,10*log10(mean(AftPa{1})),'r','linewidth',3)

    

figure
subplot(1,2,1)
    y1=f.*(mean(BefPF{2})-std(BefPF{2})/sqrt(5));                  %#create first curve
    y2=f.*(mean(BefPF{2})+std(BefPF{2})/sqrt(5));                  %#create second curve
    X=[f,fliplr(f)];                %#create continuous x value array for plotting
    Y=[y1,fliplr(y2)];              %#create y values for out and then back
    fl=fill(X,Y,'b');
    set(fl,'FaceColor',[0.4 0.5 1],'EdgeColor',[0.4 0.5 1])
    hold on
    plot(f,f.*(mean(BefPF{2})),'linewidth',3)
    
    y1=f.*(mean(AftPF{2})-std(AftPF{2})/sqrt(5));                  %#create first curve
    y2=f.*(mean(AftPF{2})+std(AftPF{2})/sqrt(5));                  %#create second curve
    X=[f,fliplr(f)];                %#create continuous x value array for plotting
    Y=[y1,fliplr(y2)];              %#create y values for out and then back
    fl=fill(X,Y,'b');
    set(fl,'FaceColor',[1 0.2 0.2],'EdgeColor',[1 0.2 0.2])
    hold on
    plot(f,f.*(mean(AftPF{2})),'r','linewidth',3)

    subplot(1,2,2)
    y1=f.*(mean(BefPa{2})-std(BefPa{2})/sqrt(5));                  %#create first curve
    y2=f.*(mean(BefPa{2})+std(BefPa{2})/sqrt(5));                  %#create second curve
    X=[f,fliplr(f)];                %#create continuous x value array for plotting
    Y=[y1,fliplr(y2)];              %#create y values for out and then back
    fl=fill(X,Y,'b');
    set(fl,'FaceColor',[0.4 0.5 1],'EdgeColor',[0.4 0.5 1])
    hold on
    plot(f,f.*(mean(BefPa{2})),'linewidth',3)
    
    y1=f.*(mean(AftPa{2})-std(AftPa{2})/sqrt(5));                  %#create first curve
    y2=f.*(mean(AftPa{2})+std(AftPa{2})/sqrt(5));                  %#create second curve
    X=[f,fliplr(f)];                %#create continuous x value array for plotting
    Y=[y1,fliplr(y2)];              %#create y values for out and then back
    fl=fill(X,Y,'b');
    set(fl,'FaceColor',[1 0.2 0.2],'EdgeColor',[1 0.2 0.2])
    hold on
    plot(f,f.*(mean(AftPa{2})),'r','linewidth',3)
    
    
figure
subplot(1,2,1)
    y1=mean(BefPF{2})-std(BefPF{2})/sqrt(5);                  %#create first curve
    y2=mean(BefPF{2})+std(BefPF{2})/sqrt(5);                  %#create second curve
    X=[f,fliplr(f)];                %#create continuous x value array for plotting
    Y=[y1,fliplr(y2)];              %#create y values for out and then back
    fl=fill(X,Y,'b');
    set(fl,'FaceColor',[0.4 0.5 1],'EdgeColor',[0.4 0.5 1])
    hold on
    plot(f,mean(BefPF{2}),'linewidth',3)
    
    y1=mean(AftPF{2})-std(AftPF{2})/sqrt(5);                  %#create first curve
    y2=mean(AftPF{2})+std(AftPF{2})/sqrt(5);                  %#create second curve
    X=[f,fliplr(f)];                %#create continuous x value array for plotting
    Y=[y1,fliplr(y2)];              %#create y values for out and then back
    fl=fill(X,Y,'b');
    set(fl,'FaceColor',[1 0.2 0.2],'EdgeColor',[1 0.2 0.2])
    hold on
    plot(f,mean(AftPF{2}),'r','linewidth',3)

    subplot(1,2,2)
    y1=mean(BefPa{2})-std(BefPa{2})/sqrt(5);                  %#create first curve
    y2=mean(BefPa{2})+std(BefPa{2})/sqrt(5);                  %#create second curve
    X=[f,fliplr(f)];                %#create continuous x value array for plotting
    Y=[y1,fliplr(y2)];              %#create y values for out and then back
    fl=fill(X,Y,'b');
    set(fl,'FaceColor',[0.4 0.5 1],'EdgeColor',[0.4 0.5 1])
    hold on
    plot(f,mean(BefPa{2}),'linewidth',3)
    
    y1=mean(AftPa{2})-std(AftPa{2})/sqrt(5);                  %#create first curve
    y2=mean(AftPa{2})+std(AftPa{2})/sqrt(5);                  %#create second curve
    X=[f,fliplr(f)];                %#create continuous x value array for plotting
    Y=[y1,fliplr(y2)];              %#create y values for out and then back
    fl=fill(X,Y,'b');
    set(fl,'FaceColor',[1 0.2 0.2],'EdgeColor',[1 0.2 0.2])
    hold on
    plot(f,mean(AftPa{2}),'r','linewidth',3)
    
        
figure
subplot(1,2,1)
    y1=10*log10(mean(BefPF{2})-std(BefPF{2})/sqrt(5));                  %#create first curve
    y2=10*log10(mean(BefPF{2})+std(BefPF{2})/sqrt(5));                  %#create second curve
    X=[f,fliplr(f)];                %#create continuous x value array for plotting
    Y=[y1,fliplr(y2)];              %#create y values for out and then back
    fl=fill(X,Y,'b');
    set(fl,'FaceColor',[0.4 0.5 1],'EdgeColor',[0.4 0.5 1])
    hold on
    plot(f,10*log10(mean(BefPF{2})),'linewidth',3)
    
    y1=10*log10(mean(AftPF{2})-std(AftPF{2})/sqrt(5));                  %#create first curve
    y2=10*log10(mean(AftPF{2})+std(AftPF{2})/sqrt(5));                  %#create second curve
    X=[f,fliplr(f)];                %#create continuous x value array for plotting
    Y=[y1,fliplr(y2)];              %#create y values for out and then back
    fl=fill(X,Y,'b');
    set(fl,'FaceColor',[1 0.2 0.2],'EdgeColor',[1 0.2 0.2])
    hold on
    plot(f,10*log10(mean(AftPF{2})),'r','linewidth',3)

    subplot(1,2,2)
    y1=10*log10(mean(BefPa{2})-std(BefPa{2})/sqrt(5));                  %#create first curve
    y2=10*log10(mean(BefPa{2})+std(BefPa{2})/sqrt(5));                  %#create second curve
    X=[f,fliplr(f)];                %#create continuous x value array for plotting
    Y=[y1,fliplr(y2)];              %#create y values for out and then back
    fl=fill(X,Y,'b');
    set(fl,'FaceColor',[0.4 0.5 1],'EdgeColor',[0.4 0.5 1])
    hold on
    plot(f,10*log10(mean(BefPa{2})),'linewidth',3)
    
    y1=10*log10(mean(AftPa{2})-std(AftPa{2})/sqrt(5));                  %#create first curve
    y2=10*log10(mean(AftPa{2})+std(AftPa{2})/sqrt(5));                  %#create second curve
    X=[f,fliplr(f)];                %#create continuous x value array for plotting
    Y=[y1,fliplr(y2)];              %#create y values for out and then back
    fl=fill(X,Y,'b');
    set(fl,'FaceColor',[1 0.2 0.2],'EdgeColor',[1 0.2 0.2])
    hold on
    plot(f,10*log10(mean(AftPa{2})),'r','linewidth',3)
