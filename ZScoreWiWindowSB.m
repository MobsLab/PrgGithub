function [zscored]=ZScoreWiWindowSB(tozscore,window)

for k = 1:size(tozscore,1)
    meanval=nanmean(tozscore(k,window));
    stdval=nanstd(tozscore(k,window));
    if stdval==0
        stdval=1;
    end

    zscored(k,:) = (tozscore(k,:)-meanval)/stdval;
end

end