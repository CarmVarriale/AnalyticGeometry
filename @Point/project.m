function point = project(point, dest)
% Project point to the coorinated plane or axis of its frame
arguments (Input)
	point (1,1) Point
	dest (1,1) {mustBeMember(dest,["1","2","3","12","13","23"])}
end
arguments (Output)
	point (1,1) Point
end
point.coords = calcProject(point, dest);
end