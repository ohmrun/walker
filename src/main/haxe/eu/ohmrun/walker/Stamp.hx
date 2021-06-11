package eu.ohmrun.walker;

typedef StampDef = {
  final timestamp : TimeStamp;
  final payload   : Block;
}
@:forward abstract Stamp(StampDef) from StampDef to StampDef{
  public function new(self) this = self;
  static public function lift(self:StampDef):Stamp return new Stamp(self);

  @:from static public function fromBlock(self:Void->Void){
    return lift({
      timestamp : LogicalClock.get(),
      payload   : self
    });
  }
  public function prj():StampDef return this;
  private var self(get,never):Stamp;
  private function get_self():Stamp return lift(this);
}