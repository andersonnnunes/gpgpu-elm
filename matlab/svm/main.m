clc;
clear all;
addpath('..\shared\');
current_algo_name='svm';
n_trials = 2;
datasets;
valS = pow2(-15:1:2);
valC = pow2(-5:1:14);
nvalS = length(valS);
nvalC = length(valC);
fr=fopen(f_results, 'a');
if -1==fr
	error('error opening %s', f_results)
end
fprintf(fr,['Execution date: ',date,' ',datestr(now, 'HH:MM:SS'),'\n']);
acc=zeros(nvalS,n_trials);
fprintf('VALIDATION TRIALS for S and C\n');
fprintf(fr,'VALIDATION TRIALS for S and C\n');
start_time_validation=cputime;
for i=0:n_trials-1 % Descobra o melhor parâmetro, para isso, use a partição de validação.
	fprintf('trial %i --------------\n', i);
	fprintf(fr, 'trial %i --------------\n', i);
	trial_number=num2str(i);
	[label_vector, instance_matrix] = libsvmread(strcat('../../dataset/',name_problem,'/train/',trial_number,'-svm.dat'));
	for j = 1:nvalS % PARAMETER TUNING for S
		for k = 1:nvalC % PARAMETER TUNING for C
			model = svmtrain(label_vector, instance_matrix, ['-q -c ', num2str(valC(k)),'-g ', num2str(valS(j))]);
			[label_vector, instance_matrix] = libsvmread(strcat('../../dataset/',name_problem,'/validate/',trial_number,'-svm.dat'));
			[predict_label, ValidationAccuracy, prob_estimates] = svmpredict(label_vector, instance_matrix, model, '-q');
			acc(j,i+1) = ValidationAccuracy(1);
			fprintf('s = %g c= %g acc= %5.1f%%\n', valS(j), valC(k), acc(j,i+1));
			fprintf(fr,'s = %g c= %g acc= %5.1f%%\n', valS(j), valC(k), acc(j,i+1));
		end
	end
end
ValidationTime=cputime-start_time_validation; % Calculate CPU time (seconds) spent for validation.
fprintf('time to validate parameters = %.10f\n', ValidationTime);
fprintf(fr,'time to validate parameters = %.10f\n', ValidationTime);
avg_acc=mean(acc,2);
fprintf('VALIDATION AVERAGE:\n');
fprintf(fr,'VALIDATION AVERAGE:\n');
for i=1:nvalS
	fprintf('s = %g acc=%5.1f%%\n', valS(i), avg_acc(i));
	fprintf(fr,'s = %g acc=%5.1f%%\n', valS(i), avg_acc(i));
end
[best_acc imax] = max(avg_acc); bestS = valS(imax);
fprintf('best_acc=%5.1f%% bestS= %g\n', best_acc, bestS);
fprintf(fr,'best_acc=%5.1f%% bestS= %g\n', best_acc, bestS);


fprintf('VALIDATION TRIALS for C\n');
fprintf(fr,'VALIDATION TRIALS for C\n');
start_time_validation=cputime;
for i=0:n_trials-1 % Descobra o melhor parâmetro, para isso, use a partição de validação.
	fprintf('trial %i --------------\n', i);
	fprintf(fr, 'trial %i --------------\n', i);
	trial_number=num2str(i);
	[label_vector, instance_matrix] = libsvmread(strcat('../../dataset/',name_problem,'/train/',trial_number,'-svm.dat'));
	for j = 1:nvalS % PARAMETER TUNING
		model = svmtrain(label_vector, instance_matrix, ['-q -c ', num2str(valC(j)) ,'-g ', num2str(bestS)]);
		[label_vector, instance_matrix] = libsvmread(strcat('../../dataset/',name_problem,'/validate/',trial_number,'-svm.dat'));
		[predict_label, ValidationAccuracy, prob_estimates] = svmpredict(label_vector, instance_matrix, model, '-q');
		acc(j,i+1) = ValidationAccuracy(1);
		fprintf('c = %g acc= %5.1f%%\n', valC(j), acc(j,i+1));
		fprintf(fr,'c = %g acc= %5.1f%%\n', valC(j), acc(j,i+1));
	end
end
ValidationTime=cputime-start_time_validation; % Calculate CPU time (seconds) spent for validation.
fprintf('time to validate parameters = %.10f\n', ValidationTime);
fprintf(fr,'time to validate parameters = %.10f\n', ValidationTime);
avg_acc=mean(acc,2);
fprintf('VALIDATION AVERAGE:\n');
fprintf(fr,'VALIDATION AVERAGE:\n');
for i=1:nvalS
	fprintf('c = %g acc=%5.1f%%\n', valC(i), avg_acc(i));
	fprintf(fr,'c = %g acc=%5.1f%%\n', valC(i), avg_acc(i));
end
[best_acc imax] = max(avg_acc); bestC = valC(imax);
fprintf('best_acc=%5.1f%% bestC= %g\n', best_acc, bestC);
fprintf(fr,'best_acc=%5.1f%% bestC= %g\n', best_acc, bestC);

fprintf('TEST TRIALS\n'); % Use os melhores parâmetros com a partição de teste.
fprintf(fr,'TEST TRIALS\n');
acc_test=zeros(1,n_trials); build_time=zeros(1,n_trials); test_time=zeros(1,n_trials);
for i=0:n_trials-1 % TESTING
	[label_vector, instance_matrix] = libsvmread(strcat('../../dataset/',name_problem,'/train/',trial_number,'-svm.dat'));
	start_time_build= cputime;
	model = svmtrain(label_vector, instance_matrix, ['-q -c ', num2str(bestC),'-g ', num2str(bestS)]);
	build_time(i+1) = cputime-start_time_build;
	start_time_test = cputime;
	[predict_label, TestingAccuracy, prob_estimates] = svmpredict(label_vector, instance_matrix, model);
	test_time(i+1) = cputime-start_time_test;
	acc_test(i+1) = TestingAccuracy(1);
end
fprintf('TESTING AVERAGE:\n');
fprintf(fr,'TESTING AVERAGE:\n');
fprintf('avg. acc.= %5.1f%% s = %g c = %g\n', mean(acc_test), bestS, bestC);
fprintf(fr,'avg. acc.= %5.1f%% s = %g c = %g\n', mean(acc_test), bestS, bestC);
fprintf('avg. time to build model = %.10f\n', mean(build_time));
fprintf(fr,'avg. time to build model = %.10f\n', mean(build_time));
fprintf('avg. time to test model = %.10f\n', mean(test_time));
fprintf(fr,'avg. time to test model = %.10f\n', mean(test_time));
fclose(fr);