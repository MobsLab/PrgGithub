%AnalysisCP

%cd /Users/karimbenchenane/Documents/Data/DataEnCours/DataBulbCP/BULB-Mouse-51-10012013

try
    LFPt{1};
catch 
    load TimesOscilEventsSleep
    load LFPt
end



load LFPdHPC
LFPt=LFP;

load LFPPaCx
LFPt{4}=LFP{1};
LFPt{5}=LFP{2};
LFPt{6}=LFP{3};

load LFPAuCx
LFPt{7}=LFP{1};
LFPt{8}=LFP{2};
LFPt{9}=LFP{3};

load LFPPFCx
LFPt{10}=LFP{1};
LFPt{11}=LFP{2};
LFPt{12}=LFP{3};

load LFPBulb
LFPt{13}=LFP{1};
LFPt{14}=LFP{2};
LFPt{15}=LFP{3};


% LoadPATHKB
% 
% cd /Users/karimbenchenane/Documents/Data/DataEnCours/DataBulbCP/BULB-Mouse-51-10012013
% load behavResources
% load LFPdHPC
% LFPt=LFP;
% load LFPPFCx
% LFPt{4}=LFP{1};
% LFPt{5}=LFP{2};
% LFPt{6}=LFP{3};
% [Dt1,Dp1,Sp1,Ri1,ma1,sa1,tpsa1,mb1,sb1,tpsb1,mc1,sc1,tpsc1,md1,sd1,tpsd1,me1,se1,tpse1]=IdentifyDeltaSpindlesRipples(Restrict(LFPt,and(PreEpoch,SleepEpoch)),1,[],3000,1);close all
% [Dt2,Dp2,Sp2,Ri2,ma2,sa2,tpsa2,mb2,sb2,tpsb2,mc2,sc2,tpsc2,md2,sd2,tpsd2,me2,se2,tpse2]=IdentifyDeltaSpindlesRipples(Restrict(LFPt,and(CPEpoch,SleepEpoch)),1,[],3000,1);close all
% [Dt3,Dp3,Sp3,Ri3,ma3,sa3,tpsa3,mb3,sb3,tpsb3,mc3,sc3,tpsc3,md3,sd3,tpsd3,me3,se3,tpse3]=IdentifyDeltaSpindlesRipples(Restrict(LFPt,and(PreEpoch,SleepEpoch)),4,[],3000,1);close all
% [Dt4,Dp4,Sp4,Ri4,ma4,sa4,tpsa4,mb4,sb4,tpsb4,mc4,sc4,tpsc4,md4,sd4,tpsd4,me4,se4,tpse4]=IdentifyDeltaSpindlesRipples(Restrict(LFPt,and(CPEpoch,SleepEpoch)),4,[],3000,1);close all
% [Dt5,Dp5,Sp5,Ri5,ma5,sa5,tpsa5,mb5,sb5,tpsb5,mc5,sc5,tpsc5,md5,sd5,tpsd5,me5,se5,tpse5]=IdentifyDeltaSpindlesRipples(Restrict(LFPt,and(PreEpoch,SleepEpoch)),6,[],3000,1);close all
% [Dt6,Dp6,Sp6,Ri6,ma6,sa6,tpsa6,mb6,sb6,tpsb6,mc6,sc6,tpsc6,md6,sd6,tpsd6,me6,se6,tpse6]=IdentifyDeltaSpindlesRipples(Restrict(LFPt,and(CPEpoch,SleepEpoch)),6,[],3000,1);close all
% 
% 
% 
%save TimesOscilEventsSleep Dt1 Dp1 Sp1 Ri1 ma1 sa1 tpsa1 mb1 sb1 tpsb1 mc1 sc1 tpsc1 md1 sd1 tpsd1 me1 se1 tpse1 Dt2 Dp2 Sp2 Ri2 ma2 sa2 tpsa2 mb2 sb2 tpsb2 mc2 sc2 tpsc2 md2 sd2 tpsd2 me2 se2 tpse2 Dt3 Dp3 Sp3 Ri3 ma3 sa3 tpsa3 mb3 sb3 tpsb3 mc3 sc3 tpsc3 md3 sd3 tpsd3 me3 se3 tpse3 Dt4 Dp4 Sp4 Ri4 ma4 sa4 tpsa4 mb4 sb4 tpsb4 mc4 sc4 tpsc4 md4 sd4 tpsd4 me4 se4 tpse4 Dt5 Dp5 Sp5 Ri5 ma5 sa5 tpsa5 mb5 sb5 tpsb5 mc5 sc5 tpsc5 md5 sd5 tpsd5 me5 se5 tpse5 Dt6 Dp6 Sp6 Ri6 ma6 sa6 tpsa6 mb6 sb6 tpsb6 mc6 sc6 tpsc6 md6 sd6 tpsd6 me6 se6 tpse6



% 
% load behavResources
% load LFPdHPC
% LFPt=LFP;
% %load LFPPFCx
% load LFPPaCx
% LFPt{4}=LFP{1};
% LFPt{5}=LFP{2};
% LFPt{6}=LFP{3};
% [Dt1,Dp1,Sp1,Ri1,ma1,sa1,tpsa1,mb1,sb1,tpsb1,mc1,sc1,tpsc1,md1,sd1,tpsd1,me1,se1,tpse1]=IdentifyDeltaSpindlesRipples(Restrict(LFPt,and(PreEpoch,SleepEpoch)),1,[],3000,0);close all
% [Dt2,Dp2,Sp2,Ri2,ma2,sa2,tpsa2,mb2,sb2,tpsb2,mc2,sc2,tpsc2,md2,sd2,tpsd2,me2,se2,tpse2]=IdentifyDeltaSpindlesRipples(Restrict(LFPt,and(CPEpoch,SleepEpoch)),1,[],3000,0);close all
% [Dt3,Dp3,Sp3,Ri3,ma3,sa3,tpsa3,mb3,sb3,tpsb3,mc3,sc3,tpsc3,md3,sd3,tpsd3,me3,se3,tpse3]=IdentifyDeltaSpindlesRipples(Restrict(LFPt,and(PreEpoch,SleepEpoch)),4,[],3000,0);close all
% [Dt4,Dp4,Sp4,Ri4,ma4,sa4,tpsa4,mb4,sb4,tpsb4,mc4,sc4,tpsc4,md4,sd4,tpsd4,me4,se4,tpse4]=IdentifyDeltaSpindlesRipples(Restrict(LFPt,and(CPEpoch,SleepEpoch)),4,[],3000,0);close all
% [Dt5,Dp5,Sp5,Ri5,ma5,sa5,tpsa5,mb5,sb5,tpsb5,mc5,sc5,tpsc5,md5,sd5,tpsd5,me5,se5,tpse5]=IdentifyDeltaSpindlesRipples(Restrict(LFPt,and(PreEpoch,SleepEpoch)),6,[],3000,0);close all
% [Dt6,Dp6,Sp6,Ri6,ma6,sa6,tpsa6,mb6,sb6,tpsb6,mc6,sc6,tpsc6,md6,sd6,tpsd6,me6,se6,tpse6]=IdentifyDeltaSpindlesRipples(Restrict(LFPt,and(CPEpoch,SleepEpoch)),6,[],3000,0);close all
% 
% 
% save TimesOscilEventsSleepParCx Dt1 Dp1 Sp1 Ri1 ma1 sa1 tpsa1 mb1 sb1 tpsb1 mc1 sc1 tpsc1 md1 sd1 tpsd1 me1 se1 tpse1 Dt2 Dp2 Sp2 Ri2 ma2 sa2 tpsa2 mb2 sb2 tpsb2 mc2 sc2 tpsc2 md2 sd2 tpsd2 me2 se2 tpse2 Dt3 Dp3 Sp3 Ri3 ma3 sa3 tpsa3 mb3 sb3 tpsb3 mc3 sc3 tpsc3 md3 sd3 tpsd3 me3 se3 tpse3 Dt4 Dp4 Sp4 Ri4 ma4 sa4 tpsa4 mb4 sb4 tpsb4 mc4 sc4 tpsc4 md4 sd4 tpsd4 me4 se4 tpse4 Dt5 Dp5 Sp5 Ri5 ma5 sa5 tpsa5 mb5 sb5 tpsb5 mc5 sc5 tpsc5 md5 sd5 tpsd5 me5 se5 tpse5 Dt6 Dp6 Sp6 Ri6 ma6 sa6 tpsa6 mb6 sb6 tpsb6 mc6 sc6 tpsc6 md6 sd6 tpsd6 me6 se6 tpse6
% 
% save -v7.3 LFPtParCx LFPt

% 
% 
% load behavResources
% load LFPdHPC
% LFPt=LFP;
% %load LFPPFCx
% load LFPAuCx
% LFPt{4}=LFP{1};
% LFPt{5}=LFP{2};
% LFPt{6}=LFP{3};
% [Dt1,Dp1,Sp1,Ri1,ma1,sa1,tpsa1,mb1,sb1,tpsb1,mc1,sc1,tpsc1,md1,sd1,tpsd1,me1,se1,tpse1]=IdentifyDeltaSpindlesRipples(Restrict(LFPt,and(PreEpoch,SleepEpoch)),1,[],3000,0);close all
% [Dt2,Dp2,Sp2,Ri2,ma2,sa2,tpsa2,mb2,sb2,tpsb2,mc2,sc2,tpsc2,md2,sd2,tpsd2,me2,se2,tpse2]=IdentifyDeltaSpindlesRipples(Restrict(LFPt,and(CPEpoch,SleepEpoch)),1,[],3000,0);close all
% [Dt3,Dp3,Sp3,Ri3,ma3,sa3,tpsa3,mb3,sb3,tpsb3,mc3,sc3,tpsc3,md3,sd3,tpsd3,me3,se3,tpse3]=IdentifyDeltaSpindlesRipples(Restrict(LFPt,and(PreEpoch,SleepEpoch)),4,[],3000,0);close all
% [Dt4,Dp4,Sp4,Ri4,ma4,sa4,tpsa4,mb4,sb4,tpsb4,mc4,sc4,tpsc4,md4,sd4,tpsd4,me4,se4,tpse4]=IdentifyDeltaSpindlesRipples(Restrict(LFPt,and(CPEpoch,SleepEpoch)),4,[],3000,0);close all
% [Dt5,Dp5,Sp5,Ri5,ma5,sa5,tpsa5,mb5,sb5,tpsb5,mc5,sc5,tpsc5,md5,sd5,tpsd5,me5,se5,tpse5]=IdentifyDeltaSpindlesRipples(Restrict(LFPt,and(PreEpoch,SleepEpoch)),6,[],3000,0);close all
% [Dt6,Dp6,Sp6,Ri6,ma6,sa6,tpsa6,mb6,sb6,tpsb6,mc6,sc6,tpsc6,md6,sd6,tpsd6,me6,se6,tpse6]=IdentifyDeltaSpindlesRipples(Restrict(LFPt,and(CPEpoch,SleepEpoch)),6,[],3000,0);close all
% 
% 
% save TimesOscilEventsSleepAuCx Dt1 Dp1 Sp1 Ri1 ma1 sa1 tpsa1 mb1 sb1 tpsb1 mc1 sc1 tpsc1 md1 sd1 tpsd1 me1 se1 tpse1 Dt2 Dp2 Sp2 Ri2 ma2 sa2 tpsa2 mb2 sb2 tpsb2 mc2 sc2 tpsc2 md2 sd2 tpsd2 me2 se2 tpse2 Dt3 Dp3 Sp3 Ri3 ma3 sa3 tpsa3 mb3 sb3 tpsb3 mc3 sc3 tpsc3 md3 sd3 tpsd3 me3 se3 tpse3 Dt4 Dp4 Sp4 Ri4 ma4 sa4 tpsa4 mb4 sb4 tpsb4 mc4 sc4 tpsc4 md4 sd4 tpsd4 me4 se4 tpse4 Dt5 Dp5 Sp5 Ri5 ma5 sa5 tpsa5 mb5 sb5 tpsb5 mc5 sc5 tpsc5 md5 sd5 tpsd5 me5 se5 tpse5 Dt6 Dp6 Sp6 Ri6 ma6 sa6 tpsa6 mb6 sb6 tpsb6 mc6 sc6 tpsc6 md6 sd6 tpsd6 me6 se6 tpse6
% 
% save -v7.3 LFPtAuCx LFPt
% 

% 
% load behavResources
% load LFPdHPC
% LFPt=LFP;
% load LFPPFCx
% load LFPBulb
% LFPt{4}=LFP{1};
% LFPt{5}=LFP{2};
% LFPt{6}=LFP{3};
% [Dt1,Dp1,Sp1,Ri1,ma1,sa1,tpsa1,mb1,sb1,tpsb1,mc1,sc1,tpsc1,md1,sd1,tpsd1,me1,se1,tpse1]=IdentifyDeltaSpindlesRipples(Restrict(LFPt,and(PreEpoch,SleepEpoch)),1,[],3000,0);close all
% [Dt2,Dp2,Sp2,Ri2,ma2,sa2,tpsa2,mb2,sb2,tpsb2,mc2,sc2,tpsc2,md2,sd2,tpsd2,me2,se2,tpse2]=IdentifyDeltaSpindlesRipples(Restrict(LFPt,and(CPEpoch,SleepEpoch)),1,[],3000,0);close all
% [Dt3,Dp3,Sp3,Ri3,ma3,sa3,tpsa3,mb3,sb3,tpsb3,mc3,sc3,tpsc3,md3,sd3,tpsd3,me3,se3,tpse3]=IdentifyDeltaSpindlesRipples(Restrict(LFPt,and(PreEpoch,SleepEpoch)),4,[],3000,0);close all
% [Dt4,Dp4,Sp4,Ri4,ma4,sa4,tpsa4,mb4,sb4,tpsb4,mc4,sc4,tpsc4,md4,sd4,tpsd4,me4,se4,tpse4]=IdentifyDeltaSpindlesRipples(Restrict(LFPt,and(CPEpoch,SleepEpoch)),4,[],3000,0);close all
% [Dt5,Dp5,Sp5,Ri5,ma5,sa5,tpsa5,mb5,sb5,tpsb5,mc5,sc5,tpsc5,md5,sd5,tpsd5,me5,se5,tpse5]=IdentifyDeltaSpindlesRipples(Restrict(LFPt,and(PreEpoch,SleepEpoch)),6,[],3000,0);close all
% [Dt6,Dp6,Sp6,Ri6,ma6,sa6,tpsa6,mb6,sb6,tpsb6,mc6,sc6,tpsc6,md6,sd6,tpsd6,me6,se6,tpse6]=IdentifyDeltaSpindlesRipples(Restrict(LFPt,and(CPEpoch,SleepEpoch)),6,[],3000,0);close all
% 
% 
% save TimesOscilEventsSleepBulb Dt1 Dp1 Sp1 Ri1 ma1 sa1 tpsa1 mb1 sb1 tpsb1 mc1 sc1 tpsc1 md1 sd1 tpsd1 me1 se1 tpse1 Dt2 Dp2 Sp2 Ri2 ma2 sa2 tpsa2 mb2 sb2 tpsb2 mc2 sc2 tpsc2 md2 sd2 tpsd2 me2 se2 tpse2 Dt3 Dp3 Sp3 Ri3 ma3 sa3 tpsa3 mb3 sb3 tpsb3 mc3 sc3 tpsc3 md3 sd3 tpsd3 me3 se3 tpse3 Dt4 Dp4 Sp4 Ri4 ma4 sa4 tpsa4 mb4 sb4 tpsb4 mc4 sc4 tpsc4 md4 sd4 tpsd4 me4 se4 tpse4 Dt5 Dp5 Sp5 Ri5 ma5 sa5 tpsa5 mb5 sb5 tpsb5 mc5 sc5 tpsc5 md5 sd5 tpsd5 me5 se5 tpse5 Dt6 Dp6 Sp6 Ri6 ma6 sa6 tpsa6 mb6 sb6 tpsb6 mc6 sc6 tpsc6 md6 sd6 tpsd6 me6 se6 tpse6
% 
% save -v7.3 LFPtBulb LFPt
% 



% load LFPdHPC
% LFPt=LFP;
% load LFPPFCx
% LFPt{4}=LFP{1};
% LFPt{5}=LFP{2};
% LFPt{6}=LFP{3};
% 
% 


%--------------------------------------------------------------------------
%--------------------------------------------------------------------------
% load behavResources
% load LFPtBulb
% load TimesOscilEventsSleepAuCx
%--------------------------------------------------------------------------
%--------------------------------------------------------------------------

if 0
    
    
        a=100;b=100;

        [C1a,B]=CrossCorr(Range(Dt1),Range(Dp1),a,b);
        [C1b,B]=CrossCorr(Range(Dt1),Range(Sp1),a,b);
        [C1c,B]=CrossCorr(Range(Dp1),Range(Sp1),a,b);
        [C1d,B]=CrossCorr(Range(Dt1),Range(Ri1),a,b);
        [C1e,B]=CrossCorr(Range(Dp1),Range(Ri1),a,b);

        [C2a,B]=CrossCorr(Range(Dt2),Range(Dp2),a,b);
        [C2b,B]=CrossCorr(Range(Dt2),Range(Sp2),a,b);
        [C2c,B]=CrossCorr(Range(Dp2),Range(Sp2),a,b);
        [C2d,B]=CrossCorr(Range(Dt2),Range(Ri2),a,b);
        [C2e,B]=CrossCorr(Range(Dp2),Range(Ri2),a,b);

        [C1f,B]=CrossCorr(Range(Sp1),Range(Sp1),a,b);C1f(B==0)=0;
        [C2f,B]=CrossCorr(Range(Sp2),Range(Sp2),a,b);C2f(B==0)=0;


        figure('color',[1 1 1]), 
        subplot(2,3,1), hold on, plot(B,C1a,'k','linewidth',2), plot(B,C2a,'r','linewidth',2)
        subplot(2,3,2), hold on, plot(B,C1b,'k','linewidth',2), plot(B,C2b,'r','linewidth',2)
        subplot(2,3,3), hold on, plot(B,C1d,'k','linewidth',2), plot(B,C2d,'r','linewidth',2)
        subplot(2,3,5), hold on, plot(B,C1c,'k','linewidth',2), plot(B,C2c,'r','linewidth',2)
        subplot(2,3,6), hold on, plot(B,C1e,'k','linewidth',2), plot(B,C2e,'r','linewidth',2)
        subplot(2,3,4), hold on, plot(B,C1f,'k','linewidth',2), plot(B,C2f,'r','linewidth',2)





        [C1a,B]=CrossCorr(Range(Dt3),Range(Dp3),a,b);
        [C1b,B]=CrossCorr(Range(Dt3),Range(Sp3),a,b);
        [C1c,B]=CrossCorr(Range(Dp3),Range(Sp3),a,b);
        [C1d,B]=CrossCorr(Range(Dt3),Range(Ri1),a,b);
        [C1e,B]=CrossCorr(Range(Dp3),Range(Ri1),a,b);

        [C2a,B]=CrossCorr(Range(Dt4),Range(Dp4),a,b);
        [C2b,B]=CrossCorr(Range(Dt4),Range(Sp4),a,b);
        [C2c,B]=CrossCorr(Range(Dp4),Range(Sp4),a,b);
        [C2d,B]=CrossCorr(Range(Dt4),Range(Ri2),a,b);
        [C2e,B]=CrossCorr(Range(Dp4),Range(Ri2),a,b);

        [C1f,B]=CrossCorr(Range(Sp3),Range(Sp3),a,b);C1f(B==0)=0;
        [C2f,B]=CrossCorr(Range(Sp4),Range(Sp4),a,b);C2f(B==0)=0;


        figure('color',[1 1 1]), 
        subplot(2,3,1), hold on, plot(B,C1a,'k','linewidth',2), plot(B,C2a,'r','linewidth',2)
        subplot(2,3,2), hold on, plot(B,C1b,'k','linewidth',2), plot(B,C2b,'r','linewidth',2)
        subplot(2,3,3), hold on, plot(B,C1d,'k','linewidth',2), plot(B,C2d,'r','linewidth',2)
        subplot(2,3,5), hold on, plot(B,C1c,'k','linewidth',2), plot(B,C2c,'r','linewidth',2)
        subplot(2,3,6), hold on, plot(B,C1e,'k','linewidth',2), plot(B,C2e,'r','linewidth',2)
        subplot(2,3,4), hold on, plot(B,C1f,'k','linewidth',2), plot(B,C2f,'r','linewidth',2)




        [C1a,B]=CrossCorr(Range(Dt5),Range(Dp5),a,b);
        [C1b,B]=CrossCorr(Range(Dt5),Range(Sp5),a,b);
        [C1c,B]=CrossCorr(Range(Dp5),Range(Sp5),a,b);
        [C1d,B]=CrossCorr(Range(Dt5),Range(Ri1),a,b);
        [C1e,B]=CrossCorr(Range(Dp5),Range(Ri1),a,b);

        [C2a,B]=CrossCorr(Range(Dt6),Range(Dp6),a,b);
        [C2b,B]=CrossCorr(Range(Dt6),Range(Sp6),a,b);
        [C2c,B]=CrossCorr(Range(Dp6),Range(Sp6),a,b);
        [C2d,B]=CrossCorr(Range(Dt6),Range(Ri2),a,b);
        [C2e,B]=CrossCorr(Range(Dp6),Range(Ri2),a,b);

        [C1f,B]=CrossCorr(Range(Sp5),Range(Sp5),a,b);C1f(B==0)=0;
        [C2f,B]=CrossCorr(Range(Sp6),Range(Sp6),a,b);C2f(B==0)=0;


        figure('color',[1 1 1]), 
        subplot(2,3,1), hold on, plot(B,C1a,'k','linewidth',2), plot(B,C2a,'r','linewidth',2)
        subplot(2,3,2), hold on, plot(B,C1b,'k','linewidth',2), plot(B,C2b,'r','linewidth',2)
        subplot(2,3,3), hold on, plot(B,C1d,'k','linewidth',2), plot(B,C2d,'r','linewidth',2)
        subplot(2,3,5), hold on, plot(B,C1c,'k','linewidth',2), plot(B,C2c,'r','linewidth',2)
        subplot(2,3,6), hold on, plot(B,C1e,'k','linewidth',2), plot(B,C2e,'r','linewidth',2)
        subplot(2,3,4), hold on, plot(B,C1f,'k','linewidth',2), plot(B,C2f,'r','linewidth',2)


end


a=300; b=100;



[C1sra,B]=CrossCorr(Range(Sp5),Range(Ri1),a,b);
[C2sra,B]=CrossCorr(Range(Sp6),Range(Ri2),a,b);

[C1srb,B]=CrossCorr(Range(Dp5),Range(Ri1),a,b);
[C2srb,B]=CrossCorr(Range(Dp6),Range(Ri2),a,b);

[C1src,B]=CrossCorr(Range(Dt5),Range(Ri1),a,b);
[C2src,B]=CrossCorr(Range(Dt6),Range(Ri2),a,b);

%fig #1
figure('color',[1 1 1]), 
subplot(3,1,1),hold on, plot(B,C1sra,'k','linewidth',2), plot(B,C2sra,'r','linewidth',2), xlim([min(B) max(B)])
title('Spindles vs Ripples')
subplot(3,1,2),hold on, plot(B,C1srb,'k','linewidth',2), plot(B,C2srb,'r','linewidth',2), xlim([min(B) max(B)])
title('Delta vs Ripples')
subplot(3,1,3),hold on, plot(B,C1src,'k','linewidth',2), plot(B,C2src,'r','linewidth',2), xlim([min(B) max(B)])
title('Delta vs Ripples')

%fig #2
figure('color',[1 1 1]), hold on, plot(B,C1sra,'k','linewidth',2), plot(B,C2sra,'r','linewidth',2), xlim([min(B) max(B)])
yl=ylim;
line([0 0],yl,'color',[0.7 0.7 0.7])
title('Spindles vs Ripples')

M2=PlotRipRaw(LFPt{1},Range(Ri2,'s'),a/2);close
M1=PlotRipRaw(LFPt{1},Range(Ri1,'s'),a/2);close
%fig #3
figure('Color',[1 1 1]), hold on, plot(M1(:,1), ((M1(:,2)'-M1(1,2))),'k','linewidth',2), plot(M2(:,1),((M2(:,2)')-M2(1,2)),'r','linewidth',2)
yl=ylim;
line([0 0],yl,'color',[0.7 0.7 0.7])
title('LFP Hpc vs Ripples')
xlim([M1(1,1) M1(end,1)])

M2=PlotRipRaw(LFPt{1},Range(Ri2,'s'),a*2);close
M1=PlotRipRaw(LFPt{1},Range(Ri1,'s'),a*2);close
%fig #4
figure('Color',[1 1 1]), hold on, plot(M1(:,1),((M1(:,2)'-M1(1,2))),'k','linewidth',2), plot(M2(:,1),((M2(:,2)')-M2(1,2)),'r','linewidth',2)
yl=ylim;
line([0 0],yl,'color',[0.7 0.7 0.7])
title('LFP Hpc vs Ripples')
xlim([M1(1,1) M1(end,1)])

M3=PlotRipRaw(LFPt{6},Range(Ri1,'s'),a*2);close
M4=PlotRipRaw(LFPt{6},Range(Ri2,'s'),a*2);close
%fig #5
figure('Color',[1 1 1]), hold on, plot(M3(:,1),((M3(:,2)')-M3(1,2)),'k','linewidth',2), plot(M4(:,1),((M4(:,2)')-M4(1,2)),'r','linewidth',2)
yl=ylim;
line([0 0],yl,'color',[0.7 0.7 0.7])
title('LFP Cx vs Ripples')
xlim([M3(1,1) M3(end,1)])

%fig #6
figure('Color',[1 1 1]), hold on, plot(M3(:,1),(smooth(M3(:,2)',10)-M3(1,2)),'k','linewidth',2), plot(M4(:,1),smooth(M4(:,2)',10)-M4(1,2),'r','linewidth',2)
yl=ylim;
line([0 0],yl,'color',[0.7 0.7 0.7])
title('LFP Cx vs Ripples')
xlim([M3(1,1) M3(end,1)])

M5=PlotRipRaw(LFPt{6},Range(Sp5,'s'),a*4);close
M6=PlotRipRaw(LFPt{6},Range(Sp6,'s'),a*4);close
figure('Color',[1 1 1]), hold on, plot(M5(:,1),((M5(:,2)')-M5(1,2)),'k','linewidth',2), plot(M6(:,1),((M6(:,2)')-M6(1,2)),'r','linewidth',2)
yl=ylim;
line([0 0],yl,'color',[0.7 0.7 0.7])
title('LFP Cx vs Spindles')
xlim([M5(1,1) M5(end,1)])

M7=PlotRipRaw(LFPt{6},Range(Dp5,'s'),a*4);close
M8=PlotRipRaw(LFPt{6},Range(Dp6,'s'),a*4);close
figure('Color',[1 1 1]), hold on, plot(M7(:,1),((M7(:,2)')-M7(1,2)),'k','linewidth',2), plot(M8(:,1),((M8(:,2)')-M8(1,2)),'r','linewidth',2)
yl=ylim;
line([0 0],yl,'color',[0.7 0.7 0.7])
title('LFP Cx vs Delta')
xlim([M7(1,1) M7(end,1)])

M7=PlotRipRaw(LFPt{6},Range(Dt5,'s'),a*4);close
M8=PlotRipRaw(LFPt{6},Range(Dt6,'s'),a*4);close
figure('Color',[1 1 1]), hold on, plot(M7(:,1),((M7(:,2)')-M7(1,2)),'k','linewidth',2), plot(M8(:,1),((M8(:,2)')-M8(1,2)),'r','linewidth',2)
yl=ylim;
line([0 0],yl,'color',[0.7 0.7 0.7])
title('LFP Cx vs Delta')
xlim([M7(1,1) M7(end,1)])

% 
% M5=PlotRipRaw(LFPt{6},Range(Dp5,'s'),1000);
% M6=PlotRipRaw(LFPt{6},Range(Dp6,'s'),1000);
% figure('Color',[1 1 1]), hold on, plot(((M5(:,2)')),'k','linewidth',2), plot(((M6(:,2)')),'r','linewidth',2)
% 
% M5=PlotRipRaw(LFPt{6},Range(Dp3,'s'),1000);
% M6=PlotRipRaw(LFPt{6},Range(Dp4,'s'),1000);
% figure('Color',[1 1 1]), hold on, plot(((M5(:,2)')),'k','linewidth',2), plot(((M6(:,2)')),'r','linewidth',2)



