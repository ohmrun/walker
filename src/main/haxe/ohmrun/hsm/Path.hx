package ohmrun.hsm;

abstract Path(Array<Id>) from Array<Id> to Array<Id>{
  @:noUsing static public function lift(self:Array<Id>):Path{
    return self;
  }
  @:from static public function fromArrayOfString(self:Array<String>):Path{
    return lift(self.map( (str:String) -> Id.fromString(str)));
  }
  public function toString():String{
    return 'Path('+this.map(
      (couple) -> couple.toString()
    ).join(', ') + ")";
  }
  public function tail():Path{
    return this.tail();
  }
}