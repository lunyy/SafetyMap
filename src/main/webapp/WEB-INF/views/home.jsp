<!DOCTYPE html>
<html>
<head>
    <meta charset="UTF-8">
    <meta http-equiv="X-UA-Compatible" content="IE=edge">
    <meta name="viewport" content="width=device-width, initial-scale=1.0, user-scalable=no">
    <%@ page language="java" contentType="text/html; charset=UTF-8"%>
	<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
    <title>Safety Map</title>
    <script src="../../docs/js/jquery-1.9.1.js"></script>
    <script type="text/javascript" src="../../docs/js/examples-base.js"></script>
    <script type="text/javascript" src="../../docs/js/highlight.min.js"></script>
    <script type="text/javascript" src="https://openapi.map.naver.com/openapi/v3/maps.js?ncpClientId=83bfuniegk&amp;submodules=panorama"></script>
     <script src="https://code.jquery.com/jquery-1.12.4.min.js" integrity="sha256-ZosEbRLbNQzLpnKIkEdrPv7lOy9C27hHQ+Xp8a4MxAQ=" crossorigin="anonymous"></script>
    <script type="text/javascript" src="https://openapi.map.naver.com/openapi/v3/maps.js?ncpClientId=kcdydbiwel"></script>
    <script type="text/javascript" src="./resources/js/MarkerClustering.js"></script>
    <link rel="stylesheet" type="text/css" href="../../docs/css/examples-base.css" />
    <script>
        var HOME_PATH = '../../docs';
    </script>
</head>
<body>

<!-- @category Overlay/Marker -->

<div id="map" style="width:100%;height:600px;"></div>
<script id="code">

//cctv db load
var cen_x = 36.765797;
var cen_y = 127.282328;
var addr = new Array();
var type = new Array();
var posx = new Array();
var posy = new Array();
var cnt = 0;

<c:forEach items="${memberList}" var="member">	
		<c:if test = "${member.posx < 36.765797 and member.posx > 36.709797}">
			<c:if test = "${member.posy < 127.282328 and member.posy > 127.00328}">
				posx[cnt] = "${member.posx}";
				posy[cnt] = "${member.posy}";
				addr[cnt] = "${member.oldAddr}";
				type[cnt] = "${member.cctvType}";	
		</c:if>
	</c:if>
	cnt = cnt+1;
</c:forEach>

//streetlamp db load
var posx_s = new Array();
var posy_s = new Array();
var cnt2 = 0;
<c:forEach items="${memberList2}" var="street" end = "5000">	
	posx_s[cnt2] = "${street.posx}";
	posy_s[cnt2] = "${street.posy}";
	cnt2 = cnt2+1;
</c:forEach>

var HOME_PATH = window.HOME_PATH || '.';

//map load
var map = new naver.maps.Map('map', {
    center: new naver.maps.LatLng(36.765797, 127.282328),
    zoom: 7,
    zoomControl: true,
    zoomControlOptions: {
        position: naver.maps.Position.TOP_LEFT,
        style: naver.maps.ZoomControlStyle.SMALL
    }
});

var bounds = map.getBounds(),
    southWest = bounds.getSW(),
    northEast = bounds.getNE(),
    lngSpan = northEast.lng() - southWest.lng(),
    latSpan = northEast.lat() - southWest.lat();

var markers = [], //cctv markers
	markers2 = [], //streetlamp markers
    infoWindows = []; //cctv addr, cctv type information window
var contentstring = new Array();

//contentstring data push
for (let k = 0; k<500; k++){
	contentstring[k]= [
        '<div class="iw_inner">',
        '   <h3 style = "font-size:0.7em;">'+addr[k]+'</h3>',
        '   <p style = "font-size:0.5em;">'+type[k]+'<br />',
        '   </p>',
        '</div>'
    ].join('');
}

// make cctv marker
for (let i = 0; i<500; i++) {

    var position = new naver.maps.LatLng(
    		posx[i], posy[i]);
  
        var marker = new naver.maps.Marker({
            map: map,
            position: position,
            zIndex: 100,
            icon:{
            	url:'./resources/images/cctv2.png'
            }
        });
        
        
        var infoWindow = new naver.maps.InfoWindow({
        	 borderColor: "#A4A4A4",
        	 borderWidth: 2,
        	 maxWidth: 140,
            content:contentstring[i]
        });

        markers.push(marker);
        infoWindows.push(infoWindow);
};

//make streetlamp marker
for (let j = 0; j<3000; j++){
	 var position2 = new naver.maps.LatLng( 
			posx_s[j], posy_s[j]);
	 
	  var marker2 = new naver.maps.Marker({
	        map: map,
	        position: position2,
	        zIndex: 100,
	        icon:{
	        	url:'./resources/images/streetlamp.png'
	        }
	    });
	  
	  markers2.push(marker2);
}

naver.maps.Event.addListener(map, 'idle', function() {
    updateMarkers(map, markers);
});


// cctv marker clustering icon
var cctvMarker1 = {
        content: '<div style="cursor:pointer;width:40px;height:40px;line-height:42px;font-size:10px;color:white;text-align:center;font-weight:bold;background:url(./resources/images/cctv_c5.png);background-size:contain;"></div>',
        size: N.Size(40, 40),
        anchor: N.Point(20, 20)
    },
    cctvMarker2 = {
        content: '<div style="cursor:pointer;width:40px;height:40px;line-height:42px;font-size:10px;color:white;text-align:center;font-weight:bold;background:url(./resources/images/cctv_c4.png);background-size:contain;"></div>',
        size: N.Size(40, 40),
        anchor: N.Point(20, 20)
    },
    cctvMarker3 = {
        content: '<div style="cursor:pointer;width:40px;height:40px;line-height:42px;font-size:10px;color:white;text-align:center;font-weight:bold;background:url(./resources/images/cctv_c3.png);background-size:contain;"></div>',
        size: N.Size(40, 40),
        anchor: N.Point(20, 20)
    },
    cctvMarker4 = {
        content: '<div style="cursor:pointer;width:40px;height:40px;line-height:42px;font-size:10px;color:white;text-align:center;font-weight:bold;background:url(./resources/images/cctv_c2.png);background-size:contain;"></div>',
        size: N.Size(40, 40),
        anchor: N.Point(20, 20)
    },
    cctvMarker5 = {
        content: '<div style="cursor:pointer;width:40px;height:40px;line-height:42px;font-size:10px;color:white;text-align:center;font-weight:bold;background:url(./resources/images/cctv_c1.png);background-size:contain;"></div>',
        size: N.Size(40, 40),
        anchor: N.Point(20, 20)
    };

// street lamp clustering icon
var streetlampMarker1 = {
        content: '<div style="cursor:pointer;width:40px;height:40px;line-height:42px;font-size:10px;color:white;text-align:center;font-weight:bold;background:url(./resources/images/streetlamp_c3.png);background-size:contain;"></div>',
        size: N.Size(40, 40),
        anchor: N.Point(20, 20)
    },
    streetlampMarker2 = {
        content: '<div style="cursor:pointer;width:40px;height:40px;line-height:42px;font-size:10px;color:white;text-align:center;font-weight:bold;background:url(./resources/images/streetlamp_c2.png);background-size:contain;"></div>',
        size: N.Size(40, 40),
        anchor: N.Point(20, 20)
    },
    streetlampMarker3 = {
        content: '<div style="cursor:pointer;width:40px;height:40px;line-height:42px;font-size:10px;color:white;text-align:center;font-weight:bold;background:url(./resources/images/streetlamp_c1.png);background-size:contain;"></div>',
        size: N.Size(40, 40),
        anchor: N.Point(20, 20)
	};

//streetlamp marker clustering module
var markerClustering = new MarkerClustering({
    minClusterSize: 2,
    maxZoom: 12,
    map: map,
    markers: markers,
    disableClickZoom: false,
    gridSize: 120,
    icons: [cctvMarker1, cctvMarker2, cctvMarker3, cctvMarker4, cctvMarker5],
    indexGenerator: [5, 10, 30, 100, 500],
    stylingFunction: function(clusterMarker, count) {
        $(clusterMarker.getElement()).find('div:first-child').text(count);
    }
});

var markerClustering2 = new MarkerClustering({
    minClusterSize: 7,
    maxZoom: 12,
    map: map,
    markers: markers2,
    disableClickZoom: false,
    gridSize: 120,
    icons: [streetlampMarker1, streetlampMarker2, streetlampMarker3],
    indexGenerator: [10,30,100],
    stylingFunction: function(clusterMarker, count) {
        $(clusterMarker.getElement()).find('div:first-child').text(count);
    }
});

function refreshmap(){  
    location.reload();
}

function updateMarkers(map, markers) {

    var mapBounds = map.getBounds();
    var marker, position;

    //refreshmap();
    
    for (var i = 0; i < markers.length; i++) {

        marker = markers[i];
        position = marker.getPosition();

        if (mapBounds.hasLatLng(position)) {
            showMarker(map, marker);
            
        } else {
            hideMarker(map, marker);
           
        }
    }
}

//지도 화면 안에 들어오는 마커 팝업
function showMarker(map, marker) {

    if (marker.setMap()) return;
    marker.setMap(map);
}

function hideMarker(map, marker) {

    if (!marker.setMap()) return;
    marker.setMap(null);
}

// 해당 마커의 인덱스를 seq라는 클로저 변수로 저장하는 이벤트 핸들러를 반환합니다.
function getClickHandler(seq) {
    return function(e) {
        var marker = markers[seq],
            infoWindow = infoWindows[seq];

        if (infoWindow.getMap()) {
            infoWindow.close();
        } else {
            infoWindow.open(map, marker);
        }
    }
}

for (var i=0, ii=markers.length; i<ii; i++) {
    naver.maps.Event.addListener(markers[i], 'click', getClickHandler(i));
}
</script>
</body>
</html>
