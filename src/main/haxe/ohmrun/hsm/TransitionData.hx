package ohmrun.hsm;

class TransitionData<T>{
  public function new(self,from,into){
    this.self   = self;
    this.from   = from;
    this.into   = into;
  }
  public var self(default,null):ArrayOfNode<T>;
  public var from(default,null):ArrayOfNode<T>;
  public var into(default,null):ArrayOfNode<T>;
}