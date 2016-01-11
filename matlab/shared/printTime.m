f_speed=fopen(f_speedTrainResults, 'w');
if -1==f_speed
	error('error opening %s', f_speedTrainResults)
end
dlmwrite(f_speedTrainResults,build_time,'\n');
fclose(f_speed);
f_speed=fopen(f_speedTestResults, 'w');
if -1==f_speed
	error('error opening %s', f_speedTestResults)
end
dlmwrite(f_speedTestResults,test_time,'\n');
fclose(f_speed);