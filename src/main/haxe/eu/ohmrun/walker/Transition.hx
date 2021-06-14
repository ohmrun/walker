package eu.ohmrun.walker;

//TODO on-transition-finish? on-transition-start?
class Transition<T,G,K>{
  public var machine(default,null):Machine<T,G,K>;
  public var data(default,null):TransitionData<T,G,K>;
  
  public function new(machine,data){
    __.assert().exists(data);
    this.machine = machine;
    this.data    = data;
  }
  /**
    Produces the Machine with the TransitionData baked in as the default activation path.
  **/
  public function next(){
    return machine.copy(this.data.fetch_next_tree());
  }
  /**
    Produces a Call that runs through the individual calls on the activation path in `data`.
  **/
  
  public function reply():Call<T,G,K>{
    var nodes  = this.data.fetch_nodes();
    var origin = data.path[0];
    return Call.lift(nodes.lfold(
      (next:Couple<Bool,Node<T,G,K>>,memo:Attempt<Context<T,G,K>,Plan<T,G,K>,WalkerFailure>) -> {
        __.log().debug("here"); 
        return memo
         .broach()
         .map(
          (tp:Couple<Context<T,G,K>,Plan<T,G,K>>) -> {
            __.log().debug(_ -> _.show(tp));
            var ctx = tp.fst().copy(
              null,
              tp.snd().global,
              next.fst() ? Enter : Leave,
              origin,
              next.snd().id,
              tp.fst().buffer.concat(tp.snd().buffer)
            );
            return ctx;
          }
        ).attempt(next.snd().call.toAttempt());
      },
      Call.unit().toAttempt()
    ));
  }

}