package eu.ohmrun.walker;

typedef TreeDef<T,G,K> = KaryTree<Node<T,G,K>>;
@:using(eu.ohmrun.walker.Tree.TreeLift)
@:forward abstract Tree<T,G,K>(TreeDef<T,G,K>) from TreeDef<T,G,K> to TreeDef<T,G,K>{
  static public inline function dbg(){
    return __.log().tag("eu.ohmrun.walker").level(TRACE);
  }
  static public inline function log_path(){
    return dbg().tag('eu.ohmrun.walker.Tree.path');
  }
  @:noUsing inline static public function unit<T,G,K>():Tree<T,G,K>               return lift(Nought);
  @:noUsing inline static public function pure<T,G,K>(v:Node<T,G,K>):Tree<T,G,K>      return lift(Branch(v,Nil));
  @:noUsing inline static public function make<T,G,K>(v:Node<T,G,K>,rest:LinkedList<Tree<T,G,K>>):Tree<T,G,K> return lift(Branch(v,rest));
  @:noUsing static public function lift<T,G,K>(self:TreeDef<T,G,K>){
    return new Tree(self);
  }
  public function new(self) this = self;

  public function active():Tree<T,G,K>{
    return switch(__.option(this.value()).map(_ -> _.type)){
      case Some(All) : 
        lift(Branch(
          this.value(),
          this.children().map(
            (x:KaryTree<Node<T,G,K>>) -> (x:Tree<T,G,K>).active()
          )
        ));
      case Some(One) : 
        lift(Branch(
          this.value(),
          __.option(this.children().head()).map(x -> (x:Tree<T,G,K>).active()).map(LinkedList.pure).defv(null)
        ));
      case None   :
        lift(Nought);
    }
  }
  public function lookup(uuid:String):Option<Path>{
    function recursive(tree:Tree<T,G,K>,path:Array<Node<T,G,K>>){
      return tree.value().flat_map(
        node -> node.id.uuid.flat_map(
          uuidI -> (uuid == uuidI).if_else(
            () -> Some(path.snoc(node).map(node -> node.id)),
            () -> tree.children().fold(
              (next:Tree<T,G,K>,memo:Option<Path>) -> memo.fold(
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
  public function get(id:Id):Option<Tree<T,G,K>>{
    return this.children().search(
      (tree:Tree<T,G,K>) -> tree.value().map(
        node -> node.id.has_name_like(id)
      ).defv(false)
    );
  }
  public function path(path:Path,?depth=0):Tree<T,G,K>{
    __.log()('path $path on ${this.value()}');
    return switch([__.option(this.value()),path.head()]){
      case [Some(node),Some(head)] if (node.type == One) : 
        make(
          node,
          this.search_child(
            (node:Node<T,G,K>) -> node.id.has_name_like(head)
          ).or(
            //TODO what's the fail condition?
            () -> __.option(this.children().head())//whatever the default path was 
          ).map((child:Tree<T,G,K>) -> child.path(path.tail()))
          .map(LinkedList.pure)
          .def(LinkedList.unit)
        );
      case [Some(node),None] if (node.type == One) : 
        make(node,
          __.option(this.children().head())
            .map((tree:Tree<T,G,K>) -> tree.path(path.tail()))
            .map(LinkedList.pure)
            .def(LinkedList.unit)
        );
      case [Some(node),None]        :
        make(
          node,
          this.children().map(
            (tree:Tree<T,G,K>) -> {
              return tree.path(path.tail());
            }
          )
        );
      case [Some(node),Some(head)]  :
        make(
          node,
          this.children()
            .lfold(
              (next:Tree<T,G,K>,memo:LinkedList<KaryTree<Node<T,G,K>>>) -> {
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
              (tree:Tree<T,G,K>) -> {
                return tree.path(path.tail());
              }
            )
        );
      default : unit();
    }
  }
  public function value():Option<Node<T,G,K>>{
    return __.option(this.value());
  }
  public function has_head_value_equals(that:Tree<T,G,K>){
    return value().zip(that.value()).map(__.decouple((l:Node<T,G,K>,r:Node<T,G,K>) -> l.equals(r)));
  }
  public function toString():String{
    return KaryTree._.toString(this);
  }
}
class TreeLift{
  /**
    Produces the Tree representing the downward activation path.
  **/
  static public function divergence<T,G,K>(tree:Tree<T,G,K>,path:Path):Res<TransitionData<T,G,K>,WalkerFailure>{
    var active  = tree.active();
    var next    = tree.path(path);
    
    function are_same(lhs:Tree<T,G,K>,rhs:Tree<T,G,K>){
      return lhs.value().zip(rhs.value())
        .map(
          __.decouple(
            (l:Node<T,G,K>,r:Node<T,G,K>) -> l.id.has_name_like(r.id)
          )
        ).defv(true);
    }
    function have_same_size(l:Tree<T,G,K>,r:Tree<T,G,K>){
      return l.children().size() == r.children().size();
    }
    function have_same_children(l:Tree<T,G,K>,r:Tree<T,G,K>){
      return l.children().zip(r.children()).toArray().all(
        (next:Twin<Tree<T,G,K>>) -> next.decouple(are_same)
      );
    }
    function rec(lhs:Tree<T,G,K>,rhs:Tree<T,G,K>):Res<Option<Twin<Tree<T,G,K>>>,WalkerFailure>{
      return are_same(lhs,rhs).if_else(
        () -> have_same_size(lhs,rhs).if_else(
          () -> {
            return have_same_children(lhs,rhs).if_else(
              () -> lhs.children().zip(rhs.children()).lfold(
                (next:Twin<Tree<T,G,K>>,memo:Res<Option<Twin<Tree<T,G,K>>>,WalkerFailure>) -> memo.flat_map(
                  (opt:Option<Twin<Tree<T,G,K>>>) -> opt.fold(
                    (v) -> __.accept(Some(v)),
                    ()  -> next.decouple(rec)  
                  )
                ),
                __.accept(None)
              ),
              () -> __.accept(Some(__.couple(lhs,rhs)))
            );
          },
          () -> __.reject(__.fault().of(E_Walker_AreDifferentNodes))
        ),
        () -> __.reject(__.fault().of(E_Walker_AreDifferentNodes))
      );
    }
    var out =  rec(active,next);
    return out.flat_map(
      (opt:Option<Twin<Tree<T,G,K>>>) -> opt.map(
        (couple:Twin<Tree<T,G,K>>) -> TransitionData.make(tree,path,couple.fst(),couple.snd())
      ).resolve(
        f -> f.of(E_Walker_CannotFindName(path.toStringArray(),null))
      )
    );
  }
  /**
    Produces a Path for the natural transition, selecting the first child of each branch
  **/
  static public function fetch_default_path<T,G,K>(self:Tree<T,G,K>){
    function rec(tree:Tree<T,G,K>,path:Path):Path {
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