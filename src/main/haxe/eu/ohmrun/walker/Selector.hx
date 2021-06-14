package eu.ohmrun.walker;

enum SelectorSum{
  SelectId(id:String);
  SelectPath(path:Path);
}
@:using(eu.ohmrun.walker.Selector.SelectorLift)
abstract Selector(SelectorSum) from SelectorSum to SelectorSum{
  static public var _(default,never) = SelectorLift;
  public function new(self:SelectorSum) this = self;
  @:noUsing static public function lift(self:SelectorSum) return new Selector(self);
  @:from static public function fromPath(self:Path):Selector{
    return lift(SelectPath(self));
  }
}
class SelectorLift{
  static public function fold<Z>(self:SelectorSum,select_id:String->Z,select_path:Path->Z):Z{
    return switch(self){
      case SelectId(s)    : select_id(s);
      case SelectPath(p)  : select_path(p);
    }
  }
}