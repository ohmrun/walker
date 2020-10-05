package ohmrun.hsm;

class Machine<T,G>{
  public var tree(default,null):Tree<T,G>;
  public var calls(default,null):Calls;

  public function new(tree,?calls){
    this.tree     = tree;
    this.calls    = __.option(calls).def(Calls.unit);
  }
  public function copy(?tree,?calls){
    return new Machine(
      __.option(tree).defv(this.tree),
      __.option(calls).defv(this.calls)
    );
  }
  public function on(key:String,selector:Selector):Machine<T,G>{
    return copy(null,calls.set(key,selector));
  }
  public function to(path:Path):Res<Transition<T,G>,HsmFailure>{
    return this.tree.divergence(path).map(x -> new Transition(this,x));
  }
  public function call(path:Path):Call<T,G>{
    return Call.lift(
      Arrowlet.Anon(
        (ipt:Context<T,G>,cont:Terminal<Res<G,HsmFailure>,Noise>) -> to(path).fold(
          (ok)  -> ok.reply().prepare(ipt,cont),
          (e)   -> cont.value(__.reject(e)).serve()
        )
      )
    );
  }
  public function activator():Transition<T,G>{
    return new Transition(
      this,
      TransitionData.make(this.tree,this.tree.fetch_default_path(),Tree.unit(),this.tree.active())
    );
  }
} 