firstProblem=1;
lastProblem=3;
fr=fopen('../../results/runAll/runAll.log', 'a');
if -1==fr
	error('error opening log file')
end
fprintf(fr,['Execution date: ',date,' ',datestr(now, 'HH:MM:SS'),'\n']);
fprintf(fr, 'The results bellow are for the datasets #%i-%i\n', firstProblem, lastProblem);
fclose(fr);
for dataset=firstProblem:lastProblem
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
run('C:\Workspace\TCC_Code\matlab\sintetic\sintetic_bench.m')