% BilanManipeFor4



% 
% if Protocol==4 &  LimiTrials==1 & tr>3
% %     Res1{1}(4)=(Res1{1}(3)+Res1{1}(2))/2;
% %     Res1{3}(4)=(Res1{3}(3)+Res1{1}(2))/2;
% %     
%     Res1{1}(4)=15;
%     Res1{3}(4)=15;
%     
% end
    
    
tr11=min(tr,length(Res1{1}));
tr12=min(tr,length(Res1{2}));
tr13=min(tr,length(Res1{3}));
tr14=min(tr,length(Res1{4}));

tr21=min(tr,length(Res2{1}));
tr22=min(tr,length(Res2{2}));
tr23=min(tr,length(Res2{3}));
tr24=min(tr,length(Res2{4}));

tr31=min(tr,length(Res3{1}));
tr32=min(tr,length(Res3{2}));
tr33=min(tr,length(Res3{3}));
tr34=min(tr,length(Res3{4}));

tr41=min(tr,length(Res4{1}));
tr42=min(tr,length(Res4{2}));
tr43=min(tr,length(Res4{3}));
tr44=min(tr,length(Res4{4}));

 if LimiTrials
    for a=1:4
        for b=1:4
            eval(['Res',num2str(a),'{',num2str(b),'}=Res',num2str(a),'{',num2str(b),'}(1:tr',num2str(a),num2str(b),');'])
        end
    end
 end
   
 
if 0
    if renorm
        Nor=Res1{1};
        Res1{1}=Res1{1}/mean(Nor);
        Res1{2}=Res1{2}/mean(Nor);
        Nor=Res1{3};
        Res1{3}=Res1{3}/mean(Nor);
        Res1{4}=Res1{4}/mean(Nor);

        Nor=Res2{1};
        Res2{1}=Res2{1}/mean(Nor);
        Res2{2}=Res2{2}/mean(Nor);
        Nor=Res2{3};
        Res2{3}=Res2{3}/mean(Nor);
        Res2{4}=Res2{4}/mean(Nor);

        Nor=Res3{1};
        Res3{1}=Res3{1}/mean(Nor);
        Res3{2}=Res3{2}/mean(Nor);
        Nor=Res3{3};
        Res3{3}=Res3{3}/mean(Nor);
        Res3{4}=Res3{4}/mean(Nor);

        Nor=Res4{1};
        Res4{1}=Res4{1}/mean(Nor);
        Res4{2}=Res4{2}/mean(Nor);
        Nor=Res4{3};
        Res4{3}=Res4{3}/mean(Nor);
        Res4{4}=Res4{4}/mean(Nor);
    end
end



if renorm
    
    Bs=[Res1{1}/mean(Res1{1});Res2{1}/mean(Res2{1});Res3{1}/mean(Res3{1});Res4{1}/mean(Res4{1})];
    As=[Res1{2}/mean(Res1{1});Res2{2}/mean(Res2{1});Res3{2}/mean(Res3{1});Res4{2}/mean(Res4{1})];

    Bl=[Res1{3}/mean(Res1{3});Res2{3}/mean(Res2{3});Res3{3}/mean(Res3{3});Res3{3}/mean(Res3{3})];
    Al=[Res1{4}/mean(Res1{3});Res2{4}/mean(Res2{3});Res3{4}/mean(Res3{3});Res3{4}/mean(Res3{3})];
    
    BsM=[mean(Res1{1});mean(Res2{1});mean(Res3{1});mean(Res4{1})];
    AsM=[mean(Res1{2});mean(Res2{2});mean(Res3{2});mean(Res4{2})];

    BlM=[mean(Res1{3});mean(Res2{3});mean(Res3{3});mean(Res4{3})];
    AlM=[mean(Res1{4});mean(Res2{4});mean(Res3{4});mean(Res4{4})];
    



    if renormAll

            Bsi=[Res1{1}(1:tr11)/mean(Res1{1}(1:tr11));Res2{1}(1:tr21)/mean(Res2{1}(1:tr21));Res3{1}(1:tr31)/mean(Res3{1}(1:tr31));Res4{1}(1:tr41)/mean(Res4{1}(1:tr41))];
            Asi=[Res1{2}(1:tr21)/mean(Res1{1}(1:tr11));Res2{2}(1:tr22)/mean(Res2{1}(1:tr21));Res3{2}(1:tr32)/mean(Res3{1}(1:tr31));Res4{2}(1:tr42)/mean(Res4{1}(1:tr41))];

            Bli=[Res1{3}(1:tr13)/mean(Res1{3}(1:tr13));Res2{3}(1:tr23)/mean(Res2{3}(1:tr23));Res3{3}(1:tr33)/mean(Res3{3}(1:tr33));Res4{3}(1:tr43)/mean(Res4{3}(1:tr43))];
            Ali=[Res1{4}(1:tr14)/mean(Res1{3}(1:tr13));Res2{4}(1:tr24)/mean(Res2{3}(1:tr23));Res3{4}(1:tr34)/mean(Res3{3}(1:tr33));Res4{4}(1:tr44)/mean(Res4{3}(1:tr43))];

            BsiM=[mean(Res1{1}(1:tr11));mean(Res2{1}(1:tr21));mean(Res3{1}(1:tr31));mean(Res4{1}(1:tr41))]/mean([mean(Res1{1}(1:tr11));mean(Res2{1}(1:tr21));mean(Res3{1}(1:tr31));mean(Res4{1}(1:tr41))]);
            AsiM=[mean(Res1{2}(1:tr12));mean(Res2{2}(1:tr22));mean(Res3{2}(1:tr32));mean(Res4{2}(1:tr42))]/mean([mean(Res1{1}(1:tr11));mean(Res2{1}(1:tr21));mean(Res3{1}(1:tr31));mean(Res4{1}(1:tr41))]);

            BliM=[mean(Res1{3}(1:tr13));mean(Res2{3}(1:tr23));mean(Res3{3}(1:tr33));mean(Res4{3}(1:tr43))]/mean([mean(Res1{3}(1:tr13));mean(Res2{3}(1:tr23));mean(Res3{3}(1:tr33));mean(Res4{3}(1:tr43))]);
            AliM=[mean(Res1{4}(1:tr14));mean(Res2{4}(1:tr24));mean(Res3{4}(1:tr34));mean(Res4{4}(1:tr44))]/mean([mean(Res1{3}(1:tr13));mean(Res2{3}(1:tr23));mean(Res3{3}(1:tr33));mean(Res4{3}(1:tr43))]);

   else

            Bsi=[Res1{1}/mean(Res1{1});Res2{1}/mean(Res2{1});Res3{1}/mean(Res3{1});Res4{1}/mean(Res4{1})];
            Asi=[Res1{2}(1:tr21)/mean(Res1{1});Res2{2}(1:tr22)/mean(Res2{1});Res3{2}(1:tr32)/mean(Res3{1});Res4{2}(1:tr42)/mean(Res4{1})];

            Bli=[Res1{3}/mean(Res1{3});Res2{3}/mean(Res2{3});Res3{3}/mean(Res3{3});Res4{3}/mean(Res4{3})];
            Ali=[Res1{4}(1:tr14)/mean(Res1{3});Res2{4}(1:tr24)/mean(Res2{3});Res3{4}(1:tr34)/mean(Res3{3});Res4{4}(1:tr44)/mean(Res4{3})];   
            
            BsiM=[mean(Res1{1});mean(Res2{1});mean(Res3{1});mean(Res4{1})]/mean([mean(Res1{1});mean(Res2{1});mean(Res3{1});mean(Res4{1})]);
            AsiM=[mean(Res1{2}(1:tr12));mean(Res2{2}(1:tr22));mean(Res3{2}(1:tr32));mean(Res4{2}(1:tr42))]/mean([mean(Res1{1});mean(Res2{1});mean(Res3{1});mean(Res4{1})]);

            BliM=[mean(Res1{3});mean(Res2{3});mean(Res3{3});mean(Res4{3})]/mean([mean(Res1{3});mean(Res2{3});mean(Res3{3});mean(Res4{3})]);
            AliM=[mean(Res1{4}(1:tr14));mean(Res2{4}(1:tr24));mean(Res3{4}(1:tr34));mean(Res4{4}(1:tr44))]/mean([mean(Res1{3});mean(Res2{3});mean(Res3{3});mean(Res4{3})]);
    end

else
        Bs=[Res1{1};Res2{1};Res3{1};Res4{1}];
        As=[Res1{2};Res2{2};Res3{2};Res4{2}];

        Bl=[Res1{3};Res2{3};Res3{3};Res4{3}];
        Al=[Res1{4};Res2{4};Res3{4};Res4{4}];

        BsM=[mean(Res1{1});mean(Res2{1});mean(Res3{1});mean(Res4{1})];
        AsM=[mean(Res1{2});mean(Res2{2});mean(Res3{2});mean(Res4{2})];

        BlM=[mean(Res1{3});mean(Res2{3});mean(Res3{3});mean(Res4{3})];
        AlM=[mean(Res1{4});mean(Res2{4});mean(Res3{4});mean(Res4{4})];




        if renormAll  
            
                    Bsi=[Res1{1}(1:tr11);Res2{1}(1:tr21);Res3{1}(1:tr31);Res4{1}(1:tr41)];
                    Asi=[Res1{2}(1:tr12);Res2{2}(1:tr22);Res3{2}(1:tr32);Res4{2}(1:tr42)];

                    Bli=[Res1{3}(1:tr13);Res2{3}(1:tr23);Res3{3}(1:tr33);Res4{3}(1:tr43)];
                    Ali=[Res1{4}(1:tr14);Res2{4}(1:tr24);Res3{4}(1:tr34);Res4{4}(1:tr44)];   

                    BsiM=[mean(Res1{1}(1:tr11));mean(Res2{1}(1:tr21));mean(Res3{1}(1:tr31));mean(Res4{1}(1:tr41))];
                    AsiM=[mean(Res1{2}(1:tr12));mean(Res2{2}(1:tr22));mean(Res3{2}(1:tr32));mean(Res4{2}(1:tr42))];

                    BliM=[mean(Res1{3}(1:tr13));mean(Res2{3}(1:tr23));mean(Res3{3}(1:tr33));mean(Res4{3}(1:tr43))];
                    AliM=[mean(Res1{4}(1:tr14));mean(Res2{4}(1:tr24));mean(Res3{4}(1:tr34));mean(Res4{4}(1:tr44))]; 
        else
                    Bsi=[Res1{1};Res2{1};Res3{1};Res4{1}];
                    Asi=[Res1{2}(1:tr21);Res2{2}(1:tr22);Res3{2}(1:tr32);Res4{2}(1:tr42)];

                    Bli=[Res1{3};Res2{3};Res3{3};Res4{3}];
                    Ali=[Res1{4}(1:tr14);Res2{4}(1:tr24);Res3{4}(1:tr34);Res4{4}(1:tr44)]; 

                    BsiM=[mean(Res1{1});mean(Res2{1});mean(Res3{1});mean(Res4{1})];
                    AsiM=[mean(Res1{2}(1:tr12));mean(Res2{2}(1:tr22));mean(Res3{2}(1:tr32));mean(Res4{2}(1:tr42))];

                    BliM=[mean(Res1{3});mean(Res2{3});mean(Res3{3});mean(Res4{3})];
                    AliM=[mean(Res1{4}(1:tr14));mean(Res2{4}(1:tr24));mean(Res3{4}(1:tr34));mean(Res4{4}(1:tr44))];      
        end
end



%Renormalisation


if 1
if renorm
    Nor=Res1{1};
    Res1{1}=Res1{1}/mean(Nor);
    Res1{2}=Res1{2}/mean(Nor);
    Nor=Res1{3};
    Res1{3}=Res1{3}/mean(Nor);
    Res1{4}=Res1{4}/mean(Nor);
    
    Nor=Res2{1};
    Res2{1}=Res2{1}/mean(Nor);
    Res2{2}=Res2{2}/mean(Nor);
    Nor=Res2{3};
    Res2{3}=Res2{3}/mean(Nor);
    Res2{4}=Res2{4}/mean(Nor);
    
    Nor=Res3{1};
    Res3{1}=Res3{1}/mean(Nor);
    Res3{2}=Res3{2}/mean(Nor);
    Nor=Res3{3};
    Res3{3}=Res3{3}/mean(Nor);
    Res3{4}=Res3{4}/mean(Nor);
    
    Nor=Res4{1};
    Res4{1}=Res4{1}/mean(Nor);
    Res4{2}=Res4{2}/mean(Nor);
    Nor=Res4{3};
    Res4{3}=Res4{3}/mean(Nor);
    Res4{4}=Res4{4}/mean(Nor);
end
end




if 1

    figure('color',[1 1 1]), 
    subplot(2,2,1), hold on
    plot([1:length(Res1{1})], Res1{1},'ko-','linewidth',2)
    plot([1:length(Res1{2})], Res1{2},'ro-','linewidth',2)
    %title('Mouse 26, 09/01/2012')
    if renorm==0
    ylabel('Percentage of time spent in the small Place Field')
    else
        ylabel('Time spent in the small Place Field (vs control)')
    end

    subplot(2,2,2), hold on
    plot([1:length(Res2{1})], Res2{1},'ko-','linewidth',2)
    plot([1:length(Res2{2})], Res2{2},'ro-','linewidth',2)
    %title('Mouse 29, 07/01/2012')

    subplot(2,2,3), hold on
    plot([1:length(Res3{1})], Res3{1},'ko-','linewidth',2)
    plot([1:length(Res3{2})], Res3{2},'ro-','linewidth',2)
    %title('Mouse 35, 15/05/2012')
     if renorm==0
    ylabel('Percentage of time spent in the small Place Field')
    else
        ylabel('Normalized time spent in the small Place Field (vs control)')

    end

    subplot(2,2,4), hold on
    plot([1:length(Res4{1})], Res4{1},'ko-','linewidth',2)
    plot([1:length(Res4{2})], Res4{2},'ro-','linewidth',2)
    % title('Mouse 29, 08/01/2012 pm')

%--------------------------------------------------------------------------
%--------------------------------------------------------------------------
    
    figure('color',[1 1 1]), hold on
    plot([1:length(Res1{1})]-0.1, Res1{1},'ko','linewidth',1,'markerfacecolor','k')
    plot([1:length(Res1{2})]+0.1, Res1{2},'ro','linewidth',1,'markerfacecolor','r')
    %title('Mouse 26, 09/01/2012')
    plot([1:length(Res2{1})]-0.1, Res2{1},'ko','linewidth',1,'markerfacecolor','k')
    plot([1:length(Res2{2})]+0.1, Res2{2},'ro','linewidth',1,'markerfacecolor','r')
    %title('Mouse 29, 07/01/2012')
    plot([1:length(Res3{1})]-0.1, Res3{1},'ko','linewidth',1,'markerfacecolor','k')
    plot([1:length(Res3{2})]+0.1, Res3{2},'ro','linewidth',1,'markerfacecolor','r')
    %title('Mouse 35, 15/05/2012')
    plot([1:length(Res4{1})]-0.1, Res4{1},'ko','linewidth',1,'markerfacecolor','k')
    plot([1:length(Res4{2})]+0.1, Res4{2},'ro','linewidth',1,'markerfacecolor','r')
    % title('Mouse 29, 08/01/2012 pm')
       if renorm==0
    ylabel('Percentage of time spent in the small Place Field')
    else
        ylabel('Normalized time spent in the small Place Field (vs control)')
    end  
    

end

%--------------------------------------------------------------------------
%--------------------------------------------------------------------------

figure('color',[1 1 1]), 
subplot(2,2,1), hold on
plot([1:length(Res1{3})], Res1{3},'ko-','linewidth',2)
plot([1:length(Res1{4})], Res1{4},'ro-','linewidth',2)
%title('Mouse 26, 09/01/2012')
 if renorm==0
ylabel('Percentage of time spent in the large Place Field')
else
    ylabel('Normalized time spent in the large Place Field (vs control)')
end
subplot(2,2,2), hold on
plot([1:length(Res2{3})], Res2{3},'ko-','linewidth',2)
plot([1:length(Res2{4})], Res2{4},'ro-','linewidth',2)
%title('Mouse 29, 07/01/2012')


subplot(2,2,3), hold on
plot([1:length(Res3{3})], Res3{3},'ko-','linewidth',2)
plot([1:length(Res3{4})], Res3{4},'ro-','linewidth',2)
%title('Mouse 35, 15/05/2012')
 if renorm==0
ylabel('Percentage of time spent in the large Place Field')
else
    ylabel('Normalized time spent in the large Place Field (vs control)')
end
% 
subplot(2,2,4), hold on
plot([1:length(Res4{3})], Res4{3},'ko-','linewidth',2)
plot([1:length(Res4{4})], Res4{4},'ro-','linewidth',2)
% title('Mouse 29, 08/01/2012 pm')

%--------------------------------------------------------------------------
%--------------------------------------------------------------------------

 figure('color',[1 1 1]), hold on
    plot([1:length(Res1{3})]-0.1, Res1{3},'ko','linewidth',1,'markerfacecolor','k')
    plot([1:length(Res1{4})]+0.1, Res1{4},'ro-','linewidth',1,'markerfacecolor','r')
    %title('Mouse 26, 09/01/2012')
    plot([1:length(Res2{3})]-0.1, Res2{3},'ko','linewidth',1,'markerfacecolor','k')
    plot([1:length(Res2{4})]+0.1, Res2{4},'ro-','linewidth',1,'markerfacecolor','r')
    %title('Mouse 29, 07/01/2012')
    plot([1:length(Res3{3})]-0.1, Res3{3},'ko','linewidth',1,'markerfacecolor','k')
    plot([1:length(Res3{4})]+0.1, Res3{4},'ro-','linewidth',1,'markerfacecolor','r')
    %title('Mouse 35, 15/05/2012')
    plot([1:length(Res4{3})]-0.1, Res4{3},'ko','linewidth',1,'markerfacecolor','k')
    plot([1:length(Res4{4})]+0.1, Res4{4},'ro-','linewidth',1,'markerfacecolor','r')
    % title('Mouse 29, 08/01/2012 pm')
       if renorm==0
    ylabel('Percentage of time spent in the large Place Field')
    else
        ylabel('Normalized time spent in the large Place Field (vs control)')
    end  



%--------------------------------------------------------------------------
%--------------------------------------------------------------------------




% del=1;
% figure('color',[1 1 1]), hold on
% 
% plot([1:length(Res2{3})], Res2{3},'ko-','linewidth',2)
% a=length(Res2{3})+del;
% 
% plot([a+1:a+length(Res2{4})], Res2{4},'ro-','linewidth',2)
% a=a+length(Res2{3})+del;
% 
% plot([a+1:a+length(Res3{3})], Res3{3},'ko-','linewidth',2)
% a=a+length(Res3{3})+del;
% 
% plot([a+1:a+length(Res3{4})], Res3{4},'ro-','linewidth',2)
% a=a+length(Res3{4})+del;
% 
% plot([a+1:a+length(Res4{3})], Res4{3},'ko-','linewidth',2)
% a=a+length(Res4{3})+del;
% 
% plot([a+1:a+length(Res4{4})], Res4{4},'ro-','linewidth',2)
% a=a+length(Res4{4})+del;
% 
% title('Experiences Mouse 29:  07/01, 08/01 am and 08/01 pm')
% ylabel('Percentage of time spent in the Place Field')




[h,ps]=ttest2(Bs,As);
%figure('color',[1 1 1]), 
PlotErrorBar2(Bs,As)
title(['Small Area around place field, p=',num2str(floor(ps*1000)/1000)])
 if renorm==0
ylabel('Percentage of time spent in the large Place Field')
else
    ylabel('Normalized time spent in the large Place Field (vs control)')
end
set(gca,'xtick',[1 2])
set(gca,'xticklabel',{'before','after'})

%--------------------------------------------------------------------------
%--------------------------------------------------------------------------

[h,pl]=ttest2(Bl,Al);
%figure('color',[1 1 1]), 
PlotErrorBar2(Bl,Al)
title(['Large Area around place field, p=',num2str(floor(pl*1000)/1000)])
 if renorm==0
ylabel('Percentage of time spent in the large Place Field')
else
    ylabel('Normalized time spent in the large Place Field (vs control)')
end
set(gca,'xtick',[1 2])
set(gca,'xticklabel',{'before','after'})


%--------------------------------------------------------------------------
%--------------------------------------------------------------------------


if DoSuite


        [h,psi]=ttest2(Bsi,Asi);
        %figure('color',[1 1 1]), 
        PlotErrorBar2(Bsi,Asi)
        title(['Small Area around place field, ',num2str(tr),' first trials, p=',num2str(floor(psi*1000)/1000)])
         if renorm==0
        ylabel('Percentage of time spent in the small Place Field')
        else
            ylabel('Normalized time spent in the small Place Field (vs control)')
        end
        set(gca,'xtick',[1 2])
        set(gca,'xticklabel',{'before','after'})

%--------------------------------------------------------------------------
%--------------------------------------------------------------------------

        [h,pli]=ttest2(Bli,Ali);
        %figure('color',[1 1 1]), 
        PlotErrorBar2(Bli,Ali)
        title(['Large Area around place field, ',num2str(tr),' first trials, p=',num2str(floor(pli*1000)/1000)])
         if renorm==0
        ylabel('Percentage of time spent in the large Place Field')
        else
            ylabel('Normalized time spent in the large Place Field (vs control)')
        end
        set(gca,'xtick',[1 2])
        set(gca,'xticklabel',{'before','after'})

        %Mean
        %Bs=[Res1{3};Res2{1};Res3{1};Res4{1}];

%--------------------------------------------------------------------------
%--------------------------------------------------------------------------


        [h,psM]=ttest2(BsM,AsM);
        %figure('color',[1 1 1]), 
        PlotErrorBar2(BsM,AsM)
        title(['Mean effect (n=4), Small Area around place field, p=',num2str(floor(psM*1000)/1000)])
         if renorm==0
        ylabel('Percentage of time spent in the small Place Field')
        else
             ylabel('Normalized time spent in the small Place Field (vs control)')
        end
        set(gca,'xtick',[1 2])
        set(gca,'xticklabel',{'before','after'})

%--------------------------------------------------------------------------
%--------------------------------------------------------------------------

        [h,plM]=ttest2(BlM,AlM);
        %figure('color',[1 1 1]), 
        PlotErrorBar2(BlM,AlM)
        title(['Mean effect (n=4), Large Area around place field, p=',num2str(floor(plM*1000)/1000)])
         if renorm==0
        ylabel('Percentage of time spent in the large Place Field')
        else
            ylabel('Normalized time spent in the large Place Field (vs control)')
        end
        set(gca,'xtick',[1 2])
        set(gca,'xticklabel',{'before','after'})
        
%--------------------------------------------------------------------------
%--------------------------------------------------------------------------

        [h,psiM]=ttest2(BsiM,AsiM);
        %figure('color',[1 1 1]), 
        PlotErrorBar2(BsiM,AsiM)
        title(['Mean effect (n=4), Small Area around place field, ',num2str(tr),' first trials, p=',num2str(floor(psiM*1000)/1000)])
         if renorm==0
        ylabel('Percentage of time spent in the small Place Field')
        else
            ylabel('Normalized time spent in the small Place Field (vs control)')
        end
        set(gca,'xtick',[1 2])
        set(gca,'xticklabel',{'before','after'})
        
%--------------------------------------------------------------------------
%--------------------------------------------------------------------------        

        [h,pliM]=ttest2(BliM,AliM);
        %figure('color',[1 1 1]), 
        PlotErrorBar2(BliM,AliM)
        title(['Mean effect (n=4), Large Area around place field, ',num2str(tr),' first trials, p=',num2str(floor(pliM*1000)/1000)])
         if renorm==0
        ylabel('Percentage of time spent in the large Place Field')
        else
          ylabel('Normalized time spent in the large Place Field (vs control)')
        end
        set(gca,'xtick',[1 2])
        set(gca,'xticklabel',{'before','after'})


end

% disp(' ')
% disp(' ')
% disp('Freedman Test large Aerea')
% myfriedman([BlM,AlM])
% disp(' ')
% 
% disp('Freedman Test small Aerea')
% disp(' ')
% myfriedman([BsM,AsM])
% disp(' ')
