        Filsp=FilterLFP(Restrict(LFP,Epoch),[120 200],1024);
        Hil=hilbert(Data(Filsp));
        Fil=abs(Hil);
        Fil=tsd(Range(Filsp),Fil);
        window=[10:10:5000];
        windows=[1:5:500];
        % --> 8e-4 s
        for w=1:length(windows)
            [Y,X]=hist(zscore(smooth(Data(Fil),windows(w))),3000);
            ripdists(w,:)=Y;
            ripdistx(w,:)=X;
                                
        end
        
        for w=1:length(windows)
tseries=timeseries(ripdists(w,:),ripdistx(w,:));
time=X;
thts=resample(tseries,time);
ripdistX(w,:)=thts.time;
z=thts.Data;
 for t=1:length(z)
     ripdistS(w,t)=z(1,1,t);
 end
        end
          
          for w=1:length(windows)
              ripdistS1(w,:)=ripdistS(w,:)/sum(ripdistS(w,:));
          end
            
          amp=[0.2:0.2:20];
                        Filz=tsd(Range(Fil),zscore(Data(Fil)));

          for a=1:length(amp)
             Ep=thresholdIntervals(Filz,amp(a),'Direction','Above');
             evt{a}=(Stop(Ep)-Start(Ep));
          end
          
          for a=1:length(amp)
              num(a)=length(evt{a});
              dur(a)=nanmean(evt{a});
              durm(a)=median(evt{a});
              
          end
          
              figure
        imagesc(X,windows*8e-4,log(ripdistS))
        figure
        imagesc(X,window*8e-4,log(ripdist2))
        figure
        surf(ripdist)
        figure
        surf(X,window*8e-4,log(ripdist))
        
        
        
        Ep=thresholdIntervals(Filz,5,'Direction','Above');
        for k=1:length(Start(Ep))
            [a,b]=max(Data(Restrict(Filz,subset(Ep,k))));
            time=Range(Restrict(Filz,subset(Ep,k)));
            maxtime(k)=time(b);
        end
        
        dur=[0.005:0.005:0.3,0.4:0.1:1]*1e4;
        for i=1:length(dur)
        Epo=intervalSet(maxtime-dur(i),maxtime+dur(i));
        Epo=CleanUpEpoch(Epo);
        val(i,1)=mean(Data(Restrict(Filz,Epo)));
        val(i,2)=mean(Data(Restrict(Filz,Epoch-Epo)));
            
        end
        
        