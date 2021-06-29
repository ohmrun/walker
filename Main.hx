using eu.ohmrun.Walker;

using stx.Nano;
using stx.Pico;
using stx.Log;

#if js
import js.Browser.*;
#end


import tink.core.Noise;
import coconut.Ui.hxx;
import eu.ohmrun.walker.html5.History;
import eu.ohmrun.walker.test.HistoryTest;

class Main {
	static function main() {
		trace("main");
		var log_facade = stx.log.Facade.unit();
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
		if(document.getElementById('app') == null){
      __.log().info("mount");
      final document            = js.Browser.document;
      final el                  = document.createDivElement();
            el.setAttribute("id",'app');
            document.body.appendChild(el);
      final value               = hxx('<HistoryTestRootView history=${new History({state : Noise})}/>');
            coconut.ui.Renderer.mount(el,value);
		}
	}
}