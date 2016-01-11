fprintf(fr,'FINAL RESULTS:\n');
fprintf(fr,'avg. acc. (0-100 scale) | avg. time to build model | avg. time to test model | time spent on validation\n');
nf = java.text.DecimalFormat;
nf.setMaximumFractionDigits(5);
fprintf(fr,'%s\t%s\t%s\t%s\n', char(nf.format(mean(acc_test))), char(nf.format(mean(build_time))), char(nf.format(mean(test_time))), char(nf.format(ValidationTime)));
fclose(fr);
fr=fopen(f_allResults, 'a');
if -1==fr
	error('error opening %s', f_allResults)
end
fprintf(fr,'%s\t%s\t%s\t%s\n', char(nf.format(mean(acc_test))), char(nf.format(mean(build_time))), char(nf.format(mean(test_time))), char(nf.format(ValidationTime)));
fclose(fr);