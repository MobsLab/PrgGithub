function [Trans,MnStayTime,NumEp,TotTime] = TransMatFromFzZn(Fz,Zn,BinSz)

for init_zn = 1:5
    for init_fz = 1:2
        for end_zn = 1:5
            for end_fz = 1:2
                
                if  nansum(Fz(1:end-1) == init_fz & Zn(1:end-1) == init_zn)>0 % mouse went into this stte at least once
                Trans(init_zn + 5*(init_fz-1),end_zn + 5*(end_fz-1)) = nansum(Fz(1:end-1) == init_fz & Zn(1:end-1) == init_zn & Fz(2:end) == end_fz & Zn(2:end) ==end_zn)./ nansum(Fz(1:end-1) == init_fz & Zn(1:end-1) == init_zn);
                else
                    % Fix case where mouse never visits a state
                    Trans(init_zn + 5*(init_fz-1),end_zn + 5*(end_fz-1)) = NaN;
                end
                if init_zn==end_zn & init_fz == end_fz
                    Binary_tsd = tsd([1:1:length(Fz)]'*BinSz*1E4,(Fz==init_fz & Zn==init_zn)');
                    GoodEpoch = thresholdIntervals(Binary_tsd,0.5);
                    MnStayTime(init_zn,init_fz) = nanmean(Stop(GoodEpoch,'s') - Start(GoodEpoch,'s'));
                    NumEp(init_zn,init_fz) = length(Stop(GoodEpoch,'s'));
                    TotTime(init_zn,init_fz) = sum(Stop(GoodEpoch,'s') - Start(GoodEpoch,'s'));
                end
                
            end
        end
    end
end



end