package eu.ohmrun.walker;

class Message<T,K>{
  public final name             : Spur<K>;
  public final data             : Option<T>;
  //private var lapsed            : Bool;
  
  public function new(name:Spur<K>,data:Option<T>){
    this.name   = name;
    this.data   = data;
    //this.lapsed = false;
  }
  static public function unit<T,K>():Message<T,K>{
    return new Message(MACHINE_INIT,None);
  }
}