%   * main.m
%   * Copyright (C) Manuel Fernandez Delgado 2013 <manuel.fernandez.delgado@usc.es>
%   *
%   *     This program is free software: you can redistribute it and/or modify
%   *     it under the terms of the GNU Lesser General Public License as published by
%   *     the Free Software Foundation, either version 3 of the License, or
%   *     (at your option) any later version.
%   *
%   *     This program is distributed in the hope that it will be useful,
%   *     but WITHOUT ANY WARRANTY; without even the implied warranty of
%   *     MERCHANPOILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
%   *     GNU Lesser General Public License for more details.
%   *
%   *     You should have received a copy of the GNU Lesser General Public License
%   *     along with this program.  If not, see <http://www.gnu.org/licenses/lgpl.html>.
%   *
clc;
clear all;
current_algo_name='dkp';
n_trials=10;
addpath('..\shared\');
valS = [3.05176e-05, 6.10352e-05, 0.00012207, 0.000244141, 0.000488281, 0.000976562, 0.00195312, 0.00390625, 0.0078125, 0.015625, 0.03125, 0.0625, 0.125, 0.25, 0.5, 1, 2, 4, 8];
nvalS = length(valS); % valS contém 19 valores.
acc=zeros(nvalS,n_trials);
datasets %%com esta linha, tudo que está no arquivo datasets.m é executado.
process_chosen_dataset

for i=1:n_trials % PARAMETER TUNING
	fprintf('trial %i --------------\n', i);
	fprintf(fr, 'trial %i --------------\n', i);
	load(sprintf('trial_%i.mat', i),'-mat')
	for j = 1:nvalS
		y = dkp(xt, dt, nc, xv, valS(j));
		acc(j,i) = 100*sum(y == dv)/npv;
		fprintf('s= %g acc= %5.1f%%\n', valS(j), acc(j,i));
		fprintf(fr,'s= %g acc= %5.1f%%\n', valS(j), acc(j,i));
	end
	clear('xt','dt','iv','xv','dv','is','xs','ds')
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

% TESTING
acc_test=zeros(1,n_trials); cm = zeros(nc);  % cm=confusion matrix
for i=1:n_trials
	load(sprintf('trial_%i.mat', i),'-mat')
	y = dkp(xt, dt, nc, xs, bestS);
	for j=1:nps
		k= ds(j); l= y(j); cm(k,l)= cm(k,l) + 1;
	end
	acc_test(i) = 100*sum(y == ds)/nps;
	clear('xt','dt','iv','xv','dv','is','xs','ds')
end
cm = cm/n_trials;
fprintf('avg. acc.= %5.1f%% spread= %g\n', mean(acc_test), bestS);
fprintf(fr,'avg. acc.= %5.1f%% spread= %g\ncm=\n', mean(acc_test), bestS);
fprintf(fr, '\t'); fprintf(fr, '%5i\t', 1:nc); fprintf(fr, '\n');
for i=1:nc
	fprintf(fr, '%i\t', i); fprintf(fr,'%5.1f\t',cm(i,:)); fprintf(fr,'\n');
end
fclose(fr);
for i=1:n_trials
	delete(sprintf('trial_%i.mat',i));
end