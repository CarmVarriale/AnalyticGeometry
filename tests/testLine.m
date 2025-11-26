classdef testLine < matlab.unittest.TestCase

	properties

		frames

	end

	methods (TestClassSetup)

		function addClassToPath(testCase)
			testCase.applyFixture( ...
				matlab.unittest.fixtures.PathFixture(".."));
			testCase.applyFixture( ...
				matlab.unittest.fixtures.PathFixture("../includes/TreeNode"));
		end

	function setupFrames(testCase)
		testCase.frames = testCase.applyFixture(...
			FrameHierarchyFixture());
	end	end

	%%
	methods (Test)

		function testCreateLineFromTwoPoints(testCase)
			% Test creating line from two points
			p1 = Point([0; 0; 0], testCase.frames.world);
			p2 = Point([3; 4; 0], testCase.frames.world);
			
			line = Line(p1, p2);
			
			testCase.verifyEqual(line.anchor.coords, [0; 0; 0]);
			testCase.verifyEqual(line.anchor.ref, testCase.frames.world);
			testCase.verifyEqual( ...
				line.direc.coords, ...
				[3; 4; 0]/5, ...
				AbsTol = 1e-15);
			testCase.verifyEqual(line.direc.magnitude, 1, AbsTol = 1e-15);
		end


		function testCreateLineFromPointAndVector(testCase)
			% Test creating line from point and direction vector
			p = Point([1; 2; 3], testCase.frames.world);
			v = Vector([2; 0; 0], testCase.frames.world);
			
			line = Line(p, v);
			
			testCase.verifyEqual(line.anchor.coords, [1; 2; 3]);
			testCase.verifyEqual(line.anchor.ref, testCase.frames.world);
			testCase.verifyEqual( ...
				line.direc.coords, ...
				[1; 0; 0], ...
				AbsTol = 1e-15);
			testCase.verifyEqual(line.direc.magnitude, 1, AbsTol = 1e-15);
		end


	function testCreateLineWithVectorInDifferentFrame(testCase)
		% Test creating line with vector in different frame
		p = Point([0; 0; 0], testCase.frames.world);
		v = Vector([1; 0; 0], testCase.frames.fr3a);
		
		line = Line(p, v);
		
		% Vector should be resolved to world frame
		% fr3a is rotated π/2 about Z, [1; 0; 0] in fr3a → [1; 0; 0] in world
		testCase.verifyEqual(line.anchor.ref, testCase.frames.world);
		testCase.verifyEqual(line.direc.ref, testCase.frames.world);
		testCase.verifyEqual( ...
			line.direc.coords, ...
			[1; 0; 0], ...
			AbsTol = 1e-15);
	end
		function testCreateLineWithPointsInDifferentFrames(testCase)
			% Test creating line with points in different frames
			p1 = Point([0; 0; 0], testCase.frames.world);
			p2 = Point([1; 0; 0], testCase.frames.fr1);
			
			line = Line(p1, p2);
			
			testCase.verifyEqual(line.anchor.coords, [0; 0; 0]);
			testCase.verifyEqual(line.anchor.ref, testCase.frames.world);
			% p2 in world is [2; 1; 1], so direction is [2; 1; 1]/sqrt(6)
			expectedDir = [2; 1; 1]/sqrt(6);
			testCase.verifyEqual( ...
				line.direc.coords, ...
				expectedDir, ...
				AbsTol = 1e-15);
		end


		function testCannotCreateLineFromIdenticalPoints(testCase)
			% Test that creating line from identical points throws error
			p1 = Point([1; 2; 3], testCase.frames.world);
			p2 = Point([1; 2; 3], testCase.frames.world);
			
			try
				Line(p1, p2);
				testCase.verifyFail("Expected error was not thrown");
			catch ME
				testCase.verifyMatches( ...
					ME.identifier, ...
					"Line:InvalidPoints");
			end
		end


		function testCannotCreateLineFromZeroVector(testCase)
			% Test that creating line from zero vector throws error
			p = Point([1; 2; 3], testCase.frames.world);
			v = Vector([0; 0; 0], testCase.frames.world);
			
			try
				Line(p, v);
				testCase.verifyFail("Expected error was not thrown");
			catch ME
				testCase.verifyMatches( ...
					ME.identifier, ...
					"Line:InvalidVector");
			end
		end


		function testDefaultLineConstructor(testCase)
			% Test default line constructor
			line = Line();
			
			testCase.verifyEqual(line.anchor.coords, [0; 0; 0]);
			testCase.verifyEqual(line.direc.coords, [1; 0; 0]);
			testCase.verifyEqual(line.direc.magnitude, 1, AbsTol = 1e-15);
		end


		function testResolveInSameFrame(testCase)
			% Test resolving line in its own frame
			p = Point([1; 2; 3], testCase.frames.world);
			v = Vector([1; 0; 0], testCase.frames.world);
			line = Line(p, v);
			
			lineResolved = line.resolveIn(testCase.frames.world);
			
			testCase.verifyEqual(lineResolved.anchor.coords, [1; 2; 3]);
			testCase.verifyEqual(lineResolved.direc.coords, [1; 0; 0]);
			testCase.verifyEqual(lineResolved.anchor.ref, testCase.frames.world);
			testCase.verifyEqual(lineResolved.direc.ref, testCase.frames.world);
		end


		function testResolveInParentFrame(testCase)
			% Test resolving line from child to parent frame
			p = Point([1; 0; 0], testCase.frames.fr1);
			v = Vector([1; 0; 0], testCase.frames.fr1);
			line = Line(p, v);
			
			lineInWorld = line.resolveIn(testCase.frames.world);
			
			testCase.verifyEqual(lineInWorld.anchor.coords, [2; 1; 1]);
			testCase.verifyEqual(lineInWorld.direc.coords, [1; 0; 0]);
			testCase.verifyEqual(lineInWorld.anchor.ref, testCase.frames.world);
			testCase.verifyEqual(lineInWorld.direc.ref, testCase.frames.world);
		end


		function testResolveInChildFrame(testCase)
			% Test resolving line from parent to child frame
			p = Point([2; 1; 1], testCase.frames.world);
			v = Vector([1; 0; 0], testCase.frames.world);
			line = Line(p, v);
			
			lineInFr1 = line.resolveIn(testCase.frames.fr1);
			
			testCase.verifyEqual(lineInFr1.anchor.coords, [1; 0; 0]);
			testCase.verifyEqual(lineInFr1.direc.coords, [1; 0; 0]);
			testCase.verifyEqual(lineInFr1.anchor.ref, testCase.frames.fr1);
			testCase.verifyEqual(lineInFr1.direc.ref, testCase.frames.fr1);
		end


	function testResolveInAncestorFrame(testCase)
		% Test resolving line from grandchild to grandparent (world)
		p = Point([1; 0; 0], testCase.frames.fr3a);
		v = Vector([1; 0; 0], testCase.frames.fr3a);
		line = Line(p, v);
		
		lineInWorld = line.resolveIn(testCase.frames.world);
		
		% fr3a is at [3,1,1] in world, with π/2 Z rotation
		% Point [1,0,0] in fr3a → [4,1,1] in world
		testCase.verifyEqual( ...
			lineInWorld.anchor.coords, ...
			[4; 1; 1], ...
			AbsTol = 1e-15);
		% Direction [1,0,0] in fr3a → [1,0,0] in world (vectors don't translate)
		testCase.verifyEqual( ...
			lineInWorld.direc.coords, ...
			[1; 0; 0], ...
			AbsTol = 1e-15);
		testCase.verifyEqual(lineInWorld.anchor.ref, testCase.frames.world);
		testCase.verifyEqual(lineInWorld.direc.ref, testCase.frames.world);
	end
	function testResolveInDescendantFrame(testCase)
		% Test resolving line from grandparent to grandchild
		p = Point([2; 1; 1], testCase.frames.world);
		v = Vector([-1; 0; 0], testCase.frames.world);
		line = Line(p, v);
		
		lineIn3a = line.resolveIn(testCase.frames.fr3a);
		
		% Point [2,1,1] in world → [-1,0,0] in fr3a
		testCase.verifyEqual( ...
			lineIn3a.anchor.coords, ...
			[-1; 0; 0], ...
			AbsTol = 1e-15);
		% Vector [-1,0,0] in world → [-1,0,0] in fr3a
		testCase.verifyEqual( ...
			lineIn3a.direc.coords, ...
			[-1; 0; 0], ...
			AbsTol = 1e-15);
		testCase.verifyEqual(lineIn3a.anchor.ref, testCase.frames.fr3a);
		testCase.verifyEqual(lineIn3a.direc.ref, testCase.frames.fr3a);
	end
		function testResolveInSiblingFrame(testCase)
			% Test resolving line between sibling frames (cross-branch)
			p = Point([1; 0; 0], testCase.frames.fr2a);
			v = Vector([0; 1; 0], testCase.frames.fr2a);
			line = Line(p, v);
			
			lineIn2b = line.resolveIn(testCase.frames.fr2b);
			
			% fr2a origin is [2,0,0] in fr1, fr2b origin is [0,2,0] in fr1
			% Point [1,0,0] in fr2a -> [3,0,0] in fr1 -> [3,-2,0] in fr2b
			testCase.verifyEqual( ...
				lineIn2b.anchor.coords, ...
				[3; -2; 0], ...
				AbsTol = 1e-15);
			% Direction [0,1,0] in fr2a -> [0,1,0] in fr1 -> [0,1,0] in fr2b
			testCase.verifyEqual( ...
				lineIn2b.direc.coords, ...
				[0; 1; 0], ...
				AbsTol = 1e-15);
			testCase.verifyEqual(lineIn2b.anchor.ref, testCase.frames.fr2b);
			testCase.verifyEqual(lineIn2b.direc.ref, testCase.frames.fr2b);
		end


	function testResolveInWithRotatedFrames(testCase)
		% Test resolving line with rotated frames
		p = Point([1; 0; 0], testCase.frames.fr3c);
		v = Vector([1; 0; 0], testCase.frames.fr3c);
		line = Line(p, v);
		
		lineInFr1 = line.resolveIn(testCase.frames.fr1);
		
		% fr3c has π/2 X rotation → [1,0,0] in fr3c becomes [0,1,0] (vector) in fr1
		% Point [1,0,0] in fr3c → [0,1,2] in fr1
		testCase.verifyEqual( ...
			lineInFr1.anchor.coords, ...
			[0; 1; 2], ...
			AbsTol = 1e-15);
		testCase.verifyEqual( ...
			lineInFr1.direc.coords, ...
			[0; 1; 0], ...
			AbsTol = 1e-15);
	end
		function testResolveInPreservesDirection(testCase)
			% Test that resolving line preserves direction magnitude (unit vector)
			p = Point([1; 2; 3], testCase.frames.fr1);
			v = Vector([3; 4; 5], testCase.frames.fr1);
			line = Line(p, v);
			
			lineInWorld = line.resolveIn(testCase.frames.world);
			lineInFr2a = line.resolveIn(testCase.frames.fr2a);
			lineInFr3c = line.resolveIn(testCase.frames.fr3c);
			
			% All should have unit direction vectors
			testCase.verifyEqual( ...
				lineInWorld.direc.magnitude, ...
				1, ...
				AbsTol = 1e-15);
			testCase.verifyEqual( ...
				lineInFr2a.direc.magnitude, ...
				1, ...
				AbsTol = 1e-15);
			testCase.verifyEqual( ...
				lineInFr3c.direc.magnitude, ...
				1, ...
				AbsTol = 1e-15);
		end


		function testResolveInDoesNotModifyOriginal(testCase)
			% Test that resolveIn doesn't modify the original line
			p = Point([1; 2; 3], testCase.frames.fr1);
			v = Vector([1; 0; 0], testCase.frames.fr1);
			line = Line(p, v);
			
			originalPointCoords = line.anchor.coords;
			originalDirecCoords = line.direc.coords;
			originalRef = line.anchor.ref;
			
			lineInWorld = line.resolveIn(testCase.frames.world);
			
			% Verify original is unchanged
			testCase.verifyEqual(line.anchor.coords, originalPointCoords);
			testCase.verifyEqual(line.direc.coords, originalDirecCoords);
			testCase.verifyEqual(line.anchor.ref, originalRef);
			testCase.verifyEqual(line.direc.ref, originalRef);
			
			% Verify new line is different
			testCase.verifyNotEqual( ...
				lineInWorld.anchor.coords, ...
				originalPointCoords);
			testCase.verifyNotEqual( ...
				lineInWorld.anchor.ref, ...
				originalRef);
		end


		function testDisp(testCase)
			% Test that disp doesn't throw errors
			line = Line( ...
				Point([1; 2; 3], testCase.frames.world), ...
				Vector([1; 0; 0], testCase.frames.world));
			testCase.verifyWarningFree(@() disp(line));
		end

	end

end



