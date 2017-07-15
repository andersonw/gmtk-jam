// http://www.roguebasin.com/index.php?title=Cellular_Automata_Method_for_Generating_Random_Cave-Like_Levels
class MapHandler
{
 
	public var Map:Array<Int>;
 
	public var MapWidth:Int;
	public var MapHeight:Int;
	public var PercentAreWalls:Int;
    public var mode:Int;
	
	public var MIN_PATHABLE_SQUARES:Int = 200;
	public var LEVEL_WIDTH:Int = 12;
	public var LEVEL_HEIGHT:Int = 12;
 
	public function new():Void
	{
		MapWidth = LEVEL_WIDTH;
		MapHeight = LEVEL_HEIGHT;
		PercentAreWalls = 40;
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
		
		// fill in stuff
		var filledOnce:Bool = false;
		
		for(row in 0...MapHeight) {
			for (column in 0...MapWidth) {
				if (filledOnce) break;
				
				if (getVal(column, row) == 0) {
					fillInSpace(column, row);
					
					filledOnce = true;
				}
			}
		}
        return Map;
	}
    
    public function getVal(x:Int, y:Int):Int {
        return Map[x + MapWidth * y];
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

		/*if(getVal(x, y)==1)
		{
			if( numWalls >= 4 )
			{
				return 1;
			}
			if(numWalls<2)
			{
				return 0;
			}
		}
		else
		{
			if(numWalls>=5)
			{
				return 1;
			}
		}
		return 0;*/
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
 
	/*string MapToString()
	{
		string returnString = string.Join(" ", // Seperator between each element
		                                  "Width:",
		                                  MapWidth.ToString(),
		                                  "\tHeight:",
		                                  MapHeight.ToString(),
		                                  "\t% Walls:",
		                                  PercentAreWalls.ToString(),
		                                  Environment.NewLine
		                                 );
 
		List<string> mapSymbols = new List<string>();
		mapSymbols.Add(".");
		mapSymbols.Add("#");
		mapSymbols.Add("+");
 
		for(int column=0,row=0; row < MapHeight; row++ ) {
			for( column = 0; column < MapWidth; column++ )
			{
				returnString += mapSymbols[Map[column,row]];
			}
			returnString += Environment.NewLine;
		}
		return returnString;
	}*/
 
	public function BlankMap():Void
	{
        Map = new Array<Int>();
		for(row in 0...MapHeight) {
			for(column in 0...MapWidth) {
				setVal(row, column, 0);
			}
		}
	}
 
	public function RandomFillMap():Void
	{
		// New, empty map
		BlankMap();
 
		var mapMiddle:Int = 0; // Temp variable
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
		
		for (i in 0...LEVEL_HEIGHT) {
			visited.push(new Array<Int>());
			for (j in 0...LEVEL_WIDTH) {
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
				
				if (nxPos >= 0 && nxPos < LEVEL_WIDTH && nyPos >= 0 && nyPos < LEVEL_HEIGHT && getVal(nxPos, nyPos) != 1 && visited[nyPos][nxPos] == 0) {
					visited[nyPos][nxPos] = 1;
					count++;
					
					queue.insert(0, nxPos);
					queue.insert(0, nyPos);
				}
			}
		}
		
		if (count < MIN_PATHABLE_SQUARES) {
			RandomFillMap();
		}
		else {
			for (i in 0...LEVEL_HEIGHT) {
				for (j in 0...LEVEL_WIDTH) {
					if (visited[i][j] == 0) {
						setVal(j, i, 1);
					}
				}
			}
		}
	}
 
	public function RandomPercent(percent:Int):Int
	{
		if(percent>=Std.random(100))
		{
			return 1;
		}
		return 0;
	}
}
