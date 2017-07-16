class Level
{
    public var currLevel:Int;
    public var fixedEnemyTypes:Array<String>;
    public var enemyCount:Map<String,Int>;
    public var killedEnemyCount:Map<String,Int>;
    public function new() {
        currLevel = 0;
        fixedEnemyTypes=["boring","crazy","tank"];

        enemyCount=["boring"=>1,
                    "crazy"=>1,
                    "tank"=>1];

        killedEnemyCount=["boring"=>0,
                          "crazy"=>0,
                          "tank"=>0];
    }


    public function levelComplete():Bool {
        return Lambda.foreach(fixedEnemyTypes,function(type){
            return(killedEnemyCount[type] >= enemyCount[type]);
        });
    }
}