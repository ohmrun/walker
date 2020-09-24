package ohmrun.hsm;

class State<T>{
  public var path(default,null):ArrayOfNode<T>;
  public var tree(default,null):StateTree<T>;
  public var handlers(default,null):Handlers<T>;

  public function new(path,tree,handlers){
    this.path     = path;
    this.tree     = tree;
    this.handlers = handlers;
  }
  public function get_transition(to:Id):TransitionData<T>{
    return null;
  }
  public function copy(?path,?tree,?handlers){
    return new State(
      __.option(path).defv(this.path),
      __.option(tree).defv(this.tree),
      __.option(handlers).defv(this.handlers)
    );
  }
  public function on(key:String,selector:Selector):State<T>{
    return copy(null,null,handlers.set(key,selector));
  }
} 