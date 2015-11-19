clc;
clear all;
addpath('..\shared\');
current_algo_name='elm';
n_trials = 2;
datasets;
valS = [10:30:100 200:250:1000 1500:375:2700];
nvalS = length(valS);
fr=fopen(f_results, 'a');
if -1==fr
	error('error opening %s', f_results)
end
fprintf(fr,['Execution date: ',date,' ',datestr(now, 'HH:MM:SS'),'\n']);
acc=zeros(nvalS,n_trials);
fprintf('VALIDATION TRIALS\n');
fprintf(fr,'VALIDATION TRIALS\n');
start_time_validation=cputime;
for i=0:n_trials-1 % Descobra o melhor parâmetro, para isso, use a partição de validação.
	fprintf('trial %i --------------\n', i);
	fprintf(fr, 'trial %i --------------\n', i);
	trial_number=num2str(i);
	for j = 1:nvalS % PARAMETER TUNING
		[TrainingTime, TestingTime, TrainingAccuracy, TestingAccuracy] = ELM(strcat('../../dataset/',name_problem,'/train/',trial_number,'-elm.dat'), strcat('../../dataset/',name_problem,'/validate/',trial_number,'-elm.dat'), 1, valS(j), 'hardlim');
		acc(j,i+1) = TrainingAccuracy.*100;
		fprintf('nHiddenNeurons = %g acc= %5.1f%%\n', valS(j), acc(j,i+1));
		fprintf(fr,'nHiddenNeurons = %g acc= %5.1f%%\n', valS(j), acc(j,i+1));
	end
end
ValidationTime=cputime-start_time_validation; % Calculate CPU time (seconds) spent for validation.
fprintf('time to validate parameters = %.10f\n', ValidationTime);
fprintf(fr,'time to validate parameters = %.10f\n', ValidationTime);
avg_acc=mean(acc,2);
fprintf('VALIDATION AVERAGE:\n');
fprintf(fr,'VALIDATION AVERAGE:\n');
for i=1:nvalS
	fprintf('nHiddenNeurons = %g acc=%5.1f%%\n', valS(i), avg_acc(i));
	fprintf(fr,'nHiddenNeurons = %g acc=%5.1f%%\n', valS(i), avg_acc(i));
end
[best_acc imax] = max(avg_acc); bestS = valS(imax);
fprintf('best_acc=%5.1f%% bestS= %g\n', best_acc, bestS);
fprintf(fr,'best_acc=%5.1f%% bestS= %g\n', best_acc, bestS);

fprintf('TEST TRIALS\n'); % Use o melhor parâmetro com a partição de teste.
fprintf(fr,'TEST TRIALS\n');
acc_test=zeros(1,n_trials); build_time=zeros(1,n_trials); test_time=zeros(1,n_trials);
for i=0:n_trials-1 % TESTING
	[TrainingTime, TestingTime, TrainingAccuracy, TestingAccuracy] = ELM(strcat('../../dataset/',name_problem,'/train/',trial_number,'-elm.dat'), strcat('../../dataset/',name_problem,'/test/',trial_number,'-elm.dat'), 1, bestS, 'hardlim');
	acc_test(i+1) = TestingAccuracy.*100;
	build_time(i+1) = TrainingTime;
	test_time(i+1) = TestingTime;
end
fprintf('TESTING AVERAGE:\n');
fprintf(fr,'TESTING AVERAGE:\n');
fprintf('avg. acc.= %5.1f%% nHiddenNeurons = %g\n', mean(acc_test), bestS);
fprintf(fr,'avg. acc.= %5.1f%% nHiddenNeurons = %g\n', mean(acc_test), bestS);
fprintf('avg. time to build model = %.10f\n', mean(build_time));
fprintf(fr,'avg. time to build model = %.10f\n', mean(build_time));
fprintf('avg. time to test model = %.10f\n', mean(test_time));
fprintf(fr,'avg. time to test model = %.10f\n', mean(test_time));
fclose(fr);