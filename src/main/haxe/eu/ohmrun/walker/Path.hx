package eu.ohmrun.walker;

@:forward(head) abstract Path(Cluster<Id>) from Cluster<Id> to Cluster<Id>{
  @:arrayAccess public function get(int:Int){
    return this[int];
  }
  @:noUsing static public function lift(self:Cluster<Id>):Path{
    return self;
  }
  @:noUsing static public function unit(){
    return lift([]);
  }
  @:from static public function fromClusterOfString(self:Cluster<String>):Path{
    return lift(self.map( (str:String) -> Id.fromString(str)));
  }
  public function toString():String{
    return 'Path('+this.map(
      (couple) -> couple.toString()
    ).lfold1((n,m) -> '$m, $n') + ")";
  }
  public function tail():Path{
    return this.tail();
  }
  public function snoc(v:Id):Path{
    return this.snoc(v);
  }
  public function toStringCluster():Cluster<String>{
    return this.map(x -> x.name);
  }
}