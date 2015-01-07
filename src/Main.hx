package ;


import interdoc.MD;
import markdown.HtmlRenderer;
import Markdown;
import neko.Lib;
import interdoc.Json;
import interdoc.Html;
import interdoc.EElement;
import interdoc.EParagraph;
import interdoc.ERef;
import interdoc.ETablerow;
import sys.io.File;
import tjson.TJSON;

using Lambda;
using StringTools;
/**
 * ...
 * @author Jonas Nyström
 */

class Main
{
	static function main()
	{	
		var pars:EParagraphs = [];
		pars.push(EParagraph.H1([EElement.S('This is a header1')/*, EElement.S('ÅÄÖåäö123')*/] ));
		pars.push(EParagraph.P([EElement.S('Hello world!')]));
		pars.push(EParagraph.Span([EElement.S('I live in a span')]));
		pars.push(EParagraph.P([EElement.S('Normal'), EElement.B('fet'), EElement.I('kursiv'), EElement.S('normal.')]));
		pars.push( EParagraph.P([EElement.Ref([ERef.Href('http://google.com')], [EElement.S('Link to Google')])]));
		pars.push(EParagraph.UL([[EElement.S('first')], [EElement.S('second')]]));
		pars.push(EParagraph.OL([[EElement.S('first')], [EElement.S('second')]]));
		pars.push(EParagraph.P([EElement.Img('/picture.png', null, 123)]));		
		
		pars.push(EParagraph.Table([
			ETablerow.THead([EParagraph.Elements([EElement.S('Head a'), EElement.S('Head a-forts')]), EParagraph.Elements([EElement.S('Head b'), EElement.S('Head b-forts')])]),
			ETablerow.TBody([EParagraph.Elements([EElement.S('Cell1a'), EElement.S('Cell1a-forts')]), EParagraph.Elements([EElement.S('Cell1b'), EElement.S('Cell1b-forts')])]),
			ETablerow.TBody([EParagraph.Elements([EElement.S('Cell2a'), EElement.S('Cell2a-forts')]), EParagraph.Elements([EElement.S('Cell2b'), EElement.S('Cell2b-forts')])]),
			ETablerow.TFoot([EParagraph.Elements([EElement.S('Foot a'), EElement.S('Foot a-forts')]), EParagraph.Elements([EElement.S('Foot b'), EElement.S('Foot b-forts')])]),
		]));		

		//--------------------------------------------------------------------------------------------------------------
		// html persistence		

		var html = Html.toHtml(pars);
		
		File.saveContent('test.xml', html);
		var pars2 = Html.fromHtml(html);
		trace(Std.string(pars) == Std.string(pars2));
		//trace(Std.string(pars));
		//trace(Std.string(pars2));
		var html2 = Html.toHtml(pars2);
		
		File.saveContent('test2.xml', html2);
		
		//--------------------------------------------------------------------------------------------------------------
		// html persistence		
		var json = Json.toJson(pars);
		File.saveContent('test.json', json);		
		var pars2 = Json.fromJson(json);
		trace(Std.string(pars) == Std.string(pars2));
		
		
		//--------------------------------------------------------------------------------------------------------------
		// markdown persistence
		var lines = ~/\n\r/g.replace(MarkdownExample.test, '\n').split("\n");
		var blocks = new Document().parseLines(lines);
		var html = new HtmlRenderer().render(blocks);
		var pars = Html.fromHtml(html);
		trace(html);
		File.saveContent('md1.xml', html);
		var pars3 = Html.fromHtml(html);
		var html2 = Html.toHtml(pars3);
		//trace(html2);
		File.saveContent('md2.xml', html2);
		var pars2 = Html.fromHtml(html2);
		trace(Std.string(pars) == Std.string(pars2));
		
		trace(pars);
		
		var md = MD.toMd(pars);
		trace(md);

	}
}
