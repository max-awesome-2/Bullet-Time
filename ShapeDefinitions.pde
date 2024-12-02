/**
 This file is where all the big, clunky shape definitions are sequestered.
 */


// LETTERS
ShapeTemplate shapeA = new ShapeTemplate(
  new PVector[] {
  new PVector(-0.5, -1, 0),
  new PVector(-0.5, 0, 0),
  new PVector(-0.5, 1, 0),
  new PVector(0, -1, 0),
  new PVector(0, 0, 0),
  new PVector(0, 1, 0),
  new PVector(0.5, -1, 0),
  new PVector(0.5, 0, 0),
  new PVector(0.5, 1, 0)
  },

  new int[] {
    0, 1,
    1, 2,
    2, 8,
    8, 7,
    7, 6,
    1, 7
  },

  new int[] {
  }
  );

ShapeTemplate shapeB = new ShapeTemplate(
  new PVector[] {
  new PVector(-0.5, -1, 0),
  new PVector(-0.5, 0, 0),
  new PVector(-0.5, 1, 0),
  new PVector(0, -1, 0),
  new PVector(0, 0, 0),
  new PVector(0, 1, 0),
  new PVector(0.5, -1, 0),
  new PVector(0.5, 0, 0),
  new PVector(0.5, 1, 0)
  },

  new int[] {
    0, 1,
    1, 2,
    2, 8,
    8, 7,
    7, 6,
    1, 7,
    0, 6
  },

  new int[] {
  }
  );

ShapeTemplate shapeC = new ShapeTemplate(
  new PVector[] {
  new PVector(-0.5, -1, 0),
  new PVector(-0.5, 0, 0),
  new PVector(-0.5, 1, 0),
  new PVector(0, -1, 0),
  new PVector(0, 0, 0),
  new PVector(0, 1, 0),
  new PVector(0.5, -1, 0),
  new PVector(0.5, 0, 0),
  new PVector(0.5, 1, 0)
  },

  new int[] {
    8, 2,
    2, 0,
    0, 6
  },

  new int[] {
  }
  );

ShapeTemplate shapeD = new ShapeTemplate(
  new PVector[] {
  new PVector(-0.5, -1, 0),
  new PVector(-0.5, 0, 0),
  new PVector(-0.5, 1, 0),
  new PVector(0, -1, 0),
  new PVector(0, 0, 0),
  new PVector(0, 1, 0),
  new PVector(0.5, -1, 0),
  new PVector(0.5, 0, 0),
  new PVector(0.5, 1, 0)
  },

  new int[] {
    0, 2,
    2, 8,
    8, 6,
    6, 0
  },

  new int[] {
  }
  );

ShapeTemplate shapeE = new ShapeTemplate(
  new PVector[] {
  new PVector(-0.5, -1, 0),
  new PVector(-0.5, 0, 0),
  new PVector(-0.5, 1, 0),
  new PVector(0, -1, 0),
  new PVector(0, 0, 0),
  new PVector(0, 1, 0),
  new PVector(0.5, -1, 0),
  new PVector(0.5, 0, 0),
  new PVector(0.5, 1, 0)
  },

  new int[] {
    0, 2,
    2, 8,
    6, 0,
    7, 1
  },

  new int[] {
  }
  );


ShapeTemplate shapeF = new ShapeTemplate(
  new PVector[] {
  new PVector(-0.5, -1, 0),
  new PVector(-0.5, 0, 0),
  new PVector(-0.5, 1, 0),
  new PVector(0, -1, 0),
  new PVector(0, 0, 0),
  new PVector(0, 1, 0),
  new PVector(0.5, -1, 0),
  new PVector(0.5, 0, 0),
  new PVector(0.5, 1, 0)
  },

  new int[] {
    0, 2,
    2, 8,
    7, 1
  },

  new int[] {
  }
  );

ShapeTemplate shapeSpace = new ShapeTemplate(
  new PVector[] {
  new PVector(-0.5, -1, 0),
  new PVector(-0.5, 0, 0),
  new PVector(-0.5, 1, 0),
  new PVector(0, -1, 0),
  new PVector(0, 0, 0),
  new PVector(0, 1, 0),
  new PVector(0.5, -1, 0),
  new PVector(0.5, 0, 0),
  new PVector(0.5, 1, 0)
  },

  new int[] {
  },

  new int[] {
  }
  );

ShapeTemplate shapeG = new ShapeTemplate(
  new PVector[] {
  new PVector(-0.5, -1, 0),
  new PVector(-0.5, 0, 0),
  new PVector(-0.5, 1, 0),
  new PVector(0, -1, 0),
  new PVector(0, 0, 0),
  new PVector(0, 1, 0),
  new PVector(0.5, -1, 0),
  new PVector(0.5, 0, 0),
  new PVector(0.5, 1, 0)
  },

  new int[] {
    8, 2,
    2, 0,
    0, 6,
    6, 7,
    7, 4
  },

  new int[] {
  }
  );

ShapeTemplate shapeH = new ShapeTemplate(
  new PVector[] {
  new PVector(-0.5, -1, 0),
  new PVector(-0.5, 0, 0),
  new PVector(-0.5, 1, 0),
  new PVector(0, -1, 0),
  new PVector(0, 0, 0),
  new PVector(0, 1, 0),
  new PVector(0.5, -1, 0),
  new PVector(0.5, 0, 0),
  new PVector(0.5, 1, 0)
  },

  new int[] {
    0, 2,
    8, 6,
    1, 7
  },

  new int[] {
  }
  );

ShapeTemplate shapeI = new ShapeTemplate(
  new PVector[] {
  new PVector(-0.5, -1, 0),
  new PVector(-0.5, 0, 0),
  new PVector(-0.5, 1, 0),
  new PVector(0, -1, 0),
  new PVector(0, 0, 0),
  new PVector(0, 1, 0),
  new PVector(0.5, -1, 0),
  new PVector(0.5, 0, 0),
  new PVector(0.5, 1, 0)
  },

  new int[] {
    2, 8,
    5, 3,
    0, 6
  },

  new int[] {
  }
  );

ShapeTemplate shapeJ = new ShapeTemplate(
  new PVector[] {
  new PVector(-0.5, -1, 0),
  new PVector(-0.5, 0, 0),
  new PVector(-0.5, 1, 0),
  new PVector(0, -1, 0),
  new PVector(0, 0, 0),
  new PVector(0, 1, 0),
  new PVector(0.5, -1, 0),
  new PVector(0.5, 0, 0),
  new PVector(0.5, 1, 0)
  },

  new int[] {
    2, 8,
    5, 3,
    0, 3
  },

  new int[] {
  }
  );

ShapeTemplate shapeK = new ShapeTemplate(
  new PVector[] {
  new PVector(-0.5, -1, 0),
  new PVector(-0.5, 0, 0),
  new PVector(-0.5, 1, 0),
  new PVector(0, -1, 0),
  new PVector(0, 0, 0),
  new PVector(0, 1, 0),
  new PVector(0.5, -1, 0),
  new PVector(0.5, 0, 0),
  new PVector(0.5, 1, 0)
  },

  new int[] {
    0, 2,
    1, 8,
    1, 6
  },

  new int[] {
  }
  );

ShapeTemplate shapeL = new ShapeTemplate(
  new PVector[] {
  new PVector(-0.5, -1, 0),
  new PVector(-0.5, 0, 0),
  new PVector(-0.5, 1, 0),
  new PVector(0, -1, 0),
  new PVector(0, 0, 0),
  new PVector(0, 1, 0),
  new PVector(0.5, -1, 0),
  new PVector(0.5, 0, 0),
  new PVector(0.5, 1, 0)
  },

  new int[] {
    0, 2,
    0, 6
  },

  new int[] {
  }
  );

ShapeTemplate shapeM = new ShapeTemplate(
  new PVector[] {
  new PVector(-0.5, -1, 0),
  new PVector(-0.5, 0, 0),
  new PVector(-0.5, 1, 0),
  new PVector(0, -1, 0),
  new PVector(0, 0, 0),
  new PVector(0, 1, 0),
  new PVector(0.5, -1, 0),
  new PVector(0.5, 0, 0),
  new PVector(0.5, 1, 0)
  },

  new int[] {
    0, 2,
    2, 4,
    4, 8,
    8, 6
  },

  new int[] {
  }
  );


ShapeTemplate shapeN = new ShapeTemplate(
  new PVector[] {
  new PVector(-0.5, -1, 0),
  new PVector(-0.5, 0, 0),
  new PVector(-0.5, 1, 0),
  new PVector(0, -1, 0),
  new PVector(0, 0, 0),
  new PVector(0, 1, 0),
  new PVector(0.5, -1, 0),
  new PVector(0.5, 0, 0),
  new PVector(0.5, 1, 0)
  },

  new int[] {
    0, 2,
    2, 6,
    6, 8
  },

  new int[] {
  }
  );


ShapeTemplate shapeO = new ShapeTemplate(
  new PVector[] {
  new PVector(-0.5, -1, 0),
  new PVector(-0.5, 0, 0),
  new PVector(-0.5, 1, 0),
  new PVector(0, -1, 0),
  new PVector(0, 0, 0),
  new PVector(0, 1, 0),
  new PVector(0.5, -1, 0),
  new PVector(0.5, 0, 0),
  new PVector(0.5, 1, 0)
  },

  new int[] {
    0, 2,
    2, 8,
    8, 6,
    6, 0
  },

  new int[] {
  }
  );

ShapeTemplate shapeP = new ShapeTemplate(
  new PVector[] {
  new PVector(-0.5, -1, 0),
  new PVector(-0.5, 0, 0),
  new PVector(-0.5, 1, 0),
  new PVector(0, -1, 0),
  new PVector(0, 0, 0),
  new PVector(0, 1, 0),
  new PVector(0.5, -1, 0),
  new PVector(0.5, 0, 0),
  new PVector(0.5, 1, 0)
  },

  new int[] {
    0, 2,
    2, 8,
    8, 7,
    7, 1
  },

  new int[] {
  }
  );


ShapeTemplate shapeQ = new ShapeTemplate(
  new PVector[] {
  new PVector(-0.5, -1, 0),
  new PVector(-0.5, 0, 0),
  new PVector(-0.5, 1, 0),
  new PVector(0, -1, 0),
  new PVector(0, 0, 0),
  new PVector(0, 1, 0),
  new PVector(0.5, -1, 0),
  new PVector(0.5, 0, 0),
  new PVector(0.5, 1, 0)
  },

  new int[] {
    0, 2,
    2, 8,
    8, 6,
    6, 0,
    6, 4
  },

  new int[] {
  }
  );

ShapeTemplate shapeR = new ShapeTemplate(
  new PVector[] {
  new PVector(-0.5, -1, 0),
  new PVector(-0.5, 0, 0),
  new PVector(-0.5, 1, 0),
  new PVector(0, -1, 0),
  new PVector(0, 0, 0),
  new PVector(0, 1, 0),
  new PVector(0.5, -1, 0),
  new PVector(0.5, 0, 0),
  new PVector(0.5, 1, 0)
  },

  new int[] {
    0, 2,
    2, 8,
    8, 7,
    7, 1,
    1, 6
  },

  new int[] {
  }
  );

ShapeTemplate shapeS = new ShapeTemplate(
  new PVector[] {
  new PVector(-0.5, -1, 0),
  new PVector(-0.5, 0, 0),
  new PVector(-0.5, 1, 0),
  new PVector(0, -1, 0),
  new PVector(0, 0, 0),
  new PVector(0, 1, 0),
  new PVector(0.5, -1, 0),
  new PVector(0.5, 0, 0),
  new PVector(0.5, 1, 0)
  },

  new int[] {
    8, 2,
    2, 1,
    1, 7,
    7, 6,
    6, 0
  },

  new int[] {
  }
  );

ShapeTemplate shapeT = new ShapeTemplate(
  new PVector[] {
  new PVector(-0.5, -1, 0),
  new PVector(-0.5, 0, 0),
  new PVector(-0.5, 1, 0),
  new PVector(0, -1, 0),
  new PVector(0, 0, 0),
  new PVector(0, 1, 0),
  new PVector(0.5, -1, 0),
  new PVector(0.5, 0, 0),
  new PVector(0.5, 1, 0)
  },

  new int[] {
    2, 8,
    5, 3
  },

  new int[] {
  }
  );

ShapeTemplate shapeU = new ShapeTemplate(
  new PVector[] {
  new PVector(-0.5, -1, 0),
  new PVector(-0.5, 0, 0),
  new PVector(-0.5, 1, 0),
  new PVector(0, -1, 0),
  new PVector(0, 0, 0),
  new PVector(0, 1, 0),
  new PVector(0.5, -1, 0),
  new PVector(0.5, 0, 0),
  new PVector(0.5, 1, 0)
  },

  new int[] {
    2, 0,
    0, 6,
    6, 8
  },

  new int[] {
  }
  );

ShapeTemplate shapeV = new ShapeTemplate(
  new PVector[] {
  new PVector(-0.5, -1, 0),
  new PVector(-0.5, 0, 0),
  new PVector(-0.5, 1, 0),
  new PVector(0, -1, 0),
  new PVector(0, 0, 0),
  new PVector(0, 1, 0),
  new PVector(0.5, -1, 0),
  new PVector(0.5, 0, 0),
  new PVector(0.5, 1, 0)
  },

  new int[] {
    2, 3,
    3, 8
  },

  new int[] {
  }
  );

ShapeTemplate shapeW = new ShapeTemplate(
  new PVector[] {
  new PVector(-0.5, -1, 0),
  new PVector(-0.5, 0, 0),
  new PVector(-0.5, 1, 0),
  new PVector(0, -1, 0),
  new PVector(0, 0, 0),
  new PVector(0, 1, 0),
  new PVector(0.5, -1, 0),
  new PVector(0.5, 0, 0),
  new PVector(0.5, 1, 0)
  },

  new int[] {
    2, 0,
    0, 5,
    5, 6,
    6, 8
  },

  new int[] {
  }
  );

ShapeTemplate shapeX = new ShapeTemplate(
  new PVector[] {
  new PVector(-0.5, -1, 0),
  new PVector(-0.5, 0, 0),
  new PVector(-0.5, 1, 0),
  new PVector(0, -1, 0),
  new PVector(0, 0, 0),
  new PVector(0, 1, 0),
  new PVector(0.5, -1, 0),
  new PVector(0.5, 0, 0),
  new PVector(0.5, 1, 0)
  },

  new int[] {
    2, 6,
    0, 8
  },

  new int[] {
  }
  );

ShapeTemplate shapeY = new ShapeTemplate(
  new PVector[] {
  new PVector(-0.5, -1, 0),
  new PVector(-0.5, 0, 0),
  new PVector(-0.5, 1, 0),
  new PVector(0, -1, 0),
  new PVector(0, 0, 0),
  new PVector(0, 1, 0),
  new PVector(0.5, -1, 0),
  new PVector(0.5, 0, 0),
  new PVector(0.5, 1, 0)
  },

  new int[] {
    3, 4,
    4, 2,
    4, 8
  },

  new int[] {
  }
  );

ShapeTemplate shapeZ = new ShapeTemplate(
  new PVector[] {
  new PVector(-0.5, -1, 0),
  new PVector(-0.5, 0, 0),
  new PVector(-0.5, 1, 0),
  new PVector(0, -1, 0),
  new PVector(0, 0, 0),
  new PVector(0, 1, 0),
  new PVector(0.5, -1, 0),
  new PVector(0.5, 0, 0),
  new PVector(0.5, 1, 0)
  },

  new int[] {
    2, 8,
    8, 0,
    0, 6
  },

  new int[] {
  }
  );


//////// BASIC SHAPES
ShapeTemplate playerShip = new ShapeTemplate(

  new PVector[] {
  new PVector(0, 0.125, 0.5),
  new PVector(0.3, 0.125, -0.5),
  new PVector(0, 0.125, -0.25),
  new PVector(-0.3, 0.125, -0.5),
  new PVector(0, -0.125, -0.25),
  },

  new int[] {
    0, 1,
    1, 2,
    2, 3,
    3, 0,
    3, 4,
    1, 4,
    0, 4
  },

  new int[] {

  }

  );

ShapeTemplate enemyShip = new ShapeTemplate(

  new PVector[] {
  new PVector(0, 0.125, 0.5),
  new PVector(0.3, 0.125, -0.25),
  new PVector(0, 0.125, -0.5),
  new PVector(-0.3, 0.125, -0.25),
  new PVector(0, -0.125, -0.25),
  },

  new int[] {
    0, 1,
    1, 2,
    2, 3,
    3, 0,
    3, 4,
    1, 4,
    0, 4,
    2, 4
  },

  new int[] {
    0, 1, 4,
    1, 4, 2,
    2, 3, 4,
    0, 3, 4,
    0, 1, 2,
    0, 2, 3
  }

  );

ShapeTemplate explosionShape = new ShapeTemplate(

  new PVector[] {
  new PVector(0, 0.5),
  new PVector(0.2, 0.25),
  new PVector(0.5, 0.3),
  new PVector(0.45, 0.05),
  new PVector(0.5, -0.3),
  new PVector(0.25, -0.25),
  new PVector(-0.225, -0.5),
  new PVector(-0.25, -0.25),
  new PVector(-0.5, -0.18),
  new PVector(-0.35, 0.1),
  new PVector(-0.5, 0.35),
  new PVector(-0.25, 0.35),

  },

  new int[] {
    0, 1,
    1, 2,
    2, 3,
    3, 4,
    4, 5,
    5, 6,
    6, 7,
    7, 8,
    8, 9,
    9, 10,
    10, 11,
    11, 0
  },

  new int[] {

  }

  );

ShapeTemplate line = new ShapeTemplate(

  new PVector[] {
  new PVector(0, 0, -0.5),
  new PVector(0, 0, 0.5)
  },

  new int[] {
    0, 1
  },

  new int[] {

  }

  );

ShapeTemplate cube = new ShapeTemplate(

  new PVector[] {
  new PVector(-0.5, -0.5, -0.5),
  new PVector(0.5, -0.5, -0.5),
  new PVector(0.5, 0.5, -0.5),
  new PVector(-0.5, 0.5, -0.5),
  new PVector(-0.5, -0.5, 0.5),
  new PVector(0.5, -0.5, 0.5),
  new PVector(0.5, 0.5, 0.5),
  new PVector(-0.5, 0.5, 0.5)
  },

  new int[] {
    0, 1,
    1, 2,
    2, 3,
    3, 0,
    4, 5,
    5, 6,
    6, 7,
    7, 4,
    0, 4,
    1, 5,
    2, 6,
    3, 7
  },

  new int[] {
    0, 1, 2,
    2, 3, 0,
    4, 5, 6,
    6, 7, 4,
    0, 4, 7,
    7, 3, 0,
    1, 5, 6,
    6, 2, 1,
    0, 1, 5,
    5, 4, 0,
    3, 2, 6,
    6, 7, 3
  }

  );

ShapeTemplate diamond = new ShapeTemplate(

  new PVector[] {
  new PVector(0, -1, 0),
  new PVector(1, 0, 0),
  new PVector(0, 0, -1),
  new PVector(-1, 0, 0),
  new PVector(0, 0, 1),
  new PVector(0, 1, 0)
  },

  new int[] {
    0, 1,
    0, 2,
    0, 3,
    0, 4,
    5, 1,
    5, 2,
    5, 3,
    5, 4,
    1, 2,
    2, 3,
    3, 4,
    4, 1
  },

  new int[] {
    0, 1, 2,
    0, 2, 3,
    0, 3, 4,
    0, 4, 1,
    5, 1, 2,
    5, 2, 3,
    5, 3, 4,
    5, 4, 1
  }

  );
