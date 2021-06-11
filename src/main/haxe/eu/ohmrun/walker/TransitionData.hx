package eu.ohmrun.walker;

class TransitionData<T,G,K>{
  static public function make<T,G,K>(self:Tree<T,G,K>,path:Path,from:Tree<T,G,K>,into:Tree<T,G,K>){
    return new TransitionData(self,path,from,into);
  }
  public function new(self:Tree<T,G,K>,path:Path,from:Tree<T,G,K>,into:Tree<T,G,K>){
    this.self   = self;
    this.path   = path;
    this.from   = from;
    this.into   = into;
  }
  public var self(default,null):Tree<T,G,K>;
  public var path(default,null):Path;
  public var from(default,null):Tree<T,G,K>;
  public var into(default,null):Tree<T,G,K>;

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
  public function fetch_next_tree():Tree<T,G,K>{
    function rec(tree:Tree<T,G,K>,path:Path){
      var head     = path.head();
      var children : LinkedList<Tree<T,G,K>> = LinkedList.unit();
      for(child in tree.children()){
        var next_child : Tree<T,G,K> = rec(child,path.tail());
        if(head.zip(next_child.value()).map(__.decouple((l:Id,r:Node<T,G,K>) -> l.has_name_like(r.id))).defv(false)){
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