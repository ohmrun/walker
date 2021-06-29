package eu.ohmrun.walker;

typedef TreeDef<T,G,K,E> = KaryTree<Node<T,G,K,E>>;
@:using(eu.ohmrun.walker.Tree.TreeLift)
@:forward abstract Tree<T,G,K,E>(TreeDef<T,G,K,E>) from TreeDef<T,G,K,E> to TreeDef<T,G,K,E>{
  static public inline function dbg(){
    return __.log().tag("eu.ohmrun.walker").level(TRACE);
  }
  static public inline function log_path(){
    return dbg().tag('eu.ohmrun.walker.Tree.path');
  }
  @:noUsing inline static public function unit<T,G,K,E>():Tree<T,G,K,E>               return lift(Nought);
  @:noUsing inline static public function pure<T,G,K,E>(v:Node<T,G,K,E>):Tree<T,G,K,E>      return lift(Branch(v,Nil));
  @:noUsing inline static public function make<T,G,K,E>(v:Node<T,G,K,E>,rest:LinkedList<Tree<T,G,K,E>>):Tree<T,G,K,E> return lift(Branch(v,rest));
  @:noUsing static public function lift<T,G,K,E>(self:TreeDef<T,G,K,E>){
    return new Tree(self);
  }
  public function new(self) this = self;

  public function active():Tree<T,G,K,E>{
    return switch(__.option(this.value()).map(_ -> _.type)){
      case Some(All) : 
        lift(Branch(
          this.value(),
          this.children().map(
            (x:KaryTree<Node<T,G,K,E>>) -> (x:Tree<T,G,K,E>).active()
          )
        ));
      case Some(One) : 
        lift(Branch(
          this.value(),
          __.option(this.children().head()).map(x -> (x:Tree<T,G,K,E>).active()).map(LinkedList.pure).defv(null)
        ));
      case None   :
        lift(Nought);
    }
  }
  public function lookup(uuid:String):Option<Path>{
    function recursive(tree:Tree<T,G,K,E>,path:Cluster<Node<T,G,K,E>>){
      return tree.value().flat_map(
        node -> node.id.uuid.flat_map(
          uuidI -> (uuid == uuidI).if_else(
            () -> Some(path.snoc(node).map(node -> node.id)),
            () -> tree.children().fold(
              (next:Tree<T,G,K,E>,memo:Option<Path>) -> memo.fold(
                ok -> Some(ok),
                () -> recursive(next,path.snoc(node))
              ),
              None
            )
          )
        )
      );
    } 
    return recursive(this,[]);
  }
  public function get(id:Id):Option<Tree<T,G,K,E>>{
    return this.children().search(
      (tree:Tree<T,G,K,E>) -> tree.value().map(
        node -> node.id.has_name_like(id)
      ).defv(false)
    );
  }
  public function path(path:Path,?depth=0):Tree<T,G,K,E>{
    __.log()('path $path on ${this.value()}');
    return switch([__.option(this.value()),path.head()]){
      case [Some(node),Some(head)] if (node.type == One) : 
        make(
          node,
          this.search_child(
            (node:Node<T,G,K,E>) -> node.id.has_name_like(head)
          ).or(
            //TODO what's the fail condition?
            () -> __.option(this.children().head())//whatever the default path was 
          ).map((child:Tree<T,G,K,E>) -> child.path(path.tail()))
          .map(LinkedList.pure)
          .def(LinkedList.unit)
        );
      case [Some(node),None] if (node.type == One) : 
        make(node,
          __.option(this.children().head())
            .map((tree:Tree<T,G,K,E>) -> tree.path(path.tail()))
            .map(LinkedList.pure)
            .def(LinkedList.unit)
        );
      case [Some(node),None]        :
        make(
          node,
          this.children().map(
            (tree:Tree<T,G,K,E>) -> {
              return tree.path(path.tail());
            }
          )
        );
      case [Some(node),Some(head)]  :
        make(
          node,
          this.children()
            .lfold(
              (next:Tree<T,G,K,E>,memo:LinkedList<KaryTree<Node<T,G,K,E>>>) -> {
                return next.value().map(
                  node -> node.id.has_name_like(head)
                ).defv(false)
                 .if_else(
                    () -> memo.cons(next),
                    () -> memo.snoc(next)
                 );
              }
              ,LinkedList.unit()
            ).map(
              (tree:Tree<T,G,K,E>) -> {
                return tree.path(path.tail());
              }
            )
        );
      default : unit();
    }
  }
  public function value():Option<Node<T,G,K,E>>{
    return __.option(this.value());
  }
  public function has_head_value_equals(that:Tree<T,G,K,E>){
    return value().zip(that.value()).map(__.decouple((l:Node<T,G,K,E>,r:Node<T,G,K,E>) -> l.equals(r)));
  }
  public function toString():String{
    return KaryTree._.toString(this);
  }
}
class TreeLift{
  /**
    Produces the Tree representing the downward activation path.
  **/
  static public function divergence<T,G,K,E>(tree:Tree<T,G,K,E>,path:Path):Res<TransitionData<T,G,K,E>,WalkerFailure<E>>{
    var active  = tree.active();
    var next    = tree.path(path);
    
    function are_same(lhs:Tree<T,G,K,E>,rhs:Tree<T,G,K,E>){
      return lhs.value().zip(rhs.value())
        .map(
          __.decouple(
            (l:Node<T,G,K,E>,r:Node<T,G,K,E>) -> l.id.has_name_like(r.id)
          )
        ).defv(true);
    }
    function have_same_size(l:Tree<T,G,K,E>,r:Tree<T,G,K,E>){
      return l.children().size() == r.children().size();
    }
    function have_same_children(l:Tree<T,G,K,E>,r:Tree<T,G,K,E>){
      return l.children().zip(r.children()).toArray().all(
        (next:Twin<Tree<T,G,K,E>>) -> next.decouple(are_same)
      );
    }
    function build(lhs:Tree<T,G,K,E>,rhs:Tree<T,G,K,E>,rec){
      return lhs.children().zip(rhs.children()).lfold(
        (next:Twin<Tree<T,G,K,E>>,memo:Res<Option<Twin<Tree<T,G,K,E>>>,WalkerFailure<E>>) -> {
          return memo.flat_map(
            (opt:Option<Twin<Tree<T,G,K,E>>>) -> opt.fold(
              (v) -> __.accept(Some(v)),
              ()  -> next.decouple(rec)  
            )
          );
        },
        __.accept(None)
      );
    }
    function rec(lhs:Tree<T,G,K,E>,rhs:Tree<T,G,K,E>):Res<Option<Twin<Tree<T,G,K,E>>>,WalkerFailure<E>>{
      trace('$lhs\n$rhs');
      return are_same(lhs,rhs).if_else(
        () -> have_same_size(lhs,rhs).if_else(
          () -> {
            return have_same_children(lhs,rhs).if_else(
              () -> build(lhs,rhs,rec),
              () -> __.accept(Some(__.couple(lhs,rhs)))
            );
          },
          () -> {
            trace('$lhs\n$rhs');
            return __.reject(__.fault().of(E_Walker_AreDifferentNodes));
          }
        ),
        () -> {
          trace(['${lhs},${rhs}']);
          return __.reject(__.fault().of(E_Walker_AreDifferentNodes));
        }
      );
    }
    var out =  rec(active,next);
    return out.flat_map(
      (opt:Option<Twin<Tree<T,G,K,E>>>) -> opt.map(
        (couple:Twin<Tree<T,G,K,E>>) -> TransitionData.make(tree,path,couple.fst(),couple.snd())
      ).resolve(
        f -> f.of(E_Walker_CannotFindName(path.toStringCluster(),null))
      )
    );
  }
  /**
    Produces a Path for the natural transition, selecting the first child of each branch
  **/
  static public function fetch_default_path<T,G,K,E>(self:Tree<T,G,K,E>){
    function rec(tree:Tree<T,G,K,E>,path:Path):Path {
      var head = __.option(tree.children().head());
      var id   = head.flat_map(_ -> _.value());
      for(v in id){
        path = path.snoc(v.id);
      }
      return head.map(
        t -> rec(t,path)
      ).defv(path);
    }
    return rec(self,Path.unit());
  }
}