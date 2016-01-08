close all; clearvars -except dataset; clc;
addpath('..\shared\');
current_algo_name='svm';
nu_trials; datasets; parameters;
fr=fopen(f_results, 'w');
if -1==fr
	error('error opening %s', f_results)
end
fprintf(fr,['Execution date: ',date,' ',datestr(now, 'HH:MM:SS'),'\n']);
acc=zeros(nvalS, nvalC, n_trials);
fprintf(fr,'VALIDATION TRIALS\n');
start_time_validation=tic;
for i=0:n_trials-1
	fprintf(fr, 'trial %i --------------\n', i);
	trial_number=num2str(i);
	[label_vector, instance_matrix] = libsvmread(strcat('../../dataset/',name_problem,'/train/',trial_number,'-svm.dat'));
	for j = 1:nvalS % PARAMETER TUNING for S
		for k = 1:nvalC % PARAMETER TUNING for C
			model = svmtrain(label_vector, instance_matrix, ['-q -c ', num2str(valC(k)),'-g ', num2str(valS(j))]);
			[label_vector, instance_matrix] = libsvmread(strcat('../../dataset/',name_problem,'/validate/',trial_number,'-svm.dat'));
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
	[label_vector, instance_matrix] = libsvmread(strcat('../../dataset/',name_problem,'/train/',trial_number,'-svm.dat'));
	start_time_build = tic;
	model = svmtrain(label_vector, instance_matrix, ['-q -c ', num2str(bestC),'-g ', num2str(bestS)]);
	build_time(i+1) = toc(start_time_build);
	start_time_test = tic;
	[predict_label, TestingAccuracy, prob_estimates] = svmpredict(label_vector, instance_matrix, model, '-q');
	test_time(i+1) = toc(start_time_test);
	acc_test(i+1) = TestingAccuracy(1);
end
fprintf(fr,'FINAL RESULTS:\n');
fprintf(fr,'avg. acc. (0-100 scale) | avg. time to build model | avg. time to test model\n');
nf = java.text.DecimalFormat;
nf.setMaximumFractionDigits(5)
fprintf(fr,'%s\t%s\t%s\n', char(nf.format(mean(acc_test))), char(nf.format(mean(build_time))), char(nf.format(mean(test_time))));
fclose(fr);
fr=fopen(f_allResults, 'a');
if -1==fr
	error('error opening log file')
end
fprintf(fr,'%s\t%s\t%s\n', char(nf.format(mean(acc_test))), char(nf.format(mean(build_time))), char(nf.format(mean(test_time))));
fclose(fr);