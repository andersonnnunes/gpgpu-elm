fr=fopen(f_results, 'w');
if -1==fr
	error('error opening %s', f_results)
end
fprintf(fr,['Execution date: ',date,' ',datestr(now, 'HH:MM:SS'),'\n']);
fprintf(fr,'VALIDATION TRIALS\n');