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

dataset = 1;

if dataset == honeybee_pollen
	name_problem = 'honeybee_pollen';
	ni = 70;
	nc = 5;
	np = 2600;
	npt = 1300;
	npv = 650;
	nps = 650;
	dir = '../../dataset/honeybee_pollen/'; % nome do diretório que armazena o dataset.
	f_data = strcat(dir,'honeybee_pollen.dat'); % caminho completo para o arquivo principal do dataset.
	f_part = strcat(dir,'partitions.dat'); % caminho completo para o arquivo auxiliar do dataset.
	f_results = strcat('../../results/',current_algo_name,'/',name_problem,'.txt');
elseif dataset == bank
	name_problem = 'bank';
	ni = 53;
	nc = 2;
	np = 41188;
	npt= 20594; %round(np*0.5);
	npv= 10296; %round(np*0.25);
	nps = 10297;
	dir= '../../dataset/bank/'; % nome do diretório que armazena o dataset.
	f_data =strcat(dir,'bank-additional-full.dat'); % caminho completo para o arquivo principal do dataset.
	f_part =strcat(dir,'partitions.dat'); % caminho completo para o arquivo auxiliar do dataset.
	f_results=strcat('../../results/',current_algo_name,'/',name_problem,'.txt');
end

% Example of format for dataset description
% honeybee_pollen= 6;

% dataset=honeybee_pollen;

% if dataset == honeybee_pollen
	% name_problem = 'honeybee_pollen';  % nome do problema, pode ser qualquer nome, usado apenas para ler/escrever arquivos.
	% ni =70; % número de colunas.
	% nc =5; % número de classes.
	% np =2600; % número de instâncias.
	% npt= 1300; % número de instâncias para treinamento.
	% npv= 650; % número de instâncias para validação.
	% nps =650; % número de instâncias para testes.
	% dir= 'datasets/honeybee_pollen/'; % nome do diretório que armazena o dataset.
	% f_data =strcat(dir,'honeybee_pollen.dat'); % caminho completo para o arquivo principal do dataset.
	% f_part =strcat(dir,'partitions.dat'); % caminho completo para o arquivo auxiliar do dataset.
	% f_results ='results_honeybee_pollen.dat'; % caminho completo para o arquivo que armazenará os resultados.
% end