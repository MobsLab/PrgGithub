function [SpikeConn,SpikeConnStr]=MonoSynapticConnectivity(S,Options)
% 
% Options.Window=[1.5,4]; %the time in ms in which we're searching for a
% %monosynaptic conneixion
% Options.ExcitLim=4; %be more demanding for excitation
% Options.InhibLim=1.5;
% Options.Binsize=0.5;

for sp1=1:length(S)-1
    sp1
    for sp2=sp1+1:length(S)
        % Only look into probably isgnificant neurons
        [H0,B] = CrossCorr(Range(S{sp1}),Range(S{sp2}),Options.Binsize,100/Options.Binsize);
        
        Lim(1) = mean(H0([1:find(B<-10,1,'last'),find(B>10,1,'first'):end]))+Options.ExcitLim*std(H0([1:find(B<-10,1,'last'),find(B>10,1,'first'):end]));
        Lim(2) = max([0,mean(H0([1:find(B<-10,1,'last'),find(B>10,1,'first'):end]))-Options.InhibLim*std(H0([1:find(B<-10,1,'last'),find(B>10,1,'first'):end]))]);
        bIx = find(B>=Options.Window(1) & B<=Options.Window(2));
        h1 = H0(bIx);
        bIx = find(B>=-Options.Window(2) & B<=-Options.Window(1));
        h2 = H0(bIx);
        h=[h1,h2];
        if sum(sum(h>Lim(1))>0 | sum(h<Lim(2))>0)>0 % If they're promising
            [H0,Hm,HeI,HeS,Hstd,B,HMaxMin] = XcJitter_SB(Range(S{sp1}),Range(S{sp2}),Options.Binsize,100/Options.Binsize,0.99,100);
            [SynC,ConStr] = XcConnection_SB_new(H0,Hm,HeI,HeS,Hstd,B,HMaxMin,Options.Window);
            if abs(SynC(1))==1 || abs(SynC(2))==1
                figure
                disp('sig')
                bar(B,H0)
                hold on
                plot(B,HeI,'g','linewidth',2)
                plot(B,HeS,'g','linewidth',2)
                plot(B,B*0+HMaxMin(1,1),'r','linewidth',2)
                plot(B,B*0+HMaxMin(2,1),'r','linewidth',2)
                plot(B,B*0+HMaxMin(1,2),'b','linewidth',2)
                plot(B,B*0+HMaxMin(2,2),'b','linewidth',2)
                SynC
            end
            SpikeConn(sp1,sp2)=SynC(1);
            SpikeConn(sp2,sp1)=SynC(2);
            SpikeConnStr(sp1,sp2)=ConStr(1);
            SpikeConnStr(sp2,sp1)=ConStr(2);

        else
            SpikeConn(sp1,sp2)=0;
            SpikeConn(sp2,sp1)=0;
            SpikeConnStr(sp1,sp2)=NaN;
            SpikeConnStr(sp2,sp1)=NaN;
        end
    end
end


end
