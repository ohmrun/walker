package eu.ohmrun.walker.html5.data;

import stx.ds.kary_tree.KaryTreeZip;

class Port<T,G,K,E> extends coconut.ui.View{
  @:ref                   var self      : Element;
  @:attribute             var children  : coconut.ui.Children;
  @:attribute             var history   : History<T,G,K,E>;
  @:skipCheck @:implicit  var register  : Register;
    
  function render() '<div class="port history_node" ref=${self} >${...children}</div>';

  function viewDidMount(){
    trace("mounted");
    final nodes     = Cluster.lift(Iter._.toArray(register))
      .map_filter(
        node -> try{
            node();
            None;
          }catch(e:Node<Dynamic,Dynamic,Dynamic,Dynamic>){
            var node : Node<T,G,K,E> = __.option(eu.ohmrun.walker.html5.data.Node.lift(Std.downcast(e.prj(),NodeCls))).fudge("GI/GO");
            Some(new Discriminator(node));
          }
      );
    final nodes_hash : StringMap<Node<T,G,K,E>> = new StringMap();
    for(node in nodes){
      nodes_hash.set(node.node.el.id,node.node);
    }
    final next = nodes.rfold(
      (next:Discriminator<T,G,K,E>, memo: { rest : Cluster<Node<T,G,K,E>>, data : Cluster<Discriminator<T,G,K,E>> }) -> {
        var substates = next.get_substates().map(x -> downcast(x,Element)).map(
          x -> nodes_hash.get(x.id)
        );
        var unique    = substates.filter(
          elem -> !memo.rest.any(x -> x.el.id == elem.el.id)
        );
        return {
          rest : memo.rest.concat(substates),
          data : memo.data.snoc(next.with_unique(unique))
        }
      },
      {
        rest : Cluster.unit(),
        data : Cluster.unit()
      }
    );
    final next1 = next.data.lfold(
      (next:Discriminator<T,G,K,E>,memo : { last : KaryTree<eu.ohmrun.Node<T,G,K,E>>, data : Cluster<Discriminator<T,G,K,E>>, rest : StringMap<KaryTree<eu.ohmrun.Node<T,G,K,E>>> } ) -> {
        final children = next.unique.map(
          (node) -> if(memo.rest.exists(node.el.id)){
            memo.rest.get(node.el.id);
          }else{
            KaryTree.pure(node.getNodeSpec());
          }
        );      
        final tree = Branch(next.node.getNodeSpec(),LinkedList.fromCluster(children));
        memo.rest.set(next.node.el.id,tree);
        memo.last = tree;
        return memo;
      },
      {
        last : KaryTree.unit(),
        data : Cluster.unit(),
        rest : new StringMap()
      }
    );
    final tree : eu.ohmrun.walker.Tree<T,G,K,E> = next1.last;
    trace(tree);
    //$type(history.tree);
    history.tree = tree;
    history.initialize();
  }
  public function get_substates(){
    trace('get substates for Port');
    final nodes = self.querySelectorAll('.history_node').toCluster();
    //trace(nodes.map(x -> downcast(x,Element)).map(x ->x.id));
   
    return nodes;
  }
}





private class Discriminator<T,G,K,E>{
  public final node      : Node<T,G,K,E>;
  public final unique    : Cluster<Node<T,G,K,E>>;
  public final tree      : StringMap<KaryTree<Element>>;

  public function new(node,?unique,?tree){
    this.node     = node;
    this.unique   = __.option(unique).def(Cluster.unit);
    this.tree  
       = __.option(tree).defv(new StringMap());
  }
  public function with_unique(unique){
    return copy(null,unique,tree);
  }
  public function copy(?node,?unique,?tree){
    return new Discriminator(
      __.option(node).defv(this.node),
      __.option(unique).defv(this.unique),
      __.option(tree).defv(this.tree)
    );
  }
  public function toString():String{
    var vals = unique.map(x -> x.el.id).lfold1((n,m) -> '$m, $n');
    return 'Discriminator (${node.el.id} of ${vals})';
  }
  public function get_substates(){
    return this.node.get_substates();
  }
}