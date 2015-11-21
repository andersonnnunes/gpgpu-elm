clc;
clear all;
addpath('..\shared\');
current_algo_name='elm';
n_trials = 2;
datasets;
valS = [10:30:100 150:125:1000 1500:250:3000];
valC = {'sig', 'sin', 'hardlim', 'tribas', 'radbas'};
nvalS = length(valS);
nvalC = length(valC);
fr=fopen(f_results, 'a');
if -1==fr
	error('error opening %s', f_results)
end
fprintf(fr,['Execution date: ',date,' ',datestr(now, 'HH:MM:SS'),'\n']);
acc=zeros(nvalS, nvalC, n_trials);
fprintf('VALIDATION TRIALS\n');
fprintf(fr,'VALIDATION TRIALS\n');
tic;
for i=0:n_trials-1
	fprintf(fr, 'trial %i --------------\n', i);
	trial_number=num2str(i);
	for j = 1:nvalS % PARAMETER TUNING for S
		for k = 1:nvalC % PARAMETER TUNING for C
			[TrainingTime, TestingTime, TrainingAccuracy, TestingAccuracy] = ELM(strcat('../../dataset/',name_problem,'/train/',trial_number,'-elm.dat'), strcat('../../dataset/',name_problem,'/validate/',trial_number,'-elm.dat'), 1, valS(j), valC{k});
			acc(j,k,i+1) = TrainingAccuracy.*100;
			fprintf(fr,'nHiddenNeurons = %g act. func. = %s acc= %5.1f%%\n', valS(j), valC{k}, acc(j,k,i+1));
		end
	end
end
ValidationTime=toc;
fprintf('time to validate parameters = %.10f\n', ValidationTime);
fprintf(fr,'time to validate parameters = %.10f\n', ValidationTime);
avg_acc=mean(acc,3);
fprintf(fr,'VALIDATION AVERAGE:\n');
for j=1:nvalS
	for k=1:nvalC
		fprintf(fr,'nHiddenNeurons = %g act. func. = %s acc=%5.1f%%\n', valS(j), valC{k}, avg_acc(j,k));
	end
end
[best_acc imax] = max(avg_acc(:)); bestS = valS(mod(imax,nvalS)); [best_acc imax] = max(max(avg_acc)); bestC = valC{imax};
fprintf('best_acc=%5.1f%% bestS= %g bestC= %s\n', best_acc, bestS, bestC);
fprintf(fr,'best_acc=%5.1f%% bestS= %g bestC= %s\n', best_acc, bestS, bestC);

fprintf('TEST TRIALS\n'); % Use o melhor parâmetro com a partição de teste.
fprintf(fr,'TEST TRIALS\n');
acc_test=zeros(1,n_trials); build_time=zeros(1,n_trials); test_time=zeros(1,n_trials);
for i=0:n_trials-1 % TESTING
	[TrainingTime, TestingTime, TrainingAccuracy, TestingAccuracy] = ELM(strcat('../../dataset/',name_problem,'/train/',trial_number,'-elm.dat'), strcat('../../dataset/',name_problem,'/test/',trial_number,'-elm.dat'), 1, bestS, bestC);
	acc_test(i+1) = TestingAccuracy.*100;
	build_time(i+1) = TrainingTime;
	test_time(i+1) = TestingTime;
end
fprintf('TESTING AVERAGE:\n');
fprintf(fr,'TESTING AVERAGE:\n');
fprintf('avg. acc.= %5.1f%% nHiddenNeurons = %g act. func. = %s\n', mean(acc_test), bestS, bestC);
fprintf(fr,'avg. acc.= %5.1f%% nHiddenNeurons = %g act. func. = %s\n', mean(acc_test), bestS, bestC);
fprintf('avg. time to build model = %.10f\n', mean(build_time));
fprintf(fr,'avg. time to build model = %.10f\n', mean(build_time));
fprintf('avg. time to test model = %.10f\n', mean(test_time));
fprintf(fr,'avg. time to test model = %.10f\n', mean(test_time));
fclose(fr);