package ohmrun.hsm;

enum SelectorSum{
  SelectId(id:String);
  SelectPath(path:Path);
}
abstract Selector(SelectorSum) from SelectorSum to SelectorSum{
  public function new(self:SelectorSum) this = self;
  @:noUsing static public function lift(self:SelectorSum) return new Selector(self);
  @:from static public function fromPath(self:Path):Selector{
    return lift(SelectPath(self));
  }
}