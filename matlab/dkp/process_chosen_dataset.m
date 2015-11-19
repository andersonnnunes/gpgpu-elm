%   * process_chosen_dataset.m
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

x = zeros(np, ni); d = zeros(np);

% read patterns and classes %aqui tenta-se abrir o arquivo principal
f=fopen(f_data,'r');
if -1==f
	error('error opening %s', f_data)
end

fscanf(f,'%s',ni+1); %aqui tenta-se descobrir se cada instância tem o número correto de atributos.
for i=1:np
	fscanf(f,'%i',1);
	x(i,:) = fscanf(f,'%g', ni); % aqui tenta-se validar o número de atributos.
	d(i) = 1 + fscanf(f, '%i', 1);  % inputs must be in the range 1..nc % aqui tenta validar o número de classes.
end
fclose(f);

% read training/validation/test partitions
% aqui criam-se vetores vazios com 10 linhas que serão usados na próxima etapa. notea: n_trials está definida no main.
it=zeros(n_trials,npt); 
iv=zeros(n_trials,npv);
is=zeros(n_trials,nps);

f=fopen(f_part,'r'); % Abra o arquivo onde as partições estão determinadas
if -1==f
	error('error opening %s', f_part)
end
for i=1:n_trials %Coloque nos vetores de 10 linhas os ids contidos nas linhas do partition.dat
	% it(i,:)= 1 + fscanf(f,'%i',npt);
	% iv(i,:)= 1 + fscanf(f,'%i',npv);
	% is(i,:)= 1 + fscanf(f,'%i',nps);
	it(i,:)= fscanf(f,'%i',npt);
	iv(i,:)= fscanf(f,'%i',npv);
	is(i,:)= fscanf(f,'%i',nps);
end
fclose(f); %validação do arquivo de partições concluída com sucesso. feche o arquivo.
% crie matrizes para guardar as instâncias e seus atributos. crie matrizes para ??.
xt = zeros(npt,ni); dt=zeros(1,npt);
xv = zeros(npv,ni); dv=zeros(1,npv);
xs = zeros(nps,ni); ds=zeros(1,nps);
for i=1:n_trials
	u=it(i,:);  % training patterns %jogue na matriz U a linha i da matriz it. u tem vários ids originários do partition.dat.
	xt = x(u,:);  % training patterns %mova de x para xt as linhas especificadas por u.
	dt = d(u);  % training patterns
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