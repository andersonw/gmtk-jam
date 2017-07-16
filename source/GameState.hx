package;

class GameState {
	public var score:Int;
	public var level:Int;
    public var fixedEnemyTypes:Array<String>;
    public var enemyCount:Map<String,Int>;
    public var killedEnemyCount:Map<String,Int>;

	public function new() {
        fixedEnemyTypes=["boring","crazy","tank"];

		resetGame();
        initNewLevel();
	}
	public function initNewLevel() {
        enemyCount=["boring"=>1,
                    "crazy"=>1,
                    "tank"=>1];

        killedEnemyCount=["boring"=>0,
                          "crazy"=>0,
                          "tank"=>0];
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