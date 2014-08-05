package ;

import neko.Lib;
import interdoc.EElement;
import interdoc.EParagraph;
import interdoc.ERef;
import interdoc.ETablerow;
using interdoc.Html;
using Lambda;
/**
 * ...
 * @author Jonas Nyström
 */

class Main
{
	static function main()
	{
		var ph = EParagraph.H1([EElement.S('This is a header1')]);
		var p0 = EParagraph.P([EElement.S('Hello world!')]);
		var p1 = EParagraph.P([EElement.S('Normal'), EElement.B('fet'), EElement.I('kursiv'), EElement.S('normal.')]);
		var p2 = EParagraph.P([EElement.Ref([ERef.Href('http://google.com')], [EElement.S('Link to Google')])]);
		var ul = EParagraph.UL([[EElement.S('first')], [EElement.S('second')]]);
		var img = EParagraph.P([EElement.Img('/picture.png', null, 123)]);
		var table = EParagraph.Table([
			ETablerow.THead([EParagraph.None([EElement.S('Head a'), EElement.S('Head a-forts')]), EParagraph.None([EElement.S('Head b'), EElement.S('Head b-forts')])]),
			ETablerow.TBody([EParagraph.None([EElement.S('Cell1a'), EElement.S('Cell1a-forts')]), EParagraph.None([EElement.S('Cell1b'), EElement.S('Cell1b-forts')])]),
			ETablerow.TBody([EParagraph.None([EElement.S('Cell2a'), EElement.S('Cell2a-forts')]), EParagraph.None([EElement.S('Cell2b'), EElement.S('Cell2b-forts')])]),
			ETablerow.TFoot([EParagraph.None([EElement.S('Foot a'), EElement.S('Foot a-forts')]), EParagraph.None([EElement.S('Foot b'), EElement.S('Foot b-forts')])]),
		]);
		var pars:EParagraphs = [ph, p0, p1, p2, ul, img, table];

		var html = Html.parsGetHtml(pars);

		
		
		trace (html);
	}
}
