package eu.ohmrun.walker.html5.data;

@:default(Register.ZERO)
class Register{
  static public var ZERO = new Register();
  public function new(?delegate){
    this.delegate = __.option(delegate).defv(new Map());
  }
  private var delegate : Map<String,Block>;
  public function set(key:String,val:Block){
    this.delegate.set(key,val);
  }
  public function iterator(){
    return this.delegate.iterator();
  }
  public function keyValueIterator(){
    return this.delegate.keyValueIterator();
  }
  public function use<T,G,K,E>(interp:Block->Option<Node<T,G,K,E>>):Void{
    
  }
}