package eu.ohmrun.walker;

enum SpurSum<K>{
  MACHINE_INIT;
  MACHINE_MSG(key:K);
}
@:using(eu.ohmrun.walker.Spur.SpurLift)
abstract Spur<K>(SpurSum<K>) from SpurSum<K> to SpurSum<K>{
  static public var _(default,never) = SpurLift;
  public function new(self) this = self;
  static public function lift<K>(self:SpurSum<K>):Spur<K> return new Spur(self);

  @:from static public function fromK<K>(self:K){
    return lift(MACHINE_MSG(self));
  }
  public function prj():SpurSum<K> return this;
  private var self(get,never):Spur<K>;
  private function get_self():Spur<K> return lift(this);
}
class SpurLift{
  static public function fold<K,Z>(self:SpurSum<K>,machine_init:Void->Z,machine_msg:K->Z):Z{
    return switch(self){
      case MACHINE_INIT       : machine_init();
      case MACHINE_MSG(msg)   : machine_msg(msg);
    }
  } 
}