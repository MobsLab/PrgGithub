function VisualRespTable


do_figures = 1:100;
global FIGURE_DIR;

FIGURE_DIR = [];
if isempty(FIGURE_DIR)
    hm = getenv('HOME');
    FIGURE_DIR = [ hm filesep 'Data/Angelo/figures'];
end


outputFormat = 'html';
sign_thresh = 0.01;  
hm = getenv('HOME');
parent_dir = [ hm '/Data/Angelo'];
sign_thresh = 0.01;

datasets = List2Cell([ parent_dir filesep 'datasets_eeg.list' ] );

A = Analysis(parent_dir);

[A, rate] = getResource(A, 'CellRate', datasets);
[A, rp] = getResource(A, 'RatePrecPval', datasets);
[A, cn] = getResource(A, 'HDThetaCellList', datasets);
[A, HDMean] = getResource(A, 'CellHDMean', datasets);
[A, HDDelta] = getResource(A, 'CellHDDelta', datasets);
[A, HDPval] = getResource(A, 'CellHDPval', datasets);
[A, thetaMean] = getResource(A, 'CellThetaPhaseMean', datasets);
[A, thetaDelta] = getResource(A, 'CellThetaPhaseDelta', datasets);
[A, thetaPval] = getResource(A, 'CellThetaPhasePval', datasets);
[A, peakMean] = getResource(A, 'PeakHDMean', datasets);
[A, peakDelta] = getResource(A, 'PeakHDDelta', datasets);
[A, troughMean] = getResource(A, 'TroughHDMean', datasets);
[A, troughDelta] = getResource(A, 'TroughHDDelta', datasets);

nrows = length(cn);
cols = {
                'rate',
                'HD Mean', 
                'HD Delta',
                'HD p', 
                'theta Mean',
                'theta Delta',
                'theta p',
                'theta prec p',
                'peak mean HD',
                'peak delta HD',
                'trough mean HD',
                'trough delta HD',
            };
        
ncols = length(cols);

data = cell(nrows, ncols);

data(:,1) = cellifyArray(rate);
data(:,2) = cellifyArray(HDMean);
data(:,3) = cellifyArray(HDDelta);
data(:,4) = cellifyArray(HDPval);
data(:,5) = cellifyArray(thetaMean);
data(:,6) = cellifyArray(thetaDelta);
data(:,7) = cellifyArray(thetaPval);
data(:,8) = cellifyArray(rp);
data(:,9) = cellifyArray(peakMean);
data(:,10) = cellifyArray(peakDelta);
data(:,11) = cellifyArray(troughMean);
data(:,12) = cellifyArray(troughDelta);





if strcmp(outputFormat, 'html')
    for i = 1:length(cn)
        ll = strrep(cn{i}, '/', '_');
        cn{i} = makeHtmlLink([ ll '_figures.html'], cn{i}, 'OpenNewWindow', 1);
    end
end
  

    
makeTable(data, cn, cols, 'output', outputFormat, 'fname', 'HDTable' );

            
save VisualRespTable data cn  cols            
            




