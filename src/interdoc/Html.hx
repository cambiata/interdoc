package interdoc ;
import interdoc.EElement;
import interdoc.EParagraph;
import interdoc.ETablerow;
using interdoc.Html;
using Lambda;
using StringTools;
using cx.ArrayTools;
/**
 * ...
 * @author Jonas Nyström
 */
class Html
{
	static function eGetHtml(e:EElement)
	{
		return switch e {
			case EElement.S(s): s.trim();
			case EElement.B(s): '<b>' + s.trim()+'</b>';
			case EElement.I(s): '<i>' + s.trim() + '</i>';
			case EElement.Ref(refs, els): 
				for (ref in refs) {
					return switch ref {
						case ERef.Href(href): '<a href="$href">' + els.elsGetHtml() + '</a>';
						case _: 'xxxx';
					}
				}
				return 'x';
			case EElement.LnBr: '<br />';
			case EElement.Img(src, width, height): { return '<img src="$src" ' + ((width != null) ? 'width="$width" ':'width=""') + ((height != null)?'height="$height" ':'height=""') + ' />'; };
			case x: { throw 'Non implemented EElement: $x'; return ''; };
		}
	}
	
	
	static  function elsGetHtml(els:EElements)
	{
		return els.map(function(e) return e.eGetHtml()).join(' ');
	}
	
	static  function pGetHtml(p:EParagraph)
	{
		return switch p {
			case EParagraph.P(els): '<p>' + els.elsGetHtml() + '</p>';
			case EParagraph.Span(els): '<span>' + els.elsGetHtml() + '</span>';
			case EParagraph.H1(els):  '<h1>' + els.elsGetHtml() + '</h1>';
			case EParagraph.H2(els): '<h2>' + els.elsGetHtml() + '</h2>';
			case EParagraph.H3(els): '<h3>' + els.elsGetHtml() + '</h3>';
			case EParagraph.UL(els): '<ul>' + els.map(function(el) return '<li>' +  el.elsGetHtml() + '</li>').join('') + '</ul>';
			case EParagraph.OL(els): '<ol>' + els.map(function(el) return '<li>' +  el.elsGetHtml() + '</li>').join('') + '</ol>';
			case EParagraph.Table(rows): '<table>' + rows.rowsGetHtml() + '</table>';
			case EParagraph.Elements(els): els.elsGetHtml();
			case x: { throw 'Non implemented paragraph type: $x'; return ''; };
		}
	}
	
	static function  rowsGetHtml(rows:ETablerows) 
	{
		return rows.map(function(row) return switch row {
			case TBody(pars): '<tr>' + pars.map(function(par) return '<td>' +  par.pGetEls().elsGetHtml() + '</td>' ).join('') + '</tr>';
			case THead(pars): '<tr>' + pars.map(function(par) return '<td>' +  par.pGetEls().elsGetHtml() + '</td>' ).join('') + '</tr>';
			case TFoot(pars): '<tr>' + pars.map(function(par) return '<td>' +  par.pGetEls().elsGetHtml() + '</td>' ).join('') + '</tr>';
		}).join('') ;
	}

	static  function pGetEls(p:EParagraph)
	{
		return switch p {
			case EParagraph.P(els) | Span(els) | H1(els) | H2(els) | H3(els) | H4(els) | Elements(els): els;
			case _: throw "Can't get els out of this type: " + p.getName();
		}
	}
	
	
	static public function toHtml(pars:EParagraphs, wrapEl:String='')
	{		
		var parStrings  = pars.map(function(p) return p.pGetHtml());
		var html = parStrings.join('\n');
		if (wrapEl != '') html = '<$wrapEl>$html</$wrapEl>';
		return html;
	}
	
	//--------------------------------------------------------------------------------------------------------------------------------------
	
	static var validTags = ['p', 'span', 'h1', 'h2', 'h3', 'h4', 'ul', 'table', 'thead', 'tbody', 'tfoot', 'tr', 'td', 'a', 'b', 'i', 'strong', 'em', ''];
	static public function fromHtml(html:String):EParagraphs {
		
		var xml = Xml.parse(html);
		
		// wrap in a div, if needed, to get an array of valid paragraphs
		var firstElement = xml.firstElement().nodeName;
		if (validTags.has(firstElement.toLowerCase())) { 
			xml = Xml.parse('<div>$html</div>');
		}
		//var firstElement = xml.firstElement().nodeName;
		//trace (firstElement);
		
		var pars = new EParagraphs();
		for (el in xml.firstElement()) {			
			
			switch el.nodeType {
				case Xml.Element: {
					//trace('element'); 
					pars.push(parseParagraph(el));
				}
				case Xml.PCData: {					
					//trace('pcdata $el');
					var txt = Std.string(el).trim();
					//trace(txt.length);
					if (txt.length > 0) {
						var newEl = Xml.parse('<span>$txt</span>').elements().next();
						pars.push(parseParagraph(newEl));
					}
				}
			}
		}
		
		return pars;
	}
	
	static public function parseParagraph(xml:Xml):EParagraph {		
		
		//trace('............................................................');
		//trace(xml);
		//trace(xml.count());
		var childCount = xml.count();
		//trace(xml.nodeName);		
		
		return switch xml.nodeName {
			case 'p', 'span', 'h1', 'h2', 'h3', 'h4': {
				
				var els = new EElements();
				for (i in 0 ... childCount) {
					var child = xml.array()[i];
					switch child.nodeType {
						case Xml.Element: {
							//trace('element'); 
							els.push(parseElement(child));
						}
						case Xml.PCData: {					
							//trace('pcdata $el');
							var txt = Std.string(child).trim();
							//trace(txt.length);
							if (txt.length > 0) {
								var newEl = Xml.parse('<span>$txt</span>').elements().next();
								els.push(EElement.S(txt));
							}
						}
					}					
					
				}
				
				return switch xml.nodeName {
					case 'p': EParagraph.P(els);
					case 'span': EParagraph.Span(els);
					case 'h1': EParagraph.H1(els);
					case 'h2': EParagraph.H2(els);
					case 'h3': EParagraph.H3(els);
					case 'h4': EParagraph.H4(els);
					case _: null;
				}
			}
			
			
			case 'ul', 'ol': {
				
				var elss = new Array<EElements>();
				for (elLi in xml) {
					
					var childCount = elLi.count();
					
					var els = new EElements();
					for (i in 0 ... childCount) {
						var child = elLi.array()[i];
						
						switch child.nodeType {
							case Xml.Element: {
								//trace('element'); 
								var el = parseElement(child);
								els.push(el);
							}
							case Xml.PCData: {					
								//trace('pcdata $el');
								var txt = Std.string(child).trim();
								//trace(txt.length);
								if (txt.length > 0) {
									var newEl = Xml.parse('<span>$txt</span>').elements().next();
									els.push(EElement.S(txt));
								}
							}
						}					
						
					}					
					elss.push(els);
				}
				
				if (xml.nodeName == 'ul') return EParagraph.UL(elss);
				if (xml.nodeName == 'ol') return EParagraph.OL(elss);
				throw ('Unmatched pattern');
				
			}	
			
			case 'table': {
				
				var rows = new ETablerows();
				for (child in xml) {
					var nodename = child.nodeName;
					switch nodename {						
						case 'tr': {
							var pars = new EParagraphs();
							//for (el in child.firstElement()) {			
							for (tdi in 0 ... child.count()) {	
								
								var td = child.array()[tdi];
								for (tdchi in 0 ... td.count()) {
									
									var el = td.array()[tdchi];
									
									switch el.nodeType {
										case Xml.Element: {
											//trace('element'); 
											pars.push(parseParagraph(el));
										}
										case Xml.PCData: {					
											//trace('pcdata $el');
											var txt = Std.string(el).trim();
											//trace(txt.length);
											if (txt.length > 0) {
												var newEl = Xml.parse('<span>$txt</span>').elements().next();
												pars.push(parseParagraph(newEl));
											}
										}
									}
								}
							}							
							
							rows.push(ETablerow.TBody(pars));
						}						
					}					
				}
				return EParagraph.Table(rows);
			}
			
			
			case _:
			
		}			
		
		return null;
	}
	
	static private function parseElement(xml:Xml) 
	{
		//trace('========================');
		//trace(xml);
		//trace(xml.count());
		var childCount = xml.count();
		//trace(xml.nodeName);			
		
		var el:EElement = switch xml.nodeName {
			case 'b', 'i', 'strong', 'em': {
				var text = Std.string(xml.array()[0]);
				
				return switch xml.nodeName {
					case 'b', 'strong': EElement.B(text);
					case 'i', 'em' : EElement.I(text);
					case _: null;
				}
				//trace(text);
				//null;
			}
			
			case 'a': {
				var href = xml.get('href');
				
				var els = new EElements();
				for (i in 0 ... childCount) {
					var child = xml.array()[i];
					switch child.nodeType {
						case Xml.Element: {
							//trace('element'); 
							els.push(parseElement(child));
						}
						case Xml.PCData: {					
							//trace('pcdata $el');
							var txt = Std.string(child).trim();
							//trace(txt.length);
							if (txt.length > 0) {
								var newEl = Xml.parse('<span>$txt</span>').elements().next();
								els.push(EElement.S(txt));
							}
						}
					}					
				}		
				var refs = [ERef.Href(href)];
				return EElement.Ref(refs, els);
			}
			
			case 'img': {
				var src = xml.get('src');
				var widthStr = xml.get('width').trim();
				var width = (widthStr == '') ? null: Std.parseFloat(widthStr);
				var heightStr = xml.get('height').trim();				
				var height = (heightStr == '') ? null: Std.parseFloat(heightStr);
				return EElement.Img(src, width, height);
			}
			
			case 'hr': return EElement.LnBr;
			
			case _ : null;
		}
		return null;
	}	
	

	
	static public function htmlParsePar(xml:Xml):EParagraph {
		return null;
	}
	
}