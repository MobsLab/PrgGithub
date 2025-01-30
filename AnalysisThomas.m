
%AnalysisThomas


%------------------------------------------------------------------------
%------------------------------------------------------------------------
%------------------------------------------------------------------------

cd /Users/karimbenchenane/Documents/MATLAB/PrgMATLAB/bsmart

load('/Users/karimbenchenane/Downloads/MV1&MP1/KB_1.mat')
%load('/Users/karimbenchenane/Downloads/MV1&MP1/KB_2.mat')

%load('/Users/karimbenchenane/Downloads/MV1&MP1/KB_3.mat')
%MP1=MP1Droite;
%MV1=MV1Droite;
%MV1=MV1Gauche;
%MP1=MP1Gauche;

%------------------------------------------------------------------------
%------------------------------------------------------------------------
%------------------------------------------------------------------------

            params.trialave=0;
            params.err=[1 0.0500];
            params.pad=1;
      %      params.pad=3;
    %        params.tapers=[10 19];
            params.tapers=[3 5];
            params.fpass=[0 0.8;];

            movingwin=[100 5];
            %movingwin=[20 5];
            
            
            
            
try

                MP1;
                MV1;

            params.Fs=1/median(diff(Temps));


            chF=params.Fs;
            L = length(MP1);
            NFFT = 2^nextpow2(L); % Next power of 2 from length of y
            yf  = fft(MP1-mean(MP1),NFFT)/L;
            fl = chF*1/2*linspace(0,1,NFFT/2+1);

            S2l=abs(yf(1:NFFT/2+1));



            L = length(MV1);
            NFFT = 2^nextpow2(L); % Next power of 2 from length of y
            yf  = fft(MV1-mean(MV1),NFFT)/L;
            fl = chF*1/2*linspace(0,1,NFFT/2+1);

            S2l=abs(yf(1:NFFT/2+1));



            [Ca,phia,S12a,S1a,S2a,ta,fa]=cohgramc(MP1-mean(MP1),MV1-mean(MV1),movingwin,params);

            
            C=Ca;
            phi=phia;
            S12=S12a;
            S1=S1a;
            S2=S2a;
            t=ta;
            f=fa;
            
            
            figure('Color',[1 1 1]), hold on
            subplot(5,1,1),hold on
            plot(Temps,MP1,'k')
            plot(Temps,MV1,'r'),
            subplot(5,1,2),imagesc(t,f,10*log10(S1)'), axis xy
            subplot(5,1,3),imagesc(t,f,10*log10(S2)'), axis xy
            subplot(5,1,4),imagesc(t,f,C'), axis xy
            subplot(5,1,5),imagesc(t,f,phi'), axis xy


            %------------------------------------------------------------------------
            %------------------------------------------------------------------------
            %------------------------------------------------------------------------

            %figure('Color',[1 1 1]), hold on
            %plot(Temps,MP1,'k')
            %plot(Temps,MV1,'r'),


            [Cr,lag]=xcorr(MP1,MV1,'coeff');




            [Crp,lagp]=xcorr(MP1,MP1,'coeff');
            [Crv,lagv]=xcorr(MV1,MV1,'coeff');
            % 
            % figure('Color',[1 1 1]), hold on
            figure('Color',[1 1 1]), hold on
            plot(lag/params.Fs,Cr,'-o')
            xlim([-200 200])
            plot(lagp/params.Fs,Crp,'-ko')
            plot(lagv/params.Fs,Crv,'-ro')
            xlim([-50 50])
            yl=ylim;
            line([0 0],yl,'color',[0.7 0.7 0.7])


            %------------------------------------------------------------------------
            %------------------------------------------------------------------------
            %------------------------------------------------------------------------


%             MP1Tsd=tsd(Temps*1E4,MP1);
%             MV1Tsd=tsd(Temps*1E4,MV1);
% 
% 
%             b=1;
% 
%             c=0.01;
%             %c=0.05;
% 
%             fi=128;
% 
%             figure('Color',[1 1 1]), hold on
%             plot(Range(MP1Tsd,'s'),Data(MP1Tsd),'k','linewidth',1)
%             Bins=[0.001:c:0.79];
% 
%             for a=Bins
% 
%                 MP1f=FilterLFP(MP1Tsd,[a, a+c],fi);
%                 MV1f=FilterLFP(MV1Tsd,[a, a+c],fi);
% 
%             plot(Range(MP1f,'s'),Data(MP1f),'color',[b/length(Bins),0,(length(Bins)-b)/length(Bins)])
% 
% 
%                 g=etc_granger([Data(MP1f),Data(MV1f)],15);
%                 Gr(b,1)=g(1,2);
%                 Gr(b,2)=g(2,1);
%                 b=b+1;
%             end
% 
%             figure('Color',[1 1 1]), hold on
%             plot(Bins,Gr)
%             plot(f,mean(C),'r')

            
end


%------------------------------------------------------------------------
%------------------------------------------------------------------------
%------------------------------------------------------------------------





try
[granger1, granger_F, granger_pvalue, granger_num, granger_den, granger_num_dof, granger_den_dof, granger_dir, granger_inst]=etc_granger([MP1,MV1],15,'ts_name',{'MP1','MV1'});
end



%------------------------------------------------------------------------------------------------------------------------------------------------
%------------------------------------------------------------------------------------------------------------------------------------------------
%------------------------------------------------------------------------------------------------------------------------------------------------










%load('/Users/karimbenchenane/Downloads/MV1&MP1/KB_1.mat')
load('/Users/karimbenchenane/Downloads/MV1&MP1/KB_2.mat')

%load('/Users/karimbenchenane/Downloads/MV1&MP1/KB_3.mat')
%MP1=MP1Droite;
%MV1=MV1Droite;
%MV1=MV1Gauche;
%MP1=MP1Gauche;

%------------------------------------------------------------------------
%------------------------------------------------------------------------
%------------------------------------------------------------------------


try

                MP1;
                MV1;

            params.Fs=1/median(diff(Temps));


               [Cb,phib,S12b,S1b,S2b,tb,fb]=cohgramc(MP1-mean(MP1),MV1-mean(MV1),movingwin,params);

            
            C=Cb;
            phi=phib;
            S12=S12b;
            S1=S1b;
            S2=S2b;
            t=tb;
            f=fb;

            figure('Color',[1 1 1]), hold on
            subplot(5,1,1),hold on
            plot(Temps,MP1,'k')
            plot(Temps,MV1,'r'),
            subplot(5,1,2),imagesc(t,f,10*log10(S1)'), axis xy
            subplot(5,1,3),imagesc(t,f,10*log10(S2)'), axis xy
            subplot(5,1,4),imagesc(t,f,C'), axis xy
            subplot(5,1,5),imagesc(t,f,phi'), axis xy


            %------------------------------------------------------------------------
            %------------------------------------------------------------------------
            %------------------------------------------------------------------------

            %figure('Color',[1 1 1]), hold on
            %plot(Temps,MP1,'k')
            %plot(Temps,MV1,'r'),


            [Cr,lag]=xcorr(MP1,MV1,'coeff');



            [Crp,lagp]=xcorr(MP1,MP1,'coeff');
            [Crv,lagv]=xcorr(MV1,MV1,'coeff');
            % 
            % figure('Color',[1 1 1]), hold on
            
            figure('Color',[1 1 1]), hold on
            plot(lag/params.Fs,Cr,'-o')
            xlim([-200 200])
            
            plot(lagp/params.Fs,Crp,'-ko')
            plot(lagv/params.Fs,Crv,'-ro')
            xlim([-50 50])
            yl=ylim;
            line([0 0],yl,'color',[0.7 0.7 0.7])
% 

            %------------------------------------------------------------------------
            %------------------------------------------------------------------------
            %------------------------------------------------------------------------


%             MP1Tsd=tsd(Temps*1E4,MP1);
%             MV1Tsd=tsd(Temps*1E4,MV1);
% 
% 
%             b=1;
% 
%             c=0.01;
%             %c=0.05;
% 
%             fi=128;
% 
%             figure('Color',[1 1 1]), hold on
%             plot(Range(MP1Tsd,'s'),Data(MP1Tsd),'k','linewidth',1)
%             Bins=[0.001:c:0.79];
% 
%             for a=Bins
% 
%                 MP1f=FilterLFP(MP1Tsd,[a, a+c],fi);
%                 MV1f=FilterLFP(MV1Tsd,[a, a+c],fi);
% 
%             plot(Range(MP1f,'s'),Data(MP1f),'color',[b/length(Bins),0,(length(Bins)-b)/length(Bins)])
% 
% 
%                 g=etc_granger([Data(MP1f),Data(MV1f)],15);
%                 Gr(b,1)=g(1,2);
%                 Gr(b,2)=g(2,1);
%                 b=b+1;
%             end
% 
%             figure('Color',[1 1 1]), hold on
%             plot(Bins,Gr)
%             plot(f,mean(C),'r')

            
end


%------------------------------------------------------------------------
%------------------------------------------------------------------------
%------------------------------------------------------------------------


% 
% figure('Color',[1 1 1]), hold on
% plot(Temps,MP1,'r')
% plot(Temps,MV1,'k'),
% plot(Temps,MV1bis,'b'),


%------------------------------------------------------------------------
%------------------------------------------------------------------------
%------------------------------------------------------------------------

order=15;

try
[granger2, granger_F, granger_pvalue, granger_num, granger_den, granger_num_dof, granger_den_dof, granger_dir, granger_inst]=etc_granger([MP1,MV1],order,'ts_name',{'MP1','MV1'});
end

% try
% [granger3, granger_F, granger_pvalue, granger_num, granger_den, granger_num_dof, granger_den_dof, granger_dir, granger_inst]=etc_granger([MP1,MV1,MV1bis],order,'ts_name',{'MP1','MV1','MV1bis'});
% end

%------------------------------------------------------------------------------------------------------------------------------------------------
%------------------------------------------------------------------------------------------------------------------------------------------------
%------------------------------------------------------------------------------------------------------------------------------------------------



load('/Users/karimbenchenane/Downloads/MV1&MP1/KB_3.mat')

try
    [granger4, granger_F, granger_pvalue, granger_num, granger_den, granger_num_dof, granger_den_dof, granger_dir, granger_inst]=etc_granger([MP1Droite,MP1Gauche,MV1Droite,MV1Gauche],order,'ts_name',{'MP1Droite','MP1Gauche','MV1Droite','MV1Gauche'});
end


%------------------------------------------------------------------------------------------------------------------------------------------------
%------------------------------------------------------------------------------------------------------------------------------------------------
%------------------------------------------------------------------------------------------------------------------------------------------------




load('/Users/karimbenchenane/Downloads/MV1&MP1/KB_1.mat')

try
[granger1, granger_F, granger_pvalue, granger_num, granger_den, granger_num_dof, granger_den_dof, granger_dir, granger_inst]=etc_granger([MP1,MV1],order,'ts_name',{'MP1','MV1'});
end

[Fx2ya,Fy2xa]= one_bi_ga([MP1,MV1],1,100,order,params.Fs,[0.001:0.01:params.Fs/2]);

figure('Color',[1 1 1]), hold on, 
plot([0.001:0.01:params.Fs/2],Fx2ya,'k'), hold on, plot([0.001:0.01:params.Fs/2],Fy2xa,'r')


%------------------------------------------------------------------------------------------------------------------------------------------------
%------------------------------------------------------------------------------------------------------------------------------------------------
%------------------------------------------------------------------------------------------------------------------------------------------------



load('/Users/karimbenchenane/Downloads/MV1&MP1/KB_2.mat')

try
[granger2, granger_F, granger_pvalue, granger_num, granger_den, granger_num_dof, granger_den_dof, granger_dir, granger_inst]=etc_granger([MP1,MV1],order,'ts_name',{'MP1','MV1'});
end

[Fx2yb,Fy2xb]= one_bi_ga([MP1,MV1],1,100,order,params.Fs,[0.001:0.01:params.Fs/2]);

figure('Color',[1 1 1]), hold on
plot([0.001:0.01:params.Fs/2],Fx2yb,'k'), hold on, plot([0.001:0.01:params.Fs/2],Fy2xb,'r')

figure('Color',[1 1 1]), hold on
plot(fa,mean(Ca),'b')
plot(fb,mean(Cb),'r')            



figure('Color',[1 1 1]), hold on
plot(fa,mean(S1a),'b')
plot(fa,mean(S1b),'c')
plot(fa,mean(S2a),'r')
plot(fa,mean(S2b),'m')
plot([0.001:0.01:params.Fs/2],Fx2ya*100,'k'), hold on, plot([0.001:0.01:params.Fs/2],Fy2xa*100,'color',[0.7 0.7 0.7])
plot([0.001:0.01:params.Fs/2],Fx2yb*100,'k'), hold on, plot([0.001:0.01:params.Fs/2],Fy2xb*100,'color',[0.7 0.7 0.7])





figure('Color',[1 1 1]), hold on
plot(fa,mean(S1b),'c')
plot(fa,mean(S2b),'m')
plot([0.001:0.01:params.Fs/2],Fx2yb*100,'k'), hold on, plot([0.001:0.01:params.Fs/2],Fy2xb*100,'color',[0.7 0.7 0.7])





figure('Color',[1 1 1]), hold on
plot(fa,mean(S1a),'b')
plot(fa,mean(S2a),'r')
plot([0.001:0.01:params.Fs/2],Fx2ya*100,'k'), hold on, plot([0.001:0.01:params.Fs/2],Fy2xa*100,'color',[0.7 0.7 0.7])


