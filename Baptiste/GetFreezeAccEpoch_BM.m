


function FreezeAccEpoch = GetFreezeAccEpoch_BM(MovAcctsd , varargin)


for i = 1:2:length(varargin)
    if ~ischar(varargin{i})
        error(['Parameter ' num2str(i+2) ' is not a property.']);
    end
    switch(lower(varargin{i}))
        case 'thr'
            thr = varargin{i+1};
    end
end

if ~exist('thr','var')
    thr=1.7e7;
end

smoofact_Acc = 30;
thtps_immob = 2;

NewMovAcctsd=tsd(Range(MovAcctsd),runmean(Data(MovAcctsd),smoofact_Acc));
FreezeAccEpoch=thresholdIntervals(NewMovAcctsd,thr,'Direction','Below');
FreezeAccEpoch=mergeCloseIntervals(FreezeAccEpoch,0.3*1e4);
FreezeAccEpoch=dropShortIntervals(FreezeAccEpoch,thtps_immob*1e4);














