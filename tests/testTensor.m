classdef testTensor < matlab.unittest.TestCase

	properties

		frames
		fr0, fr1, fr2, fr3  % Additional frames specific to tensor tests
		I0, Irot1, Irot2, Irot3  % Tensor test objects

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

	methods (TestMethodSetup)

		function createObjects(testCase)
			% Create additional frames specific to tensor tests
			testCase.fr0 = Frame("Frame0", ...
				Point([0; 0; 0], testCase.frames.world), ...
				Orien([0; 0; 0], "321", testCase.frames.world), ...
				testCase.frames.world);

			testCase.fr1 = Frame("Frame1", ...
				Point([0; 0; 0], testCase.frames.world), ...
				Orien([atan(-0.5); 0; 0], "321", testCase.frames.world), ...
				testCase.frames.world);

			testCase.fr2 = Frame("Frame2", ...
				Point([0; 0; 0], testCase.frames.world), ...
				Orien([pi/2 + atan(-0.5); 0; 0], "321", testCase.frames.world), ...
				testCase.frames.world);

			testCase.fr3 = Frame("Frame3", ...
				Point([0; 0; 0], testCase.frames.world), ...
				Orien([pi/2; pi; pi/2], "321", testCase.frames.world), ...
				testCase.frames.world);

			% Inertia tensor of right triangle with base=2, height=1, mass=1
			% with respect to its vertex, in a frame with origin at the
			% triangle vertex, X axis along the base, Y axis along the height
			testCase.I0 = Tensor( ...
				[1/6, -1/6, 0; -1/6, 2/3, 0; 0, 0, 5/6], ...
				testCase.fr0);

			% Inertia tensor of right triangle with base=2, height=1, mass=1
			% with respect to its vertex, in a frame with origin at the
			% triangle vertex, X axis parallel to the hypotenuse, Y axis
			% pointing in the first quadrant
			testCase.Irot1 = Tensor( ...
				[2/5, -3/10, 0; -3/10 13/30, 0; 0, 0, 5/6], ...
				testCase.fr1);

			% Inertia tensor of right triangle with base=2, height=1, mass=1
			% with respect to its vertex, in a frame with origin at the
			% triangle vertex, X axis perpendicular to the hypotenuse and
			% pointing in the first quadrant
			testCase.Irot2 = Tensor( ...
				[13/30, 3/10, 0; 3/10, 2/5, 0; 0, 0, 5/6], ...
				testCase.fr2);

			% Inertia tensor of right triangle with base=2, height=1, mass=1
			% with respect to its vertex, in a frame with origin at the
			% triangle vertex, Z axis along the base, and X axis along the
			% height but opposite to it
			testCase.Irot3 = Tensor( ...
				[2/3, 0 1/6; 0 5/6 0; 1/6 0 1/6], ...
				testCase.fr3);
		end

	end

	%%
	methods (Test)

		function testCreateArrayOfTensors(testCase)
			numTensors = 5;
			tensorsArray = Tensor.empty(numTensors,0);
			for i = 1:numTensors
				tensorsArray(i) = Tensor(rand(3,3), testCase.frames.world);
			end
			testCase.verifyEqual(length(tensorsArray), numTensors);

			tensorsArrayDefault(5) = Tensor(rand(3,3), testCase.frames.world);
			testCase.verifyEqual(tensorsArrayDefault(1).coords, zeros(3,3))
			testCase.verifyEqual( ...
				tensorsArrayDefault(1).ref.name, ...
				"World")
			testCase.verifyEqual( ...
				tensorsArrayDefault(2).ref.name, ...
				"World")
		end


		function testRotate(testCase)
			o = Orien([0; 0; 0], "321", testCase.fr0);
			testCase.verifyEqual( ...
				o.rotate(Orien([pi/2; 0; 0], "321", testCase.fr0)).angles, ...
				[pi/2; 0; 0], ...
				AbsTol = 1e-15);
			testCase.verifyEqual( ...
				o.rotate(Orien([-pi/2; 0; 0], "321", testCase.fr0)).angles, ...
				[-pi/2; 0; 0], ...
				AbsTol = 1e-15);
			testCase.verifyEqual( ...
				o.rotate(Orien([0; pi; 0], "321", testCase.fr0)).angles, ...
				[pi; 0; pi], ...
				AbsTol = 1e-15);
			testCase.verifyEqual( ...
				o.rotate(Orien([0; -pi; 0], "321", testCase.fr0)).angles, ...
				[pi; 0; pi], ...
				AbsTol = 1e-15);
			testCase.verifyEqual( ...
				o.rotate(Orien([0; 0; -pi/2], "321", testCase.fr0)).angles, ...
				[0; 0; -pi/2], ...
				AbsTol = 1e-15);
			testCase.verifyEqual( ...
				o.rotate(Orien([pi/2; pi/2; pi/2], "321", testCase.fr0)).angles, ...
				[0; pi/2; 0], ...
				AbsTol = 1e-15);
			testCase.verifyEqual( ...
				o.rotate(Orien([pi/2; pi/2; 0], "321", testCase.fr0)).angles, ...
				[pi/2; pi/2; 0], ...
				AbsTol = 1e-15);
		end


		function testResolveInParent(testCase)
			% Test resolving tensor from child to parent frame
			% Create a child frame with rotation
			frChild = Frame("ChildFrame", ...
				Point([0; 0; 0], testCase.fr0), ...
				Orien([pi/2; 0; 0], "321", testCase.fr0), ...
				testCase.fr0);

			% Create a simple diagonal tensor in child frame
			T = Tensor(diag([1, 2, 3]), frChild);
			TParent = T.resolveInParent();

			% Verify frame reference
			testCase.verifyEqual(TParent.ref, testCase.fr0);

			% Verify tensor is rotated correctly
			% With 90 deg rotation about X, diagonal components reorder based on
			% axis transformation
			testCase.verifyEqual( ...
				TParent.coords, ...
				diag([2, 1, 3]), ...
				AbsTol = 1e-15);			% Verify original unchanged
			testCase.verifyEqual(T.coords, diag([1, 2, 3]));
			testCase.verifyEqual(T.ref, frChild);
		end


		function testResolveInChild(testCase)
			% Test resolving tensor from parent to child frame
			% Create a child frame with rotation
			frChild = Frame("ChildFrame", ...
				Point([0; 0; 0], testCase.fr0), ...
				Orien([pi/2; 0; 0], "321", testCase.fr0), ...
				testCase.fr0);

			% Create a diagonal tensor in parent frame
			T = Tensor(diag([1, 2, 3]), testCase.fr0);
			TChild = T.resolveInChild(frChild);

			% Verify frame reference (resolveInChild now sets ref to the child frame)
			testCase.verifyEqual(TChild.ref, frChild);
			testCase.verifyEqual( ...
				TChild.coords, ...
				diag([2, 1, 3]), ...
				AbsTol = 1e-15);			% Verify original unchanged
			testCase.verifyEqual(T.coords, diag([1, 2, 3]));
			testCase.verifyEqual(T.ref, testCase.fr0);
		end


		function testResolveIn(testCase)
			% Test resolveIn with parent frame
			T1 = Tensor(diag([1, 2, 3]), testCase.fr1);
			T1InParent = T1.resolveIn(testCase.frames.world);
			testCase.verifyEqual(T1InParent.ref, testCase.frames.world);

			% Test resolveIn with child frame
			T0 = Tensor(diag([1, 2, 3]), testCase.frames.world);
			T0InChild = T0.resolveIn(testCase.fr1);
			testCase.verifyEqual(T0InChild.ref, testCase.fr1);
			T_same = testCase.I0.resolveIn(testCase.fr0);
			testCase.verifyEqual( ...
				T_same.coords, ...
				testCase.I0.coords, ...
				AbsTol = 1e-15);

			% Test cross-frame resolution consistency
			% Irot1 in fr1, resolve to world, should equal I0 in fr0
			testCase.verifyEqual( ...
				testCase.Irot1.resolveIn(testCase.frames.world).coords, ...
				testCase.I0.resolveIn(testCase.frames.world).coords, ...
				AbsTol = 1e-12);
		end


		function testResolveInWorld(testCase)
			% Test resolveInWorld from various frames
			T1 = testCase.Irot1.resolveInWorld();
			testCase.verifyEqual(T1.ref, testCase.frames.world);
			testCase.verifyEqual( ...
				T1.coords, ...
				testCase.I0.coords, ...
				AbsTol = 1e-12);

			T2 = testCase.Irot2.resolveInWorld();
			testCase.verifyEqual(T2.ref, testCase.frames.world);
			testCase.verifyEqual( ...
				T2.coords, ...
				testCase.I0.coords, ...
				AbsTol = 1e-12);

			T3 = testCase.Irot3.resolveInWorld();
			testCase.verifyEqual(T3.ref, testCase.frames.world);
			testCase.verifyEqual( ...
				T3.coords, ...
				testCase.I0.coords, ...
				AbsTol = 1e-12);
		end


		function testTensorRotate(testCase)
			% Test rotating tensor with orientation
			T = Tensor(diag([1, 2, 3]), testCase.fr0);

			% Rotate 90 degrees about Z axis
			orienZ = Orien([0; 0; pi/2], "321", testCase.fr0);
			TRot = T.rotate(orienZ);

			% For diagonal tensor rotated 90 deg about Z, off-diagonal elements
			% may appear
			testCase.verifyEqual( ...
				TRot.coords, ...
				[1, 0, 0; 0, 0, -2; 0, 3, 0], ...
				AbsTol = 1e-15);			% Verify original unchanged
			testCase.verifyEqual(T.coords, diag([1, 2, 3]));

			% Test rotation with orientation in different frame
			orienWorld = Orien([pi/2; 0; 0], "321", testCase.frames.world);
			T2 = Tensor(diag([1, 2, 3]), testCase.fr0);
			T2Rot = T2.rotate(orienWorld);
			testCase.verifyEqual( ...
				T2Rot.coords, ...
				[0, -1, 0; 2, 0, 0; 0, 0, 3], ...
				AbsTol = 1e-15);
		end


		function testTensorTimesVector(testCase)
			% Test tensor * vector multiplication
			T = Tensor([1, 0, 0; 0, 2, 0; 0, 0, 3], testCase.frames.world);
			v = Vector([1; 1; 1], testCase.frames.world);

			result = T * v;
			testCase.verifyClass(result, "Vector");
			testCase.verifyEqual(result.coords, [1; 2; 3]);
			testCase.verifyEqual(result.ref, testCase.frames.world);

			% Test with vector in different frame
			frChild = Frame("ChildFrame", ...
				Point([0; 0; 0], testCase.frames.world), ...
				Orien([0; 0; 0], "321", testCase.frames.world), ...
				testCase.frames.world);
			v2 = Vector([2; 3; 4], frChild);
			result2 = T * v2;
			testCase.verifyEqual(result2.coords, [2; 6; 12]);
			testCase.verifyEqual(result2.ref, frChild);

			% Test with non-trivial tensor (inertia tensor)
			v3 = Vector([1; 0; 0], testCase.fr0);
			result3 = testCase.I0 * v3;
			testCase.verifyEqual( ...
				result3.coords, ...
				[1/6; -1/6; 0], ...
				AbsTol = 1e-15);
		end


		function testTensorTimesVectorWithRotation(testCase)
			% Test tensor * vector with frames that have different orientations
			frRot = Frame("RotFrame", ...
				Point([0; 0; 0], testCase.frames.world), ...
				Orien([0; 0; pi/2], "321", testCase.frames.world), ...
				testCase.frames.world);

			T = Tensor(diag([1, 2, 3]), testCase.frames.world);
			v = Vector([1; 0; 0], frRot);

			result = T * v;
			% v in frRot coords is [1; 0; 0], which stays [1; 0; 0] in world 
			% coords for this rotation
			% Result should be T * [1; 0; 0] = [1; 0; 0]
			testCase.verifyEqual( ...
				result.coords, ...
				[1; 0; 0], ...
				AbsTol = 1e-15);
		testCase.verifyEqual(result.ref, frRot);
	end

	end

end
