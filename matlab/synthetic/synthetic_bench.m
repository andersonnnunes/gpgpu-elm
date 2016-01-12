%{
Benchmarking pinv(A') * b' on the GPU
 Copyright 2010-2013 The MathWorks, Inc.
 Copyright 2015 Anderson Nascimento Nunes 
%}

function results = synthetic_bench()
set(0,'DefaultFigureVisible','off');
set(0,'DefaultAxesFontName', 'Times New Roman');
newFontSize = 12;
% The Benchmarking Function
% We want to benchmark pinv(A') * b', and not the cost of
% transferring data between the CPU and GPU, the time it takes to create a
% matrix, or other parameters.  We therefore separate the data generation
% from the solving of the linear system, and measure only the time it
% takes to do the latter.
function [A, b] = getData(n, clz)
	fprintf('Creating a matrix of size %d-by-%d.\n', n, n/s_dim);
	A = rand(n, n/s_dim, clz);
	b = rand(n, n/s_dim, clz);
end

function time = timeSolve(A, b, waitFcn, testCPU)
	tic;
	if testCPU==1
		x = pinv(A') * b'; %#ok<NASGU> We don't need the value of x.
	else
		x = pinv(pagefun(@ctranspose, A)) * pagefun(@ctranspose, b); %#ok<NASGU> We don't need the value of x.
	end
	waitFcn(); % Wait for operation to complete.
	time = toc;
end

% Choosing Problem Size
% As with a great number of other parallel algorithms, the performance of
% solving a linear system in parallel depends greatly on the matrix size.
% We compare the performance of the algorithm for different matrix sizes.

% Declare the matrix sizes to be a multiple of 1024.
maxSizeSingle = 1024*16;
maxSizeDouble = maxSizeSingle/2;
s_dim = 64;
step = 1024;
if maxSizeDouble/step >= 10
	step = step*floor(maxSizeDouble/(5*step));
end
sizeSingle = 1024:step:maxSizeSingle;
sizeDouble = 1024:step:maxSizeDouble;

% Comparing Performance: Time 
function time = benchFcn(A, b, waitFcn, testCPU)
	numReps = 10;
	time = inf;
	% We solve the linear system a few times and calculate the time spent
	for itr = 1:numReps
		tcurr = timeSolve(A, b, waitFcn, testCPU);
		time = min(tcurr, time);
	end
	
	% Measure the overhead introduced by calling the wait function.
	tover = inf;
	for itr = 1:numReps
		tic;
		waitFcn();
		tcurr = toc;
		tover = min(tcurr, tover);
	end
	% Remove the overhead from the measured time. Don't allow the time to
	% become negative.
	time = max(time - tover, 0);
end

% The CPU doesn't need to wait: this function handle is a placeholder.
function waitForCpu()
end

% On the GPU, to ensure accurate timing, we need to wait for the device
% to finish all pending operations.
function waitForGpu(theDevice)
	wait(theDevice);
end

% Executing the Benchmarks
% Having done all the setup, it is straightforward to execute the
% benchmarks.  However, the computations can take a long time to complete,
% so we print some intermediate status information as we complete the
% benchmarking for each matrix size.  We also encapsulate the loop over
% all the matrix sizes in a function, to benchmark both single- and 
% double-precision computations.
function [gflopsCPU, gflopsGPU] = executeBenchmarks(clz, sizes)
	fprintf(['Starting benchmarks with %d different %s-precision ' ...
		 'matrices of sizes\nranging from %d-by-%d to %d-by-%d.\n'], ...
			length(sizes), clz, sizes(1), sizes(1)/s_dim, sizes(end), ...
			sizes(end)/s_dim);
	gflopsGPU = zeros(size(sizes));
	gflopsCPU = zeros(size(sizes));
	gd = gpuDevice;
	for i = 1:length(sizes)
		n = sizes(i);
		[A, b] = getData(n, clz);
		gflopsCPU(i) = benchFcn(A, b, @waitForCpu, 1);
		fprintf('Time on CPU: %f\n', gflopsCPU(i));
		A = gpuArray(A);
		b = gpuArray(b);
		% fprintf('Free memory on GPU: %f\n', gd.FreeMemory);
		gflopsGPU(i) = benchFcn(A, b, @() waitForGpu(gd), 2);
		fprintf('Time on GPU: %f\n', gflopsGPU(i));
		clear('A','b')
	end
end

%
% We then execute the benchmarks in single and double precision.
close all;
[cpu, gpu] = executeBenchmarks('single', sizeSingle);
results.sizeSingle = sizeSingle;
results.gflopsSingleCPU = cpu;
results.gflopsSingleGPU = gpu;
[cpu, gpu] = executeBenchmarks('double', sizeDouble);
results.sizeDouble = sizeDouble;
results.gflopsDoubleCPU = cpu;
results.gflopsDoubleGPU = gpu;

% Plotting the Performance
% We can now plot the results, and compare the performance on the CPU and
% the GPU, both for single and double precision.

%
% First, we look at the performance in single
% precision.
fig = figure;
ax = axes('parent', fig);
plot(ax, results.sizeSingle, results.gflopsSingleGPU, '-x', results.sizeSingle, results.gflopsSingleCPU, '-o');
ax.FontSize = newFontSize;
grid on;
legend('UPG', 'UCP', 'Location', 'NorthWest');
title(ax, 'Com precisão simples.');
ylabel(ax, 'Tempo (segundos)');
xlabel(ax, 'Tamanho da Dimensão Maior da Matriz');
drawnow;
print(fig, 'C:\Workspace\TCC_Text\04-figuras\sptime.eps', '-depsc');

%
% Now, we look at the performance in double precision.
fig = figure;
ax = axes('parent', fig);
plot(ax, results.sizeDouble, results.gflopsDoubleGPU, '-x', ...
	 results.sizeDouble, results.gflopsDoubleCPU, '-o')
ax.FontSize = newFontSize;
legend('UPG', 'UCP', 'Location', 'NorthWest');
grid on;
title(ax, 'Com precisão dupla.');
ylabel(ax, 'Tempo (segundos)');
xlabel(ax, 'Tamanho da Dimensão Maior da Matriz');
drawnow;
print(fig, 'C:\Workspace\TCC_Text\04-figuras\dptime.eps', '-depsc');

%
% Both plots in one.
fig = figure;
ax = axes('parent', fig);
plot(ax, results.sizeDouble, results.gflopsDoubleGPU, '-x', ...
	results.sizeDouble, results.gflopsDoubleCPU, '-o', ...
	results.sizeSingle, results.gflopsSingleGPU, '-x', ...
	results.sizeSingle, results.gflopsSingleCPU, '-o')
ax.FontSize = newFontSize;
legend('UPG - Precisão Dupla', 'UCP  - Precisão Dupla', 'UPG - Precisão Simples', 'UCP  - Precisão Simples', 'Location', 'NorthWest');
grid on;
ylabel(ax, 'Tempo (segundos)');
xlabel(ax, 'Tamanho da Dimensão Maior da Matriz');
drawnow;
print(fig, 'C:\Workspace\TCC_Text\04-figuras\spdptime.eps', '-depsc');

%
% Finally, we look at the speedup when comparing the GPU to the CPU.
speedupDouble = results.gflopsDoubleCPU./results.gflopsDoubleGPU;
speedupSingle = results.gflopsSingleCPU./results.gflopsSingleGPU;
fig = figure;
ax = axes('parent', fig);
plot(ax, results.sizeSingle, speedupSingle, '-v', ...
	 results.sizeDouble, speedupDouble, '-*');
ax.FontSize = newFontSize;
grid on;
legend('Precisão simples.', 'Precisão dupla.', 'Location', 'SouthEast');
% title(ax, 'Speedup da computação na UPG em comparação à UCP');
ylabel(ax, 'Aceleração');
xlabel(ax, 'Tamanho da Dimensão Maior da Matriz');
drawnow;
print(fig, 'C:\Workspace\TCC_Text\04-figuras\speedup.eps', '-depsc');
end
