fprintf(fr,'FINAL RESULTS:\n');
fprintf(fr,'avg. acc. (0-100 scale) | std | avg. time to build model | std | avg. time to test model | std | time spent on validation\n');
nf = java.text.DecimalFormat;
nf.setMaximumFractionDigits(7);
fprintf(fr,'%s\t%s\t%s\t%s\t%s\t%s\t%s\n', char(nf.format(mean(acc_test))), char(nf.format(std(acc_test))), char(nf.format(mean(build_time))), char(nf.format(std(build_time))), char(nf.format(mean(test_time))), char(nf.format(std(test_time))), char(nf.format(ValidationTime)));
fclose(fr);
fr=fopen(f_allResults, 'a');
if -1==fr
	error('error opening %s', f_allResults)
end
fprintf(fr,'%s\t%s\t%s\t%s\t%s\t%s\t%s\n', char(nf.format(mean(acc_test))), char(nf.format(std(acc_test))), char(nf.format(mean(build_time))), char(nf.format(std(build_time))), char(nf.format(mean(test_time))), char(nf.format(std(test_time))), char(nf.format(ValidationTime)));
fclose(fr);