package interdoc ;

import interdoc.EParagraph;

/**
 * @author Jonas Nyström
 */

enum ETablerow
{
	THead(pars:EParagraphs);
	TBody(pars:EParagraphs);
	TFoot(pars:EParagraphs);
}

typedef ETablerows = Array<ETablerow>;