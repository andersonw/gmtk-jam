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
    public var bossEnemyCount:Array<Int>;
    public var randomEnemySpawnrate:Array<Float>;
	public var totalEnemiesLeft:Int;
    public var timePerLevel:Array<Float>;
    public var timeLeft:Float;

	public function new() {
        fixedEnemyTypes=["boring","crazy","tank","boss"];
        boringEnemyCount=[0,5,10,15,20,0];
        crazyEnemyCount=[0,0,2,5,8,0];
        tankEnemyCount=[0,0,0,2,4,0];
        bossEnemyCount=[0,0,0,0,0,1];
        randomEnemySpawnrate=[0,1000,1000,1000,1000,1];
        timePerLevel=[0,10,120,120,120,120];
		resetGame();
        initNewLevel();
	}
	public function initNewLevel() {
        enemyCount=["boring"=>boringEnemyCount[level],
                    "crazy"=>crazyEnemyCount[level],
                    "tank"=>tankEnemyCount[level],
                    "boss"=>bossEnemyCount[level]];

        killedEnemyCount=["boring"=>0,
                          "crazy"=>0,
                          "tank"=>0,
                          "boss"=>0];
						  
		totalEnemiesLeft = boringEnemyCount[level] + crazyEnemyCount[level] + tankEnemyCount[level] + bossEnemyCount[level];
        timeLeft = timePerLevel[level];
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