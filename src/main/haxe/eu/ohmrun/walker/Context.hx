package eu.ohmrun.walker;

class Context<T,G,K>{

  static public function make<T,G,K>(message:Message<T,K>,global:G,?phase,origin,cursor,?requests){
    return new Context(message,global,__.option(phase).defv(Enter),origin,cursor,requests);
  }
  public var message(default,null):Message<T,K>;
  public var global(default,null):G;   
  public var phase(default,null):Phase;

  public final origin     : Id;
  public final cursor     : Id;
  public final requests   : Array<Request<T,K>>;
    
  private function new(message:Message<T,K>,global:G,phase,origin,cursor,?requests){
    this.message  = message;
    this.global   = global;
    this.phase    = phase;

    this.origin   = origin;
    this.cursor   = cursor;

    this.requests = __.option(requests).defv([]);
  } 
  public function raise(request:Request<T,K>){
    requests.push(request);
  }
  public function copy(message,global,phase,origin,cursor,requests){
    return make(
      __.option(message).defv(this.message),
      __.option(global).defv(this.global),
      __.option(phase).defv(this.phase),
      __.option(origin).defv(this.origin),
      __.option(origin).defv(this.cursor),
      __.option(requests).defv(this.requests)
    );
  }
  public function use(plan:Plan<T,G,K>):Context<T,G,K>{
    return copy(null,null,null,null,null,requests.concat(plan.requests));
  }
  public function plan(plan:Plan<T,G,K>):Plan<T,G,K>{
    return Plan.make(plan.global,requests.concat(plan.requests));
  }
}