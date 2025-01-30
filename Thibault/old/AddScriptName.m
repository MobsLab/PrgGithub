
function AddScriptName()
	[ST, I] = dbstack('-completenames', 1);

	annotation('textbox',[.50 0 .2 .06], 'String', strcat(['Figure created with ' ST.name '.m']), 'FitBoxToText','on','EdgeColor','none','FontAngle','italic')