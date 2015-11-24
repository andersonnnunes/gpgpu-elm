switch current_algo_name
	case {'elm','gpgpu-elm'}
		valS = [10:30:100 150:125:650 800:200:1200];
		valC = {'sig', 'sin', 'hardlim', 'tribas', 'radbas'};
		nvalS = length(valS);
		nvalC = length(valC);
	case {'dkp'}
		valS = pow2(-15:1:2);
		nvalS = length(valS);
	case {'svm'}
		valS = pow2(-15:1:2);
		valC = pow2(-5:1:14);
		nvalS = length(valS);
		nvalC = length(valC);
	otherwise
		error(['Unknown algorithm: ' num2str(action)])
end