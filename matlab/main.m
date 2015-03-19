clc;
brandy= 1;
scab= 2;
pollen_grains= 3;
oocytes_nucleus= 4;
oocytes_states= 5;
honeybee_pollen= 6;

dataset=1;

if dataset == brandy
	name_problem='brandy';   % DATA SET brandy
	ni= 8;
	nc= 2;
	np= 115;  % no. total patterns
	npt= 57;  % no. training patterns
	npv= 30;  % no. validation patterns
	nps= 29;  % no. test patterns
	dir ='datasets/brandy/';
	f_data =strcat(dir,'brandy.dat');
	f_part =strcat(dir,'partitions.dat');
	f_results ='results_brandy.dat';
elseif dataset == scab
	name_problem ='scab';  % DATA SET scab
	ni =256;
	nc =2;
	np =126;
	npt =62;
	npv =32;
	nps =33;
	dir ='datasets/scab/';
	f_data =strcat(dir,'scab.dat');
	f_part =strcat(dir,'partitions.dat');
	f_results ='results_scab.dat';
elseif dataset == pollen_grains
	name_problem ='pollen_grains';  % DATA SET pollen_grains
	ni =23;
	nc =3;
	np =291;
	npt =145;
	npv =74;
	nps =73;
	dir ='datasets/pollen_grains/';
	f_data =strcat(dir,'pollen_grains.dat');
	f_part =strcat(dir,'partitions.dat');
	f_results ='results_pollen_grains.dat';
elseif dataset == oocytes_nucleus
	name_problem ='oocytes_nucleus';  % DATA SET oocytes_nucleus
	ni =21;
	nc =2;
	np =1023;
	npt =511;
	npv =257;
	nps =256;
	dir ='datasets/oocytes_nucleus/';
	f_data =strcat(dir,'oocytes_nucleus.dat');
	f_part =strcat(dir,'partitions.dat');
	f_results ='results_oocytes_nucleus.dat';
elseif dataset == oocytes_states
	name_problem ='oocytes_states';  % DATA SET oocytes_states
	ni =21;
	np =1023;
	nc =3;
	npt =511;
	npv =257;
	nps =256;
	dir ='datasets/oocytes_states/';
	f_data =strcat(dir,'oocytes_states.dat');
	f_part =strcat(dir,'partitions.dat');
	f_results ='results_oocytes_states.dat';
elseif dataset == honeybee_pollen
	name_problem = 'honeybee_pollen';  % DATA SET honeybee_pollen
	ni =70;
	nc =5;
	np =2600;
	npt= 1299;
	npv= 652;
	nps =650;
	dir= 'datasets/honeybee_pollen/';
	f_data =strcat(dir,'honeybee_pollen.dat');
	f_part =strcat(dir,'partitions.dat');
	f_results ='results_honeybee_pollen.dat';
end

nHiddenNeurons=50;
N0=npt;
Block=0;

caminho=strcat('datasets/',name_problem,'/',name_problem);
n_trials=10;
f_results =strcat(caminho,'_results');
fr=fopen(f_results, 'w'); %abre o arquivo de resultados para escrita
	if -1==fr
	error('error opening %s', f_results)
end
fprintf(fr,'%s\n',name_problem);
% close the file 
fclose(fr);
for i=1:n_trials
	test_number=num2str(i);
	[TrainingTime, TestingTime, TrainingAccuracy, TestingAccuracy] = OSELM(strcat(caminho,'_train',test_number), strcat(caminho,'_test',test_number), 1, nHiddenNeurons, 'hardlim', N0, Block);
	f_results =strcat(caminho,'_results');
	fr=fopen(f_results, 'a'); %abre o arquivo de resultados para escrita
	if -1==fr
		error('error opening %s', f_results)
	end
	fprintf(fr,'A acuracia para a colecao %s e %1.8f\n',test_number,TestingAccuracy);
	fprintf('A acurácia para a Coleção %s e %1.8f\n',test_number,TestingAccuracy);
end
% close the file 
fclose(fr);
