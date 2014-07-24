package interdoc ;

/**
 * @author Jonas Nyström
 */

enum ERef 
{
	Href(href:String);
	Bookmark(tag:String);
	Index(str:String);
}