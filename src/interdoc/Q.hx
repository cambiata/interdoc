package interdoc ;
import interdoc.EElement;
/**
 * ...
 * @author Jonas Nyström
 */
class Q
{
	public static function p(?text:String, ?el:EElement, ?els:EElements)
	{
		if (text != null) return EParagraph.P([EElement.S(text)]);
		if (str != null) return EParagraph.P([el]);
		if (strs == null) throw "Error";
		return EParagraph.P(els);
	}
	
	public static function img(src:String)
	{
		return EElement.Img(src, null, null);
	}
	
	/*
	public static function h(level:Int, text:String, ?str:IString, ?strs:IStrings)
	{
		var hlevel = level.fromInt();
		if (text != null) return new H([new S(text)], hlevel);
		if (str != null) return new H([str], hlevel);
		if (strs == null) throw "Error";
		return new H(strs, hlevel);
	}
	
	public static function s(text:String) return new S(text);
	public static function b(text:String) return new B(text);
	public static function i(text:String) return new I(text);
	public static function a(text:String, href:String) return new A(text, href);
	*/
	
	
}