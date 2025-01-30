% BilanManipeFor6




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

tr51=min(tr,length(Res5{1}));
tr52=min(tr,length(Res5{2}));
tr53=min(tr,length(Res5{3}));
tr54=min(tr,length(Res5{4}));

tr61=min(tr,length(Res6{1}));
tr62=min(tr,length(Res6{2}));
tr63=min(tr,length(Res6{3}));
tr64=min(tr,length(Res6{4}));

 if LimiTrials
for a=1:6
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
    
    
        Nor=Res5{1};
    Res5{1}=Res5{1}/mean(Nor);
    Res5{2}=Res5{2}/mean(Nor);
    Nor=Res5{3};
    Res5{3}=Res5{3}/mean(Nor);
    Res5{4}=Res5{4}/mean(Nor);
    
    Nor=Res6{1};
    Res6{1}=Res6{1}/mean(Nor);
    Res6{2}=Res6{2}/mean(Nor);
    Nor=Res6{3};
    Res6{3}=Res6{3}/mean(Nor);
    Res6{4}=Res6{4}/mean(Nor);
    
end
end


if renorm
    
    Bs=[Res1{1}/mean(Res1{1});Res2{1}/mean(Res2{1});Res3{1}/mean(Res3{1});Res4{1}/mean(Res4{1});Res5{1}/mean(Res5{1});Res6{1}/mean(Res6{1})];
    As=[Res1{2}/mean(Res1{1});Res2{2}/mean(Res2{1});Res3{2}/mean(Res3{1});Res4{2}/mean(Res4{1});Res5{2}/mean(Res5{1});Res6{2}/mean(Res6{1})];

    Bl=[Res1{3}/mean(Res1{3});Res2{3}/mean(Res2{3});Res3{3}/mean(Res3{3});Res3{3}/mean(Res3{3});Res5{3}/mean(Res5{3});Res6{3}/mean(Res6{3})];
    Al=[Res1{4}/mean(Res1{3});Res2{4}/mean(Res2{3});Res3{4}/mean(Res3{3});Res3{4}/mean(Res3{3});Res5{4}/mean(Res5{3});Res6{4}/mean(Res6{3})];
    
    BsM=[mean(Res1{1});mean(Res2{1});mean(Res3{1});mean(Res4{1});mean(Res5{1});mean(Res6{1})];
    AsM=[mean(Res1{2});mean(Res2{2});mean(Res3{2});mean(Res4{2});mean(Res5{2});mean(Res6{2})];

    BlM=[mean(Res1{3});mean(Res2{3});mean(Res3{3});mean(Res4{3});mean(Res5{3});mean(Res6{3})];
    AlM=[mean(Res1{4});mean(Res2{4});mean(Res3{4});mean(Res4{4});mean(Res5{4});mean(Res6{4})];
    



    if renormAll

        Bsi=[Res1{1}(1:tr11)/mean(Res1{1}(1:tr11));Res2{1}(1:tr21)/mean(Res2{1}(1:tr21));Res3{1}(1:tr31)/mean(Res3{1}(1:tr31));Res4{1}(1:tr41)/mean(Res4{1}(1:tr41));Res5{1}(1:tr51)/mean(Res5{1}(1:tr51));Res6{1}(1:tr61)/mean(Res6{1}(1:tr61))];
        Asi=[Res1{2}(1:tr21)/mean(Res1{1}(1:tr11));Res2{2}(1:tr22)/mean(Res2{1}(1:tr21));Res3{2}(1:tr32)/mean(Res3{1}(1:tr31));Res4{2}(1:tr42)/mean(Res4{1}(1:tr41));Res5{2}(1:tr52)/mean(Res5{1}(1:tr51));Res6{2}(1:tr62)/mean(Res6{1}(1:tr61))];

        Bli=[Res1{3}(1:tr13)/mean(Res1{3}(1:tr13));Res2{3}(1:tr23)/mean(Res2{3}(1:tr23));Res3{3}(1:tr33)/mean(Res3{3}(1:tr33));Res4{3}(1:tr43)/mean(Res4{3}(1:tr43));Res5{3}(1:tr53)/mean(Res5{3}(1:tr53));Res6{3}(1:tr63)/mean(Res6{3}(1:tr63))];
        Ali=[Res1{4}(1:tr14)/mean(Res1{3}(1:tr13));Res2{4}(1:tr24)/mean(Res2{3}(1:tr23));Res3{4}(1:tr34)/mean(Res3{3}(1:tr33));Res4{4}(1:tr44)/mean(Res4{3}(1:tr43));Res5{4}(1:tr54)/mean(Res5{3}(1:tr53));Res6{4}(1:tr64)/mean(Res6{3}(1:tr63))];


        BsiM=[mean(Res1{1}(1:tr11));mean(Res2{1}(1:tr21));mean(Res3{1}(1:tr31));mean(Res4{1}(1:tr41));mean(Res5{1}(1:tr51));mean(Res6{1}(1:tr61))]/mean([mean(Res1{1}(1:tr11));mean(Res2{1}(1:tr21));mean(Res3{1}(1:tr31));mean(Res4{1}(1:tr41));mean(Res5{1}(1:tr51));mean(Res6{1}(1:tr61))]);
        AsiM=[mean(Res1{2}(1:tr12));mean(Res2{2}(1:tr22));mean(Res3{2}(1:tr32));mean(Res4{2}(1:tr42));mean(Res5{2}(1:tr52));mean(Res6{2}(1:tr62))]/mean([mean(Res1{1}(1:tr11));mean(Res2{1}(1:tr21));mean(Res3{1}(1:tr31));mean(Res4{1}(1:tr41));mean(Res5{1}(1:tr51));mean(Res6{1}(1:tr61))]);

        BliM=[mean(Res1{3}(1:tr13));mean(Res2{3}(1:tr23));mean(Res3{3}(1:tr33));mean(Res4{3}(1:tr43));mean(Res5{3}(1:tr53));mean(Res6{3}(1:tr63))]/mean([mean(Res1{3}(1:tr13));mean(Res2{3}(1:tr23));mean(Res3{3}(1:tr33));mean(Res4{3}(1:tr43));mean(Res5{3}(1:tr53));mean(Res6{3}(1:tr63))]);
        AliM=[mean(Res1{4}(1:tr14));mean(Res2{4}(1:tr24));mean(Res3{4}(1:tr34));mean(Res4{4}(1:tr44));mean(Res5{4}(1:tr54));mean(Res6{4}(1:tr64))]/mean([mean(Res1{3}(1:tr13));mean(Res2{3}(1:tr23));mean(Res3{3}(1:tr33));mean(Res4{3}(1:tr43));mean(Res5{3}(1:tr53));mean(Res6{3}(1:tr63))]);

            
   else

            Bsi=[Res1{1}/mean(Res1{1});Res2{1}/mean(Res2{1});Res3{1}/mean(Res3{1});Res4{1}/mean(Res4{1});Res5{1}/mean(Res5{1});Res6{1}/mean(Res6{1})];
            Asi=[Res1{2}(1:tr21)/mean(Res1{1});Res2{2}(1:tr22)/mean(Res2{1});Res3{2}(1:tr32)/mean(Res3{1});Res4{2}(1:tr42)/mean(Res4{1});Res5{2}(1:tr52)/mean(Res5{1});Res6{2}(1:tr62)/mean(Res6{1})];

            Bli=[Res1{3}/mean(Res1{3});Res2{3}/mean(Res2{3});Res3{3}/mean(Res3{3});Res4{3}/mean(Res4{3});Res5{3}/mean(Res5{3});Res6{3}/mean(Res6{3})];
            Ali=[Res1{4}(1:tr14)/mean(Res1{3});Res2{4}(1:tr24)/mean(Res2{3});Res3{4}(1:tr34)/mean(Res3{3});Res4{4}(1:tr44)/mean(Res4{3});Res5{4}(1:tr54)/mean(Res5{3});Res6{4}(1:tr64)/mean(Res6{3})];   
            
            
            BsiM=[mean(Res1{1});mean(Res2{1});mean(Res3{1});mean(Res4{1});mean(Res5{1});mean(Res6{1})]/mean([mean(Res1{1});mean(Res2{1});mean(Res3{1});mean(Res4{1});mean(Res5{1});mean(Res6{1})]);
            AsiM=[mean(Res1{2}(1:tr12));mean(Res2{2}(1:tr22));mean(Res3{2}(1:tr32));mean(Res4{2}(1:tr42));mean(Res5{2}(1:tr52));mean(Res6{2}(1:tr62))]/mean([mean(Res1{1});mean(Res2{1});mean(Res3{1});mean(Res4{1});mean(Res5{1});mean(Res6{1})]);

            BliM=[mean(Res1{3});mean(Res2{3});mean(Res3{3});mean(Res4{3});mean(Res5{3});mean(Res6{3})]/mean([mean(Res1{3});mean(Res2{3});mean(Res3{3});mean(Res4{3});mean(Res5{3});mean(Res6{3})]);
            AliM=[mean(Res1{4}(1:tr14));mean(Res2{4}(1:tr24));mean(Res3{4}(1:tr34));mean(Res4{4}(1:tr44));mean(Res5{4}(1:tr54));mean(Res6{4}(1:tr64))]/mean([mean(Res1{3});mean(Res2{3});mean(Res3{3});mean(Res4{3});mean(Res5{3});mean(Res6{3})]);
                    

    end


else
    
    
    


        Bs=[Res1{1};Res2{1};Res3{1};Res4{1};Res5{1};Res6{1}];
        As=[Res1{2};Res2{2};Res3{2};Res4{2};Res5{2};Res6{2}];

        Bl=[Res1{3};Res2{3};Res3{3};Res4{3};Res5{3};Res6{3}];
        Al=[Res1{4};Res2{4};Res3{4};Res4{4};Res5{4};Res6{4}];

        BsM=[mean(Res1{1});mean(Res2{1});mean(Res3{1});mean(Res4{1});mean(Res5{1});mean(Res6{1})];
        AsM=[mean(Res1{2});mean(Res2{2});mean(Res3{2});mean(Res4{2});mean(Res5{2});mean(Res6{2})];

        BlM=[mean(Res1{3});mean(Res2{3});mean(Res3{3});mean(Res4{3});mean(Res5{3});mean(Res6{3})];
        AlM=[mean(Res1{4});mean(Res2{4});mean(Res3{4});mean(Res4{4});mean(Res5{4});mean(Res6{4})];




        if renormAll  
            
                    Bsi=[Res1{1}(1:tr11);Res2{1}(1:tr21);Res3{1}(1:tr31);Res4{1}(1:tr41);Res5{1}(1:tr51);Res6{1}(1:tr61)];
                    Asi=[Res1{2}(1:tr12);Res2{2}(1:tr22);Res3{2}(1:tr32);Res4{2}(1:tr42);Res5{2}(1:tr52);Res6{2}(1:tr62)];

                    Bli=[Res1{3}(1:tr13);Res2{3}(1:tr23);Res3{3}(1:tr33);Res4{3}(1:tr43);Res5{3}(1:tr53);Res6{3}(1:tr63)];
                    Ali=[Res1{4}(1:tr14);Res2{4}(1:tr24);Res3{4}(1:tr34);Res4{4}(1:tr44);Res5{4}(1:tr54);Res6{4}(1:tr64)];   

                    BsiM=[mean(Res1{1}(1:tr11));mean(Res2{1}(1:tr21));mean(Res3{1}(1:tr31));mean(Res4{1}(1:tr41));mean(Res5{1}(1:tr51));mean(Res6{1}(1:tr61))];
                    AsiM=[mean(Res1{2}(1:tr12));mean(Res2{2}(1:tr22));mean(Res3{2}(1:tr32));mean(Res4{2}(1:tr42));mean(Res5{2}(1:tr52));mean(Res6{2}(1:tr62))];

                    BliM=[mean(Res1{3}(1:tr13));mean(Res2{3}(1:tr23));mean(Res3{3}(1:tr33));mean(Res4{3}(1:tr43));mean(Res5{3}(1:tr53));mean(Res6{3}(1:tr63))];
                    AliM=[mean(Res1{4}(1:tr14));mean(Res2{4}(1:tr24));mean(Res3{4}(1:tr34));mean(Res4{4}(1:tr44));mean(Res5{4}(1:tr54));mean(Res6{4}(1:tr64))];
                    
 

        else

                    Bsi=[Res1{1};Res2{1};Res3{1};Res4{1};Res5{1};Res6{1}];
                    Asi=[Res1{2}(1:tr21);Res2{2}(1:tr22);Res3{2}(1:tr32);Res4{2}(1:tr42);Res5{2}(1:tr52);Res6{2}(1:tr62)];

                    Bli=[Res1{3};Res2{3};Res3{3};Res4{3};Res5{3};Res6{3}];
                    Ali=[Res1{4}(1:tr14);Res2{4}(1:tr24);Res3{4}(1:tr34);Res4{4}(1:tr44);Res5{4}(1:tr54);Res6{4}(1:tr64)]; 

                    BsiM=[mean(Res1{1});mean(Res2{1});mean(Res3{1});mean(Res4{1});mean(Res5{1});mean(Res6{1})];
                    AsiM=[mean(Res1{2}(1:tr12));mean(Res2{2}(1:tr22));mean(Res3{2}(1:tr32));mean(Res4{2}(1:tr42));mean(Res5{2}(1:tr52));mean(Res6{2}(1:tr62))];

                    BliM=[mean(Res1{3});mean(Res2{3});mean(Res3{3});mean(Res4{3});mean(Res5{3});mean(Res6{3})];
                    AliM=[mean(Res1{4}(1:tr14));mean(Res2{4}(1:tr24));mean(Res3{4}(1:tr34));mean(Res4{4}(1:tr44));mean(Res5{4}(1:tr54));mean(Res6{4}(1:tr64))];
                  
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
    
    
        Nor=Res5{1};
    Res5{1}=Res5{1}/mean(Nor);
    Res5{2}=Res5{2}/mean(Nor);
    Nor=Res5{3};
    Res5{3}=Res5{3}/mean(Nor);
    Res5{4}=Res5{4}/mean(Nor);
    
    Nor=Res6{1};
    Res6{1}=Res6{1}/mean(Nor);
    Res6{2}=Res6{2}/mean(Nor);
    Nor=Res6{3};
    Res6{3}=Res6{3}/mean(Nor);
    Res6{4}=Res6{4}/mean(Nor);
    
end
end


if 1

    figure('color',[1 1 1]), 
    subplot(2,3,1), hold on
    plot([1:length(Res1{1})], Res1{1},'ko-','linewidth',2)
    plot([1:length(Res1{2})], Res1{2},'ro-','linewidth',2)
    %title('Mouse 26, 09/01/2012')
    if renorm==0
    ylabel('Percentage of time spent in the small Place Field')
    else
        ylabel('Time spent in the small Place Field (vs control)')
    end

    subplot(2,3,2), hold on
    plot([1:length(Res2{1})], Res2{1},'ko-','linewidth',2)
    plot([1:length(Res2{2})], Res2{2},'ro-','linewidth',2)
    %title('Mouse 29, 07/01/2012')

    subplot(2,3,3), hold on
    plot([1:length(Res3{1})], Res3{1},'ko-','linewidth',2)
    plot([1:length(Res3{2})], Res3{2},'ro-','linewidth',2)
    %title('Mouse 35, 15/05/2012')

    % 
    subplot(2,3,4), hold on
    plot([1:length(Res4{1})], Res4{1},'ko-','linewidth',2)
    plot([1:length(Res4{2})], Res4{2},'ro-','linewidth',2)
    % title('Mouse 29, 08/01/2012 pm')
     if renorm==0
    ylabel('Percentage of time spent in the small Place Field')
    else
        ylabel('Normalized time spent in the small Place Field (vs control)')

     end

    subplot(2,3,5), hold on
    plot([1:length(Res5{1})], Res5{1},'ko-','linewidth',2)
    plot([1:length(Res5{2})], Res5{2},'ro-','linewidth',2)

    
    subplot(2,3,6), hold on
    plot([1:length(Res6{1})], Res6{1},'ko-','linewidth',2)
    plot([1:length(Res6{2})], Res6{2},'ro-','linewidth',2)
    
    
end







figure('color',[1 1 1]), 
subplot(2,3,1), hold on
plot([1:length(Res1{3})], Res1{3},'ko-','linewidth',2)
plot([1:length(Res1{4})], Res1{4},'ro-','linewidth',2)
%title('Mouse 26, 09/01/2012')
 if renorm==0
ylabel('Percentage of time spent in the large Place Field')
else
    ylabel('Normalized time spent in the large Place Field (vs control)')
end
subplot(2,3,2), hold on
plot([1:length(Res2{3})], Res2{3},'ko-','linewidth',2)
plot([1:length(Res2{4})], Res2{4},'ro-','linewidth',2)
%title('Mouse 29, 07/01/2012')


subplot(2,3,3), hold on
plot([1:length(Res3{3})], Res3{3},'ko-','linewidth',2)
plot([1:length(Res3{4})], Res3{4},'ro-','linewidth',2)
%title('Mouse 35, 15/05/2012')

% 
subplot(2,3,4), hold on
plot([1:length(Res4{3})], Res4{3},'ko-','linewidth',2)
plot([1:length(Res4{4})], Res4{4},'ro-','linewidth',2)
% title('Mouse 29, 08/01/2012 pm')
 if renorm==0
ylabel('Percentage of time spent in the large Place Field')
else
    ylabel('Normalized time spent in the large Place Field (vs control)')
 end

subplot(2,3,5), hold on
plot([1:length(Res5{3})], Res5{3},'ko-','linewidth',2)
plot([1:length(Res5{4})], Res5{4},'ro-','linewidth',2)

subplot(2,3,6), hold on
plot([1:length(Res6{3})], Res6{3},'ko-','linewidth',2)
plot([1:length(Res6{4})], Res6{4},'ro-','linewidth',2)



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




[h,psM]=ttest2(BsM,AsM);
%figure('color',[1 1 1]), 
PlotErrorBar2(BsM,AsM)
title(['Mean effect (n=3), Small Area around place field, p=',num2str(floor(psM*1000)/1000)])
 if renorm==0
ylabel('Percentage of time spent in the small Place Field')
else
     ylabel('Normalized time spent in the small Place Field (vs control)')
end
set(gca,'xtick',[1 2])
set(gca,'xticklabel',{'before','after'})

[h,plM]=ttest2(BlM,AlM);
%figure('color',[1 1 1]), 
PlotErrorBar2(BlM,AlM)
title(['Mean effect (n=3), Large Area around place field, p=',num2str(floor(plM*1000)/1000)])
 if renorm==0
ylabel('Percentage of time spent in the large Place Field')
else
    ylabel('Normalized time spent in the large Place Field (vs control)')
end
set(gca,'xtick',[1 2])
set(gca,'xticklabel',{'before','after'})

[h,psiM]=ttest2(BsiM,AsiM);
%figure('color',[1 1 1]), 
PlotErrorBar2(BsiM,AsiM)
title(['Mean effect (n=3), Small Area around place field, ',num2str(tr),' first trials, p=',num2str(floor(psiM*1000)/1000)])
 if renorm==0
ylabel('Percentage of time spent in the small Place Field')
else
    ylabel('Normalized time spent in the small Place Field (vs control)')
end
set(gca,'xtick',[1 2])
set(gca,'xticklabel',{'before','after'})

[h,pliM]=ttest2(BliM,AliM);
%figure('color',[1 1 1]), 
PlotErrorBar2(BliM,AliM)
title(['Mean effect (n=3), Large Area around place field, ',num2str(tr),' first trials, p=',num2str(floor(pliM*1000)/1000)])
 if renorm==0
ylabel('Percentage of time spent in the large Place Field')
else
  ylabel('Normalized time spent in the large Place Field (vs control)')
end
set(gca,'xtick',[1 2])
set(gca,'xticklabel',{'before','after'})


end