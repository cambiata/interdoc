package interdoc ;

/**
 * @author Jonas Nyström
 */

enum ERef 
{
	Href(href:String);
	Bookmark(tag:String);
	Index(key:String);
}