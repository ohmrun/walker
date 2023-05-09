using eu.ohmrun.Walker;

using stx.Nano;
using stx.Pico;
using stx.Log;

import stx.pico.Nada;

#if js
import js.Browser.*;
import eu.ohmrun.walker.html5.History;
import eu.ohmrun.walker.test.HistoryTest;

import coconut.Ui.hxx;

class Main{
	static public function main(){
		if(document.getElementById('app') == null){
      __.log().info("mount");
      final document            = js.Browser.document;
      final el                  = document.createDivElement();
            el.setAttribute("id",'app');
            document.body.appendChild(el);
      final value               = hxx('<HistoryTestRootView history=${new History({state : Nada})}/>');
            coconut.ui.Renderer.mount(el,value);
	}
}
#else
class Main {
	static function main() {
		trace("main");
		var log_facade = __.log().global;
				//log_facade.includes.push("eu.ohmrun.walker");
				//log_facade.includes.push("eu.ohmrun.walker.test");
				//log_facade.includes.push("stx.async");
				//log_facade.format = [INCLUDE_LOCATION,INCLUDE_DETAIL];
				// log_facade.logic	= 
				// 	stx.log.Logic.make(
				// 		(_) -> 
				// 			log_facade.logic 
				// 			&& _.always()
				// 			//_.tag('x')		
				// 	);
					
		//eu.ohmrun.walker.Test.main();		
	}
}
#end