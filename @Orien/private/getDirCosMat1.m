function T1 = getDirCosMat1(angle)
% Fundamental coordinate transformation matrix used to transform an object 
% expressed in a Base frame into one expressed in a Follower frame, when the 
% latter is rotated about the first axis of the former by a positive angle. 
% The rows of T1 are the components of the triad of the Follower frame 
% expressed in the Base frame.
% For this reason, this is also a fundamental Direction Cosine Matrix.
% If Vb is the array of coordinates of a Vector in the Base frame, the array of
% coordinates of the same Vector in the Follower Frame is Vf = R1 * Vb
arguments (Input)
	angle (1,1) double
end
arguments (Output)
	T1 {Orien.mustBeDirCosMat}
end
c = cos(angle);
s = sin(angle);
T1 = [1 0 0; 0 c s; 0 -s c];
T1(abs(T1) < 1e-12) = 0;
end