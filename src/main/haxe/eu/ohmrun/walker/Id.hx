package eu.ohmrun.walker;

typedef IdDef = Couple<String,Option<String>>;
@:using(eu.ohmrun.walker.Id.IdLift)
abstract Id(IdDef){
  static public var _(default,never) = IdLift;
  public function new(self) this = self;
  @:noUsing static public function lift(self:IdDef):Id{
    return new Id(self);
  }
  @:noUsing static public function make(name:String,?uuid:Option<String>):Id{
    return new Id(__.couple(name,uuid == null ? None : uuid));
  }
  @:from static public function fromString(self:String):Id{
    return make(self);
  }
  public var name(get,never):String;
  private function get_name():String{
    return this.fst();
  }
  public var uuid(get,never):Option<String>;
  private function get_uuid():Option<String>{
    return this.snd();
  }
  public function toString(){
    return this.snd().map(
      (id) -> '$name#$id'
    ).def(this.fst);
  } 
  public function has_name_like(id:Id):Bool{
    return this.decouple(
      (name,_) -> name == id.name
    );
  }
}
class IdLift{
  static public function eq():Eq<Id>{
    return Eq.Anon(
      (l:Id,r:Id) -> equals(l,r) ? AreEqual : NotEqual
    );
  }
  static public function equals(self:Id,that:Id):Bool{
    return self.name == that.name && self.uuid.zip(that.uuid).map(__.decouple( (x:String,y:String) -> x == y)).defv(true);
  }
  static public function lt():Ord<Id>{
    return Ord.Anon(
      (l:Id,r:Id) -> Ord.String().comply(l.name,r.name)
    );

  }
}