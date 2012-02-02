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

function setBigPhotoPos(width,height)
{
	var actWidth=(200-width)/2;
	var actHeight=(150-height)/2;

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
		document.getElementById("head_style").src="head_renren@2x.png";
		return;
	}
	if (style==1)
	{
		document.getElementById("head_style").src="head_wb@2x.png";
		return;
	}
}


function setTitle(title)
{
	document.getElementById("title").innerHTML=title;

}


function gotoDetail()
{
	window.location.href="//gotoDetail";
}


