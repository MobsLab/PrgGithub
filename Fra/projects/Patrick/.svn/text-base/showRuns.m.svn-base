ep = 1;
doPlot = true;
eegcross = -0.06;
for ep = 9
    sy = Range(subset(Sync, epochs{ep}.ix))+200;
    if ~exist('EEGPFCsmooth','var')
        EEGPFCsmooth = smooth(EEGPFCLFP, 200);
    end

    figure(4);

    passes = threshold(EEGPFCsmooth, eegcross);
    firstIntSpikes = Restrict(intSpikes, sy+500, 'align', 'next');
    passes = Restrict(passes, sy+500, 'align', 'next');

    fi = Range(firstIntSpikes);
    
    fI{ep} = fi-sy;
    
    ig2 = find(fi-sy < 5000);

    fi2 = fi(ig2)-sy(ig2);
    ps2 = Range(passes);
    ps = Range(passes);
    ps2 = ps2(ig2)-sy(ig2);
    pS{ep} = ps-sy;
    if doPlot
        for  i = 1:length(sy)
            clf
            eeg = Restrict(EEGPFCsmooth, sy(i)-1000*10, sy(i)+1000*10);
            plot(Range(eeg, 's'), Data(eeg));
            sp = Restrict(intSpikes,  sy(i)-1000*10,  sy(i)+1000*10);
            hold on
            plot(Range(sp, 's'), zeros(size(sp)), 'r.');
            set(gca, 'xlim', [(sy(i)/10000 -0.5) (sy(i)/10000+0.7)]);
            e2 = Restrict(EEGPFCsmooth, fi(i));

            plot(fi(i)/10000,Data(e2), 'g.', 'MarkerSize', 20)
            plot(ps(i)/10000, eegcross, 'm.', 'MarkerSize', 20);
            plot(get(gca, 'xlim'), [Data(e2), Data(e2)], 'g--')
            plot([fi(i)/10000 fi(i)/10000], get(gca, 'ylim'), 'g--');
            plot([ps(i)/10000 ps(i)/10000], get(gca, 'ylim'), 'm--');
             plot([sy(i)/10000 sy(i)/10000], get(gca, 'ylim'), 'k--');
           keyboard
        end
    end
end


