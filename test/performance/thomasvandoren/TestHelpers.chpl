/* Test helpers... */

use Assert;
use Random;
use Time;

// random seed for arrays
config const randSeed = SeedGenerator.currentTime;

// Control output.
config const printC = true,
  printElapsed = true;

// Make arrays bigger. E.g. set to 10 or 1000 or whatever to test bigger
// matrices.
config const scalingFactor = 1;

var randStream = new RandomStream(randSeed),
  timer: Timer;

const inner = 1..5 * scalingFactor,
  outerRows = 1..10 * scalingFactor,
  outerCols = 1..7 * scalingFactor;

// Assume C = A * B is the calculation.
var A: [outerRows, inner] int,
  B: [inner, outerCols] int,
  C: [outerRows, outerCols] int;

// Fill A and B with random values.
fillRandom(A);
fillRandom(B);

/* Fill int array with random values. */
proc fillRandom(ref A: [] int) {
  // Use serial loop so A filling is reproducible when seed is same.
  for a in A {
    a = (randStream.getNext() * A.size): int;
  }
}

/* Print C, C[7, 7], and elapsed time. */
proc printResults() {
  if printC then
    writeln(C);
  writeln("C[7, 7] = ", C[7, 7]);
  if printElapsed then
    writeln("Elapsed = ", timer.elapsed());
}

/* If not running with --fast (e.g. boundsChecking == true), ensure the array
   dimensions are correct.
*/
inline proc checkDims(DC, DA, DB) {
  if boundsChecking {
    assert(DA.dim(2) == DB.dim(1),
           "Inner dimensions of A and B do not match.");
    assert(DC.dim(1) == DA.dim(1) &&
           DC.dim(2) == DB.dim(2),
           "Outer dimentions of C, A, and B do not match.");
  }
}
