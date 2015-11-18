%   * datasets.m
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

brandy= 1;
scab= 2;
pollen_grains= 3;
oocytes_nucleus= 4;
oocytes_states= 5;
honeybee_pollen= 6;

dataset=honeybee_pollen;

if dataset == brandy
	name_problem='brandy';   % DATA SET brandy
	ni= 8;
	nc= 2;
	np= 115;  % no. total patterns
	npt= 57;  % no. training patterns
	npv= 29;  % no. validation patterns
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
	npt =64;
	npv =31;
	nps =31;
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
	npv =73;
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
	npt =818;
	npv =102;
	nps =103;
	dir ='datasets/oocytes_nucleus/';
	f_data =strcat(dir,'oocytes_nucleus.dat');
	f_part =strcat(dir,'partitions.dat');
	f_results ='results_oocytes_nucleus.dat';
elseif dataset == oocytes_states
	name_problem ='oocytes_states';  % DATA SET oocytes_states
	ni =21;
	np =1023;
	nc =3;
	npt =818;
	npv =102;
	nps =103;
	dir ='datasets/oocytes_states/';
	f_data =strcat(dir,'oocytes_states.dat');
	f_part =strcat(dir,'partitions.dat');
	f_results ='results_oocytes_states.dat';
elseif dataset == honeybee_pollen
	name_problem = 'honeybee_pollen';  % DATA SET honeybee_pollen
	ni =70;
	nc =5;
	np =2600;
	npt= 1300;
	npv= 650;
	nps =650;
	dir= 'datasets/honeybee_pollen/';
	f_data =strcat(dir,'honeybee_pollen.dat');
	f_part =strcat(dir,'partitions.dat');
	f_results ='results_honeybee_pollen.dat';
end

x = zeros(np, ni); d = zeros(np);

% read patterns and classes %aqui tenta-se abrir o arquivo
f=fopen(f_data,'r');
if -1==f
    error('error opening %s', f_data)
end
%aqui tenta-se descobrir se cada instância tem o número correto de
%variáveis
fscanf(f,'%s',ni+1);
for i=1:np
    fscanf(f,'%i',1);
    x(i,:) = fscanf(f,'%g', ni);
    d(i) = 1 + fscanf(f, '%i', 1);  % inputs must be in the range 1..nc
end
fclose(f);

% read training/validation/test partitions
it=zeros(n_trials,npt); %n_trials está definida no main
iv=zeros(n_trials,npv);
is=zeros(n_trials,nps);

f=fopen(f_part,'r'); %abra o arquivo onde as partições estão determinadas
if -1==f
    error('error opening %s', f_part)
end
for i=1:n_trials
    it(i,:)= 1 + fscanf(f,'%i',npt);
    iv(i,:)= 1 + fscanf(f,'%i',npv);
    is(i,:)= 1 + fscanf(f,'%i',nps);
end
fclose(f);

xt = zeros(npt,ni); dt=zeros(1,npt);
xv = zeros(npv,ni); dv=zeros(1,npv);
xs = zeros(nps,ni); ds=zeros(1,nps);
for i=1:n_trials
    u=it(i,:); xt = x(u,:); dt = d(u);  % training patterns
    u=iv(i,:); xv = x(u,:); dv = d(u);  % validation patterns
    u=is(i,:); xs = x(u,:); ds = d(u);  % test patterns

    avg = mean(xt); desv = std(xt);  % preprocessing: zero mean, std one
    for j=1:ni
        if desv(j)~=0
            xt(:,j) = (xt(:,j) - avg(j))/desv(j);
            xv(:,j) = (xv(:,j) - avg(j))/desv(j);            
            xs(:,j) = (xs(:,j) - avg(j))/desv(j);
        end
    end
    for j=1:npt  % normalization
        xt(j,:) = xt(j,:)/norm(xt(j,:));
    end
    for j=1:npv
        xv(j,:) = xv(j,:)/norm(xv(j,:));
    end
    for j=1:nps
        xs(j,:) = xs(j,:)/norm(xs(j,:));
    end
    save(sprintf('trial_%i.mat', i), 'xt', 'dt', 'xv', 'dv', 'xs', 'ds')
end
clear('x','it','xt','dt','iv','xv','dv','is','xs','ds')

fr=fopen(f_results, 'w'); %abre o arquivo de resultados para escrita
if -1==fr
    error('error opening %s', f_results)
end