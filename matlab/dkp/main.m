close all; clearvars -except dataset n_trials lineup firstProblem lastProblem; clc;
addpath('..\shared\');
current_algo_name='dkp';
nu_trials; datasets; process_chosen_dataset; parameters; openLogFile;
acc=zeros(nvalS,n_trials);
start_time_validation=tic;
for i=1:n_trials % Descubra o melhor parâmetro, para isso, use a partição de validação.
	fprintf(fr, 'trial %i --------------\n', i-1);
	load(sprintf('trial_%i.mat', i),'-mat')
	for j = 1:nvalS % PARAMETER TUNING
		y = dkp(xt, dt, nc, xv, valS(j), 1);
		acc(j,i) = 100*sum(y == dv)/npv;
		fprintf(fr,'s= %g acc= %5.1f%%\n', valS(j), acc(j,i));
	end
	clear('xt','dt','iv','xv','dv','is','xs','ds')
end
ValidationTime=toc(start_time_validation); % Calculate CPU time (seconds) spent for validation.
fprintf(fr,'time to validate parameters = %.10f\n', ValidationTime);
avg_acc=mean(acc,2);
fprintf(fr,'VALIDATION AVERAGE:\n');
for i=1:nvalS
	fprintf(fr,'s= %g acc=%5.1f%%\n', valS(i), avg_acc(i));
end
[best_acc, imax] = max(avg_acc); bestS = valS(imax);
fprintf(fr,'best_acc=%5.1f%% bestS= %g\n', best_acc, bestS);
fprintf(fr,'TEST TRIALS\n');
acc_test=zeros(1,n_trials); build_time=zeros(1,n_trials); test_time=zeros(1,n_trials); cm = zeros(nc);  % cm=confusion matrix
for i=1:n_trials % Use o melhor parâmetro com a partição de teste.
	start_time_build = tic;
	load(sprintf('trial_%i.mat', i),'-mat')
	build_time(i+1) = toc(start_time_build);
	start_time_test = tic;
	y = dkp(xt, dt, nc, xs, bestS, 1);
	test_time(i+1) = toc(start_time_test);
	for j=1:nps
		k= ds(j); l= y(j); cm(k,l)= cm(k,l) + 1;
	end
	acc_test(i) = 100*sum(y == ds)/nps;
	clear('xt','dt','iv','xv','dv','is','xs','ds')
end
closeLogFile;
% cm = cm/n_trials;
% fprintf(fr, '\t'); fprintf(fr, '%5i\t', 1:nc); fprintf(fr, '\n');
% for i=1:nc
	% fprintf(fr, '%i\t', i); fprintf(fr,'%5.1f\t',cm(i,:)); fprintf(fr,'\n');
% end
for i=1:n_trials
	delete(sprintf('trial_%i.mat',i));
end