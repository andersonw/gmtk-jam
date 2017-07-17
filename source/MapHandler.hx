// http://www.roguebasin.com/index.php?title=Cellular_Automata_Method_for_Generating_Random_Cave-Like_Levels
class MapHandler
{
 
	public var Map:Array<Int>;
	public var mainChunkSquares:Array<Int>;
 
	public var MapWidth:Int;
	public var MapHeight:Int;
	public var PercentAreWalls:Int;
    public var mode:Int;
	public var builtMap:Bool = false;
	
	public var MIN_PATHABLE_SQUARES:Int = 200;
 
	public function new(width:Int = 40, height:Int = 40, pctAreWalls:Int = 40):Void
	{
		MapWidth = width;
		MapHeight = height;
		PercentAreWalls = pctAreWalls;
		genMap(MapWidth, MapHeight, PercentAreWalls);
    }
    
    public function genMap(w:Int, h:Int, p:Int=40):Array<Int> {
		MapWidth = w;
		MapHeight = h;
		PercentAreWalls = p;
        
		RandomFillMap();
        mode = 0;
        for (i in 0...4) {
            MakeCaverns();
        }
        mode = 1;
        for (i in 0...1) {
            MakeCaverns();
        }
		
		while (!builtMap) {
			var tryX:Int = Std.int(Math.random() * MapWidth);
			var tryY:Int = Std.int(Math.random() * MapHeight);
			
			if (getVal(tryX, tryY) != 0) {
				continue;
			}
			fillInSpace(tryX, tryY);
		}
		for(row in 0...MapHeight) {
			for (column in 0...MapWidth) {
				if (getVal(column, row) != 1) {
					continue;
				}
				if (column == 0 || row == 0 || column == MapWidth - 1 || row == MapHeight - 1) {
					continue;
				}
				
				var chance:Float;
				if (getVal(column - 1, row) == 2 || getVal(column, row - 1) == 2) {
					chance = 0.25;
				} else if (getVal(column - 1, row) == 0 || getVal(column + 1, row) == 0 ||
					getVal(column, row - 1) == 0 || getVal(column, row + 1) == 0) {
					chance = 0.1;
				} else {
					chance = 0.01;
				}
				if (Math.random() < chance) {
					setVal(column, row, 2);
				}
			}
		}
		
        return Map;
	}
    
    public function getVal(x:Int, y:Int):Int {
        return Map[x + MapWidth * y];
    }
	
	public function getRandomPathableSquare():Int {
		return mainChunkSquares[Std.int(Math.random() * mainChunkSquares.length)];
	}
	
    public function getHalfTileValOrSolid(x:Int, y:Int):Int {
		return getValOrSolid(Std.int(x / 2), Std.int(y / 2));
    }
    public function getValOrSolid(x:Int, y:Int):Int {
		if (x < 0 || x >= MapWidth || y < 0 || y >= MapHeight) {
			return 1;
		}
        return Map[x + MapWidth * y];
    }
    
    public function setVal(x:Int, y:Int, val:Int):Void {
        Map[x + MapWidth * y] = val;
    }
 
	public function MakeCaverns():Void
	{
        var newMap = new Array<Int>();
		for (i in 0...5) {
			for(row in 0...MapHeight)
			{
				for(column in 0...MapWidth)
				{
					newMap[column + MapWidth * row] = PlaceWallLogic(column,row);
				}
			}
		}
        Map = newMap;
	}
 
	public function PlaceWallLogic(x:Int, y:Int):Int
	{
		if (getVal(x, y) == 2) {
			return 2;
		}
        if (mode == 0) {
            var numWallsInArea:Int = GetAdjacentWalls(x, y, 2, 2);
            if (numWallsInArea <= 2) {
                return 1;
            }
        }
        
		var numWalls:Int = GetAdjacentWalls(x,y,1,1);
        if (numWalls >= 5) {
            return 1;
        } else {
            return 0;
        }
	}
 
	public function GetAdjacentWalls(x:Int, y:Int, scopeX:Int, scopeY:Int):Int
	{
		var startX:Int = x - scopeX;
		var startY:Int = y - scopeY;
		var endX:Int = x + scopeX;
		var endY:Int = y + scopeY;
 
		var iX:Int = startX;
		var iY:Int = startY;
 
		var wallCounter:Int = 0;
 
		for(iY in startY...endY+1)
        {
			for(iX in startX...endX+1)
			{
                if(IsWall(iX,iY))
                {
                    wallCounter += 1;
                }
			}
		}
		return wallCounter;
	}
 
	public function IsWall(x:Int, y:Int):Bool
	{
		// Consider out-of-bound a wall
		if( IsOutOfBounds(x,y) )
		{
			return true;
		}
 
		if( getVal(x,y)==1	 )
		{
			return true;
		}
 
		if( getVal(x,y)==0	 )
		{
			return false;
		}
		return false;
	}
 
	public function IsOutOfBounds(x:Int, y:Int):Bool
	{
		if( x<0 || y<0 )
		{
			return true;
		}
		else if( x>MapWidth-1 || y>MapHeight-1 )
		{
			return true;
		}
		return false;
	}
 
	public function BlankMap():Void
	{
        Map = new Array<Int>();
		for(row in 0...MapHeight) {
			for(column in 0...MapWidth) {
				setVal(row, column, 0);
			}
		}
	}
 
	public function RandomFillMap():Void {
		BlankMap();
 
		var mapMiddle:Int = 0;
		for(row in 0...MapHeight)
        {
			for(column in 0...MapWidth)
			{
				// If coordinates lie on the the edge of the map (creates a border)
				if(column == 0 || row == 0 || column == MapWidth-1 || row == MapHeight-1)
				{
					setVal(column, row, 1);
				}
				// Else, fill with a wall a random percent of the time
				else
				{
					mapMiddle = Std.int(MapHeight / 2);
 
					if(row == mapMiddle)
					{
						setVal(column, row, 0);
					}
					else
					{
						setVal(column, row, RandomPercent(PercentAreWalls));
						if (getVal(column, row) == 0 && Math.random() < 0.02) {
							setVal(column, row, 2);
						}
					}
				}
			}
		}
	}
	
	public function fillInSpace(px:Int, py:Int):Void {
		var directions:Array<Array<Int>> = [ [1, 0], [0, 1], [-1, 0], [0, -1] ];
	
		var queue:Array<Int> = new Array<Int>();
		var visited:Array<Array<Int>> = new Array<Array<Int>>();
		var count:Int = 1;
		mainChunkSquares = new Array<Int>();
		
		for (i in 0...MapHeight) {
			visited.push(new Array<Int>());
			for (j in 0...MapWidth) {
				visited[i].push(0);
			}
		}
		queue.insert(0, px);
		queue.insert(0, py);
		
		visited[py][px] = 1;
		
		while (queue.length > 0) {
			var xPos:Int = queue.pop();
			var yPos:Int = queue.pop();
			
			for (i in 0...directions.length) {
				var nxPos:Int = xPos + directions[i][0];
				var nyPos:Int = yPos + directions[i][1];
				
				if (nxPos >= 0 && nxPos < MapWidth && nyPos >= 0 && nyPos < MapHeight && getVal(nxPos, nyPos) == 0 && visited[nyPos][nxPos] == 0) {
					visited[nyPos][nxPos] = 1;
					count++;
					mainChunkSquares.push(nyPos * MapWidth + nxPos);
					
					queue.insert(0, nxPos);
					queue.insert(0, nyPos);
				}
			}
		}
		
		if (count < MIN_PATHABLE_SQUARES) {
			RandomFillMap();
		}
		else {
			for (i in 0...MapHeight) {
				for (j in 0...MapWidth) {
					if (visited[i][j] == 0 && getVal(j, i) != 2) {
						setVal(j, i, 1);
					}
				}
			}
			builtMap = true;
		}
	}
 
	public function RandomPercent(percent:Int):Int
	{
		if(percent >= Std.random(100))
		{
			return 1;
		}
		return 0;
	}
}
