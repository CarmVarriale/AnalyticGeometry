function newPoint = projectNew(point, dest)
% Create a newPoint by projecting point to the coorinated plane or
% axis of its frame
arguments (Input)
	point (1,1) Point
	dest (1,1) {mustBeMember(dest,["1","2","3","12","13","23"])}
end
arguments (Output)
	newPoint (1,1) Point
end
newPoint = Point(calcProject(point, dest), point.ref);
end