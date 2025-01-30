function ep = LoadEpoch(fbasename,epname)

Fs = 1250/10000;
try

    fname = [fbasename '.sts.' epname];
    if exist(fname,'file')
        ep = load(fname);
        ep = intervalSet(ep(:,1)/Fs,ep(:,2)/Fs);
    else
        ep = intervalSet([],[]);
    end

catch
    warning(lasterr);
    keyboard
end
