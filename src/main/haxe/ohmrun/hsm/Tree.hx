package ohmrun.hsm;

typedef TreeDef<T> = KaryTree<Node<T>>;
@:forward abstract Tree<T>(TreeDef<T>) from TreeDef<T> to TreeDef<T>{
  static public inline function dbg(){
    return __.log().tag("ohmrun.hsm").level(TRACE);
  }
  static public inline function log_path(){
    return dbg().tag('ohmrun.hsm.Tree.path');
  }
  @:noUsing inline static public function unit<T>():Tree<T>               return lift(Nought);
  @:noUsing inline static public function pure<T>(v:Node<T>):Tree<T>      return lift(Branch(v,Nil));
  @:noUsing inline static public function make<T>(v:Node<T>,rest:LinkedList<Tree<T>>):Tree<T> return lift(Branch(v,rest));
  @:noUsing static public function lift<T>(self:TreeDef<T>){
    return new Tree(self);
  }
  public function new(self) this = self;

  public function active():Tree<T>{
    return switch(__.option(this.value()).map(_ -> _.type)){
      case Some(All) : 
        lift(Branch(
          this.value(),
          this.children().map(
            (x:KaryTree<Node<T>>) -> (x:Tree<T>).active()
          )
        ));
      case Some(One) : 
        lift(Branch(
          this.value(),
          __.option(this.children().head()).map(x -> (x:Tree<T>).active()).map(LinkedList.pure).defv(null)
        ));
      case None   :
        lift(Nought);
    }
  }
  public function get(id:Id):Option<Tree<T>>{
    return this.children().search(
      (tree:Tree<T>) -> tree.value().map(
        node -> node.id.has_name_like(id)
      ).defv(false)
    );
  }
  public function path(path:Path,?depth=0):Tree<T>{
    __.log()('path $path on ${this.value()}');
    return switch([__.option(this.value()),path.head()]){
      case [Some(node),Some(head)] if (node.type == One) : 
        make(
          node,
          this.search_child(
            (node:Node<T>) -> node.id.has_name_like(head)
          ).or(
            //TODO what's the fail condition?
            () -> __.option(this.children().head())//whatever the default path was 
          ).map((child:Tree<T>) -> child.path(path.tail()))
          .map(LinkedList.pure)
          .def(LinkedList.unit)
        );
      case [Some(node),None] if (node.type == One) : 
        make(node,
          __.option(this.children().head())
            .map((tree:Tree<T>) -> tree.path(path.tail()))
            .map(LinkedList.pure)
            .def(LinkedList.unit)
        );
      case [Some(node),None]        :
        make(
          node,
          this.children().map(
            (tree:Tree<T>) -> {
              return tree.path(path.tail());
            }
          )
        );
      case [Some(node),Some(head)]  :
        make(
          node,
          this.children()
            .lfold(
              (next:Tree<T>,memo:LinkedList<KaryTree<Node<T>>>) -> {
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
              (tree:Tree<T>) -> {
                return tree.path(path.tail());
              }
            )
        );
      default : unit();
    }
  }
  public function value():Option<Node<T>>{
    return __.option(this.value());
  }
  public function has_head_value_equals(that:Tree<T>){
    return value().zip(that.value()).map(__.decouple((l:Node<T>,r:Node<T>) -> l.equals(r)));
  }
  static public function divergence<T>(tree:Tree<T>,path:Path):Res<TransitionData<T>,HsmFailure>{
    var active  = tree.active();
    var next    = tree.path(path);
    
    function are_same(lhs:Tree<T>,rhs:Tree<T>){
      return lhs.value().zip(rhs.value())
        .map(
          __.decouple(
            (l:Node<T>,r:Node<T>) -> l.id.has_name_like(r.id)
          )
        ).defv(true);
    }
    function have_same_size(l:Tree<T>,r:Tree<T>){
      return l.children().size() == r.children().size();
    }
    function have_same_children(l:Tree<T>,r:Tree<T>){
      return l.children().zip(r.children()).toArray().all(
        (next:Twin<Tree<T>>) -> next.decouple(are_same)
      );
    }
    function rec(lhs:Tree<T>,rhs:Tree<T>):Res<Option<Twin<Tree<T>>>,HsmFailure>{
      return are_same(lhs,rhs).if_else(
        () -> have_same_size(lhs,rhs).if_else(
          () -> {
            return have_same_children(lhs,rhs).if_else(
              () -> lhs.children().zip(rhs.children()).lfold(
                (next:Twin<Tree<T>>,memo:Res<Option<Twin<Tree<T>>>,HsmFailure>) -> memo.flat_map(
                  (opt:Option<Twin<Tree<T>>>) -> opt.fold(
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
      (opt:Option<Twin<Tree<T>>>) -> opt.map(
        (couple:Twin<Tree<T>>) -> TransitionData.make(tree,path,couple.fst(),couple.snd())
      ).resolve(
        E_Hsm_CannotFindName(path,null)
      )
    );
  }
  public function toString():String{
    return KaryTree._.toString(this);
  }
}
@:forward abstract BranchSet<T>(RedBlackSet<Node<T>>) from RedBlackSet<Node<T>> to RedBlackSet<Node<T>>{
  static public function unit(){
    return new BranchSet();
  }
  public function new(){
    this = RedBlackSet.make(
      Comparable.Anon(
        ohmrun.hsm.Node._.eq(),
        ohmrun.hsm.Node._.ord()
      )
    );
  }
}