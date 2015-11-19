function y = dkp(xt, dt, nc, xv, valS, kernel)
% dkp: Direct Kernel Perceptron classifier
% arguments: 
%  xt: matrix with the training patterns
%  dt: classes for the training data from 1 to number of classes
%  xv: matrix with the validation patterns
%  valS: kernel spread
%  kernel: choose between gaussian and linear kernel
    npt = size(xt, 1); npv = size(xv, 1); s2 = valS^2;
    sumt = zeros(1,nc); vote = zeros(1,nc); y = zeros(1,npv);
	
		
    for i=1:npv
        sumt(:)=0; vote(:)=0; p=xv(i,:);
        for j=1:npt
			z = norm(xt(j,:) - p);
			if kernel == 1
				kernelV = exp(-z^2/s2);
			elseif kernel == 2
				kernelV = dot(xt(j,:),p);
			end
            k = dt(j); sumt(k) = sumt(k) + kernelV;
        end
        for j=1:nc
            for k=j+1:nc
                if sumt(j) > sumt(k)
                    vote(j) = vote(j) + 1;
                else
                    vote(k) = vote(k) + 1;
                end
            end
        end
        [~, y(i)] = max(vote);
    end
end