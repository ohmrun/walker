package eu.ohmrun.hsm;

//TODO on-transition-finish? on-transition-start?
class Transition<T,G>{
  public var machine(default,null):Machine<T,G>;
  public var data(default,null):TransitionData<T,G>;
  
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
  
  public function reply():Call<T,G>{
    return Call.lift(this.data.fetch_nodes().lfold(
      (next:Couple<Bool,Node<T,G>>,memo:Attempt<Context<T,G>,G,HsmFailure>) -> {
        __.log().debug("here"); 
        return memo
         .broach()
         .map(
          (tp:Couple<Context<T,G>,G>) -> {
            __.log().debug(_ -> _.show(tp));
            var ctx = Context.make(tp.fst().event,tp.snd(),next.fst() ? Enter : Leave);
            return ctx;
          }
        ).attempt(next.snd().call.toAttempt());
      },
      Call.unit().toAttempt()
    ));
  }

}