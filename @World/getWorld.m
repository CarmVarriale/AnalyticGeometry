function uniqueWorld = getWorld(~)
% Ensure the singleton instance is created only once and access the
% same instance for every future call
persistent world %#ok
if isempty(world) || ~isvalid(world)
	world = World();
end
uniqueWorld = world;
end