function K = getSkew(vec)
% Get the skew-symmetric matrix of the vector coordinates
% 
% For a vector v = [v1; v2; v3], returns the skew-symmetric matrix:
%     K = [ 0   -v3   v2 ]
%         [ v3   0   -v1 ]
%         [-v2   v1   0  ]
%
% This matrix is useful for representing the cross product as a matrix
% multiplication: cross(v, w) = K * w
%
% See also: cross
arguments (Input)
	vec (1,1) Vector
end
coords = vec.coords;
K = [0,         -coords(3),  coords(2);
     coords(3),  0,         -coords(1);
    -coords(2),  coords(1),  0        ];
end
