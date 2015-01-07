package interdoc ;

/**
 * @author Jonas Nyström
 */
import interdoc.EElement;
import interdoc.ETablerow;

enum EParagraph 
{
	Elements(els:EElements);
	P(els:EElements);
	Span(els:EElements);
	H1(els:EElements);
	H2(els:EElements);
	H3(els:EElements);
	H4(els:EElements);
	UL(elss:Array<EElements>);
	OL(elss:Array<EElements>);
	Table(rows:ETablerows);		
}

typedef EParagraphs = Array<EParagraph>;
