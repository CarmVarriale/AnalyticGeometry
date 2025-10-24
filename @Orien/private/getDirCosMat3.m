function T3 = getDirCosMat3(angle)
% Fundamental coordinate transformation matrix used to transform an object 
% expressed in a Base frame into one expressed in a Follower frame, when the 
% latter is rotated about the third axis of the former by a positive angle. 
% The rows of T3 are the components of the triad of the Follower frame 
% expressed in the Base frame.
% For this reason, this is also a fundamental Direction Cosine Matrix.
% If Vb is the array of coordinates of a Vector in the Base frame, the array of
% coordinates of the same Vector in the Follower Frame is Vf = T3 * Vb
arguments (Input)
	angle (1,1) double
end
arguments (Output)
	T3 {Orien.mustBeDirCosMat}
end
c = cos(angle);
s = sin(angle);
T3 = [c s 0; -s c 0; 0 0 1];
T3(abs(T3) < 1e-12) = 0;
end