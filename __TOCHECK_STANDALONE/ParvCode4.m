%ParvCode4

ploTot=1;
sav=0;


i=0;
i=i+1; labels{i}='DW AUd';
i=i+1; labels{i}='DW Par';
i=i+1; labels{i}='DW Pfc';
i=i+1; labels{i}='Sp Aud';
i=i+1; labels{i}='Sp Par';
i=i+1; labels{i}='Sp Pfc';
i=i+1; labels{i}='Ri Aud';
i=i+1; labels{i}='Ri Par';
i=i+1; labels{i}='Ri Pfc';
try
    
cd /Users/karimbenchenane/Dropbox/
end

try
    load('/Users/karimbenchenane/Dropbox/DataParvCode4data03MMN')
end

cd('/Users/karimbenchenane/Documents/Data/DataEnCours/MiceSetUp/MMN/DataMMN')


try
    Dt1;
    R{1};
catch
    try
cd('/Users/karimbenchenane/Documents/Data/DataEnCours/MiceSetUp/MMN/DataMMN')
load('/Users/karimbenchenane/Dropbox/LFPDatadata03MMN.mat')
    end
rg=Range(LFP{1});

if 0
    rg=Range(LFP{1});
    Epoch=intervalSet(0 ,620*1E4); %SWS
    %Epoch=intervalSet(620*1E4, rg(end)); %Theta
    LFP=Restrict(LFP,Epoch);
end

ch=0;
try
    Dt1;
    Dt3;
    ma1;
    
 %%   
            ch=0;
            figure('color',[1 1 1]), 
            % figure(2), clf
            %ch=15;
            subplot(5,1,1), hold on
            tbins=4;nbbins=300;
            for i=1:length(LFP)
            if i==ch
                plot(tpsa1{i},smooth(ma1{i},3),'color',[i/length(LFP) 0 (length(LFP)-i)/length(LFP)],'linewidth',2)
            else
            plot(tpsa1{i},smooth(ma1{i},3),'color',[i/length(LFP) 0 (length(LFP)-i)/length(LFP)])
            end
            end
            %i=5; [ma,sa,tpsa]=mETAverage(Range(tDeltaT2), Range(LFP{i}),Data(LFP{i}),tbins,nbbins);plot(tpsa,smooth(ma,3),'color',[i/15 0 (15-i)/15],'linewidth',2)
            % i=10; [ma,sa,tpsa]=mETAverage(Range(tDeltaT2), Range(LFP{i}),Data(LFP{i}),tbins,nbbins);plot(tpsa,smooth(ma,3),'color',[i/15 0 (15-i)/15],'linewidth',2)
            yl=ylim;
            line([0 0],[yl(1) yl(2)],'color','k')

            subplot(5,1,2), hold on
            tbins=4;nbbins=300;
            %ch=7;
            for i=1:length(LFP)
            if i==ch
                plot(tpsb1{i},smooth(mb1{i},3),'color',[i/length(LFP) 0 (length(LFP)-i)/length(LFP)],'linewidth',2)
            else
            plot(tpsb1{i},smooth(mb1{i},3),'color',[i/length(LFP) 0 (length(LFP)-i)/length(LFP)])
            end
            end
            % i=5; [ma,sa,tpsa]=mETAverage(Range(tDeltaP2), Range(LFP{i}),Data(LFP{i}),tbins,nbbins); plot(tpsa,smooth(ma,3),'color',[i/15 0 (15-i)/15],'linewidth',2)
            % i=10; [ma,sa,tpsa]=mETAverage(Range(tDeltaP2), Range(LFP{i}),Data(LFP{i}),tbins,nbbins);plot(tpsa,smooth(ma,3),'color',[i/15 0 (15-i)/15],'linewidth',2)
            yl=ylim;
            line([0 0],[yl(1) yl(2)],'color','k')

            subplot(5,1,3), hold on
            tbins=4;nbbins=300;
            %ch=1;
            for i=1:length(LFP)
            if i==ch
                plot(tpsc1{i},smooth(mc1{i},3),'color',[i/length(LFP) 0 (length(LFP)-i)/length(LFP)],'linewidth',2)
            else
            plot(tpsc1{i},smooth(mc1{i},3),'color',[i/length(LFP) 0 (length(LFP)-i)/length(LFP)])
            end
            end
            % i=5; [ma,sa,tpsa]=mETAverage(Range(spiPeaks), Range(LFP{i}),Data(LFP{i}),tbins,nbbins);plot(tpsa,smooth(ma,3),'color',[i/15 0 (15-i)/15],'linewidth',2)
            % i=10; [ma,sa,tpsa]=mETAverage(Range(spiPeaks), Range(LFP{i}),Data(LFP{i}),tbins,nbbins);plot(tpsa,smooth(ma,3),'color',[i/15 0 (15-i)/15],'linewidth',2)
            yl=ylim;
            line([0 0],[yl(1) yl(2)],'color','k')
            xlim([-250 250])

            subplot(5,1,4), hold on
            tbins=4;nbbins=300;
            for i=1:length(LFP)
            if i==ch
                plot(tpsd1{i},smooth(md1{i},3),'color',[i/length(LFP) 0 (length(LFP)-i)/length(LFP)],'linewidth',2)
            else
            plot(tpsd1{i},smooth(md1{i},3),'color',[i/length(LFP) 0 (length(LFP)-i)/length(LFP)])
            end
            end
            subplot(5,1,4), ylabel(['Ripples detected channel ', num2str(ch)]) 
            xlim([-250 250])   

            subplot(5,1,5), hold on
            tbins=1;nbbins=300;
            for i=1:length(LFP)
            if i==ch
                plot(tpse1{i},smooth(me1{i},3),'color',[i/length(LFP) 0 (length(LFP)-i)/length(LFP)],'linewidth',2)
            else
            plot(tpse1{i},smooth(me1{i},3),'color',[i/length(LFP) 0 (length(LFP)-i)/length(LFP)])
            end
            end
            subplot(5,1,5), ylabel(['Ripples detected channel ', num2str(ch)]) 
            xlim([-40 40])   

            set(gcf, 'position', [912 -15 548 946])
    
    
    
 %%   
  
          figure('color',[1 1 1]), 
            % figure(2), clf
            %ch=15;
            subplot(5,1,1), hold on
            tbins=4;nbbins=300;
            for i=1:length(LFP)
            if i==ch
                plot(tpsa2{i},smooth(ma2{i},3),'color',[i/length(LFP) 0 (length(LFP)-i)/length(LFP)],'linewidth',2)
            else
            plot(tpsa2{i},smooth(ma2{i},3),'color',[i/length(LFP) 0 (length(LFP)-i)/length(LFP)])
            end
            end
            %i=5; [ma,sa,tpsa]=mETAverage(Range(tDeltaT2), Range(LFP{i}),Data(LFP{i}),tbins,nbbins);plot(tpsa,smooth(ma,3),'color',[i/15 0 (15-i)/15],'linewidth',2)
            % i=10; [ma,sa,tpsa]=mETAverage(Range(tDeltaT2), Range(LFP{i}),Data(LFP{i}),tbins,nbbins);plot(tpsa,smooth(ma,3),'color',[i/15 0 (15-i)/15],'linewidth',2)
            yl=ylim;
            line([0 0],[yl(1) yl(2)],'color','k')

            subplot(5,1,2), hold on
            tbins=4;nbbins=300;
            %ch=7;
            for i=1:length(LFP)
            if i==ch
                plot(tpsb2{i},smooth(mb2{i},3),'color',[i/length(LFP) 0 (length(LFP)-i)/length(LFP)],'linewidth',2)
            else
            plot(tpsb2{i},smooth(mb2{i},3),'color',[i/length(LFP) 0 (length(LFP)-i)/length(LFP)])
            end
            end
            % i=5; [ma,sa,tpsa]=mETAverage(Range(tDeltaP2), Range(LFP{i}),Data(LFP{i}),tbins,nbbins); plot(tpsa,smooth(ma,3),'color',[i/15 0 (15-i)/15],'linewidth',2)
            % i=10; [ma,sa,tpsa]=mETAverage(Range(tDeltaP2), Range(LFP{i}),Data(LFP{i}),tbins,nbbins);plot(tpsa,smooth(ma,3),'color',[i/15 0 (15-i)/15],'linewidth',2)
            yl=ylim;
            line([0 0],[yl(1) yl(2)],'color','k')

            subplot(5,1,3), hold on
            tbins=4;nbbins=300;
            %ch=1;
            for i=1:length(LFP)
            if i==ch
                plot(tpsc2{i},smooth(mc2{i},3),'color',[i/length(LFP) 0 (length(LFP)-i)/length(LFP)],'linewidth',2)
            else
            plot(tpsc2{i},smooth(mc2{i},3),'color',[i/length(LFP) 0 (length(LFP)-i)/length(LFP)])
            end
            end
            % i=5; [ma,sa,tpsa]=mETAverage(Range(spiPeaks), Range(LFP{i}),Data(LFP{i}),tbins,nbbins);plot(tpsa,smooth(ma,3),'color',[i/15 0 (15-i)/15],'linewidth',2)
            % i=10; [ma,sa,tpsa]=mETAverage(Range(spiPeaks), Range(LFP{i}),Data(LFP{i}),tbins,nbbins);plot(tpsa,smooth(ma,3),'color',[i/15 0 (15-i)/15],'linewidth',2)
            yl=ylim;
            line([0 0],[yl(1) yl(2)],'color','k')
            xlim([-250 250])

            subplot(5,1,4), hold on
            tbins=4;nbbins=300;
            for i=1:length(LFP)
            if i==ch
                plot(tpsd2{i},smooth(md2{i},3),'color',[i/length(LFP) 0 (length(LFP)-i)/length(LFP)],'linewidth',2)
            else
            plot(tpsd2{i},smooth(md2{i},3),'color',[i/length(LFP) 0 (length(LFP)-i)/length(LFP)])
            end
            end
            subplot(5,1,4), ylabel(['Ripples detected channel ', num2str(ch)]) 
            xlim([-250 250])   

            subplot(5,1,5), hold on
            tbins=1;nbbins=300;
            for i=1:length(LFP)
            if i==ch
                plot(tpse2{i},smooth(me2{i},3),'color',[i/length(LFP) 0 (length(LFP)-i)/length(LFP)],'linewidth',2)
            else
            plot(tpse2{i},smooth(me2{i},3),'color',[i/length(LFP) 0 (length(LFP)-i)/length(LFP)])
            end
            end
            subplot(5,1,5), ylabel(['Ripples detected channel ', num2str(ch)]) 
            xlim([-40 40])   

            set(gcf, 'position', [912 -15 548 946])
 
    
    %%
    
         figure('color',[1 1 1]), 
            % figure(2), clf
            %ch=15;
            subplot(5,1,1), hold on
            tbins=4;nbbins=300;
            for i=1:length(LFP)
            if i==ch
                plot(tpsa3{i},smooth(ma3{i},3),'color',[i/length(LFP) 0 (length(LFP)-i)/length(LFP)],'linewidth',2)
            else
            plot(tpsa3{i},smooth(ma3{i},3),'color',[i/length(LFP) 0 (length(LFP)-i)/length(LFP)])
            end
            end
            %i=5; [ma,sa,tpsa]=mETAverage(Range(tDeltaT2), Range(LFP{i}),Data(LFP{i}),tbins,nbbins);plot(tpsa,smooth(ma,3),'color',[i/15 0 (15-i)/15],'linewidth',2)
            % i=10; [ma,sa,tpsa]=mETAverage(Range(tDeltaT2), Range(LFP{i}),Data(LFP{i}),tbins,nbbins);plot(tpsa,smooth(ma,3),'color',[i/15 0 (15-i)/15],'linewidth',2)
            yl=ylim;
            line([0 0],[yl(1) yl(2)],'color','k')

            subplot(5,1,2), hold on
            tbins=4;nbbins=300;
            %ch=7;
            for i=1:length(LFP)
            if i==ch
                plot(tpsb3{i},smooth(mb3{i},3),'color',[i/length(LFP) 0 (length(LFP)-i)/length(LFP)],'linewidth',2)
            else
            plot(tpsb3{i},smooth(mb3{i},3),'color',[i/length(LFP) 0 (length(LFP)-i)/length(LFP)])
            end
            end
            % i=5; [ma,sa,tpsa]=mETAverage(Range(tDeltaP2), Range(LFP{i}),Data(LFP{i}),tbins,nbbins); plot(tpsa,smooth(ma,3),'color',[i/15 0 (15-i)/15],'linewidth',2)
            % i=10; [ma,sa,tpsa]=mETAverage(Range(tDeltaP2), Range(LFP{i}),Data(LFP{i}),tbins,nbbins);plot(tpsa,smooth(ma,3),'color',[i/15 0 (15-i)/15],'linewidth',2)
            yl=ylim;
            line([0 0],[yl(1) yl(2)],'color','k')

            subplot(5,1,3), hold on
            tbins=4;nbbins=300;
            %ch=1;
            for i=1:length(LFP)
            if i==ch
                plot(tpsc3{i},smooth(mc3{i},3),'color',[i/length(LFP) 0 (length(LFP)-i)/length(LFP)],'linewidth',2)
            else
            plot(tpsc3{i},smooth(mc3{i},3),'color',[i/length(LFP) 0 (length(LFP)-i)/length(LFP)])
            end
            end
            % i=5; [ma,sa,tpsa]=mETAverage(Range(spiPeaks), Range(LFP{i}),Data(LFP{i}),tbins,nbbins);plot(tpsa,smooth(ma,3),'color',[i/15 0 (15-i)/15],'linewidth',2)
            % i=10; [ma,sa,tpsa]=mETAverage(Range(spiPeaks), Range(LFP{i}),Data(LFP{i}),tbins,nbbins);plot(tpsa,smooth(ma,3),'color',[i/15 0 (15-i)/15],'linewidth',2)
            yl=ylim;
            line([0 0],[yl(1) yl(2)],'color','k')
            xlim([-250 250])

            subplot(5,1,4), hold on
            tbins=4;nbbins=300;
            for i=1:length(LFP)
            if i==ch
                plot(tpsd3{i},smooth(md3{i},3),'color',[i/length(LFP) 0 (length(LFP)-i)/length(LFP)],'linewidth',2)
            else
            plot(tpsd3{i},smooth(md3{i},3),'color',[i/length(LFP) 0 (length(LFP)-i)/length(LFP)])
            end
            end
            subplot(5,1,4), ylabel(['Ripples detected channel ', num2str(ch)]) 
            xlim([-250 250])   

            subplot(5,1,5), hold on
            tbins=1;nbbins=300;
            for i=1:length(LFP)
            if i==ch
                plot(tpse3{i},smooth(me3{i},3),'color',[i/length(LFP) 0 (length(LFP)-i)/length(LFP)],'linewidth',2)
            else
            plot(tpse3{i},smooth(me3{i},3),'color',[i/length(LFP) 0 (length(LFP)-i)/length(LFP)])
            end
            end
            subplot(5,1,5), ylabel(['Ripples detected channel ', num2str(ch)]) 
            xlim([-40 40])   

            set(gcf, 'position', [912 -15 548 946])    
    
    
    
    
 %%   
catch

[Dt1,Dp1,Sp1,Ri1,ma1,sa1,tpsa1,mb1,sb1,tpsb1,mc1,sc1,tpsc1,md1,sd1,tpsd1,me1,se1,tpse1]=IdentifyDeltaSpindlesRipples(LFP,15,12,3000,1);%ploTot);
[Dt2,Dp2,Sp2,Ri2,ma2,sa2,tpsa2,mb2,sb2,tpsb2,mc2,sc2,tpsc2,md2,sd2,tpsd2,me2,se2,tpse2]=IdentifyDeltaSpindlesRipples(LFP,5,7,3000,1); %ploTot);
[Dt3,Dp3,Sp3,Ri3,ma3,sa3,tpsa3,mb3,sb3,tpsb3,mc3,sc3,tpsc3,md3,sd3,tpsd3,me3,se3,tpse3]=IdentifyDeltaSpindlesRipples(LFP,1,[],3000,1); %ploTot);

if 0
    try
cd /Users/karimbenchenane/Dropbox/
    end
    save DataParvCode4data03MMN
end

end


R{1}=Dt1;
R{2}=Dt2;
R{3}=Dt3;
R{4}=Sp1;
R{5}=Sp2;
R{6}=Sp3;
R{7}=Ri1;
R{8}=Ri2;
R{9}=Ri3;
end



if ploTot
    
%--------------------------------------------------------------------------
%%1------------------------------------------------------------------------
%--------------------------------------------------------------------------

a=5000; b=200;
for i=1:length(R)
    for j=1:length(R)
        [C{i,j},B{i,j}]=CrossCorr(Range(R{i}),Range(R{j}),a,b);
    end
end


for i=1:length(R)
C{i,i}(B{i,i}==0)=0;    
end





figure('color',[1 1 1]), 

for i=1:length(R)
    for j=1:length(R)
        
        subplot(length(R),length(R),MatXY(i,j,length(R)))
    
        
        hold on, area(B{i,i}/1E3,C{i,j},'facecolor','k'), yl=ylim; line([0 0],yl,'color','r')
   area(B{i,i}/1E3,C{i,j},'facecolor','k'), 
    xlim([-a*b a*b]/2E3)
end

end


for i=1:length(R)
    
    
subplot(length(R),length(R),MatXY(i,1,length(R))), ylabel(labels{i})
subplot(length(R),length(R),MatXY(1,i,length(R))), title(labels{i})
end
set(gcf,'Position',[226 -7 1316 937])
% 
% set(gca, 'xtick',[1:length(R)])
% set(gca, 'ytick',[1:length(R)])
% set(gca, 'xticklabel',labels)
% set(gca, 'yticklabel',labels)



%--------------------------------------------------------------------------
%%2------------------------------------------------------------------------
%--------------------------------------------------------------------------

a=2500; b=200;
for i=1:length(R)
    for j=1:length(R)
        [C{i,j},B{i,j}]=CrossCorr(Range(R{i}),Range(R{j}),a,b);
    end
end


for i=1:length(R)
C{i,i}(B{i,i}==0)=0;    
end



figure('color',[1 1 1]), 

for i=1:length(R)
    for j=1:length(R)
        
        subplot(length(R),length(R),MatXY(i,j,length(R)))
    
        
        hold on, area(B{i,j}/1E3,C{i,j},'facecolor','k'), yl=ylim; line([0 0],yl,'color','r')
        area(B{i,i}/1E3,C{i,j},'facecolor','k'), 
   xlim([-a*b a*b]/2E3)
    
end

end




% 
% set(gca, 'xtick',[1:length(R)])
% set(gca, 'ytick',[1:length(R)])
% set(gca, 'xticklabel',labels)
% set(gca, 'yticklabel',labels)



set(gcf,'Position',[226 -7 1316 937])

for i=1:length(R)
    
    
subplot(length(R),length(R),MatXY(i,1,length(R))), ylabel(labels{i})
subplot(length(R),length(R),MatXY(1,i,length(R))), title(labels{i})
end




%--------------------------------------------------------------------------
%%3------------------------------------------------------------------------
%--------------------------------------------------------------------------


a=100; b=2000;
for i=1:length(R)
    for j=1:length(R)
        [C{i,j},B{i,j}]=CrossCorr(Range(R{i}),Range(R{j}),a,b);
    end
end


for i=1:length(R)
C{i,i}(B{i,i}==0)=0;    
end





figure('color',[1 1 1]), 

for i=1:length(R)
    for j=1:length(R)
        
        subplot(length(R),length(R),MatXY(i,j,length(R)))
    
        
        hold on, area(B{i,j}/1E3,C{i,j},'facecolor','k'), yl=ylim; line([0 0],yl,'color','r')
        area(B{i,i}/1E3,C{i,j},'facecolor','k'), 
   xlim([-a*b a*b]/2E3)
    
end

end


for i=1:length(R)
    
    
subplot(length(R),length(R),MatXY(i,1,length(R))), ylabel(labels{i})
subplot(length(R),length(R),MatXY(1,i,length(R))), title(labels{i})
end
set(gcf,'Position',[226 -7 1316 937])
% 
% set(gca, 'xtick',[1:length(R)])
% set(gca, 'ytick',[1:length(R)])
% set(gca, 'xticklabel',labels)
% set(gca, 'yticklabel',labels)






%--------------------------------------------------------------------------
%%4------------------------------------------------------------------------
%--------------------------------------------------------------------------


a=100; b=1000;
for i=1:length(R)
    for j=1:length(R)
        [C{i,j},B{i,j}]=CrossCorr(Range(R{i}),Range(R{j}),a,b);
    end
end


for i=1:length(R)
C{i,i}(B{i,i}==0)=0;    
end





figure('color',[1 1 1]), 

for i=1:length(R)
    for j=1:length(R)
        
        subplot(length(R),length(R),MatXY(i,j,length(R)))
    
        
        hold on, area(B{i,j}/1E3,C{i,j},'facecolor','k'), yl=ylim; line([0 0],yl,'color','r')
        area(B{i,i}/1E3,C{i,j},'facecolor','k'), 
   xlim([-a*b a*b]/2E3)
    
end

end


for i=1:length(R)
    
    
subplot(length(R),length(R),MatXY(i,1,length(R))), ylabel(labels{i})
subplot(length(R),length(R),MatXY(1,i,length(R))), title(labels{i})
end
set(gcf,'Position',[226 -7 1316 937])
% 
% set(gca, 'xtick',[1:length(R)])
% set(gca, 'ytick',[1:length(R)])
% set(gca, 'xticklabel',labels)
% set(gca, 'yticklabel',labels)






%--------------------------------------------------------------------------
%%5------------------------------------------------------------------------
%--------------------------------------------------------------------------


a=50; b=300;
for i=1:length(R)
    for j=1:length(R)
        [C{i,j},B{i,j}]=CrossCorr(Range(R{i}),Range(R{j}),a,b);
    end
end


for i=1:length(R)
C{i,i}(B{i,i}==0)=0;    
end





figure('color',[1 1 1]), 

for i=1:length(R)
    for j=1:length(R)
        
        subplot(length(R),length(R),MatXY(i,j,length(R)))
    
        
        hold on, area(B{i,j}/1E3,C{i,j},'facecolor','k'), yl=ylim; line([0 0],yl,'color','r')
        area(B{i,i}/1E3,C{i,j},'facecolor','k'), 
   xlim([-a*b a*b]/2E3)
%    xlim([-a*b a*b]/2E4)
end

end


set(gcf,'Position',[226 -7 1316 937])

for i=1:length(R)
    
    
subplot(length(R),length(R),MatXY(i,1,length(R))), ylabel(labels{i})
subplot(length(R),length(R),MatXY(1,i,length(R))), title(labels{i})
end




%--------------------------------------------------------------------------
%%6------------------------------------------------------------------------
%--------------------------------------------------------------------------





a=20; b=100;
for i=1:length(R)
    for j=1:length(R)
        [C{i,j},B{i,j}]=CrossCorr(Range(R{i}),Range(R{j}),a,b);
    end
end


for i=1:length(R)
C{i,i}(B{i,i}==0)=0;    
end





figure('color',[1 1 1]), 

for i=1:length(R)
    for j=1:length(R)
        
        subplot(length(R),length(R),MatXY(i,j,length(R)))
    
        
        hold on, area(B{i,j}/1E3,C{i,j},'facecolor','k'), yl=ylim; line([0 0],yl,'color','r')
        area(B{i,i}/1E3,C{i,j},'facecolor','k'), 
   xlim([-a*b a*b]/2E3)
 %   xlim([-a*b a*b]/2E4)
end

end


set(gcf,'Position',[226 -7 1316 937])

for i=1:length(R)
    
    
subplot(length(R),length(R),MatXY(i,1,length(R))), ylabel(labels{i})
subplot(length(R),length(R),MatXY(1,i,length(R))), title(labels{i})
end








%--------------------------------------------------------------------------
%%7------------------------------------------------------------------------
%--------------------------------------------------------------------------


a=10; b=150;
for i=1:length(R)
    for j=1:length(R)
        [C{i,j},B{i,j}]=CrossCorr(Range(R{i}),Range(R{j}),a,b);
    end
end


for i=1:length(R)
C{i,i}(B{i,i}==0)=0;    
end





figure('color',[1 1 1]), 

for i=1:length(R)
    for j=1:length(R)
        
        subplot(length(R),length(R),MatXY(i,j,length(R)))
    
        
        hold on, area(B{i,j}/1E3,C{i,j},'facecolor','k'), yl=ylim; line([0 0],yl,'color','r')
        area(B{i,i}/1E3,C{i,j},'facecolor','k'), 
   xlim([-a*b a*b]/2E3)
%    xlim([-a*b a*b]/2E3)
end

end


set(gcf,'Position',[226 -7 1316 937])

for i=1:length(R)
    
    
subplot(length(R),length(R),MatXY(i,1,length(R))), ylabel(labels{i})
subplot(length(R),length(R),MatXY(1,i,length(R))), title(labels{i})
end





%--------------------------------------------------------------------------
%%8------------------------------------------------------------------------
%--------------------------------------------------------------------------


a=10; b=50;


try
    C;
    B;
catch
    

        for i=1:length(R)
            for j=1:length(R)
                [C{i,j},B{i,j}]=CrossCorr(Range(R{i}),Range(R{j}),a,b);
            end
        end


        for i=1:length(R)
        C{i,i}(B{i,i}==0)=0;    
        end

end



figure('color',[1 1 1]), 

for i=1:length(R)
    for j=1:length(R)
        
        subplot(length(R),length(R),MatXY(i,j,length(R)))
    
        
        hold on, area(B{i,j}/1E3,C{i,j},'facecolor','k'), yl=ylim; line([0 0],yl,'color','r')
        area(B{i,i}/1E3,C{i,j},'facecolor','k'), 
   xlim([-a*b a*b]/2E3)
%    xlim([-a*b a*b]/2E3)
end

end


set(gcf,'Position',[226 -7 1316 937])

for i=1:length(R)
    
    
subplot(length(R),length(R),MatXY(i,1,length(R))), ylabel(labels{i})
subplot(length(R),length(R),MatXY(1,i,length(R))), title(labels{i})
end







end


%--------------------------------------------------------------------------
%------------------------------------------------------------------------
%--------------------------------------------------------------------------

th=1500;
nBins=25;


EEGsleep=LFP{15};


try
    
    Epoch;
catch
    rg=Range(EEGsleep);
Epoch=intervalSet(rg(1),rg(end));
end
    
badEpoch1=thresholdIntervals(EEGsleep,th,'Direction','Above');
badEpoch2=thresholdIntervals(EEGsleep,-th,'Direction','Below');

badEpoch=or(badEpoch1,badEpoch2);
badEpoch=dropShortIntervals(badEpoch,0.01E4);
badEpoch=mergeCloseIntervals(badEpoch,4E4);
badEpoch=dropShortIntervals(badEpoch,4E4);


deb=rg(1);
goodEpoch=Epoch-badEpoch;

% 
% EpochSWS=intervalSet(180*1E4,210*1E4);
% 
% goodEpoch=and(goodEpoch,EpochSWS);

%--------------------------------------------------------------------------


EEGsleep=LFP{1};

% badEpoch1=thresholdIntervals(EEGsleep,th,'Direction','Above');
% badEpoch2=thresholdIntervals(EEGsleep,-th,'Direction','Below');
% 
% badEpoch=or(badEpoch1,badEpoch2);
% badEpoch=dropShortIntervals(badEpoch,0.01E4);
% badEpoch=mergeCloseIntervals(badEpoch,4E4);
% badEpoch=dropShortIntervals(badEpoch,4E4);
% 
% rg=Range(EEGsleep);
% Epoch=intervalSet(rg(1),rg(end));
% deb=rg(1);
% goodEpoch=Epoch-badEpoch;

EEGf=FilterLFP(EEGsleep,[1 4],1024);
figure('color',[1 1 1])
try
[phaseTsd, ph] = firingPhaseHilbert(EEGf, {Restrict(Sp1, goodEpoch)}) ;
subplot(1,3,1), [muSD(1,1), KappaSD(1,1), pvalSD(1,1)]=JustPoltMod(Data(ph{1}),nBins);
ylabel('Spindles vs Delta waves LFP Pfc')
end
try
[phaseTsd, ph] = firingPhaseHilbert(EEGf, {Restrict(Sp2, goodEpoch)}) ;
subplot(1,3,2), [muSD(2,1), KappaSD(2,1), pvalSD(2,1)]=JustPoltMod(Data(ph{1}),nBins);
end
try
[phaseTsd, ph] = firingPhaseHilbert(EEGf, {Restrict(Sp3, goodEpoch)}) ;
subplot(1,3,3), [muSD(3,1), KappaSD(3,1), pvalSD(3,1)]=JustPoltMod(Data(ph{1}),nBins);
end
set(gcf,'Position',[73 533 1450 390])


figure('color',[1 1 1])
try
[phaseTsd, ph] = firingPhaseHilbert(EEGf, {Restrict(Ri1, goodEpoch)}) ;
subplot(1,3,1), 
[muRD(1,1), KappaRD(1,1), pvalRD(1,1)]=JustPoltMod(Data(ph{1}),nBins);
ylabel('Ripples vs Delta waves LFP Pfc')
end
try
[phaseTsd, ph] = firingPhaseHilbert(EEGf, {Restrict(Ri2, goodEpoch)}) ;
subplot(1,3,2), 
[muRD(2,1), KappaRD(2,1), pvalRD(2,1)]=JustPoltMod(Data(ph{1}),nBins);
end
try
[phaseTsd, ph] = firingPhaseHilbert(EEGf, {Restrict(Ri3, goodEpoch)}) ;
subplot(1,3,3), 
[muRD(3,1), KappaRD(3,1), pvalRD(3,1)]=JustPoltMod(Data(ph{1}),nBins);
end
set(gcf,'Position',[73 533 1450 390])


%--------------------------------------------------------------------------




EEGsleep=LFP{5};
% 
% badEpoch1=thresholdIntervals(EEGsleep,th,'Direction','Above');
% badEpoch2=thresholdIntervals(EEGsleep,-th,'Direction','Below');
% 
% badEpoch=or(badEpoch1,badEpoch2);
% badEpoch=dropShortIntervals(badEpoch,0.01E4);
% badEpoch=mergeCloseIntervals(badEpoch,4E4);
% badEpoch=dropShortIntervals(badEpoch,4E4);
% 
% rg=Range(EEGsleep);
% Epoch=intervalSet(rg(1),rg(end));
% deb=rg(1);
% goodEpoch=Epoch-badEpoch;

EEGf=FilterLFP(EEGsleep,[1 4],1024);

figure('color',[1 1 1])
try
[phaseTsd, ph] = firingPhaseHilbert(EEGf, {Restrict(Sp1, goodEpoch)}) ;
subplot(1,3,1), [muSD(1,2), KappaSD(1,2), pvalSD(1,2)]=JustPoltMod(Data(ph{1}),nBins);
ylabel('Spindles vs Delta waves EEG Par')
end
try
[phaseTsd, ph] = firingPhaseHilbert(EEGf, {Restrict(Sp2, goodEpoch)}) ;
subplot(1,3,2), [muSD(2,2), KappaSD(2,2), pvalSD(2,2)]=JustPoltMod(Data(ph{1}),nBins);
end
try
[phaseTsd, ph] = firingPhaseHilbert(EEGf, {Restrict(Sp3, goodEpoch)}) ;
subplot(1,3,3), [muSD(3,2), KappaSD(3,2), pvalSD(3,2)]=JustPoltMod(Data(ph{1}),nBins);
end
set(gcf,'Position',[73 533 1450 390])




figure('color',[1 1 1])
try
[phaseTsd, ph] = firingPhaseHilbert(EEGf, {Restrict(Ri1, goodEpoch)}) ;
subplot(1,3,1), 
[muRD(1,2), KappaRD(1,2), pvalRD(1,2)]=JustPoltMod(Data(ph{1}),nBins);
ylabel('Ripples vs Delta waves EEG Par')
end
try
[phaseTsd, ph] = firingPhaseHilbert(EEGf, {Restrict(Ri2, goodEpoch)}) ;
subplot(1,3,2), 
[muRD(2,2), KappaRD(2,2), pvalRD(2,2)]=JustPoltMod(Data(ph{1}),nBins);
end
try
[phaseTsd, ph] = firingPhaseHilbert(EEGf, {Restrict(Ri3, goodEpoch)}) ;
subplot(1,3,3), 
[muRD(3,2), KappaRD(3,2), pvalRD(3,2)]=JustPoltMod(Data(ph{1}),nBins);
end
set(gcf,'Position',[73 533 1450 390])

%--------------------------------------------------------------------------





EEGsleep=LFP{7};
% 
% badEpoch1=thresholdIntervals(EEGsleep,th,'Direction','Above');
% badEpoch2=thresholdIntervals(EEGsleep,-th,'Direction','Below');
% 
% badEpoch=or(badEpoch1,badEpoch2);
% badEpoch=dropShortIntervals(badEpoch,0.01E4);
% badEpoch=mergeCloseIntervals(badEpoch,4E4);
% badEpoch=dropShortIntervals(badEpoch,4E4);
% 
% rg=Range(EEGsleep);
% Epoch=intervalSet(rg(1),rg(end));
% deb=rg(1);
% goodEpoch=Epoch-badEpoch;

EEGf=FilterLFP(EEGsleep,[1 4],1024);

figure('color',[1 1 1])
try
[phaseTsd, ph] = firingPhaseHilbert(EEGf, {Restrict(Sp1, goodEpoch)}) ;
subplot(1,3,1), [muSD(1,3), KappaSD(1,3), pvalSD(1,3)]=JustPoltMod(Data(ph{1}),nBins);
ylabel('Spindles vs Delta waves LFP Par')
end
try
[phaseTsd, ph] = firingPhaseHilbert(EEGf, {Restrict(Sp2, goodEpoch)}) ;
subplot(1,3,2), [muSD(2,3), KappaSD(2,3), pvalSD(2,3)]=JustPoltMod(Data(ph{1}),nBins);
end
try
[phaseTsd, ph] = firingPhaseHilbert(EEGf, {Restrict(Sp3, goodEpoch)}) ;
subplot(1,3,3), [muSD(3,3), KappaSD(3,3), pvalSD(3,3)]=JustPoltMod(Data(ph{1}),nBins);
end
set(gcf,'Position',[73 533 1450 390])


figure('color',[1 1 1])
try
[phaseTsd, ph] = firingPhaseHilbert(EEGf, {Restrict(Ri1, goodEpoch)}) ;
subplot(1,3,1), 
[muRD(1,3), KappaRD(1,3), pvalRD(1,3)]=JustPoltMod(Data(ph{1}),nBins);
ylabel('Ripples vs Delta waves LFP Par')
end
try
[phaseTsd, ph] = firingPhaseHilbert(EEGf, {Restrict(Ri2, goodEpoch)}) ;
subplot(1,3,2), 
[muRD(2,3), KappaRD(2,3), pvalRD(2,3)]=JustPoltMod(Data(ph{1}),nBins);
end
try
[phaseTsd, ph] = firingPhaseHilbert(EEGf, {Restrict(Ri3, goodEpoch)}) ;
subplot(1,3,3), 
[muRD(3,3), KappaRD(3,3), pvalRD(3,3)]=JustPoltMod(Data(ph{1}),nBins);
end
set(gcf,'Position',[73 533 1450 390])

%--------------------------------------------------------------------------




EEGsleep=LFP{10};

% badEpoch1=thresholdIntervals(EEGsleep,th,'Direction','Above');
% badEpoch2=thresholdIntervals(EEGsleep,-th,'Direction','Below');
% 
% badEpoch=or(badEpoch1,badEpoch2);
% badEpoch=dropShortIntervals(badEpoch,0.01E4);
% badEpoch=mergeCloseIntervals(badEpoch,4E4);
% badEpoch=dropShortIntervals(badEpoch,4E4);
% 
% rg=Range(EEGsleep);
% Epoch=intervalSet(rg(1),rg(end));
% deb=rg(1);
% goodEpoch=Epoch-badEpoch;

EEGf=FilterLFP(EEGsleep,[1 4],1024);

figure('color',[1 1 1])
try
[phaseTsd, ph] = firingPhaseHilbert(EEGf, {Restrict(Sp1, goodEpoch)}) ;
subplot(1,3,1), [muSD(1,4), KappaSD(1,4), pvalSD(1,4)]=JustPoltMod(Data(ph{1}),nBins);
ylabel('Spindles vs Delta waves EEG Aud')
end
try
[phaseTsd, ph] = firingPhaseHilbert(EEGf, {Restrict(Sp2, goodEpoch)}) ;
subplot(1,3,2), [muSD(2,4), KappaSD(2,4), pvalSD(2,4)]=JustPoltMod(Data(ph{1}),nBins);
end
try
[phaseTsd, ph] = firingPhaseHilbert(EEGf, {Restrict(Sp3, goodEpoch)}) ;
subplot(1,3,3), [muSD(3,4), KappaSD(3,4), pvalSD(3,4)]=JustPoltMod(Data(ph{1}),nBins);
end
set(gcf,'Position',[73 533 1450 390])


figure('color',[1 1 1])
try
[phaseTsd, ph] = firingPhaseHilbert(EEGf, {Restrict(Ri1, goodEpoch)}) ;
subplot(1,3,1), 
[muRD(1,4), KappaRD(1,4), pvalRD(1,4)]=JustPoltMod(Data(ph{1}),nBins);
ylabel('Ripples vs Delta waves EEG Aud')
end
try
[phaseTsd, ph] = firingPhaseHilbert(EEGf, {Restrict(Ri2, goodEpoch)}) ;
subplot(1,3,2), 
[muRD(2,4), KappaRD(2,4), pvalRD(2,4)]=JustPoltMod(Data(ph{1}),nBins);
end
try
[phaseTsd, ph] = firingPhaseHilbert(EEGf, {Restrict(Ri3, goodEpoch)}) ;
subplot(1,3,3), 
[muRD(3,4), KappaRD(3,4), pvalRD(3,4)]=JustPoltMod(Data(ph{1}),nBins);
end
set(gcf,'Position',[73 533 1450 390])


%--------------------------------------------------------------------------




EEGsleep=LFP{12};

% badEpoch1=thresholdIntervals(EEGsleep,th,'Direction','Above');
% badEpoch2=thresholdIntervals(EEGsleep,-th,'Direction','Below');
% 
% badEpoch=or(badEpoch1,badEpoch2);
% badEpoch=dropShortIntervals(badEpoch,0.01E4);
% badEpoch=mergeCloseIntervals(badEpoch,4E4);
% badEpoch=dropShortIntervals(badEpoch,4E4);
% 
% rg=Range(EEGsleep);
% Epoch=intervalSet(rg(1),rg(end));
% deb=rg(1);
% goodEpoch=Epoch-badEpoch;

EEGf=FilterLFP(EEGsleep,[1 4],1024);

figure('color',[1 1 1])
try
[phaseTsd, ph] = firingPhaseHilbert(EEGf, {Restrict(Sp1, goodEpoch)}) ;
subplot(1,3,1), [muSD(1,5), KappaSD(1,5), pvalSD(1,5)]=JustPoltMod(Data(ph{1}),nBins);
ylabel('Spindles vs Delta waves LFP Aud deep')
end
try
[phaseTsd, ph] = firingPhaseHilbert(EEGf, {Restrict(Sp2, goodEpoch)}) ;
subplot(1,3,2), [muSD(2,5), KappaSD(2,5), pvalSD(2,5)]=JustPoltMod(Data(ph{1}),nBins);
end
try
[phaseTsd, ph] = firingPhaseHilbert(EEGf, {Restrict(Sp3, goodEpoch)}) ;
subplot(1,3,3), [muSD(3,5), KappaSD(3,5), pvalSD(3,5)]=JustPoltMod(Data(ph{1}),nBins);
end
set(gcf,'Position',[73 533 1450 390])



figure('color',[1 1 1])
try
[phaseTsd, ph] = firingPhaseHilbert(EEGf, {Restrict(Ri1, goodEpoch)}) ;
subplot(1,3,1), 
[muRD(1,5), KappaRD(1,5), pvalRD(1,5)]=JustPoltMod(Data(ph{1}),nBins);
ylabel('Ripples vs Delta waves LFP Aud deep')
end
try
[phaseTsd, ph] = firingPhaseHilbert(EEGf, {Restrict(Ri2, goodEpoch)}) ;
subplot(1,3,2), 
[muRD(2,5), KappaRD(2,5), pvalRD(2,5)]=JustPoltMod(Data(ph{1}),nBins);
end
try
[phaseTsd, ph] = firingPhaseHilbert(EEGf, {Restrict(Ri3, goodEpoch)}) ;
subplot(1,3,3), 
[muRD(3,5), KappaRD(3,5), pvalRD(3,5)]=JustPoltMod(Data(ph{1}),nBins);
end
set(gcf,'Position',[73 533 1450 390])

%--------------------------------------------------------------------------




EEGsleep=LFP{15};

% badEpoch1=thresholdIntervals(EEGsleep,th,'Direction','Above');
% badEpoch2=thresholdIntervals(EEGsleep,-th,'Direction','Below');
% 
% badEpoch=or(badEpoch1,badEpoch2);
% badEpoch=dropShortIntervals(badEpoch,0.01E4);
% badEpoch=mergeCloseIntervals(badEpoch,4E4);
% badEpoch=dropShortIntervals(badEpoch,4E4);
% 
% rg=Range(EEGsleep);
% Epoch=intervalSet(rg(1),rg(end));
% deb=rg(1);
% goodEpoch=Epoch-badEpoch;

EEGf=FilterLFP(EEGsleep,[1 4],1024);


figure('color',[1 1 1])
try
[phaseTsd, ph] = firingPhaseHilbert(EEGf, {Restrict(Sp1, goodEpoch)}) ;
subplot(1,3,1), [muSD(1,6), KappaSD(1,6), pvalSD(1,6)]=JustPoltMod(Data(ph{1}),nBins);
ylabel('Spindles vs Delta waves LFP Aud sup')
end
try
[phaseTsd, ph] = firingPhaseHilbert(EEGf, {Restrict(Sp2, goodEpoch)}) ;
subplot(1,3,2), [muSD(2,6), KappaSD(2,6), pvalSD(2,6)]=JustPoltMod(Data(ph{1}),nBins);
end
try
[phaseTsd, ph] = firingPhaseHilbert(EEGf, {Restrict(Sp3, goodEpoch)}) ;
subplot(1,3,3), [muSD(3,6), KappaSD(3,6), pvalSD(3,6)]=JustPoltMod(Data(ph{1}),nBins);
end
set(gcf,'Position',[73 533 1450 390])



figure('color',[1 1 1])
try
[phaseTsd, ph] = firingPhaseHilbert(EEGf, {Restrict(Ri1, goodEpoch)}) ;
subplot(1,3,1), 
[muRD(1,6), KappaRD(1,6), pvalRD(1,6)]=JustPoltMod(Data(ph{1}),nBins);
ylabel('Ripples vs Delta waves LFP Aud sup')
end
try
[phaseTsd, ph] = firingPhaseHilbert(EEGf, {Restrict(Ri2, goodEpoch)}) ;
subplot(1,3,2), 
[muRD(2,6), KappaRD(2,6), pvalRD(2,6)]=JustPoltMod(Data(ph{1}),nBins);
end
try
[phaseTsd, ph] = firingPhaseHilbert(EEGf, {Restrict(Ri3, goodEpoch)}) ;
subplot(1,3,3), 
[muRD(3,6), KappaRD(3,6), pvalRD(3,6)]=JustPoltMod(Data(ph{1}),nBins);
end
set(gcf,'Position',[73 533 1450 390])


%--------------------------------------------------------------------------
%--------------------------------------------------------------------------
%--------------------------------------------------------------------------





%--------------------------------------------------------------------------
%--------------------------------------------------------------------------
%--------------------------------------------------------------------------



EEGsleep=LFP{1};

% badEpoch1=thresholdIntervals(EEGsleep,th,'Direction','Above');
% badEpoch2=thresholdIntervals(EEGsleep,-th,'Direction','Below');
% 
% badEpoch=or(badEpoch1,badEpoch2);
% badEpoch=dropShortIntervals(badEpoch,0.01E4);
% badEpoch=mergeCloseIntervals(badEpoch,4E4);
% badEpoch=dropShortIntervals(badEpoch,4E4);
% 
% rg=Range(EEGsleep);
% Epoch=intervalSet(rg(1),rg(end));
% deb=rg(1);
% goodEpoch=Epoch-badEpoch;

EEGf=FilterLFP(EEGsleep,[10 15],1024);




figure('color',[1 1 1])
try
[phaseTsd, ph] = firingPhaseHilbert(EEGf, {Restrict(Ri1, goodEpoch)}) ;
subplot(1,3,1), 
[muRS(1,1), KappaRS(1,1), pvalRS(1,1)]=JustPoltMod(Data(ph{1}),nBins);
ylabel('Ripples vs Spindles LFP Pfc')
end
try
[phaseTsd, ph] = firingPhaseHilbert(EEGf, {Restrict(Ri2, goodEpoch)}) ;
subplot(1,3,2), 
[muRS(2,1), KappaRS(2,1), pvalRS(2,1)]=JustPoltMod(Data(ph{1}),nBins);
end
try
[phaseTsd, ph] = firingPhaseHilbert(EEGf, {Restrict(Ri3, goodEpoch)}) ;
subplot(1,3,3), 
[muRS(3,1), KappaRS(3,1), pvalRS(3,1)]=JustPoltMod(Data(ph{1}),nBins);
end
set(gcf,'Position',[73 533 1450 390])



%--------------------------------------------------------------------------




EEGsleep=LFP{5};

% badEpoch1=thresholdIntervals(EEGsleep,th,'Direction','Above');
% badEpoch2=thresholdIntervals(EEGsleep,-th,'Direction','Below');
% 
% badEpoch=or(badEpoch1,badEpoch2);
% badEpoch=dropShortIntervals(badEpoch,0.01E4);
% badEpoch=mergeCloseIntervals(badEpoch,4E4);
% badEpoch=dropShortIntervals(badEpoch,4E4);
% 
% rg=Range(EEGsleep);
% Epoch=intervalSet(rg(1),rg(end));
% deb=rg(1);
% goodEpoch=Epoch-badEpoch;

EEGf=FilterLFP(EEGsleep,[10 15],1024);




figure('color',[1 1 1])
try
[phaseTsd, ph] = firingPhaseHilbert(EEGf, {Restrict(Ri1, goodEpoch)}) ;
subplot(1,3,1), 
[muRS(1,2), KappaRS(1,2), pvalRS(1,2)]=JustPoltMod(Data(ph{1}),nBins);
ylabel('Ripples vs Spindles EEG Par')
end
try
[phaseTsd, ph] = firingPhaseHilbert(EEGf, {Restrict(Ri2, goodEpoch)}) ;
subplot(1,3,2), 
[muRS(2,2), KappaRS(2,2), pvalRS(2,2)]=JustPoltMod(Data(ph{1}),nBins);
end
try
[phaseTsd, ph] = firingPhaseHilbert(EEGf, {Restrict(Ri3, goodEpoch)}) ;
subplot(1,3,3), 
[muRS(3,2), KappaRS(3,2), pvalRS(3,2)]=JustPoltMod(Data(ph{1}),nBins);
end
set(gcf,'Position',[73 533 1450 390])



%--------------------------------------------------------------------------




EEGsleep=LFP{7};

% badEpoch1=thresholdIntervals(EEGsleep,th,'Direction','Above');
% badEpoch2=thresholdIntervals(EEGsleep,-th,'Direction','Below');
% 
% badEpoch=or(badEpoch1,badEpoch2);
% badEpoch=dropShortIntervals(badEpoch,0.01E4);
% badEpoch=mergeCloseIntervals(badEpoch,4E4);
% badEpoch=dropShortIntervals(badEpoch,4E4);
% 
% rg=Range(EEGsleep);
% Epoch=intervalSet(rg(1),rg(end));
% deb=rg(1);
% goodEpoch=Epoch-badEpoch;

EEGf=FilterLFP(EEGsleep,[10 15],1024);




figure('color',[1 1 1])
try
[phaseTsd, ph] = firingPhaseHilbert(EEGf, {Restrict(Ri1, goodEpoch)}) ;
subplot(1,3,1), 
[muRS(1,3), KappaRS(1,3), pvalRS(1,3)]=JustPoltMod(Data(ph{1}),nBins);
ylabel('Ripples vs Spindles LFP Par')
end
try
[phaseTsd, ph] = firingPhaseHilbert(EEGf, {Restrict(Ri2, goodEpoch)}) ;
subplot(1,3,2), 
[muRS(2,3), KappaRS(2,3), pvalRS(2,3)]=JustPoltMod(Data(ph{1}),nBins);
end
try
[phaseTsd, ph] = firingPhaseHilbert(EEGf, {Restrict(Ri3, goodEpoch)}) ;
subplot(1,3,3), 
[muRS(3,3), KappaRS(3,3), pvalRS(3,3)]=JustPoltMod(Data(ph{1}),nBins);
end
set(gcf,'Position',[73 533 1450 390])



%--------------------------------------------------------------------------




EEGsleep=LFP{10};

% badEpoch1=thresholdIntervals(EEGsleep,th,'Direction','Above');
% badEpoch2=thresholdIntervals(EEGsleep,-th,'Direction','Below');
% 
% badEpoch=or(badEpoch1,badEpoch2);
% badEpoch=dropShortIntervals(badEpoch,0.01E4);
% badEpoch=mergeCloseIntervals(badEpoch,4E4);
% badEpoch=dropShortIntervals(badEpoch,4E4);
% 
% rg=Range(EEGsleep);
% Epoch=intervalSet(rg(1),rg(end));
% deb=rg(1);
% goodEpoch=Epoch-badEpoch;

EEGf=FilterLFP(EEGsleep,[10 15],1024);




figure('color',[1 1 1])
try
[phaseTsd, ph] = firingPhaseHilbert(EEGf, {Restrict(Ri1, goodEpoch)}) ;
subplot(1,3,1), 
[muRS(1,4), KappaRS(1,4), pvalRS(1,4)]=JustPoltMod(Data(ph{1}),nBins);
ylabel('Ripples vs Spindles EEG Aud')
end
try
[phaseTsd, ph] = firingPhaseHilbert(EEGf, {Restrict(Ri2, goodEpoch)}) ;
subplot(1,3,2), 
[muRS(2,4), KappaRS(2,4), pvalRS(2,4)]=JustPoltMod(Data(ph{1}),nBins);
end
try
[phaseTsd, ph] = firingPhaseHilbert(EEGf, {Restrict(Ri3, goodEpoch)}) ;
subplot(1,3,3), 
[muRS(3,4), KappaRS(3,4), pvalRS(3,4)]=JustPoltMod(Data(ph{1}),nBins);
end
set(gcf,'Position',[73 533 1450 390])



%--------------------------------------------------------------------------





EEGsleep=LFP{12};

% badEpoch1=thresholdIntervals(EEGsleep,th,'Direction','Above');
% badEpoch2=thresholdIntervals(EEGsleep,-th,'Direction','Below');
% 
% badEpoch=or(badEpoch1,badEpoch2);
% badEpoch=dropShortIntervals(badEpoch,0.01E4);
% badEpoch=mergeCloseIntervals(badEpoch,4E4);
% badEpoch=dropShortIntervals(badEpoch,4E4);
% 
% rg=Range(EEGsleep);
% Epoch=intervalSet(rg(1),rg(end));
% deb=rg(1);
% goodEpoch=Epoch-badEpoch;

EEGf=FilterLFP(EEGsleep,[10 15],1024);




figure('color',[1 1 1])
try
[phaseTsd, ph] = firingPhaseHilbert(EEGf, {Restrict(Ri1, goodEpoch)}) ;
subplot(1,3,1), 
[muRS(1,5), KappaRS(1,5), pvalRS(1,5)]=JustPoltMod(Data(ph{1}),nBins);
ylabel('Ripples vs Spindles LFP Aud deep')
end
try
[phaseTsd, ph] = firingPhaseHilbert(EEGf, {Restrict(Ri2, goodEpoch)}) ;
subplot(1,3,2), 
[muRS(2,5), KappaRS(2,5), pvalRS(2,5)]=JustPoltMod(Data(ph{1}),nBins);
end
try
[phaseTsd, ph] = firingPhaseHilbert(EEGf, {Restrict(Ri3, goodEpoch)}) ;
subplot(1,3,3), 
[muRS(3,5), KappaRS(3,5), pvalRS(3,5)]=JustPoltMod(Data(ph{1}),nBins);
end
set(gcf,'Position',[73 533 1450 390])



%--------------------------------------------------------------------------



EEGsleep=LFP{15};

% badEpoch1=thresholdIntervals(EEGsleep,th,'Direction','Above');
% badEpoch2=thresholdIntervals(EEGsleep,-th,'Direction','Below');
% 
% badEpoch=or(badEpoch1,badEpoch2);
% badEpoch=dropShortIntervals(badEpoch,0.01E4);
% badEpoch=mergeCloseIntervals(badEpoch,4E4);
% badEpoch=dropShortIntervals(badEpoch,4E4);
% 
% rg=Range(EEGsleep);
% Epoch=intervalSet(rg(1),rg(end));
% deb=rg(1);
% goodEpoch=Epoch-badEpoch;

EEGf=FilterLFP(EEGsleep,[10 15],1024);




figure('color',[1 1 1])
try
[phaseTsd, ph] = firingPhaseHilbert(EEGf, {Restrict(Ri1, goodEpoch)}) ;
subplot(1,3,1), 
[muRS(1,6), KappaRS(1,6), pvalRS(1,6)]=JustPoltMod(Data(ph{1}),nBins);
ylabel('Ripples vs Spindles LFP Aud sup')
end
try
[phaseTsd, ph] = firingPhaseHilbert(EEGf, {Restrict(Ri2, goodEpoch)}) ;
subplot(1,3,2), 
[muRS(2,6), KappaRS(2,6), pvalRS(2,6)]=JustPoltMod(Data(ph{1}),nBins);
end
try
[phaseTsd, ph] = firingPhaseHilbert(EEGf, {Restrict(Ri3, goodEpoch)}) ;
subplot(1,3,3), 
[muRS(3,6), KappaRS(3,6), pvalRS(3,6)]=JustPoltMod(Data(ph{1}),nBins);
end
set(gcf,'Position',[73 533 1450 390])



%--------------------------------------------------------------------------
%------------------------------------------------------------------------
%--------------------------------------------------------------------------



EEGsleep=LFP{1};

% badEpoch1=thresholdIntervals(EEGsleep,th,'Direction','Above');
% badEpoch2=thresholdIntervals(EEGsleep,-th,'Direction','Below');
% 
% badEpoch=or(badEpoch1,badEpoch2);
% badEpoch=dropShortIntervals(badEpoch,0.01E4);
% badEpoch=mergeCloseIntervals(badEpoch,4E4);
% badEpoch=dropShortIntervals(badEpoch,4E4);
% 
% rg=Range(EEGsleep);
% Epoch=intervalSet(rg(1),rg(end));
% deb=rg(1);
% goodEpoch=Epoch-badEpoch;

EEGf=FilterLFP(EEGsleep,[5 10],1024);




figure('color',[1 1 1])
try
[phaseTsd, ph] = firingPhaseHilbert(EEGf, {Restrict(Ri1, goodEpoch)}) ;
subplot(1,3,1), 
[muRT(1,1), KappaRT(1,1), pvalRT(1,1)]=JustPoltMod(Data(ph{1}),nBins);
ylabel('Ripples vs Theta LFP Pfc')
end
try
[phaseTsd, ph] = firingPhaseHilbert(EEGf, {Restrict(Ri2, goodEpoch)}) ;
subplot(1,3,2), 
[muRT(2,1), KappaRT(2,1), pvalRT(2,1)]=JustPoltMod(Data(ph{1}),nBins);
end
try
[phaseTsd, ph] = firingPhaseHilbert(EEGf, {Restrict(Ri3, goodEpoch)}) ;
subplot(1,3,3), 
[muRT(3,1), KappaRT(3,1), pvalRT(3,1)]=JustPoltMod(Data(ph{1}),nBins);
end
set(gcf,'Position',[73 533 1450 390])



%--------------------------------------------------------------------------




EEGsleep=LFP{5};

% badEpoch1=thresholdIntervals(EEGsleep,th,'Direction','Above');
% badEpoch2=thresholdIntervals(EEGsleep,-th,'Direction','Below');
% 
% badEpoch=or(badEpoch1,badEpoch2);
% badEpoch=dropShortIntervals(badEpoch,0.01E4);
% badEpoch=mergeCloseIntervals(badEpoch,4E4);
% badEpoch=dropShortIntervals(badEpoch,4E4);
% 
% rg=Range(EEGsleep);
% Epoch=intervalSet(rg(1),rg(end));
% deb=rg(1);
% goodEpoch=Epoch-badEpoch;

EEGf=FilterLFP(EEGsleep,[10 15],1024);




figure('color',[1 1 1])
try
[phaseTsd, ph] = firingPhaseHilbert(EEGf, {Restrict(Ri1, goodEpoch)}) ;
subplot(1,3,1), 
[muRT(1,2), KappaRT(1,2), pvalRT(1,2)]=JustPoltMod(Data(ph{1}),nBins);
ylabel('Ripples vs Theta EEG Par')
end
try
[phaseTsd, ph] = firingPhaseHilbert(EEGf, {Restrict(Ri2, goodEpoch)}) ;
subplot(1,3,2), 
[muRT(2,2), KappaRT(2,2), pvalRT(2,2)]=JustPoltMod(Data(ph{1}),nBins);
end
try
[phaseTsd, ph] = firingPhaseHilbert(EEGf, {Restrict(Ri3, goodEpoch)}) ;
subplot(1,3,3), 
[muRT(3,2), KappaRT(3,2), pvalRT(3,2)]=JustPoltMod(Data(ph{1}),nBins);
end
set(gcf,'Position',[73 533 1450 390])



%--------------------------------------------------------------------------




EEGsleep=LFP{7};

% badEpoch1=thresholdIntervals(EEGsleep,th,'Direction','Above');
% badEpoch2=thresholdIntervals(EEGsleep,-th,'Direction','Below');
% 
% badEpoch=or(badEpoch1,badEpoch2);
% badEpoch=dropShortIntervals(badEpoch,0.01E4);
% badEpoch=mergeCloseIntervals(badEpoch,4E4);
% badEpoch=dropShortIntervals(badEpoch,4E4);
% 
% rg=Range(EEGsleep);
% Epoch=intervalSet(rg(1),rg(end));
% deb=rg(1);
% goodEpoch=Epoch-badEpoch;

EEGf=FilterLFP(EEGsleep,[10 15],1024);




figure('color',[1 1 1])
try
[phaseTsd, ph] = firingPhaseHilbert(EEGf, {Restrict(Ri1, goodEpoch)}) ;
subplot(1,3,1), 
[muRT(1,3), KappaRT(1,3), pvalRT(1,3)]=JustPoltMod(Data(ph{1}),nBins);
ylabel('Ripples vs Theta LFP Par')
end
try
[phaseTsd, ph] = firingPhaseHilbert(EEGf, {Restrict(Ri2, goodEpoch)}) ;
subplot(1,3,2), 
[muRT(2,3), KappaRT(2,3), pvalRT(2,3)]=JustPoltMod(Data(ph{1}),nBins);
end
try
[phaseTsd, ph] = firingPhaseHilbert(EEGf, {Restrict(Ri3, goodEpoch)}) ;
subplot(1,3,3), 
[muRT(3,3), KappaRT(3,3), pvalRT(3,3)]=JustPoltMod(Data(ph{1}),nBins);
end
set(gcf,'Position',[73 533 1450 390])



%--------------------------------------------------------------------------




EEGsleep=LFP{10};

% badEpoch1=thresholdIntervals(EEGsleep,th,'Direction','Above');
% badEpoch2=thresholdIntervals(EEGsleep,-th,'Direction','Below');
% 
% badEpoch=or(badEpoch1,badEpoch2);
% badEpoch=dropShortIntervals(badEpoch,0.01E4);
% badEpoch=mergeCloseIntervals(badEpoch,4E4);
% badEpoch=dropShortIntervals(badEpoch,4E4);
% 
% rg=Range(EEGsleep);
% Epoch=intervalSet(rg(1),rg(end));
% deb=rg(1);
% goodEpoch=Epoch-badEpoch;

EEGf=FilterLFP(EEGsleep,[10 15],1024);




figure('color',[1 1 1])
try
[phaseTsd, ph] = firingPhaseHilbert(EEGf, {Restrict(Ri1, goodEpoch)}) ;
subplot(1,3,1), 
[muRT(1,4), KappaRT(1,4), pvalRT(1,4)]=JustPoltMod(Data(ph{1}),nBins);
ylabel('Ripples vs Theta EEG Aud')
end
try
[phaseTsd, ph] = firingPhaseHilbert(EEGf, {Restrict(Ri2, goodEpoch)}) ;
subplot(1,3,2), 
[muRT(2,4), KappaRT(2,4), pvalRT(2,4)]=JustPoltMod(Data(ph{1}),nBins);
end
try
[phaseTsd, ph] = firingPhaseHilbert(EEGf, {Restrict(Ri3, goodEpoch)}) ;
subplot(1,3,3), 
[muRT(3,4), KappaRT(3,4), pvalRT(3,4)]=JustPoltMod(Data(ph{1}),nBins);
end
set(gcf,'Position',[73 533 1450 390])



%--------------------------------------------------------------------------





EEGsleep=LFP{12};

% badEpoch1=thresholdIntervals(EEGsleep,th,'Direction','Above');
% badEpoch2=thresholdIntervals(EEGsleep,-th,'Direction','Below');
% 
% badEpoch=or(badEpoch1,badEpoch2);
% badEpoch=dropShortIntervals(badEpoch,0.01E4);
% badEpoch=mergeCloseIntervals(badEpoch,4E4);
% badEpoch=dropShortIntervals(badEpoch,4E4);
% 
% rg=Range(EEGsleep);
% Epoch=intervalSet(rg(1),rg(end));
% deb=rg(1);
% goodEpoch=Epoch-badEpoch;

EEGf=FilterLFP(EEGsleep,[10 15],1024);




figure('color',[1 1 1])
try
[phaseTsd, ph] = firingPhaseHilbert(EEGf, {Restrict(Ri1, goodEpoch)}) ;
subplot(1,3,1), 
[muRT(1,5), KappaRT(1,5), pvalRT(1,5)]=JustPoltMod(Data(ph{1}),nBins);
ylabel('Ripples vs Theta LFP Aud deep')
end
try
[phaseTsd, ph] = firingPhaseHilbert(EEGf, {Restrict(Ri2, goodEpoch)}) ;
subplot(1,3,2), 
[muRT(2,5), KappaRT(2,5), pvalRT(2,5)]=JustPoltMod(Data(ph{1}),nBins);
end
try
[phaseTsd, ph] = firingPhaseHilbert(EEGf, {Restrict(Ri3, goodEpoch)}) ;
subplot(1,3,3), 
[muRT(3,5), KappaRT(3,5), pvalRT(3,5)]=JustPoltMod(Data(ph{1}),nBins);
end
set(gcf,'Position',[73 533 1450 390])



%--------------------------------------------------------------------------



EEGsleep=LFP{15};

% badEpoch1=thresholdIntervals(EEGsleep,th,'Direction','Above');
% badEpoch2=thresholdIntervals(EEGsleep,-th,'Direction','Below');
% 
% badEpoch=or(badEpoch1,badEpoch2);
% badEpoch=dropShortIntervals(badEpoch,0.01E4);
% badEpoch=mergeCloseIntervals(badEpoch,4E4);
% badEpoch=dropShortIntervals(badEpoch,4E4);
% 
% rg=Range(EEGsleep);
% Epoch=intervalSet(rg(1),rg(end));
% deb=rg(1);
% goodEpoch=Epoch-badEpoch;

EEGf=FilterLFP(EEGsleep,[10 15],1024);




figure('color',[1 1 1])
try
[phaseTsd, ph] = firingPhaseHilbert(EEGf, {Restrict(Ri1, goodEpoch)}) ;
subplot(1,3,1), 
[muRT(1,6), KappaRT(1,6), pvalRT(1,6)]=JustPoltMod(Data(ph{1}),nBins);
ylabel('Ripples vs Theta LFP Aud sup')
end
try
[phaseTsd, ph] = firingPhaseHilbert(EEGf, {Restrict(Ri2, goodEpoch)}) ;
subplot(1,3,2), 
[muRT(2,6), KappaRT(2,6), pvalRT(2,6)]=JustPoltMod(Data(ph{1}),nBins);
end
try
[phaseTsd, ph] = firingPhaseHilbert(EEGf, {Restrict(Ri3, goodEpoch)}) ;
subplot(1,3,3), 
[muRT(3,6), KappaRT(3,6), pvalRT(3,6)]=JustPoltMod(Data(ph{1}),nBins);
end
set(gcf,'Position',[73 533 1450 390])





%--------------------------------------------------------------------------
%--------------------------------------------------------------------------
%--------------------------------------------------------------------------





figure('color',[1 1 1]), 
subplot(3,1,1), imagesc(muSD)
set(gca, 'xtick',[1:6])
set(gca, 'xticklabel',{'Pfc','Par EEG','Par LFP', 'Aud EEG', 'Aud LFP deep', 'Aud LFP sup'})
set(gca, 'ytick',[1:3])
set(gca, 'yticklabel',{'Aud','Par','Pfc'})
ylabel('Spindles')
title('Phase vs. Delta Waves')
colorbar

subplot(3,1,2), imagesc(KappaSD)
set(gca, 'xtick',[1:6])
set(gca, 'xticklabel',{'Pfc','Par EEG','Par LFP', 'Aud EEG', 'Aud LFP deep', 'Aud LFP sup'})
set(gca, 'ytick',[1:3])
set(gca, 'yticklabel',{'Aud','Par','Pfc'})
ylabel('Spindles')
title('Kappa vs. Delta Waves')
colorbar

subplot(3,1,3), imagesc(pvalSD)
set(gca, 'xtick',[1:6])
set(gca, 'xticklabel',{'Pfc','Par EEG','Par LFP', 'Aud EEG', 'Aud LFP deep', 'Aud LFP sup'})
set(gca, 'ytick',[1:3])
set(gca, 'yticklabel',{'Aud','Par','Pfc'})
ylabel('Spindles')
title('P value vs. Delta Waves')
colorbar
set(gcf,'Position',[885 207 750 642])

%--------------------------------------------------------------------------

figure('color',[1 1 1]), 
subplot(3,1,1), imagesc(muRD)
set(gca, 'xtick',[1:6])
set(gca, 'xticklabel',{'Pfc','Par EEG','Par LFP', 'Aud EEG', 'Aud LFP deep', 'Aud LFP sup'})
set(gca, 'ytick',[1:3])
set(gca, 'yticklabel',{'Aud','Par','Pfc'})
ylabel('Ripples')
title('Phase vs. Delta Waves')
colorbar

subplot(3,1,2), imagesc(KappaRD)
set(gca, 'xtick',[1:6])
set(gca, 'xticklabel',{'Pfc','Par EEG','Par LFP', 'Aud EEG', 'Aud LFP deep', 'Aud LFP sup'})
set(gca, 'ytick',[1:3])
set(gca, 'yticklabel',{'Aud','Par','Pfc'})
ylabel('Ripples')
title('Kappa vs. Delta Waves')
colorbar

subplot(3,1,3), imagesc(pvalRD)
set(gca, 'xtick',[1:6])
set(gca, 'xticklabel',{'Pfc','Par EEG','Par LFP', 'Aud EEG', 'Aud LFP deep', 'Aud LFP sup'})
set(gca, 'ytick',[1:3])
set(gca, 'yticklabel',{'Aud','Par','Pfc'})
ylabel('Ripples')
title('P value vs. Delta Waves')
colorbar
set(gcf,'Position',[885 207 750 642])




%--------------------------------------------------------------------------


figure('color',[1 1 1]), 
subplot(3,1,1), imagesc(muRS)
set(gca, 'xtick',[1:6])
set(gca, 'xticklabel',{'Pfc','Par EEG','Par LFP', 'Aud EEG', 'Aud LFP deep', 'Aud LFP sup'})
set(gca, 'ytick',[1:3])
set(gca, 'yticklabel',{'Aud','Par','Pfc'})
ylabel('Ripples')
title('Phase vs. Spindles')
colorbar

subplot(3,1,2), imagesc(KappaRS)
set(gca, 'xtick',[1:6])
set(gca, 'xticklabel',{'Pfc','Par EEG','Par LFP', 'Aud EEG', 'Aud LFP deep', 'Aud LFP sup'})
set(gca, 'ytick',[1:3])
set(gca, 'yticklabel',{'Aud','Par','Pfc'})
ylabel('Ripples')
title('Kappa vs. Spindles')
colorbar

subplot(3,1,3), imagesc(pvalRS)
set(gca, 'xtick',[1:6])
set(gca, 'xticklabel',{'Pfc','Par EEG','Par LFP', 'Aud EEG', 'Aud LFP deep', 'Aud LFP sup'})
set(gca, 'ytick',[1:3])
set(gca, 'yticklabel',{'Aud','Par','Pfc'})
ylabel('Ripples')
title('P value vs. Spindles')
colorbar

set(gcf,'Position',[885 207 750 642])

%--------------------------------------------------------------------------


figure('color',[1 1 1]), 
subplot(3,1,1), imagesc(muRT)
set(gca, 'xtick',[1:6])
set(gca, 'xticklabel',{'Pfc','Par EEG','Par LFP', 'Aud EEG', 'Aud LFP deep', 'Aud LFP sup'})
set(gca, 'ytick',[1:3])
set(gca, 'yticklabel',{'Aud','Par','Pfc'})
ylabel('Ripples')
title('Phase vs. Theta')
colorbar

subplot(3,1,2), imagesc(KappaRT)
set(gca, 'xtick',[1:6])
set(gca, 'xticklabel',{'Pfc','Par EEG','Par LFP', 'Aud EEG', 'Aud LFP deep', 'Aud LFP sup'})
set(gca, 'ytick',[1:3])
set(gca, 'yticklabel',{'Aud','Par','Pfc'})
ylabel('Ripples')
title('Kappa vs. Theta')
colorbar

subplot(3,1,3), imagesc(pvalRT)
set(gca, 'xtick',[1:6])
set(gca, 'xticklabel',{'Pfc','Par EEG','Par LFP', 'Aud EEG', 'Aud LFP deep', 'Aud LFP sup'})
set(gca, 'ytick',[1:3])
set(gca, 'yticklabel',{'Aud','Par','Pfc'})
ylabel('Ripples')
title('P value vs. Theta')
colorbar
set(gcf,'Position',[885 207 750 642])



%--------------------------------------------------------------------------
%--------------------------------------------------------------------------
%--------------------------------------------------------------------------

fac=1;

figure('color',[1 1 1]), hold on
for i=1:15
plot(Range(LFP{i},'s'),fac*Data(LFP{i})/1000+fac*i+fac*2.5,'k')
end

plot(Range(LFP{10},'s'),fac*Data(LFP{10})/1000+fac*10+fac*2.5,'k','linewidth',2)
plot(Range(LFP{5},'s'),fac*Data(LFP{5})/1000+fac*5+fac*2.5,'k','linewidth',2)

yl=ylim;
yl=[0 20];
ylim(yl)

for i=1:3
line([Range(R{i},'s') Range(R{i},'s')],yl,'color','r')
end
line([Range(R{1},'s') Range(R{1},'s')],yl,'color','r','linewidth',2)
line([Range(R{3},'s') Range(R{3},'s')],yl,'color','m')

for i=4:6
line([Range(R{i},'s') Range(R{i},'s')],yl,'color','b')
end
line([Range(R{4},'s') Range(R{4},'s')],yl,'color','b','linewidth',2)
line([Range(R{6},'s') Range(R{6},'s')],yl,'color','c')

for i=7:9
line([Range(R{i},'s') Range(R{i},'s')],yl','color','g')
end
line([Range(R{7},'s') Range(R{7},'s')],yl,'color','g','linewidth',2)
line([Range(R{9},'s') Range(R{9},'s')],yl,'color','y')

set(gcf,'Position',[75 556 1382 351])


a=0;
a=a+6; xlim([a a+6])




%--------------------------------------------------------------------------
%--------------------------------------------------------------------------
%--------------------------------------------------------------------------



if sav
    try
cd /Users/karimbenchenane/Dropbox/
save DataParvCode4data03MMN

    end
end


if 0

for i=1:50
   
eval(['saveFigure(',num2str(i),',''New2FigureBilanRhythm',num2str(i),''',''/Users/karimbenchenane/Documents/Data/DataEnCours/MiceSetUp/MMN/DataMMN'')'])
   
end

end

% set(gca, 'xtick',[1:length(R)])
% set(gca, 'ytick',[1:length(R)])
% set(gca, 'xticklabel',labels)
% set(gca, 'yticklabel',labels)


% 
% a=5000; b=200;
% [C,B]=CrossCorr(Range(Dt1),Range(Dt1),a,b); C(B==0)=0;figure('color',[1 1 1]), hold on, area(B/1E4,C,'facecolor','k'), yl=ylim; line([0 0],yl,'color','r')
% [C,B]=CrossCorr(Range(Dt1),Range(Dt2),a,b); C(B==0)=0;figure('color',[1 1 1]), hold on, area(B/1E4,C,'facecolor','k'), yl=ylim; line([0 0],yl,'color','r')
% [C,B]=CrossCorr(Range(Dt1),Range(Dt3),a,b); C(B==0)=0;figure('color',[1 1 1]), hold on, area(B/1E4,C,'facecolor','k'), yl=ylim; line([0 0],yl,'color','r')
% [C,B]=CrossCorr(Range(Dt1),Range(Sp1),a,b); C(B==0)=0;figure('color',[1 1 1]), hold on, area(B/1E4,C,'facecolor','k'), yl=ylim; line([0 0],yl,'color','r')
% [C,B]=CrossCorr(Range(Dt1),Range(Sp2),a,b); C(B==0)=0;figure('color',[1 1 1]), hold on, area(B/1E4,C,'facecolor','k'), yl=ylim; line([0 0],yl,'color','r')
% [C,B]=CrossCorr(Range(Dt1),Range(Sp3),a,b); C(B==0)=0;figure('color',[1 1 1]), hold on, area(B/1E4,C,'facecolor','k'), yl=ylim; line([0 0],yl,'color','r')
% [C,B]=CrossCorr(Range(Dt1),Range(Sp3),a,b); C(B==0)=0;figure('color',[1 1 1]), hold on, area(B/1E4,C,'facecolor','k'), yl=ylim; line([0 0],yl,'color','r')
% 
% 
% 
% 
% 
try
cd('/Users/karimbenchenane/Documents/Data/DataEnCours/MiceSetUp/MMN/DataMMN')
end
