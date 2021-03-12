%  ShearLab3Dv11 Toolbox Copying Permissions

%  This program is free software: you can redistribute it and/or modify
%  it under the terms of the GNU General Public License as published by
%  the Free Software Foundation, either version 3 of the License, or
%  (at your option) any later version.

%  This program is distributed in the hope that it will be useful,
%  but WITHOUT ANY WARRANTY; without even the implied warranty of
%  MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
%  GNU General Public License for more details.

%  If you use or mention this code in a publication please cite the website www.shearlab.org and the following paper:
%  G. Kutyniok, W.-Q. Lim, R. Reisenhofer
%  ShearLab 3D: Faithful Digital SHearlet Transforms Based on Compactly Supported Shearlets.
%  ACM Trans. Math. Software 42 (2016), Article No.: 5.


%  This package was written by 
%	Rafael Reisenhofer, Technische Universit�t Berlin
%
%  Contributors to this effort include
%   Wang-Q Lim, Technische Universit�t Berlin
%   Gitta Kutyniok, Technische Universit�t Berlin 
%
% Copyright 2014, Rafael Reisenhofer, Technische Universit�t Berlin.
% 
%                         All Rights Reserved
%
%
%
%  Special thanks to
%  
%      Wang-Q Lim, Technische Universit�t Berlin
%
%  for all the support and good ideas.
%
%  Thanks to
%
%      Philipp Petersen 
%
%  for beta testing, 
%
%      an anonymous reviewer
%
%  for very helpful suggestions and
%
%      Jonathan Buckheit, Stanford
%      Shaobing Chen, Stanford
%      Maureen Clerc, Ecole Polytechnique
%      James Crutchfield,  Berkeley & Santa Fe Institute
%      David Donoho, Stanford
%      Mark Duncan, Stanford
%      Hong-Ye Gao, Berkeley (now at Statistical Science)
%      Xiaoming Huo, Stanford (now at Georgia Tech)
%      Jerome Kalifa, Ecole Polytechnique
%      Eric Kolaczyk, Stanford (now at Boston University)
%      Ofer Levi, Stanford
%      Stephane Mallat, Ecole Polytechnique
%      Iain Johnstone,  Stanford
%      Jeffrey Scargle, NASA-Ames
%      Karl Young, NASA-Ames
%      Thomas Yu, Stanford (now at Rensselear Polytechnic) 
%
%      for sharing their WaveLab850 code (http://www-stat.stanford.edu/~wavelab/).
%
% The methods
%
% - dfilters 
% - dmaxflat
% - mctrans
% - modulate2
%
% were taken from the Nonsubsampled Contourlet Toolbox [1] which can be downloaded from
% http://www.mathworks.de/matlabcentral/fileexchange/10049-nonsubsampled-contourlet-toolbox.
%
% [1] A. L. da Cunha, J. Zhou, M. N. Do, "The Nonsubsampled Contourlet Transform: Theory, Design, and Applications," IEEE Transactions on Image Processing, 2005.
%
