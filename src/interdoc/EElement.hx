package interdoc ;

/**
 * ...
 * @author Jonas Nyström
 */
enum EElement
{
	S(text:String);
	B(text:String);
	I(text:String);
	LnBr;
	NbSp;
	Ref(refs:ERefs, els:EElements);
	Img(src:String, width:Null<Float>, height:Null<Float>);
}

typedef EElements = Array<EElement>;
