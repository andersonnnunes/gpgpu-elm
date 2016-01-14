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

honeybee_pollen = 1;
bank = 2;
skin = 3;
gas_sensor = 4;
if exist('dataset', 'var') ~= 1
	dataset = 4;
end

if dataset == honeybee_pollen
	name_problem = 'honeybee_pollen';
	ni = 70;
	nc = 5;
	np = 2600;
	npt = 1300;
	npv = 650;
	nps = 650;
elseif dataset == bank
	name_problem = 'bank';
	ni = 53;
	nc = 2;
	np = 41188;
	npt = 20594;
	npv = 10297;
	nps = 10297;
elseif dataset == skin
	name_problem = 'skin';
	ni = 3;
	nc = 2;
	np = 245057;
	npt= 122529;
	npv= 61264;
	nps = 61264;
elseif dataset == gas_sensor
	name_problem = 'gas_sensor';
	ni = 128;
	nc = 6;
	np = 13910;
	npt= 6955;
	npv= 3478;
	nps = 3477;
end
dir = strcat('../../dataset/',name_problem,'/');
f_data = strcat(dir,name_problem,'.dat');
f_part = strcat(dir,'partitions.dat');
f_results = strcat('../../results/',current_algo_name,'/',name_problem,'.log');
f_speedTrainResults = strcat('../../results/speedup/',current_algo_name,'/',name_problem,'-train.log');
f_speedTestResults = strcat('../../results/speedup/',current_algo_name,'/',name_problem,'-test.log');
f_allResults = strcat('../../results/runAll/runAll.log');