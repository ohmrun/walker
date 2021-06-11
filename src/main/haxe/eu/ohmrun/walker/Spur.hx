package eu.ohmrun.walker;

enum SpurSum<K>{
  MACHINE_INIT;
  MACHINE_MSG(key:K);
}
abstract Spur<K>(SpurSum<K>) from SpurSum<K> to SpurSum<K>{
  public function new(self) this = self;
  static public function lift<K>(self:SpurSum<K>):Spur<K> return new Spur(self);

  @:from static public function fromK<K>(self:K){
    return lift(MACHINE_MSG(self));
  }
  public function prj():SpurSum<K> return this;
  private var self(get,never):Spur<K>;
  private function get_self():Spur<K> return lift(this);
}