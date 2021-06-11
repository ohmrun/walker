package eu.ohmrun.walker;

class Machine<T,G,K>{
  public var tree(default,null):Tree<T,G,K>;
  public var calls(default,null):Calls;

  public function new(tree:Tree<T,G,K>,?calls:Calls){
    this.tree     = tree;
    this.calls    = __.option(calls).def(Calls.unit);
  }
  public function copy(?tree,?calls){
    return new Machine(
      __.option(tree).defv(this.tree),
      __.option(calls).defv(this.calls)
    );
  }
  public function on(key:String,selector:Selector):Machine<T,G,K>{
    return copy(null,calls.set(key,selector));
  }
  public function to(path:Path):Res<Transition<T,G,K>,WalkerFailure>{
    return this.tree.divergence(path).map(x -> new Transition(this,x));
  }
  public function call(path:Path):Call<T,G,K>{
    return Call.lift(
      Fletcher.Anon(
        (ipt:Context<T,G,K>,cont:Terminal<Res<Plan<T,G,K>,WalkerFailure>,Noise>) -> to(path).fold(
          (ok)  -> cont.receive(ok.reply().forward(ipt)),
          (e)   -> cont.value(__.reject(e)).serve()
        )
      )
    );
  }
  public function activator():Transition<T,G,K>{
    final path = this.tree.fetch_default_path();
    //trace(path);
    return new Transition(
      this,
      TransitionData.make(this.tree,path,Tree.unit(),this.tree.active())
    );
  }
}