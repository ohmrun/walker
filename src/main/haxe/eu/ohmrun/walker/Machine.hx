package eu.ohmrun.walker;

class Machine<T,G,K,E>{
              final tree  : Tree<T,G,K,E>;
  @:skipCheck final cache : Map<String,Path>;

  public function new(tree:Tree<T,G,K,E>,?cache:Map<String,Path>){
    this.tree     = tree;
    this.cache    = __.option(cache).defv(new Map()); 
  }

  public function search(selector:Selector):Option<Path>{
    return selector.fold(
      id -> __.option(cache.get(id)).fold(
        ok -> Some(ok),
        () -> tree.lookup(id).map(
          (path) -> {
            cache.set(id,path);
            return path;
          }
        )
      ),
      Some
    );
  }
  public function copy(?tree,?cache){
    return new Machine(
      __.option(tree).defv(this.tree),
      __.option(cache).defv(this.cache)
    );
  }
  public function to(selector:Selector):Upshot<Transition<T,G,K,E>,WalkerFailure<E>>{
    return this.search(selector).resolve( 
      f -> f.of(E_Walker_CannotFindName([],selector))
    ).flat_map(
      path -> this.tree.divergence(path)
    ).map(x -> new Transition(this,x));
  }
  public function call(selector:Selector):Call<T,G,K,E>{
    return Call.lift(
      Fletcher.Anon(
        (ipt:Context<T,G,K>,cont:Terminal<Upshot<Plan<T,G,K>,WalkerFailure<E>>,Nada>) -> to(selector).fold(
          (ok)  -> cont.receive(ok.reply().forward(ipt)),
          (e)   -> cont.value(__.reject(e)).serve()
        )
      )
    );
  }
  public function activator():Transition<T,G,K,E>{
    final path = this.tree.fetch_default_path();
    //trace(path);
    return new Transition(
      this,
      TransitionData.make(this.tree,path,Tree.unit(),this.tree.active())
    );
  }
}