package eu.ohmrun.walker.html5.data;

#if js
class NodeId{
  public final name : String;
  public final uuid : String;
  public function new(name,?uuid){
    this.name = name;
    this.uuid = __.option(uuid).def(__.uuid.bind("xxxxx"));
  }
  public function copy(?name:String,?uuid:String){
    return new NodeId(
      __.option(name).defv(this.name),
      __.option(uuid).defv(this.uuid)
    );
  }
  public function toString(){
    return encode(this);
  }
  public function toId(){
    return Id.make(name,uuid);
  }
  static public function encode(self:NodeId):String{
    return 'walker://${self.name}:${self.uuid}';
  } 
  static public function decode(string:Chars):Option<NodeId>{
    return string.starts_with("walker://").if_else(
      () -> 
        __.option(string.split("walker://")[1]).flat_map(
          inner -> {
            var parts = inner.split(":");
            return (parts.length == 2).if_else(
              () -> Some(new NodeId(parts[0],parts[1])),
              () -> None
            );
          }
        ),
      () -> None
    );
  }
}
#end