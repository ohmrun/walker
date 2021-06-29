package eu.ohmrun.walker.html5.data;

class Util{
  static public function toCluster(self:NodeList):Cluster<js.html.Node>{
    var array = [];
    for(node in self){
      array.push(node);
    }
    return Cluster.lift(array);
  }
}