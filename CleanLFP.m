function EEG=CleanLFP(EEG,thLFP)

if length(thLFP)==1
    thLFP=[-thLFP thLFP];
end

eeg=Data(EEG);

eeg(eeg<thLFP(1))=thLFP(1);
eeg(eeg>thLFP(2))=thLFP(2);

EEG=tsd(Range(EEG),eeg);
