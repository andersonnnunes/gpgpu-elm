clc;
honeybee_pollen= 1;

dataset=1;

if dataset == honeybee_pollen
	name_problem = 'honeybee_pollen';  % DATA SET honeybee_pollen
	ni =70;
	nc =5;
	np =2600;
	npt= 1299;
	npv= 652;
	nps =650;
	f_results=strcat('../../results/elm/',name_problem,'.txt');
end

nHiddenNeurons=200;
N0=npt;
Block=0;
n_trials=10;

fr=fopen(f_results, 'w');
if -1==fr
	error('error opening %s', f_results)
end
fclose(fr);
for i=0:n_trials-1
	test_number=num2str(i);
% 	[TrainingTime, TestingTime, TrainingAccuracy, TestingAccuracy] = OSELM(strcat('../../dataset/',name_problem,'/train/',test_number,'-elm.dat'), strcat('../../dataset/',name_problem,'/test/',test_number,'-elm.dat'), nHiddenNeurons, 'hardlim', N0, Block);
	[TrainingTime, TestingTime, TrainingAccuracy, TestingAccuracy] = ELM(strcat('../../dataset/',name_problem,'/train/',test_number,'-elm.dat'), strcat('../../dataset/',name_problem,'/test/',test_number,'-elm.dat'), 1, nHiddenNeurons, 'hardlim');
	fr=fopen(f_results, 'a');
	if -1==fr
		error('error opening %s', f_results)
	end
	fprintf('trial %i --------------\n', i);
	fprintf(fr, 'trial %i --------------\n', i);
	fprintf(fr,'Train acc=%5.1f%%\n', TrainingAccuracy.*100);
	fprintf(fr,'Test acc=%5.1f%%\n', TestingAccuracy.*100);
	fprintf(fr,'Train time s= %.10f\n', TrainingTime);
	fprintf(fr,'Test time s= %.10f\n', TestingTime);
	fclose(fr);
end
