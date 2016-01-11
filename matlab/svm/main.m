close all; clearvars -except dataset n_trials lineup firstProblem lastProblem; clc;
addpath('..\shared\');
current_algo_name='svm';
nu_trials; datasets; parameters; openLogFile;
acc=zeros(nvalS, nvalC, n_trials);
start_time_validation=tic;
for i=0:n_trials-1
	fprintf(fr, 'trial %i --------------\n', i);
	[label_vector, instance_matrix] = libsvmread(strcat('../../dataset/',name_problem,'/train/',num2str(i),'-svm.dat'));
	for j = 1:nvalS % PARAMETER TUNING for S
		for k = 1:nvalC % PARAMETER TUNING for C
			model = svmtrain(label_vector, instance_matrix, ['-q -c ', num2str(valC(k)),'-g ', num2str(valS(j))]);
			[label_vector, instance_matrix] = libsvmread(strcat('../../dataset/',name_problem,'/validate/',num2str(i),'-svm.dat'));
			[predict_label, ValidationAccuracy, prob_estimates] = svmpredict(label_vector, instance_matrix, model, '-q');
			acc(j,k,i+1) = ValidationAccuracy(1);
			fprintf(fr,'s = %g c= %g acc= %5.1f%%\n', valS(j), valC(k), acc(j,k,i+1));
		end
	end
end
ValidationTime=toc(start_time_validation);
fprintf(fr,'time to validate parameters = %.10f\n', ValidationTime);
avg_acc=mean(acc,3);
fprintf(fr,'VALIDATION AVERAGE:\n');
for j=1:nvalS
	for k=1:nvalC
		fprintf(fr,'s = c = %g %g acc=%5.1f%%\n', valS(j), valC(k), avg_acc(j,k));
	end
end
[best_acc imax] = max(max(avg_acc,[],2)); bestS = valS(imax); [best_acc imax] = max(max(avg_acc,[],1)); bestC = valC(imax);
fprintf(fr,'best_acc=%5.1f%% bestS= %g bestC= %g\n', best_acc, bestS, bestC);
fprintf(fr,'TEST TRIALS\n');
acc_test=zeros(1,n_trials); build_time=zeros(1,n_trials); test_time=zeros(1,n_trials);
for i=0:n_trials-1 % TESTING % Use os melhores parâmetros com a partição de teste.
	[label_vector, instance_matrix] = libsvmread(strcat('../../dataset/',name_problem,'/train/',num2str(i),'-svm.dat'));
	start_time_build = tic;
	model = svmtrain(label_vector, instance_matrix, ['-q -c ', num2str(bestC),'-g ', num2str(bestS)]);
	build_time(i+1) = toc(start_time_build);
	start_time_test = tic;
	[predict_label, TestingAccuracy, prob_estimates] = svmpredict(label_vector, instance_matrix, model, '-q');
	test_time(i+1) = toc(start_time_test);
	acc_test(i+1) = TestingAccuracy(1);
end
closeLogFile;