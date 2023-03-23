package eu.ohmrun.walker.html5.data;

#if js
@:forward abstract Into<T,G,K,E>(Call<T,G,K,E>) from Call<T,G,K,E> to Call<T,G,K,E>{
  public function new(self) this = self;
  static public function lift<T,G,K,E>(self:Call<T,G,K,E>):Into<T,G,K,E> return new Into(self);

  @:from static public function fromFnVoidFutureNoise<T,G,K,E>(fn:Void->Future<Noise>):Into<T,G,K,E>{
    return Call.lift(Fletcher.lift(
      (context:Context<T,G,K>,cont:Waypoint<Plan<T,G,K>,WalkerFailure<E>>) -> {
        return switch (context.phase){
          case Enter : 
            cont.receive(cont.later(fn().map( _ -> __.success(__.accept(Plan.pure(context.global))))));
          case Leave : 
            cont.receive(cont.value(__.accept(Plan.pure(context.global))));   
        }    
      }
    ));
  }
  public function prj():Call<T,G,K,E> return this;
  private var self(get,never):Into<T,G,K,E>;
  private function get_self():Into<T,G,K,E> return lift(this);
}
#end