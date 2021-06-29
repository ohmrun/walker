package eu.ohmrun.walker.html5;

typedef Swap<T,G,K,E>             = eu.ohmrun.walker.html5.data.Swap<T,G,K,E>;
typedef Rack<T,G,K,E>							= eu.ohmrun.walker.html5.data.Rack<T,G,K,E>;

typedef Port<T,G,K,E>							= eu.ohmrun.walker.html5.data.Port<T,G,K,E>;
typedef Into<T,G,K,E>           	= eu.ohmrun.walker.html5.data.Into<T,G,K,E>;
typedef Node<T,G,K,E>							= eu.ohmrun.walker.html5.data.Node<T,G,K,E>;
typedef NodeSum<T,G,K,E>					= eu.ohmrun.walker.html5.data.Node.NodeSum<T,G,K,E>;
typedef NodeCls<T,G,K,E>					= eu.ohmrun.walker.html5.data.Node.NodeCls<T,G,K,E>;
typedef Util 											= eu.ohmrun.walker.html5.data.Util;
typedef NodeId 										= eu.ohmrun.walker.html5.data.NodeId;

class History<T,G,K,E> implements coconut.data.Model{
	@:editable 		var state 			: G;
  @:editable    var location  	: String                            		= "";
  @:computed    var path      	: eu.ohmrun.walker.Path             		= locationToPath(location);
	@:editable 		var register 		: RedBlackMap<String,Node<T,G,K,E>>			= RedBlackMap.make(Comparable.String()); 
	@:observable 	var machine 		: Machine<T,G,K,E> 											= @byDefault null; 											
	@:editable 		var tree 				: Tree<T,G,K,E> 												= KaryTree.unit();

	@:transition public function initialize(){
		trace('initialize $machine');
		final result = Promise.trigger();
		return if(machine == null){
			final m 					= new Machine(tree);
			final transition 	= m.activator();
						transition.reply().environment(
							Context.make(Message.unit(),state),
							(ok) -> {
								final patch : Patch<History<T,G,K,E>> = { machine : transition.next() };
								this.state = ok.global;
								result.resolve(patch);
							},
							no 	-> {
								result.reject(no.toTinkError());
							}
						).submit();
			return result.asPromise();
		}else{
			var m = machine.copy(tree);
			final patch : Patch<History<T,G,K,E>> = { machine : m };
			result.resolve(patch);
			result;
		}
	}
	@:transition function next_machine(machine:Machine<T,G,K,E>){
		final patch : Patch<History<T,G,K,E>> = { machine : machine };
		return patch;
	}
  function locationToPath(url:Url):eu.ohmrun.walker.Path{
		trace(url);
    return eu.ohmrun.walker.Path.lift(url.path.parts().toStringArray().map(x -> Id.make(x)));
  }
  function isExternalLink(href:String) return href.indexOf('//') >= 0;
	
  public function intercept(element:Element) {
		if(element != null) element.addEventListener('click', listener);
	}
	public function listener(event:js.html.Event) {
		switch (cast event.target:Element).closest('a') {
			case null       :
			case anchor     : 
				switch anchor.getAttribute('href') {
					case null   : // do nothing
					case href if(isExternalLink(href)): // let browser handle
					case href   :
						event.preventDefault();
						// assume the href is a valid route for Router<T> ?
						location = href;
						var path 				= locationToPath(location);
						//trace(path);
						var transition 	= machine.to(path).fudge();
						var nref = 
								transition.data.into
									.df()
									.array()
									.map(
										(x -> x.id.name)
									).lfold(
										(n,m) -> '${m}/${n}',
										""
									);
						trace(nref);
								transition.reply().environment(
									Context.make(Message.unit(),state),
									(ok) -> {
										this.state = ok.global;
										next_machine(transition.next());
										Location.push(href);
									},
									__.crack
								).submit();
				}
		}
	}
} 