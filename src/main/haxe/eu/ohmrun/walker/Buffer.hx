package eu.ohmrun.walker;

typedef BufferDef<T,K> = Array<Stamp<Event<T,K>>>;

@:forward(iterator) abstract Buffer<T,K>(BufferDef<T,K>) from BufferDef<T,K> to BufferDef<T,K>{
  public function new(self) this = self;
  static public function lift<T,K>(self:BufferDef<T,K>):Buffer<T,K> return new Buffer(self);

  // public function sorted():Buffer<T,K>{
  //   return haxe.ds.ArraySort.sort(
  //     this,
  //     (a:Stamp<Message<T,K>>,b:Stamp<Message<T,K>>) -> {
  //       return switch([a.payload.message,b.payload.message]){
  //         case [None,None] : a.timestamp.compare_to(b.compare_to);
  //       }
  //     }
  //   );
  // }
  public function prj():BufferDef<T,K> return this;
  private var self(get,never):Buffer<T,K>;
  private function get_self():Buffer<T,K> return lift(this);
}