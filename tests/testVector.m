classdef testVector < matlab.unittest.TestCase

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

	%%
	methods (Test)

		function testCreateArrayOfVectors(testCase)
			numVectors = 5;
			vectorsArray = Vector.empty(numVectors,0);
			for i = 1:numVectors
				vectorsArray(i) = Vector(rand(3,1), testCase.frames.world);
			end
			testCase.verifyEqual(length(vectorsArray), numVectors);

			vectorsArrayDefault(5) = Vector(rand(3,1), testCase.frames.world);
			testCase.verifyEqual(vectorsArrayDefault(1).coords, [0; 0; 0])
			testCase.verifyEqual( ...
				vectorsArrayDefault(1).ref.name, ...
				"World")
			testCase.verifyEqual( ...
				vectorsArrayDefault(2).ref.name, ...
				"World")
		end


		function testRotate(testCase)
			v0 = Vector([1; 0; 0], testCase.frames.fr3);
			v4 = Vector([1; 0; 0], testCase.frames.fr4);

			testCase.verifyEqual( ...
				v0.rotate( ...
				Orien([pi/2; 0; 0], "321", testCase.frames.fr3)).coords, ...
				[0; 1; 0], ...
				AbsTol = 1e-15);
			testCase.verifyEqual( ...
				v0.rotate( ...
				Orien([0; pi/2; 0], "321", testCase.frames.fr3)).coords, ...
				[0; 0; -1], ...
				AbsTol = 1e-15);
			testCase.verifyEqual( ...
				v0.rotate( ...
				Orien([0; 0; pi/2], "321", testCase.frames.fr3)).coords, ...
				[1; 0; 0], ...
				AbsTol = 1e-15);
			testCase.verifyEqual( ...
				v4.rotate( ...
				Orien([-pi/2; 0; 0], "321", testCase.frames.fr3)).coords, ...
				[0; -1; 0], ...
				AbsTol = 1e-15);
		end


		function testResolveInParent(testCase)
			% Test resolving vector from child to parent frame
			v1 = Vector([1; 0; 0], testCase.frames.fr6);
			v1Parent = v1.resolveInParent();
			testCase.verifyEqual( ...
				v1Parent.coords, ...
				[1; 0; 0], ...
				AbsTol = 1e-15);
			testCase.verifyEqual(v1Parent.ref, testCase.frames.fr3);

			% Test with rotated frame
			v2 = Vector([1; 0; 0], testCase.frames.fr5);
			v2Parent = v2.resolveInParent();
			testCase.verifyEqual( ...
				v2Parent.coords, ...
				[0; 0; -1], ...
				AbsTol = 1e-15);
			testCase.verifyEqual(v2Parent.ref, testCase.frames.fr3);

			% Verify original vector unchanged
			testCase.verifyEqual(v1.coords, [1; 0; 0]);
			testCase.verifyEqual(v1.ref, testCase.frames.fr6);
		end


		function testResolveInChild(testCase)
			% Test resolving vector from parent to child frame
			v0 = Vector([1; 0; 0], testCase.frames.fr3);
			v0Child = v0.resolveInChild(testCase.frames.fr6);
			testCase.verifyEqual( ...
				v0Child.coords, ...
				[1; 0; 0], ...
				AbsTol = 1e-15);
			testCase.verifyEqual(v0Child.ref, testCase.frames.fr6);

			% Test with rotated frame
			v0Child2 = v0.resolveInChild(testCase.frames.fr5);
			testCase.verifyEqual( ...
				v0Child2.coords, ...
				[0; 0; 1], ...
				AbsTol = 1e-15);
			testCase.verifyEqual(v0Child2.ref, testCase.frames.fr5);

			% Verify original vector unchanged
			testCase.verifyEqual(v0.coords, [1; 0; 0]);
			testCase.verifyEqual(v0.ref, testCase.frames.fr3);
		end


		function testResolveIn(testCase)
			% Test resolveIn with parent frame
			v1 = Vector([1; 1; 0], testCase.frames.fr6);
			v1InParent = v1.resolveIn(testCase.frames.fr3);
			testCase.verifyEqual( ...
				v1InParent.coords, ...
				[1; 0; 1], ...
				AbsTol = 1e-15);
			testCase.verifyEqual(v1InParent.ref, testCase.frames.fr3);

			% Test resolveIn with child frame
			v0 = Vector([1; 0; 0], testCase.frames.fr3);
			v0InChild = v0.resolveIn(testCase.frames.fr4);
			testCase.verifyEqual( ...
				v0InChild.coords, ...
				[0; -1; 0], ...
				AbsTol = 1e-15);
			testCase.verifyEqual(v0InChild.ref, testCase.frames.fr4);

			% Test resolveIn with ancestor (World)
			v2 = Vector([1; 0; 0], testCase.frames.fr5);
			v2InWorld = v2.resolveIn(testCase.frames.world);
			testCase.verifyEqual( ...
				v2InWorld.coords, ...
				[0; 0; -1], ...
				AbsTol = 1e-15);
			testCase.verifyEqual(v2InWorld.ref, testCase.frames.world);

			% Test resolveIn with sibling (different branch)
			v1 = Vector([1; 0; 0], testCase.frames.fr6);
			v1In2 = v1.resolveIn(testCase.frames.fr5);
			testCase.verifyEqual( ...
				v1In2.coords, ...
				[0; 0; 1], ...
				AbsTol = 1e-15);
			testCase.verifyEqual(v1In2.ref, testCase.frames.fr5);
		end


		function testResolveInWorld(testCase)
			% Test resolveInWorld from various frames
			v1 = Vector([1; 1; 1], testCase.frames.fr6);
			v1World = v1.resolveInWorld();
			testCase.verifyEqual( ...
				v1World.coords, ...
				[1; -1; 1], ...
				AbsTol = 1e-15);
			testCase.verifyEqual(v1World.ref, testCase.frames.world);

			v3 = Vector([1; 0; 0], testCase.frames.fr4);
			v3World = v3.resolveInWorld();
			testCase.verifyEqual( ...
				v3World.coords, ...
				[0; 1; 0], ...
				AbsTol = 1e-15);
			testCase.verifyEqual(v3World.ref, testCase.frames.world);
		end


		function testPlusOperator(testCase)
			% Test adding vectors in same frame
			v1 = Vector([1; 2; 3], testCase.frames.world);
			v2 = Vector([4; 5; 6], testCase.frames.world);
			v3 = v1 + v2;
			testCase.verifyEqual(v3.coords, [5; 7; 9]);
			testCase.verifyEqual(v3.ref, testCase.frames.world);

			% Test adding vectors in different frames
			v4 = Vector([1; 0; 0], testCase.frames.fr3);
			v5 = Vector([1; 0; 0], testCase.frames.fr6);
			v6 = v4 + v5;
			testCase.verifyEqual( ...
				v6.coords, ...
				[2; 0; 0], ...
				AbsTol = 1e-15);
			testCase.verifyEqual(v6.ref, testCase.frames.fr3);

			% Verify originals unchanged
			testCase.verifyEqual(v1.coords, [1; 2; 3]);
			testCase.verifyEqual(v4.coords, [1; 0; 0]);
		end


		function testMinusOperator(testCase)
			% Test subtracting vectors in same frame
			v1 = Vector([5; 7; 9], testCase.frames.world);
			v2 = Vector([1; 2; 3], testCase.frames.world);
			v3 = v1 - v2;
			testCase.verifyEqual(v3.coords, [4; 5; 6]);
			testCase.verifyEqual(v3.ref, testCase.frames.world);

			% Test subtracting vectors in different frames
			v4 = Vector([2; 0; 0], testCase.frames.fr3);
			v5 = Vector([1; 0; 0], testCase.frames.fr6);
			v6 = v4 - v5;
			testCase.verifyEqual( ...
				v6.coords, ...
				[1; 0; 0], ...
				AbsTol = 1e-15);
			testCase.verifyEqual(v6.ref, testCase.frames.fr3);
		end


		function testUminusOperator(testCase)
			% Test unary minus operator
			v1 = Vector([3; 4; 5], testCase.frames.world);
			v2 = -v1;
			testCase.verifyEqual(v2.coords, [-3; -4; -5]);
			testCase.verifyEqual(v2.ref, testCase.frames.world);

			% Verify original unchanged
			testCase.verifyEqual(v1.coords, [3; 4; 5]);

			% Test with vector in different frame
			v3 = Vector([2; -3; 1], testCase.frames.fr6);
			v4 = -v3;
			testCase.verifyEqual(v4.coords, [-2; 3; -1]);
			testCase.verifyEqual(v4.ref, testCase.frames.fr6);
		end


		function testCrossProduct(testCase)
			% Test cross product in same frame
			v1 = Vector([1; 0; 0], testCase.frames.world);
			v2 = Vector([0; 1; 0], testCase.frames.world);
			v3 = cross(v1, v2);
			testCase.verifyEqual(v3.coords, [0; 0; 1]);
			testCase.verifyEqual(v3.ref, testCase.frames.world);

			% Test cross product properties
			v4 = cross(v2, v1);
			testCase.verifyEqual(v4.coords, [0; 0; -1]);

			% Test cross product in different frames
			v5 = Vector([1; 0; 0], testCase.frames.fr3);
			v6 = Vector([0; 1; 0], testCase.frames.fr6);
			v7 = cross(v5, v6);
			testCase.verifyEqual( ...
				v7.coords, ...
				[0; -1; 0], ...
				AbsTol = 1e-15);
			testCase.verifyEqual(v7.ref, testCase.frames.fr3);
		end


		function testDotProduct(testCase)
			% Test dot product in same frame
			v1 = Vector([1; 2; 3], testCase.frames.world);
			v2 = Vector([4; 5; 6], testCase.frames.world);
			scalar = dot(v1, v2);
			testCase.verifyEqual(scalar, 32);

			% Test dot product with orthogonal vectors
			v3 = Vector([1; 0; 0], testCase.frames.world);
			v4 = Vector([0; 1; 0], testCase.frames.world);
			scalar2 = dot(v3, v4);
			testCase.verifyEqual(scalar2, 0);

			% Test dot product in different frames
			v5 = Vector([1; 0; 0], testCase.frames.fr3);
			v6 = Vector([1; 0; 0], testCase.frames.fr5);
			scalar3 = dot(v5, v6);
			testCase.verifyEqual(scalar3, 0, AbsTol = 1e-15);
		end


		function testMtimesOperator(testCase)
			% Test scalar * vector
			v1 = Vector([1; 2; 3], testCase.frames.world);
			v2 = 3 * v1;
			testCase.verifyEqual(v2.coords, [3; 6; 9]);
			testCase.verifyEqual(v2.ref, testCase.frames.world);

			% Test vector * scalar
			v3 = v1 * 2;
			testCase.verifyEqual(v3.coords, [2; 4; 6]);
			testCase.verifyEqual(v3.ref, testCase.frames.world);

			% Test with negative scalar
			v4 = -2 * v1;
			testCase.verifyEqual(v4.coords, [-2; -4; -6]);

			% Verify original unchanged
			testCase.verifyEqual(v1.coords, [1; 2; 3]);
		end


		function testMrdivideOperator(testCase)
			% Test vector / scalar
			v1 = Vector([6; 9; 12], testCase.frames.world);
			v2 = v1 / 3;
			testCase.verifyEqual(v2.coords, [2; 3; 4]);
			testCase.verifyEqual(v2.ref, testCase.frames.world);

			% Test with different scalar
			v3 = v1 / 2;
			testCase.verifyEqual(v3.coords, [3; 4.5; 6]);
			testCase.verifyEqual(v3.ref, testCase.frames.world);

			% Test with negative scalar
			v4 = v1 / -3;
			testCase.verifyEqual(v4.coords, [-2; -3; -4]);

			% Test normalization (divide by magnitude)
			v5 = Vector([3; 4; 0], testCase.frames.world);
			v5_normalized = v5 / v5.magnitude;
			testCase.verifyEqual( ...
				v5_normalized.coords, ...
				[0.6; 0.8; 0], ...
				AbsTol = 1e-15);

			% Verify original unchanged
			testCase.verifyEqual(v1.coords, [6; 9; 12]);
		end


		function testProjectVector(testCase)
			v = Vector([3; 4; 5], testCase.frames.world);

			% Project to axis 1 (X)
			v1 = v.project("1");
			testCase.verifyEqual(v1.coords, [3; 0; 0]);
			testCase.verifyEqual(v1.ref, testCase.frames.world);

			% Project to axis 2 (Y)
			v2 = v.project("2");
			testCase.verifyEqual(v2.coords, [0; 4; 0]);

			% Project to axis 3 (Z)
			v3 = v.project("3");
			testCase.verifyEqual(v3.coords, [0; 0; 5]);

			% Project to plane 12 (XY)
			v12 = v.project("12");
			testCase.verifyEqual(v12.coords, [3; 4; 0]);

			% Project to plane 13 (XZ)
			v13 = v.project("13");
			testCase.verifyEqual(v13.coords, [3; 0; 5]);

			% Project to plane 23 (YZ)
			v23 = v.project("23");
			testCase.verifyEqual(v23.coords, [0; 4; 5]);

			% Verify original unchanged
			testCase.verifyEqual(v.coords, [3; 4; 5]);
		end


		function testProjectVectorOntoLine(testCase)
			% Test projection onto a line
			v = Vector([3; 4; 0], testCase.frames.world);

			% Create a line along X axis
			lineX = Line( ...
				Point([0; 0; 0], testCase.frames.world), ...
				Vector([1; 0; 0], testCase.frames.world));
			vProjX = v.project(lineX);
			testCase.verifyEqual( ...
				vProjX.coords, ...
				[3; 0; 0], ...
				AbsTol = 1e-15);

			% Create a line at 45 degrees in XY plane
			line45 = Line( ...
				Point([0; 0; 0], testCase.frames.world), ...
				Vector([1; 1; 0]/sqrt(2), testCase.frames.world));
			vProj45 = v.project(line45);
			testCase.verifyEqual( ...
				vProj45.coords, ...
				[3.5; 3.5; 0], ...
				AbsTol = 1e-15);
		end


		function testGetSkew(testCase)
			% Test skew-symmetric matrix generation
			v1 = Vector([1; 2; 3], testCase.frames.world);
			K1 = v1.skew;
			
			% Verify matrix structure
			expected1 = [0, -3, 2; 3, 0, -1; -2, 1, 0];
			testCase.verifyEqual(K1, expected1);
			
			% Verify skew-symmetry: K = -K'
			testCase.verifyEqual(K1, -K1', AbsTol = 1e-15);
			
			% Test that cross product equals matrix multiplication
			v2 = Vector([4; 5; 6], testCase.frames.world);
			crossResult = cross(v1, v2);
			matrixResult = K1 * v2.coords;
			testCase.verifyEqual( ...
				crossResult.coords, ...
				matrixResult, ...
				AbsTol = 1e-15);
			
			% Test with unit vectors
			vX = Vector([1; 0; 0], testCase.frames.world);
			KX = vX.skew;
			expectedX = [0, 0, 0; 0, 0, -1; 0, 1, 0];
			testCase.verifyEqual(KX, expectedX);
			
			vZ = Vector([0; 0; 1], testCase.frames.world);
			KZ = vZ.skew;
			expectedZ = [0, -1, 0; 1, 0, 0; 0, 0, 0];
			testCase.verifyEqual(KZ, expectedZ);
		end

	end

end
