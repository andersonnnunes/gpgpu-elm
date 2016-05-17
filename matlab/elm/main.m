close all; clearvars -except dataset n_trials lineup firstProblem lastProblem; clc;
addpath('..\shared\');
current_algo_name='elm';
nu_trials; datasets; parameters; openLogFile;
acc=zeros(nvalS, nvalC, n_trials);
validation_time=tic;
for i=0:n_trials-1
	fprintf(fr, 'trial %i --------------\n', i);
	for j = 1:nvalS % PARAMETER TUNING for S
		if valS(j)>=npt*0.4
			fprintf(fr,'Skipping iteration to prevent over-fitting.\n');
			continue
		end
		for k = 1:nvalC % PARAMETER TUNING for C
			[TrainingTime, TestingTime, TrainingAccuracy, TestingAccuracy] = ELM(strcat('../../dataset/',name_problem,'/train/',num2str(i),'-elm.dat'), strcat('../../dataset/',name_problem,'/validate/',num2str(i),'-elm.dat'), 1, valS(j), valC{k});
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
n_testTrials = n_trials*4; acc_test=zeros(1,n_testTrials); build_time=zeros(1,n_testTrials); test_time=zeros(1,n_testTrials);
for i=0:n_testTrials-1 % TESTING. Use o melhor parâmetro com a partição de teste.
	[TrainingTime, TestingTime, TrainingAccuracy, TestingAccuracy] = ELM(strcat('../../dataset/',name_problem,'/train/',num2str(mod(i,10)),'-elm.dat'), strcat('../../dataset/',name_problem,'/test/',num2str(mod(i,10)),'-elm.dat'), 1, bestS, bestC);
	acc_test(i+1) = TestingAccuracy.*100;
	build_time(i+1) = TrainingTime;
	test_time(i+1) = TestingTime;
end
printTime; closeLogFile;