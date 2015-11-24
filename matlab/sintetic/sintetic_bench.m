%% Benchmarking pinv(A') * b' on the GPU

% Copyright 2010-2013 The MathWorks, Inc.
% Copyright 2015 Anderson Nascimento Nunes

function results = sintetic_bench()
%% The Benchmarking Function
% We want to benchmark matrix left division (\), and not the cost of
% transferring data between the CPU and GPU, the time it takes to create a
% matrix, or other parameters.  We therefore separate the data generation
% from the solving of the linear system, and measure only the time it
% takes to do the latter.
function [A, b] = getData(n, clz)
    fprintf('Creating a matrix of size %d-by-%d.\n', n, n/s_dim);
    A = rand(n, n/s_dim, clz);
    b = rand(n, n/s_dim, clz);
end

function time = timeSolve(A, b, waitFcn)
    tic;
    x = pinv(A') * b'; %#ok<NASGU> We don't need the value of x.
    waitFcn(); % Wait for operation to complete.
    time = toc;
end

%% Choosing Problem Size
% As with a great number of other parallel algorithms, the performance of
% solving a linear system in parallel depends greatly on the matrix size.
% As seen in other examples, such as <paralleldemo_backslash_bench.html
% Benchmarking A\b>, we compare the performance of the algorithm for
% different matrix sizes.

% Declare the matrix sizes to be a multiple of 1024.
maxSizeSingle = 1024*20;
maxSizeDouble = maxSizeSingle/2;
s_dim = 64;
step = 1024;
if maxSizeDouble/step >= 10
    step = step*floor(maxSizeDouble/(5*step));
end
sizeSingle = 1024:step:maxSizeSingle;
sizeDouble = 1024:step:maxSizeDouble;


%% Comparing Performance: Gigaflops 
% We use the number of floating point operations per second as our measure
% of performance because that allows us to compare the performance of the
% algorithm for different matrix sizes. 
%
% Given a matrix size, the benchmarking function creates the matrix |A| and
% the right-hand side |b| once, and then solves |A\b| a few times to get
% an accurate measure of the time it takes.  We use the floating point
% operations count of the HPC Challenge, so that for an n-by-n matrix, we
% count the floating point operations as |2/3*n^3 + 3/2*n^2|.
%
% The function is passed in a handle to a 'wait' function. On the CPU, this
% function does nothing. On the GPU, this function waits for all pending
% operations to complete. Waiting in this way ensures accurate timing.
function time = benchFcn(A, b, waitFcn)
    numReps = 3;
    time = inf;
    % We solve the linear system a few times and calculate the Gigaflops 
    % based on the best time.
    for itr = 1:numReps
        tcurr = timeSolve(A, b, waitFcn);
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

%% Executing the Benchmarks
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
        gflopsCPU(i) = benchFcn(A, b, @waitForCpu);
        fprintf('Time on CPU: %f\n', gflopsCPU(i));
        A = gpuArray(A);
        b = gpuArray(b);
		fprintf('Free memory on GPU: %f\n', gd.FreeMemory);
        gflopsGPU(i) = benchFcn(A, b, @() waitForGpu(gd));
        fprintf('Time on GPU: %f\n', gflopsGPU(i));
		clear('A','b');
    end
end

%%
% We then execute the benchmarks in single and double precision.
[cpu, gpu] = executeBenchmarks('single', sizeSingle);
results.sizeSingle = sizeSingle;
results.gflopsSingleCPU = cpu;
results.gflopsSingleGPU = gpu;
[cpu, gpu] = executeBenchmarks('double', sizeDouble);
results.sizeDouble = sizeDouble;
results.gflopsDoubleCPU = cpu;
results.gflopsDoubleGPU = gpu;

%% Plotting the Performance
% We can now plot the results, and compare the performance on the CPU and
% the GPU, both for single and double precision.

%%
% First, we look at the performance of the backslash operator in single
% precision.
fig = figure;
ax = axes('parent', fig);
plot(ax, results.sizeSingle, results.gflopsSingleGPU, '-x', ...
     results.sizeSingle, results.gflopsSingleCPU, '-o');
grid on;
legend('UPG', 'UCP', 'Location', 'NorthWest');
title(ax, 'Desempenho com precisão simples.');
ylabel(ax, 'Tempo (segundos)');
xlabel(ax, 'Tamanho da Dimensão Maior da Matriz');
drawnow;
print(fig, 'C:\Workspace\TCC_Text\sptime.png', '-dpng');

%%
% Now, we look at the performance of the backslash operator in double
% precision.
fig = figure;
ax = axes('parent', fig);
plot(ax, results.sizeDouble, results.gflopsDoubleGPU, '-x', ...
     results.sizeDouble, results.gflopsDoubleCPU, '-o')
legend('UPG', 'UCP', 'Location', 'NorthWest');
grid on;
title(ax, 'Desempenho com precisão dupla.');
ylabel(ax, 'Tempo (segundos)');
xlabel(ax, 'Tamanho da Dimensão Maior da Matriz');
drawnow;
print(fig, 'C:\Workspace\TCC_Text\dptime.png', '-dpng');

%%
% Finally, we look at the speedup of the backslash operator when comparing
% the GPU to the CPU.
speedupDouble = results.gflopsDoubleCPU./results.gflopsDoubleGPU;
speedupSingle = results.gflopsSingleCPU./results.gflopsSingleGPU;
fig = figure;
ax = axes('parent', fig);
plot(ax, results.sizeSingle, speedupSingle, '-v', ...
     results.sizeDouble, speedupDouble, '-*');
grid on;
legend('Precisão simples.', 'Precisão dupla.', 'Location', 'SouthEast');
title(ax, 'Speedup da computação na UPG em comparação à UCP');
ylabel(ax, 'Speedup');
xlabel(ax, 'Tamanho da Dimensão Maior da Matriz');
drawnow;
print(fig, 'C:\Workspace\TCC_Text\speedup.png', '-dpng');
close all;
end
