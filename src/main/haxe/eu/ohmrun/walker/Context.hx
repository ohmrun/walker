package eu.ohmrun.walker;

class Context<T,G>{

  static public function make<T,G>(event:T,global:G,?phase){
    return new Context(event,global,__.option(phase).defv(Enter));
  }
  public var event(default,null):T;
  public var global(default,null):G;   
  public var phase(default,null):Phase;

  public function new(event:T,global:G,phase){
    this.event  = event;
    this.global = global;
    this.phase  = phase;
  } 
}