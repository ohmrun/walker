package eu.ohmrun.hsm;

typedef TreeDef<T,G> = KaryTree<Node<T,G>>;
@:using(eu.ohmrun.hsm.Tree.TreeLift)
@:forward abstract Tree<T,G>(TreeDef<T,G>) from TreeDef<T,G> to TreeDef<T,G>{
  static public inline function dbg(){
    return __.log().tag("eu.ohmrun.hsm").level(TRACE);
  }
  static public inline function log_path(){
    return dbg().tag('eu.ohmrun.hsm.Tree.path');
  }
  @:noUsing inline static public function unit<T,G>():Tree<T,G>               return lift(Nought);
  @:noUsing inline static public function pure<T,G>(v:Node<T,G>):Tree<T,G>      return lift(Branch(v,Nil));
  @:noUsing inline static public function make<T,G>(v:Node<T,G>,rest:LinkedList<Tree<T,G>>):Tree<T,G> return lift(Branch(v,rest));
  @:noUsing static public function lift<T,G>(self:TreeDef<T,G>){
    return new Tree(self);
  }
  public function new(self) this = self;

  public function active():Tree<T,G>{
    return switch(__.option(this.value()).map(_ -> _.type)){
      case Some(All) : 
        lift(Branch(
          this.value(),
          this.children().map(
            (x:KaryTree<Node<T,G>>) -> (x:Tree<T,G>).active()
          )
        ));
      case Some(One) : 
        lift(Branch(
          this.value(),
          __.option(this.children().head()).map(x -> (x:Tree<T,G>).active()).map(LinkedList.pure).defv(null)
        ));
      case None   :
        lift(Nought);
    }
  }
  public function get(id:Id):Option<Tree<T,G>>{
    return this.children().search(
      (tree:Tree<T,G>) -> tree.value().map(
        node -> node.id.has_name_like(id)
      ).defv(false)
    );
  }
  public function path(path:Path,?depth=0):Tree<T,G>{
    __.log()('path $path on ${this.value()}');
    return switch([__.option(this.value()),path.head()]){
      case [Some(node),Some(head)] if (node.type == One) : 
        make(
          node,
          this.search_child(
            (node:Node<T,G>) -> node.id.has_name_like(head)
          ).or(
            //TODO what's the fail condition?
            () -> __.option(this.children().head())//whatever the default path was 
          ).map((child:Tree<T,G>) -> child.path(path.tail()))
          .map(LinkedList.pure)
          .def(LinkedList.unit)
        );
      case [Some(node),None] if (node.type == One) : 
        make(node,
          __.option(this.children().head())
            .map((tree:Tree<T,G>) -> tree.path(path.tail()))
            .map(LinkedList.pure)
            .def(LinkedList.unit)
        );
      case [Some(node),None]        :
        make(
          node,
          this.children().map(
            (tree:Tree<T,G>) -> {
              return tree.path(path.tail());
            }
          )
        );
      case [Some(node),Some(head)]  :
        make(
          node,
          this.children()
            .lfold(
              (next:Tree<T,G>,memo:LinkedList<KaryTree<Node<T,G>>>) -> {
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
              (tree:Tree<T,G>) -> {
                return tree.path(path.tail());
              }
            )
        );
      default : unit();
    }
  }
  public function value():Option<Node<T,G>>{
    return __.option(this.value());
  }
  public function has_head_value_equals(that:Tree<T,G>){
    return value().zip(that.value()).map(__.decouple((l:Node<T,G>,r:Node<T,G>) -> l.equals(r)));
  }
  public function toString():String{
    return KaryTree._.toString(this);
  }
}
class TreeLift{
  /**
    Produces the Tree representing the downward activation path.
  **/
  static public function divergence<T,G>(tree:Tree<T,G>,path:Path):Res<TransitionData<T,G>,HsmFailure>{
    var active  = tree.active();
    var next    = tree.path(path);
    
    function are_same(lhs:Tree<T,G>,rhs:Tree<T,G>){
      return lhs.value().zip(rhs.value())
        .map(
          __.decouple(
            (l:Node<T,G>,r:Node<T,G>) -> l.id.has_name_like(r.id)
          )
        ).defv(true);
    }
    function have_same_size(l:Tree<T,G>,r:Tree<T,G>){
      return l.children().size() == r.children().size();
    }
    function have_same_children(l:Tree<T,G>,r:Tree<T,G>){
      return l.children().zip(r.children()).toArray().all(
        (next:Twin<Tree<T,G>>) -> next.decouple(are_same)
      );
    }
    function rec(lhs:Tree<T,G>,rhs:Tree<T,G>):Res<Option<Twin<Tree<T,G>>>,HsmFailure>{
      return are_same(lhs,rhs).if_else(
        () -> have_same_size(lhs,rhs).if_else(
          () -> {
            return have_same_children(lhs,rhs).if_else(
              () -> lhs.children().zip(rhs.children()).lfold(
                (next:Twin<Tree<T,G>>,memo:Res<Option<Twin<Tree<T,G>>>,HsmFailure>) -> memo.flat_map(
                  (opt:Option<Twin<Tree<T,G>>>) -> opt.fold(
                    (v) -> __.accept(Some(v)),
                    ()  -> next.decouple(rec)  
                  )
                ),
                __.accept(None)
              ),
              () -> __.accept(Some(__.couple(lhs,rhs)))
            );
          },
          () -> __.reject(__.fault().of(E_Hsm_AreDifferentNodes))
        ),
        () -> __.reject(__.fault().of(E_Hsm_AreDifferentNodes))
      );
    }
    var out =  rec(active,next);
    return out.flat_map(
      (opt:Option<Twin<Tree<T,G>>>) -> opt.map(
        (couple:Twin<Tree<T,G>>) -> TransitionData.make(tree,path,couple.fst(),couple.snd())
      ).resolve(
        f -> f.of(E_Hsm_CannotFindName(path,null))
      )
    );
  }
  /**
    Produces a Path for the natural transition, selecting the first child of each branch
  **/
  static public function fetch_default_path<T,G>(self:Tree<T,G>){
    function rec(tree:Tree<T,G>,path:Path):Path {
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