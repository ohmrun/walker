package eu.ohmrun.walker;

class TransitionData<T,G>{
  static public function make<T,G>(self:Tree<T,G>,path:Path,from:Tree<T,G>,into:Tree<T,G>){
    return new TransitionData(self,path,from,into);
  }
  public function new(self:Tree<T,G>,path:Path,from:Tree<T,G>,into:Tree<T,G>){
    this.self   = self;
    this.path   = path;
    this.from   = from;
    this.into   = into;
  }
  public var self(default,null):Tree<T,G>;
  public var path(default,null):Path;
  public var from(default,null):Tree<T,G>;
  public var into(default,null):Tree<T,G>;

  public function toString(){
    return '\n(from: $from)\n(into: $into)';
  }
  public function fetch_nodes(){
    var nodes = [];
        nodes = nodes.concat(this.from.bf().array().reversed().map(__.couple.bind(false)));
        nodes = nodes.concat(this.into.df().array().map(__.couple.bind(true)));
    //trace(nodes);
    return nodes;
  }
  /**
    Produces a complete representation where the active node has been shifted to be the first node
    in each branch.
  **/
  public function fetch_next_tree():Tree<T,G>{
    function rec(tree:Tree<T,G>,path:Path){
      var head     = path.head();
      var children : LinkedList<Tree<T,G>> = LinkedList.unit();
      for(child in tree.children()){
        var next_child : Tree<T,G> = rec(child,path.tail());
        if(head.zip(next_child.value()).map(__.decouple((l:Id,r:Node<T,G>) -> l.has_name_like(r.id))).defv(false)){
          children = children.cons(next_child);
        }else{
          children = children.snoc(next_child);
        }
      }
      return Tree.make(tree.value().defv(null),children);
    }
    return rec(self,path);
  }   
}