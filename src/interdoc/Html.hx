package interdoc ;
import interdoc.EElement;
import interdoc.EParagraph;
import interdoc.ETablerow;

using interdoc.Html;
using Lambda;
using StringTools;
/**
 * ...
 * @author Jonas Nyström
 */
class Html
{

	static public function eGetHtml(e:EElement)
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
			case EElement.Linebreak: '<br />';
			case EElement.Img(src, width, height): { return '<img src="$src" ' + ((width != null) ? 'width="$width" ':'') + ((height != null)?'height="$height" ':'') + ' />'; };
			case x: { throw 'Non implemented EElement: $x'; return ''; };
		}
	}
	
	
	static public function elsGetHtml(els:EElements)
	{
		return els.map(function(e) return e.eGetHtml()).join(' ');
	}
	
	static public function pGetHtml(p:EParagraph)
	{
		return switch p {
			case EParagraph.P(els): '<p>' + els.elsGetHtml() + '</p>';
			case EParagraph.H1(els):  '<h1>' + els.elsGetHtml() + '</h1>';
			case EParagraph.H2(els): '<h2>' + els.elsGetHtml() + '</h2>';
			case EParagraph.H3(els): '<h3>' + els.elsGetHtml() + '</h3>';
			case EParagraph.UL(els): '<ul>' + els.map(function(el) return '<li>' +  el.elsGetHtml() + '</li>').join('') + '</ul>';
			case EParagraph.Table(rows): '<table>' + rows.rowsGetHtml() + '</table>';
			case EParagraph.None(els): els.elsGetHtml();
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

	static public function pGetEls(p:EParagraph)
	{
		return switch p {
			case EParagraph.P(els) | H1(els) | H2(els) | H3(els) | H4(els) | None(els): els;
			case _: throw "Can't get els out of this type: " + p.getName();
		}
	}
	
	
	static public function parsGetHtml(pars:EParagraphs)
	{
		return pars.map(function(p) return p.pGetHtml());
	}
	
	
	

}