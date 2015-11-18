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
	f_results=strcat('../dataset/',name_problem,'/','elm_results.txt');
end

nHiddenNeurons=400;
N0=npt;
Block=0;
n_trials=10;

for i=0:n_trials-1
	test_number=num2str(i);
	[TrainingTime, TestingTime, TrainingAccuracy, TestingAccuracy] = OSELM(strcat('../dataset/',name_problem,'/train/',test_number,'-elm.dat'), strcat('../dataset/',name_problem,'/test/',test_number,'-elm.dat'), nHiddenNeurons, 'hardlim', N0, Block);
	fr=fopen(f_results, 'a');
	if -1==fr
		error('error opening %s', f_results)
	end
	fprintf('Conjunto %s - Taxa de acerto nos teste foi de %1.8f\n',test_number,TestingAccuracy);
	fprintf('Conjunto %s - Tempo de treinamento foi de %f\n', test_number, TrainingTime);
	fprintf('Conjunto %s - Tempo de teste foi de %f\n', test_number, TestingTime);
	fclose(fr);	
end
