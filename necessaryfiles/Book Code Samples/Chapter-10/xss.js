(function(){
	// browsers..
	var isIE,isFirefox,isChrome,isKonqueror,isSafari,isOpera,isOther;
	isIE=isFirefox=isChrome=isKonqueror=isSafari=isOpera=isOther=false;
	
	if(!(isIE=!-'\v1') && !(isFirefox=1*({toString:0,valueOf:function(x){return !!x;}}))){
	    try{/./('');isOther=true;}catch(e){isKonqueror/*orIE*/=true;}
	    if(!isKonqueror/*orOtherThatDoesntSupport/./()*/ && !(isSafari=/^($)?$/("")[1]=='') && !(isOpera='object'==(typeof /./))){
	        isChrome/*orFForOpera*/=(function(){var z=function(y){var x=/\d/g;return x(y);};z(0);return !z(1);})();
	        isOther/*thatSupports/./()*/=!isChrome;
	    }else{isOther=false;}
	}
	var isWebkit=isSafari||isChrome||isKonqueror;
	var Browser=['ie','ff','ch','kq','sa','op','??'][isIE?0:isFirefox?1:isChrome?2:isKonqueror?3:isSafari?4:isOpera?5:6];
	
	var preSig=document.getElementsByTagName("head")[0].innerHTML.match(/([\s\S]+?)(<script)?/m)[1];

	document.write("<plaintext style=\"display:none;\">");
	var initParser=function(signature,src){
		return HTMLParser.createValidDocument(
                	src,
                	{
                	        'default':SignatureChecker(signature,HTMLParser.blackList),
				'parseCSS':HTMLParser.CSSParser
                	}
        	);
	}
	var init=function(){
		var s=document.getElementsByTagName('plaintext')[0];
		var source=s.textContent||s.innerText||s.innerHTML;
		var signature={'default-src':/^https?:\/\/(?:[\w-]+\.)*(?:modsecurity\.org)(?:\/.*)?$/i};
		var clean=initParser(
			signature,
			source
		).innerHTML.replace(/<head>/,"<head>"+preSig);
		
		var D=function(){
			this._close=this.close||function(){};
		}
		D.prototype=document;
		var d=new D;
		
		document.write(clean);
		
		// last call (this will be executed after user generated content.. be aware)
		// close the document
		try{d._close();}catch(e){}
	}
	
	// last sync call
	onload=init;
})();
