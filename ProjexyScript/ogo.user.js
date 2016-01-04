// ==UserScript==
// @name			Projexy Uitklapper
// @description		Klapt de logboeken op de Projexy project pagina uit binnen (600*levels) milliseconden
// @version			1.0
// @include			https://projexy.nl/?p=view&project=*
// @include			https://*.projexy.nl/?p=view&project=*
// @include			http://projexy.nl/?p=view&project=*
// @include			http://*.projexy.nl/?p=view&project=*
// ==/UserScript==	

var myscript = document.createElement('script');
myscript.setAttribute('type', 'text/javascript');
myscript.appendChild(document.createTextNode(
	"function openalles()" + "\n" + 
	"{" + "\n" + 
	"	var all = document.getElementsByTagName('img');" + "\n" + 
	"	var count = 0;" + "\n" + 
	"	for(var i = 0; i < all.length; i++)" + "\n" + 
	"	{" + "\n" + 
	"		if(all[i].getAttribute('src') == 'layout/img/plus.gif' && all[i].getAttribute('onclick').substring(0, 4) == 'show')" + "\n" + "\n" + 
	"		{" + "\n" + 
	"			eval(all[i].getAttribute('onclick'));" + "\n" + 
	"			count++;" + "\n" + 
	"		}" + "\n" + 
	"	}" + "\n" + 
	"	if(count > 0)" + "\n" + 
	"		setTimeout('openalles()', 600);" + "\n" + 
	"}" + "\n" + 
	"openalles();"
));
document.body.appendChild(myscript);

