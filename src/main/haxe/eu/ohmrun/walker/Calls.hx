package eu.ohmrun.walker;

typedef CallsDef<K> = stx.ds.RedBlackMap<K,Selector>;

@:forward abstract Calls<K>(CallsDef<K>) from CallsDef<K> to CallsDef<K>{
  @:noUsing static public function make<K>(comparable:Comparable<K>){
    return lift(RedBlackMap.make(comparable));
  }
  @:noUsing static public function unit():Calls<String>{
    return make(Comparable.String());
  }
  static public function lift<K>(self:CallsDef<K>){
    return new Calls(self);
  }
  public function new(self) this = self;
}