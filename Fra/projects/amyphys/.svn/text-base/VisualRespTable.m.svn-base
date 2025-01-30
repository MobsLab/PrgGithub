function VisualRespTable

outputFormat = 'html'
sign_thresh = 0.01;  
hm = getenv('HOME');
parent_dir = [ hm '/Data/amyphys'];

datasets = List2Cell([ parent_dir filesep 'datasets_2way.list' ] );

A = Analysis(parent_dir);

[A, cn] = getResource(A, 'AmygdalaCellList', datasets);
[A, bs_rate] = getResource(A, 'FRateBaseline', datasets);
[A, tr] = getResource(A, 'TonicRatio', datasets);
[A, tp] = getResource(A, 'TonicPval', datasets);
[A, pr] = getResource(A, 'PhasicRatio', datasets);
[A, pp] = getResource(A, 'PhasicPval', datasets);
[A, or] = getResource(A, 'OffPhasicRatio', datasets);
[A, op] = getResource(A, 'OffPhasicPval', datasets);
[A, fr] = getResource(A, 'FixFastPhasicRatio', datasets);
[A, fp] = getResource(A, 'FixFastPhasicPval', datasets);
[A, ac] = getResource(A, 'AnatomyData', datasets);
%[A, dpl]= getResource(A, 'DensityPeakLatency', datasets);
dpl = NaN * ones(size(ac));
[A, brs]= getResource(A, 'BurstinessGlobal', datasets);
nrows = length(cn);
cols = {
            'Nucleus'
            'Baseline Rate (Hz)'
            'Burstiness'
            'Peak Latency (ms)'
            'FixSpot Change'
            'FixSpot P-value'
            'Phasic Change'
            'Phasic P-value'
            'Tonic Change'
            'Tonic P-value'
            'ImgOff Change'
            'ImgOff P-value'
            'CellClass'
            };
        
ncols = length(cols);

data = cell(nrows, ncols);

data(:,1) = ac;
data(:,2) = cellifyArray(bs_rate);
data(:,3) = cellifyArray(brs);
data(:,4) = cellifyArray(dpl);
tpsave = tp;
trsave = tr;
tr = cellifyArray(tr);
tp = cellifyArray(tp);

if strcmp(outputFormat, 'html')
    for i = 1:length(tr)
        if str2num(tp{i}) < sign_thresh
            tr{i} = ['<strong>' (tr{i}) '</strong>'];
            tp{i} = ['<strong>' (tp{i}) '</strong>'];
        end
    end
end

data(:,9) = tr;
data(:,10) = tp;

ppsave = pp;
prsave = pr;
pr = cellifyArray(pr);
pp = cellifyArray(pp);

if strcmp(outputFormat, 'html')
    for i = 1:length(tr)
        if str2num(pp{i}) < sign_thresh
            pr{i} = ['<strong>' (pr{i}) '</strong>'];
            pp{i} = ['<strong>' (pp{i}) '</strong>'];
        end
    end
end

data(:,7) = pr;
data(:,8) = pp;

fpsave = fp;
frsave = fr;
fr = cellifyArray(fr);
fp = cellifyArray(fp);

if strcmp(outputFormat, 'html')
    for i = 1:length(tr)
        if str2num(fp{i}) < sign_thresh
            fr{i} = ['<strong>' (fr{i}) '</strong>'];
            fp{i} = ['<strong>' (fp{i}) '</strong>'];
        end
    end
end

data(:,5) = fr;
data(:,6) = fp; 

opsave = op;
orsave = or;
or = cellifyArray(or);
op = cellifyArray(op);

if strcmp(outputFormat, 'html')
    for i = 1:length(or)
        if str2num(op{i}) < sign_thresh
            or{i} = ['<strong>' (or{i}) '</strong>'];
            op{i} = ['<strong>' (op{i}) '</strong>'];
        end
    end
end

data(:,11) = or;
data(:,12) = op; 

if strcmp(outputFormat, 'html')
    for i = 1:length(cn)
        [p,n,e] = fileparts(cn{i});
        cn{i} = makeHtmlLink(['PETH/' n '_peth.html'], n, 'OpenNewWindow', 1);
    end
end
  
cellclass = cell(size(or));

for i = 1:length(cellclass)
    str = '';
    if (fpsave(i)) < sign_thresh
        if frsave(i) > 1
            str =[str 'f+'];
        else
            str = [str 'f-'];
        end
    end
    if (ppsave(i)) < sign_thresh
        if prsave(i) > 1
            str = [str 'p+'];
        else
            str = [str 'p-'];
        end
    end
    if (tpsave(i)) < sign_thresh
        if trsave(i) > 1 
            str = [str 't+'];
        else
            str = [str 't-'];
        end
    end
    if (opsave(i)) < sign_thresh
        if orsave(i) > 1
            str = [str 'o+'];
        else
            str = [str 'o-'];
        end
    end
    cellclass{i} = str;
end

data(:,13) = cellclass;
    
makeTable(data, cn, cols, 'output', outputFormat, 'fname', 'visRespTable' );

            
save VisualRespTable data cn  cols            
            




