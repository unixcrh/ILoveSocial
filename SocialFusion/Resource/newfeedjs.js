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
	
	if (height>width)
	{
		document.getElementById("upload").style.width=75/height*width-2+"px";
		document.getElementById("upload").style.height=73+"px";
	
	
		document.getElementById("upload").style.left=(104-(75/height*width))/2-1+"px";
			document.getElementById("upload").style.top=7+"px";
	}
	else
	{
				document.getElementById("upload").style.width=98+"px";
		document.getElementById("upload").style.height=100/width*height+"px";
	
	
		document.getElementById("upload").style.left=1+"px";
			document.getElementById("upload").style.top=(90-(100/width*height))/2-1+"px";
	}
}

function setComment(comment)
{
	document.getElementById("photocommentdetail").innerHTML=comment;

}




function setTitle(title)
{
	document.getElementById("title").innerHTML=title;

}


function gotoDetail()
{
//	alert("Click");

}



