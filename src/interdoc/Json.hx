package interdoc;
import haxe.Json;
import interdoc.EElement.EElements;
import interdoc.EParagraph;
import tjson.TJSON;
using StringTools;

/**
 * Persistence
 * @author Jonas Nyström
 */
class Json 
{

	static public function toJson(pars:EParagraphs):String {
		var dyn = Json.parsToDyn(pars);	
		var json = TJSON.encode(dyn, 'fancy', false, true);
		return json;
	}
	
	static public function fromJson(jsonStr:String):EParagraphs {
		var dynPars = Json.jsonToDyn(jsonStr);
		return Json.dynParsToPars(dynPars);				
	}
	
	static public function parsToDyn(pars:EParagraphs) 
	{
		return pars.map(function(par) return parToDyn(par));
	}	
	
	static public function parToDyn(par:EParagraph):Dynamic {
		var typename = par.getName();
		var obj:Dynamic = switch par {
			case UL(elss), OL(elss): {
				var elssObj = elss.map(function(els) return {
					return els.map(function(el) return elToDyn(el));
				});
				{type: typename, elss:elssObj };
			}
			case Table(rows): {
				var rowsDyn = rows.map(function(row) return rowToDyn(row));
				{type: typename, rows: rowsDyn};
			}
			case Elements(els), P(els), Span(els), H1(els), H2(els), H3(els), H4(els)  : {
				var elsJsons =  els.map(function(el) return elToDyn(el));
				{type: typename, els:elsJsons };
			}
		};
		return obj;		
	}
	
	static private function rowToDyn(row:ETablerow) :Dynamic
	{
		var typename = row.getName();
		
		var pars = switch row {
			case THead(pars), TBody(pars), TFoot(pars): pars;
		}
		var parsDyn = pars.map(function(par) return parToDyn(par));
		
		var obj:Dynamic = switch row {
			case THead(pars): { type:typename, pars:parsDyn };
			case TBody(pars): { type:typename, pars:parsDyn };
			case TFoot(pars): { type:typename, pars:parsDyn };
		}
		return obj;
	}
	
	
	public static function elToDyn(el:EElement):Dynamic {		
		var typename = el.getName();
		var obj:Dynamic = switch el {
			case S(text), B(text), I(text): { type:typename, text:text };
			case LnBr, NbSp: { type:typename }
			case Ref(refs, els): {
				var refJsons = refs.map(function(ref) return refToDyn(ref));
				var elsJsons = els.map(function(el) return elToDyn(el));
				{type: typename, refs:refJsons, els:elsJsons };
			}
			case Img(src, width, height): { type:typename, src:src, widht:width, height:height };
		}
		return obj;		
	}
	
	
	
	public static function refToDyn(ref:ERef):Dynamic {
		var typename = ref.getName();
		var obj:Dynamic = switch ref {
			case Href(href): { type:typename, href:href };
			case Bookmark(tag): { type:typename, tag: tag};
			case Index(key): { type:typename, key: key};
		};
		return obj;		
	}
	
	public static function tablerowToDyn(row:ETablerow):Dynamic {
		var typename = row.getName();
		var obj:Dynamic = switch row {
			case THead(pars), TBody(pars), TFoot(pars): {
				trace(pars);
				var parsDyn = parsToDyn(pars);
				return { type:typename,pars:parsToDyn(parsDyn)};
			}
		};
		return obj;			
	}
	
	//--------------------------------------------------------------------------------------------------------------------------------------
	
	
	static public function jsonToDyn(str:String) :Array<Dynamic> {
		var dyn = TJSON.parse(str);
		return dyn;
	}
	
	static public function dynParsToPars(dynPars:Array<Dynamic>):EParagraphs {
		return dynPars.map(function(dynPar) return dynParToPar(dynPar));		
	}
	
	static public function dynParToPar(dynPar:Dynamic):EParagraph {
		var type = dynPar.type;
		var par = switch  type {
			case 'Elements', 'P', 'Span', 'H1', 'H2', 'H3', 'H4': {
				var dynEls = dynPar.els;
				var els = dynEls.map(function(dynEl) return dynElToEl(dynEl));
				return switch type {
					case 'Elements': Elements(els);
					case 'P': P(els);
					case 'Span': Span(els);
					case 'H1': H1(els);
					case 'H2': H2(els);
					case 'H3': H3(els);
					case 'H4': H4(els);
					case _ : {
						throw "Unknown EParagraph $type";				
						return null;
					}
				}
			}
			case 'UL', 'OL': {
				
				var dynElss = dynPar.elss;
				var elss = dynElss.map(function(dynEls) return dynEls.map(function(dynEl) return dynElToEl(dynEl)));
				if (type == 'UL') 	return UL(elss);
				if (type == 'OL') 	return OL(elss);
				throw "Unknown EParagraph $type";				
				return null;
			}
			case 'Table': {
				var dynRows = dynPar.rows;
				var rows = dynRows.map(function(dynRow) {
					return dynRowToRow(dynRow);
				});
				return Table(rows);
			}
			case _ :  {				
				throw "Unknown EParagraph $type";				
				return null;
			}
		}	
		
		return par;
	}
	
	static private function dynRowToRow(dynRow:Dynamic) :ETablerow
	{
		
		var type = dynRow.type;
		var pars = dynRow.pars.map(function(dynPar) return dynParToPar(dynPar));
		
		switch type {
			case 'THead': return ETablerow.THead(pars);
			case 'TBody': return ETablerow.TBody(pars);
			case 'TFoot': return ETablerow.TFoot(pars);
			case _ :  {
				throw "Unknown EElement $type";				
				return null;
			}			
			
		}
	}
	
	static private function dynElToEl(dynEl:Dynamic) :EElement
	{
		var type = dynEl.type;
		switch type {
			case 'S', 'B', 'I': {
				var text = dynEl.text;
				return switch type {
					case 'S': EElement.S(text);
					case 'B': EElement.B(text);
					case 'I': EElement.I(text);
					case _ :  {
						throw "Unknown EElement $type";				
						return null;
					}					
				}
			}
			case 'LnBr': return EElement.LnBr;
			case 'NbSp': return EElement.NbSp;
			case 'Ref': {
				var els = dynEl.els.map(function(dynEl) return dynElToEl(dynEl));				
				var refs = dynEl.refs.map(function(dynRef) return dynRefToRef(dynRef));
				return EElement.Ref(refs, els);
			}
			case 'Img': {
				return EElement.Img(dynEl.src, dynEl.width, dynEl.height);
			}
			case _ :  {
				throw "Unknown EElement $type";				
				return null;
			}
		}
		
		return null;
	}
	
	static public function dynRefToRef(dynRef:Dynamic): ERef
	{
		var type = dynRef.type;
		return switch type {
			case 'Href': return ERef.Href(dynRef.href);
			case 'Bookmark':return ERef.Bookmark(dynRef.tag);
			case 'Index':return ERef.Index(dynRef.key);
			case _ :  {
				throw "Unknown ERef $type";				
				return null;
			}			
		}
		
	}
	
}