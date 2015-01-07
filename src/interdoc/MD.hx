package interdoc;
import interdoc.EParagraph.EParagraphs;
import markdown.HtmlRenderer;
import Markdown;
using StringTools;
using Lambda;
using cx.ArrayTools;
/**
 * MD
 * @author Jonas Nyström
 */
class MD 
{

	static public function toHtml(md:String):String 
	{
		var lines = ~/\n\r/g.replace(MarkdownExample.test, '\n').split("\n");
		var blocks = new Document().parseLines(lines);
		var html = new HtmlRenderer().render(blocks);
		return html.replace('\n', '');		
	}
	
	static public function toMd(pars:EParagraphs) {
		
		var mdstrs:Array<String> = [''];
		
		for (par in pars) {
			mdstrs = parToMd(mdstrs, par);
		}
		
		return mdstrs.join('\n');
		
	}
	
	static private function parToMd(mdstrs:Array<String>, par:EParagraph) 
	{
		//trace(mdstrs);
		var type = par.getName();
		switch par {

			case Table(rows): {
				
			}
			
			case Span(els): {
				var elmdstrs = [''];
				for (el in els) {
					elmdstrs = elToMd(elmdstrs, el);
				}				
				
				var correctedElmdstrs = elmdstrs.join(' ').replace(' ...', '...');
				mdstrs.last() += correctedElmdstrs;
			}
			
			case Elements(els), P(els), H1(els), H2(els), H3(els), H4(els): {				
				mdstrs.push('\n');				
				var elmdstrs = [];
				for (el in els) {
					elmdstrs = elToMd(elmdstrs, el);
				}
				
				var correctedElmdstrs = elmdstrs.join(' ').replace(' ...', '...');
				
				switch par {
					case P(els): mdstrs.push(correctedElmdstrs);
					case H1(els): mdstrs.push ('# ' + correctedElmdstrs);
					case H2(els): mdstrs.push ('## ' + correctedElmdstrs);
					case H3(els): mdstrs.push ('### ' + correctedElmdstrs);
					case H4(els): mdstrs.push ('#### ' + correctedElmdstrs);
					case _:
				}
			}
			
			case UL(elss), OL(elss): {				
				var i = 1;
				mdstrs.push('\n');
				for (els in elss) {
					var elmdstrs = [];
					for (el in els) {
						elmdstrs = elToMd(elmdstrs, el);						
					}	
					
					var correctedElmdstrs = elmdstrs.join(' ').replace(' ...', '...');
					if (type == 'UL') mdstrs.push(' * ' + correctedElmdstrs);
					if (type == 'OL') mdstrs.push(' ${i++}. ' + correctedElmdstrs);					
				}
			}
			
			case _: 
		}
		//trace(mdstrs);
		return mdstrs;
	}
	
	static private function elToMd(elmdstrs:Array<String>, el:EElement) 
	{
		//trace(elmdstrs);
		switch el {
			case S(text): elmdstrs.push('$text');
			case B(text): elmdstrs.push('**$text**');
			case I(text): elmdstrs.push('*$text*');
			case LnBr: elmdstrs.push('///Linebreak/// ');
			case _: {
				
			}
		}
		//trace(elmdstrs);
		return elmdstrs;
	}
	
}