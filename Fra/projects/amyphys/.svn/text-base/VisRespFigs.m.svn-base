function fig_st = VisRespFigs()

fig_st = {};

global FIGURE_DIR

FIGURE_DIR = '/home/fpbatta/Data/amyphys';

load VisualRespSummary
rw = rows(:);
nuclei = rw(1:4);
fig = [];
fig.xTickLabel = nuclei;
fig.figureType = 'hist';
fig.x = 1:length(nuclei);

fig.n = [extract_mean(data{ROW_lateral, COL_baseRate});
         extract_mean(data{ROW_basal, COL_baseRate}); 
         extract_mean(data{ROW_si, COL_baseRate}); 
         extract_mean(data{ROW_bl, COL_baseRate})];

fig.figureName = 'AmyphysBaseRate';

fig_st = [fig_st {  fig }];


fig = [];
fig.xTickLabel = nuclei;
fig.figureType = 'hist';
fig.x = 1:length(nuclei);

fig.n = [extract_mean(data{ROW_lateral, COL_burstiness});
         extract_mean(data{ROW_basal, COL_burstiness}); 
         extract_mean(data{ROW_si, COL_burstiness}); 
         extract_mean(data{ROW_bl, COL_burstiness})];
fig.figureName = 'AmyphysBurstiness';

fig_st = [fig_st {  fig }];

  
fig = [];
fig.xTickLabel = nuclei;
fig.figureType = 'hist';
fig.x = 1:length(nuclei);


fig.n = [extract_mean(data{ROW_lateral, COL_fixChange}),  extract_mean(data{ROW_lateral, COL_phasChange}), extract_mean(data{ROW_lateral, COL_tonicChange}),extract_mean(data{ROW_lateral, COL_imgoffChange}); 
         extract_mean(data{ROW_basal, COL_fixChange}),extract_mean(data{ROW_basal, COL_phasChange}), extract_mean(data{ROW_basal, COL_tonicChange}), extract_mean(data{ROW_basal, COL_imgoffChange}); 
         extract_mean(data{ROW_si, COL_fixChange}), extract_mean(data{ROW_si, COL_phasChange}), extract_mean(data{ROW_si, COL_tonicChange}), extract_mean(data{ROW_si, COL_imgoffChange}); 
         extract_mean(data{ROW_bl, COL_fixChange}), extract_mean(data{ROW_bl, COL_phasChange}), extract_mean(data{ROW_bl, COL_tonicChange}), extract_mean(data{ROW_bl, COL_imgoffChange})];

     fig.legend = ({'fixspot', 'phasic', 'tonic', 'imgoff'});
 fig.figureName = 'AmyphysVisResp';
fig.yLim = [0 7];
fig_st = [fig_st {  fig }];

function f = extract_mean(s);

    f = str2num(strtok(s, '+'));
