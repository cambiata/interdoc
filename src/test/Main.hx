package test;
import haxe.unit.TestCase;
import haxe.unit.TestRunner;
import interdoc.EElement;
import interdoc.EParagraph;
import interdoc.ERef;
import interdoc.ETablerow;
import interdoc.Html;
import Markdown;
import markdown.HtmlRenderer;
import sys.FileSystem;
import sys.io.File;
using StringTools;
using Lambda;
/**
 * ...
 * @author Jonas Nyström
 */
class Main 
{
	static function main()
	{
		var r = new TestRunner();
		r.add(new InterdocTests());
		r.run();
	}	
}

class InterdocTests extends TestCase
{
	public function test0()
	{
		var par = EParagraph.H1([EElement.S('This is a header1')]);
		this.assertEquals(['<h1>This is a header1</h1>'].toString(), Html.toHtml([par]).toString());
		
		var ph = EParagraph.H1([EElement.S('This is a header1')]);
		var p0 = EParagraph.P([EElement.S('Hello world!')]);
		var p1 = EParagraph.P([EElement.S('Normal'), EElement.B('fet'), EElement.I('kursiv'), EElement.S('normal.')]);
		var p2 = EParagraph.P([EElement.Ref([ERef.Href('http://google.com')], [EElement.S('Link to Google')])]);
		var ul = EParagraph.UL([[EElement.S('first')], [EElement.S('second')]]);
		var img = EParagraph.P([EElement.Img('/picture.png', null, 123)]);
		var table = EParagraph.Table([
			ETablerow.THead([EParagraph.Elements([EElement.S('Head a'), EElement.S('Head a-forts')]), EParagraph.Elements([EElement.S('Head b'), EElement.S('Head b-forts')])]),
			ETablerow.TBody([EParagraph.Elements([EElement.S('Cell1a'), EElement.S('Cell1a-forts')]), EParagraph.Elements([EElement.S('Cell1b'), EElement.S('Cell1b-forts')])]),
			ETablerow.TBody([EParagraph.Elements([EElement.S('Cell2a'), EElement.S('Cell2a-forts')]), EParagraph.Elements([EElement.S('Cell2b'), EElement.S('Cell2b-forts')])]),
			ETablerow.TFoot([EParagraph.Elements([EElement.S('Foot a'), EElement.S('Foot a-forts')]), EParagraph.Elements([EElement.S('Foot b'), EElement.S('Foot b-forts')])]),
		]);
		var pars:EParagraphs = [ph, p0, p1, p2, ul, img, table];
		var html = Html.toHtml(pars);
		var test = ['<h1>This is a header1</h1>,<p>Hello world!</p>,<p>Normal <b>fet</b> <i>kursiv</i> normal.</p>,<p><a href="http://google.com">Link to Google</a></p>,<ul><li>first</li><li>second</li></ul>,<p><img src="/picture.png" height="123"  /></p>,<table><tr><td>Head a Head a-forts</td><td>Head b Head b-forts</td></tr><tr><td>Cell1a Cell1a-forts</td><td>Cell1b Cell1b-forts</td></tr><tr><td>Cell2a Cell2a-forts</td><td>Cell2b Cell2b-forts</td></tr><tr><td>Foot a Foot a-forts</td><td>Foot b Foot b-forts</td></tr></table>'];
		this.assertEquals(test.toString().replace('\n', ''), html.toString());		
	}
	
	public function testMarkdown()
	{
		var blocks = parse(
'
## Heading 2
### Heading 3
'
			);

		for (block in blocks) trace(block);
		var html = new HtmlRenderer().render(blocks);
		trace(html);
		
	}
	
	public function testMD2()
	{
		var lines = ~/\n\r/g.replace(MarkdownExample.minimatch, '\n').split("\n");
		var blocks =  new Document().parseLines(lines);
		blocks.iter(function(n) trace(n));
		var html = new HtmlRenderer().render(blocks);
		File.saveContent('minimatch.html', html);
		//var blocks = parse(MarkdownExample.minimatch);
		
	}
	
	
	private function parse(markdown:String)
	{
		var document = new Document();
		var lines = ~/\n\r/g.replace(markdown, '\n').split("\n");
		document.parseRefLinks(lines);
		var blocks = document.parseLines(lines);
		return blocks;
		
	}
}