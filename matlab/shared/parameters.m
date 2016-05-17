switch current_algo_name
	case {'elm','gpgpu-elm'}
		if dataset == skin
			valS = [10:30:90 140:50:240];
		else
			valS = [10:30:100 150:125:650 800:200:1200];
		end
		valC = {'sig', 'sin', 'hardlim', 'tribas', 'radbas'};
		nvalS = length(valS);
		nvalC = length(valC);
	case {'dkp'}
		valS = pow2(-12:2:2);
		nvalS = length(valS);
	case {'svm'}
		valS = pow2(-12:2:2);
		valC = pow2(-4:2:12);
		nvalS = length(valS);
		nvalC = length(valC);
	otherwise
		error(['Unknown algorithm: ' num2str(action)])
end