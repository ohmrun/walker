package ohmrun.hsm;

class State<T>{
  public var path(default,null):ArrayOfNode<T>;
  public var tree(default,null):Tree<T>;
  public var calls(default,null):Calls<T>;

  public function new(path,tree,calls){
    this.path     = path;
    this.tree     = tree;
    this.calls = calls;
  }
  public function get_transition(to:Id):TransitionData<T>{
    return null;
  }
  public function copy(?path,?tree,?calls){
    return new State(
      __.option(path).defv(this.path),
      __.option(tree).defv(this.tree),
      __.option(calls).defv(this.calls)
    );
  }
  public function on(key:String,selector:Selector):State<T>{
    return copy(null,null,calls.set(key,selector));
  }
} 