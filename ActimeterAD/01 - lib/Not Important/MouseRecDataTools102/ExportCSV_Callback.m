function ExportCSV_Callback(hObject, eventdata, pnam)
%  This function is a callback to an object on a figure menu item for
%  exporting the  plotted data to CSV file
%  hObject    handle to Save_Markers (see GCBO)
%  eventdata  reserved - to be defined in a future version of MATLAB
%  pnam - default path name to where file is stored
%
%   Written by Kevin D. Donohue (kevin.donohue@sigsoln.com) January 2011.

    
%  Get the children of current axis and find the X and Y data for the plot
vv = get(gca,'Children');
klen = length(vv);  
k=klen;  %  Start with the last child, since that is typically the plot of interest
%  step though the children to find a line type that is over 2 points
%  long (line markers for light and dark onset are 2 point lines and
%  these must be ignored)
while k>0 
gt = get(vv(k),'Type'); 
%  If child is a line check to ensure it is not a light and dark marker
if strcmp(gt,'line')
    sz = length(get(vv(k),'YData'));
    if sz > 2  %  If data segment longer than 2 points assume it plot of interest
        ydat = get(vv(k),'YData');
        xdat = get(vv(k),'XData');
        k=0;  %  Set k to get out of while loop
    else
        k=k-1;  %  If the line is not the plot of interest, go to next child
        xdat = [];  %  an empty array indicates that a plot has not been found
    end
else
    k=k-1;  %  If the type is not line, go to next child
    xdat = [];  %  an empty array indicates that a plot has not been found
end
end

%  If a line plot was found export to excel file
if ~isempty(xdat)

    %  Create cell array for output to excel
    outexcell=cell(length(xdat)+1,2);
    %  Write headers for time and wake activity
    outexcell{1,1} = 'Hour';
    outexcell{1,2} = 'Percent Wake';
    %  prompt user for file name change
    dtitle ='Export to Data CSV File';
    prompt = {'Filename'};
    chnam=get(gcf,'UserData');
    defres = {[chnam '.csv']};
    numlns = 1;
    %  Arrange data in cell array
    for kexcel=1:length(xdat)
        outexcell{kexcel+1,1} = xdat(kexcel);
        outexcell{kexcel+1,2} = ydat(kexcel);
    end

    %  Get user input
    detail_o = inputdlg(prompt,dtitle,numlns,defres,'on');
    if isempty(detail_o)
       th = warndlg('Operation Canceled, CSV file NOT create!');
       pause(3)
       if ishandle(th)
          close(th)
       end
    else
    textout([pnam detail_o{1}], outexcell)
    th = msgbox(['Creating file ' defres], 'Writing to CSV File');
    pause(2)
    if ishandle(th)
      close(th)
    end
    end
else
    th = msgbox(['File ' pnam, defres], 'saved!');
    pause(3)
    if ishandle(th)
      close(th)
    end    
end