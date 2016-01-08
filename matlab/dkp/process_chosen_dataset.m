x = zeros(np, ni); d = zeros(np, ni);

f=fopen(f_data,'r'); % tente abrir o arquivo principal
if -1==f
	error('error opening %s', f_data)
end

fscanf(f,'%s',ni+1); % descarte a primeira linha
for i=1:np % para o número total de instâncias, faça:
	fscanf(f,'%u',1); % descarte a primeira coluna
	x(i,:) = fscanf(f,'%g', ni); % copie os atributos da instância
	d(i) = 1 + fscanf(f, '%u', 1);  % copie a classe da instância
end
fclose(f);

% read training/validation/test partitions
% aqui criam-se vetores vazios que serão usados na próxima etapa. n_trials está definida no main
it=zeros(n_trials,npt); 
iv=zeros(n_trials,npv);
is=zeros(n_trials,nps);

f=fopen(f_part,'r'); % abra o arquivo onde as partições estão determinadas
if -1==f
	error('error opening %s', f_part)
end
for i=1:n_trials % coloque nos vetores os ids contidos nas linhas do partition.dat
	it(i,:)= fscanf(f,'%u',npt);
	iv(i,:)= fscanf(f,'%u',npv);
	is(i,:)= fscanf(f,'%u',nps);
% 	it(i,:)= 1 + fscanf(f,'%i',npt);
% 	iv(i,:)= 1 + fscanf(f,'%i',npv);
% 	is(i,:)= 1 + fscanf(f,'%i',nps);
end
fclose(f); %validação do arquivo de partições concluída com sucesso. feche o arquivo.
% crie matrizes para guardar as instâncias e seus atributos. crie matrizes para ??.
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