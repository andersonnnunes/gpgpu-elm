close all; clearvars -except dataset n_trials lineup firstProblem lastProblem; clc;
addpath('..\shared\');
current_algo_name='gpgpu-elm';
nu_trials; datasets; parameters; openLogFile;
acc=zeros(nvalS, nvalC, n_trials);
validation_time=tic;
for i=0:n_trials-1
	fprintf(fr, 'trial %i --------------\n', i);
	trial_number=num2str(i);
	for j = 1:nvalS % PARAMETER TUNING for S
		if valS(j)>=npt*0.4
			fprintf(fr,'Skipping iteration to prevent over-fitting.\n');
			continue
		end
		for k = 1:nvalC % PARAMETER TUNING for C
			[TrainingTime, TestingTime, TrainingAccuracy, TestingAccuracy] = ELM(strcat('../../dataset/',name_problem,'/train/',trial_number,'-elm.dat'), strcat('../../dataset/',name_problem,'/validate/',trial_number,'-elm.dat'), 1, valS(j), valC{k});
			acc(j,k,i+1) = TrainingAccuracy.*100;
			fprintf(fr,'nHiddenNeurons = %g act. func. = %s acc= %5.1f%%\n', valS(j), valC{k}, acc(j,k,i+1));
		end
	end
end
ValidationTime=toc(validation_time);
fprintf(fr,'time to validate parameters = %.10f\n', ValidationTime);
avg_acc=mean(acc,3);
fprintf(fr,'VALIDATION AVERAGE:\n');
for j=1:nvalS
	for k=1:nvalC
		fprintf(fr,'nHiddenNeurons = %g act. func. = %s acc=%5.1f%%\n', valS(j), valC{k}, avg_acc(j,k));
	end
end
[best_acc imax] = max(max(avg_acc,[],2)); bestS = valS(imax); [best_acc imax] = max(max(avg_acc,[],1)); bestC = valC{imax};
fprintf(fr,'best_acc=%5.1f%% bestS= %g bestC= %s\n', best_acc, bestS, bestC);
fprintf(fr,'TEST TRIALS\n');
acc_test=zeros(1,n_trials); build_time=zeros(1,n_trials); test_time=zeros(1,n_trials);
for i=0:n_trials-1 % TESTING % Use o melhor parâmetro com a partição de teste.
	[TrainingTime, TestingTime, TrainingAccuracy, TestingAccuracy] = ELM(strcat('../../dataset/',name_problem,'/train/',trial_number,'-elm.dat'), strcat('../../dataset/',name_problem,'/test/',trial_number,'-elm.dat'), 1, bestS, bestC);
	acc_test(i+1) = TestingAccuracy.*100;
	build_time(i+1) = TrainingTime;
	test_time(i+1) = TestingTime;
end
printTime; closeLogFile;