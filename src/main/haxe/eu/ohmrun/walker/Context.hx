package eu.ohmrun.walker;

class Context<T,G,K>{

  static public function make<T,G,K>(message:Message<T,K>,global:G,?phase,origin,cursor,?requisitions){
    return new Context(message,global,__.option(phase).defv(Enter),origin,cursor,requisitions);
  }
  public var message(default,null):Message<T,K>;
  public var global(default,null):G;   
  public var phase(default,null):Phase;

  public final origin         : Id;
  public final cursor         : Id;
  public final requisitions   : Array<Requisition<T,K>>;
    
  private function new(message:Message<T,K>,global:G,phase,origin,cursor,?requisitions){
    this.message  = message;
    this.global   = global;
    this.phase    = phase;

    this.origin   = origin;
    this.cursor   = cursor;

    this.requisitions = __.option(requisitions).defv([]);
  } 
  public function raise(request:Request<T,K>){
    requisitions.push(Requisition.make(request,this.cursor));
  }
  public function copy(message,global,phase,origin,cursor,requisitions){
    return make(
      __.option(message).defv(this.message),
      __.option(global).defv(this.global),
      __.option(phase).defv(this.phase),
      __.option(origin).defv(this.origin),
      __.option(origin).defv(this.cursor),
      __.option(requisitions).defv(this.requisitions)
    );
  }
  public function use(plan:Plan<T,G,K>):Context<T,G,K>{
    return copy(null,null,null,null,null,requisitions.concat(plan.requisitions));
  }
  public function plan(plan:Plan<T,G,K>):Plan<T,G,K>{
    return Plan.make(plan.global,requisitions.concat(plan.requisitions));
  }
}