function savegraphs(n)
% SAVEGRAPHS - Function to save graphs 1 to n
%  Close the SleepLab menu and invoke with savegraphs(n),
%  where n is the number of figures.

for i=n:-1:1
    name=['wake' num2str(i) '.png'];

    oldscreenunits = get(gcf, 'Units');
    oldpaperunits = get(gcf, 'PaperUnits');
    oldpaperpos = get(gcf, 'PaperPosition');
    set(gcf, 'Units', 'pixels');
    scrpos = get(gcf, 'Position');
    newpos = scrpos/100;
    set(gcf,'PaperUnits', 'inches', 'PaperPosition', newpos)
    print('-dpng', name, '-r100');
    drawnow
    set(gcf, 'Units', oldscreenunits, 'PaperUnits', oldpaperunits, 'PaperPosition', oldpaperpos)
    close gcf;
end
