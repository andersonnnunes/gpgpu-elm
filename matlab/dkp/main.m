clc;
clear all;
addpath('..\shared\');
current_algo_name='dkp';
n_trials = 2;
datasets; process_chosen_dataset;
valS = pow2(-15:1:2);
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
for i=1:n_trials % Descobra o melhor parâmetro, para isso, use a partição de validação.
	fprintf(fr, 'trial %i --------------\n', i);
	load(sprintf('trial_%i.mat', i),'-mat')
	for j = 1:nvalS % PARAMETER TUNING
		y = dkp(xt, dt, nc, xv, valS(j), 2);
		acc(j,i) = 100*sum(y == dv)/npv;
		fprintf(fr,'s= %g acc= %5.1f%%\n', valS(j), acc(j,i));
	end
	clear('xt','dt','iv','xv','dv','is','xs','ds')
end
ValidationTime=cputime-start_time_validation; % Calculate CPU time (seconds) spent for validation.
fprintf('time to validate parameters = %.10f\n', ValidationTime);
fprintf(fr,'time to validate parameters = %.10f\n', ValidationTime);
avg_acc=mean(acc,2);
fprintf(fr,'VALIDATION AVERAGE:\n');
for i=1:nvalS
	fprintf(fr,'s= %g acc=%5.1f%%\n', valS(i), avg_acc(i));
end
[best_acc, imax] = max(avg_acc); bestS = valS(imax);
fprintf('best_acc=%5.1f%% bestS= %g\n', best_acc, bestS);
fprintf(fr,'best_acc=%5.1f%% bestS= %g\n', best_acc, bestS);

fprintf('TEST TRIALS\n'); % Use o melhor parâmetro com a partição de teste.
fprintf(fr,'TEST TRIALS\n');
acc_test=zeros(1,n_trials); build_time=zeros(1,n_trials); test_time=zeros(1,n_trials); cm = zeros(nc);  % cm=confusion matrix
for i=1:n_trials
	start_time_build= cputime;
	load(sprintf('trial_%i.mat', i),'-mat')
	build_time(i+1) = cputime-start_time_build;
	start_time_test = cputime;
	y = dkp(xt, dt, nc, xs, bestS, 2);
	test_time(i+1) = cputime-start_time_test;
	for j=1:nps
		k= ds(j); l= y(j); cm(k,l)= cm(k,l) + 1;
	end
	acc_test(i) = 100*sum(y == ds)/nps;
	clear('xt','dt','iv','xv','dv','is','xs','ds')
end
fprintf('TESTING AVERAGE:\n');
fprintf(fr,'TESTING AVERAGE:\n');
cm = cm/n_trials;
fprintf('avg. acc.= %5.1f%% spread= %g\n', mean(acc_test), bestS);
fprintf(fr,'avg. acc.= %5.1f%% spread= %g\ncm=\n', mean(acc_test), bestS);
fprintf('avg. time to build model = %.10f\n', mean(build_time));
fprintf(fr,'avg. time to build model = %.10f\n', mean(build_time));
fprintf('avg. time to test model = %.10f\n', mean(test_time));
fprintf(fr,'avg. time to test model = %.10f\n', mean(test_time));
fprintf(fr, '\t'); fprintf(fr, '%5i\t', 1:nc); fprintf(fr, '\n');
for i=1:nc
	fprintf(fr, '%i\t', i); fprintf(fr,'%5.1f\t',cm(i,:)); fprintf(fr,'\n');
end
fclose(fr);
for i=1:n_trials
	delete(sprintf('trial_%i.mat',i));
end