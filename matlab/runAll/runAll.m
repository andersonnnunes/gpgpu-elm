fr=fopen('../../results/runAll/runAll.log', 'w');
if -1==fr
	error('error opening log file')
end
fprintf(fr,['Execution date: ',date,' ',datestr(now, 'HH:MM:SS'),'\n']);
fclose(fr);
for dataset=1:3
	run('C:\Workspace\TCC_Code\matlab\elm\main.m')
	run('C:\Workspace\TCC_Code\matlab\gpgpu-elm\main.m')
	run('C:\Workspace\TCC_Code\matlab\dkp\main.m')
	run('C:\Workspace\TCC_Code\matlab\svm\main.m')
end
fr=fopen('../../results/runAll/runAll.log', 'a');
if -1==fr
	error('error opening log file')
end
fprintf(fr,['Finalized at: ',date,' ',datestr(now, 'HH:MM:SS'),'\n']);
fclose(fr);