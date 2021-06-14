package eu.ohmrun.walker;

typedef StampDef<T> = {
  final timestamp : TimeStamp;
  final payload   : T;
}
@:forward abstract Stamp<T>(StampDef<T>) from StampDef<T> to StampDef<T>{
  public function new(self) this = self;
  static public function lift<T>(self:StampDef<T>):Stamp<T> return new Stamp(self);

  @:from static public function fromBlock(self:Void->Void):Stamp<Block>{
    return lift({
      timestamp : LogicalClock.get(),
      payload   : self
    });
  }
  @:noUsing static public function make<T>(timestamp,payload:T){
    return lift({
      timestamp : timestamp,
      payload   : payload
    });
  }
  @:noUsing static public function pure<T>(self:T){
    return make(LogicalClock.get(),self);
  }
  public function map<Ti>(fn:T->Ti):Stamp<Ti>{
    return make(this.timestamp,fn(this.payload));
  }
  //public function is_after(stamp:Timestamp)
  public function prj():StampDef<T> return this;
  private var self(get,never):Stamp<T>;
  private function get_self():Stamp<T> return lift(this);
}