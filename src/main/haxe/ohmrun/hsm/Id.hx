package ohmrun.hsm;

typedef IdDef = Couple<String,Option<String>>;
abstract Id(IdDef){
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
    return name;
  }
  public var uuid(get,never):Option<String>;
  private function get_uuid():Option<String>{
    return uuid;
  }
  public function toString(){
    return this.snd().map(
      (id) -> '$name#$id'
    ).def(this.fst);
  } 
}