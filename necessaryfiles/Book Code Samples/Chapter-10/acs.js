/*


IMPORTANT NOTICE

   THE LATEST VERSION OF THIS FILE IS NOW LOCATED AT
      http://code.taobao.org/svn/ACS/

PLEASE UPDATE TO THAT VERSION

* BSD License Template 
* 
* Copyright (c) 2009, Alibaba Group Holding Ltd.
* All rights reserved.
* 
* Redistribution and use in source and binary forms, with or without 
* modification, are permitted provided that the following conditions
* are met:
* 
*     * Redistributions of source code must retain the above copyright 
*        notice, this list of conditions and the following disclaimer.
*     * Redistributions in binary form must reproduce the above 
*        copyright notice, this list of conditions and the following 
*        disclaimer in the documentation and/or other materials provided 
*        with the distribution.
*     * Neither the name of Alibaba Group Holding Ltd nor the names of its
*        contributors may be used to endorse or promote products derived 
*        from this software without specific prior written permission.
* 
* THIS SOFTWARE IS PROVIDED BY THE COPYRIGHT HOLDERS AND CONTRIBUTORS "AS IS" 
* AND ANY EXPRESS OR IMPLIED WARRANTIES, INCLUDING, BUT NOT LIMITED TO, THE 
* IMPLIED WARRANTIES OF MERCHANTABILITY AND FITNESS FOR A PARTICULAR PURPOSE 
* ARE DISCLAIMED. IN NO EVENT SHALL THE COPYRIGHT HOLDER OR CONTRIBUTORS BE 
* LIABLE FOR ANY DIRECT, INDIRECT, INCIDENTAL, SPECIAL, EXEMPLARY, OR 
* CONSEQUENTIAL DAMAGES (INCLUDING, BUT NOT LIMITED TO, PROCUREMENT OF 
* SUBSTITUTE GOODS OR SERVICES; LOSS OF USE, DATA, OR PROFITS; OR BUSINESS 
* INTERRUPTION) HOWEVER CAUSED AND ON ANY THEORY OF LIABILITY, WHETHER IN 
* CONTRACT, STRICT LIABILITY, OR TORT (INCLUDING NEGLIGENCE OR OTHERWISE) 
* ARISING IN ANY WAY OUT OF THE USE OF THIS SOFTWARE, EVEN IF ADVISED OF THE 
* POSSIBILITY OF SUCH DAMAGE.
**/

/*Browser checks*/
var isFF =     !!(1*({toString:0,valueOf:function(x){return !!x;}}));
var isIE =     !isFF && '\v'=='v';
var isChrome = !isFF && !isIE && !!/\c[a]/('ca');
var isSafari = !isFF && !isIE && !isChrome && /a/.__proto__=='//';
var isOpera =  !isFF && !isIE && !isChrome && !isSafari && 'object'==(typeof /./);
var isWebKit = isChrome||isSafari;
var isOther =  !isFF && !isIE && !isWebKit && !isOpera;

function SignatureChecker(signature,untrustedHandler){
	if(typeof untrustedHandler!="function")
		untrustedHandler=function(){
			return false;
		};
	var sigCheck=function(event,arg){
		switch(event){
			case "init":
				// filter check
				// config load
			case "openTag":
				// check for breakers (breaker-count) on XMP,PLAINTEXT
				// check for counters in general
				/*var tag=arg.tag.toLowerCase();
				switch(tag){
					case 
					if(!signature[tag+'-count'] || --signature[tag+'-count']<0)
						return false;
				}*/
			case "closeTag":
				// check for breakers (breaker-count) on RAWTEXT elements
				// check for hashes
				return false;
			case "newCDATA":
			case "newComment":
				// let the blacklist take care of this
				return false;
			case "textNode":
				// check for censored words
				return false;
			case "setAttribute":
				// check for *-src stuff
				switch(arg.tag.toLowerCase()){
					case 'script':case 'embed':case 'frame':case 'iframe':
						if(arg.att=='src'){
							//console.log(arg.parser.getURL(arg.val));
							return !!(arg.val=arg.parser.getURL(arg.val).match(signature['default-src'])||"javascript://");
						}
						return false;
						break;
					case 'link':
						if(arg.att.toLowerCase()=='href'){
							//alert(arg.val+":"+arg.parser.getURL(arg.val)+":"+signature['default-src']);
							return !!(arg.val=(arg.parser.getURL(arg.val).match(signature['default-src'])||[""])[0]);
						}
						return true;
					case 'base':
						return false;
						break;
				}
		// falling down!
			case "parseJS":
				// todo
		// falling down!
			case "parseCSS":
				// todo
		// falling down!
			default:
				return false;
		}
		return false;
	}
	return function(event,arg){
		return sigCheck(event,arg)||untrustedHandler(event,arg);
	}
}
function setCode(src){
	return HTMLParser.createValidDocument(
		src,
		{
			'default':HTMLParser.blackList,
			'parseCSS':HTMLParser.CSSParser,
			'parseJS':HTMLParser.JSReg
		}
	);
}

// HTMLParser
function HTMLParser(source,events,extras){
	events=events?events:[];
	extras=extras?extras:{};
	function debug(x){
		if(window.console)
			console.log(x);
		else if(window.prompt)
			window.prompt("DEBUG",x);
	}
	function createElement(tag){
		if(isFF && ["html","head","body"].indexOf(tag)<0)
			return document.createElementNS("http://www.invalid.example/",tag);
		return document.createElement(tag);
	}
	
	var tnm=/^[^="'<\s>\/]+/m;
	var att=/(?:[\/\s]+)([^\s<=>\/]*)(?:\s*=\s*(?:(?:(['"])(?:((?:(?!\2)[\s\S])+))?\2)|(?:([^"'\s>][^\s>]*)))?)?/mg;
	var rmt=/<!--(?!-?>)[\s\S]+?(?:-->)|<!\[CDATA\[[\s\S]+?(?:\]\]>)|((?:<\/?[^="'<\s>\/]+)(?:(?:[\/\s]*)(?:(?:[^\s<=>\/]*)(?:\s*=\s*(?:(?:(['"])(?:(?:(?:(?!\2)[\s\S])+))?\2)|(?:(?:[^"'\s>][^\s>]*)))?)?))*(?:[\/\s]*)\/?>?)|[^<]+|[\s\t\r\n]|</img;
	var cmb=/^<!--(?!-?>)([\s\S]+?)(?:-->)$/m;
	var cdb=/^<!\[CDATA\[([\s\S]+?)(?:\]\]>)$/im;
	var xpr=/^<\?\w+.*\?>/m;
	var ent=/&((#?x?)([a-z0-9]+));?/i;
	
	var LinkResolution_f,LinkResolution;
	function initLinkResolution(){
		var LinkResolution_f=document.createElement("iframe");
		LinkResolution_f.height=LinkResolution_f.width=1;
		LinkResolution_f.frameBorder=0;
		LinkResolution_f.style.position="absolute";
		LinkResolution_f.style.top=LinkResolution_f.style.left=-20;
		document.documentElement.appendChild(LinkResolution_f);
		var LinkResolution=LinkResolution_f.contentWindow;
		LinkResolution.document.write("<html><head>");			
	}
	var parser={
		map:{},
		// killerTags is an alias of rawtextTags+cdataTags+nodynTags+plaintext
		killerTags:{plaintext:1,xmp:1,title:1,textarea:1,xml:1,script:1,style:1,iframe:1,noscript:1,noframes:1,noembed:1},
		// rawtextTags and cdataTags are not used, since we dont really have to read it's content
		// rawText element means the content inside shouldn't be unentified (check setCSS,setJS, and XMP/PLAINTEXT exceptions)
		rawtextTags:{xmp:1,style:1,script:1,xml:1},
		// cdata element means the content inside should be unentified, this is the default
		cdataTags:{textarea:1,title:1},
		// nodynTags are tags that present alternate content, and mess up innerHTML, we ignore this ones for security, all browsers fail
		nodynTags:{iframe:1,noembed:1,noframes:1,noscript:1},
		// this tags can be selfclosed without problems [script will expand after decompilation]
		canlonely:{img:1,script:1,br:1,hr:1,input:1,frame:1,keygen:1,isindex:1,param:1,meta:1,link:1,base:1},
		// index of blockelements
		blockTags:{address:1,blockquote:1,center:1,dir:1,div:1,dl:1,fieldset:1,form:1,h1:1,h2:1,h3:1,h4:1,h5:1,h6:1,hr:1,isindex:1,menu:1,noframes:1,noscript:1,ol:1,p:1,pre:1,table:1,ul:1,dd:1,dt:1,frameset:1,li:1,tbody:1,td:1,tfoot:1,th:1,thead:1,tr:1},
		killer:false,
		brokenTag:0,
		lastTag:"",
		tags:[],
		lastNode:null,
		nodes:[],
		textNode:"",
		addBase:function(base){
			if(!LinkResolution)initLinkResolution();
			var f=LinkResolution;
 			var elem=f.document.createElement("base");
                        elem.setAttribute("href",base);
                        var container=f.document.createElement("head");
                        container.appendChild(elem);
                        f.document.write(container.innerHTML);
		},
		getURL:function(link){
			if(!LinkResolution)return link;
			var f=LinkResolution;
			var elem=f.document.createElement("a");
			elem.setAttribute("href",link);
			elem.appendChild(f.document.createTextNode("link"));
			var container=f.document.createElement("span");
			container.appendChild(elem);
			f.document.write("<body>"+container.innerHTML);
			return f.document.links[f.document.links.length-1].href;
		},
		popTag:function(noTextCommit){
			// make the last change to the tag
			var x=Math.random();
			if(!noTextCommit)
				if(!this.commitTextNode())//another poptag
					return true;
			this.callEvent("closeTag",{node:this.lastNode,tag:this.lastTag});
			// if we are a script, call parseJS event
			if(this.lastTag=="script"){
				var code=this.lastNode.textContent||this.lastNode.text||this.lastNode.innerHTML||"";
				if(isIE)
					this.lastNode.text="";
				else
					this.lastNode.textContent=this.lastNode.innerHTML="";
				var evt={txt:code,node:this.lastNode,tag:this.lastTag};
				if(this.callEvent("parseJS",evt)){
					this.textNode=evt.txt||"";
					this.commitTextNode();
				}
			}
			// if we are a style, call parseCSS event
			if(!!String(this.lastTag).match(/^style\s*/i)){
				var code=this.lastNode.textContent||this.lastNode.text||this.lastNode.innerHTML||"";
				try{
					if(isIE){
						try{
							this.lastNode.innerHTML="";
						}catch(e){}
						if(this.lastNode.innerHTML.length){
							//IE6
							var nn=document.createElement(this.lastTag);
							this.lastNode.parentNode.replaceChild(nn,this.lastNode);
							this.lastNode=nn;
						}
					}else
						this.lastNode.text=this.lastNode.textContent=this.lastNode.innerHTML="";
				}catch(e){
					//alert(e);
					while(this.lastNode.firstChild)this.lastNode.removeChild(this.lastNode.firstChild);
				}
				var evt={txt:code,node:this.lastNode,tag:this.lastTag};
				
				if(this.callEvent("parseCSS",evt)){
					this.textNode=evt.txt||"";
					this.commitTextNode();
				}
			}
			// finish tag scope
			try{
				if(!this.lastTag || typeof this.map[this.lastTag]=="undefined" || this.map[this.lastTag]<=0)
					return false;
				this.brokenTag=0;
				this.map[this.lastTag]--;
				this.tags.pop();
				this.nodes.pop();
				this.lastTag=this.tags[this.tags.length-1];
				this.lastNode=this.nodes[this.nodes.length-1];
				if(this.killer)
					this.killer=false;
				return true;
			}catch(e){
				//throw e;
				return false;
			}
		},
		pushElement:function(node,tagName,lonely,move){
			move=!!move;
			// <form/> <b/> <iframe/> <p/> bugs
			lonely=(lonely&&!!this.canlonely[tagName]);
			
			var killer=false;
			this.commitTextNode();
			if(typeof this.map[tagName] == "undefined")
				this.map[tagName]=0;
			var evt={node:node,parentTag:this.lastTag,parentNode:this.lastNode,tag:tagName,move:move};
			if(!this.callEvent("openTag",evt))
				return;
			node=evt.node;tagName=evt.tag;move=evt.move;
			if(!lonely && this.killerTags[tagName])
				killer=true;
			try{
				if(this.lastNode){
					node=this.lastNode.appendChild(node);
					if(isWebKit && this.lastNode.innerHTML.length==0){
						throw "WebKit parser bug";
					}
				}
			}catch(e){
				// not allowed to append here, then pop and try again
				if(this.popTag(true))
					return this.pushElement(node,tagName,lonely,true);
			}
			if(this.brokenTag)
				this.brokenTag++;
			if(!lonely || killer){
				//debug(tagName+" "+this.map[tagName]+"+1="+(this.map[tagName]+1));
				this.map[tagName]++;
				
				this.tags.push(tagName);
				this.lastTag=tagName;
				
				this.nodes.push(node);
				this.lastNode=node;
				
				this.killer=killer;
			}else if(lonely){
				// self closed tag
				
			}
		},
		commitTextNode:function(){
			if(this.textNode.length>0){
				var tmp=document.createElement("pre");
				var text=this.textNode.match(/^[\r\n\s]*/)+"";
				tmp.innerHTML="<pre>"+this.textNode.replace(/</g,"&lt;")+"</pre>";
				if(tmp.innerText)
					text+=tmp.innerText;
				else if(tmp.textContent)
					text+=tmp.textContent;
				if(!text.length)
					return true;
				var evt={txt:text,node:this.lastNode,tag:this.lastTag};
				if(this.brokenTag==2 && this.lastTag=="script"){
					//dont allow text nodes in a broken script element
				}else if(this.callEvent("textNode",evt)){
					txt=evt.txt;lastNode=evt.node;lastTag=evt.tag;
					if(!lastTag){
						// ahm.. trying to append a node to nothing? nonono
					}else if(this.nodynTags[lastTag.toLowerCase()]){
						// dont allow textcontent inside noframes,noembed,etc.. innerHTML+= browser bug
					}else try{
						var lastText=lastNode.appendChild(document.createTextNode(text));
						if(isWebKit && lastNode.innerHTML.length==0){
							lastNode.removeChild(lastText);
							while(lastNode.firstChild)
								lastNode.removeChild(lastNode.firstChild);
                                                	throw "WebKit parser bug";
                                        	}
					}catch(e){
						if((lastTag=="style" || lastTag=="script") && (lastNode && lastNode.parentNode) && isIE){
							var oldText=lastNode.innerHTML;
							var p=lastNode.parentNode;
							tmp.innerHTML="";
							tmp.appendChild(lastNode);
							var z=tmp.innerHTML;
							var m=tmp.innerHTML.match(/^(.*>)(<\/[^<]+)$/im);
							if(!m)m=[0,"<"+lastTag+">","</"+lastTag+">"];
							tmp.innerHTML="<body>"+m[1]+oldText+txt+m[2]+"</body>";
							if(tmp.getElementsByTagName(lastTag).length)
								this.lastNode=p.appendChild(tmp.getElementsByTagName(lastTag)[0]);
						}else if(isIE || (isWebKit && lastNode.innerHTML.length==0)){
							// not allowed, then popTag and try again						
							if(this.popTag(true))
								this.commitTextNode();
							return false;
						}
					}
				}
				this.textNode="";
				delete tmp;
			}
			return true;
		},
		setAttribute:function(node,tagName,attName,value){
			try{
				// first decode
				if(ent.test(value)){
					// this is expensive, so only do it when there are entities that need to be safely decoded
					var tmp=document.createElement("pre");
					tmp.innerHTML=value;
					if(tmp.innerText)
						value=tmp.innerText;
					else if(tmp.textContent)
						value=tmp.textContent;
					delete tmp;
				}
			}catch(e){
				//?
			}
			//trim
			attName=attName.replace(/^\s*(.*?)\s*?$/img,"$1");
			value=value||"";
			//check the attribute
			this.brokenTag=1*(this.brokenTag||/['"]/.test(attName));
			var valid=!/[^#\w_:-]+/.test(attName);
			
			var evt={node:node,tag:tagName,att:attName,val:value,valid:valid};
			if(!this.callEvent("setAttribute",evt))
				return;
			node=evt.node;tagName=evt.tag;attName=evt.att;value=evt.val;valid=evt.valid;
			
			if(!valid || this.brokenTag==1)
				return;
			try{
				// and set
				if(String(attName).match(/^on\w{2,}/i)){
					var evtJS={txt:value,setThis:true};
					if(!this.callEvent("parseJS",evtJS))
						return;
					value=evtJS.txt;
				}else if(String(attName).toLowerCase()=='style'){
					var evtCSS={txt:value,inline:true};
					if(!this.callEvent("parseCSS",evtCSS))
						return;
					value=evtCSS.txt;
				}
				var attName_=attName;
				if(isIE || isOpera)
					attName_=" "+attName;
				if(isIE && !value)
					node.setAttribute(attName_,attName);
				else
					node.setAttribute(attName_,value);
				
				if(attName.toLowerCase()=="href" && tagName.toLowerCase()=="base")
					this.addBase(value);
			}catch(e){
				//? some browsers wont allow weird args.. thats ok		
			}
		},
		putComment:function(txt){
			this.commitTextNode();
			var cc,cdm,evt={txt:txt,tag:this.lastTag,node:this.lastNode};
			if(!this.callEvent("newComment",evt))
				return;
			txt=evt.txt;
			if(isIE){
				// for security reasons we wont parse this the same as IE
				// http://eaea.sirdarckcat.net/conditionalcomments.html
				// http://eaea.sirdarckcat.net/conditionalcomments2.html
				txt=txt.replace(
					/^(\[[^\]]*\][^>]*>)([\s\S]*)$/im,
					function($0,$1,$2){
						// IE conditional comments
						//treat everything inside here as HTML							
						var exDRK=extras.dontRewriteKillers;
						extras.dontRewriteKillers=true;
						cdm=HTMLParser("<html>"+$2.replace(/<!\[[^<>]+$/m,""),events,extras).firstChild;
						extras.dontRewriteKillers=exDRK;
						if(cdm && cdm.innerHTML)
							return $1+cdm.innerHTML+"<![endif]";
						else
							return $1+"<![endif]";
					}
				);
			}
			try{
				// browsers are too stupid
				//this.lastNode.appendChild(document.createComment(txt));
			}catch(e){
				if(isIE)
					this.textNode+="<!--"+txt+"-->";
			}
		},
		putCDATA:function(txt){
			this.commitTextNode();
			var evt={txt:txt,tag:this.lastTag,node:this.lastNode};
			if(!this.callEvent("newCDATA",evt))
				return;
			txt=evt.txt;
			try{
				this.lastNode.appendChild(document.createCDATASection(txt));
			}catch(e){
				this.textNode+=txt;
			}finally{
				return true;
			}
		},
		callEvent:function(event,arg){
			arg.parser=this;
			if(events[event] && typeof events[event] != "undefined" && typeof events[event].call != "undefined")
				return events[event](arg);
			if(events['default'] && typeof events['default'] != "undefined" && typeof events['default'].call != "undefined")
				return events["default"](event,arg);
			return true;
		}
	};
	
	var vdom=document.createElement("html");
	parser.pushElement(vdom,"html");
	var stop=false;
	var RegExp_HTMLParser=function(txt,elem,fMat,fIndex,fOc){
		var mt;
		// This means the rest of the code was parsed by a recursive code
		if(stop)
			return "";
		try{
		var orc=RegExp.rightContext || RegExp["$'"] || "";
		}catch(e){var orc='';}
		if(orc.length==0 || isIE)
			orc=fOc.substr(fIndex+txt.length);
		
		if(!elem || txt.charAt(1)=="!" || txt.charAt(1)=='?'){
			if(mt=txt.match(xpr)){
				// <?import <?xml
				return "{?}";
			}
			if(mt=txt.match(cmb)){
				// Comment block
				parser.putComment(mt[1]);
				return "{COMMENT}";
			}
			if(mt=txt.match(cdb)){
				// CDATA block
				parser.putCDATA(mt[1]);
				return "{CDATA}";
			}
			if(txt.match(/^<!DOCTYPE\b/i)){
				// ignore doctype since it's not in the right place anyway
				return "{!DOCTYPE}";
			}else if(elem && txt.charAt(1)=="!"){
				return "{!SOMETHING}";
			}else if(!elem){
				if(!txt)txt='';
				parser.textNode+=String(txt);
				return "{TEXTNODE "+String(txt).substr(0,3)+"}";
			}
			return "{ERROR}";
		}
		// lonely tag?
		var lonely=!!elem.match(/\/[\s\n]*>$/);
		
		// close tag?
		var closing=false;
		if(elem.charAt(1)=='/')
			closing=true;

		// get the tagName
		elem=elem.replace(/^<\/?/,"");
		elem=elem.replace(/>$/,"");
		
		var tagName;
		elem=elem.replace(tnm,function(_){tagName=_.toLowerCase();return "";});
		if(parser.killer){
			if(closing && tagName==parser.lastTag && tagName!="plaintext"){
				// finished killing
				parser.popTag();
				return "{/"+tagName+"}";
			}else{
				// convert to textNode
				parser.textNode+=txt;
				return "{TEXTNODE "+txt.substr(0,3)+"}";
			}
		}
		
		if(closing){
			// check if we are closing the last tag
			if(tagName==parser.lastTag){
				parser.popTag();
				return "{/"+tagName+"}";
			}else if(parser.map[tagName]>0){
				// if we are closing a block element.
				if(parser.blockTags[tagName]){
					var log="";
	                                var cont=true;
	                                while(cont && parser.lastTag!=tagName && parser.lastTag){
	                                        log+=" "+parser.lastTag;
	                                        cont=parser.popTag();
	                                }
	                                if(cont)parser.popTag();
	                                return "{//"+tagName+" - "+log+" }";
				}else{
					// note, this section is non HTML conformant
					
					// then, we are closing what could be an inline element
					if(parser.blockTags[parser.lastTag]){
						// if our parent is block, ignore it
						return "{IGNORING /"+tagName+"}";
					}else{
						// TODO
						// treat this as:
						// 	<b>bold<i>bold&italic</b>italic</i>normal
						// changing it to:
						//	<b>bold<i>bold&italic</i></b><i>italic</i>normal
						// so, all inline elements we close, should be reopened
						// now, it is ignored, as this:
						//	<b>bold<i>bold&italic</i></b>italicnormal
		                                var log="";
                		                var cont=true;
                        		        while(cont && parser.lastTag!=tagName && parser.lastTag){
                                		        log+=" "+parser.lastTag;
                               			        cont=parser.popTag();
                                		}
                                		if(cont)parser.popTag();
		                                return "{//"+tagName+" - "+log+" }";
					}
				}
			}else{
				// ignore it
				return "{IGNORING /"+tagName+"}";
			}
		}else{
			// create Node
			if(
				(	typeof extras.dontRewriteKillers == "undefined" || 
					extras.dontRewriteKillers==false
				) &&
				(tagName=="plaintext" || tagName=="xmp")
			)
				tagName_="pre";
			else
				tagName_=tagName;
			if(!parser.blockTags[parser.lastTag] && parser.blockTags[tagName]){
				// TODO
				// 	<b class='a' id='b'>a<div>b</div> 
				// should be treated as 
				// 	<b class='a' id='b'>a</b><div><b class='a' id='b'>b</b></div>
				// note that we should clon the inline tag
			}
			tagName=tagName.replace(/.*:/,"");
			try{
				var node=createElement(tagName_);
			}catch(e){
				return "{TAGERROR "+tagName_+"}";
			}
			var tnod;
			// set attributes
			elem=elem.replace(att,function(_,attName,quote,value,unquoted){
				if(attName!="/")
					if(tnod=parser.setAttribute(node,tagName,attName,value||unquoted)){
						node=tnod;
					}
			});
			if(parser.brokenTag==1)
				node=createElement(tagName_);
			parser.pushElement(node,tagName,lonely);
			if(parser.killer){
				var ffb=false,res="";
				// first check if there's a closing tag for us
				orc=orc.replace(new RegExp('([\\s\\S]*?)<\/'+tagName+'(?=[<=>\\s])','m'),function(_,$1){
					parser.textNode+=$1;
					parser.popTag();
					res+="{TEXTNODE}{/}";
					ffb=true;
					return "";
				});
				if(ffb){
					orc=('<! '+orc).replace(RegExp(rmt.source,'im'),'');
				}
				res=orc.replace(rmt,RegExp_HTMLParser);
				stop=true;
				return "{"+tagName+"}"+res;
			}
			return "{"+tagName+"}";
		}
		return "{}";
	};
	var result=source.replace(rmt,RegExp_HTMLParser);
	// close all opened tags
	while(parser.popTag());
	if(LinkResolution){
		LinkResolution.document.close();
		LinkResolution_f.parentNode.removeChild(LinkResolution_f);
	}
	//debug(result);
	//done
	return vdom;
}

HTMLParser.createValidDocument=function(sourceCode,events){
	var vdom,ns="http://www.w3.org/1999/xhtml";
	var CSSFIX="/*this stylesheet tries to fix document.write layout bugs*/table{font:inherit;}";
	function getParent(elem){
		return elem&&(elem.parentNode||elem.parentElement);
	}
	function removeChild(elem){
		var parent=getParent(elem);
		if(parent.removeChild)
			return parent.removeChild(elem);
		else
			return parent.removeNode(elem);
	}
	function createElement(elem){
		if(!isIE && !isWebKit && document.createElementNS){
			return document.createElementNS(ns,elem);
		}else
			return document.createElement(elem);
	}
	function getElementsByTagName(tag){
		try{
			return vdom.getElementsByTagName(tag);
		}catch(e){
			return new Array;
		}
	}

	vdom=HTMLParser(sourceCode,events);
	
	var tag;

	// we ensure that we only have one of these
	var uniqueTags=["html","head","title","body"];
	var DOM={};
	while(tag=uniqueTags.pop()){
		var h=getElementsByTagName(tag);
		if(h.length)
			DOM[tag]=h[0];
		else
			DOM[tag]=createElement(tag);
		for(var i=1;i<h.length;i++){
			var elem=h[i];
			if(elem.childNodes.length){
				var parent=getParent(elem);
				for(var j=0;j<elem.childNodes.length;j++){
					parent.appendChild(elem.childNodes[j]);
				}
			}
			removeChild(elem);
		}
	}
	
	var orphanate=DOM.html.childNodes;
	var adoption=[];
	for(var i=0;i<orphanate.length;i++){
		var orphan=orphanate[i];
		if(orphan!=DOM.head && orphan!=DOM.body)
			adoption.push(orphan);
	}
	for(var i=0;i<adoption.length;i++)
		DOM.body.appendChild(adoption[i]);
	
	// we set the elements as they should be
	DOM.html.setAttribute("xmlns",ns);
	DOM.html.appendChild(DOM.head);
	DOM.html.appendChild(DOM.body);
	
	DOM.head.appendChild(document.createElement(isIE?"style ":"style")).appendChild(document.createTextNode(CSSFIX));

	// and start over again
	vdom=createElement("html");
	vdom.setAttribute("xmlns:html",ns);
	vdom.appendChild(DOM.html);
	
	return vdom.firstChild;
}
HTMLParser.fix=function(str){
	if(isIE)
		str=String(str).replace(/\x00/,"").replace(/^[\x01-\x29]+/,"");
	return String(str).replace(/(^\W+)|\s|(\r?\n)|\t|\r|\n|\x00|\uFFFD|[\x01-\x1F]+/mg,"");
}
var last;
HTMLParser.blackList=function(event,arg){
	switch(event){
		case "openTag":
			// @theharmonyguy thanks, PoC: <a:""="<a href=">XSS
                        // disallow weird tags in IE
                        if(arg.tag.match(/[^a-zA-Z]/) || arg.tag.match(/set|namespace/)){
				return false;
			}
			// http://eaea.sirdarckcat.net/bindings.html
			if(isIE && (""+arg.parentTag).toLowerCase()=="xml")
				return false;
			// dont allow plaintext (vanity, there shall only be one plaintext)
			if(arg.tag.toLowerCase()=="plaintext")
				return false;
			last={};
		break;
		case "closeTag":
			// this event may not be triggered by some tags, be aware
			
			// pass all scripts through JSReg
			if(
				window.Sandbox && 
				last && 
				arg.tag && 
				last.tag && 
				arg.tag.toLowerCase()=="script" && 
				last.tag=="script" && 
				last.txt.length>0
			){
				arg.node.appendChild(document.createTextNode(
					"try{"+
					   "parent.Sandbox.eval(unescape('"+escape(last.txt)+"'));"+
					"}catch(e){throw e}"
				));
			}
			last={};
		break;
		case "newCDATA":
		case "newComment":
			if(isIE && arg.tag && arg.tag.toLowerCase()=="xml")
				return false;
		case "textNode":
			return true;
		case "setAttribute":
			// block namespace tags, just in case
			// http://maliciousmarkup.blogspot.com/2008/12/theres-xul-in-it.html
			if(arg.tag.indexOf(':')>=0)
				return false;
			// leave the src attributes in script elements
			if(arg.att && arg.tag.toLowerCase()=="script" && arg.att.toLowerCase()=="src"){
				arg.val="javascript://DISABLED-SCRIPT";
				return true;
			}
			// disallow weird attrs in IE
			if(arg.att.match(/[^a-zA-Z]/))
				return false;
			// block unwanted tags
			if(({
				'link':1,
				'plaintext':1,
				'vmlframe':1,
				'frame':1,
				'iframe':1,
				'video':1,
				'audio':1,
				'embed':1,
				'object':1,
				'applet':1,
				'param':1,
				'script':1,
				'style':1
			})[arg.tag.toLowerCase()])
				return false;
			if(event!="setAttribute")
				break;
			// data bindings
			if(arg.att.toLowerCase()=='datasrc')
				return false;
			//namespaced
			if(arg.att.indexOf(':')>=0)
				return false;
			//and namespaces
			if(arg.att.toLowerCase()=="xmlns")
				return false;
			//meta redirections
			if(
				arg.tag.toLowerCase()=="meta" && 
				arg.att.toLowerCase()=="http-equiv" &&
				true // HTMLParser.fix(arg.val).match(/((java|vb)script|data):/i)
			)
				return false;
			//charsets, and cookies (thanks whk!!)
			if(
				arg.tag.toLowerCase()=="meta" &&
				arg.att.toLowerCase()=="http-equiv" &&
				HTMLParser.fix(arg.val).match(/content-type|charset|set-cookie/i)
			)
				return false;
			if( arg.att.toLowerCase()=="href" ){
				var tmp=document.createElement('a'),par=document.createElement('div');
				tmp.setAttribute('href',arg.val);
				par.appendChild(tmp);
				par.innerHTML+=' ';
				arg.val=par.firstChild.getAttribute('href');
				delete tmp;
				delete par;
			}
			//opera and ie6 execute javascript URIs
			if( (
					isOpera || isIE
				) && 
				HTMLParser.fix(arg.val).match(/^(java|vb)script:/i) && 
				arg.att!="href"
			)
				return false;
			else
			// allow js uris on href
			if(
				(
					HTMLParser.fix(arg.val).match(/((java|vb)script|data):/i)
				) && 
				(
					arg.att.toLowerCase()=="href" ||
					arg.att.toLowerCase()=="action" ||
					arg.att.toLowerCase()=="formaction"
				)
			){
				return false;
				arg.val="javascript:if(!confirm('Allow to execute '+unescape('"+escape(escape(arg.val))+"')))throw 'JSUri Not Allowed';"+arg.val;
				return true;
			}
			// frames are disabled, if they were enabled, then we should add a check for src here
		break;
		case "parseCSS":
		case "parseJS":
		default:
			return false;
		case "setCSSProperty":
			// dangerous properties
			if(({
				// yeah, really, gecko, yes
				'Moz-binding':1,
				'-moz-binding':1,
				'moz-binding':1,
				'binding':1,
				// I <3 IE
				'behavior':1,
				// overlays, we actually need to reinforce this in the parent element (check CSSFIX)
				'position':2,
				'float':2,
				'top':2,
				'left':2,
				'right':2,
				'bottom':2
			})[arg.prop])
				return false;
			// dangerous values
			switch(true){
				// IE6 cleans the value from obfuscation and linebreaks, and doesnt support vars, nor attr() so this should be safe
				// Opera wont leave JS uris in the cssproplist
				case isIE&&/^[^"']*url[^\w]*\(.*[\w]script:/.test(arg.val):
					return false;
				// Opera allows SVG fonts as xss vectors.. =/ only relevant on @font-face..
				case isOpera&&/.*[^\w]format[^\w]*\(.*svg[^\w]/.test(arg.val):
					return arg.prop=='src';
				// yeah, expression may be left on IE7/8 if it's on standards mode, and wont alert.. but just to be sure we cancel
				// also note stuff like font: 'x' expression() will work, hence the \s
				case isIE&&/(^[^"']*|\s)expression[^\w]*\(/.test(arg.val):
					return false;
				default:
					return true;
			}
			return true;
		break;
	}
	// blacklist == return true on default
	return true;
	// whitelist == return false on default
	return false;
}
HTMLParser.JSReg=function(arg){
	return false;
	if(!window.JSRegSandbox){
		var fakeWindow={};
		var SB={toEval:"",eval:function(x){this.toEval+="\n\n"+x;}};
		JSReg('ghost',function(JSRegEnv){
			JSRegEnv.eval(SB.toEval);
			SB=JSRegEnv;
			SB.setWindow(fakeWindow);
		});
		function copySafe(from,to){
			for(var name in from){
				switch(typeof from[name]){
					case "string":case "number":case "boolean":
						to['$'+name+'$']=(from[name]).valueOf();
					break;
				}
			}
		}
		window.JSRegSandbox={doEval:function(code,me,copy){
			var t={};
			if(copy)
				copySafe(me,t);
			else
				t=fakeWindow;
			return SB.eval(code,t);
		}};
	}
	if(typeof arg=="string")
		arg={txt:arg,ret:true};
	if(arg.txt){
		try{
			arg.txt="(function(my){return parent.JSRegSandbox.doEval(('/*~ '+"+Function('"~*///".substr();\n'+("with(this){\n"+arg.txt+"\n}\n"))+").replace(/\}[^}]*$/m,''),my,"+(!!arg.setThis)+");})(this);";
			if(arg.ret)
				return arg.txt;
		}catch(e){return false;}
		return true;
	}
	return false;
}
/*
	This CSS Parser uses the native CSS parser, and then checks it's props.
		Notes:
		1. the cssText is broken in almost all browsers.. we should requote stuff in quotes correctly
		2. we should check that elements dont contain a hidden rule.
		3. there are a lot of xss attacks available when the content passes a cssText assignment, be paranoid
*/
HTMLParser.CSSParser=function(evt){
	var i;
	// protect against quote bugs on IE
	function fix(str){if(isIE)return String(str).replace(/^\W+/,'');return String(str);}
	function requote(str,dop){
		// only double encode on parsing HTML attributes. this may fail
		var p=dop?"% ":"";
		function fixquotes(str){
			// https://bugzilla.mozilla.org/show_bug.cgi?id=535072
			// this code tries to quote stuff inside quotes correctly.. 
			// later another code avoids 2 rules to be setted as 1
                                return String(str).replace(
                                        /%/g,
                                        "%%"
                                ).replace(
                                        /(["'])((?:\\[\s\S]|[^\\])*?)\1/g,
                                        function(_,q,c){
                                                return "'"+c.replace(
                                                        /\\([\s\S])|\W/g,
                                                        function(c,d){
								if(d)
									if(String(d).match(/[a-z0-9]/))
										return p+'% '+d;
									else{
										return p+'% '+d.charCodeAt(0).toString(16)+" ";
									}
                                                                return "%"+c.charCodeAt(0).toString(16)+" ";
                                                        }
                                                )+"'";
                                        }
                                ).replace(/\\/g,'\\\\').replace(
                                        /%([\s\S])/g,
                                        function(_,c){
                                                if(c=="%")
                                                        return c;
						if(c==" ")
							return "\\";
                                                return "\\"+c;
                                        }
                                ).replace(/"/g,'\\22 ').replace(/\\20 /g,' ');
		}
		// check the parenthesis!
		function fixparents(str){
			return fixquotes(fixquotes(str).replace(/\('/g,'(').replace(/'\)/g,')').replace(/\(/g,"(\"").replace(/\)/g,"\")"));
		}
		// final fix for IE!
		return fixparents(str).replace(/;[\s\S]*/,'');
	}
	// for now.. only parse inline styles, <style> tags are a bit more complex =/
	if(evt.inline){
		var a=document.createElement('div');
		var b=document.createElement('div');
		a.setAttribute('style',requote(evt.txt,true));
		if(isIE){try{
			a.style.cssText=evt.txt;
			var _acs=String(a.style.cssText).match(/([A-Z0-9_-]+)(?=:)/g);
			var acc=[];
			if(_acs)for(var i=0;i<_acs.length;i++)
				if(a.style[String(_acs[i]).toLowerCase().replace(
                                	/-(\w)/g,
                                	function($,_){
                                        	return _.toUpperCase();
                                	}
                        	)])
					acc[i]=String(_acs[i]).toLowerCase();
		}catch(e){}}
		if(isOpera)document.body.appendChild(a);
		var acs=isOpera?getComputedStyle(a,null):a.style;
		var acc=isIE?acc:acs;
		var oct=acc.cssText;
		var lct='';
		try{for(i=0;acc[i];i++){
			var jsAlias=fix(acc[i]).replace(
                        	/-(\w)/g,
                                function($,_){
                                	return _.toUpperCase();
                                }
                        );
			var evtCSS={
				prop:fix(acc[i]),
				jsprop:jsAlias,
				val:acs[jsAlias],
				elem:b,
				originalEvent:evt
			};
			if(evt.parser.callEvent("setCSSProperty",evtCSS)){				
				b.style[evtCSS.jsprop]=requote(evtCSS.val);
			}
		}}catch(e){}
		if(isOpera)document.body.removeChild(a);
		evt.txt=b.style.cssText;
		return true;
	}
	return false;
}