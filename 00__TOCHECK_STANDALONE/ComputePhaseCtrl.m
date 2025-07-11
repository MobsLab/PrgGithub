function phaseTsd=ComputePhaseCtrl(tsa,EEGf,meth)

% meth 1 Hilbert
% meth 2 interpol thourgh
% meth 3 interpol peaks
% meth 4 interpol peks and through


if meth==1
    try
    [phases, phaseTsd] = firingPhaseHilbert(EEGf, tsa) ;
    catch
    [phases, phaseTsd] = firingPhaseHilbert(EEGf, tsdArray(tsa)) ;
    temp=phaseTsd{1};
    clear phaseTsd
    phaseTsd=temp;
    end

elseif meth==2
    dth = diff(Data(EEGf));
    dth1 = [0 dth'];
    dth2 = [dth' 0];
    clear dth;
    t = Range(EEGf);
    thpeaks = t(find (dth1 > 0 & dth2 < 0));
%     ep = timeSpan(EEGf);
%     ThStart = Start(ep);
%     ThEnd = End(ep);
%     clear t;
%     s = Data(Restrict(tsa, ThStart, ThEnd));
    s=Range(tsa);
    
    ph = zeros(size(s));
    pks = zeros(size(s));
    for j = 1:length(s)
        pk = binsearch_floor(thpeaks, s(j));
        ph(j) = (s(j) - thpeaks(pk)) / (thpeaks(pk+1) - thpeaks(pk));
        pks(j) = pk;
    end
    phaseTsd = tsd(s,[ph]*2*pi);

 elseif meth==3
    dth = diff(Data(EEGf));
    dth1 = [0 dth'];
    dth2 = [dth' 0];
    clear dth;
    t = Range(EEGf);
    thpeaks = t(find (dth1 < 0 & dth2 > 0));
%     ep = timeSpan(EEGf);
%     ThStart = Start(ep);
%     ThEnd = End(ep);
%     clear t;
%     s = Data(Restrict(tsa, ThStart, ThEnd));
        s=Range(tsa);
    ph = zeros(size(s));
    pks = zeros(size(s));
    for j = 1:length(s)
        pk = binsearch_floor(thpeaks, s(j));
        ph(j) = (s(j) - thpeaks(pk)) / (thpeaks(pk+1) - thpeaks(pk));
    end
    phaseTsd = tsd(s,mod(ph*2*pi+pi,2*pi));
    
elseif meth==4
    dth = diff(Data(EEGf));
    dth1 = [0 dth'];
    dth2 = [dth' 0];
    clear dth;
    t = Range(EEGf);
    thpeaks = t(find (dth1 > 0 & dth2 < 0));
    ththroughs = t(find (dth1 < 0 & dth2 > 0));
%     ep = timeSpan(EEGf);
%     ThStart = Start(ep);
%     ThEnd = End(ep);
%     clear t;
%     s = Data(Restrict(tsa, ThStart, ThEnd));
        s=Range(tsa);
    ph = zeros(size(s));
    pks = zeros(size(s));
    for j = 1:length(s)
        pk = binsearch_floor(thpeaks, s(j));
        th = binsearch_floor(ththroughs,thpeaks(pk+1));
        if s(j)>ththroughs(th)
        ph(j) = (s(j) - ththroughs(th)) / (thpeaks(pk+1) - ththroughs(th))*pi+pi;
        else
        ph(j) = (s(j) - thpeaks(pk)) / (ththroughs(th) - thpeaks(pk))*pi;            
        end
    end
    phaseTsd = tsd(s,[ph]);
 end


phaseTsd = tsd(Range(phaseTsd),mod(Data(phaseTsd),2*pi));
