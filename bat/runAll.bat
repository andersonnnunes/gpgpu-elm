:: Run all tests with the specified constraints.
:: /HIGH : Process' priority is high.
:: /affinity 80 : Set process' afinity to the designed core.
:: -singleCompThread -noawt -minimize -nodesktop -nosplash : Set Matlab to run as a minimal shell.
:: -r "run '"C:\Workspace\TCC_Code\matlab\runAll\runAll.m"'; exit;" : Execute the tests, then exit.

C:\Windows\System32\cmd.exe /C start "" /HIGH /affinity 80 "C:\Program Files\MATLAB\R2015a\bin\win64\MATLAB.exe" -singleCompThread -noawt -minimize -nodesktop -nosplash -r "run '"C:\Workspace\TCC_Code\matlab\runAll\runAll.m"'; exit;"