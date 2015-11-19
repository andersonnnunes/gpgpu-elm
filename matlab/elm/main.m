clc;
clear all;
current_algo_name='elm';
n_trials=10;
addpath('..\shared\');
valS = [10, 30, 50, 70, 100, 150, 200, 350, 500, 800, 1000, 1400, 2000];
nvalS = length(valS); % valS contém 13 valores
acc=zeros(nvalS,n_trials);
datasets
fr=fopen(f_results, 'w');
if -1==fr
	error('error opening %s', f_results);
end
fclose(fr);

% N0=npt;
% Block=0;

for i=0:n_trials-1 % Vamos começar descobrindo o melhor parâmetro, para isso, use a partição de validação.
	fr=fopen(f_results, 'a');
	if -1==fr
		error('error opening %s', f_results);
	end
	fprintf('trial %i --------------\n', i);
	fprintf(fr, 'trial %i --------------\n', i);
	trial_number=num2str(i);
	for j = 1:nvalS % PARAMETER TUNING
		[TrainingTime, TestingTime, TrainingAccuracy, TestingAccuracy] = ELM(strcat('../../dataset/',name_problem,'/train/',trial_number,'-elm.dat'), strcat('../../dataset/',name_problem,'/validate/',trial_number,'-elm.dat'), 1, valS(j), 'hardlim');
		acc(j,i+1) = TrainingAccuracy.*100;
		fprintf('s= %g acc= %5.1f%%\n', valS(j), acc(j,i+1));
		fprintf(fr,'s= %g acc= %5.1f%%\n', valS(j), acc(j,i+1));
	end
end
avg_acc=mean(acc,2);
fprintf('VALIDATION AVERAGE:\n');
for i=1:nvalS
	fprintf('s= %g acc=%5.1f%%\n', valS(i), avg_acc(i));
	fprintf(fr,'s= %g acc=%5.1f%%\n', valS(i), avg_acc(i));
end
[best_acc imax] = max(avg_acc); bestS = valS(imax);
fprintf('best_acc=%5.1f%% bestS= %g\n', best_acc, bestS);
fprintf(fr,'best_acc=%5.1f%% bestS= %g\n', best_acc, bestS);

% Use o melhor parâmetro com a partição de teste.
acc_test=zeros(1,n_trials);
for i=0:n_trials-1 % TESTING
	[TrainingTime, TestingTime, TrainingAccuracy, TestingAccuracy] = ELM(strcat('../../dataset/',name_problem,'/train/',trial_number,'-elm.dat'), strcat('../../dataset/',name_problem,'/test/',trial_number,'-elm.dat'), 1, valS(j), 'hardlim');
	acc_test(i+1) = TestingAccuracy.*100;
end
fprintf('avg. acc.= %5.1f%% spread= %g\n', mean(acc_test), bestS);
fprintf(fr,'avg. acc.= %5.1f%% spread= %g\ncm=\n', mean(acc_test), bestS);
fprintf('Train time s= %.10f\n', TrainingTime);
fprintf(fr,'Train time s= %.10f\n', TrainingTime);
fprintf('Test time s= %.10f\n', TestingTime);
fprintf(fr,'Test time s= %.10f\n', TestingTime);
fclose(fr);