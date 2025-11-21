function newFrame = copyElement(frame)
% Deep copy a Frame with orphaned parent and all descendants
%
% Creates a copy of the frame with an empty parent (orphaned).
% All descendants are recursively copied and reparented to the new frame.
arguments (Input)
	frame (1,1) Frame
end
arguments (Output)
	newFrame (1,1) Frame
end
newFrame = copyElement@matlab.mixin.Copyable(frame);
newFrame.ref = World.getWorld();

% Deep copy all descendants and update their parent references
if ~isempty(frame.children)
	newFrame.children = Frame.empty;
	for i = 1:numel(frame.children)
		childCopy = copy(frame.children(i));
		childCopy.ref = newFrame;
	end
end
end