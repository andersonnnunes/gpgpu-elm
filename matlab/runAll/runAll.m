lineup=[1,1,0,1,1];
firstProblem=1;
lastProblem=3;
n_trials=10;
fr=fopen('../../results/runAll/runAll.log', 'w');
if -1==fr
	error('error opening log file')
end
fprintf(fr,'------------------------------------------------------------\n');
fprintf(fr,['Execution date: ',date,' ',datestr(now, 'HH:MM:SS'),'\n']);
fprintf(fr, 'The results bellow are for the datasets #%i-%i\n', firstProblem, lastProblem);
fclose(fr);
for dataset=firstProblem:lastProblem
	if lineup(1) == 1
		run('C:\Workspace\TCC_Code\matlab\elm\main.m');
	else
		fr=fopen('../../results/runAll/runAll.log', 'a'); fprintf(fr,'Skipping.\n'); fclose(fr);
	end
	if lineup(2) == 1
		run('C:\Workspace\TCC_Code\matlab\gpgpu-elm\main.m');
	else
		fr=fopen('../../results/runAll/runAll.log', 'a'); fprintf(fr,'Skipping.\n'); fclose(fr);
	end
	if lineup(3) == 1
		run('C:\Workspace\TCC_Code\matlab\dkp\main.m');
	else
		fr=fopen('../../results/runAll/runAll.log', 'a'); fprintf(fr,'Skipping.\n'); fclose(fr);
	end
	if lineup(4) == 1
		run('C:\Workspace\TCC_Code\matlab\svm\main.m');
	else
		fr=fopen('../../results/runAll/runAll.log', 'a'); fprintf(fr,'Skipping.\n'); fclose(fr);
	end
end
if lineup(5) == 1
	run('C:\Workspace\TCC_Code\matlab\synthetic\synthetic_bench.m')
	fr=fopen('../../results/runAll/runAll.log', 'a'); fprintf(fr,'Synthetic benchmark was done successfully.\n'); fclose(fr);
else
	fr=fopen('../../results/runAll/runAll.log', 'a'); fprintf(fr,'Skipping synthetic benchmark.\n'); fclose(fr);
end
fr=fopen('../../results/runAll/runAll.log', 'a');
if -1==fr
	error('error opening log file')
end
fprintf(fr,['Finalized at: ',date,' ',datestr(now, 'HH:MM:SS'),'\n']); fclose(fr);