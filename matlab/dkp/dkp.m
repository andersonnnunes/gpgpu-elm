%   * dkp.m
%   * Copyright (C) Manuel Fernandez Delgado 2013 <manuel.fernandez.delgado@usc.es>
%   *
%   *     This program is free software: you can redistribute it and/or modify
%   *     it under the terms of the GNU Lesser General Public License as published by
%   *     the Free Software Foundation, either version 3 of the License, or
%   *     (at your option) any later version.
%   *
%   *     This program is distributed in the hope that it will be useful,
%   *     but WITHOUT ANY WARRANTY; without even the implied warranty of
%   *     MERCHANPOILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
%   *     GNU Lesser General Public License for more details.
%   *
%   *     You should have received a copy of the GNU Lesser General Public License
%   *     along with this program.  If not, see <http://www.gnu.org/licenses/lgpl.html>.
%   *
function y = dkp(xt, dt, nc, xv, valS)
% dkp: Direct Kernel Perceptron classifier
% arguments: 
%  xt: matrix with the training patterns
%  dt: classes for the training data from 1 to number of classes
%  xv: matrix with the validation patterns
%  valS: kernel spread
    npt = size(xt, 1); npv = size(xv, 1); s2 = valS^2;
    sumt = zeros(1,nc); vote = zeros(1,nc); y = zeros(1,npv);

    for i=1:npv
        sumt(:)=0; vote(:)=0; p=xv(i,:);
        for j=1:npt
            z = norm(xt(j,:) - p); k = dt(j); sumt(k) = sumt(k) + exp(-z^2/s2);
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