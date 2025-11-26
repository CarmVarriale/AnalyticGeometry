classdef testOrien < matlab.unittest.TestCase

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

		function testCreateArrayOfOriens(testCase)
			numOriens = 5;
			oriensArray = Orien.empty(numOriens,0);
			for i = 1:numOriens
				oriensArray(i) = Orien(rand(3,1)*pi/2, "321", testCase.frames.fr1);
			end
			testCase.verifyEqual(length(oriensArray), numOriens);

			oriensArrayDefault(5) = Orien(rand(3,1)*pi/2, "321", testCase.frames.fr1);
			testCase.verifyEqual(oriensArrayDefault(1).coords, eye(3,3))
			testCase.verifyEqual( ...
				oriensArrayDefault(1).ref.name, ...
				"World")
			testCase.verifyEqual( ...
				oriensArrayDefault(2).ref.name, ...
				"World")
		end

		function testFromAnglesToDirCosMat(testCase)
			testCase.verifyEqual( ...
				Orien.getDirCosMat([pi/2; 0; 0], "321"), ...
				[0 1 0; -1 0 0; 0 0 1], ...
				AbsTol = 1e-15);
			testCase.verifyEqual( ...
				Orien.getDirCosMat([0; pi/2; 0], "321"), ...
				[0 0 -1; 0 1 0; 1 0 0], ...
				AbsTol = 1e-15);
			testCase.verifyEqual( ...
				Orien.getDirCosMat([0; 0; pi/2], "321"), ...
				[1 0 0; 0 0 1; 0 -1 0], ...
				AbsTol = 1e-15);
		end


		function testOrienProperties(testCase)
			% Test that angles, dirCosMat, and quat properties work correctly
			angles = [pi/4; pi/6; pi/3];
			o = Orien(angles, "321", testCase.frames.world);

			% Verify angles property returns correct values
			testCase.verifyEqual(o.angles, angles, AbsTol = 1e-12);

			% Verify dirCosMat is the transpose of coords
			testCase.verifyEqual(o.dirCosMat, o.coords', AbsTol = 1e-15);

			% Verify quat conversion and back
			q = o.quat;
			testCase.verifyClass(q, "quaternion");

			% Verify that converting back from quaternion gives same orientation
			oFromQuat = Orien(q.euler("ZYX", "frame")', "321", testCase.frames.world);
			testCase.verifyEqual(oFromQuat.coords, o.coords, AbsTol = 1e-12);
		end


		function testOrienWithDifferentSequences(testCase)
			% Test creating orientations with different angle sequences
			% Use multiple non-zero angles to ensure different sequences 
			% give different results
			angles = [pi/4; pi/6; pi/3];

			o321 = Orien(angles, "321", testCase.frames.world);
			testCase.verifyEqual(o321.seqID, "321");

			o123 = Orien(angles, "123", testCase.frames.world);
			testCase.verifyEqual(o123.seqID, "123");

			o313 = Orien(angles, "313", testCase.frames.world);
			testCase.verifyEqual(o313.seqID, "313");

			% Verify that different sequences give different direction cosine matrices
			testCase.verifyNotEqual(o321.coords, o123.coords);
			testCase.verifyNotEqual(o321.coords, o313.coords);
		end


		function testConvertSeqID(testCase)
			% Test converting orientation between different angle sequences
			angles = [pi/4; pi/6; pi/3];
			o321 = Orien(angles, "321", testCase.frames.world);
			originalCoords = o321.coords;

			% Convert to different sequence
			o123 = o321.convertSeqID("123");
			testCase.verifyEqual(o123.seqID, "123");

			% Verify that angles are different (different parameterization)
			testCase.verifyNotEqual(o123.angles, o321.angles);

			% Convert back to original sequence
			o321_back = o123.convertSeqID("321");
			testCase.verifyEqual(o321_back.seqID, "321");

			% Test that converting to same sequence ID does nothing
			o321_same = o321.convertSeqID("321");
			testCase.verifyEqual(o321_same.coords, originalCoords, AbsTol = 1e-15);
			testCase.verifyEqual(o321_same.angles, angles, AbsTol = 1e-15);
		end


		function testOrienRotate(testCase)
			% Test rotating an orientation (inherited from Tensor)
			o1 = Orien([0; 0; 0], "321", testCase.frames.world);
			oRot = Orien([pi/2; 0; 0], "321", testCase.frames.world);

			% Rotate identity orientation
			o2 = o1.rotate(oRot);
			testCase.verifyEqual(o2.angles, [pi/2; 0; 0], AbsTol = 1e-12);

			% Test composition of rotations
			o3 = Orien([pi/4; 0; 0], "321", testCase.frames.world);
			o4 = Orien([pi/4; 0; 0], "321", testCase.frames.world);
			o5 = o3.rotate(o4);
			testCase.verifyEqual(o5.angles(1), pi/2, AbsTol = 1e-12);
		end


		function testOrienResolveInParent(testCase)
			% Test resolving orientation in parent frame
			oChild = Orien([pi/4; 0; 0], "321", testCase.frames.fr2a);
			oParent = oChild.resolveInParent();

			% Verify reference frame changed to parent
			testCase.verifyEqual(oParent.ref, testCase.frames.fr1);

			% Verify original unchanged
			testCase.verifyEqual(oChild.ref, testCase.frames.fr2a);
		end


		function testOrienResolveInChild(testCase)
			% Test resolving orientation in child frame
			oParent = Orien([pi/4; 0; 0], "321", testCase.frames.fr1);
			oChild = oParent.resolveInChild(testCase.frames.fr2a);

			% Verify reference frame changed to child
			testCase.verifyEqual(oChild.ref, testCase.frames.fr2a);

			% Verify original unchanged
			testCase.verifyEqual(oParent.ref, testCase.frames.fr1);
		end


		function testOrienInDifferentFrames(testCase)
			% Test that orientations work correctly in different frames
			o1 = Orien([pi/2; 0; 0], "321", testCase.frames.world);
			o2 = Orien([0; pi/2; 0], "321", testCase.frames.fr1);
			o3 = Orien([0; 0; pi/2], "321", testCase.frames.fr3a);

			% Verify each has correct reference frame
			testCase.verifyEqual(o1.ref, testCase.frames.world);
			testCase.verifyEqual(o2.ref, testCase.frames.fr1);
			testCase.verifyEqual(o3.ref, testCase.frames.fr3a);

			% Verify angles are stored correctly
			testCase.verifyEqual(o1.angles, [pi/2; 0; 0], AbsTol = 1e-15);
			testCase.verifyEqual(o2.angles, [0; pi/2; 0], AbsTol = 1e-15);
			testCase.verifyEqual(o3.angles, [0; 0; pi/2], AbsTol = 1e-15);
		end


		function testOrienDefaultConstructor(testCase)
			% Test default constructor creates identity orientation in World
			o = Orien();

			testCase.verifyEqual(o.angles, [0; 0; 0], AbsTol = 1e-15);
			testCase.verifyEqual(o.seqID, "321");
			testCase.verifyEqual(o.ref.name, "World");
			testCase.verifyEqual(o.coords, eye(3), AbsTol = 1e-15);
		end


		function testOrienSetAngles(testCase)
			% Test setting angles property
			o = Orien([0; 0; 0], "321", testCase.frames.world);

			% Set new angles
			newAngles = [pi/4; pi/6; pi/3];
			o.angles = newAngles;

			% Verify angles updated
			testCase.verifyEqual(o.angles, newAngles, AbsTol = 1e-12);

			% Verify coords updated accordingly
			expectedCoords = Orien.getDirCosMat(newAngles, "321")';
			testCase.verifyEqual(o.coords, expectedCoords, AbsTol = 1e-12);
		end


		function testOrienDisp(testCase)
			% Test that disp method works without error
			o = Orien([pi/4; 0; 0], "321", testCase.frames.world);

			% Should not throw error
			testCase.verifyWarningFree(@() disp(o));

			% Test with array
			oArray(1) = Orien([pi/4; 0; 0], "321", testCase.frames.world);
			oArray(2) = Orien([0; pi/4; 0], "321", testCase.frames.fr1);
			testCase.verifyWarningFree(@() disp(oArray));

			% Test with empty
			oEmpty = Orien.empty;
			testCase.verifyWarningFree(@() disp(oEmpty));
		end

	end

end
