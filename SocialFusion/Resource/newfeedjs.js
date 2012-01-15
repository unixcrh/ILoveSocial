// JavaScript Document

function setName(name)
{
	document.getElementById('author').innerHTML=name;
}



function setWeibo(weibo)
{
	document.getElementById("weibo").innerHTML=weibo;
}

function setTime(time)
{
	document.getElementById("time").innerHTML=time;
}
function setRepost(repost)
{
		document.getElementById("blog").innerHTML=repost;
}

function setPhotoPos(width,height)
{
	var actWidth=(98-width)/2;
	var actHeight=(73-height)/2;

	document.getElementById("upload").style.left=actWidth+'px';
	document.getElementById("upload").style.top=actHeight+'px';
}

function setComment(comment)
{
	document.getElementById("photocommentdetail").innerHTML=comment;

}

function setStyle(style)
{
	if (style==0)
	{
		document.getElementById("head_style").src="head_renren.png";
		return;
	}
	if (style==1)
	{
		document.getElementById("head_style").src="head_wb.png";
		return;
	}
}


function setTitle(title)
{
	document.getElementById("title").innerHTML=title;

}


function gotoDetail()
{
//	alert("Click");

}

var mouseX;
var mouseY;
function mouseDown(e)
{
		mouseX=e.clientX;
mouseY=e.clientY;
alert(mouseX);
}
function mouseUp(e)
{
	var x1=e.clientX;
	var y1=e.clientY;
	
	
	
	if (x1-mouseX>30)
	{
		alert("right");
	}
	
	if (x1-mouseX<-50)
	{
		alert("left");
	}
	
}

