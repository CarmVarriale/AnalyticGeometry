classdef testWorld < matlab.unittest.TestCase

	properties

		world
	
	end

	methods (TestClassSetup)

		function addClassToPath(testCase)
			testCase.applyFixture( ...
				matlab.unittest.fixtures.PathFixture(".."));
			testCase.applyFixture( ...
				matlab.unittest.fixtures.PathFixture("../includes/TreeNode"));
		end
		
	end
	
	methods (TestMethodSetup)

		function createWorld(testCase)
			testCase.world = World.getWorld();
			testCase.addTeardown(@clear, "World", "getWorld")
		end

	end

	methods (Test)

		function testWorldNameValue(testCase)
			testCase.verifyEqual(testCase.world.name, "World");
		end


		function testWorldLocatValue(testCase)
			testCase.verifyEqual([0; 0; 0], testCase.world.origin.coords);
		end


		function testWorldOrienValue(testCase)
			testCase.verifyEqual( ...
				testCase.world.orien.angles, ...
				[0; 0; 0]);
			testCase.verifyEqual( ...
				testCase.world.orien.seqID, ...
				"321");
		end


		function testWorldParentIsEmpty(testCase)
			testCase.verifyEmpty(testCase.world.ref);
		end


		function testCannotChangeWorldParentToItself(testCase)
			try 
				testCase.world.parent = World.getWorld();
			catch ME
				testCase.verifyMatches( ...
					ME.identifier, ...
					"TreeNode:set:parent");
			end
		end


		function testWorldIsSingleton(testCase)
			world2 = World.getWorld();
			testCase.verifyEqual(testCase.world, world2);
			testCase.verifySameHandle(testCase.world, world2);
		end

	end

end
