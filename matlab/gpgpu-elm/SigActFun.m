function H = SigActFun(P,IW,Bias);

%%%%%%%% Feedforward neural network using sigmoidal activation function
V=pagefun(@ctranspose, P*IW); ind=gpuArray.ones(1,size(P,1));
BiasMatrix=Bias(ind,:);      
V=V+BiasMatrix;
H = 1./(1+exp(-V));