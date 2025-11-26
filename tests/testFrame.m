classdef testFrame < matlab.unittest.TestCase

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
		end

	end

	methods (Test)

	function testCannotSetItselfAsReference(testCase)
		% Test that a frame cannot be set as its own reference
		try
			testCase.frames.fr1.ref = testCase.frames.fr1;
		catch ME
			testCase.verifyMatches( ...
				ME.identifier, ...
				"TreeNode:set:parent");
			testCase.verifyMatches( ...
				ME.message, ...
				"Node cannot be its own parent");
		end
	end
	function testCannotChangeWorldReference(testCase)
		% Test that a frame cannot change its world reference
		try
			testCase.frames.world.ref = testCase.frames.fr2;
		catch ME
		end
		testCase.verifyMatches( ...
			ME.identifier, ...
			"Frame:set:ref");
		testCase.verifyMatches( ...
			ME.message, ...
			"World cannot have a non-empty ref Frame");
	end
	function testChangeReferenceAfterCreation(testCase)
		% Test that a frame reference can be changed after creation
		% Create local test frames to avoid modifying fixture
		frTest1 = Frame("TestFr1", ...
			Point([0; 0; 0], testCase.frames.world), ...
			Orien([0; 0; 0], "321", testCase.frames.world), ...
			testCase.frames.world);
		frTest2 = Frame("TestFr2", ...
			Point([0; 0; 0], testCase.frames.world), ...
			Orien([0; 0; 0], "321", testCase.frames.world), ...
			testCase.frames.world);
		
		testCase.verifyEqual(frTest2.ref, testCase.frames.world);
		testCase.verifyEqual(frTest2.parent, testCase.frames.world);
		frTest2.ref = frTest1;
		testCase.verifyEqual(frTest2.ref, frTest1);
		testCase.verifyEqual(frTest2.parent, frTest1);
		testCase.verifyEqual(frTest1.ref, testCase.frames.world);
		testCase.verifyEqual(frTest1.parent, testCase.frames.world);
		testCase.verifyEqual(frTest1.children, frTest2);
	end
		function testCannotConstructFrameWithNullName(testCase)
			% Test that a frame cannot be constructed with a null name
			try
		Frame("", ...
				Point([0; 0; 0], testCase.frames.world), ...
				Orien([0; 0; 0], "321", testCase.frames.world), ...
				testCase.frames.world);
			catch ME
			end
			testCase.verifyMatches( ...
				ME.identifier, ...
				"MATLAB:validators:mustBeNonzeroLengthText");
			testCase.verifyMatches( ...
				ME.message, ...
				"Value must be text with one or more characters.");
		end


	function testIsNameUnique(testCase)
		% Test that isNameUnique method works correctly
		try
			Frame("Frame1", ...
				Point([0; 0; 0], testCase.frames.world), ...
				Orien([0; 0; 0], "321", testCase.frames.world), ...
				testCase.frames.world);
		catch ME
			testCase.verifyMatches( ...
				ME.identifier, ...
				"Frame:Frame");
			testCase.verifyMatches( ...
				ME.message, ...
				"uID is not unique in the Frame tree");
		end
	end
		function testBaseOrientation(testCase)
			testCase.verifyEqual( ...
				unique([testCase.frames.fr4.triad.ref]), ...
				testCase.frames.fr3);
			testCase.verifyEqual( ...
				testCase.frames.fr4.triad(1).coords, ...
				[0; 1; 0], ...
				AbsTol = 1e-15);
			testCase.verifyEqual( ...
				testCase.frames.fr4.triad(2).coords, ...
				[-1; 0; 0], ...
				AbsTol = 1e-15);
			testCase.verifyEqual( ...
				testCase.frames.fr4.triad(3).coords, ...
				[0; 0; 1], ...
				AbsTol = 1e-15);
			testCase.verifyEqual( ...
				testCase.frames.fr4.orien.coords, ...
				[0, -1, 0; 1, 0, 0; 0, 0, 1], ...
				AbsTol = 1e-15);

			testCase.verifyEqual( ...
				unique([testCase.frames.fr5.triad.ref]), ...
				testCase.frames.fr3);
			testCase.verifyEqual( ...
				testCase.frames.fr5.triad(1).coords, ...
				[0; 0; -1], ...
				AbsTol = 1e-15);
			testCase.verifyEqual( ...
				testCase.frames.fr5.triad(2).coords, ...
				[0; 1; 0], ...
				AbsTol = 1e-15);
			testCase.verifyEqual( ...
				testCase.frames.fr5.triad(3).coords, ...
				[1; 0; 0], ...
				AbsTol = 1e-15);
			testCase.verifyEqual( ...
				testCase.frames.fr5.orien.coords, ...
				[0, 0, 1; 0, 1, 0; -1, 0, 0], ...
				AbsTol = 1e-15);

			testCase.verifyEqual( ...
				unique([testCase.frames.fr6.triad.ref]), ...
				testCase.frames.fr3);
			testCase.verifyEqual( ...
				testCase.frames.fr6.triad(1).coords, ...
				[1; 0; 0], ...
				AbsTol = 1e-15);
			testCase.verifyEqual( ...
				testCase.frames.fr6.triad(2).coords, ...
				[0; 0; 1], ...
				AbsTol = 1e-15);
			testCase.verifyEqual( ...
				testCase.frames.fr6.triad(3).coords, ...
				[0; -1; 0;], ...
				AbsTol = 1e-15);
			testCase.verifyEqual( ...
				testCase.frames.fr6.orien.coords, ...
				[1, 0, 0; 0, 0, -1; 0, 1, 0], ...
				AbsTol = 1e-15);
		end


		function testDefaultObject(testCase)
			frDefault = Frame();
			testCase.verifyEqual(frDefault.name, "Default Frame");
			testCase.verifyEqual(frDefault.origin.coords, [0;0;0]);
			testCase.verifyEqual(frDefault.orien.angles, [0;0;0]);
			testCase.verifyEqual(frDefault.orien.seqID, "321");
			testCase.verifyEqual(frDefault.ref, World.getWorld());

			frArrayDefault(5) = Frame( ...
				"TestArray", ...
				Point([1;2;3], testCase.frames.world), ...
				Orien([pi/4; pi/4; pi/4], "321", testCase.frames.world), ...
				testCase.frames.world);
			testCase.verifyEqual(frArrayDefault(5).name, "TestArray");
			testCase.verifyEqual(frArrayDefault(1).name, "Default Frame");
			testCase.verifyEqual(frArrayDefault(2).name, "Default Frame");
			testCase.verifyNotSameHandle( ...
				frArrayDefault(1), ...
				frArrayDefault(2));
		end


	function testTranslate(testCase)
		% Create local copies to avoid modifying fixture
		fr1Copy = copy(testCase.frames.fr1);
		fr3Copy = copy(testCase.frames.fr3);
		
		vec = Vector([1; 2; 3], fr1Copy.ref);
		testCase.verifyEqual( ...
			fr1Copy.translate(vec).origin.coords, ...
			[2;3;4]);
		testCase.verifyEqual( ...
			fr3Copy.translate(vec).origin.coords, ...
			[4;5;6]);
		testCase.verifySameHandle( ...
			fr1Copy.translate(vec), ...
			fr1Copy);
		testCase.verifyNotSameHandle( ...
			fr3Copy.translateNew("newID", vec), ...
			fr3Copy);
		testCase.verifyEqual( ...
			fr3Copy.translateNew("newID2", vec).name, ...
			"newID2");
	end
	function testRotate(testCase)
		% Create local copy to avoid modifying fixture
		fr3Copy = copy(testCase.frames.fr3);
		
		fr3rot = fr3Copy.rotate( ...
			testCase.frames.fr1.origin.resolveInWorld(), ...
			Orien([pi/2; 0; 0], "321", testCase.frames.world));

		% Verify the rotation occurred
		testCase.verifyNotEqual(fr3rot.origin.coords, [3;3;3]);
		testCase.verifySameHandle(fr3rot, fr3Copy);
	end
		function testCopy(testCase)
			fr1copy = copy(testCase.frames.fr1);

			testCase.verifyNotSameHandle(fr1copy, testCase.frames.fr1);
			testCase.verifyEqual(fr1copy.name, testCase.frames.fr1.name);
		testCase.verifyEqual(fr1copy.origin, testCase.frames.fr1.origin);
		testCase.verifyEqual(fr1copy.orien, testCase.frames.fr1.orien);
		
		% After copy, verify the copy is independent
		testCase.verifyNotSameHandle(fr1copy, testCase.frames.fr1);
		
		% Original frame still has its ref
		testCase.verifyEqual(testCase.frames.fr1.ref, testCase.frames.world);
	end
		function testCopyWithChildren(testCase)
			% Test that copying a frame deep-copies all its children
			% and updates their parent references correctly
			
			% Create a parent with two children
			parent = Frame("Parent", ...
				Point([1; 0; 0], testCase.frames.world), ...
				Orien([0; 0; 0], "321", testCase.frames.world), ...
				testCase.frames.world);
			child1 = Frame("Child1", ...
				Point([0; 1; 0], parent), ...
				Orien([0; 0; 0], "321", parent), ...
				parent);
			child2 = Frame("Child2", ...
				Point([0; 0; 1], parent), ...
				Orien([0; 0; 0], "321", parent), ...
				parent);
			
			% Verify parent has two children
			testCase.verifyEqual(numel(parent.children), 2);
			
			% Copy the parent
			parentCopy = copy(parent);
			
			% Verify the copy has the same number of children
			testCase.verifyEqual(numel(parentCopy.children), 2);
			
			% Verify children are different objects (deep copy)
			testCase.verifyNotSameHandle(parentCopy.children(1), child1);
			testCase.verifyNotSameHandle(parentCopy.children(2), child2);
			
			% Verify copied children point to copied parent
			testCase.verifySameHandle(parentCopy.children(1).parent, parentCopy);
			testCase.verifySameHandle(parentCopy.children(2).parent, parentCopy);
			
			% Verify original children still point to original parent
			testCase.verifySameHandle(child1.parent, parent);
			testCase.verifySameHandle(child2.parent, parent);
			
			% Verify children have same properties
			testCase.verifyEqual(parentCopy.children(1).name, child1.name);
			testCase.verifyEqual(parentCopy.children(2).name, child2.name);
		end


		function testCopyWithGrandchildren(testCase)
			% Test that copying recursively copies the entire subtree
			
			% Create a three-level hierarchy
			grandparent = Frame("Grandparent", ...
				Point([1; 0; 0], testCase.frames.world), ...
				Orien([0; 0; 0], "321", testCase.frames.world), ...
				testCase.frames.world);
			parent = Frame("Parent", ...
				Point([0; 1; 0], grandparent), ...
				Orien([0; 0; 0], "321", grandparent), ...
				grandparent);
			child = Frame("Child", ...
				Point([0; 0; 1], parent), ...
				Orien([0; 0; 0], "321", parent), ...
				parent);
			
			% Copy the grandparent
			gpCopy = copy(grandparent);
			
			% Verify the entire tree is copied
			testCase.verifyEqual(numel(gpCopy.children), 1);
			testCase.verifyEqual(numel(gpCopy.children(1).children), 1);
			
			% Verify grandchild is a different object
			testCase.verifyNotSameHandle( ...
				gpCopy.children(1).children(1), child);
			
			% Verify parent-child links throughout the tree
			testCase.verifySameHandle( ...
				gpCopy.children(1).parent, gpCopy);
			testCase.verifySameHandle( ...
				gpCopy.children(1).children(1).parent, gpCopy.children(1));
			
			% Verify original tree is unchanged
			testCase.verifySameHandle(parent.parent, grandparent);
			testCase.verifySameHandle(child.parent, parent);
			
			% Verify properties are preserved
			testCase.verifyEqual(gpCopy.children(1).name, "Parent");
			testCase.verifyEqual(gpCopy.children(1).children(1).name, "Child");
		end


		function testCopyIndependence(testCase)
			% Test that modifying the copy doesn't affect the original
			
			parent = Frame("Parent", ...
				Point([1; 0; 0], testCase.frames.world), ...
				Orien([0; 0; 0], "321", testCase.frames.world), ...
				testCase.frames.world);
			child = Frame("Child", ...
				Point([0; 1; 0], parent), ...
				Orien([0; 0; 0], "321", parent), ...
				parent);
			
			parentCopy = copy(parent);
			
			% Modify the copied child
			parentCopy.children(1).origin = Point([5; 5; 5], parentCopy);
			
			% Verify original is unchanged
			testCase.verifyNotEqual( ...
				child.origin.coords, [5; 5; 5]);
			testCase.verifyEqual( ...
				child.origin.coords, [0; 1; 0]);
			
			% Verify copy is changed
			testCase.verifyEqual( ...
				parentCopy.children(1).origin.coords, [5; 5; 5]);
		end


		function testProjectFrame(testCase)
			% Test projecting frame origin to coordinate planes/axes
			fr = Frame("TestFrame", ...
				Point([3; 4; 5], testCase.frames.world), ...
				Orien([0; 0; 0], "321", testCase.frames.world), ...
				testCase.frames.world);
			
			% Project to X axis (modifies in place)
			frProj1 = fr.project("1");
			testCase.verifyEqual(frProj1.origin.coords, [3; 0; 0]);
			testCase.verifySameHandle(frProj1, fr);
			
			% Reset and project to Y axis
			fr.origin = Point([3; 4; 5], testCase.frames.world);
			frProj2 = fr.project("2");
			testCase.verifyEqual(frProj2.origin.coords, [0; 4; 0]);
			
			% Reset and project to Z axis
			fr.origin = Point([3; 4; 5], testCase.frames.world);
			frProj3 = fr.project("3");
			testCase.verifyEqual(frProj3.origin.coords, [0; 0; 5]);
			
			% Reset and project to XY plane
			fr.origin = Point([3; 4; 5], testCase.frames.world);
			frProj12 = fr.project("12");
			testCase.verifyEqual(frProj12.origin.coords, [3; 4; 0]);
			
			% Reset and project to XZ plane
			fr.origin = Point([3; 4; 5], testCase.frames.world);
			frProj13 = fr.project("13");
			testCase.verifyEqual(frProj13.origin.coords, [3; 0; 5]);
			
			% Reset and project to YZ plane
			fr.origin = Point([3; 4; 5], testCase.frames.world);
			frProj23 = fr.project("23");
			testCase.verifyEqual(frProj23.origin.coords, [0; 4; 5]);
		end


		function testProjectNewFrame(testCase)
			% Test creating new projected frame without modifying original
			fr = Frame("OriginalFrame", ...
				Point([3; 4; 5], testCase.frames.world), ...
				Orien([pi/4; 0; 0], "321", testCase.frames.world), ...
				testCase.frames.world);
			
			% Create projected frame to XY plane
			frNew = fr.projectNew("ProjectedFrame", "12");
			
			% Verify new frame is created
			testCase.verifyNotSameHandle(frNew, fr);
			testCase.verifyEqual(frNew.name, "ProjectedFrame");
			testCase.verifyEqual(frNew.origin.coords, [3; 4; 0]);
			testCase.verifyEqual(frNew.ref, fr);
			
			% Verify original frame is unchanged
			testCase.verifyEqual(fr.origin.coords, [3; 4; 5]);
			testCase.verifyEqual(fr.name, "OriginalFrame");
			testCase.verifyEqual(fr.ref, testCase.frames.world);
			
			% Verify new frame is child of original
			testCase.verifyTrue(frNew.isChildOf(fr));
			
			% Test projection to different planes
			frNewX = fr.projectNew("ProjectedX", "1");
			testCase.verifyEqual(frNewX.origin.coords, [3; 0; 0]);
			
			frNewYZ = fr.projectNew("ProjectedYZ", "23");
			testCase.verifyEqual(frNewYZ.origin.coords, [0; 4; 5]);
		end


		function testResolveInFrame(testCase)
			% Test resolveIn with same frame (should not change)
			fr4Copy = copy(testCase.frames.fr4);
			fr4InFr4 = fr4Copy.resolveIn(testCase.frames.fr4);
			testCase.verifyEqual(fr4InFr4.origin.coords, [0; 0; 0]);
			testCase.verifyEqual(fr4InFr4.ref, testCase.frames.fr4);
			
			% Test resolveIn with parent frame
			fr4Copy2 = copy(testCase.frames.fr4);
			fr4InFr3 = fr4Copy2.resolveIn(testCase.frames.fr3);
			testCase.verifyEqual(fr4InFr3.origin.coords, [0; 0; 0]);
			testCase.verifyEqual(fr4InFr3.ref, testCase.frames.fr3);
			
			% Test resolveIn with sibling frame
			fr4Copy3 = copy(testCase.frames.fr4);
			fr4InFr5 = fr4Copy3.resolveIn(testCase.frames.fr5);
			testCase.verifyEqual(fr4InFr5.ref, testCase.frames.fr5);
			% Both fr4 and fr5 have origin at fr3, so resolved should be at origin
			testCase.verifyEqual( ...
				fr4InFr5.origin.coords, ...
				[0; 0; 0], ...
				AbsTol = 1e-15);
			
			% Test that resolveIn changes the reference frame
			% Note: copy() sets ref to World, so create a new frame
			frTemp = Frame("TempFrame", ...
				Point([1; 2; 3], testCase.frames.fr3), ...
				Orien([0; 0; 0], "321", testCase.frames.fr3), ...
				testCase.frames.fr3);
			testCase.verifyEqual(frTemp.ref, testCase.frames.fr3);
			frTemp.resolveIn(testCase.frames.world);
			testCase.verifyEqual(frTemp.ref, testCase.frames.world);
		end


		function testResolveInFrameWithRotation(testCase)
			% Test that resolveIn correctly transforms orientation
			frRot = Frame("RotatedFrame", ...
				Point([0; 0; 0], testCase.frames.fr3), ...
				Orien([0; 0; pi/2], "321", testCase.frames.fr3), ...
				testCase.frames.fr3);
			
			frRotInWorld = frRot.resolveIn(testCase.frames.world);
			
			% Verify orientation is correctly transformed
			% fr3 has rotation [0; 0; 0] and frRot adds [0; 0; pi/2]
			testCase.verifyEqual( ...
				frRotInWorld.orien.angles, ...
				[0; 0; pi/2], ...
				AbsTol = 1e-15);
			testCase.verifyEqual(frRotInWorld.ref, testCase.frames.world);
		end


		function testResolveInFrameComplexHierarchy(testCase)
			% Test with the existing hierarchy World -> fr3 -> fr4
			% Create copies to avoid modifying test fixtures
			
			% Test that orientation is correctly transformed
			fr4Copy = copy(testCase.frames.fr4);
			fr4Copy.resolveIn(testCase.frames.world);
			testCase.verifyEqual(fr4Copy.ref, testCase.frames.world);
			testCase.verifyEqual( ...
				fr4Copy.orien.angles, ...
				[pi/2; 0; 0], ...
				AbsTol = 1e-15);
			
			% Test sibling frame resolution
			fr5Copy = copy(testCase.frames.fr5);
			fr5Copy.resolveIn(testCase.frames.fr4);
			testCase.verifyEqual(fr5Copy.ref, testCase.frames.fr4);
			
			% Test that origin remains at parent location when both have same 
			% origin
			fr6Copy = copy(testCase.frames.fr6);
			fr6Copy.resolveIn(testCase.frames.fr3);
		testCase.verifyEqual(fr6Copy.origin.coords, [0; 0; 0]);
		testCase.verifyEqual(fr6Copy.ref, testCase.frames.fr3);
	end


	function testAxesProperty(testCase)
		% Test that the axes property returns correct Line objects
		axes = testCase.frames.fr4.axes;
		
		% Verify we get 3 axes
		testCase.verifyEqual(numel(axes), 3);
		
		% Verify all axes are Line objects
		testCase.verifyClass(axes(1), "Line");
		testCase.verifyClass(axes(2), "Line");
		testCase.verifyClass(axes(3), "Line");
		
		% Verify axes pass through the frame origin
		testCase.verifyEqual(axes(1).anchor, testCase.frames.fr4.origin);
		testCase.verifyEqual(axes(2).anchor, testCase.frames.fr4.origin);
		testCase.verifyEqual(axes(3).anchor, testCase.frames.fr4.origin);
		
		% Verify axes directions match frame triad vectors
		testCase.verifyEqual(axes(1).direc, testCase.frames.fr4.triad(1));
		testCase.verifyEqual(axes(2).direc, testCase.frames.fr4.triad(2));
		testCase.verifyEqual(axes(3).direc, testCase.frames.fr4.triad(3));
		
		% Test with a frame at non-origin position
		axes_fr3 = testCase.frames.fr3.axes;
		% All axes should pass through the frame origin
		testCase.verifyEqual(axes_fr3(1).anchor, testCase.frames.fr3.origin);
		testCase.verifyEqual(axes_fr3(2).anchor, testCase.frames.fr3.origin);
		testCase.verifyEqual(axes_fr3(3).anchor, testCase.frames.fr3.origin);
	end


	function testAxesWithRotatedFrame(testCase)
		% Test axes property for rotated frames
		% fr4 is rotated 90° about X relative to fr3
		axes4 = testCase.frames.fr4.axes;
		
		% The axes should be rotated according to fr4's orientation
		% Verify the axes are in the correct reference frame
		testCase.verifyEqual(axes4(1).direc.ref, testCase.frames.fr3);
		testCase.verifyEqual(axes4(2).direc.ref, testCase.frames.fr3);
		testCase.verifyEqual(axes4(3).direc.ref, testCase.frames.fr3);
		
		% Verify directions match the rotated triad
		testCase.verifyEqual( ...
			axes4(1).direc.coords, ...
			[0; 1; 0], ...
			AbsTol = 1e-15);
		testCase.verifyEqual( ...
			axes4(2).direc.coords, ...
			[-1; 0; 0], ...
			AbsTol = 1e-15);
		testCase.verifyEqual( ...
			axes4(3).direc.coords, ...
			[0; 0; 1], ...
			AbsTol = 1e-15);
	end


	function testRotateFrameAroundLine(testCase)
		% Test rotating a frame around a line
		% Create a frame to rotate
		fr = Frame("TestRotFrame", ...
			Point([2; 0; 0], testCase.frames.world), ...
			Orien([0; 0; 0], "321", testCase.frames.world), ...
			testCase.frames.world);
		
		% Create a line along Z axis through origin
		lineZ = Line( ...
			Point([0; 0; 0], testCase.frames.world), ...
			Vector([0; 0; 1], testCase.frames.world));
		
		% Rotate 90° around the Z axis
		fr.rotate(lineZ, pi/2);
		
		% After 90° rotation about Z, point [2; 0; 0] should go to [0; 2; 0]
		testCase.verifyEqual( ...
			fr.origin.coords, ...
			[0; 2; 0], ...
			AbsTol = 1e-15);
		
		% Orientation should also be rotated 90° about Z
		% The angles depend on the euler sequence and may differ
		testCase.verifyEqual( ...
			fr.orien.angles(1), ...
			pi/2, ...
			AbsTol = 1e-12);
	end


	function testRotateFrameAroundLineWithOffset(testCase)
		% Test rotating around a line that doesn't pass through origin
		fr = Frame("TestFrame2", ...
			Point([3; 0; 0], testCase.frames.world), ...
			Orien([0; 0; 0], "321", testCase.frames.world), ...
			testCase.frames.world);
		
		% Create a line along Z axis through [1; 0; 0]
		lineZ = Line( ...
			Point([1; 0; 0], testCase.frames.world), ...
			Vector([0; 0; 1], testCase.frames.world));
		
		% Rotate 90° around this line
		fr.rotate(lineZ, pi/2);
		
		% Point [3; 0; 0] is at distance 2 from line at [1; 0; 0]
		% After 90° rotation, it should be at [1; 2; 0]
		testCase.verifyEqual( ...
			fr.origin.coords, ...
			[1; 2; 0], ...
			AbsTol = 1e-15);
	end


	function testRotateFrameAroundLineNegativeAngle(testCase)
		% Test rotation with negative angle
		fr = Frame("TestFrame3", ...
			Point([0; 2; 0], testCase.frames.world), ...
			Orien([0; 0; 0], "321", testCase.frames.world), ...
			testCase.frames.world);
		
		% Line along Z axis through origin
		lineZ = Line( ...
			Point([0; 0; 0], testCase.frames.world), ...
			Vector([0; 0; 1], testCase.frames.world));
		
		% Rotate -90° (clockwise when looking down Z axis)
		fr.rotate(lineZ, -pi/2);
		
		% [0; 2; 0] should go to [2; 0; 0]
		testCase.verifyEqual( ...
			fr.origin.coords, ...
			[2; 0; 0], ...
			AbsTol = 1e-15);
		
		% Verify orientation changed (exact angles depend on euler sequence)
		testCase.verifyEqual( ...
			fr.orien.angles(1), ...
			-pi/2, ...
			AbsTol = 1e-12);
	end


	function testRotateFrameAroundDifferentAxes(testCase)
		% Test rotating around X and Y axes
		% Rotate around X axis
		frX = Frame("TestFrameX", ...
			Point([0; 2; 0], testCase.frames.world), ...
			Orien([0; 0; 0], "321", testCase.frames.world), ...
			testCase.frames.world);
		
		lineX = Line( ...
			Point([0; 0; 0], testCase.frames.world), ...
			Vector([1; 0; 0], testCase.frames.world));
		
		frX.rotate(lineX, pi/2);
		
		% [0; 2; 0] rotated 90° about X should go to [0; 0; 2]
		testCase.verifyEqual( ...
			frX.origin.coords, ...
			[0; 0; 2], ...
			AbsTol = 1e-15);
		
		% Rotate around Y axis
		frY = Frame("TestFrameY", ...
			Point([2; 0; 0], testCase.frames.world), ...
			Orien([0; 0; 0], "321", testCase.frames.world), ...
			testCase.frames.world);
		
		lineY = Line( ...
			Point([0; 0; 0], testCase.frames.world), ...
			Vector([0; 1; 0], testCase.frames.world));
		
		frY.rotate(lineY, pi/2);
		
		% [2; 0; 0] rotated 90° about Y should go to [0; 0; -2]
		testCase.verifyEqual( ...
			frY.origin.coords, ...
			[0; 0; -2], ...
			AbsTol = 1e-15);
	end


	function testRotateFrameAroundLinePreservesRef(testCase)
		% Test that rotating around a line preserves the reference frame
		fr = Frame("TestFrameRef", ...
			Point([1; 0; 0], testCase.frames.fr1), ...
			Orien([0; 0; 0], "321", testCase.frames.fr1), ...
			testCase.frames.fr1);
		
		originalRef = fr.ref;
		
		lineZ = Line( ...
			Point([0; 0; 0], testCase.frames.fr1), ...
			Vector([0; 0; 1], testCase.frames.fr1));
		
		fr.rotate(lineZ, pi/4);
		
	% Reference frame should remain unchanged
	testCase.verifyEqual(fr.ref, originalRef);
	testCase.verifyEqual(fr.ref, testCase.frames.fr1);
end


function testRotateNewFrameAroundLine(testCase)
	% Test rotateNew method with a Line
	fr = Frame("OriginalFrame", ...
		Point([2; 0; 0], testCase.frames.world), ...
		Orien([0; 0; 0], "321", testCase.frames.world), ...
		testCase.frames.world);
	
	lineZ = Line( ...
		Point([0; 0; 0], testCase.frames.world), ...
		Vector([0; 0; 1], testCase.frames.world));
	
	% Create new rotated frame using Line and angle
	frNew = fr.rotateNew("RotatedFrame", lineZ, pi/2);
	
	% Verify new frame is created
	testCase.verifyNotSameHandle(frNew, fr);
	testCase.verifyEqual(frNew.name, "RotatedFrame");
	
	% Verify rotation applied to new frame
	testCase.verifyEqual( ...
		frNew.origin.coords, ...
		[0; 2; 0], ...
		AbsTol = 1e-15);
	
	% Verify original frame unchanged
	testCase.verifyEqual(fr.origin.coords, [2; 0; 0]);
	testCase.verifyEqual(fr.orien.angles, [0; 0; 0]);
	
	% Verify new frame is child of original
	testCase.verifyTrue(frNew.isChildOf(fr));
end


function testRotateNewFrameAroundPoint(testCase)
	% Test rotateNew method with a Point and Orien (original behavior)
	fr = Frame("OriginalFrame", ...
		Point([3; 3; 3], testCase.frames.world), ...
		Orien([0; 0; 0], "321", testCase.frames.world), ...
		testCase.frames.world);
	
	p0 = Point([1; 1; 1], testCase.frames.world);
	orien = Orien([pi/2; 0; 0], "321", testCase.frames.world);
	
	% Create new rotated frame using Point and Orien
	frNew = fr.rotateNew("RotatedFrame", p0, orien);
	
	% Verify new frame is created
	testCase.verifyNotSameHandle(frNew, fr);
	testCase.verifyEqual(frNew.name, "RotatedFrame");
	
	% Verify original frame unchanged
	testCase.verifyEqual(fr.origin.coords, [3; 3; 3]);
	testCase.verifyEqual(fr.orien.angles, [0; 0; 0]);
	
	% Verify new frame is child of original
	testCase.verifyTrue(frNew.isChildOf(fr));
end

	end
	
end