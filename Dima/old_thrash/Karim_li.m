

load SpectrumDataL/Spectrum2
Stsd{1}=tsd(t*1E4,Sp);
load SpectrumDataL/Spectrum1
Stsd{2}=tsd(t*1E4,Sp);
load SpectrumDataL/Spectrum13
Stsd{3}=tsd(t*1E4,Sp);
load SpectrumDataL/Spectrum15
Stsd{4}=tsd(t*1E4,Sp);
load SpectrumDataL/Spectrum7
Stsd{5}=tsd(t*1E4,Sp);
load SpectrumDataL/Spectrum9
Stsd{6}=tsd(t*1E4,Sp);
load SpectrumDataL/Spectrum4
Stsd{7}=tsd(t*1E4,Sp);

name{1}='PFC left';
name{2}='dHPC left';
name{3}='deep dHPC';
name{4}='pir dHPC';
name{5}='Bulb';
name{6}='vHPC';
name{7}='PFC right';


Epoch2=intervalSet(StimInfo.StartTime(StimInfo.Freq==2)*1E4, StimInfo.StopTime(StimInfo.Freq==2)*1E4);
Epoch4=intervalSet(StimInfo.StartTime(StimInfo.Freq==4)*1E4, StimInfo.StopTime(StimInfo.Freq==4)*1E4);
Epoch7=intervalSet(StimInfo.StartTime(StimInfo.Freq==7)*1E4, StimInfo.StopTime(StimInfo.Freq==7)*1E4);
Epoch10=intervalSet(StimInfo.StartTime(StimInfo.Freq==10)*1E4, StimInfo.StopTime(StimInfo.Freq==10)*1E4);


figure,

clf 
for i=1:20
%     for i=13
%     try
k=1;
        for a=1:7
        Epoch=subset(Epoch2,i);
        st=Start(Epoch);En=End(Epoch);
        Epoch=intervalSet(st-10E4,En+10E4);
        try
            subplot(7,4,k), imagesc(Range(Restrict(Stsd{a},Epoch),'s'),f,10*log10(Data(Restrict(Stsd{a},Epoch))')), axis xy, caxis([20 55]); title([name{a},num2str(i)])
       % 10*log10(Data(Restrict(Stsd{a},Epoch))'
        line([st st]/1E4,ylim,'color','k')
        line([En En]/1E4,ylim,'color','k')        
        end
        Epoch=subset(Epoch4,i);
        st=Start(Epoch);En=End(Epoch);
        Epoch=intervalSet(st-10E4,En+10E4);
        try
            subplot(7,4,k+1), imagesc(Range(Restrict(Stsd{a},Epoch),'s'),f,10*log10(Data(Restrict(Stsd{a},Epoch))')), axis xy, caxis([20 55]); title([name{a},num2str(i)])
        line([st st]/1E4,ylim,'color','k')
        line([En En]/1E4,ylim,'color','k')        
        end
        Epoch=subset(Epoch7,i);
        st=Start(Epoch);En=End(Epoch);
        Epoch=intervalSet(st-10E4,En+10E4);
        try
            subplot(7,4,k+2), imagesc(Range(Restrict(Stsd{a},Epoch),'s'),f,10*log10(Data(Restrict(Stsd{a},Epoch))')), axis xy, caxis([20 55]); title([name{a},num2str(i)])
        line([st st]/1E4,ylim,'color','k')
        line([En En]/1E4,ylim,'color','k')        
        end
        Epoch=subset(Epoch10,i);
        st=Start(Epoch);En=End(Epoch);
        Epoch=intervalSet(st-10E4,En+10E4);
        try
            subplot(7,4,k+3), imagesc(Range(Restrict(Stsd{a},Epoch),'s'),f,10*log10(Data(Restrict(Stsd{a},Epoch))')), axis xy, caxis([20 55]); title([name{a},num2str(i)])
        line([st st]/1E4,ylim,'color','k')
        line([En En]/1E4,ylim,'color','k')
        end
        k=k+4;
        end
        
        pause(5)
        
%     end
end


