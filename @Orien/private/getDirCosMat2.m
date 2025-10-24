function T2 = getDirCosMat2(angle)
% Fundamental coordinate transformation matrix used to transform an object 
% expressed in a Base frame into one expressed in a Follower frame, when the 
% latter is rotated about the second axis of the former by a positive angle. 
% The rows of T2 are the components of the triad of the Follower frame 
% expressed in the Base frame.
% For this reason, this is also a fundamental Direction Cosine Matrix.
% If Vb is the array of coordinates of a Vector in the Base frame, the array of
% coordinates of the same Vector in the Follower Frame is Vf = T2 * Vb
arguments (Input)
	angle (1,1) double
end
arguments (Output)
	T2 {Orien.mustBeDirCosMat}
end
c = cos(angle);
s = sin(angle);
T2 = [c 0 -s; 0 1 0; s 0 c];
T2(abs(T2) < 1e-12) = 0;
end