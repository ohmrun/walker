package eu.ohmrun.walker;

class Hive<T,K>{
  private final embed : Embed<Event<T,K>>;
  public function new(){
    this.embed  = new Embed();
  }
  public inline function raise(event:Event<T,K>){
    final block = embed.pack(event);
    final stamp = Stamp.fromBlock(block);
    Hook.raise(stamp);
  }
}