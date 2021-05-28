using eu.ohmrun.Walker;

class Main {
	static function main() {
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
					
		eu.ohmrun.walker.Test.main();
	}
}