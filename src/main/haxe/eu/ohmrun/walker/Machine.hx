package eu.ohmrun.walker;

class Machine<T,G,K>{
  final tree  : Tree<T,G,K>;
  final known : StringMap<Path>;

  public function new(tree:Tree<T,G,K>,known:StringMap<Path>){
    this.tree     = tree;
    this.known    = known; 
  }

  public function search(selector:Selector):Option<Path>{
    return selector.fold(
      id -> __.option(known.get(id)).fold(
        ok -> Some(ok),
        () -> tree.lookup(id).map(
          __.command(
            (path) -> known.set(id,path)
          )
        )
      ),
      Some
    );
  }
  public function copy(?tree,?known){
    return new Machine(
      __.option(tree).defv(this.tree),
      __.option(known).defv(this.known)
    );
  }
  public function to(selector:Selector):Res<Transition<T,G,K>,WalkerFailure>{
    return this.search(selector).resolve( 
      f -> f.of(E_Walker_CannotFindName([],selector))
    ).flat_map(
      path -> this.tree.divergence(path)
    ).map(x -> new Transition(this,x));
  }
  public function call(selector:Selector):Call<T,G,K>{
    return Call.lift(
      Fletcher.Anon(
        (ipt:Context<T,G,K>,cont:Terminal<Res<Plan<T,G,K>,WalkerFailure>,Noise>) -> to(selector).fold(
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