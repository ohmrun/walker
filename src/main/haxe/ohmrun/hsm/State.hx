package ohmrun.hsm;

class State<T>{
  public var tree(default,null):Tree<T>;
  public var calls(default,null):Calls<T>;

  public function new(tree,?calls){
    this.tree     = tree;
    this.calls    = calls;
  }
  public function get_transition(to:Id):TransitionData<T>{
    return null;
  }
  public function copy(?tree,?calls){
    return new State(
      __.option(tree).defv(this.tree),
      __.option(calls).defv(this.calls)
    );
  }
  public function on(key:String,selector:Selector):State<T>{
    return copy(null,calls.set(key,selector));
  }
  public function boop(){
    var levels  = [];
    var n       = 0;
    var zipper  = this.tree.zipper();
    var value   = zipper.value();
    switch(value.type){
      case All : 
      case One :  
    }
    
  }
} 