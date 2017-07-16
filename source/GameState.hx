package;

class GameState {
	public var score:Int;
	public var level:Int;
    public var fixedEnemyTypes:Array<String>;
    public var enemyCount:Map<String,Int>;
    public var killedEnemyCount:Map<String,Int>;
    public var boringEnemyCount:Array<Int>;
    public var crazyEnemyCount:Array<Int>;
    public var tankEnemyCount:Array<Int>;
    public var randomEnemySpawnrate:Array<Float>;
	public var totalEnemiesLeft:Int;

	public function new() {
        fixedEnemyTypes=["boring","crazy","tank"];
        boringEnemyCount=[0,5,10,20,50,];
        crazyEnemyCount=[0,0,2,5,10,0];
        tankEnemyCount=[0,0,0,2,5,20];
        randomEnemySpawnrate=[1000,1000,1000,1000,1000,0.1];
		resetGame();
        initNewLevel();
	}
	public function initNewLevel() {
        enemyCount=["boring"=>boringEnemyCount[level],
                    "crazy"=>crazyEnemyCount[level],
                    "tank"=>tankEnemyCount[level]];

        killedEnemyCount=["boring"=>0,
                          "crazy"=>0,
                          "tank" => 0];
						  
		totalEnemiesLeft = boringEnemyCount[level] + crazyEnemyCount[level] + tankEnemyCount[level];
	}
	public function resetGame() {
		score = 0;
		level = 1;
	}

    public function levelComplete():Bool {
        return Lambda.foreach(fixedEnemyTypes,function(type){
            return(killedEnemyCount[type] >= enemyCount[type]);
        });
    }
}