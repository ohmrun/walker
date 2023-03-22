package eu.ohmrun.walker.html5.data;

#if js
class Util{
  static public function toCluster(self:NodeList):Cluster<js.html.Node>{
    var array = [];
    for(node in self){
      array.push(node);
    }
    return Cluster.lift(array);
  }
}
#end